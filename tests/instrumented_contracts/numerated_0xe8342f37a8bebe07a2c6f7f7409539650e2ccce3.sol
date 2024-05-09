1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
180 
181 pragma solidity ^0.8.1;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      *
204      * [IMPORTANT]
205      * ====
206      * You shouldn't rely on `isContract` to protect against flash loan attacks!
207      *
208      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
209      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
210      * constructor.
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize/address.code.length, which returns 0
215         // for contracts in construction, since the code is only stored at the end
216         // of the constructor execution.
217 
218         return account.code.length > 0;
219     }
220 
221     /**
222      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
223      * `recipient`, forwarding all available gas and reverting on errors.
224      *
225      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
226      * of certain opcodes, possibly making contracts go over the 2300 gas limit
227      * imposed by `transfer`, making them unable to receive funds via
228      * `transfer`. {sendValue} removes this limitation.
229      *
230      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
231      *
232      * IMPORTANT: because control is transferred to `recipient`, care must be
233      * taken to not create reentrancy vulnerabilities. Consider using
234      * {ReentrancyGuard} or the
235      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
236      */
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     /**
245      * @dev Performs a Solidity function call using a low level `call`. A
246      * plain `call` is an unsafe replacement for a function call: use this
247      * function instead.
248      *
249      * If `target` reverts with a revert reason, it is bubbled up by this
250      * function (like regular Solidity function calls).
251      *
252      * Returns the raw returned data. To convert to the expected return value,
253      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
254      *
255      * Requirements:
256      *
257      * - `target` must be a contract.
258      * - calling `target` with `data` must not revert.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionCall(target, data, "Address: low-level call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(address(this).balance >= value, "Address: insufficient balance for call");
312         require(isContract(target), "Address: call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.call{value: value}(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(isContract(target), "Address: delegate call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
402 
403 
404 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @title ERC721 token receiver interface
410  * @dev Interface for any contract that wants to support safeTransfers
411  * from ERC721 asset contracts.
412  */
413 interface IERC721Receiver {
414     /**
415      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
416      * by `operator` from `from`, this function is called.
417      *
418      * It must return its Solidity selector to confirm the token transfer.
419      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
420      *
421      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
422      */
423     function onERC721Received(
424         address operator,
425         address from,
426         uint256 tokenId,
427         bytes calldata data
428     ) external returns (bytes4);
429 }
430 
431 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Interface of the ERC165 standard, as defined in the
440  * https://eips.ethereum.org/EIPS/eip-165[EIP].
441  *
442  * Implementers can declare support of contract interfaces, which can then be
443  * queried by others ({ERC165Checker}).
444  *
445  * For an implementation, see {ERC165}.
446  */
447 interface IERC165 {
448     /**
449      * @dev Returns true if this contract implements the interface defined by
450      * `interfaceId`. See the corresponding
451      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
452      * to learn more about how these ids are created.
453      *
454      * This function call must use less than 30 000 gas.
455      */
456     function supportsInterface(bytes4 interfaceId) external view returns (bool);
457 }
458 
459 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Implementation of the {IERC165} interface.
469  *
470  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
471  * for the additional interface id that will be supported. For example:
472  *
473  * ```solidity
474  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
475  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
476  * }
477  * ```
478  *
479  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
480  */
481 abstract contract ERC165 is IERC165 {
482     /**
483      * @dev See {IERC165-supportsInterface}.
484      */
485     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486         return interfaceId == type(IERC165).interfaceId;
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
491 
492 
493 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509      */
510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
514      */
515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
516 
517     /**
518      * @dev Returns the number of tokens in ``owner``'s account.
519      */
520     function balanceOf(address owner) external view returns (uint256 balance);
521 
522     /**
523      * @dev Returns the owner of the `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId,
548         bytes calldata data
549     ) external;
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
553      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must exist and be owned by `from`.
560      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
561      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
562      *
563      * Emits a {Transfer} event.
564      */
565     function safeTransferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Transfers `tokenId` token from `from` to `to`.
573      *
574      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must be owned by `from`.
581      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
582      *
583      * Emits a {Transfer} event.
584      */
585     function transferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external;
590 
591     /**
592      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
593      * The approval is cleared when the token is transferred.
594      *
595      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
596      *
597      * Requirements:
598      *
599      * - The caller must own the token or be an approved operator.
600      * - `tokenId` must exist.
601      *
602      * Emits an {Approval} event.
603      */
604     function approve(address to, uint256 tokenId) external;
605 
606     /**
607      * @dev Approve or remove `operator` as an operator for the caller.
608      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
609      *
610      * Requirements:
611      *
612      * - The `operator` cannot be the caller.
613      *
614      * Emits an {ApprovalForAll} event.
615      */
616     function setApprovalForAll(address operator, bool _approved) external;
617 
618     /**
619      * @dev Returns the account approved for `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function getApproved(uint256 tokenId) external view returns (address operator);
626 
627     /**
628      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
629      *
630      * See {setApprovalForAll}
631      */
632     function isApprovedForAll(address owner, address operator) external view returns (bool);
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Metadata is IERC721 {
648     /**
649      * @dev Returns the token collection name.
650      */
651     function name() external view returns (string memory);
652 
653     /**
654      * @dev Returns the token collection symbol.
655      */
656     function symbol() external view returns (string memory);
657 
658     /**
659      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
660      */
661     function tokenURI(uint256 tokenId) external view returns (string memory);
662 }
663 
664 // File: contracts/ERC721A.sol
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
710         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
711         uint64 startTimestamp;
712         // Whether the token has been burned.
713         bool burned;
714     }
715 
716     // Compiler will pack this into a single 256bit word.
717     struct AddressData {
718         // Realistically, 2**64-1 is more than enough.
719         uint64 balance;
720         // Keeps track of mint count with minimal overhead for tokenomics.
721         uint64 numberMinted;
722         // Keeps track of burn count with minimal overhead for tokenomics.
723         uint64 numberBurned;
724         // For miscellaneous variable(s) pertaining to the address
725         // (e.g. number of whitelist mint slots used).
726         // If there are multiple variables, please pack them into a uint64.
727         uint64 aux;
728     }
729 
730     // The tokenId of the next token to be minted.
731     uint256 internal _currentIndex;
732 
733     // The number of tokens burned.
734     uint256 internal _burnCounter;
735 
736     // Token name
737     string private _name;
738 
739     // Token symbol
740     string private _symbol;
741 
742     // Mapping from token ID to ownership details
743     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
744     mapping(uint256 => TokenOwnership) internal _ownerships;
745 
746     // Mapping owner address to address data
747     mapping(address => AddressData) private _addressData;
748 
749     // Mapping from token ID to approved address
750     mapping(uint256 => address) private _tokenApprovals;
751 
752     // Mapping from owner to operator approvals
753     mapping(address => mapping(address => bool)) private _operatorApprovals;
754 
755     constructor(string memory name_, string memory symbol_) {
756         _name = name_;
757         _symbol = symbol_;
758         _currentIndex = _startTokenId();
759     }
760 
761     /**
762      * To change the starting tokenId, please override this function.
763      */
764     function _startTokenId() internal view virtual returns (uint256) {
765         return 0;
766     }
767 
768     /**
769      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
770      */
771     function totalSupply() public view returns (uint256) {
772         // Counter underflow is impossible as _burnCounter cannot be incremented
773         // more than _currentIndex - _startTokenId() times
774         unchecked {
775             return _currentIndex - _burnCounter - _startTokenId();
776         }
777     }
778 
779     /**
780      * Returns the total amount of tokens minted in the contract.
781      */
782     function _totalMinted() internal view returns (uint256) {
783         // Counter underflow is impossible as _currentIndex does not decrement,
784         // and it is initialized to _startTokenId()
785         unchecked {
786             return _currentIndex - _startTokenId();
787         }
788     }
789 
790     /**
791      * @dev See {IERC165-supportsInterface}.
792      */
793     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
794         return
795             interfaceId == type(IERC721).interfaceId ||
796             interfaceId == type(IERC721Metadata).interfaceId ||
797             super.supportsInterface(interfaceId);
798     }
799 
800     /**
801      * @dev See {IERC721-balanceOf}.
802      */
803     function balanceOf(address owner) public view override returns (uint256) {
804         if (owner == address(0)) revert BalanceQueryForZeroAddress();
805         return uint256(_addressData[owner].balance);
806     }
807 
808     /**
809      * Returns the number of tokens minted by `owner`.
810      */
811     function _numberMinted(address owner) internal view returns (uint256) {
812         return uint256(_addressData[owner].numberMinted);
813     }
814 
815     /**
816      * Returns the number of tokens burned by or on behalf of `owner`.
817      */
818     function _numberBurned(address owner) internal view returns (uint256) {
819         return uint256(_addressData[owner].numberBurned);
820     }
821 
822     /**
823      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
824      */
825     function _getAux(address owner) internal view returns (uint64) {
826         return _addressData[owner].aux;
827     }
828 
829     /**
830      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
831      * If there are multiple variables, please pack them into a uint64.
832      */
833     function _setAux(address owner, uint64 aux) internal {
834         _addressData[owner].aux = aux;
835     }
836 
837     /**
838      * Gas spent here starts off proportional to the maximum mint batch size.
839      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
840      */
841     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
842         uint256 curr = tokenId;
843 
844         unchecked {
845             if (_startTokenId() <= curr && curr < _currentIndex) {
846                 TokenOwnership memory ownership = _ownerships[curr];
847                 if (!ownership.burned) {
848                     if (ownership.addr != address(0)) {
849                         return ownership;
850                     }
851                     // Invariant:
852                     // There will always be an ownership that has an address and is not burned
853                     // before an ownership that does not have an address and is not burned.
854                     // Hence, curr will not underflow.
855                     while (true) {
856                         curr--;
857                         ownership = _ownerships[curr];
858                         if (ownership.addr != address(0)) {
859                             return ownership;
860                         }
861                     }
862                 }
863             }
864         }
865         revert OwnerQueryForNonexistentToken();
866     }
867 
868     /**
869      * @dev See {IERC721-ownerOf}.
870      */
871     function ownerOf(uint256 tokenId) public view override returns (address) {
872         return _ownershipOf(tokenId).addr;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-name}.
877      */
878     function name() public view virtual override returns (string memory) {
879         return _name;
880     }
881 
882     /**
883      * @dev See {IERC721Metadata-symbol}.
884      */
885     function symbol() public view virtual override returns (string memory) {
886         return _symbol;
887     }
888 
889     /**
890      * @dev See {IERC721Metadata-tokenURI}.
891      */
892     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
893         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
894 
895         string memory baseURI = _baseURI();
896         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
897     }
898 
899     /**
900      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
901      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
902      * by default, can be overriden in child contracts.
903      */
904     function _baseURI() internal view virtual returns (string memory) {
905         return '';
906     }
907 
908     /**
909      * @dev See {IERC721-approve}.
910      */
911     function approve(address to, uint256 tokenId) public override {
912         address owner = ERC721A.ownerOf(tokenId);
913         if (to == owner) revert ApprovalToCurrentOwner();
914 
915         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
916             revert ApprovalCallerNotOwnerNorApproved();
917         }
918 
919         _approve(to, tokenId, owner);
920     }
921 
922     /**
923      * @dev See {IERC721-getApproved}.
924      */
925     function getApproved(uint256 tokenId) public view override returns (address) {
926         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
927 
928         return _tokenApprovals[tokenId];
929     }
930 
931     /**
932      * @dev See {IERC721-setApprovalForAll}.
933      */
934     function setApprovalForAll(address operator, bool approved) public virtual override {
935         if (operator == _msgSender()) revert ApproveToCaller();
936 
937         _operatorApprovals[_msgSender()][operator] = approved;
938         emit ApprovalForAll(_msgSender(), operator, approved);
939     }
940 
941     /**
942      * @dev See {IERC721-isApprovedForAll}.
943      */
944     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
945         return _operatorApprovals[owner][operator];
946     }
947 
948     /**
949      * @dev See {IERC721-transferFrom}.
950      */
951     function transferFrom(
952         address from,
953         address to,
954         uint256 tokenId
955     ) public virtual override {
956         _transfer(from, to, tokenId);
957     }
958 
959     /**
960      * @dev See {IERC721-safeTransferFrom}.
961      */
962     function safeTransferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) public virtual override {
967         safeTransferFrom(from, to, tokenId, '');
968     }
969 
970     /**
971      * @dev See {IERC721-safeTransferFrom}.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) public virtual override {
979         _transfer(from, to, tokenId);
980         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
981             revert TransferToNonERC721ReceiverImplementer();
982         }
983     }
984 
985     /**
986      * @dev Returns whether `tokenId` exists.
987      *
988      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
989      *
990      * Tokens start existing when they are minted (`_mint`),
991      */
992     function _exists(uint256 tokenId) internal view returns (bool) {
993         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
994     }
995 
996     /**
997      * @dev Equivalent to `_safeMint(to, quantity, '')`.
998      */
999     function _safeMint(address to, uint256 quantity) internal {
1000         _safeMint(to, quantity, '');
1001     }
1002 
1003     /**
1004      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - If `to` refers to a smart contract, it must implement 
1009      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1010      * - `quantity` must be greater than 0.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _safeMint(
1015         address to,
1016         uint256 quantity,
1017         bytes memory _data
1018     ) internal {
1019         uint256 startTokenId = _currentIndex;
1020         if (to == address(0)) revert MintToZeroAddress();
1021         if (quantity == 0) revert MintZeroQuantity();
1022 
1023         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1024 
1025         // Overflows are incredibly unrealistic.
1026         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1027         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1028         unchecked {
1029             _addressData[to].balance += uint64(quantity);
1030             _addressData[to].numberMinted += uint64(quantity);
1031 
1032             _ownerships[startTokenId].addr = to;
1033             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1034 
1035             uint256 updatedIndex = startTokenId;
1036             uint256 end = updatedIndex + quantity;
1037 
1038             if (to.isContract()) {
1039                 do {
1040                     emit Transfer(address(0), to, updatedIndex);
1041                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1042                         revert TransferToNonERC721ReceiverImplementer();
1043                     }
1044                 } while (updatedIndex != end);
1045                 // Reentrancy protection
1046                 if (_currentIndex != startTokenId) revert();
1047             } else {
1048                 do {
1049                     emit Transfer(address(0), to, updatedIndex++);
1050                 } while (updatedIndex != end);
1051             }
1052             _currentIndex = updatedIndex;
1053         }
1054         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1055     }
1056 
1057     /**
1058      * @dev Mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `quantity` must be greater than 0.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _mint(address to, uint256 quantity) internal {
1068         uint256 startTokenId = _currentIndex;
1069         if (to == address(0)) revert MintToZeroAddress();
1070         if (quantity == 0) revert MintZeroQuantity();
1071 
1072         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1073 
1074         // Overflows are incredibly unrealistic.
1075         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1076         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1077         unchecked {
1078             _addressData[to].balance += uint64(quantity);
1079             _addressData[to].numberMinted += uint64(quantity);
1080 
1081             _ownerships[startTokenId].addr = to;
1082             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1083 
1084             uint256 updatedIndex = startTokenId;
1085             uint256 end = updatedIndex + quantity;
1086 
1087             do {
1088                 emit Transfer(address(0), to, updatedIndex++);
1089             } while (updatedIndex != end);
1090 
1091             _currentIndex = updatedIndex;
1092         }
1093         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1094     }
1095 
1096     /**
1097      * @dev Transfers `tokenId` from `from` to `to`.
1098      *
1099      * Requirements:
1100      *
1101      * - `to` cannot be the zero address.
1102      * - `tokenId` token must be owned by `from`.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _transfer(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) private {
1111         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1112 
1113         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1114 
1115         bool isApprovedOrOwner = (_msgSender() == from ||
1116             isApprovedForAll(from, _msgSender()) ||
1117             getApproved(tokenId) == _msgSender());
1118 
1119         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1120         if (to == address(0)) revert TransferToZeroAddress();
1121 
1122         _beforeTokenTransfers(from, to, tokenId, 1);
1123 
1124         // Clear approvals from the previous owner
1125         _approve(address(0), tokenId, from);
1126 
1127         // Underflow of the sender's balance is impossible because we check for
1128         // ownership above and the recipient's balance can't realistically overflow.
1129         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1130         unchecked {
1131             _addressData[from].balance -= 1;
1132             _addressData[to].balance += 1;
1133 
1134             TokenOwnership storage currSlot = _ownerships[tokenId];
1135             currSlot.addr = to;
1136             currSlot.startTimestamp = uint64(block.timestamp);
1137 
1138             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1139             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1140             uint256 nextTokenId = tokenId + 1;
1141             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1142             if (nextSlot.addr == address(0)) {
1143                 // This will suffice for checking _exists(nextTokenId),
1144                 // as a burned slot cannot contain the zero address.
1145                 if (nextTokenId != _currentIndex) {
1146                     nextSlot.addr = from;
1147                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1148                 }
1149             }
1150         }
1151 
1152         emit Transfer(from, to, tokenId);
1153         _afterTokenTransfers(from, to, tokenId, 1);
1154     }
1155 
1156     /**
1157      * @dev Equivalent to `_burn(tokenId, false)`.
1158      */
1159     function _burn(uint256 tokenId) internal virtual {
1160         _burn(tokenId, false);
1161     }
1162 
1163     /**
1164      * @dev Destroys `tokenId`.
1165      * The approval is cleared when the token is burned.
1166      *
1167      * Requirements:
1168      *
1169      * - `tokenId` must exist.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1174         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1175 
1176         address from = prevOwnership.addr;
1177 
1178         if (approvalCheck) {
1179             bool isApprovedOrOwner = (_msgSender() == from ||
1180                 isApprovedForAll(from, _msgSender()) ||
1181                 getApproved(tokenId) == _msgSender());
1182 
1183             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1184         }
1185 
1186         _beforeTokenTransfers(from, address(0), tokenId, 1);
1187 
1188         // Clear approvals from the previous owner
1189         _approve(address(0), tokenId, from);
1190 
1191         // Underflow of the sender's balance is impossible because we check for
1192         // ownership above and the recipient's balance can't realistically overflow.
1193         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1194         unchecked {
1195             AddressData storage addressData = _addressData[from];
1196             addressData.balance -= 1;
1197             addressData.numberBurned += 1;
1198 
1199             // Keep track of who burned the token, and the timestamp of burning.
1200             TokenOwnership storage currSlot = _ownerships[tokenId];
1201             currSlot.addr = from;
1202             currSlot.startTimestamp = uint64(block.timestamp);
1203             currSlot.burned = true;
1204 
1205             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1206             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1207             uint256 nextTokenId = tokenId + 1;
1208             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1209             if (nextSlot.addr == address(0)) {
1210                 // This will suffice for checking _exists(nextTokenId),
1211                 // as a burned slot cannot contain the zero address.
1212                 if (nextTokenId != _currentIndex) {
1213                     nextSlot.addr = from;
1214                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1215                 }
1216             }
1217         }
1218 
1219         emit Transfer(from, address(0), tokenId);
1220         _afterTokenTransfers(from, address(0), tokenId, 1);
1221 
1222         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1223         unchecked {
1224             _burnCounter++;
1225         }
1226     }
1227 
1228     /**
1229      * @dev Approve `to` to operate on `tokenId`
1230      *
1231      * Emits a {Approval} event.
1232      */
1233     function _approve(
1234         address to,
1235         uint256 tokenId,
1236         address owner
1237     ) private {
1238         _tokenApprovals[tokenId] = to;
1239         emit Approval(owner, to, tokenId);
1240     }
1241 
1242     /**
1243      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1244      *
1245      * @param from address representing the previous owner of the given token ID
1246      * @param to target address that will receive the tokens
1247      * @param tokenId uint256 ID of the token to be transferred
1248      * @param _data bytes optional data to send along with the call
1249      * @return bool whether the call correctly returned the expected magic value
1250      */
1251     function _checkContractOnERC721Received(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) private returns (bool) {
1257         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1258             return retval == IERC721Receiver(to).onERC721Received.selector;
1259         } catch (bytes memory reason) {
1260             if (reason.length == 0) {
1261                 revert TransferToNonERC721ReceiverImplementer();
1262             } else {
1263                 assembly {
1264                     revert(add(32, reason), mload(reason))
1265                 }
1266             }
1267         }
1268     }
1269 
1270     /**
1271      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1272      * And also called before burning one token.
1273      *
1274      * startTokenId - the first token id to be transferred
1275      * quantity - the amount to be transferred
1276      *
1277      * Calling conditions:
1278      *
1279      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1280      * transferred to `to`.
1281      * - When `from` is zero, `tokenId` will be minted for `to`.
1282      * - When `to` is zero, `tokenId` will be burned by `from`.
1283      * - `from` and `to` are never both zero.
1284      */
1285     function _beforeTokenTransfers(
1286         address from,
1287         address to,
1288         uint256 startTokenId,
1289         uint256 quantity
1290     ) internal virtual {}
1291 
1292     /**
1293      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1294      * minting.
1295      * And also called after one token has been burned.
1296      *
1297      * startTokenId - the first token id to be transferred
1298      * quantity - the amount to be transferred
1299      *
1300      * Calling conditions:
1301      *
1302      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1303      * transferred to `to`.
1304      * - When `from` is zero, `tokenId` has been minted for `to`.
1305      * - When `to` is zero, `tokenId` has been burned by `from`.
1306      * - `from` and `to` are never both zero.
1307      */
1308     function _afterTokenTransfers(
1309         address from,
1310         address to,
1311         uint256 startTokenId,
1312         uint256 quantity
1313     ) internal virtual {}
1314 }
1315 // File: contracts/ERC721AQueryable.sol
1316 
1317 
1318 // Creator: Chiru Labs
1319 
1320 pragma solidity ^0.8.4;
1321 
1322 
1323 error InvalidQueryRange();
1324 
1325 /**
1326  * @title ERC721A Queryable
1327  * @dev ERC721A subclass with convenience query functions.
1328  */
1329 abstract contract ERC721AQueryable is ERC721A {
1330     /**
1331      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1332      *
1333      * If the `tokenId` is out of bounds:
1334      *   - `addr` = `address(0)`
1335      *   - `startTimestamp` = `0`
1336      *   - `burned` = `false`
1337      *
1338      * If the `tokenId` is burned:
1339      *   - `addr` = `<Address of owner before token was burned>`
1340      *   - `startTimestamp` = `<Timestamp when token was burned>`
1341      *   - `burned = `true`
1342      *
1343      * Otherwise:
1344      *   - `addr` = `<Address of owner>`
1345      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1346      *   - `burned = `false`
1347      */
1348     function explicitOwnershipOf(uint256 tokenId) public view returns (TokenOwnership memory) {
1349         TokenOwnership memory ownership;
1350         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1351             return ownership;
1352         }
1353         ownership = _ownerships[tokenId];
1354         if (ownership.burned) {
1355             return ownership;
1356         }
1357         return _ownershipOf(tokenId);
1358     }
1359 
1360     /**
1361      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1362      * See {ERC721AQueryable-explicitOwnershipOf}
1363      */
1364     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory) {
1365         unchecked {
1366             uint256 tokenIdsLength = tokenIds.length;
1367             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1368             for (uint256 i; i != tokenIdsLength; ++i) {
1369                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1370             }
1371             return ownerships;
1372         }
1373     }
1374 
1375     /**
1376      * @dev Returns an array of token IDs owned by `owner`,
1377      * in the range [`start`, `stop`)
1378      * (i.e. `start <= tokenId < stop`).
1379      *
1380      * This function allows for tokens to be queried if the collection
1381      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1382      *
1383      * Requirements:
1384      *
1385      * - `start` < `stop`
1386      */
1387     function tokensOfOwnerIn(
1388         address owner,
1389         uint256 start,
1390         uint256 stop
1391     ) external view returns (uint256[] memory) {
1392         unchecked {
1393             if (start >= stop) revert InvalidQueryRange();
1394             uint256 tokenIdsIdx;
1395             uint256 stopLimit = _currentIndex;
1396             // Set `start = max(start, _startTokenId())`.
1397             if (start < _startTokenId()) {
1398                 start = _startTokenId();
1399             }
1400             // Set `stop = min(stop, _currentIndex)`.
1401             if (stop > stopLimit) {
1402                 stop = stopLimit;
1403             }
1404             uint256 tokenIdsMaxLength = balanceOf(owner);
1405             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1406             // to cater for cases where `balanceOf(owner)` is too big.
1407             if (start < stop) {
1408                 uint256 rangeLength = stop - start;
1409                 if (rangeLength < tokenIdsMaxLength) {
1410                     tokenIdsMaxLength = rangeLength;
1411                 }
1412             } else {
1413                 tokenIdsMaxLength = 0;
1414             }
1415             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1416             if (tokenIdsMaxLength == 0) {
1417                 return tokenIds;
1418             }
1419             // We need to call `explicitOwnershipOf(start)`,
1420             // because the slot at `start` may not be initialized.
1421             TokenOwnership memory ownership = explicitOwnershipOf(start);
1422             address currOwnershipAddr;
1423             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1424             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1425             if (!ownership.burned) {
1426                 currOwnershipAddr = ownership.addr;
1427             }
1428             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1429                 ownership = _ownerships[i];
1430                 if (ownership.burned) {
1431                     continue;
1432                 }
1433                 if (ownership.addr != address(0)) {
1434                     currOwnershipAddr = ownership.addr;
1435                 }
1436                 if (currOwnershipAddr == owner) {
1437                     tokenIds[tokenIdsIdx++] = i;
1438                 }
1439             }
1440             // Downsize the array to fit.
1441             assembly {
1442                 mstore(tokenIds, tokenIdsIdx)
1443             }
1444             return tokenIds;
1445         }
1446     }
1447 
1448     /**
1449      * @dev Returns an array of token IDs owned by `owner`.
1450      *
1451      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1452      * It is meant to be called off-chain.
1453      *
1454      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1455      * multiple smaller scans if the collection is large enough to cause
1456      * an out-of-gas error (10K pfp collections should be fine).
1457      */
1458     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1459         unchecked {
1460             uint256 tokenIdsIdx;
1461             address currOwnershipAddr;
1462             uint256 tokenIdsLength = balanceOf(owner);
1463             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1464             TokenOwnership memory ownership;
1465             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1466                 ownership = _ownerships[i];
1467                 if (ownership.burned) {
1468                     continue;
1469                 }
1470                 if (ownership.addr != address(0)) {
1471                     currOwnershipAddr = ownership.addr;
1472                 }
1473                 if (currOwnershipAddr == owner) {
1474                     tokenIds[tokenIdsIdx++] = i;
1475                 }
1476             }
1477             return tokenIds;
1478         }
1479     }
1480 }
1481 // File: contracts/SnakeGame.sol
1482 
1483 
1484 
1485 pragma solidity ^0.8.4;
1486 
1487 
1488 
1489 
1490 contract SnakeGameNFT is ERC721A, Ownable {
1491 
1492     string public baseURI = "https://gateway.pinata.cloud/ipfs/QmXbKhvwxHkN7r9WdEhCoU7tEUqZP5WPmYFeJUJkgWoTzW/";
1493     string public constant baseExtension = ".json";
1494     uint256 public constant MAX_FREE = 1;
1495     uint256 public constant MAX_PER_TX = 10;
1496     uint256 public constant MAX_SUPPLY = 800;
1497     uint256 public price = 0.005 ether;
1498 
1499     bool public paused = true;
1500 
1501     constructor() ERC721A("Snake Game NFT", "SnakeGameNFT") {}
1502 
1503     function mint(uint256 _amount) external payable {
1504         address _caller = _msgSender();
1505         require(!paused, "Paused");
1506         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1507         require(_amount > 0, "No 0 mints");
1508         require(tx.origin == _caller, "No contracts");
1509         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1510         require(_amount * price == msg.value, "Invalid funds provided");
1511 
1512         _safeMint(_caller, _amount);
1513     }
1514 
1515     function freeMint() external payable {
1516         address _caller = _msgSender();
1517         require(!paused, "Paused");
1518         require(MAX_SUPPLY >= totalSupply() + 1, "Exceeds max supply");
1519         require(tx.origin == _caller, "No contracts");
1520         require(MAX_FREE >= uint256(_getAux(_caller)) + 1, "Excess max per free wallet");
1521 
1522         _setAux(_caller, 1);
1523         _safeMint(_caller, 1);
1524     }
1525 
1526     function _startTokenId() internal override view virtual returns (uint256) {
1527         return 1;
1528     }
1529 
1530     function minted(address _owner) public view returns (uint256) {
1531         return _numberMinted(_owner);
1532     }
1533 
1534     function withdraw() external onlyOwner {
1535         uint256 balance = address(this).balance;
1536         (bool success, ) = _msgSender().call{value: balance}("");
1537         require(success, "Failed to send");
1538     }
1539 
1540     function teamMint(uint256 _number) external onlyOwner {
1541         _safeMint(_msgSender(), _number);
1542     }
1543 
1544     function setPrice(uint256 _price) external onlyOwner {
1545         price = _price;
1546     }
1547 
1548     function pause(bool _state) external onlyOwner {
1549         paused = _state;
1550     }
1551 
1552     function setBaseURI(string memory baseURI_) external onlyOwner {
1553         baseURI = baseURI_;
1554     }
1555 
1556     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1557         require(_exists(_tokenId), "Token does not exist.");
1558         return bytes(baseURI).length > 0 ? string(
1559             abi.encodePacked(
1560               baseURI,
1561               Strings.toString(_tokenId),
1562               baseExtension
1563             )
1564         ) : "";
1565     }
1566 }