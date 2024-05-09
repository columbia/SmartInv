1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
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
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Approve or remove `operator` as an operator for the caller.
433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Metadata is IERC721 {
473     /**
474      * @dev Returns the token collection name.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the token collection symbol.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
485      */
486     function tokenURI(uint256 tokenId) external view returns (string memory);
487 }
488 
489 // File: @openzeppelin/contracts/utils/Strings.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev String operations.
498  */
499 library Strings {
500     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
504      */
505     function toString(uint256 value) internal pure returns (string memory) {
506         // Inspired by OraclizeAPI's implementation - MIT licence
507         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
508 
509         if (value == 0) {
510             return "0";
511         }
512         uint256 temp = value;
513         uint256 digits;
514         while (temp != 0) {
515             digits++;
516             temp /= 10;
517         }
518         bytes memory buffer = new bytes(digits);
519         while (value != 0) {
520             digits -= 1;
521             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
522             value /= 10;
523         }
524         return string(buffer);
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
529      */
530     function toHexString(uint256 value) internal pure returns (string memory) {
531         if (value == 0) {
532             return "0x00";
533         }
534         uint256 temp = value;
535         uint256 length = 0;
536         while (temp != 0) {
537             length++;
538             temp >>= 8;
539         }
540         return toHexString(value, length);
541     }
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
545      */
546     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
547         bytes memory buffer = new bytes(2 * length + 2);
548         buffer[0] = "0";
549         buffer[1] = "x";
550         for (uint256 i = 2 * length + 1; i > 1; --i) {
551             buffer[i] = _HEX_SYMBOLS[value & 0xf];
552             value >>= 4;
553         }
554         require(value == 0, "Strings: hex length insufficient");
555         return string(buffer);
556     }
557 }
558 
559 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Contract module that helps prevent reentrant calls to a function.
568  *
569  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
570  * available, which can be applied to functions to make sure there are no nested
571  * (reentrant) calls to them.
572  *
573  * Note that because there is a single `nonReentrant` guard, functions marked as
574  * `nonReentrant` may not call one another. This can be worked around by making
575  * those functions `private`, and then adding `external` `nonReentrant` entry
576  * points to them.
577  *
578  * TIP: If you would like to learn more about reentrancy and alternative ways
579  * to protect against it, check out our blog post
580  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
581  */
582 abstract contract ReentrancyGuard {
583     // Booleans are more expensive than uint256 or any type that takes up a full
584     // word because each write operation emits an extra SLOAD to first read the
585     // slot's contents, replace the bits taken up by the boolean, and then write
586     // back. This is the compiler's defense against contract upgrades and
587     // pointer aliasing, and it cannot be disabled.
588 
589     // The values being non-zero value makes deployment a bit more expensive,
590     // but in exchange the refund on every call to nonReentrant will be lower in
591     // amount. Since refunds are capped to a percentage of the total
592     // transaction's gas, it is best to keep them low in cases like this one, to
593     // increase the likelihood of the full refund coming into effect.
594     uint256 private constant _NOT_ENTERED = 1;
595     uint256 private constant _ENTERED = 2;
596 
597     uint256 private _status;
598 
599     constructor() {
600         _status = _NOT_ENTERED;
601     }
602 
603     /**
604      * @dev Prevents a contract from calling itself, directly or indirectly.
605      * Calling a `nonReentrant` function from another `nonReentrant`
606      * function is not supported. It is possible to prevent this from happening
607      * by making the `nonReentrant` function external, and making it call a
608      * `private` function that does the actual work.
609      */
610     modifier nonReentrant() {
611         // On the first call to nonReentrant, _notEntered will be true
612         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
613 
614         // Any calls to nonReentrant after this point will fail
615         _status = _ENTERED;
616 
617         _;
618 
619         // By storing the original value once again, a refund is triggered (see
620         // https://eips.ethereum.org/EIPS/eip-2200)
621         _status = _NOT_ENTERED;
622     }
623 }
624 
625 // File: @openzeppelin/contracts/utils/Context.sol
626 
627 
628 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev Provides information about the current execution context, including the
634  * sender of the transaction and its data. While these are generally available
635  * via msg.sender and msg.data, they should not be accessed in such a direct
636  * manner, since when dealing with meta-transactions the account sending and
637  * paying for execution may not be the actual sender (as far as an application
638  * is concerned).
639  *
640  * This contract is only required for intermediate, library-like contracts.
641  */
642 abstract contract Context {
643     function _msgSender() internal view virtual returns (address) {
644         return msg.sender;
645     }
646 
647     function _msgData() internal view virtual returns (bytes calldata) {
648         return msg.data;
649     }
650 }
651 
652 // File: erc721a/contracts/ERC721A.sol
653 
654 
655 // Creator: Chiru Labs
656 
657 pragma solidity ^0.8.4;
658 
659 
660 
661 
662 
663 
664 
665 
666 error ApprovalCallerNotOwnerNorApproved();
667 error ApprovalQueryForNonexistentToken();
668 error ApproveToCaller();
669 error ApprovalToCurrentOwner();
670 error BalanceQueryForZeroAddress();
671 error MintToZeroAddress();
672 error MintZeroQuantity();
673 error OwnerQueryForNonexistentToken();
674 error TransferCallerNotOwnerNorApproved();
675 error TransferFromIncorrectOwner();
676 error TransferToNonERC721ReceiverImplementer();
677 error TransferToZeroAddress();
678 error URIQueryForNonexistentToken();
679 
680 /**
681  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
682  * the Metadata extension. Built to optimize for lower gas during batch mints.
683  *
684  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
685  *
686  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
687  *
688  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
689  */
690 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
691     using Address for address;
692     using Strings for uint256;
693 
694     // Compiler will pack this into a single 256bit word.
695     struct TokenOwnership {
696         // The address of the owner.
697         address addr;
698         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
699         uint64 startTimestamp;
700         // Whether the token has been burned.
701         bool burned;
702     }
703 
704     // Compiler will pack this into a single 256bit word.
705     struct AddressData {
706         // Realistically, 2**64-1 is more than enough.
707         uint64 balance;
708         // Keeps track of mint count with minimal overhead for tokenomics.
709         uint64 numberMinted;
710         // Keeps track of burn count with minimal overhead for tokenomics.
711         uint64 numberBurned;
712         // For miscellaneous variable(s) pertaining to the address
713         // (e.g. number of whitelist mint slots used).
714         // If there are multiple variables, please pack them into a uint64.
715         uint64 aux;
716     }
717 
718     // The tokenId of the next token to be minted.
719     uint256 internal _currentIndex;
720 
721     // The number of tokens burned.
722     uint256 internal _burnCounter;
723 
724     // Token name
725     string private _name;
726 
727     // Token symbol
728     string private _symbol;
729 
730     // Mapping from token ID to ownership details
731     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
732     mapping(uint256 => TokenOwnership) internal _ownerships;
733 
734     // Mapping owner address to address data
735     mapping(address => AddressData) private _addressData;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     constructor(string memory name_, string memory symbol_) {
744         _name = name_;
745         _symbol = symbol_;
746         _currentIndex = _startTokenId();
747     }
748 
749     /**
750      * To change the starting tokenId, please override this function.
751      */
752     function _startTokenId() internal view virtual returns (uint256) {
753         return 0;
754     }
755 
756     /**
757      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
758      */
759     function totalSupply() public view returns (uint256) {
760         // Counter underflow is impossible as _burnCounter cannot be incremented
761         // more than _currentIndex - _startTokenId() times
762         unchecked {
763             return _currentIndex - _burnCounter - _startTokenId();
764         }
765     }
766 
767     /**
768      * Returns the total amount of tokens minted in the contract.
769      */
770     function _totalMinted() internal view returns (uint256) {
771         // Counter underflow is impossible as _currentIndex does not decrement,
772         // and it is initialized to _startTokenId()
773         unchecked {
774             return _currentIndex - _startTokenId();
775         }
776     }
777 
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
782         return
783             interfaceId == type(IERC721).interfaceId ||
784             interfaceId == type(IERC721Metadata).interfaceId ||
785             super.supportsInterface(interfaceId);
786     }
787 
788     /**
789      * @dev See {IERC721-balanceOf}.
790      */
791     function balanceOf(address owner) public view override returns (uint256) {
792         if (owner == address(0)) revert BalanceQueryForZeroAddress();
793         return uint256(_addressData[owner].balance);
794     }
795 
796     /**
797      * Returns the number of tokens minted by `owner`.
798      */
799     function _numberMinted(address owner) internal view returns (uint256) {
800         return uint256(_addressData[owner].numberMinted);
801     }
802 
803     /**
804      * Returns the number of tokens burned by or on behalf of `owner`.
805      */
806     function _numberBurned(address owner) internal view returns (uint256) {
807         return uint256(_addressData[owner].numberBurned);
808     }
809 
810     /**
811      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
812      */
813     function _getAux(address owner) internal view returns (uint64) {
814         return _addressData[owner].aux;
815     }
816 
817     /**
818      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
819      * If there are multiple variables, please pack them into a uint64.
820      */
821     function _setAux(address owner, uint64 aux) internal {
822         _addressData[owner].aux = aux;
823     }
824 
825     /**
826      * Gas spent here starts off proportional to the maximum mint batch size.
827      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
828      */
829     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
830         uint256 curr = tokenId;
831 
832         unchecked {
833             if (_startTokenId() <= curr && curr < _currentIndex) {
834                 TokenOwnership memory ownership = _ownerships[curr];
835                 if (!ownership.burned) {
836                     if (ownership.addr != address(0)) {
837                         return ownership;
838                     }
839                     // Invariant:
840                     // There will always be an ownership that has an address and is not burned
841                     // before an ownership that does not have an address and is not burned.
842                     // Hence, curr will not underflow.
843                     while (true) {
844                         curr--;
845                         ownership = _ownerships[curr];
846                         if (ownership.addr != address(0)) {
847                             return ownership;
848                         }
849                     }
850                 }
851             }
852         }
853         revert OwnerQueryForNonexistentToken();
854     }
855 
856     /**
857      * @dev See {IERC721-ownerOf}.
858      */
859     function ownerOf(uint256 tokenId) public view override returns (address) {
860         return _ownershipOf(tokenId).addr;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-name}.
865      */
866     function name() public view virtual override returns (string memory) {
867         return _name;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-symbol}.
872      */
873     function symbol() public view virtual override returns (string memory) {
874         return _symbol;
875     }
876 
877     /**
878      * @dev See {IERC721Metadata-tokenURI}.
879      */
880     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
881         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
882 
883         string memory baseURI = _baseURI();
884         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
885     }
886 
887     /**
888      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
889      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
890      * by default, can be overriden in child contracts.
891      */
892     function _baseURI() internal view virtual returns (string memory) {
893         return '';
894     }
895 
896     /**
897      * @dev See {IERC721-approve}.
898      */
899     function approve(address to, uint256 tokenId) public override {
900         address owner = ERC721A.ownerOf(tokenId);
901         if (to == owner) revert ApprovalToCurrentOwner();
902 
903         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
904             revert ApprovalCallerNotOwnerNorApproved();
905         }
906 
907         _approve(to, tokenId, owner);
908     }
909 
910     /**
911      * @dev See {IERC721-getApproved}.
912      */
913     function getApproved(uint256 tokenId) public view override returns (address) {
914         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
915 
916         return _tokenApprovals[tokenId];
917     }
918 
919     /**
920      * @dev See {IERC721-setApprovalForAll}.
921      */
922     function setApprovalForAll(address operator, bool approved) public virtual override {
923         if (operator == _msgSender()) revert ApproveToCaller();
924 
925         _operatorApprovals[_msgSender()][operator] = approved;
926         emit ApprovalForAll(_msgSender(), operator, approved);
927     }
928 
929     /**
930      * @dev See {IERC721-isApprovedForAll}.
931      */
932     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
933         return _operatorApprovals[owner][operator];
934     }
935 
936     /**
937      * @dev See {IERC721-transferFrom}.
938      */
939     function transferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public virtual override {
944         _transfer(from, to, tokenId);
945     }
946 
947     /**
948      * @dev See {IERC721-safeTransferFrom}.
949      */
950     function safeTransferFrom(
951         address from,
952         address to,
953         uint256 tokenId
954     ) public virtual override {
955         safeTransferFrom(from, to, tokenId, '');
956     }
957 
958     /**
959      * @dev See {IERC721-safeTransferFrom}.
960      */
961     function safeTransferFrom(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) public virtual override {
967         _transfer(from, to, tokenId);
968         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
969             revert TransferToNonERC721ReceiverImplementer();
970         }
971     }
972 
973     /**
974      * @dev Returns whether `tokenId` exists.
975      *
976      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
977      *
978      * Tokens start existing when they are minted (`_mint`),
979      */
980     function _exists(uint256 tokenId) internal view returns (bool) {
981         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
982     }
983 
984     function _safeMint(address to, uint256 quantity) internal {
985         _safeMint(to, quantity, '');
986     }
987 
988     /**
989      * @dev Safely mints `quantity` tokens and transfers them to `to`.
990      *
991      * Requirements:
992      *
993      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
994      * - `quantity` must be greater than 0.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _safeMint(
999         address to,
1000         uint256 quantity,
1001         bytes memory _data
1002     ) internal {
1003         _mint(to, quantity, _data, true);
1004     }
1005 
1006     /**
1007      * @dev Mints `quantity` tokens and transfers them to `to`.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `quantity` must be greater than 0.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _mint(
1017         address to,
1018         uint256 quantity,
1019         bytes memory _data,
1020         bool safe
1021     ) internal {
1022         uint256 startTokenId = _currentIndex;
1023         if (to == address(0)) revert MintToZeroAddress();
1024         if (quantity == 0) revert MintZeroQuantity();
1025 
1026         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1027 
1028         // Overflows are incredibly unrealistic.
1029         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1030         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1031         unchecked {
1032             _addressData[to].balance += uint64(quantity);
1033             _addressData[to].numberMinted += uint64(quantity);
1034 
1035             _ownerships[startTokenId].addr = to;
1036             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1037 
1038             uint256 updatedIndex = startTokenId;
1039             uint256 end = updatedIndex + quantity;
1040 
1041             if (safe && to.isContract()) {
1042                 do {
1043                     emit Transfer(address(0), to, updatedIndex);
1044                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1045                         revert TransferToNonERC721ReceiverImplementer();
1046                     }
1047                 } while (updatedIndex != end);
1048                 // Reentrancy protection
1049                 if (_currentIndex != startTokenId) revert();
1050             } else {
1051                 do {
1052                     emit Transfer(address(0), to, updatedIndex++);
1053                 } while (updatedIndex != end);
1054             }
1055             _currentIndex = updatedIndex;
1056         }
1057         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1058     }
1059 
1060     /**
1061      * @dev Transfers `tokenId` from `from` to `to`.
1062      *
1063      * Requirements:
1064      *
1065      * - `to` cannot be the zero address.
1066      * - `tokenId` token must be owned by `from`.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _transfer(
1071         address from,
1072         address to,
1073         uint256 tokenId
1074     ) private {
1075         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1076 
1077         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1078 
1079         bool isApprovedOrOwner = (_msgSender() == from ||
1080             isApprovedForAll(from, _msgSender()) ||
1081             getApproved(tokenId) == _msgSender());
1082 
1083         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1084         if (to == address(0)) revert TransferToZeroAddress();
1085 
1086         _beforeTokenTransfers(from, to, tokenId, 1);
1087 
1088         // Clear approvals from the previous owner
1089         _approve(address(0), tokenId, from);
1090 
1091         // Underflow of the sender's balance is impossible because we check for
1092         // ownership above and the recipient's balance can't realistically overflow.
1093         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1094         unchecked {
1095             _addressData[from].balance -= 1;
1096             _addressData[to].balance += 1;
1097 
1098             TokenOwnership storage currSlot = _ownerships[tokenId];
1099             currSlot.addr = to;
1100             currSlot.startTimestamp = uint64(block.timestamp);
1101 
1102             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1103             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1104             uint256 nextTokenId = tokenId + 1;
1105             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1106             if (nextSlot.addr == address(0)) {
1107                 // This will suffice for checking _exists(nextTokenId),
1108                 // as a burned slot cannot contain the zero address.
1109                 if (nextTokenId != _currentIndex) {
1110                     nextSlot.addr = from;
1111                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1112                 }
1113             }
1114         }
1115 
1116         emit Transfer(from, to, tokenId);
1117         _afterTokenTransfers(from, to, tokenId, 1);
1118     }
1119 
1120     /**
1121      * @dev This is equivalent to _burn(tokenId, false)
1122      */
1123     function _burn(uint256 tokenId) internal virtual {
1124         _burn(tokenId, false);
1125     }
1126 
1127     /**
1128      * @dev Destroys `tokenId`.
1129      * The approval is cleared when the token is burned.
1130      *
1131      * Requirements:
1132      *
1133      * - `tokenId` must exist.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1138         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1139 
1140         address from = prevOwnership.addr;
1141 
1142         if (approvalCheck) {
1143             bool isApprovedOrOwner = (_msgSender() == from ||
1144                 isApprovedForAll(from, _msgSender()) ||
1145                 getApproved(tokenId) == _msgSender());
1146 
1147             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1148         }
1149 
1150         _beforeTokenTransfers(from, address(0), tokenId, 1);
1151 
1152         // Clear approvals from the previous owner
1153         _approve(address(0), tokenId, from);
1154 
1155         // Underflow of the sender's balance is impossible because we check for
1156         // ownership above and the recipient's balance can't realistically overflow.
1157         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1158         unchecked {
1159             AddressData storage addressData = _addressData[from];
1160             addressData.balance -= 1;
1161             addressData.numberBurned += 1;
1162 
1163             // Keep track of who burned the token, and the timestamp of burning.
1164             TokenOwnership storage currSlot = _ownerships[tokenId];
1165             currSlot.addr = from;
1166             currSlot.startTimestamp = uint64(block.timestamp);
1167             currSlot.burned = true;
1168 
1169             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1170             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1171             uint256 nextTokenId = tokenId + 1;
1172             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1173             if (nextSlot.addr == address(0)) {
1174                 // This will suffice for checking _exists(nextTokenId),
1175                 // as a burned slot cannot contain the zero address.
1176                 if (nextTokenId != _currentIndex) {
1177                     nextSlot.addr = from;
1178                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1179                 }
1180             }
1181         }
1182 
1183         emit Transfer(from, address(0), tokenId);
1184         _afterTokenTransfers(from, address(0), tokenId, 1);
1185 
1186         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1187         unchecked {
1188             _burnCounter++;
1189         }
1190     }
1191 
1192     /**
1193      * @dev Approve `to` to operate on `tokenId`
1194      *
1195      * Emits a {Approval} event.
1196      */
1197     function _approve(
1198         address to,
1199         uint256 tokenId,
1200         address owner
1201     ) private {
1202         _tokenApprovals[tokenId] = to;
1203         emit Approval(owner, to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1208      *
1209      * @param from address representing the previous owner of the given token ID
1210      * @param to target address that will receive the tokens
1211      * @param tokenId uint256 ID of the token to be transferred
1212      * @param _data bytes optional data to send along with the call
1213      * @return bool whether the call correctly returned the expected magic value
1214      */
1215     function _checkContractOnERC721Received(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) private returns (bool) {
1221         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1222             return retval == IERC721Receiver(to).onERC721Received.selector;
1223         } catch (bytes memory reason) {
1224             if (reason.length == 0) {
1225                 revert TransferToNonERC721ReceiverImplementer();
1226             } else {
1227                 assembly {
1228                     revert(add(32, reason), mload(reason))
1229                 }
1230             }
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1236      * And also called before burning one token.
1237      *
1238      * startTokenId - the first token id to be transferred
1239      * quantity - the amount to be transferred
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` will be minted for `to`.
1246      * - When `to` is zero, `tokenId` will be burned by `from`.
1247      * - `from` and `to` are never both zero.
1248      */
1249     function _beforeTokenTransfers(
1250         address from,
1251         address to,
1252         uint256 startTokenId,
1253         uint256 quantity
1254     ) internal virtual {}
1255 
1256     /**
1257      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1258      * minting.
1259      * And also called after one token has been burned.
1260      *
1261      * startTokenId - the first token id to be transferred
1262      * quantity - the amount to be transferred
1263      *
1264      * Calling conditions:
1265      *
1266      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1267      * transferred to `to`.
1268      * - When `from` is zero, `tokenId` has been minted for `to`.
1269      * - When `to` is zero, `tokenId` has been burned by `from`.
1270      * - `from` and `to` are never both zero.
1271      */
1272     function _afterTokenTransfers(
1273         address from,
1274         address to,
1275         uint256 startTokenId,
1276         uint256 quantity
1277     ) internal virtual {}
1278 }
1279 
1280 // File: @openzeppelin/contracts/access/Ownable.sol
1281 
1282 
1283 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1284 
1285 pragma solidity ^0.8.0;
1286 
1287 
1288 /**
1289  * @dev Contract module which provides a basic access control mechanism, where
1290  * there is an account (an owner) that can be granted exclusive access to
1291  * specific functions.
1292  *
1293  * By default, the owner account will be the one that deploys the contract. This
1294  * can later be changed with {transferOwnership}.
1295  *
1296  * This module is used through inheritance. It will make available the modifier
1297  * `onlyOwner`, which can be applied to your functions to restrict their use to
1298  * the owner.
1299  */
1300 abstract contract Ownable is Context {
1301     address private _owner;
1302 
1303     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1304 
1305     /**
1306      * @dev Initializes the contract setting the deployer as the initial owner.
1307      */
1308     constructor() {
1309         _transferOwnership(_msgSender());
1310     }
1311 
1312     /**
1313      * @dev Returns the address of the current owner.
1314      */
1315     function owner() public view virtual returns (address) {
1316         return _owner;
1317     }
1318 
1319     /**
1320      * @dev Throws if called by any account other than the owner.
1321      */
1322     modifier onlyOwner() {
1323         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1324         _;
1325     }
1326 
1327     /**
1328      * @dev Leaves the contract without owner. It will not be possible to call
1329      * `onlyOwner` functions anymore. Can only be called by the current owner.
1330      *
1331      * NOTE: Renouncing ownership will leave the contract without an owner,
1332      * thereby removing any functionality that is only available to the owner.
1333      */
1334     function renounceOwnership() public virtual onlyOwner {
1335         _transferOwnership(address(0));
1336     }
1337 
1338     /**
1339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1340      * Can only be called by the current owner.
1341      */
1342     function transferOwnership(address newOwner) public virtual onlyOwner {
1343         require(newOwner != address(0), "Ownable: new owner is the zero address");
1344         _transferOwnership(newOwner);
1345     }
1346 
1347     /**
1348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1349      * Internal function without access restriction.
1350      */
1351     function _transferOwnership(address newOwner) internal virtual {
1352         address oldOwner = _owner;
1353         _owner = newOwner;
1354         emit OwnershipTransferred(oldOwner, newOwner);
1355     }
1356 }
1357 
1358 // File: contracts/JidoriMale.sol
1359 
1360 
1361 /*
1362 ┌───────┐        ┌─┐                       ┌────────┐
1363 └──┐ ┌──┘        | |                       |      ○ | 
1364    | |           | |                       |        | 
1365    | |         __| |   ___    _  __        |        | 
1366    | |   ●   / __  |  / _ \  | |/ / ●      |  FIND  | 
1367 __ | |  ┌─┐ / /  | | | | | | |  /  ┌─┐     |  YOUR  |          
1368 \ \/ /  | | | \__| | | |_| | | |   | |     | SELFIE | 
1369  \__/   |_|  \_____|  \___/  |_|   |_|     └────────┘
1370 
1371 */
1372 pragma solidity ^0.8.4;
1373 
1374 
1375 
1376 
1377 
1378 contract JidoriMale is Ownable, ERC721A, ReentrancyGuard {
1379     mapping(uint256 => bool) public claimed;
1380     mapping(address => uint256) public buyed;
1381     address private girlContract = 0x0f7f90a5274Ec882597BE323f43347bf73E09BcE;
1382 
1383     struct JidoriConfig {
1384         uint256 stage;
1385         uint256 publicSaleMaxMint;
1386         uint256 publicSalePrice;
1387         uint256 maxSupply;
1388     }
1389 
1390     JidoriConfig public jidoriConfig;
1391 
1392     bool private airdropped = false;
1393     bool private devMinted = false;
1394 
1395     constructor() ERC721A("Jidori Boy", "JIDORI-BOY") {
1396         initConfig(1, 3, 25000000000000000, 3950);
1397     }
1398 
1399     function initConfig(
1400         uint256 stage,
1401         uint256 publicSaleMaxMint,
1402         uint256 publicSalePrice,
1403         uint256 maxSupply
1404     ) private onlyOwner {
1405         jidoriConfig.stage = stage;
1406         jidoriConfig.publicSaleMaxMint = publicSaleMaxMint;
1407         jidoriConfig.publicSalePrice = publicSalePrice;
1408         jidoriConfig.maxSupply = maxSupply;
1409     }
1410 
1411     function airdrop(address[] calldata addresses) external onlyOwner airdropEnabled nonReentrant {
1412         for (uint256 i; i < addresses.length; ++i) {
1413             _mint(addresses[i], 1, '',true);
1414         }
1415         airdropped = true;
1416     }
1417 
1418     function claimBoy(uint256[] calldata girlIds)
1419         external
1420         claimEnabled
1421         nonReentrant
1422     {
1423         for(uint256 i; i < girlIds.length; ++i){
1424             uint256 girlId = girlIds[i];
1425             require(!claimed[girlId], "This tokenId already claimed");
1426             require(ERC721A(girlContract).ownerOf(girlId) == msg.sender, "Unauthorized");
1427             
1428             claimed[girlId] = true;
1429         }
1430 
1431         _safeMint(msg.sender, girlIds.length);
1432     }
1433 
1434     function mint(uint256 quantity) external saleEnabled payable {
1435         JidoriConfig memory config = jidoriConfig;
1436         uint256 publicSalePrice = uint256(config.publicSalePrice);
1437         uint256 publicSaleMaxMint = uint256(config.publicSaleMaxMint);
1438         uint256 maxSupply = uint256(config.maxSupply);
1439         require(
1440             totalSupply() + quantity <= maxSupply,
1441             "Insufficient quantity left."
1442         );
1443         require(
1444             getAddressBuyed(msg.sender) + quantity <= publicSaleMaxMint,
1445             "You mint too much."
1446         );        
1447         require(
1448             quantity * publicSalePrice <= msg.value,
1449             "Insufficient balance."
1450         );
1451 
1452         _safeMint(msg.sender, quantity);
1453         buyed[msg.sender] += quantity;
1454     }
1455 
1456     function getStage() private view returns (uint256) {
1457         JidoriConfig memory config = jidoriConfig;
1458         uint256 stage = uint256(config.stage);
1459         return stage;
1460     }
1461 
1462     function setStage(uint256 _stage) external onlyOwner {
1463         jidoriConfig.stage = _stage;
1464     }
1465 
1466     function getAddressBuyed(address owner) public view returns (uint256) {
1467         return buyed[owner];
1468     }
1469 
1470     function devMint(uint256 quantity) external onlyOwner {
1471         require(!devMinted, "Dev minted.");
1472 
1473         _safeMint(msg.sender, quantity);
1474         devMinted = true;
1475     }
1476 
1477     string private _baseTokenURI;
1478 
1479     function _baseURI() internal view virtual override returns (string memory) {
1480         return _baseTokenURI;
1481     }
1482 
1483     function setBaseURI(string calldata baseURI) external onlyOwner {
1484         _baseTokenURI = baseURI;
1485     }
1486 
1487     function withdraw() external onlyOwner nonReentrant {
1488         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1489         require(success, "Transfer failed.");
1490     }
1491 
1492     // modifiers
1493     modifier airdropEnabled() {
1494         require(!airdropped && getStage() == 1, "Unable to airdrop.");
1495         _;
1496     }
1497 
1498     modifier claimEnabled() {
1499         require(getStage() == 2, "Unable to claim.");
1500         _;
1501     }
1502 
1503     modifier saleEnabled() {
1504         require(getStage() == 3, "Unable to mint.");
1505         _;
1506     }
1507 }