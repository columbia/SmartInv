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
75 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
76 
77 pragma solidity ^0.8.1;
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
99      *
100      * [IMPORTANT]
101      * ====
102      * You shouldn't rely on `isContract` to protect against flash loan attacks!
103      *
104      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
105      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
106      * constructor.
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize/address.code.length, which returns 0
111         // for contracts in construction, since the code is only stored at the end
112         // of the constructor execution.
113 
114         return account.code.length > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         (bool success, ) = recipient.call{value: amount}("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain `call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
197      * with `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         require(isContract(target), "Address: static call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.staticcall(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(isContract(target), "Address: delegate call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
270      * revert reason using the provided one.
271      *
272      * _Available since v4.3._
273      */
274     function verifyCallResult(
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) internal pure returns (bytes memory) {
279         if (success) {
280             return returndata;
281         } else {
282             // Look for revert reason and bubble it up if present
283             if (returndata.length > 0) {
284                 // The easiest way to bubble the revert reason is using memory via assembly
285 
286                 assembly {
287                     let returndata_size := mload(returndata)
288                     revert(add(32, returndata), returndata_size)
289                 }
290             } else {
291                 revert(errorMessage);
292             }
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
298 
299 
300 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @title ERC721 token receiver interface
306  * @dev Interface for any contract that wants to support safeTransfers
307  * from ERC721 asset contracts.
308  */
309 interface IERC721Receiver {
310     /**
311      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
312      * by `operator` from `from`, this function is called.
313      *
314      * It must return its Solidity selector to confirm the token transfer.
315      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
316      *
317      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
318      */
319     function onERC721Received(
320         address operator,
321         address from,
322         uint256 tokenId,
323         bytes calldata data
324     ) external returns (bytes4);
325 }
326 
327 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Interface of the ERC165 standard, as defined in the
336  * https://eips.ethereum.org/EIPS/eip-165[EIP].
337  *
338  * Implementers can declare support of contract interfaces, which can then be
339  * queried by others ({ERC165Checker}).
340  *
341  * For an implementation, see {ERC165}.
342  */
343 interface IERC165 {
344     /**
345      * @dev Returns true if this contract implements the interface defined by
346      * `interfaceId`. See the corresponding
347      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
348      * to learn more about how these ids are created.
349      *
350      * This function call must use less than 30 000 gas.
351      */
352     function supportsInterface(bytes4 interfaceId) external view returns (bool);
353 }
354 
355 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 
363 /**
364  * @dev Implementation of the {IERC165} interface.
365  *
366  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
367  * for the additional interface id that will be supported. For example:
368  *
369  * ```solidity
370  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
372  * }
373  * ```
374  *
375  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
376  */
377 abstract contract ERC165 is IERC165 {
378     /**
379      * @dev See {IERC165-supportsInterface}.
380      */
381     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382         return interfaceId == type(IERC165).interfaceId;
383     }
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
387 
388 
389 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev Required interface of an ERC721 compliant contract.
396  */
397 interface IERC721 is IERC165 {
398     /**
399      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
400      */
401     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
402 
403     /**
404      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
405      */
406     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
407 
408     /**
409      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
410      */
411     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
412 
413     /**
414      * @dev Returns the number of tokens in ``owner``'s account.
415      */
416     function balanceOf(address owner) external view returns (uint256 balance);
417 
418     /**
419      * @dev Returns the owner of the `tokenId` token.
420      *
421      * Requirements:
422      *
423      * - `tokenId` must exist.
424      */
425     function ownerOf(uint256 tokenId) external view returns (address owner);
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId,
444         bytes calldata data
445     ) external;
446 
447     /**
448      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
449      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must exist and be owned by `from`.
456      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
457      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
458      *
459      * Emits a {Transfer} event.
460      */
461     function safeTransferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) external;
466 
467     /**
468      * @dev Transfers `tokenId` token from `from` to `to`.
469      *
470      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
471      *
472      * Requirements:
473      *
474      * - `from` cannot be the zero address.
475      * - `to` cannot be the zero address.
476      * - `tokenId` token must be owned by `from`.
477      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
478      *
479      * Emits a {Transfer} event.
480      */
481     function transferFrom(
482         address from,
483         address to,
484         uint256 tokenId
485     ) external;
486 
487     /**
488      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
489      * The approval is cleared when the token is transferred.
490      *
491      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
492      *
493      * Requirements:
494      *
495      * - The caller must own the token or be an approved operator.
496      * - `tokenId` must exist.
497      *
498      * Emits an {Approval} event.
499      */
500     function approve(address to, uint256 tokenId) external;
501 
502     /**
503      * @dev Approve or remove `operator` as an operator for the caller.
504      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
505      *
506      * Requirements:
507      *
508      * - The `operator` cannot be the caller.
509      *
510      * Emits an {ApprovalForAll} event.
511      */
512     function setApprovalForAll(address operator, bool _approved) external;
513 
514     /**
515      * @dev Returns the account approved for `tokenId` token.
516      *
517      * Requirements:
518      *
519      * - `tokenId` must exist.
520      */
521     function getApproved(uint256 tokenId) external view returns (address operator);
522 
523     /**
524      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
525      *
526      * See {setApprovalForAll}
527      */
528     function isApprovedForAll(address owner, address operator) external view returns (bool);
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
532 
533 
534 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
541  * @dev See https://eips.ethereum.org/EIPS/eip-721
542  */
543 interface IERC721Enumerable is IERC721 {
544     /**
545      * @dev Returns the total amount of tokens stored by the contract.
546      */
547     function totalSupply() external view returns (uint256);
548 
549     /**
550      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
551      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
552      */
553     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
554 
555     /**
556      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
557      * Use along with {totalSupply} to enumerate all tokens.
558      */
559     function tokenByIndex(uint256 index) external view returns (uint256);
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
572  * @dev See https://eips.ethereum.org/EIPS/eip-721
573  */
574 interface IERC721Metadata is IERC721 {
575     /**
576      * @dev Returns the token collection name.
577      */
578     function name() external view returns (string memory);
579 
580     /**
581      * @dev Returns the token collection symbol.
582      */
583     function symbol() external view returns (string memory);
584 
585     /**
586      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
587      */
588     function tokenURI(uint256 tokenId) external view returns (string memory);
589 }
590 
591 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev Contract module that helps prevent reentrant calls to a function.
600  *
601  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
602  * available, which can be applied to functions to make sure there are no nested
603  * (reentrant) calls to them.
604  *
605  * Note that because there is a single `nonReentrant` guard, functions marked as
606  * `nonReentrant` may not call one another. This can be worked around by making
607  * those functions `private`, and then adding `external` `nonReentrant` entry
608  * points to them.
609  *
610  * TIP: If you would like to learn more about reentrancy and alternative ways
611  * to protect against it, check out our blog post
612  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
613  */
614 abstract contract ReentrancyGuard {
615     // Booleans are more expensive than uint256 or any type that takes up a full
616     // word because each write operation emits an extra SLOAD to first read the
617     // slot's contents, replace the bits taken up by the boolean, and then write
618     // back. This is the compiler's defense against contract upgrades and
619     // pointer aliasing, and it cannot be disabled.
620 
621     // The values being non-zero value makes deployment a bit more expensive,
622     // but in exchange the refund on every call to nonReentrant will be lower in
623     // amount. Since refunds are capped to a percentage of the total
624     // transaction's gas, it is best to keep them low in cases like this one, to
625     // increase the likelihood of the full refund coming into effect.
626     uint256 private constant _NOT_ENTERED = 1;
627     uint256 private constant _ENTERED = 2;
628 
629     uint256 private _status;
630 
631     constructor() {
632         _status = _NOT_ENTERED;
633     }
634 
635     /**
636      * @dev Prevents a contract from calling itself, directly or indirectly.
637      * Calling a `nonReentrant` function from another `nonReentrant`
638      * function is not supported. It is possible to prevent this from happening
639      * by making the `nonReentrant` function external, and making it call a
640      * `private` function that does the actual work.
641      */
642     modifier nonReentrant() {
643         // On the first call to nonReentrant, _notEntered will be true
644         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
645 
646         // Any calls to nonReentrant after this point will fail
647         _status = _ENTERED;
648 
649         _;
650 
651         // By storing the original value once again, a refund is triggered (see
652         // https://eips.ethereum.org/EIPS/eip-2200)
653         _status = _NOT_ENTERED;
654     }
655 }
656 
657 // File: @openzeppelin/contracts/utils/Context.sol
658 
659 
660 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @dev Provides information about the current execution context, including the
666  * sender of the transaction and its data. While these are generally available
667  * via msg.sender and msg.data, they should not be accessed in such a direct
668  * manner, since when dealing with meta-transactions the account sending and
669  * paying for execution may not be the actual sender (as far as an application
670  * is concerned).
671  *
672  * This contract is only required for intermediate, library-like contracts.
673  */
674 abstract contract Context {
675     function _msgSender() internal view virtual returns (address) {
676         return msg.sender;
677     }
678 
679     function _msgData() internal view virtual returns (bytes calldata) {
680         return msg.data;
681     }
682 }
683 
684 // File: contracts/ERC721A.sol
685 
686 
687 
688 pragma solidity ^0.8.0;
689 
690 
691 
692 
693 
694 
695 
696 
697 
698 /**
699  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
700  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
701  *
702  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
703  *
704  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
705  *
706  * Does not support burning tokens to address(0).
707  */
708 contract ERC721A is
709   Context,
710   ERC165,
711   IERC721,
712   IERC721Metadata,
713   IERC721Enumerable
714 {
715   using Address for address;
716   using Strings for uint256;
717 
718   struct TokenOwnership {
719     address addr;
720     uint64 startTimestamp;
721   }
722 
723   struct AddressData {
724     uint128 balance;
725     uint128 numberMinted;
726   }
727 
728   uint256 private currentIndex = 0;
729 
730   uint256 internal immutable collectionSize;
731   uint256 internal immutable maxBatchSize;
732 
733   // Token name
734   string private _name;
735 
736   // Token symbol
737   string private _symbol;
738 
739   // Mapping from token ID to ownership details
740   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
741   mapping(uint256 => TokenOwnership) private _ownerships;
742 
743   // Mapping owner address to address data
744   mapping(address => AddressData) private _addressData;
745 
746   // Mapping from token ID to approved address
747   mapping(uint256 => address) private _tokenApprovals;
748 
749   // Mapping from owner to operator approvals
750   mapping(address => mapping(address => bool)) private _operatorApprovals;
751 
752   /**
753    * @dev
754    * `maxBatchSize` refers to how much a minter can mint at a time.
755    * `collectionSize_` refers to how many tokens are in the collection.
756    */
757   constructor(
758     string memory name_,
759     string memory symbol_,
760     uint256 maxBatchSize_,
761     uint256 collectionSize_
762   ) {
763     require(
764       collectionSize_ > 0,
765       "ERC721A: collection must have a nonzero supply"
766     );
767     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
768     _name = name_;
769     _symbol = symbol_;
770     maxBatchSize = maxBatchSize_;
771     collectionSize = collectionSize_;
772   }
773 
774   /**
775    * @dev See {IERC721Enumerable-totalSupply}.
776    */
777   function totalSupply() public view override returns (uint256) {
778     return currentIndex;
779   }
780 
781   /**
782    * @dev See {IERC721Enumerable-tokenByIndex}.
783    */
784   function tokenByIndex(uint256 index) public view override returns (uint256) {
785     require(index < totalSupply(), "ERC721A: global index out of bounds");
786     return index;
787   }
788 
789   /**
790    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
791    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
792    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
793    */
794   function tokenOfOwnerByIndex(address owner, uint256 index)
795     public
796     view
797     override
798     returns (uint256)
799   {
800     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
801     uint256 numMintedSoFar = totalSupply();
802     uint256 tokenIdsIdx = 0;
803     address currOwnershipAddr = address(0);
804     for (uint256 i = 0; i < numMintedSoFar; i++) {
805       TokenOwnership memory ownership = _ownerships[i];
806       if (ownership.addr != address(0)) {
807         currOwnershipAddr = ownership.addr;
808       }
809       if (currOwnershipAddr == owner) {
810         if (tokenIdsIdx == index) {
811           return i;
812         }
813         tokenIdsIdx++;
814       }
815     }
816     revert("ERC721A: unable to get token of owner by index");
817   }
818 
819   /**
820    * @dev See {IERC165-supportsInterface}.
821    */
822   function supportsInterface(bytes4 interfaceId)
823     public
824     view
825     virtual
826     override(ERC165, IERC165)
827     returns (bool)
828   {
829     return
830       interfaceId == type(IERC721).interfaceId ||
831       interfaceId == type(IERC721Metadata).interfaceId ||
832       interfaceId == type(IERC721Enumerable).interfaceId ||
833       super.supportsInterface(interfaceId);
834   }
835 
836   /**
837    * @dev See {IERC721-balanceOf}.
838    */
839   function balanceOf(address owner) public view override returns (uint256) {
840     require(owner != address(0), "ERC721A: balance query for the zero address");
841     return uint256(_addressData[owner].balance);
842   }
843 
844   function _numberMinted(address owner) internal view returns (uint256) {
845     require(
846       owner != address(0),
847       "ERC721A: number minted query for the zero address"
848     );
849     return uint256(_addressData[owner].numberMinted);
850   }
851 
852   function ownershipOf(uint256 tokenId)
853     internal
854     view
855     returns (TokenOwnership memory)
856   {
857     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
858 
859     uint256 lowestTokenToCheck;
860     if (tokenId >= maxBatchSize) {
861       lowestTokenToCheck = tokenId - maxBatchSize + 1;
862     }
863 
864     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
865       TokenOwnership memory ownership = _ownerships[curr];
866       if (ownership.addr != address(0)) {
867         return ownership;
868       }
869     }
870 
871     revert("ERC721A: unable to determine the owner of token");
872   }
873 
874   /**
875    * @dev See {IERC721-ownerOf}.
876    */
877   function ownerOf(uint256 tokenId) public view override returns (address) {
878     return ownershipOf(tokenId).addr;
879   }
880 
881   /**
882    * @dev See {IERC721Metadata-name}.
883    */
884   function name() public view virtual override returns (string memory) {
885     return _name;
886   }
887 
888   /**
889    * @dev See {IERC721Metadata-symbol}.
890    */
891   function symbol() public view virtual override returns (string memory) {
892     return _symbol;
893   }
894 
895   /**
896    * @dev See {IERC721Metadata-tokenURI}.
897    */
898   function tokenURI(uint256 tokenId)
899     public
900     view
901     virtual
902     override
903     returns (string memory)
904   {
905     require(
906       _exists(tokenId),
907       "ERC721Metadata: URI query for nonexistent token"
908     );
909 
910     string memory baseURI = _baseURI();
911     return
912       bytes(baseURI).length > 0
913         ? string(abi.encodePacked(baseURI, tokenId.toString()))
914         : "";
915   }
916 
917   /**
918    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
919    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
920    * by default, can be overriden in child contracts.
921    */
922   function _baseURI() internal view virtual returns (string memory) {
923     return "";
924   }
925 
926   /**
927    * @dev See {IERC721-approve}.
928    */
929   function approve(address to, uint256 tokenId) public override {
930     address owner = ERC721A.ownerOf(tokenId);
931     require(to != owner, "ERC721A: approval to current owner");
932 
933     require(
934       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
935       "ERC721A: approve caller is not owner nor approved for all"
936     );
937 
938     _approve(to, tokenId, owner);
939   }
940 
941   /**
942    * @dev See {IERC721-getApproved}.
943    */
944   function getApproved(uint256 tokenId) public view override returns (address) {
945     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
946 
947     return _tokenApprovals[tokenId];
948   }
949 
950   /**
951    * @dev See {IERC721-setApprovalForAll}.
952    */
953   function setApprovalForAll(address operator, bool approved) public override {
954     require(operator != _msgSender(), "ERC721A: approve to caller");
955 
956     _operatorApprovals[_msgSender()][operator] = approved;
957     emit ApprovalForAll(_msgSender(), operator, approved);
958   }
959 
960   /**
961    * @dev See {IERC721-isApprovedForAll}.
962    */
963   function isApprovedForAll(address owner, address operator)
964     public
965     view
966     virtual
967     override
968     returns (bool)
969   {
970     return _operatorApprovals[owner][operator];
971   }
972 
973   /**
974    * @dev See {IERC721-transferFrom}.
975    */
976   function transferFrom(
977     address from,
978     address to,
979     uint256 tokenId
980   ) public override {
981     _transfer(from, to, tokenId);
982   }
983 
984   /**
985    * @dev See {IERC721-safeTransferFrom}.
986    */
987   function safeTransferFrom(
988     address from,
989     address to,
990     uint256 tokenId
991   ) public override {
992     safeTransferFrom(from, to, tokenId, "");
993   }
994 
995   /**
996    * @dev See {IERC721-safeTransferFrom}.
997    */
998   function safeTransferFrom(
999     address from,
1000     address to,
1001     uint256 tokenId,
1002     bytes memory _data
1003   ) public override {
1004     _transfer(from, to, tokenId);
1005     require(
1006       _checkOnERC721Received(from, to, tokenId, _data),
1007       "ERC721A: transfer to non ERC721Receiver implementer"
1008     );
1009   }
1010 
1011   /**
1012    * @dev Returns whether `tokenId` exists.
1013    *
1014    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1015    *
1016    * Tokens start existing when they are minted (`_mint`),
1017    */
1018   function _exists(uint256 tokenId) internal view returns (bool) {
1019     return tokenId < currentIndex;
1020   }
1021 
1022   function _safeMint(address to, uint256 quantity) internal {
1023     _safeMint(to, quantity, "");
1024   }
1025 
1026   /**
1027    * @dev Mints `quantity` tokens and transfers them to `to`.
1028    *
1029    * Requirements:
1030    *
1031    * - there must be `quantity` tokens remaining unminted in the total collection.
1032    * - `to` cannot be the zero address.
1033    * - `quantity` cannot be larger than the max batch size.
1034    *
1035    * Emits a {Transfer} event.
1036    */
1037   function _safeMint(
1038     address to,
1039     uint256 quantity,
1040     bytes memory _data
1041   ) internal {
1042     uint256 startTokenId = currentIndex;
1043     require(to != address(0), "ERC721A: mint to the zero address");
1044     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1045     require(!_exists(startTokenId), "ERC721A: token already minted");
1046     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1047 
1048     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1049 
1050     AddressData memory addressData = _addressData[to];
1051     _addressData[to] = AddressData(
1052       addressData.balance + uint128(quantity),
1053       addressData.numberMinted + uint128(quantity)
1054     );
1055     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1056 
1057     uint256 updatedIndex = startTokenId;
1058 
1059     for (uint256 i = 0; i < quantity; i++) {
1060       emit Transfer(address(0), to, updatedIndex);
1061       require(
1062         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1063         "ERC721A: transfer to non ERC721Receiver implementer"
1064       );
1065       updatedIndex++;
1066     }
1067 
1068     currentIndex = updatedIndex;
1069     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1070   }
1071 
1072   /**
1073    * @dev Transfers `tokenId` from `from` to `to`.
1074    *
1075    * Requirements:
1076    *
1077    * - `to` cannot be the zero address.
1078    * - `tokenId` token must be owned by `from`.
1079    *
1080    * Emits a {Transfer} event.
1081    */
1082   function _transfer(
1083     address from,
1084     address to,
1085     uint256 tokenId
1086   ) private {
1087     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1088 
1089     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1090       getApproved(tokenId) == _msgSender() ||
1091       isApprovedForAll(prevOwnership.addr, _msgSender()));
1092 
1093     require(
1094       isApprovedOrOwner,
1095       "ERC721A: transfer caller is not owner nor approved"
1096     );
1097 
1098     require(
1099       prevOwnership.addr == from,
1100       "ERC721A: transfer from incorrect owner"
1101     );
1102     require(to != address(0), "ERC721A: transfer to the zero address");
1103 
1104     _beforeTokenTransfers(from, to, tokenId, 1);
1105 
1106     // Clear approvals from the previous owner
1107     _approve(address(0), tokenId, prevOwnership.addr);
1108 
1109     _addressData[from].balance -= 1;
1110     _addressData[to].balance += 1;
1111     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1112 
1113     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1114     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1115     uint256 nextTokenId = tokenId + 1;
1116     if (_ownerships[nextTokenId].addr == address(0)) {
1117       if (_exists(nextTokenId)) {
1118         _ownerships[nextTokenId] = TokenOwnership(
1119           prevOwnership.addr,
1120           prevOwnership.startTimestamp
1121         );
1122       }
1123     }
1124 
1125     emit Transfer(from, to, tokenId);
1126     _afterTokenTransfers(from, to, tokenId, 1);
1127   }
1128 
1129   /**
1130    * @dev Approve `to` to operate on `tokenId`
1131    *
1132    * Emits a {Approval} event.
1133    */
1134   function _approve(
1135     address to,
1136     uint256 tokenId,
1137     address owner
1138   ) private {
1139     _tokenApprovals[tokenId] = to;
1140     emit Approval(owner, to, tokenId);
1141   }
1142 
1143   uint256 public nextOwnerToExplicitlySet = 0;
1144 
1145   /**
1146    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1147    */
1148   function _setOwnersExplicit(uint256 quantity) internal {
1149     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1150     require(quantity > 0, "quantity must be nonzero");
1151     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1152     if (endIndex > collectionSize - 1) {
1153       endIndex = collectionSize - 1;
1154     }
1155     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1156     require(_exists(endIndex), "not enough minted yet for this cleanup");
1157     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1158       if (_ownerships[i].addr == address(0)) {
1159         TokenOwnership memory ownership = ownershipOf(i);
1160         _ownerships[i] = TokenOwnership(
1161           ownership.addr,
1162           ownership.startTimestamp
1163         );
1164       }
1165     }
1166     nextOwnerToExplicitlySet = endIndex + 1;
1167   }
1168 
1169   /**
1170    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1171    * The call is not executed if the target address is not a contract.
1172    *
1173    * @param from address representing the previous owner of the given token ID
1174    * @param to target address that will receive the tokens
1175    * @param tokenId uint256 ID of the token to be transferred
1176    * @param _data bytes optional data to send along with the call
1177    * @return bool whether the call correctly returned the expected magic value
1178    */
1179   function _checkOnERC721Received(
1180     address from,
1181     address to,
1182     uint256 tokenId,
1183     bytes memory _data
1184   ) private returns (bool) {
1185     if (to.isContract()) {
1186       try
1187         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1188       returns (bytes4 retval) {
1189         return retval == IERC721Receiver(to).onERC721Received.selector;
1190       } catch (bytes memory reason) {
1191         if (reason.length == 0) {
1192           revert("ERC721A: transfer to non ERC721Receiver implementer");
1193         } else {
1194           assembly {
1195             revert(add(32, reason), mload(reason))
1196           }
1197         }
1198       }
1199     } else {
1200       return true;
1201     }
1202   }
1203 
1204   /**
1205    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1206    *
1207    * startTokenId - the first token id to be transferred
1208    * quantity - the amount to be transferred
1209    *
1210    * Calling conditions:
1211    *
1212    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1213    * transferred to `to`.
1214    * - When `from` is zero, `tokenId` will be minted for `to`.
1215    */
1216   function _beforeTokenTransfers(
1217     address from,
1218     address to,
1219     uint256 startTokenId,
1220     uint256 quantity
1221   ) internal virtual {}
1222 
1223   /**
1224    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1225    * minting.
1226    *
1227    * startTokenId - the first token id to be transferred
1228    * quantity - the amount to be transferred
1229    *
1230    * Calling conditions:
1231    *
1232    * - when `from` and `to` are both non-zero.
1233    * - `from` and `to` are never both zero.
1234    */
1235   function _afterTokenTransfers(
1236     address from,
1237     address to,
1238     uint256 startTokenId,
1239     uint256 quantity
1240   ) internal virtual {}
1241 }
1242 
1243 // File: @openzeppelin/contracts/access/Ownable.sol
1244 
1245 
1246 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1247 
1248 pragma solidity ^0.8.0;
1249 
1250 
1251 /**
1252  * @dev Contract module which provides a basic access control mechanism, where
1253  * there is an account (an owner) that can be granted exclusive access to
1254  * specific functions.
1255  *
1256  * By default, the owner account will be the one that deploys the contract. This
1257  * can later be changed with {transferOwnership}.
1258  *
1259  * This module is used through inheritance. It will make available the modifier
1260  * `onlyOwner`, which can be applied to your functions to restrict their use to
1261  * the owner.
1262  */
1263 abstract contract Ownable is Context {
1264     address private _owner;
1265 
1266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1267 
1268     /**
1269      * @dev Initializes the contract setting the deployer as the initial owner.
1270      */
1271     constructor() {
1272         _transferOwnership(_msgSender());
1273     }
1274 
1275     /**
1276      * @dev Returns the address of the current owner.
1277      */
1278     function owner() public view virtual returns (address) {
1279         return _owner;
1280     }
1281 
1282     /**
1283      * @dev Throws if called by any account other than the owner.
1284      */
1285     modifier onlyOwner() {
1286         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1287         _;
1288     }
1289 
1290     /**
1291      * @dev Leaves the contract without owner. It will not be possible to call
1292      * `onlyOwner` functions anymore. Can only be called by the current owner.
1293      *
1294      * NOTE: Renouncing ownership will leave the contract without an owner,
1295      * thereby removing any functionality that is only available to the owner.
1296      */
1297     function renounceOwnership() public virtual onlyOwner {
1298         _transferOwnership(address(0));
1299     }
1300 
1301     /**
1302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1303      * Can only be called by the current owner.
1304      */
1305     function transferOwnership(address newOwner) public virtual onlyOwner {
1306         require(newOwner != address(0), "Ownable: new owner is the zero address");
1307         _transferOwnership(newOwner);
1308     }
1309 
1310     /**
1311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1312      * Internal function without access restriction.
1313      */
1314     function _transferOwnership(address newOwner) internal virtual {
1315         address oldOwner = _owner;
1316         _owner = newOwner;
1317         emit OwnershipTransferred(oldOwner, newOwner);
1318     }
1319 }
1320 
1321 // File: contracts/KillChallenge.sol
1322 
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 
1327 
1328 
1329 
1330 contract KillChallenge is Ownable, ERC721A, ReentrancyGuard {
1331     using Strings for uint256;
1332 
1333     uint64 public price;
1334     uint32 public startTime;
1335     uint256 public immutable maxPerAddressDuringMint;
1336     uint public limitedFreeMintCounter;
1337     mapping(address => uint) public freeMintRecord;
1338 
1339     constructor(
1340         uint256 maxBatchSize_,
1341         uint256 collectionSize_,
1342         uint64 price_
1343     )
1344         ERC721A(
1345             "KillChallenge",
1346             "KILLCHALLENGE",
1347             maxBatchSize_,
1348             collectionSize_
1349         )
1350     {
1351         maxPerAddressDuringMint = maxBatchSize_;
1352         price = price_;
1353     }
1354 
1355     modifier callerIsUser() {
1356         require(tx.origin == msg.sender, "The caller is another contract");
1357         _;
1358     }
1359 
1360     function devMint(address to, uint256 quantity) external onlyOwner {
1361         require(
1362             numberMinted(to) + quantity <= maxPerAddressDuringMint,
1363             "can not mint this many"
1364         );
1365         freeMintRecord[to] += quantity;
1366         limitedFreeMintCounter += quantity;
1367         _safeMint(to, quantity);
1368     }
1369 
1370     function publicSaleMint(uint256 quantity) external payable callerIsUser {
1371         uint256 price_ = uint256(price);
1372         uint256 startTime_ = uint256(startTime);
1373 
1374         require(
1375             isPublicSaleOn(price_, startTime_),
1376             "public sale has not begun yet"
1377         );
1378         require(
1379             totalSupply() + quantity <= collectionSize,
1380             "reached max supply"
1381         );
1382         require(
1383             numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1384             "can not mint this many"
1385         );
1386 
1387         uint freeCount = 0;
1388         if (freeMintRecord[msg.sender] == 0 && limitedFreeMintCounter < 3000) {
1389             freeCount = 1;
1390             freeMintRecord[msg.sender] += freeCount;
1391             limitedFreeMintCounter++;
1392         }
1393 
1394         _safeMint(msg.sender, quantity);
1395         refundIfOver(price_ * (quantity - freeCount));
1396     }
1397 
1398     function refundIfOver(uint256 price_) private {
1399         require(msg.value >= price_, "Need to send more ETH.");
1400         if (msg.value > price_) {
1401             payable(msg.sender).transfer(msg.value - price_);
1402         }
1403     }
1404 
1405     function updateStartTime(uint32 startTime_) external onlyOwner {
1406         startTime = startTime_;
1407     }
1408 
1409     function isPublicSaleOn(uint256 publicPriceWei, uint256 publicSaleStartTime)
1410         public
1411         view
1412         returns (bool)
1413     {
1414         return publicPriceWei != 0 && publicSaleStartTime > 0 && block.timestamp >= publicSaleStartTime;
1415     }
1416 
1417     // metadata URI
1418     string private _baseTokenURI;
1419 
1420     function _baseURI() internal view virtual override returns (string memory) {
1421         return _baseTokenURI;
1422     }
1423 
1424     function setBaseURI(string calldata baseURI) external onlyOwner {
1425         _baseTokenURI = baseURI;
1426     }
1427 
1428     function tokenURI(uint256 tokenId)
1429         public
1430         view
1431         virtual
1432         override
1433         returns (string memory)
1434     {
1435         require(
1436             _exists(tokenId),
1437             "ERC721Metadata: URI query for nonexistent token"
1438         );
1439 
1440         return
1441             string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
1442     }
1443 
1444     function withdrawMoney() external onlyOwner nonReentrant {
1445         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1446         require(success, "Transfer failed.");
1447     }
1448 
1449     function numberMinted(address owner) public view returns (uint256) {
1450         return _numberMinted(owner);
1451     }
1452 
1453     function getOwnershipData(uint256 tokenId)
1454         external
1455         view
1456         returns (TokenOwnership memory)
1457     {
1458         return ownershipOf(tokenId);
1459     }
1460 }