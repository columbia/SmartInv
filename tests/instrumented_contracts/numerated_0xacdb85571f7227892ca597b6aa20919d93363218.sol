1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
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
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/Address.sol
99 
100 
101 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
102 
103 pragma solidity ^0.8.1;
104 
105 /**
106  * @dev Collection of functions related to the address type
107  */
108 library Address {
109     /**
110      * @dev Returns true if `account` is a contract.
111      *
112      * [IMPORTANT]
113      * ====
114      * It is unsafe to assume that an address for which this function returns
115      * false is an externally-owned account (EOA) and not a contract.
116      *
117      * Among others, `isContract` will return false for the following
118      * types of addresses:
119      *
120      *  - an externally-owned account
121      *  - a contract in construction
122      *  - an address where a contract will be created
123      *  - an address where a contract lived, but was destroyed
124      * ====
125      *
126      * [IMPORTANT]
127      * ====
128      * You shouldn't rely on `isContract` to protect against flash loan attacks!
129      *
130      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
131      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
132      * constructor.
133      * ====
134      */
135     function isContract(address account) internal view returns (bool) {
136         // This method relies on extcodesize/address.code.length, which returns 0
137         // for contracts in construction, since the code is only stored at the end
138         // of the constructor execution.
139 
140         return account.code.length > 0;
141     }
142 
143     /**
144      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
145      * `recipient`, forwarding all available gas and reverting on errors.
146      *
147      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
148      * of certain opcodes, possibly making contracts go over the 2300 gas limit
149      * imposed by `transfer`, making them unable to receive funds via
150      * `transfer`. {sendValue} removes this limitation.
151      *
152      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
153      *
154      * IMPORTANT: because control is transferred to `recipient`, care must be
155      * taken to not create reentrancy vulnerabilities. Consider using
156      * {ReentrancyGuard} or the
157      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
158      */
159     function sendValue(address payable recipient, uint256 amount) internal {
160         require(address(this).balance >= amount, "Address: insufficient balance");
161 
162         (bool success, ) = recipient.call{value: amount}("");
163         require(success, "Address: unable to send value, recipient may have reverted");
164     }
165 
166     /**
167      * @dev Performs a Solidity function call using a low level `call`. A
168      * plain `call` is an unsafe replacement for a function call: use this
169      * function instead.
170      *
171      * If `target` reverts with a revert reason, it is bubbled up by this
172      * function (like regular Solidity function calls).
173      *
174      * Returns the raw returned data. To convert to the expected return value,
175      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
176      *
177      * Requirements:
178      *
179      * - `target` must be a contract.
180      * - calling `target` with `data` must not revert.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
190      * `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
204      * but also transferring `value` wei to `target`.
205      *
206      * Requirements:
207      *
208      * - the calling contract must have an ETH balance of at least `value`.
209      * - the called Solidity function must be `payable`.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
223      * with `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCallWithValue(
228         address target,
229         bytes memory data,
230         uint256 value,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         require(address(this).balance >= value, "Address: insufficient balance for call");
234         require(isContract(target), "Address: call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.call{value: value}(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
247         return functionStaticCall(target, data, "Address: low-level static call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal view returns (bytes memory) {
261         require(isContract(target), "Address: static call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.staticcall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(isContract(target), "Address: delegate call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.delegatecall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
296      * revert reason using the provided one.
297      *
298      * _Available since v4.3._
299      */
300     function verifyCallResult(
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal pure returns (bytes memory) {
305         if (success) {
306             return returndata;
307         } else {
308             // Look for revert reason and bubble it up if present
309             if (returndata.length > 0) {
310                 // The easiest way to bubble the revert reason is using memory via assembly
311 
312                 assembly {
313                     let returndata_size := mload(returndata)
314                     revert(add(32, returndata), returndata_size)
315                 }
316             } else {
317                 revert(errorMessage);
318             }
319         }
320     }
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
324 
325 
326 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @title ERC721 token receiver interface
332  * @dev Interface for any contract that wants to support safeTransfers
333  * from ERC721 asset contracts.
334  */
335 interface IERC721Receiver {
336     /**
337      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
338      * by `operator` from `from`, this function is called.
339      *
340      * It must return its Solidity selector to confirm the token transfer.
341      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
342      *
343      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
344      */
345     function onERC721Received(
346         address operator,
347         address from,
348         uint256 tokenId,
349         bytes calldata data
350     ) external returns (bytes4);
351 }
352 
353 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Interface of the ERC165 standard, as defined in the
362  * https://eips.ethereum.org/EIPS/eip-165[EIP].
363  *
364  * Implementers can declare support of contract interfaces, which can then be
365  * queried by others ({ERC165Checker}).
366  *
367  * For an implementation, see {ERC165}.
368  */
369 interface IERC165 {
370     /**
371      * @dev Returns true if this contract implements the interface defined by
372      * `interfaceId`. See the corresponding
373      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
374      * to learn more about how these ids are created.
375      *
376      * This function call must use less than 30 000 gas.
377      */
378     function supportsInterface(bytes4 interfaceId) external view returns (bool);
379 }
380 
381 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 
389 /**
390  * @dev Implementation of the {IERC165} interface.
391  *
392  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
393  * for the additional interface id that will be supported. For example:
394  *
395  * ```solidity
396  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
397  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
398  * }
399  * ```
400  *
401  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
402  */
403 abstract contract ERC165 is IERC165 {
404     /**
405      * @dev See {IERC165-supportsInterface}.
406      */
407     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
408         return interfaceId == type(IERC165).interfaceId;
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Required interface of an ERC721 compliant contract.
422  */
423 interface IERC721 is IERC165 {
424     /**
425      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
426      */
427     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
431      */
432     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
436      */
437     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
438 
439     /**
440      * @dev Returns the number of tokens in ``owner``'s account.
441      */
442     function balanceOf(address owner) external view returns (uint256 balance);
443 
444     /**
445      * @dev Returns the owner of the `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function ownerOf(uint256 tokenId) external view returns (address owner);
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
455      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must exist and be owned by `from`.
462      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId
471     ) external;
472 
473     /**
474      * @dev Transfers `tokenId` token from `from` to `to`.
475      *
476      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must be owned by `from`.
483      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
484      *
485      * Emits a {Transfer} event.
486      */
487     function transferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external;
492 
493     /**
494      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
495      * The approval is cleared when the token is transferred.
496      *
497      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
498      *
499      * Requirements:
500      *
501      * - The caller must own the token or be an approved operator.
502      * - `tokenId` must exist.
503      *
504      * Emits an {Approval} event.
505      */
506     function approve(address to, uint256 tokenId) external;
507 
508     /**
509      * @dev Returns the account approved for `tokenId` token.
510      *
511      * Requirements:
512      *
513      * - `tokenId` must exist.
514      */
515     function getApproved(uint256 tokenId) external view returns (address operator);
516 
517     /**
518      * @dev Approve or remove `operator` as an operator for the caller.
519      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
520      *
521      * Requirements:
522      *
523      * - The `operator` cannot be the caller.
524      *
525      * Emits an {ApprovalForAll} event.
526      */
527     function setApprovalForAll(address operator, bool _approved) external;
528 
529     /**
530      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
531      *
532      * See {setApprovalForAll}
533      */
534     function isApprovedForAll(address owner, address operator) external view returns (bool);
535 
536     /**
537      * @dev Safely transfers `tokenId` token from `from` to `to`.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must exist and be owned by `from`.
544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
546      *
547      * Emits a {Transfer} event.
548      */
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 tokenId,
553         bytes calldata data
554     ) external;
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Metadata is IERC721 {
570     /**
571      * @dev Returns the token collection name.
572      */
573     function name() external view returns (string memory);
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() external view returns (string memory);
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) external view returns (string memory);
584 }
585 
586 // File: contracts/new.sol
587 
588 
589 
590 
591 pragma solidity ^0.8.4;
592 
593 
594 
595 
596 
597 
598 
599 
600 error ApprovalCallerNotOwnerNorApproved();
601 error ApprovalQueryForNonexistentToken();
602 error ApproveToCaller();
603 error ApprovalToCurrentOwner();
604 error BalanceQueryForZeroAddress();
605 error MintToZeroAddress();
606 error MintZeroQuantity();
607 error OwnerQueryForNonexistentToken();
608 error TransferCallerNotOwnerNorApproved();
609 error TransferFromIncorrectOwner();
610 error TransferToNonERC721ReceiverImplementer();
611 error TransferToZeroAddress();
612 error URIQueryForNonexistentToken();
613 
614 /**
615  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
616  * the Metadata extension. Built to optimize for lower gas during batch mints.
617  *
618  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
619  *
620  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
621  *
622  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
623  */
624 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
625     using Address for address;
626     using Strings for uint256;
627 
628     // Compiler will pack this into a single 256bit word.
629     struct TokenOwnership {
630         // The address of the owner.
631         address addr;
632         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
633         uint64 startTimestamp;
634         // Whether the token has been burned.
635         bool burned;
636     }
637 
638     // Compiler will pack this into a single 256bit word.
639     struct AddressData {
640         // Realistically, 2**64-1 is more than enough.
641         uint64 balance;
642         // Keeps track of mint count with minimal overhead for tokenomics.
643         uint64 numberMinted;
644         // Keeps track of burn count with minimal overhead for tokenomics.
645         uint64 numberBurned;
646         // For miscellaneous variable(s) pertaining to the address
647         // (e.g. number of whitelist mint slots used).
648         // If there are multiple variables, please pack them into a uint64.
649         uint64 aux;
650     }
651 
652     // The tokenId of the next token to be minted.
653     uint256 internal _currentIndex;
654 
655     // The number of tokens burned.
656     uint256 internal _burnCounter;
657 
658     // Token name
659     string private _name;
660 
661     // Token symbol
662     string private _symbol;
663 
664     // Mapping from token ID to ownership details
665     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
666     mapping(uint256 => TokenOwnership) internal _ownerships;
667 
668     // Mapping owner address to address data
669     mapping(address => AddressData) private _addressData;
670 
671     // Mapping from token ID to approved address
672     mapping(uint256 => address) private _tokenApprovals;
673 
674     // Mapping from owner to operator approvals
675     mapping(address => mapping(address => bool)) private _operatorApprovals;
676 
677     constructor(string memory name_, string memory symbol_) {
678         _name = name_;
679         _symbol = symbol_;
680         _currentIndex = _startTokenId();
681     }
682 
683     /**
684      * To change the starting tokenId, please override this function.
685      */
686     function _startTokenId() internal view virtual returns (uint256) {
687         return 0;
688     }
689 
690     /**
691      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
692      */
693     function totalSupply() public view returns (uint256) {
694         // Counter underflow is impossible as _burnCounter cannot be incremented
695         // more than _currentIndex - _startTokenId() times
696         unchecked {
697             return _currentIndex - _burnCounter - _startTokenId();
698         }
699     }
700 
701     /**
702      * Returns the total amount of tokens minted in the contract.
703      */
704     function _totalMinted() internal view returns (uint256) {
705         // Counter underflow is impossible as _currentIndex does not decrement,
706         // and it is initialized to _startTokenId()
707         unchecked {
708             return _currentIndex - _startTokenId();
709         }
710     }
711 
712     /**
713      * @dev See {IERC165-supportsInterface}.
714      */
715     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
716         return
717             interfaceId == type(IERC721).interfaceId ||
718             interfaceId == type(IERC721Metadata).interfaceId ||
719             super.supportsInterface(interfaceId);
720     }
721 
722     /**
723      * @dev See {IERC721-balanceOf}.
724      */
725     function balanceOf(address owner) public view override returns (uint256) {
726         if (owner == address(0)) revert BalanceQueryForZeroAddress();
727         return uint256(_addressData[owner].balance);
728     }
729 
730     /**
731      * Returns the number of tokens minted by `owner`.
732      */
733     function _numberMinted(address owner) internal view returns (uint256) {
734         return uint256(_addressData[owner].numberMinted);
735     }
736 
737     /**
738      * Returns the number of tokens burned by or on behalf of `owner`.
739      */
740     function _numberBurned(address owner) internal view returns (uint256) {
741         return uint256(_addressData[owner].numberBurned);
742     }
743 
744     /**
745      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
746      */
747     function _getAux(address owner) internal view returns (uint64) {
748         return _addressData[owner].aux;
749     }
750 
751     /**
752      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
753      * If there are multiple variables, please pack them into a uint64.
754      */
755     function _setAux(address owner, uint64 aux) internal {
756         _addressData[owner].aux = aux;
757     }
758 
759     /**
760      * Gas spent here starts off proportional to the maximum mint batch size.
761      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
762      */
763     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
764         uint256 curr = tokenId;
765 
766         unchecked {
767             if (_startTokenId() <= curr && curr < _currentIndex) {
768                 TokenOwnership memory ownership = _ownerships[curr];
769                 if (!ownership.burned) {
770                     if (ownership.addr != address(0)) {
771                         return ownership;
772                     }
773                     // Invariant:
774                     // There will always be an ownership that has an address and is not burned
775                     // before an ownership that does not have an address and is not burned.
776                     // Hence, curr will not underflow.
777                     while (true) {
778                         curr--;
779                         ownership = _ownerships[curr];
780                         if (ownership.addr != address(0)) {
781                             return ownership;
782                         }
783                     }
784                 }
785             }
786         }
787         revert OwnerQueryForNonexistentToken();
788     }
789 
790     /**
791      * @dev See {IERC721-ownerOf}.
792      */
793     function ownerOf(uint256 tokenId) public view override returns (address) {
794         return _ownershipOf(tokenId).addr;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-name}.
799      */
800     function name() public view virtual override returns (string memory) {
801         return _name;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-symbol}.
806      */
807     function symbol() public view virtual override returns (string memory) {
808         return _symbol;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-tokenURI}.
813      */
814     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
815         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
816 
817         string memory baseURI = _baseURI();
818         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
819     }
820 
821     /**
822      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
823      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
824      * by default, can be overriden in child contracts.
825      */
826     function _baseURI() internal view virtual returns (string memory) {
827         return '';
828     }
829 
830     /**
831      * @dev See {IERC721-approve}.
832      */
833     function approve(address to, uint256 tokenId) public override {
834         address owner = ERC721A.ownerOf(tokenId);
835         if (to == owner) revert ApprovalToCurrentOwner();
836 
837         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
838             revert ApprovalCallerNotOwnerNorApproved();
839         }
840 
841         _approve(to, tokenId, owner);
842     }
843 
844     /**
845      * @dev See {IERC721-getApproved}.
846      */
847     function getApproved(uint256 tokenId) public view override returns (address) {
848         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
849 
850         return _tokenApprovals[tokenId];
851     }
852 
853     /**
854      * @dev See {IERC721-setApprovalForAll}.
855      */
856     function setApprovalForAll(address operator, bool approved) public virtual override {
857         if (operator == _msgSender()) revert ApproveToCaller();
858 
859         _operatorApprovals[_msgSender()][operator] = approved;
860         emit ApprovalForAll(_msgSender(), operator, approved);
861     }
862 
863     /**
864      * @dev See {IERC721-isApprovedForAll}.
865      */
866     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
867         return _operatorApprovals[owner][operator];
868     }
869 
870     /**
871      * @dev See {IERC721-transferFrom}.
872      */
873     function transferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public virtual override {
878         _transfer(from, to, tokenId);
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId
888     ) public virtual override {
889         safeTransferFrom(from, to, tokenId, '');
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) public virtual override {
901         _transfer(from, to, tokenId);
902         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
903             revert TransferToNonERC721ReceiverImplementer();
904         }
905     }
906 
907     /**
908      * @dev Returns whether `tokenId` exists.
909      *
910      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
911      *
912      * Tokens start existing when they are minted (`_mint`),
913      */
914     function _exists(uint256 tokenId) internal view returns (bool) {
915         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
916             !_ownerships[tokenId].burned;
917     }
918 
919     function _safeMint(address to, uint256 quantity) internal {
920         _safeMint(to, quantity, '');
921     }
922 
923     /**
924      * @dev Safely mints `quantity` tokens and transfers them to `to`.
925      *
926      * Requirements:
927      *
928      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
929      * - `quantity` must be greater than 0.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _safeMint(
934         address to,
935         uint256 quantity,
936         bytes memory _data
937     ) internal {
938         _mint(to, quantity, _data, true);
939     }
940 
941     /**
942      * @dev Mints `quantity` tokens and transfers them to `to`.
943      *
944      * Requirements:
945      *
946      * - `to` cannot be the zero address.
947      * - `quantity` must be greater than 0.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _mint(
952         address to,
953         uint256 quantity,
954         bytes memory _data,
955         bool safe
956     ) internal {
957         uint256 startTokenId = _currentIndex;
958         if (to == address(0)) revert MintToZeroAddress();
959         if (quantity == 0) revert MintZeroQuantity();
960 
961         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
962 
963         // Overflows are incredibly unrealistic.
964         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
965         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
966         unchecked {
967             _addressData[to].balance += uint64(quantity);
968             _addressData[to].numberMinted += uint64(quantity);
969 
970             _ownerships[startTokenId].addr = to;
971             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
972 
973             uint256 updatedIndex = startTokenId;
974             uint256 end = updatedIndex + quantity;
975 
976             if (safe && to.isContract()) {
977                 do {
978                     emit Transfer(address(0), to, updatedIndex);
979                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
980                         revert TransferToNonERC721ReceiverImplementer();
981                     }
982                 } while (updatedIndex != end);
983                 // Reentrancy protection
984                 if (_currentIndex != startTokenId) revert();
985             } else {
986                 do {
987                     emit Transfer(address(0), to, updatedIndex++);
988                 } while (updatedIndex != end);
989             }
990             _currentIndex = updatedIndex;
991         }
992         _afterTokenTransfers(address(0), to, startTokenId, quantity);
993     }
994 
995     /**
996      * @dev Transfers `tokenId` from `from` to `to`.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `tokenId` token must be owned by `from`.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _transfer(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) private {
1010         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1011 
1012         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1013 
1014         bool isApprovedOrOwner = (_msgSender() == from ||
1015             isApprovedForAll(from, _msgSender()) ||
1016             getApproved(tokenId) == _msgSender());
1017 
1018         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1019         if (to == address(0)) revert TransferToZeroAddress();
1020 
1021         _beforeTokenTransfers(from, to, tokenId, 1);
1022 
1023         // Clear approvals from the previous owner
1024         _approve(address(0), tokenId, from);
1025 
1026         // Underflow of the sender's balance is impossible because we check for
1027         // ownership above and the recipient's balance can't realistically overflow.
1028         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1029         unchecked {
1030             _addressData[from].balance -= 1;
1031             _addressData[to].balance += 1;
1032 
1033             TokenOwnership storage currSlot = _ownerships[tokenId];
1034             currSlot.addr = to;
1035             currSlot.startTimestamp = uint64(block.timestamp);
1036 
1037             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1038             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1039             uint256 nextTokenId = tokenId + 1;
1040             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1041             if (nextSlot.addr == address(0)) {
1042                 // This will suffice for checking _exists(nextTokenId),
1043                 // as a burned slot cannot contain the zero address.
1044                 if (nextTokenId != _currentIndex) {
1045                     nextSlot.addr = from;
1046                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1047                 }
1048             }
1049         }
1050 
1051         emit Transfer(from, to, tokenId);
1052         _afterTokenTransfers(from, to, tokenId, 1);
1053     }
1054 
1055     /**
1056      * @dev This is equivalent to _burn(tokenId, false)
1057      */
1058     function _burn(uint256 tokenId) internal virtual {
1059         _burn(tokenId, false);
1060     }
1061 
1062     /**
1063      * @dev Destroys `tokenId`.
1064      * The approval is cleared when the token is burned.
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must exist.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1073         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1074 
1075         address from = prevOwnership.addr;
1076 
1077         if (approvalCheck) {
1078             bool isApprovedOrOwner = (_msgSender() == from ||
1079                 isApprovedForAll(from, _msgSender()) ||
1080                 getApproved(tokenId) == _msgSender());
1081 
1082             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1083         }
1084 
1085         _beforeTokenTransfers(from, address(0), tokenId, 1);
1086 
1087         // Clear approvals from the previous owner
1088         _approve(address(0), tokenId, from);
1089 
1090         // Underflow of the sender's balance is impossible because we check for
1091         // ownership above and the recipient's balance can't realistically overflow.
1092         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1093         unchecked {
1094             AddressData storage addressData = _addressData[from];
1095             addressData.balance -= 1;
1096             addressData.numberBurned += 1;
1097 
1098             // Keep track of who burned the token, and the timestamp of burning.
1099             TokenOwnership storage currSlot = _ownerships[tokenId];
1100             currSlot.addr = from;
1101             currSlot.startTimestamp = uint64(block.timestamp);
1102             currSlot.burned = true;
1103 
1104             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1105             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1106             uint256 nextTokenId = tokenId + 1;
1107             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1108             if (nextSlot.addr == address(0)) {
1109                 // This will suffice for checking _exists(nextTokenId),
1110                 // as a burned slot cannot contain the zero address.
1111                 if (nextTokenId != _currentIndex) {
1112                     nextSlot.addr = from;
1113                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1114                 }
1115             }
1116         }
1117 
1118         emit Transfer(from, address(0), tokenId);
1119         _afterTokenTransfers(from, address(0), tokenId, 1);
1120 
1121         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1122         unchecked {
1123             _burnCounter++;
1124         }
1125     }
1126 
1127     /**
1128      * @dev Approve `to` to operate on `tokenId`
1129      *
1130      * Emits a {Approval} event.
1131      */
1132     function _approve(
1133         address to,
1134         uint256 tokenId,
1135         address owner
1136     ) private {
1137         _tokenApprovals[tokenId] = to;
1138         emit Approval(owner, to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1143      *
1144      * @param from address representing the previous owner of the given token ID
1145      * @param to target address that will receive the tokens
1146      * @param tokenId uint256 ID of the token to be transferred
1147      * @param _data bytes optional data to send along with the call
1148      * @return bool whether the call correctly returned the expected magic value
1149      */
1150     function _checkContractOnERC721Received(
1151         address from,
1152         address to,
1153         uint256 tokenId,
1154         bytes memory _data
1155     ) private returns (bool) {
1156         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1157             return retval == IERC721Receiver(to).onERC721Received.selector;
1158         } catch (bytes memory reason) {
1159             if (reason.length == 0) {
1160                 revert TransferToNonERC721ReceiverImplementer();
1161             } else {
1162                 assembly {
1163                     revert(add(32, reason), mload(reason))
1164                 }
1165             }
1166         }
1167     }
1168 
1169     /**
1170      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1171      * And also called before burning one token.
1172      *
1173      * startTokenId - the first token id to be transferred
1174      * quantity - the amount to be transferred
1175      *
1176      * Calling conditions:
1177      *
1178      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1179      * transferred to `to`.
1180      * - When `from` is zero, `tokenId` will be minted for `to`.
1181      * - When `to` is zero, `tokenId` will be burned by `from`.
1182      * - `from` and `to` are never both zero.
1183      */
1184     function _beforeTokenTransfers(
1185         address from,
1186         address to,
1187         uint256 startTokenId,
1188         uint256 quantity
1189     ) internal virtual {}
1190 
1191     /**
1192      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1193      * minting.
1194      * And also called after one token has been burned.
1195      *
1196      * startTokenId - the first token id to be transferred
1197      * quantity - the amount to be transferred
1198      *
1199      * Calling conditions:
1200      *
1201      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1202      * transferred to `to`.
1203      * - When `from` is zero, `tokenId` has been minted for `to`.
1204      * - When `to` is zero, `tokenId` has been burned by `from`.
1205      * - `from` and `to` are never both zero.
1206      */
1207     function _afterTokenTransfers(
1208         address from,
1209         address to,
1210         uint256 startTokenId,
1211         uint256 quantity
1212     ) internal virtual {}
1213 }
1214 
1215 abstract contract Ownable is Context {
1216     address private _owner;
1217 
1218     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1219 
1220     /**
1221      * @dev Initializes the contract setting the deployer as the initial owner.
1222      */
1223     constructor() {
1224         _transferOwnership(_msgSender());
1225     }
1226 
1227     /**
1228      * @dev Returns the address of the current owner.
1229      */
1230     function owner() public view virtual returns (address) {
1231         return _owner;
1232     }
1233 
1234     /**
1235      * @dev Throws if called by any account other than the owner.
1236      */
1237     modifier onlyOwner() {
1238         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1239         _;
1240     }
1241 
1242     /**
1243      * @dev Leaves the contract without owner. It will not be possible to call
1244      * `onlyOwner` functions anymore. Can only be called by the current owner.
1245      *
1246      * NOTE: Renouncing ownership will leave the contract without an owner,
1247      * thereby removing any functionality that is only available to the owner.
1248      */
1249     function renounceOwnership() public virtual onlyOwner {
1250         _transferOwnership(address(0));
1251     }
1252 
1253     /**
1254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1255      * Can only be called by the current owner.
1256      */
1257     function transferOwnership(address newOwner) public virtual onlyOwner {
1258         require(newOwner != address(0), "Ownable: new owner is the zero address");
1259         _transferOwnership(newOwner);
1260     }
1261 
1262     /**
1263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1264      * Internal function without access restriction.
1265      */
1266     function _transferOwnership(address newOwner) internal virtual {
1267         address oldOwner = _owner;
1268         _owner = newOwner;
1269         emit OwnershipTransferred(oldOwner, newOwner);
1270     }
1271 }
1272 pragma solidity ^0.8.13;
1273 
1274 interface IOperatorFilterRegistry {
1275     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1276     function register(address registrant) external;
1277     function registerAndSubscribe(address registrant, address subscription) external;
1278     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1279     function updateOperator(address registrant, address operator, bool filtered) external;
1280     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1281     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1282     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1283     function subscribe(address registrant, address registrantToSubscribe) external;
1284     function unsubscribe(address registrant, bool copyExistingEntries) external;
1285     function subscriptionOf(address addr) external returns (address registrant);
1286     function subscribers(address registrant) external returns (address[] memory);
1287     function subscriberAt(address registrant, uint256 index) external returns (address);
1288     function copyEntriesOf(address registrant, address registrantToCopy) external;
1289     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1290     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1291     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1292     function filteredOperators(address addr) external returns (address[] memory);
1293     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1294     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1295     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1296     function isRegistered(address addr) external returns (bool);
1297     function codeHashOf(address addr) external returns (bytes32);
1298 }
1299 pragma solidity ^0.8.13;
1300 
1301 
1302 
1303 abstract contract OperatorFilterer {
1304     error OperatorNotAllowed(address operator);
1305 
1306     IOperatorFilterRegistry constant operatorFilterRegistry =
1307         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1308 
1309     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1310         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1311         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1312         // order for the modifier to filter addresses.
1313         if (address(operatorFilterRegistry).code.length > 0) {
1314             if (subscribe) {
1315                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1316             } else {
1317                 if (subscriptionOrRegistrantToCopy != address(0)) {
1318                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1319                 } else {
1320                     operatorFilterRegistry.register(address(this));
1321                 }
1322             }
1323         }
1324     }
1325 
1326     modifier onlyAllowedOperator(address from) virtual {
1327         // Check registry code length to facilitate testing in environments without a deployed registry.
1328         if (address(operatorFilterRegistry).code.length > 0) {
1329             // Allow spending tokens from addresses with balance
1330             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1331             // from an EOA.
1332             if (from == msg.sender) {
1333                 _;
1334                 return;
1335             }
1336             if (
1337                 !(
1338                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1339                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1340                 )
1341             ) {
1342                 revert OperatorNotAllowed(msg.sender);
1343             }
1344         }
1345         _;
1346     }
1347 }
1348 pragma solidity ^0.8.13;
1349 
1350 
1351 
1352 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1353     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1354 
1355     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1356 }
1357     pragma solidity ^0.8.7;
1358     
1359     contract CheckButts is ERC721A, DefaultOperatorFilterer , Ownable {
1360     using Strings for uint256;
1361 
1362 
1363   string private uriPrefix = "ipfs://bafybeidnaidnsoo2ju6k4hfqw7i2mg6sals73vdd77zybx3djwfr7lh3by/";
1364   string private uriSuffix = ".json";
1365   string public hiddenURL;
1366 
1367   
1368   
1369 
1370   uint256 public cost = 0.003 ether;
1371  
1372   
1373 
1374   uint16 public maxSupply = 6969;
1375   uint8 public maxMintAmountPerTx = 31;
1376   uint8 public maxFreeMintAmountPerWallet = 1;
1377                                                              
1378  
1379   bool public paused = true;
1380   bool public reveal = true;
1381 
1382    mapping (address => uint8) public NFTPerPublicAddress;
1383 
1384  
1385   
1386   
1387  
1388   
1389 
1390   constructor() ERC721A("CheckButts", "CK") {
1391   }
1392 
1393 
1394   
1395  
1396   function mint(uint8 _mintAmount) external payable  {
1397      uint16 totalSupply = uint16(totalSupply());
1398      uint8 nft = NFTPerPublicAddress[msg.sender];
1399     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1400     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1401     require(msg.sender == tx.origin , "No Bots Allowed");
1402 
1403     require(!paused, "The contract is paused!");
1404     
1405       if(nft >= maxFreeMintAmountPerWallet)
1406     {
1407     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1408     }
1409     else {
1410          uint8 costAmount = _mintAmount + nft;
1411         if(costAmount > maxFreeMintAmountPerWallet)
1412        {
1413         costAmount = costAmount - maxFreeMintAmountPerWallet;
1414         require(msg.value >= cost * costAmount, "Insufficient funds!");
1415        }
1416        
1417          
1418     }
1419     
1420 
1421 
1422     _safeMint(msg.sender , _mintAmount);
1423 
1424     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1425      
1426      delete totalSupply;
1427      delete _mintAmount;
1428   }
1429   
1430   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1431      uint16 totalSupply = uint16(totalSupply());
1432     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1433      _safeMint(_receiver , _mintAmount);
1434      delete _mintAmount;
1435      delete _receiver;
1436      delete totalSupply;
1437   }
1438 
1439   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1440      uint16 totalSupply = uint16(totalSupply());
1441      uint totalAmount =   _amountPerAddress * addresses.length;
1442     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1443      for (uint256 i = 0; i < addresses.length; i++) {
1444             _safeMint(addresses[i], _amountPerAddress);
1445         }
1446 
1447      delete _amountPerAddress;
1448      delete totalSupply;
1449   }
1450 
1451  
1452 
1453   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1454       maxSupply = _maxSupply;
1455   }
1456 
1457 
1458 
1459    
1460   function tokenURI(uint256 _tokenId)
1461     public
1462     view
1463     virtual
1464     override
1465     returns (string memory)
1466   {
1467     require(
1468       _exists(_tokenId),
1469       "ERC721Metadata: URI query for nonexistent token"
1470     );
1471     
1472   
1473 if ( reveal == false)
1474 {
1475     return hiddenURL;
1476 }
1477     
1478 
1479     string memory currentBaseURI = _baseURI();
1480     return bytes(currentBaseURI).length > 0
1481         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1482         : "";
1483   }
1484  
1485  
1486 
1487 
1488  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1489     maxFreeMintAmountPerWallet = _limit;
1490    delete _limit;
1491 
1492 }
1493 
1494     
1495   
1496 
1497   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1498     uriPrefix = _uriPrefix;
1499   }
1500    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1501     hiddenURL = _uriPrefix;
1502   }
1503 
1504 
1505   function setPaused() external onlyOwner {
1506     paused = !paused;
1507    
1508   }
1509 
1510   function setCost(uint _cost) external onlyOwner{
1511       cost = _cost;
1512 
1513   }
1514 
1515  function setRevealed() external onlyOwner{
1516      reveal = !reveal;
1517  }
1518 
1519   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1520       maxMintAmountPerTx = _maxtx;
1521 
1522   }
1523 
1524  
1525 
1526   function withdraw() external onlyOwner {
1527   uint _balance = address(this).balance;
1528      payable(msg.sender).transfer(_balance ); 
1529        
1530   }
1531 
1532 
1533   function _baseURI() internal view  override returns (string memory) {
1534     return uriPrefix;
1535   }
1536 
1537     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1538         super.transferFrom(from, to, tokenId);
1539     }
1540 
1541     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1542         super.safeTransferFrom(from, to, tokenId);
1543     }
1544 
1545     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1546         public
1547         override
1548         onlyAllowedOperator(from)
1549     {
1550         super.safeTransferFrom(from, to, tokenId, data);
1551     }
1552 }