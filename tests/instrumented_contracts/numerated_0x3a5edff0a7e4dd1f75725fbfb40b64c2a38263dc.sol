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
404 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
421      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Transfers `tokenId` token from `from` to `to`.
553      *
554      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
573      * The approval is cleared when the token is transferred.
574      *
575      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
576      *
577      * Requirements:
578      *
579      * - The caller must own the token or be an approved operator.
580      * - `tokenId` must exist.
581      *
582      * Emits an {Approval} event.
583      */
584     function approve(address to, uint256 tokenId) external;
585 
586     /**
587      * @dev Returns the account approved for `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function getApproved(uint256 tokenId) external view returns (address operator);
594 
595     /**
596      * @dev Approve or remove `operator` as an operator for the caller.
597      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
598      *
599      * Requirements:
600      *
601      * - The `operator` cannot be the caller.
602      *
603      * Emits an {ApprovalForAll} event.
604      */
605     function setApprovalForAll(address operator, bool _approved) external;
606 
607     /**
608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
609      *
610      * See {setApprovalForAll}
611      */
612     function isApprovedForAll(address owner, address operator) external view returns (bool);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes calldata data
632     ) external;
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
664 // File: https://github.com/chiru-labs/ERC721A/blob/v3.1.0/contracts/ERC721A.sol
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
993         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
994             !_ownerships[tokenId].burned;
995     }
996 
997     function _safeMint(address to, uint256 quantity) internal {
998         _safeMint(to, quantity, '');
999     }
1000 
1001     /**
1002      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1007      * - `quantity` must be greater than 0.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _safeMint(
1012         address to,
1013         uint256 quantity,
1014         bytes memory _data
1015     ) internal {
1016         _mint(to, quantity, _data, true);
1017     }
1018 
1019     /**
1020      * @dev Mints `quantity` tokens and transfers them to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `quantity` must be greater than 0.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _mint(
1030         address to,
1031         uint256 quantity,
1032         bytes memory _data,
1033         bool safe
1034     ) internal {
1035         uint256 startTokenId = _currentIndex;
1036         if (to == address(0)) revert MintToZeroAddress();
1037         if (quantity == 0) revert MintZeroQuantity();
1038 
1039         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1040 
1041         // Overflows are incredibly unrealistic.
1042         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1043         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1044         unchecked {
1045             _addressData[to].balance += uint64(quantity);
1046             _addressData[to].numberMinted += uint64(quantity);
1047 
1048             _ownerships[startTokenId].addr = to;
1049             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1050 
1051             uint256 updatedIndex = startTokenId;
1052             uint256 end = updatedIndex + quantity;
1053 
1054             if (safe && to.isContract()) {
1055                 do {
1056                     emit Transfer(address(0), to, updatedIndex);
1057                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1058                         revert TransferToNonERC721ReceiverImplementer();
1059                     }
1060                 } while (updatedIndex != end);
1061                 // Reentrancy protection
1062                 if (_currentIndex != startTokenId) revert();
1063             } else {
1064                 do {
1065                     emit Transfer(address(0), to, updatedIndex++);
1066                 } while (updatedIndex != end);
1067             }
1068             _currentIndex = updatedIndex;
1069         }
1070         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1071     }
1072 
1073     /**
1074      * @dev Transfers `tokenId` from `from` to `to`.
1075      *
1076      * Requirements:
1077      *
1078      * - `to` cannot be the zero address.
1079      * - `tokenId` token must be owned by `from`.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _transfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) private {
1088         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1089 
1090         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1091 
1092         bool isApprovedOrOwner = (_msgSender() == from ||
1093             isApprovedForAll(from, _msgSender()) ||
1094             getApproved(tokenId) == _msgSender());
1095 
1096         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1097         if (to == address(0)) revert TransferToZeroAddress();
1098 
1099         _beforeTokenTransfers(from, to, tokenId, 1);
1100 
1101         // Clear approvals from the previous owner
1102         _approve(address(0), tokenId, from);
1103 
1104         // Underflow of the sender's balance is impossible because we check for
1105         // ownership above and the recipient's balance can't realistically overflow.
1106         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1107         unchecked {
1108             _addressData[from].balance -= 1;
1109             _addressData[to].balance += 1;
1110 
1111             TokenOwnership storage currSlot = _ownerships[tokenId];
1112             currSlot.addr = to;
1113             currSlot.startTimestamp = uint64(block.timestamp);
1114 
1115             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1116             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1117             uint256 nextTokenId = tokenId + 1;
1118             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1119             if (nextSlot.addr == address(0)) {
1120                 // This will suffice for checking _exists(nextTokenId),
1121                 // as a burned slot cannot contain the zero address.
1122                 if (nextTokenId != _currentIndex) {
1123                     nextSlot.addr = from;
1124                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1125                 }
1126             }
1127         }
1128 
1129         emit Transfer(from, to, tokenId);
1130         _afterTokenTransfers(from, to, tokenId, 1);
1131     }
1132 
1133     /**
1134      * @dev This is equivalent to _burn(tokenId, false)
1135      */
1136     function _burn(uint256 tokenId) internal virtual {
1137         _burn(tokenId, false);
1138     }
1139 
1140     /**
1141      * @dev Destroys `tokenId`.
1142      * The approval is cleared when the token is burned.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must exist.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1151         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1152 
1153         address from = prevOwnership.addr;
1154 
1155         if (approvalCheck) {
1156             bool isApprovedOrOwner = (_msgSender() == from ||
1157                 isApprovedForAll(from, _msgSender()) ||
1158                 getApproved(tokenId) == _msgSender());
1159 
1160             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1161         }
1162 
1163         _beforeTokenTransfers(from, address(0), tokenId, 1);
1164 
1165         // Clear approvals from the previous owner
1166         _approve(address(0), tokenId, from);
1167 
1168         // Underflow of the sender's balance is impossible because we check for
1169         // ownership above and the recipient's balance can't realistically overflow.
1170         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1171         unchecked {
1172             AddressData storage addressData = _addressData[from];
1173             addressData.balance -= 1;
1174             addressData.numberBurned += 1;
1175 
1176             // Keep track of who burned the token, and the timestamp of burning.
1177             TokenOwnership storage currSlot = _ownerships[tokenId];
1178             currSlot.addr = from;
1179             currSlot.startTimestamp = uint64(block.timestamp);
1180             currSlot.burned = true;
1181 
1182             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1183             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1184             uint256 nextTokenId = tokenId + 1;
1185             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1186             if (nextSlot.addr == address(0)) {
1187                 // This will suffice for checking _exists(nextTokenId),
1188                 // as a burned slot cannot contain the zero address.
1189                 if (nextTokenId != _currentIndex) {
1190                     nextSlot.addr = from;
1191                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1192                 }
1193             }
1194         }
1195 
1196         emit Transfer(from, address(0), tokenId);
1197         _afterTokenTransfers(from, address(0), tokenId, 1);
1198 
1199         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1200         unchecked {
1201             _burnCounter++;
1202         }
1203     }
1204 
1205     /**
1206      * @dev Approve `to` to operate on `tokenId`
1207      *
1208      * Emits a {Approval} event.
1209      */
1210     function _approve(
1211         address to,
1212         uint256 tokenId,
1213         address owner
1214     ) private {
1215         _tokenApprovals[tokenId] = to;
1216         emit Approval(owner, to, tokenId);
1217     }
1218 
1219     /**
1220      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1221      *
1222      * @param from address representing the previous owner of the given token ID
1223      * @param to target address that will receive the tokens
1224      * @param tokenId uint256 ID of the token to be transferred
1225      * @param _data bytes optional data to send along with the call
1226      * @return bool whether the call correctly returned the expected magic value
1227      */
1228     function _checkContractOnERC721Received(
1229         address from,
1230         address to,
1231         uint256 tokenId,
1232         bytes memory _data
1233     ) private returns (bool) {
1234         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1235             return retval == IERC721Receiver(to).onERC721Received.selector;
1236         } catch (bytes memory reason) {
1237             if (reason.length == 0) {
1238                 revert TransferToNonERC721ReceiverImplementer();
1239             } else {
1240                 assembly {
1241                     revert(add(32, reason), mload(reason))
1242                 }
1243             }
1244         }
1245     }
1246 
1247     /**
1248      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1249      * And also called before burning one token.
1250      *
1251      * startTokenId - the first token id to be transferred
1252      * quantity - the amount to be transferred
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` will be minted for `to`.
1259      * - When `to` is zero, `tokenId` will be burned by `from`.
1260      * - `from` and `to` are never both zero.
1261      */
1262     function _beforeTokenTransfers(
1263         address from,
1264         address to,
1265         uint256 startTokenId,
1266         uint256 quantity
1267     ) internal virtual {}
1268 
1269     /**
1270      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1271      * minting.
1272      * And also called after one token has been burned.
1273      *
1274      * startTokenId - the first token id to be transferred
1275      * quantity - the amount to be transferred
1276      *
1277      * Calling conditions:
1278      *
1279      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1280      * transferred to `to`.
1281      * - When `from` is zero, `tokenId` has been minted for `to`.
1282      * - When `to` is zero, `tokenId` has been burned by `from`.
1283      * - `from` and `to` are never both zero.
1284      */
1285     function _afterTokenTransfers(
1286         address from,
1287         address to,
1288         uint256 startTokenId,
1289         uint256 quantity
1290     ) internal virtual {}
1291 }
1292 
1293 // File: contract.sol
1294 
1295 
1296 pragma solidity 0.8.13;
1297 
1298 
1299 
1300 contract NOUNBIRDS is ERC721A, Ownable {
1301     uint16 public constant MAX_SUPPLY = 10000;
1302     uint8 public constant MAX_PER_WALLET = 3;
1303 
1304     bool private revealed = false;
1305     string private baseUri = "https://gateway.pinata.cloud/ipfs/QmQFFP5qiJTRQUFs5jby5Ff79U9XRftwE4wmXerVmNdg61/";
1306     uint96 private royaltyBasisPoints = 750;
1307 
1308     constructor() ERC721A("Nounbirds", "NOUNBIRDS") {}
1309 
1310     function soldOut() external view returns (bool) {
1311         return totalSupply() == MAX_SUPPLY;
1312     }
1313 
1314     function numberMinted(address owner) external view returns (uint256) {
1315         return _numberMinted(owner);
1316     }
1317 
1318     function mint(uint256 _quantity) external {
1319         require(_quantity > 0, "INCORRECT_QUANTITY");
1320         require(_numberMinted(msg.sender) + _quantity <= MAX_PER_WALLET, "INCORRECT_QUANTITY");
1321         require(totalSupply() + _quantity <= MAX_SUPPLY, "SALE_MAXED");
1322 
1323         _safeMint(msg.sender, _quantity);
1324     }
1325 
1326     function devMint(uint256 _quantity) external onlyOwner {
1327         require(_quantity > 0, "INCORRECT_QUANTITY");
1328         require(totalSupply() + _quantity <= MAX_SUPPLY, "SALE_MAXED");
1329         
1330         _safeMint(msg.sender, _quantity);
1331     }
1332 
1333     function _startTokenId() internal view virtual override returns (uint256) {
1334         return 0;
1335     }
1336 
1337     function setBaseUri(string calldata _baseUri) external onlyOwner {
1338         baseUri = _baseUri;
1339     }
1340 
1341     function reveal(string calldata _baseUri) external onlyOwner {
1342         revealed = true;
1343         baseUri = _baseUri;
1344     }
1345 
1346     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1347         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1348 
1349         string memory filename = revealed ? Strings.toString(tokenId) : "hidden";
1350         return bytes(baseUri).length != 0 ? string(abi.encodePacked(baseUri, filename, ".json")) : '';
1351     }
1352 
1353     function setRoyalty(uint96 _royaltyBasisPoints) external onlyOwner {
1354         royaltyBasisPoints = _royaltyBasisPoints;
1355     }
1356 
1357     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
1358         require(_exists(_tokenId), "Cannot query non-existent token");
1359         return (owner(), (_salePrice * royaltyBasisPoints) / 10000);
1360     }
1361 
1362     function transferFunds() external onlyOwner {
1363         payable(owner()).transfer(address(this).balance);
1364     }
1365 }