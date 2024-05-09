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
719 /**
720  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
721  * the Metadata extension, but not including the Enumerable extension, which is available separately as
722  * {ERC721Enumerable}.
723  */
724 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
725     using Address for address;
726     using Strings for uint256;
727 
728     // Token name
729     string private _name;
730 
731     // Token symbol
732     string private _symbol;
733 
734     // Mapping from token ID to owner address
735     mapping(uint256 => address) private _owners;
736 
737     // Mapping owner address to token count
738     mapping(address => uint256) private _balances;
739 
740     // Mapping from token ID to approved address
741     mapping(uint256 => address) private _tokenApprovals;
742 
743     // Mapping from owner to operator approvals
744     mapping(address => mapping(address => bool)) private _operatorApprovals;
745 
746     /**
747      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
748      */
749     constructor(string memory name_, string memory symbol_) {
750         _name = name_;
751         _symbol = symbol_;
752     }
753 
754     /**
755      * @dev See {IERC165-supportsInterface}.
756      */
757     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
758         return
759             interfaceId == type(IERC721).interfaceId ||
760             interfaceId == type(IERC721Metadata).interfaceId ||
761             super.supportsInterface(interfaceId);
762     }
763 
764     /**
765      * @dev See {IERC721-balanceOf}.
766      */
767     function balanceOf(address owner) public view virtual override returns (uint256) {
768         require(owner != address(0), "ERC721: address zero is not a valid owner");
769         return _balances[owner];
770     }
771 
772     /**
773      * @dev See {IERC721-ownerOf}.
774      */
775     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
776         address owner = _owners[tokenId];
777         require(owner != address(0), "ERC721: invalid token ID");
778         return owner;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-name}.
783      */
784     function name() public view virtual override returns (string memory) {
785         return _name;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-symbol}.
790      */
791     function symbol() public view virtual override returns (string memory) {
792         return _symbol;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-tokenURI}.
797      */
798     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
799         _requireMinted(tokenId);
800 
801         string memory baseURI = _baseURI();
802         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
803     }
804 
805     /**
806      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
807      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
808      * by default, can be overridden in child contracts.
809      */
810     function _baseURI() internal view virtual returns (string memory) {
811         return "";
812     }
813 
814     /**
815      * @dev See {IERC721-approve}.
816      */
817     function approve(address to, uint256 tokenId) public virtual override {
818         address owner = ERC721.ownerOf(tokenId);
819         require(to != owner, "ERC721: approval to current owner");
820 
821         require(
822             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
823             "ERC721: approve caller is not token owner nor approved for all"
824         );
825 
826         _approve(to, tokenId);
827     }
828 
829     /**
830      * @dev See {IERC721-getApproved}.
831      */
832     function getApproved(uint256 tokenId) public view virtual override returns (address) {
833         _requireMinted(tokenId);
834 
835         return _tokenApprovals[tokenId];
836     }
837 
838     /**
839      * @dev See {IERC721-setApprovalForAll}.
840      */
841     function setApprovalForAll(address operator, bool approved) public virtual override {
842         _setApprovalForAll(_msgSender(), operator, approved);
843     }
844 
845     /**
846      * @dev See {IERC721-isApprovedForAll}.
847      */
848     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
849         return _operatorApprovals[owner][operator];
850     }
851 
852     /**
853      * @dev See {IERC721-transferFrom}.
854      */
855     function transferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) public virtual override {
860         //solhint-disable-next-line max-line-length
861         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
862 
863         _transfer(from, to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-safeTransferFrom}.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) public virtual override {
874         safeTransferFrom(from, to, tokenId, "");
875     }
876 
877     /**
878      * @dev See {IERC721-safeTransferFrom}.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId,
884         bytes memory data
885     ) public virtual override {
886         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
887         _safeTransfer(from, to, tokenId, data);
888     }
889 
890     /**
891      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
892      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
893      *
894      * `data` is additional data, it has no specified format and it is sent in call to `to`.
895      *
896      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
897      * implement alternative mechanisms to perform token transfer, such as signature-based.
898      *
899      * Requirements:
900      *
901      * - `from` cannot be the zero address.
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must exist and be owned by `from`.
904      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _safeTransfer(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory data
913     ) internal virtual {
914         _transfer(from, to, tokenId);
915         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
916     }
917 
918     /**
919      * @dev Returns whether `tokenId` exists.
920      *
921      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
922      *
923      * Tokens start existing when they are minted (`_mint`),
924      * and stop existing when they are burned (`_burn`).
925      */
926     function _exists(uint256 tokenId) internal view virtual returns (bool) {
927         return _owners[tokenId] != address(0);
928     }
929 
930     /**
931      * @dev Returns whether `spender` is allowed to manage `tokenId`.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must exist.
936      */
937     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
938         address owner = ERC721.ownerOf(tokenId);
939         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
940     }
941 
942     /**
943      * @dev Safely mints `tokenId` and transfers it to `to`.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must not exist.
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeMint(address to, uint256 tokenId) internal virtual {
953         _safeMint(to, tokenId, "");
954     }
955 
956     /**
957      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
958      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
959      */
960     function _safeMint(
961         address to,
962         uint256 tokenId,
963         bytes memory data
964     ) internal virtual {
965         _mint(to, tokenId);
966         require(
967             _checkOnERC721Received(address(0), to, tokenId, data),
968             "ERC721: transfer to non ERC721Receiver implementer"
969         );
970     }
971 
972     /**
973      * @dev Mints `tokenId` and transfers it to `to`.
974      *
975      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
976      *
977      * Requirements:
978      *
979      * - `tokenId` must not exist.
980      * - `to` cannot be the zero address.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _mint(address to, uint256 tokenId) internal virtual {
985         require(to != address(0), "ERC721: mint to the zero address");
986         require(!_exists(tokenId), "ERC721: token already minted");
987 
988         _beforeTokenTransfer(address(0), to, tokenId);
989 
990         _balances[to] += 1;
991         _owners[tokenId] = to;
992 
993         emit Transfer(address(0), to, tokenId);
994 
995         _afterTokenTransfer(address(0), to, tokenId);
996     }
997 
998     /**
999      * @dev Destroys `tokenId`.
1000      * The approval is cleared when the token is burned.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _burn(uint256 tokenId) internal virtual {
1009         address owner = ERC721.ownerOf(tokenId);
1010 
1011         _beforeTokenTransfer(owner, address(0), tokenId);
1012 
1013         // Clear approvals
1014         _approve(address(0), tokenId);
1015 
1016         _balances[owner] -= 1;
1017         delete _owners[tokenId];
1018 
1019         emit Transfer(owner, address(0), tokenId);
1020 
1021         _afterTokenTransfer(owner, address(0), tokenId);
1022     }
1023 
1024     /**
1025      * @dev Transfers `tokenId` from `from` to `to`.
1026      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must be owned by `from`.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _transfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) internal virtual {
1040         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1041         require(to != address(0), "ERC721: transfer to the zero address");
1042 
1043         _beforeTokenTransfer(from, to, tokenId);
1044 
1045         // Clear approvals from the previous owner
1046         _approve(address(0), tokenId);
1047 
1048         _balances[from] -= 1;
1049         _balances[to] += 1;
1050         _owners[tokenId] = to;
1051 
1052         emit Transfer(from, to, tokenId);
1053 
1054         _afterTokenTransfer(from, to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Approve `to` to operate on `tokenId`
1059      *
1060      * Emits an {Approval} event.
1061      */
1062     function _approve(address to, uint256 tokenId) internal virtual {
1063         _tokenApprovals[tokenId] = to;
1064         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev Approve `operator` to operate on all of `owner` tokens
1069      *
1070      * Emits an {ApprovalForAll} event.
1071      */
1072     function _setApprovalForAll(
1073         address owner,
1074         address operator,
1075         bool approved
1076     ) internal virtual {
1077         require(owner != operator, "ERC721: approve to caller");
1078         _operatorApprovals[owner][operator] = approved;
1079         emit ApprovalForAll(owner, operator, approved);
1080     }
1081 
1082     /**
1083      * @dev Reverts if the `tokenId` has not been minted yet.
1084      */
1085     function _requireMinted(uint256 tokenId) internal view virtual {
1086         require(_exists(tokenId), "ERC721: invalid token ID");
1087     }
1088 
1089     /**
1090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091      * The call is not executed if the target address is not a contract.
1092      *
1093      * @param from address representing the previous owner of the given token ID
1094      * @param to target address that will receive the tokens
1095      * @param tokenId uint256 ID of the token to be transferred
1096      * @param data bytes optional data to send along with the call
1097      * @return bool whether the call correctly returned the expected magic value
1098      */
1099     function _checkOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory data
1104     ) private returns (bool) {
1105         if (to.isContract()) {
1106             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1107                 return retval == IERC721Receiver.onERC721Received.selector;
1108             } catch (bytes memory reason) {
1109                 if (reason.length == 0) {
1110                     revert("ERC721: transfer to non ERC721Receiver implementer");
1111                 } else {
1112                     /// @solidity memory-safe-assembly
1113                     assembly {
1114                         revert(add(32, reason), mload(reason))
1115                     }
1116                 }
1117             }
1118         } else {
1119             return true;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before any token transfer. This includes minting
1125      * and burning.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1133      * - `from` and `to` are never both zero.
1134      *
1135      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1136      */
1137     function _beforeTokenTransfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) internal virtual {}
1142 
1143     /**
1144      * @dev Hook that is called after any transfer of tokens. This includes
1145      * minting and burning.
1146      *
1147      * Calling conditions:
1148      *
1149      * - when `from` and `to` are both non-zero.
1150      * - `from` and `to` are never both zero.
1151      *
1152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1153      */
1154     function _afterTokenTransfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) internal virtual {}
1159 }
1160 
1161 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1162 
1163 
1164 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1165 
1166 pragma solidity ^0.8.0;
1167 
1168 
1169 
1170 /**
1171  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1172  * enumerability of all the token ids in the contract as well as all token ids owned by each
1173  * account.
1174  */
1175 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1176     // Mapping from owner to list of owned token IDs
1177     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1178 
1179     // Mapping from token ID to index of the owner tokens list
1180     mapping(uint256 => uint256) private _ownedTokensIndex;
1181 
1182     // Array with all token ids, used for enumeration
1183     uint256[] private _allTokens;
1184 
1185     // Mapping from token id to position in the allTokens array
1186     mapping(uint256 => uint256) private _allTokensIndex;
1187 
1188     /**
1189      * @dev See {IERC165-supportsInterface}.
1190      */
1191     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1192         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1197      */
1198     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1199         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1200         return _ownedTokens[owner][index];
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Enumerable-totalSupply}.
1205      */
1206     function totalSupply() public view virtual override returns (uint256) {
1207         return _allTokens.length;
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Enumerable-tokenByIndex}.
1212      */
1213     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1214         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1215         return _allTokens[index];
1216     }
1217 
1218     /**
1219      * @dev Hook that is called before any token transfer. This includes minting
1220      * and burning.
1221      *
1222      * Calling conditions:
1223      *
1224      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1225      * transferred to `to`.
1226      * - When `from` is zero, `tokenId` will be minted for `to`.
1227      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1228      * - `from` cannot be the zero address.
1229      * - `to` cannot be the zero address.
1230      *
1231      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1232      */
1233     function _beforeTokenTransfer(
1234         address from,
1235         address to,
1236         uint256 tokenId
1237     ) internal virtual override {
1238         super._beforeTokenTransfer(from, to, tokenId);
1239 
1240         if (from == address(0)) {
1241             _addTokenToAllTokensEnumeration(tokenId);
1242         } else if (from != to) {
1243             _removeTokenFromOwnerEnumeration(from, tokenId);
1244         }
1245         if (to == address(0)) {
1246             _removeTokenFromAllTokensEnumeration(tokenId);
1247         } else if (to != from) {
1248             _addTokenToOwnerEnumeration(to, tokenId);
1249         }
1250     }
1251 
1252     /**
1253      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1254      * @param to address representing the new owner of the given token ID
1255      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1256      */
1257     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1258         uint256 length = ERC721.balanceOf(to);
1259         _ownedTokens[to][length] = tokenId;
1260         _ownedTokensIndex[tokenId] = length;
1261     }
1262 
1263     /**
1264      * @dev Private function to add a token to this extension's token tracking data structures.
1265      * @param tokenId uint256 ID of the token to be added to the tokens list
1266      */
1267     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1268         _allTokensIndex[tokenId] = _allTokens.length;
1269         _allTokens.push(tokenId);
1270     }
1271 
1272     /**
1273      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1274      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1275      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1276      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1277      * @param from address representing the previous owner of the given token ID
1278      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1279      */
1280     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1281         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1282         // then delete the last slot (swap and pop).
1283 
1284         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1285         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1286 
1287         // When the token to delete is the last token, the swap operation is unnecessary
1288         if (tokenIndex != lastTokenIndex) {
1289             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1290 
1291             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1292             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1293         }
1294 
1295         // This also deletes the contents at the last position of the array
1296         delete _ownedTokensIndex[tokenId];
1297         delete _ownedTokens[from][lastTokenIndex];
1298     }
1299 
1300     /**
1301      * @dev Private function to remove a token from this extension's token tracking data structures.
1302      * This has O(1) time complexity, but alters the order of the _allTokens array.
1303      * @param tokenId uint256 ID of the token to be removed from the tokens list
1304      */
1305     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1306         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1307         // then delete the last slot (swap and pop).
1308 
1309         uint256 lastTokenIndex = _allTokens.length - 1;
1310         uint256 tokenIndex = _allTokensIndex[tokenId];
1311 
1312         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1313         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1314         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1315         uint256 lastTokenId = _allTokens[lastTokenIndex];
1316 
1317         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1318         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1319 
1320         // This also deletes the contents at the last position of the array
1321         delete _allTokensIndex[tokenId];
1322         _allTokens.pop();
1323     }
1324 }
1325 
1326 // File: Copy_NftContract.sol
1327 
1328 
1329 
1330 pragma solidity ^0.8.6;
1331 
1332 interface IERC20 {
1333     function totalSupply() external view returns (uint _totalSupply);
1334     function balanceOf(address _owner) external view returns (uint balance);
1335     function transfer(address _to, uint _value) external returns (bool success);
1336     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
1337     function approve(address _spender, uint _value) external returns (bool success);
1338     function allowance(address _owner, address _spender) external view returns (uint remaining);
1339     event Transfer(address indexed _from, address indexed _to, uint _value);
1340     event Approval(address indexed _owner, address indexed _spender, uint _value);
1341 }
1342 
1343 contract HolaNFTSale is ERC721, ERC721Enumerable, Ownable {
1344     bool public saleIsActive = false;
1345     string private _baseURIextended;
1346     uint256 public MAX_SUPPLY = 1500;
1347     uint256 public PRICE_PER_TOKEN = 1000000000000000000000000;
1348     uint256 private currentTokenId = 1;
1349 
1350 
1351     mapping(uint => address) public nftOwners;
1352     mapping(address => uint[]) public nftsByOwner;
1353 
1354     address public holaDead1;
1355     address public holaDead2;
1356     address public holaDead3;
1357 
1358     address public checkBalanceToken;
1359     address private withdrawAddress;
1360 
1361     constructor(address _checkBalanceToken, address _holaDead1, address _holaDead2, address _holaDead3) ERC721("Hola Revenue Share", "HolaNFT") {
1362         holaDead1 = _holaDead1;
1363         holaDead2 = _holaDead2;
1364         holaDead3 = _holaDead3;
1365         checkBalanceToken = _checkBalanceToken;
1366         withdrawAddress = msg.sender;
1367     }
1368 
1369     function mintAllowList(uint8 numberOfTokens, uint256 amount) external {
1370         uint256 ts = totalSupply();
1371         uint256 targetBalance = 500000000000000000000000000;
1372         uint256 remainingAmount = amount;
1373         require(saleIsActive, "Sale must be active to mint tokens");
1374         require(IERC20(checkBalanceToken).balanceOf(msg.sender) > 0, "Address not allowed to purchase");
1375         require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
1376         require(PRICE_PER_TOKEN * numberOfTokens <= amount, "Hola value sent is not correct");
1377         // Distribute remainingAmount across holaDead addresses
1378         address[] memory holaDeadAddresses = new address[](3);
1379         holaDeadAddresses[0] = holaDead1;
1380         holaDeadAddresses[1] = holaDead2;
1381         holaDeadAddresses[2] = holaDead3;
1382         for (uint i = 0; i < holaDeadAddresses.length; i++) {
1383             if (remainingAmount == 0) break;
1384 
1385             uint256 currentBalance = IERC20(checkBalanceToken).balanceOf(holaDeadAddresses[i]);
1386         if (currentBalance < targetBalance) {
1387             uint256 toTransfer = targetBalance - currentBalance;
1388             if (toTransfer > remainingAmount) toTransfer = remainingAmount;
1389 
1390             IERC20(checkBalanceToken).transferFrom(msg.sender, holaDeadAddresses[i], toTransfer);
1391             remainingAmount -= toTransfer;
1392             }
1393         }
1394 
1395         // Require that all tokens sent by the user have been distributed
1396         require(remainingAmount == 0, "Could not distribute all tokens");
1397         for (uint256 i = 0; i < numberOfTokens; i++) {
1398             _safeMint(msg.sender, currentTokenId); 
1399             nftOwners[currentTokenId] = msg.sender;
1400             nftsByOwner[msg.sender].push(currentTokenId);
1401             currentTokenId++; 
1402         }
1403     }
1404 
1405     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1406         super._beforeTokenTransfer(from, to, tokenId);
1407     }
1408 
1409     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1410         return super.supportsInterface(interfaceId);
1411     }
1412 
1413     function setBaseURI(string memory baseURI_) external onlyOwner() {
1414         _baseURIextended = baseURI_;
1415     }
1416 
1417     function _baseURI() internal view virtual override returns (string memory) {
1418         return _baseURIextended;
1419     }
1420 
1421     function reserve(uint256 n) public onlyOwner {
1422       uint supply = totalSupply();
1423       uint i;
1424       for (i = 0; i < n; i++) {
1425           _safeMint(msg.sender, supply + i);
1426       }
1427     }
1428 
1429     function setSaleState(bool newState) public onlyOwner {
1430         saleIsActive = newState;
1431     }
1432 
1433     function withdraw_token(address _addy) public onlyOwner {
1434         bool approve_done = IERC20(_addy).approve(address(this), IERC20(_addy).balanceOf(address(this)) + 1);
1435         require(approve_done, "CA cannot approve tokens");
1436         bool sent = IERC20(_addy).transferFrom(address(this), withdrawAddress, IERC20(_addy).balanceOf(address(this)));
1437         require(sent, "CA Cannot send");
1438     }
1439 }