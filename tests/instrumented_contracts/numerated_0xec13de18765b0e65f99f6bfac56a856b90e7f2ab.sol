1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
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
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
238 
239 
240 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
246  * @dev See https://eips.ethereum.org/EIPS/eip-721
247  */
248 interface IERC721Enumerable is IERC721 {
249     /**
250      * @dev Returns the total amount of tokens stored by the contract.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
256      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
257      */
258     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
259 
260     /**
261      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
262      * Use along with {totalSupply} to enumerate all tokens.
263      */
264     function tokenByIndex(uint256 index) external view returns (uint256);
265 }
266 
267 
268 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
269 
270 
271 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         uint256 size;
302         assembly {
303             size := extcodesize(account)
304         }
305         return size > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         (bool success, ) = recipient.call{value: amount}("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain `call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(
379         address target,
380         bytes memory data,
381         uint256 value
382     ) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(address(this).balance >= value, "Address: insufficient balance for call");
399         require(isContract(target), "Address: call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.call{value: value}(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a static call.
408      *
409      * _Available since v3.3._
410      */
411     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
412         return functionStaticCall(target, data, "Address: low-level static call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal view returns (bytes memory) {
426         require(isContract(target), "Address: static call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.staticcall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.4._
437      */
438     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
439         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         require(isContract(target), "Address: delegate call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.delegatecall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
461      * revert reason using the provided one.
462      *
463      * _Available since v4.3._
464      */
465     function verifyCallResult(
466         bool success,
467         bytes memory returndata,
468         string memory errorMessage
469     ) internal pure returns (bytes memory) {
470         if (success) {
471             return returndata;
472         } else {
473             // Look for revert reason and bubble it up if present
474             if (returndata.length > 0) {
475                 // The easiest way to bubble the revert reason is using memory via assembly
476 
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 
489 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
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
517 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev String operations.
526  */
527 library Strings {
528     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
532      */
533     function toString(uint256 value) internal pure returns (string memory) {
534         // Inspired by OraclizeAPI's implementation - MIT licence
535         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
536 
537         if (value == 0) {
538             return "0";
539         }
540         uint256 temp = value;
541         uint256 digits;
542         while (temp != 0) {
543             digits++;
544             temp /= 10;
545         }
546         bytes memory buffer = new bytes(digits);
547         while (value != 0) {
548             digits -= 1;
549             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
550             value /= 10;
551         }
552         return string(buffer);
553     }
554 
555     /**
556      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
557      */
558     function toHexString(uint256 value) internal pure returns (string memory) {
559         if (value == 0) {
560             return "0x00";
561         }
562         uint256 temp = value;
563         uint256 length = 0;
564         while (temp != 0) {
565             length++;
566             temp >>= 8;
567         }
568         return toHexString(value, length);
569     }
570 
571     /**
572      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
573      */
574     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
575         bytes memory buffer = new bytes(2 * length + 2);
576         buffer[0] = "0";
577         buffer[1] = "x";
578         for (uint256 i = 2 * length + 1; i > 1; --i) {
579             buffer[i] = _HEX_SYMBOLS[value & 0xf];
580             value >>= 4;
581         }
582         require(value == 0, "Strings: hex length insufficient");
583         return string(buffer);
584     }
585 }
586 
587 
588 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 /**
596  * @dev Implementation of the {IERC165} interface.
597  *
598  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
599  * for the additional interface id that will be supported. For example:
600  *
601  * ```solidity
602  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
603  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
604  * }
605  * ```
606  *
607  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
608  */
609 abstract contract ERC165 is IERC165 {
610     /**
611      * @dev See {IERC165-supportsInterface}.
612      */
613     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614         return interfaceId == type(IERC165).interfaceId;
615     }
616 }
617 
618 
619 // File erc721a/contracts/ERC721A.sol@v1.0.0
620 
621 
622 // Creator: Chiru Labs
623 
624 pragma solidity ^0.8.0;
625 
626 
627 
628 
629 
630 
631 
632 
633 /**
634  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
635  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
636  *
637  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
638  *
639  * Does not support burning tokens to address(0).
640  */
641 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
642     using Address for address;
643     using Strings for uint256;
644 
645     struct TokenOwnership {
646         address addr;
647         uint64 startTimestamp;
648     }
649 
650     struct AddressData {
651         uint128 balance;
652         uint128 numberMinted;
653     }
654 
655     uint256 private currentIndex = 0;
656 
657     uint256 internal immutable maxBatchSize;
658 
659     // Token name
660     string private _name;
661 
662     // Token symbol
663     string private _symbol;
664 
665     // Mapping from token ID to ownership details
666     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
667     mapping(uint256 => TokenOwnership) private _ownerships;
668 
669     // Mapping owner address to address data
670     mapping(address => AddressData) private _addressData;
671 
672     // Mapping from token ID to approved address
673     mapping(uint256 => address) private _tokenApprovals;
674 
675     // Mapping from owner to operator approvals
676     mapping(address => mapping(address => bool)) private _operatorApprovals;
677 
678     /**
679      * @dev
680      * `maxBatchSize` refers to how much a minter can mint at a time.
681      */
682     constructor(
683         string memory name_,
684         string memory symbol_,
685         uint256 maxBatchSize_
686     ) {
687         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
688         _name = name_;
689         _symbol = symbol_;
690         maxBatchSize = maxBatchSize_;
691     }
692 
693     /**
694      * @dev See {IERC721Enumerable-totalSupply}.
695      */
696     function totalSupply() public view override returns (uint256) {
697         return currentIndex;
698     }
699 
700     /**
701      * @dev See {IERC721Enumerable-tokenByIndex}.
702      */
703     function tokenByIndex(uint256 index) public view override returns (uint256) {
704         require(index < totalSupply(), "ERC721A: global index out of bounds");
705         return index;
706     }
707 
708     /**
709      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
710      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
711      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
712      */
713     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
714         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
715         uint256 numMintedSoFar = totalSupply();
716         uint256 tokenIdsIdx = 0;
717         address currOwnershipAddr = address(0);
718         for (uint256 i = 0; i < numMintedSoFar; i++) {
719             TokenOwnership memory ownership = _ownerships[i];
720             if (ownership.addr != address(0)) {
721                 currOwnershipAddr = ownership.addr;
722             }
723             if (currOwnershipAddr == owner) {
724                 if (tokenIdsIdx == index) {
725                     return i;
726                 }
727                 tokenIdsIdx++;
728             }
729         }
730         revert("ERC721A: unable to get token of owner by index");
731     }
732 
733     /**
734      * @dev See {IERC165-supportsInterface}.
735      */
736     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
737         return
738             interfaceId == type(IERC721).interfaceId ||
739             interfaceId == type(IERC721Metadata).interfaceId ||
740             interfaceId == type(IERC721Enumerable).interfaceId ||
741             super.supportsInterface(interfaceId);
742     }
743 
744     /**
745      * @dev See {IERC721-balanceOf}.
746      */
747     function balanceOf(address owner) public view override returns (uint256) {
748         require(owner != address(0), "ERC721A: balance query for the zero address");
749         return uint256(_addressData[owner].balance);
750     }
751 
752     function _numberMinted(address owner) internal view returns (uint256) {
753         require(owner != address(0), "ERC721A: number minted query for the zero address");
754         return uint256(_addressData[owner].numberMinted);
755     }
756 
757     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
758         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
759 
760         uint256 lowestTokenToCheck;
761         if (tokenId >= maxBatchSize) {
762             lowestTokenToCheck = tokenId - maxBatchSize + 1;
763         }
764 
765         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
766             TokenOwnership memory ownership = _ownerships[curr];
767             if (ownership.addr != address(0)) {
768                 return ownership;
769             }
770         }
771 
772         revert("ERC721A: unable to determine the owner of token");
773     }
774 
775     /**
776      * @dev See {IERC721-ownerOf}.
777      */
778     function ownerOf(uint256 tokenId) public view override returns (address) {
779         return ownershipOf(tokenId).addr;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-name}.
784      */
785     function name() public view virtual override returns (string memory) {
786         return _name;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-symbol}.
791      */
792     function symbol() public view virtual override returns (string memory) {
793         return _symbol;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-tokenURI}.
798      */
799     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
800         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
801 
802         string memory baseURI = _baseURI();
803         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
804     }
805 
806     /**
807      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
808      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
809      * by default, can be overriden in child contracts.
810      */
811     function _baseURI() internal view virtual returns (string memory) {
812         return "";
813     }
814 
815     /**
816      * @dev See {IERC721-approve}.
817      */
818     function approve(address to, uint256 tokenId) public override {
819         address owner = ERC721A.ownerOf(tokenId);
820         require(to != owner, "ERC721A: approval to current owner");
821 
822         require(
823             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
824             "ERC721A: approve caller is not owner nor approved for all"
825         );
826 
827         _approve(to, tokenId, owner);
828     }
829 
830     /**
831      * @dev See {IERC721-getApproved}.
832      */
833     function getApproved(uint256 tokenId) public view override returns (address) {
834         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
835 
836         return _tokenApprovals[tokenId];
837     }
838 
839     /**
840      * @dev See {IERC721-setApprovalForAll}.
841      */
842     function setApprovalForAll(address operator, bool approved) public override {
843         require(operator != _msgSender(), "ERC721A: approve to caller");
844 
845         _operatorApprovals[_msgSender()][operator] = approved;
846         emit ApprovalForAll(_msgSender(), operator, approved);
847     }
848 
849     /**
850      * @dev See {IERC721-isApprovedForAll}.
851      */
852     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
853         return _operatorApprovals[owner][operator];
854     }
855 
856     /**
857      * @dev See {IERC721-transferFrom}.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) public override {
864         _transfer(from, to, tokenId);
865     }
866 
867     /**
868      * @dev See {IERC721-safeTransferFrom}.
869      */
870     function safeTransferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public override {
875         safeTransferFrom(from, to, tokenId, "");
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) public override {
887         _transfer(from, to, tokenId);
888         require(
889             _checkOnERC721Received(from, to, tokenId, _data),
890             "ERC721A: transfer to non ERC721Receiver implementer"
891         );
892     }
893 
894     /**
895      * @dev Returns whether `tokenId` exists.
896      *
897      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
898      *
899      * Tokens start existing when they are minted (`_mint`),
900      */
901     function _exists(uint256 tokenId) internal view returns (bool) {
902         return tokenId < currentIndex;
903     }
904 
905     function _safeMint(address to, uint256 quantity) internal {
906         _safeMint(to, quantity, "");
907     }
908 
909     /**
910      * @dev Mints `quantity` tokens and transfers them to `to`.
911      *
912      * Requirements:
913      *
914      * - `to` cannot be the zero address.
915      * - `quantity` cannot be larger than the max batch size.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _safeMint(
920         address to,
921         uint256 quantity,
922         bytes memory _data
923     ) internal {
924         uint256 startTokenId = currentIndex;
925         require(to != address(0), "ERC721A: mint to the zero address");
926         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
927         require(!_exists(startTokenId), "ERC721A: token already minted");
928         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
929 
930         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
931 
932         AddressData memory addressData = _addressData[to];
933         _addressData[to] = AddressData(
934             addressData.balance + uint128(quantity),
935             addressData.numberMinted + uint128(quantity)
936         );
937         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
938 
939         uint256 updatedIndex = startTokenId;
940 
941         for (uint256 i = 0; i < quantity; i++) {
942             emit Transfer(address(0), to, updatedIndex);
943             require(
944                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
945                 "ERC721A: transfer to non ERC721Receiver implementer"
946             );
947             updatedIndex++;
948         }
949 
950         currentIndex = updatedIndex;
951         _afterTokenTransfers(address(0), to, startTokenId, quantity);
952     }
953 
954     /**
955      * @dev Transfers `tokenId` from `from` to `to`.
956      *
957      * Requirements:
958      *
959      * - `to` cannot be the zero address.
960      * - `tokenId` token must be owned by `from`.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _transfer(
965         address from,
966         address to,
967         uint256 tokenId
968     ) private {
969         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
970 
971         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
972             getApproved(tokenId) == _msgSender() ||
973             isApprovedForAll(prevOwnership.addr, _msgSender()));
974 
975         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
976 
977         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
978         require(to != address(0), "ERC721A: transfer to the zero address");
979 
980         _beforeTokenTransfers(from, to, tokenId, 1);
981 
982         // Clear approvals from the previous owner
983         _approve(address(0), tokenId, prevOwnership.addr);
984 
985         _addressData[from].balance -= 1;
986         _addressData[to].balance += 1;
987         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
988 
989         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
990         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
991         uint256 nextTokenId = tokenId + 1;
992         if (_ownerships[nextTokenId].addr == address(0)) {
993             if (_exists(nextTokenId)) {
994                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
995             }
996         }
997 
998         emit Transfer(from, to, tokenId);
999         _afterTokenTransfers(from, to, tokenId, 1);
1000     }
1001 
1002     /**
1003      * @dev Approve `to` to operate on `tokenId`
1004      *
1005      * Emits a {Approval} event.
1006      */
1007     function _approve(
1008         address to,
1009         uint256 tokenId,
1010         address owner
1011     ) private {
1012         _tokenApprovals[tokenId] = to;
1013         emit Approval(owner, to, tokenId);
1014     }
1015 
1016     uint256 public nextOwnerToExplicitlySet = 0;
1017 
1018     /**
1019      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1020      */
1021     function _setOwnersExplicit(uint256 quantity) internal {
1022         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1023         require(quantity > 0, "quantity must be nonzero");
1024         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1025         if (endIndex > currentIndex - 1) {
1026             endIndex = currentIndex - 1;
1027         }
1028         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1029         require(_exists(endIndex), "not enough minted yet for this cleanup");
1030         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1031             if (_ownerships[i].addr == address(0)) {
1032                 TokenOwnership memory ownership = ownershipOf(i);
1033                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
1034             }
1035         }
1036         nextOwnerToExplicitlySet = endIndex + 1;
1037     }
1038 
1039     /**
1040      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1041      * The call is not executed if the target address is not a contract.
1042      *
1043      * @param from address representing the previous owner of the given token ID
1044      * @param to target address that will receive the tokens
1045      * @param tokenId uint256 ID of the token to be transferred
1046      * @param _data bytes optional data to send along with the call
1047      * @return bool whether the call correctly returned the expected magic value
1048      */
1049     function _checkOnERC721Received(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) private returns (bool) {
1055         if (to.isContract()) {
1056             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1057                 return retval == IERC721Receiver(to).onERC721Received.selector;
1058             } catch (bytes memory reason) {
1059                 if (reason.length == 0) {
1060                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1061                 } else {
1062                     assembly {
1063                         revert(add(32, reason), mload(reason))
1064                     }
1065                 }
1066             }
1067         } else {
1068             return true;
1069         }
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1074      *
1075      * startTokenId - the first token id to be transferred
1076      * quantity - the amount to be transferred
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` will be minted for `to`.
1083      */
1084     function _beforeTokenTransfers(
1085         address from,
1086         address to,
1087         uint256 startTokenId,
1088         uint256 quantity
1089     ) internal virtual {}
1090 
1091     /**
1092      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1093      * minting.
1094      *
1095      * startTokenId - the first token id to be transferred
1096      * quantity - the amount to be transferred
1097      *
1098      * Calling conditions:
1099      *
1100      * - when `from` and `to` are both non-zero.
1101      * - `from` and `to` are never both zero.
1102      */
1103     function _afterTokenTransfers(
1104         address from,
1105         address to,
1106         uint256 startTokenId,
1107         uint256 quantity
1108     ) internal virtual {}
1109 }
1110 
1111 
1112 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.4.2
1113 
1114 
1115 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 /**
1120  * @dev External interface of AccessControl declared to support ERC165 detection.
1121  */
1122 interface IAccessControl {
1123     /**
1124      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1125      *
1126      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1127      * {RoleAdminChanged} not being emitted signaling this.
1128      *
1129      * _Available since v3.1._
1130      */
1131     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1132 
1133     /**
1134      * @dev Emitted when `account` is granted `role`.
1135      *
1136      * `sender` is the account that originated the contract call, an admin role
1137      * bearer except when using {AccessControl-_setupRole}.
1138      */
1139     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1140 
1141     /**
1142      * @dev Emitted when `account` is revoked `role`.
1143      *
1144      * `sender` is the account that originated the contract call:
1145      *   - if using `revokeRole`, it is the admin role bearer
1146      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1147      */
1148     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1149 
1150     /**
1151      * @dev Returns `true` if `account` has been granted `role`.
1152      */
1153     function hasRole(bytes32 role, address account) external view returns (bool);
1154 
1155     /**
1156      * @dev Returns the admin role that controls `role`. See {grantRole} and
1157      * {revokeRole}.
1158      *
1159      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1160      */
1161     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1162 
1163     /**
1164      * @dev Grants `role` to `account`.
1165      *
1166      * If `account` had not been already granted `role`, emits a {RoleGranted}
1167      * event.
1168      *
1169      * Requirements:
1170      *
1171      * - the caller must have ``role``'s admin role.
1172      */
1173     function grantRole(bytes32 role, address account) external;
1174 
1175     /**
1176      * @dev Revokes `role` from `account`.
1177      *
1178      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1179      *
1180      * Requirements:
1181      *
1182      * - the caller must have ``role``'s admin role.
1183      */
1184     function revokeRole(bytes32 role, address account) external;
1185 
1186     /**
1187      * @dev Revokes `role` from the calling account.
1188      *
1189      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1190      * purpose is to provide a mechanism for accounts to lose their privileges
1191      * if they are compromised (such as when a trusted device is misplaced).
1192      *
1193      * If the calling account had been granted `role`, emits a {RoleRevoked}
1194      * event.
1195      *
1196      * Requirements:
1197      *
1198      * - the caller must be `account`.
1199      */
1200     function renounceRole(bytes32 role, address account) external;
1201 }
1202 
1203 
1204 // File @openzeppelin/contracts/access/AccessControl.sol@v4.4.2
1205 
1206 
1207 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
1208 
1209 pragma solidity ^0.8.0;
1210 
1211 
1212 
1213 
1214 /**
1215  * @dev Contract module that allows children to implement role-based access
1216  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1217  * members except through off-chain means by accessing the contract event logs. Some
1218  * applications may benefit from on-chain enumerability, for those cases see
1219  * {AccessControlEnumerable}.
1220  *
1221  * Roles are referred to by their `bytes32` identifier. These should be exposed
1222  * in the external API and be unique. The best way to achieve this is by
1223  * using `public constant` hash digests:
1224  *
1225  * ```
1226  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1227  * ```
1228  *
1229  * Roles can be used to represent a set of permissions. To restrict access to a
1230  * function call, use {hasRole}:
1231  *
1232  * ```
1233  * function foo() public {
1234  *     require(hasRole(MY_ROLE, msg.sender));
1235  *     ...
1236  * }
1237  * ```
1238  *
1239  * Roles can be granted and revoked dynamically via the {grantRole} and
1240  * {revokeRole} functions. Each role has an associated admin role, and only
1241  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1242  *
1243  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1244  * that only accounts with this role will be able to grant or revoke other
1245  * roles. More complex role relationships can be created by using
1246  * {_setRoleAdmin}.
1247  *
1248  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1249  * grant and revoke this role. Extra precautions should be taken to secure
1250  * accounts that have been granted it.
1251  */
1252 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1253     struct RoleData {
1254         mapping(address => bool) members;
1255         bytes32 adminRole;
1256     }
1257 
1258     mapping(bytes32 => RoleData) private _roles;
1259 
1260     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1261 
1262     /**
1263      * @dev Modifier that checks that an account has a specific role. Reverts
1264      * with a standardized message including the required role.
1265      *
1266      * The format of the revert reason is given by the following regular expression:
1267      *
1268      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1269      *
1270      * _Available since v4.1._
1271      */
1272     modifier onlyRole(bytes32 role) {
1273         _checkRole(role, _msgSender());
1274         _;
1275     }
1276 
1277     /**
1278      * @dev See {IERC165-supportsInterface}.
1279      */
1280     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1281         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1282     }
1283 
1284     /**
1285      * @dev Returns `true` if `account` has been granted `role`.
1286      */
1287     function hasRole(bytes32 role, address account) public view override returns (bool) {
1288         return _roles[role].members[account];
1289     }
1290 
1291     /**
1292      * @dev Revert with a standard message if `account` is missing `role`.
1293      *
1294      * The format of the revert reason is given by the following regular expression:
1295      *
1296      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1297      */
1298     function _checkRole(bytes32 role, address account) internal view {
1299         if (!hasRole(role, account)) {
1300             revert(
1301                 string(
1302                     abi.encodePacked(
1303                         "AccessControl: account ",
1304                         Strings.toHexString(uint160(account), 20),
1305                         " is missing role ",
1306                         Strings.toHexString(uint256(role), 32)
1307                     )
1308                 )
1309             );
1310         }
1311     }
1312 
1313     /**
1314      * @dev Returns the admin role that controls `role`. See {grantRole} and
1315      * {revokeRole}.
1316      *
1317      * To change a role's admin, use {_setRoleAdmin}.
1318      */
1319     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1320         return _roles[role].adminRole;
1321     }
1322 
1323     /**
1324      * @dev Grants `role` to `account`.
1325      *
1326      * If `account` had not been already granted `role`, emits a {RoleGranted}
1327      * event.
1328      *
1329      * Requirements:
1330      *
1331      * - the caller must have ``role``'s admin role.
1332      */
1333     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1334         _grantRole(role, account);
1335     }
1336 
1337     /**
1338      * @dev Revokes `role` from `account`.
1339      *
1340      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1341      *
1342      * Requirements:
1343      *
1344      * - the caller must have ``role``'s admin role.
1345      */
1346     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1347         _revokeRole(role, account);
1348     }
1349 
1350     /**
1351      * @dev Revokes `role` from the calling account.
1352      *
1353      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1354      * purpose is to provide a mechanism for accounts to lose their privileges
1355      * if they are compromised (such as when a trusted device is misplaced).
1356      *
1357      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1358      * event.
1359      *
1360      * Requirements:
1361      *
1362      * - the caller must be `account`.
1363      */
1364     function renounceRole(bytes32 role, address account) public virtual override {
1365         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1366 
1367         _revokeRole(role, account);
1368     }
1369 
1370     /**
1371      * @dev Grants `role` to `account`.
1372      *
1373      * If `account` had not been already granted `role`, emits a {RoleGranted}
1374      * event. Note that unlike {grantRole}, this function doesn't perform any
1375      * checks on the calling account.
1376      *
1377      * [WARNING]
1378      * ====
1379      * This function should only be called from the constructor when setting
1380      * up the initial roles for the system.
1381      *
1382      * Using this function in any other way is effectively circumventing the admin
1383      * system imposed by {AccessControl}.
1384      * ====
1385      *
1386      * NOTE: This function is deprecated in favor of {_grantRole}.
1387      */
1388     function _setupRole(bytes32 role, address account) internal virtual {
1389         _grantRole(role, account);
1390     }
1391 
1392     /**
1393      * @dev Sets `adminRole` as ``role``'s admin role.
1394      *
1395      * Emits a {RoleAdminChanged} event.
1396      */
1397     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1398         bytes32 previousAdminRole = getRoleAdmin(role);
1399         _roles[role].adminRole = adminRole;
1400         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1401     }
1402 
1403     /**
1404      * @dev Grants `role` to `account`.
1405      *
1406      * Internal function without access restriction.
1407      */
1408     function _grantRole(bytes32 role, address account) internal virtual {
1409         if (!hasRole(role, account)) {
1410             _roles[role].members[account] = true;
1411             emit RoleGranted(role, account, _msgSender());
1412         }
1413     }
1414 
1415     /**
1416      * @dev Revokes `role` from `account`.
1417      *
1418      * Internal function without access restriction.
1419      */
1420     function _revokeRole(bytes32 role, address account) internal virtual {
1421         if (hasRole(role, account)) {
1422             _roles[role].members[account] = false;
1423             emit RoleRevoked(role, account, _msgSender());
1424         }
1425     }
1426 }
1427 
1428 
1429 // File @openzeppelin/contracts/security/Pausable.sol@v4.4.2
1430 
1431 
1432 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1433 
1434 pragma solidity ^0.8.0;
1435 
1436 /**
1437  * @dev Contract module which allows children to implement an emergency stop
1438  * mechanism that can be triggered by an authorized account.
1439  *
1440  * This module is used through inheritance. It will make available the
1441  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1442  * the functions of your contract. Note that they will not be pausable by
1443  * simply including this module, only once the modifiers are put in place.
1444  */
1445 abstract contract Pausable is Context {
1446     /**
1447      * @dev Emitted when the pause is triggered by `account`.
1448      */
1449     event Paused(address account);
1450 
1451     /**
1452      * @dev Emitted when the pause is lifted by `account`.
1453      */
1454     event Unpaused(address account);
1455 
1456     bool private _paused;
1457 
1458     /**
1459      * @dev Initializes the contract in unpaused state.
1460      */
1461     constructor() {
1462         _paused = false;
1463     }
1464 
1465     /**
1466      * @dev Returns true if the contract is paused, and false otherwise.
1467      */
1468     function paused() public view virtual returns (bool) {
1469         return _paused;
1470     }
1471 
1472     /**
1473      * @dev Modifier to make a function callable only when the contract is not paused.
1474      *
1475      * Requirements:
1476      *
1477      * - The contract must not be paused.
1478      */
1479     modifier whenNotPaused() {
1480         require(!paused(), "Pausable: paused");
1481         _;
1482     }
1483 
1484     /**
1485      * @dev Modifier to make a function callable only when the contract is paused.
1486      *
1487      * Requirements:
1488      *
1489      * - The contract must be paused.
1490      */
1491     modifier whenPaused() {
1492         require(paused(), "Pausable: not paused");
1493         _;
1494     }
1495 
1496     /**
1497      * @dev Triggers stopped state.
1498      *
1499      * Requirements:
1500      *
1501      * - The contract must not be paused.
1502      */
1503     function _pause() internal virtual whenNotPaused {
1504         _paused = true;
1505         emit Paused(_msgSender());
1506     }
1507 
1508     /**
1509      * @dev Returns to normal state.
1510      *
1511      * Requirements:
1512      *
1513      * - The contract must be paused.
1514      */
1515     function _unpause() internal virtual whenPaused {
1516         _paused = false;
1517         emit Unpaused(_msgSender());
1518     }
1519 }
1520 
1521 
1522 // File hardhat/console.sol@v2.8.3
1523 
1524 
1525 pragma solidity >= 0.4.22 <0.9.0;
1526 
1527 library console {
1528 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1529 
1530 	function _sendLogPayload(bytes memory payload) private view {
1531 		uint256 payloadLength = payload.length;
1532 		address consoleAddress = CONSOLE_ADDRESS;
1533 		assembly {
1534 			let payloadStart := add(payload, 32)
1535 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1536 		}
1537 	}
1538 
1539 	function log() internal view {
1540 		_sendLogPayload(abi.encodeWithSignature("log()"));
1541 	}
1542 
1543 	function logInt(int p0) internal view {
1544 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1545 	}
1546 
1547 	function logUint(uint p0) internal view {
1548 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1549 	}
1550 
1551 	function logString(string memory p0) internal view {
1552 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1553 	}
1554 
1555 	function logBool(bool p0) internal view {
1556 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1557 	}
1558 
1559 	function logAddress(address p0) internal view {
1560 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1561 	}
1562 
1563 	function logBytes(bytes memory p0) internal view {
1564 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1565 	}
1566 
1567 	function logBytes1(bytes1 p0) internal view {
1568 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1569 	}
1570 
1571 	function logBytes2(bytes2 p0) internal view {
1572 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1573 	}
1574 
1575 	function logBytes3(bytes3 p0) internal view {
1576 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1577 	}
1578 
1579 	function logBytes4(bytes4 p0) internal view {
1580 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1581 	}
1582 
1583 	function logBytes5(bytes5 p0) internal view {
1584 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1585 	}
1586 
1587 	function logBytes6(bytes6 p0) internal view {
1588 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1589 	}
1590 
1591 	function logBytes7(bytes7 p0) internal view {
1592 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1593 	}
1594 
1595 	function logBytes8(bytes8 p0) internal view {
1596 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1597 	}
1598 
1599 	function logBytes9(bytes9 p0) internal view {
1600 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1601 	}
1602 
1603 	function logBytes10(bytes10 p0) internal view {
1604 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1605 	}
1606 
1607 	function logBytes11(bytes11 p0) internal view {
1608 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1609 	}
1610 
1611 	function logBytes12(bytes12 p0) internal view {
1612 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1613 	}
1614 
1615 	function logBytes13(bytes13 p0) internal view {
1616 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1617 	}
1618 
1619 	function logBytes14(bytes14 p0) internal view {
1620 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1621 	}
1622 
1623 	function logBytes15(bytes15 p0) internal view {
1624 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1625 	}
1626 
1627 	function logBytes16(bytes16 p0) internal view {
1628 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1629 	}
1630 
1631 	function logBytes17(bytes17 p0) internal view {
1632 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1633 	}
1634 
1635 	function logBytes18(bytes18 p0) internal view {
1636 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1637 	}
1638 
1639 	function logBytes19(bytes19 p0) internal view {
1640 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1641 	}
1642 
1643 	function logBytes20(bytes20 p0) internal view {
1644 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1645 	}
1646 
1647 	function logBytes21(bytes21 p0) internal view {
1648 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1649 	}
1650 
1651 	function logBytes22(bytes22 p0) internal view {
1652 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1653 	}
1654 
1655 	function logBytes23(bytes23 p0) internal view {
1656 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1657 	}
1658 
1659 	function logBytes24(bytes24 p0) internal view {
1660 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1661 	}
1662 
1663 	function logBytes25(bytes25 p0) internal view {
1664 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1665 	}
1666 
1667 	function logBytes26(bytes26 p0) internal view {
1668 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1669 	}
1670 
1671 	function logBytes27(bytes27 p0) internal view {
1672 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1673 	}
1674 
1675 	function logBytes28(bytes28 p0) internal view {
1676 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1677 	}
1678 
1679 	function logBytes29(bytes29 p0) internal view {
1680 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1681 	}
1682 
1683 	function logBytes30(bytes30 p0) internal view {
1684 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1685 	}
1686 
1687 	function logBytes31(bytes31 p0) internal view {
1688 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1689 	}
1690 
1691 	function logBytes32(bytes32 p0) internal view {
1692 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1693 	}
1694 
1695 	function log(uint p0) internal view {
1696 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1697 	}
1698 
1699 	function log(string memory p0) internal view {
1700 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1701 	}
1702 
1703 	function log(bool p0) internal view {
1704 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1705 	}
1706 
1707 	function log(address p0) internal view {
1708 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1709 	}
1710 
1711 	function log(uint p0, uint p1) internal view {
1712 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1713 	}
1714 
1715 	function log(uint p0, string memory p1) internal view {
1716 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1717 	}
1718 
1719 	function log(uint p0, bool p1) internal view {
1720 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1721 	}
1722 
1723 	function log(uint p0, address p1) internal view {
1724 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1725 	}
1726 
1727 	function log(string memory p0, uint p1) internal view {
1728 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1729 	}
1730 
1731 	function log(string memory p0, string memory p1) internal view {
1732 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1733 	}
1734 
1735 	function log(string memory p0, bool p1) internal view {
1736 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1737 	}
1738 
1739 	function log(string memory p0, address p1) internal view {
1740 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1741 	}
1742 
1743 	function log(bool p0, uint p1) internal view {
1744 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1745 	}
1746 
1747 	function log(bool p0, string memory p1) internal view {
1748 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1749 	}
1750 
1751 	function log(bool p0, bool p1) internal view {
1752 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1753 	}
1754 
1755 	function log(bool p0, address p1) internal view {
1756 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1757 	}
1758 
1759 	function log(address p0, uint p1) internal view {
1760 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1761 	}
1762 
1763 	function log(address p0, string memory p1) internal view {
1764 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1765 	}
1766 
1767 	function log(address p0, bool p1) internal view {
1768 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1769 	}
1770 
1771 	function log(address p0, address p1) internal view {
1772 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1773 	}
1774 
1775 	function log(uint p0, uint p1, uint p2) internal view {
1776 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1777 	}
1778 
1779 	function log(uint p0, uint p1, string memory p2) internal view {
1780 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1781 	}
1782 
1783 	function log(uint p0, uint p1, bool p2) internal view {
1784 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1785 	}
1786 
1787 	function log(uint p0, uint p1, address p2) internal view {
1788 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1789 	}
1790 
1791 	function log(uint p0, string memory p1, uint p2) internal view {
1792 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1793 	}
1794 
1795 	function log(uint p0, string memory p1, string memory p2) internal view {
1796 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1797 	}
1798 
1799 	function log(uint p0, string memory p1, bool p2) internal view {
1800 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1801 	}
1802 
1803 	function log(uint p0, string memory p1, address p2) internal view {
1804 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1805 	}
1806 
1807 	function log(uint p0, bool p1, uint p2) internal view {
1808 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1809 	}
1810 
1811 	function log(uint p0, bool p1, string memory p2) internal view {
1812 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1813 	}
1814 
1815 	function log(uint p0, bool p1, bool p2) internal view {
1816 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1817 	}
1818 
1819 	function log(uint p0, bool p1, address p2) internal view {
1820 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1821 	}
1822 
1823 	function log(uint p0, address p1, uint p2) internal view {
1824 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1825 	}
1826 
1827 	function log(uint p0, address p1, string memory p2) internal view {
1828 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1829 	}
1830 
1831 	function log(uint p0, address p1, bool p2) internal view {
1832 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1833 	}
1834 
1835 	function log(uint p0, address p1, address p2) internal view {
1836 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1837 	}
1838 
1839 	function log(string memory p0, uint p1, uint p2) internal view {
1840 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1841 	}
1842 
1843 	function log(string memory p0, uint p1, string memory p2) internal view {
1844 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1845 	}
1846 
1847 	function log(string memory p0, uint p1, bool p2) internal view {
1848 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1849 	}
1850 
1851 	function log(string memory p0, uint p1, address p2) internal view {
1852 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1853 	}
1854 
1855 	function log(string memory p0, string memory p1, uint p2) internal view {
1856 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1857 	}
1858 
1859 	function log(string memory p0, string memory p1, string memory p2) internal view {
1860 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1861 	}
1862 
1863 	function log(string memory p0, string memory p1, bool p2) internal view {
1864 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1865 	}
1866 
1867 	function log(string memory p0, string memory p1, address p2) internal view {
1868 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1869 	}
1870 
1871 	function log(string memory p0, bool p1, uint p2) internal view {
1872 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1873 	}
1874 
1875 	function log(string memory p0, bool p1, string memory p2) internal view {
1876 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1877 	}
1878 
1879 	function log(string memory p0, bool p1, bool p2) internal view {
1880 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1881 	}
1882 
1883 	function log(string memory p0, bool p1, address p2) internal view {
1884 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1885 	}
1886 
1887 	function log(string memory p0, address p1, uint p2) internal view {
1888 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1889 	}
1890 
1891 	function log(string memory p0, address p1, string memory p2) internal view {
1892 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1893 	}
1894 
1895 	function log(string memory p0, address p1, bool p2) internal view {
1896 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1897 	}
1898 
1899 	function log(string memory p0, address p1, address p2) internal view {
1900 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1901 	}
1902 
1903 	function log(bool p0, uint p1, uint p2) internal view {
1904 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1905 	}
1906 
1907 	function log(bool p0, uint p1, string memory p2) internal view {
1908 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1909 	}
1910 
1911 	function log(bool p0, uint p1, bool p2) internal view {
1912 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1913 	}
1914 
1915 	function log(bool p0, uint p1, address p2) internal view {
1916 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1917 	}
1918 
1919 	function log(bool p0, string memory p1, uint p2) internal view {
1920 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1921 	}
1922 
1923 	function log(bool p0, string memory p1, string memory p2) internal view {
1924 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1925 	}
1926 
1927 	function log(bool p0, string memory p1, bool p2) internal view {
1928 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1929 	}
1930 
1931 	function log(bool p0, string memory p1, address p2) internal view {
1932 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1933 	}
1934 
1935 	function log(bool p0, bool p1, uint p2) internal view {
1936 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1937 	}
1938 
1939 	function log(bool p0, bool p1, string memory p2) internal view {
1940 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1941 	}
1942 
1943 	function log(bool p0, bool p1, bool p2) internal view {
1944 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1945 	}
1946 
1947 	function log(bool p0, bool p1, address p2) internal view {
1948 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1949 	}
1950 
1951 	function log(bool p0, address p1, uint p2) internal view {
1952 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1953 	}
1954 
1955 	function log(bool p0, address p1, string memory p2) internal view {
1956 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1957 	}
1958 
1959 	function log(bool p0, address p1, bool p2) internal view {
1960 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1961 	}
1962 
1963 	function log(bool p0, address p1, address p2) internal view {
1964 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1965 	}
1966 
1967 	function log(address p0, uint p1, uint p2) internal view {
1968 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1969 	}
1970 
1971 	function log(address p0, uint p1, string memory p2) internal view {
1972 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1973 	}
1974 
1975 	function log(address p0, uint p1, bool p2) internal view {
1976 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1977 	}
1978 
1979 	function log(address p0, uint p1, address p2) internal view {
1980 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1981 	}
1982 
1983 	function log(address p0, string memory p1, uint p2) internal view {
1984 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1985 	}
1986 
1987 	function log(address p0, string memory p1, string memory p2) internal view {
1988 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1989 	}
1990 
1991 	function log(address p0, string memory p1, bool p2) internal view {
1992 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1993 	}
1994 
1995 	function log(address p0, string memory p1, address p2) internal view {
1996 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1997 	}
1998 
1999 	function log(address p0, bool p1, uint p2) internal view {
2000 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
2001 	}
2002 
2003 	function log(address p0, bool p1, string memory p2) internal view {
2004 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2005 	}
2006 
2007 	function log(address p0, bool p1, bool p2) internal view {
2008 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2009 	}
2010 
2011 	function log(address p0, bool p1, address p2) internal view {
2012 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2013 	}
2014 
2015 	function log(address p0, address p1, uint p2) internal view {
2016 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
2017 	}
2018 
2019 	function log(address p0, address p1, string memory p2) internal view {
2020 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2021 	}
2022 
2023 	function log(address p0, address p1, bool p2) internal view {
2024 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2025 	}
2026 
2027 	function log(address p0, address p1, address p2) internal view {
2028 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2029 	}
2030 
2031 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
2032 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
2033 	}
2034 
2035 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2036 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2037 	}
2038 
2039 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2040 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2041 	}
2042 
2043 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2044 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2045 	}
2046 
2047 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2048 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2049 	}
2050 
2051 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2052 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2053 	}
2054 
2055 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2056 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2057 	}
2058 
2059 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2060 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2061 	}
2062 
2063 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2064 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2065 	}
2066 
2067 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2068 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2069 	}
2070 
2071 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2072 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2073 	}
2074 
2075 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2076 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2077 	}
2078 
2079 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2080 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2081 	}
2082 
2083 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2084 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2085 	}
2086 
2087 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2088 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2089 	}
2090 
2091 	function log(uint p0, uint p1, address p2, address p3) internal view {
2092 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2093 	}
2094 
2095 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2096 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2097 	}
2098 
2099 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2100 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2101 	}
2102 
2103 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2104 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2105 	}
2106 
2107 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2108 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2109 	}
2110 
2111 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2112 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2113 	}
2114 
2115 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2116 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2117 	}
2118 
2119 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2120 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2121 	}
2122 
2123 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2124 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2125 	}
2126 
2127 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2128 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2129 	}
2130 
2131 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2132 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2133 	}
2134 
2135 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2136 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2137 	}
2138 
2139 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2140 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2141 	}
2142 
2143 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2144 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2145 	}
2146 
2147 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2148 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2149 	}
2150 
2151 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2152 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2153 	}
2154 
2155 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2156 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2157 	}
2158 
2159 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2160 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2161 	}
2162 
2163 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2164 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2165 	}
2166 
2167 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2168 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2169 	}
2170 
2171 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2172 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2173 	}
2174 
2175 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2176 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2177 	}
2178 
2179 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2180 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2181 	}
2182 
2183 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2184 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2185 	}
2186 
2187 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2188 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2189 	}
2190 
2191 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2192 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2193 	}
2194 
2195 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2196 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2197 	}
2198 
2199 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2200 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2201 	}
2202 
2203 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2204 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2205 	}
2206 
2207 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2208 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2209 	}
2210 
2211 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2212 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2213 	}
2214 
2215 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2216 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2217 	}
2218 
2219 	function log(uint p0, bool p1, address p2, address p3) internal view {
2220 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2221 	}
2222 
2223 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2224 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2225 	}
2226 
2227 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2228 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2229 	}
2230 
2231 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2232 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2233 	}
2234 
2235 	function log(uint p0, address p1, uint p2, address p3) internal view {
2236 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2237 	}
2238 
2239 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2240 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2241 	}
2242 
2243 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2244 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2245 	}
2246 
2247 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2248 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2249 	}
2250 
2251 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2252 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2253 	}
2254 
2255 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2256 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2257 	}
2258 
2259 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2260 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2261 	}
2262 
2263 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2264 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2265 	}
2266 
2267 	function log(uint p0, address p1, bool p2, address p3) internal view {
2268 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2269 	}
2270 
2271 	function log(uint p0, address p1, address p2, uint p3) internal view {
2272 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2273 	}
2274 
2275 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2276 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2277 	}
2278 
2279 	function log(uint p0, address p1, address p2, bool p3) internal view {
2280 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2281 	}
2282 
2283 	function log(uint p0, address p1, address p2, address p3) internal view {
2284 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2285 	}
2286 
2287 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2288 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2289 	}
2290 
2291 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2292 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2293 	}
2294 
2295 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2296 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2297 	}
2298 
2299 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2300 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2301 	}
2302 
2303 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2304 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2305 	}
2306 
2307 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2308 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2309 	}
2310 
2311 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2312 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2313 	}
2314 
2315 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2316 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2317 	}
2318 
2319 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2320 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2321 	}
2322 
2323 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2324 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2325 	}
2326 
2327 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2328 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2329 	}
2330 
2331 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2332 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2333 	}
2334 
2335 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2336 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2337 	}
2338 
2339 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2340 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2341 	}
2342 
2343 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2344 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2345 	}
2346 
2347 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2348 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2349 	}
2350 
2351 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2352 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2353 	}
2354 
2355 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2356 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2357 	}
2358 
2359 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2360 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2361 	}
2362 
2363 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2364 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2365 	}
2366 
2367 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2368 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2369 	}
2370 
2371 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2372 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2373 	}
2374 
2375 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2376 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2377 	}
2378 
2379 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2380 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2381 	}
2382 
2383 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2384 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2385 	}
2386 
2387 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2388 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2389 	}
2390 
2391 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2392 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2393 	}
2394 
2395 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2396 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2397 	}
2398 
2399 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2400 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2401 	}
2402 
2403 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2404 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2405 	}
2406 
2407 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2408 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2409 	}
2410 
2411 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2412 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2413 	}
2414 
2415 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2416 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2417 	}
2418 
2419 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2420 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2421 	}
2422 
2423 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2424 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2425 	}
2426 
2427 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2428 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2429 	}
2430 
2431 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2432 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2433 	}
2434 
2435 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2436 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2437 	}
2438 
2439 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2440 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2441 	}
2442 
2443 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2444 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2445 	}
2446 
2447 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2448 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2449 	}
2450 
2451 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2452 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2453 	}
2454 
2455 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2456 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2457 	}
2458 
2459 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2460 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2461 	}
2462 
2463 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2464 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2465 	}
2466 
2467 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2468 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2469 	}
2470 
2471 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2472 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2473 	}
2474 
2475 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2476 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2477 	}
2478 
2479 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2480 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2481 	}
2482 
2483 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2484 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2485 	}
2486 
2487 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2488 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2489 	}
2490 
2491 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2492 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2493 	}
2494 
2495 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2496 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2497 	}
2498 
2499 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2500 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2501 	}
2502 
2503 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2504 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2505 	}
2506 
2507 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2508 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2509 	}
2510 
2511 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2512 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2513 	}
2514 
2515 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2516 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2517 	}
2518 
2519 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2520 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2521 	}
2522 
2523 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2524 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2525 	}
2526 
2527 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2528 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2529 	}
2530 
2531 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2532 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2533 	}
2534 
2535 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2536 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2537 	}
2538 
2539 	function log(string memory p0, address p1, address p2, address p3) internal view {
2540 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2541 	}
2542 
2543 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2544 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2545 	}
2546 
2547 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2548 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2549 	}
2550 
2551 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2552 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2553 	}
2554 
2555 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2556 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2557 	}
2558 
2559 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2560 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2561 	}
2562 
2563 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2564 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2565 	}
2566 
2567 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2568 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2569 	}
2570 
2571 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2572 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2573 	}
2574 
2575 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2576 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2577 	}
2578 
2579 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2580 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2581 	}
2582 
2583 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2584 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2585 	}
2586 
2587 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2588 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2589 	}
2590 
2591 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2592 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2593 	}
2594 
2595 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2596 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2597 	}
2598 
2599 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2600 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2601 	}
2602 
2603 	function log(bool p0, uint p1, address p2, address p3) internal view {
2604 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2605 	}
2606 
2607 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2608 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2609 	}
2610 
2611 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2612 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2613 	}
2614 
2615 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2616 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2617 	}
2618 
2619 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2620 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2621 	}
2622 
2623 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2624 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2625 	}
2626 
2627 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2628 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2629 	}
2630 
2631 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2632 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2633 	}
2634 
2635 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2636 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2637 	}
2638 
2639 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2640 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2641 	}
2642 
2643 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2644 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2645 	}
2646 
2647 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2648 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2649 	}
2650 
2651 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2652 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2653 	}
2654 
2655 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2656 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2657 	}
2658 
2659 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2660 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2661 	}
2662 
2663 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2664 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2665 	}
2666 
2667 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2668 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2669 	}
2670 
2671 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2672 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2673 	}
2674 
2675 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2676 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2677 	}
2678 
2679 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2680 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2681 	}
2682 
2683 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2684 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2685 	}
2686 
2687 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2688 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2689 	}
2690 
2691 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2692 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2693 	}
2694 
2695 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2696 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2697 	}
2698 
2699 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2700 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2701 	}
2702 
2703 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2704 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2705 	}
2706 
2707 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2708 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2709 	}
2710 
2711 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2712 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2713 	}
2714 
2715 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2716 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2717 	}
2718 
2719 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2720 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2721 	}
2722 
2723 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2724 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2725 	}
2726 
2727 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2728 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2729 	}
2730 
2731 	function log(bool p0, bool p1, address p2, address p3) internal view {
2732 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2733 	}
2734 
2735 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2736 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2737 	}
2738 
2739 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2740 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2741 	}
2742 
2743 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2744 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2745 	}
2746 
2747 	function log(bool p0, address p1, uint p2, address p3) internal view {
2748 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2749 	}
2750 
2751 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2752 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2753 	}
2754 
2755 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2756 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2757 	}
2758 
2759 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2760 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2761 	}
2762 
2763 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2764 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2765 	}
2766 
2767 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2768 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2769 	}
2770 
2771 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2772 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2773 	}
2774 
2775 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2776 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2777 	}
2778 
2779 	function log(bool p0, address p1, bool p2, address p3) internal view {
2780 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2781 	}
2782 
2783 	function log(bool p0, address p1, address p2, uint p3) internal view {
2784 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2785 	}
2786 
2787 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2788 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2789 	}
2790 
2791 	function log(bool p0, address p1, address p2, bool p3) internal view {
2792 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2793 	}
2794 
2795 	function log(bool p0, address p1, address p2, address p3) internal view {
2796 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2797 	}
2798 
2799 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2800 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2801 	}
2802 
2803 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2804 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2805 	}
2806 
2807 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2808 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2809 	}
2810 
2811 	function log(address p0, uint p1, uint p2, address p3) internal view {
2812 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2813 	}
2814 
2815 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2816 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2817 	}
2818 
2819 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2820 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2821 	}
2822 
2823 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2824 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2825 	}
2826 
2827 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2828 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2829 	}
2830 
2831 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2832 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2833 	}
2834 
2835 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2836 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2837 	}
2838 
2839 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2840 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2841 	}
2842 
2843 	function log(address p0, uint p1, bool p2, address p3) internal view {
2844 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2845 	}
2846 
2847 	function log(address p0, uint p1, address p2, uint p3) internal view {
2848 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2849 	}
2850 
2851 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2852 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2853 	}
2854 
2855 	function log(address p0, uint p1, address p2, bool p3) internal view {
2856 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2857 	}
2858 
2859 	function log(address p0, uint p1, address p2, address p3) internal view {
2860 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2861 	}
2862 
2863 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2864 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2865 	}
2866 
2867 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2868 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2869 	}
2870 
2871 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2872 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2873 	}
2874 
2875 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2876 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2877 	}
2878 
2879 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2880 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2881 	}
2882 
2883 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2884 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2885 	}
2886 
2887 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2888 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2889 	}
2890 
2891 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2892 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2893 	}
2894 
2895 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2896 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2897 	}
2898 
2899 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2900 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2901 	}
2902 
2903 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2904 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2905 	}
2906 
2907 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2908 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2909 	}
2910 
2911 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2912 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2913 	}
2914 
2915 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2916 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2917 	}
2918 
2919 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2920 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2921 	}
2922 
2923 	function log(address p0, string memory p1, address p2, address p3) internal view {
2924 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2925 	}
2926 
2927 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2928 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2929 	}
2930 
2931 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2932 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2933 	}
2934 
2935 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2936 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2937 	}
2938 
2939 	function log(address p0, bool p1, uint p2, address p3) internal view {
2940 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2941 	}
2942 
2943 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2944 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2945 	}
2946 
2947 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2948 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2949 	}
2950 
2951 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2952 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2953 	}
2954 
2955 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2956 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2957 	}
2958 
2959 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2960 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2961 	}
2962 
2963 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2964 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2965 	}
2966 
2967 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2968 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2969 	}
2970 
2971 	function log(address p0, bool p1, bool p2, address p3) internal view {
2972 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2973 	}
2974 
2975 	function log(address p0, bool p1, address p2, uint p3) internal view {
2976 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2977 	}
2978 
2979 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2980 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2981 	}
2982 
2983 	function log(address p0, bool p1, address p2, bool p3) internal view {
2984 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2985 	}
2986 
2987 	function log(address p0, bool p1, address p2, address p3) internal view {
2988 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2989 	}
2990 
2991 	function log(address p0, address p1, uint p2, uint p3) internal view {
2992 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2993 	}
2994 
2995 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2996 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2997 	}
2998 
2999 	function log(address p0, address p1, uint p2, bool p3) internal view {
3000 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
3001 	}
3002 
3003 	function log(address p0, address p1, uint p2, address p3) internal view {
3004 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
3005 	}
3006 
3007 	function log(address p0, address p1, string memory p2, uint p3) internal view {
3008 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
3009 	}
3010 
3011 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3012 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3013 	}
3014 
3015 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3016 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3017 	}
3018 
3019 	function log(address p0, address p1, string memory p2, address p3) internal view {
3020 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3021 	}
3022 
3023 	function log(address p0, address p1, bool p2, uint p3) internal view {
3024 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
3025 	}
3026 
3027 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3028 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3029 	}
3030 
3031 	function log(address p0, address p1, bool p2, bool p3) internal view {
3032 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3033 	}
3034 
3035 	function log(address p0, address p1, bool p2, address p3) internal view {
3036 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3037 	}
3038 
3039 	function log(address p0, address p1, address p2, uint p3) internal view {
3040 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3041 	}
3042 
3043 	function log(address p0, address p1, address p2, string memory p3) internal view {
3044 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3045 	}
3046 
3047 	function log(address p0, address p1, address p2, bool p3) internal view {
3048 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3049 	}
3050 
3051 	function log(address p0, address p1, address p2, address p3) internal view {
3052 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3053 	}
3054 
3055 }
3056 
3057 
3058 // File contracts/NomadERC721A.sol
3059 
3060 
3061 pragma solidity ^0.8.9;
3062 
3063 
3064 
3065 
3066 interface NomadPassInterface {
3067     function balanceOf(address account, uint256 id)
3068     external
3069     view
3070     returns (uint256);
3071 
3072     function burnFromRedeemedToken(
3073         address account,
3074         uint256 id,
3075         uint256 amount
3076     ) external;
3077 }
3078 
3079 interface NomadRewardInterface {
3080     function balanceOf(address account, uint256 id)
3081     external
3082     view
3083     returns (uint256);
3084 
3085     function mint(
3086         address account,
3087         uint256 id,
3088         uint256 amount
3089     ) external;
3090 }
3091 
3092 
3093 contract Nomad721A is ERC721A, AccessControl, Pausable {
3094 
3095     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
3096 
3097     NomadPassInterface private _nomadPass;
3098     NomadRewardInterface private _nomadReward;
3099     mapping(address => uint256[]) private _tokenIndexes;
3100 
3101     uint256 private _maxItems;
3102     uint256 private _maxPerTransaction;
3103 
3104     event TokensRedeemed(address, uint256[] ids);
3105     event RewardsRedeemed(address, uint256[] ids);
3106     event FounderBurned(address, uint256 amount);
3107     event CollectorBurned(address, uint256 amount);
3108 
3109     string private _contractURI = "";
3110     string private baseURI = "";
3111 
3112     constructor(address nomadPassAddress, uint256 maxItems, string memory name, string memory symbol, uint256 maxBatchItems) ERC721A(name, symbol, maxBatchItems) {
3113         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
3114         _setupRole(OPERATOR_ROLE, msg.sender);
3115         _nomadPass = NomadPassInterface(nomadPassAddress);
3116         _maxItems = maxItems;
3117 
3118     }
3119 
3120 
3121     function setContractURI(string memory newContractURI)
3122     external
3123     onlyRole(OPERATOR_ROLE)
3124     {
3125         _contractURI = newContractURI;
3126     }
3127 
3128     ///Returns the contract URI for OpenSea
3129     function contractURI() public view returns (string memory) {
3130         return _contractURI;
3131     }
3132 
3133     function exists(uint256 tokenId) public view returns (bool) {
3134         return super._exists(tokenId);
3135     }
3136 
3137     function setNomadPass(address nomadPassAddress)
3138     external
3139     onlyRole(OPERATOR_ROLE)
3140     {
3141         _nomadPass = NomadPassInterface(nomadPassAddress);
3142     }
3143 
3144     function setNomadReward(address nomadRewardAddress)
3145     external
3146     onlyRole(OPERATOR_ROLE)
3147     {
3148         _nomadReward = NomadRewardInterface(nomadRewardAddress);
3149     }
3150 
3151     function setMaxItems(uint256 maxItems)
3152     external
3153     onlyRole(OPERATOR_ROLE)
3154     {
3155         _maxItems = maxItems;
3156     }
3157 
3158     function setMaxPerTransaction(uint256 maxPerTransaction)
3159     external
3160     onlyRole(OPERATOR_ROLE)
3161     {
3162         _maxPerTransaction = maxPerTransaction;
3163     }
3164 
3165 
3166     function getCounter()
3167     external
3168     view
3169     returns (uint256)
3170     {
3171         return totalSupply();
3172     }
3173 
3174     function getTokenIndexes(address account)
3175     external
3176     view
3177     returns (uint256[] memory)
3178     {
3179         return _tokenIndexes[account];
3180     }
3181 
3182 
3183     function getRewardContractBalance(address account, uint256 index)
3184     external
3185     view
3186     returns (uint256)
3187     {
3188         require(address(_nomadReward) != address(0), "INVALID_REWARD_CONTRACT");
3189         return _nomadReward.balanceOf(account, index);
3190     }
3191 
3192 
3193     function _baseURI() internal view override returns (string memory) {
3194         return baseURI;
3195     }
3196 
3197     function setBaseURI(string memory _newBaseURI) public onlyRole(OPERATOR_ROLE) {
3198         baseURI = _newBaseURI;
3199     }
3200 
3201 
3202     function pause() public onlyRole(OPERATOR_ROLE) {
3203         _pause();
3204     }
3205 
3206     function unpause() public onlyRole(OPERATOR_ROLE) {
3207         _unpause();
3208     }
3209 
3210     function redeem(uint256 founderAmount, uint256 collectorAmount) external
3211     {
3212         require(!paused(), "CONTRACT_PAUSED");
3213         require(address(_nomadReward) != address(0), "INVALID_REWARD_CONTRACT");
3214 
3215         //0 is the id for Founder Pass
3216         require(founderAmount <= _nomadPass.balanceOf(msg.sender, 0), "INCORRECT_FOUNDER_BALANCE");
3217 
3218         //1 is the id for Collector Pass
3219         require(collectorAmount <= _nomadPass.balanceOf(msg.sender, 1), "INCORRECT_COLLECTOR_BALANCE");
3220 
3221         uint256 total = founderAmount + collectorAmount;
3222         if (_maxPerTransaction > 0) {
3223             require(total <= _maxPerTransaction, "INCORRECT_MAX_TRANSACTION");
3224         }
3225 
3226         require(totalSupply() + total <= _maxItems, "INCORRECT_TOTAL_BALANCE");
3227 
3228 
3229 
3230 
3231         //The counter for totalSupply() starts at zero
3232         uint256 startIndex = totalSupply();
3233 
3234         _safeMint(msg.sender, total, "");
3235 
3236 
3237         uint256[] memory ids = new uint256[](total);
3238         uint256 counter = 0;
3239 
3240         //Fill the mappings with the indexes
3241         for (uint256 i = startIndex; i < total + startIndex; i++) {
3242             _tokenIndexes[msg.sender].push(i);
3243             ids[counter] = i;
3244             counter++;
3245         }
3246         //TokensRedeemed will contain all the ids
3247         emit TokensRedeemed(msg.sender, ids);
3248 
3249         //Burn Founder passes
3250         if (founderAmount > 0) {
3251             _nomadReward.mint(msg.sender, 0, founderAmount);
3252             _nomadPass.burnFromRedeemedToken(msg.sender, 0, founderAmount);
3253             emit FounderBurned(msg.sender, founderAmount);
3254         }
3255 
3256         //Burn Collector passes
3257         if (collectorAmount > 0) {
3258             _nomadPass.burnFromRedeemedToken(msg.sender, 1, collectorAmount);
3259             emit CollectorBurned(msg.sender, collectorAmount);
3260         }
3261 
3262     }
3263 
3264 
3265 
3266     // The following functions are overrides required by Solidity.
3267     function supportsInterface(bytes4 interfaceId)
3268     public
3269     view
3270     override(ERC721A, AccessControl)
3271     returns (bool)
3272     {
3273         return super.supportsInterface(interfaceId);
3274     }
3275 
3276 }