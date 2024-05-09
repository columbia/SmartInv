1 // SPDX-License-Identifier: Unlicense
2 
3 /*
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@&# @& @ &#    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@# @& & &# &&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@@@@@@@@@@&&&&@@@@@@@@@&      &@@       &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@@@@@@@@@@@@&  &@@@&  @@@&  &@@&   @@@&   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@@&       @@&   &@@&  @@@&  &@@&   @@@&   &#  @@@&  &@&&&&&&&&&&@@@@@@@@
11 @@@@@@@@@&  &@@@#  &&     @&  @@@&  &@@&   @@@&   &#   &@&  &&#######   @@@@@@@@
12 @@@@@@@@@&  &@@@#  &&   #  &  @@@&  &@@&   @@@&   &#    &&  &@@@@@&   &@@@@@@@@@
13 @@@@@@@@@&  &@@@#  &&   &&    @&      &@&#      @@&#  &     &@@@@#   @@@@@@@@@@@
14 @@@@@@@@@&  &@@@   &&   @@&   @@@@@@@@@@@@@@@@@@@@&#  @&    &@@&   &@@@@@@@@@@@@
15 @@@@@@@@@@&#     &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#  @@&&  &&          @@@@@@@@
16 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&@@@@@@@@
17 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
18 */
19 
20 
21 // File: @openzeppelin/contracts/utils/Strings.sol
22 
23 
24 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 }
89 
90 // File: @openzeppelin/contracts/utils/Context.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Address.sol
118 
119 
120 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
121 
122 pragma solidity ^0.8.1;
123 
124 /**
125  * @dev Collection of functions related to the address type
126  */
127 library Address {
128     /**
129      * @dev Returns true if `account` is a contract.
130      *
131      * [IMPORTANT]
132      * ====
133      * It is unsafe to assume that an address for which this function returns
134      * false is an externally-owned account (EOA) and not a contract.
135      *
136      * Among others, `isContract` will return false for the following
137      * types of addresses:
138      *
139      *  - an externally-owned account
140      *  - a contract in construction
141      *  - an address where a contract will be created
142      *  - an address where a contract lived, but was destroyed
143      * ====
144      *
145      * [IMPORTANT]
146      * ====
147      * You shouldn't rely on `isContract` to protect against flash loan attacks!
148      *
149      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
150      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
151      * constructor.
152      * ====
153      */
154     function isContract(address account) internal view returns (bool) {
155         // This method relies on extcodesize/address.code.length, which returns 0
156         // for contracts in construction, since the code is only stored at the end
157         // of the constructor execution.
158 
159         return account.code.length > 0;
160     }
161 
162     /**
163      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
164      * `recipient`, forwarding all available gas and reverting on errors.
165      *
166      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
167      * of certain opcodes, possibly making contracts go over the 2300 gas limit
168      * imposed by `transfer`, making them unable to receive funds via
169      * `transfer`. {sendValue} removes this limitation.
170      *
171      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
172      *
173      * IMPORTANT: because control is transferred to `recipient`, care must be
174      * taken to not create reentrancy vulnerabilities. Consider using
175      * {ReentrancyGuard} or the
176      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
177      */
178     function sendValue(address payable recipient, uint256 amount) internal {
179         require(address(this).balance >= amount, "Address: insufficient balance");
180 
181         (bool success, ) = recipient.call{value: amount}("");
182         require(success, "Address: unable to send value, recipient may have reverted");
183     }
184 
185     /**
186      * @dev Performs a Solidity function call using a low level `call`. A
187      * plain `call` is an unsafe replacement for a function call: use this
188      * function instead.
189      *
190      * If `target` reverts with a revert reason, it is bubbled up by this
191      * function (like regular Solidity function calls).
192      *
193      * Returns the raw returned data. To convert to the expected return value,
194      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
195      *
196      * Requirements:
197      *
198      * - `target` must be a contract.
199      * - calling `target` with `data` must not revert.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionCall(target, data, "Address: low-level call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
209      * `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, 0, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but also transferring `value` wei to `target`.
224      *
225      * Requirements:
226      *
227      * - the calling contract must have an ETH balance of at least `value`.
228      * - the called Solidity function must be `payable`.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value
236     ) internal returns (bytes memory) {
237         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
242      * with `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         require(address(this).balance >= value, "Address: insufficient balance for call");
253         require(isContract(target), "Address: call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.call{value: value}(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
266         return functionStaticCall(target, data, "Address: low-level static call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal view returns (bytes memory) {
280         require(isContract(target), "Address: static call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.staticcall(data);
283         return verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
298      * but performing a delegate call.
299      *
300      * _Available since v3.4._
301      */
302     function functionDelegateCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(isContract(target), "Address: delegate call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.delegatecall(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
315      * revert reason using the provided one.
316      *
317      * _Available since v4.3._
318      */
319     function verifyCallResult(
320         bool success,
321         bytes memory returndata,
322         string memory errorMessage
323     ) internal pure returns (bytes memory) {
324         if (success) {
325             return returndata;
326         } else {
327             // Look for revert reason and bubble it up if present
328             if (returndata.length > 0) {
329                 // The easiest way to bubble the revert reason is using memory via assembly
330 
331                 assembly {
332                     let returndata_size := mload(returndata)
333                     revert(add(32, returndata), returndata_size)
334                 }
335             } else {
336                 revert(errorMessage);
337             }
338         }
339     }
340 }
341 
342 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
343 
344 
345 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
346 
347 pragma solidity ^0.8.0;
348 
349 /**
350  * @title ERC721 token receiver interface
351  * @dev Interface for any contract that wants to support safeTransfers
352  * from ERC721 asset contracts.
353  */
354 interface IERC721Receiver {
355     /**
356      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
357      * by `operator` from `from`, this function is called.
358      *
359      * It must return its Solidity selector to confirm the token transfer.
360      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
361      *
362      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
363      */
364     function onERC721Received(
365         address operator,
366         address from,
367         uint256 tokenId,
368         bytes calldata data
369     ) external returns (bytes4);
370 }
371 
372 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Interface of the ERC165 standard, as defined in the
381  * https://eips.ethereum.org/EIPS/eip-165[EIP].
382  *
383  * Implementers can declare support of contract interfaces, which can then be
384  * queried by others ({ERC165Checker}).
385  *
386  * For an implementation, see {ERC165}.
387  */
388 interface IERC165 {
389     /**
390      * @dev Returns true if this contract implements the interface defined by
391      * `interfaceId`. See the corresponding
392      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
393      * to learn more about how these ids are created.
394      *
395      * This function call must use less than 30 000 gas.
396      */
397     function supportsInterface(bytes4 interfaceId) external view returns (bool);
398 }
399 
400 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
401 
402 
403 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 
408 /**
409  * @dev Implementation of the {IERC165} interface.
410  *
411  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
412  * for the additional interface id that will be supported. For example:
413  *
414  * ```solidity
415  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
416  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
417  * }
418  * ```
419  *
420  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
421  */
422 abstract contract ERC165 is IERC165 {
423     /**
424      * @dev See {IERC165-supportsInterface}.
425      */
426     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
427         return interfaceId == type(IERC165).interfaceId;
428     }
429 }
430 
431 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
432 
433 
434 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 
439 /**
440  * @dev Required interface of an ERC721 compliant contract.
441  */
442 interface IERC721 is IERC165 {
443     /**
444      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
445      */
446     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
447 
448     /**
449      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
450      */
451     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
455      */
456     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
457 
458     /**
459      * @dev Returns the number of tokens in ``owner``'s account.
460      */
461     function balanceOf(address owner) external view returns (uint256 balance);
462 
463     /**
464      * @dev Returns the owner of the `tokenId` token.
465      *
466      * Requirements:
467      *
468      * - `tokenId` must exist.
469      */
470     function ownerOf(uint256 tokenId) external view returns (address owner);
471 
472     /**
473      * @dev Safely transfers `tokenId` token from `from` to `to`.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must exist and be owned by `from`.
480      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
481      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
482      *
483      * Emits a {Transfer} event.
484      */
485     function safeTransferFrom(
486         address from,
487         address to,
488         uint256 tokenId,
489         bytes calldata data
490     ) external;
491 
492     /**
493      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
494      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must exist and be owned by `from`.
501      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) external;
511 
512     /**
513      * @dev Transfers `tokenId` token from `from` to `to`.
514      *
515      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must be owned by `from`.
522      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
523      *
524      * Emits a {Transfer} event.
525      */
526     function transferFrom(
527         address from,
528         address to,
529         uint256 tokenId
530     ) external;
531 
532     /**
533      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
534      * The approval is cleared when the token is transferred.
535      *
536      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
537      *
538      * Requirements:
539      *
540      * - The caller must own the token or be an approved operator.
541      * - `tokenId` must exist.
542      *
543      * Emits an {Approval} event.
544      */
545     function approve(address to, uint256 tokenId) external;
546 
547     /**
548      * @dev Approve or remove `operator` as an operator for the caller.
549      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
550      *
551      * Requirements:
552      *
553      * - The `operator` cannot be the caller.
554      *
555      * Emits an {ApprovalForAll} event.
556      */
557     function setApprovalForAll(address operator, bool _approved) external;
558 
559     /**
560      * @dev Returns the account approved for `tokenId` token.
561      *
562      * Requirements:
563      *
564      * - `tokenId` must exist.
565      */
566     function getApproved(uint256 tokenId) external view returns (address operator);
567 
568     /**
569      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
570      *
571      * See {setApprovalForAll}
572      */
573     function isApprovedForAll(address owner, address operator) external view returns (bool);
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
577 
578 
579 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 
584 /**
585  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
586  * @dev See https://eips.ethereum.org/EIPS/eip-721
587  */
588 interface IERC721Enumerable is IERC721 {
589     /**
590      * @dev Returns the total amount of tokens stored by the contract.
591      */
592     function totalSupply() external view returns (uint256);
593 
594     /**
595      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
596      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
597      */
598     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
599 
600     /**
601      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
602      * Use along with {totalSupply} to enumerate all tokens.
603      */
604     function tokenByIndex(uint256 index) external view returns (uint256);
605 }
606 
607 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 
615 /**
616  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
617  * @dev See https://eips.ethereum.org/EIPS/eip-721
618  */
619 interface IERC721Metadata is IERC721 {
620     /**
621      * @dev Returns the token collection name.
622      */
623     function name() external view returns (string memory);
624 
625     /**
626      * @dev Returns the token collection symbol.
627      */
628     function symbol() external view returns (string memory);
629 
630     /**
631      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
632      */
633     function tokenURI(uint256 tokenId) external view returns (string memory);
634 }
635 
636 // File: ERC721A.sol
637 
638 
639 // Creator: Chiru Labs
640 
641 pragma solidity ^0.8.0;
642 
643 
644 
645 /**
646  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
647  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
648  *
649  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
650  *
651  * Does not support burning tokens to address(0).
652  *
653  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
654  */
655 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
656     using Address for address;
657     using Strings for uint256;
658 
659     struct TokenOwnership {
660         address addr;
661         uint64 startTimestamp;
662     }
663 
664     struct AddressData {
665         uint128 balance;
666         uint128 numberMinted;
667     }
668 
669     uint256 internal currentIndex = 1;
670 
671     // Token name
672     string private _name;
673 
674     // Token symbol
675     string private _symbol;
676 
677     // Mapping from token ID to ownership details
678     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
679     mapping(uint256 => TokenOwnership) internal _ownerships;
680 
681     // Mapping owner address to address data
682     mapping(address => AddressData) private _addressData;
683 
684     // Mapping from token ID to approved address
685     mapping(uint256 => address) private _tokenApprovals;
686 
687     // Mapping from owner to operator approvals
688     mapping(address => mapping(address => bool)) private _operatorApprovals;
689 
690     constructor(string memory name_, string memory symbol_) {
691         _name = name_;
692         _symbol = symbol_;
693     }
694 
695     /**
696      * @dev See {IERC721Enumerable-totalSupply}.
697      */
698     function totalSupply() public view override returns (uint256) {
699         return currentIndex;
700     }
701 
702     /**
703      * @dev See {IERC721Enumerable-tokenByIndex}.
704      */
705     function tokenByIndex(uint256 index) public view override returns (uint256) {
706         require(index < totalSupply(), 'ERC721A: global index out of bounds');
707         return index;
708     }
709 
710     /**
711      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
712      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
713      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
714      */
715     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
716         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
717         uint256 numMintedSoFar = totalSupply();
718         uint256 tokenIdsIdx;
719         address currOwnershipAddr;
720 
721         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
722         unchecked {
723             for (uint256 i; i < numMintedSoFar; i++) {
724                 TokenOwnership memory ownership = _ownerships[i];
725                 if (ownership.addr != address(0)) {
726                     currOwnershipAddr = ownership.addr;
727                 }
728                 if (currOwnershipAddr == owner) {
729                     if (tokenIdsIdx == index) {
730                         return i;
731                     }
732                     tokenIdsIdx++;
733                 }
734             }
735         }
736 
737         revert('ERC721A: unable to get token of owner by index');
738     }
739 
740     /**
741      * @dev See {IERC165-supportsInterface}.
742      */
743     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
744         return
745             interfaceId == type(IERC721).interfaceId ||
746             interfaceId == type(IERC721Metadata).interfaceId ||
747             interfaceId == type(IERC721Enumerable).interfaceId ||
748             super.supportsInterface(interfaceId);
749     }
750 
751     /**
752      * @dev See {IERC721-balanceOf}.
753      */
754     function balanceOf(address owner) public view override returns (uint256) {
755         require(owner != address(0), 'ERC721A: balance query for the zero address');
756         return uint256(_addressData[owner].balance);
757     }
758 
759     function _numberMinted(address owner) internal view returns (uint256) {
760         require(owner != address(0), 'ERC721A: number minted query for the zero address');
761         return uint256(_addressData[owner].numberMinted);
762     }
763 
764     /**
765      * Gas spent here starts off proportional to the maximum mint batch size.
766      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
767      */
768     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
769         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
770 
771         unchecked {
772             for (uint256 curr = tokenId; curr >= 0; curr--) {
773                 TokenOwnership memory ownership = _ownerships[curr];
774                 if (ownership.addr != address(0)) {
775                     return ownership;
776                 }
777             }
778         }
779 
780         revert('ERC721A: unable to determine the owner of token');
781     }
782 
783     /**
784      * @dev See {IERC721-ownerOf}.
785      */
786     function ownerOf(uint256 tokenId) public view override returns (address) {
787         return ownershipOf(tokenId).addr;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-name}.
792      */
793     function name() public view virtual override returns (string memory) {
794         return _name;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-symbol}.
799      */
800     function symbol() public view virtual override returns (string memory) {
801         return _symbol;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-tokenURI}.
806      */
807     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
808         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
809 
810         string memory baseURI = _baseURI();
811         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
812     }
813 
814     /**
815      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
816      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
817      * by default, can be overriden in child contracts.
818      */
819     function _baseURI() internal view virtual returns (string memory) {
820         return '';
821     }
822 
823     /**
824      * @dev See {IERC721-approve}.
825      */
826     function approve(address to, uint256 tokenId) public override {
827         address owner = ERC721A.ownerOf(tokenId);
828         require(to != owner, 'ERC721A: approval to current owner');
829 
830         require(
831             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
832             'ERC721A: approve caller is not owner nor approved for all'
833         );
834 
835         _approve(to, tokenId, owner);
836     }
837 
838     /**
839      * @dev See {IERC721-getApproved}.
840      */
841     function getApproved(uint256 tokenId) public view override returns (address) {
842         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
843 
844         return _tokenApprovals[tokenId];
845     }
846 
847     /**
848      * @dev See {IERC721-setApprovalForAll}.
849      */
850     function setApprovalForAll(address operator, bool approved) public override {
851         require(operator != _msgSender(), 'ERC721A: approve to caller');
852 
853         _operatorApprovals[_msgSender()][operator] = approved;
854         emit ApprovalForAll(_msgSender(), operator, approved);
855     }
856 
857     /**
858      * @dev See {IERC721-isApprovedForAll}.
859      */
860     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
861         return _operatorApprovals[owner][operator];
862     }
863 
864     /**
865      * @dev See {IERC721-transferFrom}.
866      */
867     function transferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) public override {
872         _transfer(from, to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public override {
883         safeTransferFrom(from, to, tokenId, '');
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) public override {
895         _transfer(from, to, tokenId);
896         require(
897             _checkOnERC721Received(from, to, tokenId, _data),
898             'ERC721A: transfer to non ERC721Receiver implementer'
899         );
900     }
901 
902     /**
903      * @dev Returns whether `tokenId` exists.
904      *
905      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
906      *
907      * Tokens start existing when they are minted (`_mint`),
908      */
909     function _exists(uint256 tokenId) internal view returns (bool) {
910         return tokenId < currentIndex;
911     }
912 
913     function _safeMint(address to, uint256 quantity) internal {
914         _safeMint(to, quantity, '');
915     }
916 
917     /**
918      * @dev Safely mints `quantity` tokens and transfers them to `to`.
919      *
920      * Requirements:
921      *
922      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
923      * - `quantity` must be greater than 0.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeMint(
928         address to,
929         uint256 quantity,
930         bytes memory _data
931     ) internal {
932         _mint(to, quantity, _data, true);
933     }
934 
935     /**
936      * @dev Mints `quantity` tokens and transfers them to `to`.
937      *
938      * Requirements:
939      *
940      * - `to` cannot be the zero address.
941      * - `quantity` must be greater than 0.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _mint(
946         address to,
947         uint256 quantity,
948         bytes memory _data,
949         bool safe
950     ) internal {
951         uint256 startTokenId = currentIndex;
952         require(to != address(0), 'ERC721A: mint to the zero address');
953         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
954 
955         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
956 
957         // Overflows are incredibly unrealistic.
958         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
959         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
960         unchecked {
961             _addressData[to].balance += uint128(quantity);
962             _addressData[to].numberMinted += uint128(quantity);
963 
964             _ownerships[startTokenId].addr = to;
965             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
966 
967             uint256 updatedIndex = startTokenId;
968 
969             for (uint256 i; i < quantity; i++) {
970                 emit Transfer(address(0), to, updatedIndex);
971                 if (safe) {
972                     require(
973                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
974                         'ERC721A: transfer to non ERC721Receiver implementer'
975                     );
976                 }
977 
978                 updatedIndex++;
979             }
980 
981             currentIndex = updatedIndex;
982         }
983 
984         _afterTokenTransfers(address(0), to, startTokenId, quantity);
985     }
986 
987     /**
988      * @dev Transfers `tokenId` from `from` to `to`.
989      *
990      * Requirements:
991      *
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must be owned by `from`.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _transfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) private {
1002         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1003 
1004         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1005             getApproved(tokenId) == _msgSender() ||
1006             isApprovedForAll(prevOwnership.addr, _msgSender()));
1007 
1008         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1009 
1010         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1011         require(to != address(0), 'ERC721A: transfer to the zero address');
1012 
1013         _beforeTokenTransfers(from, to, tokenId, 1);
1014 
1015         // Clear approvals from the previous owner
1016         _approve(address(0), tokenId, prevOwnership.addr);
1017 
1018         // Underflow of the sender's balance is impossible because we check for
1019         // ownership above and the recipient's balance can't realistically overflow.
1020         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1021         unchecked {
1022             _addressData[from].balance -= 1;
1023             _addressData[to].balance += 1;
1024 
1025             _ownerships[tokenId].addr = to;
1026             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1027 
1028             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1029             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1030             uint256 nextTokenId = tokenId + 1;
1031             if (_ownerships[nextTokenId].addr == address(0)) {
1032                 if (_exists(nextTokenId)) {
1033                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1034                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1035                 }
1036             }
1037         }
1038 
1039         emit Transfer(from, to, tokenId);
1040         _afterTokenTransfers(from, to, tokenId, 1);
1041     }
1042 
1043     /**
1044      * @dev Approve `to` to operate on `tokenId`
1045      *
1046      * Emits a {Approval} event.
1047      */
1048     function _approve(
1049         address to,
1050         uint256 tokenId,
1051         address owner
1052     ) private {
1053         _tokenApprovals[tokenId] = to;
1054         emit Approval(owner, to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1059      * The call is not executed if the target address is not a contract.
1060      *
1061      * @param from address representing the previous owner of the given token ID
1062      * @param to target address that will receive the tokens
1063      * @param tokenId uint256 ID of the token to be transferred
1064      * @param _data bytes optional data to send along with the call
1065      * @return bool whether the call correctly returned the expected magic value
1066      */
1067     function _checkOnERC721Received(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) private returns (bool) {
1073         if (to.isContract()) {
1074             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1075                 return retval == IERC721Receiver(to).onERC721Received.selector;
1076             } catch (bytes memory reason) {
1077                 if (reason.length == 0) {
1078                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1079                 } else {
1080                     assembly {
1081                         revert(add(32, reason), mload(reason))
1082                     }
1083                 }
1084             }
1085         } else {
1086             return true;
1087         }
1088     }
1089 
1090     /**
1091      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1092      *
1093      * startTokenId - the first token id to be transferred
1094      * quantity - the amount to be transferred
1095      *
1096      * Calling conditions:
1097      *
1098      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1099      * transferred to `to`.
1100      * - When `from` is zero, `tokenId` will be minted for `to`.
1101      */
1102     function _beforeTokenTransfers(
1103         address from,
1104         address to,
1105         uint256 startTokenId,
1106         uint256 quantity
1107     ) internal virtual {}
1108 
1109     /**
1110      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1111      * minting.
1112      *
1113      * startTokenId - the first token id to be transferred
1114      * quantity - the amount to be transferred
1115      *
1116      * Calling conditions:
1117      *
1118      * - when `from` and `to` are both non-zero.
1119      * - `from` and `to` are never both zero.
1120      */
1121     function _afterTokenTransfers(
1122         address from,
1123         address to,
1124         uint256 startTokenId,
1125         uint256 quantity
1126     ) internal virtual {}
1127 }
1128 
1129 
1130 // Ownable.sol
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 /**
1135  * @dev Contract module which provides a basic access control mechanism, where
1136  * there is an account (an owner) that can be granted exclusive access to
1137  * specific functions.
1138  *
1139  * By default, the owner account will be the one that deploys the contract. This
1140  * can later be changed with {transferOwnership}.
1141  *
1142  * This module is used through inheritance. It will make available the modifier
1143  * `onlyOwner`, which can be applied to your functions to restrict their use to
1144  * the owner.
1145  */
1146 abstract contract Ownable is Context {
1147     address private _owner;
1148 
1149     event OwnershipTransferred(
1150         address indexed previousOwner,
1151         address indexed newOwner
1152     );
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
1192         require(
1193             newOwner != address(0),
1194             "Ownable: new owner is the zero address"
1195         );
1196         _setOwner(newOwner);
1197     }
1198 
1199     function _setOwner(address newOwner) private {
1200         address oldOwner = _owner;
1201         _owner = newOwner;
1202         emit OwnershipTransferred(oldOwner, newOwner);
1203     }
1204 }
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 /**
1209  * @dev Contract module that helps prevent reentrant calls to a function.
1210  *
1211  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1212  * available, which can be applied to functions to make sure there are no nested
1213  * (reentrant) calls to them.
1214  *
1215  * Note that because there is a single `nonReentrant` guard, functions marked as
1216  * `nonReentrant` may not call one another. This can be worked around by making
1217  * those functions `private`, and then adding `external` `nonReentrant` entry
1218  * points to them.
1219  *
1220  * TIP: If you would like to learn more about reentrancy and alternative ways
1221  * to protect against it, check out our blog post
1222  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1223  */
1224 abstract contract ReentrancyGuard {
1225     // Booleans are more expensive than uint256 or any type that takes up a full
1226     // word because each write operation emits an extra SLOAD to first read the
1227     // slot's contents, replace the bits taken up by the boolean, and then write
1228     // back. This is the compiler's defense against contract upgrades and
1229     // pointer aliasing, and it cannot be disabled.
1230 
1231     // The values being non-zero value makes deployment a bit more expensive,
1232     // but in exchange the refund on every call to nonReentrant will be lower in
1233     // amount. Since refunds are capped to a percentage of the total
1234     // transaction's gas, it is best to keep them low in cases like this one, to
1235     // increase the likelihood of the full refund coming into effect.
1236     uint256 private constant _NOT_ENTERED = 1;
1237     uint256 private constant _ENTERED = 2;
1238 
1239     uint256 private _status;
1240 
1241     constructor() {
1242         _status = _NOT_ENTERED;
1243     }
1244 
1245     /**
1246      * @dev Prevents a contract from calling itself, directly or indirectly.
1247      * Calling a `nonReentrant` function from another `nonReentrant`
1248      * function is not supported. It is possible to prevent this from happening
1249      * by making the `nonReentrant` function external, and make it call a
1250      * `private` function that does the actual work.
1251      */
1252     modifier nonReentrant() {
1253         // On the first call to nonReentrant, _notEntered will be true
1254         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1255 
1256         // Any calls to nonReentrant after this point will fail
1257         _status = _ENTERED;
1258 
1259         _;
1260 
1261         // By storing the original value once again, a refund is triggered (see
1262         // https://eips.ethereum.org/EIPS/eip-2200)
1263         _status = _NOT_ENTERED;
1264     }
1265 }
1266 
1267 //theonionz.sol
1268 
1269 pragma solidity ^0.8.0;
1270 
1271 
1272 contract theonionz is ERC721A, Ownable, ReentrancyGuard {
1273     using Strings for uint256;
1274     string public baseURI;
1275     uint256 public cost = 0.002 ether;
1276     uint256 public maxSupply = 5000;
1277     uint256 public maxFree = 1500;
1278     uint256 public maxperAddressFreeLimit = 2;
1279     uint256 public maxperAddressPublicMint = 20;
1280 
1281     mapping(address => uint256) public addressFreeMintedBalance;
1282 
1283     constructor() ERC721A("theonionz", "ONION") {
1284         setBaseURI("https://theonionz.s3.amazonaws.com/metadata/");
1285 
1286     }
1287 
1288     function _baseURI() internal view virtual override returns (string memory) {
1289         return baseURI;
1290     }
1291 
1292     function mintFree(uint256 _mintAmount) public payable nonReentrant{
1293 		uint256 s = totalSupply();
1294         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1295         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "Max onionz per address exceeded");
1296 		require(_mintAmount > 0, "Cannot mint 0 Onionz" );
1297 		require(s + _mintAmount <= maxFree, "Cannot exceed Onionz supply" );
1298 		for (uint256 i = 0; i < _mintAmount; ++i) {
1299             addressFreeMintedBalance[msg.sender]++;
1300 
1301 		}
1302         _safeMint(msg.sender, _mintAmount);
1303 		delete s;
1304         delete addressFreeMintedCount;
1305 	}
1306 
1307 
1308     function mint(uint256 _mintAmount) public payable nonReentrant {
1309         uint256 s = totalSupply();
1310         require(_mintAmount > 0, "Cannot mint 0 Onionz");
1311         require(_mintAmount <= maxperAddressPublicMint, "Cannot mint more Onionz" );
1312         require(s + _mintAmount <= maxSupply, "Cannot exceed Onionz supply");
1313         require(msg.value >= cost * _mintAmount);
1314         _safeMint(msg.sender, _mintAmount);
1315         delete s;
1316     }
1317 
1318     function gift(uint256[] calldata quantity, address[] calldata recipient)
1319         external
1320         onlyOwner{
1321         require(
1322             quantity.length == recipient.length,
1323             "Provide quantities and recipients"
1324         );
1325         uint256 totalQuantity = 0;
1326         uint256 s = totalSupply();
1327         for (uint256 i = 0; i < quantity.length; ++i) {
1328             totalQuantity += quantity[i];
1329         }
1330         require(s + totalQuantity <= maxSupply, "Too many Onionz");
1331         delete totalQuantity;
1332         for (uint256 i = 0; i < recipient.length; ++i) {
1333             _safeMint(recipient[i], quantity[i]);
1334         }
1335         delete s;
1336     }
1337 
1338     function tokenURI(uint256 tokenId)
1339         public view virtual override returns (string memory){
1340         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1341         string memory currentBaseURI = _baseURI();
1342         return
1343             bytes(currentBaseURI).length > 0
1344                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1345                 : "";
1346     }
1347 
1348 
1349     function setCost(uint256 _newCost) public onlyOwner {
1350         cost = _newCost;
1351     }
1352 
1353     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1354         maxSupply = _newMaxSupply;
1355     }
1356 
1357     function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1358                maxFree = _newMaxFreeSupply;
1359     }
1360 
1361     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1362         baseURI = _newBaseURI;
1363     }
1364 
1365     function setMaxperAddressPublicMint(uint256 _amount) public onlyOwner {
1366         maxperAddressPublicMint = _amount;
1367     }
1368 
1369     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1370         maxperAddressFreeLimit = _amount;
1371     }
1372     function withdraw() public payable onlyOwner {
1373         (bool success, ) = payable(msg.sender).call{
1374             value: address(this).balance
1375         }("");
1376         require(success);
1377     }
1378 
1379     function withdrawAny(uint256 _amount) public payable onlyOwner {
1380         (bool success, ) = payable(msg.sender).call{value: _amount}("");
1381         require(success);
1382     }
1383 }