1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Context.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/access/Ownable.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor() {
135         _transferOwnership(_msgSender());
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         _checkOwner();
143         _;
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if the sender is not the owner.
155      */
156     function _checkOwner() internal view virtual {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _transferOwnership(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Internal function without access restriction.
183      */
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/Address.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
195 
196 pragma solidity ^0.8.1;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      *
219      * [IMPORTANT]
220      * ====
221      * You shouldn't rely on `isContract` to protect against flash loan attacks!
222      *
223      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
224      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
225      * constructor.
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies on extcodesize/address.code.length, which returns 0
230         // for contracts in construction, since the code is only stored at the end
231         // of the constructor execution.
232 
233         return account.code.length > 0;
234     }
235 
236     /**
237      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
238      * `recipient`, forwarding all available gas and reverting on errors.
239      *
240      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
241      * of certain opcodes, possibly making contracts go over the 2300 gas limit
242      * imposed by `transfer`, making them unable to receive funds via
243      * `transfer`. {sendValue} removes this limitation.
244      *
245      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
246      *
247      * IMPORTANT: because control is transferred to `recipient`, care must be
248      * taken to not create reentrancy vulnerabilities. Consider using
249      * {ReentrancyGuard} or the
250      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
251      */
252     function sendValue(address payable recipient, uint256 amount) internal {
253         require(address(this).balance >= amount, "Address: insufficient balance");
254 
255         (bool success, ) = recipient.call{value: amount}("");
256         require(success, "Address: unable to send value, recipient may have reverted");
257     }
258 
259     /**
260      * @dev Performs a Solidity function call using a low level `call`. A
261      * plain `call` is an unsafe replacement for a function call: use this
262      * function instead.
263      *
264      * If `target` reverts with a revert reason, it is bubbled up by this
265      * function (like regular Solidity function calls).
266      *
267      * Returns the raw returned data. To convert to the expected return value,
268      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
269      *
270      * Requirements:
271      *
272      * - `target` must be a contract.
273      * - calling `target` with `data` must not revert.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionCall(target, data, "Address: low-level call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
283      * `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, 0, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but also transferring `value` wei to `target`.
298      *
299      * Requirements:
300      *
301      * - the calling contract must have an ETH balance of at least `value`.
302      * - the called Solidity function must be `payable`.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
316      * with `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         require(isContract(target), "Address: call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.call{value: value}(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
340         return functionStaticCall(target, data, "Address: low-level static call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal view returns (bytes memory) {
354         require(isContract(target), "Address: static call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(isContract(target), "Address: delegate call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.delegatecall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
389      * revert reason using the provided one.
390      *
391      * _Available since v4.3._
392      */
393     function verifyCallResult(
394         bool success,
395         bytes memory returndata,
396         string memory errorMessage
397     ) internal pure returns (bytes memory) {
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404                 /// @solidity memory-safe-assembly
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
417 
418 
419 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @title ERC721 token receiver interface
425  * @dev Interface for any contract that wants to support safeTransfers
426  * from ERC721 asset contracts.
427  */
428 interface IERC721Receiver {
429     /**
430      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
431      * by `operator` from `from`, this function is called.
432      *
433      * It must return its Solidity selector to confirm the token transfer.
434      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
435      *
436      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
437      */
438     function onERC721Received(
439         address operator,
440         address from,
441         uint256 tokenId,
442         bytes calldata data
443     ) external returns (bytes4);
444 }
445 
446 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Interface of the ERC165 standard, as defined in the
455  * https://eips.ethereum.org/EIPS/eip-165[EIP].
456  *
457  * Implementers can declare support of contract interfaces, which can then be
458  * queried by others ({ERC165Checker}).
459  *
460  * For an implementation, see {ERC165}.
461  */
462 interface IERC165 {
463     /**
464      * @dev Returns true if this contract implements the interface defined by
465      * `interfaceId`. See the corresponding
466      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
467      * to learn more about how these ids are created.
468      *
469      * This function call must use less than 30 000 gas.
470      */
471     function supportsInterface(bytes4 interfaceId) external view returns (bool);
472 }
473 
474 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @dev Implementation of the {IERC165} interface.
484  *
485  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
486  * for the additional interface id that will be supported. For example:
487  *
488  * ```solidity
489  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
491  * }
492  * ```
493  *
494  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
495  */
496 abstract contract ERC165 is IERC165 {
497     /**
498      * @dev See {IERC165-supportsInterface}.
499      */
500     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
501         return interfaceId == type(IERC165).interfaceId;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
506 
507 
508 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @dev Required interface of an ERC721 compliant contract.
515  */
516 interface IERC721 is IERC165 {
517     /**
518      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
519      */
520     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
524      */
525     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
529      */
530     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
531 
532     /**
533      * @dev Returns the number of tokens in ``owner``'s account.
534      */
535     function balanceOf(address owner) external view returns (uint256 balance);
536 
537     /**
538      * @dev Returns the owner of the `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function ownerOf(uint256 tokenId) external view returns (address owner);
545 
546     /**
547      * @dev Safely transfers `tokenId` token from `from` to `to`.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must exist and be owned by `from`.
554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId,
563         bytes calldata data
564     ) external;
565 
566     /**
567      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
568      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must exist and be owned by `from`.
575      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
576      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
577      *
578      * Emits a {Transfer} event.
579      */
580     function safeTransferFrom(
581         address from,
582         address to,
583         uint256 tokenId
584     ) external;
585 
586     /**
587      * @dev Transfers `tokenId` token from `from` to `to`.
588      *
589      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must be owned by `from`.
596      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
597      *
598      * Emits a {Transfer} event.
599      */
600     function transferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external;
605 
606     /**
607      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
608      * The approval is cleared when the token is transferred.
609      *
610      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
611      *
612      * Requirements:
613      *
614      * - The caller must own the token or be an approved operator.
615      * - `tokenId` must exist.
616      *
617      * Emits an {Approval} event.
618      */
619     function approve(address to, uint256 tokenId) external;
620 
621     /**
622      * @dev Approve or remove `operator` as an operator for the caller.
623      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
624      *
625      * Requirements:
626      *
627      * - The `operator` cannot be the caller.
628      *
629      * Emits an {ApprovalForAll} event.
630      */
631     function setApprovalForAll(address operator, bool _approved) external;
632 
633     /**
634      * @dev Returns the account approved for `tokenId` token.
635      *
636      * Requirements:
637      *
638      * - `tokenId` must exist.
639      */
640     function getApproved(uint256 tokenId) external view returns (address operator);
641 
642     /**
643      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
644      *
645      * See {setApprovalForAll}
646      */
647     function isApprovedForAll(address owner, address operator) external view returns (bool);
648 }
649 
650 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
651 
652 
653 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 
658 /**
659  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
660  * @dev See https://eips.ethereum.org/EIPS/eip-721
661  */
662 interface IERC721Enumerable is IERC721 {
663     /**
664      * @dev Returns the total amount of tokens stored by the contract.
665      */
666     function totalSupply() external view returns (uint256);
667 
668     /**
669      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
670      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
671      */
672     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
673 
674     /**
675      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
676      * Use along with {totalSupply} to enumerate all tokens.
677      */
678     function tokenByIndex(uint256 index) external view returns (uint256);
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
691  * @dev See https://eips.ethereum.org/EIPS/eip-721
692  */
693 interface IERC721Metadata is IERC721 {
694     /**
695      * @dev Returns the token collection name.
696      */
697     function name() external view returns (string memory);
698 
699     /**
700      * @dev Returns the token collection symbol.
701      */
702     function symbol() external view returns (string memory);
703 
704     /**
705      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
706      */
707     function tokenURI(uint256 tokenId) external view returns (string memory);
708 }
709 
710 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
711 
712 
713 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 
718 
719 
720 
721 
722 
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
726  * the Metadata extension, but not including the Enumerable extension, which is available separately as
727  * {ERC721Enumerable}.
728  */
729 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
730     using Address for address;
731     using Strings for uint256;
732 
733     // Token name
734     string private _name;
735 
736     // Token symbol
737     string private _symbol;
738 
739     // Mapping from token ID to owner address
740     mapping(uint256 => address) private _owners;
741 
742     // Mapping owner address to token count
743     mapping(address => uint256) private _balances;
744 
745     // Mapping from token ID to approved address
746     mapping(uint256 => address) private _tokenApprovals;
747 
748     // Mapping from owner to operator approvals
749     mapping(address => mapping(address => bool)) private _operatorApprovals;
750 
751     /**
752      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
753      */
754     constructor(string memory name_, string memory symbol_) {
755         _name = name_;
756         _symbol = symbol_;
757     }
758 
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
763         return
764             interfaceId == type(IERC721).interfaceId ||
765             interfaceId == type(IERC721Metadata).interfaceId ||
766             super.supportsInterface(interfaceId);
767     }
768 
769     /**
770      * @dev See {IERC721-balanceOf}.
771      */
772     function balanceOf(address owner) public view virtual override returns (uint256) {
773         require(owner != address(0), "ERC721: address zero is not a valid owner");
774         return _balances[owner];
775     }
776 
777     /**
778      * @dev See {IERC721-ownerOf}.
779      */
780     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
781         address owner = _owners[tokenId];
782         require(owner != address(0), "ERC721: invalid token ID");
783         return owner;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-name}.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-symbol}.
795      */
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-tokenURI}.
802      */
803     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
804         _requireMinted(tokenId);
805 
806         string memory baseURI = _baseURI();
807         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
808     }
809 
810     /**
811      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
812      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
813      * by default, can be overridden in child contracts.
814      */
815     function _baseURI() internal view virtual returns (string memory) {
816         return "";
817     }
818 
819     /**
820      * @dev See {IERC721-approve}.
821      */
822     function approve(address to, uint256 tokenId) public virtual override {
823         address owner = ERC721.ownerOf(tokenId);
824         require(to != owner, "ERC721: approval to current owner");
825 
826         require(
827             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
828             "ERC721: approve caller is not token owner nor approved for all"
829         );
830 
831         _approve(to, tokenId);
832     }
833 
834     /**
835      * @dev See {IERC721-getApproved}.
836      */
837     function getApproved(uint256 tokenId) public view virtual override returns (address) {
838         _requireMinted(tokenId);
839 
840         return _tokenApprovals[tokenId];
841     }
842 
843     /**
844      * @dev See {IERC721-setApprovalForAll}.
845      */
846     function setApprovalForAll(address operator, bool approved) public virtual override {
847         _setApprovalForAll(_msgSender(), operator, approved);
848     }
849 
850     /**
851      * @dev See {IERC721-isApprovedForAll}.
852      */
853     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
854         return _operatorApprovals[owner][operator];
855     }
856 
857     /**
858      * @dev See {IERC721-transferFrom}.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         //solhint-disable-next-line max-line-length
866         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
867 
868         _transfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         safeTransferFrom(from, to, tokenId, "");
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory data
890     ) public virtual override {
891         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
892         _safeTransfer(from, to, tokenId, data);
893     }
894 
895     /**
896      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
897      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
898      *
899      * `data` is additional data, it has no specified format and it is sent in call to `to`.
900      *
901      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
902      * implement alternative mechanisms to perform token transfer, such as signature-based.
903      *
904      * Requirements:
905      *
906      * - `from` cannot be the zero address.
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must exist and be owned by `from`.
909      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _safeTransfer(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory data
918     ) internal virtual {
919         _transfer(from, to, tokenId);
920         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted (`_mint`),
929      * and stop existing when they are burned (`_burn`).
930      */
931     function _exists(uint256 tokenId) internal view virtual returns (bool) {
932         return _owners[tokenId] != address(0);
933     }
934 
935     /**
936      * @dev Returns whether `spender` is allowed to manage `tokenId`.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      */
942     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
943         address owner = ERC721.ownerOf(tokenId);
944         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
945     }
946 
947     /**
948      * @dev Safely mints `tokenId` and transfers it to `to`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(address to, uint256 tokenId) internal virtual {
958         _safeMint(to, tokenId, "");
959     }
960 
961     /**
962      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
963      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
964      */
965     function _safeMint(
966         address to,
967         uint256 tokenId,
968         bytes memory data
969     ) internal virtual {
970         _mint(to, tokenId);
971         require(
972             _checkOnERC721Received(address(0), to, tokenId, data),
973             "ERC721: transfer to non ERC721Receiver implementer"
974         );
975     }
976 
977     /**
978      * @dev Mints `tokenId` and transfers it to `to`.
979      *
980      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
981      *
982      * Requirements:
983      *
984      * - `tokenId` must not exist.
985      * - `to` cannot be the zero address.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _mint(address to, uint256 tokenId) internal virtual {
990         require(to != address(0), "ERC721: mint to the zero address");
991         require(!_exists(tokenId), "ERC721: token already minted");
992 
993         _beforeTokenTransfer(address(0), to, tokenId);
994 
995         _balances[to] += 1;
996         _owners[tokenId] = to;
997 
998         emit Transfer(address(0), to, tokenId);
999 
1000         _afterTokenTransfer(address(0), to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Destroys `tokenId`.
1005      * The approval is cleared when the token is burned.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must exist.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _burn(uint256 tokenId) internal virtual {
1014         address owner = ERC721.ownerOf(tokenId);
1015 
1016         _beforeTokenTransfer(owner, address(0), tokenId);
1017 
1018         // Clear approvals
1019         _approve(address(0), tokenId);
1020 
1021         _balances[owner] -= 1;
1022         delete _owners[tokenId];
1023 
1024         emit Transfer(owner, address(0), tokenId);
1025 
1026         _afterTokenTransfer(owner, address(0), tokenId);
1027     }
1028 
1029     /**
1030      * @dev Transfers `tokenId` from `from` to `to`.
1031      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1032      *
1033      * Requirements:
1034      *
1035      * - `to` cannot be the zero address.
1036      * - `tokenId` token must be owned by `from`.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _transfer(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) internal virtual {
1045         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1046         require(to != address(0), "ERC721: transfer to the zero address");
1047 
1048         _beforeTokenTransfer(from, to, tokenId);
1049 
1050         // Clear approvals from the previous owner
1051         _approve(address(0), tokenId);
1052 
1053         _balances[from] -= 1;
1054         _balances[to] += 1;
1055         _owners[tokenId] = to;
1056 
1057         emit Transfer(from, to, tokenId);
1058 
1059         _afterTokenTransfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev Approve `to` to operate on `tokenId`
1064      *
1065      * Emits an {Approval} event.
1066      */
1067     function _approve(address to, uint256 tokenId) internal virtual {
1068         _tokenApprovals[tokenId] = to;
1069         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1070     }
1071 
1072     /**
1073      * @dev Approve `operator` to operate on all of `owner` tokens
1074      *
1075      * Emits an {ApprovalForAll} event.
1076      */
1077     function _setApprovalForAll(
1078         address owner,
1079         address operator,
1080         bool approved
1081     ) internal virtual {
1082         require(owner != operator, "ERC721: approve to caller");
1083         _operatorApprovals[owner][operator] = approved;
1084         emit ApprovalForAll(owner, operator, approved);
1085     }
1086 
1087     /**
1088      * @dev Reverts if the `tokenId` has not been minted yet.
1089      */
1090     function _requireMinted(uint256 tokenId) internal view virtual {
1091         require(_exists(tokenId), "ERC721: invalid token ID");
1092     }
1093 
1094     /**
1095      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1096      * The call is not executed if the target address is not a contract.
1097      *
1098      * @param from address representing the previous owner of the given token ID
1099      * @param to target address that will receive the tokens
1100      * @param tokenId uint256 ID of the token to be transferred
1101      * @param data bytes optional data to send along with the call
1102      * @return bool whether the call correctly returned the expected magic value
1103      */
1104     function _checkOnERC721Received(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory data
1109     ) private returns (bool) {
1110         if (to.isContract()) {
1111             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1112                 return retval == IERC721Receiver.onERC721Received.selector;
1113             } catch (bytes memory reason) {
1114                 if (reason.length == 0) {
1115                     revert("ERC721: transfer to non ERC721Receiver implementer");
1116                 } else {
1117                     /// @solidity memory-safe-assembly
1118                     assembly {
1119                         revert(add(32, reason), mload(reason))
1120                     }
1121                 }
1122             }
1123         } else {
1124             return true;
1125         }
1126     }
1127 
1128     /**
1129      * @dev Hook that is called before any token transfer. This includes minting
1130      * and burning.
1131      *
1132      * Calling conditions:
1133      *
1134      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1135      * transferred to `to`.
1136      * - When `from` is zero, `tokenId` will be minted for `to`.
1137      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1138      * - `from` and `to` are never both zero.
1139      *
1140      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1141      */
1142     function _beforeTokenTransfer(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) internal virtual {}
1147 
1148     /**
1149      * @dev Hook that is called after any transfer of tokens. This includes
1150      * minting and burning.
1151      *
1152      * Calling conditions:
1153      *
1154      * - when `from` and `to` are both non-zero.
1155      * - `from` and `to` are never both zero.
1156      *
1157      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1158      */
1159     function _afterTokenTransfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual {}
1164 }
1165 
1166 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1167 
1168 
1169 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 
1174 
1175 /**
1176  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1177  * enumerability of all the token ids in the contract as well as all token ids owned by each
1178  * account.
1179  */
1180 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1181     // Mapping from owner to list of owned token IDs
1182     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1183 
1184     // Mapping from token ID to index of the owner tokens list
1185     mapping(uint256 => uint256) private _ownedTokensIndex;
1186 
1187     // Array with all token ids, used for enumeration
1188     uint256[] private _allTokens;
1189 
1190     // Mapping from token id to position in the allTokens array
1191     mapping(uint256 => uint256) private _allTokensIndex;
1192 
1193     /**
1194      * @dev See {IERC165-supportsInterface}.
1195      */
1196     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1197         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1198     }
1199 
1200     /**
1201      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1202      */
1203     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1204         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1205         return _ownedTokens[owner][index];
1206     }
1207 
1208     /**
1209      * @dev See {IERC721Enumerable-totalSupply}.
1210      */
1211     function totalSupply() public view virtual override returns (uint256) {
1212         return _allTokens.length;
1213     }
1214 
1215     /**
1216      * @dev See {IERC721Enumerable-tokenByIndex}.
1217      */
1218     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1219         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1220         return _allTokens[index];
1221     }
1222 
1223     /**
1224      * @dev Hook that is called before any token transfer. This includes minting
1225      * and burning.
1226      *
1227      * Calling conditions:
1228      *
1229      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1230      * transferred to `to`.
1231      * - When `from` is zero, `tokenId` will be minted for `to`.
1232      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1233      * - `from` cannot be the zero address.
1234      * - `to` cannot be the zero address.
1235      *
1236      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1237      */
1238     function _beforeTokenTransfer(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) internal virtual override {
1243         super._beforeTokenTransfer(from, to, tokenId);
1244 
1245         if (from == address(0)) {
1246             _addTokenToAllTokensEnumeration(tokenId);
1247         } else if (from != to) {
1248             _removeTokenFromOwnerEnumeration(from, tokenId);
1249         }
1250         if (to == address(0)) {
1251             _removeTokenFromAllTokensEnumeration(tokenId);
1252         } else if (to != from) {
1253             _addTokenToOwnerEnumeration(to, tokenId);
1254         }
1255     }
1256 
1257     /**
1258      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1259      * @param to address representing the new owner of the given token ID
1260      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1261      */
1262     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1263         uint256 length = ERC721.balanceOf(to);
1264         _ownedTokens[to][length] = tokenId;
1265         _ownedTokensIndex[tokenId] = length;
1266     }
1267 
1268     /**
1269      * @dev Private function to add a token to this extension's token tracking data structures.
1270      * @param tokenId uint256 ID of the token to be added to the tokens list
1271      */
1272     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1273         _allTokensIndex[tokenId] = _allTokens.length;
1274         _allTokens.push(tokenId);
1275     }
1276 
1277     /**
1278      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1279      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1280      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1281      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1282      * @param from address representing the previous owner of the given token ID
1283      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1284      */
1285     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1286         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1287         // then delete the last slot (swap and pop).
1288 
1289         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1290         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1291 
1292         // When the token to delete is the last token, the swap operation is unnecessary
1293         if (tokenIndex != lastTokenIndex) {
1294             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1295 
1296             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1297             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1298         }
1299 
1300         // This also deletes the contents at the last position of the array
1301         delete _ownedTokensIndex[tokenId];
1302         delete _ownedTokens[from][lastTokenIndex];
1303     }
1304 
1305     /**
1306      * @dev Private function to remove a token from this extension's token tracking data structures.
1307      * This has O(1) time complexity, but alters the order of the _allTokens array.
1308      * @param tokenId uint256 ID of the token to be removed from the tokens list
1309      */
1310     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1311         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1312         // then delete the last slot (swap and pop).
1313 
1314         uint256 lastTokenIndex = _allTokens.length - 1;
1315         uint256 tokenIndex = _allTokensIndex[tokenId];
1316 
1317         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1318         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1319         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1320         uint256 lastTokenId = _allTokens[lastTokenIndex];
1321 
1322         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1323         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1324 
1325         // This also deletes the contents at the last position of the array
1326         delete _allTokensIndex[tokenId];
1327         _allTokens.pop();
1328     }
1329 }
1330 
1331 // File: contracts/forg_contract.sol
1332 
1333 
1334 
1335 // Amended by HashLips
1336 /**
1337     !Disclaimer!
1338     These contracts have been used to create tutorials,
1339     and was created for the purpose to teach people
1340     how to create smart contracts on the blockchain.
1341     please review this code on your own before using any of
1342     the following code for production.
1343     HashLips will not be liable in any way if for the use 
1344     of the code. That being said, the code has been tested 
1345     to the best of the developers' knowledge to work as intended.
1346 */
1347 
1348 pragma solidity >=0.7.0 <0.9.0;
1349 
1350 
1351 
1352 contract NFT is ERC721Enumerable, Ownable {
1353   using Strings for uint256;
1354 
1355   string baseURI;
1356   string public baseExtension = ".json";
1357   uint256 public maxSupply = 3333;
1358   bool public paused = false;
1359   bool public revealed = false;
1360   string public notRevealedUri;
1361   mapping(address => bool) public whitelist;
1362   
1363   uint256 _startTime = 1666983600;
1364 
1365   struct Round{
1366     uint256 maxCount;
1367     uint256 cost;
1368     uint256 maxMintAmount;
1369     uint256 roundCurrentCount;
1370     mapping (address => uint) playerCount;
1371   } 
1372 
1373   mapping (uint => Round) roundList;
1374 
1375   constructor(
1376     string memory _name,
1377     string memory _symbol,
1378     string memory _initBaseURI,
1379     string memory _initNotRevealedUri
1380   ) ERC721(_name, _symbol) {
1381     setBaseURI(_initBaseURI);
1382     setNotRevealedURI(_initNotRevealedUri);
1383   }
1384 
1385   function setStartTime(uint time) public onlyOwner {
1386     _startTime = time;
1387   }
1388 
1389   function getCurrentRound() public view returns(uint)
1390   {
1391       uint round = 0;
1392       
1393 
1394       if(roundList[0].maxCount > roundList[0].roundCurrentCount)
1395       {
1396         round = 0;
1397       }
1398       else
1399       {
1400         round = 1;
1401       }
1402 
1403       return round;
1404   }
1405 
1406   function setRoundList(uint whichRound, uint maxCount,  uint cost, uint maxMintAmount) public onlyOwner
1407   {
1408       Round storage newRound = roundList[whichRound];
1409       newRound.maxCount = maxCount;
1410       newRound.cost = cost;
1411       newRound.maxMintAmount = maxMintAmount;
1412   }
1413 
1414   // internal
1415   function _baseURI() internal view virtual override returns (string memory) {
1416     return baseURI;
1417   }
1418 
1419   
1420 
1421   // public
1422   function mint(uint256 _mintAmount) public payable {
1423 
1424     uint currentTime = block.timestamp;
1425     require(currentTime >= _startTime,"not the right round");
1426 
1427     uint currRound = getCurrentRound();
1428 
1429     uint playerCount = roundList[currRound].playerCount[msg.sender];
1430 
1431     uint256 supply = totalSupply();
1432     require(!paused,"scale paused");
1433     require(_mintAmount > 0,"mint Amount less than 1");
1434     require(_mintAmount + playerCount <=roundList[currRound].maxMintAmount,"player max mint");
1435     require(supply + _mintAmount <= maxSupply,"nft max supply");
1436 
1437     if(currRound == 0)
1438     {
1439       require(roundList[0].roundCurrentCount + _mintAmount <= roundList[0].maxCount,"round scale out");
1440     }
1441     
1442 
1443     if (msg.sender != owner()) {
1444       require(msg.value >= roundList[currRound].cost * _mintAmount, "value not enough");
1445 
1446       if(currRound == 1)
1447       {
1448           require(whitelist[msg.sender], "not the white list");
1449       }
1450 
1451     }
1452 
1453     for (uint256 i = 1; i <= _mintAmount; i++) {
1454       _safeMint(msg.sender, supply + i);
1455       
1456     }
1457     roundList[currRound].roundCurrentCount = roundList[currRound].roundCurrentCount + _mintAmount;
1458     roundList[currRound].playerCount[msg.sender] = playerCount + _mintAmount;
1459     if(currRound == 0 && roundList[0].roundCurrentCount == roundList[0].maxCount)
1460     {
1461         paused = true;
1462     }
1463   }
1464 
1465     
1466   function airDorp(address player,uint256 _airAmount) public payable onlyOwner{
1467     uint256 supply = totalSupply();
1468     require(!paused);
1469     require(_airAmount > 0);
1470     require(supply + _airAmount <= maxSupply);
1471 
1472     for (uint256 i = 1; i <= _airAmount; i++) {
1473       _safeMint(player, supply + i);
1474     }
1475 
1476   }
1477 
1478   function walletOfOwner(address _owner)
1479     public
1480     view
1481     returns (uint256[] memory)
1482   {
1483     uint256 ownerTokenCount = balanceOf(_owner);
1484     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1485     for (uint256 i; i < ownerTokenCount; i++) {
1486       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1487     }
1488     return tokenIds;
1489   }
1490 
1491   function tokenURI(uint256 tokenId)
1492     public
1493     view
1494     virtual
1495     override
1496     returns (string memory)
1497   {
1498     require(
1499       _exists(tokenId),
1500       "ERC721Metadata: URI query for nonexistent token"
1501     );
1502     
1503     if(revealed == false) {
1504         return notRevealedUri;
1505     }
1506 
1507     string memory currentBaseURI = _baseURI();
1508     return bytes(currentBaseURI).length > 0
1509         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1510         : "";
1511   }
1512 
1513   //only owner
1514   function reveal() public onlyOwner {
1515       revealed = true;
1516   }
1517   
1518 
1519   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1520     notRevealedUri = _notRevealedURI;
1521   }
1522 
1523   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1524     baseURI = _newBaseURI;
1525   }
1526 
1527   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1528     baseExtension = _newBaseExtension;
1529   }
1530 
1531   function pause(bool _state) public onlyOwner {
1532     paused = _state;
1533   }
1534 
1535   function addWhiteListArray(address[] memory _userList) public onlyOwner {
1536       for(uint i = 0; i < _userList.length; i ++)
1537       {
1538         whitelist[_userList[i]] = true;
1539       }
1540   }
1541 
1542   function whitelistUser(address _user) public onlyOwner {
1543     whitelist[_user] = true;
1544   }
1545  
1546   function removeWhitelistUser(address _user) public onlyOwner {
1547     whitelist[_user] = false;
1548   }
1549  
1550   function withdraw() public payable onlyOwner {
1551 
1552     // =============================================================================
1553     
1554     // This will payout the owner 95% of the contract balance.
1555     // Do not remove this otherwise you will not be able to withdraw the funds.
1556     // =============================================================================
1557     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1558     require(os);
1559     // =============================================================================
1560   }
1561 }