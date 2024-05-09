1 // File: @openzeppelin/contracts/utils/Strings.sol
2 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
3 // SPDX-License-Identifier: Unlicense
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/Address.sol
98 
99 
100 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
101 
102 pragma solidity ^0.8.1;
103 
104 /**
105  * @dev Collection of functions related to the address type
106  */
107 library Address {
108     /**
109      * @dev Returns true if `account` is a contract.
110      *
111      * [IMPORTANT]
112      * ====
113      * It is unsafe to assume that an address for which this function returns
114      * false is an externally-owned account (EOA) and not a contract.
115      *
116      * Among others, `isContract` will return false for the following
117      * types of addresses:
118      *
119      *  - an externally-owned account
120      *  - a contract in construction
121      *  - an address where a contract will be created
122      *  - an address where a contract lived, but was destroyed
123      * ====
124      *
125      * [IMPORTANT]
126      * ====
127      * You shouldn't rely on `isContract` to protect against flash loan attacks!
128      *
129      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
130      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
131      * constructor.
132      * ====
133      */
134     function isContract(address account) internal view returns (bool) {
135         // This method relies on extcodesize/address.code.length, which returns 0
136         // for contracts in construction, since the code is only stored at the end
137         // of the constructor execution.
138 
139         return account.code.length > 0;
140     }
141 
142     /**
143      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
144      * `recipient`, forwarding all available gas and reverting on errors.
145      *
146      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
147      * of certain opcodes, possibly making contracts go over the 2300 gas limit
148      * imposed by `transfer`, making them unable to receive funds via
149      * `transfer`. {sendValue} removes this limitation.
150      *
151      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
152      *
153      * IMPORTANT: because control is transferred to `recipient`, care must be
154      * taken to not create reentrancy vulnerabilities. Consider using
155      * {ReentrancyGuard} or the
156      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
157      */
158     function sendValue(address payable recipient, uint256 amount) internal {
159         require(address(this).balance >= amount, "Address: insufficient balance");
160 
161         (bool success, ) = recipient.call{value: amount}("");
162         require(success, "Address: unable to send value, recipient may have reverted");
163     }
164 
165     /**
166      * @dev Performs a Solidity function call using a low level `call`. A
167      * plain `call` is an unsafe replacement for a function call: use this
168      * function instead.
169      *
170      * If `target` reverts with a revert reason, it is bubbled up by this
171      * function (like regular Solidity function calls).
172      *
173      * Returns the raw returned data. To convert to the expected return value,
174      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
175      *
176      * Requirements:
177      *
178      * - `target` must be a contract.
179      * - calling `target` with `data` must not revert.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
184         return functionCall(target, data, "Address: low-level call failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
189      * `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, 0, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but also transferring `value` wei to `target`.
204      *
205      * Requirements:
206      *
207      * - the calling contract must have an ETH balance of at least `value`.
208      * - the called Solidity function must be `payable`.
209      *
210      * _Available since v3.1._
211      */
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value
216     ) internal returns (bytes memory) {
217         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
222      * with `errorMessage` as a fallback revert reason when `target` reverts.
223      *
224      * _Available since v3.1._
225      */
226     function functionCallWithValue(
227         address target,
228         bytes memory data,
229         uint256 value,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         require(address(this).balance >= value, "Address: insufficient balance for call");
233         require(isContract(target), "Address: call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.call{value: value}(data);
236         return verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
246         return functionStaticCall(target, data, "Address: low-level static call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a static call.
252      *
253      * _Available since v3.3._
254      */
255     function functionStaticCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal view returns (bytes memory) {
260         require(isContract(target), "Address: static call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.staticcall(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
278      * but performing a delegate call.
279      *
280      * _Available since v3.4._
281      */
282     function functionDelegateCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         require(isContract(target), "Address: delegate call to non-contract");
288 
289         (bool success, bytes memory returndata) = target.delegatecall(data);
290         return verifyCallResult(success, returndata, errorMessage);
291     }
292 
293     /**
294      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
295      * revert reason using the provided one.
296      *
297      * _Available since v4.3._
298      */
299     function verifyCallResult(
300         bool success,
301         bytes memory returndata,
302         string memory errorMessage
303     ) internal pure returns (bytes memory) {
304         if (success) {
305             return returndata;
306         } else {
307             // Look for revert reason and bubble it up if present
308             if (returndata.length > 0) {
309                 // The easiest way to bubble the revert reason is using memory via assembly
310 
311                 assembly {
312                     let returndata_size := mload(returndata)
313                     revert(add(32, returndata), returndata_size)
314                 }
315             } else {
316                 revert(errorMessage);
317             }
318         }
319     }
320 }
321 
322 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
323 
324 
325 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @title ERC721 token receiver interface
331  * @dev Interface for any contract that wants to support safeTransfers
332  * from ERC721 asset contracts.
333  */
334 interface IERC721Receiver {
335     /**
336      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
337      * by `operator` from `from`, this function is called.
338      *
339      * It must return its Solidity selector to confirm the token transfer.
340      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
341      *
342      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
343      */
344     function onERC721Received(
345         address operator,
346         address from,
347         uint256 tokenId,
348         bytes calldata data
349     ) external returns (bytes4);
350 }
351 
352 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @dev Interface of the ERC165 standard, as defined in the
361  * https://eips.ethereum.org/EIPS/eip-165[EIP].
362  *
363  * Implementers can declare support of contract interfaces, which can then be
364  * queried by others ({ERC165Checker}).
365  *
366  * For an implementation, see {ERC165}.
367  */
368 interface IERC165 {
369     /**
370      * @dev Returns true if this contract implements the interface defined by
371      * `interfaceId`. See the corresponding
372      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
373      * to learn more about how these ids are created.
374      *
375      * This function call must use less than 30 000 gas.
376      */
377     function supportsInterface(bytes4 interfaceId) external view returns (bool);
378 }
379 
380 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Implementation of the {IERC165} interface.
390  *
391  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
392  * for the additional interface id that will be supported. For example:
393  *
394  * ```solidity
395  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
396  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
397  * }
398  * ```
399  *
400  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
401  */
402 abstract contract ERC165 is IERC165 {
403     /**
404      * @dev See {IERC165-supportsInterface}.
405      */
406     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
407         return interfaceId == type(IERC165).interfaceId;
408     }
409 }
410 
411 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 
419 /**
420  * @dev Required interface of an ERC721 compliant contract.
421  */
422 interface IERC721 is IERC165 {
423     /**
424      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
425      */
426     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
427 
428     /**
429      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
430      */
431     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
432 
433     /**
434      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
435      */
436     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
437 
438     /**
439      * @dev Returns the number of tokens in ``owner``'s account.
440      */
441     function balanceOf(address owner) external view returns (uint256 balance);
442 
443     /**
444      * @dev Returns the owner of the `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function ownerOf(uint256 tokenId) external view returns (address owner);
451 
452     /**
453      * @dev Safely transfers `tokenId` token from `from` to `to`.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must exist and be owned by `from`.
460      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
462      *
463      * Emits a {Transfer} event.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId,
469         bytes calldata data
470     ) external;
471 
472     /**
473      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
474      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must exist and be owned by `from`.
481      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
482      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
483      *
484      * Emits a {Transfer} event.
485      */
486     function safeTransferFrom(
487         address from,
488         address to,
489         uint256 tokenId
490     ) external;
491 
492     /**
493      * @dev Transfers `tokenId` token from `from` to `to`.
494      *
495      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must be owned by `from`.
502      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
503      *
504      * Emits a {Transfer} event.
505      */
506     function transferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) external;
511 
512     /**
513      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
514      * The approval is cleared when the token is transferred.
515      *
516      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
517      *
518      * Requirements:
519      *
520      * - The caller must own the token or be an approved operator.
521      * - `tokenId` must exist.
522      *
523      * Emits an {Approval} event.
524      */
525     function approve(address to, uint256 tokenId) external;
526 
527     /**
528      * @dev Approve or remove `operator` as an operator for the caller.
529      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
530      *
531      * Requirements:
532      *
533      * - The `operator` cannot be the caller.
534      *
535      * Emits an {ApprovalForAll} event.
536      */
537     function setApprovalForAll(address operator, bool _approved) external;
538 
539     /**
540      * @dev Returns the account approved for `tokenId` token.
541      *
542      * Requirements:
543      *
544      * - `tokenId` must exist.
545      */
546     function getApproved(uint256 tokenId) external view returns (address operator);
547 
548     /**
549      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
550      *
551      * See {setApprovalForAll}
552      */
553     function isApprovedForAll(address owner, address operator) external view returns (bool);
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
557 
558 
559 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
566  * @dev See https://eips.ethereum.org/EIPS/eip-721
567  */
568 interface IERC721Enumerable is IERC721 {
569     /**
570      * @dev Returns the total amount of tokens stored by the contract.
571      */
572     function totalSupply() external view returns (uint256);
573 
574     /**
575      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
576      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
577      */
578     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
579 
580     /**
581      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
582      * Use along with {totalSupply} to enumerate all tokens.
583      */
584     function tokenByIndex(uint256 index) external view returns (uint256);
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
597  * @dev See https://eips.ethereum.org/EIPS/eip-721
598  */
599 interface IERC721Metadata is IERC721 {
600     /**
601      * @dev Returns the token collection name.
602      */
603     function name() external view returns (string memory);
604 
605     /**
606      * @dev Returns the token collection symbol.
607      */
608     function symbol() external view returns (string memory);
609 
610     /**
611      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
612      */
613     function tokenURI(uint256 tokenId) external view returns (string memory);
614 }
615 
616 // File: ERC721A.sol
617 
618 
619 // Creator: Chiru Labs
620 
621 pragma solidity ^0.8.0;
622 
623 
624 
625 
626 
627 
628 
629 
630 
631 /**
632  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
633  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
634  *
635  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
636  *
637  * Does not support burning tokens to address(0).
638  *
639  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
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
655     uint256 internal currentIndex = 1;
656 
657     // Token name
658     string private _name;
659 
660     // Token symbol
661     string private _symbol;
662 
663     // Mapping from token ID to ownership details
664     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
665     mapping(uint256 => TokenOwnership) internal _ownerships;
666 
667     // Mapping owner address to address data
668     mapping(address => AddressData) private _addressData;
669 
670     // Mapping from token ID to approved address
671     mapping(uint256 => address) private _tokenApprovals;
672 
673     // Mapping from owner to operator approvals
674     mapping(address => mapping(address => bool)) private _operatorApprovals;
675 
676     constructor(string memory name_, string memory symbol_) {
677         _name = name_;
678         _symbol = symbol_;
679     }
680 
681     /**
682      * @dev See {IERC721Enumerable-totalSupply}.
683      */
684     function totalSupply() public view override returns (uint256) {
685         return currentIndex;
686     }
687 
688     /**
689      * @dev See {IERC721Enumerable-tokenByIndex}.
690      */
691     function tokenByIndex(uint256 index) public view override returns (uint256) {
692         require(index < totalSupply(), 'ERC721A: global index out of bounds');
693         return index;
694     }
695 
696     /**
697      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
698      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
699      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
700      */
701     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
702         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
703         uint256 numMintedSoFar = totalSupply();
704         uint256 tokenIdsIdx;
705         address currOwnershipAddr;
706 
707         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
708         unchecked {
709             for (uint256 i; i < numMintedSoFar; i++) {
710                 TokenOwnership memory ownership = _ownerships[i];
711                 if (ownership.addr != address(0)) {
712                     currOwnershipAddr = ownership.addr;
713                 }
714                 if (currOwnershipAddr == owner) {
715                     if (tokenIdsIdx == index) {
716                         return i;
717                     }
718                     tokenIdsIdx++;
719                 }
720             }
721         }
722 
723         revert('ERC721A: unable to get token of owner by index');
724     }
725 
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
730         return
731             interfaceId == type(IERC721).interfaceId ||
732             interfaceId == type(IERC721Metadata).interfaceId ||
733             interfaceId == type(IERC721Enumerable).interfaceId ||
734             super.supportsInterface(interfaceId);
735     }
736 
737     /**
738      * @dev See {IERC721-balanceOf}.
739      */
740     function balanceOf(address owner) public view override returns (uint256) {
741         require(owner != address(0), 'ERC721A: balance query for the zero address');
742         return uint256(_addressData[owner].balance);
743     }
744 
745     function _numberMinted(address owner) internal view returns (uint256) {
746         require(owner != address(0), 'ERC721A: number minted query for the zero address');
747         return uint256(_addressData[owner].numberMinted);
748     }
749 
750     /**
751      * Gas spent here starts off proportional to the maximum mint batch size.
752      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
753      */
754     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
755         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
756 
757         unchecked {
758             for (uint256 curr = tokenId; curr >= 0; curr--) {
759                 TokenOwnership memory ownership = _ownerships[curr];
760                 if (ownership.addr != address(0)) {
761                     return ownership;
762                 }
763             }
764         }
765 
766         revert('ERC721A: unable to determine the owner of token');
767     }
768 
769     /**
770      * @dev See {IERC721-ownerOf}.
771      */
772     function ownerOf(uint256 tokenId) public view override returns (address) {
773         return ownershipOf(tokenId).addr;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-name}.
778      */
779     function name() public view virtual override returns (string memory) {
780         return _name;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-symbol}.
785      */
786     function symbol() public view virtual override returns (string memory) {
787         return _symbol;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-tokenURI}.
792      */
793     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
794         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
795 
796         string memory baseURI = _baseURI();
797         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
798     }
799 
800     /**
801      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
802      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
803      * by default, can be overriden in child contracts.
804      */
805     function _baseURI() internal view virtual returns (string memory) {
806         return '';
807     }
808 
809     /**
810      * @dev See {IERC721-approve}.
811      */
812     function approve(address to, uint256 tokenId) public override {
813         address owner = ERC721A.ownerOf(tokenId);
814         require(to != owner, 'ERC721A: approval to current owner');
815 
816         require(
817             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
818             'ERC721A: approve caller is not owner nor approved for all'
819         );
820 
821         _approve(to, tokenId, owner);
822     }
823 
824     /**
825      * @dev See {IERC721-getApproved}.
826      */
827     function getApproved(uint256 tokenId) public view override returns (address) {
828         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
829 
830         return _tokenApprovals[tokenId];
831     }
832 
833     /**
834      * @dev See {IERC721-setApprovalForAll}.
835      */
836     function setApprovalForAll(address operator, bool approved) public override {
837         require(operator != _msgSender(), 'ERC721A: approve to caller');
838 
839         _operatorApprovals[_msgSender()][operator] = approved;
840         emit ApprovalForAll(_msgSender(), operator, approved);
841     }
842 
843     /**
844      * @dev See {IERC721-isApprovedForAll}.
845      */
846     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
847         return _operatorApprovals[owner][operator];
848     }
849 
850     /**
851      * @dev See {IERC721-transferFrom}.
852      */
853     function transferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public override {
858         _transfer(from, to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public override {
869         safeTransferFrom(from, to, tokenId, '');
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) public override {
881         _transfer(from, to, tokenId);
882         require(
883             _checkOnERC721Received(from, to, tokenId, _data),
884             'ERC721A: transfer to non ERC721Receiver implementer'
885         );
886     }
887 
888     /**
889      * @dev Returns whether `tokenId` exists.
890      *
891      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
892      *
893      * Tokens start existing when they are minted (`_mint`),
894      */
895     function _exists(uint256 tokenId) internal view returns (bool) {
896         return tokenId < currentIndex;
897     }
898 
899     function _safeMint(address to, uint256 quantity) internal {
900         _safeMint(to, quantity, '');
901     }
902 
903     /**
904      * @dev Safely mints `quantity` tokens and transfers them to `to`.
905      *
906      * Requirements:
907      *
908      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
909      * - `quantity` must be greater than 0.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _safeMint(
914         address to,
915         uint256 quantity,
916         bytes memory _data
917     ) internal {
918         _mint(to, quantity, _data, true);
919     }
920 
921     /**
922      * @dev Mints `quantity` tokens and transfers them to `to`.
923      *
924      * Requirements:
925      *
926      * - `to` cannot be the zero address.
927      * - `quantity` must be greater than 0.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _mint(
932         address to,
933         uint256 quantity,
934         bytes memory _data,
935         bool safe
936     ) internal {
937         uint256 startTokenId = currentIndex;
938         require(to != address(0), 'ERC721A: mint to the zero address');
939         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
940 
941         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
942 
943         // Overflows are incredibly unrealistic.
944         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
945         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
946         unchecked {
947             _addressData[to].balance += uint128(quantity);
948             _addressData[to].numberMinted += uint128(quantity);
949 
950             _ownerships[startTokenId].addr = to;
951             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
952 
953             uint256 updatedIndex = startTokenId;
954 
955             for (uint256 i; i < quantity; i++) {
956                 emit Transfer(address(0), to, updatedIndex);
957                 if (safe) {
958                     require(
959                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
960                         'ERC721A: transfer to non ERC721Receiver implementer'
961                     );
962                 }
963 
964                 updatedIndex++;
965             }
966 
967             currentIndex = updatedIndex;
968         }
969 
970         _afterTokenTransfers(address(0), to, startTokenId, quantity);
971     }
972 
973     /**
974      * @dev Transfers `tokenId` from `from` to `to`.
975      *
976      * Requirements:
977      *
978      * - `to` cannot be the zero address.
979      * - `tokenId` token must be owned by `from`.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _transfer(
984         address from,
985         address to,
986         uint256 tokenId
987     ) private {
988         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
989 
990         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
991             getApproved(tokenId) == _msgSender() ||
992             isApprovedForAll(prevOwnership.addr, _msgSender()));
993 
994         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
995 
996         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
997         require(to != address(0), 'ERC721A: transfer to the zero address');
998 
999         _beforeTokenTransfers(from, to, tokenId, 1);
1000 
1001         // Clear approvals from the previous owner
1002         _approve(address(0), tokenId, prevOwnership.addr);
1003 
1004         // Underflow of the sender's balance is impossible because we check for
1005         // ownership above and the recipient's balance can't realistically overflow.
1006         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1007         unchecked {
1008             _addressData[from].balance -= 1;
1009             _addressData[to].balance += 1;
1010 
1011             _ownerships[tokenId].addr = to;
1012             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1013 
1014             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1015             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1016             uint256 nextTokenId = tokenId + 1;
1017             if (_ownerships[nextTokenId].addr == address(0)) {
1018                 if (_exists(nextTokenId)) {
1019                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1020                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1021                 }
1022             }
1023         }
1024 
1025         emit Transfer(from, to, tokenId);
1026         _afterTokenTransfers(from, to, tokenId, 1);
1027     }
1028 
1029     /**
1030      * @dev Approve `to` to operate on `tokenId`
1031      *
1032      * Emits a {Approval} event.
1033      */
1034     function _approve(
1035         address to,
1036         uint256 tokenId,
1037         address owner
1038     ) private {
1039         _tokenApprovals[tokenId] = to;
1040         emit Approval(owner, to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1045      * The call is not executed if the target address is not a contract.
1046      *
1047      * @param from address representing the previous owner of the given token ID
1048      * @param to target address that will receive the tokens
1049      * @param tokenId uint256 ID of the token to be transferred
1050      * @param _data bytes optional data to send along with the call
1051      * @return bool whether the call correctly returned the expected magic value
1052      */
1053     function _checkOnERC721Received(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory _data
1058     ) private returns (bool) {
1059         if (to.isContract()) {
1060             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1061                 return retval == IERC721Receiver(to).onERC721Received.selector;
1062             } catch (bytes memory reason) {
1063                 if (reason.length == 0) {
1064                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1065                 } else {
1066                     assembly {
1067                         revert(add(32, reason), mload(reason))
1068                     }
1069                 }
1070             }
1071         } else {
1072             return true;
1073         }
1074     }
1075 
1076     /**
1077      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1078      *
1079      * startTokenId - the first token id to be transferred
1080      * quantity - the amount to be transferred
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      */
1088     function _beforeTokenTransfers(
1089         address from,
1090         address to,
1091         uint256 startTokenId,
1092         uint256 quantity
1093     ) internal virtual {}
1094 
1095     /**
1096      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1097      * minting.
1098      *
1099      * startTokenId - the first token id to be transferred
1100      * quantity - the amount to be transferred
1101      *
1102      * Calling conditions:
1103      *
1104      * - when `from` and `to` are both non-zero.
1105      * - `from` and `to` are never both zero.
1106      */
1107     function _afterTokenTransfers(
1108         address from,
1109         address to,
1110         uint256 startTokenId,
1111         uint256 quantity
1112     ) internal virtual {}
1113 }
1114 // File: goblintownai-contract.sol
1115 
1116 
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 /**
1121  * @dev Contract module which allows children to implement an emergency stop
1122  * mechanism that can be triggered by an authorized account.
1123  *
1124  * This module is used through inheritance. It will make available the
1125  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1126  * the functions of your contract. Note that they will not be pausable by
1127  * simply including this module, only once the modifiers are put in place.
1128  */
1129 abstract contract Pausable is Context {
1130     /**
1131      * @dev Emitted when the pause is triggered by `account`.
1132      */
1133     event Paused(address account);
1134 
1135     /**
1136      * @dev Emitted when the pause is lifted by `account`.
1137      */
1138     event Unpaused(address account);
1139 
1140     bool private _paused;
1141 
1142     /**
1143      * @dev Initializes the contract in unpaused state.
1144      */
1145     constructor() {
1146         _paused = false;
1147     }
1148 
1149     /**
1150      * @dev Returns true if the contract is paused, and false otherwise.
1151      */
1152     function paused() public view virtual returns (bool) {
1153         return _paused;
1154     }
1155 
1156     /**
1157      * @dev Modifier to make a function callable only when the contract is not paused.
1158      *
1159      * Requirements:
1160      *
1161      * - The contract must not be paused.
1162      */
1163     modifier whenNotPaused() {
1164         require(!paused(), "Pausable: paused");
1165         _;
1166     }
1167 
1168     /**
1169      * @dev Modifier to make a function callable only when the contract is paused.
1170      *
1171      * Requirements:
1172      *
1173      * - The contract must be paused.
1174      */
1175     modifier whenPaused() {
1176         require(paused(), "Pausable: not paused");
1177         _;
1178     }
1179 
1180     /**
1181      * @dev Triggers stopped state.
1182      *
1183      * Requirements:
1184      *
1185      * - The contract must not be paused.
1186      */
1187     function _pause() internal virtual whenNotPaused {
1188         _paused = true;
1189         emit Paused(_msgSender());
1190     }
1191 
1192     /**
1193      * @dev Returns to normal state.
1194      *
1195      * Requirements:
1196      *
1197      * - The contract must be paused.
1198      */
1199     function _unpause() internal virtual whenPaused {
1200         _paused = false;
1201         emit Unpaused(_msgSender());
1202     }
1203 }
1204 
1205 // Ownable.sol
1206 
1207 pragma solidity ^0.8.0;
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
1224     event OwnershipTransferred(
1225         address indexed previousOwner,
1226         address indexed newOwner
1227     );
1228 
1229     /**
1230      * @dev Initializes the contract setting the deployer as the initial owner.
1231      */
1232     constructor() {
1233         _setOwner(_msgSender());
1234     }
1235 
1236     /**
1237      * @dev Returns the address of the current owner.
1238      */
1239     function owner() public view virtual returns (address) {
1240         return _owner;
1241     }
1242 
1243     /**
1244      * @dev Throws if called by any account other than the owner.
1245      */
1246     modifier onlyOwner() {
1247         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1248         _;
1249     }
1250 
1251     /**
1252      * @dev Leaves the contract without owner. It will not be possible to call
1253      * `onlyOwner` functions anymore. Can only be called by the current owner.
1254      *
1255      * NOTE: Renouncing ownership will leave the contract without an owner,
1256      * thereby removing any functionality that is only available to the owner.
1257      */
1258     function renounceOwnership() public virtual onlyOwner {
1259         _setOwner(address(0));
1260     }
1261 
1262     /**
1263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1264      * Can only be called by the current owner.
1265      */
1266     function transferOwnership(address newOwner) public virtual onlyOwner {
1267         require(
1268             newOwner != address(0),
1269             "Ownable: new owner is the zero address"
1270         );
1271         _setOwner(newOwner);
1272     }
1273 
1274     function _setOwner(address newOwner) private {
1275         address oldOwner = _owner;
1276         _owner = newOwner;
1277         emit OwnershipTransferred(oldOwner, newOwner);
1278     }
1279 }
1280 
1281 pragma solidity ^0.8.0;
1282 
1283 /**
1284  * @dev Contract module that helps prevent reentrant calls to a function.
1285  *
1286  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1287  * available, which can be applied to functions to make sure there are no nested
1288  * (reentrant) calls to them.
1289  *
1290  * Note that because there is a single `nonReentrant` guard, functions marked as
1291  * `nonReentrant` may not call one another. This can be worked around by making
1292  * those functions `private`, and then adding `external` `nonReentrant` entry
1293  * points to them.
1294  *
1295  * TIP: If you would like to learn more about reentrancy and alternative ways
1296  * to protect against it, check out our blog post
1297  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1298  */
1299 abstract contract ReentrancyGuard {
1300     // Booleans are more expensive than uint256 or any type that takes up a full
1301     // word because each write operation emits an extra SLOAD to first read the
1302     // slot's contents, replace the bits taken up by the boolean, and then write
1303     // back. This is the compiler's defense against contract upgrades and
1304     // pointer aliasing, and it cannot be disabled.
1305 
1306     // The values being non-zero value makes deployment a bit more expensive,
1307     // but in exchange the refund on every call to nonReentrant will be lower in
1308     // amount. Since refunds are capped to a percentage of the total
1309     // transaction's gas, it is best to keep them low in cases like this one, to
1310     // increase the likelihood of the full refund coming into effect.
1311     uint256 private constant _NOT_ENTERED = 1;
1312     uint256 private constant _ENTERED = 2;
1313 
1314     uint256 private _status;
1315 
1316     constructor() {
1317         _status = _NOT_ENTERED;
1318     }
1319 
1320     /**
1321      * @dev Prevents a contract from calling itself, directly or indirectly.
1322      * Calling a `nonReentrant` function from another `nonReentrant`
1323      * function is not supported. It is possible to prevent this from happening
1324      * by making the `nonReentrant` function external, and make it call a
1325      * `private` function that does the actual work.
1326      */
1327     modifier nonReentrant() {
1328         // On the first call to nonReentrant, _notEntered will be true
1329         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1330 
1331         // Any calls to nonReentrant after this point will fail
1332         _status = _ENTERED;
1333 
1334         _;
1335 
1336         // By storing the original value once again, a refund is triggered (see
1337         // https://eips.ethereum.org/EIPS/eip-2200)
1338         _status = _NOT_ENTERED;
1339     }
1340 }
1341 
1342 //newerc.sol
1343 pragma solidity ^0.8.0;
1344 
1345 
1346 contract FrogRunners is ERC721A, Ownable, Pausable, ReentrancyGuard {
1347   using Strings for uint256;
1348   string public baseURI;
1349   uint256 public cost = 0.002 ether;
1350   uint256 public maxSupply = 9999;
1351   uint256 public maxFree = 1999;
1352   uint256 public maxperAddressFreeLimit = 2;
1353   uint256 public maxperAddressPublicMint = 8;
1354 
1355   mapping(address => uint256) public addressFreeMintedBalance;
1356 
1357   constructor() ERC721A("FrogRunners", "RIBBIT") {
1358     setBaseURI("");
1359   }
1360 
1361   function _baseURI() internal view virtual override returns (string memory) {
1362     return baseURI;
1363   }
1364 
1365   function mintFree(uint256 _mintAmount) public payable nonReentrant{
1366 		uint256 s = totalSupply();
1367     uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1368     require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "Max Frogs per address exceeded");
1369 		require(_mintAmount > 0, "Cannot mint 0 Frogs" );
1370 		require(s + _mintAmount <= maxFree, "Cannot exceed Frogs supply" );
1371 		for (uint256 i = 0; i < _mintAmount; ++i) {
1372       addressFreeMintedBalance[msg.sender]++;
1373 		}
1374     _safeMint(msg.sender, _mintAmount);
1375 		delete s;
1376     delete addressFreeMintedCount;
1377 	}
1378 
1379   function mint(uint256 _mintAmount) public payable nonReentrant {
1380     uint256 s = totalSupply();
1381     require(_mintAmount > 0, "Cant mint 0 Frogs");
1382     require(_mintAmount <= maxperAddressPublicMint, "Cant mint more Frogs" );
1383     require(s + _mintAmount <= maxSupply, "Cant exceed Frogs supply");
1384     require(msg.value >= cost * _mintAmount);
1385     _safeMint(msg.sender, _mintAmount);
1386     delete s;
1387   }
1388 
1389   function gift(uint256[] calldata quantity, address[] calldata recipient)
1390     external
1391     onlyOwner
1392   {
1393     require(
1394       quantity.length == recipient.length,
1395       "Provide quantities and recipients"
1396     );
1397     uint256 totalQuantity = 0;
1398     uint256 s = totalSupply();
1399     for (uint256 i = 0; i < quantity.length; ++i) {
1400       totalQuantity += quantity[i];
1401     }
1402     require(s + totalQuantity <= maxSupply, "Too many Frogs");
1403     delete totalQuantity;
1404     for (uint256 i = 0; i < recipient.length; ++i) {
1405       _safeMint(recipient[i], quantity[i]);
1406     }
1407     delete s;
1408   }
1409 
1410   function tokenURI(uint256 tokenId)
1411     public
1412     view
1413     virtual
1414     override
1415     returns (string memory)
1416   {
1417     require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1418     string memory currentBaseURI = _baseURI();
1419     return
1420       bytes(currentBaseURI).length > 0
1421         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1422         : "";
1423   }
1424   
1425   function setCost(uint256 _newCost) public onlyOwner {
1426     cost = _newCost;
1427   }
1428 
1429   function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1430     require(_newMaxSupply <= maxSupply, "Cannot increase max supply");
1431     maxSupply = _newMaxSupply;
1432   }
1433 
1434   function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1435     maxFree = _newMaxFreeSupply;
1436   }
1437 
1438   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1439     baseURI = _newBaseURI;
1440   }
1441 
1442   function setMaxperAddressPublicMint(uint256 _amount) public onlyOwner {
1443     maxperAddressPublicMint = _amount;
1444   }
1445 
1446   function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1447     maxperAddressFreeLimit = _amount;
1448   }
1449   function withdraw() public payable onlyOwner {
1450     (bool success, ) = payable(msg.sender).call{
1451       value: address(this).balance
1452     }("");
1453     require(success);
1454   }
1455 
1456   function withdrawAny(uint256 _amount) public payable onlyOwner {
1457     (bool success, ) = payable(msg.sender).call{value: _amount}("");
1458     require(success);
1459   }
1460 }