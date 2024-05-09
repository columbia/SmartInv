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
686 // Creators: locationtba.eth, 2pmflow.eth
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
704  * Does not support burning tokens to address(0).
705  */
706 contract ERC721A is
707   Context,
708   ERC165,
709   IERC721,
710   IERC721Metadata,
711   IERC721Enumerable
712 {
713   using Address for address;
714   using Strings for uint256;
715 
716   struct TokenOwnership {
717     address addr;
718     uint64 startTimestamp;
719   }
720 
721   struct AddressData {
722     uint128 balance;
723     uint128 numberMinted;
724   }
725 
726   uint256 private currentIndex = 0;
727 
728   uint256 internal immutable collectionSize;
729   uint256 internal immutable maxBatchSize;
730 
731   // Token name
732   string private _name;
733 
734   // Token symbol
735   string private _symbol;
736 
737   // Mapping from token ID to ownership details
738   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
739   mapping(uint256 => TokenOwnership) private _ownerships;
740 
741   // Mapping owner address to address data
742   mapping(address => AddressData) private _addressData;
743 
744   // Mapping from token ID to approved address
745   mapping(uint256 => address) private _tokenApprovals;
746 
747   // Mapping from owner to operator approvals
748   mapping(address => mapping(address => bool)) private _operatorApprovals;
749 
750   /**
751    * @dev
752    * `maxBatchSize` refers to how much a minter can mint at a time.
753    */
754   constructor(
755     string memory name_,
756     string memory symbol_,
757     uint256 maxBatchSize_,
758     uint256 collectionSize_
759   ) {
760     require(
761       collectionSize_ > 0,
762       "ERC721A: collection must have a nonzero supply"
763     );
764     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
765     _name = name_;
766     _symbol = symbol_;
767     maxBatchSize = maxBatchSize_;
768     collectionSize = collectionSize_;
769   }
770 
771   /**
772    * @dev See {IERC721Enumerable-totalSupply}.
773    */
774   function totalSupply() public view override returns (uint256) {
775     return currentIndex;
776   }
777 
778   /**
779    * @dev See {IERC721Enumerable-tokenByIndex}.
780    */
781   function tokenByIndex(uint256 index) public view override returns (uint256) {
782     require(index < totalSupply(), "ERC721A: global index out of bounds");
783     return index;
784   }
785 
786   /**
787    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
788    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
789    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
790    */
791   function tokenOfOwnerByIndex(address owner, uint256 index)
792     public
793     view
794     override
795     returns (uint256)
796   {
797     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
798     uint256 numMintedSoFar = totalSupply();
799     uint256 tokenIdsIdx = 0;
800     address currOwnershipAddr = address(0);
801     for (uint256 i = 0; i < numMintedSoFar; i++) {
802       TokenOwnership memory ownership = _ownerships[i];
803       if (ownership.addr != address(0)) {
804         currOwnershipAddr = ownership.addr;
805       }
806       if (currOwnershipAddr == owner) {
807         if (tokenIdsIdx == index) {
808           return i;
809         }
810         tokenIdsIdx++;
811       }
812     }
813     revert("ERC721A: unable to get token of owner by index");
814   }
815 
816   /**
817    * @dev See {IERC165-supportsInterface}.
818    */
819   function supportsInterface(bytes4 interfaceId)
820     public
821     view
822     virtual
823     override(ERC165, IERC165)
824     returns (bool)
825   {
826     return
827       interfaceId == type(IERC721).interfaceId ||
828       interfaceId == type(IERC721Metadata).interfaceId ||
829       interfaceId == type(IERC721Enumerable).interfaceId ||
830       super.supportsInterface(interfaceId);
831   }
832 
833   /**
834    * @dev See {IERC721-balanceOf}.
835    */
836   function balanceOf(address owner) public view override returns (uint256) {
837     require(owner != address(0), "ERC721A: balance query for the zero address");
838     return uint256(_addressData[owner].balance);
839   }
840 
841   function _numberMinted(address owner) internal view returns (uint256) {
842     require(
843       owner != address(0),
844       "ERC721A: number minted query for the zero address"
845     );
846     return uint256(_addressData[owner].numberMinted);
847   }
848 
849   function ownershipOf(uint256 tokenId)
850     internal
851     view
852     returns (TokenOwnership memory)
853   {
854     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
855 
856     uint256 lowestTokenToCheck;
857     if (tokenId >= maxBatchSize) {
858       lowestTokenToCheck = tokenId - maxBatchSize + 1;
859     }
860 
861     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
862       TokenOwnership memory ownership = _ownerships[curr];
863       if (ownership.addr != address(0)) {
864         return ownership;
865       }
866     }
867 
868     revert("ERC721A: unable to determine the owner of token");
869   }
870 
871   /**
872    * @dev See {IERC721-ownerOf}.
873    */
874   function ownerOf(uint256 tokenId) public view override returns (address) {
875     return ownershipOf(tokenId).addr;
876   }
877 
878   /**
879    * @dev See {IERC721Metadata-name}.
880    */
881   function name() public view virtual override returns (string memory) {
882     return _name;
883   }
884 
885   /**
886    * @dev See {IERC721Metadata-symbol}.
887    */
888   function symbol() public view virtual override returns (string memory) {
889     return _symbol;
890   }
891 
892   /**
893    * @dev See {IERC721Metadata-tokenURI}.
894    */
895   function tokenURI(uint256 tokenId)
896     public
897     view
898     virtual
899     override
900     returns (string memory)
901   {
902     require(
903       _exists(tokenId),
904       "ERC721Metadata: URI query for nonexistent token"
905     );
906 
907     string memory baseURI = _baseURI();
908     return
909       bytes(baseURI).length > 0
910         ? string(abi.encodePacked(baseURI, tokenId.toString()))
911         : "";
912   }
913 
914   /**
915    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
916    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
917    * by default, can be overriden in child contracts.
918    */
919   function _baseURI() internal view virtual returns (string memory) {
920     return "";
921   }
922 
923   /**
924    * @dev See {IERC721-approve}.
925    */
926   function approve(address to, uint256 tokenId) public override {
927     address owner = ERC721A.ownerOf(tokenId);
928     require(to != owner, "ERC721A: approval to current owner");
929 
930     require(
931       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
932       "ERC721A: approve caller is not owner nor approved for all"
933     );
934 
935     _approve(to, tokenId, owner);
936   }
937 
938   /**
939    * @dev See {IERC721-getApproved}.
940    */
941   function getApproved(uint256 tokenId) public view override returns (address) {
942     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
943 
944     return _tokenApprovals[tokenId];
945   }
946 
947   /**
948    * @dev See {IERC721-setApprovalForAll}.
949    */
950   function setApprovalForAll(address operator, bool approved) public override {
951     require(operator != _msgSender(), "ERC721A: approve to caller");
952 
953     _operatorApprovals[_msgSender()][operator] = approved;
954     emit ApprovalForAll(_msgSender(), operator, approved);
955   }
956 
957   /**
958    * @dev See {IERC721-isApprovedForAll}.
959    */
960   function isApprovedForAll(address owner, address operator)
961     public
962     view
963     virtual
964     override
965     returns (bool)
966   {
967     return _operatorApprovals[owner][operator];
968   }
969 
970   /**
971    * @dev See {IERC721-transferFrom}.
972    */
973   function transferFrom(
974     address from,
975     address to,
976     uint256 tokenId
977   ) public override {
978     _transfer(from, to, tokenId);
979   }
980 
981   /**
982    * @dev See {IERC721-safeTransferFrom}.
983    */
984   function safeTransferFrom(
985     address from,
986     address to,
987     uint256 tokenId
988   ) public override {
989     safeTransferFrom(from, to, tokenId, "");
990   }
991 
992   /**
993    * @dev See {IERC721-safeTransferFrom}.
994    */
995   function safeTransferFrom(
996     address from,
997     address to,
998     uint256 tokenId,
999     bytes memory _data
1000   ) public override {
1001     _transfer(from, to, tokenId);
1002     require(
1003       _checkOnERC721Received(from, to, tokenId, _data),
1004       "ERC721A: transfer to non ERC721Receiver implementer"
1005     );
1006   }
1007 
1008   /**
1009    * @dev Returns whether `tokenId` exists.
1010    *
1011    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1012    *
1013    * Tokens start existing when they are minted (`_mint`),
1014    */
1015   function _exists(uint256 tokenId) internal view returns (bool) {
1016     return tokenId < currentIndex;
1017   }
1018 
1019   function _safeMint(address to, uint256 quantity) internal {
1020     _safeMint(to, quantity, "");
1021   }
1022 
1023   /**
1024    * @dev Mints `quantity` tokens and transfers them to `to`.
1025    *
1026    * Requirements:
1027    *
1028    * - `to` cannot be the zero address.
1029    * - `quantity` cannot be larger than the max batch size.
1030    *
1031    * Emits a {Transfer} event.
1032    */
1033   function _safeMint(
1034     address to,
1035     uint256 quantity,
1036     bytes memory _data
1037   ) internal {
1038     uint256 startTokenId = currentIndex;
1039     require(to != address(0), "ERC721A: mint to the zero address");
1040     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1041     require(!_exists(startTokenId), "ERC721A: token already minted");
1042     //require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1043 
1044     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1045 
1046     AddressData memory addressData = _addressData[to];
1047     _addressData[to] = AddressData(
1048       addressData.balance + uint128(quantity),
1049       addressData.numberMinted + uint128(quantity)
1050     );
1051     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1052 
1053     uint256 updatedIndex = startTokenId;
1054 
1055     for (uint256 i = 0; i < quantity; i++) {
1056       emit Transfer(address(0), to, updatedIndex);
1057       require(
1058         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1059         "ERC721A: transfer to non ERC721Receiver implementer"
1060       );
1061       updatedIndex++;
1062     }
1063 
1064     currentIndex = updatedIndex;
1065     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1066   }
1067 
1068   /**
1069    * @dev Transfers `tokenId` from `from` to `to`.
1070    *
1071    * Requirements:
1072    *
1073    * - `to` cannot be the zero address.
1074    * - `tokenId` token must be owned by `from`.
1075    *
1076    * Emits a {Transfer} event.
1077    */
1078   function _transfer(
1079     address from,
1080     address to,
1081     uint256 tokenId
1082   ) private {
1083     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1084 
1085     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1086       getApproved(tokenId) == _msgSender() ||
1087       isApprovedForAll(prevOwnership.addr, _msgSender()));
1088 
1089     require(
1090       isApprovedOrOwner,
1091       "ERC721A: transfer caller is not owner nor approved"
1092     );
1093 
1094     require(
1095       prevOwnership.addr == from,
1096       "ERC721A: transfer from incorrect owner"
1097     );
1098     require(to != address(0), "ERC721A: transfer to the zero address");
1099 
1100     _beforeTokenTransfers(from, to, tokenId, 1);
1101 
1102     // Clear approvals from the previous owner
1103     _approve(address(0), tokenId, prevOwnership.addr);
1104 
1105     _addressData[from].balance -= 1;
1106     _addressData[to].balance += 1;
1107     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1108 
1109     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1110     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1111     uint256 nextTokenId = tokenId + 1;
1112     if (_ownerships[nextTokenId].addr == address(0)) {
1113       if (_exists(nextTokenId)) {
1114         _ownerships[nextTokenId] = TokenOwnership(
1115           prevOwnership.addr,
1116           prevOwnership.startTimestamp
1117         );
1118       }
1119     }
1120 
1121     emit Transfer(from, to, tokenId);
1122     _afterTokenTransfers(from, to, tokenId, 1);
1123   }
1124 
1125   /**
1126    * @dev Approve `to` to operate on `tokenId`
1127    *
1128    * Emits a {Approval} event.
1129    */
1130   function _approve(
1131     address to,
1132     uint256 tokenId,
1133     address owner
1134   ) private {
1135     _tokenApprovals[tokenId] = to;
1136     emit Approval(owner, to, tokenId);
1137   }
1138 
1139   uint256 public nextOwnerToExplicitlySet = 0;
1140 
1141   /**
1142    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1143    */
1144   function _setOwnersExplicit(uint256 quantity) internal {
1145     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1146     require(quantity > 0, "quantity must be nonzero");
1147     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1148     if (endIndex > currentIndex - 1) {
1149       endIndex = currentIndex - 1;
1150     }
1151     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1152     require(_exists(endIndex), "not enough minted yet for this cleanup");
1153     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1154       if (_ownerships[i].addr == address(0)) {
1155         TokenOwnership memory ownership = ownershipOf(i);
1156         _ownerships[i] = TokenOwnership(
1157           ownership.addr,
1158           ownership.startTimestamp
1159         );
1160       }
1161     }
1162     nextOwnerToExplicitlySet = endIndex + 1;
1163   }
1164 
1165   /**
1166    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1167    * The call is not executed if the target address is not a contract.
1168    *
1169    * @param from address representing the previous owner of the given token ID
1170    * @param to target address that will receive the tokens
1171    * @param tokenId uint256 ID of the token to be transferred
1172    * @param _data bytes optional data to send along with the call
1173    * @return bool whether the call correctly returned the expected magic value
1174    */
1175   function _checkOnERC721Received(
1176     address from,
1177     address to,
1178     uint256 tokenId,
1179     bytes memory _data
1180   ) private returns (bool) {
1181     if (to.isContract()) {
1182       try
1183         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1184       returns (bytes4 retval) {
1185         return retval == IERC721Receiver(to).onERC721Received.selector;
1186       } catch (bytes memory reason) {
1187         if (reason.length == 0) {
1188           revert("ERC721A: transfer to non ERC721Receiver implementer");
1189         } else {
1190           assembly {
1191             revert(add(32, reason), mload(reason))
1192           }
1193         }
1194       }
1195     } else {
1196       return true;
1197     }
1198   }
1199 
1200   /**
1201    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1202    *
1203    * startTokenId - the first token id to be transferred
1204    * quantity - the amount to be transferred
1205    *
1206    * Calling conditions:
1207    *
1208    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1209    * transferred to `to`.
1210    * - When `from` is zero, `tokenId` will be minted for `to`.
1211    */
1212   function _beforeTokenTransfers(
1213     address from,
1214     address to,
1215     uint256 startTokenId,
1216     uint256 quantity
1217   ) internal virtual {}
1218 
1219   /**
1220    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1221    * minting.
1222    *
1223    * startTokenId - the first token id to be transferred
1224    * quantity - the amount to be transferred
1225    *
1226    * Calling conditions:
1227    *
1228    * - when `from` and `to` are both non-zero.
1229    * - `from` and `to` are never both zero.
1230    */
1231   function _afterTokenTransfers(
1232     address from,
1233     address to,
1234     uint256 startTokenId,
1235     uint256 quantity
1236   ) internal virtual {}
1237 }
1238 
1239 // File: @openzeppelin/contracts/access/Ownable.sol
1240 
1241 
1242 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 
1247 /**
1248  * @dev Contract module which provides a basic access control mechanism, where
1249  * there is an account (an owner) that can be granted exclusive access to
1250  * specific functions.
1251  *
1252  * By default, the owner account will be the one that deploys the contract. This
1253  * can later be changed with {transferOwnership}.
1254  *
1255  * This module is used through inheritance. It will make available the modifier
1256  * `onlyOwner`, which can be applied to your functions to restrict their use to
1257  * the owner.
1258  */
1259 abstract contract Ownable is Context {
1260     address private _owner;
1261 
1262     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1263 
1264     /**
1265      * @dev Initializes the contract setting the deployer as the initial owner.
1266      */
1267     constructor() {
1268         _transferOwnership(_msgSender());
1269     }
1270 
1271     /**
1272      * @dev Returns the address of the current owner.
1273      */
1274     function owner() public view virtual returns (address) {
1275         return _owner;
1276     }
1277 
1278     /**
1279      * @dev Throws if called by any account other than the owner.
1280      */
1281     modifier onlyOwner() {
1282         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1283         _;
1284     }
1285 
1286     /**
1287      * @dev Leaves the contract without owner. It will not be possible to call
1288      * `onlyOwner` functions anymore. Can only be called by the current owner.
1289      *
1290      * NOTE: Renouncing ownership will leave the contract without an owner,
1291      * thereby removing any functionality that is only available to the owner.
1292      */
1293     function renounceOwnership() public virtual onlyOwner {
1294         _transferOwnership(address(0));
1295     }
1296 
1297     /**
1298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1299      * Can only be called by the current owner.
1300      */
1301     function transferOwnership(address newOwner) public virtual onlyOwner {
1302         require(newOwner != address(0), "Ownable: new owner is the zero address");
1303         _transferOwnership(newOwner);
1304     }
1305 
1306     /**
1307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1308      * Internal function without access restriction.
1309      */
1310     function _transferOwnership(address newOwner) internal virtual {
1311         address oldOwner = _owner;
1312         _owner = newOwner;
1313         emit OwnershipTransferred(oldOwner, newOwner);
1314     }
1315 }
1316 
1317 // File: contracts/mfersinlove.sol
1318 
1319 
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 
1324 
1325 
1326 
1327 contract mfersinlove is ERC721A, Ownable {
1328     uint256 public NFT_PRICE = 0.0069 ether;
1329     uint256 public MAX_SUPPLY = 2222;
1330     uint256 public MAX_MINTS = 10;
1331     uint256 public MAX_MINTS_RESERVED = 10;
1332     string public projName = "MfersInLove";
1333     string public projSym = "mflove";
1334 
1335     bool public DROP_ACTIVE = false;
1336 
1337     string public baseURI = "https://ipfs.io/ipfs/QmevZWPCZKdXmCzJaDpV1hiW8N5h5159tQQJbK3ikk5nrF/";
1338     mapping(address => uint) addressToReservedMints;
1339     
1340     constructor() ERC721A(projName, projSym, MAX_MINTS, MAX_SUPPLY) {}
1341 
1342     function mint(uint256 numTokens) public payable {
1343         require(DROP_ACTIVE, "Sale not started");
1344         require(
1345             numTokens > 0 && numTokens <= MAX_MINTS,
1346             "Must mint between 1 and 10 tokens"
1347         );
1348         require(totalSupply() + numTokens <= MAX_SUPPLY, "Sold Out");
1349         require(
1350             msg.value >= NFT_PRICE * numTokens,
1351             "Amount of ether sent is not enough"
1352         );
1353 
1354         _safeMint(msg.sender, numTokens);
1355     }
1356 
1357     function StaffMint(uint256 numTokens) public onlyOwner{
1358         _safeMint(msg.sender, numTokens);
1359     }
1360 
1361     function flipDropState() public onlyOwner {
1362         DROP_ACTIVE = !DROP_ACTIVE;
1363     }
1364 
1365     function setBaseURI(string memory newBaseURI) public onlyOwner {
1366         baseURI = newBaseURI;
1367     }
1368 
1369     function setPrice(uint256 newPrice) public onlyOwner {
1370         NFT_PRICE = newPrice;
1371     }
1372 
1373     function setMaxMints(uint256 newMax) public onlyOwner {
1374         MAX_MINTS = newMax;
1375     }
1376 
1377     function setSupply(uint256 newSupply) public onlyOwner {
1378         MAX_SUPPLY = newSupply;
1379     }
1380 
1381     function _baseURI() internal view virtual override returns (string memory) {
1382         return baseURI;
1383     }
1384     
1385     function reservedMintedBy() external view returns (uint256) {
1386         return addressToReservedMints[msg.sender];
1387     }
1388 
1389     function withdraw() public onlyOwner {
1390         require(payable(msg.sender).send(address(this).balance));
1391     }
1392 }