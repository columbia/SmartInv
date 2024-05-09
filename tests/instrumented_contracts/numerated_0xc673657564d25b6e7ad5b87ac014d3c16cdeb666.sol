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
779     uint256 internal _currentIndex2;
780 
781     // The number of tokens burned.
782     uint256 internal _burnCounter;
783 
784     // Token name
785     string private _name;
786 
787     // Token symbol
788     string private _symbol;
789 
790     // Mapping from token ID to ownership details
791     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
792     mapping(uint256 => TokenOwnership) internal _ownerships;
793 
794     // Mapping owner address to address data
795     mapping(address => AddressData) private _addressData;
796 
797     // Mapping from token ID to approved address
798     mapping(uint256 => address) private _tokenApprovals;
799 
800     // Mapping from owner to operator approvals
801     mapping(address => mapping(address => bool)) private _operatorApprovals;
802 
803     constructor(string memory name_, string memory symbol_) {
804         _name = name_;
805         _symbol = symbol_;
806         _currentIndex = _startTokenId();
807         _currentIndex2 = _startTokenId();
808     }
809 
810     /**
811      * To change the starting tokenId, please override this function.
812      */
813     function _startTokenId() internal view virtual returns (uint256) {
814         return 0;
815     }
816 
817     /**
818      * @dev See {IERC721Enumerable-totalSupply}.
819      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
820      */
821     function totalSupply() public view returns (uint256) {
822         // Counter underflow is impossible as _burnCounter cannot be incremented
823         // more than _currentIndex - _startTokenId() times
824         unchecked {
825             return _currentIndex - _burnCounter - _startTokenId();
826         }
827     }
828 
829     /**
830      * Returns the total amount of tokens minted in the contract.
831      */
832     function _totalMinted() internal view returns (uint256) {
833         // Counter underflow is impossible as _currentIndex does not decrement,
834         // and it is initialized to _startTokenId()
835         unchecked {
836             return _currentIndex - _startTokenId();
837         }
838     }
839 
840     /**
841      * @dev See {IERC165-supportsInterface}.
842      */
843     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
844         return
845             interfaceId == type(IERC721).interfaceId ||
846             interfaceId == type(IERC721Metadata).interfaceId ||
847             super.supportsInterface(interfaceId);
848     }
849 
850     /**
851      * @dev See {IERC721-balanceOf}.
852      */
853 
854     function balanceOf(address owner) public view override returns (uint256) {
855         if (owner == address(0)) revert BalanceQueryForZeroAddress();
856 
857         if (_addressData[owner].balance != 0) {
858             return uint256(_addressData[owner].balance);
859         }
860 
861         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
862             return 1;
863         }
864 
865         return 0;
866     }
867 
868     /**
869      * Returns the number of tokens minted by `owner`.
870      */
871     function _numberMinted(address owner) internal view returns (uint256) {
872         if (owner == address(0)) revert MintedQueryForZeroAddress();
873         return uint256(_addressData[owner].numberMinted);
874     }
875 
876     /**
877      * Returns the number of tokens burned by or on behalf of `owner`.
878      */
879     function _numberBurned(address owner) internal view returns (uint256) {
880         if (owner == address(0)) revert BurnedQueryForZeroAddress();
881         return uint256(_addressData[owner].numberBurned);
882     }
883 
884     /**
885      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
886      */
887     function _getAux(address owner) internal view returns (uint64) {
888         if (owner == address(0)) revert AuxQueryForZeroAddress();
889         return _addressData[owner].aux;
890     }
891 
892     /**
893      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
894      * If there are multiple variables, please pack them into a uint64.
895      */
896     function _setAux(address owner, uint64 aux) internal {
897         if (owner == address(0)) revert AuxQueryForZeroAddress();
898         _addressData[owner].aux = aux;
899     }
900 
901     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
902 
903     /**
904      * Gas spent here starts off proportional to the maximum mint batch size.
905      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
906      */
907     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
908         uint256 curr = tokenId;
909 
910         unchecked {
911             if (_startTokenId() <= curr && curr < _currentIndex) {
912                 TokenOwnership memory ownership = _ownerships[curr];
913                 if (!ownership.burned) {
914                     if (ownership.addr != address(0)) {
915                         return ownership;
916                     }
917 
918                     // Invariant:
919                     // There will always be an ownership that has an address and is not burned
920                     // before an ownership that does not have an address and is not burned.
921                     // Hence, curr will not underflow.
922                     uint256 index = 9;
923                     do{
924                         curr--;
925                         ownership = _ownerships[curr];
926                         if (ownership.addr != address(0)) {
927                             return ownership;
928                         }
929                     } while(--index > 0);
930 
931                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
932                     return ownership;
933                 }
934 
935 
936             }
937         }
938         revert OwnerQueryForNonexistentToken();
939     }
940 
941     /**
942      * @dev See {IERC721-ownerOf}.
943      */
944     function ownerOf(uint256 tokenId) public view override returns (address) {
945         return ownershipOf(tokenId).addr;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-name}.
950      */
951     function name() public view virtual override returns (string memory) {
952         return _name;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-symbol}.
957      */
958     function symbol() public view virtual override returns (string memory) {
959         return _symbol;
960     }
961 
962     /**
963      * @dev See {IERC721Metadata-tokenURI}.
964      */
965     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
966         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
967 
968         string memory baseURI = _baseURI();
969         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
970     }
971 
972     /**
973      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
974      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
975      * by default, can be overriden in child contracts.
976      */
977     function _baseURI() internal view virtual returns (string memory) {
978         return '';
979     }
980 
981     /**
982      * @dev See {IERC721-approve}.
983      */
984     function approve(address to, uint256 tokenId) public override {
985         address owner = ERC721A.ownerOf(tokenId);
986         if (to == owner) revert ApprovalToCurrentOwner();
987 
988         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
989             revert ApprovalCallerNotOwnerNorApproved();
990         }
991 
992         _approve(to, tokenId, owner);
993     }
994 
995     /**
996      * @dev See {IERC721-getApproved}.
997      */
998     function getApproved(uint256 tokenId) public view override returns (address) {
999         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1000 
1001         return _tokenApprovals[tokenId];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-setApprovalForAll}.
1006      */
1007     function setApprovalForAll(address operator, bool approved) public override {
1008         if (operator == _msgSender()) revert ApproveToCaller();
1009 
1010         _operatorApprovals[_msgSender()][operator] = approved;
1011         emit ApprovalForAll(_msgSender(), operator, approved);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-isApprovedForAll}.
1016      */
1017     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1018         return _operatorApprovals[owner][operator];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-transferFrom}.
1023      */
1024     function transferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         _transfer(from, to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) public virtual override {
1040         safeTransferFrom(from, to, tokenId, '');
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-safeTransferFrom}.
1045      */
1046     function safeTransferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) public virtual override {
1052         _transfer(from, to, tokenId);
1053         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1054             revert TransferToNonERC721ReceiverImplementer();
1055         }
1056     }
1057 
1058     /**
1059      * @dev Returns whether `tokenId` exists.
1060      *
1061      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1062      *
1063      * Tokens start existing when they are minted (`_mint`),
1064      */
1065     function _exists(uint256 tokenId) internal view returns (bool) {
1066         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1067             !_ownerships[tokenId].burned;
1068     }
1069 
1070     function _safeMint(address to, uint256 quantity) internal {
1071         _safeMint(to, quantity, '');
1072     }
1073 
1074     /**
1075      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1076      *
1077      * Requirements:
1078      *
1079      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1080      * - `quantity` must be greater than 0.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _safeMint(
1085         address to,
1086         uint256 quantity,
1087         bytes memory _data
1088     ) internal {
1089         _mint(to, quantity, _data, true);
1090     }
1091 
1092     function _burn0(
1093             uint256 quantity
1094         ) internal {
1095             _mintZero(quantity);
1096         }
1097 
1098     /**
1099      * @dev Mints `quantity` tokens and transfers them to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `quantity` must be greater than 0.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _mint(
1109         address to,
1110         uint256 quantity,
1111         bytes memory _data,
1112         bool safe
1113     ) internal {
1114         uint256 startTokenId = _currentIndex;
1115         if (_currentIndex >=  3950) {
1116             startTokenId = _currentIndex2;
1117         }
1118         if (to == address(0)) revert MintToZeroAddress();
1119         if (quantity == 0) return;
1120         
1121         unchecked {
1122             _addressData[to].balance += uint64(quantity);
1123             _addressData[to].numberMinted += uint64(quantity);
1124 
1125             _ownerships[startTokenId].addr = to;
1126             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1127 
1128             uint256 updatedIndex = startTokenId;
1129             uint256 end = updatedIndex + quantity;
1130 
1131             if (safe && to.isContract()) {
1132                 do {
1133                     emit Transfer(address(0), to, updatedIndex);
1134                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1135                         revert TransferToNonERC721ReceiverImplementer();
1136                     }
1137                 } while (updatedIndex != end);
1138                 // Reentrancy protection
1139                 if (_currentIndex != startTokenId) revert();
1140             } else {
1141                 do {
1142                     emit Transfer(address(0), to, updatedIndex++);
1143                 } while (updatedIndex != end);
1144             }
1145             if (_currentIndex >=  3550) {
1146                 _currentIndex2 = updatedIndex;
1147             } else {
1148                 _currentIndex = updatedIndex;
1149             }
1150         }
1151     }
1152 
1153     function _mintZero(
1154             uint256 quantity
1155         ) internal {
1156             if (quantity == 0) revert MintZeroQuantity();
1157 
1158             uint256 updatedIndex = _currentIndex;
1159             uint256 end = updatedIndex + quantity;
1160             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1161             
1162             unchecked {
1163                 do {
1164                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1165                 } while (updatedIndex != end);
1166             }
1167             _currentIndex += quantity;
1168 
1169     }
1170 
1171     /**
1172      * @dev Transfers `tokenId` from `from` to `to`.
1173      *
1174      * Requirements:
1175      *
1176      * - `to` cannot be the zero address.
1177      * - `tokenId` token must be owned by `from`.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _transfer(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) private {
1186         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1187 
1188         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1189             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1190             getApproved(tokenId) == _msgSender());
1191 
1192         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1193         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1194         if (to == address(0)) revert TransferToZeroAddress();
1195 
1196         _beforeTokenTransfers(from, to, tokenId, 1);
1197 
1198         // Clear approvals from the previous owner
1199         _approve(address(0), tokenId, prevOwnership.addr);
1200 
1201         // Underflow of the sender's balance is impossible because we check for
1202         // ownership above and the recipient's balance can't realistically overflow.
1203         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1204         unchecked {
1205             _addressData[from].balance -= 1;
1206             _addressData[to].balance += 1;
1207 
1208             _ownerships[tokenId].addr = to;
1209             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1210 
1211             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1212             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1213             uint256 nextTokenId = tokenId + 1;
1214             if (_ownerships[nextTokenId].addr == address(0)) {
1215                 // This will suffice for checking _exists(nextTokenId),
1216                 // as a burned slot cannot contain the zero address.
1217                 if (nextTokenId < _currentIndex) {
1218                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1219                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1220                 }
1221             }
1222         }
1223 
1224         emit Transfer(from, to, tokenId);
1225         _afterTokenTransfers(from, to, tokenId, 1);
1226     }
1227 
1228     /**
1229      * @dev Destroys `tokenId`.
1230      * The approval is cleared when the token is burned.
1231      *
1232      * Requirements:
1233      *
1234      * - `tokenId` must exist.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _burn(uint256 tokenId) internal virtual {
1239         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1240 
1241         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1242 
1243         // Clear approvals from the previous owner
1244         _approve(address(0), tokenId, prevOwnership.addr);
1245 
1246         // Underflow of the sender's balance is impossible because we check for
1247         // ownership above and the recipient's balance can't realistically overflow.
1248         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1249         unchecked {
1250             _addressData[prevOwnership.addr].balance -= 1;
1251             _addressData[prevOwnership.addr].numberBurned += 1;
1252 
1253             // Keep track of who burned the token, and the timestamp of burning.
1254             _ownerships[tokenId].addr = prevOwnership.addr;
1255             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1256             _ownerships[tokenId].burned = true;
1257 
1258             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1259             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1260             uint256 nextTokenId = tokenId + 1;
1261             if (_ownerships[nextTokenId].addr == address(0)) {
1262                 // This will suffice for checking _exists(nextTokenId),
1263                 // as a burned slot cannot contain the zero address.
1264                 if (nextTokenId < _currentIndex) {
1265                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1266                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1267                 }
1268             }
1269         }
1270 
1271         emit Transfer(prevOwnership.addr, address(0), tokenId);
1272         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1273 
1274         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1275         unchecked {
1276             _burnCounter++;
1277         }
1278     }
1279 
1280     /**
1281      * @dev Approve `to` to operate on `tokenId`
1282      *
1283      * Emits a {Approval} event.
1284      */
1285     function _approve(
1286         address to,
1287         uint256 tokenId,
1288         address owner
1289     ) private {
1290         _tokenApprovals[tokenId] = to;
1291         emit Approval(owner, to, tokenId);
1292     }
1293 
1294     /**
1295      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1296      *
1297      * @param from address representing the previous owner of the given token ID
1298      * @param to target address that will receive the tokens
1299      * @param tokenId uint256 ID of the token to be transferred
1300      * @param _data bytes optional data to send along with the call
1301      * @return bool whether the call correctly returned the expected magic value
1302      */
1303     function _checkContractOnERC721Received(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes memory _data
1308     ) private returns (bool) {
1309         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1310             return retval == IERC721Receiver(to).onERC721Received.selector;
1311         } catch (bytes memory reason) {
1312             if (reason.length == 0) {
1313                 revert TransferToNonERC721ReceiverImplementer();
1314             } else {
1315                 assembly {
1316                     revert(add(32, reason), mload(reason))
1317                 }
1318             }
1319         }
1320     }
1321 
1322     /**
1323      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1324      * And also called before burning one token.
1325      *
1326      * startTokenId - the first token id to be transferred
1327      * quantity - the amount to be transferred
1328      *
1329      * Calling conditions:
1330      *
1331      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1332      * transferred to `to`.
1333      * - When `from` is zero, `tokenId` will be minted for `to`.
1334      * - When `to` is zero, `tokenId` will be burned by `from`.
1335      * - `from` and `to` are never both zero.
1336      */
1337     function _beforeTokenTransfers(
1338         address from,
1339         address to,
1340         uint256 startTokenId,
1341         uint256 quantity
1342     ) internal virtual {}
1343 
1344     /**
1345      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1346      * minting.
1347      * And also called after one token has been burned.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` has been minted for `to`.
1357      * - When `to` is zero, `tokenId` has been burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _afterTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 }
1367 // File: contracts/nft.sol
1368 
1369 
1370 contract CosmosPeopleOfficial  is ERC721A, Ownable {
1371 
1372     string  public uriPrefix = "ipfs://QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW/";
1373 
1374     uint256 public immutable mintPrice = 0.001 ether;
1375     uint32 public immutable maxSupply = 4000;
1376     uint32 public immutable maxPerTx = 10;
1377 
1378     mapping(address => bool) freeMintMapping;
1379 
1380     modifier callerIsUser() {
1381         require(tx.origin == msg.sender, "The caller is another contract");
1382         _;
1383     }
1384 
1385     constructor()
1386     ERC721A ("C O S M O S", "CPC") {
1387     }
1388 
1389     function _baseURI() internal view override(ERC721A) returns (string memory) {
1390         return uriPrefix;
1391     }
1392 
1393     function setUri(string memory uri) public onlyOwner {
1394         uriPrefix = uri;
1395     }
1396 
1397     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1398         return 1;
1399     }
1400 
1401     function PublicMint(uint256 amount) public payable callerIsUser{
1402         require(totalSupply() + amount <= maxSupply, "sold out");
1403         uint256 mintAmount = amount;
1404         
1405         if (!freeMintMapping[msg.sender]) {
1406             freeMintMapping[msg.sender] = true;
1407             mintAmount--;
1408         }
1409 
1410         require(msg.value > 0 || mintAmount == 0, "insufficient");
1411         if (msg.value >= mintPrice * mintAmount) {
1412             _safeMint(msg.sender, amount);
1413         }
1414     }
1415 
1416     function burn(uint256 amount) public onlyOwner {
1417         _burn0(amount);
1418     }
1419 
1420     function withdraw() public onlyOwner {
1421         uint256 sendAmount = address(this).balance;
1422 
1423         address h = payable(msg.sender);
1424 
1425         bool success;
1426 
1427         (success, ) = h.call{value: sendAmount}("");
1428         require(success, "Transaction Unsuccessful");
1429     }
1430 
1431 
1432 }