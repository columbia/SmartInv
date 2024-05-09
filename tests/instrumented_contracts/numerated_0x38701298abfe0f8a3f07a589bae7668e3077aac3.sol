1 // SPDX-License-Identifier: MIT
2 //Developer Info: Happy MLK day!
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/utils/Address.sol
101 
102 
103 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
104 
105 pragma solidity ^0.8.1;
106 
107 /**
108  * @dev Collection of functions related to the address type
109  */
110 library Address {
111     /**
112      * @dev Returns true if `account` is a contract.
113      *
114      * [IMPORTANT]
115      * ====
116      * It is unsafe to assume that an address for which this function returns
117      * false is an externally-owned account (EOA) and not a contract.
118      *
119      * Among others, `isContract` will return false for the following
120      * types of addresses:
121      *
122      *  - an externally-owned account
123      *  - a contract in construction
124      *  - an address where a contract will be created
125      *  - an address where a contract lived, but was destroyed
126      * ====
127      *
128      * [IMPORTANT]
129      * ====
130      * You shouldn't rely on `isContract` to protect against flash loan attacks!
131      *
132      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
133      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
134      * constructor.
135      * ====
136      */
137     function isContract(address account) internal view returns (bool) {
138         // This method relies on extcodesize/address.code.length, which returns 0
139         // for contracts in construction, since the code is only stored at the end
140         // of the constructor execution.
141 
142         return account.code.length > 0;
143     }
144 
145     /**
146      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
147      * `recipient`, forwarding all available gas and reverting on errors.
148      *
149      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
150      * of certain opcodes, possibly making contracts go over the 2300 gas limit
151      * imposed by `transfer`, making them unable to receive funds via
152      * `transfer`. {sendValue} removes this limitation.
153      *
154      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
155      *
156      * IMPORTANT: because control is transferred to `recipient`, care must be
157      * taken to not create reentrancy vulnerabilities. Consider using
158      * {ReentrancyGuard} or the
159      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
160      */
161     function sendValue(address payable recipient, uint256 amount) internal {
162         require(address(this).balance >= amount, "Address: insufficient balance");
163 
164         (bool success, ) = recipient.call{value: amount}("");
165         require(success, "Address: unable to send value, recipient may have reverted");
166     }
167 
168     /**
169      * @dev Performs a Solidity function call using a low level `call`. A
170      * plain `call` is an unsafe replacement for a function call: use this
171      * function instead.
172      *
173      * If `target` reverts with a revert reason, it is bubbled up by this
174      * function (like regular Solidity function calls).
175      *
176      * Returns the raw returned data. To convert to the expected return value,
177      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
178      *
179      * Requirements:
180      *
181      * - `target` must be a contract.
182      * - calling `target` with `data` must not revert.
183      *
184      * _Available since v3.1._
185      */
186     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
187         return functionCall(target, data, "Address: low-level call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
192      * `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, 0, errorMessage);
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
206      * but also transferring `value` wei to `target`.
207      *
208      * Requirements:
209      *
210      * - the calling contract must have an ETH balance of at least `value`.
211      * - the called Solidity function must be `payable`.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value
219     ) internal returns (bytes memory) {
220         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
225      * with `errorMessage` as a fallback revert reason when `target` reverts.
226      *
227      * _Available since v3.1._
228      */
229     function functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 value,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         require(address(this).balance >= value, "Address: insufficient balance for call");
236         require(isContract(target), "Address: call to non-contract");
237 
238         (bool success, bytes memory returndata) = target.call{value: value}(data);
239         return verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a static call.
245      *
246      * _Available since v3.3._
247      */
248     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
249         return functionStaticCall(target, data, "Address: low-level static call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a static call.
255      *
256      * _Available since v3.3._
257      */
258     function functionStaticCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal view returns (bytes memory) {
263         require(isContract(target), "Address: static call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.staticcall(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but performing a delegate call.
272      *
273      * _Available since v3.4._
274      */
275     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
276         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
281      * but performing a delegate call.
282      *
283      * _Available since v3.4._
284      */
285     function functionDelegateCall(
286         address target,
287         bytes memory data,
288         string memory errorMessage
289     ) internal returns (bytes memory) {
290         require(isContract(target), "Address: delegate call to non-contract");
291 
292         (bool success, bytes memory returndata) = target.delegatecall(data);
293         return verifyCallResult(success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
298      * revert reason using the provided one.
299      *
300      * _Available since v4.3._
301      */
302     function verifyCallResult(
303         bool success,
304         bytes memory returndata,
305         string memory errorMessage
306     ) internal pure returns (bytes memory) {
307         if (success) {
308             return returndata;
309         } else {
310             // Look for revert reason and bubble it up if present
311             if (returndata.length > 0) {
312                 // The easiest way to bubble the revert reason is using memory via assembly
313 
314                 assembly {
315                     let returndata_size := mload(returndata)
316                     revert(add(32, returndata), returndata_size)
317                 }
318             } else {
319                 revert(errorMessage);
320             }
321         }
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @title ERC721 token receiver interface
334  * @dev Interface for any contract that wants to support safeTransfers
335  * from ERC721 asset contracts.
336  */
337 interface IERC721Receiver {
338     /**
339      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
340      * by `operator` from `from`, this function is called.
341      *
342      * It must return its Solidity selector to confirm the token transfer.
343      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
344      *
345      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
346      */
347     function onERC721Received(
348         address operator,
349         address from,
350         uint256 tokenId,
351         bytes calldata data
352     ) external returns (bytes4);
353 }
354 
355 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Interface of the ERC165 standard, as defined in the
364  * https://eips.ethereum.org/EIPS/eip-165[EIP].
365  *
366  * Implementers can declare support of contract interfaces, which can then be
367  * queried by others ({ERC165Checker}).
368  *
369  * For an implementation, see {ERC165}.
370  */
371 interface IERC165 {
372     /**
373      * @dev Returns true if this contract implements the interface defined by
374      * `interfaceId`. See the corresponding
375      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
376      * to learn more about how these ids are created.
377      *
378      * This function call must use less than 30 000 gas.
379      */
380     function supportsInterface(bytes4 interfaceId) external view returns (bool);
381 }
382 
383 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 
391 /**
392  * @dev Implementation of the {IERC165} interface.
393  *
394  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
395  * for the additional interface id that will be supported. For example:
396  *
397  * ```solidity
398  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
399  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
400  * }
401  * ```
402  *
403  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
404  */
405 abstract contract ERC165 is IERC165 {
406     /**
407      * @dev See {IERC165-supportsInterface}.
408      */
409     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
410         return interfaceId == type(IERC165).interfaceId;
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
415 
416 
417 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Required interface of an ERC721 compliant contract.
424  */
425 interface IERC721 is IERC165 {
426     /**
427      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
428      */
429     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
430 
431     /**
432      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
433      */
434     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
435 
436     /**
437      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
438      */
439     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
440 
441     /**
442      * @dev Returns the number of tokens in ``owner``'s account.
443      */
444     function balanceOf(address owner) external view returns (uint256 balance);
445 
446     /**
447      * @dev Returns the owner of the `tokenId` token.
448      *
449      * Requirements:
450      *
451      * - `tokenId` must exist.
452      */
453     function ownerOf(uint256 tokenId) external view returns (address owner);
454 
455     /**
456      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
457      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must exist and be owned by `from`.
464      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
465      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
466      *
467      * Emits a {Transfer} event.
468      */
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Transfers `tokenId` token from `from` to `to`.
477      *
478      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must be owned by `from`.
485      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486      *
487      * Emits a {Transfer} event.
488      */
489     function transferFrom(
490         address from,
491         address to,
492         uint256 tokenId
493     ) external;
494 
495     /**
496      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
497      * The approval is cleared when the token is transferred.
498      *
499      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
500      *
501      * Requirements:
502      *
503      * - The caller must own the token or be an approved operator.
504      * - `tokenId` must exist.
505      *
506      * Emits an {Approval} event.
507      */
508     function approve(address to, uint256 tokenId) external;
509 
510     /**
511      * @dev Returns the account approved for `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function getApproved(uint256 tokenId) external view returns (address operator);
518 
519     /**
520      * @dev Approve or remove `operator` as an operator for the caller.
521      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
522      *
523      * Requirements:
524      *
525      * - The `operator` cannot be the caller.
526      *
527      * Emits an {ApprovalForAll} event.
528      */
529     function setApprovalForAll(address operator, bool _approved) external;
530 
531     /**
532      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
533      *
534      * See {setApprovalForAll}
535      */
536     function isApprovedForAll(address owner, address operator) external view returns (bool);
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`.
540      *
541      * Requirements:
542      *
543      * - `from` cannot be the zero address.
544      * - `to` cannot be the zero address.
545      * - `tokenId` token must exist and be owned by `from`.
546      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
547      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
548      *
549      * Emits a {Transfer} event.
550      */
551     function safeTransferFrom(
552         address from,
553         address to,
554         uint256 tokenId,
555         bytes calldata data
556     ) external;
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
569  * @dev See https://eips.ethereum.org/EIPS/eip-721
570  */
571 interface IERC721Metadata is IERC721 {
572     /**
573      * @dev Returns the token collection name.
574      */
575     function name() external view returns (string memory);
576 
577     /**
578      * @dev Returns the token collection symbol.
579      */
580     function symbol() external view returns (string memory);
581 
582     /**
583      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
584      */
585     function tokenURI(uint256 tokenId) external view returns (string memory);
586 }
587 
588 // File: contracts/new.sol
589 
590 
591 
592 
593 pragma solidity ^0.8.4;
594 
595 
596 
597 
598 
599 
600 
601 
602 error ApprovalCallerNotOwnerNorApproved();
603 error ApprovalQueryForNonexistentToken();
604 error ApproveToCaller();
605 error ApprovalToCurrentOwner();
606 error BalanceQueryForZeroAddress();
607 error MintToZeroAddress();
608 error MintZeroQuantity();
609 error OwnerQueryForNonexistentToken();
610 error TransferCallerNotOwnerNorApproved();
611 error TransferFromIncorrectOwner();
612 error TransferToNonERC721ReceiverImplementer();
613 error TransferToZeroAddress();
614 error URIQueryForNonexistentToken();
615 
616 /**
617  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
618  * the Metadata extension. Built to optimize for lower gas during batch mints.
619  *
620  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
621  *
622  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
623  *
624  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
625  */
626 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
627     using Address for address;
628     using Strings for uint256;
629 
630     // Compiler will pack this into a single 256bit word.
631     struct TokenOwnership {
632         // The address of the owner.
633         address addr;
634         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
635         uint64 startTimestamp;
636         // Whether the token has been burned.
637         bool burned;
638     }
639 
640     // Compiler will pack this into a single 256bit word.
641     struct AddressData {
642         // Realistically, 2**64-1 is more than enough.
643         uint64 balance;
644         // Keeps track of mint count with minimal overhead for tokenomics.
645         uint64 numberMinted;
646         // Keeps track of burn count with minimal overhead for tokenomics.
647         uint64 numberBurned;
648         // For miscellaneous variable(s) pertaining to the address
649         // (e.g. number of whitelist mint slots used).
650         // If there are multiple variables, please pack them into a uint64.
651         uint64 aux;
652     }
653 
654     // The tokenId of the next token to be minted.
655     uint256 internal _currentIndex;
656 
657     // The number of tokens burned.
658     uint256 internal _burnCounter;
659 
660     // Token name
661     string private _name;
662 
663     // Token symbol
664     string private _symbol;
665 
666     // Mapping from token ID to ownership details
667     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
668     mapping(uint256 => TokenOwnership) internal _ownerships;
669 
670     // Mapping owner address to address data
671     mapping(address => AddressData) private _addressData;
672 
673     // Mapping from token ID to approved address
674     mapping(uint256 => address) private _tokenApprovals;
675 
676     // Mapping from owner to operator approvals
677     mapping(address => mapping(address => bool)) private _operatorApprovals;
678 
679     constructor(string memory name_, string memory symbol_) {
680         _name = name_;
681         _symbol = symbol_;
682         _currentIndex = _startTokenId();
683     }
684 
685     /**
686      * To change the starting tokenId, please override this function.
687      */
688     function _startTokenId() internal view virtual returns (uint256) {
689         return 0;
690     }
691 
692     /**
693      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
694      */
695     function totalSupply() public view returns (uint256) {
696         // Counter underflow is impossible as _burnCounter cannot be incremented
697         // more than _currentIndex - _startTokenId() times
698         unchecked {
699             return _currentIndex - _burnCounter - _startTokenId();
700         }
701     }
702 
703     /**
704      * Returns the total amount of tokens minted in the contract.
705      */
706     function _totalMinted() internal view returns (uint256) {
707         // Counter underflow is impossible as _currentIndex does not decrement,
708         // and it is initialized to _startTokenId()
709         unchecked {
710             return _currentIndex - _startTokenId();
711         }
712     }
713 
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
718         return
719             interfaceId == type(IERC721).interfaceId ||
720             interfaceId == type(IERC721Metadata).interfaceId ||
721             super.supportsInterface(interfaceId);
722     }
723 
724     /**
725      * @dev See {IERC721-balanceOf}.
726      */
727     function balanceOf(address owner) public view override returns (uint256) {
728         if (owner == address(0)) revert BalanceQueryForZeroAddress();
729         return uint256(_addressData[owner].balance);
730     }
731 
732     /**
733      * Returns the number of tokens minted by `owner`.
734      */
735     function _numberMinted(address owner) internal view returns (uint256) {
736         return uint256(_addressData[owner].numberMinted);
737     }
738 
739     /**
740      * Returns the number of tokens burned by or on behalf of `owner`.
741      */
742     function _numberBurned(address owner) internal view returns (uint256) {
743         return uint256(_addressData[owner].numberBurned);
744     }
745 
746     /**
747      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
748      */
749     function _getAux(address owner) internal view returns (uint64) {
750         return _addressData[owner].aux;
751     }
752 
753     /**
754      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
755      * If there are multiple variables, please pack them into a uint64.
756      */
757     function _setAux(address owner, uint64 aux) internal {
758         _addressData[owner].aux = aux;
759     }
760 
761     /**
762      * Gas spent here starts off proportional to the maximum mint batch size.
763      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
764      */
765     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
766         uint256 curr = tokenId;
767 
768         unchecked {
769             if (_startTokenId() <= curr && curr < _currentIndex) {
770                 TokenOwnership memory ownership = _ownerships[curr];
771                 if (!ownership.burned) {
772                     if (ownership.addr != address(0)) {
773                         return ownership;
774                     }
775                     // Invariant:
776                     // There will always be an ownership that has an address and is not burned
777                     // before an ownership that does not have an address and is not burned.
778                     // Hence, curr will not underflow.
779                     while (true) {
780                         curr--;
781                         ownership = _ownerships[curr];
782                         if (ownership.addr != address(0)) {
783                             return ownership;
784                         }
785                     }
786                 }
787             }
788         }
789         revert OwnerQueryForNonexistentToken();
790     }
791 
792     /**
793      * @dev See {IERC721-ownerOf}.
794      */
795     function ownerOf(uint256 tokenId) public view override returns (address) {
796         return _ownershipOf(tokenId).addr;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-name}.
801      */
802     function name() public view virtual override returns (string memory) {
803         return _name;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-symbol}.
808      */
809     function symbol() public view virtual override returns (string memory) {
810         return _symbol;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-tokenURI}.
815      */
816     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
817         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
818 
819         string memory baseURI = _baseURI();
820         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
821     }
822 
823     /**
824      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
825      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
826      * by default, can be overriden in child contracts.
827      */
828     function _baseURI() internal view virtual returns (string memory) {
829         return '';
830     }
831 
832     /**
833      * @dev See {IERC721-approve}.
834      */
835     function approve(address to, uint256 tokenId) public override {
836         address owner = ERC721A.ownerOf(tokenId);
837         if (to == owner) revert ApprovalToCurrentOwner();
838 
839         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
840             revert ApprovalCallerNotOwnerNorApproved();
841         }
842 
843         _approve(to, tokenId, owner);
844     }
845 
846     /**
847      * @dev See {IERC721-getApproved}.
848      */
849     function getApproved(uint256 tokenId) public view override returns (address) {
850         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
851 
852         return _tokenApprovals[tokenId];
853     }
854 
855     /**
856      * @dev See {IERC721-setApprovalForAll}.
857      */
858     function setApprovalForAll(address operator, bool approved) public virtual override {
859         if (operator == _msgSender()) revert ApproveToCaller();
860 
861         _operatorApprovals[_msgSender()][operator] = approved;
862         emit ApprovalForAll(_msgSender(), operator, approved);
863     }
864 
865     /**
866      * @dev See {IERC721-isApprovedForAll}.
867      */
868     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
869         return _operatorApprovals[owner][operator];
870     }
871 
872     /**
873      * @dev See {IERC721-transferFrom}.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         _transfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         safeTransferFrom(from, to, tokenId, '');
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) public virtual override {
903         _transfer(from, to, tokenId);
904         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
905             revert TransferToNonERC721ReceiverImplementer();
906         }
907     }
908 
909     /**
910      * @dev Returns whether `tokenId` exists.
911      *
912      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
913      *
914      * Tokens start existing when they are minted (`_mint`),
915      */
916     function _exists(uint256 tokenId) internal view returns (bool) {
917         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
918             !_ownerships[tokenId].burned;
919     }
920 
921     function _safeMint(address to, uint256 quantity) internal {
922         _safeMint(to, quantity, '');
923     }
924 
925     /**
926      * @dev Safely mints `quantity` tokens and transfers them to `to`.
927      *
928      * Requirements:
929      *
930      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
931      * - `quantity` must be greater than 0.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _safeMint(
936         address to,
937         uint256 quantity,
938         bytes memory _data
939     ) internal {
940         _mint(to, quantity, _data, true);
941     }
942 
943     /**
944      * @dev Mints `quantity` tokens and transfers them to `to`.
945      *
946      * Requirements:
947      *
948      * - `to` cannot be the zero address.
949      * - `quantity` must be greater than 0.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _mint(
954         address to,
955         uint256 quantity,
956         bytes memory _data,
957         bool safe
958     ) internal {
959         uint256 startTokenId = _currentIndex;
960         if (to == address(0)) revert MintToZeroAddress();
961         if (quantity == 0) revert MintZeroQuantity();
962 
963         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
964 
965         // Overflows are incredibly unrealistic.
966         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
967         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
968         unchecked {
969             _addressData[to].balance += uint64(quantity);
970             _addressData[to].numberMinted += uint64(quantity);
971 
972             _ownerships[startTokenId].addr = to;
973             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
974 
975             uint256 updatedIndex = startTokenId;
976             uint256 end = updatedIndex + quantity;
977 
978             if (safe && to.isContract()) {
979                 do {
980                     emit Transfer(address(0), to, updatedIndex);
981                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
982                         revert TransferToNonERC721ReceiverImplementer();
983                     }
984                 } while (updatedIndex != end);
985                 // Reentrancy protection
986                 if (_currentIndex != startTokenId) revert();
987             } else {
988                 do {
989                     emit Transfer(address(0), to, updatedIndex++);
990                 } while (updatedIndex != end);
991             }
992             _currentIndex = updatedIndex;
993         }
994         _afterTokenTransfers(address(0), to, startTokenId, quantity);
995     }
996 
997     /**
998      * @dev Transfers `tokenId` from `from` to `to`.
999      *
1000      * Requirements:
1001      *
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must be owned by `from`.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _transfer(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) private {
1012         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1013 
1014         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1015 
1016         bool isApprovedOrOwner = (_msgSender() == from ||
1017             isApprovedForAll(from, _msgSender()) ||
1018             getApproved(tokenId) == _msgSender());
1019 
1020         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1021         if (to == address(0)) revert TransferToZeroAddress();
1022 
1023         _beforeTokenTransfers(from, to, tokenId, 1);
1024 
1025         // Clear approvals from the previous owner
1026         _approve(address(0), tokenId, from);
1027 
1028         // Underflow of the sender's balance is impossible because we check for
1029         // ownership above and the recipient's balance can't realistically overflow.
1030         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1031         unchecked {
1032             _addressData[from].balance -= 1;
1033             _addressData[to].balance += 1;
1034 
1035             TokenOwnership storage currSlot = _ownerships[tokenId];
1036             currSlot.addr = to;
1037             currSlot.startTimestamp = uint64(block.timestamp);
1038 
1039             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1040             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1041             uint256 nextTokenId = tokenId + 1;
1042             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1043             if (nextSlot.addr == address(0)) {
1044                 // This will suffice for checking _exists(nextTokenId),
1045                 // as a burned slot cannot contain the zero address.
1046                 if (nextTokenId != _currentIndex) {
1047                     nextSlot.addr = from;
1048                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1049                 }
1050             }
1051         }
1052 
1053         emit Transfer(from, to, tokenId);
1054         _afterTokenTransfers(from, to, tokenId, 1);
1055     }
1056 
1057     /**
1058      * @dev This is equivalent to _burn(tokenId, false)
1059      */
1060     function _burn(uint256 tokenId) internal virtual {
1061         _burn(tokenId, false);
1062     }
1063 
1064     /**
1065      * @dev Destroys `tokenId`.
1066      * The approval is cleared when the token is burned.
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must exist.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1075         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1076 
1077         address from = prevOwnership.addr;
1078 
1079         if (approvalCheck) {
1080             bool isApprovedOrOwner = (_msgSender() == from ||
1081                 isApprovedForAll(from, _msgSender()) ||
1082                 getApproved(tokenId) == _msgSender());
1083 
1084             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1085         }
1086 
1087         _beforeTokenTransfers(from, address(0), tokenId, 1);
1088 
1089         // Clear approvals from the previous owner
1090         _approve(address(0), tokenId, from);
1091 
1092         // Underflow of the sender's balance is impossible because we check for
1093         // ownership above and the recipient's balance can't realistically overflow.
1094         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1095         unchecked {
1096             AddressData storage addressData = _addressData[from];
1097             addressData.balance -= 1;
1098             addressData.numberBurned += 1;
1099 
1100             // Keep track of who burned the token, and the timestamp of burning.
1101             TokenOwnership storage currSlot = _ownerships[tokenId];
1102             currSlot.addr = from;
1103             currSlot.startTimestamp = uint64(block.timestamp);
1104             currSlot.burned = true;
1105 
1106             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1107             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1108             uint256 nextTokenId = tokenId + 1;
1109             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1110             if (nextSlot.addr == address(0)) {
1111                 // This will suffice for checking _exists(nextTokenId),
1112                 // as a burned slot cannot contain the zero address.
1113                 if (nextTokenId != _currentIndex) {
1114                     nextSlot.addr = from;
1115                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1116                 }
1117             }
1118         }
1119 
1120         emit Transfer(from, address(0), tokenId);
1121         _afterTokenTransfers(from, address(0), tokenId, 1);
1122 
1123         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1124         unchecked {
1125             _burnCounter++;
1126         }
1127     }
1128 
1129     /**
1130      * @dev Approve `to` to operate on `tokenId`
1131      *
1132      * Emits a {Approval} event.
1133      */
1134     function _approve(
1135         address to,
1136         uint256 tokenId,
1137         address owner
1138     ) private {
1139         _tokenApprovals[tokenId] = to;
1140         emit Approval(owner, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1145      *
1146      * @param from address representing the previous owner of the given token ID
1147      * @param to target address that will receive the tokens
1148      * @param tokenId uint256 ID of the token to be transferred
1149      * @param _data bytes optional data to send along with the call
1150      * @return bool whether the call correctly returned the expected magic value
1151      */
1152     function _checkContractOnERC721Received(
1153         address from,
1154         address to,
1155         uint256 tokenId,
1156         bytes memory _data
1157     ) private returns (bool) {
1158         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1159             return retval == IERC721Receiver(to).onERC721Received.selector;
1160         } catch (bytes memory reason) {
1161             if (reason.length == 0) {
1162                 revert TransferToNonERC721ReceiverImplementer();
1163             } else {
1164                 assembly {
1165                     revert(add(32, reason), mload(reason))
1166                 }
1167             }
1168         }
1169     }
1170 
1171     /**
1172      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1173      * And also called before burning one token.
1174      *
1175      * startTokenId - the first token id to be transferred
1176      * quantity - the amount to be transferred
1177      *
1178      * Calling conditions:
1179      *
1180      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1181      * transferred to `to`.
1182      * - When `from` is zero, `tokenId` will be minted for `to`.
1183      * - When `to` is zero, `tokenId` will be burned by `from`.
1184      * - `from` and `to` are never both zero.
1185      */
1186     function _beforeTokenTransfers(
1187         address from,
1188         address to,
1189         uint256 startTokenId,
1190         uint256 quantity
1191     ) internal virtual {}
1192 
1193     /**
1194      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1195      * minting.
1196      * And also called after one token has been burned.
1197      *
1198      * startTokenId - the first token id to be transferred
1199      * quantity - the amount to be transferred
1200      *
1201      * Calling conditions:
1202      *
1203      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1204      * transferred to `to`.
1205      * - When `from` is zero, `tokenId` has been minted for `to`.
1206      * - When `to` is zero, `tokenId` has been burned by `from`.
1207      * - `from` and `to` are never both zero.
1208      */
1209     function _afterTokenTransfers(
1210         address from,
1211         address to,
1212         uint256 startTokenId,
1213         uint256 quantity
1214     ) internal virtual {}
1215 }
1216 
1217 abstract contract Ownable is Context {
1218     address private _owner;
1219 
1220     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1221 
1222     /**
1223      * @dev Initializes the contract setting the deployer as the initial owner.
1224      */
1225     constructor() {
1226         _transferOwnership(_msgSender());
1227     }
1228 
1229     /**
1230      * @dev Returns the address of the current owner.
1231      */
1232     function owner() public view virtual returns (address) {
1233         return _owner;
1234     }
1235 
1236     /**
1237      * @dev Throws if called by any account other than the owner.
1238      */
1239     modifier onlyOwner() {
1240         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1241         _;
1242     }
1243 
1244     /**
1245      * @dev Leaves the contract without owner. It will not be possible to call
1246      * `onlyOwner` functions anymore. Can only be called by the current owner.
1247      *
1248      * NOTE: Renouncing ownership will leave the contract without an owner,
1249      * thereby removing any functionality that is only available to the owner.
1250      */
1251     function renounceOwnership() public virtual onlyOwner {
1252         _transferOwnership(address(0));
1253     }
1254 
1255     /**
1256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1257      * Can only be called by the current owner.
1258      */
1259     function transferOwnership(address newOwner) public virtual onlyOwner {
1260         require(newOwner != address(0), "Ownable: new owner is the zero address");
1261         _transferOwnership(newOwner);
1262     }
1263 
1264     /**
1265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1266      * Internal function without access restriction.
1267      */
1268     function _transferOwnership(address newOwner) internal virtual {
1269         address oldOwner = _owner;
1270         _owner = newOwner;
1271         emit OwnershipTransferred(oldOwner, newOwner);
1272     }
1273 }
1274 pragma solidity ^0.8.13;
1275 
1276 interface IOperatorFilterRegistry {
1277     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1278     function register(address registrant) external;
1279     function registerAndSubscribe(address registrant, address subscription) external;
1280     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1281     function updateOperator(address registrant, address operator, bool filtered) external;
1282     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1283     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1284     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1285     function subscribe(address registrant, address registrantToSubscribe) external;
1286     function unsubscribe(address registrant, bool copyExistingEntries) external;
1287     function subscriptionOf(address addr) external returns (address registrant);
1288     function subscribers(address registrant) external returns (address[] memory);
1289     function subscriberAt(address registrant, uint256 index) external returns (address);
1290     function copyEntriesOf(address registrant, address registrantToCopy) external;
1291     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1292     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1293     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1294     function filteredOperators(address addr) external returns (address[] memory);
1295     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1296     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1297     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1298     function isRegistered(address addr) external returns (bool);
1299     function codeHashOf(address addr) external returns (bytes32);
1300 }
1301 pragma solidity ^0.8.13;
1302 
1303 
1304 
1305 abstract contract OperatorFilterer {
1306     error OperatorNotAllowed(address operator);
1307 
1308     IOperatorFilterRegistry constant operatorFilterRegistry =
1309         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1310 
1311     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1312         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1313         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1314         // order for the modifier to filter addresses.
1315         if (address(operatorFilterRegistry).code.length > 0) {
1316             if (subscribe) {
1317                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1318             } else {
1319                 if (subscriptionOrRegistrantToCopy != address(0)) {
1320                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1321                 } else {
1322                     operatorFilterRegistry.register(address(this));
1323                 }
1324             }
1325         }
1326     }
1327 
1328     modifier onlyAllowedOperator(address from) virtual {
1329         // Check registry code length to facilitate testing in environments without a deployed registry.
1330         if (address(operatorFilterRegistry).code.length > 0) {
1331             // Allow spending tokens from addresses with balance
1332             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1333             // from an EOA.
1334             if (from == msg.sender) {
1335                 _;
1336                 return;
1337             }
1338             if (
1339                 !(
1340                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1341                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1342                 )
1343             ) {
1344                 revert OperatorNotAllowed(msg.sender);
1345             }
1346         }
1347         _;
1348     }
1349 }
1350 pragma solidity ^0.8.13;
1351 
1352 
1353 
1354 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1355     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1356 
1357     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1358 }
1359     pragma solidity ^0.8.7;
1360     
1361     contract Cluck is ERC721A, DefaultOperatorFilterer , Ownable {
1362     using Strings for uint256;
1363 
1364 
1365   string private uriPrefix ;
1366   string private uriSuffix = ".json";
1367   string public hiddenURL;
1368 
1369   
1370   
1371 
1372   uint256 public cost = 0.003 ether;
1373  
1374   
1375 
1376   uint16 public maxSupply = 5555;
1377   uint8 public maxMintAmountPerTx = 26;
1378     uint8 public maxFreeMintAmountPerWallet = 1;
1379                                                              
1380  
1381   bool public paused = true;
1382   bool public reveal =false;
1383 
1384    mapping (address => uint8) public NFTPerPublicAddress;
1385 
1386  
1387   
1388   
1389  
1390   
1391 
1392   constructor() ERC721A("Cluck", "$CLUCK") {
1393   }
1394 
1395 
1396   
1397  
1398   function mint(uint8 _mintAmount) external payable  {
1399      uint16 totalSupply = uint16(totalSupply());
1400      uint8 nft = NFTPerPublicAddress[msg.sender];
1401     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1402     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1403     require(msg.sender == tx.origin , "No Bots Allowed");
1404 
1405     require(!paused, "The contract is paused!");
1406     
1407       if(nft >= maxFreeMintAmountPerWallet)
1408     {
1409     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1410     }
1411     else {
1412          uint8 costAmount = _mintAmount + nft;
1413         if(costAmount > maxFreeMintAmountPerWallet)
1414        {
1415         costAmount = costAmount - maxFreeMintAmountPerWallet;
1416         require(msg.value >= cost * costAmount, "Insufficient funds!");
1417        }
1418        
1419          
1420     }
1421     
1422 
1423 
1424     _safeMint(msg.sender , _mintAmount);
1425 
1426     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1427      
1428      delete totalSupply;
1429      delete _mintAmount;
1430   }
1431   
1432   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1433      uint16 totalSupply = uint16(totalSupply());
1434     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1435      _safeMint(_receiver , _mintAmount);
1436      delete _mintAmount;
1437      delete _receiver;
1438      delete totalSupply;
1439   }
1440 
1441   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1442      uint16 totalSupply = uint16(totalSupply());
1443      uint totalAmount =   _amountPerAddress * addresses.length;
1444     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1445      for (uint256 i = 0; i < addresses.length; i++) {
1446             _safeMint(addresses[i], _amountPerAddress);
1447         }
1448 
1449      delete _amountPerAddress;
1450      delete totalSupply;
1451   }
1452 
1453  
1454 
1455   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1456       maxSupply = _maxSupply;
1457   }
1458 
1459 
1460 
1461    
1462   function tokenURI(uint256 _tokenId)
1463     public
1464     view
1465     virtual
1466     override
1467     returns (string memory)
1468   {
1469     require(
1470       _exists(_tokenId),
1471       "ERC721Metadata: URI query for nonexistent token"
1472     );
1473     
1474   
1475 if ( reveal == false)
1476 {
1477     return hiddenURL;
1478 }
1479     
1480 
1481     string memory currentBaseURI = _baseURI();
1482     return bytes(currentBaseURI).length > 0
1483         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1484         : "";
1485   }
1486  
1487  
1488 
1489 
1490  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1491     maxFreeMintAmountPerWallet = _limit;
1492    delete _limit;
1493 
1494 }
1495 
1496     
1497   
1498 
1499   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1500     uriPrefix = _uriPrefix;
1501   }
1502    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1503     hiddenURL = _uriPrefix;
1504   }
1505 
1506 
1507   function setPaused() external onlyOwner {
1508     paused = !paused;
1509    
1510   }
1511 
1512   function setCost(uint _cost) external onlyOwner{
1513       cost = _cost;
1514 
1515   }
1516 
1517  function setRevealed() external onlyOwner{
1518      reveal = !reveal;
1519  }
1520 
1521   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1522       maxMintAmountPerTx = _maxtx;
1523 
1524   }
1525 
1526  
1527 
1528   function withdraw() external onlyOwner {
1529   uint _balance = address(this).balance;
1530      payable(msg.sender).transfer(_balance ); 
1531        
1532   }
1533 
1534 
1535   function _baseURI() internal view  override returns (string memory) {
1536     return uriPrefix;
1537   }
1538 
1539     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1540         super.transferFrom(from, to, tokenId);
1541     }
1542 
1543     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1544         super.safeTransferFrom(from, to, tokenId);
1545     }
1546 
1547     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1548         public
1549         override
1550         onlyAllowedOperator(from)
1551     {
1552         super.safeTransferFrom(from, to, tokenId, data);
1553     }
1554 }