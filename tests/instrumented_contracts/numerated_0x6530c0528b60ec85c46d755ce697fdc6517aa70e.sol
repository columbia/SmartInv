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
616 // Creator: Chiru Labs
617 
618 pragma solidity ^0.8.0;
619 
620 
621 
622 
623 
624 
625 
626 
627 
628 /**
629  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
630  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
631  *
632  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
633  *
634  * Does not support burning tokens to address(0).
635  *
636  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
637  */
638 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
639     using Address for address;
640     using Strings for uint256;
641 
642     struct TokenOwnership {
643         address addr;
644         uint64 startTimestamp;
645     }
646 
647     struct AddressData {
648         uint128 balance;
649         uint128 numberMinted;
650     }
651 
652     uint256 internal _nextTokenId;
653 
654     // Token name
655     string private _name;
656 
657     // Token symbol
658     string private _symbol;
659 
660     // Mapping from token ID to ownership details
661     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
662     mapping(uint256 => TokenOwnership) internal _ownerships;
663 
664     // Mapping owner address to address data
665     mapping(address => AddressData) private _addressData;
666 
667     // Mapping from token ID to approved address
668     mapping(uint256 => address) private _tokenApprovals;
669 
670     // Mapping from owner to operator approvals
671     mapping(address => mapping(address => bool)) private _operatorApprovals;
672 
673     constructor(string memory name_, string memory symbol_) {
674         _name = name_;
675         _symbol = symbol_;
676         _nextTokenId = 1;
677     }
678 
679     /**
680      * @dev See {IERC721Enumerable-totalSupply}.
681      */
682     function totalSupply() public view override returns (uint256) {
683         return _nextTokenId - 1;
684     }
685 
686     /**
687      * @dev See {IERC721Enumerable-tokenByIndex}.
688      */
689     function tokenByIndex(uint256 index) public view override returns (uint256) {
690         require(index < totalSupply(), 'ERC721A: global index out of bounds');
691         return index;
692     }
693 
694     /**
695      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
696      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
697      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
698      */
699     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
700         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
701         uint256 numMintedSoFar = totalSupply();
702         uint256 tokenIdsIdx = 0;
703         address currOwnershipAddr = address(0);
704         for (uint256 i = 0; i < numMintedSoFar; i++) {
705             TokenOwnership memory ownership = _ownerships[i];
706             if (ownership.addr != address(0)) {
707                 currOwnershipAddr = ownership.addr;
708             }
709             if (currOwnershipAddr == owner) {
710                 if (tokenIdsIdx == index) {
711                     return i;
712                 }
713                 tokenIdsIdx++;
714             }
715         }
716         revert('ERC721A: unable to get token of owner by index');
717     }
718 
719     /**
720      * @dev See {IERC165-supportsInterface}.
721      */
722     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
723         return
724             interfaceId == type(IERC721).interfaceId ||
725             interfaceId == type(IERC721Metadata).interfaceId ||
726             interfaceId == type(IERC721Enumerable).interfaceId ||
727             super.supportsInterface(interfaceId);
728     }
729 
730     /**
731      * @dev See {IERC721-balanceOf}.
732      */
733     function balanceOf(address owner) public view override returns (uint256) {
734         require(owner != address(0), 'ERC721A: balance query for the zero address');
735         return uint256(_addressData[owner].balance);
736     }
737 
738     function _numberMinted(address owner) internal view returns (uint256) {
739         require(owner != address(0), 'ERC721A: number minted query for the zero address');
740         return uint256(_addressData[owner].numberMinted);
741     }
742 
743     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
744         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
745 
746         for (uint256 curr = tokenId; ; curr--) {
747             TokenOwnership memory ownership = _ownerships[curr];
748             if (ownership.addr != address(0)) {
749                 return ownership;
750             }
751         }
752 
753         revert('ERC721A: unable to determine the owner of token');
754     }
755 
756     /**
757      * @dev See {IERC721-ownerOf}.
758      */
759     function ownerOf(uint256 tokenId) public view override returns (address) {
760         return ownershipOf(tokenId).addr;
761     }
762 
763     /**
764      * @dev See {IERC721Metadata-name}.
765      */
766     function name() public view virtual override returns (string memory) {
767         return _name;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-symbol}.
772      */
773     function symbol() public view virtual override returns (string memory) {
774         return _symbol;
775     }
776 
777     /**
778      * @dev See {IERC721Metadata-tokenURI}.
779      */
780     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
781         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
782 
783         string memory baseURI = _baseURI();
784         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
785     }
786 
787     /**
788      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
789      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
790      * by default, can be overriden in child contracts.
791      */
792     function _baseURI() internal view virtual returns (string memory) {
793         return '';
794     }
795 
796     /**
797      * @dev See {IERC721-approve}.
798      */
799     function approve(address to, uint256 tokenId) public override {
800         address owner = ERC721A.ownerOf(tokenId);
801         require(to != owner, 'ERC721A: approval to current owner');
802 
803         require(
804             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
805             'ERC721A: approve caller is not owner nor approved for all'
806         );
807 
808         _approve(to, tokenId, owner);
809     }
810 
811     /**
812      * @dev See {IERC721-getApproved}.
813      */
814     function getApproved(uint256 tokenId) public view override returns (address) {
815         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
816 
817         return _tokenApprovals[tokenId];
818     }
819 
820     /**
821      * @dev See {IERC721-setApprovalForAll}.
822      */
823     function setApprovalForAll(address operator, bool approved) public override {
824         require(operator != _msgSender(), 'ERC721A: approve to caller');
825 
826         _operatorApprovals[_msgSender()][operator] = approved;
827         emit ApprovalForAll(_msgSender(), operator, approved);
828     }
829 
830     /**
831      * @dev See {IERC721-isApprovedForAll}.
832      */
833     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
834         return _operatorApprovals[owner][operator];
835     }
836 
837     /**
838      * @dev See {IERC721-transferFrom}.
839      */
840     function transferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public override {
845         _transfer(from, to, tokenId);
846     }
847 
848     /**
849      * @dev See {IERC721-safeTransferFrom}.
850      */
851     function safeTransferFrom(
852         address from,
853         address to,
854         uint256 tokenId
855     ) public override {
856         safeTransferFrom(from, to, tokenId, '');
857     }
858 
859     /**
860      * @dev See {IERC721-safeTransferFrom}.
861      */
862     function safeTransferFrom(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) public override {
868         _transfer(from, to, tokenId);
869         require(
870             _checkOnERC721Received(from, to, tokenId, _data),
871             'ERC721A: transfer to non ERC721Receiver implementer'
872         );
873     }
874 
875     /**
876      * @dev Returns whether `tokenId` exists.
877      *
878      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
879      *
880      * Tokens start existing when they are minted (`_mint`),
881      */
882     function _exists(uint256 tokenId) internal view returns (bool) {
883         return tokenId < _nextTokenId;
884     }
885 
886     function _safeMint(address to, uint256 quantity) internal {
887         _safeMint(to, quantity, '');
888     }
889 
890     /**
891      * @dev Mints `quantity` tokens and transfers them to `to`.
892      *
893      * Requirements:
894      *
895      * - `to` cannot be the zero address.
896      * - `quantity` cannot be larger than the max batch size.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _safeMint(
901         address to,
902         uint256 quantity,
903         bytes memory _data
904     ) internal {
905         uint256 startTokenId = _nextTokenId;
906         require(to != address(0), 'ERC721A: mint to the zero address');
907         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
908         require(!_exists(startTokenId), 'ERC721A: token already minted');
909         require(quantity > 0, 'ERC721A: quantity must be greater 0');
910 
911         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
912 
913         AddressData memory addressData = _addressData[to];
914         _addressData[to] = AddressData(
915             addressData.balance + uint128(quantity),
916             addressData.numberMinted + uint128(quantity)
917         );
918         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
919 
920         uint256 updatedIndex = startTokenId;
921 
922         for (uint256 i = 0; i < quantity; i++) {
923             emit Transfer(address(0), to, updatedIndex);
924             require(
925                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
926                 'ERC721A: transfer to non ERC721Receiver implementer'
927             );
928             updatedIndex++;
929         }
930 
931         _nextTokenId = updatedIndex;
932         _afterTokenTransfers(address(0), to, startTokenId, quantity);
933     }
934 
935     /**
936      * @dev Transfers `tokenId` from `from` to `to`.
937      *
938      * Requirements:
939      *
940      * - `to` cannot be the zero address.
941      * - `tokenId` token must be owned by `from`.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _transfer(
946         address from,
947         address to,
948         uint256 tokenId
949     ) private {
950         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
951 
952         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
953             getApproved(tokenId) == _msgSender() ||
954             isApprovedForAll(prevOwnership.addr, _msgSender()));
955 
956         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
957 
958         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
959         require(to != address(0), 'ERC721A: transfer to the zero address');
960 
961         _beforeTokenTransfers(from, to, tokenId, 1);
962 
963         // Clear approvals from the previous owner
964         _approve(address(0), tokenId, prevOwnership.addr);
965 
966         // Underflow of the sender's balance is impossible because we check for
967         // ownership above and the recipient's balance can't realistically overflow.
968         unchecked {
969             _addressData[from].balance -= 1;
970             _addressData[to].balance += 1;
971         }
972 
973         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
974 
975         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
976         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
977         uint256 nextTokenId = tokenId + 1;
978         if (_ownerships[nextTokenId].addr == address(0)) {
979             if (_exists(nextTokenId)) {
980                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
981             }
982         }
983 
984         emit Transfer(from, to, tokenId);
985         _afterTokenTransfers(from, to, tokenId, 1);
986     }
987 
988     /**
989      * @dev Approve `to` to operate on `tokenId`
990      *
991      * Emits a {Approval} event.
992      */
993     function _approve(
994         address to,
995         uint256 tokenId,
996         address owner
997     ) private {
998         _tokenApprovals[tokenId] = to;
999         emit Approval(owner, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1004      * The call is not executed if the target address is not a contract.
1005      *
1006      * @param from address representing the previous owner of the given token ID
1007      * @param to target address that will receive the tokens
1008      * @param tokenId uint256 ID of the token to be transferred
1009      * @param _data bytes optional data to send along with the call
1010      * @return bool whether the call correctly returned the expected magic value
1011      */
1012     function _checkOnERC721Received(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) private returns (bool) {
1018         if (to.isContract()) {
1019             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1020                 return retval == IERC721Receiver(to).onERC721Received.selector;
1021             } catch (bytes memory reason) {
1022                 if (reason.length == 0) {
1023                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1024                 } else {
1025                     assembly {
1026                         revert(add(32, reason), mload(reason))
1027                     }
1028                 }
1029             }
1030         } else {
1031             return true;
1032         }
1033     }
1034 
1035     /**
1036      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1037      *
1038      * startTokenId - the first token id to be transferred
1039      * quantity - the amount to be transferred
1040      *
1041      * Calling conditions:
1042      *
1043      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1044      * transferred to `to`.
1045      * - When `from` is zero, `tokenId` will be minted for `to`.
1046      */
1047     function _beforeTokenTransfers(
1048         address from,
1049         address to,
1050         uint256 startTokenId,
1051         uint256 quantity
1052     ) internal virtual {}
1053 
1054     /**
1055      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1056      * minting.
1057      *
1058      * startTokenId - the first token id to be transferred
1059      * quantity - the amount to be transferred
1060      *
1061      * Calling conditions:
1062      *
1063      * - when `from` and `to` are both non-zero.
1064      * - `from` and `to` are never both zero.
1065      */
1066     function _afterTokenTransfers(
1067         address from,
1068         address to,
1069         uint256 startTokenId,
1070         uint256 quantity
1071     ) internal virtual {}
1072 }
1073 
1074 // File: @openzeppelin/contracts/access/Ownable.sol
1075 
1076 
1077 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1078 
1079 pragma solidity ^0.8.0;
1080 
1081 
1082 /**
1083  * @dev Contract module which provides a basic access control mechanism, where
1084  * there is an account (an owner) that can be granted exclusive access to
1085  * specific functions.
1086  *
1087  * By default, the owner account will be the one that deploys the contract. This
1088  * can later be changed with {transferOwnership}.
1089  *
1090  * This module is used through inheritance. It will make available the modifier
1091  * `onlyOwner`, which can be applied to your functions to restrict their use to
1092  * the owner.
1093  */
1094 abstract contract Ownable is Context {
1095     address private _owner;
1096 
1097     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1098 
1099     /**
1100      * @dev Initializes the contract setting the deployer as the initial owner.
1101      */
1102     constructor() {
1103         _transferOwnership(_msgSender());
1104     }
1105 
1106     /**
1107      * @dev Returns the address of the current owner.
1108      */
1109     function owner() public view virtual returns (address) {
1110         return _owner;
1111     }
1112 
1113     /**
1114      * @dev Throws if called by any account other than the owner.
1115      */
1116     modifier onlyOwner() {
1117         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1118         _;
1119     }
1120 
1121     /**
1122      * @dev Leaves the contract without owner. It will not be possible to call
1123      * `onlyOwner` functions anymore. Can only be called by the current owner.
1124      *
1125      * NOTE: Renouncing ownership will leave the contract without an owner,
1126      * thereby removing any functionality that is only available to the owner.
1127      */
1128     function renounceOwnership() public virtual onlyOwner {
1129         _transferOwnership(address(0));
1130     }
1131 
1132     /**
1133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1134      * Can only be called by the current owner.
1135      */
1136     function transferOwnership(address newOwner) public virtual onlyOwner {
1137         require(newOwner != address(0), "Ownable: new owner is the zero address");
1138         _transferOwnership(newOwner);
1139     }
1140 
1141     /**
1142      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1143      * Internal function without access restriction.
1144      */
1145     function _transferOwnership(address newOwner) internal virtual {
1146         address oldOwner = _owner;
1147         _owner = newOwner;
1148         emit OwnershipTransferred(oldOwner, newOwner);
1149     }
1150 }
1151 
1152 pragma solidity ^0.8.0;
1153 
1154 /**
1155  * @dev These functions deal with verification of Merkle Trees proofs.
1156  *
1157  * The proofs can be generated using the JavaScript library
1158  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1159  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1160  *
1161  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1162  *
1163  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1164  * hashing, or use a hash function other than keccak256 for hashing leaves.
1165  * This is because the concatenation of a sorted pair of internal nodes in
1166  * the merkle tree could be reinterpreted as a leaf value.
1167  */
1168 library MerkleProof {
1169     /**
1170      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1171      * defined by `root`. For this, a `proof` must be provided, containing
1172      * sibling hashes on the branch from the leaf to the root of the tree. Each
1173      * pair of leaves and each pair of pre-images are assumed to be sorted.
1174      */
1175     function verify(
1176         bytes32[] memory proof,
1177         bytes32 root,
1178         bytes32 leaf
1179     ) internal pure returns (bool) {
1180         return processProof(proof, leaf) == root;
1181     }
1182 
1183     /**
1184      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1185      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1186      * hash matches the root of the tree. When processing the proof, the pairs
1187      * of leafs & pre-images are assumed to be sorted.
1188      *
1189      * _Available since v4.4._
1190      */
1191     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1192         bytes32 computedHash = leaf;
1193         for (uint256 i = 0; i < proof.length; i++) {
1194             bytes32 proofElement = proof[i];
1195             if (computedHash <= proofElement) {
1196                 // Hash(current computed hash + current element of the proof)
1197                 computedHash = _efficientHash(computedHash, proofElement);
1198             } else {
1199                 // Hash(current element of the proof + current computed hash)
1200                 computedHash = _efficientHash(proofElement, computedHash);
1201             }
1202         }
1203         return computedHash;
1204     }
1205 
1206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1207         assembly {
1208             mstore(0x00, a)
1209             mstore(0x20, b)
1210             value := keccak256(0x00, 0x40)
1211         }
1212     }
1213 }
1214 
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 contract TheKekiland is ERC721A, Ownable {
1219   using Strings for uint256;
1220   uint256 public presalePrice = 0 ether;
1221   uint256 public mintPrice = 0.01 ether;
1222   uint256 public supply = 1111;
1223   string private baseURI = "ipfs://TZDDDsmUdsdDSDSFdssdWRddssaDSdssXC/";
1224   bytes32 public wlMerkleRoot;
1225   uint8 public phase = 1;
1226   uint8 public maxBuy = 4;
1227   uint8 public wlMax = 1;
1228 
1229   mapping(address => uint8)  public walletBuys;
1230 
1231   constructor() ERC721A("The Kekiland", "The Kekiland") {
1232   }
1233 
1234   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1235     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1236 
1237     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1238   }
1239 
1240   function mintForAddress(address[] calldata _addresses, uint256 quantity) public onlyOwner {
1241     for (uint i=0; i<_addresses.length; i++) {
1242       _safeMint(_addresses[i], quantity);
1243     }
1244   }
1245 
1246   function mint(uint256 quantity) external payable {
1247     require(phase >= 2, "Sale has not started");
1248     require(totalSupply() + quantity <= supply, "You can't mint more then the total supply");
1249     require(walletBuys[msg.sender] + quantity <= maxBuy, "Buy limit reached");
1250     require(msg.value >= mintPrice * quantity, "Insufficient funds");
1251 
1252     _safeMint(msg.sender, quantity);
1253   }
1254 
1255   function wlMint(uint8 _mintAmount, bytes32[] calldata _merkleProof) public payable {
1256     // Verify whitelist requirements
1257     require(phase == 1, "Sale has not started");
1258     require(walletBuys[msg.sender] + _mintAmount <= wlMax, "Max presale minted for this wallet!");
1259     require(msg.value >= presalePrice * _mintAmount, "Insufficient funds");
1260     
1261     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1262     require(MerkleProof.verify(_merkleProof, wlMerkleRoot, leaf), "Invalid proof!");
1263 
1264     walletBuys[msg.sender] += _mintAmount;
1265     _safeMint(msg.sender, _mintAmount);
1266   }
1267 
1268   function getBaseURI() public view returns (string memory) {
1269     return baseURI;
1270   }
1271 
1272   function _baseURI() internal view override returns (string memory) {
1273     return baseURI;
1274   }
1275 
1276   function setBaseURI(string memory baseURI_) external onlyOwner {
1277     baseURI = baseURI_;
1278   }
1279 
1280   function setMintPrice (uint256 _newPrice) external onlyOwner {
1281     mintPrice = _newPrice;
1282   }
1283 
1284   function setPresalePrice (uint256 _newPrice) external onlyOwner {
1285     presalePrice = _newPrice;
1286   }
1287 
1288   function changePhase(uint8 _phase) public onlyOwner {
1289     phase = _phase;
1290   }
1291 
1292   function setMaxBuy(uint8 _maxBuy) external onlyOwner {
1293       maxBuy = _maxBuy;
1294   }
1295 
1296   function wlReserve(uint256 _supply) external onlyOwner {
1297       supply = _supply;
1298   }
1299 
1300   function changeWLRootHash(bytes32 _rootHash) external onlyOwner {
1301     wlMerkleRoot = _rootHash;
1302   }
1303 
1304   function getContractBalance () external view onlyOwner returns (uint256) {
1305     return address(this).balance;
1306   }
1307 
1308   function withdrawAll() external onlyOwner{
1309         uint256 balance = address(this).balance;
1310         require(balance > 0, "Insufficent balance");
1311         
1312         address[1] memory addresses = [
1313             0x0ba37a7856daE10294a3D88F0C7Ad9b2c9A59DC8
1314  
1315         ];
1316 
1317         uint32[5] memory shares = [
1318             uint32(50),
1319             uint32(40),
1320             uint32(330),
1321             uint32(330),
1322             uint32(250)
1323         ];
1324 
1325         for (uint32 i = 0; i < addresses.length; i++) {
1326             uint256 amount = i == addresses.length - 1 ? address(this).balance : balance * shares[i] / 1000;
1327             _widthdraw(addresses[i], amount);
1328         }
1329   }
1330  
1331   //Withdraw balance from contract
1332   function _widthdraw(address _address, uint256 _amount) private {
1333         (bool success, ) = _address.call{ value: _amount }("");
1334         require(success, "Failed to withdraw Ether");
1335   }
1336 
1337 }