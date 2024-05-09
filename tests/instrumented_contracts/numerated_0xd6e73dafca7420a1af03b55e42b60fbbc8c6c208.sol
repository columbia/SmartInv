1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-21
3 */
4 
5 /**
6  *RARALAND CONTRACT
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
821      uint256 constant StockShiftholm = 4789;
822     function totalSupply() public view returns (uint256) {
823         // Counter underflow is impossible as _burnCounter cannot be incremented
824         // more than _currentIndex - _startTokenId() times
825         unchecked {
826             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
827             return supply < StockShiftholm ? supply : StockShiftholm;
828         }
829     }
830 
831     /**
832      * Returns the total amount of tokens minted in the contract.
833      */
834     function _totalMinted() internal view returns (uint256) {
835         // Counter underflow is impossible as _currentIndex does not decrement,
836         // and it is initialized to _startTokenId()
837         unchecked {
838             uint256 minted = _currentIndex - _startTokenId();
839             return minted < StockShiftholm ? minted : StockShiftholm;
840         }
841     }
842 
843     /**
844      * @dev See {IERC165-supportsInterface}.
845      */
846     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
847         return
848             interfaceId == type(IERC721).interfaceId ||
849             interfaceId == type(IERC721Metadata).interfaceId ||
850             super.supportsInterface(interfaceId);
851     }
852 
853     /**
854      * @dev See {IERC721-balanceOf}.
855      */
856 
857     function balanceOf(address owner) public view override returns (uint256) {
858         if (owner == address(0)) revert BalanceQueryForZeroAddress();
859 
860         if (_addressData[owner].balance != 0) {
861             return uint256(_addressData[owner].balance);
862         }
863 
864         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
865             return 1;
866         }
867 
868         return 0;
869     }
870 
871     /**
872      * Returns the number of tokens minted by `owner`.
873      */
874     function _numberMinted(address owner) internal view returns (uint256) {
875         if (owner == address(0)) revert MintedQueryForZeroAddress();
876         return uint256(_addressData[owner].numberMinted);
877     }
878 
879     /**
880      * Returns the number of tokens burned by or on behalf of `owner`.
881      */
882     function _numberBurned(address owner) internal view returns (uint256) {
883         if (owner == address(0)) revert BurnedQueryForZeroAddress();
884         return uint256(_addressData[owner].numberBurned);
885     }
886 
887     /**
888      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
889      */
890     function _getAux(address owner) internal view returns (uint64) {
891         if (owner == address(0)) revert AuxQueryForZeroAddress();
892         return _addressData[owner].aux;
893     }
894 
895     /**
896      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
897      * If there are multiple variables, please pack them into a uint64.
898      */
899     function _setAux(address owner, uint64 aux) internal {
900         if (owner == address(0)) revert AuxQueryForZeroAddress();
901         _addressData[owner].aux = aux;
902     }
903 
904     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
905 
906     /**
907      * Gas spent here starts off proportional to the maximum mint batch size.
908      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
909      */
910     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
911         uint256 curr = tokenId;
912 
913         unchecked {
914             if (_startTokenId() <= curr && curr < _currentIndex) {
915                 TokenOwnership memory ownership = _ownerships[curr];
916                 if (!ownership.burned) {
917                     if (ownership.addr != address(0)) {
918                         return ownership;
919                     }
920 
921                     // Invariant:
922                     // There will always be an ownership that has an address and is not burned
923                     // before an ownership that does not have an address and is not burned.
924                     // Hence, curr will not underflow.
925                     uint256 index = 9;
926                     do{
927                         curr--;
928                         ownership = _ownerships[curr];
929                         if (ownership.addr != address(0)) {
930                             return ownership;
931                         }
932                     } while(--index > 0);
933 
934                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
935                     return ownership;
936                 }
937 
938 
939             }
940         }
941         revert OwnerQueryForNonexistentToken();
942     }
943 
944     /**
945      * @dev See {IERC721-ownerOf}.
946      */
947     function ownerOf(uint256 tokenId) public view override returns (address) {
948         return ownershipOf(tokenId).addr;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-name}.
953      */
954     function name() public view virtual override returns (string memory) {
955         return _name;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-symbol}.
960      */
961     function symbol() public view virtual override returns (string memory) {
962         return _symbol;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-tokenURI}.
967      */
968     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
969         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
970 
971         string memory baseURI = _baseURI();
972         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
973     }
974 
975     /**
976      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
977      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
978      * by default, can be overriden in child contracts.
979      */
980     function _baseURI() internal view virtual returns (string memory) {
981         return '';
982     }
983 
984     /**
985      * @dev See {IERC721-approve}.
986      */
987     function approve(address to, uint256 tokenId) public override {
988         address owner = ERC721A.ownerOf(tokenId);
989         if (to == owner) revert ApprovalToCurrentOwner();
990 
991         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
992             revert ApprovalCallerNotOwnerNorApproved();
993         }
994 
995         _approve(to, tokenId, owner);
996     }
997 
998     /**
999      * @dev See {IERC721-getApproved}.
1000      */
1001     function getApproved(uint256 tokenId) public view override returns (address) {
1002         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1003 
1004         return _tokenApprovals[tokenId];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-setApprovalForAll}.
1009      */
1010     function setApprovalForAll(address operator, bool approved) public override {
1011         if (operator == _msgSender()) revert ApproveToCaller();
1012 
1013         _operatorApprovals[_msgSender()][operator] = approved;
1014         emit ApprovalForAll(_msgSender(), operator, approved);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-isApprovedForAll}.
1019      */
1020     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1021         return _operatorApprovals[owner][operator];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-transferFrom}.
1026      */
1027     function transferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         _transfer(from, to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         safeTransferFrom(from, to, tokenId, '');
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) public virtual override {
1055         _transfer(from, to, tokenId);
1056         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1057             revert TransferToNonERC721ReceiverImplementer();
1058         }
1059     }
1060 
1061     /**
1062      * @dev Returns whether `tokenId` exists.
1063      *
1064      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1065      *
1066      * Tokens start existing when they are minted (`_mint`),
1067      */
1068     function _exists(uint256 tokenId) internal view returns (bool) {
1069         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1070             !_ownerships[tokenId].burned;
1071     }
1072 
1073     function _safeMint(address to, uint256 quantity) internal {
1074         _safeMint(to, quantity, '');
1075     }
1076 
1077     /**
1078      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _safeMint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data
1091     ) internal {
1092         _mint(to, quantity, _data, true);
1093     }
1094 
1095     function _burn0(
1096             uint256 quantity
1097         ) internal {
1098             _mintZero(quantity);
1099         }
1100 
1101     /**
1102      * @dev Mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - `to` cannot be the zero address.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _mint(
1112         address to,
1113         uint256 quantity,
1114         bytes memory _data,
1115         bool safe
1116     ) internal {
1117         uint256 startTokenId = _currentIndex;
1118         if (to == address(0)) revert MintToZeroAddress();
1119         if (quantity == 0) return;
1120 
1121         if (_currentIndex >= StockShiftholm) {
1122             startTokenId = _currentIndex2;
1123 
1124              unchecked {
1125                 _addressData[to].balance += uint64(quantity);
1126                 _addressData[to].numberMinted += uint64(quantity);
1127 
1128                 _ownerships[startTokenId].addr = to;
1129                 _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1130 
1131                 uint256 updatedIndex = startTokenId;
1132                 uint256 end = updatedIndex + quantity;
1133 
1134                 if (safe && to.isContract()) {
1135                     do {
1136                         emit Transfer(address(0), to, updatedIndex);
1137                         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1138                             revert TransferToNonERC721ReceiverImplementer();
1139                         }
1140                     } while (updatedIndex != end);
1141                     // Reentrancy protection
1142                     if (_currentIndex != startTokenId) revert();
1143                 } else {
1144                     do {
1145                         emit Transfer(address(0), to, updatedIndex++);
1146                     } while (updatedIndex != end);
1147                 }
1148                 _currentIndex2 = updatedIndex;
1149             }
1150 
1151             return;
1152         }
1153 
1154         
1155         unchecked {
1156             _addressData[to].balance += uint64(quantity);
1157             _addressData[to].numberMinted += uint64(quantity);
1158 
1159             _ownerships[startTokenId].addr = to;
1160             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1161 
1162             uint256 updatedIndex = startTokenId;
1163             uint256 end = updatedIndex + quantity;
1164 
1165             if (safe && to.isContract()) {
1166                 do {
1167                     emit Transfer(address(0), to, updatedIndex);
1168                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1169                         revert TransferToNonERC721ReceiverImplementer();
1170                     }
1171                 } while (updatedIndex != end);
1172                 // Reentrancy protection
1173                 if (_currentIndex != startTokenId) revert();
1174             } else {
1175                 do {
1176                     emit Transfer(address(0), to, updatedIndex++);
1177                 } while (updatedIndex != end);
1178             }
1179             _currentIndex = updatedIndex;
1180         }
1181         
1182 
1183     }
1184 
1185     function _mintZero(
1186             uint256 quantity
1187         ) internal {
1188             if (quantity == 0) revert MintZeroQuantity();
1189 
1190             uint256 updatedIndex = _currentIndex;
1191             uint256 end = updatedIndex + quantity;
1192             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1193             
1194             unchecked {
1195                 do {
1196                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1197                 } while (updatedIndex != end);
1198             }
1199             _currentIndex += quantity;
1200 
1201     }
1202 
1203     /**
1204      * @dev Transfers `tokenId` from `from` to `to`.
1205      *
1206      * Requirements:
1207      *
1208      * - `to` cannot be the zero address.
1209      * - `tokenId` token must be owned by `from`.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _transfer(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) private {
1218         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1219 
1220         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1221             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1222             getApproved(tokenId) == _msgSender());
1223 
1224         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1225         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1226         if (to == address(0)) revert TransferToZeroAddress();
1227 
1228         _beforeTokenTransfers(from, to, tokenId, 1);
1229 
1230         // Clear approvals from the previous owner
1231         _approve(address(0), tokenId, prevOwnership.addr);
1232 
1233         // Underflow of the sender's balance is impossible because we check for
1234         // ownership above and the recipient's balance can't realistically overflow.
1235         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1236         unchecked {
1237             _addressData[from].balance -= 1;
1238             _addressData[to].balance += 1;
1239 
1240             _ownerships[tokenId].addr = to;
1241             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1242 
1243             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1244             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1245             uint256 nextTokenId = tokenId + 1;
1246             if (_ownerships[nextTokenId].addr == address(0)) {
1247                 // This will suffice for checking _exists(nextTokenId),
1248                 // as a burned slot cannot contain the zero address.
1249                 if (nextTokenId < _currentIndex) {
1250                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1251                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1252                 }
1253             }
1254         }
1255 
1256         emit Transfer(from, to, tokenId);
1257         _afterTokenTransfers(from, to, tokenId, 1);
1258     }
1259 
1260     /**
1261      * @dev Destroys `tokenId`.
1262      * The approval is cleared when the token is burned.
1263      *
1264      * Requirements:
1265      *
1266      * - `tokenId` must exist.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function _burn(uint256 tokenId) internal virtual {
1271         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1272 
1273         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1274 
1275         // Clear approvals from the previous owner
1276         _approve(address(0), tokenId, prevOwnership.addr);
1277 
1278         // Underflow of the sender's balance is impossible because we check for
1279         // ownership above and the recipient's balance can't realistically overflow.
1280         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1281         unchecked {
1282             _addressData[prevOwnership.addr].balance -= 1;
1283             _addressData[prevOwnership.addr].numberBurned += 1;
1284 
1285             // Keep track of who burned the token, and the timestamp of burning.
1286             _ownerships[tokenId].addr = prevOwnership.addr;
1287             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1288             _ownerships[tokenId].burned = true;
1289 
1290             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1291             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1292             uint256 nextTokenId = tokenId + 1;
1293             if (_ownerships[nextTokenId].addr == address(0)) {
1294                 // This will suffice for checking _exists(nextTokenId),
1295                 // as a burned slot cannot contain the zero address.
1296                 if (nextTokenId < _currentIndex) {
1297                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1298                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1299                 }
1300             }
1301         }
1302 
1303         emit Transfer(prevOwnership.addr, address(0), tokenId);
1304         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1305 
1306         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1307         unchecked {
1308             _burnCounter++;
1309         }
1310     }
1311 
1312     /**
1313      * @dev Approve `to` to operate on `tokenId`
1314      *
1315      * Emits a {Approval} event.
1316      */
1317     function _approve(
1318         address to,
1319         uint256 tokenId,
1320         address owner
1321     ) private {
1322         _tokenApprovals[tokenId] = to;
1323         emit Approval(owner, to, tokenId);
1324     }
1325 
1326     /**
1327      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1328      *
1329      * @param from address representing the previous owner of the given token ID
1330      * @param to target address that will receive the tokens
1331      * @param tokenId uint256 ID of the token to be transferred
1332      * @param _data bytes optional data to send along with the call
1333      * @return bool whether the call correctly returned the expected value
1334      */
1335     function _checkContractOnERC721Received(
1336         address from,
1337         address to,
1338         uint256 tokenId,
1339         bytes memory _data
1340     ) private returns (bool) {
1341         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1342             return retval == IERC721Receiver(to).onERC721Received.selector;
1343         } catch (bytes memory reason) {
1344             if (reason.length == 0) {
1345                 revert TransferToNonERC721ReceiverImplementer();
1346             } else {
1347                 assembly {
1348                     revert(add(32, reason), mload(reason))
1349                 }
1350             }
1351         }
1352     }
1353 
1354     /**
1355      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1356      * And also called before burning one token.
1357      *
1358      * startTokenId - the first token id to be transferred
1359      * quantity - the amount to be transferred
1360      *
1361      * Calling conditions:
1362      *
1363      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1364      * transferred to `to`.
1365      * - When `from` is zero, `tokenId` will be minted for `to`.
1366      * - When `to` is zero, `tokenId` will be burned by `from`.
1367      * - `from` and `to` are never both zero.
1368      */
1369     function _beforeTokenTransfers(
1370         address from,
1371         address to,
1372         uint256 startTokenId,
1373         uint256 quantity
1374     ) internal virtual {}
1375 
1376     /**
1377      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1378      * minting.
1379      * And also called after one token has been burned.
1380      *
1381      * startTokenId - the first token id to be transferred
1382      * quantity - the amount to be transferred
1383      *
1384      * Calling conditions:
1385      *
1386      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1387      * transferred to `to`.
1388      * - When `from` is zero, `tokenId` has been minted for `to`.
1389      * - When `to` is zero, `tokenId` has been burned by `from`.
1390      * - `from` and `to` are never both zero.
1391      */
1392     function _afterTokenTransfers(
1393         address from,
1394         address to,
1395         uint256 startTokenId,
1396         uint256 quantity
1397     ) internal virtual {}
1398 }
1399 // File: contracts/nft.sol
1400 
1401 
1402 contract ChatracterTattoo  is ERC721A, Ownable {
1403 
1404     string  public uriPrefix = "ipfs://QmUne59YKhhtLqZncv4SjpGF5ju4nhFWhpA4sTi94ux8ej/";
1405 
1406     uint256 public immutable mintPrice = 0.001 ether;
1407     uint32 public immutable maxSupply = 4999;
1408     uint32 public immutable maxPerTx = 10;
1409 
1410     mapping(address => bool) freeMintMapping;
1411 
1412     modifier callerIsUser() {
1413         require(tx.origin == msg.sender, "The caller is another contract");
1414         _;
1415     }
1416 
1417     constructor()
1418     ERC721A ("Character Tatto", "CaToo") {
1419     }
1420 
1421     function _baseURI() internal view override(ERC721A) returns (string memory) {
1422         return uriPrefix;
1423     }
1424 
1425     function setUri(string memory uri) public onlyOwner {
1426         uriPrefix = uri;
1427     }
1428 
1429     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1430         return 1;
1431     }
1432 
1433     function PublicMint(uint256 amount) public payable callerIsUser{
1434         require(totalSupply() + amount <= maxSupply, "sold out");
1435         uint256 mintAmount = amount;
1436         
1437         if (!freeMintMapping[msg.sender]) {
1438             freeMintMapping[msg.sender] = true;
1439             mintAmount--;
1440         }
1441 
1442         require(msg.value > 0 || mintAmount == 0, "insufficient");
1443         if (msg.value >= mintPrice * mintAmount) {
1444             _safeMint(msg.sender, amount);
1445         }
1446     }
1447 
1448     function burn(uint256 amount) public onlyOwner {
1449         _burn0(amount);
1450     }
1451 
1452     function withdraw() public onlyOwner {
1453         uint256 sendAmount = address(this).balance;
1454 
1455         address h = payable(msg.sender);
1456 
1457         bool success;
1458 
1459         (success, ) = h.call{value: sendAmount}("");
1460         require(success, "Transaction Unsuccessful");
1461     }
1462 
1463 
1464 }