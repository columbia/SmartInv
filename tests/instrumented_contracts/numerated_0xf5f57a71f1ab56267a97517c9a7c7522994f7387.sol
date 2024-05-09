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
299 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
427      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
428      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
468      * The approval is cleared when the token is transferred.
469      *
470      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
471      *
472      * Requirements:
473      *
474      * - The caller must own the token or be an approved operator.
475      * - `tokenId` must exist.
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address to, uint256 tokenId) external;
480 
481     /**
482      * @dev Returns the account approved for `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function getApproved(uint256 tokenId) external view returns (address operator);
489 
490     /**
491      * @dev Approve or remove `operator` as an operator for the caller.
492      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
493      *
494      * Requirements:
495      *
496      * - The `operator` cannot be the caller.
497      *
498      * Emits an {ApprovalForAll} event.
499      */
500     function setApprovalForAll(address operator, bool _approved) external;
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes calldata data
527     ) external;
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
683 // File: contracts/ERC721A.sol
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
707 contract ERC721A is
708   Context,
709   ERC165,
710   IERC721,
711   IERC721Metadata,
712   IERC721Enumerable
713 {
714   using Address for address;
715   using Strings for uint256;
716 
717   struct TokenOwnership {
718     address addr;
719     uint64 startTimestamp;
720   }
721 
722   struct AddressData {
723     uint128 balance;
724     uint128 numberMinted;
725   }
726 
727   uint256 private currentIndex = 0;
728 
729   uint256 internal immutable collectionSize;
730   uint256 internal immutable maxBatchSize;
731 
732   // Token name
733   string private _name;
734 
735   // Token symbol
736   string private _symbol;
737 
738   // Mapping from token ID to ownership details
739   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
740   mapping(uint256 => TokenOwnership) private _ownerships;
741 
742   // Mapping owner address to address data
743   mapping(address => AddressData) private _addressData;
744 
745   // Mapping from token ID to approved address
746   mapping(uint256 => address) private _tokenApprovals;
747 
748   // Mapping from owner to operator approvals
749   mapping(address => mapping(address => bool)) private _operatorApprovals;
750 
751   /**
752    * @dev
753    * `maxBatchSize` refers to how much a minter can mint at a time.
754    * `collectionSize_` refers to how many tokens are in the collection.
755    */
756   constructor(
757     string memory name_,
758     string memory symbol_,
759     uint256 maxBatchSize_,
760     uint256 collectionSize_
761   ) {
762     require(
763       collectionSize_ > 0,
764       "ERC721A: collection must have a nonzero supply"
765     );
766     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
767     _name = name_;
768     _symbol = symbol_;
769     maxBatchSize = maxBatchSize_;
770     collectionSize = collectionSize_;
771   }
772 
773   /**
774    * @dev See {IERC721Enumerable-totalSupply}.
775    */
776   function totalSupply() public view override returns (uint256) {
777     return currentIndex;
778   }
779 
780   /**
781    * @dev See {IERC721Enumerable-tokenByIndex}.
782    */
783   function tokenByIndex(uint256 index) public view override returns (uint256) {
784     require(index < totalSupply(), "ERC721A: global index out of bounds");
785     return index;
786   }
787 
788   /**
789    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
790    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
791    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
792    */
793   function tokenOfOwnerByIndex(address owner, uint256 index)
794     public
795     view
796     override
797     returns (uint256)
798   {
799     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
800     uint256 numMintedSoFar = totalSupply();
801     uint256 tokenIdsIdx = 0;
802     address currOwnershipAddr = address(0);
803     for (uint256 i = 0; i < numMintedSoFar; i++) {
804       TokenOwnership memory ownership = _ownerships[i];
805       if (ownership.addr != address(0)) {
806         currOwnershipAddr = ownership.addr;
807       }
808       if (currOwnershipAddr == owner) {
809         if (tokenIdsIdx == index) {
810           return i;
811         }
812         tokenIdsIdx++;
813       }
814     }
815     revert("ERC721A: unable to get token of owner by index");
816   }
817 
818   /**
819    * @dev See {IERC165-supportsInterface}.
820    */
821   function supportsInterface(bytes4 interfaceId)
822     public
823     view
824     virtual
825     override(ERC165, IERC165)
826     returns (bool)
827   {
828     return
829       interfaceId == type(IERC721).interfaceId ||
830       interfaceId == type(IERC721Metadata).interfaceId ||
831       interfaceId == type(IERC721Enumerable).interfaceId ||
832       super.supportsInterface(interfaceId);
833   }
834 
835   /**
836    * @dev See {IERC721-balanceOf}.
837    */
838   function balanceOf(address owner) public view override returns (uint256) {
839     require(owner != address(0), "ERC721A: balance query for the zero address");
840     return uint256(_addressData[owner].balance);
841   }
842 
843   function _numberMinted(address owner) internal view returns (uint256) {
844     require(
845       owner != address(0),
846       "ERC721A: number minted query for the zero address"
847     );
848     return uint256(_addressData[owner].numberMinted);
849   }
850 
851   function ownershipOf(uint256 tokenId)
852     internal
853     view
854     returns (TokenOwnership memory)
855   {
856     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
857 
858     uint256 lowestTokenToCheck;
859     if (tokenId >= maxBatchSize) {
860       lowestTokenToCheck = tokenId - maxBatchSize + 1;
861     }
862 
863     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
864       TokenOwnership memory ownership = _ownerships[curr];
865       if (ownership.addr != address(0)) {
866         return ownership;
867       }
868     }
869 
870     revert("ERC721A: unable to determine the owner of token");
871   }
872 
873   /**
874    * @dev See {IERC721-ownerOf}.
875    */
876   function ownerOf(uint256 tokenId) public view override returns (address) {
877     return ownershipOf(tokenId).addr;
878   }
879 
880   /**
881    * @dev See {IERC721Metadata-name}.
882    */
883   function name() public view virtual override returns (string memory) {
884     return _name;
885   }
886 
887   /**
888    * @dev See {IERC721Metadata-symbol}.
889    */
890   function symbol() public view virtual override returns (string memory) {
891     return _symbol;
892   }
893 
894   /**
895    * @dev See {IERC721Metadata-tokenURI}.
896    */
897   function tokenURI(uint256 tokenId)
898     public
899     view
900     virtual
901     override
902     returns (string memory)
903   {
904     require(
905       _exists(tokenId),
906       "ERC721Metadata: URI query for nonexistent token"
907     );
908 
909     string memory baseURI = _baseURI();
910     return
911       bytes(baseURI).length > 0
912         ? string(abi.encodePacked(baseURI, tokenId.toString()))
913         : "";
914   }
915 
916   /**
917    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
918    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
919    * by default, can be overriden in child contracts.
920    */
921   function _baseURI() internal view virtual returns (string memory) {
922     return "";
923   }
924 
925   /**
926    * @dev See {IERC721-approve}.
927    */
928   function approve(address to, uint256 tokenId) public override {
929     address owner = ERC721A.ownerOf(tokenId);
930     require(to != owner, "ERC721A: approval to current owner");
931 
932     require(
933       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
934       "ERC721A: approve caller is not owner nor approved for all"
935     );
936 
937     _approve(to, tokenId, owner);
938   }
939 
940   /**
941    * @dev See {IERC721-getApproved}.
942    */
943   function getApproved(uint256 tokenId) public view override returns (address) {
944     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
945 
946     return _tokenApprovals[tokenId];
947   }
948 
949   /**
950    * @dev See {IERC721-setApprovalForAll}.
951    */
952   function setApprovalForAll(address operator, bool approved) public override {
953     require(operator != _msgSender(), "ERC721A: approve to caller");
954 
955     _operatorApprovals[_msgSender()][operator] = approved;
956     emit ApprovalForAll(_msgSender(), operator, approved);
957   }
958 
959   /**
960    * @dev See {IERC721-isApprovedForAll}.
961    */
962   function isApprovedForAll(address owner, address operator)
963     public
964     view
965     virtual
966     override
967     returns (bool)
968   {
969     return _operatorApprovals[owner][operator];
970   }
971 
972   /**
973    * @dev See {IERC721-transferFrom}.
974    */
975   function transferFrom(
976     address from,
977     address to,
978     uint256 tokenId
979   ) public override {
980     _transfer(from, to, tokenId);
981   }
982 
983   /**
984    * @dev See {IERC721-safeTransferFrom}.
985    */
986   function safeTransferFrom(
987     address from,
988     address to,
989     uint256 tokenId
990   ) public override {
991     safeTransferFrom(from, to, tokenId, "");
992   }
993 
994   /**
995    * @dev See {IERC721-safeTransferFrom}.
996    */
997   function safeTransferFrom(
998     address from,
999     address to,
1000     uint256 tokenId,
1001     bytes memory _data
1002   ) public override {
1003     _transfer(from, to, tokenId);
1004     require(
1005       _checkOnERC721Received(from, to, tokenId, _data),
1006       "ERC721A: transfer to non ERC721Receiver implementer"
1007     );
1008   }
1009 
1010   /**
1011    * @dev Returns whether `tokenId` exists.
1012    *
1013    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1014    *
1015    * Tokens start existing when they are minted (`_mint`),
1016    */
1017   function _exists(uint256 tokenId) internal view returns (bool) {
1018     return tokenId < currentIndex;
1019   }
1020 
1021   function _safeMint(address to, uint256 quantity) internal {
1022     _safeMint(to, quantity, "");
1023   }
1024 
1025   /**
1026    * @dev Mints `quantity` tokens and transfers them to `to`.
1027    *
1028    * Requirements:
1029    *
1030    * - there must be `quantity` tokens remaining unminted in the total collection.
1031    * - `to` cannot be the zero address.
1032    * - `quantity` cannot be larger than the max batch size.
1033    *
1034    * Emits a {Transfer} event.
1035    */
1036   function _safeMint(
1037     address to,
1038     uint256 quantity,
1039     bytes memory _data
1040   ) internal {
1041     uint256 startTokenId = currentIndex;
1042     require(to != address(0), "ERC721A: mint to the zero address");
1043     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1044     require(!_exists(startTokenId), "ERC721A: token already minted");
1045     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1046 
1047     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1048 
1049     AddressData memory addressData = _addressData[to];
1050     _addressData[to] = AddressData(
1051       addressData.balance + uint128(quantity),
1052       addressData.numberMinted + uint128(quantity)
1053     );
1054     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1055 
1056     uint256 updatedIndex = startTokenId;
1057 
1058     for (uint256 i = 0; i < quantity; i++) {
1059       emit Transfer(address(0), to, updatedIndex);
1060       require(
1061         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1062         "ERC721A: transfer to non ERC721Receiver implementer"
1063       );
1064       updatedIndex++;
1065     }
1066 
1067     currentIndex = updatedIndex;
1068     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1069   }
1070 
1071   /**
1072    * @dev Transfers `tokenId` from `from` to `to`.
1073    *
1074    * Requirements:
1075    *
1076    * - `to` cannot be the zero address.
1077    * - `tokenId` token must be owned by `from`.
1078    *
1079    * Emits a {Transfer} event.
1080    */
1081   function _transfer(
1082     address from,
1083     address to,
1084     uint256 tokenId
1085   ) private {
1086     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1087 
1088     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1089       getApproved(tokenId) == _msgSender() ||
1090       isApprovedForAll(prevOwnership.addr, _msgSender()));
1091 
1092     require(
1093       isApprovedOrOwner,
1094       "ERC721A: transfer caller is not owner nor approved"
1095     );
1096 
1097     require(
1098       prevOwnership.addr == from,
1099       "ERC721A: transfer from incorrect owner"
1100     );
1101     require(to != address(0), "ERC721A: transfer to the zero address");
1102 
1103     _beforeTokenTransfers(from, to, tokenId, 1);
1104 
1105     // Clear approvals from the previous owner
1106     _approve(address(0), tokenId, prevOwnership.addr);
1107 
1108     _addressData[from].balance -= 1;
1109     _addressData[to].balance += 1;
1110     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1111 
1112     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1113     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1114     uint256 nextTokenId = tokenId + 1;
1115     if (_ownerships[nextTokenId].addr == address(0)) {
1116       if (_exists(nextTokenId)) {
1117         _ownerships[nextTokenId] = TokenOwnership(
1118           prevOwnership.addr,
1119           prevOwnership.startTimestamp
1120         );
1121       }
1122     }
1123 
1124     emit Transfer(from, to, tokenId);
1125     _afterTokenTransfers(from, to, tokenId, 1);
1126   }
1127 
1128   /**
1129    * @dev Approve `to` to operate on `tokenId`
1130    *
1131    * Emits a {Approval} event.
1132    */
1133   function _approve(
1134     address to,
1135     uint256 tokenId,
1136     address owner
1137   ) private {
1138     _tokenApprovals[tokenId] = to;
1139     emit Approval(owner, to, tokenId);
1140   }
1141 
1142   uint256 public nextOwnerToExplicitlySet = 0;
1143 
1144   /**
1145    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1146    */
1147   function _setOwnersExplicit(uint256 quantity) internal {
1148     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1149     require(quantity > 0, "quantity must be nonzero");
1150     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1151     if (endIndex > collectionSize - 1) {
1152       endIndex = collectionSize - 1;
1153     }
1154     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1155     require(_exists(endIndex), "not enough minted yet for this cleanup");
1156     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1157       if (_ownerships[i].addr == address(0)) {
1158         TokenOwnership memory ownership = ownershipOf(i);
1159         _ownerships[i] = TokenOwnership(
1160           ownership.addr,
1161           ownership.startTimestamp
1162         );
1163       }
1164     }
1165     nextOwnerToExplicitlySet = endIndex + 1;
1166   }
1167 
1168   /**
1169    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1170    * The call is not executed if the target address is not a contract.
1171    *
1172    * @param from address representing the previous owner of the given token ID
1173    * @param to target address that will receive the tokens
1174    * @param tokenId uint256 ID of the token to be transferred
1175    * @param _data bytes optional data to send along with the call
1176    * @return bool whether the call correctly returned the expected magic value
1177    */
1178   function _checkOnERC721Received(
1179     address from,
1180     address to,
1181     uint256 tokenId,
1182     bytes memory _data
1183   ) private returns (bool) {
1184     if (to.isContract()) {
1185       try
1186         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1187       returns (bytes4 retval) {
1188         return retval == IERC721Receiver(to).onERC721Received.selector;
1189       } catch (bytes memory reason) {
1190         if (reason.length == 0) {
1191           revert("ERC721A: transfer to non ERC721Receiver implementer");
1192         } else {
1193           assembly {
1194             revert(add(32, reason), mload(reason))
1195           }
1196         }
1197       }
1198     } else {
1199       return true;
1200     }
1201   }
1202 
1203   /**
1204    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1205    *
1206    * startTokenId - the first token id to be transferred
1207    * quantity - the amount to be transferred
1208    *
1209    * Calling conditions:
1210    *
1211    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1212    * transferred to `to`.
1213    * - When `from` is zero, `tokenId` will be minted for `to`.
1214    */
1215   function _beforeTokenTransfers(
1216     address from,
1217     address to,
1218     uint256 startTokenId,
1219     uint256 quantity
1220   ) internal virtual {}
1221 
1222   /**
1223    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1224    * minting.
1225    *
1226    * startTokenId - the first token id to be transferred
1227    * quantity - the amount to be transferred
1228    *
1229    * Calling conditions:
1230    *
1231    * - when `from` and `to` are both non-zero.
1232    * - `from` and `to` are never both zero.
1233    */
1234   function _afterTokenTransfers(
1235     address from,
1236     address to,
1237     uint256 startTokenId,
1238     uint256 quantity
1239   ) internal virtual {}
1240 }
1241 // File: @openzeppelin/contracts/access/Ownable.sol
1242 
1243 
1244 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1245 
1246 pragma solidity ^0.8.0;
1247 
1248 
1249 /**
1250  * @dev Contract module which provides a basic access control mechanism, where
1251  * there is an account (an owner) that can be granted exclusive access to
1252  * specific functions.
1253  *
1254  * By default, the owner account will be the one that deploys the contract. This
1255  * can later be changed with {transferOwnership}.
1256  *
1257  * This module is used through inheritance. It will make available the modifier
1258  * `onlyOwner`, which can be applied to your functions to restrict their use to
1259  * the owner.
1260  */
1261 abstract contract Ownable is Context {
1262     address private _owner;
1263 
1264     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1265 
1266     /**
1267      * @dev Initializes the contract setting the deployer as the initial owner.
1268      */
1269     constructor() {
1270         _transferOwnership(_msgSender());
1271     }
1272 
1273     /**
1274      * @dev Returns the address of the current owner.
1275      */
1276     function owner() public view virtual returns (address) {
1277         return _owner;
1278     }
1279 
1280     /**
1281      * @dev Throws if called by any account other than the owner.
1282      */
1283     modifier onlyOwner() {
1284         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1285         _;
1286     }
1287 
1288     /**
1289      * @dev Leaves the contract without owner. It will not be possible to call
1290      * `onlyOwner` functions anymore. Can only be called by the current owner.
1291      *
1292      * NOTE: Renouncing ownership will leave the contract without an owner,
1293      * thereby removing any functionality that is only available to the owner.
1294      */
1295     function renounceOwnership() public virtual onlyOwner {
1296         _transferOwnership(address(0));
1297     }
1298 
1299     /**
1300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1301      * Can only be called by the current owner.
1302      */
1303     function transferOwnership(address newOwner) public virtual onlyOwner {
1304         require(newOwner != address(0), "Ownable: new owner is the zero address");
1305         _transferOwnership(newOwner);
1306     }
1307 
1308     /**
1309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1310      * Internal function without access restriction.
1311      */
1312     function _transferOwnership(address newOwner) internal virtual {
1313         address oldOwner = _owner;
1314         _owner = newOwner;
1315         emit OwnershipTransferred(oldOwner, newOwner);
1316     }
1317 }
1318 
1319 // File: contracts/Project.sol
1320 
1321 
1322 
1323 pragma solidity ^0.8.0;
1324 /**
1325 */
1326 
1327 
1328 
1329 
1330 
1331 contract MoonStamps is Ownable, ERC721A, ReentrancyGuard {
1332     bool publicSale = true;
1333     uint256 nbFree = 169;
1334     uint256 public price = 0.0015 ether;
1335 
1336     constructor() ERC721A("Moon Stamps", "MOON", 10, 1969) {}
1337 
1338     modifier callerIsUser() {
1339         require(tx.origin == msg.sender, "The caller is another contract");
1340         _;
1341     }
1342 
1343     function setFree(uint256 nb) external onlyOwner {
1344         nbFree = nb;
1345     }
1346 
1347     function freeMint(uint256 quantity) external callerIsUser {
1348         require(publicSale, "Public sale has not begun yet");
1349         require(totalSupply() + quantity <= nbFree, "Reached max free supply");
1350         require(quantity <= 10, "can not mint this many free at a time");
1351         _safeMint(msg.sender, quantity);
1352     }
1353 
1354     function mint(uint256 quantity) external payable callerIsUser {
1355         require(publicSale, "Public sale has not begun yet");
1356         require(
1357             totalSupply() + quantity <= collectionSize,
1358             "Reached max supply"
1359         );
1360         require(quantity <= 10, "can not mint this many at a time");
1361         require(
1362             price * quantity <= msg.value,
1363             "Ether value sent is not correct"
1364         );
1365 
1366         _safeMint(msg.sender, quantity);
1367     }
1368 
1369 	function setprice(uint256 _newprice) public onlyOwner {
1370 	    price = _newprice;
1371 	}
1372 
1373     // metadata URI
1374     string private _baseTokenURI =
1375         "ipfs://private/";
1376 
1377     function initMint() external onlyOwner {
1378         _safeMint(msg.sender, 1); // As the collection starts at 0, this first mint is for the deployer ...
1379     }
1380 
1381     
1382     function setSaleState(bool state) external onlyOwner {
1383         publicSale = state;
1384     }
1385 
1386     function _baseURI() internal view virtual override returns (string memory) {
1387         return _baseTokenURI;
1388     }
1389 
1390     function setBaseURI(string calldata baseURI) external onlyOwner {
1391         _baseTokenURI = baseURI;
1392     }
1393 
1394     function withdrawMoney() external onlyOwner nonReentrant {
1395         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1396         require(success, "Transfer failed.");
1397     }
1398 
1399     function setOwnersExplicit(uint256 quantity)
1400         external
1401         onlyOwner
1402         nonReentrant
1403     {
1404         _setOwnersExplicit(quantity);
1405     }
1406 
1407     function numberMinted(address owner) public view returns (uint256) {
1408         return _numberMinted(owner);
1409     }
1410 
1411     function getOwnershipData(uint256 tokenId)
1412         external
1413         view
1414         returns (TokenOwnership memory)
1415     {
1416         return ownershipOf(tokenId);
1417     }
1418     
1419 }