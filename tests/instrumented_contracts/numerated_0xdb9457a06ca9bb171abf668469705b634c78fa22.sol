1 /**
2   _____ _           ___ _    _ _    _                _      
3  |_   _| |_  ___   / __| |_ (_) |__(_)_ _  __ _ _  _| |_ ___
4    | | | ' \/ -_) | (__| ' \| | '_ \ | ' \/ _` | || |  _(_-<
5    |_| |_||_\___|  \___|_||_|_|_.__/_|_||_\__,_|\_,_|\__/__/
6                                                             
7 */
8 // @author DegenLabz2000
9 // SPDX-License-Identifier: MIT 
10 // File: @openzeppelin/contracts/utils/Strings.sol
11 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev String operations.
17  */
18 library Strings {
19     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Address.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
82 
83 pragma solidity ^0.8.1;
84 
85 /**
86  * @dev Collection of functions related to the address type
87  */
88 library Address {
89     /**
90      * @dev Returns true if `account` is a contract.
91      *
92      * [IMPORTANT]
93      * ====
94      * It is unsafe to assume that an address for which this function returns
95      * false is an externally-owned account (EOA) and not a contract.
96      *
97      * Among others, `isContract` will return false for the following
98      * types of addresses:
99      *
100      *  - an externally-owned account
101      *  - a contract in construction
102      *  - an address where a contract will be created
103      *  - an address where a contract lived, but was destroyed
104      * ====
105      *
106      * [IMPORTANT]
107      * ====
108      * You shouldn't rely on `isContract` to protect against flash loan attacks!
109      *
110      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
111      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
112      * constructor.
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize/address.code.length, which returns 0
117         // for contracts in construction, since the code is only stored at the end
118         // of the constructor execution.
119 
120         return account.code.length > 0;
121     }
122 
123     /**
124      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
125      * `recipient`, forwarding all available gas and reverting on errors.
126      *
127      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
128      * of certain opcodes, possibly making contracts go over the 2300 gas limit
129      * imposed by `transfer`, making them unable to receive funds via
130      * `transfer`. {sendValue} removes this limitation.
131      *
132      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
133      *
134      * IMPORTANT: because control is transferred to `recipient`, care must be
135      * taken to not create reentrancy vulnerabilities. Consider using
136      * {ReentrancyGuard} or the
137      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
138      */
139     function sendValue(address payable recipient, uint256 amount) internal {
140         require(address(this).balance >= amount, "Address: insufficient balance");
141 
142         (bool success, ) = recipient.call{value: amount}("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain `call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but also transferring `value` wei to `target`.
185      *
186      * Requirements:
187      *
188      * - the calling contract must have an ETH balance of at least `value`.
189      * - the called Solidity function must be `payable`.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
203      * with `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         require(isContract(target), "Address: call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.call{value: value}(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal view returns (bytes memory) {
241         require(isContract(target), "Address: static call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.staticcall(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(isContract(target), "Address: delegate call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.delegatecall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
276      * revert reason using the provided one.
277      *
278      * _Available since v4.3._
279      */
280     function verifyCallResult(
281         bool success,
282         bytes memory returndata,
283         string memory errorMessage
284     ) internal pure returns (bytes memory) {
285         if (success) {
286             return returndata;
287         } else {
288             // Look for revert reason and bubble it up if present
289             if (returndata.length > 0) {
290                 // The easiest way to bubble the revert reason is using memory via assembly
291 
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 
303 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @title ERC721 token receiver interface
312  * @dev Interface for any contract that wants to support safeTransfers
313  * from ERC721 asset contracts.
314  */
315 interface IERC721Receiver {
316     /**
317      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
318      * by `operator` from `from`, this function is called.
319      *
320      * It must return its Solidity selector to confirm the token transfer.
321      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
322      *
323      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
324      */
325     function onERC721Received(
326         address operator,
327         address from,
328         uint256 tokenId,
329         bytes calldata data
330     ) external returns (bytes4);
331 }
332 
333 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev Interface of the ERC165 standard, as defined in the
342  * https://eips.ethereum.org/EIPS/eip-165[EIP].
343  *
344  * Implementers can declare support of contract interfaces, which can then be
345  * queried by others ({ERC165Checker}).
346  *
347  * For an implementation, see {ERC165}.
348  */
349 interface IERC165 {
350     /**
351      * @dev Returns true if this contract implements the interface defined by
352      * `interfaceId`. See the corresponding
353      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
354      * to learn more about how these ids are created.
355      *
356      * This function call must use less than 30 000 gas.
357      */
358     function supportsInterface(bytes4 interfaceId) external view returns (bool);
359 }
360 
361 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Implementation of the {IERC165} interface.
371  *
372  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
373  * for the additional interface id that will be supported. For example:
374  *
375  * ```solidity
376  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
378  * }
379  * ```
380  *
381  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
382  */
383 abstract contract ERC165 is IERC165 {
384     /**
385      * @dev See {IERC165-supportsInterface}.
386      */
387     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
388         return interfaceId == type(IERC165).interfaceId;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev Required interface of an ERC721 compliant contract.
402  */
403 interface IERC721 is IERC165 {
404     /**
405      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
406      */
407     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
408 
409     /**
410      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
411      */
412     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
413 
414     /**
415      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
416      */
417     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
418 
419     /**
420      * @dev Returns the number of tokens in ``owner``'s account.
421      */
422     function balanceOf(address owner) external view returns (uint256 balance);
423 
424     /**
425      * @dev Returns the owner of the `tokenId` token.
426      *
427      * Requirements:
428      *
429      * - `tokenId` must exist.
430      */
431     function ownerOf(uint256 tokenId) external view returns (address owner);
432 
433     /**
434      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
435      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Transfers `tokenId` token from `from` to `to`.
455      *
456      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must be owned by `from`.
463      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
464      *
465      * Emits a {Transfer} event.
466      */
467     function transferFrom(
468         address from,
469         address to,
470         uint256 tokenId
471     ) external;
472 
473     /**
474      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
475      * The approval is cleared when the token is transferred.
476      *
477      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
478      *
479      * Requirements:
480      *
481      * - The caller must own the token or be an approved operator.
482      * - `tokenId` must exist.
483      *
484      * Emits an {Approval} event.
485      */
486     function approve(address to, uint256 tokenId) external;
487 
488     /**
489      * @dev Returns the account approved for `tokenId` token.
490      *
491      * Requirements:
492      *
493      * - `tokenId` must exist.
494      */
495     function getApproved(uint256 tokenId) external view returns (address operator);
496 
497     /**
498      * @dev Approve or remove `operator` as an operator for the caller.
499      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
500      *
501      * Requirements:
502      *
503      * - The `operator` cannot be the caller.
504      *
505      * Emits an {ApprovalForAll} event.
506      */
507     function setApprovalForAll(address operator, bool _approved) external;
508 
509     /**
510      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
511      *
512      * See {setApprovalForAll}
513      */
514     function isApprovedForAll(address owner, address operator) external view returns (bool);
515 
516     /**
517      * @dev Safely transfers `tokenId` token from `from` to `to`.
518      *
519      * Requirements:
520      *
521      * - `from` cannot be the zero address.
522      * - `to` cannot be the zero address.
523      * - `tokenId` token must exist and be owned by `from`.
524      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
525      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
526      *
527      * Emits a {Transfer} event.
528      */
529     function safeTransferFrom(
530         address from,
531         address to,
532         uint256 tokenId,
533         bytes calldata data
534     ) external;
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
547  * @dev See https://eips.ethereum.org/EIPS/eip-721
548  */
549 interface IERC721Metadata is IERC721 {
550     /**
551      * @dev Returns the token collection name.
552      */
553     function name() external view returns (string memory);
554 
555     /**
556      * @dev Returns the token collection symbol.
557      */
558     function symbol() external view returns (string memory);
559 
560     /**
561      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
562      */
563     function tokenURI(uint256 tokenId) external view returns (string memory);
564 }
565 
566 // File: @openzeppelin/contracts/utils/Context.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @dev Provides information about the current execution context, including the
575  * sender of the transaction and its data. While these are generally available
576  * via msg.sender and msg.data, they should not be accessed in such a direct
577  * manner, since when dealing with meta-transactions the account sending and
578  * paying for execution may not be the actual sender (as far as an application
579  * is concerned).
580  *
581  * This contract is only required for intermediate, library-like contracts.
582  */
583 abstract contract Context {
584     function _msgSender() internal view virtual returns (address) {
585         return msg.sender;
586     }
587 
588     function _msgData() internal view virtual returns (bytes calldata) {
589         return msg.data;
590     }
591 }
592 
593 // File: erc721a/contracts/ERC721A.sol
594 
595 
596 // Creator: Chiru Labs
597 
598 pragma solidity ^0.8.4;
599 
600 
601 
602 
603 
604 
605 
606 
607 error ApprovalCallerNotOwnerNorApproved();
608 error ApprovalQueryForNonexistentToken();
609 error ApproveToCaller();
610 error ApprovalToCurrentOwner();
611 error BalanceQueryForZeroAddress();
612 error MintToZeroAddress();
613 error MintZeroQuantity();
614 error OwnerQueryForNonexistentToken();
615 error TransferCallerNotOwnerNorApproved();
616 error TransferFromIncorrectOwner();
617 error TransferToNonERC721ReceiverImplementer();
618 error TransferToZeroAddress();
619 error URIQueryForNonexistentToken();
620 
621 /**
622  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
623  * the Metadata extension. Built to optimize for lower gas during batch mints.
624  *
625  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
626  *
627  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
628  *
629  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
630  */
631 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
632     using Address for address;
633     using Strings for uint256;
634 
635     // Compiler will pack this into a single 256bit word.
636     struct TokenOwnership {
637         // The address of the owner.
638         address addr;
639         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
640         uint64 startTimestamp;
641         // Whether the token has been burned.
642         bool burned;
643     }
644 
645     // Compiler will pack this into a single 256bit word.
646     struct AddressData {
647         // Realistically, 2**64-1 is more than enough.
648         uint64 balance;
649         // Keeps track of mint count with minimal overhead for tokenomics.
650         uint64 numberMinted;
651         // Keeps track of burn count with minimal overhead for tokenomics.
652         uint64 numberBurned;
653         // For miscellaneous variable(s) pertaining to the address
654         // (e.g. number of whitelist mint slots used).
655         // If there are multiple variables, please pack them into a uint64.
656         uint64 aux;
657     }
658 
659     // The tokenId of the next token to be minted.
660     uint256 internal _currentIndex;
661 
662     // The number of tokens burned.
663     uint256 internal _burnCounter;
664 
665     // Token name
666     string private _name;
667 
668     // Token symbol
669     string private _symbol;
670 
671     // Mapping from token ID to ownership details
672     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
673     mapping(uint256 => TokenOwnership) internal _ownerships;
674 
675     // Mapping owner address to address data
676     mapping(address => AddressData) private _addressData;
677 
678     // Mapping from token ID to approved address
679     mapping(uint256 => address) private _tokenApprovals;
680 
681     // Mapping from owner to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683 
684     constructor(string memory name_, string memory symbol_) {
685         _name = name_;
686         _symbol = symbol_;
687         _currentIndex = _startTokenId();
688     }
689 
690     /**
691      * To change the starting tokenId, please override this function.
692      */
693     function _startTokenId() internal view virtual returns (uint256) {
694         return 0;
695     }
696 
697     /**
698      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
699      */
700     function totalSupply() public view returns (uint256) {
701         // Counter underflow is impossible as _burnCounter cannot be incremented
702         // more than _currentIndex - _startTokenId() times
703         unchecked {
704             return _currentIndex - _burnCounter - _startTokenId();
705         }
706     }
707 
708     /**
709      * Returns the total amount of tokens minted in the contract.
710      */
711     function _totalMinted() internal view returns (uint256) {
712         // Counter underflow is impossible as _currentIndex does not decrement,
713         // and it is initialized to _startTokenId()
714         unchecked {
715             return _currentIndex - _startTokenId();
716         }
717     }
718 
719     /**
720      * @dev See {IERC165-supportsInterface}.
721      */
722     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
723         return
724             interfaceId == type(IERC721).interfaceId ||
725             interfaceId == type(IERC721Metadata).interfaceId ||
726             super.supportsInterface(interfaceId);
727     }
728 
729     /**
730      * @dev See {IERC721-balanceOf}.
731      */
732     function balanceOf(address owner) public view override returns (uint256) {
733         if (owner == address(0)) revert BalanceQueryForZeroAddress();
734         return uint256(_addressData[owner].balance);
735     }
736 
737     /**
738      * Returns the number of tokens minted by `owner`.
739      */
740     function _numberMinted(address owner) internal view returns (uint256) {
741         return uint256(_addressData[owner].numberMinted);
742     }
743 
744     /**
745      * Returns the number of tokens burned by or on behalf of `owner`.
746      */
747     function _numberBurned(address owner) internal view returns (uint256) {
748         return uint256(_addressData[owner].numberBurned);
749     }
750 
751     /**
752      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
753      */
754     function _getAux(address owner) internal view returns (uint64) {
755         return _addressData[owner].aux;
756     }
757 
758     /**
759      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
760      * If there are multiple variables, please pack them into a uint64.
761      */
762     function _setAux(address owner, uint64 aux) internal {
763         _addressData[owner].aux = aux;
764     }
765 
766     /**
767      * Gas spent here starts off proportional to the maximum mint batch size.
768      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
769      */
770     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
771         uint256 curr = tokenId;
772 
773         unchecked {
774             if (_startTokenId() <= curr && curr < _currentIndex) {
775                 TokenOwnership memory ownership = _ownerships[curr];
776                 if (!ownership.burned) {
777                     if (ownership.addr != address(0)) {
778                         return ownership;
779                     }
780                     // Invariant:
781                     // There will always be an ownership that has an address and is not burned
782                     // before an ownership that does not have an address and is not burned.
783                     // Hence, curr will not underflow.
784                     while (true) {
785                         curr--;
786                         ownership = _ownerships[curr];
787                         if (ownership.addr != address(0)) {
788                             return ownership;
789                         }
790                     }
791                 }
792             }
793         }
794         revert OwnerQueryForNonexistentToken();
795     }
796 
797     /**
798      * @dev See {IERC721-ownerOf}.
799      */
800     function ownerOf(uint256 tokenId) public view override returns (address) {
801         return _ownershipOf(tokenId).addr;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-name}.
806      */
807     function name() public view virtual override returns (string memory) {
808         return _name;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-symbol}.
813      */
814     function symbol() public view virtual override returns (string memory) {
815         return _symbol;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-tokenURI}.
820      */
821     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
822         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
823 
824         string memory baseURI = _baseURI();
825         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
826     }
827 
828     /**
829      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
830      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
831      * by default, can be overriden in child contracts.
832      */
833     function _baseURI() internal view virtual returns (string memory) {
834         return '';
835     }
836 
837     /**
838      * @dev See {IERC721-approve}.
839      */
840     function approve(address to, uint256 tokenId) public override {
841         address owner = ERC721A.ownerOf(tokenId);
842         if (to == owner) revert ApprovalToCurrentOwner();
843 
844         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
845             revert ApprovalCallerNotOwnerNorApproved();
846         }
847 
848         _approve(to, tokenId, owner);
849     }
850 
851     /**
852      * @dev See {IERC721-getApproved}.
853      */
854     function getApproved(uint256 tokenId) public view override returns (address) {
855         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
856 
857         return _tokenApprovals[tokenId];
858     }
859 
860     /**
861      * @dev See {IERC721-setApprovalForAll}.
862      */
863     function setApprovalForAll(address operator, bool approved) public virtual override {
864         if (operator == _msgSender()) revert ApproveToCaller();
865 
866         _operatorApprovals[_msgSender()][operator] = approved;
867         emit ApprovalForAll(_msgSender(), operator, approved);
868     }
869 
870     /**
871      * @dev See {IERC721-isApprovedForAll}.
872      */
873     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
874         return _operatorApprovals[owner][operator];
875     }
876 
877     /**
878      * @dev See {IERC721-transferFrom}.
879      */
880     function transferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) public virtual override {
885         _transfer(from, to, tokenId);
886     }
887 
888     /**
889      * @dev See {IERC721-safeTransferFrom}.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) public virtual override {
896         safeTransferFrom(from, to, tokenId, '');
897     }
898 
899     /**
900      * @dev See {IERC721-safeTransferFrom}.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId,
906         bytes memory _data
907     ) public virtual override {
908         _transfer(from, to, tokenId);
909         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
910             revert TransferToNonERC721ReceiverImplementer();
911         }
912     }
913 
914     /**
915      * @dev Returns whether `tokenId` exists.
916      *
917      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
918      *
919      * Tokens start existing when they are minted (`_mint`),
920      */
921     function _exists(uint256 tokenId) internal view returns (bool) {
922         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
923     }
924 
925     function _safeMint(address to, uint256 quantity) internal {
926         _safeMint(to, quantity, '');
927     }
928 
929     /**
930      * @dev Safely mints `quantity` tokens and transfers them to `to`.
931      *
932      * Requirements:
933      *
934      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
935      * - `quantity` must be greater than 0.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeMint(
940         address to,
941         uint256 quantity,
942         bytes memory _data
943     ) internal {
944         _mint(to, quantity, _data, true);
945     }
946 
947     /**
948      * @dev Mints `quantity` tokens and transfers them to `to`.
949      *
950      * Requirements:
951      *
952      * - `to` cannot be the zero address.
953      * - `quantity` must be greater than 0.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _mint(
958         address to,
959         uint256 quantity,
960         bytes memory _data,
961         bool safe
962     ) internal {
963         uint256 startTokenId = _currentIndex;
964         if (to == address(0)) revert MintToZeroAddress();
965         if (quantity == 0) revert MintZeroQuantity();
966 
967         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
968 
969         // Overflows are incredibly unrealistic.
970         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
971         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
972         unchecked {
973             _addressData[to].balance += uint64(quantity);
974             _addressData[to].numberMinted += uint64(quantity);
975 
976             _ownerships[startTokenId].addr = to;
977             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
978 
979             uint256 updatedIndex = startTokenId;
980             uint256 end = updatedIndex + quantity;
981 
982             if (safe && to.isContract()) {
983                 do {
984                     emit Transfer(address(0), to, updatedIndex);
985                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
986                         revert TransferToNonERC721ReceiverImplementer();
987                     }
988                 } while (updatedIndex != end);
989                 // Reentrancy protection
990                 if (_currentIndex != startTokenId) revert();
991             } else {
992                 do {
993                     emit Transfer(address(0), to, updatedIndex++);
994                 } while (updatedIndex != end);
995             }
996             _currentIndex = updatedIndex;
997         }
998         _afterTokenTransfers(address(0), to, startTokenId, quantity);
999     }
1000 
1001     /**
1002      * @dev Transfers `tokenId` from `from` to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must be owned by `from`.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _transfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) private {
1016         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1017 
1018         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1019 
1020         bool isApprovedOrOwner = (_msgSender() == from ||
1021             isApprovedForAll(from, _msgSender()) ||
1022             getApproved(tokenId) == _msgSender());
1023 
1024         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1025         if (to == address(0)) revert TransferToZeroAddress();
1026 
1027         _beforeTokenTransfers(from, to, tokenId, 1);
1028 
1029         // Clear approvals from the previous owner
1030         _approve(address(0), tokenId, from);
1031 
1032         // Underflow of the sender's balance is impossible because we check for
1033         // ownership above and the recipient's balance can't realistically overflow.
1034         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1035         unchecked {
1036             _addressData[from].balance -= 1;
1037             _addressData[to].balance += 1;
1038 
1039             TokenOwnership storage currSlot = _ownerships[tokenId];
1040             currSlot.addr = to;
1041             currSlot.startTimestamp = uint64(block.timestamp);
1042 
1043             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1044             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1045             uint256 nextTokenId = tokenId + 1;
1046             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1047             if (nextSlot.addr == address(0)) {
1048                 // This will suffice for checking _exists(nextTokenId),
1049                 // as a burned slot cannot contain the zero address.
1050                 if (nextTokenId != _currentIndex) {
1051                     nextSlot.addr = from;
1052                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1053                 }
1054             }
1055         }
1056 
1057         emit Transfer(from, to, tokenId);
1058         _afterTokenTransfers(from, to, tokenId, 1);
1059     }
1060 
1061     /**
1062      * @dev This is equivalent to _burn(tokenId, false)
1063      */
1064     function _burn(uint256 tokenId) internal virtual {
1065         _burn(tokenId, false);
1066     }
1067 
1068     /**
1069      * @dev Destroys `tokenId`.
1070      * The approval is cleared when the token is burned.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1079         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1080 
1081         address from = prevOwnership.addr;
1082 
1083         if (approvalCheck) {
1084             bool isApprovedOrOwner = (_msgSender() == from ||
1085                 isApprovedForAll(from, _msgSender()) ||
1086                 getApproved(tokenId) == _msgSender());
1087 
1088             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1089         }
1090 
1091         _beforeTokenTransfers(from, address(0), tokenId, 1);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId, from);
1095 
1096         // Underflow of the sender's balance is impossible because we check for
1097         // ownership above and the recipient's balance can't realistically overflow.
1098         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1099         unchecked {
1100             AddressData storage addressData = _addressData[from];
1101             addressData.balance -= 1;
1102             addressData.numberBurned += 1;
1103 
1104             // Keep track of who burned the token, and the timestamp of burning.
1105             TokenOwnership storage currSlot = _ownerships[tokenId];
1106             currSlot.addr = from;
1107             currSlot.startTimestamp = uint64(block.timestamp);
1108             currSlot.burned = true;
1109 
1110             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1111             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1112             uint256 nextTokenId = tokenId + 1;
1113             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1114             if (nextSlot.addr == address(0)) {
1115                 // This will suffice for checking _exists(nextTokenId),
1116                 // as a burned slot cannot contain the zero address.
1117                 if (nextTokenId != _currentIndex) {
1118                     nextSlot.addr = from;
1119                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1120                 }
1121             }
1122         }
1123 
1124         emit Transfer(from, address(0), tokenId);
1125         _afterTokenTransfers(from, address(0), tokenId, 1);
1126 
1127         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1128         unchecked {
1129             _burnCounter++;
1130         }
1131     }
1132 
1133     /**
1134      * @dev Approve `to` to operate on `tokenId`
1135      *
1136      * Emits a {Approval} event.
1137      */
1138     function _approve(
1139         address to,
1140         uint256 tokenId,
1141         address owner
1142     ) private {
1143         _tokenApprovals[tokenId] = to;
1144         emit Approval(owner, to, tokenId);
1145     }
1146 
1147     /**
1148      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1149      *
1150      * @param from address representing the previous owner of the given token ID
1151      * @param to target address that will receive the tokens
1152      * @param tokenId uint256 ID of the token to be transferred
1153      * @param _data bytes optional data to send along with the call
1154      * @return bool whether the call correctly returned the expected magic value
1155      */
1156     function _checkContractOnERC721Received(
1157         address from,
1158         address to,
1159         uint256 tokenId,
1160         bytes memory _data
1161     ) private returns (bool) {
1162         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1163             return retval == IERC721Receiver(to).onERC721Received.selector;
1164         } catch (bytes memory reason) {
1165             if (reason.length == 0) {
1166                 revert TransferToNonERC721ReceiverImplementer();
1167             } else {
1168                 assembly {
1169                     revert(add(32, reason), mload(reason))
1170                 }
1171             }
1172         }
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1177      * And also called before burning one token.
1178      *
1179      * startTokenId - the first token id to be transferred
1180      * quantity - the amount to be transferred
1181      *
1182      * Calling conditions:
1183      *
1184      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1185      * transferred to `to`.
1186      * - When `from` is zero, `tokenId` will be minted for `to`.
1187      * - When `to` is zero, `tokenId` will be burned by `from`.
1188      * - `from` and `to` are never both zero.
1189      */
1190     function _beforeTokenTransfers(
1191         address from,
1192         address to,
1193         uint256 startTokenId,
1194         uint256 quantity
1195     ) internal virtual {}
1196 
1197     /**
1198      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1199      * minting.
1200      * And also called after one token has been burned.
1201      *
1202      * startTokenId - the first token id to be transferred
1203      * quantity - the amount to be transferred
1204      *
1205      * Calling conditions:
1206      *
1207      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1208      * transferred to `to`.
1209      * - When `from` is zero, `tokenId` has been minted for `to`.
1210      * - When `to` is zero, `tokenId` has been burned by `from`.
1211      * - `from` and `to` are never both zero.
1212      */
1213     function _afterTokenTransfers(
1214         address from,
1215         address to,
1216         uint256 startTokenId,
1217         uint256 quantity
1218     ) internal virtual {}
1219 }
1220 
1221 // File: @openzeppelin/contracts/access/Ownable.sol
1222 
1223 
1224 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 
1229 /**
1230  * @dev Contract module which provides a basic access control mechanism, where
1231  * there is an account (an owner) that can be granted exclusive access to
1232  * specific functions.
1233  *
1234  * By default, the owner account will be the one that deploys the contract. This
1235  * can later be changed with {transferOwnership}.
1236  *
1237  * This module is used through inheritance. It will make available the modifier
1238  * `onlyOwner`, which can be applied to your functions to restrict their use to
1239  * the owner.
1240  */
1241 abstract contract Ownable is Context {
1242     address private _owner;
1243 
1244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1245 
1246     /**
1247      * @dev Initializes the contract setting the deployer as the initial owner.
1248      */
1249     constructor() {
1250         _transferOwnership(_msgSender());
1251     }
1252 
1253     /**
1254      * @dev Returns the address of the current owner.
1255      */
1256     function owner() public view virtual returns (address) {
1257         return _owner;
1258     }
1259 
1260     /**
1261      * @dev Throws if called by any account other than the owner.
1262      */
1263     modifier onlyOwner() {
1264         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1265         _;
1266     }
1267 
1268     /**
1269      * @dev Leaves the contract without owner. It will not be possible to call
1270      * `onlyOwner` functions anymore. Can only be called by the current owner.
1271      *
1272      * NOTE: Renouncing ownership will leave the contract without an owner,
1273      * thereby removing any functionality that is only available to the owner.
1274      */
1275     function renounceOwnership() public virtual onlyOwner {
1276         _transferOwnership(address(0));
1277     }
1278 
1279     /**
1280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1281      * Can only be called by the current owner.
1282      */
1283     function transferOwnership(address newOwner) public virtual onlyOwner {
1284         require(newOwner != address(0), "Ownable: new owner is the zero address");
1285         _transferOwnership(newOwner);
1286     }
1287 
1288     /**
1289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1290      * Internal function without access restriction.
1291      */
1292     function _transferOwnership(address newOwner) internal virtual {
1293         address oldOwner = _owner;
1294         _owner = newOwner;
1295         emit OwnershipTransferred(oldOwner, newOwner);
1296     }
1297 }
1298 
1299 // File: contracts/TheChibinauts.sol
1300 
1301 
1302 pragma solidity >=0.8.0 <0.9.0;
1303 
1304 
1305 
1306 
1307 
1308 contract TheChibinauts is ERC721A, Ownable { 
1309 
1310   using Strings for uint256;
1311 
1312   string public uriPrefix = "ipfs://QmbEfueBPKmqKkbsrvLJHVJtjEw4iMwL3YX7ykZCMKGDZG/";
1313   string public uriSuffix = ".json"; 
1314   string public hiddenMetadataUri;
1315   
1316   uint256 public cost = 0.003 ether; 
1317 
1318   uint256 public maxSupply = 5000; 
1319   uint256 public maxMintAmountPerTx = 10; 
1320   uint256 public totalMaxMintAmount = 12; 
1321 
1322   uint256 public freeMaxMintAmount = 2; 
1323 
1324   bool public paused = true;
1325   bool public publicSale = false;
1326   bool public revealed = true;
1327 
1328   mapping(address => uint256) public addressMintedBalance; 
1329 
1330   constructor() ERC721A("TheChibinauts", "Chibi") { 
1331         setHiddenMetadataUri("ipfs://__CID__/hidden.json"); 
1332             ownerMint(50); 
1333     } 
1334 
1335   // MODIFIERS 
1336   
1337   modifier mintCompliance(uint256 _mintAmount) {
1338     if (msg.sender != owner()) { 
1339         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1340     }
1341     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1342     _;
1343   } 
1344 
1345   modifier mintPriceCompliance(uint256 _mintAmount) {
1346     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1347    if (ownerMintedCount >= freeMaxMintAmount) {
1348         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1349    }
1350         _;
1351   }
1352 
1353   // MINTS 
1354 
1355    function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1356     require(!paused, 'The contract is paused!'); 
1357     require(publicSale, "Not open to public yet!");
1358     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1359 
1360     if (ownerMintedCount < freeMaxMintAmount) {  
1361             require(ownerMintedCount + _mintAmount <= freeMaxMintAmount, "Exceeded Free Mint Limit");
1362         } else if (ownerMintedCount >= freeMaxMintAmount) { 
1363             require(ownerMintedCount + _mintAmount <= totalMaxMintAmount, "Exceeded Mint Limit");
1364         }
1365 
1366     _safeMint(_msgSender(), _mintAmount);
1367     for (uint256 i = 1; i <=_mintAmount; i++){
1368         addressMintedBalance[msg.sender]++;
1369     }
1370   }
1371 
1372   function ownerMint(uint256 _mintAmount) public payable onlyOwner {
1373      require(_mintAmount > 0, 'Invalid mint amount!');
1374      require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1375     _safeMint(_msgSender(), _mintAmount);
1376   }
1377 
1378 function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1379     _safeMint(_receiver, _mintAmount);
1380   }
1381   
1382   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1383     uint256 ownerTokenCount = balanceOf(_owner);
1384     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1385     uint256 currentTokenId = _startTokenId();
1386     uint256 ownedTokenIndex = 0;
1387     address latestOwnerAddress;
1388 
1389     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1390       TokenOwnership memory ownership = _ownerships[currentTokenId];
1391 
1392       if (!ownership.burned && ownership.addr != address(0)) {
1393         latestOwnerAddress = ownership.addr;
1394       }
1395 
1396       if (latestOwnerAddress == _owner) {
1397         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1398 
1399         ownedTokenIndex++;
1400       }
1401 
1402       currentTokenId++;
1403     }
1404 
1405     return ownedTokenIds;
1406   }
1407 
1408   function _startTokenId() internal view virtual override returns (uint256) {
1409     return 1;
1410   }
1411 
1412   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1413     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1414 
1415     if (revealed == false) {
1416       return hiddenMetadataUri;
1417     }
1418 
1419     string memory currentBaseURI = _baseURI();
1420     return bytes(currentBaseURI).length > 0
1421         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1422         : '';
1423   }
1424 
1425   function setRevealed(bool _state) public onlyOwner {
1426     revealed = _state;
1427   }
1428 
1429   function setCost(uint256 _cost) public onlyOwner {
1430     cost = _cost; 
1431   }
1432 
1433    function setFreeMaxMintAmount(uint256 _freeMaxMintAmount) public onlyOwner {
1434     freeMaxMintAmount = _freeMaxMintAmount; 
1435   }
1436 
1437   function setTotalMaxMintAmount(uint _amount) public onlyOwner {
1438       require(_amount <= maxSupply, "Exceed total amount");
1439       totalMaxMintAmount = _amount;
1440   }
1441 
1442   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1443     maxMintAmountPerTx = _maxMintAmountPerTx;
1444   }
1445 
1446   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1447     hiddenMetadataUri = _hiddenMetadataUri;
1448   }
1449 
1450   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1451     uriPrefix = _uriPrefix;
1452   }
1453 
1454   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1455     uriSuffix = _uriSuffix;
1456   }
1457 
1458   function setPaused(bool _state) public onlyOwner {
1459     paused = _state;
1460   }
1461 
1462   function setPublicSale(bool _state) public onlyOwner {
1463     publicSale = _state;
1464   }
1465 
1466   // WITHDRAW
1467     function withdraw() public payable onlyOwner {
1468   
1469     (bool os, ) = payable(owner()).call{value: address(this).balance}(""); 
1470     require(os);
1471    
1472   }
1473 
1474   function _baseURI() internal view virtual override returns (string memory) {
1475     return uriPrefix;
1476   }
1477 }