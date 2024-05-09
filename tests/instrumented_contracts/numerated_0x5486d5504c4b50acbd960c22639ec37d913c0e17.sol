1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
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
72 // File: @openzeppelin/contracts/utils/Address.sol
73 
74 
75 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
76 
77 pragma solidity ^0.8.1;
78 
79 /**
80  * @dev Collection of functions related to the address type
81  */
82 library Address {
83     /**
84      * @dev Returns true if `account` is a contract.
85      *
86      * [IMPORTANT]
87      * ====
88      * It is unsafe to assume that an address for which this function returns
89      * false is an externally-owned account (EOA) and not a contract.
90      *
91      * Among others, `isContract` will return false for the following
92      * types of addresses:
93      *
94      *  - an externally-owned account
95      *  - a contract in construction
96      *  - an address where a contract will be created
97      *  - an address where a contract lived, but was destroyed
98      * ====
99      *
100      * [IMPORTANT]
101      * ====
102      * You shouldn't rely on `isContract` to protect against flash loan attacks!
103      *
104      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
105      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
106      * constructor.
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize/address.code.length, which returns 0
111         // for contracts in construction, since the code is only stored at the end
112         // of the constructor execution.
113 
114         return account.code.length > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         (bool success, ) = recipient.call{value: amount}("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain `call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
197      * with `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         require(isContract(target), "Address: static call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.staticcall(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(isContract(target), "Address: delegate call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
270      * revert reason using the provided one.
271      *
272      * _Available since v4.3._
273      */
274     function verifyCallResult(
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) internal pure returns (bytes memory) {
279         if (success) {
280             return returndata;
281         } else {
282             // Look for revert reason and bubble it up if present
283             if (returndata.length > 0) {
284                 // The easiest way to bubble the revert reason is using memory via assembly
285 
286                 assembly {
287                     let returndata_size := mload(returndata)
288                     revert(add(32, returndata), returndata_size)
289                 }
290             } else {
291                 revert(errorMessage);
292             }
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
298 
299 
300 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @title ERC721 token receiver interface
306  * @dev Interface for any contract that wants to support safeTransfers
307  * from ERC721 asset contracts.
308  */
309 interface IERC721Receiver {
310     /**
311      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
312      * by `operator` from `from`, this function is called.
313      *
314      * It must return its Solidity selector to confirm the token transfer.
315      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
316      *
317      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
318      */
319     function onERC721Received(
320         address operator,
321         address from,
322         uint256 tokenId,
323         bytes calldata data
324     ) external returns (bytes4);
325 }
326 
327 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Interface of the ERC165 standard, as defined in the
336  * https://eips.ethereum.org/EIPS/eip-165[EIP].
337  *
338  * Implementers can declare support of contract interfaces, which can then be
339  * queried by others ({ERC165Checker}).
340  *
341  * For an implementation, see {ERC165}.
342  */
343 interface IERC165 {
344     /**
345      * @dev Returns true if this contract implements the interface defined by
346      * `interfaceId`. See the corresponding
347      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
348      * to learn more about how these ids are created.
349      *
350      * This function call must use less than 30 000 gas.
351      */
352     function supportsInterface(bytes4 interfaceId) external view returns (bool);
353 }
354 
355 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 
363 /**
364  * @dev Implementation of the {IERC165} interface.
365  *
366  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
367  * for the additional interface id that will be supported. For example:
368  *
369  * ```solidity
370  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
372  * }
373  * ```
374  *
375  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
376  */
377 abstract contract ERC165 is IERC165 {
378     /**
379      * @dev See {IERC165-supportsInterface}.
380      */
381     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
382         return interfaceId == type(IERC165).interfaceId;
383     }
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
387 
388 
389 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev Required interface of an ERC721 compliant contract.
396  */
397 interface IERC721 is IERC165 {
398     /**
399      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
400      */
401     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
402 
403     /**
404      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
405      */
406     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
407 
408     /**
409      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
410      */
411     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
412 
413     /**
414      * @dev Returns the number of tokens in ``owner``'s account.
415      */
416     function balanceOf(address owner) external view returns (uint256 balance);
417 
418     /**
419      * @dev Returns the owner of the `tokenId` token.
420      *
421      * Requirements:
422      *
423      * - `tokenId` must exist.
424      */
425     function ownerOf(uint256 tokenId) external view returns (address owner);
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId,
444         bytes calldata data
445     ) external;
446 
447     /**
448      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
449      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must exist and be owned by `from`.
456      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
457      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
458      *
459      * Emits a {Transfer} event.
460      */
461     function safeTransferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) external;
466 
467     /**
468      * @dev Transfers `tokenId` token from `from` to `to`.
469      *
470      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
471      *
472      * Requirements:
473      *
474      * - `from` cannot be the zero address.
475      * - `to` cannot be the zero address.
476      * - `tokenId` token must be owned by `from`.
477      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
478      *
479      * Emits a {Transfer} event.
480      */
481     function transferFrom(
482         address from,
483         address to,
484         uint256 tokenId
485     ) external;
486 
487     /**
488      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
489      * The approval is cleared when the token is transferred.
490      *
491      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
492      *
493      * Requirements:
494      *
495      * - The caller must own the token or be an approved operator.
496      * - `tokenId` must exist.
497      *
498      * Emits an {Approval} event.
499      */
500     function approve(address to, uint256 tokenId) external;
501 
502     /**
503      * @dev Approve or remove `operator` as an operator for the caller.
504      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
505      *
506      * Requirements:
507      *
508      * - The `operator` cannot be the caller.
509      *
510      * Emits an {ApprovalForAll} event.
511      */
512     function setApprovalForAll(address operator, bool _approved) external;
513 
514     /**
515      * @dev Returns the account approved for `tokenId` token.
516      *
517      * Requirements:
518      *
519      * - `tokenId` must exist.
520      */
521     function getApproved(uint256 tokenId) external view returns (address operator);
522 
523     /**
524      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
525      *
526      * See {setApprovalForAll}
527      */
528     function isApprovedForAll(address owner, address operator) external view returns (bool);
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
541  * @dev See https://eips.ethereum.org/EIPS/eip-721
542  */
543 interface IERC721Metadata is IERC721 {
544     /**
545      * @dev Returns the token collection name.
546      */
547     function name() external view returns (string memory);
548 
549     /**
550      * @dev Returns the token collection symbol.
551      */
552     function symbol() external view returns (string memory);
553 
554     /**
555      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
556      */
557     function tokenURI(uint256 tokenId) external view returns (string memory);
558 }
559 
560 // File: @openzeppelin/contracts/utils/Context.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev Provides information about the current execution context, including the
569  * sender of the transaction and its data. While these are generally available
570  * via msg.sender and msg.data, they should not be accessed in such a direct
571  * manner, since when dealing with meta-transactions the account sending and
572  * paying for execution may not be the actual sender (as far as an application
573  * is concerned).
574  *
575  * This contract is only required for intermediate, library-like contracts.
576  */
577 abstract contract Context {
578     function _msgSender() internal view virtual returns (address) {
579         return msg.sender;
580     }
581 
582     function _msgData() internal view virtual returns (bytes calldata) {
583         return msg.data;
584     }
585 }
586 
587 // File: contracts/ERC721A.sol
588 
589 
590 // Creator: Chiru Labs
591 
592 pragma solidity ^0.8.13;
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
1316 // File: contracts/TrippinPixelApe.sol
1317 
1318 
1319 
1320 pragma solidity ^0.8.13;
1321 
1322 
1323 
1324 contract TrippinPixelApe is ERC721A, Ownable {
1325 
1326     string public baseURI = "https://trippinpixelape.com/metadata/";    
1327     uint256 public constant MAX_SUPPLY = 5555;
1328     uint256 public MINT_PRICE = 0.004 ether;
1329     uint256 public constant MAX_PER_TX = 7;
1330     uint256 public constant FREE_AMOUNT = 1000;
1331 
1332     constructor() ERC721A("TrippinPixelApe", "TrippinPixelApe") {
1333     }
1334 
1335     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1336         require(_exists(_tokenId), "Token does not exist.");
1337         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1338     }
1339 
1340     function setBaseURI(string memory _baseURI) external onlyOwner {
1341         baseURI = _baseURI;
1342     }
1343 
1344     function setMintPrice(uint256 _price) external onlyOwner {
1345         MINT_PRICE = _price;
1346     }
1347 
1348     function publicMint(uint256 count) external payable {
1349         require(totalSupply() + count <= MAX_SUPPLY, "Excedes max supply.");
1350         require(count <= MAX_PER_TX, "Exceeds max per transaction.");
1351         if (msg.sender != owner() && (totalSupply() > FREE_AMOUNT)) {
1352             require(msg.value >= count * MINT_PRICE, "Amount sent less than the cost of minting NFT(s)");
1353         }
1354         _safeMint(_msgSender(), count);
1355     }
1356 
1357     function withdrawMoney() external onlyOwner {
1358         (bool success, ) = _msgSender().call{value: address(this).balance}("");
1359         require(success, "Transfer failed.");
1360     }
1361 }