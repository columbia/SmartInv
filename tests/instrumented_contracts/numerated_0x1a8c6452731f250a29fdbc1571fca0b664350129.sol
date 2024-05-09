1 //SPDX-License-Identifier: MIT
2 //File: @openzeppelin/contracts/utils/Strings.sol
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
636 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
646  * @dev See https://eips.ethereum.org/EIPS/eip-721
647  */
648 interface IERC721Metadata is IERC721 {
649     /**
650      * @dev Returns the token collection name.
651      */
652     function name() external view returns (string memory);
653 
654     /**
655      * @dev Returns the token collection symbol.
656      */
657     function symbol() external view returns (string memory);
658 
659     /**
660      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
661      */
662     function tokenURI(uint256 tokenId) external view returns (string memory);
663 }
664 
665 // File: erc721a/contracts/ERC721A.sol
666 
667 
668 // Creator: Chiru Labs
669 
670 pragma solidity ^0.8.4;
671 
672 
673 
674 
675 
676 
677 
678 
679 error ApprovalCallerNotOwnerNorApproved();
680 error ApprovalQueryForNonexistentToken();
681 error ApproveToCaller();
682 error ApprovalToCurrentOwner();
683 error BalanceQueryForZeroAddress();
684 error MintToZeroAddress();
685 error MintZeroQuantity();
686 error OwnerQueryForNonexistentToken();
687 error TransferCallerNotOwnerNorApproved();
688 error TransferFromIncorrectOwner();
689 error TransferToNonERC721ReceiverImplementer();
690 error TransferToZeroAddress();
691 error URIQueryForNonexistentToken();
692 
693 /**
694  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
695  * the Metadata extension. Built to optimize for lower gas during batch mints.
696  *
697  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
698  *
699  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
700  *
701  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
702  */
703 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
704     using Address for address;
705     using Strings for uint256;
706 
707     // Compiler will pack this into a single 256bit word.
708     struct TokenOwnership {
709         // The address of the owner.
710         address addr;
711         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
712         uint64 startTimestamp;
713         // Whether the token has been burned.
714         bool burned;
715     }
716 
717     // Compiler will pack this into a single 256bit word.
718     struct AddressData {
719         // Realistically, 2**64-1 is more than enough.
720         uint64 balance;
721         // Keeps track of mint count with minimal overhead for tokenomics.
722         uint64 numberMinted;
723         // Keeps track of burn count with minimal overhead for tokenomics.
724         uint64 numberBurned;
725         // For miscellaneous variable(s) pertaining to the address
726         // (e.g. number of whitelist mint slots used).
727         // If there are multiple variables, please pack them into a uint64.
728         uint64 aux;
729     }
730 
731     // The tokenId of the next token to be minted.
732     uint256 internal _currentIndex;
733 
734     // The number of tokens burned.
735     uint256 internal _burnCounter;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to ownership details
744     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
745     mapping(uint256 => TokenOwnership) internal _ownerships;
746 
747     // Mapping owner address to address data
748     mapping(address => AddressData) private _addressData;
749 
750     // Mapping from token ID to approved address
751     mapping(uint256 => address) private _tokenApprovals;
752 
753     // Mapping from owner to operator approvals
754     mapping(address => mapping(address => bool)) private _operatorApprovals;
755 
756     constructor(string memory name_, string memory symbol_) {
757         _name = name_;
758         _symbol = symbol_;
759         _currentIndex = _startTokenId();
760     }
761 
762     /**
763      * To change the starting tokenId, please override this function.
764      */
765     function _startTokenId() internal view virtual returns (uint256) {
766         return 0;
767     }
768 
769     /**
770      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
771      */
772     function totalSupply() public view returns (uint256) {
773         // Counter underflow is impossible as _burnCounter cannot be incremented
774         // more than _currentIndex - _startTokenId() times
775         unchecked {
776             return _currentIndex - _burnCounter - _startTokenId();
777         }
778     }
779 
780     /**
781      * Returns the total amount of tokens minted in the contract.
782      */
783     function _totalMinted() internal view returns (uint256) {
784         // Counter underflow is impossible as _currentIndex does not decrement,
785         // and it is initialized to _startTokenId()
786         unchecked {
787             return _currentIndex - _startTokenId();
788         }
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
795         return
796             interfaceId == type(IERC721).interfaceId ||
797             interfaceId == type(IERC721Metadata).interfaceId ||
798             super.supportsInterface(interfaceId);
799     }
800 
801     /**
802      * @dev See {IERC721-balanceOf}.
803      */
804     function balanceOf(address owner) public view override returns (uint256) {
805         if (owner == address(0)) revert BalanceQueryForZeroAddress();
806         return uint256(_addressData[owner].balance);
807     }
808 
809     /**
810      * Returns the number of tokens minted by `owner`.
811      */
812     function _numberMinted(address owner) internal view returns (uint256) {
813         return uint256(_addressData[owner].numberMinted);
814     }
815 
816     /**
817      * Returns the number of tokens burned by or on behalf of `owner`.
818      */
819     function _numberBurned(address owner) internal view returns (uint256) {
820         return uint256(_addressData[owner].numberBurned);
821     }
822 
823     /**
824      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
825      */
826     function _getAux(address owner) internal view returns (uint64) {
827         return _addressData[owner].aux;
828     }
829 
830     /**
831      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
832      * If there are multiple variables, please pack them into a uint64.
833      */
834     function _setAux(address owner, uint64 aux) internal {
835         _addressData[owner].aux = aux;
836     }
837 
838     /**
839      * Gas spent here starts off proportional to the maximum mint batch size.
840      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
841      */
842     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
843         uint256 curr = tokenId;
844 
845         unchecked {
846             if (_startTokenId() <= curr && curr < _currentIndex) {
847                 TokenOwnership memory ownership = _ownerships[curr];
848                 if (!ownership.burned) {
849                     if (ownership.addr != address(0)) {
850                         return ownership;
851                     }
852                     // Invariant:
853                     // There will always be an ownership that has an address and is not burned
854                     // before an ownership that does not have an address and is not burned.
855                     // Hence, curr will not underflow.
856                     while (true) {
857                         curr--;
858                         ownership = _ownerships[curr];
859                         if (ownership.addr != address(0)) {
860                             return ownership;
861                         }
862                     }
863                 }
864             }
865         }
866         revert OwnerQueryForNonexistentToken();
867     }
868 
869     /**
870      * @dev See {IERC721-ownerOf}.
871      */
872     function ownerOf(uint256 tokenId) public view override returns (address) {
873         return _ownershipOf(tokenId).addr;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-name}.
878      */
879     function name() public view virtual override returns (string memory) {
880         return _name;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-symbol}.
885      */
886     function symbol() public view virtual override returns (string memory) {
887         return _symbol;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-tokenURI}.
892      */
893     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
894         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
895 
896         string memory baseURI = _baseURI();
897         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
898     }
899 
900     /**
901      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
902      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
903      * by default, can be overriden in child contracts.
904      */
905     function _baseURI() internal view virtual returns (string memory) {
906         return '';
907     }
908 
909     /**
910      * @dev See {IERC721-approve}.
911      */
912     function approve(address to, uint256 tokenId) public override {
913         address owner = ERC721A.ownerOf(tokenId);
914         if (to == owner) revert ApprovalToCurrentOwner();
915 
916         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
917             revert ApprovalCallerNotOwnerNorApproved();
918         }
919 
920         _approve(to, tokenId, owner);
921     }
922 
923     /**
924      * @dev See {IERC721-getApproved}.
925      */
926     function getApproved(uint256 tokenId) public view override returns (address) {
927         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
928 
929         return _tokenApprovals[tokenId];
930     }
931 
932     /**
933      * @dev See {IERC721-setApprovalForAll}.
934      */
935     function setApprovalForAll(address operator, bool approved) public virtual override {
936         if (operator == _msgSender()) revert ApproveToCaller();
937 
938         _operatorApprovals[_msgSender()][operator] = approved;
939         emit ApprovalForAll(_msgSender(), operator, approved);
940     }
941 
942     /**
943      * @dev See {IERC721-isApprovedForAll}.
944      */
945     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
946         return _operatorApprovals[owner][operator];
947     }
948 
949     /**
950      * @dev See {IERC721-transferFrom}.
951      */
952     function transferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         _transfer(from, to, tokenId);
958     }
959 
960     /**
961      * @dev See {IERC721-safeTransferFrom}.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId
967     ) public virtual override {
968         safeTransferFrom(from, to, tokenId, '');
969     }
970 
971     /**
972      * @dev See {IERC721-safeTransferFrom}.
973      */
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) public virtual override {
980         _transfer(from, to, tokenId);
981         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
982             revert TransferToNonERC721ReceiverImplementer();
983         }
984     }
985 
986     /**
987      * @dev Returns whether `tokenId` exists.
988      *
989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
990      *
991      * Tokens start existing when they are minted (`_mint`),
992      */
993     function _exists(uint256 tokenId) internal view returns (bool) {
994         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
995             !_ownerships[tokenId].burned;
996     }
997 
998     function _safeMint(address to, uint256 quantity) internal {
999         _safeMint(to, quantity, '');
1000     }
1001 
1002     /**
1003      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1008      * - `quantity` must be greater than 0.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _safeMint(
1013         address to,
1014         uint256 quantity,
1015         bytes memory _data
1016     ) internal {
1017         _mint(to, quantity, _data, true);
1018     }
1019 
1020     /**
1021      * @dev Mints `quantity` tokens and transfers them to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `quantity` must be greater than 0.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _mint(
1031         address to,
1032         uint256 quantity,
1033         bytes memory _data,
1034         bool safe
1035     ) internal {
1036         uint256 startTokenId = _currentIndex;
1037         if (to == address(0)) revert MintToZeroAddress();
1038         if (quantity == 0) revert MintZeroQuantity();
1039 
1040         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1041 
1042         // Overflows are incredibly unrealistic.
1043         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1044         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1045         unchecked {
1046             _addressData[to].balance += uint64(quantity);
1047             _addressData[to].numberMinted += uint64(quantity);
1048 
1049             _ownerships[startTokenId].addr = to;
1050             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1051 
1052             uint256 updatedIndex = startTokenId;
1053             uint256 end = updatedIndex + quantity;
1054 
1055             if (safe && to.isContract()) {
1056                 do {
1057                     emit Transfer(address(0), to, updatedIndex);
1058                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1059                         revert TransferToNonERC721ReceiverImplementer();
1060                     }
1061                 } while (updatedIndex != end);
1062                 // Reentrancy protection
1063                 if (_currentIndex != startTokenId) revert();
1064             } else {
1065                 do {
1066                     emit Transfer(address(0), to, updatedIndex++);
1067                 } while (updatedIndex != end);
1068             }
1069             _currentIndex = updatedIndex;
1070         }
1071         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1072     }
1073 
1074     /**
1075      * @dev Transfers `tokenId` from `from` to `to`.
1076      *
1077      * Requirements:
1078      *
1079      * - `to` cannot be the zero address.
1080      * - `tokenId` token must be owned by `from`.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _transfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) private {
1089         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1090 
1091         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1092 
1093         bool isApprovedOrOwner = (_msgSender() == from ||
1094             isApprovedForAll(from, _msgSender()) ||
1095             getApproved(tokenId) == _msgSender());
1096 
1097         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1098         if (to == address(0)) revert TransferToZeroAddress();
1099 
1100         _beforeTokenTransfers(from, to, tokenId, 1);
1101 
1102         // Clear approvals from the previous owner
1103         _approve(address(0), tokenId, from);
1104 
1105         // Underflow of the sender's balance is impossible because we check for
1106         // ownership above and the recipient's balance can't realistically overflow.
1107         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1108         unchecked {
1109             _addressData[from].balance -= 1;
1110             _addressData[to].balance += 1;
1111 
1112             TokenOwnership storage currSlot = _ownerships[tokenId];
1113             currSlot.addr = to;
1114             currSlot.startTimestamp = uint64(block.timestamp);
1115 
1116             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1117             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1118             uint256 nextTokenId = tokenId + 1;
1119             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1120             if (nextSlot.addr == address(0)) {
1121                 // This will suffice for checking _exists(nextTokenId),
1122                 // as a burned slot cannot contain the zero address.
1123                 if (nextTokenId != _currentIndex) {
1124                     nextSlot.addr = from;
1125                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1126                 }
1127             }
1128         }
1129 
1130         emit Transfer(from, to, tokenId);
1131         _afterTokenTransfers(from, to, tokenId, 1);
1132     }
1133 
1134     /**
1135      * @dev This is equivalent to _burn(tokenId, false)
1136      */
1137     function _burn(uint256 tokenId) internal virtual {
1138         _burn(tokenId, false);
1139     }
1140 
1141     /**
1142      * @dev Destroys `tokenId`.
1143      * The approval is cleared when the token is burned.
1144      *
1145      * Requirements:
1146      *
1147      * - `tokenId` must exist.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1152         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1153 
1154         address from = prevOwnership.addr;
1155 
1156         if (approvalCheck) {
1157             bool isApprovedOrOwner = (_msgSender() == from ||
1158                 isApprovedForAll(from, _msgSender()) ||
1159                 getApproved(tokenId) == _msgSender());
1160 
1161             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1162         }
1163 
1164         _beforeTokenTransfers(from, address(0), tokenId, 1);
1165 
1166         // Clear approvals from the previous owner
1167         _approve(address(0), tokenId, from);
1168 
1169         // Underflow of the sender's balance is impossible because we check for
1170         // ownership above and the recipient's balance can't realistically overflow.
1171         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1172         unchecked {
1173             AddressData storage addressData = _addressData[from];
1174             addressData.balance -= 1;
1175             addressData.numberBurned += 1;
1176 
1177             // Keep track of who burned the token, and the timestamp of burning.
1178             TokenOwnership storage currSlot = _ownerships[tokenId];
1179             currSlot.addr = from;
1180             currSlot.startTimestamp = uint64(block.timestamp);
1181             currSlot.burned = true;
1182 
1183             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1184             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1185             uint256 nextTokenId = tokenId + 1;
1186             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1187             if (nextSlot.addr == address(0)) {
1188                 // This will suffice for checking _exists(nextTokenId),
1189                 // as a burned slot cannot contain the zero address.
1190                 if (nextTokenId != _currentIndex) {
1191                     nextSlot.addr = from;
1192                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1193                 }
1194             }
1195         }
1196 
1197         emit Transfer(from, address(0), tokenId);
1198         _afterTokenTransfers(from, address(0), tokenId, 1);
1199 
1200         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1201         unchecked {
1202             _burnCounter++;
1203         }
1204     }
1205 
1206     /**
1207      * @dev Approve `to` to operate on `tokenId`
1208      *
1209      * Emits a {Approval} event.
1210      */
1211     function _approve(
1212         address to,
1213         uint256 tokenId,
1214         address owner
1215     ) private {
1216         _tokenApprovals[tokenId] = to;
1217         emit Approval(owner, to, tokenId);
1218     }
1219 
1220     /**
1221      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1222      *
1223      * @param from address representing the previous owner of the given token ID
1224      * @param to target address that will receive the tokens
1225      * @param tokenId uint256 ID of the token to be transferred
1226      * @param _data bytes optional data to send along with the call
1227      * @return bool whether the call correctly returned the expected magic value
1228      */
1229     function _checkContractOnERC721Received(
1230         address from,
1231         address to,
1232         uint256 tokenId,
1233         bytes memory _data
1234     ) private returns (bool) {
1235         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1236             return retval == IERC721Receiver(to).onERC721Received.selector;
1237         } catch (bytes memory reason) {
1238             if (reason.length == 0) {
1239                 revert TransferToNonERC721ReceiverImplementer();
1240             } else {
1241                 assembly {
1242                     revert(add(32, reason), mload(reason))
1243                 }
1244             }
1245         }
1246     }
1247 
1248     /**
1249      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1250      * And also called before burning one token.
1251      *
1252      * startTokenId - the first token id to be transferred
1253      * quantity - the amount to be transferred
1254      *
1255      * Calling conditions:
1256      *
1257      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1258      * transferred to `to`.
1259      * - When `from` is zero, `tokenId` will be minted for `to`.
1260      * - When `to` is zero, `tokenId` will be burned by `from`.
1261      * - `from` and `to` are never both zero.
1262      */
1263     function _beforeTokenTransfers(
1264         address from,
1265         address to,
1266         uint256 startTokenId,
1267         uint256 quantity
1268     ) internal virtual {}
1269 
1270     /**
1271      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1272      * minting.
1273      * And also called after one token has been burned.
1274      *
1275      * startTokenId - the first token id to be transferred
1276      * quantity - the amount to be transferred
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` has been minted for `to`.
1283      * - When `to` is zero, `tokenId` has been burned by `from`.
1284      * - `from` and `to` are never both zero.
1285      */
1286     function _afterTokenTransfers(
1287         address from,
1288         address to,
1289         uint256 startTokenId,
1290         uint256 quantity
1291     ) internal virtual {}
1292 }
1293 
1294 // File: contracts/testerc721a.sol
1295 
1296 
1297 pragma solidity ^0.8.4;
1298 
1299 
1300 
1301 
1302 
1303 
1304 
1305 
1306 
1307 
1308 contract testerc721a is ERC721A, Ownable {
1309     uint256 public MAX_MINTS = 3;
1310     uint256 public MAX_SUPPLY = 7777;
1311     uint256 public firstMintRate = 0.003 ether;
1312     uint256 public secondMintRate = 0.007 ether;
1313     
1314 
1315     bool public paused = true; 
1316     bool public revealed = true;
1317 
1318     string public baseURI = "ipfs://QmZjr2DJRtQWE44tHx1yFuyJ8vHumXwtTtt3wTJyHYdHfu/";
1319     string public notRevealedBaseUri = "";
1320     string public baseExtension = ".json";
1321 
1322     address[] public whitelistedAddresses;
1323 
1324     constructor() ERC721A("Cryptoguzgan", "CGZN") {}
1325 
1326     function mint(uint256 quantity) external payable {
1327         // _safeMint's second argument now takes in a quantity, not a tokenId.
1328         uint256 mintedTokens = balanceOf(msg.sender);
1329         if(msg.sender != owner()){
1330             require(!paused, "Contract is PAUSED");
1331             require(quantity + balanceOf(msg.sender) <= MAX_MINTS, "Exceeded the minting limit");
1332             require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1333             require(msg.value >= needToUpdateCost(mintedTokens,quantity),"Not enough Ether sent");
1334 
1335             
1336         }
1337         _safeMint(msg.sender, quantity);
1338 
1339     }
1340 
1341 
1342 
1343     function _baseURI() internal view override returns (string memory) {
1344         if(revealed == true){
1345             return baseURI; 
1346         } else{
1347             return notRevealedBaseUri; 
1348         }
1349         
1350     }
1351 
1352     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1353         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1354 
1355         string memory currentBaseUri;
1356         string memory currentExtension;
1357         if (revealed == true){
1358             currentBaseUri = baseURI;
1359             currentExtension = Strings.toString(tokenId + 1);
1360         }else{
1361             currentBaseUri = notRevealedBaseUri;
1362             currentExtension = "hiddden";
1363         }
1364         return bytes(currentBaseUri).length != 0 ? string(abi.encodePacked(currentBaseUri,currentExtension,baseExtension)) : '';
1365     }
1366     //Minting costs
1367 
1368     function needToUpdateCost(uint256 _minted, uint256 _quantity) internal view returns (uint256 _cost) {
1369         if(_minted == 0){
1370             if(_quantity == 1){
1371                 return 0 ether;
1372             }else if(_quantity == 2){
1373                 return firstMintRate;
1374             }else{
1375                 return firstMintRate + secondMintRate;
1376             }
1377         }else if(_minted == 1){
1378             if(_quantity == 1){
1379                 return firstMintRate;
1380             }else if(_quantity == 2){
1381                 return firstMintRate + secondMintRate;
1382             }
1383         }else{
1384             return secondMintRate;
1385         }
1386     }
1387     function setMintAmount(uint256 _mintAmount) public onlyOwner {
1388         MAX_MINTS = _mintAmount;
1389     }
1390     function setFirstMintRate(uint256 _mintAmount) public onlyOwner {
1391         firstMintRate = _mintAmount;
1392     }
1393     function setSecondMintRate(uint256 _mintAmount) public onlyOwner {
1394         secondMintRate = _mintAmount;
1395     }
1396 
1397     //baseuri changes
1398     function setBaseUri(string memory _newbaseURI) public onlyOwner {
1399         baseURI = _newbaseURI;
1400     }
1401     function setBaseUriNotReveal(string memory _newbaseURI) public onlyOwner {
1402         notRevealedBaseUri = _newbaseURI;
1403     }
1404     //complex chnages (whitelist,teamwhitelist)
1405 
1406     //bool values
1407     function pause(bool _state) public onlyOwner {
1408     paused = _state;
1409   }
1410 
1411     function reveal() public onlyOwner {
1412     revealed = true;
1413   }
1414   //functions
1415 
1416 
1417     function withdraw() external payable onlyOwner {
1418         payable(address(owner())).transfer(address(this).balance);
1419         
1420     }
1421 }