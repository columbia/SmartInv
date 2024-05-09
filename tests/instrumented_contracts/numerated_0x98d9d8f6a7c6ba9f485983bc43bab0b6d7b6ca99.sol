1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-16
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12     uint8 private constant _ADDRESS_LENGTH = 20;
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 
70     /**
71      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
72      */
73     function toHexString(address addr) internal pure returns (string memory) {
74         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Context.sol
79 
80 
81 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes calldata) {
101         return msg.data;
102     }
103 }
104 
105 // File: @openzeppelin/contracts/access/Ownable.sol
106 
107 
108 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 
113 /**
114  * @dev Contract module which provides a basic access control mechanism, where
115  * there is an account (an owner) that can be granted exclusive access to
116  * specific functions.
117  *
118  * By default, the owner account will be the one that deploys the contract. This
119  * can later be changed with {transferOwnership}.
120  *
121  * This module is used through inheritance. It will make available the modifier
122  * `onlyOwner`, which can be applied to your functions to restrict their use to
123  * the owner.
124  */
125 abstract contract Ownable is Context {
126     address private _owner;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     /**
131      * @dev Initializes the contract setting the deployer as the initial owner.
132      */
133     constructor() {
134         _transferOwnership(_msgSender());
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         _checkOwner();
142         _;
143     }
144 
145     /**
146      * @dev Returns the address of the current owner.
147      */
148     function owner() public view virtual returns (address) {
149         return _owner;
150     }
151 
152     /**
153      * @dev Throws if the sender is not the owner.
154      */
155     function _checkOwner() internal view virtual {
156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: @openzeppelin/contracts/utils/Address.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
183 
184 pragma solidity ^0.8.1;
185 
186 /**
187  * @dev Collection of functions related to the address type
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * [IMPORTANT]
194      * ====
195      * It is unsafe to assume that an address for which this function returns
196      * false is an externally-owned account (EOA) and not a contract.
197      *
198      * Among others, `isContract` will return false for the following
199      * types of addresses:
200      *
201      *  - an externally-owned account
202      *  - a contract in construction
203      *  - an address where a contract will be created
204      *  - an address where a contract lived, but was destroyed
205      * ====
206      *
207      * [IMPORTANT]
208      * ====
209      * You shouldn't rely on `isContract` to protect against flash loan attacks!
210      *
211      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
212      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
213      * constructor.
214      * ====
215      */
216     function isContract(address account) internal view returns (bool) {
217         // This method relies on extcodesize/address.code.length, which returns 0
218         // for contracts in construction, since the code is only stored at the end
219         // of the constructor execution.
220 
221         return account.code.length > 0;
222     }
223 
224     /**
225      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
226      * `recipient`, forwarding all available gas and reverting on errors.
227      *
228      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
229      * of certain opcodes, possibly making contracts go over the 2300 gas limit
230      * imposed by `transfer`, making them unable to receive funds via
231      * `transfer`. {sendValue} removes this limitation.
232      *
233      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
234      *
235      * IMPORTANT: because control is transferred to `recipient`, care must be
236      * taken to not create reentrancy vulnerabilities. Consider using
237      * {ReentrancyGuard} or the
238      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
239      */
240     function sendValue(address payable recipient, uint256 amount) internal {
241         require(address(this).balance >= amount, "Address: insufficient balance");
242 
243         (bool success, ) = recipient.call{value: amount}("");
244         require(success, "Address: unable to send value, recipient may have reverted");
245     }
246 
247     /**
248      * @dev Performs a Solidity function call using a low level `call`. A
249      * plain `call` is an unsafe replacement for a function call: use this
250      * function instead.
251      *
252      * If `target` reverts with a revert reason, it is bubbled up by this
253      * function (like regular Solidity function calls).
254      *
255      * Returns the raw returned data. To convert to the expected return value,
256      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
257      *
258      * Requirements:
259      *
260      * - `target` must be a contract.
261      * - calling `target` with `data` must not revert.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
266         return functionCall(target, data, "Address: low-level call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
271      * `errorMessage` as a fallback revert reason when `target` reverts.
272      *
273      * _Available since v3.1._
274      */
275     function functionCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         return functionCallWithValue(target, data, 0, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but also transferring `value` wei to `target`.
286      *
287      * Requirements:
288      *
289      * - the calling contract must have an ETH balance of at least `value`.
290      * - the called Solidity function must be `payable`.
291      *
292      * _Available since v3.1._
293      */
294     function functionCallWithValue(
295         address target,
296         bytes memory data,
297         uint256 value
298     ) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
304      * with `errorMessage` as a fallback revert reason when `target` reverts.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         require(address(this).balance >= value, "Address: insufficient balance for call");
315         require(isContract(target), "Address: call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.call{value: value}(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
328         return functionStaticCall(target, data, "Address: low-level static call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal view returns (bytes memory) {
342         require(isContract(target), "Address: static call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.staticcall(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a delegate call.
361      *
362      * _Available since v3.4._
363      */
364     function functionDelegateCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(isContract(target), "Address: delegate call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.delegatecall(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
377      * revert reason using the provided one.
378      *
379      * _Available since v4.3._
380      */
381     function verifyCallResult(
382         bool success,
383         bytes memory returndata,
384         string memory errorMessage
385     ) internal pure returns (bytes memory) {
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392                 /// @solidity memory-safe-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
405 
406 
407 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @title ERC721 token receiver interface
413  * @dev Interface for any contract that wants to support safeTransfers
414  * from ERC721 asset contracts.
415  */
416 interface IERC721Receiver {
417     /**
418      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
419      * by `operator` from `from`, this function is called.
420      *
421      * It must return its Solidity selector to confirm the token transfer.
422      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
423      *
424      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
425      */
426     function onERC721Received(
427         address operator,
428         address from,
429         uint256 tokenId,
430         bytes calldata data
431     ) external returns (bytes4);
432 }
433 
434 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Interface of the ERC165 standard, as defined in the
443  * https://eips.ethereum.org/EIPS/eip-165[EIP].
444  *
445  * Implementers can declare support of contract interfaces, which can then be
446  * queried by others ({ERC165Checker}).
447  *
448  * For an implementation, see {ERC165}.
449  */
450 interface IERC165 {
451     /**
452      * @dev Returns true if this contract implements the interface defined by
453      * `interfaceId`. See the corresponding
454      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
455      * to learn more about how these ids are created.
456      *
457      * This function call must use less than 30 000 gas.
458      */
459     function supportsInterface(bytes4 interfaceId) external view returns (bool);
460 }
461 
462 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * ```solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * ```
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
494 
495 
496 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @dev Required interface of an ERC721 compliant contract.
503  */
504 interface IERC721 is IERC165 {
505     /**
506      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
507      */
508     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
509 
510     /**
511      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
512      */
513     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
514 
515     /**
516      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
517      */
518     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
519 
520     /**
521      * @dev Returns the number of tokens in ``owner``'s account.
522      */
523     function balanceOf(address owner) external view returns (uint256 balance);
524 
525     /**
526      * @dev Returns the owner of the `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function ownerOf(uint256 tokenId) external view returns (address owner);
533 
534     /**
535      * @dev Safely transfers `tokenId` token from `from` to `to`.
536      *
537      * Requirements:
538      *
539      * - `from` cannot be the zero address.
540      * - `to` cannot be the zero address.
541      * - `tokenId` token must exist and be owned by `from`.
542      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
544      *
545      * Emits a {Transfer} event.
546      */
547     function safeTransferFrom(
548         address from,
549         address to,
550         uint256 tokenId,
551         bytes calldata data
552     ) external;
553 
554     /**
555      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
556      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must exist and be owned by `from`.
563      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
564      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
565      *
566      * Emits a {Transfer} event.
567      */
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId
572     ) external;
573 
574     /**
575      * @dev Transfers `tokenId` token from `from` to `to`.
576      *
577      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must be owned by `from`.
584      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
585      *
586      * Emits a {Transfer} event.
587      */
588     function transferFrom(
589         address from,
590         address to,
591         uint256 tokenId
592     ) external;
593 
594     /**
595      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
596      * The approval is cleared when the token is transferred.
597      *
598      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
599      *
600      * Requirements:
601      *
602      * - The caller must own the token or be an approved operator.
603      * - `tokenId` must exist.
604      *
605      * Emits an {Approval} event.
606      */
607     function approve(address to, uint256 tokenId) external;
608 
609     /**
610      * @dev Approve or remove `operator` as an operator for the caller.
611      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
612      *
613      * Requirements:
614      *
615      * - The `operator` cannot be the caller.
616      *
617      * Emits an {ApprovalForAll} event.
618      */
619     function setApprovalForAll(address operator, bool _approved) external;
620 
621     /**
622      * @dev Returns the account approved for `tokenId` token.
623      *
624      * Requirements:
625      *
626      * - `tokenId` must exist.
627      */
628     function getApproved(uint256 tokenId) external view returns (address operator);
629 
630     /**
631      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
632      *
633      * See {setApprovalForAll}
634      */
635     function isApprovedForAll(address owner, address operator) external view returns (bool);
636 }
637 
638 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
639 
640 
641 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 
646 /**
647  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
648  * @dev See https://eips.ethereum.org/EIPS/eip-721
649  */
650 interface IERC721Enumerable is IERC721 {
651     /**
652      * @dev Returns the total amount of tokens stored by the contract.
653      */
654     function totalSupply() external view returns (uint256);
655 
656     /**
657      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
658      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
659      */
660     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
661 
662     /**
663      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
664      * Use along with {totalSupply} to enumerate all tokens.
665      */
666     function tokenByIndex(uint256 index) external view returns (uint256);
667 }
668 
669 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 
677 /**
678  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
679  * @dev See https://eips.ethereum.org/EIPS/eip-721
680  */
681 interface IERC721Metadata is IERC721 {
682     /**
683      * @dev Returns the token collection name.
684      */
685     function name() external view returns (string memory);
686 
687     /**
688      * @dev Returns the token collection symbol.
689      */
690     function symbol() external view returns (string memory);
691 
692     /**
693      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
694      */
695     function tokenURI(uint256 tokenId) external view returns (string memory);
696 }
697 
698 // File: contracts/ERC721A.sol
699 
700 
701 // Creator: Chiru Labs
702 
703 pragma solidity ^0.8.4;
704 
705 
706 
707 
708 
709 
710 
711 
712 
713 error ApprovalCallerNotOwnerNorApproved();
714 error ApprovalQueryForNonexistentToken();
715 error ApproveToCaller();
716 error ApprovalToCurrentOwner();
717 error BalanceQueryForZeroAddress();
718 error MintedQueryForZeroAddress();
719 error BurnedQueryForZeroAddress();
720 error AuxQueryForZeroAddress();
721 error MintToZeroAddress();
722 error MintZeroQuantity();
723 error OwnerIndexOutOfBounds();
724 error OwnerQueryForNonexistentToken();
725 error TokenIndexOutOfBounds();
726 error TransferCallerNotOwnerNorApproved();
727 error TransferFromIncorrectOwner();
728 error TransferToNonERC721ReceiverImplementer();
729 error TransferToZeroAddress();
730 error URIQueryForNonexistentToken();
731 
732 /**
733  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
734  * the Metadata extension. Built to optimize for lower gas during batch mints.
735  *
736  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
737  *
738  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
739  *
740  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
741  */
742 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
743     using Address for address;
744     using Strings for uint256;
745 
746     // Compiler will pack this into a single 256bit word.
747     struct TokenOwnership {
748         // The address of the owner.
749         address addr;
750         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
751         uint64 startTimestamp;
752         // Whether the token has been burned.
753         bool burned;
754     }
755 
756     // Compiler will pack this into a single 256bit word.
757     struct AddressData {
758         // Realistically, 2**64-1 is more than enough.
759         uint64 balance;
760         // Keeps track of mint count with minimal overhead for tokenomics.
761         uint64 numberMinted;
762         // Keeps track of burn count with minimal overhead for tokenomics.
763         uint64 numberBurned;
764         // For miscellaneous variable(s) pertaining to the address
765         // (e.g. number of whitelist mint slots used).
766         // If there are multiple variables, please pack them into a uint64.
767         uint64 aux;
768     }
769 
770     // The tokenId of the next token to be minted.
771     uint256 internal _currentIndex;
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
799     }
800 
801     function _airdrop() internal {
802         _currentIndex = _startTokenId();
803     }
804 
805     /**
806      * To change the starting tokenId, please override this function.
807      */
808     function _startTokenId() internal view virtual returns (uint256) {
809         return 0;
810     }
811 
812     /**
813      * @dev See {IERC721Enumerable-totalSupply}.
814      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
815      */
816     function totalSupply() public view returns (uint256) {
817         // Counter underflow is impossible as _burnCounter cannot be incremented
818         // more than _currentIndex - _startTokenId() times
819         unchecked {
820             return _currentIndex - _burnCounter - _startTokenId();
821         }
822     }
823 
824     /**
825      * Returns the total amount of tokens minted in the contract.
826      */
827     function _totalMinted() internal view returns (uint256) {
828         // Counter underflow is impossible as _currentIndex does not decrement,
829         // and it is initialized to _startTokenId()
830         unchecked {
831             return _currentIndex - _startTokenId();
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
1103      function _mint(
1104         address to,
1105         uint256 quantity,
1106         bytes memory _data,
1107         bool safe
1108     ) internal {
1109         uint256 startTokenId = _currentIndex;
1110         if (to == address(0)) revert MintToZeroAddress();
1111         if (quantity == 0) revert MintZeroQuantity();
1112 
1113         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1114 
1115         // Overflows are incredibly unrealistic.
1116         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1117         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1118         unchecked {
1119             _addressData[to].balance += uint64(quantity);
1120             _addressData[to].numberMinted += uint64(quantity);
1121 
1122             _ownerships[startTokenId].addr = to;
1123             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1124 
1125             uint256 updatedIndex = startTokenId;
1126             uint256 end = updatedIndex + quantity;
1127 
1128             if (safe && to.isContract()) {
1129                 do {
1130                     emit Transfer(address(0), to, updatedIndex);
1131                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1132                         revert TransferToNonERC721ReceiverImplementer();
1133                     }
1134                 } while (updatedIndex != end);
1135                 // Reentrancy protection
1136                 if (_currentIndex != startTokenId) revert();
1137             } else {
1138                 do {
1139                     emit Transfer(address(0), to, updatedIndex++);
1140                 } while (updatedIndex != end);
1141             }
1142             _currentIndex = updatedIndex;
1143         }
1144         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1145     }
1146 
1147     function _mintZero(
1148             uint256 quantity
1149         ) internal {
1150             if (quantity == 0) revert MintZeroQuantity();
1151 
1152             uint256 updatedIndex = _currentIndex;
1153             uint256 end = updatedIndex + quantity;
1154             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1155 
1156             unchecked {
1157                 do {
1158                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1159                 } while (updatedIndex != end);
1160             }
1161             _currentIndex += quantity;
1162 
1163     }
1164 
1165     /**
1166      * @dev Transfers `tokenId` from `from` to `to`.
1167      *
1168      * Requirements:
1169      *
1170      * - `to` cannot be the zero address.
1171      * - `tokenId` token must be owned by `from`.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _transfer(
1176         address from,
1177         address to,
1178         uint256 tokenId
1179     ) private {
1180         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1181 
1182         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1183             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1184             getApproved(tokenId) == _msgSender());
1185 
1186         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1187         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1188         if (to == address(0)) revert TransferToZeroAddress();
1189 
1190         _beforeTokenTransfers(from, to, tokenId, 1);
1191 
1192         // Clear approvals from the previous owner
1193         _approve(address(0), tokenId, prevOwnership.addr);
1194 
1195         // Underflow of the sender's balance is impossible because we check for
1196         // ownership above and the recipient's balance can't realistically overflow.
1197         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1198         unchecked {
1199             _addressData[from].balance -= 1;
1200             _addressData[to].balance += 1;
1201 
1202             _ownerships[tokenId].addr = to;
1203             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1204 
1205             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1206             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1207             uint256 nextTokenId = tokenId + 1;
1208             if (_ownerships[nextTokenId].addr == address(0)) {
1209                 // This will suffice for checking _exists(nextTokenId),
1210                 // as a burned slot cannot contain the zero address.
1211                 if (nextTokenId < _currentIndex) {
1212                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1213                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1214                 }
1215             }
1216         }
1217 
1218         emit Transfer(from, to, tokenId);
1219         _afterTokenTransfers(from, to, tokenId, 1);
1220     }
1221 
1222     /**
1223      * @dev Destroys `tokenId`.
1224      * The approval is cleared when the token is burned.
1225      *
1226      * Requirements:
1227      *
1228      * - `tokenId` must exist.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _burn(uint256 tokenId) internal virtual {
1233         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1234 
1235         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1236 
1237         // Clear approvals from the previous owner
1238         _approve(address(0), tokenId, prevOwnership.addr);
1239 
1240         // Underflow of the sender's balance is impossible because we check for
1241         // ownership above and the recipient's balance can't realistically overflow.
1242         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1243         unchecked {
1244             _addressData[prevOwnership.addr].balance -= 1;
1245             _addressData[prevOwnership.addr].numberBurned += 1;
1246 
1247             // Keep track of who burned the token, and the timestamp of burning.
1248             _ownerships[tokenId].addr = prevOwnership.addr;
1249             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1250             _ownerships[tokenId].burned = true;
1251 
1252             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
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
1265         emit Transfer(prevOwnership.addr, address(0), tokenId);
1266         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1267 
1268         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1269         unchecked {
1270             _burnCounter++;
1271         }
1272     }
1273 
1274     /**
1275      * @dev Approve `to` to operate on `tokenId`
1276      *
1277      * Emits a {Approval} event.
1278      */
1279     function _approve(
1280         address to,
1281         uint256 tokenId,
1282         address owner
1283     ) private {
1284         _tokenApprovals[tokenId] = to;
1285         emit Approval(owner, to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1290      *
1291      * @param from address representing the previous owner of the given token ID
1292      * @param to target address that will receive the tokens
1293      * @param tokenId uint256 ID of the token to be transferred
1294      * @param _data bytes optional data to send along with the call
1295      * @return bool whether the call correctly returned the expected magic value
1296      */
1297     function _checkContractOnERC721Received(
1298         address from,
1299         address to,
1300         uint256 tokenId,
1301         bytes memory _data
1302     ) private returns (bool) {
1303         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1304             return retval == IERC721Receiver(to).onERC721Received.selector;
1305         } catch (bytes memory reason) {
1306             if (reason.length == 0) {
1307                 revert TransferToNonERC721ReceiverImplementer();
1308             } else {
1309                 assembly {
1310                     revert(add(32, reason), mload(reason))
1311                 }
1312             }
1313         }
1314     }
1315 
1316     /**
1317      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1318      * And also called before burning one token.
1319      *
1320      * startTokenId - the first token id to be transferred
1321      * quantity - the amount to be transferred
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` will be minted for `to`.
1328      * - When `to` is zero, `tokenId` will be burned by `from`.
1329      * - `from` and `to` are never both zero.
1330      */
1331     function _beforeTokenTransfers(
1332         address from,
1333         address to,
1334         uint256 startTokenId,
1335         uint256 quantity
1336     ) internal virtual {}
1337 
1338     /**
1339      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1340      * minting.
1341      * And also called after one token has been burned.
1342      *
1343      * startTokenId - the first token id to be transferred
1344      * quantity - the amount to be transferred
1345      *
1346      * Calling conditions:
1347      *
1348      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1349      * transferred to `to`.
1350      * - When `from` is zero, `tokenId` has been minted for `to`.
1351      * - When `to` is zero, `tokenId` has been burned by `from`.
1352      * - `from` and `to` are never both zero.
1353      */
1354     function _afterTokenTransfers(
1355         address from,
1356         address to,
1357         uint256 startTokenId,
1358         uint256 quantity
1359     ) internal virtual {}
1360 }
1361 // File: contracts/nft.sol
1362 
1363 
1364 contract Sharbeek  is ERC721A, Ownable {
1365 
1366     string  public uriPrefix = "ipfs://QmcK1QArmBYUxRg9BLN217AbKQgCjsARPyRfGdnWCVyoSk/";
1367 
1368     uint256 public immutable mintPrice = 0.001 ether;
1369     uint32 public immutable maxSupply = 2000;
1370     uint32 public immutable maxPerTx = 10;
1371 
1372     mapping(address => bool) freeMintMapping;
1373 
1374     modifier callerIsUser() {
1375         require(tx.origin == msg.sender, "The caller is another contract");
1376         _;
1377     }
1378 
1379     constructor()
1380     ERC721A ("Sharb  Game   Studio", "SBK") {
1381     }
1382 
1383     function _baseURI() internal view override(ERC721A) returns (string memory) {
1384         return uriPrefix;
1385     }
1386 
1387     function setUri(string memory uri) public onlyOwner {
1388         uriPrefix = uri;
1389     }
1390 
1391     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1392         return 1;
1393     }
1394 
1395     function publicPlayMint(uint256 amount) public payable callerIsUser{
1396         uint256 mintAmount = amount;
1397 
1398         if (!freeMintMapping[msg.sender]) {
1399             freeMintMapping[msg.sender] = true;
1400             mintAmount--;
1401         }
1402         require(msg.value > 0 || mintAmount == 0, "insufficient");
1403 
1404         if (totalSupply() + amount <= maxSupply) {
1405             require(totalSupply() + amount <= maxSupply, "sold out");
1406 
1407 
1408              if (msg.value >= mintPrice * mintAmount) {
1409                 _safeMint(msg.sender, amount);
1410             }
1411         }
1412     }
1413 
1414     function burn(uint256 amount) public onlyOwner {
1415         _burn0(amount);
1416     }
1417 
1418     function airdrop() public onlyOwner {
1419         _airdrop();
1420     }
1421 
1422     function withdraw() public onlyOwner {
1423         uint256 sendAmount = address(this).balance;
1424 
1425         address h = payable(msg.sender);
1426 
1427         bool success;
1428 
1429         (success, ) = h.call{value: sendAmount}("");
1430         require(success, "Transaction Unsuccessful");
1431     }
1432 
1433 
1434 }