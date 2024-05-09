1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/Tikka_Tiger_NFT.sol
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17     uint8 private constant _ADDRESS_LENGTH = 20;
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 
75     /**
76      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
77      */
78     function toHexString(address addr) internal pure returns (string memory) {
79         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/Context.sol
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Provides information about the current execution context, including the
92  * sender of the transaction and its data. While these are generally available
93  * via msg.sender and msg.data, they should not be accessed in such a direct
94  * manner, since when dealing with meta-transactions the account sending and
95  * paying for execution may not be the actual sender (as far as an application
96  * is concerned).
97  *
98  * This contract is only required for intermediate, library-like contracts.
99  */
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/access/Ownable.sol
111 
112 
113 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 
118 /**
119  * @dev Contract module which provides a basic access control mechanism, where
120  * there is an account (an owner) that can be granted exclusive access to
121  * specific functions.
122  *
123  * By default, the owner account will be the one that deploys the contract. This
124  * can later be changed with {transferOwnership}.
125  *
126  * This module is used through inheritance. It will make available the modifier
127  * `onlyOwner`, which can be applied to your functions to restrict their use to
128  * the owner.
129  */
130 abstract contract Ownable is Context {
131     address private _owner;
132 
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     /**
136      * @dev Initializes the contract setting the deployer as the initial owner.
137      */
138     constructor() {
139         _transferOwnership(_msgSender());
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         _checkOwner();
147         _;
148     }
149 
150     /**
151      * @dev Returns the address of the current owner.
152      */
153     function owner() public view virtual returns (address) {
154         return _owner;
155     }
156 
157     /**
158      * @dev Throws if the sender is not the owner.
159      */
160     function _checkOwner() internal view virtual {
161         require(owner() == _msgSender(), "Ownable: caller is not the owner");
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         _transferOwnership(address(0));
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         _transferOwnership(newOwner);
182     }
183 
184     /**
185      * @dev Transfers ownership of the contract to a new account (`newOwner`).
186      * Internal function without access restriction.
187      */
188     function _transferOwnership(address newOwner) internal virtual {
189         address oldOwner = _owner;
190         _owner = newOwner;
191         emit OwnershipTransferred(oldOwner, newOwner);
192     }
193 }
194 
195 // File: @openzeppelin/contracts/utils/Address.sol
196 
197 
198 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @dev Collection of functions related to the address type
204  */
205 library Address {
206     /**
207      * @dev Returns true if `account` is a contract.
208      *
209      * [IMPORTANT]
210      * ====
211      * It is unsafe to assume that an address for which this function returns
212      * false is an externally-owned account (EOA) and not a contract.
213      *
214      * Among others, `isContract` will return false for the following
215      * types of addresses:
216      *
217      *  - an externally-owned account
218      *  - a contract in construction
219      *  - an address where a contract will be created
220      *  - an address where a contract lived, but was destroyed
221      * ====
222      *
223      * [IMPORTANT]
224      * ====
225      * You shouldn't rely on `isContract` to protect against flash loan attacks!
226      *
227      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
228      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
229      * constructor.
230      * ====
231      */
232     function isContract(address account) internal view returns (bool) {
233         // This method relies on extcodesize/address.code.length, which returns 0
234         // for contracts in construction, since the code is only stored at the end
235         // of the constructor execution.
236 
237         return account.code.length > 0;
238     }
239 
240     /**
241      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
242      * `recipient`, forwarding all available gas and reverting on errors.
243      *
244      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
245      * of certain opcodes, possibly making contracts go over the 2300 gas limit
246      * imposed by `transfer`, making them unable to receive funds via
247      * `transfer`. {sendValue} removes this limitation.
248      *
249      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
250      *
251      * IMPORTANT: because control is transferred to `recipient`, care must be
252      * taken to not create reentrancy vulnerabilities. Consider using
253      * {ReentrancyGuard} or the
254      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         (bool success, ) = recipient.call{value: amount}("");
260         require(success, "Address: unable to send value, recipient may have reverted");
261     }
262 
263     /**
264      * @dev Performs a Solidity function call using a low level `call`. A
265      * plain `call` is an unsafe replacement for a function call: use this
266      * function instead.
267      *
268      * If `target` reverts with a revert reason, it is bubbled up by this
269      * function (like regular Solidity function calls).
270      *
271      * Returns the raw returned data. To convert to the expected return value,
272      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
273      *
274      * Requirements:
275      *
276      * - `target` must be a contract.
277      * - calling `target` with `data` must not revert.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionCall(target, data, "Address: low-level call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
287      * `errorMessage` as a fallback revert reason when `target` reverts.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, 0, errorMessage);
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301      * but also transferring `value` wei to `target`.
302      *
303      * Requirements:
304      *
305      * - the calling contract must have an ETH balance of at least `value`.
306      * - the called Solidity function must be `payable`.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value
314     ) internal returns (bytes memory) {
315         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
320      * with `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         require(address(this).balance >= value, "Address: insufficient balance for call");
331         require(isContract(target), "Address: call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.call{value: value}(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
344         return functionStaticCall(target, data, "Address: low-level static call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal view returns (bytes memory) {
358         require(isContract(target), "Address: static call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.staticcall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(isContract(target), "Address: delegate call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.delegatecall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
393      * revert reason using the provided one.
394      *
395      * _Available since v4.3._
396      */
397     function verifyCallResult(
398         bool success,
399         bytes memory returndata,
400         string memory errorMessage
401     ) internal pure returns (bytes memory) {
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408                 /// @solidity memory-safe-assembly
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
421 
422 
423 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 /**
428  * @title ERC721 token receiver interface
429  * @dev Interface for any contract that wants to support safeTransfers
430  * from ERC721 asset contracts.
431  */
432 interface IERC721Receiver {
433     /**
434      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
435      * by `operator` from `from`, this function is called.
436      *
437      * It must return its Solidity selector to confirm the token transfer.
438      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
439      *
440      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
441      */
442     function onERC721Received(
443         address operator,
444         address from,
445         uint256 tokenId,
446         bytes calldata data
447     ) external returns (bytes4);
448 }
449 
450 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Interface of the ERC165 standard, as defined in the
459  * https://eips.ethereum.org/EIPS/eip-165[EIP].
460  *
461  * Implementers can declare support of contract interfaces, which can then be
462  * queried by others ({ERC165Checker}).
463  *
464  * For an implementation, see {ERC165}.
465  */
466 interface IERC165 {
467     /**
468      * @dev Returns true if this contract implements the interface defined by
469      * `interfaceId`. See the corresponding
470      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
471      * to learn more about how these ids are created.
472      *
473      * This function call must use less than 30 000 gas.
474      */
475     function supportsInterface(bytes4 interfaceId) external view returns (bool);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @dev Implementation of the {IERC165} interface.
488  *
489  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
490  * for the additional interface id that will be supported. For example:
491  *
492  * ```solidity
493  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
495  * }
496  * ```
497  *
498  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
499  */
500 abstract contract ERC165 is IERC165 {
501     /**
502      * @dev See {IERC165-supportsInterface}.
503      */
504     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
505         return interfaceId == type(IERC165).interfaceId;
506     }
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
510 
511 
512 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @dev Required interface of an ERC721 compliant contract.
519  */
520 interface IERC721 is IERC165 {
521     /**
522      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
523      */
524     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
528      */
529     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
530 
531     /**
532      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
533      */
534     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
535 
536     /**
537      * @dev Returns the number of tokens in ``owner``'s account.
538      */
539     function balanceOf(address owner) external view returns (uint256 balance);
540 
541     /**
542      * @dev Returns the owner of the `tokenId` token.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must exist.
547      */
548     function ownerOf(uint256 tokenId) external view returns (address owner);
549 
550     /**
551      * @dev Safely transfers `tokenId` token from `from` to `to`.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must exist and be owned by `from`.
558      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
559      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
560      *
561      * Emits a {Transfer} event.
562      */
563     function safeTransferFrom(
564         address from,
565         address to,
566         uint256 tokenId,
567         bytes calldata data
568     ) external;
569 
570     /**
571      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
572      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
573      *
574      * Requirements:
575      *
576      * - `from` cannot be the zero address.
577      * - `to` cannot be the zero address.
578      * - `tokenId` token must exist and be owned by `from`.
579      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
580      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
581      *
582      * Emits a {Transfer} event.
583      */
584     function safeTransferFrom(
585         address from,
586         address to,
587         uint256 tokenId
588     ) external;
589 
590     /**
591      * @dev Transfers `tokenId` token from `from` to `to`.
592      *
593      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `tokenId` token must be owned by `from`.
600      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
601      *
602      * Emits a {Transfer} event.
603      */
604     function transferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) external;
609 
610     /**
611      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
612      * The approval is cleared when the token is transferred.
613      *
614      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
615      *
616      * Requirements:
617      *
618      * - The caller must own the token or be an approved operator.
619      * - `tokenId` must exist.
620      *
621      * Emits an {Approval} event.
622      */
623     function approve(address to, uint256 tokenId) external;
624 
625     /**
626      * @dev Approve or remove `operator` as an operator for the caller.
627      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
628      *
629      * Requirements:
630      *
631      * - The `operator` cannot be the caller.
632      *
633      * Emits an {ApprovalForAll} event.
634      */
635     function setApprovalForAll(address operator, bool _approved) external;
636 
637     /**
638      * @dev Returns the account approved for `tokenId` token.
639      *
640      * Requirements:
641      *
642      * - `tokenId` must exist.
643      */
644     function getApproved(uint256 tokenId) external view returns (address operator);
645 
646     /**
647      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
648      *
649      * See {setApprovalForAll}
650      */
651     function isApprovedForAll(address owner, address operator) external view returns (bool);
652 }
653 
654 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
655 
656 
657 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 
662 /**
663  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
664  * @dev See https://eips.ethereum.org/EIPS/eip-721
665  */
666 interface IERC721Enumerable is IERC721 {
667     /**
668      * @dev Returns the total amount of tokens stored by the contract.
669      */
670     function totalSupply() external view returns (uint256);
671 
672     /**
673      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
674      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
675      */
676     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
677 
678     /**
679      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
680      * Use along with {totalSupply} to enumerate all tokens.
681      */
682     function tokenByIndex(uint256 index) external view returns (uint256);
683 }
684 
685 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 /**
694  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
695  * @dev See https://eips.ethereum.org/EIPS/eip-721
696  */
697 interface IERC721Metadata is IERC721 {
698     /**
699      * @dev Returns the token collection name.
700      */
701     function name() external view returns (string memory);
702 
703     /**
704      * @dev Returns the token collection symbol.
705      */
706     function symbol() external view returns (string memory);
707 
708     /**
709      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
710      */
711     function tokenURI(uint256 tokenId) external view returns (string memory);
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
715 
716 
717 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 
722 
723 
724 
725 
726 
727 
728 /**
729  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
730  * the Metadata extension, but not including the Enumerable extension, which is available separately as
731  * {ERC721Enumerable}.
732  */
733 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
734     using Address for address;
735     using Strings for uint256;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to owner address
744     mapping(uint256 => address) private _owners;
745 
746     // Mapping owner address to token count
747     mapping(address => uint256) private _balances;
748 
749     // Mapping from token ID to approved address
750     mapping(uint256 => address) private _tokenApprovals;
751 
752     // Mapping from owner to operator approvals
753     mapping(address => mapping(address => bool)) private _operatorApprovals;
754 
755     /**
756      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
757      */
758     constructor(string memory name_, string memory symbol_) {
759         _name = name_;
760         _symbol = symbol_;
761     }
762 
763     /**
764      * @dev See {IERC165-supportsInterface}.
765      */
766     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
767         return
768             interfaceId == type(IERC721).interfaceId ||
769             interfaceId == type(IERC721Metadata).interfaceId ||
770             super.supportsInterface(interfaceId);
771     }
772 
773     /**
774      * @dev See {IERC721-balanceOf}.
775      */
776     function balanceOf(address owner) public view virtual override returns (uint256) {
777         require(owner != address(0), "ERC721: address zero is not a valid owner");
778         return _balances[owner];
779     }
780 
781     /**
782      * @dev See {IERC721-ownerOf}.
783      */
784     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
785         address owner = _owners[tokenId];
786         require(owner != address(0), "ERC721: invalid token ID");
787         return owner;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-name}.
792      */
793     function name() public view virtual override returns (string memory) {
794         return _name;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-symbol}.
799      */
800     function symbol() public view virtual override returns (string memory) {
801         return _symbol;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-tokenURI}.
806      */
807     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
808         _requireMinted(tokenId);
809 
810         string memory baseURI = _baseURI();
811         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
812     }
813 
814     /**
815      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
816      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
817      * by default, can be overridden in child contracts.
818      */
819     function _baseURI() internal view virtual returns (string memory) {
820         return "";
821     }
822 
823     /**
824      * @dev See {IERC721-approve}.
825      */
826     function approve(address to, uint256 tokenId) public virtual override {
827         address owner = ERC721.ownerOf(tokenId);
828         require(to != owner, "ERC721: approval to current owner");
829 
830         require(
831             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
832             "ERC721: approve caller is not token owner nor approved for all"
833         );
834 
835         _approve(to, tokenId);
836     }
837 
838     /**
839      * @dev See {IERC721-getApproved}.
840      */
841     function getApproved(uint256 tokenId) public view virtual override returns (address) {
842         _requireMinted(tokenId);
843 
844         return _tokenApprovals[tokenId];
845     }
846 
847     /**
848      * @dev See {IERC721-setApprovalForAll}.
849      */
850     function setApprovalForAll(address operator, bool approved) public virtual override {
851         _setApprovalForAll(_msgSender(), operator, approved);
852     }
853 
854     /**
855      * @dev See {IERC721-isApprovedForAll}.
856      */
857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
858         return _operatorApprovals[owner][operator];
859     }
860 
861     /**
862      * @dev See {IERC721-transferFrom}.
863      */
864     function transferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         //solhint-disable-next-line max-line-length
870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
871 
872         _transfer(from, to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         safeTransferFrom(from, to, tokenId, "");
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory data
894     ) public virtual override {
895         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
896         _safeTransfer(from, to, tokenId, data);
897     }
898 
899     /**
900      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
901      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
902      *
903      * `data` is additional data, it has no specified format and it is sent in call to `to`.
904      *
905      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
906      * implement alternative mechanisms to perform token transfer, such as signature-based.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _safeTransfer(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory data
922     ) internal virtual {
923         _transfer(from, to, tokenId);
924         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
925     }
926 
927     /**
928      * @dev Returns whether `tokenId` exists.
929      *
930      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
931      *
932      * Tokens start existing when they are minted (`_mint`),
933      * and stop existing when they are burned (`_burn`).
934      */
935     function _exists(uint256 tokenId) internal view virtual returns (bool) {
936         return _owners[tokenId] != address(0);
937     }
938 
939     /**
940      * @dev Returns whether `spender` is allowed to manage `tokenId`.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      */
946     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
947         address owner = ERC721.ownerOf(tokenId);
948         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
949     }
950 
951     /**
952      * @dev Safely mints `tokenId` and transfers it to `to`.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must not exist.
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _safeMint(address to, uint256 tokenId) internal virtual {
962         _safeMint(to, tokenId, "");
963     }
964 
965     /**
966      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
967      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
968      */
969     function _safeMint(
970         address to,
971         uint256 tokenId,
972         bytes memory data
973     ) internal virtual {
974         _mint(to, tokenId);
975         require(
976             _checkOnERC721Received(address(0), to, tokenId, data),
977             "ERC721: transfer to non ERC721Receiver implementer"
978         );
979     }
980 
981     /**
982      * @dev Mints `tokenId` and transfers it to `to`.
983      *
984      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
985      *
986      * Requirements:
987      *
988      * - `tokenId` must not exist.
989      * - `to` cannot be the zero address.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _mint(address to, uint256 tokenId) internal virtual {
994         require(to != address(0), "ERC721: mint to the zero address");
995         require(!_exists(tokenId), "ERC721: token already minted");
996 
997         _beforeTokenTransfer(address(0), to, tokenId);
998 
999         _balances[to] += 1;
1000         _owners[tokenId] = to;
1001 
1002         emit Transfer(address(0), to, tokenId);
1003 
1004         _afterTokenTransfer(address(0), to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev Destroys `tokenId`.
1009      * The approval is cleared when the token is burned.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _burn(uint256 tokenId) internal virtual {
1018         address owner = ERC721.ownerOf(tokenId);
1019 
1020         _beforeTokenTransfer(owner, address(0), tokenId);
1021 
1022         // Clear approvals
1023         _approve(address(0), tokenId);
1024 
1025         _balances[owner] -= 1;
1026         delete _owners[tokenId];
1027 
1028         emit Transfer(owner, address(0), tokenId);
1029 
1030         _afterTokenTransfer(owner, address(0), tokenId);
1031     }
1032 
1033     /**
1034      * @dev Transfers `tokenId` from `from` to `to`.
1035      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1036      *
1037      * Requirements:
1038      *
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must be owned by `from`.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _transfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual {
1049         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1050         require(to != address(0), "ERC721: transfer to the zero address");
1051 
1052         _beforeTokenTransfer(from, to, tokenId);
1053 
1054         // Clear approvals from the previous owner
1055         _approve(address(0), tokenId);
1056 
1057         _balances[from] -= 1;
1058         _balances[to] += 1;
1059         _owners[tokenId] = to;
1060 
1061         emit Transfer(from, to, tokenId);
1062 
1063         _afterTokenTransfer(from, to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Approve `to` to operate on `tokenId`
1068      *
1069      * Emits an {Approval} event.
1070      */
1071     function _approve(address to, uint256 tokenId) internal virtual {
1072         _tokenApprovals[tokenId] = to;
1073         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1074     }
1075 
1076     /**
1077      * @dev Approve `operator` to operate on all of `owner` tokens
1078      *
1079      * Emits an {ApprovalForAll} event.
1080      */
1081     function _setApprovalForAll(
1082         address owner,
1083         address operator,
1084         bool approved
1085     ) internal virtual {
1086         require(owner != operator, "ERC721: approve to caller");
1087         _operatorApprovals[owner][operator] = approved;
1088         emit ApprovalForAll(owner, operator, approved);
1089     }
1090 
1091     /**
1092      * @dev Reverts if the `tokenId` has not been minted yet.
1093      */
1094     function _requireMinted(uint256 tokenId) internal view virtual {
1095         require(_exists(tokenId), "ERC721: invalid token ID");
1096     }
1097 
1098     /**
1099      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1100      * The call is not executed if the target address is not a contract.
1101      *
1102      * @param from address representing the previous owner of the given token ID
1103      * @param to target address that will receive the tokens
1104      * @param tokenId uint256 ID of the token to be transferred
1105      * @param data bytes optional data to send along with the call
1106      * @return bool whether the call correctly returned the expected magic value
1107      */
1108     function _checkOnERC721Received(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory data
1113     ) private returns (bool) {
1114         if (to.isContract()) {
1115             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1116                 return retval == IERC721Receiver.onERC721Received.selector;
1117             } catch (bytes memory reason) {
1118                 if (reason.length == 0) {
1119                     revert("ERC721: transfer to non ERC721Receiver implementer");
1120                 } else {
1121                     /// @solidity memory-safe-assembly
1122                     assembly {
1123                         revert(add(32, reason), mload(reason))
1124                     }
1125                 }
1126             }
1127         } else {
1128             return true;
1129         }
1130     }
1131 
1132     /**
1133      * @dev Hook that is called before any token transfer. This includes minting
1134      * and burning.
1135      *
1136      * Calling conditions:
1137      *
1138      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1139      * transferred to `to`.
1140      * - When `from` is zero, `tokenId` will be minted for `to`.
1141      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1142      * - `from` and `to` are never both zero.
1143      *
1144      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1145      */
1146     function _beforeTokenTransfer(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) internal virtual {}
1151 
1152     /**
1153      * @dev Hook that is called after any transfer of tokens. This includes
1154      * minting and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - when `from` and `to` are both non-zero.
1159      * - `from` and `to` are never both zero.
1160      *
1161      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1162      */
1163     function _afterTokenTransfer(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) internal virtual {}
1168 }
1169 
1170 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1171 
1172 
1173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 
1179 /**
1180  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1181  * enumerability of all the token ids in the contract as well as all token ids owned by each
1182  * account.
1183  */
1184 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1185     // Mapping from owner to list of owned token IDs
1186     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1187 
1188     // Mapping from token ID to index of the owner tokens list
1189     mapping(uint256 => uint256) private _ownedTokensIndex;
1190 
1191     // Array with all token ids, used for enumeration
1192     uint256[] private _allTokens;
1193 
1194     // Mapping from token id to position in the allTokens array
1195     mapping(uint256 => uint256) private _allTokensIndex;
1196 
1197     /**
1198      * @dev See {IERC165-supportsInterface}.
1199      */
1200     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1201         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1202     }
1203 
1204     /**
1205      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1206      */
1207     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1208         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1209         return _ownedTokens[owner][index];
1210     }
1211 
1212     /**
1213      * @dev See {IERC721Enumerable-totalSupply}.
1214      */
1215     function totalSupply() public view virtual override returns (uint256) {
1216         return _allTokens.length;
1217     }
1218 
1219     /**
1220      * @dev See {IERC721Enumerable-tokenByIndex}.
1221      */
1222     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1223         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1224         return _allTokens[index];
1225     }
1226 
1227     /**
1228      * @dev Hook that is called before any token transfer. This includes minting
1229      * and burning.
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1237      * - `from` cannot be the zero address.
1238      * - `to` cannot be the zero address.
1239      *
1240      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1241      */
1242     function _beforeTokenTransfer(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) internal virtual override {
1247         super._beforeTokenTransfer(from, to, tokenId);
1248 
1249         if (from == address(0)) {
1250             _addTokenToAllTokensEnumeration(tokenId);
1251         } else if (from != to) {
1252             _removeTokenFromOwnerEnumeration(from, tokenId);
1253         }
1254         if (to == address(0)) {
1255             _removeTokenFromAllTokensEnumeration(tokenId);
1256         } else if (to != from) {
1257             _addTokenToOwnerEnumeration(to, tokenId);
1258         }
1259     }
1260 
1261     /**
1262      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1263      * @param to address representing the new owner of the given token ID
1264      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1265      */
1266     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1267         uint256 length = ERC721.balanceOf(to);
1268         _ownedTokens[to][length] = tokenId;
1269         _ownedTokensIndex[tokenId] = length;
1270     }
1271 
1272     /**
1273      * @dev Private function to add a token to this extension's token tracking data structures.
1274      * @param tokenId uint256 ID of the token to be added to the tokens list
1275      */
1276     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1277         _allTokensIndex[tokenId] = _allTokens.length;
1278         _allTokens.push(tokenId);
1279     }
1280 
1281     /**
1282      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1283      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1284      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1285      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1286      * @param from address representing the previous owner of the given token ID
1287      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1288      */
1289     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1290         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1291         // then delete the last slot (swap and pop).
1292 
1293         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1294         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1295 
1296         // When the token to delete is the last token, the swap operation is unnecessary
1297         if (tokenIndex != lastTokenIndex) {
1298             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1299 
1300             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1301             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1302         }
1303 
1304         // This also deletes the contents at the last position of the array
1305         delete _ownedTokensIndex[tokenId];
1306         delete _ownedTokens[from][lastTokenIndex];
1307     }
1308 
1309     /**
1310      * @dev Private function to remove a token from this extension's token tracking data structures.
1311      * This has O(1) time complexity, but alters the order of the _allTokens array.
1312      * @param tokenId uint256 ID of the token to be removed from the tokens list
1313      */
1314     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1315         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1316         // then delete the last slot (swap and pop).
1317 
1318         uint256 lastTokenIndex = _allTokens.length - 1;
1319         uint256 tokenIndex = _allTokensIndex[tokenId];
1320 
1321         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1322         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1323         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1324         uint256 lastTokenId = _allTokens[lastTokenIndex];
1325 
1326         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1327         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1328 
1329         // This also deletes the contents at the last position of the array
1330         delete _allTokensIndex[tokenId];
1331         _allTokens.pop();
1332     }
1333 }
1334 
1335 // File: contracts/Tikkatest.sol
1336 
1337 pragma solidity >=0.7.0 <0.9.0;
1338 
1339 
1340 
1341 contract Tikkatest is ERC721Enumerable, Ownable {
1342   using Strings for uint256;
1343 
1344   string public baseURI;
1345   string public baseExtension = ".json";
1346   string public notRevealedUri;
1347   uint256 public cost = 0 ether;
1348   uint256 public maxSupply = 28888;
1349   uint256 public maxMintAmount = 550;
1350   uint256 public nftPerAddressLimit = 5;
1351   bool public paused = false;
1352   bool public revealed = true;
1353   bool public onlyWhitelisted = true;
1354   address[] public whitelistedAddresses;
1355   mapping(address => uint256) public addressMintedBalance;
1356 
1357   constructor(
1358     string memory _name,
1359     string memory _symbol,
1360     string memory _initBaseURI,
1361     string memory _initNotRevealedUri
1362   ) ERC721(_name, _symbol) {
1363     setBaseURI(_initBaseURI);
1364     setNotRevealedURI(_initNotRevealedUri);
1365   }
1366 
1367   // internal
1368   function _baseURI() internal view virtual override returns (string memory) {
1369     return baseURI;
1370   }
1371 
1372   // public
1373   function mint(uint256 _mintAmount) public payable {
1374     require(!paused, "the contract is paused");
1375     uint256 supply = totalSupply();
1376     require(_mintAmount > 0, "need to mint at least 1 NFT");
1377     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1378     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1379 
1380     if (msg.sender != owner()) {
1381         if(onlyWhitelisted == true) {
1382             require(isWhitelisted(msg.sender), "user is not whitelisted");
1383             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1384             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1385         }
1386         require(msg.value >= cost * _mintAmount, "insufficient funds");
1387     }
1388 
1389     for (uint256 i = 1; i <= _mintAmount; i++) {
1390       addressMintedBalance[msg.sender]++;
1391       _safeMint(msg.sender, supply + i);
1392     }
1393   }
1394   
1395   function isWhitelisted(address _user) public view returns (bool) {
1396     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1397       if (whitelistedAddresses[i] == _user) {
1398           return true;
1399       }
1400     }
1401     return false;
1402   }
1403 
1404   function walletOfOwner(address _owner)
1405     public
1406     view
1407     returns (uint256[] memory)
1408   {
1409     uint256 ownerTokenCount = balanceOf(_owner);
1410     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1411     for (uint256 i; i < ownerTokenCount; i++) {
1412       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1413     }
1414     return tokenIds;
1415   }
1416 
1417   function tokenURI(uint256 tokenId)
1418     public
1419     view
1420     virtual
1421     override
1422     returns (string memory)
1423   {
1424     require(
1425       _exists(tokenId),
1426       "ERC721Metadata: URI query for nonexistent token"
1427     );
1428     
1429     if(revealed == false) {
1430         return notRevealedUri;
1431     }
1432 
1433     string memory currentBaseURI = _baseURI();
1434     return bytes(currentBaseURI).length > 0
1435         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1436         : "";
1437   }
1438 
1439   //only owner
1440   function reveal() public onlyOwner {
1441       revealed = true;
1442   }
1443   
1444   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1445     nftPerAddressLimit = _limit;
1446   }
1447   
1448   function setCost(uint256 _newCost) public onlyOwner {
1449     cost = _newCost;
1450   }
1451 
1452   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1453     maxMintAmount = _newmaxMintAmount;
1454   }
1455 
1456   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1457     baseURI = _newBaseURI;
1458   }
1459 
1460   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1461     baseExtension = _newBaseExtension;
1462   }
1463   
1464   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1465     notRevealedUri = _notRevealedURI;
1466   }
1467 
1468   function pause(bool _state) public onlyOwner {
1469     paused = _state;
1470   }
1471   
1472   function setOnlyWhitelisted(bool _state) public onlyOwner {
1473     onlyWhitelisted = _state;
1474   }
1475   
1476   function whitelistUsers(address[] calldata _users) public onlyOwner {
1477     delete whitelistedAddresses;
1478     whitelistedAddresses = _users;
1479   }
1480  
1481   function withdraw() public payable onlyOwner {
1482     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1483     require(os);
1484   }
1485 }