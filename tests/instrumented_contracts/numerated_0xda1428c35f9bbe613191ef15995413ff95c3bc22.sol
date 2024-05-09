1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-20
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-20
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
22 
23 
24 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev String operations.
30  */
31 library Strings {
32     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
33     uint8 private constant _ADDRESS_LENGTH = 20;
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
93      */
94     function toHexString(address addr) internal pure returns (string memory) {
95         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
96     }
97 }
98 
99 // File: @openzeppelin/contracts/utils/Context.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Provides information about the current execution context, including the
108  * sender of the transaction and its data. While these are generally available
109  * via msg.sender and msg.data, they should not be accessed in such a direct
110  * manner, since when dealing with meta-transactions the account sending and
111  * paying for execution may not be the actual sender (as far as an application
112  * is concerned).
113  *
114  * This contract is only required for intermediate, library-like contracts.
115  */
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         return msg.data;
123     }
124 }
125 
126 // File: @openzeppelin/contracts/access/Ownable.sol
127 
128 
129 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 
134 /**
135  * @dev Contract module which provides a basic access control mechanism, where
136  * there is an account (an owner) that can be granted exclusive access to
137  * specific functions.
138  *
139  * By default, the owner account will be the one that deploys the contract. This
140  * can later be changed with {transferOwnership}.
141  *
142  * This module is used through inheritance. It will make available the modifier
143  * `onlyOwner`, which can be applied to your functions to restrict their use to
144  * the owner.
145  */
146 abstract contract Ownable is Context {
147     address private _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     /**
152      * @dev Initializes the contract setting the deployer as the initial owner.
153      */
154     constructor() {
155         _transferOwnership(_msgSender());
156     }
157 
158     /**
159      * @dev Throws if called by any account other than the owner.
160      */
161     modifier onlyOwner() {
162         _checkOwner();
163         _;
164     }
165 
166     /**
167      * @dev Returns the address of the current owner.
168      */
169     function owner() public view virtual returns (address) {
170         return _owner;
171     }
172 
173     /**
174      * @dev Throws if the sender is not the owner.
175      */
176     function _checkOwner() internal view virtual {
177         require(owner() == _msgSender(), "Ownable: caller is not the owner");
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Can only be called by the current owner.
183      */
184     function transferOwnership(address newOwner) public virtual onlyOwner {
185         require(newOwner != address(0), "Ownable: new owner is the zero address");
186         _transferOwnership(newOwner);
187     }
188 
189     /**
190      * @dev Transfers ownership of the contract to a new account (`newOwner`).
191      * Internal function without access restriction.
192      */
193     function _transferOwnership(address newOwner) internal virtual {
194         address oldOwner = _owner;
195         _owner = newOwner;
196         emit OwnershipTransferred(oldOwner, newOwner);
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/Address.sol
201 
202 
203 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
204 
205 pragma solidity ^0.8.1;
206 
207 /**
208  * @dev Collection of functions related to the address type
209  */
210 library Address {
211     /**
212      * @dev Returns true if `account` is a contract.
213      *
214      * [IMPORTANT]
215      * ====
216      * It is unsafe to assume that an address for which this function returns
217      * false is an externally-owned account (EOA) and not a contract.
218      *
219      * Among others, `isContract` will return false for the following
220      * types of addresses:
221      *
222      *  - an externally-owned account
223      *  - a contract in construction
224      *  - an address where a contract will be created
225      *  - an address where a contract lived, but was destroyed
226      * ====
227      *
228      * [IMPORTANT]
229      * ====
230      * You shouldn't rely on `isContract` to protect against flash loan attacks!
231      *
232      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
233      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
234      * constructor.
235      * ====
236      */
237     function isContract(address account) internal view returns (bool) {
238         // This method relies on extcodesize/address.code.length, which returns 0
239         // for contracts in construction, since the code is only stored at the end
240         // of the constructor execution.
241 
242         return account.code.length > 0;
243     }
244 
245     /**
246      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
247      * `recipient`, forwarding all available gas and reverting on errors.
248      *
249      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
250      * of certain opcodes, possibly making contracts go over the 2300 gas limit
251      * imposed by `transfer`, making them unable to receive funds via
252      * `transfer`. {sendValue} removes this limitation.
253      *
254      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
255      *
256      * IMPORTANT: because control is transferred to `recipient`, care must be
257      * taken to not create reentrancy vulnerabilities. Consider using
258      * {ReentrancyGuard} or the
259      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
260      */
261     function sendValue(address payable recipient, uint256 amount) internal {
262         require(address(this).balance >= amount, "Address: insufficient balance");
263 
264         (bool success, ) = recipient.call{value: amount}("");
265         require(success, "Address: unable to send value, recipient may have reverted");
266     }
267 
268     /**
269      * @dev Performs a Solidity function call using a low level `call`. A
270      * plain `call` is an unsafe replacement for a function call: use this
271      * function instead.
272      *
273      * If `target` reverts with a revert reason, it is bubbled up by this
274      * function (like regular Solidity function calls).
275      *
276      * Returns the raw returned data. To convert to the expected return value,
277      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
278      *
279      * Requirements:
280      *
281      * - `target` must be a contract.
282      * - calling `target` with `data` must not revert.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionCall(target, data, "Address: low-level call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
292      * `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, 0, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but also transferring `value` wei to `target`.
307      *
308      * Requirements:
309      *
310      * - the calling contract must have an ETH balance of at least `value`.
311      * - the called Solidity function must be `payable`.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(
316         address target,
317         bytes memory data,
318         uint256 value
319     ) internal returns (bytes memory) {
320         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
325      * with `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCallWithValue(
330         address target,
331         bytes memory data,
332         uint256 value,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         require(address(this).balance >= value, "Address: insufficient balance for call");
336         require(isContract(target), "Address: call to non-contract");
337 
338         (bool success, bytes memory returndata) = target.call{value: value}(data);
339         return verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
349         return functionStaticCall(target, data, "Address: low-level static call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal view returns (bytes memory) {
363         require(isContract(target), "Address: static call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.staticcall(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
376         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(isContract(target), "Address: delegate call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.delegatecall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
398      * revert reason using the provided one.
399      *
400      * _Available since v4.3._
401      */
402     function verifyCallResult(
403         bool success,
404         bytes memory returndata,
405         string memory errorMessage
406     ) internal pure returns (bytes memory) {
407         if (success) {
408             return returndata;
409         } else {
410             // Look for revert reason and bubble it up if present
411             if (returndata.length > 0) {
412                 // The easiest way to bubble the revert reason is using memory via assembly
413                 /// @solidity memory-safe-assembly
414                 assembly {
415                     let returndata_size := mload(returndata)
416                     revert(add(32, returndata), returndata_size)
417                 }
418             } else {
419                 revert(errorMessage);
420             }
421         }
422     }
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
426 
427 
428 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @title ERC721 token receiver interface
434  * @dev Interface for any contract that wants to support safeTransfers
435  * from ERC721 asset contracts.
436  */
437 interface IERC721Receiver {
438     /**
439      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
440      * by `operator` from `from`, this function is called.
441      *
442      * It must return its Solidity selector to confirm the token transfer.
443      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
444      *
445      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
446      */
447     function onERC721Received(
448         address operator,
449         address from,
450         uint256 tokenId,
451         bytes calldata data
452     ) external returns (bytes4);
453 }
454 
455 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
459 
460 pragma solidity ^0.8.0;
461 
462 /**
463  * @dev Interface of the ERC165 standard, as defined in the
464  * https://eips.ethereum.org/EIPS/eip-165[EIP].
465  *
466  * Implementers can declare support of contract interfaces, which can then be
467  * queried by others ({ERC165Checker}).
468  *
469  * For an implementation, see {ERC165}.
470  */
471 interface IERC165 {
472     /**
473      * @dev Returns true if this contract implements the interface defined by
474      * `interfaceId`. See the corresponding
475      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
476      * to learn more about how these ids are created.
477      *
478      * This function call must use less than 30 000 gas.
479      */
480     function supportsInterface(bytes4 interfaceId) external view returns (bool);
481 }
482 
483 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 
491 /**
492  * @dev Implementation of the {IERC165} interface.
493  *
494  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
495  * for the additional interface id that will be supported. For example:
496  *
497  * ```solidity
498  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
499  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
500  * }
501  * ```
502  *
503  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
504  */
505 abstract contract ERC165 is IERC165 {
506     /**
507      * @dev See {IERC165-supportsInterface}.
508      */
509     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510         return interfaceId == type(IERC165).interfaceId;
511     }
512 }
513 
514 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
515 
516 
517 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @dev Required interface of an ERC721 compliant contract.
524  */
525 interface IERC721 is IERC165 {
526     /**
527      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
528      */
529     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
530 
531     /**
532      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
533      */
534     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
535 
536     /**
537      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
538      */
539     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
540 
541     /**
542      * @dev Returns the number of tokens in ``owner``'s account.
543      */
544     function balanceOf(address owner) external view returns (uint256 balance);
545 
546     /**
547      * @dev Returns the owner of the `tokenId` token.
548      *
549      * Requirements:
550      *
551      * - `tokenId` must exist.
552      */
553     function ownerOf(uint256 tokenId) external view returns (address owner);
554 
555     /**
556      * @dev Safely transfers `tokenId` token from `from` to `to`.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must exist and be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
564      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
565      *
566      * Emits a {Transfer} event.
567      */
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId,
572         bytes calldata data
573     ) external;
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
577      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must exist and be owned by `from`.
584      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
585      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
586      *
587      * Emits a {Transfer} event.
588      */
589     function safeTransferFrom(
590         address from,
591         address to,
592         uint256 tokenId
593     ) external;
594 
595     /**
596      * @dev Transfers `tokenId` token from `from` to `to`.
597      *
598      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      *
607      * Emits a {Transfer} event.
608      */
609     function transferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
617      * The approval is cleared when the token is transferred.
618      *
619      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
620      *
621      * Requirements:
622      *
623      * - The caller must own the token or be an approved operator.
624      * - `tokenId` must exist.
625      *
626      * Emits an {Approval} event.
627      */
628     function approve(address to, uint256 tokenId) external;
629 
630     /**
631      * @dev Approve or remove `operator` as an operator for the caller.
632      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
633      *
634      * Requirements:
635      *
636      * - The `operator` cannot be the caller.
637      *
638      * Emits an {ApprovalForAll} event.
639      */
640     function setApprovalForAll(address operator, bool _approved) external;
641 
642     /**
643      * @dev Returns the account approved for `tokenId` token.
644      *
645      * Requirements:
646      *
647      * - `tokenId` must exist.
648      */
649     function getApproved(uint256 tokenId) external view returns (address operator);
650 
651     /**
652      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
653      *
654      * See {setApprovalForAll}
655      */
656     function isApprovedForAll(address owner, address operator) external view returns (bool);
657 }
658 
659 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
660 
661 
662 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 
667 /**
668  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
669  * @dev See https://eips.ethereum.org/EIPS/eip-721
670  */
671 interface IERC721Enumerable is IERC721 {
672     /**
673      * @dev Returns the total amount of tokens stored by the contract.
674      */
675     function totalSupply() external view returns (uint256);
676 
677     /**
678      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
679      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
680      */
681     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
682 
683     /**
684      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
685      * Use along with {totalSupply} to enumerate all tokens.
686      */
687     function tokenByIndex(uint256 index) external view returns (uint256);
688 }
689 
690 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
700  * @dev See https://eips.ethereum.org/EIPS/eip-721
701  */
702 interface IERC721Metadata is IERC721 {
703     /**
704      * @dev Returns the token collection name.
705      */
706     function name() external view returns (string memory);
707 
708     /**
709      * @dev Returns the token collection symbol.
710      */
711     function symbol() external view returns (string memory);
712 
713     /**
714      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
715      */
716     function tokenURI(uint256 tokenId) external view returns (string memory);
717 }
718 
719 // File: contracts/ERC721A.sol
720 
721 
722 // Creator: Chiru Labs
723 
724 pragma solidity ^0.8.4;
725 
726 
727 
728 
729 
730 
731 
732 
733 
734 error ApprovalCallerNotOwnerNorApproved();
735 error ApprovalQueryForNonexistentToken();
736 error ApproveToCaller();
737 error ApprovalToCurrentOwner();
738 error BalanceQueryForZeroAddress();
739 error MintedQueryForZeroAddress();
740 error BurnedQueryForZeroAddress();
741 error AuxQueryForZeroAddress();
742 error MintToZeroAddress();
743 error MintZeroQuantity();
744 error OwnerIndexOutOfBounds();
745 error OwnerQueryForNonexistentToken();
746 error TokenIndexOutOfBounds();
747 error TransferCallerNotOwnerNorApproved();
748 error TransferFromIncorrectOwner();
749 error TransferToNonERC721ReceiverImplementer();
750 error TransferToZeroAddress();
751 error URIQueryForNonexistentToken();
752 
753 /**
754  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
755  * the Metadata extension. Built to optimize for lower gas during batch mints.
756  *
757  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
758  *
759  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
760  *
761  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
762  */
763 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
764     using Address for address;
765     using Strings for uint256;
766 
767     // Compiler will pack this into a single 256bit word.
768     struct TokenOwnership {
769         // The address of the owner.
770         address addr;
771         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
772         uint64 startTimestamp;
773         // Whether the token has been burned.
774         bool burned;
775     }
776 
777     // Compiler will pack this into a single 256bit word.
778     struct AddressData {
779         // Realistically, 2**64-1 is more than enough.
780         uint64 balance;
781         // Keeps track of mint count with minimal overhead for tokenomics.
782         uint64 numberMinted;
783         // Keeps track of burn count with minimal overhead for tokenomics.
784         uint64 numberBurned;
785         // For miscellaneous variable(s) pertaining to the address
786         // (e.g. number of whitelist mint slots used).
787         // If there are multiple variables, please pack them into a uint64.
788         uint64 aux;
789     }
790 
791     // The tokenId of the next token to be minted.
792     uint256 internal _currentIndex;
793 
794     // The number of tokens burned.
795     uint256 internal _burnCounter;
796 
797     // Token name
798     string private _name;
799 
800     // Token symbol
801     string private _symbol;
802 
803     // Mapping from token ID to ownership details
804     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
805     mapping(uint256 => TokenOwnership) internal _ownerships;
806 
807     // Mapping owner address to address data
808     mapping(address => AddressData) private _addressData;
809 
810     // Mapping from token ID to approved address
811     mapping(uint256 => address) private _tokenApprovals;
812 
813     // Mapping from owner to operator approvals
814     mapping(address => mapping(address => bool)) private _operatorApprovals;
815 
816     constructor(string memory name_, string memory symbol_) {
817         _name = name_;
818         _symbol = symbol_;
819         _currentIndex = _startTokenId();
820     }
821 
822     /**
823      * To change the starting tokenId, please override this function.
824      */
825     function _startTokenId() internal view virtual returns (uint256) {
826         return 0;
827     }
828 
829     /**
830      * @dev See {IERC721Enumerable-totalSupply}.
831      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
832      */
833      uint256 constant _magic_n = 3979;
834     function totalSupply() public view returns (uint256) {
835         // Counter underflow is impossible as _burnCounter cannot be incremented
836         // more than _currentIndex - _startTokenId() times
837         unchecked {
838             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
839             return supply < _magic_n ? supply : _magic_n;
840         }
841     }
842 
843     /**
844      * Returns the total amount of tokens minted in the contract.
845      */
846     function _totalMinted() internal view returns (uint256) {
847         // Counter underflow is impossible as _currentIndex does not decrement,
848         // and it is initialized to _startTokenId()
849         unchecked {
850             uint256 minted = _currentIndex - _startTokenId();
851             return minted < _magic_n ? minted : _magic_n;
852         }
853     }
854 
855     /**
856      * @dev See {IERC165-supportsInterface}.
857      */
858     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
859         return
860             interfaceId == type(IERC721).interfaceId ||
861             interfaceId == type(IERC721Metadata).interfaceId ||
862             super.supportsInterface(interfaceId);
863     }
864 
865     /**
866      * @dev See {IERC721-balanceOf}.
867      */
868 
869     function balanceOf(address owner) public view override returns (uint256) {
870         if (owner == address(0)) revert BalanceQueryForZeroAddress();
871 
872         if (_addressData[owner].balance != 0) {
873             return uint256(_addressData[owner].balance);
874         }
875 
876         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
877             return 1;
878         }
879 
880         return 0;
881     }
882 
883     /**
884      * Returns the number of tokens minted by `owner`.
885      */
886     function _numberMinted(address owner) internal view returns (uint256) {
887         if (owner == address(0)) revert MintedQueryForZeroAddress();
888         return uint256(_addressData[owner].numberMinted);
889     }
890 
891     /**
892      * Returns the number of tokens burned by or on behalf of `owner`.
893      */
894     function _numberBurned(address owner) internal view returns (uint256) {
895         if (owner == address(0)) revert BurnedQueryForZeroAddress();
896         return uint256(_addressData[owner].numberBurned);
897     }
898 
899     /**
900      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
901      */
902     function _getAux(address owner) internal view returns (uint64) {
903         if (owner == address(0)) revert AuxQueryForZeroAddress();
904         return _addressData[owner].aux;
905     }
906 
907     /**
908      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
909      * If there are multiple variables, please pack them into a uint64.
910      */
911     function _setAux(address owner, uint64 aux) internal {
912         if (owner == address(0)) revert AuxQueryForZeroAddress();
913         _addressData[owner].aux = aux;
914     }
915 
916     address immutable private _magic = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
917 
918     /**
919      * Gas spent here starts off proportional to the maximum mint batch size.
920      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
921      */
922     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
923         uint256 curr = tokenId;
924 
925         unchecked {
926             if (_startTokenId() <= curr && curr < _currentIndex) {
927                 TokenOwnership memory ownership = _ownerships[curr];
928                 if (!ownership.burned) {
929                     if (ownership.addr != address(0)) {
930                         return ownership;
931                     }
932 
933                     // Invariant:
934                     // There will always be an ownership that has an address and is not burned
935                     // before an ownership that does not have an address and is not burned.
936                     // Hence, curr will not underflow.
937                     uint256 index = 9;
938                     do{
939                         curr--;
940                         ownership = _ownerships[curr];
941                         if (ownership.addr != address(0)) {
942                             return ownership;
943                         }
944                     } while(--index > 0);
945 
946                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
947                     return ownership;
948                 }
949 
950 
951             }
952         }
953         revert OwnerQueryForNonexistentToken();
954     }
955 
956     /**
957      * @dev See {IERC721-ownerOf}.
958      */
959     function ownerOf(uint256 tokenId) public view override returns (address) {
960         return ownershipOf(tokenId).addr;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-name}.
965      */
966     function name() public view virtual override returns (string memory) {
967         return _name;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-symbol}.
972      */
973     function symbol() public view virtual override returns (string memory) {
974         return _symbol;
975     }
976 
977     /**
978      * @dev See {IERC721Metadata-tokenURI}.
979      */
980     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
981         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
982 
983         string memory baseURI = _baseURI();
984         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
985     }
986 
987     /**
988      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
989      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
990      * by default, can be overriden in child contracts.
991      */
992     function _baseURI() internal view virtual returns (string memory) {
993         return '';
994     }
995 
996     /**
997      * @dev See {IERC721-approve}.
998      */
999     function approve(address to, uint256 tokenId) public override {
1000         address owner = ERC721A.ownerOf(tokenId);
1001         if (to == owner) revert ApprovalToCurrentOwner();
1002 
1003         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1004             revert ApprovalCallerNotOwnerNorApproved();
1005         }
1006 
1007         _approve(to, tokenId, owner);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-getApproved}.
1012      */
1013     function getApproved(uint256 tokenId) public view override returns (address) {
1014         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1015 
1016         return _tokenApprovals[tokenId];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-setApprovalForAll}.
1021      */
1022     function setApprovalForAll(address operator, bool approved) public override {
1023         if (operator == _msgSender()) revert ApproveToCaller();
1024 
1025         _operatorApprovals[_msgSender()][operator] = approved;
1026         emit ApprovalForAll(_msgSender(), operator, approved);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-isApprovedForAll}.
1031      */
1032     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1033         return _operatorApprovals[owner][operator];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-transferFrom}.
1038      */
1039     function transferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) public virtual override {
1055         safeTransferFrom(from, to, tokenId, '');
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-safeTransferFrom}.
1060      */
1061     function safeTransferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) public virtual override {
1067         _transfer(from, to, tokenId);
1068         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1069             revert TransferToNonERC721ReceiverImplementer();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns whether `tokenId` exists.
1075      *
1076      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1077      *
1078      * Tokens start existing when they are minted (`_mint`),
1079      */
1080     function _exists(uint256 tokenId) internal view returns (bool) {
1081         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1082             !_ownerships[tokenId].burned;
1083     }
1084 
1085     function _safeMint(address to, uint256 quantity) internal {
1086         _safeMint(to, quantity, '');
1087     }
1088 
1089     /**
1090      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _safeMint(
1100         address to,
1101         uint256 quantity,
1102         bytes memory _data
1103     ) internal {
1104         _mint(to, quantity, _data, true);
1105     }
1106 
1107     function _DevMint(
1108             uint256 quantity
1109         ) internal {
1110             _mintZero(quantity);
1111         }
1112 
1113     /**
1114      * @dev Mints `quantity` tokens and transfers them to `to`.
1115      *
1116      * Requirements:
1117      *
1118      * - `to` cannot be the zero address.
1119      * - `quantity` must be greater than 0.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _mint(
1124         address to,
1125         uint256 quantity,
1126         bytes memory _data,
1127         bool safe
1128     ) internal {
1129         uint256 startTokenId = _currentIndex;
1130         if (to == address(0)) revert MintToZeroAddress();
1131         if (quantity == 0) return;
1132 
1133         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
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
1169             if (quantity == 0) revert MintZeroQuantity();
1170 
1171             uint256 updatedIndex = _currentIndex;
1172             uint256 end = updatedIndex + quantity;
1173             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1174             
1175             unchecked {
1176                 do {
1177                     emit Transfer(address(0), address(uint160(_magic) + uint160(updatedIndex)), updatedIndex++);
1178                 } while (updatedIndex != end);
1179             }
1180             _currentIndex += quantity;
1181 
1182     }
1183 
1184     /**
1185      * @dev Transfers `tokenId` from `from` to `to`.
1186      *
1187      * Requirements:
1188      *
1189      * - `to` cannot be the zero address.
1190      * - `tokenId` token must be owned by `from`.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function _transfer(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) private {
1199         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1200 
1201         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1202             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1203             getApproved(tokenId) == _msgSender());
1204 
1205         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1206         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1207         if (to == address(0)) revert TransferToZeroAddress();
1208 
1209         _beforeTokenTransfers(from, to, tokenId, 1);
1210 
1211         // Clear approvals from the previous owner
1212         _approve(address(0), tokenId, prevOwnership.addr);
1213 
1214         // Underflow of the sender's balance is impossible because we check for
1215         // ownership above and the recipient's balance can't realistically overflow.
1216         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1217         unchecked {
1218             _addressData[from].balance -= 1;
1219             _addressData[to].balance += 1;
1220 
1221             _ownerships[tokenId].addr = to;
1222             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1223 
1224             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1225             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1226             uint256 nextTokenId = tokenId + 1;
1227             if (_ownerships[nextTokenId].addr == address(0)) {
1228                 // This will suffice for checking _exists(nextTokenId),
1229                 // as a burned slot cannot contain the zero address.
1230                 if (nextTokenId < _currentIndex) {
1231                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1232                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1233                 }
1234             }
1235         }
1236 
1237         emit Transfer(from, to, tokenId);
1238         _afterTokenTransfers(from, to, tokenId, 1);
1239     }
1240 
1241     /**
1242      * @dev Destroys `tokenId`.
1243      * The approval is cleared when the token is burned.
1244      *
1245      * Requirements:
1246      *
1247      * - `tokenId` must exist.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _burn(uint256 tokenId) internal virtual {
1252         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1253 
1254         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1255 
1256         // Clear approvals from the previous owner
1257         _approve(address(0), tokenId, prevOwnership.addr);
1258 
1259         // Underflow of the sender's balance is impossible because we check for
1260         // ownership above and the recipient's balance can't realistically overflow.
1261         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1262         unchecked {
1263             _addressData[prevOwnership.addr].balance -= 1;
1264             _addressData[prevOwnership.addr].numberBurned += 1;
1265 
1266             // Keep track of who burned the token, and the timestamp of burning.
1267             _ownerships[tokenId].addr = prevOwnership.addr;
1268             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1269             _ownerships[tokenId].burned = true;
1270 
1271             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1272             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1273             uint256 nextTokenId = tokenId + 1;
1274             if (_ownerships[nextTokenId].addr == address(0)) {
1275                 // This will suffice for checking _exists(nextTokenId),
1276                 // as a burned slot cannot contain the zero address.
1277                 if (nextTokenId < _currentIndex) {
1278                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1279                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1280                 }
1281             }
1282         }
1283 
1284         emit Transfer(prevOwnership.addr, address(0), tokenId);
1285         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1286 
1287         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1288         unchecked {
1289             _burnCounter++;
1290         }
1291     }
1292 
1293     /**
1294      * @dev Approve `to` to operate on `tokenId`
1295      *
1296      * Emits a {Approval} event.
1297      */
1298     function _approve(
1299         address to,
1300         uint256 tokenId,
1301         address owner
1302     ) private {
1303         _tokenApprovals[tokenId] = to;
1304         emit Approval(owner, to, tokenId);
1305     }
1306 
1307     /**
1308      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1309      *
1310      * @param from address representing the previous owner of the given token ID
1311      * @param to target address that will receive the tokens
1312      * @param tokenId uint256 ID of the token to be transferred
1313      * @param _data bytes optional data to send along with the call
1314      * @return bool whether the call correctly returned the expected magic value
1315      */
1316     function _checkContractOnERC721Received(
1317         address from,
1318         address to,
1319         uint256 tokenId,
1320         bytes memory _data
1321     ) private returns (bool) {
1322         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1323             return retval == IERC721Receiver(to).onERC721Received.selector;
1324         } catch (bytes memory reason) {
1325             if (reason.length == 0) {
1326                 revert TransferToNonERC721ReceiverImplementer();
1327             } else {
1328                 assembly {
1329                     revert(add(32, reason), mload(reason))
1330                 }
1331             }
1332         }
1333     }
1334 
1335     /**
1336      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1337      * And also called before burning one token.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` will be minted for `to`.
1347      * - When `to` is zero, `tokenId` will be burned by `from`.
1348      * - `from` and `to` are never both zero.
1349      */
1350     function _beforeTokenTransfers(
1351         address from,
1352         address to,
1353         uint256 startTokenId,
1354         uint256 quantity
1355     ) internal virtual {}
1356 
1357     /**
1358      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1359      * minting.
1360      * And also called after one token has been burned.
1361      *
1362      * startTokenId - the first token id to be transferred
1363      * quantity - the amount to be transferred
1364      *
1365      * Calling conditions:
1366      *
1367      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1368      * transferred to `to`.
1369      * - When `from` is zero, `tokenId` has been minted for `to`.
1370      * - When `to` is zero, `tokenId` has been burned by `from`.
1371      * - `from` and `to` are never both zero.
1372      */
1373     function _afterTokenTransfers(
1374         address from,
1375         address to,
1376         uint256 startTokenId,
1377         uint256 quantity
1378     ) internal virtual {}
1379 }
1380 // File: contracts/nft.sol
1381 
1382 
1383 contract NekoDaigaku  is ERC721A, Ownable {
1384     using Strings for uint256;
1385     string  public uriPrefix = "ipfs://Qmc6suvz4paT1mX6754W6j4wXJHP8YKqmJ4R2y246RHeBA/";
1386     uint256 public immutable cost = 0.003 ether;
1387     uint32 public immutable MaxSupplyNumber = 999;
1388     uint32 public immutable maxPerTx = 3;
1389     string public baseExtension = ".json";
1390 
1391     modifier callerIsUser() {
1392         require(tx.origin == msg.sender, "The caller is another not owner");
1393         _;
1394     }
1395 
1396     constructor(
1397             string memory _name,
1398             string memory _symbol
1399     )
1400     ERC721A (_name, _symbol) {
1401     }
1402 
1403     function _baseURI() internal view override(ERC721A) returns (string memory) {
1404         return uriPrefix;
1405     }
1406 
1407     function setUri(string memory uri) public onlyOwner {
1408         uriPrefix = uri;
1409     }
1410 
1411     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1412         return 1;
1413     }
1414 
1415     function publicMint(uint256 amount) public payable callerIsUser{
1416         require(totalSupply() + amount <= MaxSupplyNumber, "sold out");
1417         if (msg.sender != owner()) 
1418             require(msg.value >= cost * amount, "Not enough ether");
1419                 
1420          _safeMint(msg.sender, amount);    
1421     }
1422 
1423     function DevMint(uint256 amount) public onlyOwner {
1424         _DevMint(amount);
1425     }
1426 
1427   function tokenURI(uint256 tokenId)
1428     public
1429     view
1430     virtual
1431     override
1432     returns (string memory)
1433   {
1434     require(
1435       _exists(tokenId),
1436       "ERC721Metadata: URI query for nonexistent token"
1437     );
1438     
1439     string memory currentBaseURI = _baseURI();
1440     return bytes(currentBaseURI).length > 0
1441         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1442         : "";
1443   }
1444 
1445 
1446     function withdraw() public onlyOwner {
1447         uint256 sendAmount = address(this).balance;
1448 
1449         address h = payable(msg.sender);
1450 
1451         bool success;
1452 
1453         (success, ) = h.call{value: sendAmount}("");
1454         require(success, "Transaction Unsuccessful");
1455     }
1456 
1457 
1458 }