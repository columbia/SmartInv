1 //SPDX-License-Identifier: UNLICENSED
2 //SKOOL DAYZ
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
687         return 1;
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
719             interfaceId == type(IERC2981).interfaceId ||
720             super.supportsInterface(interfaceId);
721     }
722 
723     /**
724      * @dev See {IERC721-balanceOf}.
725      */
726     function balanceOf(address owner) public view override returns (uint256) {
727         if (owner == address(0)) revert BalanceQueryForZeroAddress();
728         return uint256(_addressData[owner].balance);
729     }
730 
731     /**
732      * Returns the number of tokens minted by `owner`.
733      */
734     function _numberMinted(address owner) internal view returns (uint256) {
735         return uint256(_addressData[owner].numberMinted);
736     }
737 
738     /**
739      * Returns the number of tokens burned by or on behalf of `owner`.
740      */
741     function _numberBurned(address owner) internal view returns (uint256) {
742         return uint256(_addressData[owner].numberBurned);
743     }
744 
745     /**
746      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
747      */
748     function _getAux(address owner) internal view returns (uint64) {
749         return _addressData[owner].aux;
750     }
751 
752     /**
753      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
754      * If there are multiple variables, please pack them into a uint64.
755      */
756     function _setAux(address owner, uint64 aux) internal {
757         _addressData[owner].aux = aux;
758     }
759 
760     /**
761      * Gas spent here starts off proportional to the maximum mint batch size.
762      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
763      */
764     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
765         uint256 curr = tokenId;
766 
767         unchecked {
768             if (_startTokenId() <= curr && curr < _currentIndex) {
769                 TokenOwnership memory ownership = _ownerships[curr];
770                 if (!ownership.burned) {
771                     if (ownership.addr != address(0)) {
772                         return ownership;
773                     }
774                     // Invariant:
775                     // There will always be an ownership that has an address and is not burned
776                     // before an ownership that does not have an address and is not burned.
777                     // Hence, curr will not underflow.
778                     while (true) {
779                         curr--;
780                         ownership = _ownerships[curr];
781                         if (ownership.addr != address(0)) {
782                             return ownership;
783                         }
784                     }
785                 }
786             }
787         }
788         revert OwnerQueryForNonexistentToken();
789     }
790 
791     /**
792      * @dev See {IERC721-ownerOf}.
793      */
794     function ownerOf(uint256 tokenId) public view override returns (address) {
795         return _ownershipOf(tokenId).addr;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-name}.
800      */
801     function name() public view virtual override returns (string memory) {
802         return _name;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-symbol}.
807      */
808     function symbol() public view virtual override returns (string memory) {
809         return _symbol;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-tokenURI}.
814      */
815     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
816         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
817 
818         string memory baseURI = _baseURI();
819         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
820     }
821 
822     /**
823      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
824      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
825      * by default, can be overriden in child contracts.
826      */
827     function _baseURI() internal view virtual returns (string memory) {
828         return '';
829     }
830 
831     /**
832      * @dev See {IERC721-approve}.
833      */
834     function approve(address to, uint256 tokenId) public override {
835         address owner = ERC721A.ownerOf(tokenId);
836         if (to == owner) revert ApprovalToCurrentOwner();
837 
838         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
839             revert ApprovalCallerNotOwnerNorApproved();
840         }
841 
842         _approve(to, tokenId, owner);
843     }
844 
845     /**
846      * @dev See {IERC721-getApproved}.
847      */
848     function getApproved(uint256 tokenId) public view override returns (address) {
849         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
850 
851         return _tokenApprovals[tokenId];
852     }
853 
854     /**
855      * @dev See {IERC721-setApprovalForAll}.
856      */
857     function setApprovalForAll(address operator, bool approved) public virtual override {
858         if (operator == _msgSender()) revert ApproveToCaller();
859 
860         _operatorApprovals[_msgSender()][operator] = approved;
861         emit ApprovalForAll(_msgSender(), operator, approved);
862     }
863 
864     /**
865      * @dev See {IERC721-isApprovedForAll}.
866      */
867     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
868         return _operatorApprovals[owner][operator];
869     }
870 
871     /**
872      * @dev See {IERC721-transferFrom}.
873      */
874     function transferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         _transfer(from, to, tokenId);
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) public virtual override {
890         safeTransferFrom(from, to, tokenId, '');
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId,
900         bytes memory _data
901     ) public virtual override {
902         _transfer(from, to, tokenId);
903         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
904             revert TransferToNonERC721ReceiverImplementer();
905         }
906     }
907 
908     /**
909      * @dev Returns whether `tokenId` exists.
910      *
911      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
912      *
913      * Tokens start existing when they are minted (`_mint`),
914      */
915     function _exists(uint256 tokenId) internal view returns (bool) {
916         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
917             !_ownerships[tokenId].burned;
918     }
919 
920     function _safeMint(address to, uint256 quantity) internal {
921         _safeMint(to, quantity, '');
922     }
923 
924     /**
925      * @dev Safely mints `quantity` tokens and transfers them to `to`.
926      *
927      * Requirements:
928      *
929      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
930      * - `quantity` must be greater than 0.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _safeMint(
935         address to,
936         uint256 quantity,
937         bytes memory _data
938     ) internal {
939         _mint(to, quantity, _data, true);
940     }
941 
942     /**
943      * @dev Mints `quantity` tokens and transfers them to `to`.
944      *
945      * Requirements:
946      *
947      * - `to` cannot be the zero address.
948      * - `quantity` must be greater than 0.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _mint(
953         address to,
954         uint256 quantity,
955         bytes memory _data,
956         bool safe
957     ) internal {
958         uint256 startTokenId = _currentIndex;
959         if (to == address(0)) revert MintToZeroAddress();
960         if (quantity == 0) revert MintZeroQuantity();
961 
962         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
963 
964         // Overflows are incredibly unrealistic.
965         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
966         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
967         unchecked {
968             _addressData[to].balance += uint64(quantity);
969             _addressData[to].numberMinted += uint64(quantity);
970 
971             _ownerships[startTokenId].addr = to;
972             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
973 
974             uint256 updatedIndex = startTokenId;
975             uint256 end = updatedIndex + quantity;
976 
977             if (safe && to.isContract()) {
978                 do {
979                     emit Transfer(address(0), to, updatedIndex);
980                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
981                         revert TransferToNonERC721ReceiverImplementer();
982                     }
983                 } while (updatedIndex != end);
984                 // Reentrancy protection
985                 if (_currentIndex != startTokenId) revert();
986             } else {
987                 do {
988                     emit Transfer(address(0), to, updatedIndex++);
989                 } while (updatedIndex != end);
990             }
991             _currentIndex = updatedIndex;
992         }
993         _afterTokenTransfers(address(0), to, startTokenId, quantity);
994     }
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) private {
1011         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1012 
1013         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1014 
1015         bool isApprovedOrOwner = (_msgSender() == from ||
1016             isApprovedForAll(from, _msgSender()) ||
1017             getApproved(tokenId) == _msgSender());
1018 
1019         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1020         if (to == address(0)) revert TransferToZeroAddress();
1021 
1022         _beforeTokenTransfers(from, to, tokenId, 1);
1023 
1024         // Clear approvals from the previous owner
1025         _approve(address(0), tokenId, from);
1026 
1027         // Underflow of the sender's balance is impossible because we check for
1028         // ownership above and the recipient's balance can't realistically overflow.
1029         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1030         unchecked {
1031             _addressData[from].balance -= 1;
1032             _addressData[to].balance += 1;
1033 
1034             TokenOwnership storage currSlot = _ownerships[tokenId];
1035             currSlot.addr = to;
1036             currSlot.startTimestamp = uint64(block.timestamp);
1037 
1038             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1039             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1040             uint256 nextTokenId = tokenId + 1;
1041             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1042             if (nextSlot.addr == address(0)) {
1043                 // This will suffice for checking _exists(nextTokenId),
1044                 // as a burned slot cannot contain the zero address.
1045                 if (nextTokenId != _currentIndex) {
1046                     nextSlot.addr = from;
1047                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1048                 }
1049             }
1050         }
1051 
1052         emit Transfer(from, to, tokenId);
1053         _afterTokenTransfers(from, to, tokenId, 1);
1054     }
1055 
1056     /**
1057      * @dev This is equivalent to _burn(tokenId, false)
1058      */
1059     function _burn(uint256 tokenId) internal virtual {
1060         _burn(tokenId, false);
1061     }
1062 
1063     /**
1064      * @dev Destroys `tokenId`.
1065      * The approval is cleared when the token is burned.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must exist.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1074         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1075 
1076         address from = prevOwnership.addr;
1077 
1078         if (approvalCheck) {
1079             bool isApprovedOrOwner = (_msgSender() == from ||
1080                 isApprovedForAll(from, _msgSender()) ||
1081                 getApproved(tokenId) == _msgSender());
1082 
1083             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1084         }
1085 
1086         _beforeTokenTransfers(from, address(0), tokenId, 1);
1087 
1088         // Clear approvals from the previous owner
1089         _approve(address(0), tokenId, from);
1090 
1091         // Underflow of the sender's balance is impossible because we check for
1092         // ownership above and the recipient's balance can't realistically overflow.
1093         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1094         unchecked {
1095             AddressData storage addressData = _addressData[from];
1096             addressData.balance -= 1;
1097             addressData.numberBurned += 1;
1098 
1099             // Keep track of who burned the token, and the timestamp of burning.
1100             TokenOwnership storage currSlot = _ownerships[tokenId];
1101             currSlot.addr = from;
1102             currSlot.startTimestamp = uint64(block.timestamp);
1103             currSlot.burned = true;
1104 
1105             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1106             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1107             uint256 nextTokenId = tokenId + 1;
1108             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1109             if (nextSlot.addr == address(0)) {
1110                 // This will suffice for checking _exists(nextTokenId),
1111                 // as a burned slot cannot contain the zero address.
1112                 if (nextTokenId != _currentIndex) {
1113                     nextSlot.addr = from;
1114                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1115                 }
1116             }
1117         }
1118 
1119         emit Transfer(from, address(0), tokenId);
1120         _afterTokenTransfers(from, address(0), tokenId, 1);
1121 
1122         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1123         unchecked {
1124             _burnCounter++;
1125         }
1126     }
1127 
1128     /**
1129      * @dev Approve `to` to operate on `tokenId`
1130      *
1131      * Emits a {Approval} event.
1132      */
1133     function _approve(
1134         address to,
1135         uint256 tokenId,
1136         address owner
1137     ) private {
1138         _tokenApprovals[tokenId] = to;
1139         emit Approval(owner, to, tokenId);
1140     }
1141 
1142     /**
1143      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1144      *
1145      * @param from address representing the previous owner of the given token ID
1146      * @param to target address that will receive the tokens
1147      * @param tokenId uint256 ID of the token to be transferred
1148      * @param _data bytes optional data to send along with the call
1149      * @return bool whether the call correctly returned the expected magic value
1150      */
1151     function _checkContractOnERC721Received(
1152         address from,
1153         address to,
1154         uint256 tokenId,
1155         bytes memory _data
1156     ) private returns (bool) {
1157         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1158             return retval == IERC721Receiver(to).onERC721Received.selector;
1159         } catch (bytes memory reason) {
1160             if (reason.length == 0) {
1161                 revert TransferToNonERC721ReceiverImplementer();
1162             } else {
1163                 assembly {
1164                     revert(add(32, reason), mload(reason))
1165                 }
1166             }
1167         }
1168     }
1169 
1170     /**
1171      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1172      * And also called before burning one token.
1173      *
1174      * startTokenId - the first token id to be transferred
1175      * quantity - the amount to be transferred
1176      *
1177      * Calling conditions:
1178      *
1179      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1180      * transferred to `to`.
1181      * - When `from` is zero, `tokenId` will be minted for `to`.
1182      * - When `to` is zero, `tokenId` will be burned by `from`.
1183      * - `from` and `to` are never both zero.
1184      */
1185     function _beforeTokenTransfers(
1186         address from,
1187         address to,
1188         uint256 startTokenId,
1189         uint256 quantity
1190     ) internal virtual {}
1191 
1192     /**
1193      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1194      * minting.
1195      * And also called after one token has been burned.
1196      *
1197      * startTokenId - the first token id to be transferred
1198      * quantity - the amount to be transferred
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` has been minted for `to`.
1205      * - When `to` is zero, `tokenId` has been burned by `from`.
1206      * - `from` and `to` are never both zero.
1207      */
1208     function _afterTokenTransfers(
1209         address from,
1210         address to,
1211         uint256 startTokenId,
1212         uint256 quantity
1213     ) internal virtual {}
1214 }
1215 pragma solidity ^0.8.0;
1216 
1217 /**
1218  * @dev These functions deal with verification of Merkle Trees proofs.
1219  *
1220  * The proofs can be generated using the JavaScript library
1221  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1222  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1223  *
1224  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1225  */
1226 library MerkleProof {
1227     /**
1228      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1229      * defined by `root`. For this, a `proof` must be provided, containing
1230      * sibling hashes on the branch from the leaf to the root of the tree. Each
1231      * pair of leaves and each pair of pre-images are assumed to be sorted.
1232      */
1233     function verify(
1234         bytes32[] memory proof,
1235         bytes32 root,
1236         bytes32 leaf
1237     ) internal pure returns (bool) {
1238         return processProof(proof, leaf) == root;
1239     }
1240 
1241     /**
1242      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1243      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1244      * hash matches the root of the tree. When processing the proof, the pairs
1245      * of leafs & pre-images are assumed to be sorted.
1246      *
1247      * _Available since v4.4._
1248      */
1249     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1250         bytes32 computedHash = leaf;
1251         for (uint256 i = 0; i < proof.length; i++) {
1252             bytes32 proofElement = proof[i];
1253             if (computedHash <= proofElement) {
1254                 // Hash(current computed hash + current element of the proof)
1255                 computedHash = _efficientHash(computedHash, proofElement);
1256             } else {
1257                 // Hash(current element of the proof + current computed hash)
1258                 computedHash = _efficientHash(proofElement, computedHash);
1259             }
1260         }
1261         return computedHash;
1262     }
1263 
1264     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1265         assembly {
1266             mstore(0x00, a)
1267             mstore(0x20, b)
1268             value := keccak256(0x00, 0x40)
1269         }
1270     }
1271 }
1272 abstract contract Ownable is Context {
1273     address private _owner;
1274 
1275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1276 
1277     /**
1278      * @dev Initializes the contract setting the deployer as the initial owner.
1279      */
1280     constructor() {
1281         _transferOwnership(_msgSender());
1282     }
1283 
1284     /**
1285      * @dev Returns the address of the current owner.
1286      */
1287     function owner() public view virtual returns (address) {
1288         return _owner;
1289     }
1290 
1291     /**
1292      * @dev Throws if called by any account other than the owner.
1293      */
1294     modifier onlyOwner() {
1295         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1296         _;
1297     }
1298 
1299     /**
1300      * @dev Leaves the contract without owner. It will not be possible to call
1301      * `onlyOwner` functions anymore. Can only be called by the current owner.
1302      *
1303      * NOTE: Renouncing ownership will leave the contract without an owner,
1304      * thereby removing any functionality that is only available to the owner.
1305      */
1306     function renounceOwnership() public virtual onlyOwner {
1307         _transferOwnership(address(0));
1308     }
1309 
1310     /**
1311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1312      * Can only be called by the current owner.
1313      */
1314     function transferOwnership(address newOwner) public virtual onlyOwner {
1315         require(newOwner != address(0), "Ownable: new owner is the zero address");
1316         _transferOwnership(newOwner);
1317     }
1318 
1319     /**
1320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1321      * Internal function without access restriction.
1322      */
1323     function _transferOwnership(address newOwner) internal virtual {
1324         address oldOwner = _owner;
1325         _owner = newOwner;
1326         emit OwnershipTransferred(oldOwner, newOwner);
1327     }
1328 }
1329 
1330 interface IERC2981 is IERC165 {
1331     /// ERC165 bytes to add to interface array - set in parent contract
1332     /// implementing this standard
1333     ///
1334     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
1335     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1336     /// _registerInterface(_INTERFACE_ID_ERC2981);
1337 
1338     /// @notice Called with the sale price to determine how much royalty
1339     //          is owed and to whom.
1340     /// @param _tokenId - the NFT asset queried for royalty information
1341     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
1342     /// @return receiver - address of who should be sent the royalty payment
1343     /// @return royaltyAmount - the royalty payment amount for _salePrice
1344     function royaltyInfo(
1345         uint256 _tokenId,
1346         uint256 _salePrice
1347     ) external view returns (
1348         address receiver,
1349         uint256 royaltyAmount
1350     );
1351 }
1352 
1353 contract SkoolDayz is ERC721A, IERC2981, Ownable {
1354   using Strings for uint256;
1355   string public baseURI = "https://storage.googleapis.com/skooldayz/json/";
1356   uint256 public cost = 0 ether;
1357   uint256 public maxSupply = 5555;
1358   uint256 public mintStartTime = 0;
1359   mapping(address => uint256) public totalMinted;
1360   mapping(address => bool) internal admins;
1361   constructor(
1362   ) ERC721A("Skool Dayz", "SKOOL") {
1363     admins[0x3C6DBc42A18343e3CDDb5896bF09BB13BdE8D071] = true;
1364     admins[0x61afB7081CFAc891a5498702626F94932fbbEac3] = true;
1365     admins[0xA37BFe36d292EeFE8B93A7Cd8Fb9e83F12645C42] = true;
1366   }
1367   function mint(uint256 _mintAmount) public payable {
1368     uint256 supply = totalSupply();
1369     require(_mintAmount > 0, "You need to mint at least 1 NFT");
1370     require(supply + _mintAmount <= maxSupply, "Max NFT limit exceeded");
1371     if (msg.sender != owner()) {
1372         if (admins[msg.sender] != true) {
1373           require(mintStartTime>0, "Skool Day'z mint has not started");
1374           require(_mintAmount <= (5 - totalMinted[msg.sender]), "Max mint amount exceeded");
1375         }
1376     }
1377     _safeMint(msg.sender, _mintAmount);
1378     totalMinted[msg.sender] = totalMinted[msg.sender]+_mintAmount;
1379   }
1380   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1381     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1382     return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1383   }
1384   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1385     baseURI = _newBaseURI;
1386   }
1387   function startMint() public onlyOwner {
1388     mintStartTime = block.timestamp;
1389   }
1390   function royaltyInfo(uint256 tokenId, uint256 salePrice)
1391     public
1392     pure
1393     override
1394     returns (address receiver, uint256 royaltyAmount)
1395   {
1396     return (0xd6ab62d56f6DA9a47c528949510061a33726DD5b,(3 * salePrice)/100);
1397   }
1398 }