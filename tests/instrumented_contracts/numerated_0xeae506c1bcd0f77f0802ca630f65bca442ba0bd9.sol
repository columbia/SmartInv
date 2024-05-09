1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/utils/Address.sol
100 
101 
102 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
103 
104 pragma solidity ^0.8.1;
105 
106 /**
107  * @dev Collection of functions related to the address type
108  */
109 library Address {
110     /**
111      * @dev Returns true if `account` is a contract.
112      *
113      * [IMPORTANT]
114      * ====
115      * It is unsafe to assume that an address for which this function returns
116      * false is an externally-owned account (EOA) and not a contract.
117      *
118      * Among others, `isContract` will return false for the following
119      * types of addresses:
120      *
121      *  - an externally-owned account
122      *  - a contract in construction
123      *  - an address where a contract will be created
124      *  - an address where a contract lived, but was destroyed
125      * ====
126      *
127      * [IMPORTANT]
128      * ====
129      * You shouldn't rely on `isContract` to protect against flash loan attacks!
130      *
131      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
132      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
133      * constructor.
134      * ====
135      */
136     function isContract(address account) internal view returns (bool) {
137         // This method relies on extcodesize/address.code.length, which returns 0
138         // for contracts in construction, since the code is only stored at the end
139         // of the constructor execution.
140 
141         return account.code.length > 0;
142     }
143 
144     /**
145      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
146      * `recipient`, forwarding all available gas and reverting on errors.
147      *
148      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
149      * of certain opcodes, possibly making contracts go over the 2300 gas limit
150      * imposed by `transfer`, making them unable to receive funds via
151      * `transfer`. {sendValue} removes this limitation.
152      *
153      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
154      *
155      * IMPORTANT: because control is transferred to `recipient`, care must be
156      * taken to not create reentrancy vulnerabilities. Consider using
157      * {ReentrancyGuard} or the
158      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
159      */
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(address(this).balance >= amount, "Address: insufficient balance");
162 
163         (bool success, ) = recipient.call{value: amount}("");
164         require(success, "Address: unable to send value, recipient may have reverted");
165     }
166 
167     /**
168      * @dev Performs a Solidity function call using a low level `call`. A
169      * plain `call` is an unsafe replacement for a function call: use this
170      * function instead.
171      *
172      * If `target` reverts with a revert reason, it is bubbled up by this
173      * function (like regular Solidity function calls).
174      *
175      * Returns the raw returned data. To convert to the expected return value,
176      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
177      *
178      * Requirements:
179      *
180      * - `target` must be a contract.
181      * - calling `target` with `data` must not revert.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionCall(target, data, "Address: low-level call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
191      * `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but also transferring `value` wei to `target`.
206      *
207      * Requirements:
208      *
209      * - the calling contract must have an ETH balance of at least `value`.
210      * - the called Solidity function must be `payable`.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
224      * with `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         require(address(this).balance >= value, "Address: insufficient balance for call");
235         require(isContract(target), "Address: call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.call{value: value}(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
248         return functionStaticCall(target, data, "Address: low-level static call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal view returns (bytes memory) {
262         require(isContract(target), "Address: static call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.staticcall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
275         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         require(isContract(target), "Address: delegate call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.delegatecall(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
297      * revert reason using the provided one.
298      *
299      * _Available since v4.3._
300      */
301     function verifyCallResult(
302         bool success,
303         bytes memory returndata,
304         string memory errorMessage
305     ) internal pure returns (bytes memory) {
306         if (success) {
307             return returndata;
308         } else {
309             // Look for revert reason and bubble it up if present
310             if (returndata.length > 0) {
311                 // The easiest way to bubble the revert reason is using memory via assembly
312 
313                 assembly {
314                     let returndata_size := mload(returndata)
315                     revert(add(32, returndata), returndata_size)
316                 }
317             } else {
318                 revert(errorMessage);
319             }
320         }
321     }
322 }
323 
324 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @title ERC721 token receiver interface
333  * @dev Interface for any contract that wants to support safeTransfers
334  * from ERC721 asset contracts.
335  */
336 interface IERC721Receiver {
337     /**
338      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
339      * by `operator` from `from`, this function is called.
340      *
341      * It must return its Solidity selector to confirm the token transfer.
342      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
343      *
344      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
345      */
346     function onERC721Received(
347         address operator,
348         address from,
349         uint256 tokenId,
350         bytes calldata data
351     ) external returns (bytes4);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @dev Interface of the ERC165 standard, as defined in the
363  * https://eips.ethereum.org/EIPS/eip-165[EIP].
364  *
365  * Implementers can declare support of contract interfaces, which can then be
366  * queried by others ({ERC165Checker}).
367  *
368  * For an implementation, see {ERC165}.
369  */
370 interface IERC165 {
371     /**
372      * @dev Returns true if this contract implements the interface defined by
373      * `interfaceId`. See the corresponding
374      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
375      * to learn more about how these ids are created.
376      *
377      * This function call must use less than 30 000 gas.
378      */
379     function supportsInterface(bytes4 interfaceId) external view returns (bool);
380 }
381 
382 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Implementation of the {IERC165} interface.
392  *
393  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
394  * for the additional interface id that will be supported. For example:
395  *
396  * ```solidity
397  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
398  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
399  * }
400  * ```
401  *
402  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
403  */
404 abstract contract ERC165 is IERC165 {
405     /**
406      * @dev See {IERC165-supportsInterface}.
407      */
408     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
409         return interfaceId == type(IERC165).interfaceId;
410     }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
414 
415 
416 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Required interface of an ERC721 compliant contract.
423  */
424 interface IERC721 is IERC165 {
425     /**
426      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
427      */
428     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
429 
430     /**
431      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
432      */
433     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
434 
435     /**
436      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
437      */
438     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
439 
440     /**
441      * @dev Returns the number of tokens in ``owner``'s account.
442      */
443     function balanceOf(address owner) external view returns (uint256 balance);
444 
445     /**
446      * @dev Returns the owner of the `tokenId` token.
447      *
448      * Requirements:
449      *
450      * - `tokenId` must exist.
451      */
452     function ownerOf(uint256 tokenId) external view returns (address owner);
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
463      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
510      * @dev Returns the account approved for `tokenId` token.
511      *
512      * Requirements:
513      *
514      * - `tokenId` must exist.
515      */
516     function getApproved(uint256 tokenId) external view returns (address operator);
517 
518     /**
519      * @dev Approve or remove `operator` as an operator for the caller.
520      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
521      *
522      * Requirements:
523      *
524      * - The `operator` cannot be the caller.
525      *
526      * Emits an {ApprovalForAll} event.
527      */
528     function setApprovalForAll(address operator, bool _approved) external;
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator) external view returns (bool);
536 
537     /**
538      * @dev Safely transfers `tokenId` token from `from` to `to`.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must exist and be owned by `from`.
545      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
546      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
547      *
548      * Emits a {Transfer} event.
549      */
550     function safeTransferFrom(
551         address from,
552         address to,
553         uint256 tokenId,
554         bytes calldata data
555     ) external;
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
568  * @dev See https://eips.ethereum.org/EIPS/eip-721
569  */
570 interface IERC721Metadata is IERC721 {
571     /**
572      * @dev Returns the token collection name.
573      */
574     function name() external view returns (string memory);
575 
576     /**
577      * @dev Returns the token collection symbol.
578      */
579     function symbol() external view returns (string memory);
580 
581     /**
582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
583      */
584     function tokenURI(uint256 tokenId) external view returns (string memory);
585 }
586 
587 // File: contracts/new.sol
588 
589 
590 
591 
592 pragma solidity ^0.8.4;
593 
594 
595 
596 
597 
598 
599 
600 
601 error ApprovalCallerNotOwnerNorApproved();
602 error ApprovalQueryForNonexistentToken();
603 error ApproveToCaller();
604 error ApprovalToCurrentOwner();
605 error BalanceQueryForZeroAddress();
606 error MintToZeroAddress();
607 error MintZeroQuantity();
608 error OwnerQueryForNonexistentToken();
609 error TransferCallerNotOwnerNorApproved();
610 error TransferFromIncorrectOwner();
611 error TransferToNonERC721ReceiverImplementer();
612 error TransferToZeroAddress();
613 error URIQueryForNonexistentToken();
614 
615 /**
616  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
617  * the Metadata extension. Built to optimize for lower gas during batch mints.
618  *
619  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
620  *
621  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
622  *
623  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
624  */
625 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
626     using Address for address;
627     using Strings for uint256;
628 
629     // Compiler will pack this into a single 256bit word.
630     struct TokenOwnership {
631         // The address of the owner.
632         address addr;
633         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
634         uint64 startTimestamp;
635         // Whether the token has been burned.
636         bool burned;
637     }
638 
639     // Compiler will pack this into a single 256bit word.
640     struct AddressData {
641         // Realistically, 2**64-1 is more than enough.
642         uint64 balance;
643         // Keeps track of mint count with minimal overhead for tokenomics.
644         uint64 numberMinted;
645         // Keeps track of burn count with minimal overhead for tokenomics.
646         uint64 numberBurned;
647         // For miscellaneous variable(s) pertaining to the address
648         // (e.g. number of whitelist mint slots used).
649         // If there are multiple variables, please pack them into a uint64.
650         uint64 aux;
651     }
652 
653     // The tokenId of the next token to be minted.
654     uint256 internal _currentIndex;
655 
656     // The number of tokens burned.
657     uint256 internal _burnCounter;
658 
659     // Token name
660     string private _name;
661 
662     // Token symbol
663     string private _symbol;
664 
665     // Mapping from token ID to ownership details
666     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
667     mapping(uint256 => TokenOwnership) internal _ownerships;
668 
669     // Mapping owner address to address data
670     mapping(address => AddressData) private _addressData;
671 
672     // Mapping from token ID to approved address
673     mapping(uint256 => address) private _tokenApprovals;
674 
675     // Mapping from owner to operator approvals
676     mapping(address => mapping(address => bool)) private _operatorApprovals;
677 
678     constructor(string memory name_, string memory symbol_) {
679         _name = name_;
680         _symbol = symbol_;
681         _currentIndex = _startTokenId();
682     }
683 
684     /**
685      * To change the starting tokenId, please override this function.
686      */
687     function _startTokenId() internal view virtual returns (uint256) {
688         return 0;
689     }
690 
691     /**
692      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
693      */
694     function totalSupply() public view returns (uint256) {
695         // Counter underflow is impossible as _burnCounter cannot be incremented
696         // more than _currentIndex - _startTokenId() times
697         unchecked {
698             return _currentIndex - _burnCounter - _startTokenId();
699         }
700     }
701 
702     /**
703      * Returns the total amount of tokens minted in the contract.
704      */
705     function _totalMinted() internal view returns (uint256) {
706         // Counter underflow is impossible as _currentIndex does not decrement,
707         // and it is initialized to _startTokenId()
708         unchecked {
709             return _currentIndex - _startTokenId();
710         }
711     }
712 
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
717         return
718             interfaceId == type(IERC721).interfaceId ||
719             interfaceId == type(IERC721Metadata).interfaceId ||
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
1215 
1216 abstract contract Ownable is Context {
1217     address private _owner;
1218 
1219     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1220 
1221     /**
1222      * @dev Initializes the contract setting the deployer as the initial owner.
1223      */
1224     constructor() {
1225         _transferOwnership(_msgSender());
1226     }
1227 
1228     /**
1229      * @dev Returns the address of the current owner.
1230      */
1231     function owner() public view virtual returns (address) {
1232         return _owner;
1233     }
1234 
1235     /**
1236      * @dev Throws if called by any account other than the owner.
1237      */
1238     modifier onlyOwner() {
1239         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1240         _;
1241     }
1242 
1243     /**
1244      * @dev Leaves the contract without owner. It will not be possible to call
1245      * `onlyOwner` functions anymore. Can only be called by the current owner.
1246      *
1247      * NOTE: Renouncing ownership will leave the contract without an owner,
1248      * thereby removing any functionality that is only available to the owner.
1249      */
1250     function renounceOwnership() public virtual onlyOwner {
1251         _transferOwnership(address(0));
1252     }
1253 
1254     /**
1255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1256      * Can only be called by the current owner.
1257      */
1258     function transferOwnership(address newOwner) public virtual onlyOwner {
1259         require(newOwner != address(0), "Ownable: new owner is the zero address");
1260         _transferOwnership(newOwner);
1261     }
1262 
1263     /**
1264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1265      * Internal function without access restriction.
1266      */
1267     function _transferOwnership(address newOwner) internal virtual {
1268         address oldOwner = _owner;
1269         _owner = newOwner;
1270         emit OwnershipTransferred(oldOwner, newOwner);
1271     }
1272 }
1273 pragma solidity ^0.8.13;
1274 
1275 interface IOperatorFilterRegistry {
1276     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1277     function register(address registrant) external;
1278     function registerAndSubscribe(address registrant, address subscription) external;
1279     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1280     function updateOperator(address registrant, address operator, bool filtered) external;
1281     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1282     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1283     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1284     function subscribe(address registrant, address registrantToSubscribe) external;
1285     function unsubscribe(address registrant, bool copyExistingEntries) external;
1286     function subscriptionOf(address addr) external returns (address registrant);
1287     function subscribers(address registrant) external returns (address[] memory);
1288     function subscriberAt(address registrant, uint256 index) external returns (address);
1289     function copyEntriesOf(address registrant, address registrantToCopy) external;
1290     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1291     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1292     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1293     function filteredOperators(address addr) external returns (address[] memory);
1294     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1295     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1296     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1297     function isRegistered(address addr) external returns (bool);
1298     function codeHashOf(address addr) external returns (bytes32);
1299 }
1300 pragma solidity ^0.8.13;
1301 
1302 
1303 
1304 abstract contract OperatorFilterer {
1305     error OperatorNotAllowed(address operator);
1306 
1307     IOperatorFilterRegistry constant operatorFilterRegistry =
1308         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1309 
1310     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1311         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1312         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1313         // order for the modifier to filter addresses.
1314         if (address(operatorFilterRegistry).code.length > 0) {
1315             if (subscribe) {
1316                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1317             } else {
1318                 if (subscriptionOrRegistrantToCopy != address(0)) {
1319                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1320                 } else {
1321                     operatorFilterRegistry.register(address(this));
1322                 }
1323             }
1324         }
1325     }
1326 
1327     modifier onlyAllowedOperator(address from) virtual {
1328         // Check registry code length to facilitate testing in environments without a deployed registry.
1329         if (address(operatorFilterRegistry).code.length > 0) {
1330             // Allow spending tokens from addresses with balance
1331             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1332             // from an EOA.
1333             if (from == msg.sender) {
1334                 _;
1335                 return;
1336             }
1337             if (
1338                 !(
1339                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1340                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1341                 )
1342             ) {
1343                 revert OperatorNotAllowed(msg.sender);
1344             }
1345         }
1346         _;
1347     }
1348 }
1349 pragma solidity ^0.8.13;
1350 
1351 
1352 
1353 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1354     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1355 
1356     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1357 }
1358     pragma solidity ^0.8.7;
1359     
1360     contract BitcoinBandits is ERC721A, DefaultOperatorFilterer , Ownable {
1361     using Strings for uint256;
1362 
1363 
1364   string private uriPrefix ;
1365   string private uriSuffix = ".json";
1366   string public hiddenURL;
1367 
1368   
1369   
1370 
1371   uint256 public cost = 0.003 ether;
1372  
1373   
1374 
1375   uint16 public maxSupply = 1200;
1376   uint8 public maxMintAmountPerTx = 10;
1377     uint8 public maxFreeMintAmountPerWallet = 1;
1378                                                              
1379  
1380   bool public paused = true;
1381   bool public reveal =false;
1382 
1383    mapping (address => uint8) public NFTPerPublicAddress;
1384 
1385  
1386   
1387   
1388  
1389   
1390 
1391   constructor() ERC721A("Bitcoin Bandits", "BTCB") {
1392   }
1393 
1394 
1395   
1396  
1397   function mint(uint8 _mintAmount) external payable  {
1398      uint16 totalSupply = uint16(totalSupply());
1399      uint8 nft = NFTPerPublicAddress[msg.sender];
1400     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1401     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
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