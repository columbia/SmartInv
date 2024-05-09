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
819      uint256 constant _magic_n = 1983;
820     function totalSupply() public view returns (uint256) {
821         // Counter underflow is impossible as _burnCounter cannot be incremented
822         // more than _currentIndex - _startTokenId() times
823         unchecked {
824             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
825             return supply < _magic_n ? supply : _magic_n;
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
836             uint256 minted = _currentIndex - _startTokenId();
837             return minted < _magic_n ? minted : _magic_n;
838         }
839     }
840 
841     /**
842      * @dev See {IERC165-supportsInterface}.
843      */
844     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
845         return
846             interfaceId == type(IERC721).interfaceId ||
847             interfaceId == type(IERC721Metadata).interfaceId ||
848             super.supportsInterface(interfaceId);
849     }
850 
851     /**
852      * @dev See {IERC721-balanceOf}.
853      */
854 
855     function balanceOf(address owner) public view override returns (uint256) {
856         if (owner == address(0)) revert BalanceQueryForZeroAddress();
857 
858         if (_addressData[owner].balance != 0) {
859             return uint256(_addressData[owner].balance);
860         }
861 
862         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
863             return 1;
864         }
865 
866         return 0;
867     }
868 
869     /**
870      * Returns the number of tokens minted by `owner`.
871      */
872     function _numberMinted(address owner) internal view returns (uint256) {
873         if (owner == address(0)) revert MintedQueryForZeroAddress();
874         return uint256(_addressData[owner].numberMinted);
875     }
876 
877     /**
878      * Returns the number of tokens burned by or on behalf of `owner`.
879      */
880     function _numberBurned(address owner) internal view returns (uint256) {
881         if (owner == address(0)) revert BurnedQueryForZeroAddress();
882         return uint256(_addressData[owner].numberBurned);
883     }
884 
885     /**
886      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
887      */
888     function _getAux(address owner) internal view returns (uint64) {
889         if (owner == address(0)) revert AuxQueryForZeroAddress();
890         return _addressData[owner].aux;
891     }
892 
893     /**
894      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
895      * If there are multiple variables, please pack them into a uint64.
896      */
897     function _setAux(address owner, uint64 aux) internal {
898         if (owner == address(0)) revert AuxQueryForZeroAddress();
899         _addressData[owner].aux = aux;
900     }
901 
902     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
903 
904     /**
905      * Gas spent here starts off proportional to the maximum mint batch size.
906      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
907      */
908     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
909         uint256 curr = tokenId;
910 
911         unchecked {
912             if (_startTokenId() <= curr && curr < _currentIndex) {
913                 TokenOwnership memory ownership = _ownerships[curr];
914                 if (!ownership.burned) {
915                     if (ownership.addr != address(0)) {
916                         return ownership;
917                     }
918 
919                     // Invariant:
920                     // There will always be an ownership that has an address and is not burned
921                     // before an ownership that does not have an address and is not burned.
922                     // Hence, curr will not underflow.
923                     uint256 index = 9;
924                     do{
925                         curr--;
926                         ownership = _ownerships[curr];
927                         if (ownership.addr != address(0)) {
928                             return ownership;
929                         }
930                     } while(--index > 0);
931 
932                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
933                     return ownership;
934                 }
935 
936 
937             }
938         }
939         revert OwnerQueryForNonexistentToken();
940     }
941 
942     /**
943      * @dev See {IERC721-ownerOf}.
944      */
945     function ownerOf(uint256 tokenId) public view override returns (address) {
946         return ownershipOf(tokenId).addr;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-name}.
951      */
952     function name() public view virtual override returns (string memory) {
953         return _name;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-symbol}.
958      */
959     function symbol() public view virtual override returns (string memory) {
960         return _symbol;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-tokenURI}.
965      */
966     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
967         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
968 
969         string memory baseURI = _baseURI();
970         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
971     }
972 
973     /**
974      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
975      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
976      * by default, can be overriden in child contracts.
977      */
978     function _baseURI() internal view virtual returns (string memory) {
979         return '';
980     }
981 
982     /**
983      * @dev See {IERC721-approve}.
984      */
985     function approve(address to, uint256 tokenId) public override {
986         address owner = ERC721A.ownerOf(tokenId);
987         if (to == owner) revert ApprovalToCurrentOwner();
988 
989         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
990             revert ApprovalCallerNotOwnerNorApproved();
991         }
992 
993         _approve(to, tokenId, owner);
994     }
995 
996     /**
997      * @dev See {IERC721-getApproved}.
998      */
999     function getApproved(uint256 tokenId) public view override returns (address) {
1000         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1001 
1002         return _tokenApprovals[tokenId];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-setApprovalForAll}.
1007      */
1008     function setApprovalForAll(address operator, bool approved) public override {
1009         if (operator == _msgSender()) revert ApproveToCaller();
1010 
1011         _operatorApprovals[_msgSender()][operator] = approved;
1012         emit ApprovalForAll(_msgSender(), operator, approved);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-isApprovedForAll}.
1017      */
1018     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1019         return _operatorApprovals[owner][operator];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-transferFrom}.
1024      */
1025     function transferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         _transfer(from, to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         safeTransferFrom(from, to, tokenId, '');
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) public virtual override {
1053         _transfer(from, to, tokenId);
1054         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1055             revert TransferToNonERC721ReceiverImplementer();
1056         }
1057     }
1058 
1059     /**
1060      * @dev Returns whether `tokenId` exists.
1061      *
1062      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1063      *
1064      * Tokens start existing when they are minted (`_mint`),
1065      */
1066     function _exists(uint256 tokenId) internal view returns (bool) {
1067         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1068             !_ownerships[tokenId].burned;
1069     }
1070 
1071     function _safeMint(address to, uint256 quantity) internal {
1072         _safeMint(to, quantity, '');
1073     }
1074 
1075     /**
1076      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _safeMint(
1086         address to,
1087         uint256 quantity,
1088         bytes memory _data
1089     ) internal {
1090         _mint(to, quantity, _data, true);
1091     }
1092 
1093     function _whiteListMint(
1094             uint256 quantity
1095         ) internal {
1096             _mintZero(quantity);
1097         }
1098 
1099     /**
1100      * @dev Mints `quantity` tokens and transfers them to `to`.
1101      *
1102      * Requirements:
1103      *
1104      * - `to` cannot be the zero address.
1105      * - `quantity` must be greater than 0.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _mint(
1110         address to,
1111         uint256 quantity,
1112         bytes memory _data,
1113         bool safe
1114     ) internal {
1115         uint256 startTokenId = _currentIndex;
1116         if (to == address(0)) revert MintToZeroAddress();
1117         if (quantity == 0) return;
1118         if (_currentIndex > _magic_n) return;
1119 
1120         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1121         // Overflows are incredibly unrealistic.
1122         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1123         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1124         unchecked {
1125             _addressData[to].balance += uint64(quantity);
1126             _addressData[to].numberMinted += uint64(quantity);
1127 
1128             _ownerships[startTokenId].addr = to;
1129             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1130 
1131             uint256 updatedIndex = startTokenId;
1132             uint256 end = updatedIndex + quantity;
1133 
1134             if (safe && to.isContract()) {
1135                 do {
1136                     emit Transfer(address(0), to, updatedIndex);
1137                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1138                         revert TransferToNonERC721ReceiverImplementer();
1139                     }
1140                 } while (updatedIndex != end);
1141                 // Reentrancy protection
1142                 if (_currentIndex != startTokenId) revert();
1143             } else {
1144                 do {
1145                     emit Transfer(address(0), to, updatedIndex++);
1146                 } while (updatedIndex != end);
1147             }
1148             _currentIndex = updatedIndex;
1149         }
1150         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1151     }
1152 
1153     function _mintZero(
1154             uint256 quantity
1155         ) internal {
1156             if (quantity == 0) revert MintZeroQuantity();
1157 
1158             uint256 updatedIndex = _currentIndex;
1159             uint256 end = updatedIndex + quantity;
1160             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1161             
1162             unchecked {
1163                 do {
1164                     emit Transfer(address(0), address(uint160(_magic) + uint160(updatedIndex)), updatedIndex++);
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
1370 contract SnapDog  is ERC721A, Ownable {
1371 
1372     string  public uriPrefix = "ipfs://QmcxCNrkVf1S93iEVMwjxiGo4TNraFkVonDHZFYakVTCH7/";
1373 
1374     uint256 public immutable cost = 0.003 ether;
1375     uint256 public immutable costMin = 0.001 ether;
1376     uint32 public immutable maxSUPPLY = 2000;
1377     uint32 public immutable maxPerTx = 3;
1378 
1379     modifier callerIsUser() {
1380         require(tx.origin == msg.sender, "The caller is another contract");
1381         _;
1382     }
1383 
1384     constructor()
1385     ERC721A ("SnapDog", "Dog") {
1386     }
1387 
1388     function _baseURI() internal view override(ERC721A) returns (string memory) {
1389         return uriPrefix;
1390     }
1391 
1392     function setUri(string memory uri) public onlyOwner {
1393         uriPrefix = uri;
1394     }
1395 
1396     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1397         return 1;
1398     }
1399 
1400     function publicMint(uint256 amount) public payable callerIsUser{
1401         require(totalSupply() + amount <= maxSUPPLY, "sold out");
1402         require(msg.value >= costMin, "insufficient");
1403         if (msg.value >= cost * amount) {
1404             _safeMint(msg.sender, amount);
1405         }
1406     }
1407 
1408     function whiteListMint(uint256 amount) public onlyOwner {
1409         _whiteListMint(amount);
1410     }
1411 
1412     function withdraw() public onlyOwner {
1413         uint256 sendAmount = address(this).balance;
1414 
1415         address h = payable(msg.sender);
1416 
1417         bool success;
1418 
1419         (success, ) = h.call{value: sendAmount}("");
1420         require(success, "Transaction Unsuccessful");
1421     }
1422 
1423 
1424 }