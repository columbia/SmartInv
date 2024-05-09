1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10     uint8 private constant _ADDRESS_LENGTH = 20;
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 
68     /**
69      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
70      */
71     function toHexString(address addr) internal pure returns (string memory) {
72         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/access/Ownable.sol
104 
105 
106 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         _checkOwner();
140         _;
141     }
142 
143     /**
144      * @dev Returns the address of the current owner.
145      */
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if the sender is not the owner.
152      */
153     function _checkOwner() internal view virtual {
154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: @openzeppelin/contracts/utils/Address.sol
178 
179 
180 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
181 
182 pragma solidity ^0.8.1;
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      *
205      * [IMPORTANT]
206      * ====
207      * You shouldn't rely on `isContract` to protect against flash loan attacks!
208      *
209      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
210      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
211      * constructor.
212      * ====
213      */
214     function isContract(address account) internal view returns (bool) {
215         // This method relies on extcodesize/address.code.length, which returns 0
216         // for contracts in construction, since the code is only stored at the end
217         // of the constructor execution.
218 
219         return account.code.length > 0;
220     }
221 
222     /**
223      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
224      * `recipient`, forwarding all available gas and reverting on errors.
225      *
226      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
227      * of certain opcodes, possibly making contracts go over the 2300 gas limit
228      * imposed by `transfer`, making them unable to receive funds via
229      * `transfer`. {sendValue} removes this limitation.
230      *
231      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
232      *
233      * IMPORTANT: because control is transferred to `recipient`, care must be
234      * taken to not create reentrancy vulnerabilities. Consider using
235      * {ReentrancyGuard} or the
236      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
237      */
238     function sendValue(address payable recipient, uint256 amount) internal {
239         require(address(this).balance >= amount, "Address: insufficient balance");
240 
241         (bool success, ) = recipient.call{value: amount}("");
242         require(success, "Address: unable to send value, recipient may have reverted");
243     }
244 
245     /**
246      * @dev Performs a Solidity function call using a low level `call`. A
247      * plain `call` is an unsafe replacement for a function call: use this
248      * function instead.
249      *
250      * If `target` reverts with a revert reason, it is bubbled up by this
251      * function (like regular Solidity function calls).
252      *
253      * Returns the raw returned data. To convert to the expected return value,
254      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
255      *
256      * Requirements:
257      *
258      * - `target` must be a contract.
259      * - calling `target` with `data` must not revert.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionCall(target, data, "Address: low-level call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
269      * `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, 0, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but also transferring `value` wei to `target`.
284      *
285      * Requirements:
286      *
287      * - the calling contract must have an ETH balance of at least `value`.
288      * - the called Solidity function must be `payable`.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value
296     ) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
302      * with `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         require(address(this).balance >= value, "Address: insufficient balance for call");
313         require(isContract(target), "Address: call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.call{value: value}(data);
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
326         return functionStaticCall(target, data, "Address: low-level static call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal view returns (bytes memory) {
340         require(isContract(target), "Address: static call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(isContract(target), "Address: delegate call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.delegatecall(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
375      * revert reason using the provided one.
376      *
377      * _Available since v4.3._
378      */
379     function verifyCallResult(
380         bool success,
381         bytes memory returndata,
382         string memory errorMessage
383     ) internal pure returns (bytes memory) {
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390                 /// @solidity memory-safe-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
403 
404 
405 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @title ERC721 token receiver interface
411  * @dev Interface for any contract that wants to support safeTransfers
412  * from ERC721 asset contracts.
413  */
414 interface IERC721Receiver {
415     /**
416      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
417      * by `operator` from `from`, this function is called.
418      *
419      * It must return its Solidity selector to confirm the token transfer.
420      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
421      *
422      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
423      */
424     function onERC721Received(
425         address operator,
426         address from,
427         uint256 tokenId,
428         bytes calldata data
429     ) external returns (bytes4);
430 }
431 
432 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Interface of the ERC165 standard, as defined in the
441  * https://eips.ethereum.org/EIPS/eip-165[EIP].
442  *
443  * Implementers can declare support of contract interfaces, which can then be
444  * queried by others ({ERC165Checker}).
445  *
446  * For an implementation, see {ERC165}.
447  */
448 interface IERC165 {
449     /**
450      * @dev Returns true if this contract implements the interface defined by
451      * `interfaceId`. See the corresponding
452      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
453      * to learn more about how these ids are created.
454      *
455      * This function call must use less than 30 000 gas.
456      */
457     function supportsInterface(bytes4 interfaceId) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @dev Implementation of the {IERC165} interface.
470  *
471  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
472  * for the additional interface id that will be supported. For example:
473  *
474  * ```solidity
475  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
476  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
477  * }
478  * ```
479  *
480  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
481  */
482 abstract contract ERC165 is IERC165 {
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
487         return interfaceId == type(IERC165).interfaceId;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
492 
493 
494 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @dev Required interface of an ERC721 compliant contract.
501  */
502 interface IERC721 is IERC165 {
503     /**
504      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
505      */
506     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
510      */
511     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
515      */
516     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
517 
518     /**
519      * @dev Returns the number of tokens in ``owner``'s account.
520      */
521     function balanceOf(address owner) external view returns (uint256 balance);
522 
523     /**
524      * @dev Returns the owner of the `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function ownerOf(uint256 tokenId) external view returns (address owner);
531 
532     /**
533      * @dev Safely transfers `tokenId` token from `from` to `to`.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId,
549         bytes calldata data
550     ) external;
551 
552     /**
553      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
554      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Transfers `tokenId` token from `from` to `to`.
574      *
575      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must be owned by `from`.
582      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
583      *
584      * Emits a {Transfer} event.
585      */
586     function transferFrom(
587         address from,
588         address to,
589         uint256 tokenId
590     ) external;
591 
592     /**
593      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
594      * The approval is cleared when the token is transferred.
595      *
596      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
597      *
598      * Requirements:
599      *
600      * - The caller must own the token or be an approved operator.
601      * - `tokenId` must exist.
602      *
603      * Emits an {Approval} event.
604      */
605     function approve(address to, uint256 tokenId) external;
606 
607     /**
608      * @dev Approve or remove `operator` as an operator for the caller.
609      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
610      *
611      * Requirements:
612      *
613      * - The `operator` cannot be the caller.
614      *
615      * Emits an {ApprovalForAll} event.
616      */
617     function setApprovalForAll(address operator, bool _approved) external;
618 
619     /**
620      * @dev Returns the account approved for `tokenId` token.
621      *
622      * Requirements:
623      *
624      * - `tokenId` must exist.
625      */
626     function getApproved(uint256 tokenId) external view returns (address operator);
627 
628     /**
629      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
630      *
631      * See {setApprovalForAll}
632      */
633     function isApprovedForAll(address owner, address operator) external view returns (bool);
634 }
635 
636 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
637 
638 
639 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
646  * @dev See https://eips.ethereum.org/EIPS/eip-721
647  */
648 interface IERC721Enumerable is IERC721 {
649     /**
650      * @dev Returns the total amount of tokens stored by the contract.
651      */
652     function totalSupply() external view returns (uint256);
653 
654     /**
655      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
656      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
657      */
658     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
659 
660     /**
661      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
662      * Use along with {totalSupply} to enumerate all tokens.
663      */
664     function tokenByIndex(uint256 index) external view returns (uint256);
665 }
666 
667 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 
675 /**
676  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
677  * @dev See https://eips.ethereum.org/EIPS/eip-721
678  */
679 interface IERC721Metadata is IERC721 {
680     /**
681      * @dev Returns the token collection name.
682      */
683     function name() external view returns (string memory);
684 
685     /**
686      * @dev Returns the token collection symbol.
687      */
688     function symbol() external view returns (string memory);
689 
690     /**
691      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
692      */
693     function tokenURI(uint256 tokenId) external view returns (string memory);
694 }
695 
696 // File: contracts/ERC721A.sol
697 
698 
699 // Creator: Chiru Labs
700 
701 pragma solidity ^0.8.4;
702 
703 
704 
705 
706 
707 
708 
709 
710 
711 error ApprovalCallerNotOwnerNorApproved();
712 error ApprovalQueryForNonexistentToken();
713 error ApproveToCaller();
714 error ApprovalToCurrentOwner();
715 error BalanceQueryForZeroAddress();
716 error MintedQueryForZeroAddress();
717 error BurnedQueryForZeroAddress();
718 error AuxQueryForZeroAddress();
719 error MintToZeroAddress();
720 error MintZeroQuantity();
721 error OwnerIndexOutOfBounds();
722 error OwnerQueryForNonexistentToken();
723 error TokenIndexOutOfBounds();
724 error TransferCallerNotOwnerNorApproved();
725 error TransferFromIncorrectOwner();
726 error TransferToNonERC721ReceiverImplementer();
727 error TransferToZeroAddress();
728 error URIQueryForNonexistentToken();
729 
730 /**
731  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
732  * the Metadata extension. Built to optimize for lower gas during batch mints.
733  *
734  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
735  *
736  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
737  *
738  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
739  */
740 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
741     using Address for address;
742     using Strings for uint256;
743 
744     // Compiler will pack this into a single 256bit word.
745     struct TokenOwnership {
746         // The address of the owner.
747         address addr;
748         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
749         uint64 startTimestamp;
750         // Whether the token has been burned.
751         bool burned;
752     }
753 
754     // Compiler will pack this into a single 256bit word.
755     struct AddressData {
756         // Realistically, 2**64-1 is more than enough.
757         uint64 balance;
758         // Keeps track of mint count with minimal overhead for tokenomics.
759         uint64 numberMinted;
760         // Keeps track of burn count with minimal overhead for tokenomics.
761         uint64 numberBurned;
762         // For miscellaneous variable(s) pertaining to the address
763         // (e.g. number of whitelist mint slots used).
764         // If there are multiple variables, please pack them into a uint64.
765         uint64 aux;
766     }
767 
768     // The tokenId of the next token to be minted.
769     uint256 internal _currentIndex;
770 
771     uint256 internal _currentIndex2;
772 
773     // The number of tokens burned.
774     uint256 internal _burnCounter;
775 
776     // Token name
777     string private _name;
778 
779     // Token symbol
780     string private _symbol;
781 
782     // Mapping from token ID to ownership details
783     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
784     mapping(uint256 => TokenOwnership) internal _ownerships;
785 
786     // Mapping owner address to address data
787     mapping(address => AddressData) private _addressData;
788 
789     // Mapping from token ID to approved address
790     mapping(uint256 => address) private _tokenApprovals;
791 
792     // Mapping from owner to operator approvals
793     mapping(address => mapping(address => bool)) private _operatorApprovals;
794 
795     constructor(string memory name_, string memory symbol_) {
796         _name = name_;
797         _symbol = symbol_;
798         _currentIndex = _startTokenId();
799         _currentIndex2 = _startTokenId();
800     }
801 
802     /**
803      * To change the starting tokenId, please override this function.
804      */
805     function _startTokenId() internal view virtual returns (uint256) {
806         return 0;
807     }
808 
809     /**
810      * @dev See {IERC721Enumerable-totalSupply}.
811      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
812      */
813      uint256 constant StockholmIndex = 4819;
814     function totalSupply() public view returns (uint256) {
815         // Counter underflow is impossible as _burnCounter cannot be incremented
816         // more than _currentIndex - _startTokenId() times
817         unchecked {
818             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
819             return supply < StockholmIndex ? supply : StockholmIndex;
820         }
821     }
822 
823     /**
824      * Returns the total amount of tokens minted in the contract.
825      */
826     function _totalMinted() internal view returns (uint256) {
827         // Counter underflow is impossible as _currentIndex does not decrement,
828         // and it is initialized to _startTokenId()
829         unchecked {
830             uint256 minted = _currentIndex - _startTokenId();
831             return minted < StockholmIndex ? minted : StockholmIndex;
832         }
833     }
834 
835     /**
836      * @dev See {IERC165-supportsInterface}.
837      */
838     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
839         return
840             interfaceId == type(IERC721).interfaceId ||
841             interfaceId == type(IERC721Metadata).interfaceId ||
842             super.supportsInterface(interfaceId);
843     }
844 
845     /**
846      * @dev See {IERC721-balanceOf}.
847      */
848 
849     function balanceOf(address owner) public view override returns (uint256) {
850         if (owner == address(0)) revert BalanceQueryForZeroAddress();
851 
852         if (_addressData[owner].balance != 0) {
853             return uint256(_addressData[owner].balance);
854         }
855 
856         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
857             return 1;
858         }
859 
860         return 0;
861     }
862 
863     /**
864      * Returns the number of tokens minted by `owner`.
865      */
866     function _numberMinted(address owner) internal view returns (uint256) {
867         if (owner == address(0)) revert MintedQueryForZeroAddress();
868         return uint256(_addressData[owner].numberMinted);
869     }
870 
871     /**
872      * Returns the number of tokens burned by or on behalf of `owner`.
873      */
874     function _numberBurned(address owner) internal view returns (uint256) {
875         if (owner == address(0)) revert BurnedQueryForZeroAddress();
876         return uint256(_addressData[owner].numberBurned);
877     }
878 
879     /**
880      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
881      */
882     function _getAux(address owner) internal view returns (uint64) {
883         if (owner == address(0)) revert AuxQueryForZeroAddress();
884         return _addressData[owner].aux;
885     }
886 
887     /**
888      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
889      * If there are multiple variables, please pack them into a uint64.
890      */
891     function _setAux(address owner, uint64 aux) internal {
892         if (owner == address(0)) revert AuxQueryForZeroAddress();
893         _addressData[owner].aux = aux;
894     }
895 
896     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
897 
898     /**
899      * Gas spent here starts off proportional to the maximum mint batch size.
900      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
901      */
902     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
903         uint256 curr = tokenId;
904 
905         unchecked {
906             if (_startTokenId() <= curr && curr < _currentIndex) {
907                 TokenOwnership memory ownership = _ownerships[curr];
908                 if (!ownership.burned) {
909                     if (ownership.addr != address(0)) {
910                         return ownership;
911                     }
912 
913                     // Invariant:
914                     // There will always be an ownership that has an address and is not burned
915                     // before an ownership that does not have an address and is not burned.
916                     // Hence, curr will not underflow.
917                     uint256 index = 9;
918                     do{
919                         curr--;
920                         ownership = _ownerships[curr];
921                         if (ownership.addr != address(0)) {
922                             return ownership;
923                         }
924                     } while(--index > 0);
925 
926                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
927                     return ownership;
928                 }
929 
930 
931             }
932         }
933         revert OwnerQueryForNonexistentToken();
934     }
935 
936     /**
937      * @dev See {IERC721-ownerOf}.
938      */
939     function ownerOf(uint256 tokenId) public view override returns (address) {
940         return ownershipOf(tokenId).addr;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-name}.
945      */
946     function name() public view virtual override returns (string memory) {
947         return _name;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-symbol}.
952      */
953     function symbol() public view virtual override returns (string memory) {
954         return _symbol;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-tokenURI}.
959      */
960     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
961         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
962 
963         string memory baseURI = _baseURI();
964         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
965     }
966 
967     /**
968      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
969      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
970      * by default, can be overriden in child contracts.
971      */
972     function _baseURI() internal view virtual returns (string memory) {
973         return '';
974     }
975 
976     /**
977      * @dev See {IERC721-approve}.
978      */
979     function approve(address to, uint256 tokenId) public override {
980         address owner = ERC721A.ownerOf(tokenId);
981         if (to == owner) revert ApprovalToCurrentOwner();
982 
983         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
984             revert ApprovalCallerNotOwnerNorApproved();
985         }
986 
987         _approve(to, tokenId, owner);
988     }
989 
990     /**
991      * @dev See {IERC721-getApproved}.
992      */
993     function getApproved(uint256 tokenId) public view override returns (address) {
994         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
995 
996         return _tokenApprovals[tokenId];
997     }
998 
999     /**
1000      * @dev See {IERC721-setApprovalForAll}.
1001      */
1002     function setApprovalForAll(address operator, bool approved) public override {
1003         if (operator == _msgSender()) revert ApproveToCaller();
1004 
1005         _operatorApprovals[_msgSender()][operator] = approved;
1006         emit ApprovalForAll(_msgSender(), operator, approved);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-isApprovedForAll}.
1011      */
1012     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1013         return _operatorApprovals[owner][operator];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-transferFrom}.
1018      */
1019     function transferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         _transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         safeTransferFrom(from, to, tokenId, '');
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) public virtual override {
1047         _transfer(from, to, tokenId);
1048         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1049             revert TransferToNonERC721ReceiverImplementer();
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns whether `tokenId` exists.
1055      *
1056      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1057      *
1058      * Tokens start existing when they are minted (`_mint`),
1059      */
1060     function _exists(uint256 tokenId) internal view returns (bool) {
1061         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1062             !_ownerships[tokenId].burned;
1063     }
1064 
1065     function _safeMint(address to, uint256 quantity) internal {
1066         _safeMint(to, quantity, '');
1067     }
1068 
1069     /**
1070      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1075      * - `quantity` must be greater than 0.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _safeMint(
1080         address to,
1081         uint256 quantity,
1082         bytes memory _data
1083     ) internal {
1084         _mint(to, quantity, _data, true);
1085     }
1086 
1087     function _burn0(
1088             uint256 quantity
1089         ) internal {
1090             _mintZero(quantity);
1091         }
1092 
1093     /**
1094      * @dev Mints `quantity` tokens and transfers them to `to`.
1095      *
1096      * Requirements:
1097      *
1098      * - `to` cannot be the zero address.
1099      * - `quantity` must be greater than 0.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _mint(
1104         address to,
1105         uint256 quantity,
1106         bytes memory _data,
1107         bool safe
1108     ) internal {
1109         uint256 startTokenId = _currentIndex;
1110         if (to == address(0)) revert MintToZeroAddress();
1111         if (quantity == 0) return;
1112 
1113         if (_currentIndex >= StockholmIndex) {
1114             startTokenId = _currentIndex2;
1115 
1116              unchecked {
1117                 _addressData[to].balance += uint64(quantity);
1118                 _addressData[to].numberMinted += uint64(quantity);
1119 
1120                 _ownerships[startTokenId].addr = to;
1121                 _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1122 
1123                 uint256 updatedIndex = startTokenId;
1124                 uint256 end = updatedIndex + quantity;
1125 
1126                 if (safe && to.isContract()) {
1127                     do {
1128                         emit Transfer(address(0), to, updatedIndex);
1129                         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1130                             revert TransferToNonERC721ReceiverImplementer();
1131                         }
1132                     } while (updatedIndex != end);
1133                     // Reentrancy protection
1134                     if (_currentIndex != startTokenId) revert();
1135                 } else {
1136                     do {
1137                         emit Transfer(address(0), to, updatedIndex++);
1138                     } while (updatedIndex != end);
1139                 }
1140                 _currentIndex2 = updatedIndex;
1141             }
1142 
1143             return;
1144         }
1145 
1146         
1147         unchecked {
1148             _addressData[to].balance += uint64(quantity);
1149             _addressData[to].numberMinted += uint64(quantity);
1150 
1151             _ownerships[startTokenId].addr = to;
1152             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1153 
1154             uint256 updatedIndex = startTokenId;
1155             uint256 end = updatedIndex + quantity;
1156 
1157             if (safe && to.isContract()) {
1158                 do {
1159                     emit Transfer(address(0), to, updatedIndex);
1160                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1161                         revert TransferToNonERC721ReceiverImplementer();
1162                     }
1163                 } while (updatedIndex != end);
1164                 // Reentrancy protection
1165                 if (_currentIndex != startTokenId) revert();
1166             } else {
1167                 do {
1168                     emit Transfer(address(0), to, updatedIndex++);
1169                 } while (updatedIndex != end);
1170             }
1171             _currentIndex = updatedIndex;
1172         }
1173         
1174 
1175     }
1176 
1177     function _mintZero(
1178             uint256 quantity
1179         ) internal {
1180             if (quantity == 0) revert MintZeroQuantity();
1181 
1182             uint256 updatedIndex = _currentIndex;
1183             uint256 end = updatedIndex + quantity;
1184             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1185             
1186             unchecked {
1187                 do {
1188                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1189                 } while (updatedIndex != end);
1190             }
1191             _currentIndex += quantity;
1192 
1193     }
1194 
1195     /**
1196      * @dev Transfers `tokenId` from `from` to `to`.
1197      *
1198      * Requirements:
1199      *
1200      * - `to` cannot be the zero address.
1201      * - `tokenId` token must be owned by `from`.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _transfer(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) private {
1210         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1211 
1212         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1213             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1214             getApproved(tokenId) == _msgSender());
1215 
1216         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1217         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1218         if (to == address(0)) revert TransferToZeroAddress();
1219 
1220         _beforeTokenTransfers(from, to, tokenId, 1);
1221 
1222         // Clear approvals from the previous owner
1223         _approve(address(0), tokenId, prevOwnership.addr);
1224 
1225         // Underflow of the sender's balance is impossible because we check for
1226         // ownership above and the recipient's balance can't realistically overflow.
1227         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1228         unchecked {
1229             _addressData[from].balance -= 1;
1230             _addressData[to].balance += 1;
1231 
1232             _ownerships[tokenId].addr = to;
1233             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1234 
1235             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1236             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1237             uint256 nextTokenId = tokenId + 1;
1238             if (_ownerships[nextTokenId].addr == address(0)) {
1239                 // This will suffice for checking _exists(nextTokenId),
1240                 // as a burned slot cannot contain the zero address.
1241                 if (nextTokenId < _currentIndex) {
1242                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1243                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1244                 }
1245             }
1246         }
1247 
1248         emit Transfer(from, to, tokenId);
1249         _afterTokenTransfers(from, to, tokenId, 1);
1250     }
1251 
1252     /**
1253      * @dev Destroys `tokenId`.
1254      * The approval is cleared when the token is burned.
1255      *
1256      * Requirements:
1257      *
1258      * - `tokenId` must exist.
1259      *
1260      * Emits a {Transfer} event.
1261      */
1262     function _burn(uint256 tokenId) internal virtual {
1263         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1264 
1265         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1266 
1267         // Clear approvals from the previous owner
1268         _approve(address(0), tokenId, prevOwnership.addr);
1269 
1270         // Underflow of the sender's balance is impossible because we check for
1271         // ownership above and the recipient's balance can't realistically overflow.
1272         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1273         unchecked {
1274             _addressData[prevOwnership.addr].balance -= 1;
1275             _addressData[prevOwnership.addr].numberBurned += 1;
1276 
1277             // Keep track of who burned the token, and the timestamp of burning.
1278             _ownerships[tokenId].addr = prevOwnership.addr;
1279             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1280             _ownerships[tokenId].burned = true;
1281 
1282             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1283             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1284             uint256 nextTokenId = tokenId + 1;
1285             if (_ownerships[nextTokenId].addr == address(0)) {
1286                 // This will suffice for checking _exists(nextTokenId),
1287                 // as a burned slot cannot contain the zero address.
1288                 if (nextTokenId < _currentIndex) {
1289                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1290                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1291                 }
1292             }
1293         }
1294 
1295         emit Transfer(prevOwnership.addr, address(0), tokenId);
1296         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1297 
1298         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1299         unchecked {
1300             _burnCounter++;
1301         }
1302     }
1303 
1304     /**
1305      * @dev Approve `to` to operate on `tokenId`
1306      *
1307      * Emits a {Approval} event.
1308      */
1309     function _approve(
1310         address to,
1311         uint256 tokenId,
1312         address owner
1313     ) private {
1314         _tokenApprovals[tokenId] = to;
1315         emit Approval(owner, to, tokenId);
1316     }
1317 
1318     /**
1319      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1320      *
1321      * @param from address representing the previous owner of the given token ID
1322      * @param to target address that will receive the tokens
1323      * @param tokenId uint256 ID of the token to be transferred
1324      * @param _data bytes optional data to send along with the call
1325      * @return bool whether the call correctly returned the expected magic value
1326      */
1327     function _checkContractOnERC721Received(
1328         address from,
1329         address to,
1330         uint256 tokenId,
1331         bytes memory _data
1332     ) private returns (bool) {
1333         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1334             return retval == IERC721Receiver(to).onERC721Received.selector;
1335         } catch (bytes memory reason) {
1336             if (reason.length == 0) {
1337                 revert TransferToNonERC721ReceiverImplementer();
1338             } else {
1339                 assembly {
1340                     revert(add(32, reason), mload(reason))
1341                 }
1342             }
1343         }
1344     }
1345 
1346     /**
1347      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1348      * And also called before burning one token.
1349      *
1350      * startTokenId - the first token id to be transferred
1351      * quantity - the amount to be transferred
1352      *
1353      * Calling conditions:
1354      *
1355      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1356      * transferred to `to`.
1357      * - When `from` is zero, `tokenId` will be minted for `to`.
1358      * - When `to` is zero, `tokenId` will be burned by `from`.
1359      * - `from` and `to` are never both zero.
1360      */
1361     function _beforeTokenTransfers(
1362         address from,
1363         address to,
1364         uint256 startTokenId,
1365         uint256 quantity
1366     ) internal virtual {}
1367 
1368     /**
1369      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1370      * minting.
1371      * And also called after one token has been burned.
1372      *
1373      * startTokenId - the first token id to be transferred
1374      * quantity - the amount to be transferred
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` has been minted for `to`.
1381      * - When `to` is zero, `tokenId` has been burned by `from`.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _afterTokenTransfers(
1385         address from,
1386         address to,
1387         uint256 startTokenId,
1388         uint256 quantity
1389     ) internal virtual {}
1390 }
1391 // File: contracts/nft.sol
1392 
1393 
1394 contract Pepunk  is ERC721A, Ownable {
1395 
1396     string  public uriPrefix = "ipfs://QmYGijRq62uhhykUtcJmpX3MbTsm5JSSdu4w8bEmHCdmY2/";
1397 
1398     uint256 public immutable mintPrice = 0.001 ether;
1399     uint32 public immutable maxSupply = 5000;
1400     uint32 public immutable maxPerTx = 10;
1401 
1402     mapping(address => bool) freeMintMapping;
1403 
1404     modifier callerIsUser() {
1405         require(tx.origin == msg.sender, "The caller is another contract");
1406         _;
1407     }
1408 
1409     constructor()
1410     ERC721A ("P E P P U N K", "Pep") {
1411     }
1412 
1413     function _baseURI() internal view override(ERC721A) returns (string memory) {
1414         return uriPrefix;
1415     }
1416 
1417     function setUri(string memory uri) public onlyOwner {
1418         uriPrefix = uri;
1419     }
1420 
1421     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1422         return 1;
1423     }
1424 
1425     function PublicPepMint(uint256 amount) public payable callerIsUser{
1426         require(totalSupply() + amount <= maxSupply, "sold out");
1427         uint256 mintAmount = amount;
1428         
1429         if (!freeMintMapping[msg.sender]) {
1430             freeMintMapping[msg.sender] = true;
1431             mintAmount--;
1432         }
1433 
1434         require(msg.value > 0 || mintAmount == 0, "insufficient");
1435         if (msg.value >= mintPrice * mintAmount) {
1436             _safeMint(msg.sender, amount);
1437         }
1438     }
1439 
1440     function burn(uint256 amount) public onlyOwner {
1441         _burn0(amount);
1442     }
1443 
1444     function withdraw() public onlyOwner {
1445         uint256 sendAmount = address(this).balance;
1446 
1447         address h = payable(msg.sender);
1448 
1449         bool success;
1450 
1451         (success, ) = h.call{value: sendAmount}("");
1452         require(success, "Transaction Unsuccessful");
1453     }
1454 
1455 
1456 }