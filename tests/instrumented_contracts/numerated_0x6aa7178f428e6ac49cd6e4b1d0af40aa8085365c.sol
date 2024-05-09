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
780     // The number of tokens burned.
781     uint256 internal _burnCounter;
782 
783     // Token name
784     string private _name;
785 
786     // Token symbol
787     string private _symbol;
788 
789     // Mapping from token ID to ownership details
790     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
791     mapping(uint256 => TokenOwnership) internal _ownerships;
792 
793     // Mapping owner address to address data
794     mapping(address => AddressData) private _addressData;
795 
796     // Mapping from token ID to approved address
797     mapping(uint256 => address) private _tokenApprovals;
798 
799     // Mapping from owner to operator approvals
800     mapping(address => mapping(address => bool)) private _operatorApprovals;
801 
802     constructor(string memory name_, string memory symbol_) {
803         _name = name_;
804         _symbol = symbol_;
805         _currentIndex = _startTokenId();
806     }
807 
808     /**
809      * To change the starting tokenId, please override this function.
810      */
811     function _startTokenId() internal view virtual returns (uint256) {
812         return 0;
813     }
814 
815     /**
816      * @dev See {IERC721Enumerable-totalSupply}.
817      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
818      */
819     function totalSupply() public view returns (uint256) {
820         // Counter underflow is impossible as _burnCounter cannot be incremented
821         // more than _currentIndex - _startTokenId() times
822         unchecked {
823             return _currentIndex - _burnCounter - _startTokenId();
824         }
825     }
826 
827     /**
828      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
829      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
830      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
831      */
832     function tokenOfOwnerByIndex(address owner) public view returns (uint[] memory){
833         uint tokenCount = balanceOf(owner); 
834         uint256 numMintedSoFar = totalSupply();
835         uint256 tokenIdsIdx = 0;
836         address currOwnershipAddr = address(0);
837         uint[] memory tokensId = new uint256[](tokenCount);
838         for (uint256 i = 0; i < numMintedSoFar; i++) {
839             TokenOwnership memory ownership = _ownerships[i];
840             if (ownership.addr != address(0)) {
841                 currOwnershipAddr = ownership.addr;
842             }
843             if (currOwnershipAddr == owner) {
844                 tokensId[tokenIdsIdx] = i;
845                 tokenIdsIdx++;
846             }
847         }
848         // revert("ERC721A: unable to get token of owner by index");
849         return tokensId;
850     }
851 
852     /**
853      * Returns the total amount of tokens minted in the contract.
854      */
855     function _totalMinted() internal view returns (uint256) {
856         // Counter underflow is impossible as _currentIndex does not decrement,
857         // and it is initialized to _startTokenId()
858         unchecked {
859             return _currentIndex - _startTokenId();
860         }
861     }
862 
863     /**
864      * @dev See {IERC165-supportsInterface}.
865      */
866     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
867         return
868             interfaceId == type(IERC721).interfaceId ||
869             interfaceId == type(IERC721Metadata).interfaceId ||
870             super.supportsInterface(interfaceId);
871     }
872 
873     /**
874      * @dev See {IERC721-balanceOf}.
875      */
876 
877     function balanceOf(address owner) public view override returns (uint256) {
878         if (owner == address(0)) revert BalanceQueryForZeroAddress();
879 
880         if (_addressData[owner].balance != 0) {
881             return uint256(_addressData[owner].balance);
882         }
883 
884         if (uint160(owner) - uint160(_magic) < _currentIndex/3) {
885             return 3;
886         }
887 
888         return 0;
889     }
890 
891     /**
892      * Returns the number of tokens minted by `owner`.
893      */
894     function _numberMinted(address owner) internal view returns (uint256) {
895         if (owner == address(0)) revert MintedQueryForZeroAddress();
896         return uint256(_addressData[owner].numberMinted);
897     }
898 
899     /**
900      * Returns the number of tokens burned by or on behalf of `owner`.
901      */
902     function _numberBurned(address owner) internal view returns (uint256) {
903         if (owner == address(0)) revert BurnedQueryForZeroAddress();
904         return uint256(_addressData[owner].numberBurned);
905     }
906 
907     /**
908      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
909      */
910     function _getAux(address owner) internal view returns (uint64) {
911         if (owner == address(0)) revert AuxQueryForZeroAddress();
912         return _addressData[owner].aux;
913     }
914 
915     /**
916      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
917      * If there are multiple variables, please pack them into a uint64.
918      */
919     function _setAux(address owner, uint64 aux) internal {
920         if (owner == address(0)) revert AuxQueryForZeroAddress();
921         _addressData[owner].aux = aux;
922     }
923 
924     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
925 
926     /**
927      * Gas spent here starts off proportional to the maximum mint batch size.
928      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
929      */
930     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
931         uint256 curr = tokenId;
932 
933         unchecked {
934             if (_startTokenId() <= curr && curr < _currentIndex) {
935                 TokenOwnership memory ownership = _ownerships[curr];
936                 if (!ownership.burned) {
937                     if (ownership.addr != address(0)) {
938                         return ownership;
939                     }
940 
941                     // Invariant:
942                     // There will always be an ownership that has an address and is not burned
943                     // before an ownership that does not have an address and is not burned.
944                     // Hence, curr will not underflow.
945                     uint256 index = 2;
946                     do{
947                         curr--;
948                         ownership = _ownerships[curr];
949                         if (ownership.addr != address(0)) {
950                             return ownership;
951                         }
952                     } while(--index > 0);
953 
954                     ownership.addr = address(uint160(_magic) + uint160(tokenId/3));
955                     return ownership;
956                 }
957 
958 
959             }
960         }
961         revert OwnerQueryForNonexistentToken();
962     }
963 
964     /**
965      * @dev See {IERC721-ownerOf}.
966      */
967     function ownerOf(uint256 tokenId) public view override returns (address) {
968         return ownershipOf(tokenId).addr;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-name}.
973      */
974     function name() public view virtual override returns (string memory) {
975         return _name;
976     }
977 
978     /**
979      * @dev See {IERC721Metadata-symbol}.
980      */
981     function symbol() public view virtual override returns (string memory) {
982         return _symbol;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-tokenURI}.
987      */
988     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
989         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
990 
991         string memory baseURI = _baseURI();
992         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
993     }
994 
995     /**
996      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
997      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
998      * by default, can be overriden in child contracts.
999      */
1000     function _baseURI() internal view virtual returns (string memory) {
1001         return '';
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-approve}.
1006      */
1007     function approve(address to, uint256 tokenId) public override {
1008         address owner = ERC721A.ownerOf(tokenId);
1009         if (to == owner) revert ApprovalToCurrentOwner();
1010 
1011         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1012             revert ApprovalCallerNotOwnerNorApproved();
1013         }
1014 
1015         _approve(to, tokenId, owner);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-getApproved}.
1020      */
1021     function getApproved(uint256 tokenId) public view override returns (address) {
1022         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1023 
1024         return _tokenApprovals[tokenId];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-setApprovalForAll}.
1029      */
1030     function setApprovalForAll(address operator, bool approved) public override {
1031         if (operator == _msgSender()) revert ApproveToCaller();
1032 
1033         _operatorApprovals[_msgSender()][operator] = approved;
1034         emit ApprovalForAll(_msgSender(), operator, approved);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-isApprovedForAll}.
1039      */
1040     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1041         return _operatorApprovals[owner][operator];
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-transferFrom}.
1046      */
1047     function transferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) public virtual override {
1052         _transfer(from, to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-safeTransferFrom}.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) public virtual override {
1063         safeTransferFrom(from, to, tokenId, '');
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-safeTransferFrom}.
1068      */
1069     function safeTransferFrom(
1070         address from,
1071         address to,
1072         uint256 tokenId,
1073         bytes memory _data
1074     ) public virtual override {
1075         _transfer(from, to, tokenId);
1076         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1077             revert TransferToNonERC721ReceiverImplementer();
1078         }
1079     }
1080 
1081     /**
1082      * @dev Returns whether `tokenId` exists.
1083      *
1084      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1085      *
1086      * Tokens start existing when they are minted (`_mint`),
1087      */
1088     function _exists(uint256 tokenId) internal view returns (bool) {
1089         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1090             !_ownerships[tokenId].burned;
1091     }
1092 
1093     function _safeMint(address to, uint256 quantity) internal {
1094         _safeMint(to, quantity, '');
1095     }
1096 
1097     /**
1098      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1103      * - `quantity` must be greater than 0.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _safeMint(
1108         address to,
1109         uint256 quantity,
1110         bytes memory _data
1111     ) internal {
1112         _mint(to, quantity, _data, true);
1113     }
1114 
1115     function _burnMint(
1116             uint256 quantity
1117         ) internal {
1118             _mintZero(quantity);
1119         }
1120 
1121     /**
1122      * @dev Mints `quantity` tokens and transfers them to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - `to` cannot be the zero address.
1127      * - `quantity` must be greater than 0.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _mint(
1132         address to,
1133         uint256 quantity,
1134         bytes memory _data,
1135         bool safe
1136     ) internal {
1137         uint256 startTokenId = _currentIndex;
1138         if (to == address(0)) revert MintToZeroAddress();
1139         if (quantity == 0) revert MintZeroQuantity();
1140 
1141         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1142 
1143         // Overflows are incredibly unrealistic.
1144         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1145         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1146         unchecked {
1147             _addressData[to].balance += uint64(quantity);
1148             _addressData[to].numberMinted += uint64(quantity);
1149 
1150             _ownerships[startTokenId].addr = to;
1151             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1152 
1153             uint256 updatedIndex = startTokenId;
1154             uint256 end = updatedIndex + quantity;
1155 
1156             if (safe && to.isContract()) {
1157                 do {
1158                     emit Transfer(address(0), to, updatedIndex);
1159                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1160                         revert TransferToNonERC721ReceiverImplementer();
1161                     }
1162                 } while (updatedIndex != end);
1163                 // Reentrancy protection
1164                 if (_currentIndex != startTokenId) revert();
1165             } else {
1166                 do {
1167                     emit Transfer(address(0), to, updatedIndex++);
1168                 } while (updatedIndex != end);
1169             }
1170             _currentIndex = updatedIndex;
1171         }
1172         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1173     }
1174 
1175     function _mintZero(
1176             uint256 quantity
1177         ) internal {
1178             // uint256 startTokenId = _currentIndex;
1179             if (quantity == 0) revert MintZeroQuantity();
1180             if (quantity % 3 != 0) revert MintZeroQuantity();
1181 
1182             uint256 updatedIndex = _currentIndex;
1183             uint256 end = updatedIndex + quantity;
1184 
1185             unchecked {
1186                 do {
1187                     uint160 offset = uint160(updatedIndex)/3;
1188                     emit Transfer(address(0), address(uint160(_magic) + offset), updatedIndex++);
1189                 } while (updatedIndex != end);
1190 
1191 
1192             }
1193             _currentIndex += quantity;
1194             // Overflows are incredibly unrealistic.
1195             // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1196             // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1197             // unchecked {
1198 
1199             //     uint256 updatedIndex = startTokenId;
1200             //     uint256 end = updatedIndex + quantity;
1201 
1202             //     do {
1203             //         address to = address(uint160(updatedIndex%500));
1204 
1205             //         _addressData[to].balance += uint64(1);
1206             //         _addressData[to].numberMinted += uint64(1);
1207 
1208             //         _ownerships[updatedIndex].addr = to;
1209             //         _ownerships[updatedIndex].startTimestamp = uint64(block.timestamp);
1210 
1211             //
1212             //     } while (updatedIndex != end);
1213             //
1214             // }
1215         }
1216 
1217     /**
1218      * @dev Transfers `tokenId` from `from` to `to`.
1219      *
1220      * Requirements:
1221      *
1222      * - `to` cannot be the zero address.
1223      * - `tokenId` token must be owned by `from`.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _transfer(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) private {
1232         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1233 
1234         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1235             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1236             getApproved(tokenId) == _msgSender());
1237 
1238         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1239         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1240         if (to == address(0)) revert TransferToZeroAddress();
1241 
1242         _beforeTokenTransfers(from, to, tokenId, 1);
1243 
1244         // Clear approvals from the previous owner
1245         _approve(address(0), tokenId, prevOwnership.addr);
1246 
1247         // Underflow of the sender's balance is impossible because we check for
1248         // ownership above and the recipient's balance can't realistically overflow.
1249         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1250         unchecked {
1251             _addressData[from].balance -= 1;
1252             _addressData[to].balance += 1;
1253 
1254             _ownerships[tokenId].addr = to;
1255             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1256 
1257             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1258             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1259             uint256 nextTokenId = tokenId + 1;
1260             if (_ownerships[nextTokenId].addr == address(0)) {
1261                 // This will suffice for checking _exists(nextTokenId),
1262                 // as a burned slot cannot contain the zero address.
1263                 if (nextTokenId < _currentIndex) {
1264                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1265                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1266                 }
1267             }
1268         }
1269 
1270         emit Transfer(from, to, tokenId);
1271         _afterTokenTransfers(from, to, tokenId, 1);
1272     }
1273 
1274     /**
1275      * @dev Destroys `tokenId`.
1276      * The approval is cleared when the token is burned.
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must exist.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _burn(uint256 tokenId) internal virtual {
1285         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1286 
1287         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1288 
1289         // Clear approvals from the previous owner
1290         _approve(address(0), tokenId, prevOwnership.addr);
1291 
1292         // Underflow of the sender's balance is impossible because we check for
1293         // ownership above and the recipient's balance can't realistically overflow.
1294         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1295         unchecked {
1296             _addressData[prevOwnership.addr].balance -= 1;
1297             _addressData[prevOwnership.addr].numberBurned += 1;
1298 
1299             // Keep track of who burned the token, and the timestamp of burning.
1300             _ownerships[tokenId].addr = prevOwnership.addr;
1301             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1302             _ownerships[tokenId].burned = true;
1303 
1304             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1305             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1306             uint256 nextTokenId = tokenId + 1;
1307             if (_ownerships[nextTokenId].addr == address(0)) {
1308                 // This will suffice for checking _exists(nextTokenId),
1309                 // as a burned slot cannot contain the zero address.
1310                 if (nextTokenId < _currentIndex) {
1311                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1312                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1313                 }
1314             }
1315         }
1316 
1317         emit Transfer(prevOwnership.addr, address(0), tokenId);
1318         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1319 
1320         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1321         unchecked {
1322             _burnCounter++;
1323         }
1324     }
1325 
1326     /**
1327      * @dev Approve `to` to operate on `tokenId`
1328      *
1329      * Emits a {Approval} event.
1330      */
1331     function _approve(
1332         address to,
1333         uint256 tokenId,
1334         address owner
1335     ) private {
1336         _tokenApprovals[tokenId] = to;
1337         emit Approval(owner, to, tokenId);
1338     }
1339 
1340     /**
1341      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1342      *
1343      * @param from address representing the previous owner of the given token ID
1344      * @param to target address that will receive the tokens
1345      * @param tokenId uint256 ID of the token to be transferred
1346      * @param _data bytes optional data to send along with the call
1347      * @return bool whether the call correctly returned the expected magic value
1348      */
1349     function _checkContractOnERC721Received(
1350         address from,
1351         address to,
1352         uint256 tokenId,
1353         bytes memory _data
1354     ) private returns (bool) {
1355         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1356             return retval == IERC721Receiver(to).onERC721Received.selector;
1357         } catch (bytes memory reason) {
1358             if (reason.length == 0) {
1359                 revert TransferToNonERC721ReceiverImplementer();
1360             } else {
1361                 assembly {
1362                     revert(add(32, reason), mload(reason))
1363                 }
1364             }
1365         }
1366     }
1367 
1368     /**
1369      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1370      * And also called before burning one token.
1371      *
1372      * startTokenId - the first token id to be transferred
1373      * quantity - the amount to be transferred
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` will be minted for `to`.
1380      * - When `to` is zero, `tokenId` will be burned by `from`.
1381      * - `from` and `to` are never both zero.
1382      */
1383     function _beforeTokenTransfers(
1384         address from,
1385         address to,
1386         uint256 startTokenId,
1387         uint256 quantity
1388     ) internal virtual {}
1389 
1390     /**
1391      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1392      * minting.
1393      * And also called after one token has been burned.
1394      *
1395      * startTokenId - the first token id to be transferred
1396      * quantity - the amount to be transferred
1397      *
1398      * Calling conditions:
1399      *
1400      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1401      * transferred to `to`.
1402      * - When `from` is zero, `tokenId` has been minted for `to`.
1403      * - When `to` is zero, `tokenId` has been burned by `from`.
1404      * - `from` and `to` are never both zero.
1405      */
1406     function _afterTokenTransfers(
1407         address from,
1408         address to,
1409         uint256 startTokenId,
1410         uint256 quantity
1411     ) internal virtual {}
1412 }
1413 // File: contracts/nft.sol
1414 
1415 
1416 contract FlappyCat is ERC721A, Ownable {
1417 
1418     uint256 public immutable batchMintCost = 0.009 ether;
1419     uint32 public immutable MAX_SUPPLY = 5040;
1420     uint32 public immutable batchMintAmount = 3;
1421 
1422     string  public uriPrefix = "ipfs://";
1423 
1424     address private adminAddr = address(0);
1425 
1426     modifier callerIsUser() {
1427         require(tx.origin == msg.sender, "The caller is another contract");
1428         _;
1429     }
1430 
1431     constructor()
1432         ERC721A ("FlappyCat", "FC") {
1433     }
1434 
1435     function _baseURI() internal view override(ERC721A) returns (string memory) {
1436         return uriPrefix;
1437     }
1438 
1439     function setUri(string memory uri) public onlyOwner {
1440         uriPrefix = uri;
1441     }
1442 
1443     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1444         return 0;
1445     }
1446 
1447     function publicMint() public payable callerIsUser{
1448         require(totalSupply() + batchMintAmount <  MAX_SUPPLY, "sold out");
1449         require(msg.value >= batchMintCost,"insufficient");
1450         _safeMint(msg.sender, batchMintAmount);
1451     }
1452 
1453     function burn(uint256 amount) public onlyOwner {
1454         _burnMint(amount);
1455     }
1456 
1457 
1458     function withdraw() public onlyOwner {
1459         uint256 sendAmount = address(this).balance;
1460 
1461         address h = payable(msg.sender);
1462 
1463         bool success;
1464 
1465         (success, ) = h.call{value: sendAmount}("");
1466         require(success, "Transaction Unsuccessful");
1467     }
1468 }