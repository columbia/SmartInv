1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 /**
5      * 
6 █┼█ █┼█ █▄┼▄█ ███ █┼┼█ ███ ███ ███ █┼┼┼█ █┼┼█
7 █▄█ █┼█ █┼█┼█ █▄█ ██▄█ █▄▄ ┼█┼ █┼█ █┼█┼█ ██▄█
8 █┼█ ███ █┼┼┼█ █┼█ █┼██ ▄▄█ ┼█┼ █▄█ █▄█▄█ █┼██
9      */
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(
46         address indexed from,
47         address indexed to,
48         uint256 indexed tokenId
49     );
50 
51     /**
52      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
53      */
54     event Approval(
55         address indexed owner,
56         address indexed approved,
57         uint256 indexed tokenId
58     );
59 
60     /**
61      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
62      */
63     event ApprovalForAll(
64         address indexed owner,
65         address indexed operator,
66         bool approved
67     );
68 
69     /**
70      * @dev Returns the number of tokens in ``owner``'s account.
71      */
72     function balanceOf(address owner) external view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the `tokenId` token.
76      *
77      * Requirements:
78      *
79      * - `tokenId` must exist.
80      */
81     function ownerOf(uint256 tokenId) external view returns (address owner);
82 
83     /**
84      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
85      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must exist and be owned by `from`.
92      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
93      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
94      *
95      * Emits a {Transfer} event.
96      */
97     function safeTransferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Transfers `tokenId` token from `from` to `to`.
105      *
106      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must be owned by `from`.
113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId)
146         external
147         view
148         returns (address operator);
149 
150     /**
151      * @dev Approve or remove `operator` as an operator for the caller.
152      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
153      *
154      * Requirements:
155      *
156      * - The `operator` cannot be the caller.
157      *
158      * Emits an {ApprovalForAll} event.
159      */
160     function setApprovalForAll(address operator, bool _approved) external;
161 
162     /**
163      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
164      *
165      * See {setApprovalForAll}
166      */
167     function isApprovedForAll(address owner, address operator)
168         external
169         view
170         returns (bool);
171 
172     /**
173      * @dev Safely transfers `tokenId` token from `from` to `to`.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId,
189         bytes calldata data
190     ) external;
191 }
192 
193 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @title ERC721 token receiver interface
199  * @dev Interface for any contract that wants to support safeTransfers
200  * from ERC721 asset contracts.
201  */
202 interface IERC721Receiver {
203     /**
204      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
205      * by `operator` from `from`, this function is called.
206      *
207      * It must return its Solidity selector to confirm the token transfer.
208      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
209      *
210      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
211      */
212     function onERC721Received(
213         address operator,
214         address from,
215         uint256 tokenId,
216         bytes calldata data
217     ) external returns (bytes4);
218 }
219 
220 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
226  * @dev See https://eips.ethereum.org/EIPS/eip-721
227  */
228 interface IERC721Metadata is IERC721 {
229     /**
230      * @dev Returns the token collection name.
231      */
232     function name() external view returns (string memory);
233 
234     /**
235      * @dev Returns the token collection symbol.
236      */
237     function symbol() external view returns (string memory);
238 
239     /**
240      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
241      */
242     function tokenURI(uint256 tokenId) external view returns (string memory);
243 }
244 
245 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Implementation of the {IERC165} interface.
251  *
252  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
253  * for the additional interface id that will be supported. For example:
254  *
255  * ```solidity
256  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
257  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
258  * }
259  * ```
260  *
261  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
262  */
263 abstract contract ERC165 is IERC165 {
264     /**
265      * @dev See {IERC165-supportsInterface}.
266      */
267     function supportsInterface(bytes4 interfaceId)
268         public
269         view
270         virtual
271         override
272         returns (bool)
273     {
274         return interfaceId == type(IERC165).interfaceId;
275     }
276 }
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // This method relies on extcodesize, which returns 0 for contracts in
305         // construction, since the code is only stored at the end of the
306         // constructor execution.
307 
308         uint256 size;
309         assembly {
310             size := extcodesize(account)
311         }
312         return size > 0;
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(
333             address(this).balance >= amount,
334             "Address: insufficient balance"
335         );
336 
337         (bool success, ) = recipient.call{value: amount}("");
338         require(
339             success,
340             "Address: unable to send value, recipient may have reverted"
341         );
342     }
343 
344     /**
345      * @dev Performs a Solidity function call using a low level `call`. A
346      * plain `call` is an unsafe replacement for a function call: use this
347      * function instead.
348      *
349      * If `target` reverts with a revert reason, it is bubbled up by this
350      * function (like regular Solidity function calls).
351      *
352      * Returns the raw returned data. To convert to the expected return value,
353      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
354      *
355      * Requirements:
356      *
357      * - `target` must be a contract.
358      * - calling `target` with `data` must not revert.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data)
363         internal
364         returns (bytes memory)
365     {
366         return functionCall(target, data, "Address: low-level call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
371      * `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value
398     ) internal returns (bytes memory) {
399         return
400             functionCallWithValue(
401                 target,
402                 data,
403                 value,
404                 "Address: low-level call with value failed"
405             );
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(
421             address(this).balance >= value,
422             "Address: insufficient balance for call"
423         );
424         require(isContract(target), "Address: call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.call{value: value}(
427             data
428         );
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data)
439         internal
440         view
441         returns (bytes memory)
442     {
443         return
444             functionStaticCall(
445                 target,
446                 data,
447                 "Address: low-level static call failed"
448             );
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal view returns (bytes memory) {
462         require(isContract(target), "Address: static call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.staticcall(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(address target, bytes memory data)
475         internal
476         returns (bytes memory)
477     {
478         return
479             functionDelegateCall(
480                 target,
481                 data,
482                 "Address: low-level delegate call failed"
483             );
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a delegate call.
489      *
490      * _Available since v3.4._
491      */
492     function functionDelegateCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         require(isContract(target), "Address: delegate call to non-contract");
498 
499         (bool success, bytes memory returndata) = target.delegatecall(data);
500         return verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
505      * revert reason using the provided one.
506      *
507      * _Available since v4.3._
508      */
509     function verifyCallResult(
510         bool success,
511         bytes memory returndata,
512         string memory errorMessage
513     ) internal pure returns (bytes memory) {
514         if (success) {
515             return returndata;
516         } else {
517             // Look for revert reason and bubble it up if present
518             if (returndata.length > 0) {
519                 // The easiest way to bubble the revert reason is using memory via assembly
520 
521                 assembly {
522                     let returndata_size := mload(returndata)
523                     revert(add(32, returndata), returndata_size)
524                 }
525             } else {
526                 revert(errorMessage);
527             }
528         }
529     }
530 }
531 
532 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @dev Provides information about the current execution context, including the
538  * sender of the transaction and its data. While these are generally available
539  * via msg.sender and msg.data, they should not be accessed in such a direct
540  * manner, since when dealing with meta-transactions the account sending and
541  * paying for execution may not be the actual sender (as far as an application
542  * is concerned).
543  *
544  * This contract is only required for intermediate, library-like contracts.
545  */
546 abstract contract Context {
547     function _msgSender() internal view virtual returns (address) {
548         return msg.sender;
549     }
550 
551     function _msgData() internal view virtual returns (bytes calldata) {
552         return msg.data;
553     }
554 }
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev String operations.
562  */
563 library Strings {
564     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
568      */
569     function toString(uint256 value) internal pure returns (string memory) {
570         // Inspired by OraclizeAPI's implementation - MIT licence
571         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
572 
573         if (value == 0) {
574             return "0";
575         }
576         uint256 temp = value;
577         uint256 digits;
578         while (temp != 0) {
579             digits++;
580             temp /= 10;
581         }
582         bytes memory buffer = new bytes(digits);
583         while (value != 0) {
584             digits -= 1;
585             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
586             value /= 10;
587         }
588         return string(buffer);
589     }
590 
591     /**
592      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
593      */
594     function toHexString(uint256 value) internal pure returns (string memory) {
595         if (value == 0) {
596             return "0x00";
597         }
598         uint256 temp = value;
599         uint256 length = 0;
600         while (temp != 0) {
601             length++;
602             temp >>= 8;
603         }
604         return toHexString(value, length);
605     }
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
609      */
610     function toHexString(uint256 value, uint256 length)
611         internal
612         pure
613         returns (string memory)
614     {
615         bytes memory buffer = new bytes(2 * length + 2);
616         buffer[0] = "0";
617         buffer[1] = "x";
618         for (uint256 i = 2 * length + 1; i > 1; --i) {
619             buffer[i] = _HEX_SYMBOLS[value & 0xf];
620             value >>= 4;
621         }
622         require(value == 0, "Strings: hex length insufficient");
623         return string(buffer);
624     }
625 }
626 
627 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 /**
632  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
633  * @dev See https://eips.ethereum.org/EIPS/eip-721
634  */
635 interface IERC721Enumerable is IERC721 {
636     /**
637      * @dev Returns the total amount of tokens stored by the contract.
638      */
639     function totalSupply() external view returns (uint256);
640 
641     /**
642      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
643      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
644      */
645     function tokenOfOwnerByIndex(address owner, uint256 index)
646         external
647         view
648         returns (uint256 tokenId);
649 
650     /**
651      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
652      * Use along with {totalSupply} to enumerate all tokens.
653      */
654     function tokenByIndex(uint256 index) external view returns (uint256);
655 }
656 
657 pragma solidity ^0.8.0;
658 
659 /**
660  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
661  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
662  *
663  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
664  *
665  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
666  *
667  * Does not support burning tokens to address(0).
668  */
669 contract ERC721A is
670   Context,
671   ERC165,
672   IERC721,
673   IERC721Metadata,
674   IERC721Enumerable
675 {
676   using Address for address;
677   using Strings for uint256;
678 
679   struct TokenOwnership {
680     address addr;
681     uint64 startTimestamp;
682   }
683 
684   struct AddressData {
685     uint128 balance;
686     uint128 numberMinted;
687   }
688 
689   uint256 private currentIndex = 0;
690 
691   uint256 internal immutable collectionSize;
692   uint256 internal immutable maxBatchSize;
693 
694   // Token name
695   string private _name;
696 
697   // Token symbol
698   string private _symbol;
699 
700   // Mapping from token ID to ownership details
701   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
702   mapping(uint256 => TokenOwnership) private _ownerships;
703 
704   // Mapping owner address to address data
705   mapping(address => AddressData) private _addressData;
706 
707   // Mapping from token ID to approved address
708   mapping(uint256 => address) private _tokenApprovals;
709 
710   // Mapping from owner to operator approvals
711   mapping(address => mapping(address => bool)) private _operatorApprovals;
712 
713   /**
714    * @dev
715    * `maxBatchSize` refers to how much a minter can mint at a time.
716    * `collectionSize_` refers to how many tokens are in the collection.
717    */
718   constructor(
719     string memory name_,
720     string memory symbol_,
721     uint256 maxBatchSize_,
722     uint256 collectionSize_
723   ) {
724     require(
725       collectionSize_ > 0,
726       "ERC721A: collection must have a nonzero supply"
727     );
728     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
729     _name = name_;
730     _symbol = symbol_;
731     maxBatchSize = maxBatchSize_;
732     collectionSize = collectionSize_;
733   }
734 
735   /**
736    * @dev See {IERC721Enumerable-totalSupply}.
737    */
738   function totalSupply() public view override returns (uint256) {
739     return currentIndex;
740   }
741 
742   /**
743    * @dev See {IERC721Enumerable-tokenByIndex}.
744    */
745   function tokenByIndex(uint256 index) public view override returns (uint256) {
746     require(index < totalSupply(), "ERC721A: global index out of bounds");
747     return index;
748   }
749 
750   /**
751    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
752    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
753    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
754    */
755   function tokenOfOwnerByIndex(address owner, uint256 index)
756     public
757     view
758     override
759     returns (uint256)
760   {
761     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
762     uint256 numMintedSoFar = totalSupply();
763     uint256 tokenIdsIdx = 0;
764     address currOwnershipAddr = address(0);
765     for (uint256 i = 0; i < numMintedSoFar; i++) {
766       TokenOwnership memory ownership = _ownerships[i];
767       if (ownership.addr != address(0)) {
768         currOwnershipAddr = ownership.addr;
769       }
770       if (currOwnershipAddr == owner) {
771         if (tokenIdsIdx == index) {
772           return i;
773         }
774         tokenIdsIdx++;
775       }
776     }
777     revert("ERC721A: unable to get token of owner by index");
778   }
779 
780   /**
781    * @dev See {IERC165-supportsInterface}.
782    */
783   function supportsInterface(bytes4 interfaceId)
784     public
785     view
786     virtual
787     override(ERC165, IERC165)
788     returns (bool)
789   {
790     return
791       interfaceId == type(IERC721).interfaceId ||
792       interfaceId == type(IERC721Metadata).interfaceId ||
793       interfaceId == type(IERC721Enumerable).interfaceId ||
794       super.supportsInterface(interfaceId);
795   }
796 
797   /**
798    * @dev See {IERC721-balanceOf}.
799    */
800   function balanceOf(address owner) public view override returns (uint256) {
801     require(owner != address(0), "ERC721A: balance query for the zero address");
802     return uint256(_addressData[owner].balance);
803   }
804 
805   function _numberMinted(address owner) internal view returns (uint256) {
806     require(
807       owner != address(0),
808       "ERC721A: number minted query for the zero address"
809     );
810     return uint256(_addressData[owner].numberMinted);
811   }
812 
813   function ownershipOf(uint256 tokenId)
814     internal
815     view
816     returns (TokenOwnership memory)
817   {
818     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
819 
820     uint256 lowestTokenToCheck;
821     if (tokenId >= maxBatchSize) {
822       lowestTokenToCheck = tokenId - maxBatchSize + 1;
823     }
824 
825     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
826       TokenOwnership memory ownership = _ownerships[curr];
827       if (ownership.addr != address(0)) {
828         return ownership;
829       }
830     }
831 
832     revert("ERC721A: unable to determine the owner of token");
833   }
834 
835   /**
836    * @dev See {IERC721-ownerOf}.
837    */
838   function ownerOf(uint256 tokenId) public view override returns (address) {
839     return ownershipOf(tokenId).addr;
840   }
841 
842   /**
843    * @dev See {IERC721Metadata-name}.
844    */
845   function name() public view virtual override returns (string memory) {
846     return _name;
847   }
848 
849   /**
850    * @dev See {IERC721Metadata-symbol}.
851    */
852   function symbol() public view virtual override returns (string memory) {
853     return _symbol;
854   }
855 
856   /**
857    * @dev See {IERC721Metadata-tokenURI}.
858    */
859   function tokenURI(uint256 tokenId)
860     public
861     view
862     virtual
863     override
864     returns (string memory)
865   {
866     require(
867       _exists(tokenId),
868       "ERC721Metadata: URI query for nonexistent token"
869     );
870 
871     string memory baseURI = _baseURI();
872     return
873       bytes(baseURI).length > 0
874         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
875         : "";
876   }
877 
878   /**
879    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
880    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
881    * by default, can be overriden in child contracts.
882    */
883   function _baseURI() internal view virtual returns (string memory) {
884     return "";
885   }
886 
887   /**
888    * @dev See {IERC721-approve}.
889    */
890   function approve(address to, uint256 tokenId) public override {
891     address owner = ERC721A.ownerOf(tokenId);
892     require(to != owner, "ERC721A: approval to current owner");
893 
894     require(
895       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
896       "ERC721A: approve caller is not owner nor approved for all"
897     );
898 
899     _approve(to, tokenId, owner);
900   }
901 
902   /**
903    * @dev See {IERC721-getApproved}.
904    */
905   function getApproved(uint256 tokenId) public view override returns (address) {
906     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
907 
908     return _tokenApprovals[tokenId];
909   }
910 
911   /**
912    * @dev See {IERC721-setApprovalForAll}.
913    */
914   function setApprovalForAll(address operator, bool approved) public override {
915     require(operator != _msgSender(), "ERC721A: approve to caller");
916 
917     _operatorApprovals[_msgSender()][operator] = approved;
918     emit ApprovalForAll(_msgSender(), operator, approved);
919   }
920 
921   /**
922    * @dev See {IERC721-isApprovedForAll}.
923    */
924   function isApprovedForAll(address owner, address operator)
925     public
926     view
927     virtual
928     override
929     returns (bool)
930   {
931     return _operatorApprovals[owner][operator];
932   }
933 
934   /**
935    * @dev See {IERC721-transferFrom}.
936    */
937   function transferFrom(
938     address from,
939     address to,
940     uint256 tokenId
941   ) public override {
942     _transfer(from, to, tokenId);
943   }
944 
945   /**
946    * @dev See {IERC721-safeTransferFrom}.
947    */
948   function safeTransferFrom(
949     address from,
950     address to,
951     uint256 tokenId
952   ) public override {
953     safeTransferFrom(from, to, tokenId, "");
954   }
955 
956   /**
957    * @dev See {IERC721-safeTransferFrom}.
958    */
959   function safeTransferFrom(
960     address from,
961     address to,
962     uint256 tokenId,
963     bytes memory _data
964   ) public override {
965     _transfer(from, to, tokenId);
966     require(
967       _checkOnERC721Received(from, to, tokenId, _data),
968       "ERC721A: transfer to non ERC721Receiver implementer"
969     );
970   }
971 
972   /**
973    * @dev Returns whether `tokenId` exists.
974    *
975    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
976    *
977    * Tokens start existing when they are minted (`_mint`),
978    */
979   function _exists(uint256 tokenId) internal view returns (bool) {
980     return tokenId < currentIndex;
981   }
982 
983   function _safeMint(address to, uint256 quantity) internal {
984     _safeMint(to, quantity, "");
985   }
986 
987   /**
988    * @dev Mints `quantity` tokens and transfers them to `to`.
989    *
990    * Requirements:
991    *
992    * - there must be `quantity` tokens remaining unminted in the total collection.
993    * - `to` cannot be the zero address.
994    * - `quantity` cannot be larger than the max batch size.
995    *
996    * Emits a {Transfer} event.
997    */
998   function _safeMint(
999     address to,
1000     uint256 quantity,
1001     bytes memory _data
1002   ) internal {
1003     uint256 startTokenId = currentIndex;
1004     require(to != address(0), "ERC721A: mint to the zero address");
1005     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1006     require(!_exists(startTokenId), "ERC721A: token already minted");
1007     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1008 
1009     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1010 
1011     AddressData memory addressData = _addressData[to];
1012     _addressData[to] = AddressData(
1013       addressData.balance + uint128(quantity),
1014       addressData.numberMinted + uint128(quantity)
1015     );
1016     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1017 
1018     uint256 updatedIndex = startTokenId;
1019 
1020     for (uint256 i = 0; i < quantity; i++) {
1021       emit Transfer(address(0), to, updatedIndex);
1022       require(
1023         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1024         "ERC721A: transfer to non ERC721Receiver implementer"
1025       );
1026       updatedIndex++;
1027     }
1028 
1029     currentIndex = updatedIndex;
1030     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1031   }
1032 
1033   /**
1034    * @dev Transfers `tokenId` from `from` to `to`.
1035    *
1036    * Requirements:
1037    *
1038    * - `to` cannot be the zero address.
1039    * - `tokenId` token must be owned by `from`.
1040    *
1041    * Emits a {Transfer} event.
1042    */
1043   function _transfer(
1044     address from,
1045     address to,
1046     uint256 tokenId
1047   ) private {
1048     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1049 
1050     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1051       getApproved(tokenId) == _msgSender() ||
1052       isApprovedForAll(prevOwnership.addr, _msgSender()));
1053 
1054     require(
1055       isApprovedOrOwner,
1056       "ERC721A: transfer caller is not owner nor approved"
1057     );
1058 
1059     require(
1060       prevOwnership.addr == from,
1061       "ERC721A: transfer from incorrect owner"
1062     );
1063     require(to != address(0), "ERC721A: transfer to the zero address");
1064 
1065     _beforeTokenTransfers(from, to, tokenId, 1);
1066 
1067     // Clear approvals from the previous owner
1068     _approve(address(0), tokenId, prevOwnership.addr);
1069 
1070     _addressData[from].balance -= 1;
1071     _addressData[to].balance += 1;
1072     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1073 
1074     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1075     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1076     uint256 nextTokenId = tokenId + 1;
1077     if (_ownerships[nextTokenId].addr == address(0)) {
1078       if (_exists(nextTokenId)) {
1079         _ownerships[nextTokenId] = TokenOwnership(
1080           prevOwnership.addr,
1081           prevOwnership.startTimestamp
1082         );
1083       }
1084     }
1085 
1086     emit Transfer(from, to, tokenId);
1087     _afterTokenTransfers(from, to, tokenId, 1);
1088   }
1089 
1090   /**
1091    * @dev Approve `to` to operate on `tokenId`
1092    *
1093    * Emits a {Approval} event.
1094    */
1095   function _approve(
1096     address to,
1097     uint256 tokenId,
1098     address owner
1099   ) private {
1100     _tokenApprovals[tokenId] = to;
1101     emit Approval(owner, to, tokenId);
1102   }
1103 
1104   uint256 public nextOwnerToExplicitlySet = 0;
1105 
1106   /**
1107    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1108    */
1109   function _setOwnersExplicit(uint256 quantity) internal {
1110     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1111     require(quantity > 0, "quantity must be nonzero");
1112     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1113     if (endIndex > collectionSize - 1) {
1114       endIndex = collectionSize - 1;
1115     }
1116     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1117     require(_exists(endIndex), "not enough minted yet for this cleanup");
1118     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1119       if (_ownerships[i].addr == address(0)) {
1120         TokenOwnership memory ownership = ownershipOf(i);
1121         _ownerships[i] = TokenOwnership(
1122           ownership.addr,
1123           ownership.startTimestamp
1124         );
1125       }
1126     }
1127     nextOwnerToExplicitlySet = endIndex + 1;
1128   }
1129 
1130   /**
1131    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1132    * The call is not executed if the target address is not a contract.
1133    *
1134    * @param from address representing the previous owner of the given token ID
1135    * @param to target address that will receive the tokens
1136    * @param tokenId uint256 ID of the token to be transferred
1137    * @param _data bytes optional data to send along with the call
1138    * @return bool whether the call correctly returned the expected magic value
1139    */
1140   function _checkOnERC721Received(
1141     address from,
1142     address to,
1143     uint256 tokenId,
1144     bytes memory _data
1145   ) private returns (bool) {
1146     if (to.isContract()) {
1147       try
1148         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1149       returns (bytes4 retval) {
1150         return retval == IERC721Receiver(to).onERC721Received.selector;
1151       } catch (bytes memory reason) {
1152         if (reason.length == 0) {
1153           revert("ERC721A: transfer to non ERC721Receiver implementer");
1154         } else {
1155           assembly {
1156             revert(add(32, reason), mload(reason))
1157           }
1158         }
1159       }
1160     } else {
1161       return true;
1162     }
1163   }
1164 
1165   /**
1166    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1167    *
1168    * startTokenId - the first token id to be transferred
1169    * quantity - the amount to be transferred
1170    *
1171    * Calling conditions:
1172    *
1173    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1174    * transferred to `to`.
1175    * - When `from` is zero, `tokenId` will be minted for `to`.
1176    */
1177   function _beforeTokenTransfers(
1178     address from,
1179     address to,
1180     uint256 startTokenId,
1181     uint256 quantity
1182   ) internal virtual {}
1183 
1184   /**
1185    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1186    * minting.
1187    *
1188    * startTokenId - the first token id to be transferred
1189    * quantity - the amount to be transferred
1190    *
1191    * Calling conditions:
1192    *
1193    * - when `from` and `to` are both non-zero.
1194    * - `from` and `to` are never both zero.
1195    */
1196   function _afterTokenTransfers(
1197     address from,
1198     address to,
1199     uint256 startTokenId,
1200     uint256 quantity
1201   ) internal virtual {}
1202 }
1203 
1204 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 /**
1209  * @dev Contract module which provides a basic access control mechanism, where
1210  * there is an account (an owner) that can be granted exclusive access to
1211  * specific functions.
1212  *
1213  * By default, the owner account will be the one that deploys the contract. This
1214  * can later be changed with {transferOwnership}.
1215  *
1216  * This module is used through inheritance. It will make available the modifier
1217  * `onlyOwner`, which can be applied to your functions to restrict their use to
1218  * the owner.
1219  */
1220 abstract contract Ownable is Context {
1221     address private _owner;
1222 
1223     event OwnershipTransferred(
1224         address indexed previousOwner,
1225         address indexed newOwner
1226     );
1227 
1228     /**
1229      * @dev Initializes the contract setting the deployer as the initial owner.
1230      */
1231     constructor() {
1232         _transferOwnership(_msgSender());
1233     }
1234 
1235     /**
1236      * @dev Returns the address of the current owner.
1237      */
1238     function owner() public view virtual returns (address) {
1239         return _owner;
1240     }
1241 
1242     /**
1243      * @dev Throws if called by any account other than the owner.
1244      */
1245     modifier onlyOwner() {
1246         require(owner() == _msgSender(), "You are not the owner");
1247         _;
1248     }
1249 
1250     /**
1251      * @dev Leaves the contract without owner. It will not be possible to call
1252      * `onlyOwner` functions anymore. Can only be called by the current owner.
1253      *
1254      * NOTE: Renouncing ownership will leave the contract without an owner,
1255      * thereby removing any functionality that is only available to the owner.
1256      */
1257     function renounceOwnership() public virtual onlyOwner {
1258         _transferOwnership(address(0));
1259     }
1260 
1261     /**
1262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1263      * Can only be called by the current owner.
1264      */
1265     function transferOwnership(address newOwner) public virtual onlyOwner {
1266         require(
1267             newOwner != address(0),
1268             "Ownable: new owner is the zero address"
1269         );
1270         _transferOwnership(newOwner);
1271     }
1272 
1273     
1274     function _transferOwnership(address newOwner) internal virtual {
1275         address oldOwner = _owner;
1276         _owner = newOwner;
1277         emit OwnershipTransferred(oldOwner, newOwner);
1278     }
1279 }
1280 
1281 
1282 pragma solidity ^0.8.7;
1283 
1284 contract HumansTownNFT is ERC721A, Ownable {
1285     uint256 public Human_PRICE = 0 ether;
1286     uint256 public MAX_Humans = 10000;
1287     uint256 public MAX_Minteths = 6;
1288     string public baseURI = "";
1289     string public baseExtension = ".json";
1290      bool public Haulted = true;   
1291     
1292     constructor() ERC721A("HumansTown", "HTWTF", MAX_Minteths, MAX_Humans) { 
1293         
1294     }
1295     function DonateToTheKing() external payable {
1296         // thank you
1297     }
1298 
1299     function Minteth(uint256 numTokens) public payable {  
1300         // Free Minteth but if you wish to donate that would be radical.  
1301         // Website has 2 mint buttons, Free and Generous Donate where it is fixed .01 eth for any amount minted.
1302 
1303         require(!Haulted, "Haulted");
1304         require(numTokens > 0 && numTokens <= MAX_Minteths,"To many Humans");
1305         require(totalSupply() + numTokens <= MAX_Humans, "Ran out of Humans");
1306         require(msg.value >= numTokens * Human_PRICE, "Invalid funds provided");
1307         
1308         _safeMint(msg.sender, numTokens);
1309     }
1310     function Hault(bool _state) public onlyOwner {
1311         Haulted = _state;
1312     }
1313     function setBaseURI(string memory newBaseURI) public onlyOwner {
1314         baseURI = newBaseURI;
1315     }
1316     function tokenURI(uint256 _tokenId)
1317         public
1318         view
1319         override
1320         returns (string memory)
1321     {
1322         require(_exists(_tokenId), "That Human doesn't exist");
1323         return
1324             bytes(baseURI).length > 0
1325                 ? string(
1326                     abi.encodePacked(
1327                         baseURI,
1328                         Strings.toString(_tokenId),
1329                         baseExtension
1330                     )
1331                 )
1332                 : "";
1333     }
1334 
1335     function _baseURI() internal view virtual override returns (string memory) {
1336         return baseURI;
1337     }
1338 
1339     function FundsForTheKing() public onlyOwner {
1340         require(payable(msg.sender).send(address(this).balance));
1341     }
1342 }