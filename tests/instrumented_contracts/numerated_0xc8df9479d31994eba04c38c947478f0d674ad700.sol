1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
358      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Transfers `tokenId` token from `from` to `to`.
378      *
379      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
398      * The approval is cleared when the token is transferred.
399      *
400      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
401      *
402      * Requirements:
403      *
404      * - The caller must own the token or be an approved operator.
405      * - `tokenId` must exist.
406      *
407      * Emits an {Approval} event.
408      */
409     function approve(address to, uint256 tokenId) external;
410 
411     /**
412      * @dev Returns the account approved for `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function getApproved(uint256 tokenId) external view returns (address operator);
419 
420     /**
421      * @dev Approve or remove `operator` as an operator for the caller.
422      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
423      *
424      * Requirements:
425      *
426      * - The `operator` cannot be the caller.
427      *
428      * Emits an {ApprovalForAll} event.
429      */
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432     /**
433      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
434      *
435      * See {setApprovalForAll}
436      */
437     function isApprovedForAll(address owner, address operator) external view returns (bool);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Metadata is IERC721 {
473     /**
474      * @dev Returns the token collection name.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the token collection symbol.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
485      */
486     function tokenURI(uint256 tokenId) external view returns (string memory);
487 }
488 
489 // File: @openzeppelin/contracts/utils/Context.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Provides information about the current execution context, including the
498  * sender of the transaction and its data. While these are generally available
499  * via msg.sender and msg.data, they should not be accessed in such a direct
500  * manner, since when dealing with meta-transactions the account sending and
501  * paying for execution may not be the actual sender (as far as an application
502  * is concerned).
503  *
504  * This contract is only required for intermediate, library-like contracts.
505  */
506 abstract contract Context {
507     function _msgSender() internal view virtual returns (address) {
508         return msg.sender;
509     }
510 
511     function _msgData() internal view virtual returns (bytes calldata) {
512         return msg.data;
513     }
514 }
515 
516 // File: @openzeppelin/contracts/access/Ownable.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @dev Contract module which provides a basic access control mechanism, where
526  * there is an account (an owner) that can be granted exclusive access to
527  * specific functions.
528  *
529  * By default, the owner account will be the one that deploys the contract. This
530  * can later be changed with {transferOwnership}.
531  *
532  * This module is used through inheritance. It will make available the modifier
533  * `onlyOwner`, which can be applied to your functions to restrict their use to
534  * the owner.
535  */
536 abstract contract Ownable is Context {
537     address private _owner;
538 
539     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
540 
541     /**
542      * @dev Initializes the contract setting the deployer as the initial owner.
543      */
544     constructor() {
545         _transferOwnership(_msgSender());
546     }
547 
548     /**
549      * @dev Returns the address of the current owner.
550      */
551     function owner() public view virtual returns (address) {
552         return _owner;
553     }
554 
555     /**
556      * @dev Throws if called by any account other than the owner.
557      */
558     modifier onlyOwner() {
559         require(owner() == _msgSender(), "Ownable: caller is not the owner");
560         _;
561     }
562 
563     /**
564      * @dev Leaves the contract without owner. It will not be possible to call
565      * `onlyOwner` functions anymore. Can only be called by the current owner.
566      *
567      * NOTE: Renouncing ownership will leave the contract without an owner,
568      * thereby removing any functionality that is only available to the owner.
569      */
570     function renounceOwnership() public virtual onlyOwner {
571         _transferOwnership(address(0));
572     }
573 
574     /**
575      * @dev Transfers ownership of the contract to a new account (`newOwner`).
576      * Can only be called by the current owner.
577      */
578     function transferOwnership(address newOwner) public virtual onlyOwner {
579         require(newOwner != address(0), "Ownable: new owner is the zero address");
580         _transferOwnership(newOwner);
581     }
582 
583     /**
584      * @dev Transfers ownership of the contract to a new account (`newOwner`).
585      * Internal function without access restriction.
586      */
587     function _transferOwnership(address newOwner) internal virtual {
588         address oldOwner = _owner;
589         _owner = newOwner;
590         emit OwnershipTransferred(oldOwner, newOwner);
591     }
592 }
593 
594 // File: @openzeppelin/contracts/utils/Strings.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 /**
602  * @dev String operations.
603  */
604 library Strings {
605     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
609      */
610     function toString(uint256 value) internal pure returns (string memory) {
611         // Inspired by OraclizeAPI's implementation - MIT licence
612         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
613 
614         if (value == 0) {
615             return "0";
616         }
617         uint256 temp = value;
618         uint256 digits;
619         while (temp != 0) {
620             digits++;
621             temp /= 10;
622         }
623         bytes memory buffer = new bytes(digits);
624         while (value != 0) {
625             digits -= 1;
626             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
627             value /= 10;
628         }
629         return string(buffer);
630     }
631 
632     /**
633      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
634      */
635     function toHexString(uint256 value) internal pure returns (string memory) {
636         if (value == 0) {
637             return "0x00";
638         }
639         uint256 temp = value;
640         uint256 length = 0;
641         while (temp != 0) {
642             length++;
643             temp >>= 8;
644         }
645         return toHexString(value, length);
646     }
647 
648     /**
649      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
650      */
651     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
652         bytes memory buffer = new bytes(2 * length + 2);
653         buffer[0] = "0";
654         buffer[1] = "x";
655         for (uint256 i = 2 * length + 1; i > 1; --i) {
656             buffer[i] = _HEX_SYMBOLS[value & 0xf];
657             value >>= 4;
658         }
659         require(value == 0, "Strings: hex length insufficient");
660         return string(buffer);
661     }
662 }
663 
664 // File: SevensGiveawayClaim/ERC721A.sol
665 
666 
667 // Creator: Chiru Labs
668 
669 pragma solidity ^0.8.4;
670 
671 
672 
673 
674 
675 
676 
677 
678 error ApprovalCallerNotOwnerNorApproved();
679 error ApprovalQueryForNonexistentToken();
680 error ApproveToCaller();
681 error ApprovalToCurrentOwner();
682 error BalanceQueryForZeroAddress();
683 error MintToZeroAddress();
684 error MintZeroQuantity();
685 error OwnerQueryForNonexistentToken();
686 error TransferCallerNotOwnerNorApproved();
687 error TransferFromIncorrectOwner();
688 error TransferToNonERC721ReceiverImplementer();
689 error TransferToZeroAddress();
690 error URIQueryForNonexistentToken();
691 
692 /**
693  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
694  * the Metadata extension. Built to optimize for lower gas during batch mints.
695  *
696  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
697  *
698  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
699  *
700  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
701  */
702 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
703     using Address for address;
704     using Strings for uint256;
705 
706     // Compiler will pack this into a single 256bit word.
707     struct TokenOwnership {
708         // The address of the owner.
709         address addr;
710         // Whether the token has been burned.
711         bool burned;
712     }
713 
714     // Compiler will pack this into a single 256bit word.
715     struct AddressData {
716         // Realistically, 2**64-1 is more than enough.
717         uint64 balance;
718         // Keeps track of mint count with minimal overhead for tokenomics.
719         uint64 numberMinted;
720         // Keeps track of burn count with minimal overhead for tokenomics.
721         uint64 numberBurned;
722 
723         uint32 whitelistMinted;
724         uint32 mintPassWhitelistMinted;
725     }
726 
727     // The tokenId of the next token to be minted.
728     uint256 internal _currentIndex;
729 
730     // The number of tokens burned.
731     uint256 internal _burnCounter;
732 
733     // Token name
734     string private _name;
735 
736     // Token symbol
737     string private _symbol;
738 
739     // Mapping from token ID to ownership details
740     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
741     mapping(uint256 => TokenOwnership) internal _ownerships;
742 
743     // Mapping owner address to address data
744     mapping(address => AddressData) private _addressData;
745 
746     // Mapping from token ID to approved address
747     mapping(uint256 => address) private _tokenApprovals;
748 
749     // Mapping from owner to operator approvals
750     mapping(address => mapping(address => bool)) private _operatorApprovals;
751 
752     constructor(string memory name_, string memory symbol_) {
753         _name = name_;
754         _symbol = symbol_;
755         _currentIndex = _startTokenId();
756     }
757 
758     /**
759      * To change the starting tokenId, please override this function.
760      */
761     function _startTokenId() internal view virtual returns (uint256) {
762         return 1;
763     }
764 
765     /**
766      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
767      */
768     function totalSupply() public view returns (uint256) {
769         // Counter underflow is impossible as _burnCounter cannot be incremented
770         // more than _currentIndex - _startTokenId() times
771         unchecked {
772             return _currentIndex - _burnCounter - _startTokenId();
773         }
774     }
775 
776     /**
777      * Returns the total amount of tokens minted in the contract.
778      */
779     function _totalMinted() internal view returns (uint256) {
780         // Counter underflow is impossible as _currentIndex does not decrement,
781         // and it is initialized to _startTokenId()
782         unchecked {
783             return _currentIndex - _startTokenId();
784         }
785     }
786 
787     /**
788      * @dev See {IERC165-supportsInterface}.
789      */
790     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
791         return
792             interfaceId == type(IERC721).interfaceId ||
793             interfaceId == type(IERC721Metadata).interfaceId ||
794             super.supportsInterface(interfaceId);
795     }
796 
797     /**
798      * @dev See {IERC721-balanceOf}.
799      */
800     function balanceOf(address owner) public view override returns (uint256) {
801         if (owner == address(0)) revert BalanceQueryForZeroAddress();
802         return uint256(_addressData[owner].balance);
803     }
804 
805     /**
806      * Returns the number of tokens minted by `owner`.
807      */
808     function _numberMinted(address owner) internal view returns (uint256) {
809         return uint256(_addressData[owner].numberMinted);
810     }
811 
812     /**
813      * Returns the number of tokens burned by or on behalf of `owner`.
814      */
815     function _numberBurned(address owner) internal view returns (uint256) {
816         return uint256(_addressData[owner].numberBurned);
817     }
818 
819     function getWhitelistMintedData(address owner) public view returns (uint32, uint32) {
820         return (_addressData[owner].whitelistMinted, _addressData[owner].mintPassWhitelistMinted);
821     }
822 
823     /**
824      * Gas spent here starts off proportional to the maximum mint batch size.
825      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
826      */
827     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
828         uint256 curr = tokenId;
829 
830         unchecked {
831             if (_startTokenId() <= curr && curr < _currentIndex) {
832                 TokenOwnership memory ownership = _ownerships[curr];
833                 if (!ownership.burned) {
834                     if (ownership.addr != address(0)) {
835                         return ownership;
836                     }
837                     // Invariant:
838                     // There will always be an ownership that has an address and is not burned
839                     // before an ownership that does not have an address and is not burned.
840                     // Hence, curr will not underflow.
841                     while (true) {
842                         curr--;
843                         ownership = _ownerships[curr];
844                         if (ownership.addr != address(0)) {
845                             return ownership;
846                         }
847                     }
848                 }
849             }
850         }
851         revert OwnerQueryForNonexistentToken();
852     }
853 
854     /**
855      * @dev See {IERC721-ownerOf}.
856      */
857     function ownerOf(uint256 tokenId) public view override returns (address) {
858         return _ownershipOf(tokenId).addr;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-name}.
863      */
864     function name() public view virtual override returns (string memory) {
865         return _name;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-symbol}.
870      */
871     function symbol() public view virtual override returns (string memory) {
872         return _symbol;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-tokenURI}.
877      */
878     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
879         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
880 
881         string memory baseURI = _baseURI();
882         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), '.json')) : '';
883     }
884 
885     /**
886      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
887      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
888      * by default, can be overriden in child contracts.
889      */
890     function _baseURI() internal view virtual returns (string memory) {
891         return '';
892     }
893 
894     /**
895      * @dev See {IERC721-approve}.
896      */
897     function approve(address to, uint256 tokenId) public override {
898         address owner = ERC721A.ownerOf(tokenId);
899         if (to == owner) revert ApprovalToCurrentOwner();
900 
901         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
902             revert ApprovalCallerNotOwnerNorApproved();
903         }
904 
905         _approve(to, tokenId, owner);
906     }
907 
908     /**
909      * @dev See {IERC721-getApproved}.
910      */
911     function getApproved(uint256 tokenId) public view override returns (address) {
912         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
913 
914         return _tokenApprovals[tokenId];
915     }
916 
917     /**
918      * @dev See {IERC721-setApprovalForAll}.
919      */
920     function setApprovalForAll(address operator, bool approved) public virtual override {
921         if (operator == _msgSender()) revert ApproveToCaller();
922 
923         _operatorApprovals[_msgSender()][operator] = approved;
924         emit ApprovalForAll(_msgSender(), operator, approved);
925     }
926 
927     /**
928      * @dev See {IERC721-isApprovedForAll}.
929      */
930     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
931         return _operatorApprovals[owner][operator];
932     }
933 
934     /**
935      * @dev See {IERC721-transferFrom}.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public virtual override {
942         _transfer(from, to, tokenId);
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public virtual override {
953         safeTransferFrom(from, to, tokenId, '');
954     }
955 
956     /**
957      * @dev See {IERC721-safeTransferFrom}.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) public virtual override {
965         _transfer(from, to, tokenId);
966         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
967             revert TransferToNonERC721ReceiverImplementer();
968         }
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted (`_mint`),
977      */
978     function _exists(uint256 tokenId) internal view returns (bool) {
979         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
980     }
981 
982     /**
983      * @dev Mints `quantity` tokens and transfers them to `to`.
984      *
985      * Requirements:
986      *
987      * - `to` cannot be the zero address.
988      * - `quantity` must be greater than 0.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _mint(
993         address to,
994         uint256 quantity,
995         bool addToWhitelistMinted,
996         bool addToMintPassWhitelistMinted
997     ) internal {
998         uint256 startTokenId = _currentIndex;
999 
1000         // Overflows are incredibly unrealistic.
1001         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1002         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1003         unchecked {
1004             AddressData storage addressData = _addressData[to];
1005             addressData.balance += uint64(quantity);
1006             addressData.numberMinted += uint64(quantity);
1007             if(addToWhitelistMinted)
1008                 addressData.whitelistMinted += uint32(quantity);
1009             if(addToMintPassWhitelistMinted)
1010                 addressData.mintPassWhitelistMinted += uint32(quantity);
1011 
1012             _ownerships[startTokenId].addr = to;
1013 
1014             uint256 updatedIndex = startTokenId;
1015             uint256 end = updatedIndex + quantity;
1016 
1017             do {
1018                 emit Transfer(address(0), to, updatedIndex++);
1019             } while (updatedIndex != end);
1020             _currentIndex = updatedIndex;
1021         }
1022     }
1023 
1024     function _airdropMint(
1025         address to,
1026         uint256 quantity
1027     ) internal {
1028         uint256 startTokenId = _currentIndex;
1029 
1030         unchecked {
1031             _addressData[to].balance += uint64(quantity);
1032 
1033             _ownerships[startTokenId].addr = to;
1034 
1035             uint256 updatedIndex = startTokenId;
1036             uint256 end = updatedIndex + quantity;
1037 
1038             do {
1039                 emit Transfer(address(0), to, updatedIndex++);
1040             } while (updatedIndex != end);
1041             _currentIndex = updatedIndex;
1042         }
1043     }
1044 
1045     /**
1046      * @dev Transfers `tokenId` from `from` to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _transfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) private {
1060         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1061 
1062         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1063 
1064         bool isApprovedOrOwner = (_msgSender() == from ||
1065             isApprovedForAll(from, _msgSender()) ||
1066             getApproved(tokenId) == _msgSender());
1067 
1068         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1069         if (to == address(0)) revert TransferToZeroAddress();
1070 
1071         // Clear approvals from the previous owner
1072         _approve(address(0), tokenId, from);
1073 
1074         // Underflow of the sender's balance is impossible because we check for
1075         // ownership above and the recipient's balance can't realistically overflow.
1076         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1077         unchecked {
1078             _addressData[from].balance -= 1;
1079             _addressData[to].balance += 1;
1080 
1081             TokenOwnership storage currSlot = _ownerships[tokenId];
1082             currSlot.addr = to;
1083 
1084             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1085             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1086             uint256 nextTokenId = tokenId + 1;
1087             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1088             if (nextSlot.addr == address(0)) {
1089                 // This will suffice for checking _exists(nextTokenId),
1090                 // as a burned slot cannot contain the zero address.
1091                 if (nextTokenId != _currentIndex) {
1092                     nextSlot.addr = from;
1093                 }
1094             }
1095         }
1096 
1097         emit Transfer(from, to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev This is equivalent to _burn(tokenId, false)
1102      */
1103     function _burn(uint256 tokenId) internal virtual {
1104         _burn(tokenId, false);
1105     }
1106 
1107     /**
1108      * @dev Destroys `tokenId`.
1109      * The approval is cleared when the token is burned.
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must exist.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1118         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1119 
1120         address from = prevOwnership.addr;
1121 
1122         if (approvalCheck) {
1123             bool isApprovedOrOwner = (_msgSender() == from ||
1124                 isApprovedForAll(from, _msgSender()) ||
1125                 getApproved(tokenId) == _msgSender());
1126 
1127             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1128         }
1129 
1130         // Clear approvals from the previous owner
1131         _approve(address(0), tokenId, from);
1132 
1133         // Underflow of the sender's balance is impossible because we check for
1134         // ownership above and the recipient's balance can't realistically overflow.
1135         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1136         unchecked {
1137             AddressData storage addressData = _addressData[from];
1138             addressData.balance -= 1;
1139             addressData.numberBurned += 1;
1140 
1141             // Keep track of who burned the token, and the timestamp of burning.
1142             TokenOwnership storage currSlot = _ownerships[tokenId];
1143             currSlot.addr = from;
1144             currSlot.burned = true;
1145 
1146             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1147             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1148             uint256 nextTokenId = tokenId + 1;
1149             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1150             if (nextSlot.addr == address(0)) {
1151                 // This will suffice for checking _exists(nextTokenId),
1152                 // as a burned slot cannot contain the zero address.
1153                 if (nextTokenId != _currentIndex) {
1154                     nextSlot.addr = from;
1155                 }
1156             }
1157         }
1158 
1159         emit Transfer(from, address(0), tokenId);
1160 
1161         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1162         unchecked {
1163             _burnCounter++;
1164         }
1165     }
1166 
1167     /**
1168      * @dev Approve `to` to operate on `tokenId`
1169      *
1170      * Emits a {Approval} event.
1171      */
1172     function _approve(
1173         address to,
1174         uint256 tokenId,
1175         address owner
1176     ) private {
1177         _tokenApprovals[tokenId] = to;
1178         emit Approval(owner, to, tokenId);
1179     }
1180 
1181     /**
1182      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1183      *
1184      * @param from address representing the previous owner of the given token ID
1185      * @param to target address that will receive the tokens
1186      * @param tokenId uint256 ID of the token to be transferred
1187      * @param _data bytes optional data to send along with the call
1188      * @return bool whether the call correctly returned the expected magic value
1189      */
1190     function _checkContractOnERC721Received(
1191         address from,
1192         address to,
1193         uint256 tokenId,
1194         bytes memory _data
1195     ) private returns (bool) {
1196         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1197             return retval == IERC721Receiver(to).onERC721Received.selector;
1198         } catch (bytes memory reason) {
1199             if (reason.length == 0) {
1200                 revert TransferToNonERC721ReceiverImplementer();
1201             } else {
1202                 assembly {
1203                     revert(add(32, reason), mload(reason))
1204                 }
1205             }
1206         }
1207     }
1208 }
1209 
1210 // File: SevensGiveawayClaim/ERC721ALowCap.sol
1211 
1212 
1213 // Creator: Chiru Labs
1214 
1215 pragma solidity ^0.8.4;
1216 
1217 
1218 /**
1219  * @title ERC721A Low Cap
1220  * @dev ERC721A Helper functions for Low Cap (<= 10,000) totalSupply.
1221  */
1222 abstract contract ERC721ALowCap is ERC721A {
1223     /**
1224      * @dev Returns the tokenIds of the address. O(totalSupply) in complexity.
1225      */
1226     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1227         uint256 holdingAmount = balanceOf(owner);
1228         uint256 currSupply = _currentIndex;
1229         uint256 tokenIdsIdx;
1230         address currOwnershipAddr;
1231 
1232         uint256[] memory list = new uint256[](holdingAmount);
1233 
1234         unchecked {
1235             for (uint256 i = _startTokenId(); i < currSupply; ++i) {
1236                 TokenOwnership memory ownership = _ownerships[i];
1237 
1238                 if (ownership.burned) {
1239                     continue;
1240                 }
1241 
1242                 // Find out who owns this sequence
1243                 if (ownership.addr != address(0)) {
1244                     currOwnershipAddr = ownership.addr;
1245                 }
1246 
1247                 // Append tokens the last found owner owns in the sequence
1248                 if (currOwnershipAddr == owner) {
1249                     list[tokenIdsIdx++] = i;
1250                 }
1251 
1252                 // All tokens have been found, we don't need to keep searching
1253                 if (tokenIdsIdx == holdingAmount) {
1254                     break;
1255                 }
1256             }
1257         }
1258 
1259         return list;
1260     }
1261 }
1262 
1263 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1264 
1265 
1266 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 
1271 /**
1272  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1273  *
1274  * These functions can be used to verify that a message was signed by the holder
1275  * of the private keys of a given address.
1276  */
1277 library ECDSA {
1278     enum RecoverError {
1279         NoError,
1280         InvalidSignature,
1281         InvalidSignatureLength,
1282         InvalidSignatureS,
1283         InvalidSignatureV
1284     }
1285 
1286     function _throwError(RecoverError error) private pure {
1287         if (error == RecoverError.NoError) {
1288             return; // no error: do nothing
1289         } else if (error == RecoverError.InvalidSignature) {
1290             revert("ECDSA: invalid signature");
1291         } else if (error == RecoverError.InvalidSignatureLength) {
1292             revert("ECDSA: invalid signature length");
1293         } else if (error == RecoverError.InvalidSignatureS) {
1294             revert("ECDSA: invalid signature 's' value");
1295         } else if (error == RecoverError.InvalidSignatureV) {
1296             revert("ECDSA: invalid signature 'v' value");
1297         }
1298     }
1299 
1300     /**
1301      * @dev Returns the address that signed a hashed message (`hash`) with
1302      * `signature` or error string. This address can then be used for verification purposes.
1303      *
1304      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1305      * this function rejects them by requiring the `s` value to be in the lower
1306      * half order, and the `v` value to be either 27 or 28.
1307      *
1308      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1309      * verification to be secure: it is possible to craft signatures that
1310      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1311      * this is by receiving a hash of the original message (which may otherwise
1312      * be too long), and then calling {toEthSignedMessageHash} on it.
1313      *
1314      * Documentation for signature generation:
1315      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1316      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1317      *
1318      * _Available since v4.3._
1319      */
1320     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1321         // Check the signature length
1322         // - case 65: r,s,v signature (standard)
1323         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1324         if (signature.length == 65) {
1325             bytes32 r;
1326             bytes32 s;
1327             uint8 v;
1328             // ecrecover takes the signature parameters, and the only way to get them
1329             // currently is to use assembly.
1330             assembly {
1331                 r := mload(add(signature, 0x20))
1332                 s := mload(add(signature, 0x40))
1333                 v := byte(0, mload(add(signature, 0x60)))
1334             }
1335             return tryRecover(hash, v, r, s);
1336         } else if (signature.length == 64) {
1337             bytes32 r;
1338             bytes32 vs;
1339             // ecrecover takes the signature parameters, and the only way to get them
1340             // currently is to use assembly.
1341             assembly {
1342                 r := mload(add(signature, 0x20))
1343                 vs := mload(add(signature, 0x40))
1344             }
1345             return tryRecover(hash, r, vs);
1346         } else {
1347             return (address(0), RecoverError.InvalidSignatureLength);
1348         }
1349     }
1350 
1351     /**
1352      * @dev Returns the address that signed a hashed message (`hash`) with
1353      * `signature`. This address can then be used for verification purposes.
1354      *
1355      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1356      * this function rejects them by requiring the `s` value to be in the lower
1357      * half order, and the `v` value to be either 27 or 28.
1358      *
1359      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1360      * verification to be secure: it is possible to craft signatures that
1361      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1362      * this is by receiving a hash of the original message (which may otherwise
1363      * be too long), and then calling {toEthSignedMessageHash} on it.
1364      */
1365     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1366         (address recovered, RecoverError error) = tryRecover(hash, signature);
1367         _throwError(error);
1368         return recovered;
1369     }
1370 
1371     /**
1372      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1373      *
1374      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1375      *
1376      * _Available since v4.3._
1377      */
1378     function tryRecover(
1379         bytes32 hash,
1380         bytes32 r,
1381         bytes32 vs
1382     ) internal pure returns (address, RecoverError) {
1383         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1384         uint8 v = uint8((uint256(vs) >> 255) + 27);
1385         return tryRecover(hash, v, r, s);
1386     }
1387 
1388     /**
1389      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1390      *
1391      * _Available since v4.2._
1392      */
1393     function recover(
1394         bytes32 hash,
1395         bytes32 r,
1396         bytes32 vs
1397     ) internal pure returns (address) {
1398         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1399         _throwError(error);
1400         return recovered;
1401     }
1402 
1403     /**
1404      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1405      * `r` and `s` signature fields separately.
1406      *
1407      * _Available since v4.3._
1408      */
1409     function tryRecover(
1410         bytes32 hash,
1411         uint8 v,
1412         bytes32 r,
1413         bytes32 s
1414     ) internal pure returns (address, RecoverError) {
1415         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1416         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1417         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1418         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1419         //
1420         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1421         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1422         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1423         // these malleable signatures as well.
1424         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1425             return (address(0), RecoverError.InvalidSignatureS);
1426         }
1427         if (v != 27 && v != 28) {
1428             return (address(0), RecoverError.InvalidSignatureV);
1429         }
1430 
1431         // If the signature is valid (and not malleable), return the signer address
1432         address signer = ecrecover(hash, v, r, s);
1433         if (signer == address(0)) {
1434             return (address(0), RecoverError.InvalidSignature);
1435         }
1436 
1437         return (signer, RecoverError.NoError);
1438     }
1439 
1440     /**
1441      * @dev Overload of {ECDSA-recover} that receives the `v`,
1442      * `r` and `s` signature fields separately.
1443      */
1444     function recover(
1445         bytes32 hash,
1446         uint8 v,
1447         bytes32 r,
1448         bytes32 s
1449     ) internal pure returns (address) {
1450         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1451         _throwError(error);
1452         return recovered;
1453     }
1454 
1455     /**
1456      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1457      * produces hash corresponding to the one signed with the
1458      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1459      * JSON-RPC method as part of EIP-191.
1460      *
1461      * See {recover}.
1462      */
1463     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1464         // 32 is the length in bytes of hash,
1465         // enforced by the type signature above
1466         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1467     }
1468 
1469     /**
1470      * @dev Returns an Ethereum Signed Message, created from `s`. This
1471      * produces hash corresponding to the one signed with the
1472      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1473      * JSON-RPC method as part of EIP-191.
1474      *
1475      * See {recover}.
1476      */
1477     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1478         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1479     }
1480 
1481     /**
1482      * @dev Returns an Ethereum Signed Typed Data, created from a
1483      * `domainSeparator` and a `structHash`. This produces hash corresponding
1484      * to the one signed with the
1485      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1486      * JSON-RPC method as part of EIP-712.
1487      *
1488      * See {recover}.
1489      */
1490     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1491         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1492     }
1493 }
1494 
1495 // File: SevensGiveawayClaim/Eve.sol
1496 
1497 
1498 
1499 pragma solidity ^0.8.10;
1500 
1501 
1502 
1503 
1504 
1505 
1506 contract Eve is ERC721A, ERC721ALowCap, Ownable {
1507     using ECDSA for bytes32;
1508     using Strings for uint256;
1509 
1510     modifier directOnly {
1511         require(msg.sender == tx.origin);
1512         _;
1513     }
1514 
1515     enum SaleStatus {
1516         CLOSED,
1517         WHITELIST,
1518         PUBLIC
1519     }
1520 
1521     struct AirdropData {
1522         address to;
1523         uint96 amount;
1524     }
1525 
1526     // Supply constants
1527     uint public constant MaxSupply = 10777;
1528     uint public constant ReservedSupply = 4407;
1529     uint public constant PublicSupply = MaxSupply - ReservedSupply;
1530 
1531     // Mint Settings
1532     uint public constant MintPassWhitelistMintPrice =  0.049 ether;
1533     uint public constant WhitelistMintPrice =  0.06 ether;
1534     uint public constant PublicMintPrice =  0.07 ether;
1535     uint constant maxMintsPerPublicTX = 7;
1536 
1537     // Sha-256 provenance
1538     bytes32 public constant provenanceHash = 0x0f3ca15e7fa2310a264187a0541bea543c0109ee43414f6bccdbfda35feb2de0;
1539 
1540     // Muttable state
1541     uint public reservedMinted;
1542     uint public randomStartingIndex;
1543 
1544     SaleStatus public saleStatus;
1545 
1546     string baseURI = "";
1547 
1548     address public signer = 0x6BFe1678260eAE70bD571997F4fDa7B731a155fD;
1549 
1550     constructor() ERC721A("The Sevens Eve", "EVE") {}
1551 
1552     // Minting
1553 
1554     function mintPublic(uint amount) external payable directOnly {
1555         // Check for sale status
1556         require(saleStatus == SaleStatus.PUBLIC, "Sale is not active");
1557 
1558         // Make sure mint doesn't go over total supply
1559         require(_totalMinted() + amount <= PublicSupply + reservedMinted, "Mint would go over max supply");
1560 
1561         // Verify the ETH amount sent
1562         require(msg.value == amount * PublicMintPrice, "Invalid ETH sent");
1563 
1564         // Mints per public transaction are limited to 7
1565         require(amount > 0 && amount <= maxMintsPerPublicTX, "Invalid amount");
1566 
1567         // Mint the token(s)
1568         _mint(msg.sender, amount, false, false);
1569 
1570         // If maximum public supply is reached, close the saleStatus
1571         if(_totalMinted() == PublicSupply + reservedMinted) {
1572             saleStatus = SaleStatus.CLOSED;
1573         }
1574     }
1575 
1576     function mintWhitelist(uint amount, uint mintPassAmount, uint maxAmount, uint maxMintPassAmount, bytes calldata signature) external payable directOnly {
1577         // Check for sale status
1578         require(saleStatus == SaleStatus.WHITELIST, "Sale is not active");
1579 
1580         // Make sure mint doesn't go over total supply
1581         require(_totalMinted() + amount + mintPassAmount <= PublicSupply + reservedMinted, "Mint would go over max supply");
1582 
1583         // Fetch amount minted for sender
1584         (uint whitelistMinted, uint mintPassMinted) = getWhitelistMintedData(msg.sender);
1585 
1586         // Verify sender isn't minting over maximum allowed for both whitelist minting and mint pass whitelist minting
1587         require(amount + whitelistMinted <= maxAmount, "Invalid amount");
1588         require(mintPassAmount + mintPassMinted <= maxMintPassAmount, "Invalid amount");
1589 
1590         // Verify the ETH amount sent
1591         require(msg.value == (amount * WhitelistMintPrice) + (mintPassAmount * MintPassWhitelistMintPrice), "Invalid ETH sent");
1592 
1593         // Verify the ECDSA signature
1594         require(verifySignature(keccak256(abi.encode(msg.sender, maxAmount, maxMintPassAmount)), signature));
1595 
1596         /*
1597          * Mint the token(s)
1598          * while splitting mints in batches of 7
1599          * this will help with gas consuming loops when transferring or selling tokens
1600          */ 
1601         if(amount > 0) {
1602             uint mintedSoFar = 0;
1603             do {
1604                 uint batchAmount = min(amount - mintedSoFar, 7);
1605                 mintedSoFar += batchAmount;
1606                 _mint(msg.sender, batchAmount, true, false);
1607             } while(mintedSoFar < amount);
1608         }
1609 
1610         if(mintPassAmount > 0) {
1611             uint mintedSoFar = 0;
1612             do {
1613                 uint batchAmount = min(mintPassAmount - mintedSoFar, 7);
1614                 mintedSoFar += batchAmount;
1615                 _mint(msg.sender, batchAmount, false, true);
1616             } while(mintedSoFar < mintPassAmount);
1617         }
1618     }
1619 
1620     // View Only
1621 
1622     function tokenURI(uint tokenId) public view override returns(string memory) {
1623         return string(abi.encodePacked(baseURI, tokenId.toString(), '.json'));
1624     }
1625 
1626     // Internal
1627 
1628     function verifySignature(bytes32 hash, bytes calldata signature) internal view returns(bool) {
1629         return hash.toEthSignedMessageHash().recover(signature) == signer;
1630     }
1631 
1632     // Only Owner
1633 
1634     function airdrop(AirdropData[] calldata airdropData) external onlyOwner {
1635         uint totalDropped = 0;
1636         unchecked {
1637             uint len = airdropData.length;
1638             for(uint i = 0; i < len; i++) {
1639                 totalDropped += airdropData[i].amount;
1640                 _airdropMint(airdropData[i].to, airdropData[i].amount);
1641             }
1642         }
1643         require((reservedMinted += totalDropped) <= ReservedSupply, "OVER_SUPPLY");
1644     }
1645 
1646     function setSigner(address _signer) external onlyOwner {
1647         signer = _signer;
1648     }
1649 
1650     function setBaseURI(string calldata baseURI_) external onlyOwner {
1651         baseURI = baseURI_;
1652     }
1653 
1654     function rollRandomStartingIndex() external onlyOwner {
1655         require(provenanceHash != bytes32(0), "PROVENANCE_HASH_NOT_SET");
1656         require(randomStartingIndex == 0, "RSI_SET");
1657 
1658         uint random = uint(keccak256(abi.encode(block.timestamp, block.difficulty, totalSupply())));
1659         randomStartingIndex = (random % MaxSupply);
1660 
1661         /* 
1662          * The first token in the collection(which starts from 1) will have the metadata of `randomStartingIndex`
1663          * for that reason it must not be the same to avoid default order
1664          */
1665         if(randomStartingIndex == 1) randomStartingIndex++;
1666     }
1667 
1668     // 0: CLOSED
1669     // 1: WHITELIST
1670     // 2: PUBLIC
1671     function setSaleStatus(SaleStatus _saleStatus) external onlyOwner {
1672         saleStatus = _saleStatus;
1673     }
1674 
1675     function withdraw(address to) external onlyOwner {
1676         (bool success, ) = to.call{ value: address(this).balance }("");
1677         require(success, "Transfer failed");
1678     }
1679 
1680     // Utils
1681 
1682     function min(uint a, uint b) internal pure returns(uint) {
1683         return(a < b ? a : b);
1684     }
1685 
1686 }
1687 // File: SevensGiveawayClaim/GiveawayClaim.sol
1688 
1689 pragma solidity ^0.8.10;
1690 
1691 contract GiveawayClaim is Ownable {
1692     using ECDSA for bytes32;
1693 
1694     error Paused();
1695     error InvalidSignature();
1696     error NotEnoughMints();
1697 
1698     /* Constants */
1699 
1700     Eve constant EVE = Eve(0xC3CD69649394bF1A18a7a0c7F90E4D0e4f1A9758);
1701     address constant SIGNER = 0xd0F071258DA42A8736Ca728E0ad129Ff09dfB6ab;
1702     address constant TOKEN_HOLDER = 0xe612fe75fF429f66dd8C59B1890aC00A84CA8003;
1703     uint256 constant FIRST_ID = 7656;
1704 
1705     /* Storage */
1706 
1707     uint256 _nextId = FIRST_ID;
1708     bool public isPaused = false;
1709     mapping(address => uint256) public amountClaimed;
1710 
1711     /* External */
1712 
1713     modifier notPaused {
1714         if(isPaused) revert Paused();
1715         _;
1716     }
1717 
1718     function claim(uint256 amount, uint256 maxAmount, uint8 v, bytes32 r, bytes32 s) external notPaused {
1719         if((amountClaimed[msg.sender] += amount) > maxAmount) revert NotEnoughMints();
1720         _verifySignature(msg.sender, maxAmount, v, r, s);
1721         _mint(msg.sender, amount);
1722     }
1723 
1724     /* Only Owner */
1725 
1726     function togglePaused() external onlyOwner {
1727         isPaused = !isPaused;
1728     }
1729 
1730     function setNextId(uint256 nextId) external onlyOwner {
1731         _nextId = nextId;
1732     }
1733 
1734     /* Internal */
1735 
1736     function _verifySignature(address user, uint256 maxAmount, uint8 v, bytes32 r, bytes32 s) internal pure {
1737         if(keccak256(abi.encode(user, maxAmount)).toEthSignedMessageHash().recover(v, r, s) != SIGNER) revert InvalidSignature();
1738     }
1739 
1740     function _mint(address to, uint256 amount) internal {
1741         uint256 nextId = _nextId;
1742         uint256 maxId = nextId + amount;
1743 
1744         for(uint id = nextId; id < maxId; id++) {
1745             EVE.transferFrom(TOKEN_HOLDER, to, id);
1746         }
1747         _nextId += amount;
1748     }
1749 
1750     function min(uint256 a, uint256 b) internal pure returns(uint256) {
1751         return a < b ? a : b;
1752     }
1753 }