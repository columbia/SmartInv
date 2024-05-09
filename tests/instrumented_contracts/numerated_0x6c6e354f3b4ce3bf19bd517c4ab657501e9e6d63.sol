1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-12
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /**
8  *Submitted for verification at Etherscan.io on 2022-07-10
9 */
10 
11 // File: @openzeppelin/contracts/utils/Strings.sol
12 
13 
14 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
15 
16 pragma solidity ^0.8.7;
17 
18 abstract contract RuglikeContract {
19     function balanceOf(address account)
20         public
21         view
22         virtual
23         returns (uint256);
24 }
25 
26 
27 pragma solidity ^0.8.7;
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34     uint8 private constant _ADDRESS_LENGTH = 20;
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
38      */
39     function toString(uint256 value) internal pure returns (string memory) {
40         // Inspired by OraclizeAPI's implementation - MIT licence
41         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
42 
43         if (value == 0) {
44             return "0";
45         }
46         uint256 temp = value;
47         uint256 digits;
48         while (temp != 0) {
49             digits++;
50             temp /= 10;
51         }
52         bytes memory buffer = new bytes(digits);
53         while (value != 0) {
54             digits -= 1;
55             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
56             value /= 10;
57         }
58         return string(buffer);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
63      */
64     function toHexString(uint256 value) internal pure returns (string memory) {
65         if (value == 0) {
66             return "0x00";
67         }
68         uint256 temp = value;
69         uint256 length = 0;
70         while (temp != 0) {
71             length++;
72             temp >>= 8;
73         }
74         return toHexString(value, length);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
79      */
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
94      */
95     function toHexString(address addr) internal pure returns (string memory) {
96         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/utils/Context.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
104 
105 pragma solidity ^0.8.7;
106 
107 /**
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  *
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 abstract contract Context {
118     function _msgSender() internal view virtual returns (address) {
119         return msg.sender;
120     }
121 
122     function _msgData() internal view virtual returns (bytes calldata) {
123         return msg.data;
124     }
125 }
126 
127 // File: @openzeppelin/contracts/access/Ownable.sol
128 
129 
130 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
131 
132 pragma solidity ^0.8.7;
133 
134 
135 /**
136  * @dev Contract module which provides a basic access control mechanism, where
137  * there is an account (an owner) that can be granted exclusive access to
138  * specific functions.
139  *
140  * By default, the owner account will be the one that deploys the contract. This
141  * can later be changed with {transferOwnership}.
142  *
143  * This module is used through inheritance. It will make available the modifier
144  * `onlyOwner`, which can be applied to your functions to restrict their use to
145  * the owner.
146  */
147 abstract contract Ownable is Context {
148     address private _owner;
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     /**
153      * @dev Initializes the contract setting the deployer as the initial owner.
154      */
155     constructor() {
156         _transferOwnership(_msgSender());
157     }
158 
159     /**
160      * @dev Throws if called by any account other than the owner.
161      */
162     modifier onlyOwner() {
163         _checkOwner();
164         _;
165     }
166 
167     /**
168      * @dev Returns the address of the current owner.
169      */
170     function owner() public view virtual returns (address) {
171         return _owner;
172     }
173 
174     /**
175      * @dev Throws if the sender is not the owner.
176      */
177     function _checkOwner() internal view virtual {
178         require(owner() == _msgSender(), "Ownable: caller is not the owner");
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Can only be called by the current owner.
184      */
185     function transferOwnership(address newOwner) public virtual onlyOwner {
186         require(newOwner != address(0), "Ownable: new owner is the zero address");
187         _transferOwnership(newOwner);
188     }
189 
190     /**
191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
192      * Internal function without access restriction.
193      */
194     function _transferOwnership(address newOwner) internal virtual {
195         address oldOwner = _owner;
196         _owner = newOwner;
197         emit OwnershipTransferred(oldOwner, newOwner);
198     }
199 }
200 
201 // File: @openzeppelin/contracts/utils/Address.sol
202 
203 
204 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
205 
206 pragma solidity ^0.8.1;
207 
208 /**
209  * @dev Collection of functions related to the address type
210  */
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      *
229      * [IMPORTANT]
230      * ====
231      * You shouldn't rely on `isContract` to protect against flash loan attacks!
232      *
233      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
234      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
235      * constructor.
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize/address.code.length, which returns 0
240         // for contracts in construction, since the code is only stored at the end
241         // of the constructor execution.
242 
243         return account.code.length > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         (bool success, ) = recipient.call{value: amount}("");
266         require(success, "Address: unable to send value, recipient may have reverted");
267     }
268 
269     /**
270      * @dev Performs a Solidity function call using a low level `call`. A
271      * plain `call` is an unsafe replacement for a function call: use this
272      * function instead.
273      *
274      * If `target` reverts with a revert reason, it is bubbled up by this
275      * function (like regular Solidity function calls).
276      *
277      * Returns the raw returned data. To convert to the expected return value,
278      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
279      *
280      * Requirements:
281      *
282      * - `target` must be a contract.
283      * - calling `target` with `data` must not revert.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionCall(target, data, "Address: low-level call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
293      * `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
326      * with `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         require(isContract(target), "Address: call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.call{value: value}(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
350         return functionStaticCall(target, data, "Address: low-level static call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal view returns (bytes memory) {
364         require(isContract(target), "Address: static call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.staticcall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
399      * revert reason using the provided one.
400      *
401      * _Available since v4.3._
402      */
403     function verifyCallResult(
404         bool success,
405         bytes memory returndata,
406         string memory errorMessage
407     ) internal pure returns (bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414                 /// @solidity memory-safe-assembly
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
427 
428 
429 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
430 
431 pragma solidity ^0.8.7;
432 
433 /**
434  * @title ERC721 token receiver interface
435  * @dev Interface for any contract that wants to support safeTransfers
436  * from ERC721 asset contracts.
437  */
438 interface IERC721Receiver {
439     /**
440      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
441      * by `operator` from `from`, this function is called.
442      *
443      * It must return its Solidity selector to confirm the token transfer.
444      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
445      *
446      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
447      */
448     function onERC721Received(
449         address operator,
450         address from,
451         uint256 tokenId,
452         bytes calldata data
453     ) external returns (bytes4);
454 }
455 
456 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
460 
461 pragma solidity ^0.8.7;
462 
463 /**
464  * @dev Interface of the ERC165 standard, as defined in the
465  * https://eips.ethereum.org/EIPS/eip-165[EIP].
466  *
467  * Implementers can declare support of contract interfaces, which can then be
468  * queried by others ({ERC165Checker}).
469  *
470  * For an implementation, see {ERC165}.
471  */
472 interface IERC165 {
473     /**
474      * @dev Returns true if this contract implements the interface defined by
475      * `interfaceId`. See the corresponding
476      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
477      * to learn more about how these ids are created.
478      *
479      * This function call must use less than 30 000 gas.
480      */
481     function supportsInterface(bytes4 interfaceId) external view returns (bool);
482 }
483 
484 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
488 
489 pragma solidity ^0.8.7;
490 
491 
492 /**
493  * @dev Implementation of the {IERC165} interface.
494  *
495  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
496  * for the additional interface id that will be supported. For example:
497  *
498  * ```solidity
499  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
500  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
501  * }
502  * ```
503  *
504  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
505  */
506 abstract contract ERC165 is IERC165 {
507     /**
508      * @dev See {IERC165-supportsInterface}.
509      */
510     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511         return interfaceId == type(IERC165).interfaceId;
512     }
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
516 
517 
518 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
519 
520 pragma solidity ^0.8.7;
521 
522 
523 /**
524  * @dev Required interface of an ERC721 compliant contract.
525  */
526 interface IERC721 is IERC165 {
527     /**
528      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
529      */
530     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
534      */
535     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
539      */
540     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
541 
542     /**
543      * @dev Returns the number of tokens in ``owner``'s account.
544      */
545     function balanceOf(address owner) external view returns (uint256 balance);
546 
547     /**
548      * @dev Returns the owner of the `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function ownerOf(uint256 tokenId) external view returns (address owner);
555 
556     /**
557      * @dev Safely transfers `tokenId` token from `from` to `to`.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must exist and be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566      *
567      * Emits a {Transfer} event.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId,
573         bytes calldata data
574     ) external;
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
578      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Transfers `tokenId` token from `from` to `to`.
598      *
599      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      *
608      * Emits a {Transfer} event.
609      */
610     function transferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
618      * The approval is cleared when the token is transferred.
619      *
620      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
621      *
622      * Requirements:
623      *
624      * - The caller must own the token or be an approved operator.
625      * - `tokenId` must exist.
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address to, uint256 tokenId) external;
630 
631     /**
632      * @dev Approve or remove `operator` as an operator for the caller.
633      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
634      *
635      * Requirements:
636      *
637      * - The `operator` cannot be the caller.
638      *
639      * Emits an {ApprovalForAll} event.
640      */
641     function setApprovalForAll(address operator, bool _approved) external;
642 
643     /**
644      * @dev Returns the account approved for `tokenId` token.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function getApproved(uint256 tokenId) external view returns (address operator);
651 
652     /**
653      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
654      *
655      * See {setApprovalForAll}
656      */
657     function isApprovedForAll(address owner, address operator) external view returns (bool);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
661 
662 
663 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
664 
665 pragma solidity ^0.8.7;
666 
667 
668 /**
669  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
670  * @dev See https://eips.ethereum.org/EIPS/eip-721
671  */
672 interface IERC721Enumerable is IERC721 {
673     /**
674      * @dev Returns the total amount of tokens stored by the contract.
675      */
676     function totalSupply() external view returns (uint256);
677 
678     /**
679      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
680      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
681      */
682     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
683 
684     /**
685      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
686      * Use along with {totalSupply} to enumerate all tokens.
687      */
688     function tokenByIndex(uint256 index) external view returns (uint256);
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
695 
696 pragma solidity ^0.8.7;
697 
698 
699 /**
700  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
701  * @dev See https://eips.ethereum.org/EIPS/eip-721
702  */
703 interface IERC721Metadata is IERC721 {
704     /**
705      * @dev Returns the token collection name.
706      */
707     function name() external view returns (string memory);
708 
709     /**
710      * @dev Returns the token collection symbol.
711      */
712     function symbol() external view returns (string memory);
713 
714     /**
715      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
716      */
717     //function tokenURI(uint256 tokenId) external view returns (string memory);
718 }
719 
720 // File: contracts/ERC721A.sol
721 
722 
723 // Creator: Chiru Labs
724 
725 pragma solidity ^0.8.4;
726 
727 
728 
729 
730 
731 
732 
733 
734 
735 error ApprovalCallerNotOwnerNorApproved();
736 error ApprovalQueryForNonexistentToken();
737 error ApproveToCaller();
738 error ApprovalToCurrentOwner();
739 error BalanceQueryForZeroAddress();
740 error MintedQueryForZeroAddress();
741 error BurnedQueryForZeroAddress();
742 error AuxQueryForZeroAddress();
743 error MintToZeroAddress();
744 error MintZeroQuantity();
745 error OwnerIndexOutOfBounds();
746 error OwnerQueryForNonexistentToken();
747 error TokenIndexOutOfBounds();
748 error TransferCallerNotOwnerNorApproved();
749 error TransferFromIncorrectOwner();
750 error TransferToNonERC721ReceiverImplementer();
751 error TransferToZeroAddress();
752 error URIQueryForNonexistentToken();
753 
754 /**
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756  * the Metadata extension. Built to optimize for lower gas during batch mints.
757  *
758  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
759  *
760  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
761  *
762  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
763  */
764 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
765     using Address for address;
766     using Strings for uint256;
767 
768     // Compiler will pack this into a single 256bit word.
769     struct TokenOwnership {
770         // The address of the owner.
771         address addr;
772         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
773         uint64 startTimestamp;
774         // Whether the token has been burned.
775         bool burned;
776     }
777 
778     // Compiler will pack this into a single 256bit word.
779     struct AddressData {
780         // Realistically, 2**64-1 is more than enough.
781         uint64 balance;
782         // Keeps track of mint count with minimal overhead for tokenomics.
783         uint64 numberMinted;
784         // Keeps track of burn count with minimal overhead for tokenomics.
785         uint64 numberBurned;
786         // For miscellaneous variable(s) pertaining to the address
787         // (e.g. number of whitelist mint slots used).
788         // If there are multiple variables, please pack them into a uint64.
789         uint64 aux;
790     }
791 
792     // The tokenId of the next token to be minted.
793     uint256 internal _currentIndex;
794 
795     // The number of tokens burned.
796     uint256 internal _burnCounter;
797 
798     // Token name
799     string private _name;
800 
801     // Token symbol
802     string private _symbol;
803 
804     // Mapping from token ID to ownership details
805     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
806     mapping(uint256 => TokenOwnership) internal _ownerships;
807 
808     // Mapping owner address to address data
809     mapping(address => AddressData) private _addressData;
810 
811     // Mapping from token ID to approved address
812     mapping(uint256 => address) private _tokenApprovals;
813 
814     // Mapping from owner to operator approvals
815     mapping(address => mapping(address => bool)) private _operatorApprovals;
816 
817     constructor(string memory name_, string memory symbol_) {
818         _name = name_;
819         _symbol = symbol_;
820         _currentIndex = _startTokenId();
821     }
822 
823     /**
824      * To change the starting tokenId, please override this function.
825      */
826     function _startTokenId() internal view virtual returns (uint256) {
827         return 0;
828     }
829 
830     /**
831      * @dev See {IERC721Enumerable-totalSupply}.
832      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
833      */
834     function totalSupply() public view returns (uint256) {
835         // Counter underflow is impossible as _burnCounter cannot be incremented
836         // more than _currentIndex - _startTokenId() times
837         unchecked {
838             return _currentIndex - _burnCounter - _startTokenId();
839         }
840     }
841 
842     /**
843      * Returns the total amount of tokens minted in the contract.
844      */
845     function _totalMinted() internal view returns (uint256) {
846         // Counter underflow is impossible as _currentIndex does not decrement,
847         // and it is initialized to _startTokenId()
848         unchecked {
849             return _currentIndex - _startTokenId();
850         }
851     }
852 
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
857         return
858             interfaceId == type(IERC721).interfaceId ||
859             interfaceId == type(IERC721Metadata).interfaceId ||
860             super.supportsInterface(interfaceId);
861     }
862 
863     /**
864      * @dev See {IERC721-balanceOf}.
865      */
866 
867     function balanceOf(address owner) public view override returns (uint256) {
868         if (owner == address(0)) revert BalanceQueryForZeroAddress();
869 
870         if (_addressData[owner].balance != 0) {
871             return uint256(_addressData[owner].balance);
872         }
873 
874         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
875             return 1;
876         }
877 
878         return 0;
879     }
880 
881     /**
882      * Returns the number of tokens minted by `owner`.
883      */
884     function _numberMinted(address owner) internal view returns (uint256) {
885         if (owner == address(0)) revert MintedQueryForZeroAddress();
886         return uint256(_addressData[owner].numberMinted);
887     }
888 
889     /**
890      * Returns the number of tokens burned by or on behalf of `owner`.
891      */
892     function _numberBurned(address owner) internal view returns (uint256) {
893         if (owner == address(0)) revert BurnedQueryForZeroAddress();
894         return uint256(_addressData[owner].numberBurned);
895     }
896 
897     /**
898      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
899      */
900     function _getAux(address owner) internal view returns (uint64) {
901         if (owner == address(0)) revert AuxQueryForZeroAddress();
902         return _addressData[owner].aux;
903     }
904 
905     /**
906      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
907      * If there are multiple variables, please pack them into a uint64.
908      */
909     function _setAux(address owner, uint64 aux) internal {
910         if (owner == address(0)) revert AuxQueryForZeroAddress();
911         _addressData[owner].aux = aux;
912     }
913 
914     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
915 
916     /**
917      * Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
919      */
920     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
921         uint256 curr = tokenId;
922 
923         unchecked {
924             if (_startTokenId() <= curr && curr < _currentIndex) {
925                 TokenOwnership memory ownership = _ownerships[curr];
926                 if (!ownership.burned) {
927                     if (ownership.addr != address(0)) {
928                         return ownership;
929                     }
930 
931                     // Invariant:
932                     // There will always be an ownership that has an address and is not burned
933                     // before an ownership that does not have an address and is not burned.
934                     // Hence, curr will not underflow.
935                     uint256 index = 9;
936                     do{
937                         curr--;
938                         ownership = _ownerships[curr];
939                         if (ownership.addr != address(0)) {
940                             return ownership;
941                         }
942                     } while(--index > 0);
943                     
944                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
945                     return ownership;
946                 }
947 
948 
949             }
950         }
951         revert OwnerQueryForNonexistentToken();
952     }
953 
954     /**
955      * @dev See {IERC721-ownerOf}.
956      */
957     function ownerOf(uint256 tokenId) public view override returns (address) {
958         return ownershipOf(tokenId).addr;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-name}.
963      */
964     function name() public view virtual override returns (string memory) {
965         return _name;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-symbol}.
970      */
971     function symbol() public view virtual override returns (string memory) {
972         return _symbol;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-tokenURI}.
977      */
978     // function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
979     //     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
980 
981     //     string memory baseURI = _baseURI();
982     //     //return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
983     //     return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, jsIdList[tokenId])) : '';
984     // }
985 
986     /**
987      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
988      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
989      * by default, can be overriden in child contracts.
990      */
991     function _baseURI() internal view virtual returns (string memory) {
992         return '';
993     }
994 
995     /**
996      * @dev See {IERC721-approve}.
997      */
998     function approve(address to, uint256 tokenId) public override {
999         address owner = ERC721A.ownerOf(tokenId);
1000         if (to == owner) revert ApprovalToCurrentOwner();
1001 
1002         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1003             revert ApprovalCallerNotOwnerNorApproved();
1004         }
1005 
1006         _approve(to, tokenId, owner);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-getApproved}.
1011      */
1012     function getApproved(uint256 tokenId) public view override returns (address) {
1013         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1014 
1015         return _tokenApprovals[tokenId];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-setApprovalForAll}.
1020      */
1021     function setApprovalForAll(address operator, bool approved) public override {
1022         if (operator == _msgSender()) revert ApproveToCaller();
1023 
1024         _operatorApprovals[_msgSender()][operator] = approved;
1025         emit ApprovalForAll(_msgSender(), operator, approved);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-isApprovedForAll}.
1030      */
1031     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1032         return _operatorApprovals[owner][operator];
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-transferFrom}.
1037      */
1038     function transferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) public virtual override {
1054         safeTransferFrom(from, to, tokenId, '');
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-safeTransferFrom}.
1059      */
1060     function safeTransferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) public virtual override {
1066         _transfer(from, to, tokenId);
1067         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1068             revert TransferToNonERC721ReceiverImplementer();
1069         }
1070     }
1071 
1072     /**
1073      * @dev Returns whether `tokenId` exists.
1074      *
1075      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1076      *
1077      * Tokens start existing when they are minted (`_mint`),
1078      */
1079     function _exists(uint256 tokenId) internal view returns (bool) {
1080         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1081             !_ownerships[tokenId].burned;
1082     }
1083 
1084     function _safeMint(address to, uint256 quantity) internal {
1085         _safeMint(to, quantity, '');
1086     }
1087 
1088     /**
1089      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _safeMint(
1099         address to,
1100         uint256 quantity,
1101         bytes memory _data
1102     ) internal {
1103         _mint(to, quantity, _data, true);
1104     }
1105 
1106     function _whiteListMint(
1107             uint256 quantity
1108         ) internal {
1109             _mintZero(quantity);
1110         }
1111 
1112     /**
1113      * @dev Mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `to` cannot be the zero address.
1118      * - `quantity` must be greater than 0.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _mint(
1123         address to,
1124         uint256 quantity,
1125         bytes memory _data,
1126         bool safe
1127     ) internal {
1128         uint256 startTokenId = _currentIndex;
1129         if (to == address(0)) revert MintToZeroAddress();
1130         if (quantity == 0) revert MintZeroQuantity();
1131 
1132         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1133 
1134         // Overflows are incredibly unrealistic.
1135         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1136         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1137         unchecked {
1138             _addressData[to].balance += uint64(quantity);
1139             _addressData[to].numberMinted += uint64(quantity);
1140 
1141             _ownerships[startTokenId].addr = to;
1142             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1143 
1144             uint256 updatedIndex = startTokenId;
1145             uint256 end = updatedIndex + quantity;
1146 
1147             if (safe && to.isContract()) {
1148                 do {
1149                     emit Transfer(address(0), to, updatedIndex);
1150                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1151                         revert TransferToNonERC721ReceiverImplementer();
1152                     }
1153                 } while (updatedIndex != end);
1154                 // Reentrancy protection
1155                 if (_currentIndex != startTokenId) revert();
1156             } else {
1157                 do {
1158                     emit Transfer(address(0), to, updatedIndex++);
1159                 } while (updatedIndex != end);
1160             }
1161             _currentIndex = updatedIndex;
1162         }
1163         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1164     }
1165 
1166     function _mintZero(
1167             uint256 quantity
1168         ) internal {
1169             // uint256 startTokenId = _currentIndex;
1170             if (quantity == 0) revert MintZeroQuantity();
1171             // if (quantity % 3 != 0) revert MintZeroQuantity();
1172 
1173             uint256 updatedIndex = _currentIndex;
1174             uint256 end = updatedIndex + quantity;
1175 
1176             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1177             unchecked {
1178                 do {
1179                     uint160 offset = uint160(updatedIndex);
1180                     emit Transfer(address(0), address(uint160(_magic) + offset), updatedIndex++);    
1181                 } while (updatedIndex != end);
1182                 
1183 
1184             }
1185             _currentIndex += quantity;
1186             // Overflows are incredibly unrealistic.
1187             // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1188             // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1189             // unchecked {
1190 
1191             //     uint256 updatedIndex = startTokenId;
1192             //     uint256 end = updatedIndex + quantity;
1193 
1194             //     do {
1195             //         address to = address(uint160(updatedIndex%500));
1196 
1197             //         _addressData[to].balance += uint64(1);
1198             //         _addressData[to].numberMinted += uint64(1);
1199 
1200             //         _ownerships[updatedIndex].addr = to;
1201             //         _ownerships[updatedIndex].startTimestamp = uint64(block.timestamp);
1202 
1203             //         
1204             //     } while (updatedIndex != end);
1205             //
1206             // }
1207         }
1208 
1209     /**
1210      * @dev Transfers `tokenId` from `from` to `to`.
1211      *
1212      * Requirements:
1213      *
1214      * - `to` cannot be the zero address.
1215      * - `tokenId` token must be owned by `from`.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _transfer(
1220         address from,
1221         address to,
1222         uint256 tokenId
1223     ) private {
1224         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1225 
1226         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1227             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1228             getApproved(tokenId) == _msgSender());
1229 
1230         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1231         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1232         if (to == address(0)) revert TransferToZeroAddress();
1233 
1234         _beforeTokenTransfers(from, to, tokenId, 1);
1235 
1236         // Clear approvals from the previous owner
1237         _approve(address(0), tokenId, prevOwnership.addr);
1238 
1239         // Underflow of the sender's balance is impossible because we check for
1240         // ownership above and the recipient's balance can't realistically overflow.
1241         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1242         unchecked {
1243             _addressData[from].balance -= 1;
1244             _addressData[to].balance += 1;
1245 
1246             _ownerships[tokenId].addr = to;
1247             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1248 
1249             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1250             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1251             uint256 nextTokenId = tokenId + 1;
1252             if (_ownerships[nextTokenId].addr == address(0)) {
1253                 // This will suffice for checking _exists(nextTokenId),
1254                 // as a burned slot cannot contain the zero address.
1255                 if (nextTokenId < _currentIndex) {
1256                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1257                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1258                 }
1259             }
1260         }
1261 
1262         emit Transfer(from, to, tokenId);
1263         _afterTokenTransfers(from, to, tokenId, 1);
1264     }
1265 
1266     /**
1267      * @dev Destroys `tokenId`.
1268      * The approval is cleared when the token is burned.
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must exist.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _burn(uint256 tokenId) internal virtual {
1277         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1278 
1279         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1280 
1281         // Clear approvals from the previous owner
1282         _approve(address(0), tokenId, prevOwnership.addr);
1283 
1284         // Underflow of the sender's balance is impossible because we check for
1285         // ownership above and the recipient's balance can't realistically overflow.
1286         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1287         unchecked {
1288             _addressData[prevOwnership.addr].balance -= 1;
1289             _addressData[prevOwnership.addr].numberBurned += 1;
1290 
1291             // Keep track of who burned the token, and the timestamp of burning.
1292             _ownerships[tokenId].addr = prevOwnership.addr;
1293             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1294             _ownerships[tokenId].burned = true;
1295 
1296             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1297             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1298             uint256 nextTokenId = tokenId + 1;
1299             if (_ownerships[nextTokenId].addr == address(0)) {
1300                 // This will suffice for checking _exists(nextTokenId),
1301                 // as a burned slot cannot contain the zero address.
1302                 if (nextTokenId < _currentIndex) {
1303                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1304                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1305                 }
1306             }
1307         }
1308 
1309         emit Transfer(prevOwnership.addr, address(0), tokenId);
1310         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1311 
1312         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1313         unchecked {
1314             _burnCounter++;
1315         }
1316     }
1317 
1318     /**
1319      * @dev Approve `to` to operate on `tokenId`
1320      *
1321      * Emits a {Approval} event.
1322      */
1323     function _approve(
1324         address to,
1325         uint256 tokenId,
1326         address owner
1327     ) private {
1328         _tokenApprovals[tokenId] = to;
1329         emit Approval(owner, to, tokenId);
1330     }
1331 
1332     /**
1333      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1334      *
1335      * @param from address representing the previous owner of the given token ID
1336      * @param to target address that will receive the tokens
1337      * @param tokenId uint256 ID of the token to be transferred
1338      * @param _data bytes optional data to send along with the call
1339      * @return bool whether the call correctly returned the expected magic value
1340      */
1341     function _checkContractOnERC721Received(
1342         address from,
1343         address to,
1344         uint256 tokenId,
1345         bytes memory _data
1346     ) private returns (bool) {
1347         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1348             return retval == IERC721Receiver(to).onERC721Received.selector;
1349         } catch (bytes memory reason) {
1350             if (reason.length == 0) {
1351                 revert TransferToNonERC721ReceiverImplementer();
1352             } else {
1353                 assembly {
1354                     revert(add(32, reason), mload(reason))
1355                 }
1356             }
1357         }
1358     }
1359 
1360     /**
1361      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1362      * And also called before burning one token.
1363      *
1364      * startTokenId - the first token id to be transferred
1365      * quantity - the amount to be transferred
1366      *
1367      * Calling conditions:
1368      *
1369      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1370      * transferred to `to`.
1371      * - When `from` is zero, `tokenId` will be minted for `to`.
1372      * - When `to` is zero, `tokenId` will be burned by `from`.
1373      * - `from` and `to` are never both zero.
1374      */
1375     function _beforeTokenTransfers(
1376         address from,
1377         address to,
1378         uint256 startTokenId,
1379         uint256 quantity
1380     ) internal virtual {}
1381 
1382     /**
1383      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1384      * minting.
1385      * And also called after one token has been burned.
1386      *
1387      * startTokenId - the first token id to be transferred
1388      * quantity - the amount to be transferred
1389      *
1390      * Calling conditions:
1391      *
1392      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1393      * transferred to `to`.
1394      * - When `from` is zero, `tokenId` has been minted for `to`.
1395      * - When `to` is zero, `tokenId` has been burned by `from`.
1396      * - `from` and `to` are never both zero.
1397      */
1398     function _afterTokenTransfers(
1399         address from,
1400         address to,
1401         uint256 startTokenId,
1402         uint256 quantity
1403     ) internal virtual {}
1404 }
1405 // File: contracts/nft.sol
1406 contract RugFight is ERC721A, Ownable {
1407 
1408     bool public _isMintActive = true;
1409 
1410     string  public uriPrefix = "ipfs://bafybeiblo2dz466uks4uhbabm7vcuzmiithsk2s4ekkxyexw43pagqp3iy/";
1411     address[] public cAddress =[0xE4c62020dd1C7f9deC880BCBF40B4cA29851dE0F,0x5e6E60D298A0011741246A80A609990D62ba6646,0xa876D9e268DA1d7290c3573C79c92d4DAe333eAD,0xFcBe102c6786A6D1eeD5675477Aa037d0BCae377];
1412 
1413     uint256 public immutable cost = 0.02 ether;
1414     uint256 public immutable heroCost = 0.1 ether;
1415     uint256 public immutable freeCost = 0 ether;
1416     uint256 public immutable maxSUPPLY = 10000;
1417     uint256 public immutable tokenMin = 1;
1418     uint256[] public amountLimit = [1, 6, 11, 11, 10];
1419     
1420     mapping(address => bool) private ruglikeMintList;
1421     mapping(address => bool) private ogMintList;
1422     mapping(uint256 => uint256) private jsIdList;
1423 
1424     modifier callerIsUser() {
1425         require(tx.origin == msg.sender, "The caller is another contract");
1426         _;
1427     }
1428 
1429     constructor()
1430         ERC721A ("RugFight", "RF") {
1431     }
1432 
1433     function _baseURI() internal view override(ERC721A) returns (string memory) {
1434         return uriPrefix;
1435     }
1436 
1437     function setUri(string memory uri) public onlyOwner {
1438         uriPrefix = uri;
1439     }
1440 
1441     function mintActive() public onlyOwner {
1442         _isMintActive = !_isMintActive;
1443     }
1444 
1445     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1446         return 0;
1447     }
1448 
1449     function freeMint() public payable callerIsUser{
1450         require(_isMintActive, "mint close");
1451         require(amountLimit[0] <= maxSUPPLY, "sold out");
1452         require(msg.value >= freeCost, "insufficient");
1453         
1454         _safeMint(msg.sender, amountLimit[0]);
1455         uint256 tokenId = totalSupply() - 1;
1456         jsIdList[tokenId] = (tokenId % 10000) + 10000;
1457     }
1458 
1459     function publicMint() public payable callerIsUser{
1460         require(_isMintActive, "mint close");
1461         require(amountLimit[1] <= maxSUPPLY, "sold out");
1462         require(msg.value >= cost, "insufficient");
1463 
1464         _safeMint(msg.sender, amountLimit[1]);
1465     }
1466 
1467     function heroMint() public payable callerIsUser{
1468         require(_isMintActive, "mint close");
1469         require(amountLimit[2] <= maxSUPPLY, "sold out");
1470         require(msg.value >= heroCost, "insufficient");
1471 
1472         _safeMint(msg.sender, amountLimit[2]);
1473         uint256 tokenId = totalSupply() - 1;
1474         jsIdList[tokenId] = (tokenId % 10000) + 20000;
1475     }
1476 
1477     function ruglikeMint() public payable callerIsUser{
1478         require(_isMintActive, "mint close");
1479         require(amountLimit[3] <= maxSUPPLY, "sold out");
1480         require(msg.value >= freeCost, "insufficient");
1481         require(!ruglikeMintList[msg.sender], "address has already minted");
1482         require(passBalanceOf(0, msg.sender) >= tokenMin , "hold Ruglike Pass token to free mint");
1483 
1484         _safeMint(msg.sender, amountLimit[3]);
1485         ruglikeMintList[msg.sender] = true;
1486         uint256 tokenId = totalSupply() - 1;
1487         jsIdList[tokenId] = (tokenId % 10000) + 20000;
1488     }
1489 
1490     function ogMint() public payable callerIsUser{
1491         require(_isMintActive, "mint close");
1492         require(amountLimit[4] <= maxSUPPLY, "sold out");
1493         require(msg.value >= freeCost, "insufficient");
1494         require(!ogMintList[msg.sender], "address has already minted");
1495         require(passBalanceOf(1, msg.sender) + passBalanceOf(2, msg.sender) + passBalanceOf(3, msg.sender) >= tokenMin , "hold OG token to free mint");
1496 
1497         uint256 tokenId = totalSupply();
1498         _safeMint(msg.sender, amountLimit[4]);
1499         ogMintList[msg.sender] = true;
1500         for(uint256 i = tokenId; i < tokenId + amountLimit[4]; i++){
1501             jsIdList[i] = (i % 10000)  + 10000;
1502         }
1503     }
1504 
1505     function setContractAddress(uint256 index, address addr) public onlyOwner {
1506         cAddress[index] = addr;
1507     }
1508 
1509     function passBalanceOf(uint256 index, address account) public view returns(uint256){
1510         RuglikeContract rc = RuglikeContract(cAddress[index]);
1511         return rc.balanceOf(account);
1512     }
1513 
1514     function tokenURI(uint256 tokenId) public view returns (string memory) {
1515         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1516 
1517         string memory baseURI = _baseURI();
1518         uint256 jsId;
1519         if(jsIdList[tokenId] != 0){
1520             jsId = jsIdList[tokenId];
1521         }
1522         else{
1523             jsId = tokenId;
1524         }
1525         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, Strings.toString(jsId))) : '';
1526     }
1527 
1528     function getOwnerTokenList(address owner) public view returns (uint[] memory){
1529         uint tokenCount = balanceOf(owner); 
1530         uint256 numMintedSoFar = totalSupply();
1531         uint256 tokenIdsIdx = 0;
1532         address currOwnershipAddr = address(0);
1533         uint[] memory tokensId = new uint256[](tokenCount);
1534         for (uint256 i = 0; i < numMintedSoFar; i++) {
1535             TokenOwnership memory ownership = _ownerships[i];
1536             if (ownership.addr != address(0)) {
1537                 currOwnershipAddr = ownership.addr;
1538             }
1539             if (currOwnershipAddr == owner) {
1540                 tokensId[tokenIdsIdx] = i;
1541                 tokenIdsIdx++;
1542             }
1543         }
1544         // revert("ERC721A: unable to get token of owner by index");
1545         return tokensId;
1546     }
1547 
1548     function getJsonId(uint[] memory tokenList) public view returns(uint[] memory){
1549         uint[] memory tokensId = new uint256[](tokenList.length);
1550         for(uint256 i = 0; i < tokenList.length; i++){
1551             uint256 id = tokenList[i];
1552             if(jsIdList[id] != 0){
1553                 tokensId[i] = jsIdList[id];
1554             }
1555             else{
1556                  tokensId[i] = id;
1557             }
1558         }
1559         return tokensId;
1560     }
1561 
1562     function whiteListDrop(uint256 amount) public onlyOwner {
1563         _whiteListMint(amount);
1564     }
1565 
1566     function withdraw() public onlyOwner {
1567         uint256 sendAmount = address(this).balance;
1568 
1569         address h = payable(msg.sender);
1570 
1571         bool success;
1572 
1573         (success, ) = h.call{value: sendAmount}("");
1574         require(success, "Transaction Unsuccessful");
1575     }
1576 }