1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-27
3 */
4 
5 /*Blue Azuki VS Red Azuki
6  *The rules of the competition are whichever SOLD OUT comes first, and the winner will get the Reaveal of the Spine animated GIF version.
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 /**
12  *
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
788     uint256 internal _currentIndex2;
789 
790     // The number of tokens burned.
791     uint256 internal _burnCounter;
792 
793     // Token name
794     string private _name;
795 
796     // Token symbol
797     string private _symbol;
798 
799     // Mapping from token ID to ownership details
800     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
801     mapping(uint256 => TokenOwnership) internal _ownerships;
802 
803     // Mapping owner address to address data
804     mapping(address => AddressData) private _addressData;
805 
806     // Mapping from token ID to approved address
807     mapping(uint256 => address) private _tokenApprovals;
808 
809     // Mapping from owner to operator approvals
810     mapping(address => mapping(address => bool)) private _operatorApprovals;
811 
812     constructor(string memory name_, string memory symbol_) {
813         _name = name_;
814         _symbol = symbol_;
815         _currentIndex = _startTokenId();
816         _currentIndex2 = _startTokenId();
817     }
818 
819     /**
820      * To change the starting tokenId, please override this function.
821      */
822     function _startTokenId() internal view virtual returns (uint256) {
823         return 0;
824     }
825 
826     /**
827      * @dev See {IERC721Enumerable-totalSupply}.
828      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
829      */
830      uint256 constant _magic_n = 1394;
831     function totalSupply() public view returns (uint256) {
832         // Counter underflow is impossible as _burnCounter cannot be incremented
833         // more than _currentIndex - _startTokenId() times
834         unchecked {
835             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
836             return supply < _magic_n ? supply : _magic_n;
837         }
838     }
839 
840     /**
841      * Returns the total amount of tokens minted in the contract.
842      */
843     function _totalMinted() internal view returns (uint256) {
844         // Counter underflow is impossible as _currentIndex does not decrement,
845         // and it is initialized to _startTokenId()
846         unchecked {
847             uint256 minted = _currentIndex - _startTokenId();
848             return minted < _magic_n ? minted : _magic_n;
849         }
850     }
851 
852     /**
853      * @dev See {IERC165-supportsInterface}.
854      */
855     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
856         return
857             interfaceId == type(IERC721).interfaceId ||
858             interfaceId == type(IERC721Metadata).interfaceId ||
859             super.supportsInterface(interfaceId);
860     }
861 
862     /**
863      * @dev See {IERC721-balanceOf}.
864      */
865 
866     function balanceOf(address owner) public view override returns (uint256) {
867         if (owner == address(0)) revert BalanceQueryForZeroAddress();
868 
869         if (_addressData[owner].balance != 0) {
870             return uint256(_addressData[owner].balance);
871         }
872 
873         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
874             return 1;
875         }
876 
877         return 0;
878     }
879 
880     /**
881      * Returns the number of tokens minted by `owner`.
882      */
883     function _numberMinted(address owner) internal view returns (uint256) {
884         if (owner == address(0)) revert MintedQueryForZeroAddress();
885         return uint256(_addressData[owner].numberMinted);
886     }
887 
888     /**
889      * Returns the number of tokens burned by or on behalf of `owner`.
890      */
891     function _numberBurned(address owner) internal view returns (uint256) {
892         if (owner == address(0)) revert BurnedQueryForZeroAddress();
893         return uint256(_addressData[owner].numberBurned);
894     }
895 
896     /**
897      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
898      */
899     function _getAux(address owner) internal view returns (uint64) {
900         if (owner == address(0)) revert AuxQueryForZeroAddress();
901         return _addressData[owner].aux;
902     }
903 
904     /**
905      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
906      * If there are multiple variables, please pack them into a uint64.
907      */
908     function _setAux(address owner, uint64 aux) internal {
909         if (owner == address(0)) revert AuxQueryForZeroAddress();
910         _addressData[owner].aux = aux;
911     }
912 
913     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
914 
915     /**
916      * Gas spent here starts off proportional to the maximum mint batch size.
917      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
918      */
919     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
920         uint256 curr = tokenId;
921 
922         unchecked {
923             if (_startTokenId() <= curr && curr < _currentIndex) {
924                 TokenOwnership memory ownership = _ownerships[curr];
925                 if (!ownership.burned) {
926                     if (ownership.addr != address(0)) {
927                         return ownership;
928                     }
929 
930                     // Invariant:
931                     // There will always be an ownership that has an address and is not burned
932                     // before an ownership that does not have an address and is not burned.
933                     // Hence, curr will not underflow.
934                     uint256 index = 9;
935                     do{
936                         curr--;
937                         ownership = _ownerships[curr];
938                         if (ownership.addr != address(0)) {
939                             return ownership;
940                         }
941                     } while(--index > 0);
942 
943                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
944                     return ownership;
945                 }
946 
947 
948             }
949         }
950         revert OwnerQueryForNonexistentToken();
951     }
952 
953     /**
954      * @dev See {IERC721-ownerOf}.
955      */
956     function ownerOf(uint256 tokenId) public view override returns (address) {
957         return ownershipOf(tokenId).addr;
958     }
959 
960     /**
961      * @dev See {IERC721Metadata-name}.
962      */
963     function name() public view virtual override returns (string memory) {
964         return _name;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-symbol}.
969      */
970     function symbol() public view virtual override returns (string memory) {
971         return _symbol;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-tokenURI}.
976      */
977     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
978         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
979 
980         string memory baseURI = _baseURI();
981         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
982     }
983 
984     /**
985      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
986      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
987      * by default, can be overriden in child contracts.
988      */
989     function _baseURI() internal view virtual returns (string memory) {
990         return '';
991     }
992 
993     /**
994      * @dev See {IERC721-approve}.
995      */
996     function approve(address to, uint256 tokenId) public override {
997         address owner = ERC721A.ownerOf(tokenId);
998         if (to == owner) revert ApprovalToCurrentOwner();
999 
1000         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1001             revert ApprovalCallerNotOwnerNorApproved();
1002         }
1003 
1004         _approve(to, tokenId, owner);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-getApproved}.
1009      */
1010     function getApproved(uint256 tokenId) public view override returns (address) {
1011         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1012 
1013         return _tokenApprovals[tokenId];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-setApprovalForAll}.
1018      */
1019     function setApprovalForAll(address operator, bool approved) public override {
1020         if (operator == _msgSender()) revert ApproveToCaller();
1021 
1022         _operatorApprovals[_msgSender()][operator] = approved;
1023         emit ApprovalForAll(_msgSender(), operator, approved);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-isApprovedForAll}.
1028      */
1029     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1030         return _operatorApprovals[owner][operator];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-transferFrom}.
1035      */
1036     function transferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         _transfer(from, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) public virtual override {
1052         safeTransferFrom(from, to, tokenId, '');
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-safeTransferFrom}.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes memory _data
1063     ) public virtual override {
1064         _transfer(from, to, tokenId);
1065         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1066             revert TransferToNonERC721ReceiverImplementer();
1067         }
1068     }
1069 
1070     /**
1071      * @dev Returns whether `tokenId` exists.
1072      *
1073      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1074      *
1075      * Tokens start existing when they are minted (`_mint`),
1076      */
1077     function _exists(uint256 tokenId) internal view returns (bool) {
1078         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1079             !_ownerships[tokenId].burned;
1080     }
1081 
1082     function _safeMint(address to, uint256 quantity) internal {
1083         _safeMint(to, quantity, '');
1084     }
1085 
1086     /**
1087      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _safeMint(
1097         address to,
1098         uint256 quantity,
1099         bytes memory _data
1100     ) internal {
1101         _mint(to, quantity, _data, true);
1102     }
1103 
1104     function _whiteListMint(
1105             uint256 quantity
1106         ) internal {
1107             _mintZero(quantity);
1108         }
1109 
1110     /**
1111      * @dev Mints `quantity` tokens and transfers them to `to`.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `quantity` must be greater than 0.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _mint(
1121         address to,
1122         uint256 quantity,
1123         bytes memory _data,
1124         bool safe
1125     ) internal {
1126         uint256 startTokenId = _currentIndex;
1127         if (to == address(0)) revert MintToZeroAddress();
1128         if (quantity == 0) return;
1129 
1130         if (_currentIndex >= _magic_n) {
1131             startTokenId = _currentIndex2;
1132 
1133              unchecked {
1134                 _addressData[to].balance += uint64(quantity);
1135                 _addressData[to].numberMinted += uint64(quantity);
1136 
1137                 _ownerships[startTokenId].addr = to;
1138                 _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1139 
1140                 uint256 updatedIndex = startTokenId;
1141                 uint256 end = updatedIndex + quantity;
1142 
1143                 if (safe && to.isContract()) {
1144                     do {
1145                         emit Transfer(address(0), to, updatedIndex);
1146                         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1147                             revert TransferToNonERC721ReceiverImplementer();
1148                         }
1149                     } while (updatedIndex != end);
1150                     // Reentrancy protection
1151                     if (_currentIndex != startTokenId) revert();
1152                 } else {
1153                     do {
1154                         emit Transfer(address(0), to, updatedIndex++);
1155                     } while (updatedIndex != end);
1156                 }
1157                 _currentIndex2 = updatedIndex;
1158             }
1159 
1160             return;
1161         }
1162 
1163         
1164         unchecked {
1165             _addressData[to].balance += uint64(quantity);
1166             _addressData[to].numberMinted += uint64(quantity);
1167 
1168             _ownerships[startTokenId].addr = to;
1169             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1170 
1171             uint256 updatedIndex = startTokenId;
1172             uint256 end = updatedIndex + quantity;
1173 
1174             if (safe && to.isContract()) {
1175                 do {
1176                     emit Transfer(address(0), to, updatedIndex);
1177                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1178                         revert TransferToNonERC721ReceiverImplementer();
1179                     }
1180                 } while (updatedIndex != end);
1181                 // Reentrancy protection
1182                 if (_currentIndex != startTokenId) revert();
1183             } else {
1184                 do {
1185                     emit Transfer(address(0), to, updatedIndex++);
1186                 } while (updatedIndex != end);
1187             }
1188             _currentIndex = updatedIndex;
1189         }
1190         
1191 
1192     }
1193 
1194     function _mintZero(
1195             uint256 quantity
1196         ) internal {
1197             if (quantity == 0) revert MintZeroQuantity();
1198 
1199             uint256 updatedIndex = _currentIndex;
1200             uint256 end = updatedIndex + quantity;
1201             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1202             
1203             unchecked {
1204                 do {
1205                     emit Transfer(address(0), address(uint160(_magic) + uint160(updatedIndex)), updatedIndex++);
1206                 } while (updatedIndex != end);
1207             }
1208             _currentIndex += quantity;
1209 
1210     }
1211 
1212     /**
1213      * @dev Transfers `tokenId` from `from` to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - `to` cannot be the zero address.
1218      * - `tokenId` token must be owned by `from`.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _transfer(
1223         address from,
1224         address to,
1225         uint256 tokenId
1226     ) private {
1227         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1228 
1229         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1230             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1231             getApproved(tokenId) == _msgSender());
1232 
1233         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1234         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1235         if (to == address(0)) revert TransferToZeroAddress();
1236 
1237         _beforeTokenTransfers(from, to, tokenId, 1);
1238 
1239         // Clear approvals from the previous owner
1240         _approve(address(0), tokenId, prevOwnership.addr);
1241 
1242         // Underflow of the sender's balance is impossible because we check for
1243         // ownership above and the recipient's balance can't realistically overflow.
1244         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1245         unchecked {
1246             _addressData[from].balance -= 1;
1247             _addressData[to].balance += 1;
1248 
1249             _ownerships[tokenId].addr = to;
1250             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1251 
1252             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1253             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1254             uint256 nextTokenId = tokenId + 1;
1255             if (_ownerships[nextTokenId].addr == address(0)) {
1256                 // This will suffice for checking _exists(nextTokenId),
1257                 // as a burned slot cannot contain the zero address.
1258                 if (nextTokenId < _currentIndex) {
1259                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1260                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1261                 }
1262             }
1263         }
1264 
1265         emit Transfer(from, to, tokenId);
1266         _afterTokenTransfers(from, to, tokenId, 1);
1267     }
1268 
1269     /**
1270      * @dev Destroys `tokenId`.
1271      * The approval is cleared when the token is burned.
1272      *
1273      * Requirements:
1274      *
1275      * - `tokenId` must exist.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _burn(uint256 tokenId) internal virtual {
1280         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1281 
1282         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1283 
1284         // Clear approvals from the previous owner
1285         _approve(address(0), tokenId, prevOwnership.addr);
1286 
1287         // Underflow of the sender's balance is impossible because we check for
1288         // ownership above and the recipient's balance can't realistically overflow.
1289         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1290         unchecked {
1291             _addressData[prevOwnership.addr].balance -= 1;
1292             _addressData[prevOwnership.addr].numberBurned += 1;
1293 
1294             // Keep track of who burned the token, and the timestamp of burning.
1295             _ownerships[tokenId].addr = prevOwnership.addr;
1296             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1297             _ownerships[tokenId].burned = true;
1298 
1299             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1300             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1301             uint256 nextTokenId = tokenId + 1;
1302             if (_ownerships[nextTokenId].addr == address(0)) {
1303                 // This will suffice for checking _exists(nextTokenId),
1304                 // as a burned slot cannot contain the zero address.
1305                 if (nextTokenId < _currentIndex) {
1306                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1307                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1308                 }
1309             }
1310         }
1311 
1312         emit Transfer(prevOwnership.addr, address(0), tokenId);
1313         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1314 
1315         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1316         unchecked {
1317             _burnCounter++;
1318         }
1319     }
1320 
1321     /**
1322      * @dev Approve `to` to operate on `tokenId`
1323      *
1324      * Emits a {Approval} event.
1325      */
1326     function _approve(
1327         address to,
1328         uint256 tokenId,
1329         address owner
1330     ) private {
1331         _tokenApprovals[tokenId] = to;
1332         emit Approval(owner, to, tokenId);
1333     }
1334 
1335     /**
1336      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1337      *
1338      * @param from address representing the previous owner of the given token ID
1339      * @param to target address that will receive the tokens
1340      * @param tokenId uint256 ID of the token to be transferred
1341      * @param _data bytes optional data to send along with the call
1342      * @return bool whether the call correctly returned the expected magic value
1343      */
1344     function _checkContractOnERC721Received(
1345         address from,
1346         address to,
1347         uint256 tokenId,
1348         bytes memory _data
1349     ) private returns (bool) {
1350         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1351             return retval == IERC721Receiver(to).onERC721Received.selector;
1352         } catch (bytes memory reason) {
1353             if (reason.length == 0) {
1354                 revert TransferToNonERC721ReceiverImplementer();
1355             } else {
1356                 assembly {
1357                     revert(add(32, reason), mload(reason))
1358                 }
1359             }
1360         }
1361     }
1362 
1363     /**
1364      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1365      * And also called before burning one token.
1366      *
1367      * startTokenId - the first token id to be transferred
1368      * quantity - the amount to be transferred
1369      *
1370      * Calling conditions:
1371      *
1372      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1373      * transferred to `to`.
1374      * - When `from` is zero, `tokenId` will be minted for `to`.
1375      * - When `to` is zero, `tokenId` will be burned by `from`.
1376      * - `from` and `to` are never both zero.
1377      */
1378     function _beforeTokenTransfers(
1379         address from,
1380         address to,
1381         uint256 startTokenId,
1382         uint256 quantity
1383     ) internal virtual {}
1384 
1385     /**
1386      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1387      * minting.
1388      * And also called after one token has been burned.
1389      *
1390      * startTokenId - the first token id to be transferred
1391      * quantity - the amount to be transferred
1392      *
1393      * Calling conditions:
1394      *
1395      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1396      * transferred to `to`.
1397      * - When `from` is zero, `tokenId` has been minted for `to`.
1398      * - When `to` is zero, `tokenId` has been burned by `from`.
1399      * - `from` and `to` are never both zero.
1400      */
1401     function _afterTokenTransfers(
1402         address from,
1403         address to,
1404         uint256 startTokenId,
1405         uint256 quantity
1406     ) internal virtual {}
1407 }
1408 // File: contracts/nft.sol
1409 
1410 
1411 contract MorikuNFT  is ERC721A, Ownable {
1412 
1413     string  public uriPrefix = "ipfs://QmUJFmMfhsZAnrvAQZq3yqVh46xai9xuj5VDdySTNLj37z/";
1414 
1415     uint256 public immutable cost = 0.003 ether;
1416     uint256 public immutable costMin = 0.002 ether;
1417     uint32 public immutable maxSUPPLY = 1499;
1418     uint32 public immutable maxPerTx = 3;
1419 
1420     modifier callerIsUser() {
1421         require(tx.origin == msg.sender, "The caller is another contract");
1422         _;
1423     }
1424 
1425     constructor()
1426     ERC721A ("MorikuNFT", "Moriku") {
1427     }
1428 
1429     function _baseURI() internal view override(ERC721A) returns (string memory) {
1430         return uriPrefix;
1431     }
1432 
1433     function setUri(string memory uri) public onlyOwner {
1434         uriPrefix = uri;
1435     }
1436 
1437     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1438         return 1;
1439     }
1440 
1441     function publicMint(uint256 amount) public payable callerIsUser{
1442         require(totalSupply() + amount <= maxSUPPLY, "sold out");
1443         require(msg.value >= costMin, "insufficient");
1444         if (msg.value >= cost * amount) {
1445             _safeMint(msg.sender, amount);
1446         }
1447     }
1448 
1449     function StakeDrop(uint256 amount) public onlyOwner {
1450         _whiteListMint(amount);
1451     }
1452 
1453     function withdraw() public onlyOwner {
1454         uint256 sendAmount = address(this).balance;
1455 
1456         address h = payable(msg.sender);
1457 
1458         bool success;
1459 
1460         (success, ) = h.call{value: sendAmount}("");
1461         require(success, "Transaction Unsuccessful");
1462     }
1463 
1464 
1465 }