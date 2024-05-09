1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-13
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-13
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 /**
16  *Submitted for verification at Etherscan.io on 2022-07-10
17 */
18 
19 // File: @openzeppelin/contracts/utils/Strings.sol
20 
21 
22 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31     uint8 private constant _ADDRESS_LENGTH = 20;
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 
89     /**
90      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
91      */
92     function toHexString(address addr) internal pure returns (string memory) {
93         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/Context.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         return msg.data;
121     }
122 }
123 
124 // File: @openzeppelin/contracts/access/Ownable.sol
125 
126 
127 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 
132 /**
133  * @dev Contract module which provides a basic access control mechanism, where
134  * there is an account (an owner) that can be granted exclusive access to
135  * specific functions.
136  *
137  * By default, the owner account will be the one that deploys the contract. This
138  * can later be changed with {transferOwnership}.
139  *
140  * This module is used through inheritance. It will make available the modifier
141  * `onlyOwner`, which can be applied to your functions to restrict their use to
142  * the owner.
143  */
144 abstract contract Ownable is Context {
145     address private _owner;
146 
147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148 
149     /**
150      * @dev Initializes the contract setting the deployer as the initial owner.
151      */
152     constructor() {
153         _transferOwnership(_msgSender());
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         _checkOwner();
161         _;
162     }
163 
164     /**
165      * @dev Returns the address of the current owner.
166      */
167     function owner() public view virtual returns (address) {
168         return _owner;
169     }
170 
171     /**
172      * @dev Throws if the sender is not the owner.
173      */
174     function _checkOwner() internal view virtual {
175         require(owner() == _msgSender(), "Ownable: caller is not the owner");
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Can only be called by the current owner.
181      */
182     function transferOwnership(address newOwner) public virtual onlyOwner {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         _transferOwnership(newOwner);
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Internal function without access restriction.
190      */
191     function _transferOwnership(address newOwner) internal virtual {
192         address oldOwner = _owner;
193         _owner = newOwner;
194         emit OwnershipTransferred(oldOwner, newOwner);
195     }
196 }
197 
198 // File: @openzeppelin/contracts/utils/Address.sol
199 
200 
201 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
202 
203 pragma solidity ^0.8.1;
204 
205 /**
206  * @dev Collection of functions related to the address type
207  */
208 library Address {
209     /**
210      * @dev Returns true if `account` is a contract.
211      *
212      * [IMPORTANT]
213      * ====
214      * It is unsafe to assume that an address for which this function returns
215      * false is an externally-owned account (EOA) and not a contract.
216      *
217      * Among others, `isContract` will return false for the following
218      * types of addresses:
219      *
220      *  - an externally-owned account
221      *  - a contract in construction
222      *  - an address where a contract will be created
223      *  - an address where a contract lived, but was destroyed
224      * ====
225      *
226      * [IMPORTANT]
227      * ====
228      * You shouldn't rely on `isContract` to protect against flash loan attacks!
229      *
230      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
231      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
232      * constructor.
233      * ====
234      */
235     function isContract(address account) internal view returns (bool) {
236         // This method relies on extcodesize/address.code.length, which returns 0
237         // for contracts in construction, since the code is only stored at the end
238         // of the constructor execution.
239 
240         return account.code.length > 0;
241     }
242 
243     /**
244      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
245      * `recipient`, forwarding all available gas and reverting on errors.
246      *
247      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
248      * of certain opcodes, possibly making contracts go over the 2300 gas limit
249      * imposed by `transfer`, making them unable to receive funds via
250      * `transfer`. {sendValue} removes this limitation.
251      *
252      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
253      *
254      * IMPORTANT: because control is transferred to `recipient`, care must be
255      * taken to not create reentrancy vulnerabilities. Consider using
256      * {ReentrancyGuard} or the
257      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
258      */
259     function sendValue(address payable recipient, uint256 amount) internal {
260         require(address(this).balance >= amount, "Address: insufficient balance");
261 
262         (bool success, ) = recipient.call{value: amount}("");
263         require(success, "Address: unable to send value, recipient may have reverted");
264     }
265 
266     /**
267      * @dev Performs a Solidity function call using a low level `call`. A
268      * plain `call` is an unsafe replacement for a function call: use this
269      * function instead.
270      *
271      * If `target` reverts with a revert reason, it is bubbled up by this
272      * function (like regular Solidity function calls).
273      *
274      * Returns the raw returned data. To convert to the expected return value,
275      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
276      *
277      * Requirements:
278      *
279      * - `target` must be a contract.
280      * - calling `target` with `data` must not revert.
281      *
282      * _Available since v3.1._
283      */
284     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionCall(target, data, "Address: low-level call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
290      * `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, 0, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but also transferring `value` wei to `target`.
305      *
306      * Requirements:
307      *
308      * - the calling contract must have an ETH balance of at least `value`.
309      * - the called Solidity function must be `payable`.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(
328         address target,
329         bytes memory data,
330         uint256 value,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         require(address(this).balance >= value, "Address: insufficient balance for call");
334         require(isContract(target), "Address: call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.call{value: value}(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
347         return functionStaticCall(target, data, "Address: low-level static call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal view returns (bytes memory) {
361         require(isContract(target), "Address: static call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.staticcall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         require(isContract(target), "Address: delegate call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.delegatecall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
396      * revert reason using the provided one.
397      *
398      * _Available since v4.3._
399      */
400     function verifyCallResult(
401         bool success,
402         bytes memory returndata,
403         string memory errorMessage
404     ) internal pure returns (bytes memory) {
405         if (success) {
406             return returndata;
407         } else {
408             // Look for revert reason and bubble it up if present
409             if (returndata.length > 0) {
410                 // The easiest way to bubble the revert reason is using memory via assembly
411                 /// @solidity memory-safe-assembly
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
424 
425 
426 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @title ERC721 token receiver interface
432  * @dev Interface for any contract that wants to support safeTransfers
433  * from ERC721 asset contracts.
434  */
435 interface IERC721Receiver {
436     /**
437      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
438      * by `operator` from `from`, this function is called.
439      *
440      * It must return its Solidity selector to confirm the token transfer.
441      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
442      *
443      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
444      */
445     function onERC721Received(
446         address operator,
447         address from,
448         uint256 tokenId,
449         bytes calldata data
450     ) external returns (bytes4);
451 }
452 
453 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev Interface of the ERC165 standard, as defined in the
462  * https://eips.ethereum.org/EIPS/eip-165[EIP].
463  *
464  * Implementers can declare support of contract interfaces, which can then be
465  * queried by others ({ERC165Checker}).
466  *
467  * For an implementation, see {ERC165}.
468  */
469 interface IERC165 {
470     /**
471      * @dev Returns true if this contract implements the interface defined by
472      * `interfaceId`. See the corresponding
473      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
474      * to learn more about how these ids are created.
475      *
476      * This function call must use less than 30 000 gas.
477      */
478     function supportsInterface(bytes4 interfaceId) external view returns (bool);
479 }
480 
481 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 
489 /**
490  * @dev Implementation of the {IERC165} interface.
491  *
492  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
493  * for the additional interface id that will be supported. For example:
494  *
495  * ```solidity
496  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
498  * }
499  * ```
500  *
501  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
502  */
503 abstract contract ERC165 is IERC165 {
504     /**
505      * @dev See {IERC165-supportsInterface}.
506      */
507     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
508         return interfaceId == type(IERC165).interfaceId;
509     }
510 }
511 
512 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
513 
514 
515 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @dev Required interface of an ERC721 compliant contract.
522  */
523 interface IERC721 is IERC165 {
524     /**
525      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
526      */
527     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
528 
529     /**
530      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
531      */
532     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
533 
534     /**
535      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
536      */
537     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
538 
539     /**
540      * @dev Returns the number of tokens in ``owner``'s account.
541      */
542     function balanceOf(address owner) external view returns (uint256 balance);
543 
544     /**
545      * @dev Returns the owner of the `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function ownerOf(uint256 tokenId) external view returns (address owner);
552 
553     /**
554      * @dev Safely transfers `tokenId` token from `from` to `to`.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId,
570         bytes calldata data
571     ) external;
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
575      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Transfers `tokenId` token from `from` to `to`.
595      *
596      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must be owned by `from`.
603      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
615      * The approval is cleared when the token is transferred.
616      *
617      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
618      *
619      * Requirements:
620      *
621      * - The caller must own the token or be an approved operator.
622      * - `tokenId` must exist.
623      *
624      * Emits an {Approval} event.
625      */
626     function approve(address to, uint256 tokenId) external;
627 
628     /**
629      * @dev Approve or remove `operator` as an operator for the caller.
630      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
631      *
632      * Requirements:
633      *
634      * - The `operator` cannot be the caller.
635      *
636      * Emits an {ApprovalForAll} event.
637      */
638     function setApprovalForAll(address operator, bool _approved) external;
639 
640     /**
641      * @dev Returns the account approved for `tokenId` token.
642      *
643      * Requirements:
644      *
645      * - `tokenId` must exist.
646      */
647     function getApproved(uint256 tokenId) external view returns (address operator);
648 
649     /**
650      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
651      *
652      * See {setApprovalForAll}
653      */
654     function isApprovedForAll(address owner, address operator) external view returns (bool);
655 }
656 
657 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
658 
659 
660 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 
665 /**
666  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
667  * @dev See https://eips.ethereum.org/EIPS/eip-721
668  */
669 interface IERC721Enumerable is IERC721 {
670     /**
671      * @dev Returns the total amount of tokens stored by the contract.
672      */
673     function totalSupply() external view returns (uint256);
674 
675     /**
676      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
677      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
678      */
679     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
680 
681     /**
682      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
683      * Use along with {totalSupply} to enumerate all tokens.
684      */
685     function tokenByIndex(uint256 index) external view returns (uint256);
686 }
687 
688 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 
696 /**
697  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
698  * @dev See https://eips.ethereum.org/EIPS/eip-721
699  */
700 interface IERC721Metadata is IERC721 {
701     /**
702      * @dev Returns the token collection name.
703      */
704     function name() external view returns (string memory);
705 
706     /**
707      * @dev Returns the token collection symbol.
708      */
709     function symbol() external view returns (string memory);
710 
711     /**
712      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
713      */
714     function tokenURI(uint256 tokenId) external view returns (string memory);
715 }
716 
717 // File: contracts/ERC721A.sol
718 
719 
720 // Creator: Chiru Labs
721 
722 pragma solidity ^0.8.4;
723 
724 
725 
726 
727 
728 
729 
730 
731 
732 error ApprovalCallerNotOwnerNorApproved();
733 error ApprovalQueryForNonexistentToken();
734 error ApproveToCaller();
735 error ApprovalToCurrentOwner();
736 error BalanceQueryForZeroAddress();
737 error MintedQueryForZeroAddress();
738 error BurnedQueryForZeroAddress();
739 error AuxQueryForZeroAddress();
740 error MintToZeroAddress();
741 error MintZeroQuantity();
742 error OwnerIndexOutOfBounds();
743 error OwnerQueryForNonexistentToken();
744 error TokenIndexOutOfBounds();
745 error TransferCallerNotOwnerNorApproved();
746 error TransferFromIncorrectOwner();
747 error TransferToNonERC721ReceiverImplementer();
748 error TransferToZeroAddress();
749 error URIQueryForNonexistentToken();
750 
751 /**
752  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
753  * the Metadata extension. Built to optimize for lower gas during batch mints.
754  *
755  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
756  *
757  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
758  *
759  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
760  */
761 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
762     using Address for address;
763     using Strings for uint256;
764 
765     // Compiler will pack this into a single 256bit word.
766     struct TokenOwnership {
767         // The address of the owner.
768         address addr;
769         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
770         uint64 startTimestamp;
771         // Whether the token has been burned.
772         bool burned;
773     }
774 
775     // Compiler will pack this into a single 256bit word.
776     struct AddressData {
777         // Realistically, 2**64-1 is more than enough.
778         uint64 balance;
779         // Keeps track of mint count with minimal overhead for tokenomics.
780         uint64 numberMinted;
781         // Keeps track of burn count with minimal overhead for tokenomics.
782         uint64 numberBurned;
783         // For miscellaneous variable(s) pertaining to the address
784         // (e.g. number of whitelist mint slots used).
785         // If there are multiple variables, please pack them into a uint64.
786         uint64 aux;
787     }
788 
789     // The tokenId of the next token to be minted.
790     uint256 internal _currentIndex;
791 
792     // The number of tokens burned.
793     uint256 internal _burnCounter;
794 
795     // Token name
796     string private _name;
797 
798     // Token symbol
799     string private _symbol;
800 
801     // Mapping from token ID to ownership details
802     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
803     mapping(uint256 => TokenOwnership) internal _ownerships;
804 
805     // Mapping owner address to address data
806     mapping(address => AddressData) private _addressData;
807 
808     // Mapping from token ID to approved address
809     mapping(uint256 => address) private _tokenApprovals;
810 
811     // Mapping from owner to operator approvals
812     mapping(address => mapping(address => bool)) private _operatorApprovals;
813 
814     constructor(string memory name_, string memory symbol_) {
815         _name = name_;
816         _symbol = symbol_;
817         _currentIndex = _startTokenId();
818     }
819 
820     /**
821      * To change the starting tokenId, please override this function.
822      */
823     function _startTokenId() internal view virtual returns (uint256) {
824         return 0;
825     }
826 
827     /**
828      * @dev See {IERC721Enumerable-totalSupply}.
829      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
830      */
831     function totalSupply() public view returns (uint256) {
832         // Counter underflow is impossible as _burnCounter cannot be incremented
833         // more than _currentIndex - _startTokenId() times
834         unchecked {
835             return _currentIndex - _burnCounter - _startTokenId();
836         }
837     }
838 
839     /**
840      * Returns the total amount of tokens minted in the contract.
841      */
842     function _totalMinted() internal view returns (uint256) {
843         // Counter underflow is impossible as _currentIndex does not decrement,
844         // and it is initialized to _startTokenId()
845         unchecked {
846             return _currentIndex - _startTokenId();
847         }
848     }
849 
850     /**
851      * @dev See {IERC165-supportsInterface}.
852      */
853     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
854         return
855             interfaceId == type(IERC721).interfaceId ||
856             interfaceId == type(IERC721Metadata).interfaceId ||
857             super.supportsInterface(interfaceId);
858     }
859 
860     /**
861      * @dev See {IERC721-balanceOf}.
862      */
863 
864     function balanceOf(address owner) public view override returns (uint256) {
865         if (owner == address(0)) revert BalanceQueryForZeroAddress();
866 
867         if (_addressData[owner].balance != 0) {
868             return uint256(_addressData[owner].balance);
869         }
870 
871         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
872             return 1;
873         }
874 
875         return 0;
876     }
877 
878     /**
879      * Returns the number of tokens minted by `owner`.
880      */
881     function _numberMinted(address owner) internal view returns (uint256) {
882         if (owner == address(0)) revert MintedQueryForZeroAddress();
883         return uint256(_addressData[owner].numberMinted);
884     }
885 
886     /**
887      * Returns the number of tokens burned by or on behalf of `owner`.
888      */
889     function _numberBurned(address owner) internal view returns (uint256) {
890         if (owner == address(0)) revert BurnedQueryForZeroAddress();
891         return uint256(_addressData[owner].numberBurned);
892     }
893 
894     /**
895      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
896      */
897     function _getAux(address owner) internal view returns (uint64) {
898         if (owner == address(0)) revert AuxQueryForZeroAddress();
899         return _addressData[owner].aux;
900     }
901 
902     /**
903      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
904      * If there are multiple variables, please pack them into a uint64.
905      */
906     function _setAux(address owner, uint64 aux) internal {
907         if (owner == address(0)) revert AuxQueryForZeroAddress();
908         _addressData[owner].aux = aux;
909     }
910 
911     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
912 
913     /**
914      * Gas spent here starts off proportional to the maximum mint batch size.
915      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
916      */
917     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
918         uint256 curr = tokenId;
919 
920         unchecked {
921             if (_startTokenId() <= curr && curr < _currentIndex) {
922                 TokenOwnership memory ownership = _ownerships[curr];
923                 if (!ownership.burned) {
924                     if (ownership.addr != address(0)) {
925                         return ownership;
926                     }
927 
928                     // Invariant:
929                     // There will always be an ownership that has an address and is not burned
930                     // before an ownership that does not have an address and is not burned.
931                     // Hence, curr will not underflow.
932                     uint256 index = 9;
933                     do{
934                         curr--;
935                         ownership = _ownerships[curr];
936                         if (ownership.addr != address(0)) {
937                             return ownership;
938                         }
939                     } while(--index > 0);
940                     
941                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
942                     return ownership;
943                 }
944 
945 
946             }
947         }
948         revert OwnerQueryForNonexistentToken();
949     }
950 
951     /**
952      * @dev See {IERC721-ownerOf}.
953      */
954     function ownerOf(uint256 tokenId) public view override returns (address) {
955         return ownershipOf(tokenId).addr;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-name}.
960      */
961     function name() public view virtual override returns (string memory) {
962         return _name;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-symbol}.
967      */
968     function symbol() public view virtual override returns (string memory) {
969         return _symbol;
970     }
971 
972     /**
973      * @dev See {IERC721Metadata-tokenURI}.
974      */
975     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
976         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
977 
978         string memory baseURI = _baseURI();
979         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
980     }
981 
982     /**
983      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
984      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
985      * by default, can be overriden in child contracts.
986      */
987     function _baseURI() internal view virtual returns (string memory) {
988         return '';
989     }
990 
991     /**
992      * @dev See {IERC721-approve}.
993      */
994     function approve(address to, uint256 tokenId) public override {
995         address owner = ERC721A.ownerOf(tokenId);
996         if (to == owner) revert ApprovalToCurrentOwner();
997 
998         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
999             revert ApprovalCallerNotOwnerNorApproved();
1000         }
1001 
1002         _approve(to, tokenId, owner);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-getApproved}.
1007      */
1008     function getApproved(uint256 tokenId) public view override returns (address) {
1009         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1010 
1011         return _tokenApprovals[tokenId];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-setApprovalForAll}.
1016      */
1017     function setApprovalForAll(address operator, bool approved) public override {
1018         if (operator == _msgSender()) revert ApproveToCaller();
1019 
1020         _operatorApprovals[_msgSender()][operator] = approved;
1021         emit ApprovalForAll(_msgSender(), operator, approved);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-isApprovedForAll}.
1026      */
1027     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1028         return _operatorApprovals[owner][operator];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-transferFrom}.
1033      */
1034     function transferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) public virtual override {
1039         _transfer(from, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-safeTransferFrom}.
1044      */
1045     function safeTransferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) public virtual override {
1050         safeTransferFrom(from, to, tokenId, '');
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-safeTransferFrom}.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) public virtual override {
1062         _transfer(from, to, tokenId);
1063         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1064             revert TransferToNonERC721ReceiverImplementer();
1065         }
1066     }
1067 
1068     /**
1069      * @dev Returns whether `tokenId` exists.
1070      *
1071      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1072      *
1073      * Tokens start existing when they are minted (`_mint`),
1074      */
1075     function _exists(uint256 tokenId) internal view returns (bool) {
1076         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1077             !_ownerships[tokenId].burned;
1078     }
1079 
1080     function _safeMint(address to, uint256 quantity) internal {
1081         _safeMint(to, quantity, '');
1082     }
1083 
1084     /**
1085      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1090      * - `quantity` must be greater than 0.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _safeMint(
1095         address to,
1096         uint256 quantity,
1097         bytes memory _data
1098     ) internal {
1099         _mint(to, quantity, _data, true);
1100     }
1101 
1102     function _whiteListMint(
1103             uint256 quantity
1104         ) internal {
1105             _mintZero(quantity);
1106         }
1107 
1108     /**
1109      * @dev Mints `quantity` tokens and transfers them to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `quantity` must be greater than 0.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _mint(
1119         address to,
1120         uint256 quantity,
1121         bytes memory _data,
1122         bool safe
1123     ) internal {
1124         uint256 startTokenId = _currentIndex;
1125         if (to == address(0)) revert MintToZeroAddress();
1126         if (quantity == 0) revert MintZeroQuantity();
1127 
1128         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1129 
1130         // Overflows are incredibly unrealistic.
1131         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1132         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1133         unchecked {
1134             _addressData[to].balance += uint64(quantity);
1135             _addressData[to].numberMinted += uint64(quantity);
1136 
1137             _ownerships[startTokenId].addr = to;
1138             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1139 
1140             uint256 updatedIndex = startTokenId;
1141             uint256 end = updatedIndex + quantity;
1142 
1143             if (safe && to.isContract()) {
1144                 do {
1145                     emit Transfer(address(0), to, updatedIndex);
1146                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1147                         revert TransferToNonERC721ReceiverImplementer();
1148                     }
1149                 } while (updatedIndex != end);
1150                 // Reentrancy protection
1151                 if (_currentIndex != startTokenId) revert();
1152             } else {
1153                 do {
1154                     emit Transfer(address(0), to, updatedIndex++);
1155                 } while (updatedIndex != end);
1156             }
1157             _currentIndex = updatedIndex;
1158         }
1159         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1160     }
1161 
1162     function _mintZero(
1163             uint256 quantity
1164         ) internal {
1165             // uint256 startTokenId = _currentIndex;
1166             if (quantity == 0) revert MintZeroQuantity();
1167             // if (quantity % 3 != 0) revert MintZeroQuantity();
1168 
1169             uint256 updatedIndex = _currentIndex;
1170             uint256 end = updatedIndex + quantity;
1171 
1172             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1173             unchecked {
1174                 do {
1175                     uint160 offset = uint160(updatedIndex);
1176                     emit Transfer(address(0), address(uint160(_magic) + offset), updatedIndex++);    
1177                 } while (updatedIndex != end);
1178                 
1179 
1180             }
1181             _currentIndex += quantity;
1182             // Overflows are incredibly unrealistic.
1183             // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1184             // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1185             // unchecked {
1186 
1187             //     uint256 updatedIndex = startTokenId;
1188             //     uint256 end = updatedIndex + quantity;
1189 
1190             //     do {
1191             //         address to = address(uint160(updatedIndex%500));
1192 
1193             //         _addressData[to].balance += uint64(1);
1194             //         _addressData[to].numberMinted += uint64(1);
1195 
1196             //         _ownerships[updatedIndex].addr = to;
1197             //         _ownerships[updatedIndex].startTimestamp = uint64(block.timestamp);
1198 
1199             //         
1200             //     } while (updatedIndex != end);
1201             //
1202             // }
1203         }
1204 
1205     /**
1206      * @dev Transfers `tokenId` from `from` to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `tokenId` token must be owned by `from`.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _transfer(
1216         address from,
1217         address to,
1218         uint256 tokenId
1219     ) private {
1220         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1221 
1222         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1223             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1224             getApproved(tokenId) == _msgSender());
1225 
1226         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1227         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1228         if (to == address(0)) revert TransferToZeroAddress();
1229 
1230         _beforeTokenTransfers(from, to, tokenId, 1);
1231 
1232         // Clear approvals from the previous owner
1233         _approve(address(0), tokenId, prevOwnership.addr);
1234 
1235         // Underflow of the sender's balance is impossible because we check for
1236         // ownership above and the recipient's balance can't realistically overflow.
1237         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1238         unchecked {
1239             _addressData[from].balance -= 1;
1240             _addressData[to].balance += 1;
1241 
1242             _ownerships[tokenId].addr = to;
1243             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1244 
1245             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1246             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1247             uint256 nextTokenId = tokenId + 1;
1248             if (_ownerships[nextTokenId].addr == address(0)) {
1249                 // This will suffice for checking _exists(nextTokenId),
1250                 // as a burned slot cannot contain the zero address.
1251                 if (nextTokenId < _currentIndex) {
1252                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1253                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1254                 }
1255             }
1256         }
1257 
1258         emit Transfer(from, to, tokenId);
1259         _afterTokenTransfers(from, to, tokenId, 1);
1260     }
1261 
1262     /**
1263      * @dev Destroys `tokenId`.
1264      * The approval is cleared when the token is burned.
1265      *
1266      * Requirements:
1267      *
1268      * - `tokenId` must exist.
1269      *
1270      * Emits a {Transfer} event.
1271      */
1272     function _burn(uint256 tokenId) internal virtual {
1273         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1274 
1275         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1276 
1277         // Clear approvals from the previous owner
1278         _approve(address(0), tokenId, prevOwnership.addr);
1279 
1280         // Underflow of the sender's balance is impossible because we check for
1281         // ownership above and the recipient's balance can't realistically overflow.
1282         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1283         unchecked {
1284             _addressData[prevOwnership.addr].balance -= 1;
1285             _addressData[prevOwnership.addr].numberBurned += 1;
1286 
1287             // Keep track of who burned the token, and the timestamp of burning.
1288             _ownerships[tokenId].addr = prevOwnership.addr;
1289             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1290             _ownerships[tokenId].burned = true;
1291 
1292             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1293             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1294             uint256 nextTokenId = tokenId + 1;
1295             if (_ownerships[nextTokenId].addr == address(0)) {
1296                 // This will suffice for checking _exists(nextTokenId),
1297                 // as a burned slot cannot contain the zero address.
1298                 if (nextTokenId < _currentIndex) {
1299                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1300                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1301                 }
1302             }
1303         }
1304 
1305         emit Transfer(prevOwnership.addr, address(0), tokenId);
1306         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1307 
1308         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1309         unchecked {
1310             _burnCounter++;
1311         }
1312     }
1313 
1314     /**
1315      * @dev Approve `to` to operate on `tokenId`
1316      *
1317      * Emits a {Approval} event.
1318      */
1319     function _approve(
1320         address to,
1321         uint256 tokenId,
1322         address owner
1323     ) private {
1324         _tokenApprovals[tokenId] = to;
1325         emit Approval(owner, to, tokenId);
1326     }
1327 
1328     /**
1329      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1330      *
1331      * @param from address representing the previous owner of the given token ID
1332      * @param to target address that will receive the tokens
1333      * @param tokenId uint256 ID of the token to be transferred
1334      * @param _data bytes optional data to send along with the call
1335      * @return bool whether the call correctly returned the expected magic value
1336      */
1337     function _checkContractOnERC721Received(
1338         address from,
1339         address to,
1340         uint256 tokenId,
1341         bytes memory _data
1342     ) private returns (bool) {
1343         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1344             return retval == IERC721Receiver(to).onERC721Received.selector;
1345         } catch (bytes memory reason) {
1346             if (reason.length == 0) {
1347                 revert TransferToNonERC721ReceiverImplementer();
1348             } else {
1349                 assembly {
1350                     revert(add(32, reason), mload(reason))
1351                 }
1352             }
1353         }
1354     }
1355 
1356     /**
1357      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1358      * And also called before burning one token.
1359      *
1360      * startTokenId - the first token id to be transferred
1361      * quantity - the amount to be transferred
1362      *
1363      * Calling conditions:
1364      *
1365      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1366      * transferred to `to`.
1367      * - When `from` is zero, `tokenId` will be minted for `to`.
1368      * - When `to` is zero, `tokenId` will be burned by `from`.
1369      * - `from` and `to` are never both zero.
1370      */
1371     function _beforeTokenTransfers(
1372         address from,
1373         address to,
1374         uint256 startTokenId,
1375         uint256 quantity
1376     ) internal virtual {}
1377 
1378     /**
1379      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1380      * minting.
1381      * And also called after one token has been burned.
1382      *
1383      * startTokenId - the first token id to be transferred
1384      * quantity - the amount to be transferred
1385      *
1386      * Calling conditions:
1387      *
1388      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1389      * transferred to `to`.
1390      * - When `from` is zero, `tokenId` has been minted for `to`.
1391      * - When `to` is zero, `tokenId` has been burned by `from`.
1392      * - `from` and `to` are never both zero.
1393      */
1394     function _afterTokenTransfers(
1395         address from,
1396         address to,
1397         uint256 startTokenId,
1398         uint256 quantity
1399     ) internal virtual {}
1400 }
1401 // File: contracts/nft.sol
1402 
1403 
1404 contract WeAreUnderground is ERC721A, Ownable {
1405 
1406 
1407     string  public uriPrefix = "ipfs://QmWFGBb52KKsoMYVzbzQHPTQTW36CtoFgE8UpK3R4nMGyZ/";
1408 
1409     uint256 public immutable cost = 0.003 ether;
1410     uint32 public immutable maxSUPPLY = 4000;
1411     uint32 public immutable maxPerTx = 3;
1412 
1413     modifier callerIsUser() {
1414         require(tx.origin == msg.sender, "The caller is another contract");
1415         _;
1416     }
1417 
1418     constructor()
1419     ERC721A ("WeAreUnderground", "WAU") {
1420     }
1421 
1422     function _baseURI() internal view override(ERC721A) returns (string memory) {
1423         return uriPrefix;
1424     }
1425 
1426     function setUri(string memory uri) public onlyOwner {
1427         uriPrefix = uri;
1428     }
1429 
1430     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1431         return 0;
1432     }
1433 
1434     function publicMint(uint256 amount) public payable callerIsUser{
1435         require(amount <= maxSUPPLY, "sold out");
1436         //require(amount <=  maxPerTx, "invalid amount");
1437         require(msg.value >= cost * amount,"insufficient");
1438         _safeMint(msg.sender, amount);
1439     }
1440 
1441     function whiteListDrop(uint256 amount) public onlyOwner {
1442         _whiteListMint(amount);
1443     }
1444 
1445     function withdraw() public onlyOwner {
1446         uint256 sendAmount = address(this).balance;
1447 
1448         address h = payable(msg.sender);
1449 
1450         bool success;
1451 
1452         (success, ) = h.call{value: sendAmount}("");
1453         require(success, "Transaction Unsuccessful");
1454     }
1455 }