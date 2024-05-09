1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
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
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292                 /// @solidity memory-safe-assembly
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @title ERC721 token receiver interface
313  * @dev Interface for any contract that wants to support safeTransfers
314  * from ERC721 asset contracts.
315  */
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
325      */
326     function onERC721Received(
327         address operator,
328         address from,
329         uint256 tokenId,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Implementation of the {IERC165} interface.
372  *
373  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
374  * for the additional interface id that will be supported. For example:
375  *
376  * ```solidity
377  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
378  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
379  * }
380  * ```
381  *
382  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
383  */
384 abstract contract ERC165 is IERC165 {
385     /**
386      * @dev See {IERC165-supportsInterface}.
387      */
388     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
389         return interfaceId == type(IERC165).interfaceId;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
394 
395 
396 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 /**
402  * @dev Required interface of an ERC721 compliant contract.
403  */
404 interface IERC721 is IERC165 {
405     /**
406      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
412      */
413     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
417      */
418     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
419 
420     /**
421      * @dev Returns the number of tokens in ``owner``'s account.
422      */
423     function balanceOf(address owner) external view returns (uint256 balance);
424 
425     /**
426      * @dev Returns the owner of the `tokenId` token.
427      *
428      * Requirements:
429      *
430      * - `tokenId` must exist.
431      */
432     function ownerOf(uint256 tokenId) external view returns (address owner);
433 
434     /**
435      * @dev Safely transfers `tokenId` token from `from` to `to`.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId,
451         bytes calldata data
452     ) external;
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
456      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId
472     ) external;
473 
474     /**
475      * @dev Transfers `tokenId` token from `from` to `to`.
476      *
477      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      *
486      * Emits a {Transfer} event.
487      */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
496      * The approval is cleared when the token is transferred.
497      *
498      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
499      *
500      * Requirements:
501      *
502      * - The caller must own the token or be an approved operator.
503      * - `tokenId` must exist.
504      *
505      * Emits an {Approval} event.
506      */
507     function approve(address to, uint256 tokenId) external;
508 
509     /**
510      * @dev Approve or remove `operator` as an operator for the caller.
511      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
512      *
513      * Requirements:
514      *
515      * - The `operator` cannot be the caller.
516      *
517      * Emits an {ApprovalForAll} event.
518      */
519     function setApprovalForAll(address operator, bool _approved) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator) external view returns (bool);
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
539 
540 
541 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
548  * @dev See https://eips.ethereum.org/EIPS/eip-721
549  */
550 interface IERC721Enumerable is IERC721 {
551     /**
552      * @dev Returns the total amount of tokens stored by the contract.
553      */
554     function totalSupply() external view returns (uint256);
555 
556     /**
557      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
558      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
559      */
560     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
561 
562     /**
563      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
564      * Use along with {totalSupply} to enumerate all tokens.
565      */
566     function tokenByIndex(uint256 index) external view returns (uint256);
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
579  * @dev See https://eips.ethereum.org/EIPS/eip-721
580  */
581 interface IERC721Metadata is IERC721 {
582     /**
583      * @dev Returns the token collection name.
584      */
585     function name() external view returns (string memory);
586 
587     /**
588      * @dev Returns the token collection symbol.
589      */
590     function symbol() external view returns (string memory);
591 
592     /**
593      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
594      */
595     function tokenURI(uint256 tokenId) external view returns (string memory);
596 }
597 
598 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Contract module that helps prevent reentrant calls to a function.
607  *
608  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
609  * available, which can be applied to functions to make sure there are no nested
610  * (reentrant) calls to them.
611  *
612  * Note that because there is a single `nonReentrant` guard, functions marked as
613  * `nonReentrant` may not call one another. This can be worked around by making
614  * those functions `private`, and then adding `external` `nonReentrant` entry
615  * points to them.
616  *
617  * TIP: If you would like to learn more about reentrancy and alternative ways
618  * to protect against it, check out our blog post
619  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
620  */
621 abstract contract ReentrancyGuard {
622     // Booleans are more expensive than uint256 or any type that takes up a full
623     // word because each write operation emits an extra SLOAD to first read the
624     // slot's contents, replace the bits taken up by the boolean, and then write
625     // back. This is the compiler's defense against contract upgrades and
626     // pointer aliasing, and it cannot be disabled.
627 
628     // The values being non-zero value makes deployment a bit more expensive,
629     // but in exchange the refund on every call to nonReentrant will be lower in
630     // amount. Since refunds are capped to a percentage of the total
631     // transaction's gas, it is best to keep them low in cases like this one, to
632     // increase the likelihood of the full refund coming into effect.
633     uint256 private constant _NOT_ENTERED = 1;
634     uint256 private constant _ENTERED = 2;
635 
636     uint256 private _status;
637 
638     constructor() {
639         _status = _NOT_ENTERED;
640     }
641 
642     /**
643      * @dev Prevents a contract from calling itself, directly or indirectly.
644      * Calling a `nonReentrant` function from another `nonReentrant`
645      * function is not supported. It is possible to prevent this from happening
646      * by making the `nonReentrant` function external, and making it call a
647      * `private` function that does the actual work.
648      */
649     modifier nonReentrant() {
650         // On the first call to nonReentrant, _notEntered will be true
651         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
652 
653         // Any calls to nonReentrant after this point will fail
654         _status = _ENTERED;
655 
656         _;
657 
658         // By storing the original value once again, a refund is triggered (see
659         // https://eips.ethereum.org/EIPS/eip-2200)
660         _status = _NOT_ENTERED;
661     }
662 }
663 
664 // File: @openzeppelin/contracts/utils/Context.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev Provides information about the current execution context, including the
673  * sender of the transaction and its data. While these are generally available
674  * via msg.sender and msg.data, they should not be accessed in such a direct
675  * manner, since when dealing with meta-transactions the account sending and
676  * paying for execution may not be the actual sender (as far as an application
677  * is concerned).
678  *
679  * This contract is only required for intermediate, library-like contracts.
680  */
681 abstract contract Context {
682     function _msgSender() internal view virtual returns (address) {
683         return msg.sender;
684     }
685 
686     function _msgData() internal view virtual returns (bytes calldata) {
687         return msg.data;
688     }
689 }
690 
691 // File: contracts/ERC721A.sol
692 
693 
694 
695 pragma solidity ^0.8.0;
696 
697 
698 
699 
700 
701 
702 
703 
704 
705 /**
706  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
707  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
708  *
709  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
710  *
711  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
712  *
713  * Does not support burning tokens to address(0).
714  */
715 contract ERC721A is
716   Context,
717   ERC165,
718   IERC721,
719   IERC721Metadata,
720   IERC721Enumerable
721 {
722   using Address for address;
723   using Strings for uint256;
724 
725   struct TokenOwnership {
726     address addr;
727     uint64 startTimestamp;
728   }
729 
730   struct AddressData {
731     uint128 balance;
732     uint128 numberMinted;
733   }
734 
735   uint256 private currentIndex = 0;
736 
737   uint256 internal immutable collectionSize;
738   uint256 internal immutable maxBatchSize;
739 
740   // Token name
741   string private _name;
742 
743   // Token symbol
744   string private _symbol;
745 
746   // Mapping from token ID to ownership details
747   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
748   mapping(uint256 => TokenOwnership) private _ownerships;
749 
750   // Mapping owner address to address data
751   mapping(address => AddressData) private _addressData;
752 
753   // Mapping from token ID to approved address
754   mapping(uint256 => address) private _tokenApprovals;
755 
756   // Mapping from owner to operator approvals
757   mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759   /**
760    * @dev
761    * `maxBatchSize` refers to how much a minter can mint at a time.
762    * `collectionSize_` refers to how many tokens are in the collection.
763    */
764   constructor(
765     string memory name_,
766     string memory symbol_,
767     uint256 maxBatchSize_,
768     uint256 collectionSize_
769   ) {
770     require(
771       collectionSize_ > 0,
772       "ERC721A: collection must have a nonzero supply"
773     );
774     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
775     _name = name_;
776     _symbol = symbol_;
777     maxBatchSize = maxBatchSize_;
778     collectionSize = collectionSize_;
779   }
780 
781   /**
782    * @dev See {IERC721Enumerable-totalSupply}.
783    */
784   function totalSupply() public view override returns (uint256) {
785     return currentIndex;
786   }
787 
788   /**
789    * @dev See {IERC721Enumerable-tokenByIndex}.
790    */
791   function tokenByIndex(uint256 index) public view override returns (uint256) {
792     require(index < totalSupply(), "ERC721A: global index out of bounds");
793     return index;
794   }
795 
796   /**
797    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
798    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
799    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
800    */
801   function tokenOfOwnerByIndex(address owner, uint256 index)
802     public
803     view
804     override
805     returns (uint256)
806   {
807     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
808     uint256 numMintedSoFar = totalSupply();
809     uint256 tokenIdsIdx = 0;
810     address currOwnershipAddr = address(0);
811     for (uint256 i = 0; i < numMintedSoFar; i++) {
812       TokenOwnership memory ownership = _ownerships[i];
813       if (ownership.addr != address(0)) {
814         currOwnershipAddr = ownership.addr;
815       }
816       if (currOwnershipAddr == owner) {
817         if (tokenIdsIdx == index) {
818           return i;
819         }
820         tokenIdsIdx++;
821       }
822     }
823     revert("ERC721A: unable to get token of owner by index");
824   }
825 
826   /**
827    * @dev See {IERC165-supportsInterface}.
828    */
829   function supportsInterface(bytes4 interfaceId)
830     public
831     view
832     virtual
833     override(ERC165, IERC165)
834     returns (bool)
835   {
836     return
837       interfaceId == type(IERC721).interfaceId ||
838       interfaceId == type(IERC721Metadata).interfaceId ||
839       interfaceId == type(IERC721Enumerable).interfaceId ||
840       super.supportsInterface(interfaceId);
841   }
842 
843   /**
844    * @dev See {IERC721-balanceOf}.
845    */
846   function balanceOf(address owner) public view override returns (uint256) {
847     require(owner != address(0), "ERC721A: balance query for the zero address");
848     return uint256(_addressData[owner].balance);
849   }
850 
851   function _numberMinted(address owner) internal view returns (uint256) {
852     require(
853       owner != address(0),
854       "ERC721A: number minted query for the zero address"
855     );
856     return uint256(_addressData[owner].numberMinted);
857   }
858 
859   function ownershipOf(uint256 tokenId)
860     internal
861     view
862     returns (TokenOwnership memory)
863   {
864     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
865 
866     uint256 lowestTokenToCheck;
867     if (tokenId >= maxBatchSize) {
868       lowestTokenToCheck = tokenId - maxBatchSize + 1;
869     }
870 
871     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
872       TokenOwnership memory ownership = _ownerships[curr];
873       if (ownership.addr != address(0)) {
874         return ownership;
875       }
876     }
877 
878     revert("ERC721A: unable to determine the owner of token");
879   }
880 
881   /**
882    * @dev See {IERC721-ownerOf}.
883    */
884   function ownerOf(uint256 tokenId) public view override returns (address) {
885     return ownershipOf(tokenId).addr;
886   }
887 
888   /**
889    * @dev See {IERC721Metadata-name}.
890    */
891   function name() public view virtual override returns (string memory) {
892     return _name;
893   }
894 
895   /**
896    * @dev See {IERC721Metadata-symbol}.
897    */
898   function symbol() public view virtual override returns (string memory) {
899     return _symbol;
900   }
901 
902   /**
903    * @dev See {IERC721Metadata-tokenURI}.
904    */
905   function tokenURI(uint256 tokenId)
906     public
907     view
908     virtual
909     override
910     returns (string memory)
911   {
912     require(
913       _exists(tokenId),
914       "ERC721Metadata: URI query for nonexistent token"
915     );
916 
917     string memory baseURI = _baseURI();
918     return
919       bytes(baseURI).length > 0
920         ? string(abi.encodePacked(baseURI, tokenId.toString()))
921         : "";
922   }
923 
924   /**
925    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
926    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
927    * by default, can be overriden in child contracts.
928    */
929   function _baseURI() internal view virtual returns (string memory) {
930     return "";
931   }
932 
933   /**
934    * @dev See {IERC721-approve}.
935    */
936   function approve(address to, uint256 tokenId) public override {
937     address owner = ERC721A.ownerOf(tokenId);
938     require(to != owner, "ERC721A: approval to current owner");
939 
940     require(
941       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
942       "ERC721A: approve caller is not owner nor approved for all"
943     );
944 
945     _approve(to, tokenId, owner);
946   }
947 
948   /**
949    * @dev See {IERC721-getApproved}.
950    */
951   function getApproved(uint256 tokenId) public view override returns (address) {
952     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
953 
954     return _tokenApprovals[tokenId];
955   }
956 
957   /**
958    * @dev See {IERC721-setApprovalForAll}.
959    */
960   function setApprovalForAll(address operator, bool approved) public override {
961     require(operator != _msgSender(), "ERC721A: approve to caller");
962 
963     _operatorApprovals[_msgSender()][operator] = approved;
964     emit ApprovalForAll(_msgSender(), operator, approved);
965   }
966 
967   /**
968    * @dev See {IERC721-isApprovedForAll}.
969    */
970   function isApprovedForAll(address owner, address operator)
971     public
972     view
973     virtual
974     override
975     returns (bool)
976   {
977     return _operatorApprovals[owner][operator];
978   }
979 
980   /**
981    * @dev See {IERC721-transferFrom}.
982    */
983   function transferFrom(
984     address from,
985     address to,
986     uint256 tokenId
987   ) public override {
988     _transfer(from, to, tokenId);
989   }
990 
991   /**
992    * @dev See {IERC721-safeTransferFrom}.
993    */
994   function safeTransferFrom(
995     address from,
996     address to,
997     uint256 tokenId
998   ) public override {
999     safeTransferFrom(from, to, tokenId, "");
1000   }
1001 
1002   /**
1003    * @dev See {IERC721-safeTransferFrom}.
1004    */
1005   function safeTransferFrom(
1006     address from,
1007     address to,
1008     uint256 tokenId,
1009     bytes memory _data
1010   ) public override {
1011     _transfer(from, to, tokenId);
1012     require(
1013       _checkOnERC721Received(from, to, tokenId, _data),
1014       "ERC721A: transfer to non ERC721Receiver implementer"
1015     );
1016   }
1017 
1018   /**
1019    * @dev Returns whether `tokenId` exists.
1020    *
1021    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1022    *
1023    * Tokens start existing when they are minted (`_mint`),
1024    */
1025   function _exists(uint256 tokenId) internal view returns (bool) {
1026     return tokenId < currentIndex;
1027   }
1028 
1029   function _safeMint(address to, uint256 quantity) internal {
1030     _safeMint(to, quantity, "");
1031   }
1032 
1033   /**
1034    * @dev Mints `quantity` tokens and transfers them to `to`.
1035    *
1036    * Requirements:
1037    *
1038    * - there must be `quantity` tokens remaining unminted in the total collection.
1039    * - `to` cannot be the zero address.
1040    * - `quantity` cannot be larger than the max batch size.
1041    *
1042    * Emits a {Transfer} event.
1043    */
1044   function _safeMint(
1045     address to,
1046     uint256 quantity,
1047     bytes memory _data
1048   ) internal {
1049     uint256 startTokenId = currentIndex;
1050     require(to != address(0), "ERC721A: mint to the zero address");
1051     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1052     require(!_exists(startTokenId), "ERC721A: token already minted");
1053     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1054 
1055     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1056 
1057     AddressData memory addressData = _addressData[to];
1058     _addressData[to] = AddressData(
1059       addressData.balance + uint128(quantity),
1060       addressData.numberMinted + uint128(quantity)
1061     );
1062     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1063 
1064     uint256 updatedIndex = startTokenId;
1065 
1066     for (uint256 i = 0; i < quantity; i++) {
1067       emit Transfer(address(0), to, updatedIndex);
1068       require(
1069         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1070         "ERC721A: transfer to non ERC721Receiver implementer"
1071       );
1072       updatedIndex++;
1073     }
1074 
1075     currentIndex = updatedIndex;
1076     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1077   }
1078 
1079   /**
1080    * @dev Transfers `tokenId` from `from` to `to`.
1081    *
1082    * Requirements:
1083    *
1084    * - `to` cannot be the zero address.
1085    * - `tokenId` token must be owned by `from`.
1086    *
1087    * Emits a {Transfer} event.
1088    */
1089   function _transfer(
1090     address from,
1091     address to,
1092     uint256 tokenId
1093   ) private {
1094     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1095 
1096     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1097       getApproved(tokenId) == _msgSender() ||
1098       isApprovedForAll(prevOwnership.addr, _msgSender()));
1099 
1100     require(
1101       isApprovedOrOwner,
1102       "ERC721A: transfer caller is not owner nor approved"
1103     );
1104 
1105     require(
1106       prevOwnership.addr == from,
1107       "ERC721A: transfer from incorrect owner"
1108     );
1109     require(to != address(0), "ERC721A: transfer to the zero address");
1110 
1111     _beforeTokenTransfers(from, to, tokenId, 1);
1112 
1113     // Clear approvals from the previous owner
1114     _approve(address(0), tokenId, prevOwnership.addr);
1115 
1116     _addressData[from].balance -= 1;
1117     _addressData[to].balance += 1;
1118     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1119 
1120     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1121     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1122     uint256 nextTokenId = tokenId + 1;
1123     if (_ownerships[nextTokenId].addr == address(0)) {
1124       if (_exists(nextTokenId)) {
1125         _ownerships[nextTokenId] = TokenOwnership(
1126           prevOwnership.addr,
1127           prevOwnership.startTimestamp
1128         );
1129       }
1130     }
1131 
1132     emit Transfer(from, to, tokenId);
1133     _afterTokenTransfers(from, to, tokenId, 1);
1134   }
1135 
1136   /**
1137    * @dev Approve `to` to operate on `tokenId`
1138    *
1139    * Emits a {Approval} event.
1140    */
1141   function _approve(
1142     address to,
1143     uint256 tokenId,
1144     address owner
1145   ) private {
1146     _tokenApprovals[tokenId] = to;
1147     emit Approval(owner, to, tokenId);
1148   }
1149 
1150   uint256 public nextOwnerToExplicitlySet = 0;
1151 
1152   /**
1153    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1154    */
1155   function _setOwnersExplicit(uint256 quantity) internal {
1156     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1157     require(quantity > 0, "quantity must be nonzero");
1158     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1159     if (endIndex > collectionSize - 1) {
1160       endIndex = collectionSize - 1;
1161     }
1162     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1163     require(_exists(endIndex), "not enough minted yet for this cleanup");
1164     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1165       if (_ownerships[i].addr == address(0)) {
1166         TokenOwnership memory ownership = ownershipOf(i);
1167         _ownerships[i] = TokenOwnership(
1168           ownership.addr,
1169           ownership.startTimestamp
1170         );
1171       }
1172     }
1173     nextOwnerToExplicitlySet = endIndex + 1;
1174   }
1175 
1176   /**
1177    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1178    * The call is not executed if the target address is not a contract.
1179    *
1180    * @param from address representing the previous owner of the given token ID
1181    * @param to target address that will receive the tokens
1182    * @param tokenId uint256 ID of the token to be transferred
1183    * @param _data bytes optional data to send along with the call
1184    * @return bool whether the call correctly returned the expected magic value
1185    */
1186   function _checkOnERC721Received(
1187     address from,
1188     address to,
1189     uint256 tokenId,
1190     bytes memory _data
1191   ) private returns (bool) {
1192     if (to.isContract()) {
1193       try
1194         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1195       returns (bytes4 retval) {
1196         return retval == IERC721Receiver(to).onERC721Received.selector;
1197       } catch (bytes memory reason) {
1198         if (reason.length == 0) {
1199           revert("ERC721A: transfer to non ERC721Receiver implementer");
1200         } else {
1201           assembly {
1202             revert(add(32, reason), mload(reason))
1203           }
1204         }
1205       }
1206     } else {
1207       return true;
1208     }
1209   }
1210 
1211   /**
1212    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1213    *
1214    * startTokenId - the first token id to be transferred
1215    * quantity - the amount to be transferred
1216    *
1217    * Calling conditions:
1218    *
1219    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1220    * transferred to `to`.
1221    * - When `from` is zero, `tokenId` will be minted for `to`.
1222    */
1223   function _beforeTokenTransfers(
1224     address from,
1225     address to,
1226     uint256 startTokenId,
1227     uint256 quantity
1228   ) internal virtual {}
1229 
1230   /**
1231    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1232    * minting.
1233    *
1234    * startTokenId - the first token id to be transferred
1235    * quantity - the amount to be transferred
1236    *
1237    * Calling conditions:
1238    *
1239    * - when `from` and `to` are both non-zero.
1240    * - `from` and `to` are never both zero.
1241    */
1242   function _afterTokenTransfers(
1243     address from,
1244     address to,
1245     uint256 startTokenId,
1246     uint256 quantity
1247   ) internal virtual {}
1248 }
1249 // File: @openzeppelin/contracts/access/Ownable.sol
1250 
1251 
1252 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1253 
1254 pragma solidity ^0.8.0;
1255 
1256 
1257 /**
1258  * @dev Contract module which provides a basic access control mechanism, where
1259  * there is an account (an owner) that can be granted exclusive access to
1260  * specific functions.
1261  *
1262  * By default, the owner account will be the one that deploys the contract. This
1263  * can later be changed with {transferOwnership}.
1264  *
1265  * This module is used through inheritance. It will make available the modifier
1266  * `onlyOwner`, which can be applied to your functions to restrict their use to
1267  * the owner.
1268  */
1269 abstract contract Ownable is Context {
1270     address private _owner;
1271 
1272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1273 
1274     /**
1275      * @dev Initializes the contract setting the deployer as the initial owner.
1276      */
1277     constructor() {
1278         _transferOwnership(_msgSender());
1279     }
1280 
1281     /**
1282      * @dev Throws if called by any account other than the owner.
1283      */
1284     modifier onlyOwner() {
1285         _checkOwner();
1286         _;
1287     }
1288 
1289     /**
1290      * @dev Returns the address of the current owner.
1291      */
1292     function owner() public view virtual returns (address) {
1293         return _owner;
1294     }
1295 
1296     /**
1297      * @dev Throws if the sender is not the owner.
1298      */
1299     function _checkOwner() internal view virtual {
1300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1301     }
1302 
1303     /**
1304      * @dev Leaves the contract without owner. It will not be possible to call
1305      * `onlyOwner` functions anymore. Can only be called by the current owner.
1306      *
1307      * NOTE: Renouncing ownership will leave the contract without an owner,
1308      * thereby removing any functionality that is only available to the owner.
1309      */
1310     function renounceOwnership() public virtual onlyOwner {
1311         _transferOwnership(address(0));
1312     }
1313 
1314     /**
1315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1316      * Can only be called by the current owner.
1317      */
1318     function transferOwnership(address newOwner) public virtual onlyOwner {
1319         require(newOwner != address(0), "Ownable: new owner is the zero address");
1320         _transferOwnership(newOwner);
1321     }
1322 
1323     /**
1324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1325      * Internal function without access restriction.
1326      */
1327     function _transferOwnership(address newOwner) internal virtual {
1328         address oldOwner = _owner;
1329         _owner = newOwner;
1330         emit OwnershipTransferred(oldOwner, newOwner);
1331     }
1332 }
1333 
1334 // File: contracts/PhudgyPepes.sol
1335 
1336 
1337 pragma solidity ^0.8.0;
1338 
1339 
1340 
1341 
1342 contract PhudgyPepes is ERC721A, Ownable, ReentrancyGuard {
1343 
1344     mapping (address => uint256) public WalletMint;
1345     bool public MintStartEnabled  = false;
1346     uint public MintPrice = 0.003 ether; //0.003 ETH
1347     string public baseURI;  
1348     uint public freeMint = 2;
1349     uint public maxMintPerTx = 20;  
1350     uint public maxMint = 8888;
1351 
1352     constructor() ERC721A("Phudgy Pepes", "Phudgy Pepes",88,8888){}
1353 
1354     function mint(uint256 qty) external payable
1355     {
1356         require(MintStartEnabled , "Notice Phudgy Pepes:  Minting Public Pause");
1357         require(qty <= maxMintPerTx, "Notice Phudgy Pepes:  Limit Per Transaction");
1358         require(totalSupply() + qty <= maxMint,"Notice Phudgy Pepes:  Soldout");
1359         _safemint(qty);
1360     }
1361 
1362     function _safemint(uint256 qty) internal
1363     {
1364         if(WalletMint[msg.sender] < freeMint) 
1365         {
1366             if(qty < freeMint) qty = freeMint;
1367            require(msg.value >= (qty - freeMint) * MintPrice,"Notice Phudgy Pepes:  Claim Free NFT");
1368             WalletMint[msg.sender] += qty;
1369            _safeMint(msg.sender, qty);
1370         }
1371         else
1372         {
1373            require(msg.value >= qty * MintPrice,"Notice Phudgy Pepes:  Fund not enough");
1374             WalletMint[msg.sender] += qty;
1375            _safeMint(msg.sender, qty);
1376         }
1377     }
1378 
1379     function numberMinted(address owner) public view returns (uint256) {
1380         return _numberMinted(owner);
1381     }
1382 
1383     function _baseURI() internal view virtual override returns (string memory) {
1384         return baseURI;
1385     }
1386 
1387     function airdropNFT(address to ,uint256 qty) external onlyOwner
1388     {
1389         _safeMint(to, qty);
1390     }
1391 
1392     function OwnerBatchMint(uint256 qty) external onlyOwner
1393     {
1394         _safeMint(msg.sender, qty);
1395     }
1396 
1397     function setPublicMinting() external onlyOwner {
1398         MintStartEnabled  = !MintStartEnabled ;
1399     }
1400     
1401     function setBaseURI(string calldata baseURI_) external onlyOwner {
1402         baseURI = baseURI_;
1403     }
1404 
1405     function setPrice(uint256 price_) external onlyOwner {
1406         MintPrice = price_;
1407     }
1408 
1409     function setmaxMintPerTx(uint256 maxMintPerTx_) external onlyOwner {
1410         maxMintPerTx = maxMintPerTx_;
1411     }
1412 
1413     function setMaxFreeMint(uint256 qty_) external onlyOwner {
1414         freeMint = qty_;
1415     }
1416 
1417     function setmaxMint(uint256 maxMint_) external onlyOwner {
1418         maxMint = maxMint_;
1419     }
1420 
1421     function withdraw() public onlyOwner {
1422         payable(msg.sender).transfer(payable(address(this)).balance);
1423     }
1424 
1425 }