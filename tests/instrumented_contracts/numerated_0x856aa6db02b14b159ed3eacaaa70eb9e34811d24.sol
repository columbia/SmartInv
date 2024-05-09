1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-25
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
8 pragma solidity ^0.8.0;
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
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 pragma solidity ^0.8.0;
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 
170 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
171 pragma solidity ^0.8.0;
172 /**
173  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
174  * @dev See https://eips.ethereum.org/EIPS/eip-721
175  */
176 interface IERC721Enumerable is IERC721 {
177     /**
178      * @dev Returns the total amount of tokens stored by the contract.
179      */
180     function totalSupply() external view returns (uint256);
181 
182     /**
183      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
184      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
185      */
186     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
187 
188     /**
189      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
190      * Use along with {totalSupply} to enumerate all tokens.
191      */
192     function tokenByIndex(uint256 index) external view returns (uint256);
193 }
194 
195 
196 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
197 pragma solidity ^0.8.0;
198 /**
199  * @dev Implementation of the {IERC165} interface.
200  *
201  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
202  * for the additional interface id that will be supported. For example:
203  *
204  * ```solidity
205  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
206  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
207  * }
208  * ```
209  *
210  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
211  */
212 abstract contract ERC165 is IERC165 {
213     /**
214      * @dev See {IERC165-supportsInterface}.
215      */
216     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
217         return interfaceId == type(IERC165).interfaceId;
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Strings.sol
222 
223 
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev String operations.
229  */
230 library Strings {
231     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
232 
233     /**
234      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
235      */
236     function toString(uint256 value) internal pure returns (string memory) {
237         // Inspired by OraclizeAPI's implementation - MIT licence
238         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
239 
240         if (value == 0) {
241             return "0";
242         }
243         uint256 temp = value;
244         uint256 digits;
245         while (temp != 0) {
246             digits++;
247             temp /= 10;
248         }
249         bytes memory buffer = new bytes(digits);
250         while (value != 0) {
251             digits -= 1;
252             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
253             value /= 10;
254         }
255         return string(buffer);
256     }
257 
258     /**
259      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
260      */
261     function toHexString(uint256 value) internal pure returns (string memory) {
262         if (value == 0) {
263             return "0x00";
264         }
265         uint256 temp = value;
266         uint256 length = 0;
267         while (temp != 0) {
268             length++;
269             temp >>= 8;
270         }
271         return toHexString(value, length);
272     }
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
276      */
277     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
278         bytes memory buffer = new bytes(2 * length + 2);
279         buffer[0] = "0";
280         buffer[1] = "x";
281         for (uint256 i = 2 * length + 1; i > 1; --i) {
282             buffer[i] = _HEX_SYMBOLS[value & 0xf];
283             value >>= 4;
284         }
285         require(value == 0, "Strings: hex length insufficient");
286         return string(buffer);
287     }
288 }
289 
290 // File: @openzeppelin/contracts/utils/Address.sol
291 
292 
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies on extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         uint256 size;
323         assembly {
324             size := extcodesize(account)
325         }
326         return size > 0;
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         (bool success, ) = recipient.call{value: amount}("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353      * @dev Performs a Solidity function call using a low level `call`. A
354      * plain `call` is an unsafe replacement for a function call: use this
355      * function instead.
356      *
357      * If `target` reverts with a revert reason, it is bubbled up by this
358      * function (like regular Solidity function calls).
359      *
360      * Returns the raw returned data. To convert to the expected return value,
361      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362      *
363      * Requirements:
364      *
365      * - `target` must be a contract.
366      * - calling `target` with `data` must not revert.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
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
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
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
419         require(address(this).balance >= value, "Address: insufficient balance for call");
420         require(isContract(target), "Address: call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.call{value: value}(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
433         return functionStaticCall(target, data, "Address: low-level static call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal view returns (bytes memory) {
447         require(isContract(target), "Address: static call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.staticcall(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but performing a delegate call.
456      *
457      * _Available since v3.4._
458      */
459     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         require(isContract(target), "Address: delegate call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.delegatecall(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
482      * revert reason using the provided one.
483      *
484      * _Available since v4.3._
485      */
486     function verifyCallResult(
487         bool success,
488         bytes memory returndata,
489         string memory errorMessage
490     ) internal pure returns (bytes memory) {
491         if (success) {
492             return returndata;
493         } else {
494             // Look for revert reason and bubble it up if present
495             if (returndata.length > 0) {
496                 // The easiest way to bubble the revert reason is using memory via assembly
497 
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
518  * @dev See https://eips.ethereum.org/EIPS/eip-721
519  */
520 interface IERC721Metadata is IERC721 {
521     /**
522      * @dev Returns the token collection name.
523      */
524     function name() external view returns (string memory);
525 
526     /**
527      * @dev Returns the token collection symbol.
528      */
529     function symbol() external view returns (string memory);
530 
531     /**
532      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
533      */
534     function tokenURI(uint256 tokenId) external view returns (string memory);
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
538 
539 
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @title ERC721 token receiver interface
545  * @dev Interface for any contract that wants to support safeTransfers
546  * from ERC721 asset contracts.
547  */
548 interface IERC721Receiver {
549     /**
550      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
551      * by `operator` from `from`, this function is called.
552      *
553      * It must return its Solidity selector to confirm the token transfer.
554      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
555      *
556      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
557      */
558     function onERC721Received(
559         address operator,
560         address from,
561         uint256 tokenId,
562         bytes calldata data
563     ) external returns (bytes4);
564 }
565 
566 // File: @openzeppelin/contracts/utils/Context.sol
567 pragma solidity ^0.8.0;
568 /**
569  * @dev Provides information about the current execution context, including the
570  * sender of the transaction and its data. While these are generally available
571  * via msg.sender and msg.data, they should not be accessed in such a direct
572  * manner, since when dealing with meta-transactions the account sending and
573  * paying for execution may not be the actual sender (as far as an application
574  * is concerned).
575  *
576  * This contract is only required for intermediate, library-like contracts.
577  */
578 abstract contract Context {
579     function _msgSender() internal view virtual returns (address) {
580         return msg.sender;
581     }
582 
583     function _msgData() internal view virtual returns (bytes calldata) {
584         return msg.data;
585     }
586 }
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
592  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
593  *
594  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
595  *
596  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
597  *
598  * Does not support burning tokens to address(0).
599  */
600 contract ERC721A is
601   Context,
602   ERC165,
603   IERC721,
604   IERC721Metadata,
605   IERC721Enumerable
606 {
607   using Address for address;
608   using Strings for uint256;
609 
610   struct TokenOwnership {
611     address addr;
612     uint64 startTimestamp;
613   }
614 
615   struct AddressData {
616     uint128 balance;
617     uint128 numberMinted;
618   }
619 
620   uint256 private currentIndex = 0;
621 
622   uint256 internal immutable collectionSize;
623   uint256 internal immutable maxBatchSize;
624 
625   // Token name
626   string private _name;
627 
628   // Token symbol
629   string private _symbol;
630 
631   // Mapping from token ID to ownership details
632   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
633   mapping(uint256 => TokenOwnership) internal _ownerships;
634 
635   // Mapping owner address to address data
636   mapping(address => AddressData) private _addressData;
637 
638   // Mapping from token ID to approved address
639   mapping(uint256 => address) private _tokenApprovals;
640 
641   // Mapping from owner to operator approvals
642   mapping(address => mapping(address => bool)) private _operatorApprovals;
643 
644   /**
645    * @dev
646    * `maxBatchSize` refers to how much a minter can mint at a time.
647    * `collectionSize_` refers to how many tokens are in the collection.
648    */
649   constructor(
650     string memory name_,
651     string memory symbol_,
652     uint256 maxBatchSize_,
653     uint256 collectionSize_
654   ) {
655     require(
656       collectionSize_ > 0,
657       "ERC721A: collection must have a nonzero supply"
658     );
659     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
660     _name = name_;
661     _symbol = symbol_;
662     maxBatchSize = maxBatchSize_;
663     collectionSize = collectionSize_;
664   }
665 
666   /**
667    * @dev See {IERC721Enumerable-totalSupply}.
668    */
669   function totalSupply() public view override returns (uint256) {
670     return currentIndex;
671   }
672 
673   /**
674    * @dev See {IERC721Enumerable-tokenByIndex}.
675    */
676   function tokenByIndex(uint256 index) public view override returns (uint256) {
677     require(index < totalSupply(), "ERC721A: global index out of bounds");
678     return index;
679   }
680 
681   /**
682    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
683    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
684    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
685    */
686   function tokenOfOwnerByIndex(address owner, uint256 index)
687     public
688     view
689     override
690     returns (uint256)
691   {
692     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
693     uint256 numMintedSoFar = totalSupply();
694     uint256 tokenIdsIdx = 0;
695     address currOwnershipAddr = address(0);
696     for (uint256 i = 0; i < numMintedSoFar; i++) {
697       TokenOwnership memory ownership = _ownerships[i];
698       if (ownership.addr != address(0)) {
699         currOwnershipAddr = ownership.addr;
700       }
701       if (currOwnershipAddr == owner) {
702         if (tokenIdsIdx == index) {
703           return i;
704         }
705         tokenIdsIdx++;
706       }
707     }
708     revert("ERC721A: unable to get token of owner by index");
709   }
710 
711   /**
712    * @dev See {IERC165-supportsInterface}.
713    */
714   function supportsInterface(bytes4 interfaceId)
715     public
716     view
717     virtual
718     override(ERC165, IERC165)
719     returns (bool)
720   {
721     return
722       interfaceId == type(IERC721).interfaceId ||
723       interfaceId == type(IERC721Metadata).interfaceId ||
724       interfaceId == type(IERC721Enumerable).interfaceId ||
725       super.supportsInterface(interfaceId);
726   }
727 
728   /**
729    * @dev See {IERC721-balanceOf}.
730    */
731   function balanceOf(address owner) public view override returns (uint256) {
732     require(owner != address(0), "ERC721A: balance query for the zero address");
733     return uint256(_addressData[owner].balance);
734   }
735 
736   function _numberMinted(address owner) internal view returns (uint256) {
737     require(
738       owner != address(0),
739       "ERC721A: number minted query for the zero address"
740     );
741     return uint256(_addressData[owner].numberMinted);
742   }
743 
744   function ownershipOf(uint256 tokenId)
745     internal
746     view
747     returns (TokenOwnership memory)
748   {
749     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
750 
751     uint256 lowestTokenToCheck;
752     if (tokenId >= maxBatchSize) {
753       lowestTokenToCheck = tokenId - maxBatchSize + 1;
754     }
755 
756     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
757       TokenOwnership memory ownership = _ownerships[curr];
758       if (ownership.addr != address(0)) {
759         return ownership;
760       }
761     }
762 
763     revert("ERC721A: unable to determine the owner of token");
764   }
765 
766   /**
767    * @dev See {IERC721-ownerOf}.
768    */
769   function ownerOf(uint256 tokenId) public view override returns (address) {
770     return ownershipOf(tokenId).addr;
771   }
772 
773   /**
774    * @dev See {IERC721Metadata-name}.
775    */
776   function name() public view virtual override returns (string memory) {
777     return _name;
778   }
779 
780   /**
781    * @dev See {IERC721Metadata-symbol}.
782    */
783   function symbol() public view virtual override returns (string memory) {
784     return _symbol;
785   }
786 
787   /**
788    * @dev See {IERC721Metadata-tokenURI}.
789    */
790   function tokenURI(uint256 tokenId)
791     public
792     view
793     virtual
794     override
795     returns (string memory)
796   {
797     require(
798       _exists(tokenId),
799       "ERC721Metadata: URI query for nonexistent token"
800     );
801 
802     string memory baseURI = _baseURI();
803     return
804       bytes(baseURI).length > 0
805         ? string(abi.encodePacked(baseURI, tokenId.toString()))
806         : "";
807   }
808 
809   /**
810    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
811    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
812    * by default, can be overriden in child contracts.
813    */
814   function _baseURI() internal view virtual returns (string memory) {
815     return "";
816   }
817 
818   /**
819    * @dev See {IERC721-approve}.
820    */
821   function approve(address to, uint256 tokenId) public override {
822     address owner = ERC721A.ownerOf(tokenId);
823     require(to != owner, "ERC721A: approval to current owner");
824 
825     require(
826       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
827       "ERC721A: approve caller is not owner nor approved for all"
828     );
829 
830     _approve(to, tokenId, owner);
831   }
832 
833   /**
834    * @dev See {IERC721-getApproved}.
835    */
836   function getApproved(uint256 tokenId) public view override returns (address) {
837     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
838 
839     return _tokenApprovals[tokenId];
840   }
841 
842   /**
843    * @dev See {IERC721-setApprovalForAll}.
844    */
845   function setApprovalForAll(address operator, bool approved) public override {
846     require(operator != _msgSender(), "ERC721A: approve to caller");
847 
848     _operatorApprovals[_msgSender()][operator] = approved;
849     emit ApprovalForAll(_msgSender(), operator, approved);
850   }
851 
852   /**
853    * @dev See {IERC721-isApprovedForAll}.
854    */
855   function isApprovedForAll(address owner, address operator)
856     public
857     view
858     virtual
859     override
860     returns (bool)
861   {
862     return _operatorApprovals[owner][operator];
863   }
864 
865   /**
866    * @dev See {IERC721-transferFrom}.
867    */
868   function transferFrom(
869     address from,
870     address to,
871     uint256 tokenId
872   ) public override {
873     _transfer(from, to, tokenId);
874   }
875 
876   /**
877    * @dev See {IERC721-safeTransferFrom}.
878    */
879   function safeTransferFrom(
880     address from,
881     address to,
882     uint256 tokenId
883   ) public override {
884     safeTransferFrom(from, to, tokenId, "");
885   }
886 
887   /**
888    * @dev See {IERC721-safeTransferFrom}.
889    */
890   function safeTransferFrom(
891     address from,
892     address to,
893     uint256 tokenId,
894     bytes memory _data
895   ) public override {
896     _transfer(from, to, tokenId);
897     require(
898       _checkOnERC721Received(from, to, tokenId, _data),
899       "ERC721A: transfer to non ERC721Receiver implementer"
900     );
901   }
902 
903   /**
904    * @dev Returns whether `tokenId` exists.
905    *
906    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
907    *
908    * Tokens start existing when they are minted (`_mint`),
909    */
910   function _exists(uint256 tokenId) internal view returns (bool) {
911     return tokenId < currentIndex;
912   }
913 
914   function _safeMint(address to, uint256 quantity) internal {
915     _safeMint(to, quantity, "");
916   }
917 
918   /**
919    * @dev Mints `quantity` tokens and transfers them to `to`.
920    *
921    * Requirements:
922    *
923    * - there must be `quantity` tokens remaining unminted in the total collection.
924    * - `to` cannot be the zero address.
925    * - `quantity` cannot be larger than the max batch size.
926    *
927    * Emits a {Transfer} event.
928    */
929   function _safeMint(
930     address to,
931     uint256 quantity,
932     bytes memory _data
933   ) internal {
934     uint256 startTokenId = currentIndex;
935     require(to != address(0), "ERC721A: mint to the zero address");
936     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
937     require(!_exists(startTokenId), "ERC721A: token already minted");
938     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
939 
940     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
941 
942     AddressData memory addressData = _addressData[to];
943     _addressData[to] = AddressData(
944       addressData.balance + uint128(quantity),
945       addressData.numberMinted + uint128(quantity)
946     );
947     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
948 
949     uint256 updatedIndex = startTokenId;
950 
951     for (uint256 i = 0; i < quantity; i++) {
952       emit Transfer(address(0), to, updatedIndex);
953       require(
954         _checkOnERC721Received(address(0), to, updatedIndex, _data),
955         "ERC721A: transfer to non ERC721Receiver implementer"
956       );
957       updatedIndex++;
958     }
959 
960     currentIndex = updatedIndex;
961     _afterTokenTransfers(address(0), to, startTokenId, quantity);
962   }
963 
964   /**
965    * @dev Transfers `tokenId` from `from` to `to`.
966    *
967    * Requirements:
968    *
969    * - `to` cannot be the zero address.
970    * - `tokenId` token must be owned by `from`.
971    *
972    * Emits a {Transfer} event.
973    */
974   function _transfer(
975     address from,
976     address to,
977     uint256 tokenId
978   ) private {
979     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
980 
981     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
982       getApproved(tokenId) == _msgSender() ||
983       isApprovedForAll(prevOwnership.addr, _msgSender()));
984 
985     require(
986       isApprovedOrOwner,
987       "ERC721A: transfer caller is not owner nor approved"
988     );
989 
990     require(
991       prevOwnership.addr == from,
992       "ERC721A: transfer from incorrect owner"
993     );
994     require(to != address(0), "ERC721A: transfer to the zero address");
995 
996     _beforeTokenTransfers(from, to, tokenId, 1);
997 
998     // Clear approvals from the previous owner
999     _approve(address(0), tokenId, prevOwnership.addr);
1000 
1001     _addressData[from].balance -= 1;
1002     _addressData[to].balance += 1;
1003     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1004 
1005     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1006     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1007     uint256 nextTokenId = tokenId + 1;
1008     if (_ownerships[nextTokenId].addr == address(0)) {
1009       if (_exists(nextTokenId)) {
1010         _ownerships[nextTokenId] = TokenOwnership(
1011           prevOwnership.addr,
1012           prevOwnership.startTimestamp
1013         );
1014       }
1015     }
1016 
1017     emit Transfer(from, to, tokenId);
1018     _afterTokenTransfers(from, to, tokenId, 1);
1019   }
1020 
1021   /**
1022    * @dev Approve `to` to operate on `tokenId`
1023    *
1024    * Emits a {Approval} event.
1025    */
1026   function _approve(
1027     address to,
1028     uint256 tokenId,
1029     address owner
1030   ) private {
1031     _tokenApprovals[tokenId] = to;
1032     emit Approval(owner, to, tokenId);
1033   }
1034 
1035   uint256 public nextOwnerToExplicitlySet = 0;
1036 
1037   /**
1038    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1039    */
1040   function _setOwnersExplicit(uint256 quantity) internal {
1041     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1042     require(quantity > 0, "quantity must be nonzero");
1043     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1044     if (endIndex > collectionSize - 1) {
1045       endIndex = collectionSize - 1;
1046     }
1047     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1048     require(_exists(endIndex), "not enough minted yet for this cleanup");
1049     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1050       if (_ownerships[i].addr == address(0)) {
1051         TokenOwnership memory ownership = ownershipOf(i);
1052         _ownerships[i] = TokenOwnership(
1053           ownership.addr,
1054           ownership.startTimestamp
1055         );
1056       }
1057     }
1058     nextOwnerToExplicitlySet = endIndex + 1;
1059   }
1060 
1061   /**
1062    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1063    * The call is not executed if the target address is not a contract.
1064    *
1065    * @param from address representing the previous owner of the given token ID
1066    * @param to target address that will receive the tokens
1067    * @param tokenId uint256 ID of the token to be transferred
1068    * @param _data bytes optional data to send along with the call
1069    * @return bool whether the call correctly returned the expected magic value
1070    */
1071   function _checkOnERC721Received(
1072     address from,
1073     address to,
1074     uint256 tokenId,
1075     bytes memory _data
1076   ) private returns (bool) {
1077     if (to.isContract()) {
1078       try
1079         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1080       returns (bytes4 retval) {
1081         return retval == IERC721Receiver(to).onERC721Received.selector;
1082       } catch (bytes memory reason) {
1083         if (reason.length == 0) {
1084           revert("ERC721A: transfer to non ERC721Receiver implementer");
1085         } else {
1086           assembly {
1087             revert(add(32, reason), mload(reason))
1088           }
1089         }
1090       }
1091     } else {
1092       return true;
1093     }
1094   }
1095 
1096   /**
1097    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1098    *
1099    * startTokenId - the first token id to be transferred
1100    * quantity - the amount to be transferred
1101    *
1102    * Calling conditions:
1103    *
1104    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1105    * transferred to `to`.
1106    * - When `from` is zero, `tokenId` will be minted for `to`.
1107    */
1108   function _beforeTokenTransfers(
1109     address from,
1110     address to,
1111     uint256 startTokenId,
1112     uint256 quantity
1113   ) internal virtual {}
1114 
1115   /**
1116    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1117    * minting.
1118    *
1119    * startTokenId - the first token id to be transferred
1120    * quantity - the amount to be transferred
1121    *
1122    * Calling conditions:
1123    *
1124    * - when `from` and `to` are both non-zero.
1125    * - `from` and `to` are never both zero.
1126    */
1127   function _afterTokenTransfers(
1128     address from,
1129     address to,
1130     uint256 startTokenId,
1131     uint256 quantity
1132   ) internal virtual {}
1133 }
1134 
1135 // File: @openzeppelin/contracts/access/Ownable.sol
1136 pragma solidity ^0.8.0;
1137 /**
1138  * @dev Contract module which provides a basic access control mechanism, where
1139  * there is an account (an owner) that can be granted exclusive access to
1140  * specific functions.
1141  *
1142  * By default, the owner account will be the one that deploys the contract. This
1143  * can later be changed with {transferOwnership}.
1144  *
1145  * This module is used through inheritance. It will make available the modifier
1146  * `onlyOwner`, which can be applied to your functions to restrict their use to
1147  * the owner.
1148  */
1149 abstract contract Ownable is Context {
1150     address private _owner;
1151 
1152     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1153 
1154     /**
1155      * @dev Initializes the contract setting the deployer as the initial owner.
1156      */
1157     constructor() {
1158         _setOwner(_msgSender());
1159     }
1160 
1161     /**
1162      * @dev Returns the address of the current owner.
1163      */
1164     function owner() public view virtual returns (address) {
1165         return _owner;
1166     }
1167 
1168     /**
1169      * @dev Throws if called by any account other than the owner.
1170      */
1171     modifier onlyOwner() {
1172         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1173         _;
1174     }
1175 
1176     /**
1177      * @dev Leaves the contract without owner. It will not be possible to call
1178      * `onlyOwner` functions anymore. Can only be called by the current owner.
1179      *
1180      * NOTE: Renouncing ownership will leave the contract without an owner,
1181      * thereby removing any functionality that is only available to the owner.
1182      */
1183     function renounceOwnership() public virtual onlyOwner {
1184         _setOwner(address(0));
1185     }
1186 
1187     /**
1188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1189      * Can only be called by the current owner.
1190      */
1191     function transferOwnership(address newOwner) public virtual onlyOwner {
1192         require(newOwner != address(0), "Ownable: new owner is the zero address");
1193         _setOwner(newOwner);
1194     }
1195 
1196     function _setOwner(address newOwner) private {
1197         address oldOwner = _owner;
1198         _owner = newOwner;
1199         emit OwnershipTransferred(oldOwner, newOwner);
1200     }
1201 }
1202 
1203 pragma solidity >=0.7.0 <0.9.0;
1204 
1205 contract PeacefulApeClub is ERC721A, Ownable {
1206   using Strings for uint256;
1207 
1208   string public baseURI;
1209   string public baseExtension = ".json";
1210   string public notRevealedUri;
1211   uint256 public cost = 0 ether;
1212   uint256 public maxMintAmount = 3000;
1213   uint256 public nftPerAddressLimit = 1;
1214   uint256 public currentPhaseMintMaxAmount = 3000;
1215   uint256 public maxSupply;
1216 
1217   uint32 public publicSaleStart = 1647136800;
1218   uint32 public preSaleStart = 1646964000;
1219   uint32 public vipSaleStart = 1646618400;
1220 
1221   bool public publicSalePaused = true;
1222   bool public preSalePaused = true;
1223   bool public vipSalePaused = false;
1224   
1225   bool public revealed = false;
1226   bool public onlyWhitelisted = false;
1227 
1228   mapping(address => uint256) vipMintAmount;
1229   mapping(address => uint256) whitelistMint;
1230   mapping(address => uint256) addressMintedBalance;
1231 
1232   // addresses to manage this contract
1233   mapping(address => bool) controllers;
1234 
1235 
1236   constructor(
1237     string memory _name,
1238     string memory _symbol,
1239     string memory _initBaseURI,
1240     string memory _initNotRevealedUri,
1241     uint256 _maxSettingAmountPerMint,
1242     uint256 _maxCollectionSize
1243   ) ERC721A(_name, _symbol, _maxSettingAmountPerMint, _maxCollectionSize) {
1244     baseURI = _initBaseURI;
1245     notRevealedUri = _initNotRevealedUri;
1246     maxSupply = _maxCollectionSize;
1247   }
1248 
1249   // internal
1250   function _baseURI() internal view virtual override returns (string memory) {
1251     return baseURI;
1252   }
1253 
1254   // public
1255   function vipSaleMint(uint256 _mintAmount) public {
1256     require(_mintAmount > 0, "Mint Amount should be bigger than 0");
1257     require((!vipSalePaused)&&(vipSaleStart <= block.timestamp), "Not Reach VIP Sale Time");
1258   
1259     uint256 supply = totalSupply();
1260     require(_mintAmount > 0, "need to mint at least 1 NFT");
1261     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1262     require(supply + _mintAmount <= currentPhaseMintMaxAmount, "reach current Phase NFT limit");
1263     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1264 
1265     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1266     if (msg.sender != owner()) {
1267       require(vipMintAmount[msg.sender] != 0, "user is not VIP");
1268       uint256 vipMintCount = vipMintAmount[msg.sender];
1269       require(ownerMintedCount + _mintAmount <= vipMintCount, "max VIP Mint Amount exceeded");
1270       require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1271     }
1272     
1273 	addressMintedBalance[msg.sender] += _mintAmount;
1274     _safeMint(msg.sender, _mintAmount);
1275   }
1276 
1277   function preSaleMint(uint256 _mintAmount) public payable {
1278     require(_mintAmount > 0, "Mint Amount should be bigger than 0");
1279     require((!preSalePaused)&&(preSaleStart <= block.timestamp), "Not Reach Pre Sale Time");
1280   
1281     uint256 supply = totalSupply();
1282     require(_mintAmount > 0, "need to mint at least 1 NFT");
1283     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1284     require(supply + _mintAmount <= currentPhaseMintMaxAmount, "reach current Phase NFT limit");
1285     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1286 
1287     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1288     if(onlyWhitelisted == true) {
1289       require(whitelistMint[msg.sender] != 0, "user is not whitelisted");
1290       uint256 whitelistMintCount = whitelistMint[msg.sender];
1291       require(ownerMintedCount + _mintAmount <= whitelistMintCount, "max whitelist Mint Amount exceeded");
1292     }	
1293     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1294     require(msg.value >= cost * _mintAmount, "insufficient funds");
1295 
1296 	addressMintedBalance[msg.sender] += _mintAmount;    
1297     _safeMint(msg.sender, _mintAmount);
1298   }
1299 
1300   function publicSaleMint(uint256 _mintAmount) public payable {
1301     require(_mintAmount > 0, "Mint Amount should be bigger than 0");
1302     require((!publicSalePaused)&&(publicSaleStart <= block.timestamp), "Not Reach Public Sale Time");
1303   
1304     uint256 supply = totalSupply();
1305     require(_mintAmount > 0, "need to mint at least 1 NFT");
1306     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1307     require(supply + _mintAmount <= currentPhaseMintMaxAmount, "reach current Phase NFT limit");
1308     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1309 
1310     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1311     if(onlyWhitelisted == true) {
1312       require(whitelistMint[msg.sender] != 0, "user is not whitelisted");
1313       uint256 whitelistMintCount = whitelistMint[msg.sender];
1314       require(ownerMintedCount + _mintAmount <= whitelistMintCount, "max whitelist Mint Amount exceeded");
1315     }	
1316     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1317     require(msg.value >= cost * _mintAmount, "insufficient funds");
1318 
1319 	addressMintedBalance[msg.sender] += _mintAmount;      
1320     _safeMint(msg.sender, _mintAmount);
1321   }
1322   
1323   function checkWhitelistMintAmount(address _account) public view returns (uint256) {
1324     return whitelistMint[_account];
1325   }  
1326 
1327    /**
1328    * This implementation is only for read purpose
1329    */
1330 
1331   function walletOfOwner(address _owner) public view returns (uint256[] memory)
1332   {
1333     uint256 numMintedSoFar = totalSupply();
1334     address currOwnershipAddr = address(0);
1335     uint256 ownerTokenCount = balanceOf(_owner);
1336 //    require(ownerTokenCount > 0, "This address didn't have any token"); 
1337     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1338     uint256 tokenIdsIdx = 0;
1339 
1340     for (uint256 i = 0; i < numMintedSoFar; i++) {
1341       TokenOwnership memory ownership = _ownerships[i];
1342       if (ownership.addr != address(0)) {
1343         currOwnershipAddr = ownership.addr;
1344       }
1345       if (currOwnershipAddr == _owner) {
1346         tokenIds[tokenIdsIdx]= i ;
1347         tokenIdsIdx++;
1348       }
1349     }
1350     return tokenIds;
1351   }
1352 
1353    /**
1354    * token Id start from 0 due to 721A implementation
1355    * 
1356    */
1357   function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1358   {
1359     require(
1360       _exists(tokenId),
1361       "ERC721Metadata: URI query for nonexistent token"
1362     );
1363     
1364     if(revealed == false) {
1365         return notRevealedUri;
1366     }
1367 
1368     string memory currentBaseURI = _baseURI();
1369     return bytes(currentBaseURI).length > 0
1370         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1371         : "";
1372   }
1373 
1374   function publicSaleIsActive() public view returns (bool) {
1375     return ( (publicSaleStart <= block.timestamp) && (!publicSalePaused) );
1376   }
1377 
1378   function preSaleIsActive() public view returns (bool) {
1379     return ( (preSaleStart <= block.timestamp) && (!preSalePaused) );
1380   }
1381 
1382   function vipSaleIsActive() public view returns (bool) {
1383     return ( (vipSaleStart <= block.timestamp) && (!vipSalePaused) );
1384   }
1385 
1386   function checkVIPMintAmount(address _account) public view returns (uint256) {
1387     return vipMintAmount[_account];
1388   }
1389 
1390   // for controller
1391   function reveal(bool _state) public {
1392     require(controllers[msg.sender], "Only controllers can operate this function");
1393     revealed = _state;
1394   }
1395   
1396   function setNftPerAddressLimit(uint256 _limit) public {
1397     require(controllers[msg.sender], "Only controllers can operate this function");
1398     nftPerAddressLimit = _limit;
1399   }
1400   
1401   function setCost(uint256 _newCost) public {
1402     require(controllers[msg.sender], "Only controllers can operate this function");
1403     cost = _newCost;
1404   }
1405 
1406   function setmaxMintAmount(uint256 _newmaxMintAmount) public {
1407     require(controllers[msg.sender], "Only controllers can operate this function");
1408     maxMintAmount = _newmaxMintAmount;
1409   }
1410 
1411   function setcurrentPhaseMintMaxAmount(uint256 _newPhaseAmount) public {
1412     require(controllers[msg.sender], "Only controllers can operate this function");
1413     currentPhaseMintMaxAmount = _newPhaseAmount;
1414   }
1415 
1416   function setPublicSaleStart(uint32 timestamp) public {
1417     require(controllers[msg.sender], "Only controllers can operate this function");
1418     publicSaleStart = timestamp;
1419   }
1420   
1421   function setPreSaleStart(uint32 timestamp) public {
1422     require(controllers[msg.sender], "Only controllers can operate this function");
1423     preSaleStart = timestamp;
1424   } 
1425 
1426   function setVIPSaleStart(uint32 timestamp) public {
1427     require(controllers[msg.sender], "Only controllers can operate this function");
1428     vipSaleStart = timestamp;
1429   }
1430 
1431   function setBaseURI(string memory _newBaseURI) public {
1432     require(controllers[msg.sender], "Only controllers can operate this function");
1433     baseURI = _newBaseURI;
1434   }
1435 
1436   function setBaseExtension(string memory _newBaseExtension) public {
1437     require(controllers[msg.sender], "Only controllers can operate this function");
1438     baseExtension = _newBaseExtension;
1439   }
1440   
1441   function setNotRevealedURI(string memory _notRevealedURI) public {
1442     require(controllers[msg.sender], "Only controllers can operate this function");
1443     notRevealedUri = _notRevealedURI;
1444   }
1445 
1446   function setPreSalePause(bool _state) public {
1447     require(controllers[msg.sender], "Only controllers can operate this function");
1448     preSalePaused = _state;
1449   }
1450 
1451   function setVIPSalePause(bool _state) public {
1452     require(controllers[msg.sender], "Only controllers can operate this function");
1453     vipSalePaused = _state;
1454   }
1455 
1456    /**
1457    * This implementation is only for less than 1000 lists in WL with 100 lists a batch in Ethereum
1458    * cost 35000 gaslimit a list after the initial 50000 gaslimit
1459    */
1460   function setVIPUsers(address[] memory _accounts, uint256[] memory _amounts) public {
1461     require(controllers[msg.sender], "Only controllers can operate this function");
1462     require(_accounts.length == _amounts.length, "accounts and amounts array length mismatch");
1463 
1464     for (uint256 i = 0; i < _accounts.length; ++i) {
1465       vipMintAmount[_accounts[i]]=_amounts[i];
1466     }
1467   }
1468 
1469   function setPublicSalePause(bool _state) public {
1470     require(controllers[msg.sender], "Only controllers can operate this function");
1471     publicSalePaused = _state;
1472   }
1473   
1474   function setOnlyWhitelisted(bool _state) public {
1475     require(controllers[msg.sender], "Only controllers can operate this function");
1476     onlyWhitelisted = _state;
1477   }
1478 
1479    /**
1480    * This implementation is only for less than 1000 lists in WL with 100 lists a batch in Ethereum
1481    * cost 35000 gaslimit a list after the initial 50000 gaslimit
1482    */
1483   function whitelistUsers(address[] memory _accounts, uint256[] memory _amounts) public {
1484     require(controllers[msg.sender], "Only controllers can operate this function");
1485     require(_accounts.length == _amounts.length, "accounts and amounts array length mismatch");
1486 
1487     for (uint256 i = 0; i < _accounts.length; ++i) {
1488       whitelistMint[_accounts[i]]=_amounts[i];
1489     }
1490   }
1491 
1492   //only owner
1493  
1494    /**
1495    * enables an address for management
1496    * @param controller the address to enable
1497    */
1498   function addController(address controller) external onlyOwner {
1499     controllers[controller] = true;
1500   }
1501 
1502   /**
1503    * disables an address for management
1504    * @param controller the address to disbale
1505    */
1506   function removeController(address controller) external onlyOwner {
1507     controllers[controller] = false;
1508   }
1509  
1510   function withdraw() public onlyOwner {
1511     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1512     require(success);
1513   }
1514 }