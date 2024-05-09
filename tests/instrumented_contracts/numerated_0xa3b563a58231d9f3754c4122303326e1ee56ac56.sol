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
179 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
180 
181 pragma solidity ^0.8.0;
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
203      */
204     function isContract(address account) internal view returns (bool) {
205         // This method relies on extcodesize, which returns 0 for contracts in
206         // construction, since the code is only stored at the end of the
207         // constructor execution.
208 
209         uint256 size;
210         assembly {
211             size := extcodesize(account)
212         }
213         return size > 0;
214     }
215 
216     /**
217      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
218      * `recipient`, forwarding all available gas and reverting on errors.
219      *
220      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
221      * of certain opcodes, possibly making contracts go over the 2300 gas limit
222      * imposed by `transfer`, making them unable to receive funds via
223      * `transfer`. {sendValue} removes this limitation.
224      *
225      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
226      *
227      * IMPORTANT: because control is transferred to `recipient`, care must be
228      * taken to not create reentrancy vulnerabilities. Consider using
229      * {ReentrancyGuard} or the
230      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
231      */
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(address(this).balance >= amount, "Address: insufficient balance");
234 
235         (bool success, ) = recipient.call{value: amount}("");
236         require(success, "Address: unable to send value, recipient may have reverted");
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain `call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
263      * `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, 0, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but also transferring `value` wei to `target`.
278      *
279      * Requirements:
280      *
281      * - the calling contract must have an ETH balance of at least `value`.
282      * - the called Solidity function must be `payable`.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(
287         address target,
288         bytes memory data,
289         uint256 value
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
296      * with `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         require(address(this).balance >= value, "Address: insufficient balance for call");
307         require(isContract(target), "Address: call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.call{value: value}(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
320         return functionStaticCall(target, data, "Address: low-level static call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal view returns (bytes memory) {
334         require(isContract(target), "Address: static call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.staticcall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(isContract(target), "Address: delegate call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.delegatecall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
369      * revert reason using the provided one.
370      *
371      * _Available since v4.3._
372      */
373     function verifyCallResult(
374         bool success,
375         bytes memory returndata,
376         string memory errorMessage
377     ) internal pure returns (bytes memory) {
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @title ERC721 token receiver interface
405  * @dev Interface for any contract that wants to support safeTransfers
406  * from ERC721 asset contracts.
407  */
408 interface IERC721Receiver {
409     /**
410      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
411      * by `operator` from `from`, this function is called.
412      *
413      * It must return its Solidity selector to confirm the token transfer.
414      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
415      *
416      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
417      */
418     function onERC721Received(
419         address operator,
420         address from,
421         uint256 tokenId,
422         bytes calldata data
423     ) external returns (bytes4);
424 }
425 
426 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @dev Interface of the ERC165 standard, as defined in the
435  * https://eips.ethereum.org/EIPS/eip-165[EIP].
436  *
437  * Implementers can declare support of contract interfaces, which can then be
438  * queried by others ({ERC165Checker}).
439  *
440  * For an implementation, see {ERC165}.
441  */
442 interface IERC165 {
443     /**
444      * @dev Returns true if this contract implements the interface defined by
445      * `interfaceId`. See the corresponding
446      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
447      * to learn more about how these ids are created.
448      *
449      * This function call must use less than 30 000 gas.
450      */
451     function supportsInterface(bytes4 interfaceId) external view returns (bool);
452 }
453 
454 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 /**
463  * @dev Implementation of the {IERC165} interface.
464  *
465  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
466  * for the additional interface id that will be supported. For example:
467  *
468  * ```solidity
469  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
470  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
471  * }
472  * ```
473  *
474  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
475  */
476 abstract contract ERC165 is IERC165 {
477     /**
478      * @dev See {IERC165-supportsInterface}.
479      */
480     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481         return interfaceId == type(IERC165).interfaceId;
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 
493 /**
494  * @dev Required interface of an ERC721 compliant contract.
495  */
496 interface IERC721 is IERC165 {
497     /**
498      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
499      */
500     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
501 
502     /**
503      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
504      */
505     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
509      */
510     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
511 
512     /**
513      * @dev Returns the number of tokens in ``owner``'s account.
514      */
515     function balanceOf(address owner) external view returns (uint256 balance);
516 
517     /**
518      * @dev Returns the owner of the `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function ownerOf(uint256 tokenId) external view returns (address owner);
525 
526     /**
527      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
528      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must exist and be owned by `from`.
535      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
536      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
537      *
538      * Emits a {Transfer} event.
539      */
540     function safeTransferFrom(
541         address from,
542         address to,
543         uint256 tokenId
544     ) external;
545 
546     /**
547      * @dev Transfers `tokenId` token from `from` to `to`.
548      *
549      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must be owned by `from`.
556      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
557      *
558      * Emits a {Transfer} event.
559      */
560     function transferFrom(
561         address from,
562         address to,
563         uint256 tokenId
564     ) external;
565 
566     /**
567      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
568      * The approval is cleared when the token is transferred.
569      *
570      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
571      *
572      * Requirements:
573      *
574      * - The caller must own the token or be an approved operator.
575      * - `tokenId` must exist.
576      *
577      * Emits an {Approval} event.
578      */
579     function approve(address to, uint256 tokenId) external;
580 
581     /**
582      * @dev Returns the account approved for `tokenId` token.
583      *
584      * Requirements:
585      *
586      * - `tokenId` must exist.
587      */
588     function getApproved(uint256 tokenId) external view returns (address operator);
589 
590     /**
591      * @dev Approve or remove `operator` as an operator for the caller.
592      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
593      *
594      * Requirements:
595      *
596      * - The `operator` cannot be the caller.
597      *
598      * Emits an {ApprovalForAll} event.
599      */
600     function setApprovalForAll(address operator, bool _approved) external;
601 
602     /**
603      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
604      *
605      * See {setApprovalForAll}
606      */
607     function isApprovedForAll(address owner, address operator) external view returns (bool);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must exist and be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
619      *
620      * Emits a {Transfer} event.
621      */
622     function safeTransferFrom(
623         address from,
624         address to,
625         uint256 tokenId,
626         bytes calldata data
627     ) external;
628 }
629 
630 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
640  * @dev See https://eips.ethereum.org/EIPS/eip-721
641  */
642 interface IERC721Metadata is IERC721 {
643     /**
644      * @dev Returns the token collection name.
645      */
646     function name() external view returns (string memory);
647 
648     /**
649      * @dev Returns the token collection symbol.
650      */
651     function symbol() external view returns (string memory);
652 
653     /**
654      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
655      */
656     function tokenURI(uint256 tokenId) external view returns (string memory);
657 }
658 
659 // File: erc721a/contracts/ERC721A.sol
660 
661 
662 // Creator: Chiru Labs
663 
664 pragma solidity ^0.8.4;
665 
666 
667 
668 
669 
670 
671 
672 
673 error ApprovalCallerNotOwnerNorApproved();
674 error ApprovalQueryForNonexistentToken();
675 error ApproveToCaller();
676 error ApprovalToCurrentOwner();
677 error BalanceQueryForZeroAddress();
678 error MintToZeroAddress();
679 error MintZeroQuantity();
680 error OwnerQueryForNonexistentToken();
681 error TransferCallerNotOwnerNorApproved();
682 error TransferFromIncorrectOwner();
683 error TransferToNonERC721ReceiverImplementer();
684 error TransferToZeroAddress();
685 error URIQueryForNonexistentToken();
686 
687 /**
688  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
689  * the Metadata extension. Built to optimize for lower gas during batch mints.
690  *
691  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
692  *
693  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
694  *
695  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
696  */
697 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
698     using Address for address;
699     using Strings for uint256;
700 
701     // Compiler will pack this into a single 256bit word.
702     struct TokenOwnership {
703         // The address of the owner.
704         address addr;
705         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
706         uint64 startTimestamp;
707         // Whether the token has been burned.
708         bool burned;
709     }
710 
711     // Compiler will pack this into a single 256bit word.
712     struct AddressData {
713         // Realistically, 2**64-1 is more than enough.
714         uint64 balance;
715         // Keeps track of mint count with minimal overhead for tokenomics.
716         uint64 numberMinted;
717         // Keeps track of burn count with minimal overhead for tokenomics.
718         uint64 numberBurned;
719         // For miscellaneous variable(s) pertaining to the address
720         // (e.g. number of whitelist mint slots used).
721         // If there are multiple variables, please pack them into a uint64.
722         uint64 aux;
723     }
724 
725     // The tokenId of the next token to be minted.
726     uint256 internal _currentIndex;
727 
728     // The number of tokens burned.
729     uint256 internal _burnCounter;
730 
731     // Token name
732     string private _name;
733 
734     // Token symbol
735     string private _symbol;
736 
737     // Mapping from token ID to ownership details
738     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
739     mapping(uint256 => TokenOwnership) internal _ownerships;
740 
741     // Mapping owner address to address data
742     mapping(address => AddressData) private _addressData;
743 
744     // Mapping from token ID to approved address
745     mapping(uint256 => address) private _tokenApprovals;
746 
747     // Mapping from owner to operator approvals
748     mapping(address => mapping(address => bool)) private _operatorApprovals;
749 
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753         _currentIndex = _startTokenId();
754     }
755 
756     /**
757      * To change the starting tokenId, please override this function.
758      */
759     function _startTokenId() internal view virtual returns (uint256) {
760         return 0;
761     }
762 
763     /**
764      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
765      */
766     function totalSupply() public view returns (uint256) {
767         // Counter underflow is impossible as _burnCounter cannot be incremented
768         // more than _currentIndex - _startTokenId() times
769         unchecked {
770             return _currentIndex - _burnCounter - _startTokenId();
771         }
772     }
773 
774     /**
775      * Returns the total amount of tokens minted in the contract.
776      */
777     function _totalMinted() internal view returns (uint256) {
778         // Counter underflow is impossible as _currentIndex does not decrement,
779         // and it is initialized to _startTokenId()
780         unchecked {
781             return _currentIndex - _startTokenId();
782         }
783     }
784 
785     /**
786      * @dev See {IERC165-supportsInterface}.
787      */
788     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
789         return
790             interfaceId == type(IERC721).interfaceId ||
791             interfaceId == type(IERC721Metadata).interfaceId ||
792             super.supportsInterface(interfaceId);
793     }
794 
795     /**
796      * @dev See {IERC721-balanceOf}.
797      */
798     function balanceOf(address owner) public view override returns (uint256) {
799         if (owner == address(0)) revert BalanceQueryForZeroAddress();
800         return uint256(_addressData[owner].balance);
801     }
802 
803     /**
804      * Returns the number of tokens minted by `owner`.
805      */
806     function _numberMinted(address owner) internal view returns (uint256) {
807         return uint256(_addressData[owner].numberMinted);
808     }
809 
810     /**
811      * Returns the number of tokens burned by or on behalf of `owner`.
812      */
813     function _numberBurned(address owner) internal view returns (uint256) {
814         return uint256(_addressData[owner].numberBurned);
815     }
816 
817     /**
818      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
819      */
820     function _getAux(address owner) internal view returns (uint64) {
821         return _addressData[owner].aux;
822     }
823 
824     /**
825      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
826      * If there are multiple variables, please pack them into a uint64.
827      */
828     function _setAux(address owner, uint64 aux) internal {
829         _addressData[owner].aux = aux;
830     }
831 
832     /**
833      * Gas spent here starts off proportional to the maximum mint batch size.
834      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
835      */
836     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
837         uint256 curr = tokenId;
838 
839         unchecked {
840             if (_startTokenId() <= curr && curr < _currentIndex) {
841                 TokenOwnership memory ownership = _ownerships[curr];
842                 if (!ownership.burned) {
843                     if (ownership.addr != address(0)) {
844                         return ownership;
845                     }
846                     // Invariant:
847                     // There will always be an ownership that has an address and is not burned
848                     // before an ownership that does not have an address and is not burned.
849                     // Hence, curr will not underflow.
850                     while (true) {
851                         curr--;
852                         ownership = _ownerships[curr];
853                         if (ownership.addr != address(0)) {
854                             return ownership;
855                         }
856                     }
857                 }
858             }
859         }
860         revert OwnerQueryForNonexistentToken();
861     }
862 
863     /**
864      * @dev See {IERC721-ownerOf}.
865      */
866     function ownerOf(uint256 tokenId) public view override returns (address) {
867         return _ownershipOf(tokenId).addr;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-name}.
872      */
873     function name() public view virtual override returns (string memory) {
874         return _name;
875     }
876 
877     /**
878      * @dev See {IERC721Metadata-symbol}.
879      */
880     function symbol() public view virtual override returns (string memory) {
881         return _symbol;
882     }
883 
884     /**
885      * @dev See {IERC721Metadata-tokenURI}.
886      */
887     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
888         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
889 
890         string memory baseURI = _baseURI();
891         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
892     }
893 
894     /**
895      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
896      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
897      * by default, can be overriden in child contracts.
898      */
899     function _baseURI() internal view virtual returns (string memory) {
900         return '';
901     }
902 
903     /**
904      * @dev See {IERC721-approve}.
905      */
906     function approve(address to, uint256 tokenId) public override {
907         address owner = ERC721A.ownerOf(tokenId);
908         if (to == owner) revert ApprovalToCurrentOwner();
909 
910         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
911             revert ApprovalCallerNotOwnerNorApproved();
912         }
913 
914         _approve(to, tokenId, owner);
915     }
916 
917     /**
918      * @dev See {IERC721-getApproved}.
919      */
920     function getApproved(uint256 tokenId) public view override returns (address) {
921         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
922 
923         return _tokenApprovals[tokenId];
924     }
925 
926     /**
927      * @dev See {IERC721-setApprovalForAll}.
928      */
929     function setApprovalForAll(address operator, bool approved) public virtual override {
930         if (operator == _msgSender()) revert ApproveToCaller();
931 
932         _operatorApprovals[_msgSender()][operator] = approved;
933         emit ApprovalForAll(_msgSender(), operator, approved);
934     }
935 
936     /**
937      * @dev See {IERC721-isApprovedForAll}.
938      */
939     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
940         return _operatorApprovals[owner][operator];
941     }
942 
943     /**
944      * @dev See {IERC721-transferFrom}.
945      */
946     function transferFrom(
947         address from,
948         address to,
949         uint256 tokenId
950     ) public virtual override {
951         _transfer(from, to, tokenId);
952     }
953 
954     /**
955      * @dev See {IERC721-safeTransferFrom}.
956      */
957     function safeTransferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         safeTransferFrom(from, to, tokenId, '');
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) public virtual override {
974         _transfer(from, to, tokenId);
975         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
976             revert TransferToNonERC721ReceiverImplementer();
977         }
978     }
979 
980     /**
981      * @dev Returns whether `tokenId` exists.
982      *
983      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
984      *
985      * Tokens start existing when they are minted (`_mint`),
986      */
987     function _exists(uint256 tokenId) internal view returns (bool) {
988         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
989             !_ownerships[tokenId].burned;
990     }
991 
992     function _safeMint(address to, uint256 quantity) internal {
993         _safeMint(to, quantity, '');
994     }
995 
996     /**
997      * @dev Safely mints `quantity` tokens and transfers them to `to`.
998      *
999      * Requirements:
1000      *
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1002      * - `quantity` must be greater than 0.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeMint(
1007         address to,
1008         uint256 quantity,
1009         bytes memory _data
1010     ) internal {
1011         _mint(to, quantity, _data, true);
1012     }
1013 
1014     /**
1015      * @dev Mints `quantity` tokens and transfers them to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `quantity` must be greater than 0.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _mint(
1025         address to,
1026         uint256 quantity,
1027         bytes memory _data,
1028         bool safe
1029     ) internal {
1030         uint256 startTokenId = _currentIndex;
1031         if (to == address(0)) revert MintToZeroAddress();
1032         if (quantity == 0) revert MintZeroQuantity();
1033 
1034         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1035 
1036         // Overflows are incredibly unrealistic.
1037         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1038         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1039         unchecked {
1040             _addressData[to].balance += uint64(quantity);
1041             _addressData[to].numberMinted += uint64(quantity);
1042 
1043             _ownerships[startTokenId].addr = to;
1044             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1045 
1046             uint256 updatedIndex = startTokenId;
1047             uint256 end = updatedIndex + quantity;
1048 
1049             if (safe && to.isContract()) {
1050                 do {
1051                     emit Transfer(address(0), to, updatedIndex);
1052                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1053                         revert TransferToNonERC721ReceiverImplementer();
1054                     }
1055                 } while (updatedIndex != end);
1056                 // Reentrancy protection
1057                 if (_currentIndex != startTokenId) revert();
1058             } else {
1059                 do {
1060                     emit Transfer(address(0), to, updatedIndex++);
1061                 } while (updatedIndex != end);
1062             }
1063             _currentIndex = updatedIndex;
1064         }
1065         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1066     }
1067 
1068     /**
1069      * @dev Transfers `tokenId` from `from` to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - `to` cannot be the zero address.
1074      * - `tokenId` token must be owned by `from`.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _transfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) private {
1083         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1084 
1085         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1086 
1087         bool isApprovedOrOwner = (_msgSender() == from ||
1088             isApprovedForAll(from, _msgSender()) ||
1089             getApproved(tokenId) == _msgSender());
1090 
1091         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1092         if (to == address(0)) revert TransferToZeroAddress();
1093 
1094         _beforeTokenTransfers(from, to, tokenId, 1);
1095 
1096         // Clear approvals from the previous owner
1097         _approve(address(0), tokenId, from);
1098 
1099         // Underflow of the sender's balance is impossible because we check for
1100         // ownership above and the recipient's balance can't realistically overflow.
1101         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1102         unchecked {
1103             _addressData[from].balance -= 1;
1104             _addressData[to].balance += 1;
1105 
1106             TokenOwnership storage currSlot = _ownerships[tokenId];
1107             currSlot.addr = to;
1108             currSlot.startTimestamp = uint64(block.timestamp);
1109 
1110             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1111             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1112             uint256 nextTokenId = tokenId + 1;
1113             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1114             if (nextSlot.addr == address(0)) {
1115                 // This will suffice for checking _exists(nextTokenId),
1116                 // as a burned slot cannot contain the zero address.
1117                 if (nextTokenId != _currentIndex) {
1118                     nextSlot.addr = from;
1119                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1120                 }
1121             }
1122         }
1123 
1124         emit Transfer(from, to, tokenId);
1125         _afterTokenTransfers(from, to, tokenId, 1);
1126     }
1127 
1128     /**
1129      * @dev This is equivalent to _burn(tokenId, false)
1130      */
1131     function _burn(uint256 tokenId) internal virtual {
1132         _burn(tokenId, false);
1133     }
1134 
1135     /**
1136      * @dev Destroys `tokenId`.
1137      * The approval is cleared when the token is burned.
1138      *
1139      * Requirements:
1140      *
1141      * - `tokenId` must exist.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1146         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1147 
1148         address from = prevOwnership.addr;
1149 
1150         if (approvalCheck) {
1151             bool isApprovedOrOwner = (_msgSender() == from ||
1152                 isApprovedForAll(from, _msgSender()) ||
1153                 getApproved(tokenId) == _msgSender());
1154 
1155             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1156         }
1157 
1158         _beforeTokenTransfers(from, address(0), tokenId, 1);
1159 
1160         // Clear approvals from the previous owner
1161         _approve(address(0), tokenId, from);
1162 
1163         // Underflow of the sender's balance is impossible because we check for
1164         // ownership above and the recipient's balance can't realistically overflow.
1165         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1166         unchecked {
1167             AddressData storage addressData = _addressData[from];
1168             addressData.balance -= 1;
1169             addressData.numberBurned += 1;
1170 
1171             // Keep track of who burned the token, and the timestamp of burning.
1172             TokenOwnership storage currSlot = _ownerships[tokenId];
1173             currSlot.addr = from;
1174             currSlot.startTimestamp = uint64(block.timestamp);
1175             currSlot.burned = true;
1176 
1177             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1178             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1179             uint256 nextTokenId = tokenId + 1;
1180             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1181             if (nextSlot.addr == address(0)) {
1182                 // This will suffice for checking _exists(nextTokenId),
1183                 // as a burned slot cannot contain the zero address.
1184                 if (nextTokenId != _currentIndex) {
1185                     nextSlot.addr = from;
1186                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1187                 }
1188             }
1189         }
1190 
1191         emit Transfer(from, address(0), tokenId);
1192         _afterTokenTransfers(from, address(0), tokenId, 1);
1193 
1194         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1195         unchecked {
1196             _burnCounter++;
1197         }
1198     }
1199 
1200     /**
1201      * @dev Approve `to` to operate on `tokenId`
1202      *
1203      * Emits a {Approval} event.
1204      */
1205     function _approve(
1206         address to,
1207         uint256 tokenId,
1208         address owner
1209     ) private {
1210         _tokenApprovals[tokenId] = to;
1211         emit Approval(owner, to, tokenId);
1212     }
1213 
1214     /**
1215      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1216      *
1217      * @param from address representing the previous owner of the given token ID
1218      * @param to target address that will receive the tokens
1219      * @param tokenId uint256 ID of the token to be transferred
1220      * @param _data bytes optional data to send along with the call
1221      * @return bool whether the call correctly returned the expected magic value
1222      */
1223     function _checkContractOnERC721Received(
1224         address from,
1225         address to,
1226         uint256 tokenId,
1227         bytes memory _data
1228     ) private returns (bool) {
1229         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1230             return retval == IERC721Receiver(to).onERC721Received.selector;
1231         } catch (bytes memory reason) {
1232             if (reason.length == 0) {
1233                 revert TransferToNonERC721ReceiverImplementer();
1234             } else {
1235                 assembly {
1236                     revert(add(32, reason), mload(reason))
1237                 }
1238             }
1239         }
1240     }
1241 
1242     /**
1243      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1244      * And also called before burning one token.
1245      *
1246      * startTokenId - the first token id to be transferred
1247      * quantity - the amount to be transferred
1248      *
1249      * Calling conditions:
1250      *
1251      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1252      * transferred to `to`.
1253      * - When `from` is zero, `tokenId` will be minted for `to`.
1254      * - When `to` is zero, `tokenId` will be burned by `from`.
1255      * - `from` and `to` are never both zero.
1256      */
1257     function _beforeTokenTransfers(
1258         address from,
1259         address to,
1260         uint256 startTokenId,
1261         uint256 quantity
1262     ) internal virtual {}
1263 
1264     /**
1265      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1266      * minting.
1267      * And also called after one token has been burned.
1268      *
1269      * startTokenId - the first token id to be transferred
1270      * quantity - the amount to be transferred
1271      *
1272      * Calling conditions:
1273      *
1274      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1275      * transferred to `to`.
1276      * - When `from` is zero, `tokenId` has been minted for `to`.
1277      * - When `to` is zero, `tokenId` has been burned by `from`.
1278      * - `from` and `to` are never both zero.
1279      */
1280     function _afterTokenTransfers(
1281         address from,
1282         address to,
1283         uint256 startTokenId,
1284         uint256 quantity
1285     ) internal virtual {}
1286 }
1287 
1288 // File: hardhat/console.sol
1289 
1290 
1291 pragma solidity >= 0.4.22 <0.9.0;
1292 
1293 library console {
1294 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1295 
1296 	function _sendLogPayload(bytes memory payload) private view {
1297 		uint256 payloadLength = payload.length;
1298 		address consoleAddress = CONSOLE_ADDRESS;
1299 		assembly {
1300 			let payloadStart := add(payload, 32)
1301 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1302 		}
1303 	}
1304 
1305 	function log() internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log()"));
1307 	}
1308 
1309 	function logInt(int p0) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1311 	}
1312 
1313 	function logUint(uint p0) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1315 	}
1316 
1317 	function logString(string memory p0) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1319 	}
1320 
1321 	function logBool(bool p0) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1323 	}
1324 
1325 	function logAddress(address p0) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1327 	}
1328 
1329 	function logBytes(bytes memory p0) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1331 	}
1332 
1333 	function logBytes1(bytes1 p0) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1335 	}
1336 
1337 	function logBytes2(bytes2 p0) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1339 	}
1340 
1341 	function logBytes3(bytes3 p0) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1343 	}
1344 
1345 	function logBytes4(bytes4 p0) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1347 	}
1348 
1349 	function logBytes5(bytes5 p0) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1351 	}
1352 
1353 	function logBytes6(bytes6 p0) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1355 	}
1356 
1357 	function logBytes7(bytes7 p0) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1359 	}
1360 
1361 	function logBytes8(bytes8 p0) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1363 	}
1364 
1365 	function logBytes9(bytes9 p0) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1367 	}
1368 
1369 	function logBytes10(bytes10 p0) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1371 	}
1372 
1373 	function logBytes11(bytes11 p0) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1375 	}
1376 
1377 	function logBytes12(bytes12 p0) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1379 	}
1380 
1381 	function logBytes13(bytes13 p0) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1383 	}
1384 
1385 	function logBytes14(bytes14 p0) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1387 	}
1388 
1389 	function logBytes15(bytes15 p0) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1391 	}
1392 
1393 	function logBytes16(bytes16 p0) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1395 	}
1396 
1397 	function logBytes17(bytes17 p0) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1399 	}
1400 
1401 	function logBytes18(bytes18 p0) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1403 	}
1404 
1405 	function logBytes19(bytes19 p0) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1407 	}
1408 
1409 	function logBytes20(bytes20 p0) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1411 	}
1412 
1413 	function logBytes21(bytes21 p0) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1415 	}
1416 
1417 	function logBytes22(bytes22 p0) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1419 	}
1420 
1421 	function logBytes23(bytes23 p0) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1423 	}
1424 
1425 	function logBytes24(bytes24 p0) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1427 	}
1428 
1429 	function logBytes25(bytes25 p0) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1431 	}
1432 
1433 	function logBytes26(bytes26 p0) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1435 	}
1436 
1437 	function logBytes27(bytes27 p0) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1439 	}
1440 
1441 	function logBytes28(bytes28 p0) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1443 	}
1444 
1445 	function logBytes29(bytes29 p0) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1447 	}
1448 
1449 	function logBytes30(bytes30 p0) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1451 	}
1452 
1453 	function logBytes31(bytes31 p0) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1455 	}
1456 
1457 	function logBytes32(bytes32 p0) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1459 	}
1460 
1461 	function log(uint p0) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1463 	}
1464 
1465 	function log(string memory p0) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1467 	}
1468 
1469 	function log(bool p0) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1471 	}
1472 
1473 	function log(address p0) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1475 	}
1476 
1477 	function log(uint p0, uint p1) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1479 	}
1480 
1481 	function log(uint p0, string memory p1) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1483 	}
1484 
1485 	function log(uint p0, bool p1) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1487 	}
1488 
1489 	function log(uint p0, address p1) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1491 	}
1492 
1493 	function log(string memory p0, uint p1) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1495 	}
1496 
1497 	function log(string memory p0, string memory p1) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1499 	}
1500 
1501 	function log(string memory p0, bool p1) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1503 	}
1504 
1505 	function log(string memory p0, address p1) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1507 	}
1508 
1509 	function log(bool p0, uint p1) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1511 	}
1512 
1513 	function log(bool p0, string memory p1) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1515 	}
1516 
1517 	function log(bool p0, bool p1) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1519 	}
1520 
1521 	function log(bool p0, address p1) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1523 	}
1524 
1525 	function log(address p0, uint p1) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1527 	}
1528 
1529 	function log(address p0, string memory p1) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1531 	}
1532 
1533 	function log(address p0, bool p1) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1535 	}
1536 
1537 	function log(address p0, address p1) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1539 	}
1540 
1541 	function log(uint p0, uint p1, uint p2) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1543 	}
1544 
1545 	function log(uint p0, uint p1, string memory p2) internal view {
1546 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1547 	}
1548 
1549 	function log(uint p0, uint p1, bool p2) internal view {
1550 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1551 	}
1552 
1553 	function log(uint p0, uint p1, address p2) internal view {
1554 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1555 	}
1556 
1557 	function log(uint p0, string memory p1, uint p2) internal view {
1558 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1559 	}
1560 
1561 	function log(uint p0, string memory p1, string memory p2) internal view {
1562 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1563 	}
1564 
1565 	function log(uint p0, string memory p1, bool p2) internal view {
1566 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1567 	}
1568 
1569 	function log(uint p0, string memory p1, address p2) internal view {
1570 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1571 	}
1572 
1573 	function log(uint p0, bool p1, uint p2) internal view {
1574 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1575 	}
1576 
1577 	function log(uint p0, bool p1, string memory p2) internal view {
1578 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1579 	}
1580 
1581 	function log(uint p0, bool p1, bool p2) internal view {
1582 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1583 	}
1584 
1585 	function log(uint p0, bool p1, address p2) internal view {
1586 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1587 	}
1588 
1589 	function log(uint p0, address p1, uint p2) internal view {
1590 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1591 	}
1592 
1593 	function log(uint p0, address p1, string memory p2) internal view {
1594 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1595 	}
1596 
1597 	function log(uint p0, address p1, bool p2) internal view {
1598 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1599 	}
1600 
1601 	function log(uint p0, address p1, address p2) internal view {
1602 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1603 	}
1604 
1605 	function log(string memory p0, uint p1, uint p2) internal view {
1606 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1607 	}
1608 
1609 	function log(string memory p0, uint p1, string memory p2) internal view {
1610 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1611 	}
1612 
1613 	function log(string memory p0, uint p1, bool p2) internal view {
1614 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1615 	}
1616 
1617 	function log(string memory p0, uint p1, address p2) internal view {
1618 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1619 	}
1620 
1621 	function log(string memory p0, string memory p1, uint p2) internal view {
1622 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1623 	}
1624 
1625 	function log(string memory p0, string memory p1, string memory p2) internal view {
1626 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1627 	}
1628 
1629 	function log(string memory p0, string memory p1, bool p2) internal view {
1630 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1631 	}
1632 
1633 	function log(string memory p0, string memory p1, address p2) internal view {
1634 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1635 	}
1636 
1637 	function log(string memory p0, bool p1, uint p2) internal view {
1638 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1639 	}
1640 
1641 	function log(string memory p0, bool p1, string memory p2) internal view {
1642 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1643 	}
1644 
1645 	function log(string memory p0, bool p1, bool p2) internal view {
1646 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1647 	}
1648 
1649 	function log(string memory p0, bool p1, address p2) internal view {
1650 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1651 	}
1652 
1653 	function log(string memory p0, address p1, uint p2) internal view {
1654 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1655 	}
1656 
1657 	function log(string memory p0, address p1, string memory p2) internal view {
1658 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1659 	}
1660 
1661 	function log(string memory p0, address p1, bool p2) internal view {
1662 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1663 	}
1664 
1665 	function log(string memory p0, address p1, address p2) internal view {
1666 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1667 	}
1668 
1669 	function log(bool p0, uint p1, uint p2) internal view {
1670 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1671 	}
1672 
1673 	function log(bool p0, uint p1, string memory p2) internal view {
1674 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1675 	}
1676 
1677 	function log(bool p0, uint p1, bool p2) internal view {
1678 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1679 	}
1680 
1681 	function log(bool p0, uint p1, address p2) internal view {
1682 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1683 	}
1684 
1685 	function log(bool p0, string memory p1, uint p2) internal view {
1686 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1687 	}
1688 
1689 	function log(bool p0, string memory p1, string memory p2) internal view {
1690 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1691 	}
1692 
1693 	function log(bool p0, string memory p1, bool p2) internal view {
1694 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1695 	}
1696 
1697 	function log(bool p0, string memory p1, address p2) internal view {
1698 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1699 	}
1700 
1701 	function log(bool p0, bool p1, uint p2) internal view {
1702 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1703 	}
1704 
1705 	function log(bool p0, bool p1, string memory p2) internal view {
1706 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1707 	}
1708 
1709 	function log(bool p0, bool p1, bool p2) internal view {
1710 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1711 	}
1712 
1713 	function log(bool p0, bool p1, address p2) internal view {
1714 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1715 	}
1716 
1717 	function log(bool p0, address p1, uint p2) internal view {
1718 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1719 	}
1720 
1721 	function log(bool p0, address p1, string memory p2) internal view {
1722 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1723 	}
1724 
1725 	function log(bool p0, address p1, bool p2) internal view {
1726 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1727 	}
1728 
1729 	function log(bool p0, address p1, address p2) internal view {
1730 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1731 	}
1732 
1733 	function log(address p0, uint p1, uint p2) internal view {
1734 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1735 	}
1736 
1737 	function log(address p0, uint p1, string memory p2) internal view {
1738 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1739 	}
1740 
1741 	function log(address p0, uint p1, bool p2) internal view {
1742 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1743 	}
1744 
1745 	function log(address p0, uint p1, address p2) internal view {
1746 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1747 	}
1748 
1749 	function log(address p0, string memory p1, uint p2) internal view {
1750 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1751 	}
1752 
1753 	function log(address p0, string memory p1, string memory p2) internal view {
1754 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1755 	}
1756 
1757 	function log(address p0, string memory p1, bool p2) internal view {
1758 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1759 	}
1760 
1761 	function log(address p0, string memory p1, address p2) internal view {
1762 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1763 	}
1764 
1765 	function log(address p0, bool p1, uint p2) internal view {
1766 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1767 	}
1768 
1769 	function log(address p0, bool p1, string memory p2) internal view {
1770 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1771 	}
1772 
1773 	function log(address p0, bool p1, bool p2) internal view {
1774 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1775 	}
1776 
1777 	function log(address p0, bool p1, address p2) internal view {
1778 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1779 	}
1780 
1781 	function log(address p0, address p1, uint p2) internal view {
1782 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1783 	}
1784 
1785 	function log(address p0, address p1, string memory p2) internal view {
1786 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1787 	}
1788 
1789 	function log(address p0, address p1, bool p2) internal view {
1790 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1791 	}
1792 
1793 	function log(address p0, address p1, address p2) internal view {
1794 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1795 	}
1796 
1797 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1798 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1799 	}
1800 
1801 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1802 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1803 	}
1804 
1805 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1806 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1807 	}
1808 
1809 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1810 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1811 	}
1812 
1813 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1814 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1815 	}
1816 
1817 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1818 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1819 	}
1820 
1821 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1822 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1823 	}
1824 
1825 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1826 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1827 	}
1828 
1829 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1830 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1831 	}
1832 
1833 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1834 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1835 	}
1836 
1837 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1838 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1839 	}
1840 
1841 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1842 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1843 	}
1844 
1845 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1846 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1847 	}
1848 
1849 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1850 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1851 	}
1852 
1853 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1854 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1855 	}
1856 
1857 	function log(uint p0, uint p1, address p2, address p3) internal view {
1858 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1859 	}
1860 
1861 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1862 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1863 	}
1864 
1865 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1866 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1867 	}
1868 
1869 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1870 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1871 	}
1872 
1873 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1874 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1875 	}
1876 
1877 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1878 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1879 	}
1880 
1881 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1882 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1883 	}
1884 
1885 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1886 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1887 	}
1888 
1889 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1890 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1891 	}
1892 
1893 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1894 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1895 	}
1896 
1897 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1898 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1899 	}
1900 
1901 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1902 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1903 	}
1904 
1905 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1906 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1907 	}
1908 
1909 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1910 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1911 	}
1912 
1913 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1914 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1915 	}
1916 
1917 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1918 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1919 	}
1920 
1921 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1922 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1923 	}
1924 
1925 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1926 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1927 	}
1928 
1929 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1930 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1931 	}
1932 
1933 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1934 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1935 	}
1936 
1937 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1938 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1939 	}
1940 
1941 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1942 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1943 	}
1944 
1945 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1946 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1947 	}
1948 
1949 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1950 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1951 	}
1952 
1953 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1954 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1955 	}
1956 
1957 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1958 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1959 	}
1960 
1961 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1962 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1963 	}
1964 
1965 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1966 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1967 	}
1968 
1969 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1970 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1971 	}
1972 
1973 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1974 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1975 	}
1976 
1977 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1978 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1979 	}
1980 
1981 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1982 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1983 	}
1984 
1985 	function log(uint p0, bool p1, address p2, address p3) internal view {
1986 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1987 	}
1988 
1989 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1990 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1991 	}
1992 
1993 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1994 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1995 	}
1996 
1997 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1998 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1999 	}
2000 
2001 	function log(uint p0, address p1, uint p2, address p3) internal view {
2002 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2003 	}
2004 
2005 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2006 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2007 	}
2008 
2009 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2010 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2011 	}
2012 
2013 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2014 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2015 	}
2016 
2017 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2018 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2019 	}
2020 
2021 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2022 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2023 	}
2024 
2025 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2026 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2027 	}
2028 
2029 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2030 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2031 	}
2032 
2033 	function log(uint p0, address p1, bool p2, address p3) internal view {
2034 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2035 	}
2036 
2037 	function log(uint p0, address p1, address p2, uint p3) internal view {
2038 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2039 	}
2040 
2041 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2042 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2043 	}
2044 
2045 	function log(uint p0, address p1, address p2, bool p3) internal view {
2046 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2047 	}
2048 
2049 	function log(uint p0, address p1, address p2, address p3) internal view {
2050 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2051 	}
2052 
2053 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2054 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2055 	}
2056 
2057 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2058 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2059 	}
2060 
2061 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2062 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2063 	}
2064 
2065 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2066 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2067 	}
2068 
2069 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2070 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2071 	}
2072 
2073 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2074 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2075 	}
2076 
2077 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2078 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2079 	}
2080 
2081 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2082 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2083 	}
2084 
2085 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2086 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2087 	}
2088 
2089 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2090 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2091 	}
2092 
2093 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2094 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2095 	}
2096 
2097 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2098 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2099 	}
2100 
2101 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2102 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2103 	}
2104 
2105 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2106 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2107 	}
2108 
2109 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2110 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2111 	}
2112 
2113 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2114 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2115 	}
2116 
2117 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2118 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2119 	}
2120 
2121 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2122 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2123 	}
2124 
2125 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2126 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2127 	}
2128 
2129 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2130 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2131 	}
2132 
2133 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2134 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2135 	}
2136 
2137 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2138 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2139 	}
2140 
2141 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2142 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2143 	}
2144 
2145 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2146 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2147 	}
2148 
2149 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2150 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2151 	}
2152 
2153 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2154 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2155 	}
2156 
2157 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2158 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2159 	}
2160 
2161 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2162 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2163 	}
2164 
2165 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2166 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2167 	}
2168 
2169 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2170 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2171 	}
2172 
2173 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2174 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2175 	}
2176 
2177 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2178 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2179 	}
2180 
2181 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2182 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2183 	}
2184 
2185 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2186 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2187 	}
2188 
2189 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2190 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2191 	}
2192 
2193 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2194 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2195 	}
2196 
2197 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2198 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2199 	}
2200 
2201 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2202 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2203 	}
2204 
2205 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2206 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2207 	}
2208 
2209 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2210 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2211 	}
2212 
2213 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2214 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2215 	}
2216 
2217 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2218 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2219 	}
2220 
2221 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2222 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2223 	}
2224 
2225 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2226 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2227 	}
2228 
2229 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2230 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2231 	}
2232 
2233 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2234 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2235 	}
2236 
2237 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2238 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2239 	}
2240 
2241 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2242 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2243 	}
2244 
2245 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2246 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2247 	}
2248 
2249 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2250 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2251 	}
2252 
2253 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2254 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2255 	}
2256 
2257 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2258 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2259 	}
2260 
2261 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2262 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2263 	}
2264 
2265 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2266 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2267 	}
2268 
2269 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2270 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2271 	}
2272 
2273 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2274 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2275 	}
2276 
2277 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2278 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2279 	}
2280 
2281 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2282 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2283 	}
2284 
2285 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2286 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2287 	}
2288 
2289 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2290 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2291 	}
2292 
2293 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2294 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2295 	}
2296 
2297 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2298 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2299 	}
2300 
2301 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2302 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2303 	}
2304 
2305 	function log(string memory p0, address p1, address p2, address p3) internal view {
2306 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2307 	}
2308 
2309 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2310 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2311 	}
2312 
2313 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2314 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2315 	}
2316 
2317 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2318 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2319 	}
2320 
2321 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2322 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2323 	}
2324 
2325 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2326 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2327 	}
2328 
2329 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2330 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2331 	}
2332 
2333 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2334 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2335 	}
2336 
2337 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2338 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2339 	}
2340 
2341 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2342 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2343 	}
2344 
2345 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2346 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2347 	}
2348 
2349 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2350 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2351 	}
2352 
2353 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2354 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2355 	}
2356 
2357 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2358 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2359 	}
2360 
2361 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2362 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2363 	}
2364 
2365 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2366 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2367 	}
2368 
2369 	function log(bool p0, uint p1, address p2, address p3) internal view {
2370 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2371 	}
2372 
2373 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2374 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2375 	}
2376 
2377 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2378 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2379 	}
2380 
2381 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2382 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2383 	}
2384 
2385 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2386 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2387 	}
2388 
2389 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2390 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2391 	}
2392 
2393 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2394 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2395 	}
2396 
2397 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2398 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2399 	}
2400 
2401 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2402 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2403 	}
2404 
2405 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2406 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2407 	}
2408 
2409 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2410 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2411 	}
2412 
2413 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2414 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2415 	}
2416 
2417 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2418 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2419 	}
2420 
2421 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2422 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2423 	}
2424 
2425 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2426 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2427 	}
2428 
2429 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2430 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2431 	}
2432 
2433 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2434 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2435 	}
2436 
2437 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2438 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2439 	}
2440 
2441 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2442 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2443 	}
2444 
2445 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2446 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2447 	}
2448 
2449 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2450 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2451 	}
2452 
2453 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2454 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2455 	}
2456 
2457 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2458 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2459 	}
2460 
2461 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2462 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2463 	}
2464 
2465 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2466 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2467 	}
2468 
2469 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2470 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2471 	}
2472 
2473 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2474 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2475 	}
2476 
2477 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2478 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2479 	}
2480 
2481 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2482 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2483 	}
2484 
2485 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2486 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2487 	}
2488 
2489 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2490 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2491 	}
2492 
2493 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2494 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2495 	}
2496 
2497 	function log(bool p0, bool p1, address p2, address p3) internal view {
2498 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2499 	}
2500 
2501 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2502 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2503 	}
2504 
2505 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2506 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2507 	}
2508 
2509 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2510 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2511 	}
2512 
2513 	function log(bool p0, address p1, uint p2, address p3) internal view {
2514 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2515 	}
2516 
2517 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2518 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2519 	}
2520 
2521 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2522 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2523 	}
2524 
2525 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2526 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2527 	}
2528 
2529 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2530 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2531 	}
2532 
2533 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2534 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2535 	}
2536 
2537 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2538 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2539 	}
2540 
2541 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2542 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2543 	}
2544 
2545 	function log(bool p0, address p1, bool p2, address p3) internal view {
2546 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2547 	}
2548 
2549 	function log(bool p0, address p1, address p2, uint p3) internal view {
2550 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2551 	}
2552 
2553 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2554 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2555 	}
2556 
2557 	function log(bool p0, address p1, address p2, bool p3) internal view {
2558 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2559 	}
2560 
2561 	function log(bool p0, address p1, address p2, address p3) internal view {
2562 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2563 	}
2564 
2565 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2566 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2567 	}
2568 
2569 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2570 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2571 	}
2572 
2573 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2574 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2575 	}
2576 
2577 	function log(address p0, uint p1, uint p2, address p3) internal view {
2578 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2579 	}
2580 
2581 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2582 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2583 	}
2584 
2585 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2586 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2587 	}
2588 
2589 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2590 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2591 	}
2592 
2593 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2594 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2595 	}
2596 
2597 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2598 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2599 	}
2600 
2601 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2602 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2603 	}
2604 
2605 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2606 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2607 	}
2608 
2609 	function log(address p0, uint p1, bool p2, address p3) internal view {
2610 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2611 	}
2612 
2613 	function log(address p0, uint p1, address p2, uint p3) internal view {
2614 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2615 	}
2616 
2617 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2618 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2619 	}
2620 
2621 	function log(address p0, uint p1, address p2, bool p3) internal view {
2622 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2623 	}
2624 
2625 	function log(address p0, uint p1, address p2, address p3) internal view {
2626 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2627 	}
2628 
2629 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2630 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2631 	}
2632 
2633 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2634 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2635 	}
2636 
2637 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2638 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2639 	}
2640 
2641 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2642 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2643 	}
2644 
2645 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2646 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2647 	}
2648 
2649 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2650 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2651 	}
2652 
2653 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2654 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2655 	}
2656 
2657 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2658 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2659 	}
2660 
2661 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2662 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2663 	}
2664 
2665 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2666 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2667 	}
2668 
2669 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2670 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2671 	}
2672 
2673 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2674 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2675 	}
2676 
2677 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2678 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2679 	}
2680 
2681 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2682 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2683 	}
2684 
2685 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2686 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2687 	}
2688 
2689 	function log(address p0, string memory p1, address p2, address p3) internal view {
2690 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2691 	}
2692 
2693 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2694 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2695 	}
2696 
2697 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2698 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2699 	}
2700 
2701 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2702 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2703 	}
2704 
2705 	function log(address p0, bool p1, uint p2, address p3) internal view {
2706 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2707 	}
2708 
2709 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2710 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2711 	}
2712 
2713 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2714 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2715 	}
2716 
2717 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2718 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2719 	}
2720 
2721 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2722 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2723 	}
2724 
2725 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2726 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2727 	}
2728 
2729 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2730 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2731 	}
2732 
2733 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2734 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2735 	}
2736 
2737 	function log(address p0, bool p1, bool p2, address p3) internal view {
2738 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2739 	}
2740 
2741 	function log(address p0, bool p1, address p2, uint p3) internal view {
2742 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2743 	}
2744 
2745 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2746 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2747 	}
2748 
2749 	function log(address p0, bool p1, address p2, bool p3) internal view {
2750 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2751 	}
2752 
2753 	function log(address p0, bool p1, address p2, address p3) internal view {
2754 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2755 	}
2756 
2757 	function log(address p0, address p1, uint p2, uint p3) internal view {
2758 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2759 	}
2760 
2761 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2762 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2763 	}
2764 
2765 	function log(address p0, address p1, uint p2, bool p3) internal view {
2766 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2767 	}
2768 
2769 	function log(address p0, address p1, uint p2, address p3) internal view {
2770 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2771 	}
2772 
2773 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2774 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2775 	}
2776 
2777 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2778 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2779 	}
2780 
2781 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2782 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2783 	}
2784 
2785 	function log(address p0, address p1, string memory p2, address p3) internal view {
2786 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2787 	}
2788 
2789 	function log(address p0, address p1, bool p2, uint p3) internal view {
2790 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2791 	}
2792 
2793 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2794 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2795 	}
2796 
2797 	function log(address p0, address p1, bool p2, bool p3) internal view {
2798 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2799 	}
2800 
2801 	function log(address p0, address p1, bool p2, address p3) internal view {
2802 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2803 	}
2804 
2805 	function log(address p0, address p1, address p2, uint p3) internal view {
2806 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2807 	}
2808 
2809 	function log(address p0, address p1, address p2, string memory p3) internal view {
2810 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2811 	}
2812 
2813 	function log(address p0, address p1, address p2, bool p3) internal view {
2814 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2815 	}
2816 
2817 	function log(address p0, address p1, address p2, address p3) internal view {
2818 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2819 	}
2820 
2821 }
2822 
2823 // File: contracts/knk721A.sol
2824 
2825 //SPDX-License-Identifier: Unlicense
2826 pragma solidity ^0.8.0;
2827 
2828 
2829 
2830 
2831 
2832 contract KujiraNoKonton is ERC721A, Ownable {
2833     using Strings for uint256;
2834 
2835     string public notRevealedURI;
2836     bool public presaleOpen = false;
2837     bool public publicSaleOpen = false;
2838     bool public revealed = false;
2839     uint256 public devMintQuantity = 100;
2840     uint256 public maxSupply = 5000;
2841     uint256 public wlDiscountPrice = 0.035 ether;
2842     uint256 public wlPrice = 0.063 ether;
2843     uint256 public publicSalePrice = 0.07 ether;
2844     string public baseTokenURI;
2845     mapping(address => bool) public freeMintList;
2846     mapping(address => bool) public WlDiscountList;
2847     mapping(address => bool) public WlList;
2848  
2849     constructor(string memory _notRevealedURI) ERC721A("KUJIRA NO KONTON", "KNK") {
2850         notRevealedURI = _notRevealedURI;
2851     }
2852 
2853     function freeMint() public {
2854         require(presaleOpen, "The mint is not open yet");
2855         require(freeMintList[msg.sender], "You're not on the freemint list");
2856         uint256 supply = totalSupply();
2857         require(supply <= maxSupply, "There is not enough NFT left");
2858         _safeMint(msg.sender, 1);
2859         freeMintList[msg.sender] = false;
2860     }
2861 
2862     function wlDiscountMint(uint256 _quantity) public payable {
2863         require(presaleOpen, "the wl Discount Mint is not open");
2864         require(WlDiscountList[msg.sender], "You're not registered on the wl Discount");
2865         require(numberMinted(msg.sender) + _quantity <= 2, "You already have 2 nft");
2866         uint256 supply = totalSupply();
2867         require(supply + _quantity <= maxSupply, "There is not enough NFT left");
2868         require(msg.value >= _quantity * wlDiscountPrice);
2869         _safeMint(msg.sender, _quantity);
2870     }
2871 
2872     function wlMint(uint256 _quantity) public payable {
2873         require(presaleOpen, "the wl Discount Mint is not open");
2874         require(WlList[msg.sender], "You're not registered on the wl Discount");
2875         require(numberMinted(msg.sender) + _quantity <= 3, "You already have 3 nft");
2876         uint256 supply = totalSupply();
2877         require(supply + _quantity <= maxSupply, "There is not enough NFT left");
2878         require(msg.value >= _quantity * wlPrice);
2879         _safeMint(msg.sender, _quantity);
2880     }
2881 
2882     function publicMint(uint256 _quantity) public payable {
2883         require(publicSaleOpen, "public sale is not open");
2884         require(_quantity <= 10, "the maximum amount of NFT you can mint is 10");
2885         uint256 supply = totalSupply();
2886         require(supply + _quantity <= maxSupply, "There is not enough NFT left");
2887         require(msg.value >= _quantity * publicSalePrice);
2888         _safeMint(msg.sender, _quantity);
2889     }
2890 
2891     function devMint(uint256 _quantity) public onlyOwner {
2892         require(numberMinted(msg.sender) + _quantity <= devMintQuantity, "the dev already mint 100 NFT");
2893         uint256 supply = totalSupply();
2894         require(supply + _quantity <= maxSupply, "there is not enough NFT left");
2895         _safeMint(msg.sender, _quantity);
2896     }
2897 
2898     //list handling
2899     function setFreeMintList(address[] memory _addresses) public onlyOwner {
2900         require(_addresses.length > 0, "array is empty");
2901         for (uint256 i = 0; i < _addresses.length; i++) {
2902             freeMintList[_addresses[i]] = true;
2903         }
2904     }
2905 
2906     function setWlDiscountList(address[] memory _addresses) public onlyOwner {
2907         require(_addresses.length > 0, "array is empty");
2908         for (uint256 i = 0; i < _addresses.length; i++) {
2909             WlDiscountList[_addresses[i]] = true;
2910         }
2911     }    
2912 
2913     function setWlList(address[] memory _addresses) public onlyOwner {
2914         require(_addresses.length > 0, "array is empty");
2915         for (uint256 i = 0; i < _addresses.length; i++) {
2916             WlList[_addresses[i]] = true;
2917         }
2918     }
2919 
2920     //metadatas
2921     function tokenURI(uint256 tokenId)
2922         public
2923         view
2924         virtual
2925         override
2926         returns (string memory)
2927     {
2928         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2929 
2930         if(!revealed) {
2931             return notRevealedURI;
2932         }
2933         string memory baseURI = baseTokenURI;
2934         return bytes(baseURI).length > 0
2935             ? string(abi.encodePacked(baseURI, tokenId.toString()))
2936             : "";
2937     }
2938 
2939     //public view
2940     function addressInList(address _address) public view returns (uint256) {
2941         if (freeMintList[_address]) {
2942             return 1;
2943         } else if (WlDiscountList[_address]) {
2944             return 2;
2945         } else if (WlList[_address]) {
2946             return 3;
2947         }
2948         return 0;
2949     }
2950 
2951     function numberMinted(address _owner) public view returns (uint256) {
2952         return _numberMinted(_owner);
2953     }
2954 
2955     //set function
2956     function setBaseURI(string memory _baseURI) public onlyOwner {
2957         baseTokenURI = _baseURI;
2958     }
2959 
2960     function setNotRevealURI(string memory _notRevealedURI) public onlyOwner {
2961         notRevealedURI = _notRevealedURI;
2962     }
2963 
2964     function setPresaleOpen(bool _set) public onlyOwner {
2965         presaleOpen = _set;
2966     }
2967 
2968     function setPublicSaleOpen(bool _set) public onlyOwner {
2969         publicSaleOpen = _set;
2970     }
2971 
2972     function reduceSupply(uint256 _newSupply) public onlyOwner {
2973         maxSupply = _newSupply;
2974     }
2975 
2976     function reveal() public onlyOwner {
2977         revealed = true;
2978     }
2979 
2980     //withdraw
2981     function withdraw() public payable onlyOwner {
2982         (bool os, ) = payable(owner()).call{ value: address(this).balance }("");
2983         require(os);
2984     }
2985 }