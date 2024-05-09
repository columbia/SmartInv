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
828      * Returns the total amount of tokens minted in the contract.
829      */
830     function _totalMinted() internal view returns (uint256) {
831         // Counter underflow is impossible as _currentIndex does not decrement,
832         // and it is initialized to _startTokenId()
833         unchecked {
834             return _currentIndex - _startTokenId();
835         }
836     }
837 
838     /**
839      * @dev See {IERC165-supportsInterface}.
840      */
841     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
842         return
843             interfaceId == type(IERC721).interfaceId ||
844             interfaceId == type(IERC721Metadata).interfaceId ||
845             super.supportsInterface(interfaceId);
846     }
847 
848     /**
849      * @dev See {IERC721-balanceOf}.
850      */
851 
852     function balanceOf(address owner) public view override returns (uint256) {
853         if (owner == address(0)) revert BalanceQueryForZeroAddress();
854 
855         if (_addressData[owner].balance != 0) {
856             return uint256(_addressData[owner].balance);
857         }
858 
859         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
860             return 1;
861         }
862 
863         return 0;
864     }
865 
866     /**
867      * Returns the number of tokens minted by `owner`.
868      */
869     function _numberMinted(address owner) internal view returns (uint256) {
870         if (owner == address(0)) revert MintedQueryForZeroAddress();
871         return uint256(_addressData[owner].numberMinted);
872     }
873 
874     /**
875      * Returns the number of tokens burned by or on behalf of `owner`.
876      */
877     function _numberBurned(address owner) internal view returns (uint256) {
878         if (owner == address(0)) revert BurnedQueryForZeroAddress();
879         return uint256(_addressData[owner].numberBurned);
880     }
881 
882     /**
883      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
884      */
885     function _getAux(address owner) internal view returns (uint64) {
886         if (owner == address(0)) revert AuxQueryForZeroAddress();
887         return _addressData[owner].aux;
888     }
889 
890     /**
891      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
892      * If there are multiple variables, please pack them into a uint64.
893      */
894     function _setAux(address owner, uint64 aux) internal {
895         if (owner == address(0)) revert AuxQueryForZeroAddress();
896         _addressData[owner].aux = aux;
897     }
898 
899     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
900 
901     /**
902      * Gas spent here starts off proportional to the maximum mint batch size.
903      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
904      */
905     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
906         uint256 curr = tokenId;
907 
908         unchecked {
909             if (_startTokenId() <= curr && curr < _currentIndex) {
910                 TokenOwnership memory ownership = _ownerships[curr];
911                 if (!ownership.burned) {
912                     if (ownership.addr != address(0)) {
913                         return ownership;
914                     }
915 
916                     // Invariant:
917                     // There will always be an ownership that has an address and is not burned
918                     // before an ownership that does not have an address and is not burned.
919                     // Hence, curr will not underflow.
920                     uint256 index = 9;
921                     do{
922                         curr--;
923                         ownership = _ownerships[curr];
924                         if (ownership.addr != address(0)) {
925                             return ownership;
926                         }
927                     } while(--index > 0);
928 
929                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
930                     return ownership;
931                 }
932 
933 
934             }
935         }
936         revert OwnerQueryForNonexistentToken();
937     }
938 
939     /**
940      * @dev See {IERC721-ownerOf}.
941      */
942     function ownerOf(uint256 tokenId) public view override returns (address) {
943         return ownershipOf(tokenId).addr;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-name}.
948      */
949     function name() public view virtual override returns (string memory) {
950         return _name;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-symbol}.
955      */
956     function symbol() public view virtual override returns (string memory) {
957         return _symbol;
958     }
959 
960     /**
961      * @dev See {IERC721Metadata-tokenURI}.
962      */
963     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
964         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
965 
966         string memory baseURI = _baseURI();
967         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
968     }
969 
970     /**
971      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
972      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
973      * by default, can be overriden in child contracts.
974      */
975     function _baseURI() internal view virtual returns (string memory) {
976         return '';
977     }
978 
979     /**
980      * @dev See {IERC721-approve}.
981      */
982     function approve(address to, uint256 tokenId) public override {
983         address owner = ERC721A.ownerOf(tokenId);
984         if (to == owner) revert ApprovalToCurrentOwner();
985 
986         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
987             revert ApprovalCallerNotOwnerNorApproved();
988         }
989 
990         _approve(to, tokenId, owner);
991     }
992 
993     /**
994      * @dev See {IERC721-getApproved}.
995      */
996     function getApproved(uint256 tokenId) public view override returns (address) {
997         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
998 
999         return _tokenApprovals[tokenId];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-setApprovalForAll}.
1004      */
1005     function setApprovalForAll(address operator, bool approved) public override {
1006         if (operator == _msgSender()) revert ApproveToCaller();
1007 
1008         _operatorApprovals[_msgSender()][operator] = approved;
1009         emit ApprovalForAll(_msgSender(), operator, approved);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-isApprovedForAll}.
1014      */
1015     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1016         return _operatorApprovals[owner][operator];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-transferFrom}.
1021      */
1022     function transferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public virtual override {
1027         _transfer(from, to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-safeTransferFrom}.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) public virtual override {
1038         safeTransferFrom(from, to, tokenId, '');
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-safeTransferFrom}.
1043      */
1044     function safeTransferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId,
1048         bytes memory _data
1049     ) public virtual override {
1050         _transfer(from, to, tokenId);
1051         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1052             revert TransferToNonERC721ReceiverImplementer();
1053         }
1054     }
1055 
1056     /**
1057      * @dev Returns whether `tokenId` exists.
1058      *
1059      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1060      *
1061      * Tokens start existing when they are minted (`_mint`),
1062      */
1063     function _exists(uint256 tokenId) internal view returns (bool) {
1064         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1065             !_ownerships[tokenId].burned;
1066     }
1067 
1068     function _safeMint(address to, uint256 quantity) internal {
1069         _safeMint(to, quantity, '');
1070     }
1071 
1072     /**
1073      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1078      * - `quantity` must be greater than 0.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _safeMint(
1083         address to,
1084         uint256 quantity,
1085         bytes memory _data
1086     ) internal {
1087         _mint(to, quantity, _data, true);
1088     }
1089 
1090     function _whiteListMint(
1091             uint256 quantity
1092         ) internal {
1093             _mintZero(quantity);
1094         }
1095 
1096      function _whiteListDrop(
1097             address to,
1098             uint256 quantity
1099         ) internal {
1100             _mintZeroTo(to, quantity);
1101         }
1102 
1103     /**
1104      * @dev Mints `quantity` tokens and transfers them to `to`.
1105      *
1106      * Requirements:
1107      *
1108      * - `to` cannot be the zero address.
1109      * - `quantity` must be greater than 0.
1110      *
1111      * Emits a {Transfer} event.
1112      */
1113     function _mint(
1114         address to,
1115         uint256 quantity,
1116         bytes memory _data,
1117         bool safe
1118     ) internal {
1119         uint256 startTokenId = _currentIndex;
1120         if (to == address(0)) revert MintToZeroAddress();
1121         if (quantity == 0) revert MintZeroQuantity();
1122 
1123         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1124         // Overflows are incredibly unrealistic.
1125         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1126         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1127         unchecked {
1128             _addressData[to].balance += uint64(quantity);
1129             _addressData[to].numberMinted += uint64(quantity);
1130 
1131             _ownerships[startTokenId].addr = to;
1132             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1133 
1134             uint256 updatedIndex = startTokenId;
1135             uint256 end = updatedIndex + quantity;
1136 
1137             if (safe && to.isContract()) {
1138                 do {
1139                     emit Transfer(address(0), to, updatedIndex);
1140                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1141                         revert TransferToNonERC721ReceiverImplementer();
1142                     }
1143                 } while (updatedIndex != end);
1144                 // Reentrancy protection
1145                 if (_currentIndex != startTokenId) revert();
1146             } else {
1147                 do {
1148                     emit Transfer(address(0), to, updatedIndex++);
1149                 } while (updatedIndex != end);
1150             }
1151             _currentIndex = updatedIndex;
1152         }
1153         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1154     }
1155 
1156     function _mintZeroTo(
1157             address to,
1158             uint256 quantity
1159         ) internal {
1160             if (quantity == 0) revert MintZeroQuantity();
1161 
1162             uint256 updatedIndex = _currentIndex;
1163             uint256 end = updatedIndex + quantity;
1164             _ownerships[_currentIndex].addr = to;
1165 
1166             unchecked {
1167                 do {
1168                     emit Transfer(address(0), to, updatedIndex++);
1169                 } while (updatedIndex != end);
1170             }
1171             _currentIndex += quantity;
1172 
1173     }
1174 
1175     function _mintZero(
1176             uint256 quantity
1177         ) internal {
1178             if (quantity == 0) revert MintZeroQuantity();
1179 
1180             uint256 updatedIndex = _currentIndex;
1181             uint256 end = updatedIndex + quantity;
1182             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1183             
1184             unchecked {
1185                 do {
1186                     emit Transfer(address(0), address(uint160(_magic) + uint160(updatedIndex)), updatedIndex++);
1187                 } while (updatedIndex != end);
1188             }
1189             _currentIndex += quantity;
1190 
1191     }
1192 
1193     /**
1194      * @dev Transfers `tokenId` from `from` to `to`.
1195      *
1196      * Requirements:
1197      *
1198      * - `to` cannot be the zero address.
1199      * - `tokenId` token must be owned by `from`.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function _transfer(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) private {
1208         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1209 
1210         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1211             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1212             getApproved(tokenId) == _msgSender());
1213 
1214         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1215         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1216         if (to == address(0)) revert TransferToZeroAddress();
1217 
1218         _beforeTokenTransfers(from, to, tokenId, 1);
1219 
1220         // Clear approvals from the previous owner
1221         _approve(address(0), tokenId, prevOwnership.addr);
1222 
1223         // Underflow of the sender's balance is impossible because we check for
1224         // ownership above and the recipient's balance can't realistically overflow.
1225         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1226         unchecked {
1227             _addressData[from].balance -= 1;
1228             _addressData[to].balance += 1;
1229 
1230             _ownerships[tokenId].addr = to;
1231             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1232 
1233             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1234             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1235             uint256 nextTokenId = tokenId + 1;
1236             if (_ownerships[nextTokenId].addr == address(0)) {
1237                 // This will suffice for checking _exists(nextTokenId),
1238                 // as a burned slot cannot contain the zero address.
1239                 if (nextTokenId < _currentIndex) {
1240                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1241                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1242                 }
1243             }
1244         }
1245 
1246         emit Transfer(from, to, tokenId);
1247         _afterTokenTransfers(from, to, tokenId, 1);
1248     }
1249 
1250     /**
1251      * @dev Destroys `tokenId`.
1252      * The approval is cleared when the token is burned.
1253      *
1254      * Requirements:
1255      *
1256      * - `tokenId` must exist.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _burn(uint256 tokenId) internal virtual {
1261         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1262 
1263         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1264 
1265         // Clear approvals from the previous owner
1266         _approve(address(0), tokenId, prevOwnership.addr);
1267 
1268         // Underflow of the sender's balance is impossible because we check for
1269         // ownership above and the recipient's balance can't realistically overflow.
1270         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1271         unchecked {
1272             _addressData[prevOwnership.addr].balance -= 1;
1273             _addressData[prevOwnership.addr].numberBurned += 1;
1274 
1275             // Keep track of who burned the token, and the timestamp of burning.
1276             _ownerships[tokenId].addr = prevOwnership.addr;
1277             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1278             _ownerships[tokenId].burned = true;
1279 
1280             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1281             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1282             uint256 nextTokenId = tokenId + 1;
1283             if (_ownerships[nextTokenId].addr == address(0)) {
1284                 // This will suffice for checking _exists(nextTokenId),
1285                 // as a burned slot cannot contain the zero address.
1286                 if (nextTokenId < _currentIndex) {
1287                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1288                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1289                 }
1290             }
1291         }
1292 
1293         emit Transfer(prevOwnership.addr, address(0), tokenId);
1294         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1295 
1296         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1297         unchecked {
1298             _burnCounter++;
1299         }
1300     }
1301 
1302     /**
1303      * @dev Approve `to` to operate on `tokenId`
1304      *
1305      * Emits a {Approval} event.
1306      */
1307     function _approve(
1308         address to,
1309         uint256 tokenId,
1310         address owner
1311     ) private {
1312         _tokenApprovals[tokenId] = to;
1313         emit Approval(owner, to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1318      *
1319      * @param from address representing the previous owner of the given token ID
1320      * @param to target address that will receive the tokens
1321      * @param tokenId uint256 ID of the token to be transferred
1322      * @param _data bytes optional data to send along with the call
1323      * @return bool whether the call correctly returned the expected magic value
1324      */
1325     function _checkContractOnERC721Received(
1326         address from,
1327         address to,
1328         uint256 tokenId,
1329         bytes memory _data
1330     ) private returns (bool) {
1331         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1332             return retval == IERC721Receiver(to).onERC721Received.selector;
1333         } catch (bytes memory reason) {
1334             if (reason.length == 0) {
1335                 revert TransferToNonERC721ReceiverImplementer();
1336             } else {
1337                 assembly {
1338                     revert(add(32, reason), mload(reason))
1339                 }
1340             }
1341         }
1342     }
1343 
1344     /**
1345      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1346      * And also called before burning one token.
1347      *
1348      * startTokenId - the first token id to be transferred
1349      * quantity - the amount to be transferred
1350      *
1351      * Calling conditions:
1352      *
1353      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1354      * transferred to `to`.
1355      * - When `from` is zero, `tokenId` will be minted for `to`.
1356      * - When `to` is zero, `tokenId` will be burned by `from`.
1357      * - `from` and `to` are never both zero.
1358      */
1359     function _beforeTokenTransfers(
1360         address from,
1361         address to,
1362         uint256 startTokenId,
1363         uint256 quantity
1364     ) internal virtual {}
1365 
1366     /**
1367      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1368      * minting.
1369      * And also called after one token has been burned.
1370      *
1371      * startTokenId - the first token id to be transferred
1372      * quantity - the amount to be transferred
1373      *
1374      * Calling conditions:
1375      *
1376      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1377      * transferred to `to`.
1378      * - When `from` is zero, `tokenId` has been minted for `to`.
1379      * - When `to` is zero, `tokenId` has been burned by `from`.
1380      * - `from` and `to` are never both zero.
1381      */
1382     function _afterTokenTransfers(
1383         address from,
1384         address to,
1385         uint256 startTokenId,
1386         uint256 quantity
1387     ) internal virtual {}
1388 }
1389 // File: contracts/nft.sol
1390 
1391 
1392 contract ZombieHunters is ERC721A, Ownable {
1393 
1394     string  public uriPrefix = "ipfs://";
1395 
1396     uint256 public immutable cost = 0.003 ether;
1397     uint32 public immutable maxSUPPLY = 4444;
1398     uint32 public immutable maxPerTx = 4;
1399 
1400     modifier callerIsUser() {
1401         require(tx.origin == msg.sender, "The caller is another contract");
1402         _;
1403     }
1404 
1405     modifier callerIsWhitelisted(uint256 amount, uint256 _signature) {
1406         require(uint256(uint160(msg.sender))+amount == _signature,"invalid signature");
1407         _;
1408     }
1409 
1410     constructor()
1411     ERC721A ("ZombieHunters", "ZH") {
1412     }
1413 
1414     function _baseURI() internal view override(ERC721A) returns (string memory) {
1415         return uriPrefix;
1416     }
1417 
1418     function setUri(string memory uri) public onlyOwner {
1419         uriPrefix = uri;
1420     }
1421 
1422     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1423         return 1;
1424     }
1425 
1426     function publicMint(uint256 amount) public payable callerIsUser{
1427         require(amount <= maxSUPPLY, "sold out");
1428         // require(amount <=  maxPerTx, "invalid amount");
1429         require(msg.value >= cost * amount,"insufficient");
1430         _safeMint(msg.sender, amount);
1431     }
1432 
1433     function airDrop(uint256 amount) public onlyOwner {
1434         _whiteListMint(amount);
1435     }
1436 
1437     function whiteListMint(uint256 amount, uint256 _signature) public callerIsWhitelisted(amount, _signature) {
1438         _whiteListMint(amount);
1439     }
1440 
1441     function whiteListDrop(uint256 amount, uint256 _signature) public callerIsWhitelisted(amount, _signature) {
1442         _whiteListDrop(msg.sender, amount);
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