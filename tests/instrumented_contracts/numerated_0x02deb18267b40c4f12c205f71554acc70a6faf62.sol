1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      */
29     function isContract(address account) internal view returns (bool) {
30         // This method relies on extcodesize, which returns 0 for contracts in
31         // construction, since the code is only stored at the end of the
32         // constructor execution.
33 
34         uint256 size;
35         assembly {
36             size := extcodesize(account)
37         }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         (bool success, ) = recipient.call{value: amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain `call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
121      * with `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{value: value}(data);
135         return verifyCallResult(success, returndata, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
145         return functionStaticCall(target, data, "Address: low-level static call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal view returns (bytes memory) {
159         require(isContract(target), "Address: static call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.staticcall(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         require(isContract(target), "Address: delegate call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
194      * revert reason using the provided one.
195      *
196      * _Available since v4.3._
197      */
198     function verifyCallResult(
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal pure returns (bytes memory) {
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @title ERC721 token receiver interface
230  * @dev Interface for any contract that wants to support safeTransfers
231  * from ERC721 asset contracts.
232  */
233 interface IERC721Receiver {
234     /**
235      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
236      * by `operator` from `from`, this function is called.
237      *
238      * It must return its Solidity selector to confirm the token transfer.
239      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
240      *
241      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
242      */
243     function onERC721Received(
244         address operator,
245         address from,
246         uint256 tokenId,
247         bytes calldata data
248     ) external returns (bytes4);
249 }
250 
251 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Interface of the ERC165 standard, as defined in the
260  * https://eips.ethereum.org/EIPS/eip-165[EIP].
261  *
262  * Implementers can declare support of contract interfaces, which can then be
263  * queried by others ({ERC165Checker}).
264  *
265  * For an implementation, see {ERC165}.
266  */
267 interface IERC165 {
268     /**
269      * @dev Returns true if this contract implements the interface defined by
270      * `interfaceId`. See the corresponding
271      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
272      * to learn more about how these ids are created.
273      *
274      * This function call must use less than 30 000 gas.
275      */
276     function supportsInterface(bytes4 interfaceId) external view returns (bool);
277 }
278 
279 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
280 
281 
282 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 
287 /**
288  * @dev Implementation of the {IERC165} interface.
289  *
290  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
291  * for the additional interface id that will be supported. For example:
292  *
293  * ```solidity
294  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
295  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
296  * }
297  * ```
298  *
299  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
300  */
301 abstract contract ERC165 is IERC165 {
302     /**
303      * @dev See {IERC165-supportsInterface}.
304      */
305     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
306         return interfaceId == type(IERC165).interfaceId;
307     }
308 }
309 
310 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 
318 /**
319  * @dev Required interface of an ERC721 compliant contract.
320  */
321 interface IERC721 is IERC165 {
322     /**
323      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
324      */
325     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
326 
327     /**
328      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
329      */
330     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
334      */
335     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
336 
337     /**
338      * @dev Returns the number of tokens in ``owner``'s account.
339      */
340     function balanceOf(address owner) external view returns (uint256 balance);
341 
342     /**
343      * @dev Returns the owner of the `tokenId` token.
344      *
345      * Requirements:
346      *
347      * - `tokenId` must exist.
348      */
349     function ownerOf(uint256 tokenId) external view returns (address owner);
350 
351     /**
352      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
353      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `tokenId` token must exist and be owned by `from`.
360      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
362      *
363      * Emits a {Transfer} event.
364      */
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId
369     ) external;
370 
371     /**
372      * @dev Transfers `tokenId` token from `from` to `to`.
373      *
374      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `tokenId` token must be owned by `from`.
381      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transferFrom(
386         address from,
387         address to,
388         uint256 tokenId
389     ) external;
390 
391     /**
392      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
393      * The approval is cleared when the token is transferred.
394      *
395      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
396      *
397      * Requirements:
398      *
399      * - The caller must own the token or be an approved operator.
400      * - `tokenId` must exist.
401      *
402      * Emits an {Approval} event.
403      */
404     function approve(address to, uint256 tokenId) external;
405 
406     /**
407      * @dev Returns the account approved for `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function getApproved(uint256 tokenId) external view returns (address operator);
414 
415     /**
416      * @dev Approve or remove `operator` as an operator for the caller.
417      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
418      *
419      * Requirements:
420      *
421      * - The `operator` cannot be the caller.
422      *
423      * Emits an {ApprovalForAll} event.
424      */
425     function setApprovalForAll(address operator, bool _approved) external;
426 
427     /**
428      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
429      *
430      * See {setApprovalForAll}
431      */
432     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
453 }
454 
455 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 
463 /**
464  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
465  * @dev See https://eips.ethereum.org/EIPS/eip-721
466  */
467 interface IERC721Enumerable is IERC721 {
468     /**
469      * @dev Returns the total amount of tokens stored by the contract.
470      */
471     function totalSupply() external view returns (uint256);
472 
473     /**
474      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
475      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
476      */
477     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
478 
479     /**
480      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
481      * Use along with {totalSupply} to enumerate all tokens.
482      */
483     function tokenByIndex(uint256 index) external view returns (uint256);
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
496  * @dev See https://eips.ethereum.org/EIPS/eip-721
497  */
498 interface IERC721Metadata is IERC721 {
499     /**
500      * @dev Returns the token collection name.
501      */
502     function name() external view returns (string memory);
503 
504     /**
505      * @dev Returns the token collection symbol.
506      */
507     function symbol() external view returns (string memory);
508 
509     /**
510      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
511      */
512     function tokenURI(uint256 tokenId) external view returns (string memory);
513 }
514 
515 // File: @openzeppelin/contracts/utils/Strings.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev String operations.
524  */
525 library Strings {
526     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
527 
528     /**
529      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
530      */
531     function toString(uint256 value) internal pure returns (string memory) {
532         // Inspired by OraclizeAPI's implementation - MIT licence
533         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
534 
535         if (value == 0) {
536             return "0";
537         }
538         uint256 temp = value;
539         uint256 digits;
540         while (temp != 0) {
541             digits++;
542             temp /= 10;
543         }
544         bytes memory buffer = new bytes(digits);
545         while (value != 0) {
546             digits -= 1;
547             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
548             value /= 10;
549         }
550         return string(buffer);
551     }
552 
553     /**
554      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
555      */
556     function toHexString(uint256 value) internal pure returns (string memory) {
557         if (value == 0) {
558             return "0x00";
559         }
560         uint256 temp = value;
561         uint256 length = 0;
562         while (temp != 0) {
563             length++;
564             temp >>= 8;
565         }
566         return toHexString(value, length);
567     }
568 
569     /**
570      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
571      */
572     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
573         bytes memory buffer = new bytes(2 * length + 2);
574         buffer[0] = "0";
575         buffer[1] = "x";
576         for (uint256 i = 2 * length + 1; i > 1; --i) {
577             buffer[i] = _HEX_SYMBOLS[value & 0xf];
578             value >>= 4;
579         }
580         require(value == 0, "Strings: hex length insufficient");
581         return string(buffer);
582     }
583 }
584 
585 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Contract module that helps prevent reentrant calls to a function.
594  *
595  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
596  * available, which can be applied to functions to make sure there are no nested
597  * (reentrant) calls to them.
598  *
599  * Note that because there is a single `nonReentrant` guard, functions marked as
600  * `nonReentrant` may not call one another. This can be worked around by making
601  * those functions `private`, and then adding `external` `nonReentrant` entry
602  * points to them.
603  *
604  * TIP: If you would like to learn more about reentrancy and alternative ways
605  * to protect against it, check out our blog post
606  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
607  */
608 abstract contract ReentrancyGuard {
609     // Booleans are more expensive than uint256 or any type that takes up a full
610     // word because each write operation emits an extra SLOAD to first read the
611     // slot's contents, replace the bits taken up by the boolean, and then write
612     // back. This is the compiler's defense against contract upgrades and
613     // pointer aliasing, and it cannot be disabled.
614 
615     // The values being non-zero value makes deployment a bit more expensive,
616     // but in exchange the refund on every call to nonReentrant will be lower in
617     // amount. Since refunds are capped to a percentage of the total
618     // transaction's gas, it is best to keep them low in cases like this one, to
619     // increase the likelihood of the full refund coming into effect.
620     uint256 private constant _NOT_ENTERED = 1;
621     uint256 private constant _ENTERED = 2;
622 
623     uint256 private _status;
624 
625     constructor() {
626         _status = _NOT_ENTERED;
627     }
628 
629     /**
630      * @dev Prevents a contract from calling itself, directly or indirectly.
631      * Calling a `nonReentrant` function from another `nonReentrant`
632      * function is not supported. It is possible to prevent this from happening
633      * by making the `nonReentrant` function external, and making it call a
634      * `private` function that does the actual work.
635      */
636     modifier nonReentrant() {
637         // On the first call to nonReentrant, _notEntered will be true
638         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
639 
640         // Any calls to nonReentrant after this point will fail
641         _status = _ENTERED;
642 
643         _;
644 
645         // By storing the original value once again, a refund is triggered (see
646         // https://eips.ethereum.org/EIPS/eip-2200)
647         _status = _NOT_ENTERED;
648     }
649 }
650 
651 // File: @openzeppelin/contracts/utils/Context.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Provides information about the current execution context, including the
660  * sender of the transaction and its data. While these are generally available
661  * via msg.sender and msg.data, they should not be accessed in such a direct
662  * manner, since when dealing with meta-transactions the account sending and
663  * paying for execution may not be the actual sender (as far as an application
664  * is concerned).
665  *
666  * This contract is only required for intermediate, library-like contracts.
667  */
668 abstract contract Context {
669     function _msgSender() internal view virtual returns (address) {
670         return msg.sender;
671     }
672 
673     function _msgData() internal view virtual returns (bytes calldata) {
674         return msg.data;
675     }
676 }
677 
678 // File: ERC721A.sol
679 
680 
681 
682 pragma solidity ^0.8.0;
683 
684 
685 
686 
687 
688 
689 
690 
691 
692 /**
693  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
694  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
695  *
696  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
697  *
698  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
699  *
700  * Does not support burning tokens to address(0).
701  */
702 contract ERC721A is
703   Context,
704   ERC165,
705   IERC721,
706   IERC721Metadata,
707   IERC721Enumerable
708 {
709   using Address for address;
710   using Strings for uint256;
711 
712   struct TokenOwnership {
713     address addr;
714     uint64 startTimestamp;
715   }
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
735   mapping(uint256 => TokenOwnership) private _ownerships;
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
759       "ERC721A: collection must have a nonzero supply"
760     );
761     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
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
779     require(index < totalSupply(), "ERC721A: global index out of bounds");
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
794     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
795     uint256 numMintedSoFar = totalSupply();
796     uint256 tokenIdsIdx = 0;
797     address currOwnershipAddr = address(0);
798     for (uint256 i = 0; i < numMintedSoFar; i++) {
799       TokenOwnership memory ownership = _ownerships[i];
800       if (ownership.addr != address(0)) {
801         currOwnershipAddr = ownership.addr;
802       }
803       if (currOwnershipAddr == owner) {
804         if (tokenIdsIdx == index) {
805           return i;
806         }
807         tokenIdsIdx++;
808       }
809     }
810     revert("ERC721A: unable to get token of owner by index");
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
834     require(owner != address(0), "ERC721A: balance query for the zero address");
835     return uint256(_addressData[owner].balance);
836   }
837 
838   function _numberMinted(address owner) internal view returns (uint256) {
839     require(
840       owner != address(0),
841       "ERC721A: number minted query for the zero address"
842     );
843     return uint256(_addressData[owner].numberMinted);
844   }
845 
846   function ownershipOf(uint256 tokenId)
847     internal
848     view
849     returns (TokenOwnership memory)
850   {
851     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
852 
853     uint256 lowestTokenToCheck;
854     if (tokenId >= maxBatchSize) {
855       lowestTokenToCheck = tokenId - maxBatchSize + 1;
856     }
857 
858     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
859       TokenOwnership memory ownership = _ownerships[curr];
860       if (ownership.addr != address(0)) {
861         return ownership;
862       }
863     }
864 
865     revert("ERC721A: unable to determine the owner of token");
866   }
867 
868   /**
869    * @dev See {IERC721-ownerOf}.
870    */
871   function ownerOf(uint256 tokenId) public view override returns (address) {
872     return ownershipOf(tokenId).addr;
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
924     address owner = ERC721A.ownerOf(tokenId);
925     require(to != owner, "ERC721A: approval to current owner");
926 
927     require(
928       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
929       "ERC721A: approve caller is not owner nor approved for all"
930     );
931 
932     _approve(to, tokenId, owner);
933   }
934 
935   /**
936    * @dev See {IERC721-getApproved}.
937    */
938   function getApproved(uint256 tokenId) public view override returns (address) {
939     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
940 
941     return _tokenApprovals[tokenId];
942   }
943 
944   /**
945    * @dev See {IERC721-setApprovalForAll}.
946    */
947   function setApprovalForAll(address operator, bool approved) public override {
948     require(operator != _msgSender(), "ERC721A: approve to caller");
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
1001       "ERC721A: transfer to non ERC721Receiver implementer"
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
1037     require(to != address(0), "ERC721A: mint to the zero address");
1038     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1039     require(!_exists(startTokenId), "ERC721A: token already minted");
1040     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1041 
1042     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1043 
1044     AddressData memory addressData = _addressData[to];
1045     _addressData[to] = AddressData(
1046       addressData.balance + uint128(quantity),
1047       addressData.numberMinted + uint128(quantity)
1048     );
1049     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1050 
1051     uint256 updatedIndex = startTokenId;
1052 
1053     for (uint256 i = 0; i < quantity; i++) {
1054       emit Transfer(address(0), to, updatedIndex);
1055       require(
1056         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1057         "ERC721A: transfer to non ERC721Receiver implementer"
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
1081     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1082 
1083     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1084       getApproved(tokenId) == _msgSender() ||
1085       isApprovedForAll(prevOwnership.addr, _msgSender()));
1086 
1087     require(
1088       isApprovedOrOwner,
1089       "ERC721A: transfer caller is not owner nor approved"
1090     );
1091 
1092     require(
1093       prevOwnership.addr == from,
1094       "ERC721A: transfer from incorrect owner"
1095     );
1096     require(to != address(0), "ERC721A: transfer to the zero address");
1097 
1098     _beforeTokenTransfers(from, to, tokenId, 1);
1099 
1100     // Clear approvals from the previous owner
1101     _approve(address(0), tokenId, prevOwnership.addr);
1102 
1103     _addressData[from].balance -= 1;
1104     _addressData[to].balance += 1;
1105     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1106 
1107     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1108     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1109     uint256 nextTokenId = tokenId + 1;
1110     if (_ownerships[nextTokenId].addr == address(0)) {
1111       if (_exists(nextTokenId)) {
1112         _ownerships[nextTokenId] = TokenOwnership(
1113           prevOwnership.addr,
1114           prevOwnership.startTimestamp
1115         );
1116       }
1117     }
1118 
1119     emit Transfer(from, to, tokenId);
1120     _afterTokenTransfers(from, to, tokenId, 1);
1121   }
1122 
1123   /**
1124    * @dev Approve `to` to operate on `tokenId`
1125    *
1126    * Emits a {Approval} event.
1127    */
1128   function _approve(
1129     address to,
1130     uint256 tokenId,
1131     address owner
1132   ) private {
1133     _tokenApprovals[tokenId] = to;
1134     emit Approval(owner, to, tokenId);
1135   }
1136 
1137   uint256 public nextOwnerToExplicitlySet = 0;
1138 
1139   /**
1140    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1141    */
1142   function _setOwnersExplicit(uint256 quantity) internal {
1143     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1144     require(quantity > 0, "quantity must be nonzero");
1145     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1146     if (endIndex > collectionSize - 1) {
1147       endIndex = collectionSize - 1;
1148     }
1149     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1150     require(_exists(endIndex), "not enough minted yet for this cleanup");
1151     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1152       if (_ownerships[i].addr == address(0)) {
1153         TokenOwnership memory ownership = ownershipOf(i);
1154         _ownerships[i] = TokenOwnership(
1155           ownership.addr,
1156           ownership.startTimestamp
1157         );
1158       }
1159     }
1160     nextOwnerToExplicitlySet = endIndex + 1;
1161   }
1162 
1163   /**
1164    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1165    * The call is not executed if the target address is not a contract.
1166    *
1167    * @param from address representing the previous owner of the given token ID
1168    * @param to target address that will receive the tokens
1169    * @param tokenId uint256 ID of the token to be transferred
1170    * @param _data bytes optional data to send along with the call
1171    * @return bool whether the call correctly returned the expected magic value
1172    */
1173   function _checkOnERC721Received(
1174     address from,
1175     address to,
1176     uint256 tokenId,
1177     bytes memory _data
1178   ) private returns (bool) {
1179     if (to.isContract()) {
1180       try
1181         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1182       returns (bytes4 retval) {
1183         return retval == IERC721Receiver(to).onERC721Received.selector;
1184       } catch (bytes memory reason) {
1185         if (reason.length == 0) {
1186           revert("ERC721A: transfer to non ERC721Receiver implementer");
1187         } else {
1188           assembly {
1189             revert(add(32, reason), mload(reason))
1190           }
1191         }
1192       }
1193     } else {
1194       return true;
1195     }
1196   }
1197 
1198   /**
1199    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1200    *
1201    * startTokenId - the first token id to be transferred
1202    * quantity - the amount to be transferred
1203    *
1204    * Calling conditions:
1205    *
1206    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1207    * transferred to `to`.
1208    * - When `from` is zero, `tokenId` will be minted for `to`.
1209    */
1210   function _beforeTokenTransfers(
1211     address from,
1212     address to,
1213     uint256 startTokenId,
1214     uint256 quantity
1215   ) internal virtual {}
1216 
1217   /**
1218    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1219    * minting.
1220    *
1221    * startTokenId - the first token id to be transferred
1222    * quantity - the amount to be transferred
1223    *
1224    * Calling conditions:
1225    *
1226    * - when `from` and `to` are both non-zero.
1227    * - `from` and `to` are never both zero.
1228    */
1229   function _afterTokenTransfers(
1230     address from,
1231     address to,
1232     uint256 startTokenId,
1233     uint256 quantity
1234   ) internal virtual {}
1235 }
1236 // File: @openzeppelin/contracts/access/Ownable.sol
1237 
1238 
1239 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1240 
1241 pragma solidity ^0.8.0;
1242 
1243 
1244 /**
1245  * @dev Contract module which provides a basic access control mechanism, where
1246  * there is an account (an owner) that can be granted exclusive access to
1247  * specific functions.
1248  *
1249  * By default, the owner account will be the one that deploys the contract. This
1250  * can later be changed with {transferOwnership}.
1251  *
1252  * This module is used through inheritance. It will make available the modifier
1253  * `onlyOwner`, which can be applied to your functions to restrict their use to
1254  * the owner.
1255  */
1256 abstract contract Ownable is Context {
1257     address private _owner;
1258 
1259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1260 
1261     /**
1262      * @dev Initializes the contract setting the deployer as the initial owner.
1263      */
1264     constructor() {
1265         _transferOwnership(_msgSender());
1266     }
1267 
1268     /**
1269      * @dev Returns the address of the current owner.
1270      */
1271     function owner() public view virtual returns (address) {
1272         return _owner;
1273     }
1274 
1275     /**
1276      * @dev Throws if called by any account other than the owner.
1277      */
1278     modifier onlyOwner() {
1279         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1280         _;
1281     }
1282 
1283     /**
1284      * @dev Leaves the contract without owner. It will not be possible to call
1285      * `onlyOwner` functions anymore. Can only be called by the current owner.
1286      *
1287      * NOTE: Renouncing ownership will leave the contract without an owner,
1288      * thereby removing any functionality that is only available to the owner.
1289      */
1290     function renounceOwnership() public virtual onlyOwner {
1291         _transferOwnership(address(0));
1292     }
1293 
1294     /**
1295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1296      * Can only be called by the current owner.
1297      */
1298     function transferOwnership(address newOwner) public virtual onlyOwner {
1299         require(newOwner != address(0), "Ownable: new owner is the zero address");
1300         _transferOwnership(newOwner);
1301     }
1302 
1303     /**
1304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1305      * Internal function without access restriction.
1306      */
1307     function _transferOwnership(address newOwner) internal virtual {
1308         address oldOwner = _owner;
1309         _owner = newOwner;
1310         emit OwnershipTransferred(oldOwner, newOwner);
1311     }
1312 }
1313 
1314 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1315 
1316 
1317 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1318 
1319 pragma solidity ^0.8.0;
1320 
1321 /**
1322  * @dev These functions deal with verification of Merkle Trees proofs.
1323  *
1324  * The proofs can be generated using the JavaScript library
1325  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1326  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1327  *
1328  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1329  */
1330 library MerkleProof {
1331     /**
1332      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1333      * defined by `root`. For this, a `proof` must be provided, containing
1334      * sibling hashes on the branch from the leaf to the root of the tree. Each
1335      * pair of leaves and each pair of pre-images are assumed to be sorted.
1336      */
1337     function verify(
1338         bytes32[] memory proof,
1339         bytes32 root,
1340         bytes32 leaf
1341     ) internal pure returns (bool) {
1342         return processProof(proof, leaf) == root;
1343     }
1344 
1345     /**
1346      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1347      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1348      * hash matches the root of the tree. When processing the proof, the pairs
1349      * of leafs & pre-images are assumed to be sorted.
1350      *
1351      * _Available since v4.4._
1352      */
1353     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1354         bytes32 computedHash = leaf;
1355         for (uint256 i = 0; i < proof.length; i++) {
1356             bytes32 proofElement = proof[i];
1357             if (computedHash <= proofElement) {
1358                 // Hash(current computed hash + current element of the proof)
1359                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1360             } else {
1361                 // Hash(current element of the proof + current computed hash)
1362                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1363             }
1364         }
1365         return computedHash;
1366     }
1367 }
1368 
1369 // File: SpacePals.sol
1370 
1371 
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 
1376 
1377 
1378 
1379 
1380 // 1FF16B3BACDB1B066433946DF5E8A49F
1381 contract SpacePals is Ownable, ERC721A, ReentrancyGuard {
1382     uint256 public constant PRICE = 0.1 ether;
1383     uint256 public constant MAX_PALS_PURCHASE = 2;
1384     uint256 public constant MAX_PALS = 10000;
1385     uint256 public constant MAX_BATCH_SIZE = 5;
1386     address private constant PALS_TEAM = 0x9A4d2B0AA37FF77dBCf8281bcE1Ba2518f5386E1;
1387 
1388     bool public isPresaleLive = false;
1389     bool public isPublicLive = false;
1390 
1391     bytes32 public merkleRoot;
1392     mapping(address => uint256) public presaleAddressMintCount;
1393     mapping(address => uint256) public publicAddressMintCount;
1394 
1395     string private _baseTokenURI;
1396 
1397     constructor() ERC721A("Space Pals", "PALS", MAX_BATCH_SIZE, MAX_PALS) {
1398     }
1399 
1400     modifier mintGuard(uint256 tokenCount) {
1401         require(msg.sender == tx.origin, "No cheating");
1402         require(PRICE * tokenCount <= msg.value, "Wrong ether value");
1403         require(totalSupply() + tokenCount <= MAX_PALS, "Not enough supply");
1404         require(tokenCount <= MAX_PALS_PURCHASE, "Exceeds token txn limit ");
1405         _;
1406     }
1407 
1408     function reservePALS(uint256 amount) external onlyOwner {
1409         require(totalSupply() + amount <= MAX_PALS, "Not enough supply");
1410         require(amount % MAX_BATCH_SIZE == 0);
1411 
1412         uint256 chunks = amount / MAX_BATCH_SIZE;
1413         for (uint256 i = 0; i < chunks; i++) {
1414             _safeMint(msg.sender, MAX_BATCH_SIZE);
1415         }
1416     }
1417 
1418     function mint(uint256 amount) external payable mintGuard(amount) {
1419         require(isPublicLive, "Sale not live");
1420         require(publicAddressMintCount[msg.sender] + amount <= MAX_PALS_PURCHASE, "Address already minted allocation");
1421         
1422         publicAddressMintCount[msg.sender] += amount;
1423         _safeMint(msg.sender, amount);
1424     }
1425 
1426     function mintPresale(bytes32[] calldata proof, uint256 amount) external payable mintGuard(amount) {
1427         require(isPresaleLive, "Presale not live");
1428         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not eligible");
1429         require(presaleAddressMintCount[msg.sender] + amount <= MAX_PALS_PURCHASE, "Address already minted allocation");
1430         
1431         presaleAddressMintCount[msg.sender] += amount;
1432         _safeMint(msg.sender, amount);
1433     }
1434 
1435     function setMerkleRoot(bytes32 root) external onlyOwner {
1436         merkleRoot = root;
1437     }
1438 
1439     function flipPublicState() external onlyOwner {
1440         isPublicLive = !isPublicLive;
1441     }
1442 
1443     function flipPresaleState() external onlyOwner {
1444         isPresaleLive = !isPresaleLive;
1445     }
1446 
1447     function setBaseURI(string calldata baseURI) external onlyOwner {
1448         _baseTokenURI = baseURI;
1449     }
1450 
1451     function _baseURI() internal view virtual override returns (string memory) {
1452         return _baseTokenURI;
1453     }
1454 
1455     function withdraw() external onlyOwner {
1456         payable(PALS_TEAM).transfer(address(this).balance);
1457     }
1458 }