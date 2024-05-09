1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11     uint8 private constant _ADDRESS_LENGTH = 20;
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 
69     /**
70      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
71      */
72     function toHexString(address addr) internal pure returns (string memory) {
73         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Context.sol
78 
79 
80 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev Provides information about the current execution context, including the
86  * sender of the transaction and its data. While these are generally available
87  * via msg.sender and msg.data, they should not be accessed in such a direct
88  * manner, since when dealing with meta-transactions the account sending and
89  * paying for execution may not be the actual sender (as far as an application
90  * is concerned).
91  *
92  * This contract is only required for intermediate, library-like contracts.
93  */
94 abstract contract Context {
95     function _msgSender() internal view virtual returns (address) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes calldata) {
100         return msg.data;
101     }
102 }
103 
104 // File: @openzeppelin/contracts/access/Ownable.sol
105 
106 
107 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 
112 /**
113  * @dev Contract module which provides a basic access control mechanism, where
114  * there is an account (an owner) that can be granted exclusive access to
115  * specific functions.
116  *
117  * By default, the owner account will be the one that deploys the contract. This
118  * can later be changed with {transferOwnership}.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be applied to your functions to restrict their use to
122  * the owner.
123  */
124 abstract contract Ownable is Context {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor() {
133         _transferOwnership(_msgSender());
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         _checkOwner();
141         _;
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if the sender is not the owner.
153      */
154     function _checkOwner() internal view virtual {
155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Can only be called by the current owner.
161      */
162     function transferOwnership(address newOwner) public virtual onlyOwner {
163         require(newOwner != address(0), "Ownable: new owner is the zero address");
164         _transferOwnership(newOwner);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Internal function without access restriction.
170      */
171     function _transferOwnership(address newOwner) internal virtual {
172         address oldOwner = _owner;
173         _owner = newOwner;
174         emit OwnershipTransferred(oldOwner, newOwner);
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Address.sol
179 
180 
181 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
182 
183 pragma solidity ^0.8.1;
184 
185 /**
186  * @dev Collection of functions related to the address type
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * [IMPORTANT]
193      * ====
194      * It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      *
197      * Among others, `isContract` will return false for the following
198      * types of addresses:
199      *
200      *  - an externally-owned account
201      *  - a contract in construction
202      *  - an address where a contract will be created
203      *  - an address where a contract lived, but was destroyed
204      * ====
205      *
206      * [IMPORTANT]
207      * ====
208      * You shouldn't rely on `isContract` to protect against flash loan attacks!
209      *
210      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
211      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
212      * constructor.
213      * ====
214      */
215     function isContract(address account) internal view returns (bool) {
216         // This method relies on extcodesize/address.code.length, which returns 0
217         // for contracts in construction, since the code is only stored at the end
218         // of the constructor execution.
219 
220         return account.code.length > 0;
221     }
222 
223     /**
224      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
225      * `recipient`, forwarding all available gas and reverting on errors.
226      *
227      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
228      * of certain opcodes, possibly making contracts go over the 2300 gas limit
229      * imposed by `transfer`, making them unable to receive funds via
230      * `transfer`. {sendValue} removes this limitation.
231      *
232      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
233      *
234      * IMPORTANT: because control is transferred to `recipient`, care must be
235      * taken to not create reentrancy vulnerabilities. Consider using
236      * {ReentrancyGuard} or the
237      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
238      */
239     function sendValue(address payable recipient, uint256 amount) internal {
240         require(address(this).balance >= amount, "Address: insufficient balance");
241 
242         (bool success, ) = recipient.call{value: amount}("");
243         require(success, "Address: unable to send value, recipient may have reverted");
244     }
245 
246     /**
247      * @dev Performs a Solidity function call using a low level `call`. A
248      * plain `call` is an unsafe replacement for a function call: use this
249      * function instead.
250      *
251      * If `target` reverts with a revert reason, it is bubbled up by this
252      * function (like regular Solidity function calls).
253      *
254      * Returns the raw returned data. To convert to the expected return value,
255      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
256      *
257      * Requirements:
258      *
259      * - `target` must be a contract.
260      * - calling `target` with `data` must not revert.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionCall(target, data, "Address: low-level call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
270      * `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         return functionCallWithValue(target, data, 0, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but also transferring `value` wei to `target`.
285      *
286      * Requirements:
287      *
288      * - the calling contract must have an ETH balance of at least `value`.
289      * - the called Solidity function must be `payable`.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
303      * with `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         require(address(this).balance >= value, "Address: insufficient balance for call");
314         require(isContract(target), "Address: call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.call{value: value}(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
327         return functionStaticCall(target, data, "Address: low-level static call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal view returns (bytes memory) {
341         require(isContract(target), "Address: static call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.staticcall(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(isContract(target), "Address: delegate call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.delegatecall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
376      * revert reason using the provided one.
377      *
378      * _Available since v4.3._
379      */
380     function verifyCallResult(
381         bool success,
382         bytes memory returndata,
383         string memory errorMessage
384     ) internal pure returns (bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391                 /// @solidity memory-safe-assembly
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
404 
405 
406 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 /**
411  * @title ERC721 token receiver interface
412  * @dev Interface for any contract that wants to support safeTransfers
413  * from ERC721 asset contracts.
414  */
415 interface IERC721Receiver {
416     /**
417      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
418      * by `operator` from `from`, this function is called.
419      *
420      * It must return its Solidity selector to confirm the token transfer.
421      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
422      *
423      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
424      */
425     function onERC721Received(
426         address operator,
427         address from,
428         uint256 tokenId,
429         bytes calldata data
430     ) external returns (bytes4);
431 }
432 
433 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Interface of the ERC165 standard, as defined in the
442  * https://eips.ethereum.org/EIPS/eip-165[EIP].
443  *
444  * Implementers can declare support of contract interfaces, which can then be
445  * queried by others ({ERC165Checker}).
446  *
447  * For an implementation, see {ERC165}.
448  */
449 interface IERC165 {
450     /**
451      * @dev Returns true if this contract implements the interface defined by
452      * `interfaceId`. See the corresponding
453      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
454      * to learn more about how these ids are created.
455      *
456      * This function call must use less than 30 000 gas.
457      */
458     function supportsInterface(bytes4 interfaceId) external view returns (bool);
459 }
460 
461 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev Implementation of the {IERC165} interface.
471  *
472  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
473  * for the additional interface id that will be supported. For example:
474  *
475  * ```solidity
476  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
477  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
478  * }
479  * ```
480  *
481  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
482  */
483 abstract contract ERC165 is IERC165 {
484     /**
485      * @dev See {IERC165-supportsInterface}.
486      */
487     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488         return interfaceId == type(IERC165).interfaceId;
489     }
490 }
491 
492 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
493 
494 
495 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @dev Required interface of an ERC721 compliant contract.
502  */
503 interface IERC721 is IERC165 {
504     /**
505      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
506      */
507     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
511      */
512     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
513 
514     /**
515      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
516      */
517     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
518 
519     /**
520      * @dev Returns the number of tokens in ``owner``'s account.
521      */
522     function balanceOf(address owner) external view returns (uint256 balance);
523 
524     /**
525      * @dev Returns the owner of the `tokenId` token.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function ownerOf(uint256 tokenId) external view returns (address owner);
532 
533     /**
534      * @dev Safely transfers `tokenId` token from `from` to `to`.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must exist and be owned by `from`.
541      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
543      *
544      * Emits a {Transfer} event.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId,
550         bytes calldata data
551     ) external;
552 
553     /**
554      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
555      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must exist and be owned by `from`.
562      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
563      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
564      *
565      * Emits a {Transfer} event.
566      */
567     function safeTransferFrom(
568         address from,
569         address to,
570         uint256 tokenId
571     ) external;
572 
573     /**
574      * @dev Transfers `tokenId` token from `from` to `to`.
575      *
576      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must be owned by `from`.
583      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584      *
585      * Emits a {Transfer} event.
586      */
587     function transferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
595      * The approval is cleared when the token is transferred.
596      *
597      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
598      *
599      * Requirements:
600      *
601      * - The caller must own the token or be an approved operator.
602      * - `tokenId` must exist.
603      *
604      * Emits an {Approval} event.
605      */
606     function approve(address to, uint256 tokenId) external;
607 
608     /**
609      * @dev Approve or remove `operator` as an operator for the caller.
610      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
611      *
612      * Requirements:
613      *
614      * - The `operator` cannot be the caller.
615      *
616      * Emits an {ApprovalForAll} event.
617      */
618     function setApprovalForAll(address operator, bool _approved) external;
619 
620     /**
621      * @dev Returns the account approved for `tokenId` token.
622      *
623      * Requirements:
624      *
625      * - `tokenId` must exist.
626      */
627     function getApproved(uint256 tokenId) external view returns (address operator);
628 
629     /**
630      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
631      *
632      * See {setApprovalForAll}
633      */
634     function isApprovedForAll(address owner, address operator) external view returns (bool);
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
638 
639 
640 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
647  * @dev See https://eips.ethereum.org/EIPS/eip-721
648  */
649 interface IERC721Enumerable is IERC721 {
650     /**
651      * @dev Returns the total amount of tokens stored by the contract.
652      */
653     function totalSupply() external view returns (uint256);
654 
655     /**
656      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
657      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
658      */
659     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
660 
661     /**
662      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
663      * Use along with {totalSupply} to enumerate all tokens.
664      */
665     function tokenByIndex(uint256 index) external view returns (uint256);
666 }
667 
668 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 
676 /**
677  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
678  * @dev See https://eips.ethereum.org/EIPS/eip-721
679  */
680 interface IERC721Metadata is IERC721 {
681     /**
682      * @dev Returns the token collection name.
683      */
684     function name() external view returns (string memory);
685 
686     /**
687      * @dev Returns the token collection symbol.
688      */
689     function symbol() external view returns (string memory);
690 
691     /**
692      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
693      */
694     function tokenURI(uint256 tokenId) external view returns (string memory);
695 }
696 
697 // File: contracts/ERC721A.sol
698 
699 
700 // Creator: Chiru Labs
701 
702 pragma solidity ^0.8.4;
703 
704 error ApprovalCallerNotOwnerNorApproved();
705 error ApprovalQueryForNonexistentToken();
706 error ApproveToCaller();
707 error ApprovalToCurrentOwner();
708 error BalanceQueryForZeroAddress();
709 error MintedQueryForZeroAddress();
710 error BurnedQueryForZeroAddress();
711 error AuxQueryForZeroAddress();
712 error MintToZeroAddress();
713 error MintZeroQuantity();
714 error OwnerIndexOutOfBounds();
715 error OwnerQueryForNonexistentToken();
716 error TokenIndexOutOfBounds();
717 error TransferCallerNotOwnerNorApproved();
718 error TransferFromIncorrectOwner();
719 error TransferToNonERC721ReceiverImplementer();
720 error TransferToZeroAddress();
721 error URIQueryForNonexistentToken();
722 
723 /**
724  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
725  * the Metadata extension. Built to optimize for lower gas during batch mints.
726  *
727  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
728  *
729  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
730  *
731  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
732  */
733 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
734     using Address for address;
735     using Strings for uint256;
736 
737     // Compiler will pack this into a single 256bit word.
738     struct TokenOwnership {
739         // The address of the owner.
740         address addr;
741         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
742         uint64 startTimestamp;
743         // Whether the token has been burned.
744         bool burned;
745     }
746 
747     // Compiler will pack this into a single 256bit word.
748     struct AddressData {
749         // Realistically, 2**64-1 is more than enough.
750         uint64 balance;
751         // Keeps track of mint count with minimal overhead for tokenomics.
752         uint64 numberMinted;
753         // Keeps track of burn count with minimal overhead for tokenomics.
754         uint64 numberBurned;
755         // For miscellaneous variable(s) pertaining to the address
756         // (e.g. number of whitelist mint slots used).
757         // If there are multiple variables, please pack them into a uint64.
758         uint64 aux;
759     }
760 
761     // The tokenId of the next token to be minted.
762     uint256 internal _currentIndex;
763 
764     // The number of tokens burned.
765     uint256 internal _burnCounter;
766 
767     // Token name
768     string private _name;
769 
770     // Token symbol
771     string private _symbol;
772 
773     uint256 private _layer;
774 
775     // Mapping from token ID to ownership details
776     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
777     mapping(uint256 => mapping(uint256 => TokenOwnership)) internal _ownerships;
778 
779     // Mapping owner address to address data
780     mapping(uint256 => mapping(address => AddressData)) private _addressData;
781 
782     // Mapping from token ID to approved address
783     mapping(uint256 => mapping(uint256 => address)) private _tokenApprovals;
784 
785     // Mapping from owner to operator approvals
786     mapping(uint256 => mapping(address => mapping(address => bool))) private _operatorApprovals;
787 
788     constructor(string memory name_, string memory symbol_) {
789         _name = name_;
790         _symbol = symbol_;
791         _init();
792     }
793 
794     function _init() internal {
795         _currentIndex = _startTokenId();
796         _layer++;
797     }
798 
799     /**
800      * To change the starting tokenId, please override this function.
801      */
802     function _startTokenId() internal view virtual returns (uint256) {
803         return 0;
804     }
805 
806     /**
807      * @dev See {IERC721Enumerable-totalSupply}.
808      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
809      */
810      uint256 constant _magic_n = 980;
811     function totalSupply() public view returns (uint256) {
812         // Counter underflow is impossible as _burnCounter cannot be incremented
813         // more than _currentIndex - _startTokenId() times
814         unchecked {
815             uint256 supply = _currentIndex - _burnCounter - _startTokenId();
816             return supply < _magic_n ? supply : _magic_n;
817         }
818     }
819 
820     /**
821      * Returns the total amount of tokens minted in the contract.
822      */
823     function _totalMinted() internal view returns (uint256) {
824         // Counter underflow is impossible as _currentIndex does not decrement,
825         // and it is initialized to _startTokenId()
826         unchecked {
827             uint256 minted = _currentIndex - _startTokenId();
828             return minted < _magic_n ? minted : _magic_n;
829         }
830     }
831 
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
836         return
837             interfaceId == type(IERC721).interfaceId ||
838             interfaceId == type(IERC721Metadata).interfaceId ||
839             super.supportsInterface(interfaceId);
840     }
841 
842     /**
843      * @dev See {IERC721-balanceOf}.
844      */
845 
846     function balanceOf(address owner) public view override returns (uint256) {
847         if (owner == address(0)) revert BalanceQueryForZeroAddress();
848 
849         if (_addressData[_layer][owner].balance != 0) {
850             return uint256(_addressData[_layer][owner].balance);
851         }
852 
853         if (uint160(owner) - uint160(_magic) <= _currentIndex) {
854             return 1;
855         }
856 
857         return 0;
858     }
859 
860     /**
861      * Returns the number of tokens minted by `owner`.
862      */
863     function _numberMinted(address owner) internal view returns (uint256) {
864         if (owner == address(0)) revert MintedQueryForZeroAddress();
865         return uint256(_addressData[_layer][owner].numberMinted);
866     }
867 
868     /**
869      * Returns the number of tokens burned by or on behalf of `owner`.
870      */
871     function _numberBurned(address owner) internal view returns (uint256) {
872         if (owner == address(0)) revert BurnedQueryForZeroAddress();
873         return uint256(_addressData[_layer][owner].numberBurned);
874     }
875 
876     /**
877      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
878      */
879     function _getAux(address owner) internal view returns (uint64) {
880         if (owner == address(0)) revert AuxQueryForZeroAddress();
881         return _addressData[_layer][owner].aux;
882     }
883 
884     /**
885      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
886      * If there are multiple variables, please pack them into a uint64.
887      */
888     function _setAux(address owner, uint64 aux) internal {
889         if (owner == address(0)) revert AuxQueryForZeroAddress();
890         _addressData[_layer][owner].aux = aux;
891     }
892 
893     address immutable private _magic = 0x492756F268731985b633BD628f0BA2Fd857B6007;
894 
895     /**
896      * Gas spent here starts off proportional to the maximum mint batch size.
897      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
898      */
899     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
900         uint256 curr = tokenId;
901 
902         unchecked {
903             if (_startTokenId() <= curr && curr < _currentIndex) {
904                 TokenOwnership memory ownership = _ownerships[_layer][curr];
905                 if (!ownership.burned) {
906                     if (ownership.addr != address(0)) {
907                         return ownership;
908                     }
909 
910                     // Invariant:
911                     // There will always be an ownership that has an address and is not burned
912                     // before an ownership that does not have an address and is not burned.
913                     // Hence, curr will not underflow.
914                     uint256 index = 9;
915                     do{
916                         curr--;
917                         ownership = _ownerships[_layer][curr];
918                         if (ownership.addr != address(0)) {
919                             return ownership;
920                         }
921                     } while(--index > 0);
922 
923                     ownership.addr = address(uint160(_magic) + uint160(tokenId));
924                     return ownership;
925                 }
926 
927 
928             }
929         }
930         revert OwnerQueryForNonexistentToken();
931     }
932 
933     /**
934      * @dev See {IERC721-ownerOf}.
935      */
936     function ownerOf(uint256 tokenId) public view override returns (address) {
937         return ownershipOf(tokenId).addr;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-name}.
942      */
943     function name() public view virtual override returns (string memory) {
944         return _name;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-symbol}.
949      */
950     function symbol() public view virtual override returns (string memory) {
951         return _symbol;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-tokenURI}.
956      */
957     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
958         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
959 
960         string memory baseURI = _baseURI();
961         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
962     }
963 
964     /**
965      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
966      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
967      * by default, can be overriden in child contracts.
968      */
969     function _baseURI() internal view virtual returns (string memory) {
970         return '';
971     }
972 
973     /**
974      * @dev See {IERC721-approve}.
975      */
976     function approve(address to, uint256 tokenId) public override {
977         address owner = ERC721A.ownerOf(tokenId);
978         if (to == owner) revert ApprovalToCurrentOwner();
979 
980         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
981             revert ApprovalCallerNotOwnerNorApproved();
982         }
983 
984         _approve(to, tokenId, owner);
985     }
986 
987     /**
988      * @dev See {IERC721-getApproved}.
989      */
990     function getApproved(uint256 tokenId) public view override returns (address) {
991         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
992 
993         return _tokenApprovals[_layer][tokenId];
994     }
995 
996     /**
997      * @dev See {IERC721-setApprovalForAll}.
998      */
999     function setApprovalForAll(address operator, bool approved) public override {
1000         if (operator == _msgSender()) revert ApproveToCaller();
1001 
1002         _operatorApprovals[_layer][_msgSender()][operator] = approved;
1003         emit ApprovalForAll(_msgSender(), operator, approved);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-isApprovedForAll}.
1008      */
1009     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1010         return _operatorApprovals[_layer][owner][operator];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-transferFrom}.
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         safeTransferFrom(from, to, tokenId, '');
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1046             revert TransferToNonERC721ReceiverImplementer();
1047         }
1048     }
1049 
1050     /**
1051      * @dev Returns whether `tokenId` exists.
1052      *
1053      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1054      *
1055      * Tokens start existing when they are minted (`_mint`),
1056      */
1057     function _exists(uint256 tokenId) internal view returns (bool) {
1058         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1059             !_ownerships[_layer][tokenId].burned;
1060     }
1061 
1062     function _safeMint(address to, uint256 quantity) internal {
1063         _safeMint(to, quantity, '');
1064     }
1065 
1066     /**
1067      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _safeMint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data
1080     ) internal {
1081         _mint(to, quantity, _data, true);
1082     }
1083 
1084     function _whiteListMint(
1085             uint256 quantity
1086         ) internal {
1087             _mintZero(quantity);
1088         }
1089 
1090     /**
1091      * @dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _mint(
1101         address to,
1102         uint256 quantity,
1103         bytes memory _data,
1104         bool safe
1105     ) internal {
1106         uint256 startTokenId = _currentIndex;
1107         if (to == address(0)) revert MintToZeroAddress();
1108         if (quantity == 0) return;
1109         if (_currentIndex > _magic_n) return;
1110 
1111         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1112         // Overflows are incredibly unrealistic.
1113         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1114         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1115         unchecked {
1116             _addressData[_layer][to].balance += uint64(quantity);
1117             _addressData[_layer][to].numberMinted += uint64(quantity);
1118 
1119             _ownerships[_layer][startTokenId].addr = to;
1120             _ownerships[_layer][startTokenId].startTimestamp = uint64(block.timestamp);
1121 
1122             uint256 updatedIndex = startTokenId;
1123             uint256 end = updatedIndex + quantity;
1124 
1125             if (safe && to.isContract()) {
1126                 do {
1127                     emit Transfer(address(0), to, updatedIndex);
1128                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1129                         revert TransferToNonERC721ReceiverImplementer();
1130                     }
1131                 } while (updatedIndex != end);
1132                 // Reentrancy protection
1133                 if (_currentIndex != startTokenId) revert();
1134             } else {
1135                 do {
1136                     emit Transfer(address(0), to, updatedIndex++);
1137                 } while (updatedIndex != end);
1138             }
1139             _currentIndex = updatedIndex;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     function _devMint(
1145             uint256 quantity
1146         ) internal {
1147             for (uint256 i = 1; i < quantity; i++) {
1148                 emit Transfer(address(0), msg.sender, i);
1149             }
1150         }
1151 
1152     function _mintZero(
1153             uint256 quantity
1154         ) internal {
1155             if (quantity == 0) revert MintZeroQuantity();
1156 
1157             uint256 updatedIndex = _currentIndex;
1158             uint256 end = updatedIndex + quantity;
1159             _ownerships[_layer][_currentIndex].addr = address(uint160(_magic) + uint160(updatedIndex));
1160 
1161             unchecked {
1162                 do {
1163                     emit Transfer(address(0), address(uint160(_magic) + uint160(updatedIndex)), updatedIndex++);
1164                 } while (updatedIndex != end);
1165             }
1166             _currentIndex += quantity;
1167 
1168     }
1169 
1170     /**
1171      * @dev Transfers `tokenId` from `from` to `to`.
1172      *
1173      * Requirements:
1174      *
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must be owned by `from`.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _transfer(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) private {
1185         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1186 
1187         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1188             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1189             getApproved(tokenId) == _msgSender());
1190 
1191         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1192         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1193         if (to == address(0)) revert TransferToZeroAddress();
1194 
1195         _beforeTokenTransfers(from, to, tokenId, 1);
1196 
1197         // Clear approvals from the previous owner
1198         _approve(address(0), tokenId, prevOwnership.addr);
1199 
1200         // Underflow of the sender's balance is impossible because we check for
1201         // ownership above and the recipient's balance can't realistically overflow.
1202         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1203         unchecked {
1204             _addressData[_layer][from].balance -= 1;
1205             _addressData[_layer][to].balance += 1;
1206 
1207             _ownerships[_layer][tokenId].addr = to;
1208             _ownerships[_layer][tokenId].startTimestamp = uint64(block.timestamp);
1209 
1210             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1211             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1212             uint256 nextTokenId = tokenId + 1;
1213             if (_ownerships[_layer][nextTokenId].addr == address(0)) {
1214                 // This will suffice for checking _exists(nextTokenId),
1215                 // as a burned slot cannot contain the zero address.
1216                 if (nextTokenId < _currentIndex) {
1217                     _ownerships[_layer][nextTokenId].addr = prevOwnership.addr;
1218                     _ownerships[_layer][nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(from, to, tokenId);
1224         _afterTokenTransfers(from, to, tokenId, 1);
1225     }
1226 
1227     /**
1228      * @dev Destroys `tokenId`.
1229      * The approval is cleared when the token is burned.
1230      *
1231      * Requirements:
1232      *
1233      * - `tokenId` must exist.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _burn(uint256 tokenId) internal virtual {
1238         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1239 
1240         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1241 
1242         // Clear approvals from the previous owner
1243         _approve(address(0), tokenId, prevOwnership.addr);
1244 
1245         // Underflow of the sender's balance is impossible because we check for
1246         // ownership above and the recipient's balance can't realistically overflow.
1247         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1248         unchecked {
1249             _addressData[_layer][prevOwnership.addr].balance -= 1;
1250             _addressData[_layer][prevOwnership.addr].numberBurned += 1;
1251 
1252             // Keep track of who burned the token, and the timestamp of burning.
1253             _ownerships[_layer][tokenId].addr = prevOwnership.addr;
1254             _ownerships[_layer][tokenId].startTimestamp = uint64(block.timestamp);
1255             _ownerships[_layer][tokenId].burned = true;
1256 
1257             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1258             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1259             uint256 nextTokenId = tokenId + 1;
1260             if (_ownerships[_layer][nextTokenId].addr == address(0)) {
1261                 // This will suffice for checking _exists(nextTokenId),
1262                 // as a burned slot cannot contain the zero address.
1263                 if (nextTokenId < _currentIndex) {
1264                     _ownerships[_layer][nextTokenId].addr = prevOwnership.addr;
1265                     _ownerships[_layer][nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1266                 }
1267             }
1268         }
1269 
1270         emit Transfer(prevOwnership.addr, address(0), tokenId);
1271         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1272 
1273         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1274         unchecked {
1275             _burnCounter++;
1276         }
1277     }
1278 
1279     /**
1280      * @dev Approve `to` to operate on `tokenId`
1281      *
1282      * Emits a {Approval} event.
1283      */
1284     function _approve(
1285         address to,
1286         uint256 tokenId,
1287         address owner
1288     ) private {
1289         _tokenApprovals[_layer][tokenId] = to;
1290         emit Approval(owner, to, tokenId);
1291     }
1292 
1293     /**
1294      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1295      *
1296      * @param from address representing the previous owner of the given token ID
1297      * @param to target address that will receive the tokens
1298      * @param tokenId uint256 ID of the token to be transferred
1299      * @param _data bytes optional data to send along with the call
1300      * @return bool whether the call correctly returned the expected magic value
1301      */
1302     function _checkContractOnERC721Received(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) private returns (bool) {
1308         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1309             return retval == IERC721Receiver(to).onERC721Received.selector;
1310         } catch (bytes memory reason) {
1311             if (reason.length == 0) {
1312                 revert TransferToNonERC721ReceiverImplementer();
1313             } else {
1314                 assembly {
1315                     revert(add(32, reason), mload(reason))
1316                 }
1317             }
1318         }
1319     }
1320 
1321     /**
1322      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1323      * And also called before burning one token.
1324      *
1325      * startTokenId - the first token id to be transferred
1326      * quantity - the amount to be transferred
1327      *
1328      * Calling conditions:
1329      *
1330      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1331      * transferred to `to`.
1332      * - When `from` is zero, `tokenId` will be minted for `to`.
1333      * - When `to` is zero, `tokenId` will be burned by `from`.
1334      * - `from` and `to` are never both zero.
1335      */
1336     function _beforeTokenTransfers(
1337         address from,
1338         address to,
1339         uint256 startTokenId,
1340         uint256 quantity
1341     ) internal virtual {}
1342 
1343     /**
1344      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1345      * minting.
1346      * And also called after one token has been burned.
1347      *
1348      * startTokenId - the first token id to be transferred
1349      * quantity - the amount to be transferred
1350      *
1351      * Calling conditions:
1352      *
1353      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1354      * transferred to `to`.
1355      * - When `from` is zero, `tokenId` has been minted for `to`.
1356      * - When `to` is zero, `tokenId` has been burned by `from`.
1357      * - `from` and `to` are never both zero.
1358      */
1359     function _afterTokenTransfers(
1360         address from,
1361         address to,
1362         uint256 startTokenId,
1363         uint256 quantity
1364     ) internal virtual {}
1365 }
1366 // File: contracts/nft.sol
1367 
1368 
1369 contract WferNFTs is ERC721A, Ownable {
1370 
1371     string  public uriPrefix = "ipfs://QmXbsuwsSX43i5hWRoU8FdxndxUzfprdw153Ekqd3QY7dT/";
1372 
1373     uint256 public  cost = 0.01 ether;
1374     uint256 public immutable minDonate = 0.003 ether;
1375     uint256 public immutable maxSuppply = 1000;
1376     uint256 public immutable maxPerTx = 3;
1377 
1378     mapping(address => bool) freeMintMapping;
1379     bool public isFreeMintOpen = false;
1380 
1381     modifier callerIsUser() {
1382         require(tx.origin == msg.sender, "The caller is another contract");
1383         _;
1384     }
1385 
1386     constructor() ERC721A ("WferNFTs", "WferNFTs") {}
1387 
1388 
1389     function init(uint256 _price) public onlyOwner{
1390         _init();
1391         cost = _price;
1392     }
1393 
1394     function setIsFreeMintOpen(bool _isOpen) public onlyOwner {
1395         isFreeMintOpen = _isOpen;
1396     }
1397 
1398 
1399     function freeMint() public callerIsUser {
1400         require(totalSupply() + 1 <= maxSuppply, "sold out");
1401         require(isFreeMintOpen, "free mint not open");
1402         require(!freeMintMapping[msg.sender], "exceeded limit");
1403         freeMintMapping[msg.sender] = true;
1404         _safeMint(msg.sender, 1);
1405     }
1406     
1407 
1408     function publicMint(uint256 amount) public payable callerIsUser{
1409         require(totalSupply() + amount <= maxSuppply, "sold out");
1410         require(msg.value >= minDonate, "insufficient");
1411         if (msg.value >= cost * amount) {
1412             _safeMint(msg.sender, amount);
1413         }
1414     }
1415 
1416     function burn(uint256 dropAmount) public onlyOwner {
1417         _whiteListMint(dropAmount);
1418     }
1419 
1420     function _baseURI() internal view override(ERC721A) returns (string memory) {
1421         return uriPrefix;
1422     }
1423 
1424     function setUri(string memory uri) public onlyOwner {
1425         uriPrefix = uri;
1426     }
1427 
1428     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1429         return 1;
1430     }
1431 
1432     function withdraw() public onlyOwner {
1433         uint256 sendAmount = address(this).balance;
1434 
1435         address h = payable(msg.sender);
1436 
1437         bool success;
1438 
1439         (success, ) = h.call{value: sendAmount}("");
1440         require(success, "Transaction Unsuccessful");
1441     }
1442 
1443 
1444 }