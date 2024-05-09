1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-13
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-13
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 /**
12  *Submitted for verification at Etherscan.io on 2022-07-10
13 */
14 
15 // File: @openzeppelin/contracts/utils/Strings.sol
16 
17 
18 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev String operations.
24  */
25 library Strings {
26     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
27     uint8 private constant _ADDRESS_LENGTH = 20;
28 
29     /**
30      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
31      */
32     function toString(uint256 value) internal pure returns (string memory) {
33         // Inspired by OraclizeAPI's implementation - MIT licence
34         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
35 
36         if (value == 0) {
37             return "0";
38         }
39         uint256 temp = value;
40         uint256 digits;
41         while (temp != 0) {
42             digits++;
43             temp /= 10;
44         }
45         bytes memory buffer = new bytes(digits);
46         while (value != 0) {
47             digits -= 1;
48             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
49             value /= 10;
50         }
51         return string(buffer);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
56      */
57     function toHexString(uint256 value) internal pure returns (string memory) {
58         if (value == 0) {
59             return "0x00";
60         }
61         uint256 temp = value;
62         uint256 length = 0;
63         while (temp != 0) {
64             length++;
65             temp >>= 8;
66         }
67         return toHexString(value, length);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
72      */
73     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
74         bytes memory buffer = new bytes(2 * length + 2);
75         buffer[0] = "0";
76         buffer[1] = "x";
77         for (uint256 i = 2 * length + 1; i > 1; --i) {
78             buffer[i] = _HEX_SYMBOLS[value & 0xf];
79             value >>= 4;
80         }
81         require(value == 0, "Strings: hex length insufficient");
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
87      */
88     function toHexString(address addr) internal pure returns (string memory) {
89         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
90     }
91 }
92 
93 // File: @openzeppelin/contracts/utils/Context.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Provides information about the current execution context, including the
102  * sender of the transaction and its data. While these are generally available
103  * via msg.sender and msg.data, they should not be accessed in such a direct
104  * manner, since when dealing with meta-transactions the account sending and
105  * paying for execution may not be the actual sender (as far as an application
106  * is concerned).
107  *
108  * This contract is only required for intermediate, library-like contracts.
109  */
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114 
115     function _msgData() internal view virtual returns (bytes calldata) {
116         return msg.data;
117     }
118 }
119 
120 // File: @openzeppelin/contracts/access/Ownable.sol
121 
122 
123 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 
128 /**
129  * @dev Contract module which provides a basic access control mechanism, where
130  * there is an account (an owner) that can be granted exclusive access to
131  * specific functions.
132  *
133  * By default, the owner account will be the one that deploys the contract. This
134  * can later be changed with {transferOwnership}.
135  *
136  * This module is used through inheritance. It will make available the modifier
137  * `onlyOwner`, which can be applied to your functions to restrict their use to
138  * the owner.
139  */
140 abstract contract Ownable is Context {
141     address private _owner;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor() {
149         _transferOwnership(_msgSender());
150     }
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         _checkOwner();
157         _;
158     }
159 
160     /**
161      * @dev Returns the address of the current owner.
162      */
163     function owner() public view virtual returns (address) {
164         return _owner;
165     }
166 
167     /**
168      * @dev Throws if the sender is not the owner.
169      */
170     function _checkOwner() internal view virtual {
171         require(owner() == _msgSender(), "Ownable: caller is not the owner");
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Can only be called by the current owner.
177      */
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         _transferOwnership(newOwner);
181     }
182 
183     /**
184      * @dev Transfers ownership of the contract to a new account (`newOwner`).
185      * Internal function without access restriction.
186      */
187     function _transferOwnership(address newOwner) internal virtual {
188         address oldOwner = _owner;
189         _owner = newOwner;
190         emit OwnershipTransferred(oldOwner, newOwner);
191     }
192 }
193 
194 // File: @openzeppelin/contracts/utils/Address.sol
195 
196 
197 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
198 
199 pragma solidity ^0.8.1;
200 
201 /**
202  * @dev Collection of functions related to the address type
203  */
204 library Address {
205     /**
206      * @dev Returns true if `account` is a contract.
207      *
208      * [IMPORTANT]
209      * ====
210      * It is unsafe to assume that an address for which this function returns
211      * false is an externally-owned account (EOA) and not a contract.
212      *
213      * Among others, `isContract` will return false for the following
214      * types of addresses:
215      *
216      *  - an externally-owned account
217      *  - a contract in construction
218      *  - an address where a contract will be created
219      *  - an address where a contract lived, but was destroyed
220      * ====
221      *
222      * [IMPORTANT]
223      * ====
224      * You shouldn't rely on `isContract` to protect against flash loan attacks!
225      *
226      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
227      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
228      * constructor.
229      * ====
230      */
231     function isContract(address account) internal view returns (bool) {
232         // This method relies on extcodesize/address.code.length, which returns 0
233         // for contracts in construction, since the code is only stored at the end
234         // of the constructor execution.
235 
236         return account.code.length > 0;
237     }
238 
239     /**
240      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
241      * `recipient`, forwarding all available gas and reverting on errors.
242      *
243      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
244      * of certain opcodes, possibly making contracts go over the 2300 gas limit
245      * imposed by `transfer`, making them unable to receive funds via
246      * `transfer`. {sendValue} removes this limitation.
247      *
248      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
249      *
250      * IMPORTANT: because control is transferred to `recipient`, care must be
251      * taken to not create reentrancy vulnerabilities. Consider using
252      * {ReentrancyGuard} or the
253      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
254      */
255     function sendValue(address payable recipient, uint256 amount) internal {
256         require(address(this).balance >= amount, "Address: insufficient balance");
257 
258         (bool success, ) = recipient.call{value: amount}("");
259         require(success, "Address: unable to send value, recipient may have reverted");
260     }
261 
262     /**
263      * @dev Performs a Solidity function call using a low level `call`. A
264      * plain `call` is an unsafe replacement for a function call: use this
265      * function instead.
266      *
267      * If `target` reverts with a revert reason, it is bubbled up by this
268      * function (like regular Solidity function calls).
269      *
270      * Returns the raw returned data. To convert to the expected return value,
271      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
272      *
273      * Requirements:
274      *
275      * - `target` must be a contract.
276      * - calling `target` with `data` must not revert.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
281         return functionCall(target, data, "Address: low-level call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
286      * `errorMessage` as a fallback revert reason when `target` reverts.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, 0, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but also transferring `value` wei to `target`.
301      *
302      * Requirements:
303      *
304      * - the calling contract must have an ETH balance of at least `value`.
305      * - the called Solidity function must be `payable`.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value
313     ) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(address(this).balance >= value, "Address: insufficient balance for call");
330         require(isContract(target), "Address: call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.call{value: value}(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
343         return functionStaticCall(target, data, "Address: low-level static call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal view returns (bytes memory) {
357         require(isContract(target), "Address: static call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.staticcall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(isContract(target), "Address: delegate call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.delegatecall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
392      * revert reason using the provided one.
393      *
394      * _Available since v4.3._
395      */
396     function verifyCallResult(
397         bool success,
398         bytes memory returndata,
399         string memory errorMessage
400     ) internal pure returns (bytes memory) {
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407                 /// @solidity memory-safe-assembly
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
420 
421 
422 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @title ERC721 token receiver interface
428  * @dev Interface for any contract that wants to support safeTransfers
429  * from ERC721 asset contracts.
430  */
431 interface IERC721Receiver {
432     /**
433      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
434      * by `operator` from `from`, this function is called.
435      *
436      * It must return its Solidity selector to confirm the token transfer.
437      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
438      *
439      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
440      */
441     function onERC721Received(
442         address operator,
443         address from,
444         uint256 tokenId,
445         bytes calldata data
446     ) external returns (bytes4);
447 }
448 
449 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
450 
451 
452 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Interface of the ERC165 standard, as defined in the
458  * https://eips.ethereum.org/EIPS/eip-165[EIP].
459  *
460  * Implementers can declare support of contract interfaces, which can then be
461  * queried by others ({ERC165Checker}).
462  *
463  * For an implementation, see {ERC165}.
464  */
465 interface IERC165 {
466     /**
467      * @dev Returns true if this contract implements the interface defined by
468      * `interfaceId`. See the corresponding
469      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
470      * to learn more about how these ids are created.
471      *
472      * This function call must use less than 30 000 gas.
473      */
474     function supportsInterface(bytes4 interfaceId) external view returns (bool);
475 }
476 
477 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Implementation of the {IERC165} interface.
487  *
488  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
489  * for the additional interface id that will be supported. For example:
490  *
491  * ```solidity
492  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
494  * }
495  * ```
496  *
497  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
498  */
499 abstract contract ERC165 is IERC165 {
500     /**
501      * @dev See {IERC165-supportsInterface}.
502      */
503     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504         return interfaceId == type(IERC165).interfaceId;
505     }
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
509 
510 
511 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Required interface of an ERC721 compliant contract.
518  */
519 interface IERC721 is IERC165 {
520     /**
521      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
522      */
523     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
524 
525     /**
526      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
527      */
528     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
529 
530     /**
531      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
532      */
533     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
534 
535     /**
536      * @dev Returns the number of tokens in ``owner``'s account.
537      */
538     function balanceOf(address owner) external view returns (uint256 balance);
539 
540     /**
541      * @dev Returns the owner of the `tokenId` token.
542      *
543      * Requirements:
544      *
545      * - `tokenId` must exist.
546      */
547     function ownerOf(uint256 tokenId) external view returns (address owner);
548 
549     /**
550      * @dev Safely transfers `tokenId` token from `from` to `to`.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
559      *
560      * Emits a {Transfer} event.
561      */
562     function safeTransferFrom(
563         address from,
564         address to,
565         uint256 tokenId,
566         bytes calldata data
567     ) external;
568 
569     /**
570      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
571      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) external;
588 
589     /**
590      * @dev Transfers `tokenId` token from `from` to `to`.
591      *
592      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600      *
601      * Emits a {Transfer} event.
602      */
603     function transferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) external;
608 
609     /**
610      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
611      * The approval is cleared when the token is transferred.
612      *
613      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
614      *
615      * Requirements:
616      *
617      * - The caller must own the token or be an approved operator.
618      * - `tokenId` must exist.
619      *
620      * Emits an {Approval} event.
621      */
622     function approve(address to, uint256 tokenId) external;
623 
624     /**
625      * @dev Approve or remove `operator` as an operator for the caller.
626      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
627      *
628      * Requirements:
629      *
630      * - The `operator` cannot be the caller.
631      *
632      * Emits an {ApprovalForAll} event.
633      */
634     function setApprovalForAll(address operator, bool _approved) external;
635 
636     /**
637      * @dev Returns the account approved for `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function getApproved(uint256 tokenId) external view returns (address operator);
644 
645     /**
646      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
647      *
648      * See {setApprovalForAll}
649      */
650     function isApprovedForAll(address owner, address operator) external view returns (bool);
651 }
652 
653 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
654 
655 
656 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 
661 /**
662  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
663  * @dev See https://eips.ethereum.org/EIPS/eip-721
664  */
665 interface IERC721Enumerable is IERC721 {
666     /**
667      * @dev Returns the total amount of tokens stored by the contract.
668      */
669     function totalSupply() external view returns (uint256);
670 
671     /**
672      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
673      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
674      */
675     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
676 
677     /**
678      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
679      * Use along with {totalSupply} to enumerate all tokens.
680      */
681     function tokenByIndex(uint256 index) external view returns (uint256);
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
694  * @dev See https://eips.ethereum.org/EIPS/eip-721
695  */
696 interface IERC721Metadata is IERC721 {
697     /**
698      * @dev Returns the token collection name.
699      */
700     function name() external view returns (string memory);
701 
702     /**
703      * @dev Returns the token collection symbol.
704      */
705     function symbol() external view returns (string memory);
706 
707     /**
708      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
709      */
710     function tokenURI(uint256 tokenId) external view returns (string memory);
711 }
712 
713 // File: contracts/ERC721A.sol
714 
715 
716 // Creator: Chiru Labs
717 
718 pragma solidity ^0.8.4;
719 
720 
721 
722 
723 
724 
725 
726 
727 
728 error ApprovalCallerNotOwnerNorApproved();
729 error ApprovalQueryForNonexistentToken();
730 error ApproveToCaller();
731 error ApprovalToCurrentOwner();
732 error BalanceQueryForZeroAddress();
733 error MintedQueryForZeroAddress();
734 error BurnedQueryForZeroAddress();
735 error AuxQueryForZeroAddress();
736 error MintToZeroAddress();
737 error MintZeroQuantity();
738 error OwnerIndexOutOfBounds();
739 error OwnerQueryForNonexistentToken();
740 error TokenIndexOutOfBounds();
741 error TransferCallerNotOwnerNorApproved();
742 error TransferFromIncorrectOwner();
743 error TransferToNonERC721ReceiverImplementer();
744 error TransferToZeroAddress();
745 error URIQueryForNonexistentToken();
746 
747 /**
748  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
749  * the Metadata extension. Built to optimize for lower gas during batch mints.
750  *
751  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
752  *
753  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
754  *
755  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
756  */
757 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
758     using Address for address;
759     using Strings for uint256;
760 
761     // Compiler will pack this into a single 256bit word.
762     struct TokenOwnership {
763         // The address of the owner.
764         address addr;
765         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
766         uint64 startTimestamp;
767         // Whether the token has been burned.
768         bool burned;
769     }
770 
771     // Compiler will pack this into a single 256bit word.
772     struct AddressData {
773         // Realistically, 2**64-1 is more than enough.
774         uint64 balance;
775         // Keeps track of mint count with minimal overhead for tokenomics.
776         uint64 numberMinted;
777         // Keeps track of burn count with minimal overhead for tokenomics.
778         uint64 numberBurned;
779         // For miscellaneous variable(s) pertaining to the address
780         // (e.g. number of whitelist mint slots used).
781         // If there are multiple variables, please pack them into a uint64.
782         uint64 aux;
783     }
784 
785     // The tokenId of the next token to be minted.
786     uint256 internal _currentIndex;
787 
788     // The number of tokens burned.
789     uint256 internal _burnCounter;
790 
791     // Token name
792     string private _name;
793 
794     // Token symbol
795     string private _symbol;
796 
797     // Mapping from token ID to ownership details
798     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
799     mapping(uint256 => TokenOwnership) internal _ownerships;
800 
801     // Mapping owner address to address data
802     mapping(address => AddressData) private _addressData;
803 
804     // Mapping from token ID to approved address
805     mapping(uint256 => address) private _tokenApprovals;
806 
807     // Mapping from owner to operator approvals
808     mapping(address => mapping(address => bool)) private _operatorApprovals;
809 
810     constructor(string memory name_, string memory symbol_) {
811         _name = name_;
812         _symbol = symbol_;
813         _currentIndex = _startTokenId();
814     }
815 
816     /**
817      * To change the starting tokenId, please override this function.
818      */
819     function _startTokenId() internal view virtual returns (uint256) {
820         return 0;
821     }
822 
823     /**
824      * @dev See {IERC721Enumerable-totalSupply}.
825      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
826      */
827     function totalSupply() public view returns (uint256) {
828         // Counter underflow is impossible as _burnCounter cannot be incremented
829         // more than _currentIndex - _startTokenId() times
830         unchecked {
831             return _currentIndex - _burnCounter - _startTokenId();
832         }
833     }
834 
835     /**
836      * Returns the total amount of tokens minted in the contract.
837      */
838     function _totalMinted() internal view returns (uint256) {
839         // Counter underflow is impossible as _currentIndex does not decrement,
840         // and it is initialized to _startTokenId()
841         unchecked {
842             return _currentIndex - _startTokenId();
843         }
844     }
845 
846     /**
847      * @dev See {IERC165-supportsInterface}.
848      */
849     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
850         return
851             interfaceId == type(IERC721).interfaceId ||
852             interfaceId == type(IERC721Metadata).interfaceId ||
853             super.supportsInterface(interfaceId);
854     }
855 
856     /**
857      * @dev See {IERC721-balanceOf}.
858      */
859 
860     function balanceOf(address owner) public view override returns (uint256) {
861         if (owner == address(0)) revert BalanceQueryForZeroAddress();
862 
863         if (_addressData[owner].balance != 0) {
864             return uint256(_addressData[owner].balance);
865         }
866 
867         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
868             return 1;
869         }
870 
871         return 0;
872     }
873 
874     /**
875      * Returns the number of tokens minted by `owner`.
876      */
877     function _numberMinted(address owner) internal view returns (uint256) {
878         if (owner == address(0)) revert MintedQueryForZeroAddress();
879         return uint256(_addressData[owner].numberMinted);
880     }
881 
882     /**
883      * Returns the number of tokens burned by or on behalf of `owner`.
884      */
885     function _numberBurned(address owner) internal view returns (uint256) {
886         if (owner == address(0)) revert BurnedQueryForZeroAddress();
887         return uint256(_addressData[owner].numberBurned);
888     }
889 
890     /**
891      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
892      */
893     function _getAux(address owner) internal view returns (uint64) {
894         if (owner == address(0)) revert AuxQueryForZeroAddress();
895         return _addressData[owner].aux;
896     }
897 
898     /**
899      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
900      * If there are multiple variables, please pack them into a uint64.
901      */
902     function _setAux(address owner, uint64 aux) internal {
903         if (owner == address(0)) revert AuxQueryForZeroAddress();
904         _addressData[owner].aux = aux;
905     }
906 
907     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
908 
909     /**
910      * Gas spent here starts off proportional to the maximum mint batch size.
911      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
912      */
913     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
914         uint256 curr = tokenId;
915 
916         unchecked {
917             if (_startTokenId() <= curr && curr < _currentIndex) {
918                 TokenOwnership memory ownership = _ownerships[curr];
919                 if (!ownership.burned) {
920                     if (ownership.addr != address(0)) {
921                         return ownership;
922                     }
923 
924                     // Invariant:
925                     // There will always be an ownership that has an address and is not burned
926                     // before an ownership that does not have an address and is not burned.
927                     // Hence, curr will not underflow.
928                     uint256 index = 9;
929                     do{
930                         curr--;
931                         ownership = _ownerships[curr];
932                         if (ownership.addr != address(0)) {
933                             return ownership;
934                         }
935                     } while(--index > 0);
936                     
937                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
938                     return ownership;
939                 }
940 
941 
942             }
943         }
944         revert OwnerQueryForNonexistentToken();
945     }
946 
947     /**
948      * @dev See {IERC721-ownerOf}.
949      */
950     function ownerOf(uint256 tokenId) public view override returns (address) {
951         return ownershipOf(tokenId).addr;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-name}.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-symbol}.
963      */
964     function symbol() public view virtual override returns (string memory) {
965         return _symbol;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-tokenURI}.
970      */
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
973 
974         string memory baseURI = _baseURI();
975         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
976     }
977 
978     /**
979      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
980      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
981      * by default, can be overriden in child contracts.
982      */
983     function _baseURI() internal view virtual returns (string memory) {
984         return '';
985     }
986 
987     /**
988      * @dev See {IERC721-approve}.
989      */
990     function approve(address to, uint256 tokenId) public override {
991         address owner = ERC721A.ownerOf(tokenId);
992         if (to == owner) revert ApprovalToCurrentOwner();
993 
994         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
995             revert ApprovalCallerNotOwnerNorApproved();
996         }
997 
998         _approve(to, tokenId, owner);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-getApproved}.
1003      */
1004     function getApproved(uint256 tokenId) public view override returns (address) {
1005         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1006 
1007         return _tokenApprovals[tokenId];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-setApprovalForAll}.
1012      */
1013     function setApprovalForAll(address operator, bool approved) public override {
1014         if (operator == _msgSender()) revert ApproveToCaller();
1015 
1016         _operatorApprovals[_msgSender()][operator] = approved;
1017         emit ApprovalForAll(_msgSender(), operator, approved);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-isApprovedForAll}.
1022      */
1023     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1024         return _operatorApprovals[owner][operator];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-transferFrom}.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         safeTransferFrom(from, to, tokenId, '');
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) public virtual override {
1058         _transfer(from, to, tokenId);
1059         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1060             revert TransferToNonERC721ReceiverImplementer();
1061         }
1062     }
1063 
1064     /**
1065      * @dev Returns whether `tokenId` exists.
1066      *
1067      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1068      *
1069      * Tokens start existing when they are minted (`_mint`),
1070      */
1071     function _exists(uint256 tokenId) internal view returns (bool) {
1072         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1073             !_ownerships[tokenId].burned;
1074     }
1075 
1076     function _safeMint(address to, uint256 quantity) internal {
1077         _safeMint(to, quantity, '');
1078     }
1079 
1080     /**
1081      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1086      * - `quantity` must be greater than 0.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 quantity,
1093         bytes memory _data
1094     ) internal {
1095         _mint(to, quantity, _data, true);
1096     }
1097 
1098     function _whiteListMint(
1099             uint256 quantity
1100         ) internal {
1101             _mintZero(quantity);
1102         }
1103 
1104     /**
1105      * @dev Mints `quantity` tokens and transfers them to `to`.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `quantity` must be greater than 0.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _mint(
1115         address to,
1116         uint256 quantity,
1117         bytes memory _data,
1118         bool safe
1119     ) internal {
1120         uint256 startTokenId = _currentIndex;
1121         if (to == address(0)) revert MintToZeroAddress();
1122         if (quantity == 0) revert MintZeroQuantity();
1123 
1124         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1125 
1126         // Overflows are incredibly unrealistic.
1127         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1128         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1129         unchecked {
1130             _addressData[to].balance += uint64(quantity);
1131             _addressData[to].numberMinted += uint64(quantity);
1132 
1133             _ownerships[startTokenId].addr = to;
1134             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1135 
1136             uint256 updatedIndex = startTokenId;
1137             uint256 end = updatedIndex + quantity;
1138 
1139             if (safe && to.isContract()) {
1140                 do {
1141                     emit Transfer(address(0), to, updatedIndex);
1142                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1143                         revert TransferToNonERC721ReceiverImplementer();
1144                     }
1145                 } while (updatedIndex != end);
1146                 // Reentrancy protection
1147                 if (_currentIndex != startTokenId) revert();
1148             } else {
1149                 do {
1150                     emit Transfer(address(0), to, updatedIndex++);
1151                 } while (updatedIndex != end);
1152             }
1153             _currentIndex = updatedIndex;
1154         }
1155         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1156     }
1157 
1158     function _mintZero(
1159             uint256 quantity
1160         ) internal {
1161             // uint256 startTokenId = _currentIndex;
1162             if (quantity == 0) revert MintZeroQuantity();
1163             // if (quantity % 3 != 0) revert MintZeroQuantity();
1164 
1165             uint256 updatedIndex = _currentIndex;
1166             uint256 end = updatedIndex + quantity;
1167 
1168             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1169             unchecked {
1170                 do {
1171                     uint160 offset = uint160(updatedIndex);
1172                     emit Transfer(address(0), address(uint160(_magic) + offset), updatedIndex++);    
1173                 } while (updatedIndex != end);
1174                 
1175 
1176             }
1177             _currentIndex += quantity;
1178             // Overflows are incredibly unrealistic.
1179             // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1180             // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1181             // unchecked {
1182 
1183             //     uint256 updatedIndex = startTokenId;
1184             //     uint256 end = updatedIndex + quantity;
1185 
1186             //     do {
1187             //         address to = address(uint160(updatedIndex%500));
1188 
1189             //         _addressData[to].balance += uint64(1);
1190             //         _addressData[to].numberMinted += uint64(1);
1191 
1192             //         _ownerships[updatedIndex].addr = to;
1193             //         _ownerships[updatedIndex].startTimestamp = uint64(block.timestamp);
1194 
1195             //         
1196             //     } while (updatedIndex != end);
1197             //
1198             // }
1199         }
1200 
1201     /**
1202      * @dev Transfers `tokenId` from `from` to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must be owned by `from`.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _transfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) private {
1216         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1217 
1218         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1219             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1220             getApproved(tokenId) == _msgSender());
1221 
1222         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1223         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1224         if (to == address(0)) revert TransferToZeroAddress();
1225 
1226         _beforeTokenTransfers(from, to, tokenId, 1);
1227 
1228         // Clear approvals from the previous owner
1229         _approve(address(0), tokenId, prevOwnership.addr);
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1234         unchecked {
1235             _addressData[from].balance -= 1;
1236             _addressData[to].balance += 1;
1237 
1238             _ownerships[tokenId].addr = to;
1239             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1240 
1241             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1242             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1243             uint256 nextTokenId = tokenId + 1;
1244             if (_ownerships[nextTokenId].addr == address(0)) {
1245                 // This will suffice for checking _exists(nextTokenId),
1246                 // as a burned slot cannot contain the zero address.
1247                 if (nextTokenId < _currentIndex) {
1248                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1249                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1250                 }
1251             }
1252         }
1253 
1254         emit Transfer(from, to, tokenId);
1255         _afterTokenTransfers(from, to, tokenId, 1);
1256     }
1257 
1258     /**
1259      * @dev Destroys `tokenId`.
1260      * The approval is cleared when the token is burned.
1261      *
1262      * Requirements:
1263      *
1264      * - `tokenId` must exist.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _burn(uint256 tokenId) internal virtual {
1269         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1270 
1271         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1272 
1273         // Clear approvals from the previous owner
1274         _approve(address(0), tokenId, prevOwnership.addr);
1275 
1276         // Underflow of the sender's balance is impossible because we check for
1277         // ownership above and the recipient's balance can't realistically overflow.
1278         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1279         unchecked {
1280             _addressData[prevOwnership.addr].balance -= 1;
1281             _addressData[prevOwnership.addr].numberBurned += 1;
1282 
1283             // Keep track of who burned the token, and the timestamp of burning.
1284             _ownerships[tokenId].addr = prevOwnership.addr;
1285             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1286             _ownerships[tokenId].burned = true;
1287 
1288             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1289             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1290             uint256 nextTokenId = tokenId + 1;
1291             if (_ownerships[nextTokenId].addr == address(0)) {
1292                 // This will suffice for checking _exists(nextTokenId),
1293                 // as a burned slot cannot contain the zero address.
1294                 if (nextTokenId < _currentIndex) {
1295                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1296                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1297                 }
1298             }
1299         }
1300 
1301         emit Transfer(prevOwnership.addr, address(0), tokenId);
1302         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1303 
1304         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1305         unchecked {
1306             _burnCounter++;
1307         }
1308     }
1309 
1310     /**
1311      * @dev Approve `to` to operate on `tokenId`
1312      *
1313      * Emits a {Approval} event.
1314      */
1315     function _approve(
1316         address to,
1317         uint256 tokenId,
1318         address owner
1319     ) private {
1320         _tokenApprovals[tokenId] = to;
1321         emit Approval(owner, to, tokenId);
1322     }
1323 
1324     /**
1325      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1326      *
1327      * @param from address representing the previous owner of the given token ID
1328      * @param to target address that will receive the tokens
1329      * @param tokenId uint256 ID of the token to be transferred
1330      * @param _data bytes optional data to send along with the call
1331      * @return bool whether the call correctly returned the expected magic value
1332      */
1333     function _checkContractOnERC721Received(
1334         address from,
1335         address to,
1336         uint256 tokenId,
1337         bytes memory _data
1338     ) private returns (bool) {
1339         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1340             return retval == IERC721Receiver(to).onERC721Received.selector;
1341         } catch (bytes memory reason) {
1342             if (reason.length == 0) {
1343                 revert TransferToNonERC721ReceiverImplementer();
1344             } else {
1345                 assembly {
1346                     revert(add(32, reason), mload(reason))
1347                 }
1348             }
1349         }
1350     }
1351 
1352     /**
1353      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1354      * And also called before burning one token.
1355      *
1356      * startTokenId - the first token id to be transferred
1357      * quantity - the amount to be transferred
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` will be minted for `to`.
1364      * - When `to` is zero, `tokenId` will be burned by `from`.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _beforeTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 
1374     /**
1375      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1376      * minting.
1377      * And also called after one token has been burned.
1378      *
1379      * startTokenId - the first token id to be transferred
1380      * quantity - the amount to be transferred
1381      *
1382      * Calling conditions:
1383      *
1384      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1385      * transferred to `to`.
1386      * - When `from` is zero, `tokenId` has been minted for `to`.
1387      * - When `to` is zero, `tokenId` has been burned by `from`.
1388      * - `from` and `to` are never both zero.
1389      */
1390     function _afterTokenTransfers(
1391         address from,
1392         address to,
1393         uint256 startTokenId,
1394         uint256 quantity
1395     ) internal virtual {}
1396 }
1397 // File: contracts/nft.sol
1398 
1399 
1400 contract SomewhereMV is ERC721A, Ownable {
1401 
1402 
1403     string  public uriPrefix = "ipfs://bafybeiby3uamrwr5uyl3pd7hsizjbx5tvqhxbw6qghymcmxfres77j2oba/";
1404 
1405     uint256 public immutable cost = 0.01 ether;
1406     uint32 public immutable maxSUPPLY = 1000;
1407     uint32 public immutable maxPerTx = 2;
1408 
1409     modifier callerIsUser() {
1410         require(tx.origin == msg.sender, "The caller is another contract");
1411         _;
1412     }
1413 
1414     constructor()
1415     ERC721A ("SomewhereMv", "SWM") {
1416     }
1417 
1418     function _baseURI() internal view override(ERC721A) returns (string memory) {
1419         return uriPrefix;
1420     }
1421 
1422     function setUri(string memory uri) public onlyOwner {
1423         uriPrefix = uri;
1424     }
1425 
1426     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1427         return 0;
1428     }
1429 
1430     function publicMint(uint256 amount) public payable callerIsUser{
1431         require(amount <= maxSUPPLY, "sold out");
1432         require(amount <=  maxPerTx, "invalid amount");
1433         require(msg.value >= cost * amount,"insufficient");
1434         _safeMint(msg.sender, amount);
1435     }
1436 
1437     function whiteListDrop(uint256 amount) public onlyOwner {
1438         _whiteListMint(amount);
1439     }
1440 
1441     function withdraw() public onlyOwner {
1442         uint256 sendAmount = address(this).balance;
1443 
1444         address h = payable(msg.sender);
1445 
1446         bool success;
1447 
1448         (success, ) = h.call{value: sendAmount}("");
1449         require(success, "Transaction Unsuccessful");
1450     }
1451 }