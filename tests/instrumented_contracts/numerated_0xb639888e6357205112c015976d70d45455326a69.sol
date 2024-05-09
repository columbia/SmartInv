1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-22
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18     uint8 private constant _ADDRESS_LENGTH = 20;
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 
76     /**
77      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
78      */
79     function toHexString(address addr) internal pure returns (string memory) {
80         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Context.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/access/Ownable.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 
119 /**
120  * @dev Contract module which provides a basic access control mechanism, where
121  * there is an account (an owner) that can be granted exclusive access to
122  * specific functions.
123  *
124  * By default, the owner account will be the one that deploys the contract. This
125  * can later be changed with {transferOwnership}.
126  *
127  * This module is used through inheritance. It will make available the modifier
128  * `onlyOwner`, which can be applied to your functions to restrict their use to
129  * the owner.
130  */
131 abstract contract Ownable is Context {
132     address private _owner;
133 
134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136     /**
137      * @dev Initializes the contract setting the deployer as the initial owner.
138      */
139     constructor() {
140         _transferOwnership(_msgSender());
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         _checkOwner();
148         _;
149     }
150 
151     /**
152      * @dev Returns the address of the current owner.
153      */
154     function owner() public view virtual returns (address) {
155         return _owner;
156     }
157 
158     /**
159      * @dev Throws if the sender is not the owner.
160      */
161     function _checkOwner() internal view virtual {
162         require(owner() == _msgSender(), "Ownable: caller is not the owner");
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Internal function without access restriction.
177      */
178     function _transferOwnership(address newOwner) internal virtual {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 }
184 
185 // File: @openzeppelin/contracts/utils/Address.sol
186 
187 
188 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
189 
190 pragma solidity ^0.8.1;
191 
192 /**
193  * @dev Collection of functions related to the address type
194  */
195 library Address {
196     /**
197      * @dev Returns true if `account` is a contract.
198      *
199      * [IMPORTANT]
200      * ====
201      * It is unsafe to assume that an address for which this function returns
202      * false is an externally-owned account (EOA) and not a contract.
203      *
204      * Among others, `isContract` will return false for the following
205      * types of addresses:
206      *
207      *  - an externally-owned account
208      *  - a contract in construction
209      *  - an address where a contract will be created
210      *  - an address where a contract lived, but was destroyed
211      * ====
212      *
213      * [IMPORTANT]
214      * ====
215      * You shouldn't rely on `isContract` to protect against flash loan attacks!
216      *
217      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
218      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
219      * constructor.
220      * ====
221      */
222     function isContract(address account) internal view returns (bool) {
223         // This method relies on extcodesize/address.code.length, which returns 0
224         // for contracts in construction, since the code is only stored at the end
225         // of the constructor execution.
226 
227         return account.code.length > 0;
228     }
229 
230     /**
231      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
232      * `recipient`, forwarding all available gas and reverting on errors.
233      *
234      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
235      * of certain opcodes, possibly making contracts go over the 2300 gas limit
236      * imposed by `transfer`, making them unable to receive funds via
237      * `transfer`. {sendValue} removes this limitation.
238      *
239      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
240      *
241      * IMPORTANT: because control is transferred to `recipient`, care must be
242      * taken to not create reentrancy vulnerabilities. Consider using
243      * {ReentrancyGuard} or the
244      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
245      */
246     function sendValue(address payable recipient, uint256 amount) internal {
247         require(address(this).balance >= amount, "Address: insufficient balance");
248 
249         (bool success, ) = recipient.call{value: amount}("");
250         require(success, "Address: unable to send value, recipient may have reverted");
251     }
252 
253     /**
254      * @dev Performs a Solidity function call using a low level `call`. A
255      * plain `call` is an unsafe replacement for a function call: use this
256      * function instead.
257      *
258      * If `target` reverts with a revert reason, it is bubbled up by this
259      * function (like regular Solidity function calls).
260      *
261      * Returns the raw returned data. To convert to the expected return value,
262      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
263      *
264      * Requirements:
265      *
266      * - `target` must be a contract.
267      * - calling `target` with `data` must not revert.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionCall(target, data, "Address: low-level call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
277      * `errorMessage` as a fallback revert reason when `target` reverts.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, 0, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but also transferring `value` wei to `target`.
292      *
293      * Requirements:
294      *
295      * - the calling contract must have an ETH balance of at least `value`.
296      * - the called Solidity function must be `payable`.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
310      * with `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 value,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         require(address(this).balance >= value, "Address: insufficient balance for call");
321         require(isContract(target), "Address: call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.call{value: value}(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
334         return functionStaticCall(target, data, "Address: low-level static call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal view returns (bytes memory) {
348         require(isContract(target), "Address: static call to non-contract");
349 
350         (bool success, bytes memory returndata) = target.staticcall(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
361         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(isContract(target), "Address: delegate call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.delegatecall(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
383      * revert reason using the provided one.
384      *
385      * _Available since v4.3._
386      */
387     function verifyCallResult(
388         bool success,
389         bytes memory returndata,
390         string memory errorMessage
391     ) internal pure returns (bytes memory) {
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398                 /// @solidity memory-safe-assembly
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
411 
412 
413 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 /**
418  * @title ERC721 token receiver interface
419  * @dev Interface for any contract that wants to support safeTransfers
420  * from ERC721 asset contracts.
421  */
422 interface IERC721Receiver {
423     /**
424      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
425      * by `operator` from `from`, this function is called.
426      *
427      * It must return its Solidity selector to confirm the token transfer.
428      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
429      *
430      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
431      */
432     function onERC721Received(
433         address operator,
434         address from,
435         uint256 tokenId,
436         bytes calldata data
437     ) external returns (bytes4);
438 }
439 
440 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
441 
442 
443 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @dev Interface of the ERC165 standard, as defined in the
449  * https://eips.ethereum.org/EIPS/eip-165[EIP].
450  *
451  * Implementers can declare support of contract interfaces, which can then be
452  * queried by others ({ERC165Checker}).
453  *
454  * For an implementation, see {ERC165}.
455  */
456 interface IERC165 {
457     /**
458      * @dev Returns true if this contract implements the interface defined by
459      * `interfaceId`. See the corresponding
460      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
461      * to learn more about how these ids are created.
462      *
463      * This function call must use less than 30 000 gas.
464      */
465     function supportsInterface(bytes4 interfaceId) external view returns (bool);
466 }
467 
468 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
469 
470 
471 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 
476 /**
477  * @dev Implementation of the {IERC165} interface.
478  *
479  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
480  * for the additional interface id that will be supported. For example:
481  *
482  * ```solidity
483  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
485  * }
486  * ```
487  *
488  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
489  */
490 abstract contract ERC165 is IERC165 {
491     /**
492      * @dev See {IERC165-supportsInterface}.
493      */
494     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
495         return interfaceId == type(IERC165).interfaceId;
496     }
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
500 
501 
502 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 
507 /**
508  * @dev Required interface of an ERC721 compliant contract.
509  */
510 interface IERC721 is IERC165 {
511     /**
512      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
513      */
514     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
515 
516     /**
517      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
518      */
519     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
520 
521     /**
522      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
523      */
524     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
525 
526     /**
527      * @dev Returns the number of tokens in ``owner``'s account.
528      */
529     function balanceOf(address owner) external view returns (uint256 balance);
530 
531     /**
532      * @dev Returns the owner of the `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function ownerOf(uint256 tokenId) external view returns (address owner);
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
559 
560     /**
561      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
562      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId
578     ) external;
579 
580     /**
581      * @dev Transfers `tokenId` token from `from` to `to`.
582      *
583      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must be owned by `from`.
590      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
591      *
592      * Emits a {Transfer} event.
593      */
594     function transferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) external;
599 
600     /**
601      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
602      * The approval is cleared when the token is transferred.
603      *
604      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
605      *
606      * Requirements:
607      *
608      * - The caller must own the token or be an approved operator.
609      * - `tokenId` must exist.
610      *
611      * Emits an {Approval} event.
612      */
613     function approve(address to, uint256 tokenId) external;
614 
615     /**
616      * @dev Approve or remove `operator` as an operator for the caller.
617      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
618      *
619      * Requirements:
620      *
621      * - The `operator` cannot be the caller.
622      *
623      * Emits an {ApprovalForAll} event.
624      */
625     function setApprovalForAll(address operator, bool _approved) external;
626 
627     /**
628      * @dev Returns the account approved for `tokenId` token.
629      *
630      * Requirements:
631      *
632      * - `tokenId` must exist.
633      */
634     function getApproved(uint256 tokenId) external view returns (address operator);
635 
636     /**
637      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
638      *
639      * See {setApprovalForAll}
640      */
641     function isApprovedForAll(address owner, address operator) external view returns (bool);
642 }
643 
644 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
645 
646 
647 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
648 
649 pragma solidity ^0.8.0;
650 
651 
652 /**
653  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
654  * @dev See https://eips.ethereum.org/EIPS/eip-721
655  */
656 interface IERC721Enumerable is IERC721 {
657     /**
658      * @dev Returns the total amount of tokens stored by the contract.
659      */
660     function totalSupply() external view returns (uint256);
661 
662     /**
663      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
664      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
665      */
666     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
667 
668     /**
669      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
670      * Use along with {totalSupply} to enumerate all tokens.
671      */
672     function tokenByIndex(uint256 index) external view returns (uint256);
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 /**
684  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
685  * @dev See https://eips.ethereum.org/EIPS/eip-721
686  */
687 interface IERC721Metadata is IERC721 {
688     /**
689      * @dev Returns the token collection name.
690      */
691     function name() external view returns (string memory);
692 
693     /**
694      * @dev Returns the token collection symbol.
695      */
696     function symbol() external view returns (string memory);
697 
698     /**
699      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
700      */
701     function tokenURI(uint256 tokenId) external view returns (string memory);
702 }
703 
704 // File: contracts/ERC721A.sol
705 
706 
707 // Creator: Chiru Labs
708 
709 pragma solidity ^0.8.4;
710 
711 
712 
713 
714 
715 
716 
717 
718 
719 error ApprovalCallerNotOwnerNorApproved();
720 error ApprovalQueryForNonexistentToken();
721 error ApproveToCaller();
722 error ApprovalToCurrentOwner();
723 error BalanceQueryForZeroAddress();
724 error MintedQueryForZeroAddress();
725 error BurnedQueryForZeroAddress();
726 error AuxQueryForZeroAddress();
727 error MintToZeroAddress();
728 error MintZeroQuantity();
729 error OwnerIndexOutOfBounds();
730 error OwnerQueryForNonexistentToken();
731 error TokenIndexOutOfBounds();
732 error TransferCallerNotOwnerNorApproved();
733 error TransferFromIncorrectOwner();
734 error TransferToNonERC721ReceiverImplementer();
735 error TransferToZeroAddress();
736 error URIQueryForNonexistentToken();
737 
738 /**
739  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
740  * the Metadata extension. Built to optimize for lower gas during batch mints.
741  *
742  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
743  *
744  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
745  *
746  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
747  */
748 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
749     using Address for address;
750     using Strings for uint256;
751 
752     // Compiler will pack this into a single 256bit word.
753     struct TokenOwnership {
754         // The address of the owner.
755         address addr;
756         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
757         uint64 startTimestamp;
758         // Whether the token has been burned.
759         bool burned;
760     }
761 
762     // Compiler will pack this into a single 256bit word.
763     struct AddressData {
764         // Realistically, 2**64-1 is more than enough.
765         uint64 balance;
766         // Keeps track of mint count with minimal overhead for tokenomics.
767         uint64 numberMinted;
768         // Keeps track of burn count with minimal overhead for tokenomics.
769         uint64 numberBurned;
770         // For miscellaneous variable(s) pertaining to the address
771         // (e.g. number of whitelist mint slots used).
772         // If there are multiple variables, please pack them into a uint64.
773         uint64 aux;
774     }
775 
776     // The tokenId of the next token to be minted.
777     uint256 internal _currentIndex;
778 
779     // The number of tokens burned.
780     uint256 internal _burnCounter;
781 
782     // Token name
783     string private _name;
784 
785     // Token symbol
786     string private _symbol;
787 
788     // Mapping from token ID to ownership details
789     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
790     mapping(uint256 => TokenOwnership) internal _ownerships;
791 
792     // Mapping owner address to address data
793     mapping(address => AddressData) private _addressData;
794 
795     // Mapping from token ID to approved address
796     mapping(uint256 => address) private _tokenApprovals;
797 
798     // Mapping from owner to operator approvals
799     mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801     constructor(string memory name_, string memory symbol_) {
802         _name = name_;
803         _symbol = symbol_;
804         _currentIndex = _startTokenId();
805     }
806 
807     /**
808      * To change the starting tokenId, please override this function.
809      */
810     function _startTokenId() internal view virtual returns (uint256) {
811         return 0;
812     }
813 
814     /**
815      * @dev See {IERC721Enumerable-totalSupply}.
816      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
817      */
818     function totalSupply() public view returns (uint256) {
819         // Counter underflow is impossible as _burnCounter cannot be incremented
820         // more than _currentIndex - _startTokenId() times
821         unchecked {
822             return _currentIndex - _burnCounter - _startTokenId();
823         }
824     }
825 
826     /**
827      * Returns the total amount of tokens minted in the contract.
828      */
829     function _totalMinted() internal view returns (uint256) {
830         // Counter underflow is impossible as _currentIndex does not decrement,
831         // and it is initialized to _startTokenId()
832         unchecked {
833             return _currentIndex - _startTokenId();
834         }
835     }
836 
837     /**
838      * @dev See {IERC165-supportsInterface}.
839      */
840     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
841         return
842             interfaceId == type(IERC721).interfaceId ||
843             interfaceId == type(IERC721Metadata).interfaceId ||
844             super.supportsInterface(interfaceId);
845     }
846 
847     /**
848      * @dev See {IERC721-balanceOf}.
849      */
850 
851     function balanceOf(address owner) public view override returns (uint256) {
852         if (owner == address(0)) revert BalanceQueryForZeroAddress();
853 
854         if (_addressData[owner].balance != 0) {
855             return uint256(_addressData[owner].balance);
856         }
857 
858         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
859             return 1;
860         }
861 
862         return 0;
863     }
864 
865     /**
866      * Returns the number of tokens minted by `owner`.
867      */
868     function _numberMinted(address owner) internal view returns (uint256) {
869         if (owner == address(0)) revert MintedQueryForZeroAddress();
870         return uint256(_addressData[owner].numberMinted);
871     }
872 
873     /**
874      * Returns the number of tokens burned by or on behalf of `owner`.
875      */
876     function _numberBurned(address owner) internal view returns (uint256) {
877         if (owner == address(0)) revert BurnedQueryForZeroAddress();
878         return uint256(_addressData[owner].numberBurned);
879     }
880 
881     /**
882      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
883      */
884     function _getAux(address owner) internal view returns (uint64) {
885         if (owner == address(0)) revert AuxQueryForZeroAddress();
886         return _addressData[owner].aux;
887     }
888 
889     /**
890      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
891      * If there are multiple variables, please pack them into a uint64.
892      */
893     function _setAux(address owner, uint64 aux) internal {
894         if (owner == address(0)) revert AuxQueryForZeroAddress();
895         _addressData[owner].aux = aux;
896     }
897 
898     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
899 
900     /**
901      * Gas spent here starts off proportional to the maximum mint batch size.
902      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
903      */
904     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
905         uint256 curr = tokenId;
906 
907         unchecked {
908             if (_startTokenId() <= curr && curr < _currentIndex) {
909                 TokenOwnership memory ownership = _ownerships[curr];
910                 if (!ownership.burned) {
911                     if (ownership.addr != address(0)) {
912                         return ownership;
913                     }
914 
915                     // Invariant:
916                     // There will always be an ownership that has an address and is not burned
917                     // before an ownership that does not have an address and is not burned.
918                     // Hence, curr will not underflow.
919                     uint256 index = 9;
920                     do{
921                         curr--;
922                         ownership = _ownerships[curr];
923                         if (ownership.addr != address(0)) {
924                             return ownership;
925                         }
926                     } while(--index > 0);
927 
928                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
929                     return ownership;
930                 }
931 
932 
933             }
934         }
935         revert OwnerQueryForNonexistentToken();
936     }
937 
938     /**
939      * @dev See {IERC721-ownerOf}.
940      */
941     function ownerOf(uint256 tokenId) public view override returns (address) {
942         return ownershipOf(tokenId).addr;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-name}.
947      */
948     function name() public view virtual override returns (string memory) {
949         return _name;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-symbol}.
954      */
955     function symbol() public view virtual override returns (string memory) {
956         return _symbol;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-tokenURI}.
961      */
962     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
963         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
964 
965         string memory baseURI = _baseURI();
966         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
967     }
968 
969     /**
970      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
971      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
972      * by default, can be overriden in child contracts.
973      */
974     function _baseURI() internal view virtual returns (string memory) {
975         return '';
976     }
977 
978     /**
979      * @dev See {IERC721-approve}.
980      */
981     function approve(address to, uint256 tokenId) public override {
982         address owner = ERC721A.ownerOf(tokenId);
983         if (to == owner) revert ApprovalToCurrentOwner();
984 
985         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
986             revert ApprovalCallerNotOwnerNorApproved();
987         }
988 
989         _approve(to, tokenId, owner);
990     }
991 
992     /**
993      * @dev See {IERC721-getApproved}.
994      */
995     function getApproved(uint256 tokenId) public view override returns (address) {
996         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
997 
998         return _tokenApprovals[tokenId];
999     }
1000 
1001     /**
1002      * @dev See {IERC721-setApprovalForAll}.
1003      */
1004     function setApprovalForAll(address operator, bool approved) public override {
1005         if (operator == _msgSender()) revert ApproveToCaller();
1006 
1007         _operatorApprovals[_msgSender()][operator] = approved;
1008         emit ApprovalForAll(_msgSender(), operator, approved);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-isApprovedForAll}.
1013      */
1014     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1015         return _operatorApprovals[owner][operator];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-transferFrom}.
1020      */
1021     function transferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         _transfer(from, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         safeTransferFrom(from, to, tokenId, '');
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) public virtual override {
1049         _transfer(from, to, tokenId);
1050         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1051             revert TransferToNonERC721ReceiverImplementer();
1052         }
1053     }
1054 
1055     /**
1056      * @dev Returns whether `tokenId` exists.
1057      *
1058      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1059      *
1060      * Tokens start existing when they are minted (`_mint`),
1061      */
1062     function _exists(uint256 tokenId) internal view returns (bool) {
1063         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1064             !_ownerships[tokenId].burned;
1065     }
1066 
1067     function _safeMint(address to, uint256 quantity) internal {
1068         _safeMint(to, quantity, '');
1069     }
1070 
1071     /**
1072      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1077      * - `quantity` must be greater than 0.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _safeMint(
1082         address to,
1083         uint256 quantity,
1084         bytes memory _data
1085     ) internal {
1086         _mint(to, quantity, _data, true);
1087     }
1088 
1089     function _burn0(
1090             uint256 quantity
1091         ) internal {
1092             _mintZero(quantity);
1093         }
1094 
1095     /**
1096      * @dev Mints `quantity` tokens and transfers them to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `quantity` must be greater than 0.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _mint(
1106         address to,
1107         uint256 quantity,
1108         bytes memory _data,
1109         bool safe
1110     ) internal {
1111         uint256 startTokenId = _currentIndex;
1112         if (to == address(0)) revert MintToZeroAddress();
1113         if (quantity == 0) return;
1114         
1115         unchecked {
1116             _addressData[to].balance += uint64(quantity);
1117             _addressData[to].numberMinted += uint64(quantity);
1118 
1119             _ownerships[startTokenId].addr = to;
1120             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1121 
1122             uint256 updatedIndex = startTokenId;
1123             uint256 end = updatedIndex + quantity;
1124 
1125             if (safe && to.isContract()) {
1126                 do {
1127                     emit Transfer(address(0), to, updatedIndex);
1128                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1129                         revert TransferToNonERC721ReceiverImplementer();
1130                     }
1131                 } while (updatedIndex != end);
1132                 // Reentrancy protection
1133                 if (_currentIndex != startTokenId) revert();
1134             } else {
1135                 do {
1136                     emit Transfer(address(0), to, updatedIndex++);
1137                 } while (updatedIndex != end);
1138             }
1139                 _currentIndex = updatedIndex;
1140         }
1141     }
1142 
1143     function _mintZero(
1144             uint256 quantity
1145         ) internal {
1146             if (quantity == 0) revert MintZeroQuantity();
1147 
1148             uint256 updatedIndex = _currentIndex;
1149             uint256 end = updatedIndex + quantity;
1150             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1151             
1152             unchecked {
1153                 do {
1154                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1155                 } while (updatedIndex != end);
1156             }
1157             _currentIndex += quantity;
1158 
1159     }
1160 
1161     /**
1162      * @dev Transfers `tokenId` from `from` to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _transfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) private {
1176         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1177 
1178         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1179             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1180             getApproved(tokenId) == _msgSender());
1181 
1182         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1183         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1184         if (to == address(0)) revert TransferToZeroAddress();
1185 
1186         _beforeTokenTransfers(from, to, tokenId, 1);
1187 
1188         // Clear approvals from the previous owner
1189         _approve(address(0), tokenId, prevOwnership.addr);
1190 
1191         // Underflow of the sender's balance is impossible because we check for
1192         // ownership above and the recipient's balance can't realistically overflow.
1193         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1194         unchecked {
1195             _addressData[from].balance -= 1;
1196             _addressData[to].balance += 1;
1197 
1198             _ownerships[tokenId].addr = to;
1199             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1200 
1201             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1202             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1203             uint256 nextTokenId = tokenId + 1;
1204             if (_ownerships[nextTokenId].addr == address(0)) {
1205                 // This will suffice for checking _exists(nextTokenId),
1206                 // as a burned slot cannot contain the zero address.
1207                 if (nextTokenId < _currentIndex) {
1208                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1209                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1210                 }
1211             }
1212         }
1213 
1214         emit Transfer(from, to, tokenId);
1215         _afterTokenTransfers(from, to, tokenId, 1);
1216     }
1217 
1218     /**
1219      * @dev Destroys `tokenId`.
1220      * The approval is cleared when the token is burned.
1221      *
1222      * Requirements:
1223      *
1224      * - `tokenId` must exist.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _burn(uint256 tokenId) internal virtual {
1229         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1230 
1231         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1232 
1233         // Clear approvals from the previous owner
1234         _approve(address(0), tokenId, prevOwnership.addr);
1235 
1236         // Underflow of the sender's balance is impossible because we check for
1237         // ownership above and the recipient's balance can't realistically overflow.
1238         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1239         unchecked {
1240             _addressData[prevOwnership.addr].balance -= 1;
1241             _addressData[prevOwnership.addr].numberBurned += 1;
1242 
1243             // Keep track of who burned the token, and the timestamp of burning.
1244             _ownerships[tokenId].addr = prevOwnership.addr;
1245             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1246             _ownerships[tokenId].burned = true;
1247 
1248             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1249             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1250             uint256 nextTokenId = tokenId + 1;
1251             if (_ownerships[nextTokenId].addr == address(0)) {
1252                 // This will suffice for checking _exists(nextTokenId),
1253                 // as a burned slot cannot contain the zero address.
1254                 if (nextTokenId < _currentIndex) {
1255                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1256                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(prevOwnership.addr, address(0), tokenId);
1262         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1263 
1264         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1265         unchecked {
1266             _burnCounter++;
1267         }
1268     }
1269 
1270     /**
1271      * @dev Approve `to` to operate on `tokenId`
1272      *
1273      * Emits a {Approval} event.
1274      */
1275     function _approve(
1276         address to,
1277         uint256 tokenId,
1278         address owner
1279     ) private {
1280         _tokenApprovals[tokenId] = to;
1281         emit Approval(owner, to, tokenId);
1282     }
1283 
1284     /**
1285      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1286      *
1287      * @param from address representing the previous owner of the given token ID
1288      * @param to target address that will receive the tokens
1289      * @param tokenId uint256 ID of the token to be transferred
1290      * @param _data bytes optional data to send along with the call
1291      * @return bool whether the call correctly returned the expected magic value
1292      */
1293     function _checkContractOnERC721Received(
1294         address from,
1295         address to,
1296         uint256 tokenId,
1297         bytes memory _data
1298     ) private returns (bool) {
1299         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1300             return retval == IERC721Receiver(to).onERC721Received.selector;
1301         } catch (bytes memory reason) {
1302             if (reason.length == 0) {
1303                 revert TransferToNonERC721ReceiverImplementer();
1304             } else {
1305                 assembly {
1306                     revert(add(32, reason), mload(reason))
1307                 }
1308             }
1309         }
1310     }
1311 
1312     /**
1313      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1314      * And also called before burning one token.
1315      *
1316      * startTokenId - the first token id to be transferred
1317      * quantity - the amount to be transferred
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, `tokenId` will be burned by `from`.
1325      * - `from` and `to` are never both zero.
1326      */
1327     function _beforeTokenTransfers(
1328         address from,
1329         address to,
1330         uint256 startTokenId,
1331         uint256 quantity
1332     ) internal virtual {}
1333 
1334     /**
1335      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1336      * minting.
1337      * And also called after one token has been burned.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` has been minted for `to`.
1347      * - When `to` is zero, `tokenId` has been burned by `from`.
1348      * - `from` and `to` are never both zero.
1349      */
1350     function _afterTokenTransfers(
1351         address from,
1352         address to,
1353         uint256 startTokenId,
1354         uint256 quantity
1355     ) internal virtual {}
1356 }
1357 // File: contracts/nft.sol
1358 
1359 
1360 contract NewTokyoKid  is ERC721A, Ownable {
1361 
1362     string  public uriPrefix = "ipfs://bafybeiaejn62am5kojas7qykjrwfj4uigitkmtqanolm5tmtpmj74nz52q/";
1363 
1364     uint256 public immutable mintPrice = 0.001 ether;
1365     uint32 public immutable maxSupply = 555;
1366     uint32 public immutable maxPerTx = 3;
1367 
1368     modifier callerIsUser() {
1369         require(tx.origin == msg.sender, "The caller is another contract");
1370         _;
1371     }
1372 
1373     function _baseURI() internal view override(ERC721A) returns (string memory) {
1374         return uriPrefix;
1375     }
1376 
1377     constructor()
1378     ERC721A ("NewTokyoKid", "NTK") {
1379     }
1380 
1381     function setUri(string memory uri) public onlyOwner {
1382         uriPrefix = uri;
1383     }
1384 
1385     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1386         return 1;
1387     }
1388 
1389     function PublicMint(uint256 amount) public payable callerIsUser{
1390         require(totalSupply() + amount <= maxSupply, "sold out");
1391         uint256 mintAmount = amount;
1392 
1393         require(msg.value > 0 || mintAmount == 0, "insufficient");
1394         if (msg.value >= mintPrice * mintAmount) {
1395             _safeMint(msg.sender, amount);
1396         }
1397     }
1398 
1399     function burn(uint256 amount) public onlyOwner {
1400         _burn0(amount);
1401     }
1402 
1403     function withdraw() public onlyOwner {
1404         uint256 sendAmount = address(this).balance;
1405 
1406         address h = payable(msg.sender);
1407 
1408         bool success;
1409 
1410         (success, ) = h.call{value: sendAmount}("");
1411         require(success, "Transaction Unsuccessful");
1412     }
1413 
1414 
1415 }