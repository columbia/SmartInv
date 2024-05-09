1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/access/Ownable.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _transferOwnership(_msgSender());
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view virtual returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         _transferOwnership(address(0));
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _transferOwnership(newOwner);
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Internal function without access restriction.
167      */
168     function _transferOwnership(address newOwner) internal virtual {
169         address oldOwner = _owner;
170         _owner = newOwner;
171         emit OwnershipTransferred(oldOwner, newOwner);
172     }
173 }
174 
175 // File: @openzeppelin/contracts/utils/Address.sol
176 
177 
178 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
179 
180 pragma solidity ^0.8.1;
181 
182 /**
183  * @dev Collection of functions related to the address type
184  */
185 library Address {
186     /**
187      * @dev Returns true if `account` is a contract.
188      *
189      * [IMPORTANT]
190      * ====
191      * It is unsafe to assume that an address for which this function returns
192      * false is an externally-owned account (EOA) and not a contract.
193      *
194      * Among others, `isContract` will return false for the following
195      * types of addresses:
196      *
197      *  - an externally-owned account
198      *  - a contract in construction
199      *  - an address where a contract will be created
200      *  - an address where a contract lived, but was destroyed
201      * ====
202      *
203      * [IMPORTANT]
204      * ====
205      * You shouldn't rely on `isContract` to protect against flash loan attacks!
206      *
207      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
208      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
209      * constructor.
210      * ====
211      */
212     function isContract(address account) internal view returns (bool) {
213         // This method relies on extcodesize/address.code.length, which returns 0
214         // for contracts in construction, since the code is only stored at the end
215         // of the constructor execution.
216 
217         return account.code.length > 0;
218     }
219 
220     /**
221      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
222      * `recipient`, forwarding all available gas and reverting on errors.
223      *
224      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
225      * of certain opcodes, possibly making contracts go over the 2300 gas limit
226      * imposed by `transfer`, making them unable to receive funds via
227      * `transfer`. {sendValue} removes this limitation.
228      *
229      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
230      *
231      * IMPORTANT: because control is transferred to `recipient`, care must be
232      * taken to not create reentrancy vulnerabilities. Consider using
233      * {ReentrancyGuard} or the
234      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
235      */
236     function sendValue(address payable recipient, uint256 amount) internal {
237         require(address(this).balance >= amount, "Address: insufficient balance");
238 
239         (bool success, ) = recipient.call{value: amount}("");
240         require(success, "Address: unable to send value, recipient may have reverted");
241     }
242 
243     /**
244      * @dev Performs a Solidity function call using a low level `call`. A
245      * plain `call` is an unsafe replacement for a function call: use this
246      * function instead.
247      *
248      * If `target` reverts with a revert reason, it is bubbled up by this
249      * function (like regular Solidity function calls).
250      *
251      * Returns the raw returned data. To convert to the expected return value,
252      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
253      *
254      * Requirements:
255      *
256      * - `target` must be a contract.
257      * - calling `target` with `data` must not revert.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionCall(target, data, "Address: low-level call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
267      * `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, 0, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but also transferring `value` wei to `target`.
282      *
283      * Requirements:
284      *
285      * - the calling contract must have an ETH balance of at least `value`.
286      * - the called Solidity function must be `payable`.
287      *
288      * _Available since v3.1._
289      */
290     function functionCallWithValue(
291         address target,
292         bytes memory data,
293         uint256 value
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
300      * with `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(
305         address target,
306         bytes memory data,
307         uint256 value,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(address(this).balance >= value, "Address: insufficient balance for call");
311         require(isContract(target), "Address: call to non-contract");
312 
313         (bool success, bytes memory returndata) = target.call{value: value}(data);
314         return verifyCallResult(success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but performing a static call.
320      *
321      * _Available since v3.3._
322      */
323     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
324         return functionStaticCall(target, data, "Address: low-level static call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal view returns (bytes memory) {
338         require(isContract(target), "Address: static call to non-contract");
339 
340         (bool success, bytes memory returndata) = target.staticcall(data);
341         return verifyCallResult(success, returndata, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a delegate call.
347      *
348      * _Available since v3.4._
349      */
350     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(isContract(target), "Address: delegate call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.delegatecall(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
373      * revert reason using the provided one.
374      *
375      * _Available since v4.3._
376      */
377     function verifyCallResult(
378         bool success,
379         bytes memory returndata,
380         string memory errorMessage
381     ) internal pure returns (bytes memory) {
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
401 
402 
403 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 /**
408  * @title ERC721 token receiver interface
409  * @dev Interface for any contract that wants to support safeTransfers
410  * from ERC721 asset contracts.
411  */
412 interface IERC721Receiver {
413     /**
414      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
415      * by `operator` from `from`, this function is called.
416      *
417      * It must return its Solidity selector to confirm the token transfer.
418      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
419      *
420      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
421      */
422     function onERC721Received(
423         address operator,
424         address from,
425         uint256 tokenId,
426         bytes calldata data
427     ) external returns (bytes4);
428 }
429 
430 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
431 
432 
433 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Interface of the ERC165 standard, as defined in the
439  * https://eips.ethereum.org/EIPS/eip-165[EIP].
440  *
441  * Implementers can declare support of contract interfaces, which can then be
442  * queried by others ({ERC165Checker}).
443  *
444  * For an implementation, see {ERC165}.
445  */
446 interface IERC165 {
447     /**
448      * @dev Returns true if this contract implements the interface defined by
449      * `interfaceId`. See the corresponding
450      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
451      * to learn more about how these ids are created.
452      *
453      * This function call must use less than 30 000 gas.
454      */
455     function supportsInterface(bytes4 interfaceId) external view returns (bool);
456 }
457 
458 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 
466 /**
467  * @dev Implementation of the {IERC165} interface.
468  *
469  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
470  * for the additional interface id that will be supported. For example:
471  *
472  * ```solidity
473  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
474  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
475  * }
476  * ```
477  *
478  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
479  */
480 abstract contract ERC165 is IERC165 {
481     /**
482      * @dev See {IERC165-supportsInterface}.
483      */
484     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485         return interfaceId == type(IERC165).interfaceId;
486     }
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
490 
491 
492 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 
497 /**
498  * @dev Required interface of an ERC721 compliant contract.
499  */
500 interface IERC721 is IERC165 {
501     /**
502      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
503      */
504     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
505 
506     /**
507      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
508      */
509     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
510 
511     /**
512      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
513      */
514     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
515 
516     /**
517      * @dev Returns the number of tokens in ``owner``'s account.
518      */
519     function balanceOf(address owner) external view returns (uint256 balance);
520 
521     /**
522      * @dev Returns the owner of the `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function ownerOf(uint256 tokenId) external view returns (address owner);
529 
530     /**
531      * @dev Safely transfers `tokenId` token from `from` to `to`.
532      *
533      * Requirements:
534      *
535      * - `from` cannot be the zero address.
536      * - `to` cannot be the zero address.
537      * - `tokenId` token must exist and be owned by `from`.
538      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
539      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
540      *
541      * Emits a {Transfer} event.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 tokenId,
547         bytes calldata data
548     ) external;
549 
550     /**
551      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
552      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId
568     ) external;
569 
570     /**
571      * @dev Transfers `tokenId` token from `from` to `to`.
572      *
573      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      *
582      * Emits a {Transfer} event.
583      */
584     function transferFrom(
585         address from,
586         address to,
587         uint256 tokenId
588     ) external;
589 
590     /**
591      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
592      * The approval is cleared when the token is transferred.
593      *
594      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
595      *
596      * Requirements:
597      *
598      * - The caller must own the token or be an approved operator.
599      * - `tokenId` must exist.
600      *
601      * Emits an {Approval} event.
602      */
603     function approve(address to, uint256 tokenId) external;
604 
605     /**
606      * @dev Approve or remove `operator` as an operator for the caller.
607      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
608      *
609      * Requirements:
610      *
611      * - The `operator` cannot be the caller.
612      *
613      * Emits an {ApprovalForAll} event.
614      */
615     function setApprovalForAll(address operator, bool _approved) external;
616 
617     /**
618      * @dev Returns the account approved for `tokenId` token.
619      *
620      * Requirements:
621      *
622      * - `tokenId` must exist.
623      */
624     function getApproved(uint256 tokenId) external view returns (address operator);
625 
626     /**
627      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
628      *
629      * See {setApprovalForAll}
630      */
631     function isApprovedForAll(address owner, address operator) external view returns (bool);
632 }
633 
634 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
635 
636 
637 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 /**
643  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
644  * @dev See https://eips.ethereum.org/EIPS/eip-721
645  */
646 interface IERC721Metadata is IERC721 {
647     /**
648      * @dev Returns the token collection name.
649      */
650     function name() external view returns (string memory);
651 
652     /**
653      * @dev Returns the token collection symbol.
654      */
655     function symbol() external view returns (string memory);
656 
657     /**
658      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
659      */
660     function tokenURI(uint256 tokenId) external view returns (string memory);
661 }
662 
663 pragma solidity ^0.8.4;
664 
665 
666 
667 
668 
669 
670 
671 
672 error ApprovalCallerNotOwnerNorApproved();
673 error ApprovalQueryForNonexistentToken();
674 error ApproveToCaller();
675 error ApprovalToCurrentOwner();
676 error BalanceQueryForZeroAddress();
677 error MintToZeroAddress();
678 error MintZeroQuantity();
679 error OwnerQueryForNonexistentToken();
680 error TransferCallerNotOwnerNorApproved();
681 error TransferFromIncorrectOwner();
682 error TransferToNonERC721ReceiverImplementer();
683 error TransferToZeroAddress();
684 error URIQueryForNonexistentToken();
685 
686 /**
687  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
688  * the Metadata extension. Built to optimize for lower gas during batch mints.
689  *
690  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
691  *
692  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
693  *
694  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
695  */
696 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
697     using Address for address;
698     using Strings for uint256;
699 
700     // Compiler will pack this into a single 256bit word.
701     struct TokenOwnership {
702         // The address of the owner.
703         address addr;
704         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
705         uint64 startTimestamp;
706         // Whether the token has been burned.
707         bool burned;
708     }
709 
710     // Compiler will pack this into a single 256bit word.
711     struct AddressData {
712         // Realistically, 2**64-1 is more than enough.
713         uint64 balance;
714         // Keeps track of mint count with minimal overhead for tokenomics.
715         uint64 numberMinted;
716         // Keeps track of burn count with minimal overhead for tokenomics.
717         uint64 numberBurned;
718         // For miscellaneous variable(s) pertaining to the address
719         // (e.g. number of whitelist mint slots used).
720         // If there are multiple variables, please pack them into a uint64.
721         uint64 aux;
722     }
723 
724     // The tokenId of the next token to be minted.
725     uint256 internal _currentIndex;
726 
727     // The number of tokens burned.
728     uint256 internal _burnCounter;
729 
730     // Token name
731     string private _name;
732 
733     // Token symbol
734     string private _symbol;
735 
736     // Mapping from token ID to ownership details
737     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
738     mapping(uint256 => TokenOwnership) internal _ownerships;
739 
740     // Mapping owner address to address data
741     mapping(address => AddressData) private _addressData;
742 
743     // Mapping from token ID to approved address
744     mapping(uint256 => address) private _tokenApprovals;
745 
746     // Mapping from owner to operator approvals
747     mapping(address => mapping(address => bool)) private _operatorApprovals;
748 
749     constructor(string memory name_, string memory symbol_) {
750         _name = name_;
751         _symbol = symbol_;
752         _currentIndex = _startTokenId();
753     }
754 
755     /**
756      * To change the starting tokenId, please override this function.
757      */
758     function _startTokenId() internal view virtual returns (uint256) {
759         return 0;
760     }
761 
762     /**
763      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
764      */
765     function totalSupply() public view returns (uint256) {
766         // Counter underflow is impossible as _burnCounter cannot be incremented
767         // more than _currentIndex - _startTokenId() times
768         unchecked {
769             return _currentIndex - _burnCounter - _startTokenId();
770         }
771     }
772 
773     /**
774      * Returns the total amount of tokens minted in the contract.
775      */
776     function _totalMinted() internal view returns (uint256) {
777         // Counter underflow is impossible as _currentIndex does not decrement,
778         // and it is initialized to _startTokenId()
779         unchecked {
780             return _currentIndex - _startTokenId();
781         }
782     }
783 
784     /**
785      * @dev See {IERC165-supportsInterface}.
786      */
787     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
788         return
789             interfaceId == type(IERC721).interfaceId ||
790             interfaceId == type(IERC721Metadata).interfaceId ||
791             super.supportsInterface(interfaceId);
792     }
793 
794     /**
795      * @dev See {IERC721-balanceOf}.
796      */
797     function balanceOf(address owner) public view override returns (uint256) {
798         if (owner == address(0)) revert BalanceQueryForZeroAddress();
799         return uint256(_addressData[owner].balance);
800     }
801 
802     /**
803      * Returns the number of tokens minted by `owner`.
804      */
805     function _numberMinted(address owner) internal view returns (uint256) {
806         return uint256(_addressData[owner].numberMinted);
807     }
808 
809     /**
810      * Returns the number of tokens burned by or on behalf of `owner`.
811      */
812     function _numberBurned(address owner) internal view returns (uint256) {
813         return uint256(_addressData[owner].numberBurned);
814     }
815 
816     /**
817      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
818      */
819     function _getAux(address owner) internal view returns (uint64) {
820         return _addressData[owner].aux;
821     }
822 
823     /**
824      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
825      * If there are multiple variables, please pack them into a uint64.
826      */
827     function _setAux(address owner, uint64 aux) internal {
828         _addressData[owner].aux = aux;
829     }
830 
831     /**
832      * Gas spent here starts off proportional to the maximum mint batch size.
833      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
834      */
835     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
836         uint256 curr = tokenId;
837 
838         unchecked {
839             if (_startTokenId() <= curr && curr < _currentIndex) {
840                 TokenOwnership memory ownership = _ownerships[curr];
841                 if (!ownership.burned) {
842                     if (ownership.addr != address(0)) {
843                         return ownership;
844                     }
845                     // Invariant:
846                     // There will always be an ownership that has an address and is not burned
847                     // before an ownership that does not have an address and is not burned.
848                     // Hence, curr will not underflow.
849                     while (true) {
850                         curr--;
851                         ownership = _ownerships[curr];
852                         if (ownership.addr != address(0)) {
853                             return ownership;
854                         }
855                     }
856                 }
857             }
858         }
859         revert OwnerQueryForNonexistentToken();
860     }
861 
862     /**
863      * @dev See {IERC721-ownerOf}.
864      */
865     function ownerOf(uint256 tokenId) public view override returns (address) {
866         return _ownershipOf(tokenId).addr;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-name}.
871      */
872     function name() public view virtual override returns (string memory) {
873         return _name;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-symbol}.
878      */
879     function symbol() public view virtual override returns (string memory) {
880         return _symbol;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-tokenURI}.
885      */
886     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
887         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
888 
889         string memory baseURI = _baseURI();
890         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
891     }
892 
893     /**
894      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
895      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
896      * by default, can be overriden in child contracts.
897      */
898     function _baseURI() internal view virtual returns (string memory) {
899         return '';
900     }
901 
902     /**
903      * @dev See {IERC721-approve}.
904      */
905     function approve(address to, uint256 tokenId) public override {
906         address owner = ERC721A.ownerOf(tokenId);
907         if (to == owner) revert ApprovalToCurrentOwner();
908 
909         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
910             revert ApprovalCallerNotOwnerNorApproved();
911         }
912 
913         _approve(to, tokenId, owner);
914     }
915 
916     /**
917      * @dev See {IERC721-getApproved}.
918      */
919     function getApproved(uint256 tokenId) public view override returns (address) {
920         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
921 
922         return _tokenApprovals[tokenId];
923     }
924 
925     /**
926      * @dev See {IERC721-setApprovalForAll}.
927      */
928     function setApprovalForAll(address operator, bool approved) public virtual override {
929         if (operator == _msgSender()) revert ApproveToCaller();
930 
931         _operatorApprovals[_msgSender()][operator] = approved;
932         emit ApprovalForAll(_msgSender(), operator, approved);
933     }
934 
935     /**
936      * @dev See {IERC721-isApprovedForAll}.
937      */
938     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
939         return _operatorApprovals[owner][operator];
940     }
941 
942     /**
943      * @dev See {IERC721-transferFrom}.
944      */
945     function transferFrom(
946         address from,
947         address to,
948         uint256 tokenId
949     ) public virtual override {
950         _transfer(from, to, tokenId);
951     }
952 
953     /**
954      * @dev See {IERC721-safeTransferFrom}.
955      */
956     function safeTransferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public virtual override {
961         safeTransferFrom(from, to, tokenId, '');
962     }
963 
964     /**
965      * @dev See {IERC721-safeTransferFrom}.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) public virtual override {
973         _transfer(from, to, tokenId);
974         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
975             revert TransferToNonERC721ReceiverImplementer();
976         }
977     }
978 
979     /**
980      * @dev Returns whether `tokenId` exists.
981      *
982      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
983      *
984      * Tokens start existing when they are minted (`_mint`),
985      */
986     function _exists(uint256 tokenId) internal view returns (bool) {
987         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
988     }
989 
990     /**
991      * @dev Equivalent to `_safeMint(to, quantity, '')`.
992      */
993     function _safeMint(address to, uint256 quantity) internal {
994         _safeMint(to, quantity, '');
995     }
996 
997     /**
998      * @dev Safely mints `quantity` tokens and transfers them to `to`.
999      *
1000      * Requirements:
1001      *
1002      * - If `to` refers to a smart contract, it must implement 
1003      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1004      * - `quantity` must be greater than 0.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _safeMint(
1009         address to,
1010         uint256 quantity,
1011         bytes memory _data
1012     ) internal {
1013         uint256 startTokenId = _currentIndex;
1014         if (to == address(0)) revert MintToZeroAddress();
1015         if (quantity == 0) revert MintZeroQuantity();
1016 
1017         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1018 
1019         // Overflows are incredibly unrealistic.
1020         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1021         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1022         unchecked {
1023             _addressData[to].balance += uint64(quantity);
1024             _addressData[to].numberMinted += uint64(quantity);
1025 
1026             _ownerships[startTokenId].addr = to;
1027             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1028 
1029             uint256 updatedIndex = startTokenId;
1030             uint256 end = updatedIndex + quantity;
1031 
1032             if (to.isContract()) {
1033                 do {
1034                     emit Transfer(address(0), to, updatedIndex);
1035                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1036                         revert TransferToNonERC721ReceiverImplementer();
1037                     }
1038                 } while (updatedIndex != end);
1039                 // Reentrancy protection
1040                 if (_currentIndex != startTokenId) revert();
1041             } else {
1042                 do {
1043                     emit Transfer(address(0), to, updatedIndex++);
1044                 } while (updatedIndex != end);
1045             }
1046             _currentIndex = updatedIndex;
1047         }
1048         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1049     }
1050 
1051     /**
1052      * @dev Mints `quantity` tokens and transfers them to `to`.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - `quantity` must be greater than 0.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _mint(address to, uint256 quantity) internal {
1062         uint256 startTokenId = _currentIndex;
1063         if (to == address(0)) revert MintToZeroAddress();
1064         if (quantity == 0) revert MintZeroQuantity();
1065 
1066         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1067 
1068         // Overflows are incredibly unrealistic.
1069         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1070         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1071         unchecked {
1072             _addressData[to].balance += uint64(quantity);
1073             _addressData[to].numberMinted += uint64(quantity);
1074 
1075             _ownerships[startTokenId].addr = to;
1076             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1077 
1078             uint256 updatedIndex = startTokenId;
1079             uint256 end = updatedIndex + quantity;
1080 
1081             do {
1082                 emit Transfer(address(0), to, updatedIndex++);
1083             } while (updatedIndex != end);
1084 
1085             _currentIndex = updatedIndex;
1086         }
1087         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1088     }
1089 
1090     /**
1091      * @dev Transfers `tokenId` from `from` to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must be owned by `from`.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _transfer(
1101         address from,
1102         address to,
1103         uint256 tokenId
1104     ) private {
1105         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1106 
1107         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1108 
1109         bool isApprovedOrOwner = (_msgSender() == from ||
1110             isApprovedForAll(from, _msgSender()) ||
1111             getApproved(tokenId) == _msgSender());
1112 
1113         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1114         if (to == address(0)) revert TransferToZeroAddress();
1115 
1116         _beforeTokenTransfers(from, to, tokenId, 1);
1117 
1118         // Clear approvals from the previous owner
1119         _approve(address(0), tokenId, from);
1120 
1121         // Underflow of the sender's balance is impossible because we check for
1122         // ownership above and the recipient's balance can't realistically overflow.
1123         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1124         unchecked {
1125             _addressData[from].balance -= 1;
1126             _addressData[to].balance += 1;
1127 
1128             TokenOwnership storage currSlot = _ownerships[tokenId];
1129             currSlot.addr = to;
1130             currSlot.startTimestamp = uint64(block.timestamp);
1131 
1132             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1133             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1134             uint256 nextTokenId = tokenId + 1;
1135             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1136             if (nextSlot.addr == address(0)) {
1137                 // This will suffice for checking _exists(nextTokenId),
1138                 // as a burned slot cannot contain the zero address.
1139                 if (nextTokenId != _currentIndex) {
1140                     nextSlot.addr = from;
1141                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1142                 }
1143             }
1144         }
1145 
1146         emit Transfer(from, to, tokenId);
1147         _afterTokenTransfers(from, to, tokenId, 1);
1148     }
1149 
1150     /**
1151      * @dev Equivalent to `_burn(tokenId, false)`.
1152      */
1153     function _burn(uint256 tokenId) internal virtual {
1154         _burn(tokenId, false);
1155     }
1156 
1157     /**
1158      * @dev Destroys `tokenId`.
1159      * The approval is cleared when the token is burned.
1160      *
1161      * Requirements:
1162      *
1163      * - `tokenId` must exist.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1168         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1169 
1170         address from = prevOwnership.addr;
1171 
1172         if (approvalCheck) {
1173             bool isApprovedOrOwner = (_msgSender() == from ||
1174                 isApprovedForAll(from, _msgSender()) ||
1175                 getApproved(tokenId) == _msgSender());
1176 
1177             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1178         }
1179 
1180         _beforeTokenTransfers(from, address(0), tokenId, 1);
1181 
1182         // Clear approvals from the previous owner
1183         _approve(address(0), tokenId, from);
1184 
1185         // Underflow of the sender's balance is impossible because we check for
1186         // ownership above and the recipient's balance can't realistically overflow.
1187         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1188         unchecked {
1189             AddressData storage addressData = _addressData[from];
1190             addressData.balance -= 1;
1191             addressData.numberBurned += 1;
1192 
1193             // Keep track of who burned the token, and the timestamp of burning.
1194             TokenOwnership storage currSlot = _ownerships[tokenId];
1195             currSlot.addr = from;
1196             currSlot.startTimestamp = uint64(block.timestamp);
1197             currSlot.burned = true;
1198 
1199             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1200             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1201             uint256 nextTokenId = tokenId + 1;
1202             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1203             if (nextSlot.addr == address(0)) {
1204                 // This will suffice for checking _exists(nextTokenId),
1205                 // as a burned slot cannot contain the zero address.
1206                 if (nextTokenId != _currentIndex) {
1207                     nextSlot.addr = from;
1208                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1209                 }
1210             }
1211         }
1212 
1213         emit Transfer(from, address(0), tokenId);
1214         _afterTokenTransfers(from, address(0), tokenId, 1);
1215 
1216         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1217         unchecked {
1218             _burnCounter++;
1219         }
1220     }
1221 
1222     /**
1223      * @dev Approve `to` to operate on `tokenId`
1224      *
1225      * Emits a {Approval} event.
1226      */
1227     function _approve(
1228         address to,
1229         uint256 tokenId,
1230         address owner
1231     ) private {
1232         _tokenApprovals[tokenId] = to;
1233         emit Approval(owner, to, tokenId);
1234     }
1235 
1236     /**
1237      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1238      *
1239      * @param from address representing the previous owner of the given token ID
1240      * @param to target address that will receive the tokens
1241      * @param tokenId uint256 ID of the token to be transferred
1242      * @param _data bytes optional data to send along with the call
1243      * @return bool whether the call correctly returned the expected magic value
1244      */
1245     function _checkContractOnERC721Received(
1246         address from,
1247         address to,
1248         uint256 tokenId,
1249         bytes memory _data
1250     ) private returns (bool) {
1251         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1252             return retval == IERC721Receiver(to).onERC721Received.selector;
1253         } catch (bytes memory reason) {
1254             if (reason.length == 0) {
1255                 revert TransferToNonERC721ReceiverImplementer();
1256             } else {
1257                 assembly {
1258                     revert(add(32, reason), mload(reason))
1259                 }
1260             }
1261         }
1262     }
1263 
1264     /**
1265      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1266      * And also called before burning one token.
1267      *
1268      * startTokenId - the first token id to be transferred
1269      * quantity - the amount to be transferred
1270      *
1271      * Calling conditions:
1272      *
1273      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1274      * transferred to `to`.
1275      * - When `from` is zero, `tokenId` will be minted for `to`.
1276      * - When `to` is zero, `tokenId` will be burned by `from`.
1277      * - `from` and `to` are never both zero.
1278      */
1279     function _beforeTokenTransfers(
1280         address from,
1281         address to,
1282         uint256 startTokenId,
1283         uint256 quantity
1284     ) internal virtual {}
1285 
1286     /**
1287      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1288      * minting.
1289      * And also called after one token has been burned.
1290      *
1291      * startTokenId - the first token id to be transferred
1292      * quantity - the amount to be transferred
1293      *
1294      * Calling conditions:
1295      *
1296      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1297      * transferred to `to`.
1298      * - When `from` is zero, `tokenId` has been minted for `to`.
1299      * - When `to` is zero, `tokenId` has been burned by `from`.
1300      * - `from` and `to` are never both zero.
1301      */
1302     function _afterTokenTransfers(
1303         address from,
1304         address to,
1305         uint256 startTokenId,
1306         uint256 quantity
1307     ) internal virtual {}
1308 }
1309 // File: contracts/ERC721AQueryable.sol
1310 
1311 
1312 pragma solidity ^0.8.4;
1313 
1314 
1315 error InvalidQueryRange();
1316 
1317 /**
1318  * @title ERC721A Queryable
1319  * @dev ERC721A subclass with convenience query functions.
1320  */
1321 abstract contract ERC721AQueryable is ERC721A {
1322     /**
1323      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1324      *
1325      * If the `tokenId` is out of bounds:
1326      *   - `addr` = `address(0)`
1327      *   - `startTimestamp` = `0`
1328      *   - `burned` = `false`
1329      *
1330      * If the `tokenId` is burned:
1331      *   - `addr` = `<Address of owner before token was burned>`
1332      *   - `startTimestamp` = `<Timestamp when token was burned>`
1333      *   - `burned = `true`
1334      *
1335      * Otherwise:
1336      *   - `addr` = `<Address of owner>`
1337      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1338      *   - `burned = `false`
1339      */
1340     function explicitOwnershipOf(uint256 tokenId) public view returns (TokenOwnership memory) {
1341         TokenOwnership memory ownership;
1342         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1343             return ownership;
1344         }
1345         ownership = _ownerships[tokenId];
1346         if (ownership.burned) {
1347             return ownership;
1348         }
1349         return _ownershipOf(tokenId);
1350     }
1351 
1352     /**
1353      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1354      * See {ERC721AQueryable-explicitOwnershipOf}
1355      */
1356     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory) {
1357         unchecked {
1358             uint256 tokenIdsLength = tokenIds.length;
1359             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1360             for (uint256 i; i != tokenIdsLength; ++i) {
1361                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1362             }
1363             return ownerships;
1364         }
1365     }
1366 
1367     /**
1368      * @dev Returns an array of token IDs owned by `owner`,
1369      * in the range [`start`, `stop`)
1370      * (i.e. `start <= tokenId < stop`).
1371      *
1372      * This function allows for tokens to be queried if the collection
1373      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1374      *
1375      * Requirements:
1376      *
1377      * - `start` < `stop`
1378      */
1379     function tokensOfOwnerIn(
1380         address owner,
1381         uint256 start,
1382         uint256 stop
1383     ) external view returns (uint256[] memory) {
1384         unchecked {
1385             if (start >= stop) revert InvalidQueryRange();
1386             uint256 tokenIdsIdx;
1387             uint256 stopLimit = _currentIndex;
1388             // Set `start = max(start, _startTokenId())`.
1389             if (start < _startTokenId()) {
1390                 start = _startTokenId();
1391             }
1392             // Set `stop = min(stop, _currentIndex)`.
1393             if (stop > stopLimit) {
1394                 stop = stopLimit;
1395             }
1396             uint256 tokenIdsMaxLength = balanceOf(owner);
1397             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1398             // to cater for cases where `balanceOf(owner)` is too big.
1399             if (start < stop) {
1400                 uint256 rangeLength = stop - start;
1401                 if (rangeLength < tokenIdsMaxLength) {
1402                     tokenIdsMaxLength = rangeLength;
1403                 }
1404             } else {
1405                 tokenIdsMaxLength = 0;
1406             }
1407             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1408             if (tokenIdsMaxLength == 0) {
1409                 return tokenIds;
1410             }
1411             // We need to call `explicitOwnershipOf(start)`,
1412             // because the slot at `start` may not be initialized.
1413             TokenOwnership memory ownership = explicitOwnershipOf(start);
1414             address currOwnershipAddr;
1415             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1416             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1417             if (!ownership.burned) {
1418                 currOwnershipAddr = ownership.addr;
1419             }
1420             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1421                 ownership = _ownerships[i];
1422                 if (ownership.burned) {
1423                     continue;
1424                 }
1425                 if (ownership.addr != address(0)) {
1426                     currOwnershipAddr = ownership.addr;
1427                 }
1428                 if (currOwnershipAddr == owner) {
1429                     tokenIds[tokenIdsIdx++] = i;
1430                 }
1431             }
1432             // Downsize the array to fit.
1433             assembly {
1434                 mstore(tokenIds, tokenIdsIdx)
1435             }
1436             return tokenIds;
1437         }
1438     }
1439 
1440     /**
1441      * @dev Returns an array of token IDs owned by `owner`.
1442      *
1443      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1444      * It is meant to be called off-chain.
1445      *
1446      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1447      * multiple smaller scans if the collection is large enough to cause
1448      * an out-of-gas error (10K pfp collections should be fine).
1449      */
1450     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1451         unchecked {
1452             uint256 tokenIdsIdx;
1453             address currOwnershipAddr;
1454             uint256 tokenIdsLength = balanceOf(owner);
1455             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1456             TokenOwnership memory ownership;
1457             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1458                 ownership = _ownerships[i];
1459                 if (ownership.burned) {
1460                     continue;
1461                 }
1462                 if (ownership.addr != address(0)) {
1463                     currOwnershipAddr = ownership.addr;
1464                 }
1465                 if (currOwnershipAddr == owner) {
1466                     tokenIds[tokenIdsIdx++] = i;
1467                 }
1468             }
1469             return tokenIds;
1470         }
1471     }
1472 }
1473 
1474 pragma solidity ^0.8.4;
1475 
1476 contract OpenSnakeGame is ERC721A, Ownable {
1477     string public baseURI = "https://storageapi.fleek.co/256e1077-3ba4-4f13-9298-2a063e646bf9-bucket/OpenSnake/json/";
1478     string public constant baseExtension = ".json";
1479     uint256 public constant MAX_FREE = 1;
1480     uint256 public constant MAX_PER_TX = 10;
1481     uint256 public constant MAX_SUPPLY = 900;
1482     uint256 public price = 0.002 ether;
1483 
1484     bool public paused = true;
1485 
1486     constructor() ERC721A("OpenSnake Game", "OpenSnakeGame") {
1487         _safeMint(msg.sender, 1);
1488     }
1489 
1490     function Mint(uint256 amount) external payable {
1491         address _caller = _msgSender();
1492         require(!paused, "Paused");
1493         require(MAX_SUPPLY >= totalSupply() + amount, "Exceeds max supply");
1494         require(tx.origin == _caller, "No contracts");
1495         require(MAX_PER_TX >= amount , "Excess max per paid tx");
1496         require(price*amount <= msg.value, "Invalid funds provided");
1497 
1498         _safeMint(_caller, amount);
1499     }
1500 
1501     function freeMint() public{
1502         address _caller = _msgSender();
1503         require(!paused, "Paused");
1504         require(MAX_SUPPLY >= totalSupply() + 1, "Exceeds max supply");
1505         require(tx.origin == _caller, "No contracts");
1506         require(MAX_FREE >= uint256(_getAux(_caller)) + 1, "Excess max per free wallet");
1507 
1508         _setAux(_caller, 1);
1509         _safeMint(_caller, 1);
1510     }
1511 
1512     function _startTokenId() internal override view virtual returns (uint256) {
1513         return 1;
1514     }
1515 
1516     function minted(address _owner) public view returns (uint256) {
1517         return _numberMinted(_owner);
1518     }
1519 
1520     function withdraw() external onlyOwner {
1521         uint256 balance = address(this).balance;
1522         (bool success, ) = _msgSender().call{value: balance}("");
1523         require(success, "Failed to send");
1524     }
1525 
1526     function teamMint(uint256 _number) external onlyOwner {
1527         _safeMint(_msgSender(), _number);
1528     }
1529 
1530     function setPrice(uint256 _price) external onlyOwner {
1531         price = _price;
1532     }
1533 
1534     function pause(bool _state) external onlyOwner {
1535         paused = _state;
1536     }
1537 
1538     function setBaseURI(string memory baseURI_) external onlyOwner {
1539         baseURI = baseURI_;
1540     }
1541 
1542     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1543         require(_exists(_tokenId), "Token does not exist.");
1544         return bytes(baseURI).length > 0 ? string(
1545             abi.encodePacked(
1546               baseURI,
1547               Strings.toString(_tokenId),
1548               baseExtension
1549             )
1550         ) : "";
1551     }
1552 }