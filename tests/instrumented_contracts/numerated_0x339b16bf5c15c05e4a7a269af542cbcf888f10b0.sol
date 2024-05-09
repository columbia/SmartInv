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
650 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
651 
652 
653 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 
658 /**
659  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
660  * @dev See https://eips.ethereum.org/EIPS/eip-721
661  */
662 interface IERC721Metadata is IERC721 {
663     /**
664      * @dev Returns the token collection name.
665      */
666     function name() external view returns (string memory);
667 
668     /**
669      * @dev Returns the token collection symbol.
670      */
671     function symbol() external view returns (string memory);
672 
673     /**
674      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
675      */
676     function tokenURI(uint256 tokenId) external view returns (string memory);
677 }
678 
679 // File: ERC721A.sol
680 
681 
682 // Creator: Chiru Labs
683 
684 pragma solidity ^0.8.4;
685 
686 
687 
688 
689 
690 
691 
692 
693 error ApprovalCallerNotOwnerNorApproved();
694 error ApprovalQueryForNonexistentToken();
695 error ApproveToCaller();
696 error ApprovalToCurrentOwner();
697 error BalanceQueryForZeroAddress();
698 error MintToZeroAddress();
699 error MintZeroQuantity();
700 error OwnerQueryForNonexistentToken();
701 error TransferCallerNotOwnerNorApproved();
702 error TransferFromIncorrectOwner();
703 error TransferToNonERC721ReceiverImplementer();
704 error TransferToZeroAddress();
705 error URIQueryForNonexistentToken();
706 
707 /**
708  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
709  * the Metadata extension. Built to optimize for lower gas during batch mints.
710  *
711  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
712  *
713  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
714  *
715  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
716  */
717 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
718     using Address for address;
719     using Strings for uint256;
720 
721     // Compiler will pack this into a single 256bit word.
722     struct TokenOwnership {
723         // The address of the owner.
724         address addr;
725         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
726         uint64 startTimestamp;
727         // Whether the token has been burned.
728         bool burned;
729     }
730 
731     // Compiler will pack this into a single 256bit word.
732     struct AddressData {
733         // Realistically, 2**64-1 is more than enough.
734         uint64 balance;
735         // Keeps track of mint count with minimal overhead for tokenomics.
736         uint64 numberMinted;
737         // Keeps track of burn count with minimal overhead for tokenomics.
738         uint64 numberBurned;
739         // For miscellaneous variable(s) pertaining to the address
740         // (e.g. number of whitelist mint slots used).
741         // If there are multiple variables, please pack them into a uint64.
742         uint64 aux;
743     }
744 
745     // The tokenId of the next token to be minted.
746     uint256 internal _currentIndex;
747 
748     // The number of tokens burned.
749     uint256 internal _burnCounter;
750 
751     // Token name
752     string private _name;
753 
754     // Token symbol
755     string private _symbol;
756 
757     // Mapping from token ID to ownership details
758     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
759     mapping(uint256 => TokenOwnership) internal _ownerships;
760 
761     // Mapping owner address to address data
762     mapping(address => AddressData) private _addressData;
763 
764     // Mapping from token ID to approved address
765     mapping(uint256 => address) private _tokenApprovals;
766 
767     // Mapping from owner to operator approvals
768     mapping(address => mapping(address => bool)) private _operatorApprovals;
769 
770     constructor(string memory name_, string memory symbol_) {
771         _name = name_;
772         _symbol = symbol_;
773         _currentIndex = _startTokenId();
774     }
775 
776     /**
777      * To change the starting tokenId, please override this function.
778      */
779     function _startTokenId() internal view virtual returns (uint256) {
780         return 1;
781     }
782 
783     /**
784      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
785      */
786     function totalSupply() public view returns (uint256) {
787         // Counter underflow is impossible as _burnCounter cannot be incremented
788         // more than _currentIndex - _startTokenId() times
789         unchecked {
790             return _currentIndex - _burnCounter - _startTokenId();
791         }
792     }
793 
794     /**
795      * Returns the total amount of tokens minted in the contract.
796      */
797     function _totalMinted() internal view returns (uint256) {
798         // Counter underflow is impossible as _currentIndex does not decrement,
799         // and it is initialized to _startTokenId()
800         unchecked {
801             return _currentIndex - _startTokenId();
802         }
803     }
804 
805     /**
806      * @dev See {IERC165-supportsInterface}.
807      */
808     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
809         return
810             interfaceId == type(IERC721).interfaceId ||
811             interfaceId == type(IERC721Metadata).interfaceId ||
812             super.supportsInterface(interfaceId);
813     }
814 
815     /**
816      * @dev See {IERC721-balanceOf}.
817      */
818     function balanceOf(address owner) public view override returns (uint256) {
819         if (owner == address(0)) revert BalanceQueryForZeroAddress();
820         return uint256(_addressData[owner].balance);
821     }
822 
823     /**
824      * Returns the number of tokens minted by `owner`.
825      */
826     function _numberMinted(address owner) internal view returns (uint256) {
827         return uint256(_addressData[owner].numberMinted);
828     }
829 
830     /**
831      * Returns the number of tokens burned by or on behalf of `owner`.
832      */
833     function _numberBurned(address owner) internal view returns (uint256) {
834         return uint256(_addressData[owner].numberBurned);
835     }
836 
837     /**
838      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
839      */
840     function _getAux(address owner) internal view returns (uint64) {
841         return _addressData[owner].aux;
842     }
843 
844     /**
845      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
846      * If there are multiple variables, please pack them into a uint64.
847      */
848     function _setAux(address owner, uint64 aux) internal {
849         _addressData[owner].aux = aux;
850     }
851 
852     /**
853      * Gas spent here starts off proportional to the maximum mint batch size.
854      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
855      */
856     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
857         uint256 curr = tokenId;
858 
859         unchecked {
860             if (_startTokenId() <= curr && curr < _currentIndex) {
861                 TokenOwnership memory ownership = _ownerships[curr];
862                 if (!ownership.burned) {
863                     if (ownership.addr != address(0)) {
864                         return ownership;
865                     }
866                     // Invariant:
867                     // There will always be an ownership that has an address and is not burned
868                     // before an ownership that does not have an address and is not burned.
869                     // Hence, curr will not underflow.
870                     while (true) {
871                         curr--;
872                         ownership = _ownerships[curr];
873                         if (ownership.addr != address(0)) {
874                             return ownership;
875                         }
876                     }
877                 }
878             }
879         }
880         revert OwnerQueryForNonexistentToken();
881     }
882 
883     /**
884      * @dev See {IERC721-ownerOf}.
885      */
886     function ownerOf(uint256 tokenId) public view override returns (address) {
887         return _ownershipOf(tokenId).addr;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-name}.
892      */
893     function name() public view virtual override returns (string memory) {
894         return _name;
895     }
896 
897     /**
898      * @dev See {IERC721Metadata-symbol}.
899      */
900     function symbol() public view virtual override returns (string memory) {
901         return _symbol;
902     }
903 
904     /**
905      * @dev See {IERC721Metadata-tokenURI}.
906      */
907     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
908         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
909 
910         string memory baseURI = _baseURI();
911         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
912     }
913 
914     /**
915      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
916      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
917      * by default, can be overriden in child contracts.
918      */
919     function _baseURI() internal view virtual returns (string memory) {
920         return '';
921     }
922 
923     /**
924      * @dev See {IERC721-approve}.
925      */
926     function approve(address to, uint256 tokenId) public override {
927         address owner = ERC721A.ownerOf(tokenId);
928         if (to == owner) revert ApprovalToCurrentOwner();
929 
930         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
931             revert ApprovalCallerNotOwnerNorApproved();
932         }
933 
934         _approve(to, tokenId, owner);
935     }
936 
937     /**
938      * @dev See {IERC721-getApproved}.
939      */
940     function getApproved(uint256 tokenId) public view override returns (address) {
941         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
942 
943         return _tokenApprovals[tokenId];
944     }
945 
946     /**
947      * @dev See {IERC721-setApprovalForAll}.
948      */
949     function setApprovalForAll(address operator, bool approved) public virtual override {
950         if (operator == _msgSender()) revert ApproveToCaller();
951 
952         _operatorApprovals[_msgSender()][operator] = approved;
953         emit ApprovalForAll(_msgSender(), operator, approved);
954     }
955 
956     /**
957      * @dev See {IERC721-isApprovedForAll}.
958      */
959     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
960         return _operatorApprovals[owner][operator];
961     }
962 
963     /**
964      * @dev See {IERC721-transferFrom}.
965      */
966     function transferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         _transfer(from, to, tokenId);
972     }
973 
974     /**
975      * @dev See {IERC721-safeTransferFrom}.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId
981     ) public virtual override {
982         safeTransferFrom(from, to, tokenId, '');
983     }
984 
985     /**
986      * @dev See {IERC721-safeTransferFrom}.
987      */
988     function safeTransferFrom(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) public virtual override {
994         _transfer(from, to, tokenId);
995         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
996             revert TransferToNonERC721ReceiverImplementer();
997         }
998     }
999 
1000     /**
1001      * @dev Returns whether `tokenId` exists.
1002      *
1003      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1004      *
1005      * Tokens start existing when they are minted (`_mint`),
1006      */
1007     function _exists(uint256 tokenId) internal view returns (bool) {
1008         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1009     }
1010 
1011     function _safeMint(address to, uint256 quantity) internal {
1012         _safeMint(to, quantity, '');
1013     }
1014 
1015     /**
1016      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1021      * - `quantity` must be greater than 0.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _safeMint(
1026         address to,
1027         uint256 quantity,
1028         bytes memory _data
1029     ) internal {
1030         _mint(to, quantity, _data, true);
1031     }
1032 
1033     /**
1034      * @dev Mints `quantity` tokens and transfers them to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `quantity` must be greater than 0.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _mint(
1044         address to,
1045         uint256 quantity,
1046         bytes memory _data,
1047         bool safe
1048     ) internal {
1049         uint256 startTokenId = _currentIndex;
1050         if (to == address(0)) revert MintToZeroAddress();
1051         if (quantity == 0) revert MintZeroQuantity();
1052 
1053         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1054 
1055         // Overflows are incredibly unrealistic.
1056         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1057         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1058         unchecked {
1059             _addressData[to].balance += uint64(quantity);
1060             _addressData[to].numberMinted += uint64(quantity);
1061 
1062             _ownerships[startTokenId].addr = to;
1063             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1064 
1065             uint256 updatedIndex = startTokenId;
1066             uint256 end = updatedIndex + quantity;
1067 
1068             if (safe && to.isContract()) {
1069                 do {
1070                     emit Transfer(address(0), to, updatedIndex);
1071                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1072                         revert TransferToNonERC721ReceiverImplementer();
1073                     }
1074                 } while (updatedIndex != end);
1075                 // Reentrancy protection
1076                 if (_currentIndex != startTokenId) revert();
1077             } else {
1078                 do {
1079                     emit Transfer(address(0), to, updatedIndex++);
1080                 } while (updatedIndex != end);
1081             }
1082             _currentIndex = updatedIndex;
1083         }
1084         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1085     }
1086 
1087     /**
1088      * @dev Transfers `tokenId` from `from` to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `tokenId` token must be owned by `from`.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _transfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) private {
1102         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1103 
1104         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1105 
1106         bool isApprovedOrOwner = (_msgSender() == from ||
1107             isApprovedForAll(from, _msgSender()) ||
1108             getApproved(tokenId) == _msgSender());
1109 
1110         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1111         if (to == address(0)) revert TransferToZeroAddress();
1112 
1113         _beforeTokenTransfers(from, to, tokenId, 1);
1114 
1115         // Clear approvals from the previous owner
1116         _approve(address(0), tokenId, from);
1117 
1118         // Underflow of the sender's balance is impossible because we check for
1119         // ownership above and the recipient's balance can't realistically overflow.
1120         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1121         unchecked {
1122             _addressData[from].balance -= 1;
1123             _addressData[to].balance += 1;
1124 
1125             TokenOwnership storage currSlot = _ownerships[tokenId];
1126             currSlot.addr = to;
1127             currSlot.startTimestamp = uint64(block.timestamp);
1128 
1129             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1130             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1131             uint256 nextTokenId = tokenId + 1;
1132             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1133             if (nextSlot.addr == address(0)) {
1134                 // This will suffice for checking _exists(nextTokenId),
1135                 // as a burned slot cannot contain the zero address.
1136                 if (nextTokenId != _currentIndex) {
1137                     nextSlot.addr = from;
1138                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1139                 }
1140             }
1141         }
1142 
1143         emit Transfer(from, to, tokenId);
1144         _afterTokenTransfers(from, to, tokenId, 1);
1145     }
1146 
1147     /**
1148      * @dev This is equivalent to _burn(tokenId, false)
1149      */
1150     function _burn(uint256 tokenId) internal virtual {
1151         _burn(tokenId, false);
1152     }
1153 
1154     /**
1155      * @dev Destroys `tokenId`.
1156      * The approval is cleared when the token is burned.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must exist.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1165         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1166 
1167         address from = prevOwnership.addr;
1168 
1169         if (approvalCheck) {
1170             bool isApprovedOrOwner = (_msgSender() == from ||
1171                 isApprovedForAll(from, _msgSender()) ||
1172                 getApproved(tokenId) == _msgSender());
1173 
1174             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1175         }
1176 
1177         _beforeTokenTransfers(from, address(0), tokenId, 1);
1178 
1179         // Clear approvals from the previous owner
1180         _approve(address(0), tokenId, from);
1181 
1182         // Underflow of the sender's balance is impossible because we check for
1183         // ownership above and the recipient's balance can't realistically overflow.
1184         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1185         unchecked {
1186             AddressData storage addressData = _addressData[from];
1187             addressData.balance -= 1;
1188             addressData.numberBurned += 1;
1189 
1190             // Keep track of who burned the token, and the timestamp of burning.
1191             TokenOwnership storage currSlot = _ownerships[tokenId];
1192             currSlot.addr = from;
1193             currSlot.startTimestamp = uint64(block.timestamp);
1194             currSlot.burned = true;
1195 
1196             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1197             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1198             uint256 nextTokenId = tokenId + 1;
1199             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1200             if (nextSlot.addr == address(0)) {
1201                 // This will suffice for checking _exists(nextTokenId),
1202                 // as a burned slot cannot contain the zero address.
1203                 if (nextTokenId != _currentIndex) {
1204                     nextSlot.addr = from;
1205                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1206                 }
1207             }
1208         }
1209 
1210         emit Transfer(from, address(0), tokenId);
1211         _afterTokenTransfers(from, address(0), tokenId, 1);
1212 
1213         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1214         unchecked {
1215             _burnCounter++;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Approve `to` to operate on `tokenId`
1221      *
1222      * Emits a {Approval} event.
1223      */
1224     function _approve(
1225         address to,
1226         uint256 tokenId,
1227         address owner
1228     ) private {
1229         _tokenApprovals[tokenId] = to;
1230         emit Approval(owner, to, tokenId);
1231     }
1232 
1233     /**
1234      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1235      *
1236      * @param from address representing the previous owner of the given token ID
1237      * @param to target address that will receive the tokens
1238      * @param tokenId uint256 ID of the token to be transferred
1239      * @param _data bytes optional data to send along with the call
1240      * @return bool whether the call correctly returned the expected magic value
1241      */
1242     function _checkContractOnERC721Received(
1243         address from,
1244         address to,
1245         uint256 tokenId,
1246         bytes memory _data
1247     ) private returns (bool) {
1248         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1249             return retval == IERC721Receiver(to).onERC721Received.selector;
1250         } catch (bytes memory reason) {
1251             if (reason.length == 0) {
1252                 revert TransferToNonERC721ReceiverImplementer();
1253             } else {
1254                 assembly {
1255                     revert(add(32, reason), mload(reason))
1256                 }
1257             }
1258         }
1259     }
1260 
1261     /**
1262      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1263      * And also called before burning one token.
1264      *
1265      * startTokenId - the first token id to be transferred
1266      * quantity - the amount to be transferred
1267      *
1268      * Calling conditions:
1269      *
1270      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1271      * transferred to `to`.
1272      * - When `from` is zero, `tokenId` will be minted for `to`.
1273      * - When `to` is zero, `tokenId` will be burned by `from`.
1274      * - `from` and `to` are never both zero.
1275      */
1276     function _beforeTokenTransfers(
1277         address from,
1278         address to,
1279         uint256 startTokenId,
1280         uint256 quantity
1281     ) internal virtual {}
1282 
1283     /**
1284      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1285      * minting.
1286      * And also called after one token has been burned.
1287      *
1288      * startTokenId - the first token id to be transferred
1289      * quantity - the amount to be transferred
1290      *
1291      * Calling conditions:
1292      *
1293      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1294      * transferred to `to`.
1295      * - When `from` is zero, `tokenId` has been minted for `to`.
1296      * - When `to` is zero, `tokenId` has been burned by `from`.
1297      * - `from` and `to` are never both zero.
1298      */
1299     function _afterTokenTransfers(
1300         address from,
1301         address to,
1302         uint256 startTokenId,
1303         uint256 quantity
1304     ) internal virtual {}
1305 }
1306 // File: Dogearmy.sol
1307 
1308 
1309 pragma solidity ^0.8.0;
1310 
1311 
1312 
1313 
1314 contract DogeArmy is ERC721A, Ownable {
1315     using Strings for uint256;
1316     
1317     string public baseURI;
1318     string public baseExtension = ".json";
1319     uint256 public mintRate = 0.02 ether;
1320     bool public paused = true;
1321     uint256 public maxSupply = 10000;
1322     uint256 public maxFreeMint = 1;
1323     uint256 public maxPerWallet = 5;
1324 
1325     mapping(address => uint256) public freeMintClaimed;
1326 
1327     constructor(string memory _initBaseURI) ERC721A("Doge Army", "DA") {
1328         setBaseURI(_initBaseURI);
1329         _safeMint(msg.sender, 503);
1330     }
1331 
1332     function mint(uint256 quantity) external payable {
1333         uint256 supply = totalSupply();
1334         require(!paused, "The contract is paused!");
1335         require(quantity > 0, "Quantity Must Be Higher Than Zero");
1336         require(supply + quantity <= maxSupply, "Max Supply Reached");
1337         require(quantity <= maxPerWallet, "Max limit exceed!");
1338         require(balanceOf(msg.sender) + quantity <= maxPerWallet, "Max NFT minted");
1339 
1340         if (msg.sender != owner()) {
1341             require(msg.value >= mintRate * quantity, "Insufficient Funds");
1342         }
1343         _safeMint(msg.sender, quantity);
1344     }
1345 
1346     function freeMint(uint256 quantity) external payable {
1347         uint256 supply = totalSupply();
1348         require(!paused, "The contract is paused!");
1349         require(quantity > 0, "Quantity Must Be Higher Than Zero");
1350         require(quantity <= maxFreeMint, "Max limit exceed!");
1351         require(freeMintClaimed[msg.sender] + quantity <= maxFreeMint, "Already claimed free mint!");
1352         require(supply + quantity <= maxSupply, "Max Supply Reached");
1353         _safeMint(msg.sender, quantity);
1354         freeMintClaimed[msg.sender]++;
1355     }
1356 
1357     // internal
1358     function _baseURI() internal view virtual override returns (string memory) {
1359         return baseURI;
1360     }
1361 
1362     // Tokne URI using ID
1363     function tokenURI(uint256 tokenId)
1364         public
1365         view
1366         virtual
1367         override
1368         returns (string memory)
1369     {
1370         require(
1371             _exists(tokenId),
1372             "ERC721Metadata: URI query for nonexistent token"
1373         );
1374 
1375         string memory currentBaseURI = _baseURI();
1376         return
1377             bytes(currentBaseURI).length > 0
1378                 ? string(
1379                     abi.encodePacked(
1380                         currentBaseURI,
1381                         tokenId.toString(),
1382                         baseExtension
1383                     )
1384                 )
1385                 : "";
1386     }
1387 
1388     // Set mint cost
1389     function setCost(uint256 _cost)
1390         public
1391         onlyOwner
1392     {
1393         mintRate = _cost;
1394     }
1395 
1396     // Set free mint limit
1397     function SetMaxFreeMint(uint256 _amount) public onlyOwner {
1398         maxFreeMint = _amount;
1399     }
1400 
1401     // Set free mint limit
1402     function SetMaxPerWallet(uint256 _amount) public onlyOwner {
1403         maxPerWallet = _amount;
1404     }
1405 
1406     // Change suppy number
1407     function setMaxSuppy(uint256 _amount) public onlyOwner {
1408         maxSupply = _amount;
1409     }
1410 
1411     // Change mint state
1412     // false -> active
1413     // true --> inactive
1414     function flipMintState() public onlyOwner {
1415         paused = !paused;
1416     }
1417 
1418     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1419         baseURI = _newBaseURI;
1420     }
1421 
1422     function airdropNFTs(uint256 quantity, address _address) public onlyOwner {
1423         uint256 supply = totalSupply();
1424         require(supply + quantity <= maxSupply, "Max Supply Reached");
1425         _safeMint(_address, quantity);
1426     }
1427 
1428     function setBaseExtension(string memory _newBaseExtension)
1429         public
1430         onlyOwner
1431     {
1432         baseExtension = _newBaseExtension;
1433     }
1434 
1435     function withdraw() public onlyOwner {
1436         (bool ts, ) = payable(owner()).call{value: address(this).balance}("");
1437         require(ts);
1438     }
1439 }