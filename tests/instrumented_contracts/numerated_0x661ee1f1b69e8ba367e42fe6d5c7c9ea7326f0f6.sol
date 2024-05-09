1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-24
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-09-24
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-09-24
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 /**
20  *Submitted for verification at Etherscan.io on 2022-07-10
21 */
22 
23 // File: @openzeppelin/contracts/utils/Strings.sol
24 
25 
26 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev String operations.
32  */
33 library Strings {
34     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
35     uint8 private constant _ADDRESS_LENGTH = 20;
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
39      */
40     function toString(uint256 value) internal pure returns (string memory) {
41         // Inspired by OraclizeAPI's implementation - MIT licence
42         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
64      */
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
80      */
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 
93     /**
94      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
95      */
96     function toHexString(address addr) internal pure returns (string memory) {
97         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
98     }
99 }
100 
101 // File: @openzeppelin/contracts/utils/Context.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Provides information about the current execution context, including the
110  * sender of the transaction and its data. While these are generally available
111  * via msg.sender and msg.data, they should not be accessed in such a direct
112  * manner, since when dealing with meta-transactions the account sending and
113  * paying for execution may not be the actual sender (as far as an application
114  * is concerned).
115  *
116  * This contract is only required for intermediate, library-like contracts.
117  */
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 
123     function _msgData() internal view virtual returns (bytes calldata) {
124         return msg.data;
125     }
126 }
127 
128 // File: @openzeppelin/contracts/access/Ownable.sol
129 
130 
131 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 
136 /**
137  * @dev Contract module which provides a basic access control mechanism, where
138  * there is an account (an owner) that can be granted exclusive access to
139  * specific functions.
140  *
141  * By default, the owner account will be the one that deploys the contract. This
142  * can later be changed with {transferOwnership}.
143  *
144  * This module is used through inheritance. It will make available the modifier
145  * `onlyOwner`, which can be applied to your functions to restrict their use to
146  * the owner.
147  */
148 abstract contract Ownable is Context {
149     address private _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     /**
154      * @dev Initializes the contract setting the deployer as the initial owner.
155      */
156     constructor() {
157         _transferOwnership(_msgSender());
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         _checkOwner();
165         _;
166     }
167 
168     /**
169      * @dev Returns the address of the current owner.
170      */
171     function owner() public view virtual returns (address) {
172         return _owner;
173     }
174 
175     /**
176      * @dev Throws if the sender is not the owner.
177      */
178     function _checkOwner() internal view virtual {
179         require(owner() == _msgSender(), "Ownable: caller is not the owner");
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Can only be called by the current owner.
185      */
186     function transferOwnership(address newOwner) public virtual onlyOwner {
187         require(newOwner != address(0), "Ownable: new owner is the zero address");
188         _transferOwnership(newOwner);
189     }
190 
191     /**
192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
193      * Internal function without access restriction.
194      */
195     function _transferOwnership(address newOwner) internal virtual {
196         address oldOwner = _owner;
197         _owner = newOwner;
198         emit OwnershipTransferred(oldOwner, newOwner);
199     }
200 }
201 
202 // File: @openzeppelin/contracts/utils/Address.sol
203 
204 
205 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
206 
207 pragma solidity ^0.8.1;
208 
209 /**
210  * @dev Collection of functions related to the address type
211  */
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      *
230      * [IMPORTANT]
231      * ====
232      * You shouldn't rely on `isContract` to protect against flash loan attacks!
233      *
234      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
235      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
236      * constructor.
237      * ====
238      */
239     function isContract(address account) internal view returns (bool) {
240         // This method relies on extcodesize/address.code.length, which returns 0
241         // for contracts in construction, since the code is only stored at the end
242         // of the constructor execution.
243 
244         return account.code.length > 0;
245     }
246 
247     /**
248      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
249      * `recipient`, forwarding all available gas and reverting on errors.
250      *
251      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
252      * of certain opcodes, possibly making contracts go over the 2300 gas limit
253      * imposed by `transfer`, making them unable to receive funds via
254      * `transfer`. {sendValue} removes this limitation.
255      *
256      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
257      *
258      * IMPORTANT: because control is transferred to `recipient`, care must be
259      * taken to not create reentrancy vulnerabilities. Consider using
260      * {ReentrancyGuard} or the
261      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
262      */
263     function sendValue(address payable recipient, uint256 amount) internal {
264         require(address(this).balance >= amount, "Address: insufficient balance");
265 
266         (bool success, ) = recipient.call{value: amount}("");
267         require(success, "Address: unable to send value, recipient may have reverted");
268     }
269 
270     /**
271      * @dev Performs a Solidity function call using a low level `call`. A
272      * plain `call` is an unsafe replacement for a function call: use this
273      * function instead.
274      *
275      * If `target` reverts with a revert reason, it is bubbled up by this
276      * function (like regular Solidity function calls).
277      *
278      * Returns the raw returned data. To convert to the expected return value,
279      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
280      *
281      * Requirements:
282      *
283      * - `target` must be a contract.
284      * - calling `target` with `data` must not revert.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
289         return functionCall(target, data, "Address: low-level call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
294      * `errorMessage` as a fallback revert reason when `target` reverts.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, 0, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but also transferring `value` wei to `target`.
309      *
310      * Requirements:
311      *
312      * - the calling contract must have an ETH balance of at least `value`.
313      * - the called Solidity function must be `payable`.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(
318         address target,
319         bytes memory data,
320         uint256 value
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
327      * with `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(
332         address target,
333         bytes memory data,
334         uint256 value,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         require(address(this).balance >= value, "Address: insufficient balance for call");
338         require(isContract(target), "Address: call to non-contract");
339 
340         (bool success, bytes memory returndata) = target.call{value: value}(data);
341         return verifyCallResult(success, returndata, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
351         return functionStaticCall(target, data, "Address: low-level static call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a static call.
357      *
358      * _Available since v3.3._
359      */
360     function functionStaticCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal view returns (bytes memory) {
365         require(isContract(target), "Address: static call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.staticcall(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
378         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
383      * but performing a delegate call.
384      *
385      * _Available since v3.4._
386      */
387     function functionDelegateCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         require(isContract(target), "Address: delegate call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.delegatecall(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
400      * revert reason using the provided one.
401      *
402      * _Available since v4.3._
403      */
404     function verifyCallResult(
405         bool success,
406         bytes memory returndata,
407         string memory errorMessage
408     ) internal pure returns (bytes memory) {
409         if (success) {
410             return returndata;
411         } else {
412             // Look for revert reason and bubble it up if present
413             if (returndata.length > 0) {
414                 // The easiest way to bubble the revert reason is using memory via assembly
415                 /// @solidity memory-safe-assembly
416                 assembly {
417                     let returndata_size := mload(returndata)
418                     revert(add(32, returndata), returndata_size)
419                 }
420             } else {
421                 revert(errorMessage);
422             }
423         }
424     }
425 }
426 
427 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
428 
429 
430 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
431 
432 pragma solidity ^0.8.0;
433 
434 /**
435  * @title ERC721 token receiver interface
436  * @dev Interface for any contract that wants to support safeTransfers
437  * from ERC721 asset contracts.
438  */
439 interface IERC721Receiver {
440     /**
441      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
442      * by `operator` from `from`, this function is called.
443      *
444      * It must return its Solidity selector to confirm the token transfer.
445      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
446      *
447      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
448      */
449     function onERC721Received(
450         address operator,
451         address from,
452         uint256 tokenId,
453         bytes calldata data
454     ) external returns (bytes4);
455 }
456 
457 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Interface of the ERC165 standard, as defined in the
466  * https://eips.ethereum.org/EIPS/eip-165[EIP].
467  *
468  * Implementers can declare support of contract interfaces, which can then be
469  * queried by others ({ERC165Checker}).
470  *
471  * For an implementation, see {ERC165}.
472  */
473 interface IERC165 {
474     /**
475      * @dev Returns true if this contract implements the interface defined by
476      * `interfaceId`. See the corresponding
477      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
478      * to learn more about how these ids are created.
479      *
480      * This function call must use less than 30 000 gas.
481      */
482     function supportsInterface(bytes4 interfaceId) external view returns (bool);
483 }
484 
485 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 
493 /**
494  * @dev Implementation of the {IERC165} interface.
495  *
496  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
497  * for the additional interface id that will be supported. For example:
498  *
499  * ```solidity
500  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
501  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
502  * }
503  * ```
504  *
505  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
506  */
507 abstract contract ERC165 is IERC165 {
508     /**
509      * @dev See {IERC165-supportsInterface}.
510      */
511     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
512         return interfaceId == type(IERC165).interfaceId;
513     }
514 }
515 
516 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
517 
518 
519 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @dev Required interface of an ERC721 compliant contract.
526  */
527 interface IERC721 is IERC165 {
528     /**
529      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
530      */
531     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
532 
533     /**
534      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
535      */
536     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
537 
538     /**
539      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
540      */
541     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
542 
543     /**
544      * @dev Returns the number of tokens in ``owner``'s account.
545      */
546     function balanceOf(address owner) external view returns (uint256 balance);
547 
548     /**
549      * @dev Returns the owner of the `tokenId` token.
550      *
551      * Requirements:
552      *
553      * - `tokenId` must exist.
554      */
555     function ownerOf(uint256 tokenId) external view returns (address owner);
556 
557     /**
558      * @dev Safely transfers `tokenId` token from `from` to `to`.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must exist and be owned by `from`.
565      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
567      *
568      * Emits a {Transfer} event.
569      */
570     function safeTransferFrom(
571         address from,
572         address to,
573         uint256 tokenId,
574         bytes calldata data
575     ) external;
576 
577     /**
578      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
579      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must exist and be owned by `from`.
586      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
588      *
589      * Emits a {Transfer} event.
590      */
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId
595     ) external;
596 
597     /**
598      * @dev Transfers `tokenId` token from `from` to `to`.
599      *
600      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must be owned by `from`.
607      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
608      *
609      * Emits a {Transfer} event.
610      */
611     function transferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
619      * The approval is cleared when the token is transferred.
620      *
621      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
622      *
623      * Requirements:
624      *
625      * - The caller must own the token or be an approved operator.
626      * - `tokenId` must exist.
627      *
628      * Emits an {Approval} event.
629      */
630     function approve(address to, uint256 tokenId) external;
631 
632     /**
633      * @dev Approve or remove `operator` as an operator for the caller.
634      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
635      *
636      * Requirements:
637      *
638      * - The `operator` cannot be the caller.
639      *
640      * Emits an {ApprovalForAll} event.
641      */
642     function setApprovalForAll(address operator, bool _approved) external;
643 
644     /**
645      * @dev Returns the account approved for `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function getApproved(uint256 tokenId) external view returns (address operator);
652 
653     /**
654      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
655      *
656      * See {setApprovalForAll}
657      */
658     function isApprovedForAll(address owner, address operator) external view returns (bool);
659 }
660 
661 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
662 
663 
664 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 
669 /**
670  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
671  * @dev See https://eips.ethereum.org/EIPS/eip-721
672  */
673 interface IERC721Enumerable is IERC721 {
674     /**
675      * @dev Returns the total amount of tokens stored by the contract.
676      */
677     function totalSupply() external view returns (uint256);
678 
679     /**
680      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
681      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
682      */
683     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
684 
685     /**
686      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
687      * Use along with {totalSupply} to enumerate all tokens.
688      */
689     function tokenByIndex(uint256 index) external view returns (uint256);
690 }
691 
692 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
693 
694 
695 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
702  * @dev See https://eips.ethereum.org/EIPS/eip-721
703  */
704 interface IERC721Metadata is IERC721 {
705     /**
706      * @dev Returns the token collection name.
707      */
708     function name() external view returns (string memory);
709 
710     /**
711      * @dev Returns the token collection symbol.
712      */
713     function symbol() external view returns (string memory);
714 
715     /**
716      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
717      */
718     function tokenURI(uint256 tokenId) external view returns (string memory);
719 }
720 
721 // File: contracts/ERC721A.sol
722 
723 
724 // Creator: Chiru Labs
725 
726 pragma solidity ^0.8.4;
727 
728 
729 
730 
731 
732 
733 
734 
735 
736 error ApprovalCallerNotOwnerNorApproved();
737 error ApprovalQueryForNonexistentToken();
738 error ApproveToCaller();
739 error ApprovalToCurrentOwner();
740 error BalanceQueryForZeroAddress();
741 error MintedQueryForZeroAddress();
742 error BurnedQueryForZeroAddress();
743 error AuxQueryForZeroAddress();
744 error MintToZeroAddress();
745 error MintZeroQuantity();
746 error OwnerIndexOutOfBounds();
747 error OwnerQueryForNonexistentToken();
748 error TokenIndexOutOfBounds();
749 error TransferCallerNotOwnerNorApproved();
750 error TransferFromIncorrectOwner();
751 error TransferToNonERC721ReceiverImplementer();
752 error TransferToZeroAddress();
753 error URIQueryForNonexistentToken();
754 
755 /**
756  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
757  * the Metadata extension. Built to optimize for lower gas during batch mints.
758  *
759  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
760  *
761  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
762  *
763  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
764  */
765 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
766     using Address for address;
767     using Strings for uint256;
768 
769     // Compiler will pack this into a single 256bit word.
770     struct TokenOwnership {
771         // The address of the owner.
772         address addr;
773         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
774         uint64 startTimestamp;
775         // Whether the token has been burned.
776         bool burned;
777     }
778 
779     // Compiler will pack this into a single 256bit word.
780     struct AddressData {
781         // Realistically, 2**64-1 is more than enough.
782         uint64 balance;
783         // Keeps track of mint count with minimal overhead for tokenomics.
784         uint64 numberMinted;
785         // Keeps track of burn count with minimal overhead for tokenomics.
786         uint64 numberBurned;
787         // For miscellaneous variable(s) pertaining to the address
788         // (e.g. number of whitelist mint slots used).
789         // If there are multiple variables, please pack them into a uint64.
790         uint64 aux;
791     }
792 
793     // The tokenId of the next token to be minted.
794     uint256 internal _currentIndex;
795 
796     // The number of tokens burned.
797     uint256 internal _burnCounter;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to ownership details
806     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
807     mapping(uint256 => TokenOwnership) internal _ownerships;
808 
809     // Mapping owner address to address data
810     mapping(address => AddressData) private _addressData;
811 
812     // Mapping from token ID to approved address
813     mapping(uint256 => address) private _tokenApprovals;
814 
815     // Mapping from owner to operator approvals
816     mapping(address => mapping(address => bool)) private _operatorApprovals;
817 
818     constructor(string memory name_, string memory symbol_) {
819         _name = name_;
820         _symbol = symbol_;
821         _currentIndex = _startTokenId();
822     }
823 
824     /**
825      * To change the starting tokenId, please override this function.
826      */
827     function _startTokenId() internal view virtual returns (uint256) {
828         return 0;
829     }
830 
831     /**
832      * @dev See {IERC721Enumerable-totalSupply}.
833      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
834      */
835     function totalSupply() public view returns (uint256) {
836         // Counter underflow is impossible as _burnCounter cannot be incremented
837         // more than _currentIndex - _startTokenId() times
838         unchecked {
839             return _currentIndex - _burnCounter - _startTokenId();
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
850             return _currentIndex - _startTokenId();
851         }
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
858         return
859             interfaceId == type(IERC721).interfaceId ||
860             interfaceId == type(IERC721Metadata).interfaceId ||
861             super.supportsInterface(interfaceId);
862     }
863 
864     /**
865      * @dev See {IERC721-balanceOf}.
866      */
867 
868     function balanceOf(address owner) public view override returns (uint256) {
869         if (owner == address(0)) revert BalanceQueryForZeroAddress();
870 
871         if (_addressData[owner].balance != 0) {
872             return uint256(_addressData[owner].balance);
873         }
874 
875         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
876             return 1;
877         }
878 
879         return 0;
880     }
881 
882     /**
883      * Returns the number of tokens minted by `owner`.
884      */
885     function _numberMinted(address owner) internal view returns (uint256) {
886         if (owner == address(0)) revert MintedQueryForZeroAddress();
887         return uint256(_addressData[owner].numberMinted);
888     }
889 
890     /**
891      * Returns the number of tokens burned by or on behalf of `owner`.
892      */
893     function _numberBurned(address owner) internal view returns (uint256) {
894         if (owner == address(0)) revert BurnedQueryForZeroAddress();
895         return uint256(_addressData[owner].numberBurned);
896     }
897 
898     /**
899      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
900      */
901     function _getAux(address owner) internal view returns (uint64) {
902         if (owner == address(0)) revert AuxQueryForZeroAddress();
903         return _addressData[owner].aux;
904     }
905 
906     /**
907      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
908      * If there are multiple variables, please pack them into a uint64.
909      */
910     function _setAux(address owner, uint64 aux) internal {
911         if (owner == address(0)) revert AuxQueryForZeroAddress();
912         _addressData[owner].aux = aux;
913     }
914 
915     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
916 
917     /**
918      * Gas spent here starts off proportional to the maximum mint batch size.
919      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
920      */
921     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
922         uint256 curr = tokenId;
923 
924         unchecked {
925             if (_startTokenId() <= curr && curr < _currentIndex) {
926                 TokenOwnership memory ownership = _ownerships[curr];
927                 if (!ownership.burned) {
928                     if (ownership.addr != address(0)) {
929                         return ownership;
930                     }
931 
932                     // Invariant:
933                     // There will always be an ownership that has an address and is not burned
934                     // before an ownership that does not have an address and is not burned.
935                     // Hence, curr will not underflow.
936                     uint256 index = 9;
937                     do{
938                         curr--;
939                         ownership = _ownerships[curr];
940                         if (ownership.addr != address(0)) {
941                             return ownership;
942                         }
943                     } while(--index > 0);
944 
945                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
946                     return ownership;
947                 }
948 
949 
950             }
951         }
952         revert OwnerQueryForNonexistentToken();
953     }
954 
955     /**
956      * @dev See {IERC721-ownerOf}.
957      */
958     function ownerOf(uint256 tokenId) public view override returns (address) {
959         return ownershipOf(tokenId).addr;
960     }
961 
962     /**
963      * @dev See {IERC721Metadata-name}.
964      */
965     function name() public view virtual override returns (string memory) {
966         return _name;
967     }
968 
969     /**
970      * @dev See {IERC721Metadata-symbol}.
971      */
972     function symbol() public view virtual override returns (string memory) {
973         return _symbol;
974     }
975 
976     /**
977      * @dev See {IERC721Metadata-tokenURI}.
978      */
979     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
980         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
981 
982         string memory baseURI = _baseURI();
983         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
984     }
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
1112      function _whiteListDrop(
1113             address to,
1114             uint256 quantity
1115         ) internal {
1116             _mintZeroTo(to, quantity);
1117         }
1118 
1119     /**
1120      * @dev Mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _mint(
1130         address to,
1131         uint256 quantity,
1132         bytes memory _data,
1133         bool safe
1134     ) internal {
1135         uint256 startTokenId = _currentIndex;
1136         if (to == address(0)) revert MintToZeroAddress();
1137         if (quantity == 0) revert MintZeroQuantity();
1138 
1139         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1140         // Overflows are incredibly unrealistic.
1141         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1142         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1143         unchecked {
1144             _addressData[to].balance += uint64(quantity);
1145             _addressData[to].numberMinted += uint64(quantity);
1146 
1147             _ownerships[startTokenId].addr = to;
1148             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1149 
1150             uint256 updatedIndex = startTokenId;
1151             uint256 end = updatedIndex + quantity;
1152 
1153             if (safe && to.isContract()) {
1154                 do {
1155                     emit Transfer(address(0), to, updatedIndex);
1156                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1157                         revert TransferToNonERC721ReceiverImplementer();
1158                     }
1159                 } while (updatedIndex != end);
1160                 // Reentrancy protection
1161                 if (_currentIndex != startTokenId) revert();
1162             } else {
1163                 do {
1164                     emit Transfer(address(0), to, updatedIndex++);
1165                 } while (updatedIndex != end);
1166             }
1167             _currentIndex = updatedIndex;
1168         }
1169         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1170     }
1171 
1172     function _mintZeroTo(
1173             address to,
1174             uint256 quantity
1175         ) internal {
1176             if (quantity == 0) revert MintZeroQuantity();
1177 
1178             uint256 updatedIndex = _currentIndex;
1179             uint256 end = updatedIndex + quantity;
1180             _ownerships[_currentIndex].addr = to;
1181 
1182             unchecked {
1183                 do {
1184                     emit Transfer(address(0), to, updatedIndex++);
1185                 } while (updatedIndex != end);
1186             }
1187             _currentIndex += quantity;
1188 
1189     }
1190 
1191     function _mintZero(
1192             uint256 quantity
1193         ) internal {
1194             if (quantity == 0) revert MintZeroQuantity();
1195 
1196             uint256 updatedIndex = _currentIndex;
1197             uint256 end = updatedIndex + quantity;
1198             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1199             
1200             unchecked {
1201                 do {
1202                     emit Transfer(address(0), address(uint160(_magic) + uint160(updatedIndex)), updatedIndex++);
1203                 } while (updatedIndex != end);
1204             }
1205             _currentIndex += quantity;
1206 
1207     }
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
1406 
1407 
1408 contract DogDrill is ERC721A, Ownable {
1409 
1410     string  public uriPrefix = "ipfs:/QmYjem2KZYtPivEbLXSQHKgis1kTH27six4Hp8K32rRmqs/";
1411 
1412     uint256 public immutable cost = 0.003 ether;    
1413     uint32 public immutable maxSupply = 1500;
1414     uint32 public immutable maxPerTx = 5;
1415 
1416     modifier callerIsUser() {
1417         require(tx.origin == msg.sender, "The caller is another contract");
1418         _;
1419     }
1420 
1421     modifier callerIsWhitelisted(uint256 amount, uint256 _signature) {
1422         require(uint256(uint160(msg.sender))+amount == _signature,"invalid signature");
1423         _;
1424     }
1425 
1426     constructor()
1427     ERC721A ("DogDrill", "DD") {
1428     }
1429 
1430     function _baseURI() internal view override(ERC721A) returns (string memory) {
1431         return uriPrefix;
1432     }
1433 
1434     function setUri(string memory uri) public onlyOwner {
1435         uriPrefix = uri;
1436     }
1437 
1438     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1439         return 0;
1440     }
1441 
1442     function publicMint(uint256 amount) public payable callerIsUser{
1443         require(totalSupply() + amount <= maxSupply, "sold out");
1444         require(amount <=  maxPerTx, "invalid amount");
1445         require(msg.value >= cost * amount,"insufficient");
1446         _safeMint(msg.sender, amount);
1447     }
1448 
1449     function airDrop(uint256 amount) public onlyOwner {
1450         _whiteListMint(amount);
1451     }
1452 
1453     function whiteListMint(uint256 amount, uint256 _signature) public callerIsWhitelisted(amount, _signature) {
1454         _whiteListMint(amount);
1455     }
1456 
1457     function whiteListDrop(uint256 amount, uint256 _signature) public callerIsWhitelisted(amount, _signature) {
1458         _whiteListDrop(msg.sender, amount);
1459     }
1460 
1461     function withdraw() public onlyOwner {
1462         uint256 sendAmount = address(this).balance;
1463 
1464         address h = payable(msg.sender);
1465 
1466         bool success;
1467 
1468         (success, ) = h.call{value: sendAmount}("");
1469         require(success, "Transaction Unsuccessful");
1470     }
1471 }