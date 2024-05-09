1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
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
612 // File: erc721a/contracts/ERC721A.sol
613 
614 
615 // Creator: Chiru Labs
616 
617 pragma solidity ^0.8.0;
618 
619 
620 
621 
622 
623 
624 
625 
626 
627 /**
628  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
629  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
630  *
631  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
632  *
633  * Does not support burning tokens to address(0).
634  *
635  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
636  */
637 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
638     using Address for address;
639     using Strings for uint256;
640 
641     struct TokenOwnership {
642         address addr;
643         uint64 startTimestamp;
644     }
645 
646     struct AddressData {
647         uint128 balance;
648         uint128 numberMinted;
649     }
650 
651     uint256 internal _nextTokenId;
652 
653     // Token name
654     string private _name;
655 
656     // Token symbol
657     string private _symbol;
658 
659     // Mapping from token ID to ownership details
660     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
661     mapping(uint256 => TokenOwnership) internal _ownerships;
662 
663     // Mapping owner address to address data
664     mapping(address => AddressData) private _addressData;
665 
666     // Mapping from token ID to approved address
667     mapping(uint256 => address) private _tokenApprovals;
668 
669     // Mapping from owner to operator approvals
670     mapping(address => mapping(address => bool)) private _operatorApprovals;
671 
672     constructor(string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675         _nextTokenId = 1;
676     }
677 
678     /**
679      * @dev See {IERC721Enumerable-totalSupply}.
680      */
681     function totalSupply() public view override returns (uint256) {
682         return _nextTokenId - 1;
683     }
684 
685     /**
686      * @dev See {IERC721Enumerable-tokenByIndex}.
687      */
688     function tokenByIndex(uint256 index) public view override returns (uint256) {
689         require(index < totalSupply(), 'ERC721A: global index out of bounds');
690         return index;
691     }
692 
693     /**
694      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
695      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
696      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
697      */
698     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
699         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
700         uint256 numMintedSoFar = totalSupply();
701         uint256 tokenIdsIdx = 0;
702         address currOwnershipAddr = address(0);
703         for (uint256 i = 0; i < numMintedSoFar; i++) {
704             TokenOwnership memory ownership = _ownerships[i];
705             if (ownership.addr != address(0)) {
706                 currOwnershipAddr = ownership.addr;
707             }
708             if (currOwnershipAddr == owner) {
709                 if (tokenIdsIdx == index) {
710                     return i;
711                 }
712                 tokenIdsIdx++;
713             }
714         }
715         revert('ERC721A: unable to get token of owner by index');
716     }
717 
718     /**
719      * @dev See {IERC165-supportsInterface}.
720      */
721     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
722         return
723             interfaceId == type(IERC721).interfaceId ||
724             interfaceId == type(IERC721Metadata).interfaceId ||
725             interfaceId == type(IERC721Enumerable).interfaceId ||
726             super.supportsInterface(interfaceId);
727     }
728 
729     /**
730      * @dev See {IERC721-balanceOf}.
731      */
732     function balanceOf(address owner) public view override returns (uint256) {
733         require(owner != address(0), 'ERC721A: balance query for the zero address');
734         return uint256(_addressData[owner].balance);
735     }
736 
737     function _numberMinted(address owner) internal view returns (uint256) {
738         require(owner != address(0), 'ERC721A: number minted query for the zero address');
739         return uint256(_addressData[owner].numberMinted);
740     }
741 
742     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
743         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
744 
745         for (uint256 curr = tokenId; ; curr--) {
746             TokenOwnership memory ownership = _ownerships[curr];
747             if (ownership.addr != address(0)) {
748                 return ownership;
749             }
750         }
751 
752         revert('ERC721A: unable to determine the owner of token');
753     }
754 
755     /**
756      * @dev See {IERC721-ownerOf}.
757      */
758     function ownerOf(uint256 tokenId) public view override returns (address) {
759         return ownershipOf(tokenId).addr;
760     }
761 
762     /**
763      * @dev See {IERC721Metadata-name}.
764      */
765     function name() public view virtual override returns (string memory) {
766         return _name;
767     }
768 
769     /**
770      * @dev See {IERC721Metadata-symbol}.
771      */
772     function symbol() public view virtual override returns (string memory) {
773         return _symbol;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-tokenURI}.
778      */
779     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
780         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
781 
782         string memory baseURI = _baseURI();
783         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
784     }
785 
786     /**
787      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
788      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
789      * by default, can be overriden in child contracts.
790      */
791     function _baseURI() internal view virtual returns (string memory) {
792         return '';
793     }
794 
795     /**
796      * @dev See {IERC721-approve}.
797      */
798     function approve(address to, uint256 tokenId) public override {
799         address owner = ERC721A.ownerOf(tokenId);
800         require(to != owner, 'ERC721A: approval to current owner');
801 
802         require(
803             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
804             'ERC721A: approve caller is not owner nor approved for all'
805         );
806 
807         _approve(to, tokenId, owner);
808     }
809 
810     /**
811      * @dev See {IERC721-getApproved}.
812      */
813     function getApproved(uint256 tokenId) public view override returns (address) {
814         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
815 
816         return _tokenApprovals[tokenId];
817     }
818 
819     /**
820      * @dev See {IERC721-setApprovalForAll}.
821      */
822     function setApprovalForAll(address operator, bool approved) public override {
823         require(operator != _msgSender(), 'ERC721A: approve to caller');
824 
825         _operatorApprovals[_msgSender()][operator] = approved;
826         emit ApprovalForAll(_msgSender(), operator, approved);
827     }
828 
829     /**
830      * @dev See {IERC721-isApprovedForAll}.
831      */
832     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
833         return _operatorApprovals[owner][operator];
834     }
835 
836     /**
837      * @dev See {IERC721-transferFrom}.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public override {
844         _transfer(from, to, tokenId);
845     }
846 
847     /**
848      * @dev See {IERC721-safeTransferFrom}.
849      */
850     function safeTransferFrom(
851         address from,
852         address to,
853         uint256 tokenId
854     ) public override {
855         safeTransferFrom(from, to, tokenId, '');
856     }
857 
858     /**
859      * @dev See {IERC721-safeTransferFrom}.
860      */
861     function safeTransferFrom(
862         address from,
863         address to,
864         uint256 tokenId,
865         bytes memory _data
866     ) public override {
867         _transfer(from, to, tokenId);
868         require(
869             _checkOnERC721Received(from, to, tokenId, _data),
870             'ERC721A: transfer to non ERC721Receiver implementer'
871         );
872     }
873 
874     /**
875      * @dev Returns whether `tokenId` exists.
876      *
877      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
878      *
879      * Tokens start existing when they are minted (`_mint`),
880      */
881     function _exists(uint256 tokenId) internal view returns (bool) {
882         return tokenId < _nextTokenId;
883     }
884 
885     function _safeMint(address to, uint256 quantity) internal {
886         _safeMint(to, quantity, '');
887     }
888 
889     /**
890      * @dev Mints `quantity` tokens and transfers them to `to`.
891      *
892      * Requirements:
893      *
894      * - `to` cannot be the zero address.
895      * - `quantity` cannot be larger than the max batch size.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _safeMint(
900         address to,
901         uint256 quantity,
902         bytes memory _data
903     ) internal {
904         uint256 startTokenId = _nextTokenId;
905         require(to != address(0), 'ERC721A: mint to the zero address');
906         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
907         require(!_exists(startTokenId), 'ERC721A: token already minted');
908         require(quantity > 0, 'ERC721A: quantity must be greater 0');
909 
910         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
911 
912         AddressData memory addressData = _addressData[to];
913         _addressData[to] = AddressData(
914             addressData.balance + uint128(quantity),
915             addressData.numberMinted + uint128(quantity)
916         );
917         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
918 
919         uint256 updatedIndex = startTokenId;
920 
921         for (uint256 i = 0; i < quantity; i++) {
922             emit Transfer(address(0), to, updatedIndex);
923             require(
924                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
925                 'ERC721A: transfer to non ERC721Receiver implementer'
926             );
927             updatedIndex++;
928         }
929 
930         _nextTokenId = updatedIndex;
931         _afterTokenTransfers(address(0), to, startTokenId, quantity);
932     }
933 
934     /**
935      * @dev Transfers `tokenId` from `from` to `to`.
936      *
937      * Requirements:
938      *
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must be owned by `from`.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _transfer(
945         address from,
946         address to,
947         uint256 tokenId
948     ) private {
949         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
950 
951         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
952             getApproved(tokenId) == _msgSender() ||
953             isApprovedForAll(prevOwnership.addr, _msgSender()));
954 
955         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
956 
957         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
958         require(to != address(0), 'ERC721A: transfer to the zero address');
959 
960         _beforeTokenTransfers(from, to, tokenId, 1);
961 
962         // Clear approvals from the previous owner
963         _approve(address(0), tokenId, prevOwnership.addr);
964 
965         // Underflow of the sender's balance is impossible because we check for
966         // ownership above and the recipient's balance can't realistically overflow.
967         unchecked {
968             _addressData[from].balance -= 1;
969             _addressData[to].balance += 1;
970         }
971 
972         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
973 
974         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
975         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
976         uint256 nextTokenId = tokenId + 1;
977         if (_ownerships[nextTokenId].addr == address(0)) {
978             if (_exists(nextTokenId)) {
979                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
980             }
981         }
982 
983         emit Transfer(from, to, tokenId);
984         _afterTokenTransfers(from, to, tokenId, 1);
985     }
986 
987     /**
988      * @dev Approve `to` to operate on `tokenId`
989      *
990      * Emits a {Approval} event.
991      */
992     function _approve(
993         address to,
994         uint256 tokenId,
995         address owner
996     ) private {
997         _tokenApprovals[tokenId] = to;
998         emit Approval(owner, to, tokenId);
999     }
1000 
1001     /**
1002      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1003      * The call is not executed if the target address is not a contract.
1004      *
1005      * @param from address representing the previous owner of the given token ID
1006      * @param to target address that will receive the tokens
1007      * @param tokenId uint256 ID of the token to be transferred
1008      * @param _data bytes optional data to send along with the call
1009      * @return bool whether the call correctly returned the expected magic value
1010      */
1011     function _checkOnERC721Received(
1012         address from,
1013         address to,
1014         uint256 tokenId,
1015         bytes memory _data
1016     ) private returns (bool) {
1017         if (to.isContract()) {
1018             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1019                 return retval == IERC721Receiver(to).onERC721Received.selector;
1020             } catch (bytes memory reason) {
1021                 if (reason.length == 0) {
1022                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1023                 } else {
1024                     assembly {
1025                         revert(add(32, reason), mload(reason))
1026                     }
1027                 }
1028             }
1029         } else {
1030             return true;
1031         }
1032     }
1033 
1034     /**
1035      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1036      *
1037      * startTokenId - the first token id to be transferred
1038      * quantity - the amount to be transferred
1039      *
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` will be minted for `to`.
1045      */
1046     function _beforeTokenTransfers(
1047         address from,
1048         address to,
1049         uint256 startTokenId,
1050         uint256 quantity
1051     ) internal virtual {}
1052 
1053     /**
1054      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1055      * minting.
1056      *
1057      * startTokenId - the first token id to be transferred
1058      * quantity - the amount to be transferred
1059      *
1060      * Calling conditions:
1061      *
1062      * - when `from` and `to` are both non-zero.
1063      * - `from` and `to` are never both zero.
1064      */
1065     function _afterTokenTransfers(
1066         address from,
1067         address to,
1068         uint256 startTokenId,
1069         uint256 quantity
1070     ) internal virtual {}
1071 }
1072 
1073 // File: @openzeppelin/contracts/access/Ownable.sol
1074 
1075 
1076 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 
1081 /**
1082  * @dev Contract module which provides a basic access control mechanism, where
1083  * there is an account (an owner) that can be granted exclusive access to
1084  * specific functions.
1085  *
1086  * By default, the owner account will be the one that deploys the contract. This
1087  * can later be changed with {transferOwnership}.
1088  *
1089  * This module is used through inheritance. It will make available the modifier
1090  * `onlyOwner`, which can be applied to your functions to restrict their use to
1091  * the owner.
1092  */
1093 abstract contract Ownable is Context {
1094     address private _owner;
1095 
1096     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1097 
1098     /**
1099      * @dev Initializes the contract setting the deployer as the initial owner.
1100      */
1101     constructor() {
1102         _transferOwnership(_msgSender());
1103     }
1104 
1105     /**
1106      * @dev Returns the address of the current owner.
1107      */
1108     function owner() public view virtual returns (address) {
1109         return _owner;
1110     }
1111 
1112     /**
1113      * @dev Throws if called by any account other than the owner.
1114      */
1115     modifier onlyOwner() {
1116         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1117         _;
1118     }
1119 
1120     /**
1121      * @dev Leaves the contract without owner. It will not be possible to call
1122      * `onlyOwner` functions anymore. Can only be called by the current owner.
1123      *
1124      * NOTE: Renouncing ownership will leave the contract without an owner,
1125      * thereby removing any functionality that is only available to the owner.
1126      */
1127     function renounceOwnership() public virtual onlyOwner {
1128         _transferOwnership(address(0));
1129     }
1130 
1131     /**
1132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1133      * Can only be called by the current owner.
1134      */
1135     function transferOwnership(address newOwner) public virtual onlyOwner {
1136         require(newOwner != address(0), "Ownable: new owner is the zero address");
1137         _transferOwnership(newOwner);
1138     }
1139 
1140     /**
1141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1142      * Internal function without access restriction.
1143      */
1144     function _transferOwnership(address newOwner) internal virtual {
1145         address oldOwner = _owner;
1146         _owner = newOwner;
1147         emit OwnershipTransferred(oldOwner, newOwner);
1148     }
1149 }
1150 
1151 pragma solidity ^0.8.0;
1152 
1153 contract SwoleApeswtf is ERC721A, Ownable {
1154   using Strings for uint256;
1155   address public contractOwner;
1156   uint256 public mintPrice = 0.008 ether;
1157   uint256 public presalePrice = 0.0 ether;
1158   uint256 public supply = 8888;
1159   uint256 public freeAmount = 3000;
1160   string private baseURI = "ipfs://bafybeifzdp3sqwl5pnvxxtqk63vwuwirvuvirvy3ao4uahqp5z3ofpizoi/";
1161   uint8 public phase = 1;
1162   uint8 public maxBuy = 50;
1163   uint8 public presaleMaxBuy = 1;
1164 
1165   mapping(address => uint8)  public walletBuys;
1166 
1167   constructor() ERC721A("Swole Apes.wtf", "SWOLE") {
1168     contractOwner = msg.sender;
1169   }
1170 
1171   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1172     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1173 
1174     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1175   }
1176 
1177   function mintForAddress(address[] calldata _addresses, uint256 quantity) public onlyOwner {
1178     for (uint i=0; i<_addresses.length; i++) {
1179       _safeMint(_addresses[i], quantity);
1180     }
1181   }
1182 
1183   function mint(uint8 _mintAmount) external payable {
1184     require(phase == 3, "This sale has not started");
1185     require(totalSupply() + _mintAmount <= supply, "You can't mint more then the total supply");
1186     require(walletBuys[msg.sender] + _mintAmount <= maxBuy, "Buy limit reached");
1187     require(msg.value >= mintPrice * _mintAmount, "Insufficient funds");
1188 
1189     walletBuys[msg.sender] += _mintAmount;
1190     _safeMint(msg.sender, _mintAmount);
1191   }
1192 
1193   function publicMint(uint8 _mintAmount) external payable {
1194     require(phase == 2, "This sale has not started");
1195     require(totalSupply() + _mintAmount <= supply, "You can't mint more then the total supply");
1196     require(walletBuys[msg.sender] + _mintAmount <= presaleMaxBuy, "Buy limit reached");
1197     
1198 
1199     require(totalSupply() + _mintAmount < freeAmount, "All free mints have been claimed");
1200     require(msg.value >= presalePrice * _mintAmount, "Insufficient funds");
1201     
1202     walletBuys[msg.sender] += _mintAmount;
1203     _safeMint(msg.sender, _mintAmount);
1204     
1205   }
1206 
1207   function presaleMint(uint8 _mintAmount) public payable {
1208     // Verify presale list requirements
1209     require(phase == 0, "This sale has not started");
1210     require(walletBuys[msg.sender] + _mintAmount <= presaleMaxBuy, "Buy limit reached");
1211 
1212     walletBuys[msg.sender] += _mintAmount;
1213     _safeMint(msg.sender, _mintAmount);
1214   }
1215 
1216   function getBaseURI() public view returns (string memory) {
1217     return baseURI;
1218   }
1219 
1220   function _baseURI() internal view override returns (string memory) {
1221     return baseURI;
1222   }
1223 
1224   function setBaseURI(string memory baseURI_) external onlyOwner {
1225     baseURI = baseURI_;
1226   }
1227 
1228   function setMintPrice (uint256 _newPrice) external onlyOwner {
1229     mintPrice = _newPrice;
1230   }
1231 
1232   function setPresalePrice (uint256 _newPrice) external onlyOwner {
1233     presalePrice = _newPrice;
1234   }
1235 
1236   function setPhase(uint8 _phase) public onlyOwner {
1237     phase = _phase;
1238   }
1239 
1240   function setMaxBuy(uint8 _maxBuy) external onlyOwner {
1241       maxBuy = _maxBuy;
1242   }
1243 
1244   function setPresaleMaxBuy(uint8 _maxBuy) external onlyOwner {
1245       presaleMaxBuy = _maxBuy;
1246   }
1247 
1248   function updateSupply(uint256 _supply) external onlyOwner {
1249       supply = _supply;
1250   }
1251 
1252   function updateFreeAmount(uint256 _amount) external onlyOwner {
1253       freeAmount = _amount;
1254   }
1255 
1256   function getContractBalance () external view onlyOwner returns (uint256) {
1257     return address(this).balance;
1258   }
1259 
1260   function changeTreasury(address payable _newWallet) external onlyOwner {
1261     contractOwner = _newWallet;
1262   }
1263 
1264   function withdraw() external payable onlyOwner {
1265     (bool os, ) = payable(contractOwner).call{value: address(this).balance}("");
1266     require(os);
1267   }
1268 
1269 }