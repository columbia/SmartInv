1 // File: Flingo.sol
2 
3 // SPDX-License-Identifier: MIT
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
403 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
420      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
492 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
531      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
532      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId
548     ) external;
549 
550     /**
551      * @dev Transfers `tokenId` token from `from` to `to`.
552      *
553      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must be owned by `from`.
560      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
561      *
562      * Emits a {Transfer} event.
563      */
564     function transferFrom(
565         address from,
566         address to,
567         uint256 tokenId
568     ) external;
569 
570     /**
571      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
572      * The approval is cleared when the token is transferred.
573      *
574      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
575      *
576      * Requirements:
577      *
578      * - The caller must own the token or be an approved operator.
579      * - `tokenId` must exist.
580      *
581      * Emits an {Approval} event.
582      */
583     function approve(address to, uint256 tokenId) external;
584 
585     /**
586      * @dev Returns the account approved for `tokenId` token.
587      *
588      * Requirements:
589      *
590      * - `tokenId` must exist.
591      */
592     function getApproved(uint256 tokenId) external view returns (address operator);
593 
594     /**
595      * @dev Approve or remove `operator` as an operator for the caller.
596      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
597      *
598      * Requirements:
599      *
600      * - The `operator` cannot be the caller.
601      *
602      * Emits an {ApprovalForAll} event.
603      */
604     function setApprovalForAll(address operator, bool _approved) external;
605 
606     /**
607      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
608      *
609      * See {setApprovalForAll}
610      */
611     function isApprovedForAll(address owner, address operator) external view returns (bool);
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must exist and be owned by `from`.
621      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
623      *
624      * Emits a {Transfer} event.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId,
630         bytes calldata data
631     ) external;
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
663 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
664 
665 
666 // Creator: Chiru Labs
667 
668 pragma solidity ^0.8.4;
669 
670 error ApprovalCallerNotOwnerNorApproved();
671 error ApprovalQueryForNonexistentToken();
672 error ApproveToCaller();
673 error ApprovalToCurrentOwner();
674 error BalanceQueryForZeroAddress();
675 error MintToZeroAddress();
676 error MintZeroQuantity();
677 error OwnerQueryForNonexistentToken();
678 error TransferCallerNotOwnerNorApproved();
679 error TransferFromIncorrectOwner();
680 error TransferToNonERC721ReceiverImplementer();
681 error TransferToZeroAddress();
682 error URIQueryForNonexistentToken();
683 
684 /**
685  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
686  * the Metadata extension. Built to optimize for lower gas during batch mints.
687  *
688  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
689  *
690  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
691  *
692  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
693  */
694 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
695     using Address for address;
696     using Strings for uint256;
697 
698     // Compiler will pack this into a single 256bit word.
699     struct TokenOwnership {
700         // The address of the owner.
701         address addr;
702         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
703         uint64 startTimestamp;
704         // Whether the token has been burned.
705         bool burned;
706     }
707 
708     // Compiler will pack this into a single 256bit word.
709     struct AddressData {
710         // Realistically, 2**64-1 is more than enough.
711         uint64 balance;
712         // Keeps track of mint count with minimal overhead for tokenomics.
713         uint64 numberMinted;
714         // Keeps track of burn count with minimal overhead for tokenomics.
715         uint64 numberBurned;
716         // For miscellaneous variable(s) pertaining to the address
717         // (e.g. number of whitelist mint slots used).
718         // If there are multiple variables, please pack them into a uint64.
719         uint64 aux;
720     }
721 
722     // The tokenId of the next token to be minted.
723     uint256 internal _currentIndex;
724 
725     // The number of tokens burned.
726     uint256 internal _burnCounter;
727 
728     // Token name
729     string private _name;
730 
731     // Token symbol
732     string private _symbol;
733 
734     // Mapping from token ID to ownership details
735     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
736     mapping(uint256 => TokenOwnership) internal _ownerships;
737 
738     // Mapping owner address to address data
739     mapping(address => AddressData) private _addressData;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     constructor(string memory name_, string memory symbol_) {
748         _name = name_;
749         _symbol = symbol_;
750         _currentIndex = _startTokenId();
751     }
752 
753     /**
754      * To change the starting tokenId, please override this function.
755      */
756     function _startTokenId() internal view virtual returns (uint256) {
757         return 1;
758     }
759 
760     /**
761      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
762      */
763     function totalSupply() public view returns (uint256) {
764         // Counter underflow is impossible as _burnCounter cannot be incremented
765         // more than _currentIndex - _startTokenId() times
766         unchecked {
767             return _currentIndex - _burnCounter - _startTokenId();
768         }
769     }
770 
771     /**
772      * Returns the total amount of tokens minted in the contract.
773      */
774     function _totalMinted() internal view returns (uint256) {
775         // Counter underflow is impossible as _currentIndex does not decrement,
776         // and it is initialized to _startTokenId()
777         unchecked {
778             return _currentIndex - _startTokenId();
779         }
780     }
781 
782     /**
783      * @dev See {IERC165-supportsInterface}.
784      */
785     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
786         return
787             interfaceId == type(IERC721).interfaceId ||
788             interfaceId == type(IERC721Metadata).interfaceId ||
789             super.supportsInterface(interfaceId);
790     }
791 
792     /**
793      * @dev See {IERC721-balanceOf}.
794      */
795     function balanceOf(address owner) public view override returns (uint256) {
796         if (owner == address(0)) revert BalanceQueryForZeroAddress();
797         return uint256(_addressData[owner].balance);
798     }
799 
800     /**
801      * Returns the number of tokens minted by `owner`.
802      */
803     function _numberMinted(address owner) internal view returns (uint256) {
804         return uint256(_addressData[owner].numberMinted);
805     }
806 
807     /**
808      * Returns the number of tokens burned by or on behalf of `owner`.
809      */
810     function _numberBurned(address owner) internal view returns (uint256) {
811         return uint256(_addressData[owner].numberBurned);
812     }
813 
814     /**
815      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
816      */
817     function _getAux(address owner) internal view returns (uint64) {
818         return _addressData[owner].aux;
819     }
820 
821     /**
822      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
823      * If there are multiple variables, please pack them into a uint64.
824      */
825     function _setAux(address owner, uint64 aux) internal {
826         _addressData[owner].aux = aux;
827     }
828 
829     /**
830      * Gas spent here starts off proportional to the maximum mint batch size.
831      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
832      */
833     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
834         uint256 curr = tokenId;
835 
836         unchecked {
837             if (_startTokenId() <= curr && curr < _currentIndex) {
838                 TokenOwnership memory ownership = _ownerships[curr];
839                 if (!ownership.burned) {
840                     if (ownership.addr != address(0)) {
841                         return ownership;
842                     }
843                     // Invariant:
844                     // There will always be an ownership that has an address and is not burned
845                     // before an ownership that does not have an address and is not burned.
846                     // Hence, curr will not underflow.
847                     while (true) {
848                         curr--;
849                         ownership = _ownerships[curr];
850                         if (ownership.addr != address(0)) {
851                             return ownership;
852                         }
853                     }
854                 }
855             }
856         }
857         revert OwnerQueryForNonexistentToken();
858     }
859 
860     /**
861      * @dev See {IERC721-ownerOf}.
862      */
863     function ownerOf(uint256 tokenId) public view override returns (address) {
864         return _ownershipOf(tokenId).addr;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-name}.
869      */
870     function name() public view virtual override returns (string memory) {
871         return _name;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-symbol}.
876      */
877     function symbol() public view virtual override returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-tokenURI}.
883      */
884     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
885         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
886 
887         string memory baseURI = _baseURI();
888         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
889     }
890 
891     /**
892      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
893      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
894      * by default, can be overriden in child contracts.
895      */
896     function _baseURI() internal view virtual returns (string memory) {
897         return '';
898     }
899 
900     /**
901      * @dev See {IERC721-approve}.
902      */
903     function approve(address to, uint256 tokenId) public override {
904         address owner = ERC721A.ownerOf(tokenId);
905         if (to == owner) revert ApprovalToCurrentOwner();
906 
907         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
908             revert ApprovalCallerNotOwnerNorApproved();
909         }
910 
911         _approve(to, tokenId, owner);
912     }
913 
914     /**
915      * @dev See {IERC721-getApproved}.
916      */
917     function getApproved(uint256 tokenId) public view override returns (address) {
918         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
919 
920         return _tokenApprovals[tokenId];
921     }
922 
923     /**
924      * @dev See {IERC721-setApprovalForAll}.
925      */
926     function setApprovalForAll(address operator, bool approved) public virtual override {
927         if (operator == _msgSender()) revert ApproveToCaller();
928 
929         _operatorApprovals[_msgSender()][operator] = approved;
930         emit ApprovalForAll(_msgSender(), operator, approved);
931     }
932 
933     /**
934      * @dev See {IERC721-isApprovedForAll}.
935      */
936     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
937         return _operatorApprovals[owner][operator];
938     }
939 
940     /**
941      * @dev See {IERC721-transferFrom}.
942      */
943     function transferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         _transfer(from, to, tokenId);
949     }
950 
951     /**
952      * @dev See {IERC721-safeTransferFrom}.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         safeTransferFrom(from, to, tokenId, '');
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) public virtual override {
971         _transfer(from, to, tokenId);
972         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
973             revert TransferToNonERC721ReceiverImplementer();
974         }
975     }
976 
977     /**
978      * @dev Returns whether `tokenId` exists.
979      *
980      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
981      *
982      * Tokens start existing when they are minted (`_mint`),
983      */
984     function _exists(uint256 tokenId) internal view returns (bool) {
985         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
986             !_ownerships[tokenId].burned;
987     }
988 
989     function _safeMint(address to, uint256 quantity) internal {
990         _safeMint(to, quantity, '');
991     }
992 
993     /**
994      * @dev Safely mints `quantity` tokens and transfers them to `to`.
995      *
996      * Requirements:
997      *
998      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
999      * - `quantity` must be greater than 0.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _safeMint(
1004         address to,
1005         uint256 quantity,
1006         bytes memory _data
1007     ) internal {
1008         _mint(to, quantity, _data, true);
1009     }
1010 
1011     /**
1012      * @dev Mints `quantity` tokens and transfers them to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `quantity` must be greater than 0.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _mint(
1022         address to,
1023         uint256 quantity,
1024         bytes memory _data,
1025         bool safe
1026     ) internal {
1027         uint256 startTokenId = _currentIndex;
1028         if (to == address(0)) revert MintToZeroAddress();
1029         if (quantity == 0) revert MintZeroQuantity();
1030 
1031         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1032 
1033         // Overflows are incredibly unrealistic.
1034         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1035         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1036         unchecked {
1037             _addressData[to].balance += uint64(quantity);
1038             _addressData[to].numberMinted += uint64(quantity);
1039 
1040             _ownerships[startTokenId].addr = to;
1041             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1042 
1043             uint256 updatedIndex = startTokenId;
1044             uint256 end = updatedIndex + quantity;
1045 
1046             if (safe && to.isContract()) {
1047                 do {
1048                     emit Transfer(address(0), to, updatedIndex);
1049                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1050                         revert TransferToNonERC721ReceiverImplementer();
1051                     }
1052                 } while (updatedIndex != end);
1053                 // Reentrancy protection
1054                 if (_currentIndex != startTokenId) revert();
1055             } else {
1056                 do {
1057                     emit Transfer(address(0), to, updatedIndex++);
1058                 } while (updatedIndex != end);
1059             }
1060             _currentIndex = updatedIndex;
1061         }
1062         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1063     }
1064 
1065     /**
1066      * @dev Transfers `tokenId` from `from` to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `tokenId` token must be owned by `from`.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _transfer(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) private {
1080         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1081 
1082         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1083 
1084         bool isApprovedOrOwner = (_msgSender() == from ||
1085             isApprovedForAll(from, _msgSender()) ||
1086             getApproved(tokenId) == _msgSender());
1087 
1088         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1089         if (to == address(0)) revert TransferToZeroAddress();
1090 
1091         _beforeTokenTransfers(from, to, tokenId, 1);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId, from);
1095 
1096         // Underflow of the sender's balance is impossible because we check for
1097         // ownership above and the recipient's balance can't realistically overflow.
1098         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1099         unchecked {
1100             _addressData[from].balance -= 1;
1101             _addressData[to].balance += 1;
1102 
1103             TokenOwnership storage currSlot = _ownerships[tokenId];
1104             currSlot.addr = to;
1105             currSlot.startTimestamp = uint64(block.timestamp);
1106 
1107             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1108             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1109             uint256 nextTokenId = tokenId + 1;
1110             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1111             if (nextSlot.addr == address(0)) {
1112                 // This will suffice for checking _exists(nextTokenId),
1113                 // as a burned slot cannot contain the zero address.
1114                 if (nextTokenId != _currentIndex) {
1115                     nextSlot.addr = from;
1116                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1117                 }
1118             }
1119         }
1120 
1121         emit Transfer(from, to, tokenId);
1122         _afterTokenTransfers(from, to, tokenId, 1);
1123     }
1124 
1125     /**
1126      * @dev This is equivalent to _burn(tokenId, false)
1127      */
1128     function _burn(uint256 tokenId) internal virtual {
1129         _burn(tokenId, false);
1130     }
1131 
1132     /**
1133      * @dev Destroys `tokenId`.
1134      * The approval is cleared when the token is burned.
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must exist.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1143         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1144 
1145         address from = prevOwnership.addr;
1146 
1147         if (approvalCheck) {
1148             bool isApprovedOrOwner = (_msgSender() == from ||
1149                 isApprovedForAll(from, _msgSender()) ||
1150                 getApproved(tokenId) == _msgSender());
1151 
1152             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1153         }
1154 
1155         _beforeTokenTransfers(from, address(0), tokenId, 1);
1156 
1157         // Clear approvals from the previous owner
1158         _approve(address(0), tokenId, from);
1159 
1160         // Underflow of the sender's balance is impossible because we check for
1161         // ownership above and the recipient's balance can't realistically overflow.
1162         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1163         unchecked {
1164             AddressData storage addressData = _addressData[from];
1165             addressData.balance -= 1;
1166             addressData.numberBurned += 1;
1167 
1168             // Keep track of who burned the token, and the timestamp of burning.
1169             TokenOwnership storage currSlot = _ownerships[tokenId];
1170             currSlot.addr = from;
1171             currSlot.startTimestamp = uint64(block.timestamp);
1172             currSlot.burned = true;
1173 
1174             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1175             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1176             uint256 nextTokenId = tokenId + 1;
1177             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1178             if (nextSlot.addr == address(0)) {
1179                 // This will suffice for checking _exists(nextTokenId),
1180                 // as a burned slot cannot contain the zero address.
1181                 if (nextTokenId != _currentIndex) {
1182                     nextSlot.addr = from;
1183                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1184                 }
1185             }
1186         }
1187 
1188         emit Transfer(from, address(0), tokenId);
1189         _afterTokenTransfers(from, address(0), tokenId, 1);
1190 
1191         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1192         unchecked {
1193             _burnCounter++;
1194         }
1195     }
1196 
1197     /**
1198      * @dev Approve `to` to operate on `tokenId`
1199      *
1200      * Emits a {Approval} event.
1201      */
1202     function _approve(
1203         address to,
1204         uint256 tokenId,
1205         address owner
1206     ) private {
1207         _tokenApprovals[tokenId] = to;
1208         emit Approval(owner, to, tokenId);
1209     }
1210 
1211     /**
1212      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1213      *
1214      * @param from address representing the previous owner of the given token ID
1215      * @param to target address that will receive the tokens
1216      * @param tokenId uint256 ID of the token to be transferred
1217      * @param _data bytes optional data to send along with the call
1218      * @return bool whether the call correctly returned the expected magic value
1219      */
1220     function _checkContractOnERC721Received(
1221         address from,
1222         address to,
1223         uint256 tokenId,
1224         bytes memory _data
1225     ) private returns (bool) {
1226         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1227             return retval == IERC721Receiver(to).onERC721Received.selector;
1228         } catch (bytes memory reason) {
1229             if (reason.length == 0) {
1230                 revert TransferToNonERC721ReceiverImplementer();
1231             } else {
1232                 assembly {
1233                     revert(add(32, reason), mload(reason))
1234                 }
1235             }
1236         }
1237     }
1238 
1239     /**
1240      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1241      * And also called before burning one token.
1242      *
1243      * startTokenId - the first token id to be transferred
1244      * quantity - the amount to be transferred
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` will be minted for `to`.
1251      * - When `to` is zero, `tokenId` will be burned by `from`.
1252      * - `from` and `to` are never both zero.
1253      */
1254     function _beforeTokenTransfers(
1255         address from,
1256         address to,
1257         uint256 startTokenId,
1258         uint256 quantity
1259     ) internal virtual {}
1260 
1261     /**
1262      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1263      * minting.
1264      * And also called after one token has been burned.
1265      *
1266      * startTokenId - the first token id to be transferred
1267      * quantity - the amount to be transferred
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` has been minted for `to`.
1274      * - When `to` is zero, `tokenId` has been burned by `from`.
1275      * - `from` and `to` are never both zero.
1276      */
1277     function _afterTokenTransfers(
1278         address from,
1279         address to,
1280         uint256 startTokenId,
1281         uint256 quantity
1282     ) internal virtual {}
1283 }
1284 
1285 pragma solidity ^0.8.7;
1286 
1287 contract Flingo is ERC721A, Ownable {
1288     using Strings for uint256;
1289 
1290     string public baseMetaUri;
1291     
1292     //General Settings
1293     uint16 public maxMintAmountPerTransaction = 20;
1294     uint16 public maxMintAmountPerWallet = 20;
1295 
1296     //Inventory
1297     uint256 public maxSupply = 1000;
1298 
1299     //Prices
1300     uint256 public cost = 0.07 ether;
1301 
1302     //Utility
1303     bool public paused = true;
1304     
1305     constructor(string memory _baseUrl) ERC721A("Flingo", "FFLYB") {
1306         baseMetaUri = _baseUrl;
1307     }
1308 
1309     function numberMinted(address owner) public view returns (uint256) {
1310         return _numberMinted(owner);
1311     }
1312 
1313     // public
1314     function mint(uint256 _mintAmount) public payable {
1315         if (msg.sender != owner()) {
1316             uint256 ownerTokenCount = balanceOf(msg.sender);
1317 
1318             require(!paused, "Contract Paused");
1319             require(_mintAmount > 0, "Mint amount should be greater than 0");
1320             require(
1321                 _mintAmount <= maxMintAmountPerTransaction,
1322                 "Sorry you cant mint this amount at once"
1323             );
1324             require(
1325                 totalSupply() + _mintAmount <= maxSupply,
1326                 "Exceeds Max Supply"
1327             );
1328             require(
1329                 (ownerTokenCount + _mintAmount) <= maxMintAmountPerWallet,
1330                 "Sorry you cant mint more"
1331             );
1332             require(
1333                 msg.value >= cost * _mintAmount, 
1334                 "Insuffient funds");
1335         }
1336         _mintLoop(msg.sender, _mintAmount);
1337     }
1338 
1339     function gift(address _to, uint256 _mintAmount) public onlyOwner {
1340         _mintLoop(_to, _mintAmount);
1341     }
1342 
1343     function airdrop(address[] memory _airdropAddresses) public onlyOwner {
1344         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1345             address to = _airdropAddresses[i];
1346             _mintLoop(to, 1);
1347         }
1348     }
1349 
1350     function _baseURI() internal view virtual override returns (string memory) {
1351         return baseMetaUri;
1352     }
1353 
1354     function tokenURI(uint256 tokenId)
1355         public
1356         view
1357         virtual
1358         override
1359         returns (string memory)
1360     {
1361         require(
1362             _exists(tokenId),
1363             "ERC721Metadata: URI query for nonexistent token"
1364         );
1365         string memory currentBaseURI = _baseURI();
1366         return
1367             bytes(currentBaseURI).length > 0
1368                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1369                 : "";
1370     }
1371 
1372     function setCost(uint256 _newCost) public onlyOwner {
1373         cost = _newCost;
1374     }
1375 
1376      //Burn functions
1377     function batchBurn(uint256[] memory _BurnTokenIds) public virtual {
1378             for(uint256 i = 0; i < _BurnTokenIds.length; i++){
1379                 _burn(_BurnTokenIds[i], true);
1380             }
1381     }
1382 
1383     function burn(uint256 _BurnTokenId) public virtual{
1384         _burn(_BurnTokenId, true);
1385     }
1386    
1387     function setmaxMintAmountPerTransaction(uint16 _amount) public onlyOwner {
1388         maxMintAmountPerTransaction = _amount;
1389     }
1390 
1391     function setMaxMintAmountPerWallet(uint16 _amount) public onlyOwner {
1392         maxMintAmountPerWallet = _amount;
1393     }
1394 
1395     function setMaxSupply(uint256 _supply) public onlyOwner {
1396         maxSupply = _supply;
1397     }
1398 
1399     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1400         baseMetaUri = _newBaseURI;
1401     }
1402 
1403     function togglePause() public onlyOwner {
1404         paused = !paused;
1405     }
1406 
1407     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1408         _safeMint(_receiver, _mintAmount);
1409     }
1410 
1411     function withdraw() public payable onlyOwner {
1412         (bool success, ) = payable(msg.sender).call{
1413             value: address(this).balance
1414         }("");
1415         require(success);
1416     }
1417 }