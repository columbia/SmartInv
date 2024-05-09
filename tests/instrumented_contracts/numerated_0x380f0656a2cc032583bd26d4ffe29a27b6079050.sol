1 // SPDX-License-Identifier: No Licence
2 
3 // ApeRiders Contract
4 // ERC721A with amendments by cryptonthat
5 // To Mint an Ape on a Ride, go to: Mint.ApeRides.io
6 // Visit ApeRides.io for more information
7 
8 // File: @openzeppelin/contracts/utils/Strings.sol
9 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
10 
11 pragma solidity  ^0.8.0;
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
692         return 1;
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
1219 pragma solidity ^0.8.0;
1220 
1221 /**
1222  * @dev These functions deal with verification of Merkle Trees proofs.
1223  *
1224  * The proofs can be generated using the JavaScript library
1225  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1226  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1227  *
1228  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1229  */
1230 library MerkleProof {
1231     /**
1232      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1233      * defined by `root`. For this, a `proof` must be provided, containing
1234      * sibling hashes on the branch from the leaf to the root of the tree. Each
1235      * pair of leaves and each pair of pre-images are assumed to be sorted.
1236      */
1237     function verify(
1238         bytes32[] memory proof,
1239         bytes32 root,
1240         bytes32 leaf
1241     ) internal pure returns (bool) {
1242         return processProof(proof, leaf) == root;
1243     }
1244 
1245     /**
1246      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1247      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1248      * hash matches the root of the tree. When processing the proof, the pairs
1249      * of leafs & pre-images are assumed to be sorted.
1250      *
1251      * _Available since v4.4._
1252      */
1253     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1254         bytes32 computedHash = leaf;
1255         for (uint256 i = 0; i < proof.length; i++) {
1256             bytes32 proofElement = proof[i];
1257             if (computedHash <= proofElement) {
1258                 // Hash(current computed hash + current element of the proof)
1259                 computedHash = _efficientHash(computedHash, proofElement);
1260             } else {
1261                 // Hash(current element of the proof + current computed hash)
1262                 computedHash = _efficientHash(proofElement, computedHash);
1263             }
1264         }
1265         return computedHash;
1266     }
1267 
1268     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1269         assembly {
1270             mstore(0x00, a)
1271             mstore(0x20, b)
1272             value := keccak256(0x00, 0x40)
1273         }
1274     }
1275 }
1276 abstract contract Ownable is Context {
1277     address private _owner;
1278 
1279     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1280 
1281     /**
1282      * @dev Initializes the contract setting the deployer as the initial owner.
1283      */
1284     constructor() {
1285         _transferOwnership(_msgSender());
1286     }
1287 
1288     /**
1289      * @dev Returns the address of the current owner.
1290      */
1291     function owner() public view virtual returns (address) {
1292         return _owner;
1293     }
1294 
1295     /**
1296      * @dev Throws if called by any account other than the owner.
1297      */
1298     modifier onlyOwner() {
1299         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1300         _;
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
1334 //APERIDES STARTS HERE
1335 
1336 pragma solidity >=0.7.0 <0.9.0;
1337 
1338 contract deployedContract {
1339     function ownerOf(uint256) public returns (address) {}
1340 }
1341 
1342 contract ApeRiders is ERC721A, Ownable {
1343   using Strings for uint256;
1344   event ExitRide(address indexed from, uint256 indexed tokenId, ApeOnRide indexed AoRInfo);
1345 
1346   struct ApeOnRide { 
1347    address apeAddress;
1348    address rideAddress;
1349    uint256 apeId;
1350    uint256 rideId;
1351    uint256 exitTime;
1352   }
1353 
1354   string public baseURI;
1355   string public baseUnoccupiedURI;
1356   uint256 public cost = 0 ether;
1357   string public maxSupply = "infinite";
1358   uint256 public maxOccupied = 5000;
1359   uint256 public totalCurrentlyOccupied = 0;
1360   bool public paused = true;
1361   bool public onlyWhitelisted = false;
1362   address[] public whitelistedAddresses;
1363   mapping(address => bool) public supportedCollectionAddresses;
1364   mapping(address => bool) public supportedRideCollectionAddresses;
1365   mapping(uint256 => bool) public isRideOccupied;
1366   mapping(uint256 => bool) public isApeOnRideOccupied;
1367   mapping(uint256 => uint256) public currentlyOccupied;
1368   mapping(uint256 => uint256) public lastOccupied;
1369   mapping(uint256 => ApeOnRide) public apeOnRideInfo;
1370   mapping(bytes32 => uint256) internal exitTime;
1371 
1372 
1373   
1374 
1375   constructor(
1376     string memory _name,
1377     string memory _symbol,
1378     string memory _initBaseURI,
1379     string memory _initBaseUnoccupiedURI
1380   ) ERC721A(_name, _symbol) {
1381     setBaseURI(_initBaseURI);
1382     setBaseUnoccupiedURI(_initBaseUnoccupiedURI);
1383     supportedCollectionAddresses[0xa08b319f0f09Ae8261DB2034D43bf40c673f0Ad0] = true;
1384     supportedCollectionAddresses[0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D] = true;
1385     supportedCollectionAddresses[0x60E4d786628Fea6478F785A6d7e704777c86a7c6] = true;
1386     supportedCollectionAddresses[0x22C08C358f62f35B742D023Bf2fAF67e30e5376E] = true;
1387     supportedCollectionAddresses[0xAE63B956F7c77fba04e2eea59F7B8B2280f55431] = true;
1388     supportedCollectionAddresses[0x4B103d07C18798365946E76845EDC6b565779402] = true;
1389     supportedCollectionAddresses[0xF1268733C6FB05EF6bE9cF23d24436Dcd6E0B35E] = true;
1390     supportedCollectionAddresses[0x984f7B398d577C0ADDE08293a53aE9D3B6b7a5c5] = true;
1391     supportedCollectionAddresses[0x1b1bFf222999BcD6fD07b64d7880e6a95d54ACaA] = true;
1392     supportedCollectionAddresses[0x2D0D57D004F82e9f4471CaA8b9f8B1965a814154] = true;
1393     supportedRideCollectionAddresses[0x1748B24faf9780B74E5A9f3Feb41553E712E94aa] = true;
1394   }
1395 
1396   //AMENDMENT
1397   //internal
1398   function checkOwned(address _senderAddress, address  _contractAddress, uint256 _tokenId) public payable returns (bool) {
1399       if (deployedContract(_contractAddress).ownerOf(_tokenId) == _senderAddress) {
1400           return true;
1401       } else {
1402         return false;
1403       }
1404   }
1405 
1406     function addSupportedCollection(address _collectionAddresses) external onlyOwner {
1407         supportedCollectionAddresses[_collectionAddresses] = true;
1408     }
1409 
1410     function removeSupportedCollection(address _collectionAddresses) external onlyOwner {
1411         supportedCollectionAddresses[_collectionAddresses] = false;
1412     }
1413 
1414     function addSupportedRide(address _collectionAddresses) external onlyOwner {
1415         supportedRideCollectionAddresses[_collectionAddresses] = true;
1416     }
1417 
1418     function removeSupportedRide(address _collectionAddresses) external onlyOwner {
1419         supportedRideCollectionAddresses[_collectionAddresses] = false;
1420     }
1421 
1422   function exitRide(uint256 _aorTokenId) public returns (string memory) {
1423     require(!paused, "The contract is paused");
1424       if (isApeOnRideOccupied[_aorTokenId]) {
1425         require((checkOwned(msg.sender, apeOnRideInfo[_aorTokenId].apeAddress, apeOnRideInfo[_aorTokenId].apeId)||checkOwned(msg.sender, apeOnRideInfo[_aorTokenId].rideAddress, apeOnRideInfo[_aorTokenId].rideId)),"You dont own this ape or ride");
1426         isApeOnRideOccupied[_aorTokenId] = false;
1427         apeOnRideInfo[_aorTokenId].exitTime = block.timestamp;
1428         totalCurrentlyOccupied--;
1429         isRideOccupied[apeOnRideInfo[_aorTokenId].rideId] = false;
1430         lastOccupied[apeOnRideInfo[_aorTokenId].rideId] = _aorTokenId;
1431         emit ExitRide(msg.sender, _aorTokenId, apeOnRideInfo[_aorTokenId]);
1432         return "Ride is now unoccupied";
1433       } else {
1434         return "This ride is already unoccupied";
1435       }
1436   }
1437 
1438   // public
1439   function mint(address _apeAddress, uint256 _apeId, address _rideAddress, uint256 _rideId, address _receivingAddress) public payable {
1440     require(!paused, "The contract is paused");
1441     require(supportedCollectionAddresses[_apeAddress] && supportedRideCollectionAddresses[_rideAddress],"This NFT contract is not supported");
1442     require(checkOwned(_receivingAddress,_apeAddress,_apeId),"you dont own this ape");
1443     require(checkOwned(msg.sender,_rideAddress,_rideId),"you dont own this ride");
1444     ApeOnRide memory lastApeOnRide = apeOnRideInfo[currentlyOccupied[_rideId]];
1445     uint256 _exitTime = lastApeOnRide.exitTime;
1446     if ((_exitTime > 0)&&(lastApeOnRide.apeAddress == _apeAddress)&&(lastApeOnRide.apeId == _apeId)) {
1447         require((block.timestamp-_exitTime>86400), "The paperwork is still going through for this Ape Rider");
1448     }
1449     if ((isApeOnRideOccupied[currentlyOccupied[_rideId]])&&(lastApeOnRide.apeAddress == _apeAddress)) {
1450           require(lastApeOnRide.apeId!=_apeId, "This ape is already on this ride.");
1451     }
1452     
1453     if (msg.sender != owner()) {
1454         //whitelist
1455         if(onlyWhitelisted == true) {
1456             require(isWhitelisted(msg.sender), "user is not whitelisted");
1457         }
1458         require(msg.value >= cost, "insufficient funds");
1459         
1460     }
1461     _safeMint(_receivingAddress, 1);
1462 
1463     if (isRideOccupied[_rideId]&&isApeOnRideOccupied[currentlyOccupied[_rideId]]) {
1464         isApeOnRideOccupied[currentlyOccupied[_rideId]] = false;
1465         lastOccupied[_rideId] = currentlyOccupied[_rideId];
1466         apeOnRideInfo[currentlyOccupied[_rideId]].exitTime = block.timestamp;
1467         totalCurrentlyOccupied--;
1468     } else {
1469         isRideOccupied[_rideId] = true;
1470     }
1471     isApeOnRideOccupied[totalSupply()] = true;
1472     apeOnRideInfo[totalSupply()] = ApeOnRide(_apeAddress,_rideAddress,_apeId,_rideId,0);
1473     currentlyOccupied[_rideId] = totalSupply();
1474     totalCurrentlyOccupied++;
1475 
1476   }
1477   
1478   function isWhitelisted(address _user) public view returns (bool) {
1479     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1480       if (whitelistedAddresses[i] == _user) {
1481           return true;
1482       }
1483     }
1484     return false;
1485   }
1486 
1487   function tokenURI(uint256 tokenId)
1488     public
1489     view
1490     virtual
1491     override
1492     returns (string memory)
1493   {
1494     require(
1495       _exists(tokenId),
1496       "ERC721Metadata: URI query for nonexistent token"
1497     );
1498 
1499     if (isApeOnRideOccupied[tokenId]){
1500         return bytes(baseURI).length > 0
1501         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1502         : "";
1503     } else {
1504         return bytes(baseUnoccupiedURI).length > 0
1505         ? string(abi.encodePacked(baseUnoccupiedURI, tokenId.toString(), ".json"))
1506         : "";
1507     }
1508   }
1509 
1510   //only owner
1511   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1512     baseURI = _newBaseURI;
1513   }
1514 
1515   function setBaseUnoccupiedURI(string memory _newBaseUnoccupiedURI) public onlyOwner {
1516     baseUnoccupiedURI = _newBaseUnoccupiedURI;
1517   }
1518 
1519   function pause(bool _state) public onlyOwner {
1520     paused = _state;
1521   }
1522 
1523   function setCost(uint256 _cost) public onlyOwner {
1524     cost = _cost;
1525   }
1526   
1527   function setOnlyWhitelisted(bool _state) public onlyOwner {
1528     onlyWhitelisted = _state;
1529   }
1530   
1531   function whitelistUsers(address[] calldata _users) public onlyOwner {
1532     delete whitelistedAddresses;
1533     whitelistedAddresses = _users;
1534   }
1535 
1536   function withdraw() public payable onlyOwner {
1537     uint256 baseFee = address(this).balance;
1538     require(payable(0x6819eA7792CC89394fEEE84FC70d54a67cD0B765).send(baseFee));
1539   }
1540 }