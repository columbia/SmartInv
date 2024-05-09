1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 /**
5 Where am i?.......                                   
6                                                                            
7 */
8 
9 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Contract module that helps prevent reentrant calls to a function.
15  *
16  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
17  * available, which can be applied to functions to make sure there are no nested
18  * (reentrant) calls to them.
19  *
20  * Note that because there is a single `nonReentrant` guard, functions marked as
21  * `nonReentrant` may not call one another. This can be worked around by making
22  * those functions `private`, and then adding `external` `nonReentrant` entry
23  * points to them.
24  *
25  * TIP: If you would like to learn more about reentrancy and alternative ways
26  * to protect against it, check out our blog post
27  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
28  */
29 abstract contract ReentrancyGuard {
30     // Booleans are more expensive than uint256 or any type that takes up a full
31     // word because each write operation emits an extra SLOAD to first read the
32     // slot's contents, replace the bits taken up by the boolean, and then write
33     // back. This is the compiler's defense against contract upgrades and
34     // pointer aliasing, and it cannot be disabled.
35 
36     // The values being non-zero value makes deployment a bit more expensive,
37     // but in exchange the refund on every call to nonReentrant will be lower in
38     // amount. Since refunds are capped to a percentage of the total
39     // transaction's gas, it is best to keep them low in cases like this one, to
40     // increase the likelihood of the full refund coming into effect.
41     uint256 private constant _NOT_ENTERED = 1;
42     uint256 private constant _ENTERED = 2;
43 
44     uint256 private _status;
45 
46     constructor() {
47         _status = _NOT_ENTERED;
48     }
49 
50     /**
51      * @dev Prevents a contract from calling itself, directly or indirectly.
52      * Calling a `nonReentrant` function from another `nonReentrant`
53      * function is not supported. It is possible to prevent this from happening
54      * by making the `nonReentrant` function external, and making it call a
55      * `private` function that does the actual work.
56      */
57     modifier nonReentrant() {
58         // On the first call to nonReentrant, _notEntered will be true
59         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
60 
61         // Any calls to nonReentrant after this point will fail
62         _status = _ENTERED;
63 
64         _;
65 
66         // By storing the original value once again, a refund is triggered (see
67         // https://eips.ethereum.org/EIPS/eip-2200)
68         _status = _NOT_ENTERED;
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Strings.sol
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev String operations.
80  */
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
86      */
87     function toString(uint256 value) internal pure returns (string memory) {
88         // Inspired by OraclizeAPI's implementation - MIT licence
89         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
90 
91         if (value == 0) {
92             return "0";
93         }
94         uint256 temp = value;
95         uint256 digits;
96         while (temp != 0) {
97             digits++;
98             temp /= 10;
99         }
100         bytes memory buffer = new bytes(digits);
101         while (value != 0) {
102             digits -= 1;
103             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
104             value /= 10;
105         }
106         return string(buffer);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
111      */
112     function toHexString(uint256 value) internal pure returns (string memory) {
113         if (value == 0) {
114             return "0x00";
115         }
116         uint256 temp = value;
117         uint256 length = 0;
118         while (temp != 0) {
119             length++;
120             temp >>= 8;
121         }
122         return toHexString(value, length);
123     }
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
127      */
128     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
129         bytes memory buffer = new bytes(2 * length + 2);
130         buffer[0] = "0";
131         buffer[1] = "x";
132         for (uint256 i = 2 * length + 1; i > 1; --i) {
133             buffer[i] = _HEX_SYMBOLS[value & 0xf];
134             value >>= 4;
135         }
136         require(value == 0, "Strings: hex length insufficient");
137         return string(buffer);
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Context.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 /**
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 abstract contract Context {
159     function _msgSender() internal view virtual returns (address) {
160         return msg.sender;
161     }
162 
163     function _msgData() internal view virtual returns (bytes calldata) {
164         return msg.data;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/utils/Address.sol
169 
170 
171 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
172 
173 pragma solidity ^0.8.1;
174 
175 /**
176  * @dev Collection of functions related to the address type
177  */
178 library Address {
179     /**
180      * @dev Returns true if `account` is a contract.
181      *
182      * [IMPORTANT]
183      * ====
184      * It is unsafe to assume that an address for which this function returns
185      * false is an externally-owned account (EOA) and not a contract.
186      *
187      * Among others, `isContract` will return false for the following
188      * types of addresses:
189      *
190      *  - an externally-owned account
191      *  - a contract in construction
192      *  - an address where a contract will be created
193      *  - an address where a contract lived, but was destroyed
194      * ====
195      *
196      * [IMPORTANT]
197      * ====
198      * You shouldn't rely on `isContract` to protect against flash loan attacks!
199      *
200      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
201      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
202      * constructor.
203      * ====
204      */
205     function isContract(address account) internal view returns (bool) {
206         // This method relies on extcodesize/address.code.length, which returns 0
207         // for contracts in construction, since the code is only stored at the end
208         // of the constructor execution.
209 
210         return account.code.length > 0;
211     }
212 
213     /**
214      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
215      * `recipient`, forwarding all available gas and reverting on errors.
216      *
217      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
218      * of certain opcodes, possibly making contracts go over the 2300 gas limit
219      * imposed by `transfer`, making them unable to receive funds via
220      * `transfer`. {sendValue} removes this limitation.
221      *
222      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
223      *
224      * IMPORTANT: because control is transferred to `recipient`, care must be
225      * taken to not create reentrancy vulnerabilities. Consider using
226      * {ReentrancyGuard} or the
227      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
228      */
229     function sendValue(address payable recipient, uint256 amount) internal {
230         require(address(this).balance >= amount, "Address: insufficient balance");
231 
232         (bool success, ) = recipient.call{value: amount}("");
233         require(success, "Address: unable to send value, recipient may have reverted");
234     }
235 
236     /**
237      * @dev Performs a Solidity function call using a low level `call`. A
238      * plain `call` is an unsafe replacement for a function call: use this
239      * function instead.
240      *
241      * If `target` reverts with a revert reason, it is bubbled up by this
242      * function (like regular Solidity function calls).
243      *
244      * Returns the raw returned data. To convert to the expected return value,
245      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
246      *
247      * Requirements:
248      *
249      * - `target` must be a contract.
250      * - calling `target` with `data` must not revert.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionCall(target, data, "Address: low-level call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
260      * `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         return functionCallWithValue(target, data, 0, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but also transferring `value` wei to `target`.
275      *
276      * Requirements:
277      *
278      * - the calling contract must have an ETH balance of at least `value`.
279      * - the called Solidity function must be `payable`.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
293      * with `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(address(this).balance >= value, "Address: insufficient balance for call");
304         require(isContract(target), "Address: call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.call{value: value}(data);
307         return verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but performing a static call.
313      *
314      * _Available since v3.3._
315      */
316     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
317         return functionStaticCall(target, data, "Address: low-level static call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal view returns (bytes memory) {
331         require(isContract(target), "Address: static call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.staticcall(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a delegate call.
340      *
341      * _Available since v3.4._
342      */
343     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(isContract(target), "Address: delegate call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.delegatecall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
366      * revert reason using the provided one.
367      *
368      * _Available since v4.3._
369      */
370     function verifyCallResult(
371         bool success,
372         bytes memory returndata,
373         string memory errorMessage
374     ) internal pure returns (bytes memory) {
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @title ERC721 token receiver interface
402  * @dev Interface for any contract that wants to support safeTransfers
403  * from ERC721 asset contracts.
404  */
405 interface IERC721Receiver {
406     /**
407      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
408      * by `operator` from `from`, this function is called.
409      *
410      * It must return its Solidity selector to confirm the token transfer.
411      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
412      *
413      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
414      */
415     function onERC721Received(
416         address operator,
417         address from,
418         uint256 tokenId,
419         bytes calldata data
420     ) external returns (bytes4);
421 }
422 
423 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Interface of the ERC165 standard, as defined in the
432  * https://eips.ethereum.org/EIPS/eip-165[EIP].
433  *
434  * Implementers can declare support of contract interfaces, which can then be
435  * queried by others ({ERC165Checker}).
436  *
437  * For an implementation, see {ERC165}.
438  */
439 interface IERC165 {
440     /**
441      * @dev Returns true if this contract implements the interface defined by
442      * `interfaceId`. See the corresponding
443      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
444      * to learn more about how these ids are created.
445      *
446      * This function call must use less than 30 000 gas.
447      */
448     function supportsInterface(bytes4 interfaceId) external view returns (bool);
449 }
450 
451 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 
459 /**
460  * @dev Implementation of the {IERC165} interface.
461  *
462  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
463  * for the additional interface id that will be supported. For example:
464  *
465  * ```solidity
466  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
467  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
468  * }
469  * ```
470  *
471  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
472  */
473 abstract contract ERC165 is IERC165 {
474     /**
475      * @dev See {IERC165-supportsInterface}.
476      */
477     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478         return interfaceId == type(IERC165).interfaceId;
479     }
480 }
481 
482 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 
490 /**
491  * @dev Required interface of an ERC721 compliant contract.
492  */
493 interface IERC721 is IERC165 {
494     /**
495      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
496      */
497     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
498 
499     /**
500      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
501      */
502     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
503 
504     /**
505      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
506      */
507     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
508 
509     /**
510      * @dev Returns the number of tokens in ``owner``'s account.
511      */
512     function balanceOf(address owner) external view returns (uint256 balance);
513 
514     /**
515      * @dev Returns the owner of the `tokenId` token.
516      *
517      * Requirements:
518      *
519      * - `tokenId` must exist.
520      */
521     function ownerOf(uint256 tokenId) external view returns (address owner);
522 
523     /**
524      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
525      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must exist and be owned by `from`.
532      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
533      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
534      *
535      * Emits a {Transfer} event.
536      */
537     function safeTransferFrom(
538         address from,
539         address to,
540         uint256 tokenId
541     ) external;
542 
543     /**
544      * @dev Transfers `tokenId` token from `from` to `to`.
545      *
546      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
547      *
548      * Requirements:
549      *
550      * - `from` cannot be the zero address.
551      * - `to` cannot be the zero address.
552      * - `tokenId` token must be owned by `from`.
553      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
554      *
555      * Emits a {Transfer} event.
556      */
557     function transferFrom(
558         address from,
559         address to,
560         uint256 tokenId
561     ) external;
562 
563     /**
564      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
565      * The approval is cleared when the token is transferred.
566      *
567      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
568      *
569      * Requirements:
570      *
571      * - The caller must own the token or be an approved operator.
572      * - `tokenId` must exist.
573      *
574      * Emits an {Approval} event.
575      */
576     function approve(address to, uint256 tokenId) external;
577 
578     /**
579      * @dev Returns the account approved for `tokenId` token.
580      *
581      * Requirements:
582      *
583      * - `tokenId` must exist.
584      */
585     function getApproved(uint256 tokenId) external view returns (address operator);
586 
587     /**
588      * @dev Approve or remove `operator` as an operator for the caller.
589      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
590      *
591      * Requirements:
592      *
593      * - The `operator` cannot be the caller.
594      *
595      * Emits an {ApprovalForAll} event.
596      */
597     function setApprovalForAll(address operator, bool _approved) external;
598 
599     /**
600      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
601      *
602      * See {setApprovalForAll}
603      */
604     function isApprovedForAll(address owner, address operator) external view returns (bool);
605 
606     /**
607      * @dev Safely transfers `tokenId` token from `from` to `to`.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must exist and be owned by `from`.
614      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616      *
617      * Emits a {Transfer} event.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId,
623         bytes calldata data
624     ) external;
625 }
626 
627 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 
635 /**
636  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
637  * @dev See https://eips.ethereum.org/EIPS/eip-721
638  */
639 interface IERC721Metadata is IERC721 {
640     /**
641      * @dev Returns the token collection name.
642      */
643     function name() external view returns (string memory);
644 
645     /**
646      * @dev Returns the token collection symbol.
647      */
648     function symbol() external view returns (string memory);
649 
650     /**
651      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
652      */
653     function tokenURI(uint256 tokenId) external view returns (string memory);
654 }
655 
656 // File: contracts/new.sol
657 
658 
659 
660 
661 pragma solidity ^0.8.4;
662 
663 
664 
665 
666 
667 
668 
669 
670 error ApprovalCallerNotOwnerNorApproved();
671 error ApprovalQueryForNonexistentToken();
672 error ApproveToCaller();
673 error ApprovalToCurrentOwner();
674 error BalanceQueryForZeroAddress();
675 error MintToZeroAddress();
676 error MintZeroQuantity();
677 error OwnerQueryForNonexistentToken();
678 error TransferCallerNotOwnerNorApproved();
679 error TransferFromIncorrectOwner();
680 error TransferToNonERC721ReceiverImplementer();
681 error TransferToZeroAddress();
682 error URIQueryForNonexistentToken();
683 
684 /**
685  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
686  * the Metadata extension. Built to optimize for lower gas during batch mints.
687  *
688  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
689  *
690  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
691  *
692  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
693  */
694 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
695     using Address for address;
696     using Strings for uint256;
697 
698     // Compiler will pack this into a single 256bit word.
699     struct TokenOwnership {
700         // The address of the owner.
701         address addr;
702         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
703         uint64 startTimestamp;
704         // Whether the token has been burned.
705         bool burned;
706     }
707 
708     // Compiler will pack this into a single 256bit word.
709     struct AddressData {
710         // Realistically, 2**64-1 is more than enough.
711         uint64 balance;
712         // Keeps track of mint count with minimal overhead for tokenomics.
713         uint64 numberMinted;
714         // Keeps track of burn count with minimal overhead for tokenomics.
715         uint64 numberBurned;
716         // For miscellaneous variable(s) pertaining to the address
717         // (e.g. number of whitelist mint slots used).
718         // If there are multiple variables, please pack them into a uint64.
719         uint64 aux;
720     }
721 
722     // The tokenId of the next token to be minted.
723     uint256 internal _currentIndex;
724 
725     // The number of tokens burned.
726     uint256 internal _burnCounter;
727 
728     // Token name
729     string private _name;
730 
731     // Token symbol
732     string private _symbol;
733 
734     // Mapping from token ID to ownership details
735     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
736     mapping(uint256 => TokenOwnership) internal _ownerships;
737 
738     // Mapping owner address to address data
739     mapping(address => AddressData) private _addressData;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     constructor(string memory name_, string memory symbol_) {
748         _name = name_;
749         _symbol = symbol_;
750         _currentIndex = _startTokenId();
751     }
752 
753     /**
754      * To change the starting tokenId, please override this function.
755      */
756     function _startTokenId() internal view virtual returns (uint256) {
757         return 1;
758     }
759 
760     /**
761      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
762      */
763     function totalSupply() public view returns (uint256) {
764         // Counter underflow is impossible as _burnCounter cannot be incremented
765         // more than _currentIndex - _startTokenId() times
766         unchecked {
767             return _currentIndex - _burnCounter - _startTokenId();
768         }
769     }
770 
771     /**
772      * Returns the total amount of tokens minted in the contract.
773      */
774     function _totalMinted() internal view returns (uint256) {
775         // Counter underflow is impossible as _currentIndex does not decrement,
776         // and it is initialized to _startTokenId()
777         unchecked {
778             return _currentIndex - _startTokenId();
779         }
780     }
781 
782     /**
783      * @dev See {IERC165-supportsInterface}.
784      */
785     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
786         return
787             interfaceId == type(IERC721).interfaceId ||
788             interfaceId == type(IERC721Metadata).interfaceId ||
789             super.supportsInterface(interfaceId);
790     }
791 
792     /**
793      * @dev See {IERC721-balanceOf}.
794      */
795     function balanceOf(address owner) public view override returns (uint256) {
796         if (owner == address(0)) revert BalanceQueryForZeroAddress();
797         return uint256(_addressData[owner].balance);
798     }
799 
800     /**
801      * Returns the number of tokens minted by `owner`.
802      */
803     function _numberMinted(address owner) internal view returns (uint256) {
804         return uint256(_addressData[owner].numberMinted);
805     }
806 
807     /**
808      * Returns the number of tokens burned by or on behalf of `owner`.
809      */
810     function _numberBurned(address owner) internal view returns (uint256) {
811         return uint256(_addressData[owner].numberBurned);
812     }
813 
814     /**
815      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
816      */
817     function _getAux(address owner) internal view returns (uint64) {
818         return _addressData[owner].aux;
819     }
820 
821     /**
822      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
823      * If there are multiple variables, please pack them into a uint64.
824      */
825     function _setAux(address owner, uint64 aux) internal {
826         _addressData[owner].aux = aux;
827     }
828 
829     /**
830      * Gas spent here starts off proportional to the maximum mint batch size.
831      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
832      */
833     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
834         uint256 curr = tokenId;
835 
836         unchecked {
837             if (_startTokenId() <= curr && curr < _currentIndex) {
838                 TokenOwnership memory ownership = _ownerships[curr];
839                 if (!ownership.burned) {
840                     if (ownership.addr != address(0)) {
841                         return ownership;
842                     }
843                     // Invariant:
844                     // There will always be an ownership that has an address and is not burned
845                     // before an ownership that does not have an address and is not burned.
846                     // Hence, curr will not underflow.
847                     while (true) {
848                         curr--;
849                         ownership = _ownerships[curr];
850                         if (ownership.addr != address(0)) {
851                             return ownership;
852                         }
853                     }
854                 }
855             }
856         }
857         revert OwnerQueryForNonexistentToken();
858     }
859 
860     /**
861      * @dev See {IERC721-ownerOf}.
862      */
863     function ownerOf(uint256 tokenId) public view override returns (address) {
864         return _ownershipOf(tokenId).addr;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-name}.
869      */
870     function name() public view virtual override returns (string memory) {
871         return _name;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-symbol}.
876      */
877     function symbol() public view virtual override returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-tokenURI}.
883      */
884     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
885         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
886 
887         string memory baseURI = _baseURI();
888         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
889     }
890 
891     /**
892      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
893      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
894      * by default, can be overriden in child contracts.
895      */
896     function _baseURI() internal view virtual returns (string memory) {
897         return '';
898     }
899 
900     /**
901      * @dev See {IERC721-approve}.
902      */
903     function approve(address to, uint256 tokenId) public override {
904         address owner = ERC721A.ownerOf(tokenId);
905         if (to == owner) revert ApprovalToCurrentOwner();
906 
907         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
908             revert ApprovalCallerNotOwnerNorApproved();
909         }
910 
911         _approve(to, tokenId, owner);
912     }
913 
914     /**
915      * @dev See {IERC721-getApproved}.
916      */
917     function getApproved(uint256 tokenId) public view override returns (address) {
918         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
919 
920         return _tokenApprovals[tokenId];
921     }
922 
923     /**
924      * @dev See {IERC721-setApprovalForAll}.
925      */
926     function setApprovalForAll(address operator, bool approved) public virtual override {
927         if (operator == _msgSender()) revert ApproveToCaller();
928 
929         _operatorApprovals[_msgSender()][operator] = approved;
930         emit ApprovalForAll(_msgSender(), operator, approved);
931     }
932 
933     /**
934      * @dev See {IERC721-isApprovedForAll}.
935      */
936     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev See {IERC721-transferFrom}.
942      */
943     function transferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         _transfer(from, to, tokenId);
949     }
950 
951     /**
952      * @dev See {IERC721-safeTransferFrom}.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         safeTransferFrom(from, to, tokenId, '');
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) public virtual override {
971         _transfer(from, to, tokenId);
972         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
973             revert TransferToNonERC721ReceiverImplementer();
974         }
975     }
976 
977     /**
978      * @dev Returns whether `tokenId` exists.
979      *
980      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
981      *
982      * Tokens start existing when they are minted (`_mint`),
983      */
984     function _exists(uint256 tokenId) internal view returns (bool) {
985         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
986             !_ownerships[tokenId].burned;
987     }
988 
989     function _safeMint(address to, uint256 quantity) internal {
990         _safeMint(to, quantity, '');
991     }
992 
993     /**
994      * @dev Safely mints `quantity` tokens and transfers them to `to`.
995      *
996      * Requirements:
997      *
998      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
999      * - `quantity` must be greater than 0.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _safeMint(
1004         address to,
1005         uint256 quantity,
1006         bytes memory _data
1007     ) internal {
1008         _mint(to, quantity, _data, true);
1009     }
1010 
1011     /**
1012      * @dev Mints `quantity` tokens and transfers them to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `quantity` must be greater than 0.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _mint(
1022         address to,
1023         uint256 quantity,
1024         bytes memory _data,
1025         bool safe
1026     ) internal {
1027         uint256 startTokenId = _currentIndex;
1028         if (to == address(0)) revert MintToZeroAddress();
1029         if (quantity == 0) revert MintZeroQuantity();
1030 
1031         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1032 
1033         // Overflows are incredibly unrealistic.
1034         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1035         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1036         unchecked {
1037             _addressData[to].balance += uint64(quantity);
1038             _addressData[to].numberMinted += uint64(quantity);
1039 
1040             _ownerships[startTokenId].addr = to;
1041             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1042 
1043             uint256 updatedIndex = startTokenId;
1044             uint256 end = updatedIndex + quantity;
1045 
1046             if (safe && to.isContract()) {
1047                 do {
1048                     emit Transfer(address(0), to, updatedIndex);
1049                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1050                         revert TransferToNonERC721ReceiverImplementer();
1051                     }
1052                 } while (updatedIndex != end);
1053                 // Reentrancy protection
1054                 if (_currentIndex != startTokenId) revert();
1055             } else {
1056                 do {
1057                     emit Transfer(address(0), to, updatedIndex++);
1058                 } while (updatedIndex != end);
1059             }
1060             _currentIndex = updatedIndex;
1061         }
1062         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1063     }
1064 
1065     /**
1066      * @dev Transfers `tokenId` from `from` to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `tokenId` token must be owned by `from`.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _transfer(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) private {
1080         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1081 
1082         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1083 
1084         bool isApprovedOrOwner = (_msgSender() == from ||
1085             isApprovedForAll(from, _msgSender()) ||
1086             getApproved(tokenId) == _msgSender());
1087 
1088         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1089         if (to == address(0)) revert TransferToZeroAddress();
1090 
1091         _beforeTokenTransfers(from, to, tokenId, 1);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId, from);
1095 
1096         // Underflow of the sender's balance is impossible because we check for
1097         // ownership above and the recipient's balance can't realistically overflow.
1098         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1099         unchecked {
1100             _addressData[from].balance -= 1;
1101             _addressData[to].balance += 1;
1102 
1103             TokenOwnership storage currSlot = _ownerships[tokenId];
1104             currSlot.addr = to;
1105             currSlot.startTimestamp = uint64(block.timestamp);
1106 
1107             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1108             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1109             uint256 nextTokenId = tokenId + 1;
1110             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1111             if (nextSlot.addr == address(0)) {
1112                 // This will suffice for checking _exists(nextTokenId),
1113                 // as a burned slot cannot contain the zero address.
1114                 if (nextTokenId != _currentIndex) {
1115                     nextSlot.addr = from;
1116                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1117                 }
1118             }
1119         }
1120 
1121         emit Transfer(from, to, tokenId);
1122         _afterTokenTransfers(from, to, tokenId, 1);
1123     }
1124 
1125     /**
1126      * @dev This is equivalent to _burn(tokenId, false)
1127      */
1128     function _burn(uint256 tokenId) internal virtual {
1129         _burn(tokenId, false);
1130     }
1131 
1132     /**
1133      * @dev Destroys `tokenId`.
1134      * The approval is cleared when the token is burned.
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must exist.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1143         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1144 
1145         address from = prevOwnership.addr;
1146 
1147         if (approvalCheck) {
1148             bool isApprovedOrOwner = (_msgSender() == from ||
1149                 isApprovedForAll(from, _msgSender()) ||
1150                 getApproved(tokenId) == _msgSender());
1151 
1152             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1153         }
1154 
1155         _beforeTokenTransfers(from, address(0), tokenId, 1);
1156 
1157         // Clear approvals from the previous owner
1158         _approve(address(0), tokenId, from);
1159 
1160         // Underflow of the sender's balance is impossible because we check for
1161         // ownership above and the recipient's balance can't realistically overflow.
1162         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1163         unchecked {
1164             AddressData storage addressData = _addressData[from];
1165             addressData.balance -= 1;
1166             addressData.numberBurned += 1;
1167 
1168             // Keep track of who burned the token, and the timestamp of burning.
1169             TokenOwnership storage currSlot = _ownerships[tokenId];
1170             currSlot.addr = from;
1171             currSlot.startTimestamp = uint64(block.timestamp);
1172             currSlot.burned = true;
1173 
1174             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1175             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1176             uint256 nextTokenId = tokenId + 1;
1177             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1178             if (nextSlot.addr == address(0)) {
1179                 // This will suffice for checking _exists(nextTokenId),
1180                 // as a burned slot cannot contain the zero address.
1181                 if (nextTokenId != _currentIndex) {
1182                     nextSlot.addr = from;
1183                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1184                 }
1185             }
1186         }
1187 
1188         emit Transfer(from, address(0), tokenId);
1189         _afterTokenTransfers(from, address(0), tokenId, 1);
1190 
1191         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1192         unchecked {
1193             _burnCounter++;
1194         }
1195     }
1196 
1197     /**
1198      * @dev Approve `to` to operate on `tokenId`
1199      *
1200      * Emits a {Approval} event.
1201      */
1202     function _approve(
1203         address to,
1204         uint256 tokenId,
1205         address owner
1206     ) private {
1207         _tokenApprovals[tokenId] = to;
1208         emit Approval(owner, to, tokenId);
1209     }
1210 
1211     /**
1212      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1213      *
1214      * @param from address representing the previous owner of the given token ID
1215      * @param to target address that will receive the tokens
1216      * @param tokenId uint256 ID of the token to be transferred
1217      * @param _data bytes optional data to send along with the call
1218      * @return bool whether the call correctly returned the expected magic value
1219      */
1220     function _checkContractOnERC721Received(
1221         address from,
1222         address to,
1223         uint256 tokenId,
1224         bytes memory _data
1225     ) private returns (bool) {
1226         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1227             return retval == IERC721Receiver(to).onERC721Received.selector;
1228         } catch (bytes memory reason) {
1229             if (reason.length == 0) {
1230                 revert TransferToNonERC721ReceiverImplementer();
1231             } else {
1232                 assembly {
1233                     revert(add(32, reason), mload(reason))
1234                 }
1235             }
1236         }
1237     }
1238 
1239     /**
1240      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1241      * And also called before burning one token.
1242      *
1243      * startTokenId - the first token id to be transferred
1244      * quantity - the amount to be transferred
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` will be minted for `to`.
1251      * - When `to` is zero, `tokenId` will be burned by `from`.
1252      * - `from` and `to` are never both zero.
1253      */
1254     function _beforeTokenTransfers(
1255         address from,
1256         address to,
1257         uint256 startTokenId,
1258         uint256 quantity
1259     ) internal virtual {}
1260 
1261     /**
1262      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1263      * minting.
1264      * And also called after one token has been burned.
1265      *
1266      * startTokenId - the first token id to be transferred
1267      * quantity - the amount to be transferred
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` has been minted for `to`.
1274      * - When `to` is zero, `tokenId` has been burned by `from`.
1275      * - `from` and `to` are never both zero.
1276      */
1277     function _afterTokenTransfers(
1278         address from,
1279         address to,
1280         uint256 startTokenId,
1281         uint256 quantity
1282     ) internal virtual {}
1283 }
1284 
1285 abstract contract Ownable is Context {
1286     address private _owner;
1287 
1288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1289 
1290     /**
1291      * @dev Initializes the contract setting the deployer as the initial owner.
1292      */
1293     constructor() {
1294         _transferOwnership(_msgSender());
1295     }
1296 
1297     /**
1298      * @dev Returns the address of the current owner.
1299      */
1300     function owner() public view virtual returns (address) {
1301         return _owner;
1302     }
1303 
1304     /**
1305      * @dev Throws if called by any account other than the owner.
1306      */
1307     modifier onlyOwner() {
1308         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1309         _;
1310     }
1311 
1312     /**
1313      * @dev Leaves the contract without owner. It will not be possible to call
1314      * `onlyOwner` functions anymore. Can only be called by the current owner.
1315      *
1316      * NOTE: Renouncing ownership will leave the contract without an owner,
1317      * thereby removing any functionality that is only available to the owner.
1318      */
1319     function renounceOwnership() public virtual onlyOwner {
1320         _transferOwnership(address(0));
1321     }
1322 
1323     /**
1324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1325      * Can only be called by the current owner.
1326      */
1327     function transferOwnership(address newOwner) public virtual onlyOwner {
1328         require(newOwner != address(0), "Ownable: new owner is the zero address");
1329         _transferOwnership(newOwner);
1330     }
1331 
1332     /**
1333      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1334      * Internal function without access restriction.
1335      */
1336     function _transferOwnership(address newOwner) internal virtual {
1337         address oldOwner = _owner;
1338         _owner = newOwner;
1339         emit OwnershipTransferred(oldOwner, newOwner);
1340     }
1341 }
1342     pragma solidity ^0.8.7;
1343     
1344     contract KotaroWorld is ERC721A, Ownable, ReentrancyGuard {
1345     using Strings for uint256;
1346 
1347 
1348   string private uriPrefix ;
1349   string private uriSuffix = ".json";
1350   string public hiddenURL;
1351 
1352   
1353   
1354 
1355   uint256 public cost = 0.003 ether;
1356   uint256 public whiteListCost = 0.003 ether ;
1357   
1358 
1359   uint16 public maxSupply = 7777;
1360   uint8 public  maxMintAmountPerTx = 10;
1361   uint8 private maxMintAmountPerWallet ;
1362     uint8 public maxFreeMintAmountPerWallet = 1;
1363     uint256 public freeNFTAlreadyMinted = 0;
1364      uint256 public  NUM_FREE_MINTS = 7777;
1365                                                              
1366   bool public WLpaused = true;
1367   bool public paused = true;
1368   bool public reveal =false;
1369  
1370   mapping (address => bool) public isWhitelisted;
1371 
1372    
1373  
1374   
1375   
1376  
1377   
1378 
1379     constructor(
1380     string memory _tokenName,
1381     string memory _tokenSymbol,
1382     string memory _hiddenMetadataUri
1383   ) ERC721A(_tokenName, _tokenSymbol) {
1384     
1385   }
1386 
1387    modifier callerIsUser() {
1388     require(tx.origin == msg.sender, "The caller is another contract");
1389     _;
1390   }
1391  
1392  
1393   function mint(uint256 _mintAmount)
1394       external
1395       payable
1396       callerIsUser
1397   {
1398     require(!paused, "The contract is paused!");
1399     require(totalSupply() + _mintAmount < maxSupply + 1, "No more");
1400     
1401     
1402 
1403     if(freeNFTAlreadyMinted + _mintAmount > NUM_FREE_MINTS){
1404         require(
1405             (cost * _mintAmount) <= msg.value,
1406             "Incorrect ETH value sent"
1407         );
1408     }
1409      else {
1410         if (balanceOf(msg.sender) + _mintAmount > maxFreeMintAmountPerWallet) {
1411         require(
1412             (cost * _mintAmount) <= msg.value,
1413             "Incorrect ETH value sent"
1414         );
1415         require(
1416             _mintAmount <= maxMintAmountPerTx,
1417             "Max mints per transaction exceeded"
1418         );
1419         
1420         } else {
1421             require(
1422                 _mintAmount <= maxFreeMintAmountPerWallet,
1423                 "Max mints per transaction exceeded"
1424             );
1425             freeNFTAlreadyMinted += _mintAmount;
1426         }
1427     }
1428     _safeMint(msg.sender, _mintAmount);
1429   }
1430 
1431   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1432      uint16 totalSupply = uint16(totalSupply());
1433     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1434      _safeMint(_receiver , _mintAmount);
1435      delete _mintAmount;
1436      delete _receiver;
1437      delete totalSupply;
1438   }
1439 
1440   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1441      uint16 totalSupply = uint16(totalSupply());
1442      uint totalAmount =   _amountPerAddress * addresses.length;
1443     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1444      for (uint256 i = 0; i < addresses.length; i++) {
1445             _safeMint(addresses[i], _amountPerAddress);
1446         }
1447 
1448      delete _amountPerAddress;
1449      delete totalSupply;
1450   }
1451 
1452  
1453 
1454   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1455       maxSupply = _maxSupply;
1456   }
1457 
1458 
1459 
1460    
1461   function tokenURI(uint256 _tokenId)
1462     public
1463     view
1464     virtual
1465     override
1466     returns (string memory)
1467   {
1468     require(
1469       _exists(_tokenId),
1470       "ERC721Metadata: URI query for nonexistent token"
1471     );
1472     
1473   
1474 if ( reveal == false)
1475 {
1476     return hiddenURL;
1477 }
1478     
1479 
1480     string memory currentBaseURI = _baseURI();
1481     return bytes(currentBaseURI).length > 0
1482         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1483         : "";
1484   }
1485  
1486    function setWLPaused() external onlyOwner {
1487     WLpaused = !WLpaused;
1488   }
1489   function setWLCost(uint256 _cost) external onlyOwner {
1490     whiteListCost = _cost;
1491     delete _cost;
1492   }
1493 
1494 
1495 
1496  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1497     maxFreeMintAmountPerWallet = _limit;
1498    delete _limit;
1499 
1500 }
1501 
1502     
1503   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1504         for(uint8 i = 0; i < entries.length; i++) {
1505             isWhitelisted[entries[i]] = true;
1506         }   
1507     }
1508 
1509     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1510         for(uint8 i = 0; i < entries.length; i++) {
1511              isWhitelisted[entries[i]] = false;
1512         }
1513     }
1514 
1515 
1516 
1517     function whitelistMint(uint256 _mintAmount)
1518       external
1519       payable
1520   {
1521     require(!WLpaused, "Whitelist minting is over!");
1522      require(isWhitelisted[msg.sender],  "You are not whitelisted");
1523 
1524     require(totalSupply() + _mintAmount < maxSupply + 1, "No more");
1525     require (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerWallet, "max NFT per address exceeded");
1526     
1527     if(freeNFTAlreadyMinted + _mintAmount > NUM_FREE_MINTS){
1528         require(
1529             (whiteListCost * _mintAmount) <= msg.value,
1530             "Incorrect ETH value sent"
1531         );
1532     }
1533      else {
1534         if (balanceOf(msg.sender) + _mintAmount > maxFreeMintAmountPerWallet) {
1535         require(
1536             (whiteListCost * _mintAmount) <= msg.value,
1537             "Incorrect ETH value sent"
1538         );
1539         require(
1540             _mintAmount <= maxMintAmountPerTx,
1541             "Max mints per transaction exceeded"
1542         );
1543         } else {
1544             require(
1545                 _mintAmount <= maxFreeMintAmountPerWallet,
1546                 "Max mints per transaction exceeded"
1547             );
1548             freeNFTAlreadyMinted += _mintAmount;
1549         }
1550     }
1551     _safeMint(msg.sender, _mintAmount);
1552   }
1553 
1554   function seturiSuffix(string memory _uriSuffix) external onlyOwner {
1555     uriSuffix = _uriSuffix;
1556   }
1557 
1558    function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1559     uriPrefix = _uriPrefix;
1560   }
1561    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1562     hiddenURL = _uriPrefix;
1563   }
1564 function setNumFreeMints(uint256 _numfreemints)
1565       external
1566       onlyOwner
1567   {
1568       NUM_FREE_MINTS = _numfreemints;
1569   }
1570 
1571 
1572 
1573   function setPaused() external onlyOwner {
1574     paused = !paused;
1575     WLpaused = true;
1576   }
1577 
1578   function setCost(uint _cost) external onlyOwner{
1579       cost = _cost;
1580 
1581   }
1582 
1583  function setRevealed() external onlyOwner{
1584      reveal = !reveal;
1585  }
1586 
1587   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1588       maxMintAmountPerTx = _maxtx;
1589 
1590   }
1591 
1592  function setMaxMintAmountPerWallet(uint8 _maxWallet) external onlyOwner{
1593       maxMintAmountPerWallet = _maxWallet;
1594 
1595   }
1596   
1597  
1598 
1599   function withdraw() public onlyOwner nonReentrant {
1600     // This will transfer the remaining contract balance to the owner.
1601     // Do not remove this otherwise you will not be able to withdraw the funds.
1602     // =============================================================================
1603     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1604     require(os);
1605     // =============================================================================
1606   }
1607 
1608 
1609   function _baseURI() internal view  override returns (string memory) {
1610     return uriPrefix;
1611   }
1612 }