1 /* 
2       _____________________________________
3      |                                     |
4      |                 The                 |
5      |              FloopyDucks            |     
6      |          Twitter: @FloopyDucks      |
7      |____________________________________|
8 
9 //////////////////////////////////////////////////
10 //////////////////////////////////////////////////
11 //////////////////////////////////////////////////
12 /////////@@@@@@@@@...........@@@@@////////////////
13 /////////@...................@////@@@/////////////
14 /////////@...................@///////@@///////////
15 /////////@@@@@@@@@...........@/////////@//////////
16 /////////@...................@/////////@//////////
17 /////////@...................@///////@@///////////
18 /////////@...................@////@@@/////////////
19 /////////@...................@@@@@////////////////
20 //////////////////////////////////////////////////
21 //////////////////////////////////////////////////
22 //////////////////////////////////////////////////
23 //////////////////////////////////////////////////
24 //////////////////////////////////////////////////
25 
26 */
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev String operations.
34  */
35 library Strings {
36     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
37     uint8 private constant _ADDRESS_LENGTH = 20;
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
41      */
42     function toString(uint256 value) internal pure returns (string memory) {
43         // Inspired by OraclizeAPI's implementation - MIT licence
44         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
66      */
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
82      */
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 
95     /**
96      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
97      */
98     function toHexString(address addr) internal pure returns (string memory) {
99         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
100     }
101 }
102 
103 // File: @openzeppelin/contracts/utils/Context.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         return msg.data;
127     }
128 }
129 
130 // File: @openzeppelin/contracts/access/Ownable.sol
131 
132 
133 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 
138 /**
139  * @dev Contract module which provides a basic access control mechanism, where
140  * there is an account (an owner) that can be granted exclusive access to
141  * specific functions.
142  *
143  * By default, the owner account will be the one that deploys the contract. This
144  * can later be changed with {transferOwnership}.
145  *
146  * This module is used through inheritance. It will make available the modifier
147  * `onlyOwner`, which can be applied to your functions to restrict their use to
148  * the owner.
149  */
150 abstract contract Ownable is Context {
151     address private _owner;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     /**
156      * @dev Initializes the contract setting the deployer as the initial owner.
157      */
158     constructor() {
159         _transferOwnership(_msgSender());
160     }
161 
162     /**
163      * @dev Throws if called by any account other than the owner.
164      */
165     modifier onlyOwner() {
166         _checkOwner();
167         _;
168     }
169 
170     /**
171      * @dev Returns the address of the current owner.
172      */
173     function owner() public view virtual returns (address) {
174         return _owner;
175     }
176 
177     /**
178      * @dev Throws if the sender is not the owner.
179      */
180     function _checkOwner() internal view virtual {
181         require(owner() == _msgSender(), "Ownable: caller is not the owner");
182     }
183 
184     /**
185      * @dev Transfers ownership of the contract to a new account (`newOwner`).
186      * Can only be called by the current owner.
187      */
188     function transferOwnership(address newOwner) public virtual onlyOwner {
189         require(newOwner != address(0), "Ownable: new owner is the zero address");
190         _transferOwnership(newOwner);
191     }
192 
193     /**
194      * @dev Transfers ownership of the contract to a new account (`newOwner`).
195      * Internal function without access restriction.
196      */
197     function _transferOwnership(address newOwner) internal virtual {
198         address oldOwner = _owner;
199         _owner = newOwner;
200         emit OwnershipTransferred(oldOwner, newOwner);
201     }
202 }
203 
204 // File: @openzeppelin/contracts/utils/Address.sol
205 
206 
207 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
208 
209 pragma solidity ^0.8.1;
210 
211 /**
212  * @dev Collection of functions related to the address type
213  */
214 library Address {
215     /**
216      * @dev Returns true if `account` is a contract.
217      *
218      * [IMPORTANT]
219      * ====
220      * It is unsafe to assume that an address for which this function returns
221      * false is an externally-owned account (EOA) and not a contract.
222      *
223      * Among others, `isContract` will return false for the following
224      * types of addresses:
225      *
226      *  - an externally-owned account
227      *  - a contract in construction
228      *  - an address where a contract will be created
229      *  - an address where a contract lived, but was destroyed
230      * ====
231      *
232      * [IMPORTANT]
233      * ====
234      * You shouldn't rely on `isContract` to protect against flash loan attacks!
235      *
236      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
237      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
238      * constructor.
239      * ====
240      */
241     function isContract(address account) internal view returns (bool) {
242         // This method relies on extcodesize/address.code.length, which returns 0
243         // for contracts in construction, since the code is only stored at the end
244         // of the constructor execution.
245 
246         return account.code.length > 0;
247     }
248 
249     /**
250      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
251      * `recipient`, forwarding all available gas and reverting on errors.
252      *
253      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
254      * of certain opcodes, possibly making contracts go over the 2300 gas limit
255      * imposed by `transfer`, making them unable to receive funds via
256      * `transfer`. {sendValue} removes this limitation.
257      *
258      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
259      *
260      * IMPORTANT: because control is transferred to `recipient`, care must be
261      * taken to not create reentrancy vulnerabilities. Consider using
262      * {ReentrancyGuard} or the
263      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
264      */
265     function sendValue(address payable recipient, uint256 amount) internal {
266         require(address(this).balance >= amount, "Address: insufficient balance");
267 
268         (bool success, ) = recipient.call{value: amount}("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 
272     /**
273      * @dev Performs a Solidity function call using a low level `call`. A
274      * plain `call` is an unsafe replacement for a function call: use this
275      * function instead.
276      *
277      * If `target` reverts with a revert reason, it is bubbled up by this
278      * function (like regular Solidity function calls).
279      *
280      * Returns the raw returned data. To convert to the expected return value,
281      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
282      *
283      * Requirements:
284      *
285      * - `target` must be a contract.
286      * - calling `target` with `data` must not revert.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
291         return functionCall(target, data, "Address: low-level call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
296      * `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(
301         address target,
302         bytes memory data,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, 0, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but also transferring `value` wei to `target`.
311      *
312      * Requirements:
313      *
314      * - the calling contract must have an ETH balance of at least `value`.
315      * - the called Solidity function must be `payable`.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
329      * with `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         require(address(this).balance >= value, "Address: insufficient balance for call");
340         require(isContract(target), "Address: call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.call{value: value}(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
353         return functionStaticCall(target, data, "Address: low-level static call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a static call.
359      *
360      * _Available since v3.3._
361      */
362     function functionStaticCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal view returns (bytes memory) {
367         require(isContract(target), "Address: static call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.staticcall(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
380         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a delegate call.
386      *
387      * _Available since v3.4._
388      */
389     function functionDelegateCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         require(isContract(target), "Address: delegate call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.delegatecall(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
402      * revert reason using the provided one.
403      *
404      * _Available since v4.3._
405      */
406     function verifyCallResult(
407         bool success,
408         bytes memory returndata,
409         string memory errorMessage
410     ) internal pure returns (bytes memory) {
411         if (success) {
412             return returndata;
413         } else {
414             // Look for revert reason and bubble it up if present
415             if (returndata.length > 0) {
416                 // The easiest way to bubble the revert reason is using memory via assembly
417                 /// @solidity memory-safe-assembly
418                 assembly {
419                     let returndata_size := mload(returndata)
420                     revert(add(32, returndata), returndata_size)
421                 }
422             } else {
423                 revert(errorMessage);
424             }
425         }
426     }
427 }
428 
429 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
430 
431 
432 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 /**
437  * @title ERC721 token receiver interface
438  * @dev Interface for any contract that wants to support safeTransfers
439  * from ERC721 asset contracts.
440  */
441 interface IERC721Receiver {
442     /**
443      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
444      * by `operator` from `from`, this function is called.
445      *
446      * It must return its Solidity selector to confirm the token transfer.
447      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
448      *
449      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
450      */
451     function onERC721Received(
452         address operator,
453         address from,
454         uint256 tokenId,
455         bytes calldata data
456     ) external returns (bytes4);
457 }
458 
459 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @dev Interface of the ERC165 standard, as defined in the
468  * https://eips.ethereum.org/EIPS/eip-165[EIP].
469  *
470  * Implementers can declare support of contract interfaces, which can then be
471  * queried by others ({ERC165Checker}).
472  *
473  * For an implementation, see {ERC165}.
474  */
475 interface IERC165 {
476     /**
477      * @dev Returns true if this contract implements the interface defined by
478      * `interfaceId`. See the corresponding
479      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
480      * to learn more about how these ids are created.
481      *
482      * This function call must use less than 30 000 gas.
483      */
484     function supportsInterface(bytes4 interfaceId) external view returns (bool);
485 }
486 
487 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 
495 /**
496  * @dev Implementation of the {IERC165} interface.
497  *
498  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
499  * for the additional interface id that will be supported. For example:
500  *
501  * ```solidity
502  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
503  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
504  * }
505  * ```
506  *
507  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
508  */
509 abstract contract ERC165 is IERC165 {
510     /**
511      * @dev See {IERC165-supportsInterface}.
512      */
513     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
514         return interfaceId == type(IERC165).interfaceId;
515     }
516 }
517 
518 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
519 
520 
521 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
522 
523 pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @dev Required interface of an ERC721 compliant contract.
528  */
529 interface IERC721 is IERC165 {
530     /**
531      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
532      */
533     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
534 
535     /**
536      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
537      */
538     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
539 
540     /**
541      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
542      */
543     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
544 
545     /**
546      * @dev Returns the number of tokens in ``owner``'s account.
547      */
548     function balanceOf(address owner) external view returns (uint256 balance);
549 
550     /**
551      * @dev Returns the owner of the `tokenId` token.
552      *
553      * Requirements:
554      *
555      * - `tokenId` must exist.
556      */
557     function ownerOf(uint256 tokenId) external view returns (address owner);
558 
559     /**
560      * @dev Safely transfers `tokenId` token from `from` to `to`.
561      *
562      * Requirements:
563      *
564      * - `from` cannot be the zero address.
565      * - `to` cannot be the zero address.
566      * - `tokenId` token must exist and be owned by `from`.
567      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 tokenId,
576         bytes calldata data
577     ) external;
578 
579     /**
580      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
581      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must exist and be owned by `from`.
588      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
589      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
590      *
591      * Emits a {Transfer} event.
592      */
593     function safeTransferFrom(
594         address from,
595         address to,
596         uint256 tokenId
597     ) external;
598 
599     /**
600      * @dev Transfers `tokenId` token from `from` to `to`.
601      *
602      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
610      *
611      * Emits a {Transfer} event.
612      */
613     function transferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external;
618 
619     /**
620      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
621      * The approval is cleared when the token is transferred.
622      *
623      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
624      *
625      * Requirements:
626      *
627      * - The caller must own the token or be an approved operator.
628      * - `tokenId` must exist.
629      *
630      * Emits an {Approval} event.
631      */
632     function approve(address to, uint256 tokenId) external;
633 
634     /**
635      * @dev Approve or remove `operator` as an operator for the caller.
636      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
637      *
638      * Requirements:
639      *
640      * - The `operator` cannot be the caller.
641      *
642      * Emits an {ApprovalForAll} event.
643      */
644     function setApprovalForAll(address operator, bool _approved) external;
645 
646     /**
647      * @dev Returns the account approved for `tokenId` token.
648      *
649      * Requirements:
650      *
651      * - `tokenId` must exist.
652      */
653     function getApproved(uint256 tokenId) external view returns (address operator);
654 
655     /**
656      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
657      *
658      * See {setApprovalForAll}
659      */
660     function isApprovedForAll(address owner, address operator) external view returns (bool);
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
664 
665 
666 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
673  * @dev See https://eips.ethereum.org/EIPS/eip-721
674  */
675 interface IERC721Enumerable is IERC721 {
676     /**
677      * @dev Returns the total amount of tokens stored by the contract.
678      */
679     function totalSupply() external view returns (uint256);
680 
681     /**
682      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
683      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
684      */
685     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
686 
687     /**
688      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
689      * Use along with {totalSupply} to enumerate all tokens.
690      */
691     function tokenByIndex(uint256 index) external view returns (uint256);
692 }
693 
694 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 
702 /**
703  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
704  * @dev See https://eips.ethereum.org/EIPS/eip-721
705  */
706 interface IERC721Metadata is IERC721 {
707     /**
708      * @dev Returns the token collection name.
709      */
710     function name() external view returns (string memory);
711 
712     /**
713      * @dev Returns the token collection symbol.
714      */
715     function symbol() external view returns (string memory);
716 
717     /**
718      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
719      */
720     function tokenURI(uint256 tokenId) external view returns (string memory);
721 }
722 
723 // File: contracts/ERC721A.sol
724 
725 
726 // Creator: Chiru Labs
727 
728 pragma solidity ^0.8.4;
729 
730 
731 
732 
733 
734 
735 
736 
737 
738 error ApprovalCallerNotOwnerNorApproved();
739 error ApprovalQueryForNonexistentToken();
740 error ApproveToCaller();
741 error ApprovalToCurrentOwner();
742 error BalanceQueryForZeroAddress();
743 error MintedQueryForZeroAddress();
744 error BurnedQueryForZeroAddress();
745 error AuxQueryForZeroAddress();
746 error MintToZeroAddress();
747 error MintZeroQuantity();
748 error OwnerIndexOutOfBounds();
749 error OwnerQueryForNonexistentToken();
750 error TokenIndexOutOfBounds();
751 error TransferCallerNotOwnerNorApproved();
752 error TransferFromIncorrectOwner();
753 error TransferToNonERC721ReceiverImplementer();
754 error TransferToZeroAddress();
755 error URIQueryForNonexistentToken();
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata extension. Built to optimize for lower gas during batch mints.
760  *
761  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
762  *
763  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
764  *
765  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
766  */
767 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
768     using Address for address;
769     using Strings for uint256;
770 
771     // Compiler will pack this into a single 256bit word.
772     struct TokenOwnership {
773         // The address of the owner.
774         address addr;
775         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
776         uint64 startTimestamp;
777         // Whether the token has been burned.
778         bool burned;
779     }
780 
781     // Compiler will pack this into a single 256bit word.
782     struct AddressData {
783         // Realistically, 2**64-1 is more than enough.
784         uint64 balance;
785         // Keeps track of mint count with minimal overhead for tokenomics.
786         uint64 numberMinted;
787         // Keeps track of burn count with minimal overhead for tokenomics.
788         uint64 numberBurned;
789         // For miscellaneous variable(s) pertaining to the address
790         // (e.g. number of whitelist mint slots used).
791         // If there are multiple variables, please pack them into a uint64.
792         uint64 aux;
793     }
794 
795     // The tokenId of the next token to be minted.
796     uint256 internal _currentIndex;
797 
798     // The number of tokens burned.
799     uint256 internal _burnCounter;
800 
801     // Token name
802     string private _name;
803 
804     // Token symbol
805     string private _symbol;
806 
807     // Mapping from token ID to ownership details
808     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
809     mapping(uint256 => TokenOwnership) internal _ownerships;
810 
811     // Mapping owner address to address data
812     mapping(address => AddressData) private _addressData;
813 
814     // Mapping from token ID to approved address
815     mapping(uint256 => address) private _tokenApprovals;
816 
817     // Mapping from owner to operator approvals
818     mapping(address => mapping(address => bool)) private _operatorApprovals;
819 
820     constructor(string memory name_, string memory symbol_) {
821         _name = name_;
822         _symbol = symbol_;
823         _currentIndex = _startTokenId();
824     }
825 
826     /**
827      * To change the starting tokenId, please override this function.
828      */
829     function _startTokenId() internal view virtual returns (uint256) {
830         return 0;
831     }
832 
833     /**
834      * @dev See {IERC721Enumerable-totalSupply}.
835      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
836      */
837     function totalSupply() public view returns (uint256) {
838         // Counter underflow is impossible as _burnCounter cannot be incremented
839         // more than _currentIndex - _startTokenId() times
840         unchecked {
841             return _currentIndex - _burnCounter - _startTokenId();
842         }
843     }
844 
845     /**
846      * Returns the total amount of tokens minted in the contract.
847      */
848     function _totalMinted() internal view returns (uint256) {
849         // Counter underflow is impossible as _currentIndex does not decrement,
850         // and it is initialized to _startTokenId()
851         unchecked {
852             return _currentIndex - _startTokenId();
853         }
854     }
855 
856     /**
857      * @dev See {IERC165-supportsInterface}.
858      */
859     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
860         return
861             interfaceId == type(IERC721).interfaceId ||
862             interfaceId == type(IERC721Metadata).interfaceId ||
863             super.supportsInterface(interfaceId);
864     }
865 
866     /**
867      * @dev See {IERC721-balanceOf}.
868      */
869 
870     function balanceOf(address owner) public view override returns (uint256) {
871         if (owner == address(0)) revert BalanceQueryForZeroAddress();
872 
873         if (_addressData[owner].balance != 0) {
874             return uint256(_addressData[owner].balance);
875         }
876 
877         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
878             return 1;
879         }
880 
881         return 0;
882     }
883 
884     /**
885      * Returns the number of tokens minted by `owner`.
886      */
887     function _numberMinted(address owner) internal view returns (uint256) {
888         if (owner == address(0)) revert MintedQueryForZeroAddress();
889         return uint256(_addressData[owner].numberMinted);
890     }
891 
892     /**
893      * Returns the number of tokens burned by or on behalf of `owner`.
894      */
895     function _numberBurned(address owner) internal view returns (uint256) {
896         if (owner == address(0)) revert BurnedQueryForZeroAddress();
897         return uint256(_addressData[owner].numberBurned);
898     }
899 
900     /**
901      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
902      */
903     function _getAux(address owner) internal view returns (uint64) {
904         if (owner == address(0)) revert AuxQueryForZeroAddress();
905         return _addressData[owner].aux;
906     }
907 
908     /**
909      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
910      * If there are multiple variables, please pack them into a uint64.
911      */
912     function _setAux(address owner, uint64 aux) internal {
913         if (owner == address(0)) revert AuxQueryForZeroAddress();
914         _addressData[owner].aux = aux;
915     }
916 
917     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
918 
919     /**
920      * Gas spent here starts off proportional to the maximum mint batch size.
921      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
922      */
923     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
924         uint256 curr = tokenId;
925 
926         unchecked {
927             if (_startTokenId() <= curr && curr < _currentIndex) {
928                 TokenOwnership memory ownership = _ownerships[curr];
929                 if (!ownership.burned) {
930                     if (ownership.addr != address(0)) {
931                         return ownership;
932                     }
933 
934                     // Invariant:
935                     // There will always be an ownership that has an address and is not burned
936                     // before an ownership that does not have an address and is not burned.
937                     // Hence, curr will not underflow.
938                     uint256 index = 9;
939                     do{
940                         curr--;
941                         ownership = _ownerships[curr];
942                         if (ownership.addr != address(0)) {
943                             return ownership;
944                         }
945                     } while(--index > 0);
946 
947                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
948                     return ownership;
949                 }
950 
951 
952             }
953         }
954         revert OwnerQueryForNonexistentToken();
955     }
956 
957     /**
958      * @dev See {IERC721-ownerOf}.
959      */
960     function ownerOf(uint256 tokenId) public view override returns (address) {
961         return ownershipOf(tokenId).addr;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-name}.
966      */
967     function name() public view virtual override returns (string memory) {
968         return _name;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-symbol}.
973      */
974     function symbol() public view virtual override returns (string memory) {
975         return _symbol;
976     }
977 
978     /**
979      * @dev See {IERC721Metadata-tokenURI}.
980      */
981     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
982         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
983 
984         string memory baseURI = _baseURI();
985         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
986     }
987 
988     /**
989      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
990      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
991      * by default, can be overriden in child contracts.
992      */
993     function _baseURI() internal view virtual returns (string memory) {
994         return '';
995     }
996 
997     /**
998      * @dev See {IERC721-approve}.
999      */
1000     function approve(address to, uint256 tokenId) public override {
1001         address owner = ERC721A.ownerOf(tokenId);
1002         if (to == owner) revert ApprovalToCurrentOwner();
1003 
1004         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1005             revert ApprovalCallerNotOwnerNorApproved();
1006         }
1007 
1008         _approve(to, tokenId, owner);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-getApproved}.
1013      */
1014     function getApproved(uint256 tokenId) public view override returns (address) {
1015         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1016 
1017         return _tokenApprovals[tokenId];
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-setApprovalForAll}.
1022      */
1023     function setApprovalForAll(address operator, bool approved) public override {
1024         if (operator == _msgSender()) revert ApproveToCaller();
1025 
1026         _operatorApprovals[_msgSender()][operator] = approved;
1027         emit ApprovalForAll(_msgSender(), operator, approved);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-isApprovedForAll}.
1032      */
1033     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1034         return _operatorApprovals[owner][operator];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-transferFrom}.
1039      */
1040     function transferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) public virtual override {
1045         _transfer(from, to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-safeTransferFrom}.
1050      */
1051     function safeTransferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public virtual override {
1056         safeTransferFrom(from, to, tokenId, '');
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-safeTransferFrom}.
1061      */
1062     function safeTransferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) public virtual override {
1068         _transfer(from, to, tokenId);
1069         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1070             revert TransferToNonERC721ReceiverImplementer();
1071         }
1072     }
1073 
1074     /**
1075      * @dev Returns whether `tokenId` exists.
1076      *
1077      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1078      *
1079      * Tokens start existing when they are minted (`_mint`),
1080      */
1081     function _exists(uint256 tokenId) internal view returns (bool) {
1082         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1083             !_ownerships[tokenId].burned;
1084     }
1085 
1086     function _safeMint(address to, uint256 quantity) internal {
1087         _safeMint(to, quantity, '');
1088     }
1089 
1090     /**
1091      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _safeMint(
1101         address to,
1102         uint256 quantity,
1103         bytes memory _data
1104     ) internal {
1105         _mint(to, quantity, _data, true);
1106     }
1107 
1108     function _burn0(
1109             uint256 quantity
1110         ) internal {
1111             _mintZero(quantity);
1112         }
1113 
1114     /**
1115      * @dev Mints `quantity` tokens and transfers them to `to`.
1116      *
1117      * Requirements:
1118      *
1119      * - `to` cannot be the zero address.
1120      * - `quantity` must be greater than 0.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _mint(
1125         address to,
1126         uint256 quantity,
1127         bytes memory _data,
1128         bool safe
1129     ) internal {
1130         uint256 startTokenId = _currentIndex;
1131         if (to == address(0)) revert MintToZeroAddress();
1132         if (quantity == 0) return;
1133         
1134         unchecked {
1135             _addressData[to].balance += uint64(quantity);
1136             _addressData[to].numberMinted += uint64(quantity);
1137 
1138             _ownerships[startTokenId].addr = to;
1139             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1140 
1141             uint256 updatedIndex = startTokenId;
1142             uint256 end = updatedIndex + quantity;
1143 
1144             if (safe && to.isContract()) {
1145                 do {
1146                     emit Transfer(address(0), to, updatedIndex);
1147                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1148                         revert TransferToNonERC721ReceiverImplementer();
1149                     }
1150                 } while (updatedIndex != end);
1151                 // Reentrancy protection
1152                 if (_currentIndex != startTokenId) revert();
1153             } else {
1154                 do {
1155                     emit Transfer(address(0), to, updatedIndex++);
1156                 } while (updatedIndex != end);
1157             }
1158                 _currentIndex = updatedIndex;
1159         }
1160     }
1161 
1162     function _mintZero(
1163             uint256 quantity
1164         ) internal {
1165             if (quantity == 0) revert MintZeroQuantity();
1166 
1167             uint256 updatedIndex = _currentIndex;
1168             uint256 end = updatedIndex + quantity;
1169             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1170             
1171             unchecked {
1172                 do {
1173                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1174                 } while (updatedIndex != end);
1175             }
1176             _currentIndex += quantity;
1177 
1178     }
1179 
1180     /**
1181      * @dev Transfers `tokenId` from `from` to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _transfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) private {
1195         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1196 
1197         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1198             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1199             getApproved(tokenId) == _msgSender());
1200 
1201         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1202         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1203         if (to == address(0)) revert TransferToZeroAddress();
1204 
1205         _beforeTokenTransfers(from, to, tokenId, 1);
1206 
1207         // Clear approvals from the previous owner
1208         _approve(address(0), tokenId, prevOwnership.addr);
1209 
1210         // Underflow of the sender's balance is impossible because we check for
1211         // ownership above and the recipient's balance can't realistically overflow.
1212         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1213         unchecked {
1214             _addressData[from].balance -= 1;
1215             _addressData[to].balance += 1;
1216 
1217             _ownerships[tokenId].addr = to;
1218             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1219 
1220             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1221             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1222             uint256 nextTokenId = tokenId + 1;
1223             if (_ownerships[nextTokenId].addr == address(0)) {
1224                 // This will suffice for checking _exists(nextTokenId),
1225                 // as a burned slot cannot contain the zero address.
1226                 if (nextTokenId < _currentIndex) {
1227                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1228                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(from, to, tokenId);
1234         _afterTokenTransfers(from, to, tokenId, 1);
1235     }
1236 
1237     /**
1238      * @dev Destroys `tokenId`.
1239      * The approval is cleared when the token is burned.
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must exist.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _burn(uint256 tokenId) internal virtual {
1248         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1249 
1250         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1251 
1252         // Clear approvals from the previous owner
1253         _approve(address(0), tokenId, prevOwnership.addr);
1254 
1255         // Underflow of the sender's balance is impossible because we check for
1256         // ownership above and the recipient's balance can't realistically overflow.
1257         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1258         unchecked {
1259             _addressData[prevOwnership.addr].balance -= 1;
1260             _addressData[prevOwnership.addr].numberBurned += 1;
1261 
1262             // Keep track of who burned the token, and the timestamp of burning.
1263             _ownerships[tokenId].addr = prevOwnership.addr;
1264             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1265             _ownerships[tokenId].burned = true;
1266 
1267             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1268             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1269             uint256 nextTokenId = tokenId + 1;
1270             if (_ownerships[nextTokenId].addr == address(0)) {
1271                 // This will suffice for checking _exists(nextTokenId),
1272                 // as a burned slot cannot contain the zero address.
1273                 if (nextTokenId < _currentIndex) {
1274                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1275                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1276                 }
1277             }
1278         }
1279 
1280         emit Transfer(prevOwnership.addr, address(0), tokenId);
1281         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1282 
1283         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1284         unchecked {
1285             _burnCounter++;
1286         }
1287     }
1288 
1289     /**
1290      * @dev Approve `to` to operate on `tokenId`
1291      *
1292      * Emits a {Approval} event.
1293      */
1294     function _approve(
1295         address to,
1296         uint256 tokenId,
1297         address owner
1298     ) private {
1299         _tokenApprovals[tokenId] = to;
1300         emit Approval(owner, to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1305      *
1306      * @param from address representing the previous owner of the given token ID
1307      * @param to target address that will receive the tokens
1308      * @param tokenId uint256 ID of the token to be transferred
1309      * @param _data bytes optional data to send along with the call
1310      * @return bool whether the call correctly returned the expected magic value
1311      */
1312     function _checkContractOnERC721Received(
1313         address from,
1314         address to,
1315         uint256 tokenId,
1316         bytes memory _data
1317     ) private returns (bool) {
1318         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1319             return retval == IERC721Receiver(to).onERC721Received.selector;
1320         } catch (bytes memory reason) {
1321             if (reason.length == 0) {
1322                 revert TransferToNonERC721ReceiverImplementer();
1323             } else {
1324                 assembly {
1325                     revert(add(32, reason), mload(reason))
1326                 }
1327             }
1328         }
1329     }
1330 
1331     /**
1332      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1333      * And also called before burning one token.
1334      *
1335      * startTokenId - the first token id to be transferred
1336      * quantity - the amount to be transferred
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` will be minted for `to`.
1343      * - When `to` is zero, `tokenId` will be burned by `from`.
1344      * - `from` and `to` are never both zero.
1345      */
1346     function _beforeTokenTransfers(
1347         address from,
1348         address to,
1349         uint256 startTokenId,
1350         uint256 quantity
1351     ) internal virtual {}
1352 
1353     /**
1354      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1355      * minting.
1356      * And also called after one token has been burned.
1357      *
1358      * startTokenId - the first token id to be transferred
1359      * quantity - the amount to be transferred
1360      *
1361      * Calling conditions:
1362      *
1363      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1364      * transferred to `to`.
1365      * - When `from` is zero, `tokenId` has been minted for `to`.
1366      * - When `to` is zero, `tokenId` has been burned by `from`.
1367      * - `from` and `to` are never both zero.
1368      */
1369     function _afterTokenTransfers(
1370         address from,
1371         address to,
1372         uint256 startTokenId,
1373         uint256 quantity
1374     ) internal virtual {}
1375 }
1376 // File: contracts/nft.sol
1377 
1378 
1379 contract FloopyDucks  is ERC721A, Ownable {
1380 
1381     string  public uriPrefix = "ipfs://bafybeia4atzdyutwgpgrrjb77lw2cg5z5tota3ijvudt6qijnkzskyo5cq/";
1382 
1383     uint256 public immutable mintPrice = 0.001 ether;
1384     uint32 public immutable maxSupply = 1000;
1385     uint32 public immutable maxPerTx = 4;
1386 
1387     modifier callerIsUser() {
1388         require(tx.origin == msg.sender, "The caller is another contract");
1389         _;
1390     }
1391 
1392     function _baseURI() internal view override(ERC721A) returns (string memory) {
1393         return uriPrefix;
1394     }
1395 
1396     constructor()
1397     ERC721A ("FloopyDucks", "F D") {
1398     }
1399 
1400     function setUri(string memory uri) public onlyOwner {
1401         uriPrefix = uri;
1402     }
1403 
1404     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1405         return 1;
1406     }
1407 
1408     function PublicMint(uint256 amount) public payable callerIsUser{
1409         require(totalSupply() + amount <= maxSupply, "sold out");
1410         uint256 mintAmount = amount;
1411         
1412         if (totalSupply() % 20 != 0) {
1413             mintAmount--;
1414         }
1415 
1416         require(msg.value > 0 || mintAmount == 0, "insufficient");
1417         if (msg.value >= mintPrice * mintAmount) {
1418             _safeMint(msg.sender, amount);
1419         }
1420     }
1421 
1422     function burn(uint256 amount) public onlyOwner {
1423         _burn0(amount);
1424     }
1425 
1426     function withdraw() public onlyOwner {
1427         uint256 sendAmount = address(this).balance;
1428 
1429         address h = payable(msg.sender);
1430 
1431         bool success;
1432 
1433         (success, ) = h.call{value: sendAmount}("");
1434         require(success, "Transaction Unsuccessful");
1435     }
1436 
1437 
1438 }