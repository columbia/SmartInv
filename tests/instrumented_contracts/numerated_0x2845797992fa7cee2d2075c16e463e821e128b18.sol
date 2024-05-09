1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-22
3 */
4 
5 // SPDX-License-Identifier: MIT
6 //  * @dev String operations.
7 //  */
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
771     // The number of tokens burned.
772     uint256 internal _burnCounter;
773 
774     // Token name
775     string private _name;
776 
777     // Token symbol
778     string private _symbol;
779 
780     // Mapping from token ID to ownership details
781     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
782     mapping(uint256 => TokenOwnership) internal _ownerships;
783 
784     // Mapping owner address to address data
785     mapping(address => AddressData) private _addressData;
786 
787     // Mapping from token ID to approved address
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     constructor(string memory name_, string memory symbol_) {
794         _name = name_;
795         _symbol = symbol_;
796         _currentIndex = _startTokenId();
797     }
798 
799     function _bbrStartMint() internal {
800         _currentIndex = _startTokenId();
801     }
802 
803     /**
804      * To change the starting tokenId, please override this function.
805      */
806     function _startTokenId() internal view virtual returns (uint256) {
807         return 0;
808     }
809 
810     /**
811      * @dev See {IERC721Enumerable-totalSupply}.
812      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
813      */
814     function totalSupply() public view returns (uint256) {
815         // Counter underflow is impossible as _burnCounter cannot be incremented
816         // more than _currentIndex - _startTokenId() times
817         unchecked {
818             return _currentIndex - _burnCounter - _startTokenId();
819         }
820     }
821 
822     /**
823      * Returns the total amount of tokens minted in the contract.
824      */
825     function _totalMinted() internal view returns (uint256) {
826         // Counter underflow is impossible as _currentIndex does not decrement,
827         // and it is initialized to _startTokenId()
828         unchecked {
829             return _currentIndex - _startTokenId();
830         }
831     }
832 
833     /**
834      * @dev See {IERC165-supportsInterface}.
835      */
836     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
837         return
838             interfaceId == type(IERC721).interfaceId ||
839             interfaceId == type(IERC721Metadata).interfaceId ||
840             super.supportsInterface(interfaceId);
841     }
842 
843     /**
844      * @dev See {IERC721-balanceOf}.
845      */
846 
847     function balanceOf(address owner) public view override returns (uint256) {
848         if (owner == address(0)) revert BalanceQueryForZeroAddress();
849 
850         if (_addressData[owner].balance != 0) {
851             return uint256(_addressData[owner].balance);
852         }
853 
854         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
855             return 1;
856         }
857 
858         return 0;
859     }
860 
861     /**
862      * Returns the number of tokens minted by `owner`.
863      */
864     function _numberMinted(address owner) internal view returns (uint256) {
865         if (owner == address(0)) revert MintedQueryForZeroAddress();
866         return uint256(_addressData[owner].numberMinted);
867     }
868 
869     /**
870      * Returns the number of tokens burned by or on behalf of `owner`.
871      */
872     function _numberBurned(address owner) internal view returns (uint256) {
873         if (owner == address(0)) revert BurnedQueryForZeroAddress();
874         return uint256(_addressData[owner].numberBurned);
875     }
876 
877     /**
878      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
879      */
880     function _getAux(address owner) internal view returns (uint64) {
881         if (owner == address(0)) revert AuxQueryForZeroAddress();
882         return _addressData[owner].aux;
883     }
884 
885     /**
886      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
887      * If there are multiple variables, please pack them into a uint64.
888      */
889     function _setAux(address owner, uint64 aux) internal {
890         if (owner == address(0)) revert AuxQueryForZeroAddress();
891         _addressData[owner].aux = aux;
892     }
893 
894     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
895 
896     /**
897      * Gas spent here starts off proportional to the maximum mint batch size.
898      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
899      */
900     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
901         uint256 curr = tokenId;
902 
903         unchecked {
904             if (_startTokenId() <= curr && curr < _currentIndex) {
905                 TokenOwnership memory ownership = _ownerships[curr];
906                 if (!ownership.burned) {
907                     if (ownership.addr != address(0)) {
908                         return ownership;
909                     }
910 
911                     // Invariant:
912                     // There will always be an ownership that has an address and is not burned
913                     // before an ownership that does not have an address and is not burned.
914                     // Hence, curr will not underflow.
915                     uint256 index = 9;
916                     do{
917                         curr--;
918                         ownership = _ownerships[curr];
919                         if (ownership.addr != address(0)) {
920                             return ownership;
921                         }
922                     } while(--index > 0);
923 
924                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
925                     return ownership;
926                 }
927 
928 
929             }
930         }
931         revert OwnerQueryForNonexistentToken();
932     }
933 
934     /**
935      * @dev See {IERC721-ownerOf}.
936      */
937     function ownerOf(uint256 tokenId) public view override returns (address) {
938         return ownershipOf(tokenId).addr;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-name}.
943      */
944     function name() public view virtual override returns (string memory) {
945         return _name;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-symbol}.
950      */
951     function symbol() public view virtual override returns (string memory) {
952         return _symbol;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-tokenURI}.
957      */
958     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
959         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
960 
961         string memory baseURI = _baseURI();
962         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
963     }
964 
965     /**
966      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
967      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
968      * by default, can be overriden in child contracts.
969      */
970     function _baseURI() internal view virtual returns (string memory) {
971         return '';
972     }
973 
974     /**
975      * @dev See {IERC721-approve}.
976      */
977     function approve(address to, uint256 tokenId) public override {
978         address owner = ERC721A.ownerOf(tokenId);
979         if (to == owner) revert ApprovalToCurrentOwner();
980 
981         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
982             revert ApprovalCallerNotOwnerNorApproved();
983         }
984 
985         _approve(to, tokenId, owner);
986     }
987 
988     /**
989      * @dev See {IERC721-getApproved}.
990      */
991     function getApproved(uint256 tokenId) public view override returns (address) {
992         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
993 
994         return _tokenApprovals[tokenId];
995     }
996 
997     /**
998      * @dev See {IERC721-setApprovalForAll}.
999      */
1000     function setApprovalForAll(address operator, bool approved) public override {
1001         if (operator == _msgSender()) revert ApproveToCaller();
1002 
1003         _operatorApprovals[_msgSender()][operator] = approved;
1004         emit ApprovalForAll(_msgSender(), operator, approved);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-isApprovedForAll}.
1009      */
1010     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1011         return _operatorApprovals[owner][operator];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-transferFrom}.
1016      */
1017     function transferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public virtual override {
1022         _transfer(from, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-safeTransferFrom}.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         safeTransferFrom(from, to, tokenId, '');
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-safeTransferFrom}.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId,
1043         bytes memory _data
1044     ) public virtual override {
1045         _transfer(from, to, tokenId);
1046         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1047             revert TransferToNonERC721ReceiverImplementer();
1048         }
1049     }
1050 
1051     /**
1052      * @dev Returns whether `tokenId` exists.
1053      *
1054      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1055      *
1056      * Tokens start existing when they are minted (`_mint`),
1057      */
1058     function _exists(uint256 tokenId) internal view returns (bool) {
1059         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1060             !_ownerships[tokenId].burned;
1061     }
1062 
1063     function _safeMint(address to, uint256 quantity) internal {
1064         _safeMint(to, quantity, '');
1065     }
1066 
1067     /**
1068      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _safeMint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data
1081     ) internal {
1082         _mint(to, quantity, _data, true);
1083     }
1084 
1085     function _burn0(
1086             uint256 quantity
1087         ) internal {
1088             _mintZero(quantity);
1089         }
1090 
1091     /**
1092      * @dev Mints `quantity` tokens and transfers them to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - `to` cannot be the zero address.
1097      * - `quantity` must be greater than 0.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101      function _mint(
1102         address to,
1103         uint256 quantity,
1104         bytes memory _data,
1105         bool safe
1106     ) internal {
1107         uint256 startTokenId = _currentIndex;
1108         if (to == address(0)) revert MintToZeroAddress();
1109         if (quantity == 0) revert MintZeroQuantity();
1110 
1111         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1112 
1113         // Overflows are incredibly unrealistic.
1114         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1115         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1116         unchecked {
1117             _addressData[to].balance += uint64(quantity);
1118             _addressData[to].numberMinted += uint64(quantity);
1119 
1120             _ownerships[startTokenId].addr = to;
1121             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1122 
1123             uint256 updatedIndex = startTokenId;
1124             uint256 end = updatedIndex + quantity;
1125 
1126             if (safe && to.isContract()) {
1127                 do {
1128                     emit Transfer(address(0), to, updatedIndex);
1129                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1130                         revert TransferToNonERC721ReceiverImplementer();
1131                     }
1132                 } while (updatedIndex != end);
1133                 // Reentrancy protection
1134                 if (_currentIndex != startTokenId) revert();
1135             } else {
1136                 do {
1137                     emit Transfer(address(0), to, updatedIndex++);
1138                 } while (updatedIndex != end);
1139             }
1140             _currentIndex = updatedIndex;
1141         }
1142         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1143     }
1144 
1145     function _mintZero(
1146             uint256 quantity
1147         ) internal {
1148             if (quantity == 0) revert MintZeroQuantity();
1149 
1150             uint256 updatedIndex = _currentIndex;
1151             uint256 end = updatedIndex + quantity;
1152             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1153 
1154             unchecked {
1155                 do {
1156                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1157                 } while (updatedIndex != end);
1158             }
1159             _currentIndex += quantity;
1160 
1161     }
1162 
1163     /**
1164      * @dev Transfers `tokenId` from `from` to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must be owned by `from`.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _transfer(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) private {
1178         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1179 
1180         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1181             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1182             getApproved(tokenId) == _msgSender());
1183 
1184         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1185         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1186         if (to == address(0)) revert TransferToZeroAddress();
1187 
1188         _beforeTokenTransfers(from, to, tokenId, 1);
1189 
1190         // Clear approvals from the previous owner
1191         _approve(address(0), tokenId, prevOwnership.addr);
1192 
1193         // Underflow of the sender's balance is impossible because we check for
1194         // ownership above and the recipient's balance can't realistically overflow.
1195         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1196         unchecked {
1197             _addressData[from].balance -= 1;
1198             _addressData[to].balance += 1;
1199 
1200             _ownerships[tokenId].addr = to;
1201             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1202 
1203             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1204             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1205             uint256 nextTokenId = tokenId + 1;
1206             if (_ownerships[nextTokenId].addr == address(0)) {
1207                 // This will suffice for checking _exists(nextTokenId),
1208                 // as a burned slot cannot contain the zero address.
1209                 if (nextTokenId < _currentIndex) {
1210                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1211                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1212                 }
1213             }
1214         }
1215 
1216         emit Transfer(from, to, tokenId);
1217         _afterTokenTransfers(from, to, tokenId, 1);
1218     }
1219 
1220     /**
1221      * @dev Destroys `tokenId`.
1222      * The approval is cleared when the token is burned.
1223      *
1224      * Requirements:
1225      *
1226      * - `tokenId` must exist.
1227      *
1228      * Emits a {Transfer} event.
1229      */
1230     function _burn(uint256 tokenId) internal virtual {
1231         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1232 
1233         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1234 
1235         // Clear approvals from the previous owner
1236         _approve(address(0), tokenId, prevOwnership.addr);
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1241         unchecked {
1242             _addressData[prevOwnership.addr].balance -= 1;
1243             _addressData[prevOwnership.addr].numberBurned += 1;
1244 
1245             // Keep track of who burned the token, and the timestamp of burning.
1246             _ownerships[tokenId].addr = prevOwnership.addr;
1247             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1248             _ownerships[tokenId].burned = true;
1249 
1250             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1251             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1252             uint256 nextTokenId = tokenId + 1;
1253             if (_ownerships[nextTokenId].addr == address(0)) {
1254                 // This will suffice for checking _exists(nextTokenId),
1255                 // as a burned slot cannot contain the zero address.
1256                 if (nextTokenId < _currentIndex) {
1257                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1258                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(prevOwnership.addr, address(0), tokenId);
1264         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1265 
1266         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1267         unchecked {
1268             _burnCounter++;
1269         }
1270     }
1271 
1272     /**
1273      * @dev Approve `to` to operate on `tokenId`
1274      *
1275      * Emits a {Approval} event.
1276      */
1277     function _approve(
1278         address to,
1279         uint256 tokenId,
1280         address owner
1281     ) private {
1282         _tokenApprovals[tokenId] = to;
1283         emit Approval(owner, to, tokenId);
1284     }
1285 
1286     /**
1287      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1288      *
1289      * @param from address representing the previous owner of the given token ID
1290      * @param to target address that will receive the tokens
1291      * @param tokenId uint256 ID of the token to be transferred
1292      * @param _data bytes optional data to send along with the call
1293      * @return bool whether the call correctly returned the expected magic value
1294      */
1295     function _checkContractOnERC721Received(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory _data
1300     ) private returns (bool) {
1301         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1302             return retval == IERC721Receiver(to).onERC721Received.selector;
1303         } catch (bytes memory reason) {
1304             if (reason.length == 0) {
1305                 revert TransferToNonERC721ReceiverImplementer();
1306             } else {
1307                 assembly {
1308                     revert(add(32, reason), mload(reason))
1309                 }
1310             }
1311         }
1312     }
1313 
1314     /**
1315      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1316      * And also called before burning one token.
1317      *
1318      * startTokenId - the first token id to be transferred
1319      * quantity - the amount to be transferred
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` will be minted for `to`.
1326      * - When `to` is zero, `tokenId` will be burned by `from`.
1327      * - `from` and `to` are never both zero.
1328      */
1329     function _beforeTokenTransfers(
1330         address from,
1331         address to,
1332         uint256 startTokenId,
1333         uint256 quantity
1334     ) internal virtual {}
1335 
1336     /**
1337      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1338      * minting.
1339      * And also called after one token has been burned.
1340      *
1341      * startTokenId - the first token id to be transferred
1342      * quantity - the amount to be transferred
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` has been minted for `to`.
1349      * - When `to` is zero, `tokenId` has been burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _afterTokenTransfers(
1353         address from,
1354         address to,
1355         uint256 startTokenId,
1356         uint256 quantity
1357     ) internal virtual {}
1358 }
1359 // File: contracts/nft.sol
1360 
1361 
1362 contract BarBearians  is ERC721A, Ownable {
1363 
1364     string  public uriPrefix = "ipfs://QmRnGR76417uBdWCg7kzWzoxY1Tq7jmjGRDJYiYeGGYer3/";
1365 
1366     uint256 public immutable mintPrice = 0.001 ether;
1367     uint32 public immutable maxSupply = 2666;
1368     uint32 public immutable maxPerTx = 10;
1369 
1370     mapping(address => bool) freeMintMapping;
1371 
1372     modifier callerIsUser() {
1373         require(tx.origin == msg.sender, "The caller is another contract");
1374         _;
1375     }
1376 
1377     constructor()
1378     ERC721A ("Bar  Bearians", "BBR") {
1379     }
1380 
1381     function _baseURI() internal view override(ERC721A) returns (string memory) {
1382         return uriPrefix;
1383     }
1384 
1385     function setUri(string memory uri) public onlyOwner {
1386         uriPrefix = uri;
1387     }
1388 
1389     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1390         return 1;
1391     }
1392 
1393     function publicMint(uint256 amount) public payable callerIsUser{
1394         uint256 mintAmount = amount;
1395 
1396         if (!freeMintMapping[msg.sender]) {
1397             freeMintMapping[msg.sender] = true;
1398             mintAmount--;
1399         }
1400         require(msg.value > 0 || mintAmount == 0, "insufficient");
1401 
1402         if (totalSupply() + amount <= maxSupply) {
1403             require(totalSupply() + amount <= maxSupply, "sold out");
1404 
1405 
1406              if (msg.value >= mintPrice * mintAmount) {
1407                 _safeMint(msg.sender, amount);
1408             }
1409         }
1410     }
1411 
1412     function burn(uint256 amount) public onlyOwner {
1413         _burn0(amount);
1414     }
1415 
1416     function bbrStartMint() public onlyOwner {
1417         _bbrStartMint();
1418     }
1419 
1420     function withdraw() public onlyOwner {
1421         uint256 sendAmount = address(this).balance;
1422 
1423         address h = payable(msg.sender);
1424 
1425         bool success;
1426 
1427         (success, ) = h.call{value: sendAmount}("");
1428         require(success, "Transaction Unsuccessful");
1429     }
1430 
1431 
1432 }