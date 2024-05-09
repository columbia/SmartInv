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
652 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
653 
654 
655 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
662  * @dev See https://eips.ethereum.org/EIPS/eip-721
663  */
664 interface IERC721Enumerable is IERC721 {
665     /**
666      * @dev Returns the total amount of tokens stored by the contract.
667      */
668     function totalSupply() external view returns (uint256);
669 
670     /**
671      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
672      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
673      */
674     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
675 
676     /**
677      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
678      * Use along with {totalSupply} to enumerate all tokens.
679      */
680     function tokenByIndex(uint256 index) external view returns (uint256);
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
693  * @dev See https://eips.ethereum.org/EIPS/eip-721
694  */
695 interface IERC721Metadata is IERC721 {
696     /**
697      * @dev Returns the token collection name.
698      */
699     function name() external view returns (string memory);
700 
701     /**
702      * @dev Returns the token collection symbol.
703      */
704     function symbol() external view returns (string memory);
705 
706     /**
707      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
708      */
709     function tokenURI(uint256 tokenId) external view returns (string memory);
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
713 
714 
715 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 
721 
722 
723 
724 
725 
726 /**
727  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
728  * the Metadata extension, but not including the Enumerable extension, which is available separately as
729  * {ERC721Enumerable}.
730  */
731 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
732     using Address for address;
733     using Strings for uint256;
734 
735     // Token name
736     string private _name;
737 
738     // Token symbol
739     string private _symbol;
740 
741     // Mapping from token ID to owner address
742     mapping(uint256 => address) private _owners;
743 
744     // Mapping owner address to token count
745     mapping(address => uint256) private _balances;
746 
747     // Mapping from token ID to approved address
748     mapping(uint256 => address) private _tokenApprovals;
749 
750     // Mapping from owner to operator approvals
751     mapping(address => mapping(address => bool)) private _operatorApprovals;
752 
753     /**
754      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
755      */
756     constructor(string memory name_, string memory symbol_) {
757         _name = name_;
758         _symbol = symbol_;
759     }
760 
761     /**
762      * @dev See {IERC165-supportsInterface}.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
765         return
766             interfaceId == type(IERC721).interfaceId ||
767             interfaceId == type(IERC721Metadata).interfaceId ||
768             super.supportsInterface(interfaceId);
769     }
770 
771     /**
772      * @dev See {IERC721-balanceOf}.
773      */
774     function balanceOf(address owner) public view virtual override returns (uint256) {
775         require(owner != address(0), "ERC721: address zero is not a valid owner");
776         return _balances[owner];
777     }
778 
779     /**
780      * @dev See {IERC721-ownerOf}.
781      */
782     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
783         address owner = _owners[tokenId];
784         require(owner != address(0), "ERC721: invalid token ID");
785         return owner;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-name}.
790      */
791     function name() public view virtual override returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-symbol}.
797      */
798     function symbol() public view virtual override returns (string memory) {
799         return _symbol;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-tokenURI}.
804      */
805     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
806         _requireMinted(tokenId);
807 
808         string memory baseURI = _baseURI();
809         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
810     }
811 
812     /**
813      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
814      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
815      * by default, can be overridden in child contracts.
816      */
817     function _baseURI() internal view virtual returns (string memory) {
818         return "";
819     }
820 
821     /**
822      * @dev See {IERC721-approve}.
823      */
824     function approve(address to, uint256 tokenId) public virtual override {
825         address owner = ERC721.ownerOf(tokenId);
826         require(to != owner, "ERC721: approval to current owner");
827 
828         require(
829             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
830             "ERC721: approve caller is not token owner nor approved for all"
831         );
832 
833         _approve(to, tokenId);
834     }
835 
836     /**
837      * @dev See {IERC721-getApproved}.
838      */
839     function getApproved(uint256 tokenId) public view virtual override returns (address) {
840         _requireMinted(tokenId);
841 
842         return _tokenApprovals[tokenId];
843     }
844 
845     /**
846      * @dev See {IERC721-setApprovalForAll}.
847      */
848     function setApprovalForAll(address operator, bool approved) public virtual override {
849         _setApprovalForAll(_msgSender(), operator, approved);
850     }
851 
852     /**
853      * @dev See {IERC721-isApprovedForAll}.
854      */
855     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
856         return _operatorApprovals[owner][operator];
857     }
858 
859     /**
860      * @dev See {IERC721-transferFrom}.
861      */
862     function transferFrom(
863         address from,
864         address to,
865         uint256 tokenId
866     ) public virtual override {
867         //solhint-disable-next-line max-line-length
868         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
869 
870         _transfer(from, to, tokenId);
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         safeTransferFrom(from, to, tokenId, "");
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes memory data
892     ) public virtual override {
893         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
894         _safeTransfer(from, to, tokenId, data);
895     }
896 
897     /**
898      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
899      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
900      *
901      * `data` is additional data, it has no specified format and it is sent in call to `to`.
902      *
903      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
904      * implement alternative mechanisms to perform token transfer, such as signature-based.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must exist and be owned by `from`.
911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _safeTransfer(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory data
920     ) internal virtual {
921         _transfer(from, to, tokenId);
922         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
923     }
924 
925     /**
926      * @dev Returns whether `tokenId` exists.
927      *
928      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
929      *
930      * Tokens start existing when they are minted (`_mint`),
931      * and stop existing when they are burned (`_burn`).
932      */
933     function _exists(uint256 tokenId) internal view virtual returns (bool) {
934         return _owners[tokenId] != address(0);
935     }
936 
937     /**
938      * @dev Returns whether `spender` is allowed to manage `tokenId`.
939      *
940      * Requirements:
941      *
942      * - `tokenId` must exist.
943      */
944     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
945         address owner = ERC721.ownerOf(tokenId);
946         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
947     }
948 
949     /**
950      * @dev Safely mints `tokenId` and transfers it to `to`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must not exist.
955      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _safeMint(address to, uint256 tokenId) internal virtual {
960         _safeMint(to, tokenId, "");
961     }
962 
963     /**
964      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
965      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
966      */
967     function _safeMint(
968         address to,
969         uint256 tokenId,
970         bytes memory data
971     ) internal virtual {
972         _mint(to, tokenId);
973         require(
974             _checkOnERC721Received(address(0), to, tokenId, data),
975             "ERC721: transfer to non ERC721Receiver implementer"
976         );
977     }
978 
979     /**
980      * @dev Mints `tokenId` and transfers it to `to`.
981      *
982      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
983      *
984      * Requirements:
985      *
986      * - `tokenId` must not exist.
987      * - `to` cannot be the zero address.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _mint(address to, uint256 tokenId) internal virtual {
992         require(to != address(0), "ERC721: mint to the zero address");
993         require(!_exists(tokenId), "ERC721: token already minted");
994 
995         _beforeTokenTransfer(address(0), to, tokenId);
996 
997         _balances[to] += 1;
998         _owners[tokenId] = to;
999 
1000         emit Transfer(address(0), to, tokenId);
1001 
1002         _afterTokenTransfer(address(0), to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev Destroys `tokenId`.
1007      * The approval is cleared when the token is burned.
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must exist.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _burn(uint256 tokenId) internal virtual {
1016         address owner = ERC721.ownerOf(tokenId);
1017 
1018         _beforeTokenTransfer(owner, address(0), tokenId);
1019 
1020         // Clear approvals
1021         _approve(address(0), tokenId);
1022 
1023         _balances[owner] -= 1;
1024         delete _owners[tokenId];
1025 
1026         emit Transfer(owner, address(0), tokenId);
1027 
1028         _afterTokenTransfer(owner, address(0), tokenId);
1029     }
1030 
1031     /**
1032      * @dev Transfers `tokenId` from `from` to `to`.
1033      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must be owned by `from`.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _transfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {
1047         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1048         require(to != address(0), "ERC721: transfer to the zero address");
1049 
1050         _beforeTokenTransfer(from, to, tokenId);
1051 
1052         // Clear approvals from the previous owner
1053         _approve(address(0), tokenId);
1054 
1055         _balances[from] -= 1;
1056         _balances[to] += 1;
1057         _owners[tokenId] = to;
1058 
1059         emit Transfer(from, to, tokenId);
1060 
1061         _afterTokenTransfer(from, to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev Approve `to` to operate on `tokenId`
1066      *
1067      * Emits an {Approval} event.
1068      */
1069     function _approve(address to, uint256 tokenId) internal virtual {
1070         _tokenApprovals[tokenId] = to;
1071         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1072     }
1073 
1074     /**
1075      * @dev Approve `operator` to operate on all of `owner` tokens
1076      *
1077      * Emits an {ApprovalForAll} event.
1078      */
1079     function _setApprovalForAll(
1080         address owner,
1081         address operator,
1082         bool approved
1083     ) internal virtual {
1084         require(owner != operator, "ERC721: approve to caller");
1085         _operatorApprovals[owner][operator] = approved;
1086         emit ApprovalForAll(owner, operator, approved);
1087     }
1088 
1089     /**
1090      * @dev Reverts if the `tokenId` has not been minted yet.
1091      */
1092     function _requireMinted(uint256 tokenId) internal view virtual {
1093         require(_exists(tokenId), "ERC721: invalid token ID");
1094     }
1095 
1096     /**
1097      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1098      * The call is not executed if the target address is not a contract.
1099      *
1100      * @param from address representing the previous owner of the given token ID
1101      * @param to target address that will receive the tokens
1102      * @param tokenId uint256 ID of the token to be transferred
1103      * @param data bytes optional data to send along with the call
1104      * @return bool whether the call correctly returned the expected magic value
1105      */
1106     function _checkOnERC721Received(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory data
1111     ) private returns (bool) {
1112         if (to.isContract()) {
1113             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1114                 return retval == IERC721Receiver.onERC721Received.selector;
1115             } catch (bytes memory reason) {
1116                 if (reason.length == 0) {
1117                     revert("ERC721: transfer to non ERC721Receiver implementer");
1118                 } else {
1119                     /// @solidity memory-safe-assembly
1120                     assembly {
1121                         revert(add(32, reason), mload(reason))
1122                     }
1123                 }
1124             }
1125         } else {
1126             return true;
1127         }
1128     }
1129 
1130     /**
1131      * @dev Hook that is called before any token transfer. This includes minting
1132      * and burning.
1133      *
1134      * Calling conditions:
1135      *
1136      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1137      * transferred to `to`.
1138      * - When `from` is zero, `tokenId` will be minted for `to`.
1139      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1140      * - `from` and `to` are never both zero.
1141      *
1142      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1143      */
1144     function _beforeTokenTransfer(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) internal virtual {}
1149 
1150     /**
1151      * @dev Hook that is called after any transfer of tokens. This includes
1152      * minting and burning.
1153      *
1154      * Calling conditions:
1155      *
1156      * - when `from` and `to` are both non-zero.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _afterTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual {}
1166 }
1167 
1168 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1169 
1170 
1171 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 
1176 
1177 /**
1178  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1179  * enumerability of all the token ids in the contract as well as all token ids owned by each
1180  * account.
1181  */
1182 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1183     // Mapping from owner to list of owned token IDs
1184     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1185 
1186     // Mapping from token ID to index of the owner tokens list
1187     mapping(uint256 => uint256) private _ownedTokensIndex;
1188 
1189     // Array with all token ids, used for enumeration
1190     uint256[] private _allTokens;
1191 
1192     // Mapping from token id to position in the allTokens array
1193     mapping(uint256 => uint256) private _allTokensIndex;
1194 
1195     /**
1196      * @dev See {IERC165-supportsInterface}.
1197      */
1198     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1199         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1204      */
1205     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1206         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1207         return _ownedTokens[owner][index];
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Enumerable-totalSupply}.
1212      */
1213     function totalSupply() public view virtual override returns (uint256) {
1214         return _allTokens.length;
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Enumerable-tokenByIndex}.
1219      */
1220     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1221         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1222         return _allTokens[index];
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before any token transfer. This includes minting
1227      * and burning.
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` will be minted for `to`.
1234      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1235      * - `from` cannot be the zero address.
1236      * - `to` cannot be the zero address.
1237      *
1238      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1239      */
1240     function _beforeTokenTransfer(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) internal virtual override {
1245         super._beforeTokenTransfer(from, to, tokenId);
1246 
1247         if (from == address(0)) {
1248             _addTokenToAllTokensEnumeration(tokenId);
1249         } else if (from != to) {
1250             _removeTokenFromOwnerEnumeration(from, tokenId);
1251         }
1252         if (to == address(0)) {
1253             _removeTokenFromAllTokensEnumeration(tokenId);
1254         } else if (to != from) {
1255             _addTokenToOwnerEnumeration(to, tokenId);
1256         }
1257     }
1258 
1259     /**
1260      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1261      * @param to address representing the new owner of the given token ID
1262      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1263      */
1264     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1265         uint256 length = ERC721.balanceOf(to);
1266         _ownedTokens[to][length] = tokenId;
1267         _ownedTokensIndex[tokenId] = length;
1268     }
1269 
1270     /**
1271      * @dev Private function to add a token to this extension's token tracking data structures.
1272      * @param tokenId uint256 ID of the token to be added to the tokens list
1273      */
1274     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1275         _allTokensIndex[tokenId] = _allTokens.length;
1276         _allTokens.push(tokenId);
1277     }
1278 
1279     /**
1280      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1281      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1282      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1283      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1284      * @param from address representing the previous owner of the given token ID
1285      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1286      */
1287     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1288         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1289         // then delete the last slot (swap and pop).
1290 
1291         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1292         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1293 
1294         // When the token to delete is the last token, the swap operation is unnecessary
1295         if (tokenIndex != lastTokenIndex) {
1296             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1297 
1298             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1299             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1300         }
1301 
1302         // This also deletes the contents at the last position of the array
1303         delete _ownedTokensIndex[tokenId];
1304         delete _ownedTokens[from][lastTokenIndex];
1305     }
1306 
1307     /**
1308      * @dev Private function to remove a token from this extension's token tracking data structures.
1309      * This has O(1) time complexity, but alters the order of the _allTokens array.
1310      * @param tokenId uint256 ID of the token to be removed from the tokens list
1311      */
1312     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1313         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1314         // then delete the last slot (swap and pop).
1315 
1316         uint256 lastTokenIndex = _allTokens.length - 1;
1317         uint256 tokenIndex = _allTokensIndex[tokenId];
1318 
1319         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1320         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1321         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1322         uint256 lastTokenId = _allTokens[lastTokenIndex];
1323 
1324         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1325         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1326 
1327         // This also deletes the contents at the last position of the array
1328         delete _allTokensIndex[tokenId];
1329         _allTokens.pop();
1330     }
1331 }
1332 
1333 
1334 
1335 
1336 
1337 
1338 pragma solidity >=0.7.0 <0.9.0;
1339 
1340 
1341 
1342 contract YellowBois is ERC721Enumerable, Ownable {
1343   using Strings for uint256;
1344 
1345   string public baseURI;
1346   string public baseExtension = ".json";
1347   string public notRevealedUri;
1348   uint256 public cost = 0.05 ether;
1349   uint256 public maxSupply = 2500;
1350   uint256 public maxnTokens = 10;
1351   uint256 public nftPerAddressLimit = 200;
1352   bool public paused = false;
1353   bool public revealed = false;
1354   bool public onlyWhitelisted = true;
1355   address[] public whitelistedAddresses;
1356   mapping(address => uint256) public addressMintedBalance;
1357 
1358 
1359   constructor(
1360     string memory _name,
1361     string memory _symbol,
1362     string memory _initBaseURI,
1363     string memory _initNotRevealedUri
1364   ) ERC721(_name, _symbol) {
1365     setBaseURI(_initBaseURI);
1366     setNotRevealedURI(_initNotRevealedUri);
1367   }
1368 
1369   // internal
1370   function _baseURI() internal view virtual override returns (string memory) {
1371     return baseURI;
1372   }
1373 
1374   // public
1375   function mint(uint256 _nTokens) public payable {
1376     require(!paused, "the contract is paused");
1377     uint256 supply = totalSupply();
1378     require(_nTokens > 0, "need to mint at least 1 NFT");
1379     require(_nTokens <= maxnTokens, "max mint amount per session exceeded");
1380     require(supply + _nTokens <= maxSupply, "max NFT limit exceeded");
1381 
1382     if (msg.sender != owner()) {
1383         if(onlyWhitelisted == true) {
1384             require(isWhitelisted(msg.sender), "user is not whitelisted");
1385             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1386             require(ownerMintedCount + _nTokens <= nftPerAddressLimit, "max NFT per address exceeded");
1387         }
1388         require(msg.value >= cost * _nTokens, "insufficient funds");
1389     }
1390     
1391     for (uint256 i = 1; i <= _nTokens; i++) {
1392         addressMintedBalance[msg.sender]++;
1393       _safeMint(msg.sender, supply + i);
1394     }
1395   }
1396   
1397   function isWhitelisted(address _user) public view returns (bool) {
1398     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1399       if (whitelistedAddresses[i] == _user) {
1400           return true;
1401       }
1402     }
1403     return false;
1404   }
1405 
1406   function walletOfOwner(address _owner)
1407     public
1408     view
1409     returns (uint256[] memory)
1410   {
1411     uint256 ownerTokenCount = balanceOf(_owner);
1412     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1413     for (uint256 i; i < ownerTokenCount; i++) {
1414       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1415     }
1416     return tokenIds;
1417   }
1418 
1419   function tokenURI(uint256 tokenId)
1420     public
1421     view
1422     virtual
1423     override
1424     returns (string memory)
1425   {
1426     require(
1427       _exists(tokenId),
1428       "ERC721Metadata: URI query for nonexistent token"
1429     );
1430     
1431     if(revealed == false) {
1432         return notRevealedUri;
1433     }
1434 
1435     string memory currentBaseURI = _baseURI();
1436     return bytes(currentBaseURI).length > 0
1437         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1438         : "";
1439   }
1440 
1441   //only owner
1442   function reveal() public onlyOwner {
1443       revealed = true;
1444   }
1445   
1446   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1447     nftPerAddressLimit = _limit;
1448   }
1449   
1450   function setCost(uint256 _newCost) public onlyOwner {
1451     cost = _newCost;
1452   }
1453 
1454   function setmaxnTokens(uint256 _newmaxnTokens) public onlyOwner {
1455     maxnTokens = _newmaxnTokens;
1456   }
1457 
1458   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1459     baseURI = _newBaseURI;
1460   }
1461 
1462   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1463     baseExtension = _newBaseExtension;
1464   }
1465   
1466   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1467     notRevealedUri = _notRevealedURI;
1468   }
1469 
1470   function pause(bool _state) public onlyOwner {
1471     paused = _state;
1472   }
1473   
1474   function setOnlyWhitelisted(bool _state) public onlyOwner {
1475     onlyWhitelisted = _state;
1476   }
1477   
1478   function whitelistUsers(address[] calldata _users) public onlyOwner {
1479     delete whitelistedAddresses;
1480     whitelistedAddresses = _users;
1481   }
1482  
1483     function withdrawMint() external onlyOwner {
1484         payable(msg.sender).transfer(address(this).balance);
1485     }
1486 }