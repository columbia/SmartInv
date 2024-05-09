1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev String operations.
5  */
6 library Strings {
7     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
8 
9     /**
10      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
11      */
12     function toString(uint256 value) internal pure returns (string memory) {
13         // Inspired by OraclizeAPI's implementation - MIT licence
14         //
15 
16         if (value == 0) {
17             return "0";
18         }
19         uint256 temp = value;
20         uint256 digits;
21         while (temp != 0) {
22             digits++;
23             temp /= 10;
24         }
25         bytes memory buffer = new bytes(digits);
26         while (value != 0) {
27             digits -= 1;
28             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
29             value /= 10;
30         }
31         return string(buffer);
32     }
33 
34     /**
35      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
36      */
37     function toHexString(uint256 value) internal pure returns (string memory) {
38         if (value == 0) {
39             return "0x00";
40         }
41         uint256 temp = value;
42         uint256 length = 0;
43         while (temp != 0) {
44             length++;
45             temp >>= 8;
46         }
47         return toHexString(value, length);
48     }
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
52      */
53     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
54         bytes memory buffer = new bytes(2 * length + 2);
55         buffer[0] = "0";
56         buffer[1] = "x";
57         for (uint256 i = 2 * length + 1; i > 1; --i) {
58             buffer[i] = _HEX_SYMBOLS[value & 0xf];
59             value >>= 4;
60         }
61         require(value == 0, "Strings: hex length insufficient");
62         return string(buffer);
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/Address.sol
67 
68 
69 // SPDX-License-Identifier: MIT
70 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
71 
72 pragma solidity ^0.8.1;
73 
74 /**
75  * @dev Collection of functions related to the address type
76  */
77 library Address {
78     /**
79      * @dev Returns true if `account` is a contract.
80      *
81      * [IMPORTANT]
82      * ====
83      * It is unsafe to assume that an address for which this function returns
84      * false is an externally-owned account (EOA) and not a contract.
85      *
86      * Among others, `isContract` will return false for the following
87      * types of addresses:
88      *
89      *  - an externally-owned account
90      *  - a contract in construction
91      *  - an address where a contract will be created
92      *  - an address where a contract lived, but was destroyed
93      * ====
94      *
95      * [IMPORTANT]
96      * ====
97      * You shouldn't rely on `isContract` to protect against flash loan attacks!
98      *
99      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
100      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
101      * constructor.
102      * ====
103      */
104     function isContract(address account) internal view returns (bool) {
105         // This method relies on extcodesize/address.code.length, which returns 0
106         // for contracts in construction, since the code is only stored at the end
107         // of the constructor execution.
108 
109         return account.code.length > 0;
110     }
111 
112     /**
113      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
114      * `recipient`, forwarding all available gas and reverting on errors.
115      *
116      * [EIP1884] increases the gas cost
117      * of certain opcodes, possibly making contracts go over the 2300 gas limit
118      * imposed by `transfer`, making them unable to receive funds via
119      * `transfer`. {sendValue} removes this limitation.
120      *
121      *  //diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
122      *
123      * IMPORTANT: because control is transferred to `recipient`, care must be
124      * taken to not create reentrancy vulnerabilities. Consider using
125      * {ReentrancyGuard} or the
126      * //solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
127      */
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         (bool success, ) = recipient.call{value: amount}("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134 
135     /**
136      * @dev Performs a Solidity function call using a low level `call`. A
137      * plain `call` is an unsafe replacement for a function call: use this
138      * function instead.
139      *
140      * If `target` reverts with a revert reason, it is bubbled up by this
141      * function (like regular Solidity function calls).
142      *
143      * Returns the raw returned data. To convert to the expected return value,
144      * use //solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
145      *
146      * Requirements:
147      *
148      * - `target` must be a contract.
149      * - calling `target` with `data` must not revert.
150      *
151      * _Available since v3.1._
152      */
153     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
159      * `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but also transferring `value` wei to `target`.
174      *
175      * Requirements:
176      *
177      * - the calling contract must have an ETH balance of at least `value`.
178      * - the called Solidity function must be `payable`.
179      *
180      * _Available since v3.1._
181      */
182     function functionCallWithValue(
183         address target,
184         bytes memory data,
185         uint256 value
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
192      * with `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         require(address(this).balance >= value, "Address: insufficient balance for call");
203         require(isContract(target), "Address: call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.call{value: value}(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but performing a static call.
212      *
213      * _Available since v3.3._
214      */
215     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
216         return functionStaticCall(target, data, "Address: low-level static call failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal view returns (bytes memory) {
230         require(isContract(target), "Address: static call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.staticcall(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but performing a delegate call.
239      *
240      * _Available since v3.4._
241      */
242     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         require(isContract(target), "Address: delegate call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.delegatecall(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
265      * revert reason using the provided one.
266      *
267      * _Available since v4.3._
268      */
269     function verifyCallResult(
270         bool success,
271         bytes memory returndata,
272         string memory errorMessage
273     ) internal pure returns (bytes memory) {
274         if (success) {
275             return returndata;
276         } else {
277             // Look for revert reason and bubble it up if present
278             if (returndata.length > 0) {
279                 // The easiest way to bubble the revert reason is using memory via assembly
280 
281                 assembly {
282                     let returndata_size := mload(returndata)
283                     revert(add(32, returndata), returndata_size)
284                 }
285             } else {
286                 revert(errorMessage);
287             }
288         }
289     }
290 }
291 
292 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @title ERC721 token receiver interface
301  * @dev Interface for any contract that wants to support safeTransfers
302  * from ERC721 asset contracts.
303  */
304 interface IERC721Receiver {
305     /**
306      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
307      * by `operator` from `from`, this function is called.
308      *
309      * It must return its Solidity selector to confirm the token transfer.
310      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
311      *
312      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
313      */
314     function onERC721Received(
315         address operator,
316         address from,
317         uint256 tokenId,
318         bytes calldata data
319     ) external returns (bytes4);
320 }
321 
322 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Interface of the ERC165 standard, as defined in the
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * //eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 
349 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Implementation of the {IERC165} interface.
358  *
359  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
360  * for the additional interface id that will be supported. For example:
361  *
362  * ```solidity
363  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
364  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
365  * }
366  * ```
367  *
368  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
369  */
370 abstract contract ERC165 is IERC165 {
371     /**
372      * @dev See {IERC165-supportsInterface}.
373      */
374     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
375         return interfaceId == type(IERC165).interfaceId;
376     }
377 }
378 
379 
380 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 /**
388  * @dev Required interface of an ERC721 compliant contract.
389  */
390 interface IERC721 is IERC165 {
391     /**
392      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
393      */
394     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
398      */
399     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
400 
401     /**
402      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
403      */
404     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
405 
406     /**
407      * @dev Returns the number of tokens in ``owner``'s account.
408      */
409     function balanceOf(address owner) external view returns (uint256 balance);
410 
411     /**
412      * @dev Returns the owner of the `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function ownerOf(uint256 tokenId) external view returns (address owner);
419 
420     /**
421      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
422      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
423      *
424      * Requirements:
425      *
426      * - `from` cannot be the zero address.
427      * - `to` cannot be the zero address.
428      * - `tokenId` token must exist and be owned by `from`.
429      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
430      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
431      *
432      * Emits a {Transfer} event.
433      */
434     function safeTransferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Transfers `tokenId` token from `from` to `to`.
442      *
443      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
444      *
445      * Requirements:
446      *
447      * - `from` cannot be the zero address.
448      * - `to` cannot be the zero address.
449      * - `tokenId` token must be owned by `from`.
450      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
451      *
452      * Emits a {Transfer} event.
453      */
454     function transferFrom(
455         address from,
456         address to,
457         uint256 tokenId
458     ) external;
459 
460     /**
461      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
462      * The approval is cleared when the token is transferred.
463      *
464      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
465      *
466      * Requirements:
467      *
468      * - The caller must own the token or be an approved operator.
469      * - `tokenId` must exist.
470      *
471      * Emits an {Approval} event.
472      */
473     function approve(address to, uint256 tokenId) external;
474 
475     /**
476      * @dev Returns the account approved for `tokenId` token.
477      *
478      * Requirements:
479      *
480      * - `tokenId` must exist.
481      */
482     function getApproved(uint256 tokenId) external view returns (address operator);
483 
484     /**
485      * @dev Approve or remove `operator` as an operator for the caller.
486      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
487      *
488      * Requirements:
489      *
490      * - The `operator` cannot be the caller.
491      *
492      * Emits an {ApprovalForAll} event.
493      */
494     function setApprovalForAll(address operator, bool _approved) external;
495 
496     /**
497      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
498      *
499      * See {setApprovalForAll}
500      */
501     function isApprovedForAll(address owner, address operator) external view returns (bool);
502 
503     /**
504      * @dev Safely transfers `tokenId` token from `from` to `to`.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `tokenId` token must exist and be owned by `from`.
511      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
512      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
513      *
514      * Emits a {Transfer} event.
515      */
516     function safeTransferFrom(
517         address from,
518         address to,
519         uint256 tokenId,
520         bytes calldata data
521     ) external;
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
525 
526 
527 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
533  * @dev See //eips.ethereum.org/EIPS/eip-721
534  */
535 interface IERC721Enumerable is IERC721 {
536     /**
537      * @dev Returns the total amount of tokens stored by the contract.
538      */
539     function totalSupply() external view returns (uint256);
540 
541     /**
542      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
543      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
544      */
545     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
546 
547     /**
548      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
549      * Use along with {totalSupply} to enumerate all tokens.
550      */
551     function tokenByIndex(uint256 index) external view returns (uint256);
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
555 
556 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
563  * @dev See //eips.ethereum.org/EIPS/eip-721
564  */
565 interface IERC721Metadata is IERC721 {
566     /**
567      * @dev Returns the token collection name.
568      */
569     function name() external view returns (string memory);
570 
571     /**
572      * @dev Returns the token collection symbol.
573      */
574     function symbol() external view returns (string memory);
575 
576     /**
577      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
578      */
579     function tokenURI(uint256 tokenId) external view returns (string memory);
580 }
581 
582 // File: @openzeppelin/contracts/utils/Context.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @dev Provides information about the current execution context, including the
591  * sender of the transaction and its data. While these are generally available
592  * via msg.sender and msg.data, they should not be accessed in such a direct
593  * manner, since when dealing with meta-transactions the account sending and
594  * paying for execution may not be the actual sender (as far as an application
595  * is concerned).
596  *
597  * This contract is only required for intermediate, library-like contracts.
598  */
599 abstract contract Context {
600     function _msgSender() internal view virtual returns (address) {
601         return msg.sender;
602     }
603 
604     function _msgData() internal view virtual returns (bytes calldata) {
605         return msg.data;
606     }
607 }
608 
609 // File: erc721a/contracts/ERC721A.sol
610 
611 
612 // Creator: Chiru Labs
613 
614 pragma solidity ^0.8.4;
615 
616 error ApprovalCallerNotOwnerNorApproved();
617 error ApprovalQueryForNonexistentToken();
618 error ApproveToCaller();
619 error ApprovalToCurrentOwner();
620 error BalanceQueryForZeroAddress();
621 error MintedQueryForZeroAddress();
622 error BurnedQueryForZeroAddress();
623 error AuxQueryForZeroAddress();
624 error MintToZeroAddress();
625 error MintZeroQuantity();
626 error OwnerIndexOutOfBounds();
627 error OwnerQueryForNonexistentToken();
628 error TokenIndexOutOfBounds();
629 error TransferCallerNotOwnerNorApproved();
630 error TransferFromIncorrectOwner();
631 error TransferToNonERC721ReceiverImplementer();
632 error TransferToZeroAddress();
633 error URIQueryForNonexistentToken();
634 
635 /**
636  * @dev Implementation of //eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
637  * the Metadata extension. Built to optimize for lower gas during batch mints.
638  *
639  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
640  *
641  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
642  *
643  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
644  */
645 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
646     using Address for address;
647     using Strings for uint256;
648 
649     // Compiler will pack this into a single 256bit word.
650     struct TokenOwnership {
651         // The address of the owner.
652         address addr;
653         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
654         uint64 startTimestamp;
655         // Whether the token has been burned.
656         bool burned;
657     }
658 
659     // Compiler will pack this into a single 256bit word.
660     struct AddressData {
661         // Realistically, 2**64-1 is more than enough.
662         uint64 balance;
663         // Keeps track of mint count with minimal overhead for tokenomics.
664         uint64 numberMinted;
665         // Keeps track of burn count with minimal overhead for tokenomics.
666         uint64 numberBurned;
667         // For miscellaneous variable(s) pertaining to the address
668         // (e.g. number of whitelist mint slots used).
669         // If there are multiple variables, please pack them into a uint64.
670         uint64 aux;
671     }
672 
673     // The tokenId of the next token to be minted.
674     uint256 internal _currentIndex;
675 
676     // The number of tokens burned.
677     uint256 internal _burnCounter;
678 
679     // Token name
680     string private _name;
681 
682     // Token symbol
683     string private _symbol;
684 
685     // Mapping from token ID to ownership details
686     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
687     mapping(uint256 => TokenOwnership) internal _ownerships;
688 
689     // Mapping owner address to address data
690     mapping(address => AddressData) private _addressData;
691 
692     // Mapping from token ID to approved address
693     mapping(uint256 => address) private _tokenApprovals;
694 
695     // Mapping from owner to operator approvals
696     mapping(address => mapping(address => bool)) private _operatorApprovals;
697 
698     constructor(string memory name_, string memory symbol_) {
699         _name = name_;
700         _symbol = symbol_;
701         _currentIndex = _startTokenId();
702     }
703 
704     /**
705      * To change the starting tokenId, please override this function.
706      */
707     function _startTokenId() internal view virtual returns (uint256) {
708         return 1;
709     }
710 
711     /**
712      * @dev See {IERC721Enumerable-totalSupply}.
713      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
714      */
715     function totalSupply() public view returns (uint256) {
716         // Counter underflow is impossible as _burnCounter cannot be incremented
717         // more than _currentIndex - _startTokenId() times
718         unchecked {
719             return _currentIndex - _burnCounter - _startTokenId();
720         }
721     }
722 
723     /**
724      * Returns the total amount of tokens minted in the contract.
725      */
726     function _totalMinted() internal view returns (uint256) {
727         // Counter underflow is impossible as _currentIndex does not decrement,
728         // and it is initialized to _startTokenId()
729         unchecked {
730             return _currentIndex - _startTokenId();
731         }
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
738         return
739             interfaceId == type(IERC721).interfaceId ||
740             interfaceId == type(IERC721Metadata).interfaceId ||
741             super.supportsInterface(interfaceId);
742     }
743 
744     /**
745      * @dev See {IERC721-balanceOf}.
746      */
747     function balanceOf(address owner) public view override returns (uint256) {
748         if (owner == address(0)) revert BalanceQueryForZeroAddress();
749         return uint256(_addressData[owner].balance);
750     }
751 
752     /**
753      * Returns the number of tokens minted by `owner`.
754      */
755     function _numberMinted(address owner) internal view returns (uint256) {
756         if (owner == address(0)) revert MintedQueryForZeroAddress();
757         return uint256(_addressData[owner].numberMinted);
758     }
759 
760     /**
761      * Returns the number of tokens burned by or on behalf of `owner`.
762      */
763     function _numberBurned(address owner) internal view returns (uint256) {
764         if (owner == address(0)) revert BurnedQueryForZeroAddress();
765         return uint256(_addressData[owner].numberBurned);
766     }
767 
768     /**
769      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
770      */
771     function _getAux(address owner) internal view returns (uint64) {
772         if (owner == address(0)) revert AuxQueryForZeroAddress();
773         return _addressData[owner].aux;
774     }
775 
776     /**
777      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
778      * If there are multiple variables, please pack them into a uint64.
779      */
780     function _setAux(address owner, uint64 aux) internal {
781         if (owner == address(0)) revert AuxQueryForZeroAddress();
782         _addressData[owner].aux = aux;
783     }
784 
785     /**
786      * Gas spent here starts off proportional to the maximum mint batch size.
787      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
788      */
789     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
790         uint256 curr = tokenId;
791 
792         unchecked {
793             if (_startTokenId() <= curr && curr < _currentIndex) {
794                 TokenOwnership memory ownership = _ownerships[curr];
795                 if (!ownership.burned) {
796                     if (ownership.addr != address(0)) {
797                         return ownership;
798                     }
799                     // Invariant:
800                     // There will always be an ownership that has an address and is not burned
801                     // before an ownership that does not have an address and is not burned.
802                     // Hence, curr will not underflow.
803                     while (true) {
804                         curr--;
805                         ownership = _ownerships[curr];
806                         if (ownership.addr != address(0)) {
807                             return ownership;
808                         }
809                     }
810                 }
811             }
812         }
813         revert OwnerQueryForNonexistentToken();
814     }
815 
816     /**
817      * @dev See {IERC721-ownerOf}.
818      */
819     function ownerOf(uint256 tokenId) public view override returns (address) {
820         return ownershipOf(tokenId).addr;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-name}.
825      */
826     function name() public view virtual override returns (string memory) {
827         return _name;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-symbol}.
832      */
833     function symbol() public view virtual override returns (string memory) {
834         return _symbol;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-tokenURI}.
839      */
840     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
841         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
842 
843         string memory baseURI = _baseURI();
844         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
845     }
846 
847     /**
848      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
849      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
850      * by default, can be overriden in child contracts.
851      */
852     function _baseURI() internal view virtual returns (string memory) {
853         return '';
854     }
855 
856     /**
857      * @dev See {IERC721-approve}.
858      */
859     function approve(address to, uint256 tokenId) public override {
860         address owner = ERC721A.ownerOf(tokenId);
861         if (to == owner) revert ApprovalToCurrentOwner();
862 
863         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
864             revert ApprovalCallerNotOwnerNorApproved();
865         }
866 
867         _approve(to, tokenId, owner);
868     }
869 
870     /**
871      * @dev See {IERC721-getApproved}.
872      */
873     function getApproved(uint256 tokenId) public view override returns (address) {
874         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
875 
876         return _tokenApprovals[tokenId];
877     }
878 
879     /**
880      * @dev See {IERC721-setApprovalForAll}.
881      */
882     function setApprovalForAll(address operator, bool approved) public override {
883         if (operator == _msgSender()) revert ApproveToCaller();
884 
885         _operatorApprovals[_msgSender()][operator] = approved;
886         emit ApprovalForAll(_msgSender(), operator, approved);
887     }
888 
889     /**
890      * @dev See {IERC721-isApprovedForAll}.
891      */
892     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
893         return _operatorApprovals[owner][operator];
894     }
895 
896     /**
897      * @dev See {IERC721-transferFrom}.
898      */
899     function transferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) public virtual override {
904         _transfer(from, to, tokenId);
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         safeTransferFrom(from, to, tokenId, '');
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) public virtual override {
927         _transfer(from, to, tokenId);
928         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
929             revert TransferToNonERC721ReceiverImplementer();
930         }
931     }
932 
933     /**
934      * @dev Returns whether `tokenId` exists.
935      *
936      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
937      *
938      * Tokens start existing when they are minted (`_mint`),
939      */
940     function _exists(uint256 tokenId) internal view returns (bool) {
941         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
942             !_ownerships[tokenId].burned;
943     }
944 
945     function _safeMint(address to, uint256 quantity) internal {
946         _safeMint(to, quantity, '');
947     }
948 
949     /**
950      * @dev Safely mints `quantity` tokens and transfers them to `to`.
951      *
952      * Requirements:
953      *
954      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
955      * - `quantity` must be greater than 0.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _safeMint(
960         address to,
961         uint256 quantity,
962         bytes memory _data
963     ) internal {
964         _mint(to, quantity, _data, true);
965     }
966 
967     /**
968      * @dev Mints `quantity` tokens and transfers them to `to`.
969      *
970      * Requirements:
971      *
972      * - `to` cannot be the zero address.
973      * - `quantity` must be greater than 0.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _mint(
978         address to,
979         uint256 quantity,
980         bytes memory _data,
981         bool safe
982     ) internal {
983         uint256 startTokenId = _currentIndex;
984         if (to == address(0)) revert MintToZeroAddress();
985         if (quantity == 0) revert MintZeroQuantity();
986 
987         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
988 
989         // Overflows are incredibly unrealistic.
990         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
991         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
992         unchecked {
993             _addressData[to].balance += uint64(quantity);
994             _addressData[to].numberMinted += uint64(quantity);
995 
996             _ownerships[startTokenId].addr = to;
997             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
998 
999             uint256 updatedIndex = startTokenId;
1000             uint256 end = updatedIndex + quantity;
1001 
1002             if (safe && to.isContract()) {
1003                 do {
1004                     emit Transfer(address(0), to, updatedIndex);
1005                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1006                         revert TransferToNonERC721ReceiverImplementer();
1007                     }
1008                 } while (updatedIndex != end);
1009                 // Reentrancy protection
1010                 if (_currentIndex != startTokenId) revert();
1011             } else {
1012                 do {
1013                     emit Transfer(address(0), to, updatedIndex++);
1014                 } while (updatedIndex != end);
1015             }
1016             _currentIndex = updatedIndex;
1017         }
1018         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1019     }
1020 
1021     /**
1022      * @dev Transfers `tokenId` from `from` to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) private {
1036         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1037 
1038         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1039             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1040             getApproved(tokenId) == _msgSender());
1041 
1042         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1043         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1044         if (to == address(0)) revert TransferToZeroAddress();
1045 
1046         _beforeTokenTransfers(from, to, tokenId, 1);
1047 
1048         // Clear approvals from the previous owner
1049         _approve(address(0), tokenId, prevOwnership.addr);
1050 
1051         // Underflow of the sender's balance is impossible because we check for
1052         // ownership above and the recipient's balance can't realistically overflow.
1053         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1054         unchecked {
1055             _addressData[from].balance -= 1;
1056             _addressData[to].balance += 1;
1057 
1058             _ownerships[tokenId].addr = to;
1059             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1060 
1061             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1062             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1063             uint256 nextTokenId = tokenId + 1;
1064             if (_ownerships[nextTokenId].addr == address(0)) {
1065                 // This will suffice for checking _exists(nextTokenId),
1066                 // as a burned slot cannot contain the zero address.
1067                 if (nextTokenId < _currentIndex) {
1068                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1069                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1070                 }
1071             }
1072         }
1073 
1074         emit Transfer(from, to, tokenId);
1075         _afterTokenTransfers(from, to, tokenId, 1);
1076     }
1077 
1078     /**
1079      * @dev Destroys `tokenId`.
1080      * The approval is cleared when the token is burned.
1081      *
1082      * Requirements:
1083      *
1084      * - `tokenId` must exist.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _burn(uint256 tokenId) internal virtual {
1089         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1090 
1091         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId, prevOwnership.addr);
1095 
1096         // Underflow of the sender's balance is impossible because we check for
1097         // ownership above and the recipient's balance can't realistically overflow.
1098         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1099         unchecked {
1100             _addressData[prevOwnership.addr].balance -= 1;
1101             _addressData[prevOwnership.addr].numberBurned += 1;
1102 
1103             // Keep track of who burned the token, and the timestamp of burning.
1104             _ownerships[tokenId].addr = prevOwnership.addr;
1105             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1106             _ownerships[tokenId].burned = true;
1107 
1108             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1109             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1110             uint256 nextTokenId = tokenId + 1;
1111             if (_ownerships[nextTokenId].addr == address(0)) {
1112                 // This will suffice for checking _exists(nextTokenId),
1113                 // as a burned slot cannot contain the zero address.
1114                 if (nextTokenId < _currentIndex) {
1115                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1116                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1117                 }
1118             }
1119         }
1120 
1121         emit Transfer(prevOwnership.addr, address(0), tokenId);
1122         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1123 
1124         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1125         unchecked {
1126             _burnCounter++;
1127         }
1128     }
1129 
1130     /**
1131      * @dev Approve `to` to operate on `tokenId`
1132      *
1133      * Emits a {Approval} event.
1134      */
1135     function _approve(
1136         address to,
1137         uint256 tokenId,
1138         address owner
1139     ) private {
1140         _tokenApprovals[tokenId] = to;
1141         emit Approval(owner, to, tokenId);
1142     }
1143 
1144     /**
1145      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1146      *
1147      * @param from address representing the previous owner of the given token ID
1148      * @param to target address that will receive the tokens
1149      * @param tokenId uint256 ID of the token to be transferred
1150      * @param _data bytes optional data to send along with the call
1151      * @return bool whether the call correctly returned the expected magic value
1152      */
1153     function _checkContractOnERC721Received(
1154         address from,
1155         address to,
1156         uint256 tokenId,
1157         bytes memory _data
1158     ) private returns (bool) {
1159         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1160             return retval == IERC721Receiver(to).onERC721Received.selector;
1161         } catch (bytes memory reason) {
1162             if (reason.length == 0) {
1163                 revert TransferToNonERC721ReceiverImplementer();
1164             } else {
1165                 assembly {
1166                     revert(add(32, reason), mload(reason))
1167                 }
1168             }
1169         }
1170     }
1171 
1172     /**
1173      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1174      * And also called before burning one token.
1175      *
1176      * startTokenId - the first token id to be transferred
1177      * quantity - the amount to be transferred
1178      *
1179      * Calling conditions:
1180      *
1181      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1182      * transferred to `to`.
1183      * - When `from` is zero, `tokenId` will be minted for `to`.
1184      * - When `to` is zero, `tokenId` will be burned by `from`.
1185      * - `from` and `to` are never both zero.
1186      */
1187     function _beforeTokenTransfers(
1188         address from,
1189         address to,
1190         uint256 startTokenId,
1191         uint256 quantity
1192     ) internal virtual {}
1193 
1194     /**
1195      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1196      * minting.
1197      * And also called after one token has been burned.
1198      *
1199      * startTokenId - the first token id to be transferred
1200      * quantity - the amount to be transferred
1201      *
1202      * Calling conditions:
1203      *
1204      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1205      * transferred to `to`.
1206      * - When `from` is zero, `tokenId` has been minted for `to`.
1207      * - When `to` is zero, `tokenId` has been burned by `from`.
1208      * - `from` and `to` are never both zero.
1209      */
1210     function _afterTokenTransfers(
1211         address from,
1212         address to,
1213         uint256 startTokenId,
1214         uint256 quantity
1215     ) internal virtual {}
1216 }
1217 
1218 // File: @openzeppelin/contracts/access/Ownable.sol
1219 
1220 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1221 
1222 pragma solidity ^0.8.0;
1223 
1224 
1225 /**
1226  * @dev Contract module which provides a basic access control mechanism, where
1227  * there is an account (an owner) that can be granted exclusive access to
1228  * specific functions.
1229  *
1230  * By default, the owner account will be the one that deploys the contract. This
1231  * can later be changed with {transferOwnership}.
1232  *
1233  * This module is used through inheritance. It will make available the modifier
1234  * `onlyOwner`, which can be applied to your functions to restrict their use to
1235  * the owner.
1236  */
1237 abstract contract Ownable is Context {
1238     address private _owner;
1239 
1240     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1241 
1242     /**
1243      * @dev Initializes the contract setting the deployer as the initial owner.
1244      */
1245     constructor() {
1246         _transferOwnership(_msgSender());
1247     }
1248 
1249     /**
1250      * @dev Returns the address of the current owner.
1251      */
1252     function owner() public view virtual returns (address) {
1253         return _owner;
1254     }
1255 
1256     /**
1257      * @dev Throws if called by any account other than the owner.
1258      */
1259     modifier onlyOwner() {
1260         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1261         _;
1262     }
1263 
1264     /**
1265      * @dev Leaves the contract without owner. It will not be possible to call
1266      * `onlyOwner` functions anymore. Can only be called by the current owner.
1267      *
1268      * NOTE: Renouncing ownership will leave the contract without an owner,
1269      * thereby removing any functionality that is only available to the owner.
1270      */
1271     function renounceOwnership() public virtual onlyOwner {
1272         _transferOwnership(address(0));
1273     }
1274 
1275     /**
1276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1277      * Can only be called by the current owner.
1278      */
1279     function transferOwnership(address newOwner) public virtual onlyOwner {
1280         require(newOwner != address(0), "Ownable: new owner is the zero address");
1281         _transferOwnership(newOwner);
1282     }
1283 
1284     /**
1285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1286      * Internal function without access restriction.
1287      */
1288     function _transferOwnership(address newOwner) internal virtual {
1289         address oldOwner = _owner;
1290         _owner = newOwner;
1291         emit OwnershipTransferred(oldOwner, newOwner);
1292     }
1293 }
1294 
1295 pragma solidity ^0.8.4;
1296 
1297 contract MetaPunks is ERC721A, Ownable {
1298 
1299     uint256 constant public maxSupply = 5000;
1300     uint256 public mintPrice = 0.00 ether;
1301     uint256 constant public MaxMintPerTx = 3;
1302     uint256 constant public MaxMintPerWallet = 6; 
1303     uint256 constant public MaxFreeMintPerWallet = 6;
1304 
1305     bool public isSaleLive = true;
1306     string public baseURI = "ipfs://QmbXNxWwuLoiP7rCvjoULnCuSx5ouh6hConjCkeHPdR31K/";
1307      mapping(address => uint) public addressClaimed;
1308 
1309     constructor() ERC721A("Meta Punks", "Metapunks") {}
1310 
1311     function mint(uint256 quantity) external payable {
1312         require(quantity > 0 && quantity <= MaxMintPerTx, "Invalid quantity");
1313         uint256 supply = totalSupply();
1314         require(supply + quantity <= maxSupply, "Max amount of tokens minted");
1315         require(addressClaimed[_msgSender()] + quantity <= MaxMintPerWallet, "You have already received your Tokens");
1316         require(msg.value >= quantity * mintPrice, "Insufficient value to mint");
1317         addressClaimed[_msgSender()] += quantity;
1318         _safeMint(msg.sender, quantity);
1319     }
1320     
1321     function freemint(uint256 quantity) external {
1322         require(quantity <= MaxFreeMintPerWallet, "Invalid quantity");
1323         uint256 supply = totalSupply();
1324         require(supply + quantity <= maxSupply, "Max amount of tokens minted");
1325         require(addressClaimed[_msgSender()] + quantity <= MaxFreeMintPerWallet, "You have already received your Tokens");
1326         addressClaimed[_msgSender()] += quantity;
1327         _safeMint(msg.sender, quantity);
1328     }
1329 
1330     function ownerMint(address to, uint256 quantity) external onlyOwner {
1331         require(totalSupply() + quantity <= maxSupply, "Minting exceeds max supply");
1332         require(quantity > 0, "Quantity less than 1");
1333 
1334         _safeMint(to, quantity);
1335     }
1336 
1337     function toggleSaleStatus() external onlyOwner {
1338         isSaleLive = !isSaleLive;
1339     }
1340 
1341     function setMintPrice(uint256 _MintPrice) external onlyOwner {
1342         mintPrice = _MintPrice;
1343     }
1344 
1345     function withdrawAll() external onlyOwner {
1346         payable(owner()).transfer(address(this).balance);
1347     }
1348 
1349     function setBaseURI(string calldata newURI) external onlyOwner {
1350         baseURI = newURI;
1351     }
1352 
1353     function _baseURI() internal view override returns (string memory) {
1354         return baseURI;
1355     }
1356 }