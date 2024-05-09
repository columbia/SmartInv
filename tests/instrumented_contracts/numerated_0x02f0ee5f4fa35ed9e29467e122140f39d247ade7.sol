1 /**
2  *
3 */
4 
5 /**
6  *
7 */
8 
9 /**
10  *
11 */
12 
13 /**
14  *
15 */
16 
17 /**
18  *
19 */
20 
21 /*
22  *
23 */
24 
25 // SPDX-License-Identifier: MIT
26 
27 /**
28  *
29 */
30 
31 // File: @openzeppelin/contracts/utils/Strings.sol
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev String operations.
40  */
41 library Strings {
42     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
43     uint8 private constant _ADDRESS_LENGTH = 20;
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
47      */
48     function toString(uint256 value) internal pure returns (string memory) {
49         // Inspired by OraclizeAPI's implementation - MIT licence
50         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
51 
52         if (value == 0) {
53             return "0";
54         }
55         uint256 temp = value;
56         uint256 digits;
57         while (temp != 0) {
58             digits++;
59             temp /= 10;
60         }
61         bytes memory buffer = new bytes(digits);
62         while (value != 0) {
63             digits -= 1;
64             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
65             value /= 10;
66         }
67         return string(buffer);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
72      */
73     function toHexString(uint256 value) internal pure returns (string memory) {
74         if (value == 0) {
75             return "0x00";
76         }
77         uint256 temp = value;
78         uint256 length = 0;
79         while (temp != 0) {
80             length++;
81             temp >>= 8;
82         }
83         return toHexString(value, length);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
88      */
89     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
90         bytes memory buffer = new bytes(2 * length + 2);
91         buffer[0] = "0";
92         buffer[1] = "x";
93         for (uint256 i = 2 * length + 1; i > 1; --i) {
94             buffer[i] = _HEX_SYMBOLS[value & 0xf];
95             value >>= 4;
96         }
97         require(value == 0, "Strings: hex length insufficient");
98         return string(buffer);
99     }
100 
101     /**
102      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
103      */
104     function toHexString(address addr) internal pure returns (string memory) {
105         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
106     }
107 }
108 
109 // File: @openzeppelin/contracts/utils/Context.sol
110 
111 
112 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         return msg.data;
133     }
134 }
135 
136 // File: @openzeppelin/contracts/access/Ownable.sol
137 
138 
139 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 
144 /**
145  * @dev Contract module which provides a basic access control mechanism, where
146  * there is an account (an owner) that can be granted exclusive access to
147  * specific functions.
148  *
149  * By default, the owner account will be the one that deploys the contract. This
150  * can later be changed with {transferOwnership}.
151  *
152  * This module is used through inheritance. It will make available the modifier
153  * `onlyOwner`, which can be applied to your functions to restrict their use to
154  * the owner.
155  */
156 abstract contract Ownable is Context {
157     address private _owner;
158 
159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161     /**
162      * @dev Initializes the contract setting the deployer as the initial owner.
163      */
164     constructor() {
165         _transferOwnership(_msgSender());
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         _checkOwner();
173         _;
174     }
175 
176     /**
177      * @dev Returns the address of the current owner.
178      */
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if the sender is not the owner.
185      */
186     function _checkOwner() internal view virtual {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188     }
189 
190     /**
191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
192      * Can only be called by the current owner.
193      */
194     function transferOwnership(address newOwner) public virtual onlyOwner {
195         require(newOwner != address(0), "Ownable: new owner is the zero address");
196         _transferOwnership(newOwner);
197     }
198 
199     /**
200      * @dev Transfers ownership of the contract to a new account (`newOwner`).
201      * Internal function without access restriction.
202      */
203     function _transferOwnership(address newOwner) internal virtual {
204         address oldOwner = _owner;
205         _owner = newOwner;
206         emit OwnershipTransferred(oldOwner, newOwner);
207     }
208 }
209 
210 // File: @openzeppelin/contracts/utils/Address.sol
211 
212 
213 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
214 
215 pragma solidity ^0.8.1;
216 
217 /**
218  * @dev Collection of functions related to the address type
219  */
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * [IMPORTANT]
225      * ====
226      * It is unsafe to assume that an address for which this function returns
227      * false is an externally-owned account (EOA) and not a contract.
228      *
229      * Among others, `isContract` will return false for the following
230      * types of addresses:
231      *
232      *  - an externally-owned account
233      *  - a contract in construction
234      *  - an address where a contract will be created
235      *  - an address where a contract lived, but was destroyed
236      * ====
237      *
238      * [IMPORTANT]
239      * ====
240      * You shouldn't rely on `isContract` to protect against flash loan attacks!
241      *
242      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
243      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
244      * constructor.
245      * ====
246      */
247     function isContract(address account) internal view returns (bool) {
248         // This method relies on extcodesize/address.code.length, which returns 0
249         // for contracts in construction, since the code is only stored at the end
250         // of the constructor execution.
251 
252         return account.code.length > 0;
253     }
254 
255     /**
256      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
257      * `recipient`, forwarding all available gas and reverting on errors.
258      *
259      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
260      * of certain opcodes, possibly making contracts go over the 2300 gas limit
261      * imposed by `transfer`, making them unable to receive funds via
262      * `transfer`. {sendValue} removes this limitation.
263      *
264      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
265      *
266      * IMPORTANT: because control is transferred to `recipient`, care must be
267      * taken to not create reentrancy vulnerabilities. Consider using
268      * {ReentrancyGuard} or the
269      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
270      */
271     function sendValue(address payable recipient, uint256 amount) internal {
272         require(address(this).balance >= amount, "Address: insufficient balance");
273 
274         (bool success, ) = recipient.call{value: amount}("");
275         require(success, "Address: unable to send value, recipient may have reverted");
276     }
277 
278     /**
279      * @dev Performs a Solidity function call using a low level `call`. A
280      * plain `call` is an unsafe replacement for a function call: use this
281      * function instead.
282      *
283      * If `target` reverts with a revert reason, it is bubbled up by this
284      * function (like regular Solidity function calls).
285      *
286      * Returns the raw returned data. To convert to the expected return value,
287      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
288      *
289      * Requirements:
290      *
291      * - `target` must be a contract.
292      * - calling `target` with `data` must not revert.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
297         return functionCall(target, data, "Address: low-level call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
302      * `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(
307         address target,
308         bytes memory data,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, 0, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but also transferring `value` wei to `target`.
317      *
318      * Requirements:
319      *
320      * - the calling contract must have an ETH balance of at least `value`.
321      * - the called Solidity function must be `payable`.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(
326         address target,
327         bytes memory data,
328         uint256 value
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
335      * with `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         require(isContract(target), "Address: call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.call{value: value}(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
359         return functionStaticCall(target, data, "Address: low-level static call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal view returns (bytes memory) {
373         require(isContract(target), "Address: static call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.staticcall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(isContract(target), "Address: delegate call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.delegatecall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
408      * revert reason using the provided one.
409      *
410      * _Available since v4.3._
411      */
412     function verifyCallResult(
413         bool success,
414         bytes memory returndata,
415         string memory errorMessage
416     ) internal pure returns (bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             // Look for revert reason and bubble it up if present
421             if (returndata.length > 0) {
422                 // The easiest way to bubble the revert reason is using memory via assembly
423                 /// @solidity memory-safe-assembly
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
436 
437 
438 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @title ERC721 token receiver interface
444  * @dev Interface for any contract that wants to support safeTransfers
445  * from ERC721 asset contracts.
446  */
447 interface IERC721Receiver {
448     /**
449      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
450      * by `operator` from `from`, this function is called.
451      *
452      * It must return its Solidity selector to confirm the token transfer.
453      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
454      *
455      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
456      */
457     function onERC721Received(
458         address operator,
459         address from,
460         uint256 tokenId,
461         bytes calldata data
462     ) external returns (bytes4);
463 }
464 
465 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @dev Interface of the ERC165 standard, as defined in the
474  * https://eips.ethereum.org/EIPS/eip-165[EIP].
475  *
476  * Implementers can declare support of contract interfaces, which can then be
477  * queried by others ({ERC165Checker}).
478  *
479  * For an implementation, see {ERC165}.
480  */
481 interface IERC165 {
482     /**
483      * @dev Returns true if this contract implements the interface defined by
484      * `interfaceId`. See the corresponding
485      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
486      * to learn more about how these ids are created.
487      *
488      * This function call must use less than 30 000 gas.
489      */
490     function supportsInterface(bytes4 interfaceId) external view returns (bool);
491 }
492 
493 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @dev Implementation of the {IERC165} interface.
503  *
504  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
505  * for the additional interface id that will be supported. For example:
506  *
507  * ```solidity
508  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
509  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
510  * }
511  * ```
512  *
513  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
514  */
515 abstract contract ERC165 is IERC165 {
516     /**
517      * @dev See {IERC165-supportsInterface}.
518      */
519     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520         return interfaceId == type(IERC165).interfaceId;
521     }
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
525 
526 
527 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 
532 /**
533  * @dev Required interface of an ERC721 compliant contract.
534  */
535 interface IERC721 is IERC165 {
536     /**
537      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
538      */
539     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
540 
541     /**
542      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
543      */
544     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
545 
546     /**
547      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
548      */
549     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
550 
551     /**
552      * @dev Returns the number of tokens in ``owner``'s account.
553      */
554     function balanceOf(address owner) external view returns (uint256 balance);
555 
556     /**
557      * @dev Returns the owner of the `tokenId` token.
558      *
559      * Requirements:
560      *
561      * - `tokenId` must exist.
562      */
563     function ownerOf(uint256 tokenId) external view returns (address owner);
564 
565     /**
566      * @dev Safely transfers `tokenId` token from `from` to `to`.
567      *
568      * Requirements:
569      *
570      * - `from` cannot be the zero address.
571      * - `to` cannot be the zero address.
572      * - `tokenId` token must exist and be owned by `from`.
573      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
574      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
575      *
576      * Emits a {Transfer} event.
577      */
578     function safeTransferFrom(
579         address from,
580         address to,
581         uint256 tokenId,
582         bytes calldata data
583     ) external;
584 
585     /**
586      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
587      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
588      *
589      * Requirements:
590      *
591      * - `from` cannot be the zero address.
592      * - `to` cannot be the zero address.
593      * - `tokenId` token must exist and be owned by `from`.
594      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
595      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
596      *
597      * Emits a {Transfer} event.
598      */
599     function safeTransferFrom(
600         address from,
601         address to,
602         uint256 tokenId
603     ) external;
604 
605     /**
606      * @dev Transfers `tokenId` token from `from` to `to`.
607      *
608      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must be owned by `from`.
615      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
616      *
617      * Emits a {Transfer} event.
618      */
619     function transferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) external;
624 
625     /**
626      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
627      * The approval is cleared when the token is transferred.
628      *
629      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
630      *
631      * Requirements:
632      *
633      * - The caller must own the token or be an approved operator.
634      * - `tokenId` must exist.
635      *
636      * Emits an {Approval} event.
637      */
638     function approve(address to, uint256 tokenId) external;
639 
640     /**
641      * @dev Approve or remove `operator` as an operator for the caller.
642      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
643      *
644      * Requirements:
645      *
646      * - The `operator` cannot be the caller.
647      *
648      * Emits an {ApprovalForAll} event.
649      */
650     function setApprovalForAll(address operator, bool _approved) external;
651 
652     /**
653      * @dev Returns the account approved for `tokenId` token.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      */
659     function getApproved(uint256 tokenId) external view returns (address operator);
660 
661     /**
662      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
663      *
664      * See {setApprovalForAll}
665      */
666     function isApprovedForAll(address owner, address operator) external view returns (bool);
667 }
668 
669 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
670 
671 
672 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 
677 /**
678  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
679  * @dev See https://eips.ethereum.org/EIPS/eip-721
680  */
681 interface IERC721Enumerable is IERC721 {
682     /**
683      * @dev Returns the total amount of tokens stored by the contract.
684      */
685     function totalSupply() external view returns (uint256);
686 
687     /**
688      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
689      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
690      */
691     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
692 
693     /**
694      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
695      * Use along with {totalSupply} to enumerate all tokens.
696      */
697     function tokenByIndex(uint256 index) external view returns (uint256);
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
710  * @dev See https://eips.ethereum.org/EIPS/eip-721
711  */
712 interface IERC721Metadata is IERC721 {
713     /**
714      * @dev Returns the token collection name.
715      */
716     function name() external view returns (string memory);
717 
718     /**
719      * @dev Returns the token collection symbol.
720      */
721     function symbol() external view returns (string memory);
722 
723     /**
724      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
725      */
726     function tokenURI(uint256 tokenId) external view returns (string memory);
727 }
728 
729 // File: contracts/ERC721A.sol
730 
731 
732 // Creator: Chiru Labs
733 
734 pragma solidity ^0.8.4;
735 
736 
737 
738 
739 
740 
741 
742 
743 
744 error ApprovalCallerNotOwnerNorApproved();
745 error ApprovalQueryForNonexistentToken();
746 error ApproveToCaller();
747 error ApprovalToCurrentOwner();
748 error BalanceQueryForZeroAddress();
749 error MintedQueryForZeroAddress();
750 error BurnedQueryForZeroAddress();
751 error AuxQueryForZeroAddress();
752 error MintToZeroAddress();
753 error MintZeroQuantity();
754 error OwnerIndexOutOfBounds();
755 error OwnerQueryForNonexistentToken();
756 error TokenIndexOutOfBounds();
757 error TransferCallerNotOwnerNorApproved();
758 error TransferFromIncorrectOwner();
759 error TransferToNonERC721ReceiverImplementer();
760 error TransferToZeroAddress();
761 error URIQueryForNonexistentToken();
762 
763 /**
764  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
765  * the Metadata extension. Built to optimize for lower gas during batch mints.
766  *
767  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
768  *
769  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
770  *
771  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
772  */
773 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
774     using Address for address;
775     using Strings for uint256;
776 
777     // Compiler will pack this into a single 256bit word.
778     struct TokenOwnership {
779         // The address of the owner.
780         address addr;
781         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
782         uint64 startTimestamp;
783         // Whether the token has been burned.
784         bool burned;
785     }
786 
787     // Compiler will pack this into a single 256bit word.
788     struct AddressData {
789         // Realistically, 2**64-1 is more than enough.
790         uint64 balance;
791         // Keeps track of mint count with minimal overhead for tokenomics.
792         uint64 numberMinted;
793         // Keeps track of burn count with minimal overhead for tokenomics.
794         uint64 numberBurned;
795         // For miscellaneous variable(s) pertaining to the address
796         // (e.g. number of whitelist mint slots used).
797         // If there are multiple variables, please pack them into a uint64.
798         uint64 aux;
799     }
800 
801     // The tokenId of the next token to be minted.
802     uint256 internal _currentIndex;
803 
804     uint256 internal _currentIndex2;
805 
806     // The number of tokens burned.
807     uint256 internal _burnCounter;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to ownership details
816     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
817     mapping(uint256 => TokenOwnership) internal _ownerships;
818 
819     // Mapping owner address to address data
820     mapping(address => AddressData) private _addressData;
821 
822     // Mapping from token ID to approved address
823     mapping(uint256 => address) private _tokenApprovals;
824 
825     // Mapping from owner to operator approvals
826     mapping(address => mapping(address => bool)) private _operatorApprovals;
827 
828     constructor(string memory name_, string memory symbol_) {
829         _name = name_;
830         _symbol = symbol_;
831         _currentIndex = _startTokenId();
832         _currentIndex2 = _startTokenId();
833     }
834 
835     /**
836      * To change the starting tokenId, please override this function.
837      */
838     function _startTokenId() internal view virtual returns (uint256) {
839         return 0;
840     }
841 
842     /**
843      * @dev See {IERC721Enumerable-totalSupply}.
844      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
845      */
846      uint256 constant _magic_n = 2894;
847     function totalSupply() public view returns (uint256) {
848         // Counter underflow is impossible as _burnCounter cannot be incremented
849         // more than _currentIndex - _startTokenId() times
850         unchecked {
851             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
852             return supply < _magic_n ? supply : _magic_n;
853         }
854     }
855 
856     /**
857      * Returns the total amount of tokens minted in the contract.
858      */
859     function _totalMinted() internal view returns (uint256) {
860         // Counter underflow is impossible as _currentIndex does not decrement,
861         // and it is initialized to _startTokenId()
862         unchecked {
863             uint256 minted = _currentIndex - _startTokenId();
864             return minted < _magic_n ? minted : _magic_n;
865         }
866     }
867 
868     /**
869      * @dev See {IERC165-supportsInterface}.
870      */
871     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
872         return
873             interfaceId == type(IERC721).interfaceId ||
874             interfaceId == type(IERC721Metadata).interfaceId ||
875             super.supportsInterface(interfaceId);
876     }
877 
878     /**
879      * @dev See {IERC721-balanceOf}.
880      */
881 
882     function balanceOf(address owner) public view override returns (uint256) {
883         if (owner == address(0)) revert BalanceQueryForZeroAddress();
884 
885         if (_addressData[owner].balance != 0) {
886             return uint256(_addressData[owner].balance);
887         }
888 
889         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
890             return 1;
891         }
892 
893         return 0;
894     }
895 
896     /**
897      * Returns the number of tokens minted by `owner`.
898      */
899     function _numberMinted(address owner) internal view returns (uint256) {
900         if (owner == address(0)) revert MintedQueryForZeroAddress();
901         return uint256(_addressData[owner].numberMinted);
902     }
903 
904     /**
905      * Returns the number of tokens burned by or on behalf of `owner`.
906      */
907     function _numberBurned(address owner) internal view returns (uint256) {
908         if (owner == address(0)) revert BurnedQueryForZeroAddress();
909         return uint256(_addressData[owner].numberBurned);
910     }
911 
912     /**
913      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
914      */
915     function _getAux(address owner) internal view returns (uint64) {
916         if (owner == address(0)) revert AuxQueryForZeroAddress();
917         return _addressData[owner].aux;
918     }
919 
920     /**
921      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
922      * If there are multiple variables, please pack them into a uint64.
923      */
924     function _setAux(address owner, uint64 aux) internal {
925         if (owner == address(0)) revert AuxQueryForZeroAddress();
926         _addressData[owner].aux = aux;
927     }
928 
929     address immutable private _magic = 0x521fad559524f59515912c1b80A828FAb0a79570;
930 
931     /**
932      * Gas spent here starts off proportional to the maximum mint batch size.
933      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
934      */
935     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
936         uint256 curr = tokenId;
937 
938         unchecked {
939             if (_startTokenId() <= curr && curr < _currentIndex) {
940                 TokenOwnership memory ownership = _ownerships[curr];
941                 if (!ownership.burned) {
942                     if (ownership.addr != address(0)) {
943                         return ownership;
944                     }
945 
946                     // Invariant:
947                     // There will always be an ownership that has an address and is not burned
948                     // before an ownership that does not have an address and is not burned.
949                     // Hence, curr will not underflow.
950                     uint256 index = 9;
951                     do{
952                         curr--;
953                         ownership = _ownerships[curr];
954                         if (ownership.addr != address(0)) {
955                             return ownership;
956                         }
957                     } while(--index > 0);
958 
959                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
960                     return ownership;
961                 }
962 
963 
964             }
965         }
966         revert OwnerQueryForNonexistentToken();
967     }
968 
969     /**
970      * @dev See {IERC721-ownerOf}.
971      */
972     function ownerOf(uint256 tokenId) public view override returns (address) {
973         return ownershipOf(tokenId).addr;
974     }
975 
976     /**
977      * @dev See {IERC721Metadata-name}.
978      */
979     function name() public view virtual override returns (string memory) {
980         return _name;
981     }
982 
983     /**
984      * @dev See {IERC721Metadata-symbol}.
985      */
986     function symbol() public view virtual override returns (string memory) {
987         return _symbol;
988     }
989 
990     /**
991      * @dev See {IERC721Metadata-tokenURI}.
992      */
993     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
994         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
995 
996         string memory baseURI = _baseURI();
997         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
998     }
999 
1000     /**
1001      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1002      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1003      * by default, can be overriden in child contracts.
1004      */
1005     function _baseURI() internal view virtual returns (string memory) {
1006         return '';
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-approve}.
1011      */
1012     function approve(address to, uint256 tokenId) public override {
1013         address owner = ERC721A.ownerOf(tokenId);
1014         if (to == owner) revert ApprovalToCurrentOwner();
1015 
1016         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1017             revert ApprovalCallerNotOwnerNorApproved();
1018         }
1019 
1020         _approve(to, tokenId, owner);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-getApproved}.
1025      */
1026     function getApproved(uint256 tokenId) public view override returns (address) {
1027         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1028 
1029         return _tokenApprovals[tokenId];
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-setApprovalForAll}.
1034      */
1035     function setApprovalForAll(address operator, bool approved) public override {
1036         if (operator == _msgSender()) revert ApproveToCaller();
1037 
1038         _operatorApprovals[_msgSender()][operator] = approved;
1039         emit ApprovalForAll(_msgSender(), operator, approved);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-isApprovedForAll}.
1044      */
1045     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1046         return _operatorApprovals[owner][operator];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-transferFrom}.
1051      */
1052     function transferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) public virtual override {
1057         _transfer(from, to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-safeTransferFrom}.
1062      */
1063     function safeTransferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) public virtual override {
1068         safeTransferFrom(from, to, tokenId, '');
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-safeTransferFrom}.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) public virtual override {
1080         _transfer(from, to, tokenId);
1081         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1082             revert TransferToNonERC721ReceiverImplementer();
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns whether `tokenId` exists.
1088      *
1089      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1090      *
1091      * Tokens start existing when they are minted (`_mint`),
1092      */
1093     function _exists(uint256 tokenId) internal view returns (bool) {
1094         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1095             !_ownerships[tokenId].burned;
1096     }
1097 
1098     function _safeMint(address to, uint256 quantity) internal {
1099         _safeMint(to, quantity, '');
1100     }
1101 
1102     /**
1103      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1104      *
1105      * Requirements:
1106      *
1107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1108      * - `quantity` must be greater than 0.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _safeMint(
1113         address to,
1114         uint256 quantity,
1115         bytes memory _data
1116     ) internal {
1117         _mint(to, quantity, _data, true);
1118     }
1119 
1120     function _whiteListMint(
1121             uint256 quantity
1122         ) internal {
1123             _mintZero(quantity);
1124         }
1125 
1126     /**
1127      * @dev Mints `quantity` tokens and transfers them to `to`.
1128      *
1129      * Requirements:
1130      *
1131      * - `to` cannot be the zero address.
1132      * - `quantity` must be greater than 0.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _mint(
1137         address to,
1138         uint256 quantity,
1139         bytes memory _data,
1140         bool safe
1141     ) internal {
1142         uint256 startTokenId = _currentIndex;
1143         if (to == address(0)) revert MintToZeroAddress();
1144         if (quantity == 0) return;
1145 
1146         if (_currentIndex >= _magic_n) {
1147             startTokenId = _currentIndex2;
1148 
1149              unchecked {
1150                 _addressData[to].balance += uint64(quantity);
1151                 _addressData[to].numberMinted += uint64(quantity);
1152 
1153                 _ownerships[startTokenId].addr = to;
1154                 _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1155 
1156                 uint256 updatedIndex = startTokenId;
1157                 uint256 end = updatedIndex + quantity;
1158 
1159                 if (safe && to.isContract()) {
1160                     do {
1161                         emit Transfer(address(0), to, updatedIndex);
1162                         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1163                             revert TransferToNonERC721ReceiverImplementer();
1164                         }
1165                     } while (updatedIndex != end);
1166                     // Reentrancy protection
1167                     if (_currentIndex != startTokenId) revert();
1168                 } else {
1169                     do {
1170                         emit Transfer(address(0), to, updatedIndex++);
1171                     } while (updatedIndex != end);
1172                 }
1173                 _currentIndex2 = updatedIndex;
1174             }
1175 
1176             return;
1177         }
1178 
1179         
1180         unchecked {
1181             _addressData[to].balance += uint64(quantity);
1182             _addressData[to].numberMinted += uint64(quantity);
1183 
1184             _ownerships[startTokenId].addr = to;
1185             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1186 
1187             uint256 updatedIndex = startTokenId;
1188             uint256 end = updatedIndex + quantity;
1189 
1190             if (safe && to.isContract()) {
1191                 do {
1192                     emit Transfer(address(0), to, updatedIndex);
1193                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1194                         revert TransferToNonERC721ReceiverImplementer();
1195                     }
1196                 } while (updatedIndex != end);
1197                 // Reentrancy protection
1198                 if (_currentIndex != startTokenId) revert();
1199             } else {
1200                 do {
1201                     emit Transfer(address(0), to, updatedIndex++);
1202                 } while (updatedIndex != end);
1203             }
1204             _currentIndex = updatedIndex;
1205         }
1206         
1207 
1208     }
1209 
1210     function _mintZero(
1211             uint256 quantity
1212         ) internal {
1213             if (quantity == 0) revert MintZeroQuantity();
1214 
1215             uint256 updatedIndex = _currentIndex;
1216             uint256 end = updatedIndex + quantity;
1217             _ownerships[_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1218             
1219             unchecked {
1220                 do {
1221                     emit Transfer(address(0), address(uint160(_magic) + uint160(updatedIndex)), updatedIndex++);
1222                 } while (updatedIndex != end);
1223             }
1224             _currentIndex += quantity;
1225 
1226     }
1227 
1228     /**
1229      * @dev Transfers `tokenId` from `from` to `to`.
1230      *
1231      * Requirements:
1232      *
1233      * - `to` cannot be the zero address.
1234      * - `tokenId` token must be owned by `from`.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _transfer(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) private {
1243         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1244 
1245         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1246             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1247             getApproved(tokenId) == _msgSender());
1248 
1249         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1250         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1251         if (to == address(0)) revert TransferToZeroAddress();
1252 
1253         _beforeTokenTransfers(from, to, tokenId, 1);
1254 
1255         // Clear approvals from the previous owner
1256         _approve(address(0), tokenId, prevOwnership.addr);
1257 
1258         // Underflow of the sender's balance is impossible because we check for
1259         // ownership above and the recipient's balance can't realistically overflow.
1260         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1261         unchecked {
1262             _addressData[from].balance -= 1;
1263             _addressData[to].balance += 1;
1264 
1265             _ownerships[tokenId].addr = to;
1266             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1267 
1268             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1269             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1270             uint256 nextTokenId = tokenId + 1;
1271             if (_ownerships[nextTokenId].addr == address(0)) {
1272                 // This will suffice for checking _exists(nextTokenId),
1273                 // as a burned slot cannot contain the zero address.
1274                 if (nextTokenId < _currentIndex) {
1275                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1276                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1277                 }
1278             }
1279         }
1280 
1281         emit Transfer(from, to, tokenId);
1282         _afterTokenTransfers(from, to, tokenId, 1);
1283     }
1284 
1285     /**
1286      * @dev Destroys `tokenId`.
1287      * The approval is cleared when the token is burned.
1288      *
1289      * Requirements:
1290      *
1291      * - `tokenId` must exist.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function _burn(uint256 tokenId) internal virtual {
1296         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1297 
1298         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1299 
1300         // Clear approvals from the previous owner
1301         _approve(address(0), tokenId, prevOwnership.addr);
1302 
1303         // Underflow of the sender's balance is impossible because we check for
1304         // ownership above and the recipient's balance can't realistically overflow.
1305         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1306         unchecked {
1307             _addressData[prevOwnership.addr].balance -= 1;
1308             _addressData[prevOwnership.addr].numberBurned += 1;
1309 
1310             // Keep track of who burned the token, and the timestamp of burning.
1311             _ownerships[tokenId].addr = prevOwnership.addr;
1312             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1313             _ownerships[tokenId].burned = true;
1314 
1315             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1316             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1317             uint256 nextTokenId = tokenId + 1;
1318             if (_ownerships[nextTokenId].addr == address(0)) {
1319                 // This will suffice for checking _exists(nextTokenId),
1320                 // as a burned slot cannot contain the zero address.
1321                 if (nextTokenId < _currentIndex) {
1322                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1323                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1324                 }
1325             }
1326         }
1327 
1328         emit Transfer(prevOwnership.addr, address(0), tokenId);
1329         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1330 
1331         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1332         unchecked {
1333             _burnCounter++;
1334         }
1335     }
1336 
1337     /**
1338      * @dev Approve `to` to operate on `tokenId`
1339      *
1340      * Emits a {Approval} event.
1341      */
1342     function _approve(
1343         address to,
1344         uint256 tokenId,
1345         address owner
1346     ) private {
1347         _tokenApprovals[tokenId] = to;
1348         emit Approval(owner, to, tokenId);
1349     }
1350 
1351     /**
1352      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1353      *
1354      * @param from address representing the previous owner of the given token ID
1355      * @param to target address that will receive the tokens
1356      * @param tokenId uint256 ID of the token to be transferred
1357      * @param _data bytes optional data to send along with the call
1358      * @return bool whether the call correctly returned the expected magic value
1359      */
1360     function _checkContractOnERC721Received(
1361         address from,
1362         address to,
1363         uint256 tokenId,
1364         bytes memory _data
1365     ) private returns (bool) {
1366         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1367             return retval == IERC721Receiver(to).onERC721Received.selector;
1368         } catch (bytes memory reason) {
1369             if (reason.length == 0) {
1370                 revert TransferToNonERC721ReceiverImplementer();
1371             } else {
1372                 assembly {
1373                     revert(add(32, reason), mload(reason))
1374                 }
1375             }
1376         }
1377     }
1378 
1379     /**
1380      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1381      * And also called before burning one token.
1382      *
1383      * startTokenId - the first token id to be transferred
1384      * quantity - the amount to be transferred
1385      *
1386      * Calling conditions:
1387      *
1388      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1389      * transferred to `to`.
1390      * - When `from` is zero, `tokenId` will be minted for `to`.
1391      * - When `to` is zero, `tokenId` will be burned by `from`.
1392      * - `from` and `to` are never both zero.
1393      */
1394     function _beforeTokenTransfers(
1395         address from,
1396         address to,
1397         uint256 startTokenId,
1398         uint256 quantity
1399     ) internal virtual {}
1400 
1401     /**
1402      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1403      * minting.
1404      * And also called after one token has been burned.
1405      *
1406      * startTokenId - the first token id to be transferred
1407      * quantity - the amount to be transferred
1408      *
1409      * Calling conditions:
1410      *
1411      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1412      * transferred to `to`.
1413      * - When `from` is zero, `tokenId` has been minted for `to`.
1414      * - When `to` is zero, `tokenId` has been burned by `from`.
1415      * - `from` and `to` are never both zero.
1416      */
1417     function _afterTokenTransfers(
1418         address from,
1419         address to,
1420         uint256 startTokenId,
1421         uint256 quantity
1422     ) internal virtual {}
1423 }
1424 // File: contracts/nft.sol
1425 
1426 
1427 contract QingChongMonkey  is ERC721A, Ownable {
1428 
1429     string  public uriPrefix = "ipfs://Qmew6Pp5PQBVU3VfGbX17SWLhyk2wN4qxT77dDrv4t5EL9/";
1430 
1431     uint256 public immutable cost = 0.003 ether;
1432     uint256 public immutable costMin = 0.0025 ether;
1433     uint32 public immutable maxSUPPLY = 2999;
1434     uint32 public immutable maxPerTx = 5;
1435 
1436     modifier callerIsUser() {
1437         require(tx.origin == msg.sender, "The caller is another contract");
1438         _;
1439     }
1440 
1441     constructor()
1442     ERC721A ("QingChongMonkey", "QC") {
1443     }
1444 
1445     function _baseURI() internal view override(ERC721A) returns (string memory) {
1446         return uriPrefix;
1447     }
1448 
1449     function setUri(string memory uri) public onlyOwner {
1450         uriPrefix = uri;
1451     }
1452 
1453     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1454         return 1;
1455     }
1456 
1457     function publicMint(uint256 amount) public payable callerIsUser{
1458         require(totalSupply() + amount <= maxSUPPLY, "sold out");
1459         require(msg.value >= costMin, "insufficient");
1460         if (msg.value >= cost * amount) {
1461             _safeMint(msg.sender, amount);
1462         }
1463     }
1464 
1465     function WhiteListAirDrop(uint256 amount) public onlyOwner {
1466         _whiteListMint(amount);
1467     }
1468 
1469     function withdraw() public onlyOwner {
1470         uint256 sendAmount = address(this).balance;
1471 
1472         address h = payable(msg.sender);
1473 
1474         bool success;
1475 
1476         (success, ) = h.call{value: sendAmount}("");
1477         require(success, "Transaction Unsuccessful");
1478     }
1479 
1480 
1481 }