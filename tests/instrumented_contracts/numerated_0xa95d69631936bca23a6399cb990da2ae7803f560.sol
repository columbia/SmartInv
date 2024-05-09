1 // SPDX-License-Identifier: MIT
2 
3 // File: goodlife contract/Strings.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15     uint8 private constant _ADDRESS_LENGTH = 20;
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
75      */
76     function toHexString(address addr) internal pure returns (string memory) {
77         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
78     }
79 }
80 
81 // File: goodlife contract/Address.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
85 
86 pragma solidity ^0.8.1;
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      *
109      * [IMPORTANT]
110      * ====
111      * You shouldn't rely on `isContract` to protect against flash loan attacks!
112      *
113      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
114      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
115      * constructor.
116      * ====
117      */
118     function isContract(address account) internal view returns (bool) {
119         // This method relies on extcodesize/address.code.length, which returns 0
120         // for contracts in construction, since the code is only stored at the end
121         // of the constructor execution.
122 
123         return account.code.length > 0;
124     }
125 
126     /**
127      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
128      * `recipient`, forwarding all available gas and reverting on errors.
129      *
130      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
131      * of certain opcodes, possibly making contracts go over the 2300 gas limit
132      * imposed by `transfer`, making them unable to receive funds via
133      * `transfer`. {sendValue} removes this limitation.
134      *
135      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
136      *
137      * IMPORTANT: because control is transferred to `recipient`, care must be
138      * taken to not create reentrancy vulnerabilities. Consider using
139      * {ReentrancyGuard} or the
140      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
141      */
142     function sendValue(address payable recipient, uint256 amount) internal {
143         require(address(this).balance >= amount, "Address: insufficient balance");
144 
145         (bool success, ) = recipient.call{value: amount}("");
146         require(success, "Address: unable to send value, recipient may have reverted");
147     }
148 
149     /**
150      * @dev Performs a Solidity function call using a low level `call`. A
151      * plain `call` is an unsafe replacement for a function call: use this
152      * function instead.
153      *
154      * If `target` reverts with a revert reason, it is bubbled up by this
155      * function (like regular Solidity function calls).
156      *
157      * Returns the raw returned data. To convert to the expected return value,
158      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
159      *
160      * Requirements:
161      *
162      * - `target` must be a contract.
163      * - calling `target` with `data` must not revert.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168         return functionCall(target, data, "Address: low-level call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
173      * `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, 0, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187      * but also transferring `value` wei to `target`.
188      *
189      * Requirements:
190      *
191      * - the calling contract must have an ETH balance of at least `value`.
192      * - the called Solidity function must be `payable`.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206      * with `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(address(this).balance >= value, "Address: insufficient balance for call");
217         require(isContract(target), "Address: call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.call{value: value}(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
230         return functionStaticCall(target, data, "Address: low-level static call failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal view returns (bytes memory) {
244         require(isContract(target), "Address: static call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.staticcall(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         require(isContract(target), "Address: delegate call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.delegatecall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
279      * revert reason using the provided one.
280      *
281      * _Available since v4.3._
282      */
283     function verifyCallResult(
284         bool success,
285         bytes memory returndata,
286         string memory errorMessage
287     ) internal pure returns (bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294                 /// @solidity memory-safe-assembly
295                 assembly {
296                     let returndata_size := mload(returndata)
297                     revert(add(32, returndata), returndata_size)
298                 }
299             } else {
300                 revert(errorMessage);
301             }
302         }
303     }
304 }
305 
306 // File: goodlife contract/IERC721Receiver.sol
307 
308 
309 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @title ERC721 token receiver interface
315  * @dev Interface for any contract that wants to support safeTransfers
316  * from ERC721 asset contracts.
317  */
318 interface IERC721Receiver {
319     /**
320      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
321      * by `operator` from `from`, this function is called.
322      *
323      * It must return its Solidity selector to confirm the token transfer.
324      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
325      *
326      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
327      */
328     function onERC721Received(
329         address operator,
330         address from,
331         uint256 tokenId,
332         bytes calldata data
333     ) external returns (bytes4);
334 }
335 
336 // File: goodlife contract/IERC165.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Interface of the ERC165 standard, as defined in the
345  * https://eips.ethereum.org/EIPS/eip-165[EIP].
346  *
347  * Implementers can declare support of contract interfaces, which can then be
348  * queried by others ({ERC165Checker}).
349  *
350  * For an implementation, see {ERC165}.
351  */
352 interface IERC165 {
353     /**
354      * @dev Returns true if this contract implements the interface defined by
355      * `interfaceId`. See the corresponding
356      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
357      * to learn more about how these ids are created.
358      *
359      * This function call must use less than 30 000 gas.
360      */
361     function supportsInterface(bytes4 interfaceId) external view returns (bool);
362 }
363 
364 // File: goodlife contract/ERC165.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 
372 /**
373  * @dev Implementation of the {IERC165} interface.
374  *
375  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
376  * for the additional interface id that will be supported. For example:
377  *
378  * ```solidity
379  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
380  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
381  * }
382  * ```
383  *
384  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
385  */
386 abstract contract ERC165 is IERC165 {
387     /**
388      * @dev See {IERC165-supportsInterface}.
389      */
390     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
391         return interfaceId == type(IERC165).interfaceId;
392     }
393 }
394 
395 // File: goodlife contract/IERC721.sol
396 
397 
398 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 
403 /**
404  * @dev Required interface of an ERC721 compliant contract.
405  */
406 interface IERC721 is IERC165 {
407     /**
408      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
409      */
410     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
411 
412     /**
413      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
414      */
415     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
416 
417     /**
418      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
419      */
420     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
421 
422     /**
423      * @dev Returns the number of tokens in ``owner``'s account.
424      */
425     function balanceOf(address owner) external view returns (uint256 balance);
426 
427     /**
428      * @dev Returns the owner of the `tokenId` token.
429      *
430      * Requirements:
431      *
432      * - `tokenId` must exist.
433      */
434     function ownerOf(uint256 tokenId) external view returns (address owner);
435 
436     /**
437      * @dev Safely transfers `tokenId` token from `from` to `to`.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId,
453         bytes calldata data
454     ) external;
455 
456     /**
457      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
458      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must exist and be owned by `from`.
465      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
466      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId
474     ) external;
475 
476     /**
477      * @dev Transfers `tokenId` token from `from` to `to`.
478      *
479      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must be owned by `from`.
486      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
487      *
488      * Emits a {Transfer} event.
489      */
490     function transferFrom(
491         address from,
492         address to,
493         uint256 tokenId
494     ) external;
495 
496     /**
497      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
498      * The approval is cleared when the token is transferred.
499      *
500      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
501      *
502      * Requirements:
503      *
504      * - The caller must own the token or be an approved operator.
505      * - `tokenId` must exist.
506      *
507      * Emits an {Approval} event.
508      */
509     function approve(address to, uint256 tokenId) external;
510 
511     /**
512      * @dev Approve or remove `operator` as an operator for the caller.
513      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
514      *
515      * Requirements:
516      *
517      * - The `operator` cannot be the caller.
518      *
519      * Emits an {ApprovalForAll} event.
520      */
521     function setApprovalForAll(address operator, bool _approved) external;
522 
523     /**
524      * @dev Returns the account approved for `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function getApproved(uint256 tokenId) external view returns (address operator);
531 
532     /**
533      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
534      *
535      * See {setApprovalForAll}
536      */
537     function isApprovedForAll(address owner, address operator) external view returns (bool);
538 }
539 
540 // File: goodlife contract/IERC721Enumerable.sol
541 
542 
543 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
550  * @dev See https://eips.ethereum.org/EIPS/eip-721
551  */
552 interface IERC721Enumerable is IERC721 {
553     /**
554      * @dev Returns the total amount of tokens stored by the contract.
555      */
556     function totalSupply() external view returns (uint256);
557 
558     /**
559      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
560      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
561      */
562     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
563 
564     /**
565      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
566      * Use along with {totalSupply} to enumerate all tokens.
567      */
568     function tokenByIndex(uint256 index) external view returns (uint256);
569 }
570 
571 // File: goodlife contract/IERC721Metadata.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 /**
580  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
581  * @dev See https://eips.ethereum.org/EIPS/eip-721
582  */
583 interface IERC721Metadata is IERC721 {
584     /**
585      * @dev Returns the token collection name.
586      */
587     function name() external view returns (string memory);
588 
589     /**
590      * @dev Returns the token collection symbol.
591      */
592     function symbol() external view returns (string memory);
593 
594     /**
595      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
596      */
597     function tokenURI(uint256 tokenId) external view returns (string memory);
598 }
599 
600 // File: goodlife contract/Context.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Provides information about the current execution context, including the
609  * sender of the transaction and its data. While these are generally available
610  * via msg.sender and msg.data, they should not be accessed in such a direct
611  * manner, since when dealing with meta-transactions the account sending and
612  * paying for execution may not be the actual sender (as far as an application
613  * is concerned).
614  *
615  * This contract is only required for intermediate, library-like contracts.
616  */
617 abstract contract Context {
618     function _msgSender() internal view virtual returns (address) {
619         return msg.sender;
620     }
621 
622     function _msgData() internal view virtual returns (bytes calldata) {
623         return msg.data;
624     }
625 }
626 
627 // File: goodlife contract/ERC721A.sol
628 
629 
630 // Creator: Chiru Labs
631 
632 pragma solidity ^0.8.4;
633 
634 
635 
636 
637 
638 
639 
640 
641 error ApprovalCallerNotOwnerNorApproved();
642 error ApprovalQueryForNonexistentToken();
643 error ApproveToCaller();
644 error ApprovalToCurrentOwner();
645 error BalanceQueryForZeroAddress();
646 error MintToZeroAddress();
647 error MintZeroQuantity();
648 error OwnerQueryForNonexistentToken();
649 error TransferCallerNotOwnerNorApproved();
650 error TransferFromIncorrectOwner();
651 error TransferToNonERC721ReceiverImplementer();
652 error TransferToZeroAddress();
653 error URIQueryForNonexistentToken();
654 
655 /**
656  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
657  * the Metadata extension. Built to optimize for lower gas during batch mints.
658  *
659  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
660  *
661  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
662  *
663  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
664  */
665 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
666     using Address for address;
667     using Strings for uint256;
668 
669     // Compiler will pack this into a single 256bit word.
670     struct TokenOwnership {
671         // The address of the owner.
672         address addr;
673         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
674         uint64 startTimestamp;
675         // Whether the token has been burned.
676         bool burned;
677     }
678 
679     // Compiler will pack this into a single 256bit word.
680     struct AddressData {
681         // Realistically, 2**64-1 is more than enough.
682         uint64 balance;
683         // Keeps track of mint count with minimal overhead for tokenomics.
684         uint64 numberMinted;
685         // Keeps track of burn count with minimal overhead for tokenomics.
686         uint64 numberBurned;
687         // For miscellaneous variable(s) pertaining to the address
688         // (e.g. number of whitelist mint slots used).
689         // If there are multiple variables, please pack them into a uint64.
690         uint64 aux;
691     }
692 
693     // The tokenId of the next token to be minted.
694     uint256 internal _currentIndex;
695 
696     // The number of tokens burned.
697     uint256 internal _burnCounter;
698 
699     // Token name
700     string private _name;
701 
702     // Token symbol
703     string private _symbol;
704 
705     // Mapping from token ID to ownership details
706     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
707     mapping(uint256 => TokenOwnership) internal _ownerships;
708 
709     // Mapping owner address to address data
710     mapping(address => AddressData) private _addressData;
711 
712     // Mapping from token ID to approved address
713     mapping(uint256 => address) private _tokenApprovals;
714 
715     // Mapping from owner to operator approvals
716     mapping(address => mapping(address => bool)) private _operatorApprovals;
717 
718     constructor(string memory name_, string memory symbol_) {
719         _name = name_;
720         _symbol = symbol_;
721         _currentIndex = _startTokenId();
722     }
723 
724     /**
725      * To change the starting tokenId, please override this function.
726      */
727     function _startTokenId() internal view virtual returns (uint256) {
728         return 0;
729     }
730 
731     /**
732      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
733      */
734     function totalSupply() public view returns (uint256) {
735         // Counter underflow is impossible as _burnCounter cannot be incremented
736         // more than _currentIndex - _startTokenId() times
737         unchecked {
738             return _currentIndex - _burnCounter - _startTokenId();
739         }
740     }
741 
742     /**
743      * Returns the total amount of tokens minted in the contract.
744      */
745     function _totalMinted() internal view returns (uint256) {
746         // Counter underflow is impossible as _currentIndex does not decrement,
747         // and it is initialized to _startTokenId()
748         unchecked {
749             return _currentIndex - _startTokenId();
750         }
751     }
752 
753     /**
754      * @dev See {IERC165-supportsInterface}.
755      */
756     function supportsInterface(bytes4 interfaceId)
757         public
758         view
759         virtual
760         override(ERC165, IERC165)
761         returns (bool)
762     {
763         return
764             interfaceId == type(IERC721).interfaceId ||
765             interfaceId == type(IERC721Metadata).interfaceId ||
766             super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev See {IERC721-balanceOf}.
771      */
772     function balanceOf(address owner) public view override returns (uint256) {
773         if (owner == address(0)) revert BalanceQueryForZeroAddress();
774         return uint256(_addressData[owner].balance);
775     }
776 
777     /**
778      * Returns the number of tokens minted by `owner`.
779      */
780     function _numberMinted(address owner) internal view returns (uint256) {
781         return uint256(_addressData[owner].numberMinted);
782     }
783 
784     /**
785      * Returns the number of tokens burned by or on behalf of `owner`.
786      */
787     function _numberBurned(address owner) internal view returns (uint256) {
788         return uint256(_addressData[owner].numberBurned);
789     }
790 
791     /**
792      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
793      */
794     function _getAux(address owner) internal view returns (uint64) {
795         return _addressData[owner].aux;
796     }
797 
798     /**
799      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
800      * If there are multiple variables, please pack them into a uint64.
801      */
802     function _setAux(address owner, uint64 aux) internal {
803         _addressData[owner].aux = aux;
804     }
805 
806     /**
807      * Gas spent here starts off proportional to the maximum mint batch size.
808      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
809      */
810     function _ownershipOf(uint256 tokenId)
811         internal
812         view
813         returns (TokenOwnership memory)
814     {
815         uint256 curr = tokenId;
816 
817         unchecked {
818             if (_startTokenId() <= curr && curr < _currentIndex) {
819                 TokenOwnership memory ownership = _ownerships[curr];
820                 if (!ownership.burned) {
821                     if (ownership.addr != address(0)) {
822                         return ownership;
823                     }
824                     // Invariant:
825                     // There will always be an ownership that has an address and is not burned
826                     // before an ownership that does not have an address and is not burned.
827                     // Hence, curr will not underflow.
828                     while (true) {
829                         curr--;
830                         ownership = _ownerships[curr];
831                         if (ownership.addr != address(0)) {
832                             return ownership;
833                         }
834                     }
835                 }
836             }
837         }
838         revert OwnerQueryForNonexistentToken();
839     }
840 
841     /**
842      * @dev See {IERC721-ownerOf}.
843      */
844     function ownerOf(uint256 tokenId) public view override returns (address) {
845         return _ownershipOf(tokenId).addr;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-name}.
850      */
851     function name() public view virtual override returns (string memory) {
852         return _name;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-symbol}.
857      */
858     function symbol() public view virtual override returns (string memory) {
859         return _symbol;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-tokenURI}.
864      */
865     function tokenURI(uint256 tokenId)
866         public
867         view
868         virtual
869         override
870         returns (string memory)
871     {
872         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
873 
874         string memory baseURI = _baseURI();
875         return
876             bytes(baseURI).length != 0
877                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
878                 : "";
879     }
880 
881     /**
882      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
883      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
884      * by default, can be overriden in child contracts.
885      */
886     function _baseURI() internal view virtual returns (string memory) {
887         return "";
888     }
889 
890     /**
891      * @dev See {IERC721-approve}.
892      */
893     function approve(address to, uint256 tokenId) public override {
894         address owner = ERC721A.ownerOf(tokenId);
895         if (to == owner) revert ApprovalToCurrentOwner();
896 
897         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
898             revert ApprovalCallerNotOwnerNorApproved();
899         }
900 
901         _approve(to, tokenId, owner);
902     }
903 
904     /**
905      * @dev See {IERC721-getApproved}.
906      */
907     function getApproved(uint256 tokenId)
908         public
909         view
910         override
911         returns (address)
912     {
913         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
914 
915         return _tokenApprovals[tokenId];
916     }
917 
918     /**
919      * @dev See {IERC721-setApprovalForAll}.
920      */
921     function setApprovalForAll(address operator, bool approved)
922         public
923         virtual
924         override
925     {
926         if (operator == _msgSender()) revert ApproveToCaller();
927 
928         _operatorApprovals[_msgSender()][operator] = approved;
929         emit ApprovalForAll(_msgSender(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator)
936         public
937         view
938         virtual
939         override
940         returns (bool)
941     {
942         return _operatorApprovals[owner][operator];
943     }
944 
945     /**
946      * @dev See {IERC721-transferFrom}.
947      */
948     function transferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public virtual override {
953         _transfer(from, to, tokenId);
954     }
955 
956     /**
957      * @dev See {IERC721-safeTransferFrom}.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId
963     ) public virtual override {
964         safeTransferFrom(from, to, tokenId, "");
965     }
966 
967     /**
968      * @dev See {IERC721-safeTransferFrom}.
969      */
970     function safeTransferFrom(
971         address from,
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) public virtual override {
976         _transfer(from, to, tokenId);
977         if (
978             to.isContract() &&
979             !_checkContractOnERC721Received(from, to, tokenId, _data)
980         ) {
981             revert TransferToNonERC721ReceiverImplementer();
982         }
983     }
984 
985     /**
986      * @dev Returns whether `tokenId` exists.
987      *
988      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
989      *
990      * Tokens start existing when they are minted (`_mint`),
991      */
992     function _exists(uint256 tokenId) internal view returns (bool) {
993         return
994             _startTokenId() <= tokenId &&
995             tokenId < _currentIndex &&
996             !_ownerships[tokenId].burned;
997     }
998 
999     function _safeMint(address to, uint256 quantity) internal {
1000         _safeMint(to, quantity, "");
1001     }
1002 
1003     /**
1004      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1009      * - `quantity` must be greater than 0.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 quantity,
1016         bytes memory _data
1017     ) internal {
1018         _mint(to, quantity, _data, true);
1019     }
1020 
1021     /**
1022      * @dev Mints `quantity` tokens and transfers them to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `quantity` must be greater than 0.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _mint(
1032         address to,
1033         uint256 quantity,
1034         bytes memory _data,
1035         bool safe
1036     ) internal {
1037         uint256 startTokenId = _currentIndex;
1038         if (to == address(0)) revert MintToZeroAddress();
1039         if (quantity == 0) revert MintZeroQuantity();
1040 
1041         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1042 
1043         // Overflows are incredibly unrealistic.
1044         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1045         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1046         unchecked {
1047             _addressData[to].balance += uint64(quantity);
1048             _addressData[to].numberMinted += uint64(quantity);
1049 
1050             _ownerships[startTokenId].addr = to;
1051             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1052 
1053             uint256 updatedIndex = startTokenId;
1054             uint256 end = updatedIndex + quantity;
1055 
1056             if (safe && to.isContract()) {
1057                 do {
1058                     emit Transfer(address(0), to, updatedIndex);
1059                     if (
1060                         !_checkContractOnERC721Received(
1061                             address(0),
1062                             to,
1063                             updatedIndex++,
1064                             _data
1065                         )
1066                     ) {
1067                         revert TransferToNonERC721ReceiverImplementer();
1068                     }
1069                 } while (updatedIndex != end);
1070                 // Reentrancy protection
1071                 if (_currentIndex != startTokenId) revert();
1072             } else {
1073                 do {
1074                     emit Transfer(address(0), to, updatedIndex++);
1075                 } while (updatedIndex != end);
1076             }
1077             _currentIndex = updatedIndex;
1078         }
1079         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1080     }
1081 
1082     /**
1083      * @dev Transfers `tokenId` from `from` to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `tokenId` token must be owned by `from`.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _transfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) private {
1097         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1098 
1099         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1100 
1101         bool isApprovedOrOwner = (_msgSender() == from ||
1102             isApprovedForAll(from, _msgSender()) ||
1103             getApproved(tokenId) == _msgSender());
1104 
1105         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1106         if (to == address(0)) revert TransferToZeroAddress();
1107 
1108         _beforeTokenTransfers(from, to, tokenId, 1);
1109 
1110         // Clear approvals from the previous owner
1111         _approve(address(0), tokenId, from);
1112 
1113         // Underflow of the sender's balance is impossible because we check for
1114         // ownership above and the recipient's balance can't realistically overflow.
1115         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1116         unchecked {
1117             _addressData[from].balance -= 1;
1118             _addressData[to].balance += 1;
1119 
1120             TokenOwnership storage currSlot = _ownerships[tokenId];
1121             currSlot.addr = to;
1122             currSlot.startTimestamp = uint64(block.timestamp);
1123 
1124             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1125             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1126             uint256 nextTokenId = tokenId + 1;
1127             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1128             if (nextSlot.addr == address(0)) {
1129                 // This will suffice for checking _exists(nextTokenId),
1130                 // as a burned slot cannot contain the zero address.
1131                 if (nextTokenId != _currentIndex) {
1132                     nextSlot.addr = from;
1133                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1134                 }
1135             }
1136         }
1137 
1138         emit Transfer(from, to, tokenId);
1139         _afterTokenTransfers(from, to, tokenId, 1);
1140     }
1141 
1142     /**
1143      * @dev This is equivalent to _burn(tokenId, false)
1144      */
1145     function _burn(uint256 tokenId) internal virtual {
1146         _burn(tokenId, false);
1147     }
1148 
1149     /**
1150      * @dev Destroys `tokenId`.
1151      * The approval is cleared when the token is burned.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1160         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1161 
1162         address from = prevOwnership.addr;
1163 
1164         if (approvalCheck) {
1165             bool isApprovedOrOwner = (_msgSender() == from ||
1166                 isApprovedForAll(from, _msgSender()) ||
1167                 getApproved(tokenId) == _msgSender());
1168 
1169             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1170         }
1171 
1172         _beforeTokenTransfers(from, address(0), tokenId, 1);
1173 
1174         // Clear approvals from the previous owner
1175         _approve(address(0), tokenId, from);
1176 
1177         // Underflow of the sender's balance is impossible because we check for
1178         // ownership above and the recipient's balance can't realistically overflow.
1179         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1180         unchecked {
1181             AddressData storage addressData = _addressData[from];
1182             addressData.balance -= 1;
1183             addressData.numberBurned += 1;
1184 
1185             // Keep track of who burned the token, and the timestamp of burning.
1186             TokenOwnership storage currSlot = _ownerships[tokenId];
1187             currSlot.addr = from;
1188             currSlot.startTimestamp = uint64(block.timestamp);
1189             currSlot.burned = true;
1190 
1191             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1192             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1193             uint256 nextTokenId = tokenId + 1;
1194             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1195             if (nextSlot.addr == address(0)) {
1196                 // This will suffice for checking _exists(nextTokenId),
1197                 // as a burned slot cannot contain the zero address.
1198                 if (nextTokenId != _currentIndex) {
1199                     nextSlot.addr = from;
1200                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1201                 }
1202             }
1203         }
1204 
1205         emit Transfer(from, address(0), tokenId);
1206         _afterTokenTransfers(from, address(0), tokenId, 1);
1207 
1208         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1209         unchecked {
1210             _burnCounter++;
1211         }
1212     }
1213 
1214     /**
1215      * @dev Approve `to` to operate on `tokenId`
1216      *
1217      * Emits a {Approval} event.
1218      */
1219     function _approve(
1220         address to,
1221         uint256 tokenId,
1222         address owner
1223     ) private {
1224         _tokenApprovals[tokenId] = to;
1225         emit Approval(owner, to, tokenId);
1226     }
1227 
1228     /**
1229      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1230      *
1231      * @param from address representing the previous owner of the given token ID
1232      * @param to target address that will receive the tokens
1233      * @param tokenId uint256 ID of the token to be transferred
1234      * @param _data bytes optional data to send along with the call
1235      * @return bool whether the call correctly returned the expected magic value
1236      */
1237     function _checkContractOnERC721Received(
1238         address from,
1239         address to,
1240         uint256 tokenId,
1241         bytes memory _data
1242     ) private returns (bool) {
1243         try
1244             IERC721Receiver(to).onERC721Received(
1245                 _msgSender(),
1246                 from,
1247                 tokenId,
1248                 _data
1249             )
1250         returns (bytes4 retval) {
1251             return retval == IERC721Receiver(to).onERC721Received.selector;
1252         } catch (bytes memory reason) {
1253             if (reason.length == 0) {
1254                 revert TransferToNonERC721ReceiverImplementer();
1255             } else {
1256                 assembly {
1257                     revert(add(32, reason), mload(reason))
1258                 }
1259             }
1260         }
1261     }
1262 
1263     /**
1264      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1265      * And also called before burning one token.
1266      *
1267      * startTokenId - the first token id to be transferred
1268      * quantity - the amount to be transferred
1269      *
1270      * Calling conditions:
1271      *
1272      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1273      * transferred to `to`.
1274      * - When `from` is zero, `tokenId` will be minted for `to`.
1275      * - When `to` is zero, `tokenId` will be burned by `from`.
1276      * - `from` and `to` are never both zero.
1277      */
1278     function _beforeTokenTransfers(
1279         address from,
1280         address to,
1281         uint256 startTokenId,
1282         uint256 quantity
1283     ) internal virtual {}
1284 
1285     /**
1286      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1287      * minting.
1288      * And also called after one token has been burned.
1289      *
1290      * startTokenId - the first token id to be transferred
1291      * quantity - the amount to be transferred
1292      *
1293      * Calling conditions:
1294      *
1295      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1296      * transferred to `to`.
1297      * - When `from` is zero, `tokenId` has been minted for `to`.
1298      * - When `to` is zero, `tokenId` has been burned by `from`.
1299      * - `from` and `to` are never both zero.
1300      */
1301     function _afterTokenTransfers(
1302         address from,
1303         address to,
1304         uint256 startTokenId,
1305         uint256 quantity
1306     ) internal virtual {}
1307 }
1308 
1309 // File: goodlife contract/ERC721.sol
1310 
1311 
1312 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 
1318 
1319 
1320 
1321 
1322 
1323 /**
1324  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1325  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1326  * {ERC721Enumerable}.
1327  */
1328 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1329     using Address for address;
1330     using Strings for uint256;
1331 
1332     // Token name
1333     string private _name;
1334 
1335     // Token symbol
1336     string private _symbol;
1337 
1338     // Mapping from token ID to owner address
1339     mapping(uint256 => address) private _owners;
1340 
1341     // Mapping owner address to token count
1342     mapping(address => uint256) private _balances;
1343 
1344     // Mapping from token ID to approved address
1345     mapping(uint256 => address) private _tokenApprovals;
1346 
1347     // Mapping from owner to operator approvals
1348     mapping(address => mapping(address => bool)) private _operatorApprovals;
1349 
1350     /**
1351      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1352      */
1353     constructor(string memory name_, string memory symbol_) {
1354         _name = name_;
1355         _symbol = symbol_;
1356     }
1357 
1358     /**
1359      * @dev See {IERC165-supportsInterface}.
1360      */
1361     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1362         return
1363             interfaceId == type(IERC721).interfaceId ||
1364             interfaceId == type(IERC721Metadata).interfaceId ||
1365             super.supportsInterface(interfaceId);
1366     }
1367 
1368     /**
1369      * @dev See {IERC721-balanceOf}.
1370      */
1371     function balanceOf(address owner) public view virtual override returns (uint256) {
1372         require(owner != address(0), "ERC721: address zero is not a valid owner");
1373         return _balances[owner];
1374     }
1375 
1376     /**
1377      * @dev See {IERC721-ownerOf}.
1378      */
1379     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1380         address owner = _owners[tokenId];
1381         require(owner != address(0), "ERC721: invalid token ID");
1382         return owner;
1383     }
1384 
1385     /**
1386      * @dev See {IERC721Metadata-name}.
1387      */
1388     function name() public view virtual override returns (string memory) {
1389         return _name;
1390     }
1391 
1392     /**
1393      * @dev See {IERC721Metadata-symbol}.
1394      */
1395     function symbol() public view virtual override returns (string memory) {
1396         return _symbol;
1397     }
1398 
1399     /**
1400      * @dev See {IERC721Metadata-tokenURI}.
1401      */
1402     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1403         _requireMinted(tokenId);
1404 
1405         string memory baseURI = _baseURI();
1406         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1407     }
1408 
1409     /**
1410      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1411      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1412      * by default, can be overridden in child contracts.
1413      */
1414     function _baseURI() internal view virtual returns (string memory) {
1415         return "";
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-approve}.
1420      */
1421     function approve(address to, uint256 tokenId) public virtual override {
1422         address owner = ERC721.ownerOf(tokenId);
1423         require(to != owner, "ERC721: approval to current owner");
1424 
1425         require(
1426             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1427             "ERC721: approve caller is not token owner nor approved for all"
1428         );
1429 
1430         _approve(to, tokenId);
1431     }
1432 
1433     /**
1434      * @dev See {IERC721-getApproved}.
1435      */
1436     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1437         _requireMinted(tokenId);
1438 
1439         return _tokenApprovals[tokenId];
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-setApprovalForAll}.
1444      */
1445     function setApprovalForAll(address operator, bool approved) public virtual override {
1446         _setApprovalForAll(_msgSender(), operator, approved);
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-isApprovedForAll}.
1451      */
1452     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1453         return _operatorApprovals[owner][operator];
1454     }
1455 
1456     /**
1457      * @dev See {IERC721-transferFrom}.
1458      */
1459     function transferFrom(
1460         address from,
1461         address to,
1462         uint256 tokenId
1463     ) public virtual override {
1464         //solhint-disable-next-line max-line-length
1465         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1466 
1467         _transfer(from, to, tokenId);
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-safeTransferFrom}.
1472      */
1473     function safeTransferFrom(
1474         address from,
1475         address to,
1476         uint256 tokenId
1477     ) public virtual override {
1478         safeTransferFrom(from, to, tokenId, "");
1479     }
1480 
1481     /**
1482      * @dev See {IERC721-safeTransferFrom}.
1483      */
1484     function safeTransferFrom(
1485         address from,
1486         address to,
1487         uint256 tokenId,
1488         bytes memory data
1489     ) public virtual override {
1490         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1491         _safeTransfer(from, to, tokenId, data);
1492     }
1493 
1494     /**
1495      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1496      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1497      *
1498      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1499      *
1500      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1501      * implement alternative mechanisms to perform token transfer, such as signature-based.
1502      *
1503      * Requirements:
1504      *
1505      * - `from` cannot be the zero address.
1506      * - `to` cannot be the zero address.
1507      * - `tokenId` token must exist and be owned by `from`.
1508      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1509      *
1510      * Emits a {Transfer} event.
1511      */
1512     function _safeTransfer(
1513         address from,
1514         address to,
1515         uint256 tokenId,
1516         bytes memory data
1517     ) internal virtual {
1518         _transfer(from, to, tokenId);
1519         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1520     }
1521 
1522     /**
1523      * @dev Returns whether `tokenId` exists.
1524      *
1525      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1526      *
1527      * Tokens start existing when they are minted (`_mint`),
1528      * and stop existing when they are burned (`_burn`).
1529      */
1530     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1531         return _owners[tokenId] != address(0);
1532     }
1533 
1534     /**
1535      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1536      *
1537      * Requirements:
1538      *
1539      * - `tokenId` must exist.
1540      */
1541     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1542         address owner = ERC721.ownerOf(tokenId);
1543         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1544     }
1545 
1546     /**
1547      * @dev Safely mints `tokenId` and transfers it to `to`.
1548      *
1549      * Requirements:
1550      *
1551      * - `tokenId` must not exist.
1552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1553      *
1554      * Emits a {Transfer} event.
1555      */
1556     function _safeMint(address to, uint256 tokenId) internal virtual {
1557         _safeMint(to, tokenId, "");
1558     }
1559 
1560     /**
1561      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1562      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1563      */
1564     function _safeMint(
1565         address to,
1566         uint256 tokenId,
1567         bytes memory data
1568     ) internal virtual {
1569         _mint(to, tokenId);
1570         require(
1571             _checkOnERC721Received(address(0), to, tokenId, data),
1572             "ERC721: transfer to non ERC721Receiver implementer"
1573         );
1574     }
1575 
1576     /**
1577      * @dev Mints `tokenId` and transfers it to `to`.
1578      *
1579      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1580      *
1581      * Requirements:
1582      *
1583      * - `tokenId` must not exist.
1584      * - `to` cannot be the zero address.
1585      *
1586      * Emits a {Transfer} event.
1587      */
1588     function _mint(address to, uint256 tokenId) internal virtual {
1589         require(to != address(0), "ERC721: mint to the zero address");
1590         require(!_exists(tokenId), "ERC721: token already minted");
1591 
1592         _beforeTokenTransfer(address(0), to, tokenId);
1593 
1594         _balances[to] += 1;
1595         _owners[tokenId] = to;
1596 
1597         emit Transfer(address(0), to, tokenId);
1598 
1599         _afterTokenTransfer(address(0), to, tokenId);
1600     }
1601 
1602     /**
1603      * @dev Destroys `tokenId`.
1604      * The approval is cleared when the token is burned.
1605      *
1606      * Requirements:
1607      *
1608      * - `tokenId` must exist.
1609      *
1610      * Emits a {Transfer} event.
1611      */
1612     function _burn(uint256 tokenId) internal virtual {
1613         address owner = ERC721.ownerOf(tokenId);
1614 
1615         _beforeTokenTransfer(owner, address(0), tokenId);
1616 
1617         // Clear approvals
1618         _approve(address(0), tokenId);
1619 
1620         _balances[owner] -= 1;
1621         delete _owners[tokenId];
1622 
1623         emit Transfer(owner, address(0), tokenId);
1624 
1625         _afterTokenTransfer(owner, address(0), tokenId);
1626     }
1627 
1628     /**
1629      * @dev Transfers `tokenId` from `from` to `to`.
1630      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1631      *
1632      * Requirements:
1633      *
1634      * - `to` cannot be the zero address.
1635      * - `tokenId` token must be owned by `from`.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function _transfer(
1640         address from,
1641         address to,
1642         uint256 tokenId
1643     ) internal virtual {
1644         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1645         require(to != address(0), "ERC721: transfer to the zero address");
1646 
1647         _beforeTokenTransfer(from, to, tokenId);
1648 
1649         // Clear approvals from the previous owner
1650         _approve(address(0), tokenId);
1651 
1652         _balances[from] -= 1;
1653         _balances[to] += 1;
1654         _owners[tokenId] = to;
1655 
1656         emit Transfer(from, to, tokenId);
1657 
1658         _afterTokenTransfer(from, to, tokenId);
1659     }
1660 
1661     /**
1662      * @dev Approve `to` to operate on `tokenId`
1663      *
1664      * Emits an {Approval} event.
1665      */
1666     function _approve(address to, uint256 tokenId) internal virtual {
1667         _tokenApprovals[tokenId] = to;
1668         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1669     }
1670 
1671     /**
1672      * @dev Approve `operator` to operate on all of `owner` tokens
1673      *
1674      * Emits an {ApprovalForAll} event.
1675      */
1676     function _setApprovalForAll(
1677         address owner,
1678         address operator,
1679         bool approved
1680     ) internal virtual {
1681         require(owner != operator, "ERC721: approve to caller");
1682         _operatorApprovals[owner][operator] = approved;
1683         emit ApprovalForAll(owner, operator, approved);
1684     }
1685 
1686     /**
1687      * @dev Reverts if the `tokenId` has not been minted yet.
1688      */
1689     function _requireMinted(uint256 tokenId) internal view virtual {
1690         require(_exists(tokenId), "ERC721: invalid token ID");
1691     }
1692 
1693     /**
1694      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1695      * The call is not executed if the target address is not a contract.
1696      *
1697      * @param from address representing the previous owner of the given token ID
1698      * @param to target address that will receive the tokens
1699      * @param tokenId uint256 ID of the token to be transferred
1700      * @param data bytes optional data to send along with the call
1701      * @return bool whether the call correctly returned the expected magic value
1702      */
1703     function _checkOnERC721Received(
1704         address from,
1705         address to,
1706         uint256 tokenId,
1707         bytes memory data
1708     ) private returns (bool) {
1709         if (to.isContract()) {
1710             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1711                 return retval == IERC721Receiver.onERC721Received.selector;
1712             } catch (bytes memory reason) {
1713                 if (reason.length == 0) {
1714                     revert("ERC721: transfer to non ERC721Receiver implementer");
1715                 } else {
1716                     /// @solidity memory-safe-assembly
1717                     assembly {
1718                         revert(add(32, reason), mload(reason))
1719                     }
1720                 }
1721             }
1722         } else {
1723             return true;
1724         }
1725     }
1726 
1727     /**
1728      * @dev Hook that is called before any token transfer. This includes minting
1729      * and burning.
1730      *
1731      * Calling conditions:
1732      *
1733      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1734      * transferred to `to`.
1735      * - When `from` is zero, `tokenId` will be minted for `to`.
1736      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1737      * - `from` and `to` are never both zero.
1738      *
1739      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1740      */
1741     function _beforeTokenTransfer(
1742         address from,
1743         address to,
1744         uint256 tokenId
1745     ) internal virtual {}
1746 
1747     /**
1748      * @dev Hook that is called after any transfer of tokens. This includes
1749      * minting and burning.
1750      *
1751      * Calling conditions:
1752      *
1753      * - when `from` and `to` are both non-zero.
1754      * - `from` and `to` are never both zero.
1755      *
1756      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1757      */
1758     function _afterTokenTransfer(
1759         address from,
1760         address to,
1761         uint256 tokenId
1762     ) internal virtual {}
1763 }
1764 
1765 // File: goodlife contract/ERC721Enumerable.sol
1766 
1767 
1768 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1769 
1770 pragma solidity ^0.8.0;
1771 
1772 
1773 
1774 /**
1775  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1776  * enumerability of all the token ids in the contract as well as all token ids owned by each
1777  * account.
1778  */
1779 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1780     // Mapping from owner to list of owned token IDs
1781     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1782 
1783     // Mapping from token ID to index of the owner tokens list
1784     mapping(uint256 => uint256) private _ownedTokensIndex;
1785 
1786     // Array with all token ids, used for enumeration
1787     uint256[] private _allTokens;
1788 
1789     // Mapping from token id to position in the allTokens array
1790     mapping(uint256 => uint256) private _allTokensIndex;
1791 
1792     /**
1793      * @dev See {IERC165-supportsInterface}.
1794      */
1795     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1796         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1797     }
1798 
1799     /**
1800      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1801      */
1802     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1803         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1804         return _ownedTokens[owner][index];
1805     }
1806 
1807     /**
1808      * @dev See {IERC721Enumerable-totalSupply}.
1809      */
1810     function totalSupply() public view virtual override returns (uint256) {
1811         return _allTokens.length;
1812     }
1813 
1814     /**
1815      * @dev See {IERC721Enumerable-tokenByIndex}.
1816      */
1817     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1818         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1819         return _allTokens[index];
1820     }
1821 
1822     /**
1823      * @dev Hook that is called before any token transfer. This includes minting
1824      * and burning.
1825      *
1826      * Calling conditions:
1827      *
1828      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1829      * transferred to `to`.
1830      * - When `from` is zero, `tokenId` will be minted for `to`.
1831      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1832      * - `from` cannot be the zero address.
1833      * - `to` cannot be the zero address.
1834      *
1835      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1836      */
1837     function _beforeTokenTransfer(
1838         address from,
1839         address to,
1840         uint256 tokenId
1841     ) internal virtual override {
1842         super._beforeTokenTransfer(from, to, tokenId);
1843 
1844         if (from == address(0)) {
1845             _addTokenToAllTokensEnumeration(tokenId);
1846         } else if (from != to) {
1847             _removeTokenFromOwnerEnumeration(from, tokenId);
1848         }
1849         if (to == address(0)) {
1850             _removeTokenFromAllTokensEnumeration(tokenId);
1851         } else if (to != from) {
1852             _addTokenToOwnerEnumeration(to, tokenId);
1853         }
1854     }
1855 
1856     /**
1857      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1858      * @param to address representing the new owner of the given token ID
1859      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1860      */
1861     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1862         uint256 length = ERC721.balanceOf(to);
1863         _ownedTokens[to][length] = tokenId;
1864         _ownedTokensIndex[tokenId] = length;
1865     }
1866 
1867     /**
1868      * @dev Private function to add a token to this extension's token tracking data structures.
1869      * @param tokenId uint256 ID of the token to be added to the tokens list
1870      */
1871     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1872         _allTokensIndex[tokenId] = _allTokens.length;
1873         _allTokens.push(tokenId);
1874     }
1875 
1876     /**
1877      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1878      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1879      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1880      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1881      * @param from address representing the previous owner of the given token ID
1882      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1883      */
1884     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1885         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1886         // then delete the last slot (swap and pop).
1887 
1888         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1889         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1890 
1891         // When the token to delete is the last token, the swap operation is unnecessary
1892         if (tokenIndex != lastTokenIndex) {
1893             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1894 
1895             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1896             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1897         }
1898 
1899         // This also deletes the contents at the last position of the array
1900         delete _ownedTokensIndex[tokenId];
1901         delete _ownedTokens[from][lastTokenIndex];
1902     }
1903 
1904     /**
1905      * @dev Private function to remove a token from this extension's token tracking data structures.
1906      * This has O(1) time complexity, but alters the order of the _allTokens array.
1907      * @param tokenId uint256 ID of the token to be removed from the tokens list
1908      */
1909     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1910         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1911         // then delete the last slot (swap and pop).
1912 
1913         uint256 lastTokenIndex = _allTokens.length - 1;
1914         uint256 tokenIndex = _allTokensIndex[tokenId];
1915 
1916         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1917         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1918         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1919         uint256 lastTokenId = _allTokens[lastTokenIndex];
1920 
1921         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1922         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1923 
1924         // This also deletes the contents at the last position of the array
1925         delete _allTokensIndex[tokenId];
1926         _allTokens.pop();
1927     }
1928 }
1929 
1930 // File: goodlife contract/Ownable.sol
1931 
1932 
1933 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1934 
1935 pragma solidity ^0.8.0;
1936 
1937 
1938 /**
1939  * @dev Contract module which provides a basic access control mechanism, where
1940  * there is an account (an owner) that can be granted exclusive access to
1941  * specific functions.
1942  *
1943  * By default, the owner account will be the one that deploys the contract. This
1944  * can later be changed with {transferOwnership}.
1945  *
1946  * This module is used through inheritance. It will make available the modifier
1947  * `onlyOwner`, which can be applied to your functions to restrict their use to
1948  * the owner.
1949  */
1950 abstract contract Ownable is Context {
1951     address private _owner;
1952 
1953     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1954 
1955     /**
1956      * @dev Initializes the contract setting the deployer as the initial owner.
1957      */
1958     constructor() {
1959         _transferOwnership(_msgSender());
1960     }
1961 
1962     /**
1963      * @dev Throws if called by any account other than the owner.
1964      */
1965     modifier onlyOwner() {
1966         _checkOwner();
1967         _;
1968     }
1969 
1970     /**
1971      * @dev Returns the address of the current owner.
1972      */
1973     function owner() public view virtual returns (address) {
1974         return _owner;
1975     }
1976 
1977     /**
1978      * @dev Throws if the sender is not the owner.
1979      */
1980     function _checkOwner() internal view virtual {
1981         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1982     }
1983 
1984     /**
1985      * @dev Leaves the contract without owner. It will not be possible to call
1986      * `onlyOwner` functions anymore. Can only be called by the current owner.
1987      *
1988      * NOTE: Renouncing ownership will leave the contract without an owner,
1989      * thereby removing any functionality that is only available to the owner.
1990      */
1991     function renounceOwnership() public virtual onlyOwner {
1992         _transferOwnership(address(0));
1993     }
1994 
1995     /**
1996      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1997      * Can only be called by the current owner.
1998      */
1999     function transferOwnership(address newOwner) public virtual onlyOwner {
2000         require(newOwner != address(0), "Ownable: new owner is the zero address");
2001         _transferOwnership(newOwner);
2002     }
2003 
2004     /**
2005      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2006      * Internal function without access restriction.
2007      */
2008     function _transferOwnership(address newOwner) internal virtual {
2009         address oldOwner = _owner;
2010         _owner = newOwner;
2011         emit OwnershipTransferred(oldOwner, newOwner);
2012     }
2013 }
2014 
2015 // File: goodlife contract/nft-sale.sol
2016 
2017 
2018 
2019 pragma solidity ^0.8.0;
2020 
2021 
2022 
2023 
2024 /**
2025  * @author OATTTTTTTTTTT
2026  */
2027 
2028 contract BitcoinRocksByElena is ERC721A, Ownable {
2029     bool public saleIsActive = false;
2030     string private _baseURIextended;
2031     uint256 public immutable MAX_SUPPLY;
2032     /// @custom:precision 18
2033     uint256 public currentPrice;
2034     uint256 public walletLimit;
2035     mapping(address => uint256) public freeMints;
2036     /**
2037      * @param _name NFT Name
2038      * @param _symbol NFT Symbol
2039      * @param _uri Token URI used for metadata
2040      * @param limit Wallet Limit
2041      * @param price Initial Price | precision:18
2042      * @param maxSupply Maximum # of NFTs
2043      */
2044     constructor(
2045         string memory _name,
2046         string memory _symbol,
2047         string memory _uri,
2048         uint256 limit,
2049         uint256 price,
2050         uint256 maxSupply
2051 
2052     ) payable ERC721A(_name, _symbol) {
2053         _baseURIextended = _uri;
2054         currentPrice = price;
2055         walletLimit = limit;
2056         MAX_SUPPLY = maxSupply;
2057 
2058         // Mint 5 NFTs during deployment
2059         for (uint256 i = 0; i < 5; i++) {
2060             _safeMint(msg.sender, 1); 
2061         }
2062     }
2063 
2064     /**
2065      * number of nfts to mint 
2066      */
2067     function paidMint(uint256 amount) external payable {
2068         uint256 ts = totalSupply();
2069         uint256 minted = _numberMinted(msg.sender);
2070 
2071         require(saleIsActive, "Sale must be active to mint tokens");
2072         require(amount + minted <= walletLimit, "Exceeds wallet limit");
2073         require(ts + amount <= MAX_SUPPLY, "Purchase would exceed max tokens");
2074         require(currentPrice * amount == msg.value, "Value sent is not correct");
2075 
2076         _safeMint(msg.sender, amount);
2077     }
2078 
2079     function freeMint(uint256 amount) external {
2080         uint256 ts = totalSupply();
2081         uint256 minted = _numberMinted(msg.sender);
2082 
2083         require(saleIsActive, "Sale must be active to claim free mint");
2084         require(freeMints[msg.sender] == 0, "Free mint already claimed");
2085         require(amount + minted <= walletLimit, "Exceeds wallet limit");
2086         require(amount <= 1, "Exceeds free mint limit");
2087         require(ts + amount <= MAX_SUPPLY, "Purchase would exceed max tokens");
2088 
2089         _safeMint(msg.sender, amount);
2090         freeMints[msg.sender] = 1;
2091     }
2092 
2093 
2094 
2095 
2096     /**
2097      * @dev A way for the owner to reserve a specifc number of NFTs without having to
2098      * interact with the sale.
2099      * @param to The address to send reserved NFTs to.
2100      * @param amount The number of NFTs to reserve.
2101      */
2102     function reserve(address to, uint256 amount) external onlyOwner {
2103         uint256 ts = totalSupply();
2104         require(ts + amount <= MAX_SUPPLY, "Purchase would exceed max tokens");
2105         _safeMint(to, amount);
2106     }
2107 
2108     /**
2109      * @dev A way for the owner to withdraw all proceeds from the sale.
2110      */
2111     function withdraw() external onlyOwner {
2112         uint256 balance = address(this).balance;
2113         payable(msg.sender).transfer(balance);
2114     }
2115 
2116     /**
2117      * @dev Sets whether or not the NFT sale is active.
2118      * @param isActive Whether or not the sale will be active.
2119      */
2120     function setSaleIsActive(bool isActive) external onlyOwner {
2121         saleIsActive = isActive;
2122     }
2123 
2124     /**
2125      * @dev Sets the price of each NFT during the initial sale.
2126      * @param price The price of each NFT during the initial sale | precision:18
2127      */
2128     function setCurrentPrice(uint256 price) external onlyOwner {
2129         currentPrice = price;
2130     }
2131 
2132     /**
2133      * @dev Sets the maximum number of NFTs that can be sold to a specific address.
2134      * @param limit The maximum number of NFTs that be bought by a wallet.
2135      */
2136     function setWalletLimit(uint256 limit) external onlyOwner {
2137         walletLimit = limit;
2138     }
2139 
2140     /**
2141      * @dev Updates the baseURI that will be used to retrieve NFT metadata.
2142      * @param baseURI_ The baseURI to be used.
2143      */
2144     function setBaseURI(string memory baseURI_) external onlyOwner {
2145         _baseURIextended = baseURI_;
2146     }
2147 
2148     function _baseURI() internal view override returns (string memory) {
2149         return _baseURIextended;
2150     }
2151 
2152     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2153         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2154 
2155         // Get the base URI
2156         string memory baseURI = _baseURI();
2157 
2158         // If the base URI is not set, return an empty string
2159         if (bytes(baseURI).length == 0) {
2160             return "";
2161         }
2162 
2163         // Return the base URI for all tokens
2164         return baseURI;
2165     }
2166 
2167 }