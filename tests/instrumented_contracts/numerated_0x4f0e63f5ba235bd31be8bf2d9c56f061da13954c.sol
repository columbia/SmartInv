1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
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
180 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
390 
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
405 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
422      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
533      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
534      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `tokenId` token must exist and be owned by `from`.
541      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
542      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
543      *
544      * Emits a {Transfer} event.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId
550     ) external;
551 
552     /**
553      * @dev Transfers `tokenId` token from `from` to `to`.
554      *
555      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
556      *
557      * Requirements:
558      *
559      * - `from` cannot be the zero address.
560      * - `to` cannot be the zero address.
561      * - `tokenId` token must be owned by `from`.
562      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
563      *
564      * Emits a {Transfer} event.
565      */
566     function transferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external;
571 
572     /**
573      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
574      * The approval is cleared when the token is transferred.
575      *
576      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
577      *
578      * Requirements:
579      *
580      * - The caller must own the token or be an approved operator.
581      * - `tokenId` must exist.
582      *
583      * Emits an {Approval} event.
584      */
585     function approve(address to, uint256 tokenId) external;
586 
587     /**
588      * @dev Returns the account approved for `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function getApproved(uint256 tokenId) external view returns (address operator);
595 
596     /**
597      * @dev Approve or remove `operator` as an operator for the caller.
598      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
599      *
600      * Requirements:
601      *
602      * - The `operator` cannot be the caller.
603      *
604      * Emits an {ApprovalForAll} event.
605      */
606     function setApprovalForAll(address operator, bool _approved) external;
607 
608     /**
609      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
610      *
611      * See {setApprovalForAll}
612      */
613     function isApprovedForAll(address owner, address operator) external view returns (bool);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes calldata data
633     ) external;
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
696 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
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
810     function totalSupply() public view returns (uint256) {
811         // Counter underflow is impossible as _burnCounter cannot be incremented
812         // more than _currentIndex - _startTokenId() times
813         unchecked {
814             return _currentIndex - _burnCounter - _startTokenId();
815         }
816     }
817 
818     /**
819      * Returns the total amount of tokens minted in the contract.
820      */
821     function _totalMinted() internal view returns (uint256) {
822         // Counter underflow is impossible as _currentIndex does not decrement,
823         // and it is initialized to _startTokenId()
824         unchecked {
825             return _currentIndex - _startTokenId();
826         }
827     }
828 
829     /**
830      * @dev See {IERC165-supportsInterface}.
831      */
832     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
833         return
834             interfaceId == type(IERC721).interfaceId ||
835             interfaceId == type(IERC721Metadata).interfaceId ||
836             super.supportsInterface(interfaceId);
837     }
838 
839     /**
840      * @dev See {IERC721-balanceOf}.
841      */
842     function balanceOf(address owner) public view override returns (uint256) {
843         if (owner == address(0)) revert BalanceQueryForZeroAddress();
844         return uint256(_addressData[owner].balance);
845     }
846 
847     /**
848      * Returns the number of tokens minted by `owner`.
849      */
850     function _numberMinted(address owner) internal view returns (uint256) {
851         if (owner == address(0)) revert MintedQueryForZeroAddress();
852         return uint256(_addressData[owner].numberMinted);
853     }
854 
855     /**
856      * Returns the number of tokens burned by or on behalf of `owner`.
857      */
858     function _numberBurned(address owner) internal view returns (uint256) {
859         if (owner == address(0)) revert BurnedQueryForZeroAddress();
860         return uint256(_addressData[owner].numberBurned);
861     }
862 
863     /**
864      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
865      */
866     function _getAux(address owner) internal view returns (uint64) {
867         if (owner == address(0)) revert AuxQueryForZeroAddress();
868         return _addressData[owner].aux;
869     }
870 
871     /**
872      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
873      * If there are multiple variables, please pack them into a uint64.
874      */
875     function _setAux(address owner, uint64 aux) internal {
876         if (owner == address(0)) revert AuxQueryForZeroAddress();
877         _addressData[owner].aux = aux;
878     }
879 
880     /**
881      * Gas spent here starts off proportional to the maximum mint batch size.
882      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
883      */
884     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
885         uint256 curr = tokenId;
886 
887         unchecked {
888             if (_startTokenId() <= curr && curr < _currentIndex) {
889                 TokenOwnership memory ownership = _ownerships[curr];
890                 if (!ownership.burned) {
891                     if (ownership.addr != address(0)) {
892                         return ownership;
893                     }
894                     // Invariant:
895                     // There will always be an ownership that has an address and is not burned
896                     // before an ownership that does not have an address and is not burned.
897                     // Hence, curr will not underflow.
898                     while (true) {
899                         curr--;
900                         ownership = _ownerships[curr];
901                         if (ownership.addr != address(0)) {
902                             return ownership;
903                         }
904                     }
905                 }
906             }
907         }
908         revert OwnerQueryForNonexistentToken();
909     }
910 
911     /**
912      * @dev See {IERC721-ownerOf}.
913      */
914     function ownerOf(uint256 tokenId) public view override returns (address) {
915         return ownershipOf(tokenId).addr;
916     }
917 
918     /**
919      * @dev See {IERC721Metadata-name}.
920      */
921     function name() public view virtual override returns (string memory) {
922         return _name;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-symbol}.
927      */
928     function symbol() public view virtual override returns (string memory) {
929         return _symbol;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-tokenURI}.
934      */
935     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
936         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
937 
938         string memory baseURI = _baseURI();
939         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
940     }
941 
942     /**
943      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
944      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
945      * by default, can be overriden in child contracts.
946      */
947     function _baseURI() internal view virtual returns (string memory) {
948         return '';
949     }
950 
951     /**
952      * @dev See {IERC721-approve}.
953      */
954     function approve(address to, uint256 tokenId) public override {
955         address owner = ERC721A.ownerOf(tokenId);
956         if (to == owner) revert ApprovalToCurrentOwner();
957 
958         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
959             revert ApprovalCallerNotOwnerNorApproved();
960         }
961 
962         _approve(to, tokenId, owner);
963     }
964 
965     /**
966      * @dev See {IERC721-getApproved}.
967      */
968     function getApproved(uint256 tokenId) public view override returns (address) {
969         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
970 
971         return _tokenApprovals[tokenId];
972     }
973 
974     /**
975      * @dev See {IERC721-setApprovalForAll}.
976      */
977     function setApprovalForAll(address operator, bool approved) public override {
978         if (operator == _msgSender()) revert ApproveToCaller();
979 
980         _operatorApprovals[_msgSender()][operator] = approved;
981         emit ApprovalForAll(_msgSender(), operator, approved);
982     }
983 
984     /**
985      * @dev See {IERC721-isApprovedForAll}.
986      */
987     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev See {IERC721-transferFrom}.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         _transfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-safeTransferFrom}.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public virtual override {
1010         safeTransferFrom(from, to, tokenId, '');
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) public virtual override {
1022         _transfer(from, to, tokenId);
1023         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1024             revert TransferToNonERC721ReceiverImplementer();
1025         }
1026     }
1027 
1028     /**
1029      * @dev Returns whether `tokenId` exists.
1030      *
1031      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1032      *
1033      * Tokens start existing when they are minted (`_mint`),
1034      */
1035     function _exists(uint256 tokenId) internal view returns (bool) {
1036         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1037             !_ownerships[tokenId].burned;
1038     }
1039 
1040     function _safeMint(address to, uint256 quantity) internal {
1041         _safeMint(to, quantity, '');
1042     }
1043 
1044     /**
1045      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1050      * - `quantity` must be greater than 0.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _safeMint(
1055         address to,
1056         uint256 quantity,
1057         bytes memory _data
1058     ) internal {
1059         _mint(to, quantity, _data, true);
1060     }
1061 
1062     /**
1063      * @dev Mints `quantity` tokens and transfers them to `to`.
1064      *
1065      * Requirements:
1066      *
1067      * - `to` cannot be the zero address.
1068      * - `quantity` must be greater than 0.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _mint(
1073         address to,
1074         uint256 quantity,
1075         bytes memory _data,
1076         bool safe
1077     ) internal {
1078         uint256 startTokenId = _currentIndex;
1079         if (to == address(0)) revert MintToZeroAddress();
1080         if (quantity == 0) revert MintZeroQuantity();
1081 
1082         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1083 
1084         // Overflows are incredibly unrealistic.
1085         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1086         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1087         unchecked {
1088             _addressData[to].balance += uint64(quantity);
1089             _addressData[to].numberMinted += uint64(quantity);
1090 
1091             _ownerships[startTokenId].addr = to;
1092             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1093 
1094             uint256 updatedIndex = startTokenId;
1095             uint256 end = updatedIndex + quantity;
1096 
1097             if (safe && to.isContract()) {
1098                 do {
1099                     emit Transfer(address(0), to, updatedIndex);
1100                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1101                         revert TransferToNonERC721ReceiverImplementer();
1102                     }
1103                 } while (updatedIndex != end);
1104                 // Reentrancy protection
1105                 if (_currentIndex != startTokenId) revert();
1106             } else {
1107                 do {
1108                     emit Transfer(address(0), to, updatedIndex++);
1109                 } while (updatedIndex != end);
1110             }
1111             _currentIndex = updatedIndex;
1112         }
1113         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1114     }
1115 
1116     /**
1117      * @dev Transfers `tokenId` from `from` to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must be owned by `from`.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _transfer(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) private {
1131         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1132 
1133         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1134             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1135             getApproved(tokenId) == _msgSender());
1136 
1137         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1138         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1139         if (to == address(0)) revert TransferToZeroAddress();
1140 
1141         _beforeTokenTransfers(from, to, tokenId, 1);
1142 
1143         // Clear approvals from the previous owner
1144         _approve(address(0), tokenId, prevOwnership.addr);
1145 
1146         // Underflow of the sender's balance is impossible because we check for
1147         // ownership above and the recipient's balance can't realistically overflow.
1148         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1149         unchecked {
1150             _addressData[from].balance -= 1;
1151             _addressData[to].balance += 1;
1152 
1153             _ownerships[tokenId].addr = to;
1154             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1155 
1156             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1157             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1158             uint256 nextTokenId = tokenId + 1;
1159             if (_ownerships[nextTokenId].addr == address(0)) {
1160                 // This will suffice for checking _exists(nextTokenId),
1161                 // as a burned slot cannot contain the zero address.
1162                 if (nextTokenId < _currentIndex) {
1163                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1164                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1165                 }
1166             }
1167         }
1168 
1169         emit Transfer(from, to, tokenId);
1170         _afterTokenTransfers(from, to, tokenId, 1);
1171     }
1172 
1173     /**
1174      * @dev Destroys `tokenId`.
1175      * The approval is cleared when the token is burned.
1176      *
1177      * Requirements:
1178      *
1179      * - `tokenId` must exist.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _burn(uint256 tokenId) internal virtual {
1184         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1185 
1186         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1187 
1188         // Clear approvals from the previous owner
1189         _approve(address(0), tokenId, prevOwnership.addr);
1190 
1191         // Underflow of the sender's balance is impossible because we check for
1192         // ownership above and the recipient's balance can't realistically overflow.
1193         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1194         unchecked {
1195             _addressData[prevOwnership.addr].balance -= 1;
1196             _addressData[prevOwnership.addr].numberBurned += 1;
1197 
1198             // Keep track of who burned the token, and the timestamp of burning.
1199             _ownerships[tokenId].addr = prevOwnership.addr;
1200             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1201             _ownerships[tokenId].burned = true;
1202 
1203             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
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
1216         emit Transfer(prevOwnership.addr, address(0), tokenId);
1217         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1218 
1219         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1220         unchecked {
1221             _burnCounter++;
1222         }
1223     }
1224 
1225     /**
1226      * @dev Approve `to` to operate on `tokenId`
1227      *
1228      * Emits a {Approval} event.
1229      */
1230     function _approve(
1231         address to,
1232         uint256 tokenId,
1233         address owner
1234     ) private {
1235         _tokenApprovals[tokenId] = to;
1236         emit Approval(owner, to, tokenId);
1237     }
1238 
1239     /**
1240      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1241      *
1242      * @param from address representing the previous owner of the given token ID
1243      * @param to target address that will receive the tokens
1244      * @param tokenId uint256 ID of the token to be transferred
1245      * @param _data bytes optional data to send along with the call
1246      * @return bool whether the call correctly returned the expected magic value
1247      */
1248     function _checkContractOnERC721Received(
1249         address from,
1250         address to,
1251         uint256 tokenId,
1252         bytes memory _data
1253     ) private returns (bool) {
1254         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1255             return retval == IERC721Receiver(to).onERC721Received.selector;
1256         } catch (bytes memory reason) {
1257             if (reason.length == 0) {
1258                 revert TransferToNonERC721ReceiverImplementer();
1259             } else {
1260                 assembly {
1261                     revert(add(32, reason), mload(reason))
1262                 }
1263             }
1264         }
1265     }
1266 
1267     /**
1268      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1269      * And also called before burning one token.
1270      *
1271      * startTokenId - the first token id to be transferred
1272      * quantity - the amount to be transferred
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` will be minted for `to`.
1279      * - When `to` is zero, `tokenId` will be burned by `from`.
1280      * - `from` and `to` are never both zero.
1281      */
1282     function _beforeTokenTransfers(
1283         address from,
1284         address to,
1285         uint256 startTokenId,
1286         uint256 quantity
1287     ) internal virtual {}
1288 
1289     /**
1290      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1291      * minting.
1292      * And also called after one token has been burned.
1293      *
1294      * startTokenId - the first token id to be transferred
1295      * quantity - the amount to be transferred
1296      *
1297      * Calling conditions:
1298      *
1299      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1300      * transferred to `to`.
1301      * - When `from` is zero, `tokenId` has been minted for `to`.
1302      * - When `to` is zero, `tokenId` has been burned by `from`.
1303      * - `from` and `to` are never both zero.
1304      */
1305     function _afterTokenTransfers(
1306         address from,
1307         address to,
1308         uint256 startTokenId,
1309         uint256 quantity
1310     ) internal virtual {}
1311 }
1312 
1313 // File: Ownable.sol
1314 
1315 
1316 
1317 pragma solidity >=0.7.0 <0.9.0;
1318 
1319 
1320 
1321 contract okaypunksyachtclub is ERC721A, Ownable {
1322   using Strings for uint256;
1323 
1324   string baseURI;
1325   string notRevURI;
1326   string public baseExtension = ".json";
1327   uint256 public cost = 0.005 ether;
1328   uint256 public maxSupply = 6000;
1329   uint256 public maxMintAmount = 2;
1330   uint256 public freeAmount = 0;
1331 
1332   bool public paused = false;
1333   bool public revealed = true;
1334   mapping(address => uint256) nftPerWallet;
1335 
1336   constructor(
1337     string memory _initBaseURI,
1338     string memory _initNotRevURI
1339   ) ERC721A("Okay Punks Yacht Club", "OPYC") {
1340     setBaseURI(_initBaseURI);
1341     notRevURI = _initNotRevURI;
1342   }
1343 
1344  modifier checks(uint256 _mintAmount) {
1345     require(!paused);
1346     require(_mintAmount > 0);
1347     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1348     require(nftPerWallet[msg.sender] < 20, "You can't posses more than 20");
1349 
1350     if(totalSupply() >= freeAmount){
1351         if(msg.sender != owner()) require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1352         nftPerWallet[msg.sender]++;
1353     }
1354     else require(totalSupply() + _mintAmount <= freeAmount, "Free NFTs amount exceeded");
1355     require(_mintAmount <= maxMintAmount, "Max mint amount exceeded");
1356     _;
1357   }
1358 
1359   function mint(uint256 _mintAmount) public payable checks(_mintAmount) {
1360       _safeMint(msg.sender, _mintAmount);
1361   }
1362 
1363   function _baseURI() internal view virtual override returns (string memory) {
1364     return baseURI;
1365   }
1366 
1367   function tokenURI(uint256 tokenId)
1368     public
1369     view
1370     virtual
1371     override
1372     returns (string memory)
1373   {
1374     require(
1375       _exists(tokenId),
1376       "ERC721Metadata: URI query for nonexistent token"
1377     );
1378 
1379     if(!revealed){
1380       return notRevURI;
1381     }
1382 
1383     string memory currentBaseURI = _baseURI();
1384     return bytes(currentBaseURI).length > 0
1385         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1386         : "";
1387   }
1388 
1389   function setCost(uint256 _newCost) public onlyOwner {
1390     cost = _newCost;
1391   }
1392 
1393   function reveal() public onlyOwner {
1394     revealed = true;
1395   }
1396 
1397   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1398     maxMintAmount = _newmaxMintAmount;
1399   }
1400 
1401   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1402     baseURI = _newBaseURI;
1403   }
1404 
1405   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1406     baseExtension = _newBaseExtension;
1407   }
1408 
1409   function pause() public onlyOwner {
1410     paused = !paused;
1411   }
1412  
1413   function withdraw() public payable onlyOwner {
1414     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1415     require(os);
1416   }
1417 }