1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/access/Ownable.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view virtual returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Leaves the contract without owner. It will not be possible to call
149      * `onlyOwner` functions anymore. Can only be called by the current owner.
150      *
151      * NOTE: Renouncing ownership will leave the contract without an owner,
152      * thereby removing any functionality that is only available to the owner.
153      */
154     function renounceOwnership() public virtual onlyOwner {
155         _transferOwnership(address(0));
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
181 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
391 
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
406 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
423      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
495 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
534      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
535      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
536      *
537      * Requirements:
538      *
539      * - `from` cannot be the zero address.
540      * - `to` cannot be the zero address.
541      * - `tokenId` token must exist and be owned by `from`.
542      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
544      *
545      * Emits a {Transfer} event.
546      */
547     function safeTransferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) external;
552 
553     /**
554      * @dev Transfers `tokenId` token from `from` to `to`.
555      *
556      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
564      *
565      * Emits a {Transfer} event.
566      */
567     function transferFrom(
568         address from,
569         address to,
570         uint256 tokenId
571     ) external;
572 
573     /**
574      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
575      * The approval is cleared when the token is transferred.
576      *
577      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
578      *
579      * Requirements:
580      *
581      * - The caller must own the token or be an approved operator.
582      * - `tokenId` must exist.
583      *
584      * Emits an {Approval} event.
585      */
586     function approve(address to, uint256 tokenId) external;
587 
588     /**
589      * @dev Returns the account approved for `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function getApproved(uint256 tokenId) external view returns (address operator);
596 
597     /**
598      * @dev Approve or remove `operator` as an operator for the caller.
599      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
600      *
601      * Requirements:
602      *
603      * - The `operator` cannot be the caller.
604      *
605      * Emits an {ApprovalForAll} event.
606      */
607     function setApprovalForAll(address operator, bool _approved) external;
608 
609     /**
610      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
611      *
612      * See {setApprovalForAll}
613      */
614     function isApprovedForAll(address owner, address operator) external view returns (bool);
615 
616     /**
617      * @dev Safely transfers `tokenId` token from `from` to `to`.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must exist and be owned by `from`.
624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
626      *
627      * Emits a {Transfer} event.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId,
633         bytes calldata data
634     ) external;
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
647  * @dev See https://eips.ethereum.org/EIPS/eip-721
648  */
649 interface IERC721Metadata is IERC721 {
650     /**
651      * @dev Returns the token collection name.
652      */
653     function name() external view returns (string memory);
654 
655     /**
656      * @dev Returns the token collection symbol.
657      */
658     function symbol() external view returns (string memory);
659 
660     /**
661      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
662      */
663     function tokenURI(uint256 tokenId) external view returns (string memory);
664 }
665 
666 // File: erc721a/contracts/ERC721A.sol
667 
668 
669 // Creator: Chiru Labs
670 
671 pragma solidity ^0.8.4;
672 
673 
674 
675 
676 
677 
678 
679 
680 error ApprovalCallerNotOwnerNorApproved();
681 error ApprovalQueryForNonexistentToken();
682 error ApproveToCaller();
683 error ApprovalToCurrentOwner();
684 error BalanceQueryForZeroAddress();
685 error MintToZeroAddress();
686 error MintZeroQuantity();
687 error OwnerQueryForNonexistentToken();
688 error TransferCallerNotOwnerNorApproved();
689 error TransferFromIncorrectOwner();
690 error TransferToNonERC721ReceiverImplementer();
691 error TransferToZeroAddress();
692 error URIQueryForNonexistentToken();
693 
694 /**
695  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
696  * the Metadata extension. Built to optimize for lower gas during batch mints.
697  *
698  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
699  *
700  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
701  *
702  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
703  */
704 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
705     using Address for address;
706     using Strings for uint256;
707 
708     // Compiler will pack this into a single 256bit word.
709     struct TokenOwnership {
710         // The address of the owner.
711         address addr;
712         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
713         uint64 startTimestamp;
714         // Whether the token has been burned.
715         bool burned;
716     }
717 
718     // Compiler will pack this into a single 256bit word.
719     struct AddressData {
720         // Realistically, 2**64-1 is more than enough.
721         uint64 balance;
722         // Keeps track of mint count with minimal overhead for tokenomics.
723         uint64 numberMinted;
724         // Keeps track of burn count with minimal overhead for tokenomics.
725         uint64 numberBurned;
726         // For miscellaneous variable(s) pertaining to the address
727         // (e.g. number of whitelist mint slots used).
728         // If there are multiple variables, please pack them into a uint64.
729         uint64 aux;
730     }
731 
732     // The tokenId of the next token to be minted.
733     uint256 internal _currentIndex;
734 
735     // The number of tokens burned.
736     uint256 internal _burnCounter;
737 
738     // Token name
739     string private _name;
740 
741     // Token symbol
742     string private _symbol;
743 
744     // Mapping from token ID to ownership details
745     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
746     mapping(uint256 => TokenOwnership) internal _ownerships;
747 
748     // Mapping owner address to address data
749     mapping(address => AddressData) private _addressData;
750 
751     // Mapping from token ID to approved address
752     mapping(uint256 => address) private _tokenApprovals;
753 
754     // Mapping from owner to operator approvals
755     mapping(address => mapping(address => bool)) private _operatorApprovals;
756 
757     constructor(string memory name_, string memory symbol_) {
758         _name = name_;
759         _symbol = symbol_;
760         _currentIndex = _startTokenId();
761     }
762 
763     /**
764      * To change the starting tokenId, please override this function.
765      */
766     function _startTokenId() internal view virtual returns (uint256) {
767         return 0;
768     }
769 
770     /**
771      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
772      */
773     function totalSupply() public view returns (uint256) {
774         // Counter underflow is impossible as _burnCounter cannot be incremented
775         // more than _currentIndex - _startTokenId() times
776         unchecked {
777             return _currentIndex - _burnCounter - _startTokenId();
778         }
779     }
780 
781     /**
782      * Returns the total amount of tokens minted in the contract.
783      */
784     function _totalMinted() internal view returns (uint256) {
785         // Counter underflow is impossible as _currentIndex does not decrement,
786         // and it is initialized to _startTokenId()
787         unchecked {
788             return _currentIndex - _startTokenId();
789         }
790     }
791 
792     /**
793      * @dev See {IERC165-supportsInterface}.
794      */
795     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
796         return
797             interfaceId == type(IERC721).interfaceId ||
798             interfaceId == type(IERC721Metadata).interfaceId ||
799             super.supportsInterface(interfaceId);
800     }
801 
802     /**
803      * @dev See {IERC721-balanceOf}.
804      */
805     function balanceOf(address owner) public view override returns (uint256) {
806         if (owner == address(0)) revert BalanceQueryForZeroAddress();
807         return uint256(_addressData[owner].balance);
808     }
809 
810     /**
811      * Returns the number of tokens minted by `owner`.
812      */
813     function _numberMinted(address owner) internal view returns (uint256) {
814         return uint256(_addressData[owner].numberMinted);
815     }
816 
817     /**
818      * Returns the number of tokens burned by or on behalf of `owner`.
819      */
820     function _numberBurned(address owner) internal view returns (uint256) {
821         return uint256(_addressData[owner].numberBurned);
822     }
823 
824     /**
825      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
826      */
827     function _getAux(address owner) internal view returns (uint64) {
828         return _addressData[owner].aux;
829     }
830 
831     /**
832      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
833      * If there are multiple variables, please pack them into a uint64.
834      */
835     function _setAux(address owner, uint64 aux) internal {
836         _addressData[owner].aux = aux;
837     }
838 
839     /**
840      * Gas spent here starts off proportional to the maximum mint batch size.
841      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
842      */
843     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
844         uint256 curr = tokenId;
845 
846         unchecked {
847             if (_startTokenId() <= curr && curr < _currentIndex) {
848                 TokenOwnership memory ownership = _ownerships[curr];
849                 if (!ownership.burned) {
850                     if (ownership.addr != address(0)) {
851                         return ownership;
852                     }
853                     // Invariant:
854                     // There will always be an ownership that has an address and is not burned
855                     // before an ownership that does not have an address and is not burned.
856                     // Hence, curr will not underflow.
857                     while (true) {
858                         curr--;
859                         ownership = _ownerships[curr];
860                         if (ownership.addr != address(0)) {
861                             return ownership;
862                         }
863                     }
864                 }
865             }
866         }
867         revert OwnerQueryForNonexistentToken();
868     }
869 
870     /**
871      * @dev See {IERC721-ownerOf}.
872      */
873     function ownerOf(uint256 tokenId) public view override returns (address) {
874         return _ownershipOf(tokenId).addr;
875     }
876 
877     /**
878      * @dev See {IERC721Metadata-name}.
879      */
880     function name() public view virtual override returns (string memory) {
881         return _name;
882     }
883 
884     /**
885      * @dev See {IERC721Metadata-symbol}.
886      */
887     function symbol() public view virtual override returns (string memory) {
888         return _symbol;
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-tokenURI}.
893      */
894     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
895         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
896 
897         string memory baseURI = _baseURI();
898         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
899     }
900 
901     /**
902      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
903      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
904      * by default, can be overriden in child contracts.
905      */
906     function _baseURI() internal view virtual returns (string memory) {
907         return '';
908     }
909 
910     /**
911      * @dev See {IERC721-approve}.
912      */
913     function approve(address to, uint256 tokenId) public override {
914         address owner = ERC721A.ownerOf(tokenId);
915         if (to == owner) revert ApprovalToCurrentOwner();
916 
917         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
918             revert ApprovalCallerNotOwnerNorApproved();
919         }
920 
921         _approve(to, tokenId, owner);
922     }
923 
924     /**
925      * @dev See {IERC721-getApproved}.
926      */
927     function getApproved(uint256 tokenId) public view override returns (address) {
928         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
929 
930         return _tokenApprovals[tokenId];
931     }
932 
933     /**
934      * @dev See {IERC721-setApprovalForAll}.
935      */
936     function setApprovalForAll(address operator, bool approved) public virtual override {
937         if (operator == _msgSender()) revert ApproveToCaller();
938 
939         _operatorApprovals[_msgSender()][operator] = approved;
940         emit ApprovalForAll(_msgSender(), operator, approved);
941     }
942 
943     /**
944      * @dev See {IERC721-isApprovedForAll}.
945      */
946     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
947         return _operatorApprovals[owner][operator];
948     }
949 
950     /**
951      * @dev See {IERC721-transferFrom}.
952      */
953     function transferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public virtual override {
958         _transfer(from, to, tokenId);
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public virtual override {
969         safeTransferFrom(from, to, tokenId, '');
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId,
979         bytes memory _data
980     ) public virtual override {
981         _transfer(from, to, tokenId);
982         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
983             revert TransferToNonERC721ReceiverImplementer();
984         }
985     }
986 
987     /**
988      * @dev Returns whether `tokenId` exists.
989      *
990      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
991      *
992      * Tokens start existing when they are minted (`_mint`),
993      */
994     function _exists(uint256 tokenId) internal view returns (bool) {
995         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
996             !_ownerships[tokenId].burned;
997     }
998 
999     function _safeMint(address to, uint256 quantity) internal {
1000         _safeMint(to, quantity, '');
1001     }
1002 
1003     /**
1004      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1009      * - `quantity` must be greater than 0.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 quantity,
1016         bytes memory _data
1017     ) internal {
1018         _mint(to, quantity, _data, true);
1019     }
1020 
1021     /**
1022      * @dev Mints `quantity` tokens and transfers them to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `quantity` must be greater than 0.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _mint(
1032         address to,
1033         uint256 quantity,
1034         bytes memory _data,
1035         bool safe
1036     ) internal {
1037         uint256 startTokenId = _currentIndex;
1038         if (to == address(0)) revert MintToZeroAddress();
1039         if (quantity == 0) revert MintZeroQuantity();
1040 
1041         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1042 
1043         // Overflows are incredibly unrealistic.
1044         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1045         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1046         unchecked {
1047             _addressData[to].balance += uint64(quantity);
1048             _addressData[to].numberMinted += uint64(quantity);
1049 
1050             _ownerships[startTokenId].addr = to;
1051             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1052 
1053             uint256 updatedIndex = startTokenId;
1054             uint256 end = updatedIndex + quantity;
1055 
1056             if (safe && to.isContract()) {
1057                 do {
1058                     emit Transfer(address(0), to, updatedIndex);
1059                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1060                         revert TransferToNonERC721ReceiverImplementer();
1061                     }
1062                 } while (updatedIndex != end);
1063                 // Reentrancy protection
1064                 if (_currentIndex != startTokenId) revert();
1065             } else {
1066                 do {
1067                     emit Transfer(address(0), to, updatedIndex++);
1068                 } while (updatedIndex != end);
1069             }
1070             _currentIndex = updatedIndex;
1071         }
1072         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1073     }
1074 
1075     /**
1076      * @dev Transfers `tokenId` from `from` to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `tokenId` token must be owned by `from`.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _transfer(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) private {
1090         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1091 
1092         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1093 
1094         bool isApprovedOrOwner = (_msgSender() == from ||
1095             isApprovedForAll(from, _msgSender()) ||
1096             getApproved(tokenId) == _msgSender());
1097 
1098         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1099         if (to == address(0)) revert TransferToZeroAddress();
1100 
1101         _beforeTokenTransfers(from, to, tokenId, 1);
1102 
1103         // Clear approvals from the previous owner
1104         _approve(address(0), tokenId, from);
1105 
1106         // Underflow of the sender's balance is impossible because we check for
1107         // ownership above and the recipient's balance can't realistically overflow.
1108         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1109         unchecked {
1110             _addressData[from].balance -= 1;
1111             _addressData[to].balance += 1;
1112 
1113             TokenOwnership storage currSlot = _ownerships[tokenId];
1114             currSlot.addr = to;
1115             currSlot.startTimestamp = uint64(block.timestamp);
1116 
1117             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1118             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1119             uint256 nextTokenId = tokenId + 1;
1120             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1121             if (nextSlot.addr == address(0)) {
1122                 // This will suffice for checking _exists(nextTokenId),
1123                 // as a burned slot cannot contain the zero address.
1124                 if (nextTokenId != _currentIndex) {
1125                     nextSlot.addr = from;
1126                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1127                 }
1128             }
1129         }
1130 
1131         emit Transfer(from, to, tokenId);
1132         _afterTokenTransfers(from, to, tokenId, 1);
1133     }
1134 
1135     /**
1136      * @dev This is equivalent to _burn(tokenId, false)
1137      */
1138     function _burn(uint256 tokenId) internal virtual {
1139         _burn(tokenId, false);
1140     }
1141 
1142     /**
1143      * @dev Destroys `tokenId`.
1144      * The approval is cleared when the token is burned.
1145      *
1146      * Requirements:
1147      *
1148      * - `tokenId` must exist.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1153         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1154 
1155         address from = prevOwnership.addr;
1156 
1157         if (approvalCheck) {
1158             bool isApprovedOrOwner = (_msgSender() == from ||
1159                 isApprovedForAll(from, _msgSender()) ||
1160                 getApproved(tokenId) == _msgSender());
1161 
1162             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1163         }
1164 
1165         _beforeTokenTransfers(from, address(0), tokenId, 1);
1166 
1167         // Clear approvals from the previous owner
1168         _approve(address(0), tokenId, from);
1169 
1170         // Underflow of the sender's balance is impossible because we check for
1171         // ownership above and the recipient's balance can't realistically overflow.
1172         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1173         unchecked {
1174             AddressData storage addressData = _addressData[from];
1175             addressData.balance -= 1;
1176             addressData.numberBurned += 1;
1177 
1178             // Keep track of who burned the token, and the timestamp of burning.
1179             TokenOwnership storage currSlot = _ownerships[tokenId];
1180             currSlot.addr = from;
1181             currSlot.startTimestamp = uint64(block.timestamp);
1182             currSlot.burned = true;
1183 
1184             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1185             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1186             uint256 nextTokenId = tokenId + 1;
1187             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1188             if (nextSlot.addr == address(0)) {
1189                 // This will suffice for checking _exists(nextTokenId),
1190                 // as a burned slot cannot contain the zero address.
1191                 if (nextTokenId != _currentIndex) {
1192                     nextSlot.addr = from;
1193                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1194                 }
1195             }
1196         }
1197 
1198         emit Transfer(from, address(0), tokenId);
1199         _afterTokenTransfers(from, address(0), tokenId, 1);
1200 
1201         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1202         unchecked {
1203             _burnCounter++;
1204         }
1205     }
1206 
1207     /**
1208      * @dev Approve `to` to operate on `tokenId`
1209      *
1210      * Emits a {Approval} event.
1211      */
1212     function _approve(
1213         address to,
1214         uint256 tokenId,
1215         address owner
1216     ) private {
1217         _tokenApprovals[tokenId] = to;
1218         emit Approval(owner, to, tokenId);
1219     }
1220 
1221     /**
1222      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1223      *
1224      * @param from address representing the previous owner of the given token ID
1225      * @param to target address that will receive the tokens
1226      * @param tokenId uint256 ID of the token to be transferred
1227      * @param _data bytes optional data to send along with the call
1228      * @return bool whether the call correctly returned the expected magic value
1229      */
1230     function _checkContractOnERC721Received(
1231         address from,
1232         address to,
1233         uint256 tokenId,
1234         bytes memory _data
1235     ) private returns (bool) {
1236         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1237             return retval == IERC721Receiver(to).onERC721Received.selector;
1238         } catch (bytes memory reason) {
1239             if (reason.length == 0) {
1240                 revert TransferToNonERC721ReceiverImplementer();
1241             } else {
1242                 assembly {
1243                     revert(add(32, reason), mload(reason))
1244                 }
1245             }
1246         }
1247     }
1248 
1249     /**
1250      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1251      * And also called before burning one token.
1252      *
1253      * startTokenId - the first token id to be transferred
1254      * quantity - the amount to be transferred
1255      *
1256      * Calling conditions:
1257      *
1258      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1259      * transferred to `to`.
1260      * - When `from` is zero, `tokenId` will be minted for `to`.
1261      * - When `to` is zero, `tokenId` will be burned by `from`.
1262      * - `from` and `to` are never both zero.
1263      */
1264     function _beforeTokenTransfers(
1265         address from,
1266         address to,
1267         uint256 startTokenId,
1268         uint256 quantity
1269     ) internal virtual {}
1270 
1271     /**
1272      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1273      * minting.
1274      * And also called after one token has been burned.
1275      *
1276      * startTokenId - the first token id to be transferred
1277      * quantity - the amount to be transferred
1278      *
1279      * Calling conditions:
1280      *
1281      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1282      * transferred to `to`.
1283      * - When `from` is zero, `tokenId` has been minted for `to`.
1284      * - When `to` is zero, `tokenId` has been burned by `from`.
1285      * - `from` and `to` are never both zero.
1286      */
1287     function _afterTokenTransfers(
1288         address from,
1289         address to,
1290         uint256 startTokenId,
1291         uint256 quantity
1292     ) internal virtual {}
1293 }
1294 
1295 // File: contracts/thicc86.sol
1296 
1297 
1298 pragma solidity ^0.8.4; 
1299 
1300 
1301 
1302 contract ThiccClubContract is ERC721A, Ownable {
1303     uint256 amountTotalNFTs = 8686;
1304     uint256 maxMintPerTxn = 10;
1305     uint256 public price = 0.086 ether;
1306     string public baseExtension = ".json";
1307     string public baseURI;
1308     bool public URIlocked;
1309     bool public saleIsActive;
1310     using Strings for uint256;
1311 
1312     constructor() ERC721A("ThiccClub", "THICC")  {}
1313 
1314     function changeURI(string calldata _newURI) public onlyOwner {
1315         require(!URIlocked, "URI locked, can't change it anymore");
1316         baseURI = _newURI;
1317     }
1318 
1319     function lockURI() public onlyOwner {
1320         require (!URIlocked, "URI already locked");
1321         URIlocked = !URIlocked;
1322     }
1323 
1324     function flipSaleState() public onlyOwner {
1325         saleIsActive = !saleIsActive;
1326     }
1327 
1328     function reserveNFTs(uint256 amountFreeMints) public onlyOwner{    
1329         require (amountFreeMints + totalSupply()  <= amountTotalNFTs, "Not enough tokens left");
1330         _safeMint(msg.sender, amountFreeMints);
1331     }
1332 
1333     function mintNFTs(uint256 amountNFTs) public payable {
1334         require (saleIsActive, "Sale is not active at this moment");
1335         require (amountNFTs + totalSupply() <= amountTotalNFTs, "Not enough tokens left");
1336         require (amountNFTs <= maxMintPerTxn, "You are minting more NFTs than available per transaction");
1337         require (balanceOf(msg.sender) < maxMintPerTxn, "You own the max amount of NFTs allowable");
1338         require (msg.value == amountNFTs * price, "Invalid ETH amount");
1339         _safeMint(msg.sender, amountNFTs);
1340         
1341     }
1342 
1343 
1344     function _baseURI() internal view override returns (string memory) {
1345         return baseURI;
1346     }
1347 
1348     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1349   {
1350     require(
1351       _exists(tokenId),
1352       "ERC721Metadata: URI query for nonexistent token"
1353     );
1354 
1355     string memory currentBaseURI = _baseURI();
1356     return bytes(currentBaseURI).length > 0
1357         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1358         : "";
1359   }
1360 
1361     function withdraw() public payable onlyOwner {
1362 
1363     // This will pay Jordan 10% of the initial sale.
1364     (bool js, ) = payable(0x65D38b601d386f72DBc767995F47b2B136d45521).call{value: address(this).balance * 10 / 100}("");
1365     require(js);
1366 
1367     // This will pay Elena 10% of the initial sale.
1368     (bool es, ) = payable(0xa86B56C457eFe468450CfE35c0C0Ed1e06ea454d).call{value: address(this).balance * 10 / 100}("");
1369     require(es);
1370     
1371     //This will pay Cameron 2% of the initial sale.
1372     (bool cb, ) = payable(0xCabDc5cb8eAbeaD731972FF9c802ecDD2B53eb35).call{value: address(this).balance * 2 / 100}("");
1373     require(cb);
1374 
1375     // This will payout the owner 78% of the contract balance.
1376     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1377     require(os);
1378   }
1379 }