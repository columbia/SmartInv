1 // SPDX-License-Identifier: MIT
2 
3 //   _   _                         ____        _     
4 //  | | | | __ _ _ __ _ __ _   _  | __ )  ___ | |____
5 //  | |_| |/ _` | '__| '__| | | | |  _ \ / _ \| |_  /
6 //  |  _  | (_| | |  | |  | |_| | | |_) | (_) | |/ / 
7 //  |_| |_|\__,_|_|  |_|   \__, | |____/ \___/|_/___|
8 //                         |___/                                                                                                                                                      
9                                                                                         
10 // Twitter: @nftharrybolz
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21 
22     /**
23      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
24      */
25     function toString(uint256 value) internal pure returns (string memory) {
26         // Inspired by OraclizeAPI's implementation - MIT licence
27         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
28 
29         if (value == 0) {
30             return "0";
31         }
32         uint256 temp = value;
33         uint256 digits;
34         while (temp != 0) {
35             digits++;
36             temp /= 10;
37         }
38         bytes memory buffer = new bytes(digits);
39         while (value != 0) {
40             digits -= 1;
41             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
42             value /= 10;
43         }
44         return string(buffer);
45     }
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
49      */
50     function toHexString(uint256 value) internal pure returns (string memory) {
51         if (value == 0) {
52             return "0x00";
53         }
54         uint256 temp = value;
55         uint256 length = 0;
56         while (temp != 0) {
57             length++;
58             temp >>= 8;
59         }
60         return toHexString(value, length);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
65      */
66     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
67         bytes memory buffer = new bytes(2 * length + 2);
68         buffer[0] = "0";
69         buffer[1] = "x";
70         for (uint256 i = 2 * length + 1; i > 1; --i) {
71             buffer[i] = _HEX_SYMBOLS[value & 0xf];
72             value >>= 4;
73         }
74         require(value == 0, "Strings: hex length insufficient");
75         return string(buffer);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @title ERC721 token receiver interface
313  * @dev Interface for any contract that wants to support safeTransfers
314  * from ERC721 asset contracts.
315  */
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
325      */
326     function onERC721Received(
327         address operator,
328         address from,
329         uint256 tokenId,
330         bytes calldata data
331     ) external returns (bytes4);
332 }
333 
334 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Interface of the ERC165 standard, as defined in the
343  * https://eips.ethereum.org/EIPS/eip-165[EIP].
344  *
345  * Implementers can declare support of contract interfaces, which can then be
346  * queried by others ({ERC165Checker}).
347  *
348  * For an implementation, see {ERC165}.
349  */
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Implementation of the {IERC165} interface.
372  *
373  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
374  * for the additional interface id that will be supported. For example:
375  *
376  * ```solidity
377  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
378  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
379  * }
380  * ```
381  *
382  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
383  */
384 abstract contract ERC165 is IERC165 {
385     /**
386      * @dev See {IERC165-supportsInterface}.
387      */
388     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
389         return interfaceId == type(IERC165).interfaceId;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
394 
395 
396 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 
401 /**
402  * @dev Required interface of an ERC721 compliant contract.
403  */
404 interface IERC721 is IERC165 {
405     /**
406      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
409 
410     /**
411      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
412      */
413     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
417      */
418     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
419 
420     /**
421      * @dev Returns the number of tokens in ``owner``'s account.
422      */
423     function balanceOf(address owner) external view returns (uint256 balance);
424 
425     /**
426      * @dev Returns the owner of the `tokenId` token.
427      *
428      * Requirements:
429      *
430      * - `tokenId` must exist.
431      */
432     function ownerOf(uint256 tokenId) external view returns (address owner);
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
510      * @dev Approve or remove `operator` as an operator for the caller.
511      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
512      *
513      * Requirements:
514      *
515      * - The `operator` cannot be the caller.
516      *
517      * Emits an {ApprovalForAll} event.
518      */
519     function setApprovalForAll(address operator, bool _approved) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
532      *
533      * See {setApprovalForAll}
534      */
535     function isApprovedForAll(address owner, address operator) external view returns (bool);
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
548  * @dev See https://eips.ethereum.org/EIPS/eip-721
549  */
550 interface IERC721Metadata is IERC721 {
551     /**
552      * @dev Returns the token collection name.
553      */
554     function name() external view returns (string memory);
555 
556     /**
557      * @dev Returns the token collection symbol.
558      */
559     function symbol() external view returns (string memory);
560 
561     /**
562      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
563      */
564     function tokenURI(uint256 tokenId) external view returns (string memory);
565 }
566 
567 // File: @openzeppelin/contracts/utils/Context.sol
568 
569 
570 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev Provides information about the current execution context, including the
576  * sender of the transaction and its data. While these are generally available
577  * via msg.sender and msg.data, they should not be accessed in such a direct
578  * manner, since when dealing with meta-transactions the account sending and
579  * paying for execution may not be the actual sender (as far as an application
580  * is concerned).
581  *
582  * This contract is only required for intermediate, library-like contracts.
583  */
584 abstract contract Context {
585     function _msgSender() internal view virtual returns (address) {
586         return msg.sender;
587     }
588 
589     function _msgData() internal view virtual returns (bytes calldata) {
590         return msg.data;
591     }
592 }
593 
594 // File: ERC721A.sol
595 
596 
597 // Creator: Chiru Labs
598 
599 pragma solidity ^0.8.7;
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
916         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
917     }
918 
919     /**
920      * @dev Equivalent to `_safeMint(to, quantity, '')`.
921      */
922     function _safeMint(address to, uint256 quantity) internal {
923         _safeMint(to, quantity, '');
924     }
925 
926     /**
927      * @dev Safely mints `quantity` tokens and transfers them to `to`.
928      *
929      * Requirements:
930      *
931      * - If `to` refers to a smart contract, it must implement 
932      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
933      * - `quantity` must be greater than 0.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _safeMint(
938         address to,
939         uint256 quantity,
940         bytes memory _data
941     ) internal {
942         uint256 startTokenId = _currentIndex;
943         if (to == address(0)) revert MintToZeroAddress();
944         if (quantity == 0) revert MintZeroQuantity();
945 
946         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
947 
948         // Overflows are incredibly unrealistic.
949         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
950         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
951         unchecked {
952             _addressData[to].balance += uint64(quantity);
953             _addressData[to].numberMinted += uint64(quantity);
954 
955             _ownerships[startTokenId].addr = to;
956             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
957 
958             uint256 updatedIndex = startTokenId;
959             uint256 end = updatedIndex + quantity;
960 
961             if (to.isContract()) {
962                 do {
963                     emit Transfer(address(0), to, updatedIndex);
964                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
965                         revert TransferToNonERC721ReceiverImplementer();
966                     }
967                 } while (updatedIndex != end);
968                 // Reentrancy protection
969                 if (_currentIndex != startTokenId) revert();
970             } else {
971                 do {
972                     emit Transfer(address(0), to, updatedIndex++);
973                 } while (updatedIndex != end);
974             }
975             _currentIndex = updatedIndex;
976         }
977         _afterTokenTransfers(address(0), to, startTokenId, quantity);
978     }
979 
980     /**
981      * @dev Mints `quantity` tokens and transfers them to `to`.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `quantity` must be greater than 0.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _mint(address to, uint256 quantity) internal {
991         uint256 startTokenId = _currentIndex;
992         if (to == address(0)) revert MintToZeroAddress();
993         if (quantity == 0) revert MintZeroQuantity();
994 
995         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
996 
997         // Overflows are incredibly unrealistic.
998         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
999         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1000         unchecked {
1001             _addressData[to].balance += uint64(quantity);
1002             _addressData[to].numberMinted += uint64(quantity);
1003 
1004             _ownerships[startTokenId].addr = to;
1005             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1006 
1007             uint256 updatedIndex = startTokenId;
1008             uint256 end = updatedIndex + quantity;
1009 
1010             do {
1011                 emit Transfer(address(0), to, updatedIndex++);
1012             } while (updatedIndex != end);
1013 
1014             _currentIndex = updatedIndex;
1015         }
1016         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1017     }
1018 
1019     /**
1020      * @dev Transfers `tokenId` from `from` to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must be owned by `from`.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _transfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) private {
1034         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1035 
1036         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1037 
1038         bool isApprovedOrOwner = (_msgSender() == from ||
1039             isApprovedForAll(from, _msgSender()) ||
1040             getApproved(tokenId) == _msgSender());
1041 
1042         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1043         if (to == address(0)) revert TransferToZeroAddress();
1044 
1045         _beforeTokenTransfers(from, to, tokenId, 1);
1046 
1047         // Clear approvals from the previous owner
1048         _approve(address(0), tokenId, from);
1049 
1050         // Underflow of the sender's balance is impossible because we check for
1051         // ownership above and the recipient's balance can't realistically overflow.
1052         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1053         unchecked {
1054             _addressData[from].balance -= 1;
1055             _addressData[to].balance += 1;
1056 
1057             TokenOwnership storage currSlot = _ownerships[tokenId];
1058             currSlot.addr = to;
1059             currSlot.startTimestamp = uint64(block.timestamp);
1060 
1061             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1062             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1063             uint256 nextTokenId = tokenId + 1;
1064             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1065             if (nextSlot.addr == address(0)) {
1066                 // This will suffice for checking _exists(nextTokenId),
1067                 // as a burned slot cannot contain the zero address.
1068                 if (nextTokenId != _currentIndex) {
1069                     nextSlot.addr = from;
1070                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1071                 }
1072             }
1073         }
1074 
1075         emit Transfer(from, to, tokenId);
1076         _afterTokenTransfers(from, to, tokenId, 1);
1077     }
1078 
1079     /**
1080      * @dev Equivalent to `_burn(tokenId, false)`.
1081      */
1082     function _burn(uint256 tokenId) internal virtual {
1083         _burn(tokenId, false);
1084     }
1085 
1086     /**
1087      * @dev Destroys `tokenId`.
1088      * The approval is cleared when the token is burned.
1089      *
1090      * Requirements:
1091      *
1092      * - `tokenId` must exist.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1097         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1098 
1099         address from = prevOwnership.addr;
1100 
1101         if (approvalCheck) {
1102             bool isApprovedOrOwner = (_msgSender() == from ||
1103                 isApprovedForAll(from, _msgSender()) ||
1104                 getApproved(tokenId) == _msgSender());
1105 
1106             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1107         }
1108 
1109         _beforeTokenTransfers(from, address(0), tokenId, 1);
1110 
1111         // Clear approvals from the previous owner
1112         _approve(address(0), tokenId, from);
1113 
1114         // Underflow of the sender's balance is impossible because we check for
1115         // ownership above and the recipient's balance can't realistically overflow.
1116         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1117         unchecked {
1118             AddressData storage addressData = _addressData[from];
1119             addressData.balance -= 1;
1120             addressData.numberBurned += 1;
1121 
1122             // Keep track of who burned the token, and the timestamp of burning.
1123             TokenOwnership storage currSlot = _ownerships[tokenId];
1124             currSlot.addr = from;
1125             currSlot.startTimestamp = uint64(block.timestamp);
1126             currSlot.burned = true;
1127 
1128             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1129             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1130             uint256 nextTokenId = tokenId + 1;
1131             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1132             if (nextSlot.addr == address(0)) {
1133                 // This will suffice for checking _exists(nextTokenId),
1134                 // as a burned slot cannot contain the zero address.
1135                 if (nextTokenId != _currentIndex) {
1136                     nextSlot.addr = from;
1137                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1138                 }
1139             }
1140         }
1141 
1142         emit Transfer(from, address(0), tokenId);
1143         _afterTokenTransfers(from, address(0), tokenId, 1);
1144 
1145         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1146         unchecked {
1147             _burnCounter++;
1148         }
1149     }
1150 
1151     /**
1152      * @dev Approve `to` to operate on `tokenId`
1153      *
1154      * Emits a {Approval} event.
1155      */
1156     function _approve(
1157         address to,
1158         uint256 tokenId,
1159         address owner
1160     ) private {
1161         _tokenApprovals[tokenId] = to;
1162         emit Approval(owner, to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1167      *
1168      * @param from address representing the previous owner of the given token ID
1169      * @param to target address that will receive the tokens
1170      * @param tokenId uint256 ID of the token to be transferred
1171      * @param _data bytes optional data to send along with the call
1172      * @return bool whether the call correctly returned the expected magic value
1173      */
1174     function _checkContractOnERC721Received(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) private returns (bool) {
1180         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1181             return retval == IERC721Receiver(to).onERC721Received.selector;
1182         } catch (bytes memory reason) {
1183             if (reason.length == 0) {
1184                 revert TransferToNonERC721ReceiverImplementer();
1185             } else {
1186                 assembly {
1187                     revert(add(32, reason), mload(reason))
1188                 }
1189             }
1190         }
1191     }
1192 
1193     /**
1194      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1195      * And also called before burning one token.
1196      *
1197      * startTokenId - the first token id to be transferred
1198      * quantity - the amount to be transferred
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, `tokenId` will be burned by `from`.
1206      * - `from` and `to` are never both zero.
1207      */
1208     function _beforeTokenTransfers(
1209         address from,
1210         address to,
1211         uint256 startTokenId,
1212         uint256 quantity
1213     ) internal virtual {}
1214 
1215     /**
1216      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1217      * minting.
1218      * And also called after one token has been burned.
1219      *
1220      * startTokenId - the first token id to be transferred
1221      * quantity - the amount to be transferred
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` has been minted for `to`.
1228      * - When `to` is zero, `tokenId` has been burned by `from`.
1229      * - `from` and `to` are never both zero.
1230      */
1231     function _afterTokenTransfers(
1232         address from,
1233         address to,
1234         uint256 startTokenId,
1235         uint256 quantity
1236     ) internal virtual {}
1237 }
1238 // File: @openzeppelin/contracts/access/Ownable.sol
1239 
1240 
1241 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1242 
1243 pragma solidity ^0.8.0;
1244 
1245 
1246 /**
1247  * @dev Contract module which provides a basic access control mechanism, where
1248  * there is an account (an owner) that can be granted exclusive access to
1249  * specific functions.
1250  *
1251  * By default, the owner account will be the one that deploys the contract. This
1252  * can later be changed with {transferOwnership}.
1253  *
1254  * This module is used through inheritance. It will make available the modifier
1255  * `onlyOwner`, which can be applied to your functions to restrict their use to
1256  * the owner.
1257  */
1258 abstract contract Ownable is Context {
1259     address private _owner;
1260 
1261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1262 
1263     /**
1264      * @dev Initializes the contract setting the deployer as the initial owner.
1265      */
1266     constructor() {
1267         _transferOwnership(_msgSender());
1268     }
1269 
1270     /**
1271      * @dev Returns the address of the current owner.
1272      */
1273     function owner() public view virtual returns (address) {
1274         return _owner;
1275     }
1276 
1277     /**
1278      * @dev Throws if called by any account other than the owner.
1279      */
1280     modifier onlyOwner() {
1281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1282         _;
1283     }
1284 
1285     /**
1286      * @dev Leaves the contract without owner. It will not be possible to call
1287      * `onlyOwner` functions anymore. Can only be called by the current owner.
1288      *
1289      * NOTE: Renouncing ownership will leave the contract without an owner,
1290      * thereby removing any functionality that is only available to the owner.
1291      */
1292     function renounceOwnership() public virtual onlyOwner {
1293         _transferOwnership(address(0));
1294     }
1295 
1296     /**
1297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1298      * Can only be called by the current owner.
1299      */
1300     function transferOwnership(address newOwner) public virtual onlyOwner {
1301         require(newOwner != address(0), "Ownable: new owner is the zero address");
1302         _transferOwnership(newOwner);
1303     }
1304 
1305     /**
1306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1307      * Internal function without access restriction.
1308      */
1309     function _transferOwnership(address newOwner) internal virtual {
1310         address oldOwner = _owner;
1311         _owner = newOwner;
1312         emit OwnershipTransferred(oldOwner, newOwner);
1313     }
1314 }
1315 
1316 
1317 pragma solidity ^0.8.7;
1318 
1319 
1320 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.7.3
1321 
1322 
1323 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1324 
1325 pragma solidity ^0.8.0;
1326 
1327 /**
1328  * @dev Interface for the NFT Royalty Standard.
1329  *
1330  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1331  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1332  *
1333  * _Available since v4.5._
1334  */
1335 interface IERC2981 is IERC165 {
1336     /**
1337      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1338      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1339      */
1340     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1341         external
1342         view
1343         returns (address receiver, uint256 royaltyAmount);
1344 }
1345 
1346 
1347 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.7.3
1348 
1349 
1350 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1351 
1352 pragma solidity ^0.8.0;
1353 
1354 
1355 /**
1356  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1357  *
1358  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1359  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1360  *
1361  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1362  * fee is specified in basis points by default.
1363  *
1364  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1365  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1366  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1367  *
1368  * _Available since v4.5._
1369  */
1370 abstract contract ERC2981 is IERC2981, ERC165 {
1371     struct RoyaltyInfo {
1372         address receiver;
1373         uint96 royaltyFraction;
1374     }
1375 
1376     RoyaltyInfo private _defaultRoyaltyInfo;
1377     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1378 
1379     /**
1380      * @dev See {IERC165-supportsInterface}.
1381      */
1382     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1383         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1384     }
1385 
1386     /**
1387      * @inheritdoc IERC2981
1388      */
1389     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1390         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1391 
1392         if (royalty.receiver == address(0)) {
1393             royalty = _defaultRoyaltyInfo;
1394         }
1395 
1396         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1397 
1398         return (royalty.receiver, royaltyAmount);
1399     }
1400 
1401     /**
1402      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1403      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1404      * override.
1405      */
1406     function _feeDenominator() internal pure virtual returns (uint96) {
1407         return 10000;
1408     }
1409 
1410     /**
1411      * @dev Sets the royalty information that all ids in this contract will default to.
1412      *
1413      * Requirements:
1414      *
1415      * - `receiver` cannot be the zero address.
1416      * - `feeNumerator` cannot be greater than the fee denominator.
1417      */
1418     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1419         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1420         require(receiver != address(0), "ERC2981: invalid receiver");
1421 
1422         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1423     }
1424 
1425     /**
1426      * @dev Removes default royalty information.
1427      */
1428     function _deleteDefaultRoyalty() internal virtual {
1429         delete _defaultRoyaltyInfo;
1430     }
1431 
1432     /**
1433      * @dev Sets the royalty information for a specific token id, overriding the global default.
1434      *
1435      * Requirements:
1436      *
1437      * - `receiver` cannot be the zero address.
1438      * - `feeNumerator` cannot be greater than the fee denominator.
1439      */
1440     function _setTokenRoyalty(
1441         uint256 tokenId,
1442         address receiver,
1443         uint96 feeNumerator
1444     ) internal virtual {
1445         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1446         require(receiver != address(0), "ERC2981: Invalid parameters");
1447 
1448         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1449     }
1450 
1451     /**
1452      * @dev Resets royalty information for the token id back to the global default.
1453      */
1454     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1455         delete _tokenRoyaltyInfo[tokenId];
1456     }
1457 }
1458 
1459 
1460 contract HarryBolz is ERC721A, ERC2981, Ownable {
1461 
1462     string public baseURI = "ipfs://QmVkzhycW9KH9jjHqDdjm8VQKD1hrbUbzB2BnvGE7dgP7U/";
1463     uint256 public constant MAX_SUPPLY = 5555;
1464     uint256 public MINT_PRICE = 0.0035 ether;
1465     uint256   public MAX_PER_TX = 8;
1466     uint256   public MAX_PER_TX_FREE = 1;
1467     uint96   public _rAm = 500;
1468     bool public isPublicSale = false;
1469     mapping(address => uint256) public _mintedFreeAmount;
1470     mapping(address => uint256) public _totalMintedAmount;
1471     uint   public totalFreeMinted = 0;
1472 
1473     constructor() ERC721A("HarryBolz", "HarryBolz") {
1474         _setDefaultRoyalty(0xbA16237200B200e571e60AE391085feCE1783744, _rAm);
1475     }
1476 
1477   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1478         require(_exists(_tokenId), "Token does not exist.");
1479         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId), ".json"));
1480     }
1481 
1482     function setBaseURI(string memory _baseURI) external onlyOwner {
1483         baseURI = _baseURI;
1484     }
1485 
1486     function setFreeSupply(uint256 _freeSupply) public onlyOwner {
1487         MAX_PER_TX_FREE = _freeSupply;
1488     }
1489 
1490     function _startTokenId() internal view virtual override returns (uint256) {
1491         return 1;
1492     }
1493 
1494     function setMintPrice(uint256 _price) external onlyOwner {
1495         MINT_PRICE = _price;
1496     }
1497 
1498     function togglePublicSale(bool _isPublicSale) external onlyOwner {
1499         isPublicSale = _isPublicSale;
1500     }
1501 
1502      function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
1503         external
1504         onlyOwner
1505     {
1506         _setDefaultRoyalty(receiver, feeBasisPoints);
1507     }
1508 
1509     function supportsInterface(bytes4 interfaceId)
1510         public
1511         view
1512         override(ERC721A, ERC2981)
1513         returns (bool)
1514     {
1515         return super.supportsInterface(interfaceId);
1516     }
1517 
1518     function mint(uint256 count) external payable {
1519         require(isPublicSale, "Mint is not live yet");
1520         require(totalSupply() + count <= MAX_SUPPLY, "No more");
1521         require(count <= MAX_PER_TX, "Max per txn reached.");
1522             if(count >= (MAX_PER_TX_FREE - _mintedFreeAmount[msg.sender]))
1523             {
1524              require(msg.value >= (count * MINT_PRICE) - ((MAX_PER_TX_FREE - _mintedFreeAmount[msg.sender]) * MINT_PRICE), "You've already minted max free allocation or incorrect ETH sent");
1525              _mintedFreeAmount[msg.sender] = MAX_PER_TX_FREE;
1526              totalFreeMinted += MAX_PER_TX_FREE;
1527             }
1528             else if(count < (MAX_PER_TX_FREE - _mintedFreeAmount[msg.sender]))
1529             {
1530              require(msg.value >= 0, "Please send the exact ETH amount");
1531              _mintedFreeAmount[msg.sender] += count;
1532              totalFreeMinted += count;
1533             }
1534         else{
1535         require(isPublicSale, "Mint is not live yet");
1536         require(msg.value >= count * MINT_PRICE, "Please send the exact ETH amount");
1537         require(totalSupply() + count <= MAX_SUPPLY, "No more");
1538         require(count <= MAX_PER_TX, "Max per txn reached.");
1539         }
1540         _totalMintedAmount[msg.sender] += count;
1541         _safeMint(msg.sender, count);
1542     }
1543 
1544     function devMint(uint256 count) external onlyOwner {
1545         _safeMint(_msgSender(), count);
1546     }
1547 
1548     function withdrawMoney() external onlyOwner {
1549         (bool success, ) = _msgSender().call{value: address(this).balance}("");
1550         require(success, "Transfer failed.");
1551     }
1552 }