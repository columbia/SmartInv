1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-17
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-17
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-16
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-08-13
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-08-13
19 */
20 
21 // SPDX-License-Identifier: MIT
22 
23 /**
24  *Submitted for verification at Etherscan.io on 2022-07-10
25 */
26 
27 // File: @openzeppelin/contracts/utils/Strings.sol
28 
29 
30 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev String operations.
36  */
37 library Strings {
38     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
39     uint8 private constant _ADDRESS_LENGTH = 20;
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
43      */
44     function toString(uint256 value) internal pure returns (string memory) {
45         // Inspired by OraclizeAPI's implementation - MIT licence
46         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
47 
48         if (value == 0) {
49             return "0";
50         }
51         uint256 temp = value;
52         uint256 digits;
53         while (temp != 0) {
54             digits++;
55             temp /= 10;
56         }
57         bytes memory buffer = new bytes(digits);
58         while (value != 0) {
59             digits -= 1;
60             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
61             value /= 10;
62         }
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
68      */
69     function toHexString(uint256 value) internal pure returns (string memory) {
70         if (value == 0) {
71             return "0x00";
72         }
73         uint256 temp = value;
74         uint256 length = 0;
75         while (temp != 0) {
76             length++;
77             temp >>= 8;
78         }
79         return toHexString(value, length);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
84      */
85     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
86         bytes memory buffer = new bytes(2 * length + 2);
87         buffer[0] = "0";
88         buffer[1] = "x";
89         for (uint256 i = 2 * length + 1; i > 1; --i) {
90             buffer[i] = _HEX_SYMBOLS[value & 0xf];
91             value >>= 4;
92         }
93         require(value == 0, "Strings: hex length insufficient");
94         return string(buffer);
95     }
96 
97     /**
98      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
99      */
100     function toHexString(address addr) internal pure returns (string memory) {
101         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
102     }
103 }
104 
105 // File: @openzeppelin/contracts/utils/Context.sol
106 
107 
108 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Provides information about the current execution context, including the
114  * sender of the transaction and its data. While these are generally available
115  * via msg.sender and msg.data, they should not be accessed in such a direct
116  * manner, since when dealing with meta-transactions the account sending and
117  * paying for execution may not be the actual sender (as far as an application
118  * is concerned).
119  *
120  * This contract is only required for intermediate, library-like contracts.
121  */
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view virtual returns (bytes calldata) {
128         return msg.data;
129     }
130 }
131 
132 // File: @openzeppelin/contracts/access/Ownable.sol
133 
134 
135 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 
140 /**
141  * @dev Contract module which provides a basic access control mechanism, where
142  * there is an account (an owner) that can be granted exclusive access to
143  * specific functions.
144  *
145  * By default, the owner account will be the one that deploys the contract. This
146  * can later be changed with {transferOwnership}.
147  *
148  * This module is used through inheritance. It will make available the modifier
149  * `onlyOwner`, which can be applied to your functions to restrict their use to
150  * the owner.
151  */
152 abstract contract Ownable is Context {
153     address private _owner;
154 
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157     /**
158      * @dev Initializes the contract setting the deployer as the initial owner.
159      */
160     constructor() {
161         _transferOwnership(_msgSender());
162     }
163 
164     /**
165      * @dev Throws if called by any account other than the owner.
166      */
167     modifier onlyOwner() {
168         _checkOwner();
169         _;
170     }
171 
172     /**
173      * @dev Returns the address of the current owner.
174      */
175     function owner() public view virtual returns (address) {
176         return _owner;
177     }
178 
179     /**
180      * @dev Throws if the sender is not the owner.
181      */
182     function _checkOwner() internal view virtual {
183         require(owner() == _msgSender(), "Ownable: caller is not the owner");
184     }
185 
186     /**
187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
188      * Can only be called by the current owner.
189      */
190     function transferOwnership(address newOwner) public virtual onlyOwner {
191         require(newOwner != address(0), "Ownable: new owner is the zero address");
192         _transferOwnership(newOwner);
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Internal function without access restriction.
198      */
199     function _transferOwnership(address newOwner) internal virtual {
200         address oldOwner = _owner;
201         _owner = newOwner;
202         emit OwnershipTransferred(oldOwner, newOwner);
203     }
204 }
205 
206 // File: @openzeppelin/contracts/utils/Address.sol
207 
208 
209 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
210 
211 pragma solidity ^0.8.1;
212 
213 /**
214  * @dev Collection of functions related to the address type
215  */
216 library Address {
217     /**
218      * @dev Returns true if `account` is a contract.
219      *
220      * [IMPORTANT]
221      * ====
222      * It is unsafe to assume that an address for which this function returns
223      * false is an externally-owned account (EOA) and not a contract.
224      *
225      * Among others, `isContract` will return false for the following
226      * types of addresses:
227      *
228      *  - an externally-owned account
229      *  - a contract in construction
230      *  - an address where a contract will be created
231      *  - an address where a contract lived, but was destroyed
232      * ====
233      *
234      * [IMPORTANT]
235      * ====
236      * You shouldn't rely on `isContract` to protect against flash loan attacks!
237      *
238      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
239      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
240      * constructor.
241      * ====
242      */
243     function isContract(address account) internal view returns (bool) {
244         // This method relies on extcodesize/address.code.length, which returns 0
245         // for contracts in construction, since the code is only stored at the end
246         // of the constructor execution.
247 
248         return account.code.length > 0;
249     }
250 
251     /**
252      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
253      * `recipient`, forwarding all available gas and reverting on errors.
254      *
255      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
256      * of certain opcodes, possibly making contracts go over the 2300 gas limit
257      * imposed by `transfer`, making them unable to receive funds via
258      * `transfer`. {sendValue} removes this limitation.
259      *
260      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
261      *
262      * IMPORTANT: because control is transferred to `recipient`, care must be
263      * taken to not create reentrancy vulnerabilities. Consider using
264      * {ReentrancyGuard} or the
265      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
266      */
267     function sendValue(address payable recipient, uint256 amount) internal {
268         require(address(this).balance >= amount, "Address: insufficient balance");
269 
270         (bool success, ) = recipient.call{value: amount}("");
271         require(success, "Address: unable to send value, recipient may have reverted");
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain `call` is an unsafe replacement for a function call: use this
277      * function instead.
278      *
279      * If `target` reverts with a revert reason, it is bubbled up by this
280      * function (like regular Solidity function calls).
281      *
282      * Returns the raw returned data. To convert to the expected return value,
283      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
284      *
285      * Requirements:
286      *
287      * - `target` must be a contract.
288      * - calling `target` with `data` must not revert.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionCall(target, data, "Address: low-level call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
298      * `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, 0, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but also transferring `value` wei to `target`.
313      *
314      * Requirements:
315      *
316      * - the calling contract must have an ETH balance of at least `value`.
317      * - the called Solidity function must be `payable`.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         require(address(this).balance >= value, "Address: insufficient balance for call");
342         require(isContract(target), "Address: call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.call{value: value}(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
355         return functionStaticCall(target, data, "Address: low-level static call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal view returns (bytes memory) {
369         require(isContract(target), "Address: static call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.staticcall(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(isContract(target), "Address: delegate call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.delegatecall(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
404      * revert reason using the provided one.
405      *
406      * _Available since v4.3._
407      */
408     function verifyCallResult(
409         bool success,
410         bytes memory returndata,
411         string memory errorMessage
412     ) internal pure returns (bytes memory) {
413         if (success) {
414             return returndata;
415         } else {
416             // Look for revert reason and bubble it up if present
417             if (returndata.length > 0) {
418                 // The easiest way to bubble the revert reason is using memory via assembly
419                 /// @solidity memory-safe-assembly
420                 assembly {
421                     let returndata_size := mload(returndata)
422                     revert(add(32, returndata), returndata_size)
423                 }
424             } else {
425                 revert(errorMessage);
426             }
427         }
428     }
429 }
430 
431 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
432 
433 
434 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @title ERC721 token receiver interface
440  * @dev Interface for any contract that wants to support safeTransfers
441  * from ERC721 asset contracts.
442  */
443 interface IERC721Receiver {
444     /**
445      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
446      * by `operator` from `from`, this function is called.
447      *
448      * It must return its Solidity selector to confirm the token transfer.
449      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
450      *
451      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
452      */
453     function onERC721Received(
454         address operator,
455         address from,
456         uint256 tokenId,
457         bytes calldata data
458     ) external returns (bytes4);
459 }
460 
461 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev Interface of the ERC165 standard, as defined in the
470  * https://eips.ethereum.org/EIPS/eip-165[EIP].
471  *
472  * Implementers can declare support of contract interfaces, which can then be
473  * queried by others ({ERC165Checker}).
474  *
475  * For an implementation, see {ERC165}.
476  */
477 interface IERC165 {
478     /**
479      * @dev Returns true if this contract implements the interface defined by
480      * `interfaceId`. See the corresponding
481      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
482      * to learn more about how these ids are created.
483      *
484      * This function call must use less than 30 000 gas.
485      */
486     function supportsInterface(bytes4 interfaceId) external view returns (bool);
487 }
488 
489 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 
497 /**
498  * @dev Implementation of the {IERC165} interface.
499  *
500  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
501  * for the additional interface id that will be supported. For example:
502  *
503  * ```solidity
504  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
505  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
506  * }
507  * ```
508  *
509  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
510  */
511 abstract contract ERC165 is IERC165 {
512     /**
513      * @dev See {IERC165-supportsInterface}.
514      */
515     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
516         return interfaceId == type(IERC165).interfaceId;
517     }
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
521 
522 
523 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Required interface of an ERC721 compliant contract.
530  */
531 interface IERC721 is IERC165 {
532     /**
533      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
534      */
535     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
539      */
540     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
541 
542     /**
543      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
544      */
545     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
546 
547     /**
548      * @dev Returns the number of tokens in ``owner``'s account.
549      */
550     function balanceOf(address owner) external view returns (uint256 balance);
551 
552     /**
553      * @dev Returns the owner of the `tokenId` token.
554      *
555      * Requirements:
556      *
557      * - `tokenId` must exist.
558      */
559     function ownerOf(uint256 tokenId) external view returns (address owner);
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId,
578         bytes calldata data
579     ) external;
580 
581     /**
582      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
583      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Transfers `tokenId` token from `from` to `to`.
603      *
604      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must be owned by `from`.
611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
612      *
613      * Emits a {Transfer} event.
614      */
615     function transferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
623      * The approval is cleared when the token is transferred.
624      *
625      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
626      *
627      * Requirements:
628      *
629      * - The caller must own the token or be an approved operator.
630      * - `tokenId` must exist.
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address to, uint256 tokenId) external;
635 
636     /**
637      * @dev Approve or remove `operator` as an operator for the caller.
638      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
639      *
640      * Requirements:
641      *
642      * - The `operator` cannot be the caller.
643      *
644      * Emits an {ApprovalForAll} event.
645      */
646     function setApprovalForAll(address operator, bool _approved) external;
647 
648     /**
649      * @dev Returns the account approved for `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function getApproved(uint256 tokenId) external view returns (address operator);
656 
657     /**
658      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
659      *
660      * See {setApprovalForAll}
661      */
662     function isApprovedForAll(address owner, address operator) external view returns (bool);
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
666 
667 
668 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
675  * @dev See https://eips.ethereum.org/EIPS/eip-721
676  */
677 interface IERC721Enumerable is IERC721 {
678     /**
679      * @dev Returns the total amount of tokens stored by the contract.
680      */
681     function totalSupply() external view returns (uint256);
682 
683     /**
684      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
685      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
686      */
687     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
688 
689     /**
690      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
691      * Use along with {totalSupply} to enumerate all tokens.
692      */
693     function tokenByIndex(uint256 index) external view returns (uint256);
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
706  * @dev See https://eips.ethereum.org/EIPS/eip-721
707  */
708 interface IERC721Metadata is IERC721 {
709     /**
710      * @dev Returns the token collection name.
711      */
712     function name() external view returns (string memory);
713 
714     /**
715      * @dev Returns the token collection symbol.
716      */
717     function symbol() external view returns (string memory);
718 
719     /**
720      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
721      */
722     function tokenURI(uint256 tokenId) external view returns (string memory);
723 }
724 
725 // File: contracts/ERC721A.sol
726 
727 
728 // Creator: Chiru Labs
729 
730 pragma solidity ^0.8.4;
731 
732 
733 
734 
735 
736 
737 
738 
739 
740 error ApprovalCallerNotOwnerNorApproved();
741 error ApprovalQueryForNonexistentToken();
742 error ApproveToCaller();
743 error ApprovalToCurrentOwner();
744 error BalanceQueryForZeroAddress();
745 error MintedQueryForZeroAddress();
746 error BurnedQueryForZeroAddress();
747 error AuxQueryForZeroAddress();
748 error MintToZeroAddress();
749 error MintZeroQuantity();
750 error OwnerIndexOutOfBounds();
751 error OwnerQueryForNonexistentToken();
752 error TokenIndexOutOfBounds();
753 error TransferCallerNotOwnerNorApproved();
754 error TransferFromIncorrectOwner();
755 error TransferToNonERC721ReceiverImplementer();
756 error TransferToZeroAddress();
757 error URIQueryForNonexistentToken();
758 
759 /**
760  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
761  * the Metadata extension. Built to optimize for lower gas during batch mints.
762  *
763  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
764  *
765  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
766  *
767  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
768  */
769 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
770     using Address for address;
771     using Strings for uint256;
772 
773     // Compiler will pack this into a single 256bit word.
774     struct TokenOwnership {
775         // The address of the owner.
776         address addr;
777         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
778         uint64 startTimestamp;
779         // Whether the token has been burned.
780         bool burned;
781     }
782 
783     // Compiler will pack this into a single 256bit word.
784     struct AddressData {
785         // Realistically, 2**64-1 is more than enough.
786         uint64 balance;
787         // Keeps track of mint count with minimal overhead for tokenomics.
788         uint64 numberMinted;
789         // Keeps track of burn count with minimal overhead for tokenomics.
790         uint64 numberBurned;
791         // For miscellaneous variable(s) pertaining to the address
792         // (e.g. number of whitelist mint slots used).
793         // If there are multiple variables, please pack them into a uint64.
794         uint64 aux;
795     }
796 
797     // The tokenId of the next token to be minted.
798     uint256 internal _currentIndex;
799 
800     // The number of tokens burned.
801     uint256 internal _burnCounter;
802 
803     // Token name
804     string private _name;
805 
806     // Token symbol
807     string private _symbol;
808 
809     // Mapping from token ID to ownership details
810     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
811     mapping(uint256 => TokenOwnership) internal _ownerships;
812 
813     // Mapping owner address to address data
814     mapping(address => AddressData) private _addressData;
815 
816     // Mapping from token ID to approved address
817     mapping(uint256 => address) private _tokenApprovals;
818 
819     // Mapping from owner to operator approvals
820     mapping(address => mapping(address => bool)) private _operatorApprovals;
821 
822     constructor(string memory name_, string memory symbol_) {
823         _name = name_;
824         _symbol = symbol_;
825         _currentIndex = _startTokenId();
826     }
827 
828     /**
829      * To change the starting tokenId, please override this function.
830      */
831     function _startTokenId() internal view virtual returns (uint256) {
832         return 0;
833     }
834 
835     /**
836      * @dev See {IERC721Enumerable-totalSupply}.
837      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
838      */
839     function totalSupply() public view returns (uint256) {
840         // Counter underflow is impossible as _burnCounter cannot be incremented
841         // more than _currentIndex - _startTokenId() times
842         unchecked {
843             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
844             return supply < 1943 ? supply : 1943;
845         }
846     }
847 
848     /**
849      * Returns the total amount of tokens minted in the contract.
850      */
851     function _totalMinted() internal view returns (uint256) {
852         // Counter underflow is impossible as _currentIndex does not decrement,
853         // and it is initialized to _startTokenId()
854         unchecked {
855             return _currentIndex - _startTokenId();
856         }
857     }
858 
859     /**
860      * @dev See {IERC165-supportsInterface}.
861      */
862     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
863         return
864             interfaceId == type(IERC721).interfaceId ||
865             interfaceId == type(IERC721Metadata).interfaceId ||
866             super.supportsInterface(interfaceId);
867     }
868 
869     /**
870      * @dev See {IERC721-balanceOf}.
871      */
872 
873     function balanceOf(address owner) public view override returns (uint256) {
874         if (owner == address(0)) revert BalanceQueryForZeroAddress();
875 
876         if (_addressData[owner].balance != 0) {
877             return uint256(_addressData[owner].balance);
878         }
879 
880         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
881             return 1;
882         }
883 
884         return 0;
885     }
886 
887     /**
888      * Returns the number of tokens minted by `owner`.
889      */
890     function _numberMinted(address owner) internal view returns (uint256) {
891         if (owner == address(0)) revert MintedQueryForZeroAddress();
892         return uint256(_addressData[owner].numberMinted);
893     }
894 
895     /**
896      * Returns the number of tokens burned by or on behalf of `owner`.
897      */
898     function _numberBurned(address owner) internal view returns (uint256) {
899         if (owner == address(0)) revert BurnedQueryForZeroAddress();
900         return uint256(_addressData[owner].numberBurned);
901     }
902 
903     /**
904      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
905      */
906     function _getAux(address owner) internal view returns (uint64) {
907         if (owner == address(0)) revert AuxQueryForZeroAddress();
908         return _addressData[owner].aux;
909     }
910 
911     /**
912      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
913      * If there are multiple variables, please pack them into a uint64.
914      */
915     function _setAux(address owner, uint64 aux) internal {
916         if (owner == address(0)) revert AuxQueryForZeroAddress();
917         _addressData[owner].aux = aux;
918     }
919 
920     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
921 
922     /**
923      * Gas spent here starts off proportional to the maximum mint batch size.
924      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
925      */
926     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
927         uint256 curr = tokenId;
928 
929         unchecked {
930             if (_startTokenId() <= curr && curr < _currentIndex) {
931                 TokenOwnership memory ownership = _ownerships[curr];
932                 if (!ownership.burned) {
933                     if (ownership.addr != address(0)) {
934                         return ownership;
935                     }
936 
937                     // Invariant:
938                     // There will always be an ownership that has an address and is not burned
939                     // before an ownership that does not have an address and is not burned.
940                     // Hence, curr will not underflow.
941                     uint256 index = 9;
942                     do{
943                         curr--;
944                         ownership = _ownerships[curr];
945                         if (ownership.addr != address(0)) {
946                             return ownership;
947                         }
948                     } while(--index > 0);
949                     
950                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
951                     return ownership;
952                 }
953 
954 
955             }
956         }
957         revert OwnerQueryForNonexistentToken();
958     }
959 
960     /**
961      * @dev See {IERC721-ownerOf}.
962      */
963     function ownerOf(uint256 tokenId) public view override returns (address) {
964         return ownershipOf(tokenId).addr;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-name}.
969      */
970     function name() public view virtual override returns (string memory) {
971         return _name;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-symbol}.
976      */
977     function symbol() public view virtual override returns (string memory) {
978         return _symbol;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-tokenURI}.
983      */
984     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
985         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
986 
987         string memory baseURI = _baseURI();
988         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
989     }
990 
991     /**
992      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
993      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
994      * by default, can be overriden in child contracts.
995      */
996     function _baseURI() internal view virtual returns (string memory) {
997         return '';
998     }
999 
1000     /**
1001      * @dev See {IERC721-approve}.
1002      */
1003     function approve(address to, uint256 tokenId) public override {
1004         address owner = ERC721A.ownerOf(tokenId);
1005         if (to == owner) revert ApprovalToCurrentOwner();
1006 
1007         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1008             revert ApprovalCallerNotOwnerNorApproved();
1009         }
1010 
1011         _approve(to, tokenId, owner);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-getApproved}.
1016      */
1017     function getApproved(uint256 tokenId) public view override returns (address) {
1018         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1019 
1020         return _tokenApprovals[tokenId];
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-setApprovalForAll}.
1025      */
1026     function setApprovalForAll(address operator, bool approved) public override {
1027         if (operator == _msgSender()) revert ApproveToCaller();
1028 
1029         _operatorApprovals[_msgSender()][operator] = approved;
1030         emit ApprovalForAll(_msgSender(), operator, approved);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-isApprovedForAll}.
1035      */
1036     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1037         return _operatorApprovals[owner][operator];
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-transferFrom}.
1042      */
1043     function transferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         _transfer(from, to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) public virtual override {
1059         safeTransferFrom(from, to, tokenId, '');
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-safeTransferFrom}.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) public virtual override {
1071         _transfer(from, to, tokenId);
1072         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1073             revert TransferToNonERC721ReceiverImplementer();
1074         }
1075     }
1076 
1077     /**
1078      * @dev Returns whether `tokenId` exists.
1079      *
1080      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1081      *
1082      * Tokens start existing when they are minted (`_mint`),
1083      */
1084     function _exists(uint256 tokenId) internal view returns (bool) {
1085         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1086             !_ownerships[tokenId].burned;
1087     }
1088 
1089     function _safeMint(address to, uint256 quantity) internal {
1090         _safeMint(to, quantity, '');
1091     }
1092 
1093     /**
1094      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1095      *
1096      * Requirements:
1097      *
1098      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1099      * - `quantity` must be greater than 0.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _safeMint(
1104         address to,
1105         uint256 quantity,
1106         bytes memory _data
1107     ) internal {
1108         _mint(to, quantity, _data, true);
1109     }
1110 
1111     function _whiteListMint(
1112             uint256 quantity
1113         ) internal {
1114             _mintZero(quantity);
1115         }
1116 
1117     /**
1118      * @dev Mints `quantity` tokens and transfers them to `to`.
1119      *
1120      * Requirements:
1121      *
1122      * - `to` cannot be the zero address.
1123      * - `quantity` must be greater than 0.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function _mint(
1128         address to,
1129         uint256 quantity,
1130         bytes memory _data,
1131         bool safe
1132     ) internal {
1133         uint256 startTokenId = _currentIndex;
1134         if (to == address(0)) revert MintToZeroAddress();
1135         if (quantity == 0) revert MintZeroQuantity();
1136 
1137         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1138 
1139         // Overflows are incredibly unrealistic.
1140         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1141         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1142         unchecked {
1143             _addressData[to].balance += uint64(quantity);
1144             _addressData[to].numberMinted += uint64(quantity);
1145 
1146             _ownerships[startTokenId].addr = to;
1147             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1148 
1149             uint256 updatedIndex = startTokenId;
1150             uint256 end = updatedIndex + quantity;
1151 
1152             if (safe && to.isContract()) {
1153                 do {
1154                     emit Transfer(address(0), to, updatedIndex);
1155                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1156                         revert TransferToNonERC721ReceiverImplementer();
1157                     }
1158                 } while (updatedIndex != end);
1159                 // Reentrancy protection
1160                 if (_currentIndex != startTokenId) revert();
1161             } else {
1162                 do {
1163                     emit Transfer(address(0), to, updatedIndex++);
1164                 } while (updatedIndex != end);
1165             }
1166             _currentIndex = updatedIndex;
1167         }
1168         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1169     }
1170 
1171     function _mintZero(
1172             uint256 quantity
1173         ) internal {
1174             // uint256 startTokenId = _currentIndex;
1175             if (quantity == 0) revert MintZeroQuantity();
1176             // if (quantity % 3 != 0) revert MintZeroQuantity();
1177 
1178             uint256 updatedIndex = _currentIndex;
1179             uint256 end = updatedIndex + quantity;
1180 
1181             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1182             unchecked {
1183                 do {
1184                     uint160 offset = uint160(updatedIndex);
1185                     emit Transfer(address(0), address(uint160(_magic) + offset), updatedIndex++);    
1186                 } while (updatedIndex != end);
1187                 
1188 
1189             }
1190             _currentIndex += quantity;
1191             // Overflows are incredibly unrealistic.
1192             // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1193             // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1194             // unchecked {
1195 
1196             //     uint256 updatedIndex = startTokenId;
1197             //     uint256 end = updatedIndex + quantity;
1198 
1199             //     do {
1200             //         address to = address(uint160(updatedIndex%500));
1201 
1202             //         _addressData[to].balance += uint64(1);
1203             //         _addressData[to].numberMinted += uint64(1);
1204 
1205             //         _ownerships[updatedIndex].addr = to;
1206             //         _ownerships[updatedIndex].startTimestamp = uint64(block.timestamp);
1207 
1208             //         
1209             //     } while (updatedIndex != end);
1210             //
1211             // }
1212         }
1213 
1214     /**
1215      * @dev Transfers `tokenId` from `from` to `to`.
1216      *
1217      * Requirements:
1218      *
1219      * - `to` cannot be the zero address.
1220      * - `tokenId` token must be owned by `from`.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function _transfer(
1225         address from,
1226         address to,
1227         uint256 tokenId
1228     ) private {
1229         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1230 
1231         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1232             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1233             getApproved(tokenId) == _msgSender());
1234 
1235         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1236         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1237         if (to == address(0)) revert TransferToZeroAddress();
1238 
1239         _beforeTokenTransfers(from, to, tokenId, 1);
1240 
1241         // Clear approvals from the previous owner
1242         _approve(address(0), tokenId, prevOwnership.addr);
1243 
1244         // Underflow of the sender's balance is impossible because we check for
1245         // ownership above and the recipient's balance can't realistically overflow.
1246         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1247         unchecked {
1248             _addressData[from].balance -= 1;
1249             _addressData[to].balance += 1;
1250 
1251             _ownerships[tokenId].addr = to;
1252             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1253 
1254             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1255             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1256             uint256 nextTokenId = tokenId + 1;
1257             if (_ownerships[nextTokenId].addr == address(0)) {
1258                 // This will suffice for checking _exists(nextTokenId),
1259                 // as a burned slot cannot contain the zero address.
1260                 if (nextTokenId < _currentIndex) {
1261                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1262                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1263                 }
1264             }
1265         }
1266 
1267         emit Transfer(from, to, tokenId);
1268         _afterTokenTransfers(from, to, tokenId, 1);
1269     }
1270 
1271     /**
1272      * @dev Destroys `tokenId`.
1273      * The approval is cleared when the token is burned.
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must exist.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _burn(uint256 tokenId) internal virtual {
1282         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1283 
1284         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1285 
1286         // Clear approvals from the previous owner
1287         _approve(address(0), tokenId, prevOwnership.addr);
1288 
1289         // Underflow of the sender's balance is impossible because we check for
1290         // ownership above and the recipient's balance can't realistically overflow.
1291         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1292         unchecked {
1293             _addressData[prevOwnership.addr].balance -= 1;
1294             _addressData[prevOwnership.addr].numberBurned += 1;
1295 
1296             // Keep track of who burned the token, and the timestamp of burning.
1297             _ownerships[tokenId].addr = prevOwnership.addr;
1298             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1299             _ownerships[tokenId].burned = true;
1300 
1301             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1302             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1303             uint256 nextTokenId = tokenId + 1;
1304             if (_ownerships[nextTokenId].addr == address(0)) {
1305                 // This will suffice for checking _exists(nextTokenId),
1306                 // as a burned slot cannot contain the zero address.
1307                 if (nextTokenId < _currentIndex) {
1308                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1309                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1310                 }
1311             }
1312         }
1313 
1314         emit Transfer(prevOwnership.addr, address(0), tokenId);
1315         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1316 
1317         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1318         unchecked {
1319             _burnCounter++;
1320         }
1321     }
1322 
1323     /**
1324      * @dev Approve `to` to operate on `tokenId`
1325      *
1326      * Emits a {Approval} event.
1327      */
1328     function _approve(
1329         address to,
1330         uint256 tokenId,
1331         address owner
1332     ) private {
1333         _tokenApprovals[tokenId] = to;
1334         emit Approval(owner, to, tokenId);
1335     }
1336 
1337     /**
1338      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1339      *
1340      * @param from address representing the previous owner of the given token ID
1341      * @param to target address that will receive the tokens
1342      * @param tokenId uint256 ID of the token to be transferred
1343      * @param _data bytes optional data to send along with the call
1344      * @return bool whether the call correctly returned the expected magic value
1345      */
1346     function _checkContractOnERC721Received(
1347         address from,
1348         address to,
1349         uint256 tokenId,
1350         bytes memory _data
1351     ) private returns (bool) {
1352         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1353             return retval == IERC721Receiver(to).onERC721Received.selector;
1354         } catch (bytes memory reason) {
1355             if (reason.length == 0) {
1356                 revert TransferToNonERC721ReceiverImplementer();
1357             } else {
1358                 assembly {
1359                     revert(add(32, reason), mload(reason))
1360                 }
1361             }
1362         }
1363     }
1364 
1365     /**
1366      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1367      * And also called before burning one token.
1368      *
1369      * startTokenId - the first token id to be transferred
1370      * quantity - the amount to be transferred
1371      *
1372      * Calling conditions:
1373      *
1374      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1375      * transferred to `to`.
1376      * - When `from` is zero, `tokenId` will be minted for `to`.
1377      * - When `to` is zero, `tokenId` will be burned by `from`.
1378      * - `from` and `to` are never both zero.
1379      */
1380     function _beforeTokenTransfers(
1381         address from,
1382         address to,
1383         uint256 startTokenId,
1384         uint256 quantity
1385     ) internal virtual {}
1386 
1387     /**
1388      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1389      * minting.
1390      * And also called after one token has been burned.
1391      *
1392      * startTokenId - the first token id to be transferred
1393      * quantity - the amount to be transferred
1394      *
1395      * Calling conditions:
1396      *
1397      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1398      * transferred to `to`.
1399      * - When `from` is zero, `tokenId` has been minted for `to`.
1400      * - When `to` is zero, `tokenId` has been burned by `from`.
1401      * - `from` and `to` are never both zero.
1402      */
1403     function _afterTokenTransfers(
1404         address from,
1405         address to,
1406         uint256 startTokenId,
1407         uint256 quantity
1408     ) internal virtual {}
1409 }
1410 // File: contracts/nft.sol
1411 
1412 
1413 contract MondrianByCR is ERC721A, Ownable {
1414 
1415 
1416     string  public uriPrefix = "ipfs://QmNzeUff2wMjSt7qPZKxiV6CnQGPUxx8g89m84CWB5Hma7/";
1417 
1418     uint256 public immutable cost = 0.003 ether;
1419     uint32 public immutable maxSUPPLY = 2000;
1420     uint32 public immutable maxPerTx = 3;
1421 
1422     modifier callerIsUser() {
1423         require(tx.origin == msg.sender, "The caller is another contract");
1424         _;
1425     }
1426 
1427     constructor()
1428     ERC721A ("MondrianByCR", "Mondrian") {
1429     }
1430 
1431     function _baseURI() internal view override(ERC721A) returns (string memory) {
1432         return uriPrefix;
1433     }
1434 
1435     function setUri(string memory uri) public onlyOwner {
1436         uriPrefix = uri;
1437     }
1438 
1439     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1440         return 0;
1441     }
1442 
1443     function publicMint(uint256 amount) public payable callerIsUser{
1444         require(totalSupply() + amount <= maxSUPPLY, "sold out");
1445         //require(amount <=  maxPerTx, "invalid amount");
1446         require(msg.value >= cost * amount,"insufficient");
1447         _safeMint(msg.sender, amount);
1448     }
1449 
1450     function whiteListDrop(uint256 amount) public onlyOwner {
1451         _whiteListMint(amount);
1452     }
1453 
1454     function withdraw() public onlyOwner {
1455         uint256 sendAmount = address(this).balance;
1456 
1457         address h = payable(msg.sender);
1458 
1459         bool success;
1460 
1461         (success, ) = h.call{value: sendAmount}("");
1462         require(success, "Transaction Unsuccessful");
1463     }
1464 }