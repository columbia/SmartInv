1 // SPDX-License-Identifier: MIT
2 //Developer Info:
3 
4 
5 
6 // File: @openzeppelin/contracts/utils/Strings.sol
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Context.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Address.sol
103 
104 
105 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
106 
107 pragma solidity ^0.8.1;
108 
109 /**
110  * @dev Collection of functions related to the address type
111  */
112 library Address {
113     /**
114      * @dev Returns true if `account` is a contract.
115      *
116      * [IMPORTANT]
117      * ====
118      * It is unsafe to assume that an address for which this function returns
119      * false is an externally-owned account (EOA) and not a contract.
120      *
121      * Among others, `isContract` will return false for the following
122      * types of addresses:
123      *
124      *  - an externally-owned account
125      *  - a contract in construction
126      *  - an address where a contract will be created
127      *  - an address where a contract lived, but was destroyed
128      * ====
129      *
130      * [IMPORTANT]
131      * ====
132      * You shouldn't rely on `isContract` to protect against flash loan attacks!
133      *
134      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
135      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
136      * constructor.
137      * ====
138      */
139     function isContract(address account) internal view returns (bool) {
140         // This method relies on extcodesize/address.code.length, which returns 0
141         // for contracts in construction, since the code is only stored at the end
142         // of the constructor execution.
143 
144         return account.code.length > 0;
145     }
146 
147     /**
148      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
149      * `recipient`, forwarding all available gas and reverting on errors.
150      *
151      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
152      * of certain opcodes, possibly making contracts go over the 2300 gas limit
153      * imposed by `transfer`, making them unable to receive funds via
154      * `transfer`. {sendValue} removes this limitation.
155      *
156      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
157      *
158      * IMPORTANT: because control is transferred to `recipient`, care must be
159      * taken to not create reentrancy vulnerabilities. Consider using
160      * {ReentrancyGuard} or the
161      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
162      */
163     function sendValue(address payable recipient, uint256 amount) internal {
164         require(address(this).balance >= amount, "Address: insufficient balance");
165 
166         (bool success, ) = recipient.call{value: amount}("");
167         require(success, "Address: unable to send value, recipient may have reverted");
168     }
169 
170     /**
171      * @dev Performs a Solidity function call using a low level `call`. A
172      * plain `call` is an unsafe replacement for a function call: use this
173      * function instead.
174      *
175      * If `target` reverts with a revert reason, it is bubbled up by this
176      * function (like regular Solidity function calls).
177      *
178      * Returns the raw returned data. To convert to the expected return value,
179      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
180      *
181      * Requirements:
182      *
183      * - `target` must be a contract.
184      * - calling `target` with `data` must not revert.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
189         return functionCall(target, data, "Address: low-level call failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
194      * `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCall(
199         address target,
200         bytes memory data,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, 0, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but also transferring `value` wei to `target`.
209      *
210      * Requirements:
211      *
212      * - the calling contract must have an ETH balance of at least `value`.
213      * - the called Solidity function must be `payable`.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value
221     ) internal returns (bytes memory) {
222         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
227      * with `errorMessage` as a fallback revert reason when `target` reverts.
228      *
229      * _Available since v3.1._
230      */
231     function functionCallWithValue(
232         address target,
233         bytes memory data,
234         uint256 value,
235         string memory errorMessage
236     ) internal returns (bytes memory) {
237         require(address(this).balance >= value, "Address: insufficient balance for call");
238         require(isContract(target), "Address: call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.call{value: value}(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but performing a static call.
247      *
248      * _Available since v3.3._
249      */
250     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
251         return functionStaticCall(target, data, "Address: low-level static call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal view returns (bytes memory) {
265         require(isContract(target), "Address: static call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.staticcall(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a delegate call.
274      *
275      * _Available since v3.4._
276      */
277     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
283      * but performing a delegate call.
284      *
285      * _Available since v3.4._
286      */
287     function functionDelegateCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         require(isContract(target), "Address: delegate call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.delegatecall(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
300      * revert reason using the provided one.
301      *
302      * _Available since v4.3._
303      */
304     function verifyCallResult(
305         bool success,
306         bytes memory returndata,
307         string memory errorMessage
308     ) internal pure returns (bytes memory) {
309         if (success) {
310             return returndata;
311         } else {
312             // Look for revert reason and bubble it up if present
313             if (returndata.length > 0) {
314                 // The easiest way to bubble the revert reason is using memory via assembly
315 
316                 assembly {
317                     let returndata_size := mload(returndata)
318                     revert(add(32, returndata), returndata_size)
319                 }
320             } else {
321                 revert(errorMessage);
322             }
323         }
324     }
325 }
326 
327 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @title ERC721 token receiver interface
336  * @dev Interface for any contract that wants to support safeTransfers
337  * from ERC721 asset contracts.
338  */
339 interface IERC721Receiver {
340     /**
341      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
342      * by `operator` from `from`, this function is called.
343      *
344      * It must return its Solidity selector to confirm the token transfer.
345      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
346      *
347      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
348      */
349     function onERC721Received(
350         address operator,
351         address from,
352         uint256 tokenId,
353         bytes calldata data
354     ) external returns (bytes4);
355 }
356 
357 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @dev Interface of the ERC165 standard, as defined in the
366  * https://eips.ethereum.org/EIPS/eip-165[EIP].
367  *
368  * Implementers can declare support of contract interfaces, which can then be
369  * queried by others ({ERC165Checker}).
370  *
371  * For an implementation, see {ERC165}.
372  */
373 interface IERC165 {
374     /**
375      * @dev Returns true if this contract implements the interface defined by
376      * `interfaceId`. See the corresponding
377      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
378      * to learn more about how these ids are created.
379      *
380      * This function call must use less than 30 000 gas.
381      */
382     function supportsInterface(bytes4 interfaceId) external view returns (bool);
383 }
384 
385 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Implementation of the {IERC165} interface.
395  *
396  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
397  * for the additional interface id that will be supported. For example:
398  *
399  * ```solidity
400  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
401  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
402  * }
403  * ```
404  *
405  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
406  */
407 abstract contract ERC165 is IERC165 {
408     /**
409      * @dev See {IERC165-supportsInterface}.
410      */
411     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
412         return interfaceId == type(IERC165).interfaceId;
413     }
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
417 
418 
419 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 
424 /**
425  * @dev Required interface of an ERC721 compliant contract.
426  */
427 interface IERC721 is IERC165 {
428     /**
429      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
430      */
431     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
432 
433     /**
434      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
435      */
436     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
437 
438     /**
439      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
440      */
441     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
442 
443     /**
444      * @dev Returns the number of tokens in ``owner``'s account.
445      */
446     function balanceOf(address owner) external view returns (uint256 balance);
447 
448     /**
449      * @dev Returns the owner of the `tokenId` token.
450      *
451      * Requirements:
452      *
453      * - `tokenId` must exist.
454      */
455     function ownerOf(uint256 tokenId) external view returns (address owner);
456 
457     /**
458      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
459      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must exist and be owned by `from`.
466      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId
475     ) external;
476 
477     /**
478      * @dev Transfers `tokenId` token from `from` to `to`.
479      *
480      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must be owned by `from`.
487      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
488      *
489      * Emits a {Transfer} event.
490      */
491     function transferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
499      * The approval is cleared when the token is transferred.
500      *
501      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
502      *
503      * Requirements:
504      *
505      * - The caller must own the token or be an approved operator.
506      * - `tokenId` must exist.
507      *
508      * Emits an {Approval} event.
509      */
510     function approve(address to, uint256 tokenId) external;
511 
512     /**
513      * @dev Returns the account approved for `tokenId` token.
514      *
515      * Requirements:
516      *
517      * - `tokenId` must exist.
518      */
519     function getApproved(uint256 tokenId) external view returns (address operator);
520 
521     /**
522      * @dev Approve or remove `operator` as an operator for the caller.
523      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
524      *
525      * Requirements:
526      *
527      * - The `operator` cannot be the caller.
528      *
529      * Emits an {ApprovalForAll} event.
530      */
531     function setApprovalForAll(address operator, bool _approved) external;
532 
533     /**
534      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
535      *
536      * See {setApprovalForAll}
537      */
538     function isApprovedForAll(address owner, address operator) external view returns (bool);
539 
540     /**
541      * @dev Safely transfers `tokenId` token from `from` to `to`.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must exist and be owned by `from`.
548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
550      *
551      * Emits a {Transfer} event.
552      */
553     function safeTransferFrom(
554         address from,
555         address to,
556         uint256 tokenId,
557         bytes calldata data
558     ) external;
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 interface IERC721Metadata is IERC721 {
574     /**
575      * @dev Returns the token collection name.
576      */
577     function name() external view returns (string memory);
578 
579     /**
580      * @dev Returns the token collection symbol.
581      */
582     function symbol() external view returns (string memory);
583 
584     /**
585      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
586      */
587     function tokenURI(uint256 tokenId) external view returns (string memory);
588 }
589 
590 // File: contracts/new.sol
591 
592 
593 
594 
595 pragma solidity ^0.8.4;
596 
597 
598 
599 
600 
601 
602 
603 
604 error ApprovalCallerNotOwnerNorApproved();
605 error ApprovalQueryForNonexistentToken();
606 error ApproveToCaller();
607 error ApprovalToCurrentOwner();
608 error BalanceQueryForZeroAddress();
609 error MintToZeroAddress();
610 error MintZeroQuantity();
611 error OwnerQueryForNonexistentToken();
612 error TransferCallerNotOwnerNorApproved();
613 error TransferFromIncorrectOwner();
614 error TransferToNonERC721ReceiverImplementer();
615 error TransferToZeroAddress();
616 error URIQueryForNonexistentToken();
617 
618 /**
619  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
620  * the Metadata extension. Built to optimize for lower gas during batch mints.
621  *
622  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
623  *
624  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
625  *
626  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
627  */
628 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
629     using Address for address;
630     using Strings for uint256;
631 
632     // Compiler will pack this into a single 256bit word.
633     struct TokenOwnership {
634         // The address of the owner.
635         address addr;
636         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
637         uint64 startTimestamp;
638         // Whether the token has been burned.
639         bool burned;
640     }
641 
642     // Compiler will pack this into a single 256bit word.
643     struct AddressData {
644         // Realistically, 2**64-1 is more than enough.
645         uint64 balance;
646         // Keeps track of mint count with minimal overhead for tokenomics.
647         uint64 numberMinted;
648         // Keeps track of burn count with minimal overhead for tokenomics.
649         uint64 numberBurned;
650         // For miscellaneous variable(s) pertaining to the address
651         // (e.g. number of whitelist mint slots used).
652         // If there are multiple variables, please pack them into a uint64.
653         uint64 aux;
654     }
655 
656     // The tokenId of the next token to be minted.
657     uint256 internal _currentIndex;
658 
659     // The number of tokens burned.
660     uint256 internal _burnCounter;
661 
662     // Token name
663     string private _name;
664 
665     // Token symbol
666     string private _symbol;
667 
668     // Mapping from token ID to ownership details
669     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
670     mapping(uint256 => TokenOwnership) internal _ownerships;
671 
672     // Mapping owner address to address data
673     mapping(address => AddressData) private _addressData;
674 
675     // Mapping from token ID to approved address
676     mapping(uint256 => address) private _tokenApprovals;
677 
678     // Mapping from owner to operator approvals
679     mapping(address => mapping(address => bool)) private _operatorApprovals;
680 
681     constructor(string memory name_, string memory symbol_) {
682         _name = name_;
683         _symbol = symbol_;
684         _currentIndex = _startTokenId();
685     }
686 
687     /**
688      * To change the starting tokenId, please override this function.
689      */
690     function _startTokenId() internal view virtual returns (uint256) {
691         return 0;
692     }
693 
694     /**
695      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
696      */
697     function totalSupply() public view returns (uint256) {
698         // Counter underflow is impossible as _burnCounter cannot be incremented
699         // more than _currentIndex - _startTokenId() times
700         unchecked {
701             return _currentIndex - _burnCounter - _startTokenId();
702         }
703     }
704 
705     /**
706      * Returns the total amount of tokens minted in the contract.
707      */
708     function _totalMinted() internal view returns (uint256) {
709         // Counter underflow is impossible as _currentIndex does not decrement,
710         // and it is initialized to _startTokenId()
711         unchecked {
712             return _currentIndex - _startTokenId();
713         }
714     }
715 
716     /**
717      * @dev See {IERC165-supportsInterface}.
718      */
719     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
720         return
721             interfaceId == type(IERC721).interfaceId ||
722             interfaceId == type(IERC721Metadata).interfaceId ||
723             super.supportsInterface(interfaceId);
724     }
725 
726     /**
727      * @dev See {IERC721-balanceOf}.
728      */
729     function balanceOf(address owner) public view override returns (uint256) {
730         if (owner == address(0)) revert BalanceQueryForZeroAddress();
731         return uint256(_addressData[owner].balance);
732     }
733 
734     /**
735      * Returns the number of tokens minted by `owner`.
736      */
737     function _numberMinted(address owner) internal view returns (uint256) {
738         return uint256(_addressData[owner].numberMinted);
739     }
740 
741     /**
742      * Returns the number of tokens burned by or on behalf of `owner`.
743      */
744     function _numberBurned(address owner) internal view returns (uint256) {
745         return uint256(_addressData[owner].numberBurned);
746     }
747 
748     /**
749      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
750      */
751     function _getAux(address owner) internal view returns (uint64) {
752         return _addressData[owner].aux;
753     }
754 
755     /**
756      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
757      * If there are multiple variables, please pack them into a uint64.
758      */
759     function _setAux(address owner, uint64 aux) internal {
760         _addressData[owner].aux = aux;
761     }
762 
763     /**
764      * Gas spent here starts off proportional to the maximum mint batch size.
765      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
766      */
767     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
768         uint256 curr = tokenId;
769 
770         unchecked {
771             if (_startTokenId() <= curr && curr < _currentIndex) {
772                 TokenOwnership memory ownership = _ownerships[curr];
773                 if (!ownership.burned) {
774                     if (ownership.addr != address(0)) {
775                         return ownership;
776                     }
777                     // Invariant:
778                     // There will always be an ownership that has an address and is not burned
779                     // before an ownership that does not have an address and is not burned.
780                     // Hence, curr will not underflow.
781                     while (true) {
782                         curr--;
783                         ownership = _ownerships[curr];
784                         if (ownership.addr != address(0)) {
785                             return ownership;
786                         }
787                     }
788                 }
789             }
790         }
791         revert OwnerQueryForNonexistentToken();
792     }
793 
794     /**
795      * @dev See {IERC721-ownerOf}.
796      */
797     function ownerOf(uint256 tokenId) public view override returns (address) {
798         return _ownershipOf(tokenId).addr;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-name}.
803      */
804     function name() public view virtual override returns (string memory) {
805         return _name;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-symbol}.
810      */
811     function symbol() public view virtual override returns (string memory) {
812         return _symbol;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-tokenURI}.
817      */
818     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
819         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
820 
821         string memory baseURI = _baseURI();
822         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
823     }
824 
825     /**
826      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
827      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
828      * by default, can be overriden in child contracts.
829      */
830     function _baseURI() internal view virtual returns (string memory) {
831         return '';
832     }
833 
834     /**
835      * @dev See {IERC721-approve}.
836      */
837     function approve(address to, uint256 tokenId) public override {
838         address owner = ERC721A.ownerOf(tokenId);
839         if (to == owner) revert ApprovalToCurrentOwner();
840 
841         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
842             revert ApprovalCallerNotOwnerNorApproved();
843         }
844 
845         _approve(to, tokenId, owner);
846     }
847 
848     /**
849      * @dev See {IERC721-getApproved}.
850      */
851     function getApproved(uint256 tokenId) public view override returns (address) {
852         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
853 
854         return _tokenApprovals[tokenId];
855     }
856 
857     /**
858      * @dev See {IERC721-setApprovalForAll}.
859      */
860     function setApprovalForAll(address operator, bool approved) public virtual override {
861         if (operator == _msgSender()) revert ApproveToCaller();
862 
863         _operatorApprovals[_msgSender()][operator] = approved;
864         emit ApprovalForAll(_msgSender(), operator, approved);
865     }
866 
867     /**
868      * @dev See {IERC721-isApprovedForAll}.
869      */
870     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
871         return _operatorApprovals[owner][operator];
872     }
873 
874     /**
875      * @dev See {IERC721-transferFrom}.
876      */
877     function transferFrom(
878         address from,
879         address to,
880         uint256 tokenId
881     ) public virtual override {
882         _transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         safeTransferFrom(from, to, tokenId, '');
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) public virtual override {
905         _transfer(from, to, tokenId);
906         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
907             revert TransferToNonERC721ReceiverImplementer();
908         }
909     }
910 
911     /**
912      * @dev Returns whether `tokenId` exists.
913      *
914      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
915      *
916      * Tokens start existing when they are minted (`_mint`),
917      */
918     function _exists(uint256 tokenId) internal view returns (bool) {
919         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
920             !_ownerships[tokenId].burned;
921     }
922 
923     function _safeMint(address to, uint256 quantity) internal {
924         _safeMint(to, quantity, '');
925     }
926 
927     /**
928      * @dev Safely mints `quantity` tokens and transfers them to `to`.
929      *
930      * Requirements:
931      *
932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
933      * - `quantity` must be greater than 0.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _safeMint(
938         address to,
939         uint256 quantity,
940         bytes memory _data
941     ) internal {
942         _mint(to, quantity, _data, true);
943     }
944 
945     /**
946      * @dev Mints `quantity` tokens and transfers them to `to`.
947      *
948      * Requirements:
949      *
950      * - `to` cannot be the zero address.
951      * - `quantity` must be greater than 0.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _mint(
956         address to,
957         uint256 quantity,
958         bytes memory _data,
959         bool safe
960     ) internal {
961         uint256 startTokenId = _currentIndex;
962         if (to == address(0)) revert MintToZeroAddress();
963         if (quantity == 0) revert MintZeroQuantity();
964 
965         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
966 
967         // Overflows are incredibly unrealistic.
968         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
969         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
970         unchecked {
971             _addressData[to].balance += uint64(quantity);
972             _addressData[to].numberMinted += uint64(quantity);
973 
974             _ownerships[startTokenId].addr = to;
975             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
976 
977             uint256 updatedIndex = startTokenId;
978             uint256 end = updatedIndex + quantity;
979 
980             if (safe && to.isContract()) {
981                 do {
982                     emit Transfer(address(0), to, updatedIndex);
983                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
984                         revert TransferToNonERC721ReceiverImplementer();
985                     }
986                 } while (updatedIndex != end);
987                 // Reentrancy protection
988                 if (_currentIndex != startTokenId) revert();
989             } else {
990                 do {
991                     emit Transfer(address(0), to, updatedIndex++);
992                 } while (updatedIndex != end);
993             }
994             _currentIndex = updatedIndex;
995         }
996         _afterTokenTransfers(address(0), to, startTokenId, quantity);
997     }
998 
999     /**
1000      * @dev Transfers `tokenId` from `from` to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must be owned by `from`.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) private {
1014         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1015 
1016         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1017 
1018         bool isApprovedOrOwner = (_msgSender() == from ||
1019             isApprovedForAll(from, _msgSender()) ||
1020             getApproved(tokenId) == _msgSender());
1021 
1022         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1023         if (to == address(0)) revert TransferToZeroAddress();
1024 
1025         _beforeTokenTransfers(from, to, tokenId, 1);
1026 
1027         // Clear approvals from the previous owner
1028         _approve(address(0), tokenId, from);
1029 
1030         // Underflow of the sender's balance is impossible because we check for
1031         // ownership above and the recipient's balance can't realistically overflow.
1032         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1033         unchecked {
1034             _addressData[from].balance -= 1;
1035             _addressData[to].balance += 1;
1036 
1037             TokenOwnership storage currSlot = _ownerships[tokenId];
1038             currSlot.addr = to;
1039             currSlot.startTimestamp = uint64(block.timestamp);
1040 
1041             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1042             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1043             uint256 nextTokenId = tokenId + 1;
1044             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1045             if (nextSlot.addr == address(0)) {
1046                 // This will suffice for checking _exists(nextTokenId),
1047                 // as a burned slot cannot contain the zero address.
1048                 if (nextTokenId != _currentIndex) {
1049                     nextSlot.addr = from;
1050                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1051                 }
1052             }
1053         }
1054 
1055         emit Transfer(from, to, tokenId);
1056         _afterTokenTransfers(from, to, tokenId, 1);
1057     }
1058 
1059     /**
1060      * @dev This is equivalent to _burn(tokenId, false)
1061      */
1062     function _burn(uint256 tokenId) internal virtual {
1063         _burn(tokenId, false);
1064     }
1065 
1066     /**
1067      * @dev Destroys `tokenId`.
1068      * The approval is cleared when the token is burned.
1069      *
1070      * Requirements:
1071      *
1072      * - `tokenId` must exist.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1077         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1078 
1079         address from = prevOwnership.addr;
1080 
1081         if (approvalCheck) {
1082             bool isApprovedOrOwner = (_msgSender() == from ||
1083                 isApprovedForAll(from, _msgSender()) ||
1084                 getApproved(tokenId) == _msgSender());
1085 
1086             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1087         }
1088 
1089         _beforeTokenTransfers(from, address(0), tokenId, 1);
1090 
1091         // Clear approvals from the previous owner
1092         _approve(address(0), tokenId, from);
1093 
1094         // Underflow of the sender's balance is impossible because we check for
1095         // ownership above and the recipient's balance can't realistically overflow.
1096         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1097         unchecked {
1098             AddressData storage addressData = _addressData[from];
1099             addressData.balance -= 1;
1100             addressData.numberBurned += 1;
1101 
1102             // Keep track of who burned the token, and the timestamp of burning.
1103             TokenOwnership storage currSlot = _ownerships[tokenId];
1104             currSlot.addr = from;
1105             currSlot.startTimestamp = uint64(block.timestamp);
1106             currSlot.burned = true;
1107 
1108             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1109             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1110             uint256 nextTokenId = tokenId + 1;
1111             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1112             if (nextSlot.addr == address(0)) {
1113                 // This will suffice for checking _exists(nextTokenId),
1114                 // as a burned slot cannot contain the zero address.
1115                 if (nextTokenId != _currentIndex) {
1116                     nextSlot.addr = from;
1117                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1118                 }
1119             }
1120         }
1121 
1122         emit Transfer(from, address(0), tokenId);
1123         _afterTokenTransfers(from, address(0), tokenId, 1);
1124 
1125         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1126         unchecked {
1127             _burnCounter++;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Approve `to` to operate on `tokenId`
1133      *
1134      * Emits a {Approval} event.
1135      */
1136     function _approve(
1137         address to,
1138         uint256 tokenId,
1139         address owner
1140     ) private {
1141         _tokenApprovals[tokenId] = to;
1142         emit Approval(owner, to, tokenId);
1143     }
1144 
1145     /**
1146      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1147      *
1148      * @param from address representing the previous owner of the given token ID
1149      * @param to target address that will receive the tokens
1150      * @param tokenId uint256 ID of the token to be transferred
1151      * @param _data bytes optional data to send along with the call
1152      * @return bool whether the call correctly returned the expected magic value
1153      */
1154     function _checkContractOnERC721Received(
1155         address from,
1156         address to,
1157         uint256 tokenId,
1158         bytes memory _data
1159     ) private returns (bool) {
1160         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1161             return retval == IERC721Receiver(to).onERC721Received.selector;
1162         } catch (bytes memory reason) {
1163             if (reason.length == 0) {
1164                 revert TransferToNonERC721ReceiverImplementer();
1165             } else {
1166                 assembly {
1167                     revert(add(32, reason), mload(reason))
1168                 }
1169             }
1170         }
1171     }
1172 
1173     /**
1174      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1175      * And also called before burning one token.
1176      *
1177      * startTokenId - the first token id to be transferred
1178      * quantity - the amount to be transferred
1179      *
1180      * Calling conditions:
1181      *
1182      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1183      * transferred to `to`.
1184      * - When `from` is zero, `tokenId` will be minted for `to`.
1185      * - When `to` is zero, `tokenId` will be burned by `from`.
1186      * - `from` and `to` are never both zero.
1187      */
1188     function _beforeTokenTransfers(
1189         address from,
1190         address to,
1191         uint256 startTokenId,
1192         uint256 quantity
1193     ) internal virtual {}
1194 
1195     /**
1196      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1197      * minting.
1198      * And also called after one token has been burned.
1199      *
1200      * startTokenId - the first token id to be transferred
1201      * quantity - the amount to be transferred
1202      *
1203      * Calling conditions:
1204      *
1205      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1206      * transferred to `to`.
1207      * - When `from` is zero, `tokenId` has been minted for `to`.
1208      * - When `to` is zero, `tokenId` has been burned by `from`.
1209      * - `from` and `to` are never both zero.
1210      */
1211     function _afterTokenTransfers(
1212         address from,
1213         address to,
1214         uint256 startTokenId,
1215         uint256 quantity
1216     ) internal virtual {}
1217 }
1218 
1219 abstract contract Ownable is Context {
1220     address private _owner;
1221 
1222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1223 
1224     /**
1225      * @dev Initializes the contract setting the deployer as the initial owner.
1226      */
1227     constructor() {
1228         _transferOwnership(_msgSender());
1229     }
1230 
1231     /**
1232      * @dev Returns the address of the current owner.
1233      */
1234     function owner() public view virtual returns (address) {
1235         return _owner;
1236     }
1237 
1238     /**
1239      * @dev Throws if called by any account other than the owner.
1240      */
1241     modifier onlyOwner() {
1242         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1243         _;
1244     }
1245 
1246     /**
1247      * @dev Leaves the contract without owner. It will not be possible to call
1248      * `onlyOwner` functions anymore. Can only be called by the current owner.
1249      *
1250      * NOTE: Renouncing ownership will leave the contract without an owner,
1251      * thereby removing any functionality that is only available to the owner.
1252      */
1253     function renounceOwnership() public virtual onlyOwner {
1254         _transferOwnership(address(0));
1255     }
1256 
1257     /**
1258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1259      * Can only be called by the current owner.
1260      */
1261     function transferOwnership(address newOwner) public virtual onlyOwner {
1262         require(newOwner != address(0), "Ownable: new owner is the zero address");
1263         _transferOwnership(newOwner);
1264     }
1265 
1266     /**
1267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1268      * Internal function without access restriction.
1269      */
1270     function _transferOwnership(address newOwner) internal virtual {
1271         address oldOwner = _owner;
1272         _owner = newOwner;
1273         emit OwnershipTransferred(oldOwner, newOwner);
1274     }
1275 }
1276 pragma solidity ^0.8.13;
1277 
1278 interface IOperatorFilterRegistry {
1279     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1280     function register(address registrant) external;
1281     function registerAndSubscribe(address registrant, address subscription) external;
1282     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1283     function updateOperator(address registrant, address operator, bool filtered) external;
1284     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1285     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1286     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1287     function subscribe(address registrant, address registrantToSubscribe) external;
1288     function unsubscribe(address registrant, bool copyExistingEntries) external;
1289     function subscriptionOf(address addr) external returns (address registrant);
1290     function subscribers(address registrant) external returns (address[] memory);
1291     function subscriberAt(address registrant, uint256 index) external returns (address);
1292     function copyEntriesOf(address registrant, address registrantToCopy) external;
1293     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1294     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1295     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1296     function filteredOperators(address addr) external returns (address[] memory);
1297     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1298     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1299     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1300     function isRegistered(address addr) external returns (bool);
1301     function codeHashOf(address addr) external returns (bytes32);
1302 }
1303 pragma solidity ^0.8.13;
1304 
1305 
1306 
1307 abstract contract OperatorFilterer {
1308     error OperatorNotAllowed(address operator);
1309 
1310     IOperatorFilterRegistry constant operatorFilterRegistry =
1311         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1312 
1313     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1314         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1315         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1316         // order for the modifier to filter addresses.
1317         if (address(operatorFilterRegistry).code.length > 0) {
1318             if (subscribe) {
1319                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1320             } else {
1321                 if (subscriptionOrRegistrantToCopy != address(0)) {
1322                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1323                 } else {
1324                     operatorFilterRegistry.register(address(this));
1325                 }
1326             }
1327         }
1328     }
1329 
1330     modifier onlyAllowedOperator(address from) virtual {
1331         // Check registry code length to facilitate testing in environments without a deployed registry.
1332         if (address(operatorFilterRegistry).code.length > 0) {
1333             // Allow spending tokens from addresses with balance
1334             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1335             // from an EOA.
1336             if (from == msg.sender) {
1337                 _;
1338                 return;
1339             }
1340             if (
1341                 !(
1342                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1343                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1344                 )
1345             ) {
1346                 revert OperatorNotAllowed(msg.sender);
1347             }
1348         }
1349         _;
1350     }
1351 }
1352 pragma solidity ^0.8.13;
1353 
1354 
1355 
1356 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1357     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1358 
1359     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1360 }
1361     pragma solidity ^0.8.7;
1362     
1363     contract MeowMatrix is ERC721A, DefaultOperatorFilterer , Ownable {
1364     using Strings for uint256;
1365 
1366 
1367   string private uriPrefix ;
1368   string private uriSuffix = ".json";
1369   string public hiddenURL;
1370 
1371   
1372   
1373 
1374   uint256 public cost = 0.003 ether;
1375  
1376   
1377 
1378   uint16 public maxSupply = 999;
1379   uint8 public maxMintAmountPerTx = 10;
1380     uint8 public maxFreeMintAmountPerWallet = 0;
1381                                                              
1382  
1383   bool public paused = true;
1384   bool public reveal =false;
1385 
1386    mapping (address => uint8) public NFTPerPublicAddress;
1387 
1388  
1389   
1390   
1391  
1392   
1393 
1394   constructor() ERC721A("Meow Matrix", "MEOW") {
1395   }
1396 
1397 
1398   
1399  
1400   function mint(uint8 _mintAmount) external payable  {
1401      uint16 totalSupply = uint16(totalSupply());
1402      uint8 nft = NFTPerPublicAddress[msg.sender];
1403     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1404     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1405     require(msg.sender == tx.origin , "No Bots Allowed");
1406 
1407     require(!paused, "The contract is paused!");
1408     
1409       if(nft >= maxFreeMintAmountPerWallet)
1410     {
1411     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1412     }
1413     else {
1414          uint8 costAmount = _mintAmount + nft;
1415         if(costAmount > maxFreeMintAmountPerWallet)
1416        {
1417         costAmount = costAmount - maxFreeMintAmountPerWallet;
1418         require(msg.value >= cost * costAmount, "Insufficient funds!");
1419        }
1420        
1421          
1422     }
1423     
1424 
1425 
1426     _safeMint(msg.sender , _mintAmount);
1427 
1428     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1429      
1430      delete totalSupply;
1431      delete _mintAmount;
1432   }
1433   
1434   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1435      uint16 totalSupply = uint16(totalSupply());
1436     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1437      _safeMint(_receiver , _mintAmount);
1438      delete _mintAmount;
1439      delete _receiver;
1440      delete totalSupply;
1441   }
1442 
1443   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1444      uint16 totalSupply = uint16(totalSupply());
1445      uint totalAmount =   _amountPerAddress * addresses.length;
1446     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1447      for (uint256 i = 0; i < addresses.length; i++) {
1448             _safeMint(addresses[i], _amountPerAddress);
1449         }
1450 
1451      delete _amountPerAddress;
1452      delete totalSupply;
1453   }
1454 
1455  
1456 
1457   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1458       maxSupply = _maxSupply;
1459   }
1460 
1461 
1462 
1463    
1464   function tokenURI(uint256 _tokenId)
1465     public
1466     view
1467     virtual
1468     override
1469     returns (string memory)
1470   {
1471     require(
1472       _exists(_tokenId),
1473       "ERC721Metadata: URI query for nonexistent token"
1474     );
1475     
1476   
1477 if ( reveal == false)
1478 {
1479     return hiddenURL;
1480 }
1481     
1482 
1483     string memory currentBaseURI = _baseURI();
1484     return bytes(currentBaseURI).length > 0
1485         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1486         : "";
1487   }
1488  
1489  
1490 
1491 
1492  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1493     maxFreeMintAmountPerWallet = _limit;
1494    delete _limit;
1495 
1496 }
1497 
1498     
1499   
1500 
1501   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1502     uriPrefix = _uriPrefix;
1503   }
1504    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1505     hiddenURL = _uriPrefix;
1506   }
1507 
1508 
1509   function setPaused() external onlyOwner {
1510     paused = !paused;
1511    
1512   }
1513 
1514   function setCost(uint _cost) external onlyOwner{
1515       cost = _cost;
1516 
1517   }
1518 
1519  function setRevealed() external onlyOwner{
1520      reveal = !reveal;
1521  }
1522 
1523   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1524       maxMintAmountPerTx = _maxtx;
1525 
1526   }
1527 
1528  
1529 
1530   function withdraw() external onlyOwner {
1531   uint _balance = address(this).balance;
1532      payable(msg.sender).transfer(_balance ); 
1533        
1534   }
1535 
1536 
1537   function _baseURI() internal view  override returns (string memory) {
1538     return uriPrefix;
1539   }
1540 
1541     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1542         super.transferFrom(from, to, tokenId);
1543     }
1544 
1545     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1546         super.safeTransferFrom(from, to, tokenId);
1547     }
1548 
1549     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1550         public
1551         override
1552         onlyAllowedOperator(from)
1553     {
1554         super.safeTransferFrom(from, to, tokenId, data);
1555     }
1556 }