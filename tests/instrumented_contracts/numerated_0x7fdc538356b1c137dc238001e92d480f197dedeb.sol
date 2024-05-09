1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
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
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
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
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
297 
298 
299 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId,
443         bytes calldata data
444     ) external;
445 
446     /**
447      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
448      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must exist and be owned by `from`.
455      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
456      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
457      *
458      * Emits a {Transfer} event.
459      */
460     function safeTransferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Transfers `tokenId` token from `from` to `to`.
468      *
469      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must be owned by `from`.
476      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
477      *
478      * Emits a {Transfer} event.
479      */
480     function transferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
488      * The approval is cleared when the token is transferred.
489      *
490      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
491      *
492      * Requirements:
493      *
494      * - The caller must own the token or be an approved operator.
495      * - `tokenId` must exist.
496      *
497      * Emits an {Approval} event.
498      */
499     function approve(address to, uint256 tokenId) external;
500 
501     /**
502      * @dev Approve or remove `operator` as an operator for the caller.
503      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
504      *
505      * Requirements:
506      *
507      * - The `operator` cannot be the caller.
508      *
509      * Emits an {ApprovalForAll} event.
510      */
511     function setApprovalForAll(address operator, bool _approved) external;
512 
513     /**
514      * @dev Returns the account approved for `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function getApproved(uint256 tokenId) external view returns (address operator);
521 
522     /**
523      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
524      *
525      * See {setApprovalForAll}
526      */
527     function isApprovedForAll(address owner, address operator) external view returns (bool);
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
531 
532 
533 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Enumerable is IERC721 {
543     /**
544      * @dev Returns the total amount of tokens stored by the contract.
545      */
546     function totalSupply() external view returns (uint256);
547 
548     /**
549      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
550      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
551      */
552     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
553 
554     /**
555      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
556      * Use along with {totalSupply} to enumerate all tokens.
557      */
558     function tokenByIndex(uint256 index) external view returns (uint256);
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 interface IERC721Metadata is IERC721 {
574     /**
575      * @dev Returns the token collection name.
576      */
577     function name() external view returns (string memory);
578 
579     /**
580      * @dev Returns the token collection symbol.
581      */
582     function symbol() external view returns (string memory);
583 
584     /**
585      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
586      */
587     function tokenURI(uint256 tokenId) external view returns (string memory);
588 }
589 
590 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Contract module that helps prevent reentrant calls to a function.
599  *
600  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
601  * available, which can be applied to functions to make sure there are no nested
602  * (reentrant) calls to them.
603  *
604  * Note that because there is a single `nonReentrant` guard, functions marked as
605  * `nonReentrant` may not call one another. This can be worked around by making
606  * those functions `private`, and then adding `external` `nonReentrant` entry
607  * points to them.
608  *
609  * TIP: If you would like to learn more about reentrancy and alternative ways
610  * to protect against it, check out our blog post
611  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
612  */
613 abstract contract ReentrancyGuard {
614     // Booleans are more expensive than uint256 or any type that takes up a full
615     // word because each write operation emits an extra SLOAD to first read the
616     // slot's contents, replace the bits taken up by the boolean, and then write
617     // back. This is the compiler's defense against contract upgrades and
618     // pointer aliasing, and it cannot be disabled.
619 
620     // The values being non-zero value makes deployment a bit more expensive,
621     // but in exchange the refund on every call to nonReentrant will be lower in
622     // amount. Since refunds are capped to a percentage of the total
623     // transaction's gas, it is best to keep them low in cases like this one, to
624     // increase the likelihood of the full refund coming into effect.
625     uint256 private constant _NOT_ENTERED = 1;
626     uint256 private constant _ENTERED = 2;
627 
628     uint256 private _status;
629 
630     constructor() {
631         _status = _NOT_ENTERED;
632     }
633 
634     /**
635      * @dev Prevents a contract from calling itself, directly or indirectly.
636      * Calling a `nonReentrant` function from another `nonReentrant`
637      * function is not supported. It is possible to prevent this from happening
638      * by making the `nonReentrant` function external, and making it call a
639      * `private` function that does the actual work.
640      */
641     modifier nonReentrant() {
642         // On the first call to nonReentrant, _notEntered will be true
643         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
644 
645         // Any calls to nonReentrant after this point will fail
646         _status = _ENTERED;
647 
648         _;
649 
650         // By storing the original value once again, a refund is triggered (see
651         // https://eips.ethereum.org/EIPS/eip-2200)
652         _status = _NOT_ENTERED;
653     }
654 }
655 
656 // File: @openzeppelin/contracts/utils/Context.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 /**
664  * @dev Provides information about the current execution context, including the
665  * sender of the transaction and its data. While these are generally available
666  * via msg.sender and msg.data, they should not be accessed in such a direct
667  * manner, since when dealing with meta-transactions the account sending and
668  * paying for execution may not be the actual sender (as far as an application
669  * is concerned).
670  *
671  * This contract is only required for intermediate, library-like contracts.
672  */
673 abstract contract Context {
674     function _msgSender() internal view virtual returns (address) {
675         return msg.sender;
676     }
677 
678     function _msgData() internal view virtual returns (bytes calldata) {
679         return msg.data;
680     }
681 }
682 
683 // File: ERC721S.sol
684 
685 
686 
687 pragma solidity ^0.8.0;
688 
689 
690 
691 
692 
693 
694 
695 
696 
697 /**
698  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
699  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
700  *
701  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
702  *
703  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
704  *
705  * Does not support burning tokens to address(0).
706  */
707 contract ERC721S is
708   Context,
709   ERC165,
710   IERC721,
711   IERC721Metadata,
712   IERC721Enumerable
713 {
714   using Address for address;
715   using Strings for uint256;
716 
717   struct AddressData {
718     uint128 balance;
719     uint128 numberMinted;
720   }
721 
722   uint256 private currentIndex = 0;
723 
724   uint256 internal immutable collectionSize;
725   uint256 internal immutable maxBatchSize;
726 
727   // Token name
728   string private _name;
729 
730   // Token symbol
731   string private _symbol;
732 
733   // Mapping from token ID to ownership details
734   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
735   mapping(uint256 => address) private _ownerships;
736 
737   // Mapping owner address to address data
738   mapping(address => AddressData) private _addressData;
739 
740   // Mapping from token ID to approved address
741   mapping(uint256 => address) private _tokenApprovals;
742 
743   // Mapping from owner to operator approvals
744   mapping(address => mapping(address => bool)) private _operatorApprovals;
745 
746   /**
747    * @dev
748    * `maxBatchSize` refers to how much a minter can mint at a time.
749    * `collectionSize_` refers to how many tokens are in the collection.
750    */
751   constructor(
752     string memory name_,
753     string memory symbol_,
754     uint256 maxBatchSize_,
755     uint256 collectionSize_
756   ) {
757     require(
758       collectionSize_ > 0,
759       "ERC721S: collection must have a nonzero supply"
760     );
761     require(maxBatchSize_ > 0, "ERC721S: max batch size must be nonzero");
762     _name = name_;
763     _symbol = symbol_;
764     maxBatchSize = maxBatchSize_;
765     collectionSize = collectionSize_;
766   }
767 
768   /**
769    * @dev See {IERC721Enumerable-totalSupply}.
770    */
771   function totalSupply() public view override returns (uint256) {
772     return currentIndex;
773   }
774 
775   /**
776    * @dev See {IERC721Enumerable-tokenByIndex}.
777    */
778   function tokenByIndex(uint256 index) public view override returns (uint256) {
779     require(index < totalSupply(), "ERC721S: global index out of bounds");
780     return index;
781   }
782 
783   /**
784    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
785    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
786    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
787    */
788   function tokenOfOwnerByIndex(address owner, uint256 index)
789     public
790     view
791     override
792     returns (uint256)
793   {
794     require(index < balanceOf(owner), "ERC721S: owner index out of bounds");
795     uint256 numMintedSoFar = totalSupply();
796     uint256 tokenIdsIdx = 0;
797     address currOwnershipAddr = address(0);
798     for (uint256 i = 0; i < numMintedSoFar; i++) {
799       address ownership = _ownerships[i];
800       if (ownership != address(0)) {
801         currOwnershipAddr = ownership;
802       }
803       if (currOwnershipAddr == owner) {
804         if (tokenIdsIdx == index) {
805           return i;
806         }
807         tokenIdsIdx++;
808       }
809     }
810     revert("ERC721S: unable to get token of owner by index");
811   }
812 
813   /**
814    * @dev See {IERC165-supportsInterface}.
815    */
816   function supportsInterface(bytes4 interfaceId)
817     public
818     view
819     virtual
820     override(ERC165, IERC165)
821     returns (bool)
822   {
823     return
824       interfaceId == type(IERC721).interfaceId ||
825       interfaceId == type(IERC721Metadata).interfaceId ||
826       interfaceId == type(IERC721Enumerable).interfaceId ||
827       super.supportsInterface(interfaceId);
828   }
829 
830   /**
831    * @dev See {IERC721-balanceOf}.
832    */
833   function balanceOf(address owner) public view override returns (uint256) {
834     require(owner != address(0), "ERC721S: balance query for the zero address");
835     return uint256(_addressData[owner].balance);
836   }
837 
838   function _numberMinted(address owner) internal view returns (uint256) {
839     require(
840       owner != address(0),
841       "ERC721S: number minted query for the zero address"
842     );
843     return uint256(_addressData[owner].numberMinted);
844   }
845 
846   function ownershipOf(uint256 tokenId)
847     internal
848     view
849     returns (address)
850   {
851     require(_exists(tokenId), "ERC721S: owner query for nonexistent token");
852 
853     uint256 lowestTokenToCheck;
854     if (tokenId >= maxBatchSize) {
855       lowestTokenToCheck = tokenId - maxBatchSize + 1;
856     }
857 
858     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
859       address ownership = _ownerships[curr];
860       if (ownership != address(0)) {
861         return ownership;
862       }
863     }
864 
865     revert("ERC721S: unable to determine the owner of token");
866   }
867 
868   /**
869    * @dev See {IERC721-ownerOf}.
870    */
871   function ownerOf(uint256 tokenId) public view override returns (address) {
872     return ownershipOf(tokenId);
873   }
874 
875   /**
876    * @dev See {IERC721Metadata-name}.
877    */
878   function name() public view virtual override returns (string memory) {
879     return _name;
880   }
881 
882   /**
883    * @dev See {IERC721Metadata-symbol}.
884    */
885   function symbol() public view virtual override returns (string memory) {
886     return _symbol;
887   }
888 
889   /**
890    * @dev See {IERC721Metadata-tokenURI}.
891    */
892   function tokenURI(uint256 tokenId)
893     public
894     view
895     virtual
896     override
897     returns (string memory)
898   {
899     require(
900       _exists(tokenId),
901       "ERC721Metadata: URI query for nonexistent token"
902     );
903 
904     string memory baseURI = _baseURI();
905     return
906       bytes(baseURI).length > 0
907         ? string(abi.encodePacked(baseURI, tokenId.toString()))
908         : "";
909   }
910 
911   /**
912    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
913    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
914    * by default, can be overriden in child contracts.
915    */
916   function _baseURI() internal view virtual returns (string memory) {
917     return "";
918   }
919 
920   /**
921    * @dev See {IERC721-approve}.
922    */
923   function approve(address to, uint256 tokenId) public override {
924     address owner = ERC721S.ownerOf(tokenId);
925     require(to != owner, "ERC721S: approval to current owner");
926 
927     require(
928       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
929       "ERC721S: approve caller is not owner nor approved for all"
930     );
931 
932     _approve(to, tokenId, owner);
933   }
934 
935   /**
936    * @dev See {IERC721-getApproved}.
937    */
938   function getApproved(uint256 tokenId) public view override returns (address) {
939     require(_exists(tokenId), "ERC721S: approved query for nonexistent token");
940 
941     return _tokenApprovals[tokenId];
942   }
943 
944   /**
945    * @dev See {IERC721-setApprovalForAll}.
946    */
947   function setApprovalForAll(address operator, bool approved) public override {
948     require(operator != _msgSender(), "ERC721S: approve to caller");
949 
950     _operatorApprovals[_msgSender()][operator] = approved;
951     emit ApprovalForAll(_msgSender(), operator, approved);
952   }
953 
954   /**
955    * @dev See {IERC721-isApprovedForAll}.
956    */
957   function isApprovedForAll(address owner, address operator)
958     public
959     view
960     virtual
961     override
962     returns (bool)
963   {
964     return _operatorApprovals[owner][operator];
965   }
966 
967   /**
968    * @dev See {IERC721-transferFrom}.
969    */
970   function transferFrom(
971     address from,
972     address to,
973     uint256 tokenId
974   ) public override {
975     _transfer(from, to, tokenId);
976   }
977 
978   /**
979    * @dev See {IERC721-safeTransferFrom}.
980    */
981   function safeTransferFrom(
982     address from,
983     address to,
984     uint256 tokenId
985   ) public override {
986     safeTransferFrom(from, to, tokenId, "");
987   }
988 
989   /**
990    * @dev See {IERC721-safeTransferFrom}.
991    */
992   function safeTransferFrom(
993     address from,
994     address to,
995     uint256 tokenId,
996     bytes memory _data
997   ) public override {
998     _transfer(from, to, tokenId);
999     require(
1000       _checkOnERC721Received(from, to, tokenId, _data),
1001       "ERC721S: transfer to non ERC721Receiver implementer"
1002     );
1003   }
1004 
1005   /**
1006    * @dev Returns whether `tokenId` exists.
1007    *
1008    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1009    *
1010    * Tokens start existing when they are minted (`_mint`),
1011    */
1012   function _exists(uint256 tokenId) internal view returns (bool) {
1013     return tokenId < currentIndex;
1014   }
1015 
1016   function _safeMint(address to, uint256 quantity) internal {
1017     _safeMint(to, quantity, "");
1018   }
1019 
1020   /**
1021    * @dev Mints `quantity` tokens and transfers them to `to`.
1022    *
1023    * Requirements:
1024    *
1025    * - there must be `quantity` tokens remaining unminted in the total collection.
1026    * - `to` cannot be the zero address.
1027    * - `quantity` cannot be larger than the max batch size.
1028    *
1029    * Emits a {Transfer} event.
1030    */
1031   function _safeMint(
1032     address to,
1033     uint256 quantity,
1034     bytes memory _data
1035   ) internal {
1036     uint256 startTokenId = currentIndex;
1037     require(to != address(0), "ERC721S: mint to the zero address");
1038     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1039     require(!_exists(startTokenId), "ERC721S: token already minted");
1040     require(quantity <= maxBatchSize, "ERC721S: quantity to mint too high");
1041 
1042     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1043 
1044     AddressData memory addressData = _addressData[to];
1045     _addressData[to] = AddressData(
1046       addressData.balance + uint128(quantity),
1047       addressData.numberMinted + uint128(quantity)
1048     );
1049     _ownerships[startTokenId] = to;
1050 
1051     uint256 updatedIndex = startTokenId;
1052 
1053     for (uint256 i = 0; i < quantity; i++) {
1054       emit Transfer(address(0), to, updatedIndex);
1055       require(
1056         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1057         "ERC721S: transfer to non ERC721Receiver implementer"
1058       );
1059       updatedIndex++;
1060     }
1061 
1062     currentIndex = updatedIndex;
1063     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1064   }
1065 
1066   /**
1067    * @dev Transfers `tokenId` from `from` to `to`.
1068    *
1069    * Requirements:
1070    *
1071    * - `to` cannot be the zero address.
1072    * - `tokenId` token must be owned by `from`.
1073    *
1074    * Emits a {Transfer} event.
1075    */
1076   function _transfer(
1077     address from,
1078     address to,
1079     uint256 tokenId
1080   ) private {
1081     address prevOwnership = ownershipOf(tokenId);
1082 
1083     bool isApprovedOrOwner = (_msgSender() == prevOwnership ||
1084       getApproved(tokenId) == _msgSender() ||
1085       isApprovedForAll(prevOwnership, _msgSender()));
1086 
1087     require(
1088       isApprovedOrOwner,
1089       "ERC721S: transfer caller is not owner nor approved"
1090     );
1091 
1092     require(
1093       prevOwnership == from,
1094       "ERC721S: transfer from incorrect owner"
1095     );
1096     require(to != address(0), "ERC721S: transfer to the zero address");
1097 
1098     _beforeTokenTransfers(from, to, tokenId, 1);
1099 
1100     // Clear approvals from the previous owner
1101     _approve(address(0), tokenId, prevOwnership);
1102 
1103     _addressData[from].balance -= 1;
1104     _addressData[to].balance += 1;
1105     _ownerships[tokenId] = to;
1106 
1107     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1108     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1109     uint256 nextTokenId = tokenId + 1;
1110     if (_ownerships[nextTokenId] == address(0)) {
1111       if (_exists(nextTokenId)) {
1112         _ownerships[nextTokenId] = prevOwnership;
1113       }
1114     }
1115 
1116     emit Transfer(from, to, tokenId);
1117     _afterTokenTransfers(from, to, tokenId, 1);
1118   }
1119 
1120   /**
1121    * @dev Approve `to` to operate on `tokenId`
1122    *
1123    * Emits a {Approval} event.
1124    */
1125   function _approve(
1126     address to,
1127     uint256 tokenId,
1128     address owner
1129   ) private {
1130     _tokenApprovals[tokenId] = to;
1131     emit Approval(owner, to, tokenId);
1132   }
1133 
1134   uint256 public nextOwnerToExplicitlySet = 0;
1135 
1136   /**
1137    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1138    */
1139   function _setOwnersExplicit(uint256 quantity) internal {
1140     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1141     require(quantity > 0, "quantity must be nonzero");
1142     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1143     if (endIndex > collectionSize - 1) {
1144       endIndex = collectionSize - 1;
1145     }
1146     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1147     require(_exists(endIndex), "not enough minted yet for this cleanup");
1148     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1149       if (_ownerships[i] == address(0)) {
1150         address ownership = ownershipOf(i);
1151         _ownerships[i] = ownership;
1152       }
1153     }
1154     nextOwnerToExplicitlySet = endIndex + 1;
1155   }
1156 
1157   /**
1158    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1159    * The call is not executed if the target address is not a contract.
1160    *
1161    * @param from address representing the previous owner of the given token ID
1162    * @param to target address that will receive the tokens
1163    * @param tokenId uint256 ID of the token to be transferred
1164    * @param _data bytes optional data to send along with the call
1165    * @return bool whether the call correctly returned the expected magic value
1166    */
1167   function _checkOnERC721Received(
1168     address from,
1169     address to,
1170     uint256 tokenId,
1171     bytes memory _data
1172   ) private returns (bool) {
1173     if (to.isContract()) {
1174       try
1175         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1176       returns (bytes4 retval) {
1177         return retval == IERC721Receiver(to).onERC721Received.selector;
1178       } catch (bytes memory reason) {
1179         if (reason.length == 0) {
1180           revert("ERC721S: transfer to non ERC721Receiver implementer");
1181         } else {
1182           assembly {
1183             revert(add(32, reason), mload(reason))
1184           }
1185         }
1186       }
1187     } else {
1188       return true;
1189     }
1190   }
1191 
1192   /**
1193    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1194    *
1195    * startTokenId - the first token id to be transferred
1196    * quantity - the amount to be transferred
1197    *
1198    * Calling conditions:
1199    *
1200    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1201    * transferred to `to`.
1202    * - When `from` is zero, `tokenId` will be minted for `to`.
1203    */
1204   function _beforeTokenTransfers(
1205     address from,
1206     address to,
1207     uint256 startTokenId,
1208     uint256 quantity
1209   ) internal virtual {}
1210 
1211   /**
1212    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1213    * minting.
1214    *
1215    * startTokenId - the first token id to be transferred
1216    * quantity - the amount to be transferred
1217    *
1218    * Calling conditions:
1219    *
1220    * - when `from` and `to` are both non-zero.
1221    * - `from` and `to` are never both zero.
1222    */
1223   function _afterTokenTransfers(
1224     address from,
1225     address to,
1226     uint256 startTokenId,
1227     uint256 quantity
1228   ) internal virtual {}
1229 }
1230 // File: @openzeppelin/contracts/access/Ownable.sol
1231 
1232 
1233 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1234 
1235 pragma solidity ^0.8.0;
1236 
1237 
1238 /**
1239  * @dev Contract module which provides a basic access control mechanism, where
1240  * there is an account (an owner) that can be granted exclusive access to
1241  * specific functions.
1242  *
1243  * By default, the owner account will be the one that deploys the contract. This
1244  * can later be changed with {transferOwnership}.
1245  *
1246  * This module is used through inheritance. It will make available the modifier
1247  * `onlyOwner`, which can be applied to your functions to restrict their use to
1248  * the owner.
1249  */
1250 abstract contract Ownable is Context {
1251     address private _owner;
1252 
1253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1254 
1255     /**
1256      * @dev Initializes the contract setting the deployer as the initial owner.
1257      */
1258     constructor() {
1259         _transferOwnership(_msgSender());
1260     }
1261 
1262     /**
1263      * @dev Returns the address of the current owner.
1264      */
1265     function owner() public view virtual returns (address) {
1266         return _owner;
1267     }
1268 
1269     /**
1270      * @dev Throws if called by any account other than the owner.
1271      */
1272     modifier onlyOwner() {
1273         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1274         _;
1275     }
1276 
1277     /**
1278      * @dev Leaves the contract without owner. It will not be possible to call
1279      * `onlyOwner` functions anymore. Can only be called by the current owner.
1280      *
1281      * NOTE: Renouncing ownership will leave the contract without an owner,
1282      * thereby removing any functionality that is only available to the owner.
1283      */
1284     function renounceOwnership() public virtual onlyOwner {
1285         _transferOwnership(address(0));
1286     }
1287 
1288     /**
1289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1290      * Can only be called by the current owner.
1291      */
1292     function transferOwnership(address newOwner) public virtual onlyOwner {
1293         require(newOwner != address(0), "Ownable: new owner is the zero address");
1294         _transferOwnership(newOwner);
1295     }
1296 
1297     /**
1298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1299      * Internal function without access restriction.
1300      */
1301     function _transferOwnership(address newOwner) internal virtual {
1302         address oldOwner = _owner;
1303         _owner = newOwner;
1304         emit OwnershipTransferred(oldOwner, newOwner);
1305     }
1306 }
1307 
1308 // File: sins_of_shadow_W_final.sol
1309 
1310 
1311 
1312 pragma solidity ^0.8.0;
1313 
1314 
1315 
1316 
1317 
1318 contract SINS is Ownable, ERC721S, ReentrancyGuard {
1319   using Strings for uint256;
1320 
1321   uint256 thePrice = 110000000000000000;
1322                       
1323   mapping (address => uint256) public _whitelist;
1324 
1325   bool public _whitelist_on = true;
1326 
1327   uint256 public current_mint_max = 377;
1328 
1329   uint256 public num_revealed = 0;
1330 
1331   string public _starterbaseTokenURI = "ipfs://Qmd2WCWVFrbsVVybb3MVnKtrQLzQdEgxC3mccS7xnzy9M9/";
1332 
1333   string _ending = ""; 
1334 
1335   constructor(
1336     uint256 maxBatchSize_,
1337     uint256 collectionSize_
1338   ) ERC721S("SINS", "SINS", maxBatchSize_, collectionSize_) {
1339   }
1340 
1341 
1342     modifier checkWhitelist(uint256 quantity) {
1343         if(_whitelist_on){
1344             require(_whitelist[_msgSender()] >= quantity,"Account needs to whitelist"); 
1345             _whitelist[_msgSender()] -= quantity;
1346             }
1347         _;
1348     }
1349     // set amount whitelisted for user
1350     function setWhitelistAmount(address account, uint256 amount) public onlyOwner{
1351         _whitelist[account] = amount;
1352     }
1353 
1354     // turn on/off whitelist
1355     function setWhitelistStatus(bool status) public onlyOwner{
1356         _whitelist_on = status;
1357     }
1358 
1359     function seedWhitelist(address[] memory addresses, uint256[] memory numSlots)
1360     external
1361     onlyOwner
1362     {
1363     require(
1364       addresses.length == numSlots.length,
1365       "addresses does not match numSlots length"
1366     );
1367 
1368     for (uint256 i = 0; i < addresses.length; i++) {
1369       _whitelist[addresses[i]] = numSlots[i];
1370       }
1371     }
1372 
1373     // set amount revealed 
1374     function setNumRevealed(uint256 amount) public onlyOwner{
1375         num_revealed = amount;
1376     }
1377 
1378   // set amount max mint
1379     function setMaxMint(uint256 amount) public onlyOwner{
1380         current_mint_max = amount;
1381     }
1382 
1383 
1384   function mint_multiple_with_nativecoin(uint256 quantity) external payable checkWhitelist(quantity){
1385 
1386     require(totalSupply() + quantity <= current_mint_max, "reached max current mint");
1387 
1388     require(msg.value >= thePrice, "Need to send more Value.");
1389 
1390     _safeMint(msg.sender, quantity);
1391     
1392   }
1393 
1394   function getNativePrice() public view returns(uint){
1395         return(thePrice);
1396   }
1397       
1398   function getAmmountMinted() public view returns(uint,uint){
1399         return(totalSupply(),current_mint_max);
1400   }
1401 
1402   function setPrice(uint256 price) public onlyOwner{
1403     thePrice = price; 
1404   }
1405 
1406   // // metadata URI
1407   string private _baseTokenURI = "ipfs://Qmd2WCWVFrbsVVybb3MVnKtrQLzQdEgxC3mccS7xnzy9M9/";
1408 
1409   function _baseURI() internal view virtual override returns (string memory) {
1410     return _baseTokenURI;
1411   }
1412 
1413   function setBaseURI(string calldata baseURI) external onlyOwner {
1414     _baseTokenURI = baseURI;
1415   }
1416 
1417   function setStarterURI(string calldata baseURI) external onlyOwner {
1418     _starterbaseTokenURI = baseURI;
1419   }
1420 
1421   function withdrawMoney() external onlyOwner nonReentrant {
1422     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1423     require(success, "Transfer failed.");
1424   }
1425 
1426   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1427     _setOwnersExplicit(quantity);
1428   }
1429 
1430   function numberMinted(address owner) public view returns (uint256) {
1431     return _numberMinted(owner);
1432   }
1433 
1434   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1435         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1436         // if the token is greater than the number revealed show the generic URI
1437         if (tokenId >= num_revealed){
1438             string memory temp_uri = _starterbaseTokenURI;
1439             return bytes(temp_uri).length > 0 ? string(abi.encodePacked(temp_uri, tokenId.toString(),_ending)) : "";
1440         }
1441         
1442         string memory baseURI = _baseTokenURI;
1443         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), _ending)) : "";
1444   }
1445 
1446 
1447 }