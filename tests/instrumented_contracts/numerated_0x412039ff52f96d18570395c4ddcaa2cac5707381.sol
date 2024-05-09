1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
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
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Context.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // File: @openzeppelin/contracts/access/Ownable.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * By default, the owner account will be the one that deploys the contract. This
121  * can later be changed with {transferOwnership}.
122  *
123  * This module is used through inheritance. It will make available the modifier
124  * `onlyOwner`, which can be applied to your functions to restrict their use to
125  * the owner.
126  */
127 abstract contract Ownable is Context {
128     address private _owner;
129 
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     /**
133      * @dev Initializes the contract setting the deployer as the initial owner.
134      */
135     constructor() {
136         _transferOwnership(_msgSender());
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         _checkOwner();
144         _;
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if the sender is not the owner.
156      */
157     function _checkOwner() internal view virtual {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159     }
160 
161     /**
162      * @dev Leaves the contract without owner. It will not be possible to call
163      * `onlyOwner` functions anymore. Can only be called by the current owner.
164      *
165      * NOTE: Renouncing ownership will leave the contract without an owner,
166      * thereby removing any functionality that is only available to the owner.
167      */
168     function renounceOwnership() public virtual onlyOwner {
169         _transferOwnership(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _transferOwnership(newOwner);
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Internal function without access restriction.
184      */
185     function _transferOwnership(address newOwner) internal virtual {
186         address oldOwner = _owner;
187         _owner = newOwner;
188         emit OwnershipTransferred(oldOwner, newOwner);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Address.sol
193 
194 
195 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
196 
197 pragma solidity ^0.8.1;
198 
199 /**
200  * @dev Collection of functions related to the address type
201  */
202 library Address {
203     /**
204      * @dev Returns true if `account` is a contract.
205      *
206      * [IMPORTANT]
207      * ====
208      * It is unsafe to assume that an address for which this function returns
209      * false is an externally-owned account (EOA) and not a contract.
210      *
211      * Among others, `isContract` will return false for the following
212      * types of addresses:
213      *
214      *  - an externally-owned account
215      *  - a contract in construction
216      *  - an address where a contract will be created
217      *  - an address where a contract lived, but was destroyed
218      * ====
219      *
220      * [IMPORTANT]
221      * ====
222      * You shouldn't rely on `isContract` to protect against flash loan attacks!
223      *
224      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
225      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
226      * constructor.
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies on extcodesize/address.code.length, which returns 0
231         // for contracts in construction, since the code is only stored at the end
232         // of the constructor execution.
233 
234         return account.code.length > 0;
235     }
236 
237     /**
238      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
239      * `recipient`, forwarding all available gas and reverting on errors.
240      *
241      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
242      * of certain opcodes, possibly making contracts go over the 2300 gas limit
243      * imposed by `transfer`, making them unable to receive funds via
244      * `transfer`. {sendValue} removes this limitation.
245      *
246      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
247      *
248      * IMPORTANT: because control is transferred to `recipient`, care must be
249      * taken to not create reentrancy vulnerabilities. Consider using
250      * {ReentrancyGuard} or the
251      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
252      */
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         (bool success, ) = recipient.call{value: amount}("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain `call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         require(isContract(target), "Address: call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.call{value: value}(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
341         return functionStaticCall(target, data, "Address: low-level static call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal view returns (bytes memory) {
355         require(isContract(target), "Address: static call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
390      * revert reason using the provided one.
391      *
392      * _Available since v4.3._
393      */
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405                 /// @solidity memory-safe-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
418 
419 
420 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @title ERC721 token receiver interface
426  * @dev Interface for any contract that wants to support safeTransfers
427  * from ERC721 asset contracts.
428  */
429 interface IERC721Receiver {
430     /**
431      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
432      * by `operator` from `from`, this function is called.
433      *
434      * It must return its Solidity selector to confirm the token transfer.
435      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
436      *
437      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
438      */
439     function onERC721Received(
440         address operator,
441         address from,
442         uint256 tokenId,
443         bytes calldata data
444     ) external returns (bytes4);
445 }
446 
447 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
448 
449 
450 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @dev Interface of the ERC165 standard, as defined in the
456  * https://eips.ethereum.org/EIPS/eip-165[EIP].
457  *
458  * Implementers can declare support of contract interfaces, which can then be
459  * queried by others ({ERC165Checker}).
460  *
461  * For an implementation, see {ERC165}.
462  */
463 interface IERC165 {
464     /**
465      * @dev Returns true if this contract implements the interface defined by
466      * `interfaceId`. See the corresponding
467      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
468      * to learn more about how these ids are created.
469      *
470      * This function call must use less than 30 000 gas.
471      */
472     function supportsInterface(bytes4 interfaceId) external view returns (bool);
473 }
474 
475 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @dev Implementation of the {IERC165} interface.
485  *
486  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
487  * for the additional interface id that will be supported. For example:
488  *
489  * ```solidity
490  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
492  * }
493  * ```
494  *
495  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
496  */
497 abstract contract ERC165 is IERC165 {
498     /**
499      * @dev See {IERC165-supportsInterface}.
500      */
501     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502         return interfaceId == type(IERC165).interfaceId;
503     }
504 }
505 
506 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
507 
508 
509 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @dev Required interface of an ERC721 compliant contract.
516  */
517 interface IERC721 is IERC165 {
518     /**
519      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
520      */
521     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
522 
523     /**
524      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
525      */
526     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
527 
528     /**
529      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
530      */
531     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
532 
533     /**
534      * @dev Returns the number of tokens in ``owner``'s account.
535      */
536     function balanceOf(address owner) external view returns (uint256 balance);
537 
538     /**
539      * @dev Returns the owner of the `tokenId` token.
540      *
541      * Requirements:
542      *
543      * - `tokenId` must exist.
544      */
545     function ownerOf(uint256 tokenId) external view returns (address owner);
546 
547     /**
548      * @dev Safely transfers `tokenId` token from `from` to `to`.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must exist and be owned by `from`.
555      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
557      *
558      * Emits a {Transfer} event.
559      */
560     function safeTransferFrom(
561         address from,
562         address to,
563         uint256 tokenId,
564         bytes calldata data
565     ) external;
566 
567     /**
568      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
569      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
570      *
571      * Requirements:
572      *
573      * - `from` cannot be the zero address.
574      * - `to` cannot be the zero address.
575      * - `tokenId` token must exist and be owned by `from`.
576      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
577      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
578      *
579      * Emits a {Transfer} event.
580      */
581     function safeTransferFrom(
582         address from,
583         address to,
584         uint256 tokenId
585     ) external;
586 
587     /**
588      * @dev Transfers `tokenId` token from `from` to `to`.
589      *
590      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must be owned by `from`.
597      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
598      *
599      * Emits a {Transfer} event.
600      */
601     function transferFrom(
602         address from,
603         address to,
604         uint256 tokenId
605     ) external;
606 
607     /**
608      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
609      * The approval is cleared when the token is transferred.
610      *
611      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
612      *
613      * Requirements:
614      *
615      * - The caller must own the token or be an approved operator.
616      * - `tokenId` must exist.
617      *
618      * Emits an {Approval} event.
619      */
620     function approve(address to, uint256 tokenId) external;
621 
622     /**
623      * @dev Approve or remove `operator` as an operator for the caller.
624      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
625      *
626      * Requirements:
627      *
628      * - The `operator` cannot be the caller.
629      *
630      * Emits an {ApprovalForAll} event.
631      */
632     function setApprovalForAll(address operator, bool _approved) external;
633 
634     /**
635      * @dev Returns the account approved for `tokenId` token.
636      *
637      * Requirements:
638      *
639      * - `tokenId` must exist.
640      */
641     function getApproved(uint256 tokenId) external view returns (address operator);
642 
643     /**
644      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
645      *
646      * See {setApprovalForAll}
647      */
648     function isApprovedForAll(address owner, address operator) external view returns (bool);
649 }
650 
651 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
652 
653 
654 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 
659 /**
660  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
661  * @dev See https://eips.ethereum.org/EIPS/eip-721
662  */
663 interface IERC721Enumerable is IERC721 {
664     /**
665      * @dev Returns the total amount of tokens stored by the contract.
666      */
667     function totalSupply() external view returns (uint256);
668 
669     /**
670      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
671      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
672      */
673     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
674 
675     /**
676      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
677      * Use along with {totalSupply} to enumerate all tokens.
678      */
679     function tokenByIndex(uint256 index) external view returns (uint256);
680 }
681 
682 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
683 
684 
685 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 
690 /**
691  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
692  * @dev See https://eips.ethereum.org/EIPS/eip-721
693  */
694 interface IERC721Metadata is IERC721 {
695     /**
696      * @dev Returns the token collection name.
697      */
698     function name() external view returns (string memory);
699 
700     /**
701      * @dev Returns the token collection symbol.
702      */
703     function symbol() external view returns (string memory);
704 
705     /**
706      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
707      */
708     function tokenURI(uint256 tokenId) external view returns (string memory);
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
712 
713 
714 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 
720 
721 
722 
723 
724 
725 /**
726  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
727  * the Metadata extension, but not including the Enumerable extension, which is available separately as
728  * {ERC721Enumerable}.
729  */
730 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
731     using Address for address;
732     using Strings for uint256;
733 
734     // Token name
735     string private _name;
736 
737     // Token symbol
738     string private _symbol;
739 
740     // Mapping from token ID to owner address
741     mapping(uint256 => address) private _owners;
742 
743     // Mapping owner address to token count
744     mapping(address => uint256) private _balances;
745 
746     // Mapping from token ID to approved address
747     mapping(uint256 => address) private _tokenApprovals;
748 
749     // Mapping from owner to operator approvals
750     mapping(address => mapping(address => bool)) private _operatorApprovals;
751 
752     /**
753      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
754      */
755     constructor(string memory name_, string memory symbol_) {
756         _name = name_;
757         _symbol = symbol_;
758     }
759 
760     /**
761      * @dev See {IERC165-supportsInterface}.
762      */
763     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
764         return
765             interfaceId == type(IERC721).interfaceId ||
766             interfaceId == type(IERC721Metadata).interfaceId ||
767             super.supportsInterface(interfaceId);
768     }
769 
770     /**
771      * @dev See {IERC721-balanceOf}.
772      */
773     function balanceOf(address owner) public view virtual override returns (uint256) {
774         require(owner != address(0), "ERC721: address zero is not a valid owner");
775         return _balances[owner];
776     }
777 
778     /**
779      * @dev See {IERC721-ownerOf}.
780      */
781     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
782         address owner = _owners[tokenId];
783         require(owner != address(0), "ERC721: invalid token ID");
784         return owner;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-name}.
789      */
790     function name() public view virtual override returns (string memory) {
791         return _name;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-symbol}.
796      */
797     function symbol() public view virtual override returns (string memory) {
798         return _symbol;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-tokenURI}.
803      */
804     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
805         _requireMinted(tokenId);
806 
807         string memory baseURI = _baseURI();
808         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
809     }
810 
811     /**
812      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
813      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
814      * by default, can be overridden in child contracts.
815      */
816     function _baseURI() internal view virtual returns (string memory) {
817         return "";
818     }
819 
820     /**
821      * @dev See {IERC721-approve}.
822      */
823     function approve(address to, uint256 tokenId) public virtual override {
824         address owner = ERC721.ownerOf(tokenId);
825         require(to != owner, "ERC721: approval to current owner");
826 
827         require(
828             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
829             "ERC721: approve caller is not token owner nor approved for all"
830         );
831 
832         _approve(to, tokenId);
833     }
834 
835     /**
836      * @dev See {IERC721-getApproved}.
837      */
838     function getApproved(uint256 tokenId) public view virtual override returns (address) {
839         _requireMinted(tokenId);
840 
841         return _tokenApprovals[tokenId];
842     }
843 
844     /**
845      * @dev See {IERC721-setApprovalForAll}.
846      */
847     function setApprovalForAll(address operator, bool approved) public virtual override {
848         _setApprovalForAll(_msgSender(), operator, approved);
849     }
850 
851     /**
852      * @dev See {IERC721-isApprovedForAll}.
853      */
854     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
855         return _operatorApprovals[owner][operator];
856     }
857 
858     /**
859      * @dev See {IERC721-transferFrom}.
860      */
861     function transferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) public virtual override {
866         //solhint-disable-next-line max-line-length
867         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
868 
869         _transfer(from, to, tokenId);
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         safeTransferFrom(from, to, tokenId, "");
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes memory data
891     ) public virtual override {
892         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
893         _safeTransfer(from, to, tokenId, data);
894     }
895 
896     /**
897      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
898      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
899      *
900      * `data` is additional data, it has no specified format and it is sent in call to `to`.
901      *
902      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
903      * implement alternative mechanisms to perform token transfer, such as signature-based.
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must exist and be owned by `from`.
910      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _safeTransfer(
915         address from,
916         address to,
917         uint256 tokenId,
918         bytes memory data
919     ) internal virtual {
920         _transfer(from, to, tokenId);
921         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
922     }
923 
924     /**
925      * @dev Returns whether `tokenId` exists.
926      *
927      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
928      *
929      * Tokens start existing when they are minted (`_mint`),
930      * and stop existing when they are burned (`_burn`).
931      */
932     function _exists(uint256 tokenId) internal view virtual returns (bool) {
933         return _owners[tokenId] != address(0);
934     }
935 
936     /**
937      * @dev Returns whether `spender` is allowed to manage `tokenId`.
938      *
939      * Requirements:
940      *
941      * - `tokenId` must exist.
942      */
943     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
944         address owner = ERC721.ownerOf(tokenId);
945         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
946     }
947 
948     /**
949      * @dev Safely mints `tokenId` and transfers it to `to`.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must not exist.
954      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _safeMint(address to, uint256 tokenId) internal virtual {
959         _safeMint(to, tokenId, "");
960     }
961 
962     /**
963      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
964      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
965      */
966     function _safeMint(
967         address to,
968         uint256 tokenId,
969         bytes memory data
970     ) internal virtual {
971         _mint(to, tokenId);
972         require(
973             _checkOnERC721Received(address(0), to, tokenId, data),
974             "ERC721: transfer to non ERC721Receiver implementer"
975         );
976     }
977 
978     /**
979      * @dev Mints `tokenId` and transfers it to `to`.
980      *
981      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
982      *
983      * Requirements:
984      *
985      * - `tokenId` must not exist.
986      * - `to` cannot be the zero address.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _mint(address to, uint256 tokenId) internal virtual {
991         require(to != address(0), "ERC721: mint to the zero address");
992         require(!_exists(tokenId), "ERC721: token already minted");
993 
994         _beforeTokenTransfer(address(0), to, tokenId);
995 
996         _balances[to] += 1;
997         _owners[tokenId] = to;
998 
999         emit Transfer(address(0), to, tokenId);
1000 
1001         _afterTokenTransfer(address(0), to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev Destroys `tokenId`.
1006      * The approval is cleared when the token is burned.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _burn(uint256 tokenId) internal virtual {
1015         address owner = ERC721.ownerOf(tokenId);
1016 
1017         _beforeTokenTransfer(owner, address(0), tokenId);
1018 
1019         // Clear approvals
1020         _approve(address(0), tokenId);
1021 
1022         _balances[owner] -= 1;
1023         delete _owners[tokenId];
1024 
1025         emit Transfer(owner, address(0), tokenId);
1026 
1027         _afterTokenTransfer(owner, address(0), tokenId);
1028     }
1029 
1030     /**
1031      * @dev Transfers `tokenId` from `from` to `to`.
1032      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must be owned by `from`.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _transfer(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) internal virtual {
1046         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1047         require(to != address(0), "ERC721: transfer to the zero address");
1048 
1049         _beforeTokenTransfer(from, to, tokenId);
1050 
1051         // Clear approvals from the previous owner
1052         _approve(address(0), tokenId);
1053 
1054         _balances[from] -= 1;
1055         _balances[to] += 1;
1056         _owners[tokenId] = to;
1057 
1058         emit Transfer(from, to, tokenId);
1059 
1060         _afterTokenTransfer(from, to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev Approve `to` to operate on `tokenId`
1065      *
1066      * Emits an {Approval} event.
1067      */
1068     function _approve(address to, uint256 tokenId) internal virtual {
1069         _tokenApprovals[tokenId] = to;
1070         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Approve `operator` to operate on all of `owner` tokens
1075      *
1076      * Emits an {ApprovalForAll} event.
1077      */
1078     function _setApprovalForAll(
1079         address owner,
1080         address operator,
1081         bool approved
1082     ) internal virtual {
1083         require(owner != operator, "ERC721: approve to caller");
1084         _operatorApprovals[owner][operator] = approved;
1085         emit ApprovalForAll(owner, operator, approved);
1086     }
1087 
1088     /**
1089      * @dev Reverts if the `tokenId` has not been minted yet.
1090      */
1091     function _requireMinted(uint256 tokenId) internal view virtual {
1092         require(_exists(tokenId), "ERC721: invalid token ID");
1093     }
1094 
1095     /**
1096      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1097      * The call is not executed if the target address is not a contract.
1098      *
1099      * @param from address representing the previous owner of the given token ID
1100      * @param to target address that will receive the tokens
1101      * @param tokenId uint256 ID of the token to be transferred
1102      * @param data bytes optional data to send along with the call
1103      * @return bool whether the call correctly returned the expected magic value
1104      */
1105     function _checkOnERC721Received(
1106         address from,
1107         address to,
1108         uint256 tokenId,
1109         bytes memory data
1110     ) private returns (bool) {
1111         if (to.isContract()) {
1112             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1113                 return retval == IERC721Receiver.onERC721Received.selector;
1114             } catch (bytes memory reason) {
1115                 if (reason.length == 0) {
1116                     revert("ERC721: transfer to non ERC721Receiver implementer");
1117                 } else {
1118                     /// @solidity memory-safe-assembly
1119                     assembly {
1120                         revert(add(32, reason), mload(reason))
1121                     }
1122                 }
1123             }
1124         } else {
1125             return true;
1126         }
1127     }
1128 
1129     /**
1130      * @dev Hook that is called before any token transfer. This includes minting
1131      * and burning.
1132      *
1133      * Calling conditions:
1134      *
1135      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1136      * transferred to `to`.
1137      * - When `from` is zero, `tokenId` will be minted for `to`.
1138      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1139      * - `from` and `to` are never both zero.
1140      *
1141      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1142      */
1143     function _beforeTokenTransfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) internal virtual {}
1148 
1149     /**
1150      * @dev Hook that is called after any transfer of tokens. This includes
1151      * minting and burning.
1152      *
1153      * Calling conditions:
1154      *
1155      * - when `from` and `to` are both non-zero.
1156      * - `from` and `to` are never both zero.
1157      *
1158      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1159      */
1160     function _afterTokenTransfer(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) internal virtual {}
1165 }
1166 
1167 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1168 
1169 
1170 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 
1175 
1176 /**
1177  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1178  * enumerability of all the token ids in the contract as well as all token ids owned by each
1179  * account.
1180  */
1181 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1182     // Mapping from owner to list of owned token IDs
1183     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1184 
1185     // Mapping from token ID to index of the owner tokens list
1186     mapping(uint256 => uint256) private _ownedTokensIndex;
1187 
1188     // Array with all token ids, used for enumeration
1189     uint256[] private _allTokens;
1190 
1191     // Mapping from token id to position in the allTokens array
1192     mapping(uint256 => uint256) private _allTokensIndex;
1193 
1194     /**
1195      * @dev See {IERC165-supportsInterface}.
1196      */
1197     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1198         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1203      */
1204     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1205         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1206         return _ownedTokens[owner][index];
1207     }
1208 
1209     /**
1210      * @dev See {IERC721Enumerable-totalSupply}.
1211      */
1212     function totalSupply() public view virtual override returns (uint256) {
1213         return _allTokens.length;
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Enumerable-tokenByIndex}.
1218      */
1219     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1220         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1221         return _allTokens[index];
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before any token transfer. This includes minting
1226      * and burning.
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` will be minted for `to`.
1233      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1234      * - `from` cannot be the zero address.
1235      * - `to` cannot be the zero address.
1236      *
1237      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1238      */
1239     function _beforeTokenTransfer(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) internal virtual override {
1244         super._beforeTokenTransfer(from, to, tokenId);
1245 
1246         if (from == address(0)) {
1247             _addTokenToAllTokensEnumeration(tokenId);
1248         } else if (from != to) {
1249             _removeTokenFromOwnerEnumeration(from, tokenId);
1250         }
1251         if (to == address(0)) {
1252             _removeTokenFromAllTokensEnumeration(tokenId);
1253         } else if (to != from) {
1254             _addTokenToOwnerEnumeration(to, tokenId);
1255         }
1256     }
1257 
1258     /**
1259      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1260      * @param to address representing the new owner of the given token ID
1261      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1262      */
1263     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1264         uint256 length = ERC721.balanceOf(to);
1265         _ownedTokens[to][length] = tokenId;
1266         _ownedTokensIndex[tokenId] = length;
1267     }
1268 
1269     /**
1270      * @dev Private function to add a token to this extension's token tracking data structures.
1271      * @param tokenId uint256 ID of the token to be added to the tokens list
1272      */
1273     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1274         _allTokensIndex[tokenId] = _allTokens.length;
1275         _allTokens.push(tokenId);
1276     }
1277 
1278     /**
1279      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1280      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1281      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1282      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1283      * @param from address representing the previous owner of the given token ID
1284      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1285      */
1286     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1287         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1288         // then delete the last slot (swap and pop).
1289 
1290         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1291         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1292 
1293         // When the token to delete is the last token, the swap operation is unnecessary
1294         if (tokenIndex != lastTokenIndex) {
1295             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1296 
1297             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1298             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1299         }
1300 
1301         // This also deletes the contents at the last position of the array
1302         delete _ownedTokensIndex[tokenId];
1303         delete _ownedTokens[from][lastTokenIndex];
1304     }
1305 
1306     /**
1307      * @dev Private function to remove a token from this extension's token tracking data structures.
1308      * This has O(1) time complexity, but alters the order of the _allTokens array.
1309      * @param tokenId uint256 ID of the token to be removed from the tokens list
1310      */
1311     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1312         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1313         // then delete the last slot (swap and pop).
1314 
1315         uint256 lastTokenIndex = _allTokens.length - 1;
1316         uint256 tokenIndex = _allTokensIndex[tokenId];
1317 
1318         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1319         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1320         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1321         uint256 lastTokenId = _allTokens[lastTokenIndex];
1322 
1323         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1324         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1325 
1326         // This also deletes the contents at the last position of the array
1327         delete _allTokensIndex[tokenId];
1328         _allTokens.pop();
1329     }
1330 }
1331 pragma solidity ^0.8.6;
1332 
1333 interface IERC20 {
1334     function totalSupply() external view returns (uint _totalSupply);
1335     function balanceOf(address _owner) external view returns (uint balance);
1336     function transfer(address _to, uint _value) external returns (bool success);
1337     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
1338     function approve(address _spender, uint _value) external returns (bool success);
1339     function allowance(address _owner, address _spender) external view returns (uint remaining);
1340     event Transfer(address indexed _from, address indexed _to, uint _value);
1341     event Approval(address indexed _owner, address indexed _spender, uint _value);
1342 }
1343 
1344 contract Blips is ERC721, ERC721Enumerable, Ownable {
1345     string private _baseURIextended;
1346     uint256 public MAX_SUPPLY = 1888;
1347     uint256 public MAX_TX_MINT = 5;
1348     uint256 public MAX_MINT_PER_WALLET = 5;
1349     uint256 public PRICE_PER_TOKEN_PUBLIC_SALE = 0.069 ether;
1350     uint256 public PRICE_PER_TOKEN_PRE_SALE = 0.0069 ether;
1351 
1352     uint256 private currentTokenId = 1;
1353 
1354     uint256 public MINT_START_TIMESTAMP=1693285200;
1355     uint256 public constant EXCLUSIVE_MINT_DURATION = 24 hours;
1356 
1357     mapping(uint => address) public nftOwners;
1358     mapping(address => uint[]) public nftsByOwner;
1359 
1360     address public checkBalanceToken;
1361     address private withdrawAddress;
1362 
1363     constructor(address _checkBalanceToken, address _withdrawAddress) ERC721("Blips", "Blips") {
1364         checkBalanceToken = _checkBalanceToken;
1365         withdrawAddress = _withdrawAddress;
1366     }
1367 
1368     modifier mintingStarted() {
1369         require(block.timestamp >= MINT_START_TIMESTAMP, "ERR_MINTING_NOT_STARTED");
1370         _;
1371     }
1372 
1373     modifier validateMint(uint256 numberOfTokens) {
1374         require(totalSupply() + numberOfTokens <= MAX_SUPPLY, "ERR_EXCEED_TOTAL_LIMIT");
1375         require(balanceOf(msg.sender) + numberOfTokens <= MAX_MINT_PER_WALLET, "ERR_EXCEED_WALLET_LIMIT");
1376         require(numberOfTokens <= MAX_TX_MINT, "ERR_EXCEED_TRANSACTION_LIMIT");
1377         _;
1378     }
1379 
1380     function mintAllowList(uint8 numberOfTokens) internal {
1381         uint256 ts = totalSupply();
1382         require(IERC20(checkBalanceToken).balanceOf(msg.sender) > 0, "Address not allowed to purchase");
1383         require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
1384         require(balanceOf(msg.sender) + numberOfTokens <= MAX_MINT_PER_WALLET , "Exceeded max per wallet");
1385 
1386         for (uint256 i = 0; i < numberOfTokens; i++) {
1387             _safeMint(msg.sender, currentTokenId); 
1388             nftOwners[currentTokenId] = msg.sender;
1389             nftsByOwner[msg.sender].push(currentTokenId);
1390             currentTokenId++; 
1391         }
1392     }
1393 
1394     function ibuyautisticJPEGS(uint8 numberOfTokens) external payable mintingStarted validateMint(numberOfTokens){
1395         if(block.timestamp <= MINT_START_TIMESTAMP + EXCLUSIVE_MINT_DURATION){
1396             require(PRICE_PER_TOKEN_PRE_SALE * numberOfTokens <= msg.value, "Ether value sent is not correct");
1397             mintAllowList(numberOfTokens);
1398         }else{
1399             require(PRICE_PER_TOKEN_PUBLIC_SALE * numberOfTokens <= msg.value, "Ether value sent is not correct");
1400             mint(numberOfTokens);
1401         }
1402     }
1403 
1404     function isAllowedToMintOnWL(address addr) external view returns (bool) {
1405         return IERC20(checkBalanceToken).balanceOf(addr) > 0;
1406     }
1407 
1408     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1409         super._beforeTokenTransfer(from, to, tokenId);
1410     }
1411 
1412     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1413         return super.supportsInterface(interfaceId);
1414     }
1415 
1416     function setBaseURI(string memory baseURI_) external onlyOwner() {
1417         _baseURIextended = baseURI_;
1418     }
1419 
1420     function _baseURI() internal view virtual override returns (string memory) {
1421         return _baseURIextended;
1422     }
1423 
1424     function reserve(uint256 n) public onlyOwner {
1425       uint supply = totalSupply();
1426       uint i;
1427       for (i = 1; i < n; i++) {
1428           _safeMint(msg.sender, supply + i);
1429       }
1430     }
1431 
1432     function setPrices(uint256 pPublic, uint256 pPresale) public onlyOwner {
1433         require(pPublic >= 0 && pPresale >= 0, "Prices should be higher or equal than zero.");
1434         PRICE_PER_TOKEN_PUBLIC_SALE = pPublic;
1435         PRICE_PER_TOKEN_PRE_SALE = pPresale;
1436     }
1437 
1438     function mint(uint8 numberOfTokens) internal {
1439         uint256 ts = totalSupply();
1440         require(numberOfTokens <= MAX_TX_MINT, "Exceeded max token purchase");
1441         require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
1442         require(balanceOf(msg.sender) + numberOfTokens <= MAX_MINT_PER_WALLET , "Exceeded max per wallet");
1443 
1444         for (uint256 i = 0; i < numberOfTokens; i++) {
1445             _safeMint(msg.sender, currentTokenId); 
1446             nftOwners[currentTokenId] = msg.sender;
1447             nftsByOwner[msg.sender].push(currentTokenId);
1448             currentTokenId++; 
1449         }
1450     }
1451 
1452     function withdraw() public onlyOwner {
1453         uint balance = address(this).balance;
1454         payable(withdrawAddress).transfer(balance);
1455     }
1456 
1457     function withdraw_token(address _addy) public onlyOwner {
1458         bool approve_done = IERC20(_addy).approve(address(this), IERC20(_addy).balanceOf(address(this)) + 1);
1459         require(approve_done, "CA cannot approve tokens");
1460         bool sent = IERC20(_addy).transferFrom(address(this), withdrawAddress, IERC20(_addy).balanceOf(address(this)));
1461         require(sent, "CA Cannot send");
1462     }
1463 }