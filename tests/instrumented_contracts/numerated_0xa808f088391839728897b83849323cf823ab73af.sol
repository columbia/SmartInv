1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15     uint8 private constant _ADDRESS_LENGTH = 20;
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
75      */
76     function toHexString(address addr) internal pure returns (string memory) {
77         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Context.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Provides information about the current execution context, including the
90  * sender of the transaction and its data. While these are generally available
91  * via msg.sender and msg.data, they should not be accessed in such a direct
92  * manner, since when dealing with meta-transactions the account sending and
93  * paying for execution may not be the actual sender (as far as an application
94  * is concerned).
95  *
96  * This contract is only required for intermediate, library-like contracts.
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes calldata) {
104         return msg.data;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/access/Ownable.sol
109 
110 
111 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 
116 /**
117  * @dev Contract module which provides a basic access control mechanism, where
118  * there is an account (an owner) that can be granted exclusive access to
119  * specific functions.
120  *
121  * By default, the owner account will be the one that deploys the contract. This
122  * can later be changed with {transferOwnership}.
123  *
124  * This module is used through inheritance. It will make available the modifier
125  * `onlyOwner`, which can be applied to your functions to restrict their use to
126  * the owner.
127  */
128 abstract contract Ownable is Context {
129     address private _owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     /**
134      * @dev Initializes the contract setting the deployer as the initial owner.
135      */
136     constructor() {
137         _transferOwnership(_msgSender());
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         _checkOwner();
145         _;
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view virtual returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if the sender is not the owner.
157      */
158     function _checkOwner() internal view virtual {
159         require(owner() == _msgSender(), "Ownable: caller is not the owner");
160     }
161 
162     /**
163      * @dev Leaves the contract without owner. It will not be possible to call
164      * `onlyOwner` functions anymore. Can only be called by the current owner.
165      *
166      * NOTE: Renouncing ownership will leave the contract without an owner,
167      * thereby removing any functionality that is only available to the owner.
168      */
169     function renounceOwnership() public virtual onlyOwner {
170         _transferOwnership(address(0));
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Can only be called by the current owner.
176      */
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         _transferOwnership(newOwner);
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Internal function without access restriction.
185      */
186     function _transferOwnership(address newOwner) internal virtual {
187         address oldOwner = _owner;
188         _owner = newOwner;
189         emit OwnershipTransferred(oldOwner, newOwner);
190     }
191 }
192 
193 // File: @openzeppelin/contracts/utils/Address.sol
194 
195 
196 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
197 
198 pragma solidity ^0.8.1;
199 
200 /**
201  * @dev Collection of functions related to the address type
202  */
203 library Address {
204     /**
205      * @dev Returns true if `account` is a contract.
206      *
207      * [IMPORTANT]
208      * ====
209      * It is unsafe to assume that an address for which this function returns
210      * false is an externally-owned account (EOA) and not a contract.
211      *
212      * Among others, `isContract` will return false for the following
213      * types of addresses:
214      *
215      *  - an externally-owned account
216      *  - a contract in construction
217      *  - an address where a contract will be created
218      *  - an address where a contract lived, but was destroyed
219      * ====
220      *
221      * [IMPORTANT]
222      * ====
223      * You shouldn't rely on `isContract` to protect against flash loan attacks!
224      *
225      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
226      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
227      * constructor.
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies on extcodesize/address.code.length, which returns 0
232         // for contracts in construction, since the code is only stored at the end
233         // of the constructor execution.
234 
235         return account.code.length > 0;
236     }
237 
238     /**
239      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
240      * `recipient`, forwarding all available gas and reverting on errors.
241      *
242      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
243      * of certain opcodes, possibly making contracts go over the 2300 gas limit
244      * imposed by `transfer`, making them unable to receive funds via
245      * `transfer`. {sendValue} removes this limitation.
246      *
247      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
248      *
249      * IMPORTANT: because control is transferred to `recipient`, care must be
250      * taken to not create reentrancy vulnerabilities. Consider using
251      * {ReentrancyGuard} or the
252      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
253      */
254     function sendValue(address payable recipient, uint256 amount) internal {
255         require(address(this).balance >= amount, "Address: insufficient balance");
256 
257         (bool success, ) = recipient.call{value: amount}("");
258         require(success, "Address: unable to send value, recipient may have reverted");
259     }
260 
261     /**
262      * @dev Performs a Solidity function call using a low level `call`. A
263      * plain `call` is an unsafe replacement for a function call: use this
264      * function instead.
265      *
266      * If `target` reverts with a revert reason, it is bubbled up by this
267      * function (like regular Solidity function calls).
268      *
269      * Returns the raw returned data. To convert to the expected return value,
270      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
271      *
272      * Requirements:
273      *
274      * - `target` must be a contract.
275      * - calling `target` with `data` must not revert.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
280         return functionCall(target, data, "Address: low-level call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
285      * `errorMessage` as a fallback revert reason when `target` reverts.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, 0, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but also transferring `value` wei to `target`.
300      *
301      * Requirements:
302      *
303      * - the calling contract must have an ETH balance of at least `value`.
304      * - the called Solidity function must be `payable`.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value
312     ) internal returns (bytes memory) {
313         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
318      * with `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(
323         address target,
324         bytes memory data,
325         uint256 value,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(address(this).balance >= value, "Address: insufficient balance for call");
329         require(isContract(target), "Address: call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.call{value: value}(data);
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
342         return functionStaticCall(target, data, "Address: low-level static call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal view returns (bytes memory) {
356         require(isContract(target), "Address: static call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.staticcall(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
369         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
374      * but performing a delegate call.
375      *
376      * _Available since v3.4._
377      */
378     function functionDelegateCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(isContract(target), "Address: delegate call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.delegatecall(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
391      * revert reason using the provided one.
392      *
393      * _Available since v4.3._
394      */
395     function verifyCallResult(
396         bool success,
397         bytes memory returndata,
398         string memory errorMessage
399     ) internal pure returns (bytes memory) {
400         if (success) {
401             return returndata;
402         } else {
403             // Look for revert reason and bubble it up if present
404             if (returndata.length > 0) {
405                 // The easiest way to bubble the revert reason is using memory via assembly
406                 /// @solidity memory-safe-assembly
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
419 
420 
421 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @title ERC721 token receiver interface
427  * @dev Interface for any contract that wants to support safeTransfers
428  * from ERC721 asset contracts.
429  */
430 interface IERC721Receiver {
431     /**
432      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
433      * by `operator` from `from`, this function is called.
434      *
435      * It must return its Solidity selector to confirm the token transfer.
436      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
437      *
438      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
439      */
440     function onERC721Received(
441         address operator,
442         address from,
443         uint256 tokenId,
444         bytes calldata data
445     ) external returns (bytes4);
446 }
447 
448 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev Interface of the ERC165 standard, as defined in the
457  * https://eips.ethereum.org/EIPS/eip-165[EIP].
458  *
459  * Implementers can declare support of contract interfaces, which can then be
460  * queried by others ({ERC165Checker}).
461  *
462  * For an implementation, see {ERC165}.
463  */
464 interface IERC165 {
465     /**
466      * @dev Returns true if this contract implements the interface defined by
467      * `interfaceId`. See the corresponding
468      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
469      * to learn more about how these ids are created.
470      *
471      * This function call must use less than 30 000 gas.
472      */
473     function supportsInterface(bytes4 interfaceId) external view returns (bool);
474 }
475 
476 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @dev Implementation of the {IERC165} interface.
486  *
487  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
488  * for the additional interface id that will be supported. For example:
489  *
490  * ```solidity
491  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
492  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
493  * }
494  * ```
495  *
496  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
497  */
498 abstract contract ERC165 is IERC165 {
499     /**
500      * @dev See {IERC165-supportsInterface}.
501      */
502     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
503         return interfaceId == type(IERC165).interfaceId;
504     }
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
508 
509 
510 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @dev Required interface of an ERC721 compliant contract.
517  */
518 interface IERC721 is IERC165 {
519     /**
520      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
521      */
522     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
523 
524     /**
525      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
526      */
527     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
528 
529     /**
530      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
531      */
532     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
533 
534     /**
535      * @dev Returns the number of tokens in ``owner``'s account.
536      */
537     function balanceOf(address owner) external view returns (uint256 balance);
538 
539     /**
540      * @dev Returns the owner of the `tokenId` token.
541      *
542      * Requirements:
543      *
544      * - `tokenId` must exist.
545      */
546     function ownerOf(uint256 tokenId) external view returns (address owner);
547 
548     /**
549      * @dev Safely transfers `tokenId` token from `from` to `to`.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must exist and be owned by `from`.
556      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
557      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
558      *
559      * Emits a {Transfer} event.
560      */
561     function safeTransferFrom(
562         address from,
563         address to,
564         uint256 tokenId,
565         bytes calldata data
566     ) external;
567 
568     /**
569      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
570      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
571      *
572      * Requirements:
573      *
574      * - `from` cannot be the zero address.
575      * - `to` cannot be the zero address.
576      * - `tokenId` token must exist and be owned by `from`.
577      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
578      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
579      *
580      * Emits a {Transfer} event.
581      */
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) external;
587 
588     /**
589      * @dev Transfers `tokenId` token from `from` to `to`.
590      *
591      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
592      *
593      * Requirements:
594      *
595      * - `from` cannot be the zero address.
596      * - `to` cannot be the zero address.
597      * - `tokenId` token must be owned by `from`.
598      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
599      *
600      * Emits a {Transfer} event.
601      */
602     function transferFrom(
603         address from,
604         address to,
605         uint256 tokenId
606     ) external;
607 
608     /**
609      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
610      * The approval is cleared when the token is transferred.
611      *
612      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
613      *
614      * Requirements:
615      *
616      * - The caller must own the token or be an approved operator.
617      * - `tokenId` must exist.
618      *
619      * Emits an {Approval} event.
620      */
621     function approve(address to, uint256 tokenId) external;
622 
623     /**
624      * @dev Approve or remove `operator` as an operator for the caller.
625      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
626      *
627      * Requirements:
628      *
629      * - The `operator` cannot be the caller.
630      *
631      * Emits an {ApprovalForAll} event.
632      */
633     function setApprovalForAll(address operator, bool _approved) external;
634 
635     /**
636      * @dev Returns the account approved for `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function getApproved(uint256 tokenId) external view returns (address operator);
643 
644     /**
645      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
646      *
647      * See {setApprovalForAll}
648      */
649     function isApprovedForAll(address owner, address operator) external view returns (bool);
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
653 
654 
655 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
662  * @dev See https://eips.ethereum.org/EIPS/eip-721
663  */
664 interface IERC721Metadata is IERC721 {
665     /**
666      * @dev Returns the token collection name.
667      */
668     function name() external view returns (string memory);
669 
670     /**
671      * @dev Returns the token collection symbol.
672      */
673     function symbol() external view returns (string memory);
674 
675     /**
676      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
677      */
678     function tokenURI(uint256 tokenId) external view returns (string memory);
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
682 
683 
684 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 
690 
691 
692 
693 
694 
695 /**
696  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
697  * the Metadata extension, but not including the Enumerable extension, which is available separately as
698  * {ERC721Enumerable}.
699  */
700 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
701     using Address for address;
702     using Strings for uint256;
703 
704     // Token name
705     string private _name;
706 
707     // Token symbol
708     string private _symbol;
709 
710     // Mapping from token ID to owner address
711     mapping(uint256 => address) private _owners;
712 
713     // Mapping owner address to token count
714     mapping(address => uint256) private _balances;
715 
716     // Mapping from token ID to approved address
717     mapping(uint256 => address) private _tokenApprovals;
718 
719     // Mapping from owner to operator approvals
720     mapping(address => mapping(address => bool)) private _operatorApprovals;
721 
722     /**
723      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
724      */
725     constructor(string memory name_, string memory symbol_) {
726         _name = name_;
727         _symbol = symbol_;
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
734         return
735             interfaceId == type(IERC721).interfaceId ||
736             interfaceId == type(IERC721Metadata).interfaceId ||
737             super.supportsInterface(interfaceId);
738     }
739 
740     /**
741      * @dev See {IERC721-balanceOf}.
742      */
743     function balanceOf(address owner) public view virtual override returns (uint256) {
744         require(owner != address(0), "ERC721: address zero is not a valid owner");
745         return _balances[owner];
746     }
747 
748     /**
749      * @dev See {IERC721-ownerOf}.
750      */
751     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
752         address owner = _owners[tokenId];
753         require(owner != address(0), "ERC721: invalid token ID");
754         return owner;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-name}.
759      */
760     function name() public view virtual override returns (string memory) {
761         return _name;
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-symbol}.
766      */
767     function symbol() public view virtual override returns (string memory) {
768         return _symbol;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-tokenURI}.
773      */
774     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
775         _requireMinted(tokenId);
776 
777         string memory baseURI = _baseURI();
778         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
779     }
780 
781     /**
782      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
783      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
784      * by default, can be overridden in child contracts.
785      */
786     function _baseURI() internal view virtual returns (string memory) {
787         return "";
788     }
789 
790     /**
791      * @dev See {IERC721-approve}.
792      */
793     function approve(address to, uint256 tokenId) public virtual override {
794         address owner = ERC721.ownerOf(tokenId);
795         require(to != owner, "ERC721: approval to current owner");
796 
797         require(
798             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
799             "ERC721: approve caller is not token owner nor approved for all"
800         );
801 
802         _approve(to, tokenId);
803     }
804 
805     /**
806      * @dev See {IERC721-getApproved}.
807      */
808     function getApproved(uint256 tokenId) public view virtual override returns (address) {
809         _requireMinted(tokenId);
810 
811         return _tokenApprovals[tokenId];
812     }
813 
814     /**
815      * @dev See {IERC721-setApprovalForAll}.
816      */
817     function setApprovalForAll(address operator, bool approved) public virtual override {
818         _setApprovalForAll(_msgSender(), operator, approved);
819     }
820 
821     /**
822      * @dev See {IERC721-isApprovedForAll}.
823      */
824     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
825         return _operatorApprovals[owner][operator];
826     }
827 
828     /**
829      * @dev See {IERC721-transferFrom}.
830      */
831     function transferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public virtual override {
836         //solhint-disable-next-line max-line-length
837         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
838 
839         _transfer(from, to, tokenId);
840     }
841 
842     /**
843      * @dev See {IERC721-safeTransferFrom}.
844      */
845     function safeTransferFrom(
846         address from,
847         address to,
848         uint256 tokenId
849     ) public virtual override {
850         safeTransferFrom(from, to, tokenId, "");
851     }
852 
853     /**
854      * @dev See {IERC721-safeTransferFrom}.
855      */
856     function safeTransferFrom(
857         address from,
858         address to,
859         uint256 tokenId,
860         bytes memory data
861     ) public virtual override {
862         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
863         _safeTransfer(from, to, tokenId, data);
864     }
865 
866     /**
867      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
868      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
869      *
870      * `data` is additional data, it has no specified format and it is sent in call to `to`.
871      *
872      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
873      * implement alternative mechanisms to perform token transfer, such as signature-based.
874      *
875      * Requirements:
876      *
877      * - `from` cannot be the zero address.
878      * - `to` cannot be the zero address.
879      * - `tokenId` token must exist and be owned by `from`.
880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _safeTransfer(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory data
889     ) internal virtual {
890         _transfer(from, to, tokenId);
891         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
892     }
893 
894     /**
895      * @dev Returns whether `tokenId` exists.
896      *
897      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
898      *
899      * Tokens start existing when they are minted (`_mint`),
900      * and stop existing when they are burned (`_burn`).
901      */
902     function _exists(uint256 tokenId) internal view virtual returns (bool) {
903         return _owners[tokenId] != address(0);
904     }
905 
906     /**
907      * @dev Returns whether `spender` is allowed to manage `tokenId`.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must exist.
912      */
913     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
914         address owner = ERC721.ownerOf(tokenId);
915         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
916     }
917 
918     /**
919      * @dev Safely mints `tokenId` and transfers it to `to`.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must not exist.
924      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _safeMint(address to, uint256 tokenId) internal virtual {
929         _safeMint(to, tokenId, "");
930     }
931 
932     /**
933      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
934      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
935      */
936     function _safeMint(
937         address to,
938         uint256 tokenId,
939         bytes memory data
940     ) internal virtual {
941         _mint(to, tokenId);
942         require(
943             _checkOnERC721Received(address(0), to, tokenId, data),
944             "ERC721: transfer to non ERC721Receiver implementer"
945         );
946     }
947 
948     /**
949      * @dev Mints `tokenId` and transfers it to `to`.
950      *
951      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
952      *
953      * Requirements:
954      *
955      * - `tokenId` must not exist.
956      * - `to` cannot be the zero address.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _mint(address to, uint256 tokenId) internal virtual {
961         require(to != address(0), "ERC721: mint to the zero address");
962         require(!_exists(tokenId), "ERC721: token already minted");
963 
964         _beforeTokenTransfer(address(0), to, tokenId);
965 
966         _balances[to] += 1;
967         _owners[tokenId] = to;
968 
969         emit Transfer(address(0), to, tokenId);
970 
971         _afterTokenTransfer(address(0), to, tokenId);
972     }
973 
974     /**
975      * @dev Destroys `tokenId`.
976      * The approval is cleared when the token is burned.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must exist.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _burn(uint256 tokenId) internal virtual {
985         address owner = ERC721.ownerOf(tokenId);
986 
987         _beforeTokenTransfer(owner, address(0), tokenId);
988 
989         // Clear approvals
990         _approve(address(0), tokenId);
991 
992         _balances[owner] -= 1;
993         delete _owners[tokenId];
994 
995         emit Transfer(owner, address(0), tokenId);
996 
997         _afterTokenTransfer(owner, address(0), tokenId);
998     }
999 
1000     /**
1001      * @dev Transfers `tokenId` from `from` to `to`.
1002      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1003      *
1004      * Requirements:
1005      *
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must be owned by `from`.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _transfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) internal virtual {
1016         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1017         require(to != address(0), "ERC721: transfer to the zero address");
1018 
1019         _beforeTokenTransfer(from, to, tokenId);
1020 
1021         // Clear approvals from the previous owner
1022         _approve(address(0), tokenId);
1023 
1024         _balances[from] -= 1;
1025         _balances[to] += 1;
1026         _owners[tokenId] = to;
1027 
1028         emit Transfer(from, to, tokenId);
1029 
1030         _afterTokenTransfer(from, to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev Approve `to` to operate on `tokenId`
1035      *
1036      * Emits an {Approval} event.
1037      */
1038     function _approve(address to, uint256 tokenId) internal virtual {
1039         _tokenApprovals[tokenId] = to;
1040         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev Approve `operator` to operate on all of `owner` tokens
1045      *
1046      * Emits an {ApprovalForAll} event.
1047      */
1048     function _setApprovalForAll(
1049         address owner,
1050         address operator,
1051         bool approved
1052     ) internal virtual {
1053         require(owner != operator, "ERC721: approve to caller");
1054         _operatorApprovals[owner][operator] = approved;
1055         emit ApprovalForAll(owner, operator, approved);
1056     }
1057 
1058     /**
1059      * @dev Reverts if the `tokenId` has not been minted yet.
1060      */
1061     function _requireMinted(uint256 tokenId) internal view virtual {
1062         require(_exists(tokenId), "ERC721: invalid token ID");
1063     }
1064 
1065     /**
1066      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1067      * The call is not executed if the target address is not a contract.
1068      *
1069      * @param from address representing the previous owner of the given token ID
1070      * @param to target address that will receive the tokens
1071      * @param tokenId uint256 ID of the token to be transferred
1072      * @param data bytes optional data to send along with the call
1073      * @return bool whether the call correctly returned the expected magic value
1074      */
1075     function _checkOnERC721Received(
1076         address from,
1077         address to,
1078         uint256 tokenId,
1079         bytes memory data
1080     ) private returns (bool) {
1081         if (to.isContract()) {
1082             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1083                 return retval == IERC721Receiver.onERC721Received.selector;
1084             } catch (bytes memory reason) {
1085                 if (reason.length == 0) {
1086                     revert("ERC721: transfer to non ERC721Receiver implementer");
1087                 } else {
1088                     /// @solidity memory-safe-assembly
1089                     assembly {
1090                         revert(add(32, reason), mload(reason))
1091                     }
1092                 }
1093             }
1094         } else {
1095             return true;
1096         }
1097     }
1098 
1099     /**
1100      * @dev Hook that is called before any token transfer. This includes minting
1101      * and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` will be minted for `to`.
1108      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1109      * - `from` and `to` are never both zero.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _beforeTokenTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) internal virtual {}
1118 
1119     /**
1120      * @dev Hook that is called after any transfer of tokens. This includes
1121      * minting and burning.
1122      *
1123      * Calling conditions:
1124      *
1125      * - when `from` and `to` are both non-zero.
1126      * - `from` and `to` are never both zero.
1127      *
1128      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1129      */
1130     function _afterTokenTransfer(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) internal virtual {}
1135 }
1136 
1137 // File: contracts/pin-planets.sol
1138 
1139 
1140 
1141 pragma solidity ^0.8.0;
1142 
1143 
1144 
1145 contract PinPlanets is ERC721, Ownable {
1146     using Strings for uint256;
1147 
1148     uint256 private constant _maxSupply = 250;
1149     uint256 private _totalSupply = 0;
1150     string private _baseTokenURI;
1151 
1152     constructor() ERC721("Pin Planets", "PINPLAN") {}
1153 
1154     function mint() public payable {
1155         require(_totalSupply < _maxSupply, "Max supply reached!");
1156 
1157         _safeMint(msg.sender, ++_totalSupply);
1158     }
1159 
1160     function maxSupply() public pure returns (uint256) {
1161         return _maxSupply;
1162     }
1163 
1164     function totalSupply() public view returns (uint256) {
1165         return _totalSupply;
1166     }
1167 
1168     function tokenURI(uint256 tokenId)
1169         public
1170         view
1171         virtual
1172         override
1173         returns (string memory)
1174     {
1175         require(
1176             _exists(tokenId),
1177             "ERC721Metadata: URI query for nonexistent token"
1178         );
1179 
1180         string memory currentBaseURI = _baseURI();
1181 
1182         return
1183             bytes(currentBaseURI).length > 0
1184                 ? string(
1185                     abi.encodePacked(
1186                         currentBaseURI,
1187                         tokenId.toString(),
1188                         ".json"
1189                     )
1190                 )
1191                 : "https://pin-planets.netlify.app/undiscovered.json";
1192     }
1193 
1194     function _baseURI() internal view virtual override returns (string memory) {
1195         return _baseTokenURI;
1196     }
1197 
1198     function setBaseURI(string calldata baseURI) external onlyOwner {
1199         _baseTokenURI = baseURI;
1200     }
1201 }