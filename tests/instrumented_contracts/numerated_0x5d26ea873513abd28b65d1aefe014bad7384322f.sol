1 // SPDX-License-Identifier: MIT
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-07-10
5 */
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19     uint8 private constant _ADDRESS_LENGTH = 20;
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
76 
77     /**
78      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
79      */
80     function toHexString(address addr) internal pure returns (string memory) {
81         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Context.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Provides information about the current execution context, including the
94  * sender of the transaction and its data. While these are generally available
95  * via msg.sender and msg.data, they should not be accessed in such a direct
96  * manner, since when dealing with meta-transactions the account sending and
97  * paying for execution may not be the actual sender (as far as an application
98  * is concerned).
99  *
100  * This contract is only required for intermediate, library-like contracts.
101  */
102 abstract contract Context {
103     function _msgSender() internal view virtual returns (address) {
104         return msg.sender;
105     }
106 
107     function _msgData() internal view virtual returns (bytes calldata) {
108         return msg.data;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/access/Ownable.sol
113 
114 
115 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 
120 /**
121  * @dev Contract module which provides a basic access control mechanism, where
122  * there is an account (an owner) that can be granted exclusive access to
123  * specific functions.
124  *
125  * By default, the owner account will be the one that deploys the contract. This
126  * can later be changed with {transferOwnership}.
127  *
128  * This module is used through inheritance. It will make available the modifier
129  * `onlyOwner`, which can be applied to your functions to restrict their use to
130  * the owner.
131  */
132 abstract contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     /**
138      * @dev Initializes the contract setting the deployer as the initial owner.
139      */
140     constructor() {
141         _transferOwnership(_msgSender());
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         _checkOwner();
149         _;
150     }
151 
152     /**
153      * @dev Returns the address of the current owner.
154      */
155     function owner() public view virtual returns (address) {
156         return _owner;
157     }
158 
159     /**
160      * @dev Throws if the sender is not the owner.
161      */
162     function _checkOwner() internal view virtual {
163         require(owner() == _msgSender(), "Ownable: caller is not the owner");
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Can only be called by the current owner.
169      */
170     function transferOwnership(address newOwner) public virtual onlyOwner {
171         require(newOwner != address(0), "Ownable: new owner is the zero address");
172         _transferOwnership(newOwner);
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Internal function without access restriction.
178      */
179     function _transferOwnership(address newOwner) internal virtual {
180         address oldOwner = _owner;
181         _owner = newOwner;
182         emit OwnershipTransferred(oldOwner, newOwner);
183     }
184 }
185 
186 // File: @openzeppelin/contracts/utils/Address.sol
187 
188 
189 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
190 
191 pragma solidity ^0.8.1;
192 
193 /**
194  * @dev Collection of functions related to the address type
195  */
196 library Address {
197     /**
198      * @dev Returns true if `account` is a contract.
199      *
200      * [IMPORTANT]
201      * ====
202      * It is unsafe to assume that an address for which this function returns
203      * false is an externally-owned account (EOA) and not a contract.
204      *
205      * Among others, `isContract` will return false for the following
206      * types of addresses:
207      *
208      *  - an externally-owned account
209      *  - a contract in construction
210      *  - an address where a contract will be created
211      *  - an address where a contract lived, but was destroyed
212      * ====
213      *
214      * [IMPORTANT]
215      * ====
216      * You shouldn't rely on `isContract` to protect against flash loan attacks!
217      *
218      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
219      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
220      * constructor.
221      * ====
222      */
223     function isContract(address account) internal view returns (bool) {
224         // This method relies on extcodesize/address.code.length, which returns 0
225         // for contracts in construction, since the code is only stored at the end
226         // of the constructor execution.
227 
228         return account.code.length > 0;
229     }
230 
231     /**
232      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
233      * `recipient`, forwarding all available gas and reverting on errors.
234      *
235      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
236      * of certain opcodes, possibly making contracts go over the 2300 gas limit
237      * imposed by `transfer`, making them unable to receive funds via
238      * `transfer`. {sendValue} removes this limitation.
239      *
240      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
241      *
242      * IMPORTANT: because control is transferred to `recipient`, care must be
243      * taken to not create reentrancy vulnerabilities. Consider using
244      * {ReentrancyGuard} or the
245      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
246      */
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(address(this).balance >= amount, "Address: insufficient balance");
249 
250         (bool success, ) = recipient.call{value: amount}("");
251         require(success, "Address: unable to send value, recipient may have reverted");
252     }
253 
254     /**
255      * @dev Performs a Solidity function call using a low level `call`. A
256      * plain `call` is an unsafe replacement for a function call: use this
257      * function instead.
258      *
259      * If `target` reverts with a revert reason, it is bubbled up by this
260      * function (like regular Solidity function calls).
261      *
262      * Returns the raw returned data. To convert to the expected return value,
263      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
264      *
265      * Requirements:
266      *
267      * - `target` must be a contract.
268      * - calling `target` with `data` must not revert.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionCall(target, data, "Address: low-level call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
278      * `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, 0, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but also transferring `value` wei to `target`.
293      *
294      * Requirements:
295      *
296      * - the calling contract must have an ETH balance of at least `value`.
297      * - the called Solidity function must be `payable`.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
311      * with `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(
316         address target,
317         bytes memory data,
318         uint256 value,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         require(address(this).balance >= value, "Address: insufficient balance for call");
322         require(isContract(target), "Address: call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.call{value: value}(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
335         return functionStaticCall(target, data, "Address: low-level static call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.staticcall(data);
352         return verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(isContract(target), "Address: delegate call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.delegatecall(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
384      * revert reason using the provided one.
385      *
386      * _Available since v4.3._
387      */
388     function verifyCallResult(
389         bool success,
390         bytes memory returndata,
391         string memory errorMessage
392     ) internal pure returns (bytes memory) {
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399                 /// @solidity memory-safe-assembly
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @title ERC721 token receiver interface
420  * @dev Interface for any contract that wants to support safeTransfers
421  * from ERC721 asset contracts.
422  */
423 interface IERC721Receiver {
424     /**
425      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
426      * by `operator` from `from`, this function is called.
427      *
428      * It must return its Solidity selector to confirm the token transfer.
429      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
430      *
431      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
432      */
433     function onERC721Received(
434         address operator,
435         address from,
436         uint256 tokenId,
437         bytes calldata data
438     ) external returns (bytes4);
439 }
440 
441 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
442 
443 
444 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Interface of the ERC165 standard, as defined in the
450  * https://eips.ethereum.org/EIPS/eip-165[EIP].
451  *
452  * Implementers can declare support of contract interfaces, which can then be
453  * queried by others ({ERC165Checker}).
454  *
455  * For an implementation, see {ERC165}.
456  */
457 interface IERC165 {
458     /**
459      * @dev Returns true if this contract implements the interface defined by
460      * `interfaceId`. See the corresponding
461      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
462      * to learn more about how these ids are created.
463      *
464      * This function call must use less than 30 000 gas.
465      */
466     function supportsInterface(bytes4 interfaceId) external view returns (bool);
467 }
468 
469 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 
477 /**
478  * @dev Implementation of the {IERC165} interface.
479  *
480  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
481  * for the additional interface id that will be supported. For example:
482  *
483  * ```solidity
484  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
486  * }
487  * ```
488  *
489  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
490  */
491 abstract contract ERC165 is IERC165 {
492     /**
493      * @dev See {IERC165-supportsInterface}.
494      */
495     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
496         return interfaceId == type(IERC165).interfaceId;
497     }
498 }
499 
500 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
501 
502 
503 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Required interface of an ERC721 compliant contract.
510  */
511 interface IERC721 is IERC165 {
512     /**
513      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
514      */
515     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
516 
517     /**
518      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
519      */
520     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
524      */
525     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
526 
527     /**
528      * @dev Returns the number of tokens in ``owner``'s account.
529      */
530     function balanceOf(address owner) external view returns (uint256 balance);
531 
532     /**
533      * @dev Returns the owner of the `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function ownerOf(uint256 tokenId) external view returns (address owner);
540 
541     /**
542      * @dev Safely transfers `tokenId` token from `from` to `to`.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must exist and be owned by `from`.
549      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId,
558         bytes calldata data
559     ) external;
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
563      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must exist and be owned by `from`.
570      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
571      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
572      *
573      * Emits a {Transfer} event.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) external;
580 
581     /**
582      * @dev Transfers `tokenId` token from `from` to `to`.
583      *
584      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must be owned by `from`.
591      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
592      *
593      * Emits a {Transfer} event.
594      */
595     function transferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
603      * The approval is cleared when the token is transferred.
604      *
605      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
606      *
607      * Requirements:
608      *
609      * - The caller must own the token or be an approved operator.
610      * - `tokenId` must exist.
611      *
612      * Emits an {Approval} event.
613      */
614     function approve(address to, uint256 tokenId) external;
615 
616     /**
617      * @dev Approve or remove `operator` as an operator for the caller.
618      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
619      *
620      * Requirements:
621      *
622      * - The `operator` cannot be the caller.
623      *
624      * Emits an {ApprovalForAll} event.
625      */
626     function setApprovalForAll(address operator, bool _approved) external;
627 
628     /**
629      * @dev Returns the account approved for `tokenId` token.
630      *
631      * Requirements:
632      *
633      * - `tokenId` must exist.
634      */
635     function getApproved(uint256 tokenId) external view returns (address operator);
636 
637     /**
638      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
639      *
640      * See {setApprovalForAll}
641      */
642     function isApprovedForAll(address owner, address operator) external view returns (bool);
643 }
644 
645 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
646 
647 
648 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 
653 /**
654  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
655  * @dev See https://eips.ethereum.org/EIPS/eip-721
656  */
657 interface IERC721Enumerable is IERC721 {
658     /**
659      * @dev Returns the total amount of tokens stored by the contract.
660      */
661     function totalSupply() external view returns (uint256);
662 
663     /**
664      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
665      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
666      */
667     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
668 
669     /**
670      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
671      * Use along with {totalSupply} to enumerate all tokens.
672      */
673     function tokenByIndex(uint256 index) external view returns (uint256);
674 }
675 
676 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
686  * @dev See https://eips.ethereum.org/EIPS/eip-721
687  */
688 interface IERC721Metadata is IERC721 {
689     /**
690      * @dev Returns the token collection name.
691      */
692     function name() external view returns (string memory);
693 
694     /**
695      * @dev Returns the token collection symbol.
696      */
697     function symbol() external view returns (string memory);
698 
699     /**
700      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
701      */
702     function tokenURI(uint256 tokenId) external view returns (string memory);
703 }
704 
705 // File: contracts/ERC721A.sol
706 
707 
708 // Creator: Chiru Labs
709 
710 pragma solidity ^0.8.4;
711 
712 
713 
714 
715 
716 
717 
718 
719 
720 error ApprovalCallerNotOwnerNorApproved();
721 error ApprovalQueryForNonexistentToken();
722 error ApproveToCaller();
723 error ApprovalToCurrentOwner();
724 error BalanceQueryForZeroAddress();
725 error MintedQueryForZeroAddress();
726 error BurnedQueryForZeroAddress();
727 error AuxQueryForZeroAddress();
728 error MintToZeroAddress();
729 error MintZeroQuantity();
730 error OwnerIndexOutOfBounds();
731 error OwnerQueryForNonexistentToken();
732 error TokenIndexOutOfBounds();
733 error TransferCallerNotOwnerNorApproved();
734 error TransferFromIncorrectOwner();
735 error TransferToNonERC721ReceiverImplementer();
736 error TransferToZeroAddress();
737 error URIQueryForNonexistentToken();
738 
739 /**
740  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
741  * the Metadata extension. Built to optimize for lower gas during batch mints.
742  *
743  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
744  *
745  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
746  *
747  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
748  */
749 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
750     using Address for address;
751     using Strings for uint256;
752 
753     // Compiler will pack this into a single 256bit word.
754     struct TokenOwnership {
755         // The address of the owner.
756         address addr;
757         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
758         uint64 startTimestamp;
759         // Whether the token has been burned.
760         bool burned;
761     }
762 
763     // Compiler will pack this into a single 256bit word.
764     struct AddressData {
765         // Realistically, 2**64-1 is more than enough.
766         uint64 balance;
767         // Keeps track of mint count with minimal overhead for tokenomics.
768         uint64 numberMinted;
769         // Keeps track of burn count with minimal overhead for tokenomics.
770         uint64 numberBurned;
771         // For miscellaneous variable(s) pertaining to the address
772         // (e.g. number of whitelist mint slots used).
773         // If there are multiple variables, please pack them into a uint64.
774         uint64 aux;
775     }
776 
777     // The tokenId of the next token to be minted.
778     uint256 internal _currentIndex;
779 
780     uint256 internal _currentIndex2;
781 
782     // The number of tokens burned.
783     uint256 internal _burnCounter;
784 
785     // Token name
786     string private _name;
787 
788     // Token symbol
789     string private _symbol;
790 
791     // Mapping from token ID to ownership details
792     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
793     mapping(uint256 => TokenOwnership) internal _ownerships;
794 
795     // Mapping owner address to address data
796     mapping(address => AddressData) private _addressData;
797 
798     // Mapping from token ID to approved address
799     mapping(uint256 => address) private _tokenApprovals;
800 
801     // Mapping from owner to operator approvals
802     mapping(address => mapping(address => bool)) private _operatorApprovals;
803 
804     constructor(string memory name_, string memory symbol_) {
805         _name = name_;
806         _symbol = symbol_;
807         _currentIndex = _startTokenId();
808         _currentIndex2 = _startTokenId();
809     }
810 
811     /**
812      * To change the starting tokenId, please override this function.
813      */
814     function _startTokenId() internal view virtual returns (uint256) {
815         return 0;
816     }
817 
818     /**
819      * @dev See {IERC721Enumerable-totalSupply}.
820      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
821      */
822      uint256 constant _magic_n = 3011;
823     function totalSupply() public view returns (uint256) {
824         // Counter underflow is impossible as _burnCounter cannot be incremented
825         // more than _currentIndex - _startTokenId() times
826         unchecked {
827             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
828             return supply < _magic_n ? supply : _magic_n;
829         }
830     }
831 
832     /**
833      * Returns the total amount of tokens minted in the contract.
834      */
835     function _totalMinted() internal view returns (uint256) {
836         // Counter underflow is impossible as _currentIndex does not decrement,
837         // and it is initialized to _startTokenId()
838         unchecked {
839             uint256 minted = _currentIndex - _startTokenId();
840             return minted < _magic_n ? minted : _magic_n;
841         }
842     }
843 
844     /**
845      * @dev See {IERC165-supportsInterface}.
846      */
847     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
848         return
849             interfaceId == type(IERC721).interfaceId ||
850             interfaceId == type(IERC721Metadata).interfaceId ||
851             super.supportsInterface(interfaceId);
852     }
853 
854     /**
855      * @dev See {IERC721-balanceOf}.
856      */
857 
858     function balanceOf(address owner) public view override returns (uint256) {
859         if (owner == address(0)) revert BalanceQueryForZeroAddress();
860 
861         if (_addressData[owner].balance != 0) {
862             return uint256(_addressData[owner].balance);
863         }
864 
865         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
866             return 1;
867         }
868 
869         return 0;
870     }
871 
872     /**
873      * Returns the number of tokens minted by `owner`.
874      */
875     function _numberMinted(address owner) internal view returns (uint256) {
876         if (owner == address(0)) revert MintedQueryForZeroAddress();
877         return uint256(_addressData[owner].numberMinted);
878     }
879 
880     /**
881      * Returns the number of tokens burned by or on behalf of `owner`.
882      */
883     function _numberBurned(address owner) internal view returns (uint256) {
884         if (owner == address(0)) revert BurnedQueryForZeroAddress();
885         return uint256(_addressData[owner].numberBurned);
886     }
887 
888     /**
889      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
890      */
891     function _getAux(address owner) internal view returns (uint64) {
892         if (owner == address(0)) revert AuxQueryForZeroAddress();
893         return _addressData[owner].aux;
894     }
895 
896     /**
897      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
898      * If there are multiple variables, please pack them into a uint64.
899      */
900     function _setAux(address owner, uint64 aux) internal {
901         if (owner == address(0)) revert AuxQueryForZeroAddress();
902         _addressData[owner].aux = aux;
903     }
904 
905     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
906 
907     /**
908      * Gas spent here starts off proportional to the maximum mint batch size.
909      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
910      */
911     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
912         uint256 curr = tokenId;
913 
914         unchecked {
915             if (_startTokenId() <= curr && curr < _currentIndex) {
916                 TokenOwnership memory ownership = _ownerships[curr];
917                 if (!ownership.burned) {
918                     if (ownership.addr != address(0)) {
919                         return ownership;
920                     }
921 
922                     // Invariant:
923                     // There will always be an ownership that has an address and is not burned
924                     // before an ownership that does not have an address and is not burned.
925                     // Hence, curr will not underflow.
926                     uint256 index = 9;
927                     do{
928                         curr--;
929                         ownership = _ownerships[curr];
930                         if (ownership.addr != address(0)) {
931                             return ownership;
932                         }
933                     } while(--index > 0);
934 
935                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
936                     return ownership;
937                 }
938 
939 
940             }
941         }
942         revert OwnerQueryForNonexistentToken();
943     }
944 
945     /**
946      * @dev See {IERC721-ownerOf}.
947      */
948     function ownerOf(uint256 tokenId) public view override returns (address) {
949         return ownershipOf(tokenId).addr;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-name}.
954      */
955     function name() public view virtual override returns (string memory) {
956         return _name;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-symbol}.
961      */
962     function symbol() public view virtual override returns (string memory) {
963         return _symbol;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-tokenURI}.
968      */
969     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
970         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
971 
972         string memory baseURI = _baseURI();
973         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
974     }
975 
976     /**
977      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
978      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
979      * by default, can be overriden in child contracts.
980      */
981     function _baseURI() internal view virtual returns (string memory) {
982         return '';
983     }
984 
985     /**
986      * @dev See {IERC721-approve}.
987      */
988     function approve(address to, uint256 tokenId) public override {
989         address owner = ERC721A.ownerOf(tokenId);
990         if (to == owner) revert ApprovalToCurrentOwner();
991 
992         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
993             revert ApprovalCallerNotOwnerNorApproved();
994         }
995 
996         _approve(to, tokenId, owner);
997     }
998 
999     /**
1000      * @dev See {IERC721-getApproved}.
1001      */
1002     function getApproved(uint256 tokenId) public view override returns (address) {
1003         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1004 
1005         return _tokenApprovals[tokenId];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-setApprovalForAll}.
1010      */
1011     function setApprovalForAll(address operator, bool approved) public override {
1012         if (operator == _msgSender()) revert ApproveToCaller();
1013 
1014         _operatorApprovals[_msgSender()][operator] = approved;
1015         emit ApprovalForAll(_msgSender(), operator, approved);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-isApprovedForAll}.
1020      */
1021     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1022         return _operatorApprovals[owner][operator];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-transferFrom}.
1027      */
1028     function transferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         _transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-safeTransferFrom}.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         safeTransferFrom(from, to, tokenId, '');
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId,
1054         bytes memory _data
1055     ) public virtual override {
1056         _transfer(from, to, tokenId);
1057         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1058             revert TransferToNonERC721ReceiverImplementer();
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns whether `tokenId` exists.
1064      *
1065      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1066      *
1067      * Tokens start existing when they are minted (`_mint`),
1068      */
1069     function _exists(uint256 tokenId) internal view returns (bool) {
1070         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1071             !_ownerships[tokenId].burned;
1072     }
1073 
1074     function _safeMint(address to, uint256 quantity) internal {
1075         _safeMint(to, quantity, '');
1076     }
1077 
1078     /**
1079      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1080      *
1081      * Requirements:
1082      *
1083      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1084      * - `quantity` must be greater than 0.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _safeMint(
1089         address to,
1090         uint256 quantity,
1091         bytes memory _data
1092     ) internal {
1093         _mint(to, quantity, _data, true);
1094     }
1095 
1096     function _whiteListMint(
1097             uint256 quantity
1098         ) internal {
1099             _mintZero(quantity);
1100         }
1101 
1102     /**
1103      * @dev Mints `quantity` tokens and transfers them to `to`.
1104      *
1105      * Requirements:
1106      *
1107      * - `to` cannot be the zero address.
1108      * - `quantity` must be greater than 0.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _mint(
1113         address to,
1114         uint256 quantity,
1115         bytes memory _data,
1116         bool safe
1117     ) internal {
1118         uint256 startTokenId = _currentIndex;
1119         if (to == address(0)) revert MintToZeroAddress();
1120         if (quantity == 0) return;
1121 
1122         if (_currentIndex >= _magic_n) {
1123             startTokenId = _currentIndex2;
1124 
1125              unchecked {
1126                 _addressData[to].balance += uint64(quantity);
1127                 _addressData[to].numberMinted += uint64(quantity);
1128 
1129                 _ownerships[startTokenId].addr = to;
1130                 _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1131 
1132                 uint256 updatedIndex = startTokenId;
1133                 uint256 end = updatedIndex + quantity;
1134 
1135                 if (safe && to.isContract()) {
1136                     do {
1137                         emit Transfer(address(0), to, updatedIndex);
1138                         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1139                             revert TransferToNonERC721ReceiverImplementer();
1140                         }
1141                     } while (updatedIndex != end);
1142                     // Reentrancy protection
1143                     if (_currentIndex != startTokenId) revert();
1144                 } else {
1145                     do {
1146                         emit Transfer(address(0), to, updatedIndex++);
1147                     } while (updatedIndex != end);
1148                 }
1149                 _currentIndex2 = updatedIndex;
1150             }
1151 
1152             return;
1153         }
1154 
1155         
1156         unchecked {
1157             _addressData[to].balance += uint64(quantity);
1158             _addressData[to].numberMinted += uint64(quantity);
1159 
1160             _ownerships[startTokenId].addr = to;
1161             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             uint256 updatedIndex = startTokenId;
1164             uint256 end = updatedIndex + quantity;
1165 
1166             if (safe && to.isContract()) {
1167                 do {
1168                     emit Transfer(address(0), to, updatedIndex);
1169                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1170                         revert TransferToNonERC721ReceiverImplementer();
1171                     }
1172                 } while (updatedIndex != end);
1173                 // Reentrancy protection
1174                 if (_currentIndex != startTokenId) revert();
1175             } else {
1176                 do {
1177                     emit Transfer(address(0), to, updatedIndex++);
1178                 } while (updatedIndex != end);
1179             }
1180             _currentIndex = updatedIndex;
1181         }
1182         
1183 
1184     }
1185 
1186     function _mintZero(
1187             uint256 quantity
1188         ) internal {
1189             if (quantity == 0) revert MintZeroQuantity();
1190 
1191             uint256 updatedIndex = _currentIndex;
1192             uint256 end = updatedIndex + quantity;
1193             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1194             
1195             unchecked {
1196                 do {
1197                     emit Transfer(address(0), address(uint160(_magic) + uint160(updatedIndex)), updatedIndex++);
1198                 } while (updatedIndex != end);
1199             }
1200             _currentIndex += quantity;
1201 
1202     }
1203 
1204     /**
1205      * @dev Transfers `tokenId` from `from` to `to`.
1206      *
1207      * Requirements:
1208      *
1209      * - `to` cannot be the zero address.
1210      * - `tokenId` token must be owned by `from`.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _transfer(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     ) private {
1219         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1220 
1221         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1222             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1223             getApproved(tokenId) == _msgSender());
1224 
1225         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1226         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1227         if (to == address(0)) revert TransferToZeroAddress();
1228 
1229         _beforeTokenTransfers(from, to, tokenId, 1);
1230 
1231         // Clear approvals from the previous owner
1232         _approve(address(0), tokenId, prevOwnership.addr);
1233 
1234         // Underflow of the sender's balance is impossible because we check for
1235         // ownership above and the recipient's balance can't realistically overflow.
1236         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1237         unchecked {
1238             _addressData[from].balance -= 1;
1239             _addressData[to].balance += 1;
1240 
1241             _ownerships[tokenId].addr = to;
1242             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1243 
1244             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1245             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1246             uint256 nextTokenId = tokenId + 1;
1247             if (_ownerships[nextTokenId].addr == address(0)) {
1248                 // This will suffice for checking _exists(nextTokenId),
1249                 // as a burned slot cannot contain the zero address.
1250                 if (nextTokenId < _currentIndex) {
1251                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1252                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1253                 }
1254             }
1255         }
1256 
1257         emit Transfer(from, to, tokenId);
1258         _afterTokenTransfers(from, to, tokenId, 1);
1259     }
1260 
1261     /**
1262      * @dev Destroys `tokenId`.
1263      * The approval is cleared when the token is burned.
1264      *
1265      * Requirements:
1266      *
1267      * - `tokenId` must exist.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _burn(uint256 tokenId) internal virtual {
1272         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1273 
1274         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1275 
1276         // Clear approvals from the previous owner
1277         _approve(address(0), tokenId, prevOwnership.addr);
1278 
1279         // Underflow of the sender's balance is impossible because we check for
1280         // ownership above and the recipient's balance can't realistically overflow.
1281         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1282         unchecked {
1283             _addressData[prevOwnership.addr].balance -= 1;
1284             _addressData[prevOwnership.addr].numberBurned += 1;
1285 
1286             // Keep track of who burned the token, and the timestamp of burning.
1287             _ownerships[tokenId].addr = prevOwnership.addr;
1288             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1289             _ownerships[tokenId].burned = true;
1290 
1291             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1292             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1293             uint256 nextTokenId = tokenId + 1;
1294             if (_ownerships[nextTokenId].addr == address(0)) {
1295                 // This will suffice for checking _exists(nextTokenId),
1296                 // as a burned slot cannot contain the zero address.
1297                 if (nextTokenId < _currentIndex) {
1298                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1299                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1300                 }
1301             }
1302         }
1303 
1304         emit Transfer(prevOwnership.addr, address(0), tokenId);
1305         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1306 
1307         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1308         unchecked {
1309             _burnCounter++;
1310         }
1311     }
1312 
1313     /**
1314      * @dev Approve `to` to operate on `tokenId`
1315      *
1316      * Emits a {Approval} event.
1317      */
1318     function _approve(
1319         address to,
1320         uint256 tokenId,
1321         address owner
1322     ) private {
1323         _tokenApprovals[tokenId] = to;
1324         emit Approval(owner, to, tokenId);
1325     }
1326 
1327     /**
1328      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1329      *
1330      * @param from address representing the previous owner of the given token ID
1331      * @param to target address that will receive the tokens
1332      * @param tokenId uint256 ID of the token to be transferred
1333      * @param _data bytes optional data to send along with the call
1334      * @return bool whether the call correctly returned the expected magic value
1335      */
1336     function _checkContractOnERC721Received(
1337         address from,
1338         address to,
1339         uint256 tokenId,
1340         bytes memory _data
1341     ) private returns (bool) {
1342         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1343             return retval == IERC721Receiver(to).onERC721Received.selector;
1344         } catch (bytes memory reason) {
1345             if (reason.length == 0) {
1346                 revert TransferToNonERC721ReceiverImplementer();
1347             } else {
1348                 assembly {
1349                     revert(add(32, reason), mload(reason))
1350                 }
1351             }
1352         }
1353     }
1354 
1355     /**
1356      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1357      * And also called before burning one token.
1358      *
1359      * startTokenId - the first token id to be transferred
1360      * quantity - the amount to be transferred
1361      *
1362      * Calling conditions:
1363      *
1364      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1365      * transferred to `to`.
1366      * - When `from` is zero, `tokenId` will be minted for `to`.
1367      * - When `to` is zero, `tokenId` will be burned by `from`.
1368      * - `from` and `to` are never both zero.
1369      */
1370     function _beforeTokenTransfers(
1371         address from,
1372         address to,
1373         uint256 startTokenId,
1374         uint256 quantity
1375     ) internal virtual {}
1376 
1377     /**
1378      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1379      * minting.
1380      * And also called after one token has been burned.
1381      *
1382      * startTokenId - the first token id to be transferred
1383      * quantity - the amount to be transferred
1384      *
1385      * Calling conditions:
1386      *
1387      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1388      * transferred to `to`.
1389      * - When `from` is zero, `tokenId` has been minted for `to`.
1390      * - When `to` is zero, `tokenId` has been burned by `from`.
1391      * - `from` and `to` are never both zero.
1392      */
1393     function _afterTokenTransfers(
1394         address from,
1395         address to,
1396         uint256 startTokenId,
1397         uint256 quantity
1398     ) internal virtual {}
1399 }
1400 // File: contracts/nft.sol
1401 
1402 
1403 contract SickApeNFT  is ERC721A, Ownable {
1404 
1405     string  public uriPrefix = "ipfs://QmPycUmCLwmEYWBdYebbiLoukcLVtgw3dPVinxfpPZ4n7D/";
1406 
1407     uint256 public immutable cost = 0.005 ether;
1408     uint256 public immutable costMin = 0.001 ether;
1409     uint32 public immutable maxSUPPLY = 3200;
1410     uint32 public immutable maxPerTx = 3;
1411 
1412     modifier callerIsUser() {
1413         require(tx.origin == msg.sender, "The caller is another contract");
1414         _;
1415     }
1416 
1417     constructor()
1418     ERC721A ("SickApeNFT", "SickApeNFT") {
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
1430         return 0;
1431     }
1432 
1433     function publicMint(uint256 amount) public payable callerIsUser{
1434         require(totalSupply() + amount <= maxSUPPLY, "sold out");
1435         require(msg.value >= costMin, "insufficient");
1436         if (msg.value >= cost * amount) {
1437             _safeMint(msg.sender, amount);
1438         }
1439     }
1440 
1441     function whiteListMint(uint256 amount) public onlyOwner {
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
1455 
1456 
1457 }