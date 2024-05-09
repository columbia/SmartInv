1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Address.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Collection of functions related to the address type
81  */
82 library Address {
83     /**
84      * @dev Returns true if `account` is a contract.
85      *
86      * [IMPORTANT]
87      * ====
88      * It is unsafe to assume that an address for which this function returns
89      * false is an externally-owned account (EOA) and not a contract.
90      *
91      * Among others, `isContract` will return false for the following
92      * types of addresses:
93      *
94      *  - an externally-owned account
95      *  - a contract in construction
96      *  - an address where a contract will be created
97      *  - an address where a contract lived, but was destroyed
98      * ====
99      */
100     function isContract(address account) internal view returns (bool) {
101         // This method relies on extcodesize, which returns 0 for contracts in
102         // construction, since the code is only stored at the end of the
103         // constructor execution.
104 
105         uint256 size;
106         assembly {
107             size := extcodesize(account)
108         }
109         return size > 0;
110     }
111 
112     /**
113      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
114      * `recipient`, forwarding all available gas and reverting on errors.
115      *
116      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
117      * of certain opcodes, possibly making contracts go over the 2300 gas limit
118      * imposed by `transfer`, making them unable to receive funds via
119      * `transfer`. {sendValue} removes this limitation.
120      *
121      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
122      *
123      * IMPORTANT: because control is transferred to `recipient`, care must be
124      * taken to not create reentrancy vulnerabilities. Consider using
125      * {ReentrancyGuard} or the
126      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
127      */
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         (bool success, ) = recipient.call{value: amount}("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134 
135     /**
136      * @dev Performs a Solidity function call using a low level `call`. A
137      * plain `call` is an unsafe replacement for a function call: use this
138      * function instead.
139      *
140      * If `target` reverts with a revert reason, it is bubbled up by this
141      * function (like regular Solidity function calls).
142      *
143      * Returns the raw returned data. To convert to the expected return value,
144      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
145      *
146      * Requirements:
147      *
148      * - `target` must be a contract.
149      * - calling `target` with `data` must not revert.
150      *
151      * _Available since v3.1._
152      */
153     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
159      * `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but also transferring `value` wei to `target`.
174      *
175      * Requirements:
176      *
177      * - the calling contract must have an ETH balance of at least `value`.
178      * - the called Solidity function must be `payable`.
179      *
180      * _Available since v3.1._
181      */
182     function functionCallWithValue(
183         address target,
184         bytes memory data,
185         uint256 value
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
192      * with `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         require(address(this).balance >= value, "Address: insufficient balance for call");
203         require(isContract(target), "Address: call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.call{value: value}(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but performing a static call.
212      *
213      * _Available since v3.3._
214      */
215     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
216         return functionStaticCall(target, data, "Address: low-level static call failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal view returns (bytes memory) {
230         require(isContract(target), "Address: static call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.staticcall(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but performing a delegate call.
239      *
240      * _Available since v3.4._
241      */
242     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         require(isContract(target), "Address: delegate call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.delegatecall(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
265      * revert reason using the provided one.
266      *
267      * _Available since v4.3._
268      */
269     function verifyCallResult(
270         bool success,
271         bytes memory returndata,
272         string memory errorMessage
273     ) internal pure returns (bytes memory) {
274         if (success) {
275             return returndata;
276         } else {
277             // Look for revert reason and bubble it up if present
278             if (returndata.length > 0) {
279                 // The easiest way to bubble the revert reason is using memory via assembly
280 
281                 assembly {
282                     let returndata_size := mload(returndata)
283                     revert(add(32, returndata), returndata_size)
284                 }
285             } else {
286                 revert(errorMessage);
287             }
288         }
289     }
290 }
291 
292 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @title ERC721 token receiver interface
301  * @dev Interface for any contract that wants to support safeTransfers
302  * from ERC721 asset contracts.
303  */
304 interface IERC721Receiver {
305     /**
306      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
307      * by `operator` from `from`, this function is called.
308      *
309      * It must return its Solidity selector to confirm the token transfer.
310      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
311      *
312      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
313      */
314     function onERC721Received(
315         address operator,
316         address from,
317         uint256 tokenId,
318         bytes calldata data
319     ) external returns (bytes4);
320 }
321 
322 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Interface of the ERC165 standard, as defined in the
331  * https://eips.ethereum.org/EIPS/eip-165[EIP].
332  *
333  * Implementers can declare support of contract interfaces, which can then be
334  * queried by others ({ERC165Checker}).
335  *
336  * For an implementation, see {ERC165}.
337  */
338 interface IERC165 {
339     /**
340      * @dev Returns true if this contract implements the interface defined by
341      * `interfaceId`. See the corresponding
342      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
343      * to learn more about how these ids are created.
344      *
345      * This function call must use less than 30 000 gas.
346      */
347     function supportsInterface(bytes4 interfaceId) external view returns (bool);
348 }
349 
350 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Implementation of the {IERC165} interface.
360  *
361  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
362  * for the additional interface id that will be supported. For example:
363  *
364  * ```solidity
365  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
366  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
367  * }
368  * ```
369  *
370  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
371  */
372 abstract contract ERC165 is IERC165 {
373     /**
374      * @dev See {IERC165-supportsInterface}.
375      */
376     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377         return interfaceId == type(IERC165).interfaceId;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 
389 /**
390  * @dev Required interface of an ERC721 compliant contract.
391  */
392 interface IERC721 is IERC165 {
393     /**
394      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
397 
398     /**
399      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
400      */
401     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
402 
403     /**
404      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
405      */
406     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
407 
408     /**
409      * @dev Returns the number of tokens in ``owner``'s account.
410      */
411     function balanceOf(address owner) external view returns (uint256 balance);
412 
413     /**
414      * @dev Returns the owner of the `tokenId` token.
415      *
416      * Requirements:
417      *
418      * - `tokenId` must exist.
419      */
420     function ownerOf(uint256 tokenId) external view returns (address owner);
421 
422     /**
423      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
424      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must exist and be owned by `from`.
431      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
433      *
434      * Emits a {Transfer} event.
435      */
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId
440     ) external;
441 
442     /**
443      * @dev Transfers `tokenId` token from `from` to `to`.
444      *
445      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must be owned by `from`.
452      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
453      *
454      * Emits a {Transfer} event.
455      */
456     function transferFrom(
457         address from,
458         address to,
459         uint256 tokenId
460     ) external;
461 
462     /**
463      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
464      * The approval is cleared when the token is transferred.
465      *
466      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
467      *
468      * Requirements:
469      *
470      * - The caller must own the token or be an approved operator.
471      * - `tokenId` must exist.
472      *
473      * Emits an {Approval} event.
474      */
475     function approve(address to, uint256 tokenId) external;
476 
477     /**
478      * @dev Returns the account approved for `tokenId` token.
479      *
480      * Requirements:
481      *
482      * - `tokenId` must exist.
483      */
484     function getApproved(uint256 tokenId) external view returns (address operator);
485 
486     /**
487      * @dev Approve or remove `operator` as an operator for the caller.
488      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
489      *
490      * Requirements:
491      *
492      * - The `operator` cannot be the caller.
493      *
494      * Emits an {ApprovalForAll} event.
495      */
496     function setApprovalForAll(address operator, bool _approved) external;
497 
498     /**
499      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
500      *
501      * See {setApprovalForAll}
502      */
503     function isApprovedForAll(address owner, address operator) external view returns (bool);
504 
505     /**
506      * @dev Safely transfers `tokenId` token from `from` to `to`.
507      *
508      * Requirements:
509      *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512      * - `tokenId` token must exist and be owned by `from`.
513      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
514      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
515      *
516      * Emits a {Transfer} event.
517      */
518     function safeTransferFrom(
519         address from,
520         address to,
521         uint256 tokenId,
522         bytes calldata data
523     ) external;
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
536  * @dev See https://eips.ethereum.org/EIPS/eip-721
537  */
538 interface IERC721Enumerable is IERC721 {
539     /**
540      * @dev Returns the total amount of tokens stored by the contract.
541      */
542     function totalSupply() external view returns (uint256);
543 
544     /**
545      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
546      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
547      */
548     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
549 
550     /**
551      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
552      * Use along with {totalSupply} to enumerate all tokens.
553      */
554     function tokenByIndex(uint256 index) external view returns (uint256);
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Metadata is IERC721 {
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() external view returns (string memory);
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() external view returns (string memory);
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) external view returns (string memory);
584 }
585 
586 // File: @openzeppelin/contracts/utils/Context.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev Provides information about the current execution context, including the
595  * sender of the transaction and its data. While these are generally available
596  * via msg.sender and msg.data, they should not be accessed in such a direct
597  * manner, since when dealing with meta-transactions the account sending and
598  * paying for execution may not be the actual sender (as far as an application
599  * is concerned).
600  *
601  * This contract is only required for intermediate, library-like contracts.
602  */
603 abstract contract Context {
604     function _msgSender() internal view virtual returns (address) {
605         return msg.sender;
606     }
607 
608     function _msgData() internal view virtual returns (bytes calldata) {
609         return msg.data;
610     }
611 }
612 
613 // File: erc721a/contracts/ERC721A.sol
614 
615 
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
1153 /**
1154  * @dev These functions deal with verification of Merkle Trees proofs.
1155  *
1156  * The proofs can be generated using the JavaScript library
1157  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1158  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1159  *
1160  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1161  *
1162  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1163  * hashing, or use a hash function other than keccak256 for hashing leaves.
1164  * This is because the concatenation of a sorted pair of internal nodes in
1165  * the merkle tree could be reinterpreted as a leaf value.
1166  */
1167 library MerkleProof {
1168     /**
1169      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1170      * defined by `root`. For this, a `proof` must be provided, containing
1171      * sibling hashes on the branch from the leaf to the root of the tree. Each
1172      * pair of leaves and each pair of pre-images are assumed to be sorted.
1173      */
1174     function verify(
1175         bytes32[] memory proof,
1176         bytes32 root,
1177         bytes32 leaf
1178     ) internal pure returns (bool) {
1179         return processProof(proof, leaf) == root;
1180     }
1181 
1182     /**
1183      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1184      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1185      * hash matches the root of the tree. When processing the proof, the pairs
1186      * of leafs & pre-images are assumed to be sorted.
1187      *
1188      * _Available since v4.4._
1189      */
1190     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1191         bytes32 computedHash = leaf;
1192         for (uint256 i = 0; i < proof.length; i++) {
1193             bytes32 proofElement = proof[i];
1194             if (computedHash <= proofElement) {
1195                 // Hash(current computed hash + current element of the proof)
1196                 computedHash = _efficientHash(computedHash, proofElement);
1197             } else {
1198                 // Hash(current element of the proof + current computed hash)
1199                 computedHash = _efficientHash(proofElement, computedHash);
1200             }
1201         }
1202         return computedHash;
1203     }
1204 
1205     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1206         assembly {
1207             mstore(0x00, a)
1208             mstore(0x20, b)
1209             value := keccak256(0x00, 0x40)
1210         }
1211     }
1212 }
1213 
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 contract YetiFam is ERC721A, Ownable {
1218   using Strings for uint256;
1219   uint256 public mintPrice = 0.008 ether;
1220   uint256 public supply = 1500;
1221   string private baseURI = "ipfs://QmUMWzwpCLZn7EYqRDRKAZ8LCbJWRNm7i7Z5cC1kSAv/";
1222   uint8 public phase = 1;
1223   uint8 public maxBuy = 5;
1224 
1225 
1226   mapping(address => uint8)  public walletBuys;
1227 
1228   constructor() ERC721A("YetiFam", "YetiFam") {
1229   }
1230 
1231   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1232     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1233 
1234     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1235   }
1236 
1237   function airdrop(address[] calldata _addresses, uint256 quantity) public onlyOwner {
1238     for (uint i=0; i<_addresses.length; i++) {
1239       _safeMint(_addresses[i], quantity);
1240     }
1241   }
1242 
1243   function mint(uint256 quantity) external payable {
1244     require(phase >= 2, "Sale has not started");
1245     require(totalSupply() + quantity <= supply, "You can't mint more then the total supply");
1246     require(walletBuys[msg.sender] + quantity <= maxBuy, "Buy limit reached");
1247     require(msg.value >= mintPrice * quantity, "Insufficient funds");
1248 
1249     _safeMint(msg.sender, quantity);
1250   }
1251 
1252 
1253   function getBaseURI() public view returns (string memory) {
1254     return baseURI;
1255   }
1256 
1257   function _baseURI() internal view override returns (string memory) {
1258     return baseURI;
1259   }
1260 
1261   function setBaseURI(string memory baseURI_) external onlyOwner {
1262     baseURI = baseURI_;
1263   }
1264 
1265   function setMintPrice (uint256 _newPrice) external onlyOwner {
1266     mintPrice = _newPrice;
1267   }
1268 
1269 
1270 
1271   function setPhase(uint8 _phase) public onlyOwner {
1272     phase = _phase;
1273   }
1274 
1275   function setMaxBuy(uint8 _maxBuy) external onlyOwner {
1276       maxBuy = _maxBuy;
1277   }
1278 
1279   function winnersReserve(uint256 _supply) external onlyOwner {
1280       supply = _supply;
1281   }
1282 
1283 
1284 
1285 
1286   function getContractBalance () external view onlyOwner returns (uint256) {
1287     return address(this).balance;
1288   }
1289 
1290   function withdrawAll() external onlyOwner{
1291         uint256 balance = address(this).balance;
1292         require(balance > 0, "Insufficent balance");
1293         
1294         address[2] memory addresses = [
1295             0xb81737cE7508A23ED8a4956F97547F04C3002d15,
1296             0xb81737cE7508A23ED8a4956F97547F04C3002d15 
1297         ];
1298 
1299         uint32[5] memory shares = [
1300             uint32(50),
1301             uint32(40),
1302             uint32(330),
1303             uint32(330),
1304             uint32(250)
1305         ];
1306 
1307         for (uint32 i = 0; i < addresses.length; i++) {
1308             uint256 amount = i == addresses.length - 1 ? address(this).balance : balance * shares[i] / 1000;
1309             _widthdraw(addresses[i], amount);
1310         }
1311   }
1312  
1313   //Withdraw balance from contract
1314   function _widthdraw(address _address, uint256 _amount) private {
1315         (bool success, ) = _address.call{ value: _amount }("");
1316         require(success, "Failed to withdraw Ether");
1317   }
1318 
1319 }