1 // SPDX-License-Identifier: GPL-3.0
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
696 // File: erc721a/contracts/ERC721A.sol
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
711     error ApprovalCallerNotOwnerNorApproved();
712     error ApprovalQueryForNonexistentToken();
713     error ApproveToCaller();
714     error ApprovalToCurrentOwner();
715     error BalanceQueryForZeroAddress();
716     error MintedQueryForZeroAddress();
717     error BurnedQueryForZeroAddress();
718     error MintToZeroAddress();
719     error MintZeroQuantity();
720     error OwnerIndexOutOfBounds();
721     error OwnerQueryForNonexistentToken();
722     error TokenIndexOutOfBounds();
723     error TransferCallerNotOwnerNorApproved();
724     error TransferFromIncorrectOwner();
725     error TransferToNonERC721ReceiverImplementer();
726     error TransferToZeroAddress();
727     error URIQueryForNonexistentToken();
728 
729 /**
730  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
731  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
732  *
733  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
734  *
735  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
736  *
737  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
738  */
739 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
740     using Address for address;
741     using Strings for uint256;
742 
743     // Compiler will pack this into a single 256bit word.
744     struct TokenOwnership {
745         // The address of the owner.
746         address addr;
747         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
748         uint64 startTimestamp;
749         // Whether the token has been burned.
750         bool burned;
751     }
752 
753     // Compiler will pack this into a single 256bit word.
754     struct AddressData {
755         // Realistically, 2**64-1 is more than enough.
756         uint64 balance;
757         // Keeps track of mint count with minimal overhead for tokenomics.
758         uint64 numberMinted;
759         // Keeps track of burn count with minimal overhead for tokenomics.
760         uint64 numberBurned;
761     }
762 
763     // Compiler will pack the following
764     // _currentIndex and _burnCounter into a single 256bit word.
765 
766     // The tokenId of the next token to be minted.
767     uint128 internal _currentIndex;
768 
769     // The number of tokens burned.
770     uint128 internal _burnCounter;
771 
772     // Token name
773     string private _name;
774 
775     // Token symbol
776     string private _symbol;
777 
778     // Mapping from token ID to ownership details
779     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
780     mapping(uint256 => TokenOwnership) internal _ownerships;
781 
782     // Mapping owner address to address data
783     mapping(address => AddressData) private _addressData;
784 
785     // Mapping from token ID to approved address
786     mapping(uint256 => address) private _tokenApprovals;
787 
788     // Mapping from owner to operator approvals
789     mapping(address => mapping(address => bool)) private _operatorApprovals;
790 
791     constructor(string memory name_, string memory symbol_) {
792         _name = name_;
793         _symbol = symbol_;
794     }
795 
796     /**
797      * @dev See {IERC721Enumerable-totalSupply}.
798      */
799     function totalSupply() public view override returns (uint256) {
800         // Counter underflow is impossible as _burnCounter cannot be incremented
801         // more than _currentIndex times
802     unchecked {
803         return _currentIndex - _burnCounter;
804     }
805     }
806 
807     /**
808      * @dev See {IERC721Enumerable-tokenByIndex}.
809      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
810      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
811      */
812     function tokenByIndex(uint256 index) public view override returns (uint256) {
813         uint256 numMintedSoFar = _currentIndex;
814         uint256 tokenIdsIdx;
815 
816         // Counter overflow is impossible as the loop breaks when
817         // uint256 i is equal to another uint256 numMintedSoFar.
818     unchecked {
819         for (uint256 i; i < numMintedSoFar; i++) {
820             TokenOwnership memory ownership = _ownerships[i];
821             if (!ownership.burned) {
822                 if (tokenIdsIdx == index) {
823                     return i;
824                 }
825                 tokenIdsIdx++;
826             }
827         }
828     }
829         revert TokenIndexOutOfBounds();
830     }
831 
832     /**
833      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
834      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
835      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
836      */
837     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
838         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
839         uint256 numMintedSoFar = _currentIndex;
840         uint256 tokenIdsIdx;
841         address currOwnershipAddr;
842 
843         // Counter overflow is impossible as the loop breaks when
844         // uint256 i is equal to another uint256 numMintedSoFar.
845     unchecked {
846         for (uint256 i; i < numMintedSoFar; i++) {
847             TokenOwnership memory ownership = _ownerships[i];
848             if (ownership.burned) {
849                 continue;
850             }
851             if (ownership.addr != address(0)) {
852                 currOwnershipAddr = ownership.addr;
853             }
854             if (currOwnershipAddr == owner) {
855                 if (tokenIdsIdx == index) {
856                     return i;
857                 }
858                 tokenIdsIdx++;
859             }
860         }
861     }
862 
863         // Execution should never reach this point.
864         revert();
865     }
866 
867     /**
868      * @dev See {IERC165-supportsInterface}.
869      */
870     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
871         return
872         interfaceId == type(IERC721).interfaceId ||
873         interfaceId == type(IERC721Metadata).interfaceId ||
874         interfaceId == type(IERC721Enumerable).interfaceId ||
875         super.supportsInterface(interfaceId);
876     }
877 
878     /**
879      * @dev See {IERC721-balanceOf}.
880      */
881     function balanceOf(address owner) public view override returns (uint256) {
882         if (owner == address(0)) revert BalanceQueryForZeroAddress();
883         return uint256(_addressData[owner].balance);
884     }
885 
886     function _numberMinted(address owner) internal view returns (uint256) {
887         if (owner == address(0)) revert MintedQueryForZeroAddress();
888         return uint256(_addressData[owner].numberMinted);
889     }
890 
891     function _numberBurned(address owner) internal view returns (uint256) {
892         if (owner == address(0)) revert BurnedQueryForZeroAddress();
893         return uint256(_addressData[owner].numberBurned);
894     }
895 
896     /**
897      * Gas spent here starts off proportional to the maximum mint batch size.
898      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
899      */
900     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
901         uint256 curr = tokenId;
902 
903     unchecked {
904         if (curr < _currentIndex) {
905             TokenOwnership memory ownership = _ownerships[curr];
906             if (!ownership.burned) {
907                 if (ownership.addr != address(0)) {
908                     return ownership;
909                 }
910                 // Invariant:
911                 // There will always be an ownership that has an address and is not burned
912                 // before an ownership that does not have an address and is not burned.
913                 // Hence, curr will not underflow.
914                 while (true) {
915                     curr--;
916                     ownership = _ownerships[curr];
917                     if (ownership.addr != address(0)) {
918                         return ownership;
919                     }
920                 }
921             }
922         }
923     }
924         revert OwnerQueryForNonexistentToken();
925     }
926 
927     /**
928      * @dev See {IERC721-ownerOf}.
929      */
930     function ownerOf(uint256 tokenId) public view override returns (address) {
931         return ownershipOf(tokenId).addr;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-name}.
936      */
937     function name() public view virtual override returns (string memory) {
938         return _name;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-symbol}.
943      */
944     function symbol() public view virtual override returns (string memory) {
945         return _symbol;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-tokenURI}.
950      */
951     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
952         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
953 
954         string memory baseURI = _baseURI();
955         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
956     }
957 
958     /**
959      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
960      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
961      * by default, can be overriden in child contracts.
962      */
963     function _baseURI() internal view virtual returns (string memory) {
964         return '';
965     }
966 
967     /**
968      * @dev See {IERC721-approve}.
969      */
970     function approve(address to, uint256 tokenId) public override {
971         address owner = ERC721A.ownerOf(tokenId);
972         if (to == owner) revert ApprovalToCurrentOwner();
973 
974         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
975             revert ApprovalCallerNotOwnerNorApproved();
976         }
977 
978         _approve(to, tokenId, owner);
979     }
980 
981     /**
982      * @dev See {IERC721-getApproved}.
983      */
984     function getApproved(uint256 tokenId) public view override returns (address) {
985         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
986 
987         return _tokenApprovals[tokenId];
988     }
989 
990     /**
991      * @dev See {IERC721-setApprovalForAll}.
992      */
993     function setApprovalForAll(address operator, bool approved) public override {
994         if (operator == _msgSender()) revert ApproveToCaller();
995 
996         _operatorApprovals[_msgSender()][operator] = approved;
997         emit ApprovalForAll(_msgSender(), operator, approved);
998     }
999 
1000     /**
1001      * @dev See {IERC721-isApprovedForAll}.
1002      */
1003     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1004         return _operatorApprovals[owner][operator];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-transferFrom}.
1009      */
1010     function transferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         _transfer(from, to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         safeTransferFrom(from, to, tokenId, '');
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) public virtual override {
1038         _transfer(from, to, tokenId);
1039         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1040             revert TransferToNonERC721ReceiverImplementer();
1041         }
1042     }
1043 
1044     /**
1045      * @dev Returns whether `tokenId` exists.
1046      *
1047      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1048      *
1049      * Tokens start existing when they are minted (`_mint`),
1050      */
1051     function _exists(uint256 tokenId) internal view returns (bool) {
1052         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1053     }
1054 
1055     function _safeMint(address to, uint256 quantity) internal {
1056         _safeMint(to, quantity, '');
1057     }
1058 
1059     /**
1060      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _safeMint(
1070         address to,
1071         uint256 quantity,
1072         bytes memory _data
1073     ) internal {
1074         _mint(to, quantity, _data, true);
1075     }
1076 
1077     /**
1078      * @dev Mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `to` cannot be the zero address.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _mint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data,
1091         bool safe
1092     ) internal {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1101         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1102     unchecked {
1103         _addressData[to].balance += uint64(quantity);
1104         _addressData[to].numberMinted += uint64(quantity);
1105 
1106         _ownerships[startTokenId].addr = to;
1107         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1108 
1109         uint256 updatedIndex = startTokenId;
1110 
1111         for (uint256 i; i < quantity; i++) {
1112             emit Transfer(address(0), to, updatedIndex);
1113             if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1114                 revert TransferToNonERC721ReceiverImplementer();
1115             }
1116             updatedIndex++;
1117         }
1118 
1119         _currentIndex = uint128(updatedIndex);
1120     }
1121         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1122     }
1123 
1124     /**
1125      * @dev Transfers `tokenId` from `from` to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must be owned by `from`.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _transfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) private {
1139         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1140 
1141         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1142         isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1143         getApproved(tokenId) == _msgSender());
1144 
1145         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1146         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1147         if (to == address(0)) revert TransferToZeroAddress();
1148 
1149         _beforeTokenTransfers(from, to, tokenId, 1);
1150 
1151         // Clear approvals from the previous owner
1152         _approve(address(0), tokenId, prevOwnership.addr);
1153 
1154         // Underflow of the sender's balance is impossible because we check for
1155         // ownership above and the recipient's balance can't realistically overflow.
1156         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1157     unchecked {
1158         _addressData[from].balance -= 1;
1159         _addressData[to].balance += 1;
1160 
1161         _ownerships[tokenId].addr = to;
1162         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1163 
1164         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1165         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1166         uint256 nextTokenId = tokenId + 1;
1167         if (_ownerships[nextTokenId].addr == address(0)) {
1168             // This will suffice for checking _exists(nextTokenId),
1169             // as a burned slot cannot contain the zero address.
1170             if (nextTokenId < _currentIndex) {
1171                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1172                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1173             }
1174         }
1175     }
1176 
1177         emit Transfer(from, to, tokenId);
1178         _afterTokenTransfers(from, to, tokenId, 1);
1179     }
1180 
1181     /**
1182      * @dev Destroys `tokenId`.
1183      * The approval is cleared when the token is burned.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must exist.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _burn(uint256 tokenId) internal virtual {
1192         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1193 
1194         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1195 
1196         // Clear approvals from the previous owner
1197         _approve(address(0), tokenId, prevOwnership.addr);
1198 
1199         // Underflow of the sender's balance is impossible because we check for
1200         // ownership above and the recipient's balance can't realistically overflow.
1201         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1202     unchecked {
1203         _addressData[prevOwnership.addr].balance -= 1;
1204         _addressData[prevOwnership.addr].numberBurned += 1;
1205 
1206         // Keep track of who burned the token, and the timestamp of burning.
1207         _ownerships[tokenId].addr = prevOwnership.addr;
1208         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1209         _ownerships[tokenId].burned = true;
1210 
1211         // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1212         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1213         uint256 nextTokenId = tokenId + 1;
1214         if (_ownerships[nextTokenId].addr == address(0)) {
1215             // This will suffice for checking _exists(nextTokenId),
1216             // as a burned slot cannot contain the zero address.
1217             if (nextTokenId < _currentIndex) {
1218                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1219                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1220             }
1221         }
1222     }
1223 
1224         emit Transfer(prevOwnership.addr, address(0), tokenId);
1225         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1226 
1227         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1228     unchecked {
1229         _burnCounter++;
1230     }
1231     }
1232 
1233     /**
1234      * @dev Approve `to` to operate on `tokenId`
1235      *
1236      * Emits a {Approval} event.
1237      */
1238     function _approve(
1239         address to,
1240         uint256 tokenId,
1241         address owner
1242     ) private {
1243         _tokenApprovals[tokenId] = to;
1244         emit Approval(owner, to, tokenId);
1245     }
1246 
1247     /**
1248      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1249      * The call is not executed if the target address is not a contract.
1250      *
1251      * @param from address representing the previous owner of the given token ID
1252      * @param to target address that will receive the tokens
1253      * @param tokenId uint256 ID of the token to be transferred
1254      * @param _data bytes optional data to send along with the call
1255      * @return bool whether the call correctly returned the expected magic value
1256      */
1257     function _checkOnERC721Received(
1258         address from,
1259         address to,
1260         uint256 tokenId,
1261         bytes memory _data
1262     ) private returns (bool) {
1263         if (to.isContract()) {
1264             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1265                 return retval == IERC721Receiver(to).onERC721Received.selector;
1266             } catch (bytes memory reason) {
1267                 if (reason.length == 0) {
1268                     revert TransferToNonERC721ReceiverImplementer();
1269                 } else {
1270                     assembly {
1271                         revert(add(32, reason), mload(reason))
1272                     }
1273                 }
1274             }
1275         } else {
1276             return true;
1277         }
1278     }
1279 
1280     /**
1281      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1282      * And also called before burning one token.
1283      *
1284      * startTokenId - the first token id to be transferred
1285      * quantity - the amount to be transferred
1286      *
1287      * Calling conditions:
1288      *
1289      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1290      * transferred to `to`.
1291      * - When `from` is zero, `tokenId` will be minted for `to`.
1292      * - When `to` is zero, `tokenId` will be burned by `from`.
1293      * - `from` and `to` are never both zero.
1294      */
1295     function _beforeTokenTransfers(
1296         address from,
1297         address to,
1298         uint256 startTokenId,
1299         uint256 quantity
1300     ) internal virtual {}
1301 
1302     /**
1303      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1304      * minting.
1305      * And also called after one token has been burned.
1306      *
1307      * startTokenId - the first token id to be transferred
1308      * quantity - the amount to be transferred
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` has been minted for `to`.
1315      * - When `to` is zero, `tokenId` has been burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _afterTokenTransfers(
1319         address from,
1320         address to,
1321         uint256 startTokenId,
1322         uint256 quantity
1323     ) internal virtual {}
1324 }
1325 
1326 // File: contracts/LIVE_CONTRACT_FLATTEN.sol
1327 
1328 
1329 
1330 pragma solidity ^0.8.0;
1331 
1332 
1333 
1334 contract FunLovingFleshEaters is ERC721A, Ownable {
1335     using Strings for uint256;
1336 
1337     string public baseURI;
1338     string public baseExtension = ".json";
1339     uint256 private _reserved = 111;
1340     uint256 public cost = 0.0666 ether;
1341     uint256 public maxSupply = 6666;
1342     uint256 public maxMintAmount = 6;
1343     bool public paused = false;
1344     bool public revealed = false;
1345     string public notRevealedURI;
1346     mapping(address => bool) public whitelisted;
1347 
1348     // withdraw addresses
1349     address t1 = 0xb2E496b8101Cf0020ad3Fb6F067607dA730271EB;
1350     address t2 = 0xc012b7DB8538F41077906479d93185f59A7a8d4B;
1351     address t3 = 0x5AB916A42E82329eF5EaC5C97f383172F4433796;
1352 
1353     constructor(
1354         string memory _name,
1355         string memory _symbol,
1356         string memory _initBaseURI,
1357         string memory _initNotRevealedURI
1358     ) ERC721A(_name, _symbol) {
1359         setBaseURI(_initBaseURI);
1360         setNotRevealedURI(_initNotRevealedURI);
1361         _safeMint( t1, 1);
1362         _safeMint( t2, 1);
1363         _safeMint( t3, 1);
1364     }
1365 
1366     // internal
1367     function _baseURI() internal view virtual override returns (string memory) {
1368         return baseURI;
1369     }
1370 
1371     // public
1372     function mint(address _to, uint256 _mintAmount) public payable {
1373         uint256 supply = totalSupply();
1374         require(!paused, "Mint is paused");
1375         require(_mintAmount > 0, "Mint amount not greater than zero");
1376         require(_mintAmount <= maxMintAmount, "Mint amount greater than max mint amount");
1377         require( supply + _mintAmount < 6666 - _reserved,      "Exceeds maximum FLFE supply" );
1378         require(supply + _mintAmount <= maxSupply, "Suppy + mint amount greater than max supply");
1379 
1380         if (msg.sender != owner()) {
1381             if(whitelisted[msg.sender] != true) {
1382                 require(msg.value >= cost * _mintAmount, "Not enough eth sent to cover mint costs");
1383             }
1384         }
1385 
1386         _safeMint(_to, _mintAmount);
1387 
1388     }
1389 
1390     function walletOfOwner(address _owner)
1391     public
1392     view
1393     returns (uint256[] memory)
1394     {
1395         uint256 ownerTokenCount = balanceOf(_owner);
1396         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1397         for (uint256 i; i < ownerTokenCount; i++) {
1398             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1399         }
1400         return tokenIds;
1401     }
1402 
1403     function tokenURI(uint256 tokenId)
1404     public
1405     view
1406     virtual
1407     override
1408     returns (string memory)
1409     {
1410         require(
1411             _exists(tokenId),
1412             "ERC721Metadata: URI query for nonexistent token"
1413         );
1414         if (revealed == false) {
1415             return notRevealedURI;
1416         }
1417 
1418         string memory currentBaseURI = _baseURI();
1419         return bytes(currentBaseURI).length > 0
1420         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1421         : "";
1422     }
1423 
1424     //only owner
1425     function reveal() public onlyOwner {
1426         revealed = true;
1427     }
1428 
1429     function setCost(uint256 _newCost) public onlyOwner {
1430         cost = _newCost;
1431     }
1432 
1433     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1434         maxMintAmount = _newmaxMintAmount;
1435     }
1436 
1437     function setNotRevealedURI(string memory _newNotRevealedURI) public onlyOwner {
1438         notRevealedURI = _newNotRevealedURI;
1439     }
1440 
1441     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1442         baseURI = _newBaseURI;
1443     }
1444 
1445     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1446         baseExtension = _newBaseExtension;
1447     }
1448 
1449     function pause(bool _state) public onlyOwner {
1450         paused = _state;
1451     }
1452 
1453     function whitelistUser(address _user) public onlyOwner {
1454         whitelisted[_user] = true;
1455     }
1456 
1457     function removeWhitelistUser(address _user) public onlyOwner {
1458         whitelisted[_user] = false;
1459     }
1460 
1461     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1462         require( _amount <= _reserved, "Exceeds reserved FLFE supply" );
1463 
1464         _safeMint(_to, _amount);
1465 
1466         _reserved -= _amount;
1467     }
1468 
1469     function withdraw() public payable onlyOwner {
1470         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1471         require(os, "Withdraw function");
1472     }
1473 }