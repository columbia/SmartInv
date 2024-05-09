1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-06
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
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
107 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
137      * @dev Returns the address of the current owner.
138      */
139     function owner() public view virtual returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         require(owner() == _msgSender(), "Ownable: caller is not the owner");
148         _;
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public virtual onlyOwner {
159         _transferOwnership(address(0));
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Can only be called by the current owner.
165      */
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         _transferOwnership(newOwner);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Internal function without access restriction.
174      */
175     function _transferOwnership(address newOwner) internal virtual {
176         address oldOwner = _owner;
177         _owner = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 // File: @openzeppelin/contracts/utils/Address.sol
183 
184 
185 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
186 
187 pragma solidity ^0.8.1;
188 
189 /**
190  * @dev Collection of functions related to the address type
191  */
192 library Address {
193     /**
194      * @dev Returns true if `account` is a contract.
195      *
196      * [IMPORTANT]
197      * ====
198      * It is unsafe to assume that an address for which this function returns
199      * false is an externally-owned account (EOA) and not a contract.
200      *
201      * Among others, `isContract` will return false for the following
202      * types of addresses:
203      *
204      *  - an externally-owned account
205      *  - a contract in construction
206      *  - an address where a contract will be created
207      *  - an address where a contract lived, but was destroyed
208      * ====
209      *
210      * [IMPORTANT]
211      * ====
212      * You shouldn't rely on `isContract` to protect against flash loan attacks!
213      *
214      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
215      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
216      * constructor.
217      * ====
218      */
219     function isContract(address account) internal view returns (bool) {
220         // This method relies on extcodesize/address.code.length, which returns 0
221         // for contracts in construction, since the code is only stored at the end
222         // of the constructor execution.
223 
224         return account.code.length > 0;
225     }
226 
227     /**
228      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
229      * `recipient`, forwarding all available gas and reverting on errors.
230      *
231      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
232      * of certain opcodes, possibly making contracts go over the 2300 gas limit
233      * imposed by `transfer`, making them unable to receive funds via
234      * `transfer`. {sendValue} removes this limitation.
235      *
236      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
237      *
238      * IMPORTANT: because control is transferred to `recipient`, care must be
239      * taken to not create reentrancy vulnerabilities. Consider using
240      * {ReentrancyGuard} or the
241      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
242      */
243     function sendValue(address payable recipient, uint256 amount) internal {
244         require(address(this).balance >= amount, "Address: insufficient balance");
245 
246         (bool success, ) = recipient.call{value: amount}("");
247         require(success, "Address: unable to send value, recipient may have reverted");
248     }
249 
250     /**
251      * @dev Performs a Solidity function call using a low level `call`. A
252      * plain `call` is an unsafe replacement for a function call: use this
253      * function instead.
254      *
255      * If `target` reverts with a revert reason, it is bubbled up by this
256      * function (like regular Solidity function calls).
257      *
258      * Returns the raw returned data. To convert to the expected return value,
259      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
260      *
261      * Requirements:
262      *
263      * - `target` must be a contract.
264      * - calling `target` with `data` must not revert.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionCall(target, data, "Address: low-level call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
274      * `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, 0, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but also transferring `value` wei to `target`.
289      *
290      * Requirements:
291      *
292      * - the calling contract must have an ETH balance of at least `value`.
293      * - the called Solidity function must be `payable`.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
307      * with `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(address(this).balance >= value, "Address: insufficient balance for call");
318         require(isContract(target), "Address: call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.call{value: value}(data);
321         return verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
331         return functionStaticCall(target, data, "Address: low-level static call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal view returns (bytes memory) {
345         require(isContract(target), "Address: static call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.staticcall(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
358         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(isContract(target), "Address: delegate call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.delegatecall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
380      * revert reason using the provided one.
381      *
382      * _Available since v4.3._
383      */
384     function verifyCallResult(
385         bool success,
386         bytes memory returndata,
387         string memory errorMessage
388     ) internal pure returns (bytes memory) {
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @title ERC721 token receiver interface
416  * @dev Interface for any contract that wants to support safeTransfers
417  * from ERC721 asset contracts.
418  */
419 interface IERC721Receiver {
420     /**
421      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
422      * by `operator` from `from`, this function is called.
423      *
424      * It must return its Solidity selector to confirm the token transfer.
425      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
426      *
427      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
428      */
429     function onERC721Received(
430         address operator,
431         address from,
432         uint256 tokenId,
433         bytes calldata data
434     ) external returns (bytes4);
435 }
436 
437 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
438 
439 
440 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
441 
442 pragma solidity ^0.8.0;
443 
444 /**
445  * @dev Interface of the ERC165 standard, as defined in the
446  * https://eips.ethereum.org/EIPS/eip-165[EIP].
447  *
448  * Implementers can declare support of contract interfaces, which can then be
449  * queried by others ({ERC165Checker}).
450  *
451  * For an implementation, see {ERC165}.
452  */
453 interface IERC165 {
454     /**
455      * @dev Returns true if this contract implements the interface defined by
456      * `interfaceId`. See the corresponding
457      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
458      * to learn more about how these ids are created.
459      *
460      * This function call must use less than 30 000 gas.
461      */
462     function supportsInterface(bytes4 interfaceId) external view returns (bool);
463 }
464 
465 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 
473 /**
474  * @dev Implementation of the {IERC165} interface.
475  *
476  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
477  * for the additional interface id that will be supported. For example:
478  *
479  * ```solidity
480  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
482  * }
483  * ```
484  *
485  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
486  */
487 abstract contract ERC165 is IERC165 {
488     /**
489      * @dev See {IERC165-supportsInterface}.
490      */
491     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
492         return interfaceId == type(IERC165).interfaceId;
493     }
494 }
495 
496 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
497 
498 
499 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 
504 /**
505  * @dev Required interface of an ERC721 compliant contract.
506  */
507 interface IERC721 is IERC165 {
508     /**
509      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
510      */
511     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
515      */
516     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
520      */
521     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
522 
523     /**
524      * @dev Returns the number of tokens in ``owner``'s account.
525      */
526     function balanceOf(address owner) external view returns (uint256 balance);
527 
528     /**
529      * @dev Returns the owner of the `tokenId` token.
530      *
531      * Requirements:
532      *
533      * - `tokenId` must exist.
534      */
535     function ownerOf(uint256 tokenId) external view returns (address owner);
536 
537     /**
538      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
539      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
540      *
541      * Requirements:
542      *
543      * - `from` cannot be the zero address.
544      * - `to` cannot be the zero address.
545      * - `tokenId` token must exist and be owned by `from`.
546      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
547      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
548      *
549      * Emits a {Transfer} event.
550      */
551     function safeTransferFrom(
552         address from,
553         address to,
554         uint256 tokenId
555     ) external;
556 
557     /**
558      * @dev Transfers `tokenId` token from `from` to `to`.
559      *
560      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
561      *
562      * Requirements:
563      *
564      * - `from` cannot be the zero address.
565      * - `to` cannot be the zero address.
566      * - `tokenId` token must be owned by `from`.
567      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
568      *
569      * Emits a {Transfer} event.
570      */
571     function transferFrom(
572         address from,
573         address to,
574         uint256 tokenId
575     ) external;
576 
577     /**
578      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
579      * The approval is cleared when the token is transferred.
580      *
581      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
582      *
583      * Requirements:
584      *
585      * - The caller must own the token or be an approved operator.
586      * - `tokenId` must exist.
587      *
588      * Emits an {Approval} event.
589      */
590     function approve(address to, uint256 tokenId) external;
591 
592     /**
593      * @dev Returns the account approved for `tokenId` token.
594      *
595      * Requirements:
596      *
597      * - `tokenId` must exist.
598      */
599     function getApproved(uint256 tokenId) external view returns (address operator);
600 
601     /**
602      * @dev Approve or remove `operator` as an operator for the caller.
603      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
604      *
605      * Requirements:
606      *
607      * - The `operator` cannot be the caller.
608      *
609      * Emits an {ApprovalForAll} event.
610      */
611     function setApprovalForAll(address operator, bool _approved) external;
612 
613     /**
614      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
615      *
616      * See {setApprovalForAll}
617      */
618     function isApprovedForAll(address owner, address operator) external view returns (bool);
619 
620     /**
621      * @dev Safely transfers `tokenId` token from `from` to `to`.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must exist and be owned by `from`.
628      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
630      *
631      * Emits a {Transfer} event.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId,
637         bytes calldata data
638     ) external;
639 }
640 
641 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
642 
643 
644 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 
649 /**
650  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
651  * @dev See https://eips.ethereum.org/EIPS/eip-721
652  */
653 interface IERC721Enumerable is IERC721 {
654     /**
655      * @dev Returns the total amount of tokens stored by the contract.
656      */
657     function totalSupply() external view returns (uint256);
658 
659     /**
660      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
661      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
662      */
663     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
664 
665     /**
666      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
667      * Use along with {totalSupply} to enumerate all tokens.
668      */
669     function tokenByIndex(uint256 index) external view returns (uint256);
670 }
671 
672 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 
680 /**
681  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
682  * @dev See https://eips.ethereum.org/EIPS/eip-721
683  */
684 interface IERC721Metadata is IERC721 {
685     /**
686      * @dev Returns the token collection name.
687      */
688     function name() external view returns (string memory);
689 
690     /**
691      * @dev Returns the token collection symbol.
692      */
693     function symbol() external view returns (string memory);
694 
695     /**
696      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
697      */
698     function tokenURI(uint256 tokenId) external view returns (string memory);
699 }
700 
701 // File: erc721a/contracts/ERC721A.sol
702 
703 
704 // Creator: Chiru Labs
705 
706 pragma solidity ^0.8.4;
707 
708 
709 
710 
711 
712 
713 
714 
715 
716 error ApprovalCallerNotOwnerNorApproved();
717 error ApprovalQueryForNonexistentToken();
718 error ApproveToCaller();
719 error ApprovalToCurrentOwner();
720 error BalanceQueryForZeroAddress();
721 error MintedQueryForZeroAddress();
722 error BurnedQueryForZeroAddress();
723 error MintToZeroAddress();
724 error MintZeroQuantity();
725 error OwnerIndexOutOfBounds();
726 error OwnerQueryForNonexistentToken();
727 error TokenIndexOutOfBounds();
728 error TransferCallerNotOwnerNorApproved();
729 error TransferFromIncorrectOwner();
730 error TransferToNonERC721ReceiverImplementer();
731 error TransferToZeroAddress();
732 error URIQueryForNonexistentToken();
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
737  *
738  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
739  *
740  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
741  *
742  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
743  */
744 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
745     using Address for address;
746     using Strings for uint256;
747 
748     // Compiler will pack this into a single 256bit word.
749     struct TokenOwnership {
750         // The address of the owner.
751         address addr;
752         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
753         uint64 startTimestamp;
754         // Whether the token has been burned.
755         bool burned;
756     }
757 
758     // Compiler will pack this into a single 256bit word.
759     struct AddressData {
760         // Realistically, 2**64-1 is more than enough.
761         uint64 balance;
762         // Keeps track of mint count with minimal overhead for tokenomics.
763         uint64 numberMinted;
764         // Keeps track of burn count with minimal overhead for tokenomics.
765         uint64 numberBurned;
766     }
767 
768     // Compiler will pack the following 
769     // _currentIndex and _burnCounter into a single 256bit word.
770     
771     // The tokenId of the next token to be minted.
772     uint128 internal _currentIndex;
773 
774     // The number of tokens burned.
775     uint128 internal _burnCounter;
776 
777     // Token name
778     string private _name;
779 
780     // Token symbol
781     string private _symbol;
782 
783     // Mapping from token ID to ownership details
784     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
785     mapping(uint256 => TokenOwnership) internal _ownerships;
786 
787     // Mapping owner address to address data
788     mapping(address => AddressData) private _addressData;
789 
790     // Mapping from token ID to approved address
791     mapping(uint256 => address) private _tokenApprovals;
792 
793     // Mapping from owner to operator approvals
794     mapping(address => mapping(address => bool)) private _operatorApprovals;
795 
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799     }
800 
801     /**
802      * @dev See {IERC721Enumerable-totalSupply}.
803      */
804     function totalSupply() public view override returns (uint256) {
805         // Counter underflow is impossible as _burnCounter cannot be incremented
806         // more than _currentIndex times
807         unchecked {
808             return _currentIndex - _burnCounter;    
809         }
810     }
811 
812     /**
813      * @dev See {IERC721Enumerable-tokenByIndex}.
814      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
815      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
816      */
817     function tokenByIndex(uint256 index) public view override returns (uint256) {
818         uint256 numMintedSoFar = _currentIndex;
819         uint256 tokenIdsIdx;
820 
821         // Counter overflow is impossible as the loop breaks when
822         // uint256 i is equal to another uint256 numMintedSoFar.
823         unchecked {
824             for (uint256 i; i < numMintedSoFar; i++) {
825                 TokenOwnership memory ownership = _ownerships[i];
826                 if (!ownership.burned) {
827                     if (tokenIdsIdx == index) {
828                         return i;
829                     }
830                     tokenIdsIdx++;
831                 }
832             }
833         }
834         revert TokenIndexOutOfBounds();
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
839      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
840      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
841      */
842     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
843         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
844         uint256 numMintedSoFar = _currentIndex;
845         uint256 tokenIdsIdx;
846         address currOwnershipAddr;
847 
848         // Counter overflow is impossible as the loop breaks when
849         // uint256 i is equal to another uint256 numMintedSoFar.
850         unchecked {
851             for (uint256 i; i < numMintedSoFar; i++) {
852                 TokenOwnership memory ownership = _ownerships[i];
853                 if (ownership.burned) {
854                     continue;
855                 }
856                 if (ownership.addr != address(0)) {
857                     currOwnershipAddr = ownership.addr;
858                 }
859                 if (currOwnershipAddr == owner) {
860                     if (tokenIdsIdx == index) {
861                         return i;
862                     }
863                     tokenIdsIdx++;
864                 }
865             }
866         }
867 
868         // Execution should never reach this point.
869         revert();
870     }
871 
872     /**
873      * @dev See {IERC165-supportsInterface}.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
876         return
877             interfaceId == type(IERC721).interfaceId ||
878             interfaceId == type(IERC721Metadata).interfaceId ||
879             interfaceId == type(IERC721Enumerable).interfaceId ||
880             super.supportsInterface(interfaceId);
881     }
882 
883     /**
884      * @dev See {IERC721-balanceOf}.
885      */
886     function balanceOf(address owner) public view override returns (uint256) {
887         if (owner == address(0)) revert BalanceQueryForZeroAddress();
888         return uint256(_addressData[owner].balance);
889     }
890 
891     function _numberMinted(address owner) internal view returns (uint256) {
892         if (owner == address(0)) revert MintedQueryForZeroAddress();
893         return uint256(_addressData[owner].numberMinted);
894     }
895 
896     function _numberBurned(address owner) internal view returns (uint256) {
897         if (owner == address(0)) revert BurnedQueryForZeroAddress();
898         return uint256(_addressData[owner].numberBurned);
899     }
900 
901     /**
902      * Gas spent here starts off proportional to the maximum mint batch size.
903      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
904      */
905     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
906         uint256 curr = tokenId;
907 
908         unchecked {
909             if (curr < _currentIndex) {
910                 TokenOwnership memory ownership = _ownerships[curr];
911                 if (!ownership.burned) {
912                     if (ownership.addr != address(0)) {
913                         return ownership;
914                     }
915                     // Invariant: 
916                     // There will always be an ownership that has an address and is not burned 
917                     // before an ownership that does not have an address and is not burned.
918                     // Hence, curr will not underflow.
919                     while (true) {
920                         curr--;
921                         ownership = _ownerships[curr];
922                         if (ownership.addr != address(0)) {
923                             return ownership;
924                         }
925                     }
926                 }
927             }
928         }
929         revert OwnerQueryForNonexistentToken();
930     }
931 
932     /**
933      * @dev See {IERC721-ownerOf}.
934      */
935     function ownerOf(uint256 tokenId) public view override returns (address) {
936         return ownershipOf(tokenId).addr;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-name}.
941      */
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-symbol}.
948      */
949     function symbol() public view virtual override returns (string memory) {
950         return _symbol;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-tokenURI}.
955      */
956     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
957         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
958 
959         string memory baseURI = _baseURI();
960         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
961     }
962 
963     /**
964      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
965      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
966      * by default, can be overriden in child contracts.
967      */
968     function _baseURI() internal view virtual returns (string memory) {
969         return '';
970     }
971 
972     /**
973      * @dev See {IERC721-approve}.
974      */
975     function approve(address to, uint256 tokenId) public override {
976         address owner = ERC721A.ownerOf(tokenId);
977         if (to == owner) revert ApprovalToCurrentOwner();
978 
979         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
980             revert ApprovalCallerNotOwnerNorApproved();
981         }
982 
983         _approve(to, tokenId, owner);
984     }
985 
986     /**
987      * @dev See {IERC721-getApproved}.
988      */
989     function getApproved(uint256 tokenId) public view override returns (address) {
990         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
991 
992         return _tokenApprovals[tokenId];
993     }
994 
995     /**
996      * @dev See {IERC721-setApprovalForAll}.
997      */
998     function setApprovalForAll(address operator, bool approved) public override {
999         if (operator == _msgSender()) revert ApproveToCaller();
1000 
1001         _operatorApprovals[_msgSender()][operator] = approved;
1002         emit ApprovalForAll(_msgSender(), operator, approved);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-isApprovedForAll}.
1007      */
1008     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1009         return _operatorApprovals[owner][operator];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-transferFrom}.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         safeTransferFrom(from, to, tokenId, '');
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1045             revert TransferToNonERC721ReceiverImplementer();
1046         }
1047     }
1048 
1049     /**
1050      * @dev Returns whether `tokenId` exists.
1051      *
1052      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1053      *
1054      * Tokens start existing when they are minted (`_mint`),
1055      */
1056     function _exists(uint256 tokenId) internal view returns (bool) {
1057         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1058     }
1059 
1060     function _safeMint(address to, uint256 quantity) internal {
1061         _safeMint(to, quantity, '');
1062     }
1063 
1064     /**
1065      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1070      * - `quantity` must be greater than 0.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeMint(
1075         address to,
1076         uint256 quantity,
1077         bytes memory _data
1078     ) internal {
1079         _mint(to, quantity, _data, true);
1080     }
1081 
1082     /**
1083      * @dev Mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _mint(
1093         address to,
1094         uint256 quantity,
1095         bytes memory _data,
1096         bool safe
1097     ) internal {
1098         uint256 startTokenId = _currentIndex;
1099         if (to == address(0)) revert MintToZeroAddress();
1100         if (quantity == 0) revert MintZeroQuantity();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1106         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1107         unchecked {
1108             _addressData[to].balance += uint64(quantity);
1109             _addressData[to].numberMinted += uint64(quantity);
1110 
1111             _ownerships[startTokenId].addr = to;
1112             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1113 
1114             uint256 updatedIndex = startTokenId;
1115 
1116             for (uint256 i; i < quantity; i++) {
1117                 emit Transfer(address(0), to, updatedIndex);
1118                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1119                     revert TransferToNonERC721ReceiverImplementer();
1120                 }
1121                 updatedIndex++;
1122             }
1123 
1124             _currentIndex = uint128(updatedIndex);
1125         }
1126         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1127     }
1128 
1129     /**
1130      * @dev Transfers `tokenId` from `from` to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - `to` cannot be the zero address.
1135      * - `tokenId` token must be owned by `from`.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _transfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) private {
1144         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1145 
1146         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1147             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1148             getApproved(tokenId) == _msgSender());
1149 
1150         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1151         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1152         if (to == address(0)) revert TransferToZeroAddress();
1153 
1154         _beforeTokenTransfers(from, to, tokenId, 1);
1155 
1156         // Clear approvals from the previous owner
1157         _approve(address(0), tokenId, prevOwnership.addr);
1158 
1159         // Underflow of the sender's balance is impossible because we check for
1160         // ownership above and the recipient's balance can't realistically overflow.
1161         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1162         unchecked {
1163             _addressData[from].balance -= 1;
1164             _addressData[to].balance += 1;
1165 
1166             _ownerships[tokenId].addr = to;
1167             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1170             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1171             uint256 nextTokenId = tokenId + 1;
1172             if (_ownerships[nextTokenId].addr == address(0)) {
1173                 // This will suffice for checking _exists(nextTokenId),
1174                 // as a burned slot cannot contain the zero address.
1175                 if (nextTokenId < _currentIndex) {
1176                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1177                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1178                 }
1179             }
1180         }
1181 
1182         emit Transfer(from, to, tokenId);
1183         _afterTokenTransfers(from, to, tokenId, 1);
1184     }
1185 
1186     /**
1187      * @dev Destroys `tokenId`.
1188      * The approval is cleared when the token is burned.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _burn(uint256 tokenId) internal virtual {
1197         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1198 
1199         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId, prevOwnership.addr);
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1207         unchecked {
1208             _addressData[prevOwnership.addr].balance -= 1;
1209             _addressData[prevOwnership.addr].numberBurned += 1;
1210 
1211             // Keep track of who burned the token, and the timestamp of burning.
1212             _ownerships[tokenId].addr = prevOwnership.addr;
1213             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1214             _ownerships[tokenId].burned = true;
1215 
1216             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1217             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218             uint256 nextTokenId = tokenId + 1;
1219             if (_ownerships[nextTokenId].addr == address(0)) {
1220                 // This will suffice for checking _exists(nextTokenId),
1221                 // as a burned slot cannot contain the zero address.
1222                 if (nextTokenId < _currentIndex) {
1223                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1224                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(prevOwnership.addr, address(0), tokenId);
1230         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1231 
1232         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1233         unchecked { 
1234             _burnCounter++;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Approve `to` to operate on `tokenId`
1240      *
1241      * Emits a {Approval} event.
1242      */
1243     function _approve(
1244         address to,
1245         uint256 tokenId,
1246         address owner
1247     ) private {
1248         _tokenApprovals[tokenId] = to;
1249         emit Approval(owner, to, tokenId);
1250     }
1251 
1252     /**
1253      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1254      * The call is not executed if the target address is not a contract.
1255      *
1256      * @param from address representing the previous owner of the given token ID
1257      * @param to target address that will receive the tokens
1258      * @param tokenId uint256 ID of the token to be transferred
1259      * @param _data bytes optional data to send along with the call
1260      * @return bool whether the call correctly returned the expected magic value
1261      */
1262     function _checkOnERC721Received(
1263         address from,
1264         address to,
1265         uint256 tokenId,
1266         bytes memory _data
1267     ) private returns (bool) {
1268         if (to.isContract()) {
1269             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1270                 return retval == IERC721Receiver(to).onERC721Received.selector;
1271             } catch (bytes memory reason) {
1272                 if (reason.length == 0) {
1273                     revert TransferToNonERC721ReceiverImplementer();
1274                 } else {
1275                     assembly {
1276                         revert(add(32, reason), mload(reason))
1277                     }
1278                 }
1279             }
1280         } else {
1281             return true;
1282         }
1283     }
1284 
1285     /**
1286      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1287      * And also called before burning one token.
1288      *
1289      * startTokenId - the first token id to be transferred
1290      * quantity - the amount to be transferred
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` will be minted for `to`.
1297      * - When `to` is zero, `tokenId` will be burned by `from`.
1298      * - `from` and `to` are never both zero.
1299      */
1300     function _beforeTokenTransfers(
1301         address from,
1302         address to,
1303         uint256 startTokenId,
1304         uint256 quantity
1305     ) internal virtual {}
1306 
1307     /**
1308      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1309      * minting.
1310      * And also called after one token has been burned.
1311      *
1312      * startTokenId - the first token id to be transferred
1313      * quantity - the amount to be transferred
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` has been minted for `to`.
1320      * - When `to` is zero, `tokenId` has been burned by `from`.
1321      * - `from` and `to` are never both zero.
1322      */
1323     function _afterTokenTransfers(
1324         address from,
1325         address to,
1326         uint256 startTokenId,
1327         uint256 quantity
1328     ) internal virtual {}
1329 }
1330 
1331 pragma solidity ^0.8.4;
1332 
1333 contract tinybears is ERC721A, Ownable {
1334     uint256 constant public MAX_MINT = 5555;
1335     uint256 constant public MAX_MINT_PER_TX = 3;
1336     uint256 constant public PRICE = 0 ether;
1337 
1338     string public baseURI = "ipfs://QmVc1myfqTniZtFJ1yVVvd24vZDLWfQj7o4do5a9VXdBtx";
1339     address public stakingAddress;
1340     bool public paused;
1341 
1342     constructor() ERC721A("tinybears", "tb") {}
1343 
1344     function mint(uint256 quantity) external payable {
1345         require(!paused, "Sale is currently paused.");
1346         require(quantity > 0, "Mint quantity less than 0.");
1347         require(totalSupply() + quantity <= MAX_MINT, "Cannot exceed max mint amount.");
1348         require(quantity <= MAX_MINT_PER_TX, "Cannot exeeds 10 quantity per tx.");
1349         require(msg.value >= quantity * PRICE, "Exceeds mint quantity or not enough eth sent");
1350 
1351         _safeMint(msg.sender, quantity);
1352     }
1353 
1354     function adminMint(uint256 quantity) external onlyOwner {
1355         require(totalSupply() + quantity <= MAX_MINT, "Cannot exceed max mint amount");
1356 
1357         _safeMint(msg.sender, quantity);
1358     }
1359 
1360     function whitelistMint(uint256 quantity) external payable {
1361         require(!paused, "Sale is currently paused.");
1362         require(quantity > 0, "Mint quantity less than 0.");
1363         require(totalSupply() + quantity <= MAX_MINT, "Cannot exceed max mint amount.");
1364         require(quantity <= MAX_MINT_PER_TX, "Cannot exeeds 10 quantity per tx.");
1365         require(msg.value >= quantity * PRICE, "Exceeds mint quantity or not enough eth sent");
1366 
1367         _safeMint(msg.sender, quantity);
1368     }
1369 
1370     function setStakingAddress(address newStakingAddress) external onlyOwner {
1371         stakingAddress = newStakingAddress;
1372     }
1373 
1374     function setBaseURI(string calldata uri) external onlyOwner {
1375         baseURI = uri;
1376     }
1377 
1378     function toggleSale() external onlyOwner {
1379         paused = !paused;
1380     }
1381 
1382     function _baseURI() internal view override returns (string memory) {
1383         return baseURI;
1384     }
1385 
1386     function withdraw() external onlyOwner {
1387         payable(owner()).transfer(address(this).balance);
1388     }
1389 }