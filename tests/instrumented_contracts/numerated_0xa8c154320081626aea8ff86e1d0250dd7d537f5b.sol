1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-23
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
10                               
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/utils/Address.sol
104 
105 
106 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
107 
108 pragma solidity ^0.8.1;
109 
110 /**
111  * @dev Collection of functions related to the address type
112  */
113 library Address {
114     /**
115      * @dev Returns true if `account` is a contract.
116      *
117      * [IMPORTANT]
118      * ====
119      * It is unsafe to assume that an address for which this function returns
120      * false is an externally-owned account (EOA) and not a contract.
121      *
122      * Among others, `isContract` will return false for the following
123      * types of addresses:
124      *
125      *  - an externally-owned account
126      *  - a contract in construction
127      *  - an address where a contract will be created
128      *  - an address where a contract lived, but was destroyed
129      * ====
130      *
131      * [IMPORTANT]
132      * ====
133      * You shouldn't rely on `isContract` to protect against flash loan attacks!
134      *
135      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
136      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
137      * constructor.
138      * ====
139      */
140     function isContract(address account) internal view returns (bool) {
141         // This method relies on extcodesize/address.code.length, which returns 0
142         // for contracts in construction, since the code is only stored at the end
143         // of the constructor execution.
144 
145         return account.code.length > 0;
146     }
147 
148     /**
149      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
150      * `recipient`, forwarding all available gas and reverting on errors.
151      *
152      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
153      * of certain opcodes, possibly making contracts go over the 2300 gas limit
154      * imposed by `transfer`, making them unable to receive funds via
155      * `transfer`. {sendValue} removes this limitation.
156      *
157      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
158      *
159      * IMPORTANT: because control is transferred to `recipient`, care must be
160      * taken to not create reentrancy vulnerabilities. Consider using
161      * {ReentrancyGuard} or the
162      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
163      */
164     function sendValue(address payable recipient, uint256 amount) internal {
165         require(address(this).balance >= amount, "Address: insufficient balance");
166 
167         (bool success, ) = recipient.call{value: amount}("");
168         require(success, "Address: unable to send value, recipient may have reverted");
169     }
170 
171     /**
172      * @dev Performs a Solidity function call using a low level `call`. A
173      * plain `call` is an unsafe replacement for a function call: use this
174      * function instead.
175      *
176      * If `target` reverts with a revert reason, it is bubbled up by this
177      * function (like regular Solidity function calls).
178      *
179      * Returns the raw returned data. To convert to the expected return value,
180      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
181      *
182      * Requirements:
183      *
184      * - `target` must be a contract.
185      * - calling `target` with `data` must not revert.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionCall(target, data, "Address: low-level call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
195      * `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, 0, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but also transferring `value` wei to `target`.
210      *
211      * Requirements:
212      *
213      * - the calling contract must have an ETH balance of at least `value`.
214      * - the called Solidity function must be `payable`.
215      *
216      * _Available since v3.1._
217      */
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value
222     ) internal returns (bytes memory) {
223         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
228      * with `errorMessage` as a fallback revert reason when `target` reverts.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         require(address(this).balance >= value, "Address: insufficient balance for call");
239         require(isContract(target), "Address: call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.call{value: value}(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
252         return functionStaticCall(target, data, "Address: low-level static call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal view returns (bytes memory) {
266         require(isContract(target), "Address: static call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.staticcall(data);
269         return verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         require(isContract(target), "Address: delegate call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.delegatecall(data);
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     /**
300      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
301      * revert reason using the provided one.
302      *
303      * _Available since v4.3._
304      */
305     function verifyCallResult(
306         bool success,
307         bytes memory returndata,
308         string memory errorMessage
309     ) internal pure returns (bytes memory) {
310         if (success) {
311             return returndata;
312         } else {
313             // Look for revert reason and bubble it up if present
314             if (returndata.length > 0) {
315                 // The easiest way to bubble the revert reason is using memory via assembly
316 
317                 assembly {
318                     let returndata_size := mload(returndata)
319                     revert(add(32, returndata), returndata_size)
320                 }
321             } else {
322                 revert(errorMessage);
323             }
324         }
325     }
326 }
327 
328 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @title ERC721 token receiver interface
337  * @dev Interface for any contract that wants to support safeTransfers
338  * from ERC721 asset contracts.
339  */
340 interface IERC721Receiver {
341     /**
342      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
343      * by `operator` from `from`, this function is called.
344      *
345      * It must return its Solidity selector to confirm the token transfer.
346      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
347      *
348      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
349      */
350     function onERC721Received(
351         address operator,
352         address from,
353         uint256 tokenId,
354         bytes calldata data
355     ) external returns (bytes4);
356 }
357 
358 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
359 
360 
361 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 /**
366  * @dev Interface of the ERC165 standard, as defined in the
367  * https://eips.ethereum.org/EIPS/eip-165[EIP].
368  *
369  * Implementers can declare support of contract interfaces, which can then be
370  * queried by others ({ERC165Checker}).
371  *
372  * For an implementation, see {ERC165}.
373  */
374 interface IERC165 {
375     /**
376      * @dev Returns true if this contract implements the interface defined by
377      * `interfaceId`. See the corresponding
378      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
379      * to learn more about how these ids are created.
380      *
381      * This function call must use less than 30 000 gas.
382      */
383     function supportsInterface(bytes4 interfaceId) external view returns (bool);
384 }
385 
386 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev Implementation of the {IERC165} interface.
396  *
397  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
398  * for the additional interface id that will be supported. For example:
399  *
400  * ```solidity
401  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
402  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
403  * }
404  * ```
405  *
406  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
407  */
408 abstract contract ERC165 is IERC165 {
409     /**
410      * @dev See {IERC165-supportsInterface}.
411      */
412     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
413         return interfaceId == type(IERC165).interfaceId;
414     }
415 }
416 
417 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
418 
419 
420 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 
425 /**
426  * @dev Required interface of an ERC721 compliant contract.
427  */
428 interface IERC721 is IERC165 {
429     /**
430      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
431      */
432     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
436      */
437     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
438 
439     /**
440      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
441      */
442     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
443 
444     /**
445      * @dev Returns the number of tokens in ``owner``'s account.
446      */
447     function balanceOf(address owner) external view returns (uint256 balance);
448 
449     /**
450      * @dev Returns the owner of the `tokenId` token.
451      *
452      * Requirements:
453      *
454      * - `tokenId` must exist.
455      */
456     function ownerOf(uint256 tokenId) external view returns (address owner);
457 
458     /**
459      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
460      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
461      *
462      * Requirements:
463      *
464      * - `from` cannot be the zero address.
465      * - `to` cannot be the zero address.
466      * - `tokenId` token must exist and be owned by `from`.
467      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
468      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
469      *
470      * Emits a {Transfer} event.
471      */
472     function safeTransferFrom(
473         address from,
474         address to,
475         uint256 tokenId
476     ) external;
477 
478     /**
479      * @dev Transfers `tokenId` token from `from` to `to`.
480      *
481      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
482      *
483      * Requirements:
484      *
485      * - `from` cannot be the zero address.
486      * - `to` cannot be the zero address.
487      * - `tokenId` token must be owned by `from`.
488      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
489      *
490      * Emits a {Transfer} event.
491      */
492     function transferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) external;
497 
498     /**
499      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
500      * The approval is cleared when the token is transferred.
501      *
502      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
503      *
504      * Requirements:
505      *
506      * - The caller must own the token or be an approved operator.
507      * - `tokenId` must exist.
508      *
509      * Emits an {Approval} event.
510      */
511     function approve(address to, uint256 tokenId) external;
512 
513     /**
514      * @dev Returns the account approved for `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function getApproved(uint256 tokenId) external view returns (address operator);
521 
522     /**
523      * @dev Approve or remove `operator` as an operator for the caller.
524      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
525      *
526      * Requirements:
527      *
528      * - The `operator` cannot be the caller.
529      *
530      * Emits an {ApprovalForAll} event.
531      */
532     function setApprovalForAll(address operator, bool _approved) external;
533 
534     /**
535      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
536      *
537      * See {setApprovalForAll}
538      */
539     function isApprovedForAll(address owner, address operator) external view returns (bool);
540 
541     /**
542      * @dev Safely transfers `tokenId` token from `from` to `to`.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must exist and be owned by `from`.
549      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId,
558         bytes calldata data
559     ) external;
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
572  * @dev See https://eips.ethereum.org/EIPS/eip-721
573  */
574 interface IERC721Metadata is IERC721 {
575     /**
576      * @dev Returns the token collection name.
577      */
578     function name() external view returns (string memory);
579 
580     /**
581      * @dev Returns the token collection symbol.
582      */
583     function symbol() external view returns (string memory);
584 
585     /**
586      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
587      */
588     function tokenURI(uint256 tokenId) external view returns (string memory);
589 }
590 
591 // File: contracts/new.sol
592 
593 
594 
595 
596 pragma solidity ^0.8.4;
597 
598 
599 
600 
601 
602 
603 
604 
605 error ApprovalCallerNotOwnerNorApproved();
606 error ApprovalQueryForNonexistentToken();
607 error ApproveToCaller();
608 error ApprovalToCurrentOwner();
609 error BalanceQueryForZeroAddress();
610 error MintToZeroAddress();
611 error MintZeroQuantity();
612 error OwnerQueryForNonexistentToken();
613 error TransferCallerNotOwnerNorApproved();
614 error TransferFromIncorrectOwner();
615 error TransferToNonERC721ReceiverImplementer();
616 error TransferToZeroAddress();
617 error URIQueryForNonexistentToken();
618 
619 /**
620  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
621  * the Metadata extension. Built to optimize for lower gas during batch mints.
622  *
623  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
624  *
625  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
626  *
627  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
628  */
629 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
630     using Address for address;
631     using Strings for uint256;
632 
633     // Compiler will pack this into a single 256bit word.
634     struct TokenOwnership {
635         // The address of the owner.
636         address addr;
637         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
638         uint64 startTimestamp;
639         // Whether the token has been burned.
640         bool burned;
641     }
642 
643     // Compiler will pack this into a single 256bit word.
644     struct AddressData {
645         // Realistically, 2**64-1 is more than enough.
646         uint64 balance;
647         // Keeps track of mint count with minimal overhead for tokenomics.
648         uint64 numberMinted;
649         // Keeps track of burn count with minimal overhead for tokenomics.
650         uint64 numberBurned;
651         // For miscellaneous variable(s) pertaining to the address
652         // (e.g. number of whitelist mint slots used).
653         // If there are multiple variables, please pack them into a uint64.
654         uint64 aux;
655     }
656 
657     // The tokenId of the next token to be minted.
658     uint256 internal _currentIndex;
659 
660     // The number of tokens burned.
661     uint256 internal _burnCounter;
662 
663     // Token name
664     string private _name;
665 
666     // Token symbol
667     string private _symbol;
668 
669     // Mapping from token ID to ownership details
670     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
671     mapping(uint256 => TokenOwnership) internal _ownerships;
672 
673     // Mapping owner address to address data
674     mapping(address => AddressData) private _addressData;
675 
676     // Mapping from token ID to approved address
677     mapping(uint256 => address) private _tokenApprovals;
678 
679     // Mapping from owner to operator approvals
680     mapping(address => mapping(address => bool)) private _operatorApprovals;
681 
682     constructor(string memory name_, string memory symbol_) {
683         _name = name_;
684         _symbol = symbol_;
685         _currentIndex = _startTokenId();
686     }
687 
688     /**
689      * To change the starting tokenId, please override this function.
690      */
691     function _startTokenId() internal view virtual returns (uint256) {
692         return 0;
693     }
694 
695     /**
696      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
697      */
698     function totalSupply() public view returns (uint256) {
699         // Counter underflow is impossible as _burnCounter cannot be incremented
700         // more than _currentIndex - _startTokenId() times
701         unchecked {
702             return _currentIndex - _burnCounter - _startTokenId();
703         }
704     }
705 
706     /**
707      * Returns the total amount of tokens minted in the contract.
708      */
709     function _totalMinted() internal view returns (uint256) {
710         // Counter underflow is impossible as _currentIndex does not decrement,
711         // and it is initialized to _startTokenId()
712         unchecked {
713             return _currentIndex - _startTokenId();
714         }
715     }
716 
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
721         return
722             interfaceId == type(IERC721).interfaceId ||
723             interfaceId == type(IERC721Metadata).interfaceId ||
724             super.supportsInterface(interfaceId);
725     }
726 
727     /**
728      * @dev See {IERC721-balanceOf}.
729      */
730     function balanceOf(address owner) public view override returns (uint256) {
731         if (owner == address(0)) revert BalanceQueryForZeroAddress();
732         return uint256(_addressData[owner].balance);
733     }
734 
735     /**
736      * Returns the number of tokens minted by `owner`.
737      */
738     function _numberMinted(address owner) internal view returns (uint256) {
739         return uint256(_addressData[owner].numberMinted);
740     }
741 
742     /**
743      * Returns the number of tokens burned by or on behalf of `owner`.
744      */
745     function _numberBurned(address owner) internal view returns (uint256) {
746         return uint256(_addressData[owner].numberBurned);
747     }
748 
749     /**
750      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
751      */
752     function _getAux(address owner) internal view returns (uint64) {
753         return _addressData[owner].aux;
754     }
755 
756     /**
757      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
758      * If there are multiple variables, please pack them into a uint64.
759      */
760     function _setAux(address owner, uint64 aux) internal {
761         _addressData[owner].aux = aux;
762     }
763 
764     /**
765      * Gas spent here starts off proportional to the maximum mint batch size.
766      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
767      */
768     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
769         uint256 curr = tokenId;
770 
771         unchecked {
772             if (_startTokenId() <= curr && curr < _currentIndex) {
773                 TokenOwnership memory ownership = _ownerships[curr];
774                 if (!ownership.burned) {
775                     if (ownership.addr != address(0)) {
776                         return ownership;
777                     }
778                     // Invariant:
779                     // There will always be an ownership that has an address and is not burned
780                     // before an ownership that does not have an address and is not burned.
781                     // Hence, curr will not underflow.
782                     while (true) {
783                         curr--;
784                         ownership = _ownerships[curr];
785                         if (ownership.addr != address(0)) {
786                             return ownership;
787                         }
788                     }
789                 }
790             }
791         }
792         revert OwnerQueryForNonexistentToken();
793     }
794 
795     /**
796      * @dev See {IERC721-ownerOf}.
797      */
798     function ownerOf(uint256 tokenId) public view override returns (address) {
799         return _ownershipOf(tokenId).addr;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-name}.
804      */
805     function name() public view virtual override returns (string memory) {
806         return _name;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-symbol}.
811      */
812     function symbol() public view virtual override returns (string memory) {
813         return _symbol;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-tokenURI}.
818      */
819     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
820         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
821 
822         string memory baseURI = _baseURI();
823         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
824     }
825 
826     /**
827      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
828      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
829      * by default, can be overriden in child contracts.
830      */
831     function _baseURI() internal view virtual returns (string memory) {
832         return '';
833     }
834 
835     /**
836      * @dev See {IERC721-approve}.
837      */
838     function approve(address to, uint256 tokenId) public override {
839         address owner = ERC721A.ownerOf(tokenId);
840         if (to == owner) revert ApprovalToCurrentOwner();
841 
842         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
843             revert ApprovalCallerNotOwnerNorApproved();
844         }
845 
846         _approve(to, tokenId, owner);
847     }
848 
849     /**
850      * @dev See {IERC721-getApproved}.
851      */
852     function getApproved(uint256 tokenId) public view override returns (address) {
853         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
854 
855         return _tokenApprovals[tokenId];
856     }
857 
858     /**
859      * @dev See {IERC721-setApprovalForAll}.
860      */
861     function setApprovalForAll(address operator, bool approved) public virtual override {
862         if (operator == _msgSender()) revert ApproveToCaller();
863 
864         _operatorApprovals[_msgSender()][operator] = approved;
865         emit ApprovalForAll(_msgSender(), operator, approved);
866     }
867 
868     /**
869      * @dev See {IERC721-isApprovedForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
872         return _operatorApprovals[owner][operator];
873     }
874 
875     /**
876      * @dev See {IERC721-transferFrom}.
877      */
878     function transferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         _transfer(from, to, tokenId);
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public virtual override {
894         safeTransferFrom(from, to, tokenId, '');
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) public virtual override {
906         _transfer(from, to, tokenId);
907         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
908             revert TransferToNonERC721ReceiverImplementer();
909         }
910     }
911 
912     /**
913      * @dev Returns whether `tokenId` exists.
914      *
915      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
916      *
917      * Tokens start existing when they are minted (`_mint`),
918      */
919     function _exists(uint256 tokenId) internal view returns (bool) {
920         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
921             !_ownerships[tokenId].burned;
922     }
923 
924     function _safeMint(address to, uint256 quantity) internal {
925         _safeMint(to, quantity, '');
926     }
927 
928     /**
929      * @dev Safely mints `quantity` tokens and transfers them to `to`.
930      *
931      * Requirements:
932      *
933      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
934      * - `quantity` must be greater than 0.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _safeMint(
939         address to,
940         uint256 quantity,
941         bytes memory _data
942     ) internal {
943         _mint(to, quantity, _data, true);
944     }
945 
946     /**
947      * @dev Mints `quantity` tokens and transfers them to `to`.
948      *
949      * Requirements:
950      *
951      * - `to` cannot be the zero address.
952      * - `quantity` must be greater than 0.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _mint(
957         address to,
958         uint256 quantity,
959         bytes memory _data,
960         bool safe
961     ) internal {
962         uint256 startTokenId = _currentIndex;
963         if (to == address(0)) revert MintToZeroAddress();
964         if (quantity == 0) revert MintZeroQuantity();
965 
966         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
967 
968         // Overflows are incredibly unrealistic.
969         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
970         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
971         unchecked {
972             _addressData[to].balance += uint64(quantity);
973             _addressData[to].numberMinted += uint64(quantity);
974 
975             _ownerships[startTokenId].addr = to;
976             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
977 
978             uint256 updatedIndex = startTokenId;
979             uint256 end = updatedIndex + quantity;
980 
981             if (safe && to.isContract()) {
982                 do {
983                     emit Transfer(address(0), to, updatedIndex);
984                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
985                         revert TransferToNonERC721ReceiverImplementer();
986                     }
987                 } while (updatedIndex != end);
988                 // Reentrancy protection
989                 if (_currentIndex != startTokenId) revert();
990             } else {
991                 do {
992                     emit Transfer(address(0), to, updatedIndex++);
993                 } while (updatedIndex != end);
994             }
995             _currentIndex = updatedIndex;
996         }
997         _afterTokenTransfers(address(0), to, startTokenId, quantity);
998     }
999 
1000     /**
1001      * @dev Transfers `tokenId` from `from` to `to`.
1002      *
1003      * Requirements:
1004      *
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must be owned by `from`.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _transfer(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) private {
1015         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1016 
1017         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1018 
1019         bool isApprovedOrOwner = (_msgSender() == from ||
1020             isApprovedForAll(from, _msgSender()) ||
1021             getApproved(tokenId) == _msgSender());
1022 
1023         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1024         if (to == address(0)) revert TransferToZeroAddress();
1025 
1026         _beforeTokenTransfers(from, to, tokenId, 1);
1027 
1028         // Clear approvals from the previous owner
1029         _approve(address(0), tokenId, from);
1030 
1031         // Underflow of the sender's balance is impossible because we check for
1032         // ownership above and the recipient's balance can't realistically overflow.
1033         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1034         unchecked {
1035             _addressData[from].balance -= 1;
1036             _addressData[to].balance += 1;
1037 
1038             TokenOwnership storage currSlot = _ownerships[tokenId];
1039             currSlot.addr = to;
1040             currSlot.startTimestamp = uint64(block.timestamp);
1041 
1042             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1043             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1044             uint256 nextTokenId = tokenId + 1;
1045             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1046             if (nextSlot.addr == address(0)) {
1047                 // This will suffice for checking _exists(nextTokenId),
1048                 // as a burned slot cannot contain the zero address.
1049                 if (nextTokenId != _currentIndex) {
1050                     nextSlot.addr = from;
1051                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1052                 }
1053             }
1054         }
1055 
1056         emit Transfer(from, to, tokenId);
1057         _afterTokenTransfers(from, to, tokenId, 1);
1058     }
1059 
1060     /**
1061      * @dev This is equivalent to _burn(tokenId, false)
1062      */
1063     function _burn(uint256 tokenId) internal virtual {
1064         _burn(tokenId, false);
1065     }
1066 
1067     /**
1068      * @dev Destroys `tokenId`.
1069      * The approval is cleared when the token is burned.
1070      *
1071      * Requirements:
1072      *
1073      * - `tokenId` must exist.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1078         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1079 
1080         address from = prevOwnership.addr;
1081 
1082         if (approvalCheck) {
1083             bool isApprovedOrOwner = (_msgSender() == from ||
1084                 isApprovedForAll(from, _msgSender()) ||
1085                 getApproved(tokenId) == _msgSender());
1086 
1087             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1088         }
1089 
1090         _beforeTokenTransfers(from, address(0), tokenId, 1);
1091 
1092         // Clear approvals from the previous owner
1093         _approve(address(0), tokenId, from);
1094 
1095         // Underflow of the sender's balance is impossible because we check for
1096         // ownership above and the recipient's balance can't realistically overflow.
1097         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1098         unchecked {
1099             AddressData storage addressData = _addressData[from];
1100             addressData.balance -= 1;
1101             addressData.numberBurned += 1;
1102 
1103             // Keep track of who burned the token, and the timestamp of burning.
1104             TokenOwnership storage currSlot = _ownerships[tokenId];
1105             currSlot.addr = from;
1106             currSlot.startTimestamp = uint64(block.timestamp);
1107             currSlot.burned = true;
1108 
1109             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1110             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1111             uint256 nextTokenId = tokenId + 1;
1112             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1113             if (nextSlot.addr == address(0)) {
1114                 // This will suffice for checking _exists(nextTokenId),
1115                 // as a burned slot cannot contain the zero address.
1116                 if (nextTokenId != _currentIndex) {
1117                     nextSlot.addr = from;
1118                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1119                 }
1120             }
1121         }
1122 
1123         emit Transfer(from, address(0), tokenId);
1124         _afterTokenTransfers(from, address(0), tokenId, 1);
1125 
1126         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1127         unchecked {
1128             _burnCounter++;
1129         }
1130     }
1131 
1132     /**
1133      * @dev Approve `to` to operate on `tokenId`
1134      *
1135      * Emits a {Approval} event.
1136      */
1137     function _approve(
1138         address to,
1139         uint256 tokenId,
1140         address owner
1141     ) private {
1142         _tokenApprovals[tokenId] = to;
1143         emit Approval(owner, to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1148      *
1149      * @param from address representing the previous owner of the given token ID
1150      * @param to target address that will receive the tokens
1151      * @param tokenId uint256 ID of the token to be transferred
1152      * @param _data bytes optional data to send along with the call
1153      * @return bool whether the call correctly returned the expected magic value
1154      */
1155     function _checkContractOnERC721Received(
1156         address from,
1157         address to,
1158         uint256 tokenId,
1159         bytes memory _data
1160     ) private returns (bool) {
1161         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1162             return retval == IERC721Receiver(to).onERC721Received.selector;
1163         } catch (bytes memory reason) {
1164             if (reason.length == 0) {
1165                 revert TransferToNonERC721ReceiverImplementer();
1166             } else {
1167                 assembly {
1168                     revert(add(32, reason), mload(reason))
1169                 }
1170             }
1171         }
1172     }
1173 
1174     /**
1175      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1176      * And also called before burning one token.
1177      *
1178      * startTokenId - the first token id to be transferred
1179      * quantity - the amount to be transferred
1180      *
1181      * Calling conditions:
1182      *
1183      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1184      * transferred to `to`.
1185      * - When `from` is zero, `tokenId` will be minted for `to`.
1186      * - When `to` is zero, `tokenId` will be burned by `from`.
1187      * - `from` and `to` are never both zero.
1188      */
1189     function _beforeTokenTransfers(
1190         address from,
1191         address to,
1192         uint256 startTokenId,
1193         uint256 quantity
1194     ) internal virtual {}
1195 
1196     /**
1197      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1198      * minting.
1199      * And also called after one token has been burned.
1200      *
1201      * startTokenId - the first token id to be transferred
1202      * quantity - the amount to be transferred
1203      *
1204      * Calling conditions:
1205      *
1206      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1207      * transferred to `to`.
1208      * - When `from` is zero, `tokenId` has been minted for `to`.
1209      * - When `to` is zero, `tokenId` has been burned by `from`.
1210      * - `from` and `to` are never both zero.
1211      */
1212     function _afterTokenTransfers(
1213         address from,
1214         address to,
1215         uint256 startTokenId,
1216         uint256 quantity
1217     ) internal virtual {}
1218 }
1219 
1220 abstract contract Ownable is Context {
1221     address private _owner;
1222 
1223     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1224 
1225     /**
1226      * @dev Initializes the contract setting the deployer as the initial owner.
1227      */
1228     constructor() {
1229         _transferOwnership(_msgSender());
1230     }
1231 
1232     /**
1233      * @dev Returns the address of the current owner.
1234      */
1235     function owner() public view virtual returns (address) {
1236         return _owner;
1237     }
1238 
1239     /**
1240      * @dev Throws if called by any account other than the owner.
1241      */
1242     modifier onlyOwner() {
1243         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1244         _;
1245     }
1246 
1247     /**
1248      * @dev Leaves the contract without owner. It will not be possible to call
1249      * `onlyOwner` functions anymore. Can only be called by the current owner.
1250      *
1251      * NOTE: Renouncing ownership will leave the contract without an owner,
1252      * thereby removing any functionality that is only available to the owner.
1253      */
1254     function renounceOwnership() public virtual onlyOwner {
1255         _transferOwnership(address(0));
1256     }
1257 
1258     /**
1259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1260      * Can only be called by the current owner.
1261      */
1262     function transferOwnership(address newOwner) public virtual onlyOwner {
1263         require(newOwner != address(0), "Ownable: new owner is the zero address");
1264         _transferOwnership(newOwner);
1265     }
1266 
1267     /**
1268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1269      * Internal function without access restriction.
1270      */
1271     function _transferOwnership(address newOwner) internal virtual {
1272         address oldOwner = _owner;
1273         _owner = newOwner;
1274         emit OwnershipTransferred(oldOwner, newOwner);
1275     }
1276 }
1277     pragma solidity ^0.8.7;
1278     
1279     contract AnotherPepeTheFrogCollection is ERC721A, Ownable {
1280     using Strings for uint256;
1281 
1282 
1283   string private uriPrefix ;
1284   string private uriSuffix = ".json";
1285   string public hiddenURL;
1286 
1287   
1288   
1289 
1290   uint256 public cost = 0.001 ether;
1291   uint256 public whiteListCost = 0 ;
1292   
1293 
1294   uint16 public maxSupply = 4444;
1295   uint8 public maxMintAmountPerTx = 20;
1296     uint8 public maxFreeMintAmountPerWallet = 1;
1297                                                              
1298   bool public WLpaused = true;
1299   bool public paused = true;
1300   bool public reveal =false;
1301   mapping (address => uint8) public NFTPerWLAddress;
1302    mapping (address => uint8) public NFTPerPublicAddress;
1303   mapping (address => bool) public isWhitelisted;
1304  
1305   
1306   
1307  
1308   
1309 
1310   constructor() ERC721A("Another Pepe the Frog Collection", "APFC") {
1311   }
1312 
1313   
1314  
1315   function mint(uint8 _mintAmount) external payable  {
1316      uint16 totalSupply = uint16(totalSupply());
1317      uint8 nft = NFTPerPublicAddress[msg.sender];
1318     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1319     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1320 
1321     require(!paused, "The contract is paused!");
1322     
1323       if(nft >= maxFreeMintAmountPerWallet)
1324     {
1325     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1326     }
1327     else {
1328          uint8 costAmount = _mintAmount + nft;
1329         if(costAmount > maxFreeMintAmountPerWallet)
1330        {
1331         costAmount = costAmount - maxFreeMintAmountPerWallet;
1332         require(msg.value >= cost * costAmount, "Insufficient funds!");
1333        }
1334        
1335          
1336     }
1337     
1338 
1339 
1340     _safeMint(msg.sender , _mintAmount);
1341 
1342     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1343      
1344      delete totalSupply;
1345      delete _mintAmount;
1346   }
1347   
1348   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1349      uint16 totalSupply = uint16(totalSupply());
1350     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1351      _safeMint(_receiver , _mintAmount);
1352      delete _mintAmount;
1353      delete _receiver;
1354      delete totalSupply;
1355   }
1356 
1357   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1358      uint16 totalSupply = uint16(totalSupply());
1359      uint totalAmount =   _amountPerAddress * addresses.length;
1360     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1361      for (uint256 i = 0; i < addresses.length; i++) {
1362             _safeMint(addresses[i], _amountPerAddress);
1363         }
1364 
1365      delete _amountPerAddress;
1366      delete totalSupply;
1367   }
1368 
1369  
1370 
1371   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1372       maxSupply = _maxSupply;
1373   }
1374 
1375 
1376 
1377    
1378   function tokenURI(uint256 _tokenId)
1379     public
1380     view
1381     virtual
1382     override
1383     returns (string memory)
1384   {
1385     require(
1386       _exists(_tokenId),
1387       "ERC721Metadata: URI query for nonexistent token"
1388     );
1389     
1390   
1391 if ( reveal == false)
1392 {
1393     return hiddenURL;
1394 }
1395     
1396 
1397     string memory currentBaseURI = _baseURI();
1398     return bytes(currentBaseURI).length > 0
1399         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1400         : "";
1401   }
1402  
1403    function setWLPaused() external onlyOwner {
1404     WLpaused = !WLpaused;
1405   }
1406   function setWLCost(uint256 _cost) external onlyOwner {
1407     whiteListCost = _cost;
1408     delete _cost;
1409   }
1410 
1411 
1412 
1413  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1414     maxFreeMintAmountPerWallet = _limit;
1415    delete _limit;
1416 
1417 }
1418 
1419     
1420   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1421         for(uint8 i = 0; i < entries.length; i++) {
1422             isWhitelisted[entries[i]] = true;
1423         }   
1424     }
1425 
1426     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1427         for(uint8 i = 0; i < entries.length; i++) {
1428              isWhitelisted[entries[i]] = false;
1429         }
1430     }
1431 
1432 function whitelistMint(uint8 _mintAmount) external payable {
1433         
1434     
1435         uint8 nft = NFTPerWLAddress[msg.sender];
1436        require(isWhitelisted[msg.sender],  "You are not whitelisted");
1437 
1438        require (nft + _mintAmount <= maxMintAmountPerTx, "Exceeds max  limit  per address");
1439       
1440 
1441 
1442     require(!WLpaused, "Whitelist minting is over!");
1443          if(nft >= maxFreeMintAmountPerWallet)
1444     {
1445     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1446     }
1447     else {
1448          uint8 costAmount = _mintAmount + nft;
1449         if(costAmount > maxFreeMintAmountPerWallet)
1450        {
1451         costAmount = costAmount - maxFreeMintAmountPerWallet;
1452         require(msg.value >= whiteListCost * costAmount, "Insufficient funds!");
1453        }
1454        
1455          
1456     }
1457     
1458     
1459 
1460      _safeMint(msg.sender , _mintAmount);
1461       NFTPerWLAddress[msg.sender] =nft + _mintAmount;
1462      
1463       delete _mintAmount;
1464        delete nft;
1465     
1466     }
1467 
1468   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1469     uriPrefix = _uriPrefix;
1470   }
1471    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1472     hiddenURL = _uriPrefix;
1473   }
1474 
1475 
1476   function setPaused() external onlyOwner {
1477     paused = !paused;
1478     WLpaused = true;
1479   }
1480 
1481   function setCost(uint _cost) external onlyOwner{
1482       cost = _cost;
1483 
1484   }
1485 
1486  function setRevealed() external onlyOwner{
1487      reveal = !reveal;
1488  }
1489 
1490   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1491       maxMintAmountPerTx = _maxtx;
1492 
1493   }
1494 
1495  
1496 
1497   function withdraw() external onlyOwner {
1498   uint _balance = address(this).balance;
1499      payable(msg.sender).transfer(_balance ); 
1500        
1501   }
1502 
1503 
1504   function _baseURI() internal view  override returns (string memory) {
1505     return uriPrefix;
1506   }
1507 }