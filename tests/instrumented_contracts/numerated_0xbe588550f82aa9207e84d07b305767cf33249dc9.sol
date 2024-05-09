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
683 // File: contracts/babyzuki/ERC721A.sol
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
697 interface IOwnershipData{
698     function getOwnershipData(uint256 tokenId)
699         external
700         view
701         returns (address _address, uint64 _timestamp);
702 }
703 
704 /**
705  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
706  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
707  *
708  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
709  *
710  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
711  *
712  * Does not support burning tokens to address(0).
713  */
714 contract ERC721A is
715   Context,
716   ERC165,
717   IERC721,
718   IERC721Metadata,
719   IERC721Enumerable
720 {
721   using Address for address;
722   using Strings for uint256;
723 
724   struct TokenOwnership {
725     address addr;
726     uint64 startTimestamp;
727   }
728 
729   struct AddressData {
730     uint128 balance;
731     uint128 numberMinted;
732   }
733 
734   uint256 internal currentIndex = 0;
735 
736   uint256 internal immutable collectionSize;
737   uint256 internal immutable maxBatchSize;
738 
739   // Token name
740   string private _name;
741 
742   // Token symbol
743   string private _symbol;
744 
745   // Mapping from token ID to ownership details
746   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
747   mapping(uint256 => TokenOwnership) private _ownerships;
748 
749   // Mapping owner address to address data
750   mapping(address => AddressData) private _addressData;
751 
752   // Mapping from token ID to approved address
753   mapping(uint256 => address) private _tokenApprovals;
754 
755   // Mapping from owner to operator approvals
756   mapping(address => mapping(address => bool)) private _operatorApprovals;
757 
758   /**
759    * @dev
760    * `maxBatchSize` refers to how much a minter can mint at a time.
761    * `collectionSize_` refers to how many tokens are in the collection.
762    */
763   constructor(
764     string memory name_,
765     string memory symbol_,
766     uint256 maxBatchSize_,
767     uint256 collectionSize_
768   ) {
769     require(
770       collectionSize_ > 0,
771       "ERC721A: collection must have a nonzero supply"
772     );
773     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
774     _name = name_;
775     _symbol = symbol_;
776     maxBatchSize = maxBatchSize_;
777     collectionSize = collectionSize_;
778   }
779 
780   /**
781    * @dev See {IERC721Enumerable-totalSupply}.
782    */
783   function totalSupply() public view override returns (uint256) {
784     return currentIndex;
785   }
786 
787   /**
788    * @dev See {IERC721Enumerable-tokenByIndex}.
789    */
790   function tokenByIndex(uint256 index) public view override returns (uint256) {
791     require(index < totalSupply(), "ERC721A: global index out of bounds");
792     return index;
793   }
794 
795   /**
796    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
797    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
798    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
799    */
800   function tokenOfOwnerByIndex(address owner, uint256 index)
801     public
802     view
803     override
804     returns (uint256)
805   {
806     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
807     uint256 numMintedSoFar = totalSupply();
808     uint256 tokenIdsIdx = 0;
809     address currOwnershipAddr = address(0);
810     for (uint256 i = 0; i < numMintedSoFar; i++) {
811       TokenOwnership memory ownership = _ownerships[i];
812       if (ownership.addr != address(0)) {
813         currOwnershipAddr = ownership.addr;
814       }
815       if (currOwnershipAddr == owner) {
816         if (tokenIdsIdx == index) {
817           return i;
818         }
819         tokenIdsIdx++;
820       }
821     }
822     revert("ERC721A: unable to get token of owner by index");
823   }
824 
825   /**
826    * @dev See {IERC165-supportsInterface}.
827    */
828   function supportsInterface(bytes4 interfaceId)
829     public
830     view
831     virtual
832     override(ERC165, IERC165)
833     returns (bool)
834   {
835     return
836       interfaceId == type(IERC721).interfaceId ||
837       interfaceId == type(IERC721Metadata).interfaceId ||
838       interfaceId == type(IERC721Enumerable).interfaceId ||
839       super.supportsInterface(interfaceId);
840   }
841 
842   /**
843    * @dev See {IERC721-balanceOf}.
844    */
845   function balanceOf(address owner) public view override returns (uint256) {
846     require(owner != address(0), "ERC721A: balance query for the zero address");
847     return uint256(_addressData[owner].balance);
848   }
849 
850   function _numberMinted(address owner) internal view returns (uint256) {
851     require(
852       owner != address(0),
853       "ERC721A: number minted query for the zero address"
854     );
855     return uint256(_addressData[owner].numberMinted);
856   }
857 
858   function ownershipOf(uint256 tokenId)
859     internal
860     view
861     returns (TokenOwnership memory)
862   {
863     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
864 
865     uint256 lowestTokenToCheck;
866     if (tokenId >= maxBatchSize) {
867       lowestTokenToCheck = tokenId - maxBatchSize + 1;
868     }
869 
870     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
871       TokenOwnership memory ownership = _ownerships[curr];
872       if (ownership.addr != address(0)) {
873         return ownership;
874       }
875     }
876 
877     revert("ERC721A: unable to determine the owner of token");
878   }
879 
880   /**
881    * @dev See {IERC721-ownerOf}.
882    */
883   function ownerOf(uint256 tokenId) public view override returns (address) {
884     return ownershipOf(tokenId).addr;
885   }
886 
887   /**
888    * @dev See {IERC721Metadata-name}.
889    */
890   function name() public view virtual override returns (string memory) {
891     return _name;
892   }
893 
894   /**
895    * @dev See {IERC721Metadata-symbol}.
896    */
897   function symbol() public view virtual override returns (string memory) {
898     return _symbol;
899   }
900 
901   /**
902    * @dev See {IERC721Metadata-tokenURI}.
903    */
904   function tokenURI(uint256 tokenId)
905     public
906     view
907     virtual
908     override
909     returns (string memory)
910   {
911     require(
912       _exists(tokenId),
913       "ERC721Metadata: URI query for nonexistent token"
914     );
915 
916     string memory baseURI = _baseURI();
917     return
918       bytes(baseURI).length > 0
919         ? string(abi.encodePacked(baseURI, tokenId.toString()))
920         : "";
921   }
922 
923   /**
924    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
925    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
926    * by default, can be overriden in child contracts.
927    */
928   function _baseURI() internal view virtual returns (string memory) {
929     return "";
930   }
931 
932   /**
933    * @dev See {IERC721-approve}.
934    */
935   function approve(address to, uint256 tokenId) public override {
936     address owner = ERC721A.ownerOf(tokenId);
937     require(to != owner, "ERC721A: approval to current owner");
938 
939     require(
940       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
941       "ERC721A: approve caller is not owner nor approved for all"
942     );
943 
944     _approve(to, tokenId, owner);
945   }
946 
947   /**
948    * @dev See {IERC721-getApproved}.
949    */
950   function getApproved(uint256 tokenId) public view override returns (address) {
951     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
952 
953     return _tokenApprovals[tokenId];
954   }
955 
956   /**
957    * @dev See {IERC721-setApprovalForAll}.
958    */
959   function setApprovalForAll(address operator, bool approved) public override {
960     require(operator != _msgSender(), "ERC721A: approve to caller");
961 
962     _operatorApprovals[_msgSender()][operator] = approved;
963     emit ApprovalForAll(_msgSender(), operator, approved);
964   }
965 
966   /**
967    * @dev See {IERC721-isApprovedForAll}.
968    */
969   function isApprovedForAll(address owner, address operator)
970     public
971     view
972     virtual
973     override
974     returns (bool)
975   {
976     return _operatorApprovals[owner][operator];
977   }
978 
979   /**
980    * @dev See {IERC721-transferFrom}.
981    */
982   function transferFrom(
983     address from,
984     address to,
985     uint256 tokenId
986   ) public override {
987     _transfer(from, to, tokenId);
988   }
989 
990   /**
991    * @dev See {IERC721-safeTransferFrom}.
992    */
993   function safeTransferFrom(
994     address from,
995     address to,
996     uint256 tokenId
997   ) public override {
998     safeTransferFrom(from, to, tokenId, "");
999   }
1000 
1001   /**
1002    * @dev See {IERC721-safeTransferFrom}.
1003    */
1004   function safeTransferFrom(
1005     address from,
1006     address to,
1007     uint256 tokenId,
1008     bytes memory _data
1009   ) public override {
1010     _transfer(from, to, tokenId);
1011     require(
1012       _checkOnERC721Received(from, to, tokenId, _data),
1013       "ERC721A: transfer to non ERC721Receiver implementer"
1014     );
1015   }
1016 
1017   /**
1018    * @dev Returns whether `tokenId` exists.
1019    *
1020    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1021    *
1022    * Tokens start existing when they are minted (`_mint`),
1023    */
1024   function _exists(uint256 tokenId) internal view returns (bool) {
1025     return tokenId < currentIndex;
1026   }
1027 
1028   function _safeMint(address to, uint256 quantity) internal {
1029     _safeMint(to, quantity, "");
1030   }
1031 
1032   /**
1033    * @dev Mints `quantity` tokens and transfers them to `to`.
1034    *
1035    * Requirements:
1036    *
1037    * - there must be `quantity` tokens remaining unminted in the total collection.
1038    * - `to` cannot be the zero address.
1039    * - `quantity` cannot be larger than the max batch size.
1040    *
1041    * Emits a {Transfer} event.
1042    */
1043   function _safeMint(
1044     address to,
1045     uint256 quantity,
1046     bytes memory _data
1047   ) internal {
1048     uint256 startTokenId = currentIndex;
1049     require(to != address(0), "ERC721A: mint to the zero address");
1050     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1051     require(!_exists(startTokenId), "ERC721A: token already minted");
1052     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1053 
1054     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1055 
1056     AddressData memory addressData = _addressData[to];
1057     _addressData[to] = AddressData(
1058       addressData.balance + uint128(quantity),
1059       addressData.numberMinted + uint128(quantity)
1060     );
1061     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1062 
1063     uint256 updatedIndex = startTokenId;
1064 
1065     for (uint256 i = 0; i < quantity; i++) {
1066       emit Transfer(address(0), to, updatedIndex);
1067       require(
1068         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1069         "ERC721A: transfer to non ERC721Receiver implementer"
1070       );
1071       updatedIndex++;
1072     }
1073 
1074     currentIndex = updatedIndex;
1075     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1076   }
1077 
1078   /**
1079    * @dev Transfers `tokenId` from `from` to `to`.
1080    *
1081    * Requirements:
1082    *
1083    * - `to` cannot be the zero address.
1084    * - `tokenId` token must be owned by `from`.
1085    *
1086    * Emits a {Transfer} event.
1087    */
1088   function _transfer(
1089     address from,
1090     address to,
1091     uint256 tokenId
1092   ) private {
1093     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1094 
1095     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1096       getApproved(tokenId) == _msgSender() ||
1097       isApprovedForAll(prevOwnership.addr, _msgSender()));
1098 
1099     require(
1100       isApprovedOrOwner,
1101       "ERC721A: transfer caller is not owner nor approved"
1102     );
1103 
1104     require(
1105       prevOwnership.addr == from,
1106       "ERC721A: transfer from incorrect owner"
1107     );
1108     require(to != address(0), "ERC721A: transfer to the zero address");
1109 
1110     _beforeTokenTransfers(from, to, tokenId, 1);
1111 
1112     // Clear approvals from the previous owner
1113     _approve(address(0), tokenId, prevOwnership.addr);
1114 
1115     _addressData[from].balance -= 1;
1116     _addressData[to].balance += 1;
1117     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1118 
1119     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1120     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1121     uint256 nextTokenId = tokenId + 1;
1122     if (_ownerships[nextTokenId].addr == address(0)) {
1123       if (_exists(nextTokenId)) {
1124         _ownerships[nextTokenId] = TokenOwnership(
1125           prevOwnership.addr,
1126           prevOwnership.startTimestamp
1127         );
1128       }
1129     }
1130 
1131     emit Transfer(from, to, tokenId);
1132     _afterTokenTransfers(from, to, tokenId, 1);
1133   }
1134 
1135   /**
1136    * @dev Approve `to` to operate on `tokenId`
1137    *
1138    * Emits a {Approval} event.
1139    */
1140   function _approve(
1141     address to,
1142     uint256 tokenId,
1143     address owner
1144   ) private {
1145     _tokenApprovals[tokenId] = to;
1146     emit Approval(owner, to, tokenId);
1147   }
1148 
1149   uint256 public nextOwnerToExplicitlySet = 0;
1150 
1151   /**
1152    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1153    */
1154   function _setOwnersExplicit(uint256 quantity) internal {
1155     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1156     require(quantity > 0, "quantity must be nonzero");
1157     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1158     if (endIndex > collectionSize - 1) {
1159       endIndex = collectionSize - 1;
1160     }
1161     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1162     require(_exists(endIndex), "not enough minted yet for this cleanup");
1163     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1164       if (_ownerships[i].addr == address(0)) {
1165         TokenOwnership memory ownership = ownershipOf(i);
1166         _ownerships[i] = TokenOwnership(
1167           ownership.addr,
1168           ownership.startTimestamp
1169         );
1170       }
1171     }
1172     nextOwnerToExplicitlySet = endIndex + 1;
1173   }
1174 
1175   /**
1176    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1177    * The call is not executed if the target address is not a contract.
1178    *
1179    * @param from address representing the previous owner of the given token ID
1180    * @param to target address that will receive the tokens
1181    * @param tokenId uint256 ID of the token to be transferred
1182    * @param _data bytes optional data to send along with the call
1183    * @return bool whether the call correctly returned the expected magic value
1184    */
1185   function _checkOnERC721Received(
1186     address from,
1187     address to,
1188     uint256 tokenId,
1189     bytes memory _data
1190   ) private returns (bool) {
1191     if (to.isContract()) {
1192       try
1193         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1194       returns (bytes4 retval) {
1195         return retval == IERC721Receiver(to).onERC721Received.selector;
1196       } catch (bytes memory reason) {
1197         if (reason.length == 0) {
1198           revert("ERC721A: transfer to non ERC721Receiver implementer");
1199         } else {
1200           assembly {
1201             revert(add(32, reason), mload(reason))
1202           }
1203         }
1204       }
1205     } else {
1206       return true;
1207     }
1208   }
1209 
1210   /**
1211    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1212    *
1213    * startTokenId - the first token id to be transferred
1214    * quantity - the amount to be transferred
1215    *
1216    * Calling conditions:
1217    *
1218    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1219    * transferred to `to`.
1220    * - When `from` is zero, `tokenId` will be minted for `to`.
1221    */
1222   function _beforeTokenTransfers(
1223     address from,
1224     address to,
1225     uint256 startTokenId,
1226     uint256 quantity
1227   ) internal virtual {}
1228 
1229   /**
1230    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1231    * minting.
1232    *
1233    * startTokenId - the first token id to be transferred
1234    * quantity - the amount to be transferred
1235    *
1236    * Calling conditions:
1237    *
1238    * - when `from` and `to` are both non-zero.
1239    * - `from` and `to` are never both zero.
1240    */
1241   function _afterTokenTransfers(
1242     address from,
1243     address to,
1244     uint256 startTokenId,
1245     uint256 quantity
1246   ) internal virtual {}
1247 }
1248 // File: @openzeppelin/contracts/access/Ownable.sol
1249 
1250 
1251 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1252 
1253 pragma solidity ^0.8.0;
1254 
1255 
1256 /**
1257  * @dev Contract module which provides a basic access control mechanism, where
1258  * there is an account (an owner) that can be granted exclusive access to
1259  * specific functions.
1260  *
1261  * By default, the owner account will be the one that deploys the contract. This
1262  * can later be changed with {transferOwnership}.
1263  *
1264  * This module is used through inheritance. It will make available the modifier
1265  * `onlyOwner`, which can be applied to your functions to restrict their use to
1266  * the owner.
1267  */
1268 abstract contract Ownable is Context {
1269     address private _owner;
1270 
1271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1272 
1273     /**
1274      * @dev Initializes the contract setting the deployer as the initial owner.
1275      */
1276     constructor() {
1277         _transferOwnership(_msgSender());
1278     }
1279 
1280     /**
1281      * @dev Returns the address of the current owner.
1282      */
1283     function owner() public view virtual returns (address) {
1284         return _owner;
1285     }
1286 
1287     /**
1288      * @dev Throws if called by any account other than the owner.
1289      */
1290     modifier onlyOwner() {
1291         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1292         _;
1293     }
1294 
1295     /**
1296      * @dev Leaves the contract without owner. It will not be possible to call
1297      * `onlyOwner` functions anymore. Can only be called by the current owner.
1298      *
1299      * NOTE: Renouncing ownership will leave the contract without an owner,
1300      * thereby removing any functionality that is only available to the owner.
1301      */
1302     function renounceOwnership() public virtual onlyOwner {
1303         _transferOwnership(address(0));
1304     }
1305 
1306     /**
1307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1308      * Can only be called by the current owner.
1309      */
1310     function transferOwnership(address newOwner) public virtual onlyOwner {
1311         require(newOwner != address(0), "Ownable: new owner is the zero address");
1312         _transferOwnership(newOwner);
1313     }
1314 
1315     /**
1316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1317      * Internal function without access restriction.
1318      */
1319     function _transferOwnership(address newOwner) internal virtual {
1320         address oldOwner = _owner;
1321         _owner = newOwner;
1322         emit OwnershipTransferred(oldOwner, newOwner);
1323     }
1324 }
1325 
1326 // File: contracts/babyzuki/contracts.sol
1327 
1328 
1329 
1330 pragma solidity ^0.8.0;
1331 
1332 
1333 
1334 
1335 
1336 contract BBZOrigin is Ownable, ERC721A, ReentrancyGuard, IOwnershipData {
1337     struct MintConfig {
1338         uint256 dnmAmount;
1339         bool groupAActive;
1340         uint256 groupAPrice;
1341         bool groupBActive;
1342         uint256 groupBPrice;
1343         bool groupCActive;
1344         uint256 groupCPrice;
1345     }
1346 
1347     MintConfig public config;
1348 
1349     mapping(address => uint256) public groupA;
1350     mapping(address => uint256) public groupB;
1351 
1352     string private baseTokenURI;
1353 
1354     constructor(
1355         uint256 collectionSize,
1356         uint256 dnmAmount
1357     ) ERC721A("BBZ Origin", "BBZORIGIN", 5, collectionSize) {
1358       config.dnmAmount = dnmAmount;
1359       config.groupAPrice = 0.1 ether;
1360       config.groupBPrice = 0.12 ether;
1361       config.groupCPrice = 0.14 ether;
1362       baseTokenURI = "https://d359zl9sgwt1qi.cloudfront.net/";
1363     }
1364 
1365     modifier callerIsNotContract() {
1366         require(tx.origin == msg.sender, "The caller is another contract");
1367         _;
1368     }
1369 
1370     /* DnM Related */
1371     function mintDnM() external onlyOwner {
1372         uint256 numChunks = config.dnmAmount / maxBatchSize;
1373         for (uint256 i = 0; i < numChunks; i++) {
1374             _safeMint(msg.sender, maxBatchSize);
1375         }
1376     }
1377 
1378     function mintUnclaimed() external onlyOwner {
1379         for (uint256 i = currentIndex; i < collectionSize; i++) {
1380             _safeMint(msg.sender, 1);
1381         }
1382     }
1383 
1384     /* Manage */
1385     function setGroupState(bool g1, bool g2, bool g3) external onlyOwner {
1386         config.groupAActive = g1;
1387         config.groupBActive = g2;
1388         config.groupCActive = g3;
1389     }
1390 
1391     function setGroupPrice(uint256 p1, uint256 p2, uint256 p3) external onlyOwner {
1392         config.groupAPrice = p1;
1393         config.groupBPrice = p2;
1394         config.groupCPrice = p3;
1395     }
1396 
1397     function withdrawETH() external onlyOwner nonReentrant {
1398         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1399         require(success, "Transfer failed.");
1400     }
1401 
1402     /* OG Mint */
1403     function isOGMintActive() external view returns (bool) {
1404         return config.groupAActive;
1405     }
1406 
1407     function isInOgList() external view returns (bool) {
1408         return (groupA[msg.sender] > 0);
1409     }
1410 
1411     function mintOG(uint256 quantity)
1412         external
1413         payable
1414         callerIsNotContract
1415     {
1416         uint256 totalCost = uint256(config.groupAPrice) * quantity;
1417 
1418         require(config.groupAActive, "OG Sale is not active");
1419         require(msg.value >= totalCost, "Not enough ETH");
1420         require(groupA[msg.sender] >= quantity, "Not in OG list or already minted max amount");
1421         require(currentIndex + quantity <= collectionSize, "Total tokens amount reached");
1422 
1423         groupA[msg.sender] = groupA[msg.sender] - quantity;
1424         _safeMint(msg.sender, quantity);
1425     }
1426 
1427     function setOGList(
1428         address[] memory addresses,
1429         uint256[] memory numSlots
1430     ) external onlyOwner {
1431         require(
1432             addresses.length == numSlots.length,
1433             "Addresses does not match numSlots length"
1434         );
1435         for (uint256 i = 0; i < addresses.length; i++) {
1436             groupA[addresses[i]] += numSlots[i];
1437         }
1438     }
1439 
1440     /* WL Mint */
1441     function isWLMintActive() external view returns (bool) {
1442         return config.groupBActive;
1443     }
1444 
1445     function isInWLList() external view returns (bool) {
1446         return (groupB[msg.sender] > 0);
1447     }
1448 
1449     function mintWL(uint256 quantity)
1450         external
1451         payable
1452         callerIsNotContract
1453     {
1454         uint256 totalCost = uint256(config.groupBPrice) * quantity;
1455 
1456         require(config.groupBActive, "WL Sale is not active");
1457         require(msg.value >= totalCost, "Not enough ETH");
1458         require(groupB[msg.sender] >= quantity, "Not in WL list or already minted max amount");
1459         require(currentIndex + quantity <= collectionSize, "Total tokens amount reached");
1460 
1461         groupB[msg.sender] = groupB[msg.sender] - quantity;
1462         _safeMint(msg.sender, quantity);
1463     }
1464 
1465     function setWLList(
1466         address[] memory addresses,
1467         uint256[] memory numSlots
1468     ) external onlyOwner {
1469         require(
1470             addresses.length == numSlots.length,
1471             "Addresses does not match numSlots length"
1472         );
1473         for (uint256 i = 0; i < addresses.length; i++) {
1474             groupB[addresses[i]] += numSlots[i];
1475         }
1476     }
1477 
1478     /* Public Mint */
1479     function isPublicMintActive() external view returns (bool) {
1480         return config.groupCActive;
1481     }
1482 
1483     function mint(uint256 quantity)
1484         external
1485         payable
1486         callerIsNotContract
1487     {
1488         uint256 totalCost = uint256(config.groupCPrice) * quantity;
1489 
1490         require(config.groupCActive, "Public Sale is not active");
1491         require(msg.value >= totalCost, "Not enough ETH");
1492         require(currentIndex + quantity <= collectionSize, "Total tokens amount reached");
1493         require(quantity <= 3, "Max mint amount is 3");
1494 
1495         _safeMint(msg.sender, quantity);
1496     }
1497 
1498     /* Metadata */
1499     function _baseURI() internal view virtual override returns (string memory) {
1500         return baseTokenURI;
1501     }
1502 
1503     function setBaseURI(string calldata baseURI) external onlyOwner {
1504         baseTokenURI = baseURI;
1505     }
1506 
1507     function setOwnersExplicit(uint256 quantity)
1508         external
1509         onlyOwner
1510         nonReentrant
1511     {
1512         _setOwnersExplicit(quantity);
1513     }
1514 
1515     function numberMinted(address owner) public view returns (uint256) {
1516         return _numberMinted(owner);
1517     }
1518 
1519     function getOwnershipData(uint256 tokenId)
1520         external override
1521         view
1522         returns (address _address, uint64 _timestamp)
1523     {
1524         TokenOwnership memory ownership = ownershipOf(tokenId);
1525         return (ownership.addr, ownership.startTimestamp);
1526     }
1527 }