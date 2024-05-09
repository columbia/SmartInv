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
710 // File: ERC721A.sol
711 
712 
713 // Creator: Chiru Labs
714 
715 pragma solidity ^0.8.4;
716 
717 
718 
719 
720 
721 
722 
723 
724 
725 error ApprovalCallerNotOwnerNorApproved();
726 error ApprovalQueryForNonexistentToken();
727 error ApproveToCaller();
728 error ApprovalToCurrentOwner();
729 error BalanceQueryForZeroAddress();
730 error MintedQueryForZeroAddress();
731 error BurnedQueryForZeroAddress();
732 error AuxQueryForZeroAddress();
733 error MintToZeroAddress();
734 error MintZeroQuantity();
735 error OwnerIndexOutOfBounds();
736 error OwnerQueryForNonexistentToken();
737 error TokenIndexOutOfBounds();
738 error TransferCallerNotOwnerNorApproved();
739 error TransferFromIncorrectOwner();
740 error TransferToNonERC721ReceiverImplementer();
741 error TransferToZeroAddress();
742 error URIQueryForNonexistentToken();
743 
744 /**
745  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
746  * the Metadata extension. Built to optimize for lower gas during batch mints.
747  *
748  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
749  *
750  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
751  *
752  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
753  */
754 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
755     using Address for address;
756     using Strings for uint256;
757 
758     // Compiler will pack this into a single 256bit word.
759     struct TokenOwnership {
760         // The address of the owner.
761         address addr;
762         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
763         uint64 startTimestamp;
764         // Whether the token has been burned.
765         bool burned;
766     }
767 
768     // Compiler will pack this into a single 256bit word.
769     struct AddressData {
770         // Realistically, 2**64-1 is more than enough.
771         uint64 balance;
772         // Keeps track of mint count with minimal overhead for tokenomics.
773         uint64 numberMinted;
774         // Keeps track of burn count with minimal overhead for tokenomics.
775         uint64 numberBurned;
776         // For miscellaneous variable(s) pertaining to the address
777         // (e.g. number of whitelist mint slots used).
778         // If there are multiple variables, please pack them into a uint64.
779         uint64 aux;
780     }
781 
782     // The tokenId of the next token to be minted.
783     uint256 internal _currentIndex;
784 
785     // The number of tokens burned.
786     uint256 internal _burnCounter;
787 
788     // Token name
789     string private _name;
790 
791     // Token symbol
792     string private _symbol;
793 
794     // Mapping from token ID to ownership details
795     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
796     mapping(uint256 => TokenOwnership) internal _ownerships;
797 
798     // Mapping owner address to address data
799     mapping(address => AddressData) private _addressData;
800 
801     // Mapping from token ID to approved address
802     mapping(uint256 => address) private _tokenApprovals;
803 
804     // Mapping from owner to operator approvals
805     mapping(address => mapping(address => bool)) private _operatorApprovals;
806 
807     constructor(string memory name_, string memory symbol_) {
808         _name = name_;
809         _symbol = symbol_;
810         _currentIndex = _startTokenId();
811     }
812 
813     /**
814      * To change the starting tokenId, please override this function.
815      */
816     function _startTokenId() internal view virtual returns (uint256) {
817         return 0;
818     }
819 
820     /**
821      * @dev See {IERC721Enumerable-totalSupply}.
822      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
823      */
824     function totalSupply() public view returns (uint256) {
825         // Counter underflow is impossible as _burnCounter cannot be incremented
826         // more than _currentIndex - _startTokenId() times
827         unchecked {
828             return _currentIndex - _burnCounter - _startTokenId();
829         }
830     }
831 
832     /**
833      * Returns the total amount of tokens minted in the contract.
834      */
835     function _totalMinted() internal view returns (uint256) {
836         // Counter underflow is impossible as _currentIndex does not decrement,
837         // and it is initialized to _startTokenId()
838         unchecked {
839             return _currentIndex - _startTokenId();
840         }
841     }
842 
843     /**
844      * @dev See {IERC165-supportsInterface}.
845      */
846     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
847         return
848             interfaceId == type(IERC721).interfaceId ||
849             interfaceId == type(IERC721Metadata).interfaceId ||
850             super.supportsInterface(interfaceId);
851     }
852 
853     /**
854      * @dev See {IERC721-balanceOf}.
855      */
856     function balanceOf(address owner) public view override returns (uint256) {
857         if (owner == address(0)) revert BalanceQueryForZeroAddress();
858         return uint256(_addressData[owner].balance);
859     }
860 
861     /**
862      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
863      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
864      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
865      */
866     function tokenOfOwnerByIndex(address owner) public view returns (uint[] memory){
867         uint tokenCount = balanceOf(owner); 
868         uint256 numMintedSoFar = totalSupply();
869         uint256 tokenIdsIdx = 0;
870         address currOwnershipAddr = address(0);
871         uint[] memory tokensId = new uint256[](tokenCount);
872         for (uint256 i = 0; i < numMintedSoFar; i++) {
873             TokenOwnership memory ownership = _ownerships[i];
874             if (ownership.addr != address(0)) {
875                 currOwnershipAddr = ownership.addr;
876             }
877             if (currOwnershipAddr == owner) {
878                 tokensId[tokenIdsIdx] = i;
879                 tokenIdsIdx++;
880             }
881         }
882         // revert("ERC721A: unable to get token of owner by index");
883         return tokensId;
884     }
885 
886     /**
887      * Returns the number of tokens minted by `owner`.
888      */
889     function _numberMinted(address owner) internal view returns (uint256) {
890         if (owner == address(0)) revert MintedQueryForZeroAddress();
891         return uint256(_addressData[owner].numberMinted);
892     }
893 
894     /**
895      * Returns the number of tokens burned by or on behalf of `owner`.
896      */
897     function _numberBurned(address owner) internal view returns (uint256) {
898         if (owner == address(0)) revert BurnedQueryForZeroAddress();
899         return uint256(_addressData[owner].numberBurned);
900     }
901 
902     /**
903      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
904      */
905     function _getAux(address owner) internal view returns (uint64) {
906         if (owner == address(0)) revert AuxQueryForZeroAddress();
907         return _addressData[owner].aux;
908     }
909 
910     /**
911      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
912      * If there are multiple variables, please pack them into a uint64.
913      */
914     function _setAux(address owner, uint64 aux) internal {
915         if (owner == address(0)) revert AuxQueryForZeroAddress();
916         _addressData[owner].aux = aux;
917     }
918 
919     /**
920      * Gas spent here starts off proportional to the maximum mint batch size.
921      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
922      */
923     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
924         uint256 curr = tokenId;
925 
926         unchecked {
927             if (_startTokenId() <= curr && curr < _currentIndex) {
928                 TokenOwnership memory ownership = _ownerships[curr];
929                 if (!ownership.burned) {
930                     if (ownership.addr != address(0)) {
931                         return ownership;
932                     }
933                     // Invariant:
934                     // There will always be an ownership that has an address and is not burned
935                     // before an ownership that does not have an address and is not burned.
936                     // Hence, curr will not underflow.
937                     while (true) {
938                         curr--;
939                         ownership = _ownerships[curr];
940                         if (ownership.addr != address(0)) {
941                             return ownership;
942                         }
943                     }
944                 }
945             }
946         }
947         revert OwnerQueryForNonexistentToken();
948     }
949 
950     /**
951      * @dev See {IERC721-ownerOf}.
952      */
953     function ownerOf(uint256 tokenId) public view override returns (address) {
954         return ownershipOf(tokenId).addr;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-name}.
959      */
960     function name() public view virtual override returns (string memory) {
961         return _name;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-symbol}.
966      */
967     function symbol() public view virtual override returns (string memory) {
968         return _symbol;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-tokenURI}.
973      */
974     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
975         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
976 
977         string memory baseURI = _baseURI();
978         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
979     }
980 
981     /**
982      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
983      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
984      * by default, can be overriden in child contracts.
985      */
986     function _baseURI() internal view virtual returns (string memory) {
987         return '';
988     }
989 
990     /**
991      * @dev See {IERC721-approve}.
992      */
993     function approve(address to, uint256 tokenId) public override {
994         address owner = ERC721A.ownerOf(tokenId);
995         if (to == owner) revert ApprovalToCurrentOwner();
996 
997         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
998             revert ApprovalCallerNotOwnerNorApproved();
999         }
1000 
1001         _approve(to, tokenId, owner);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-getApproved}.
1006      */
1007     function getApproved(uint256 tokenId) public view override returns (address) {
1008         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1009 
1010         return _tokenApprovals[tokenId];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-setApprovalForAll}.
1015      */
1016     function setApprovalForAll(address operator, bool approved) public override {
1017         if (operator == _msgSender()) revert ApproveToCaller();
1018 
1019         _operatorApprovals[_msgSender()][operator] = approved;
1020         emit ApprovalForAll(_msgSender(), operator, approved);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-isApprovedForAll}.
1025      */
1026     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1027         return _operatorApprovals[owner][operator];
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-transferFrom}.
1032      */
1033     function transferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) public virtual override {
1038         _transfer(from, to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-safeTransferFrom}.
1043      */
1044     function safeTransferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) public virtual override {
1049         safeTransferFrom(from, to, tokenId, '');
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-safeTransferFrom}.
1054      */
1055     function safeTransferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) public virtual override {
1061         _transfer(from, to, tokenId);
1062         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1063             revert TransferToNonERC721ReceiverImplementer();
1064         }
1065     }
1066 
1067     /**
1068      * @dev Returns whether `tokenId` exists.
1069      *
1070      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1071      *
1072      * Tokens start existing when they are minted (`_mint`),
1073      */
1074     function _exists(uint256 tokenId) internal view returns (bool) {
1075         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1076             !_ownerships[tokenId].burned;
1077     }
1078 
1079     function _safeMint(address to, uint256 quantity) internal {
1080         _safeMint(to, quantity, '');
1081     }
1082 
1083     /**
1084      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _safeMint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data
1097     ) internal {
1098         _mint(to, quantity, _data, true);
1099     }
1100 
1101     /**
1102      * @dev Mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - `to` cannot be the zero address.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _mint(
1112         address to,
1113         uint256 quantity,
1114         bytes memory _data,
1115         bool safe
1116     ) internal {
1117         uint256 startTokenId = _currentIndex;
1118         if (to == address(0)) revert MintToZeroAddress();
1119         if (quantity == 0) revert MintZeroQuantity();
1120 
1121         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1122 
1123         // Overflows are incredibly unrealistic.
1124         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1125         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1126         unchecked {
1127             _addressData[to].balance += uint64(quantity);
1128             _addressData[to].numberMinted += uint64(quantity);
1129 
1130             _ownerships[startTokenId].addr = to;
1131             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1132 
1133             uint256 updatedIndex = startTokenId;
1134             uint256 end = updatedIndex + quantity;
1135 
1136             if (safe && to.isContract()) {
1137                 do {
1138                     emit Transfer(address(0), to, updatedIndex);
1139                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1140                         revert TransferToNonERC721ReceiverImplementer();
1141                     }
1142                 } while (updatedIndex != end);
1143                 // Reentrancy protection
1144                 if (_currentIndex != startTokenId) revert();
1145             } else {
1146                 do {
1147                     emit Transfer(address(0), to, updatedIndex++);
1148                 } while (updatedIndex != end);
1149             }
1150             _currentIndex = updatedIndex;
1151         }
1152         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1153     }
1154 
1155     /**
1156      * @dev Transfers `tokenId` from `from` to `to`.
1157      *
1158      * Requirements:
1159      *
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must be owned by `from`.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _transfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) private {
1170         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1171 
1172         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1173             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1174             getApproved(tokenId) == _msgSender());
1175 
1176         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1177         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1178         if (to == address(0)) revert TransferToZeroAddress();
1179 
1180         _beforeTokenTransfers(from, to, tokenId, 1);
1181 
1182         // Clear approvals from the previous owner
1183         _approve(address(0), tokenId, prevOwnership.addr);
1184 
1185         // Underflow of the sender's balance is impossible because we check for
1186         // ownership above and the recipient's balance can't realistically overflow.
1187         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1188         unchecked {
1189             _addressData[from].balance -= 1;
1190             _addressData[to].balance += 1;
1191 
1192             _ownerships[tokenId].addr = to;
1193             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1194 
1195             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1196             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1197             uint256 nextTokenId = tokenId + 1;
1198             if (_ownerships[nextTokenId].addr == address(0)) {
1199                 // This will suffice for checking _exists(nextTokenId),
1200                 // as a burned slot cannot contain the zero address.
1201                 if (nextTokenId < _currentIndex) {
1202                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1203                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1204                 }
1205             }
1206         }
1207 
1208         emit Transfer(from, to, tokenId);
1209         _afterTokenTransfers(from, to, tokenId, 1);
1210     }
1211 
1212     /**
1213      * @dev Destroys `tokenId`.
1214      * The approval is cleared when the token is burned.
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must exist.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _burn(uint256 tokenId) internal virtual {
1223         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1224 
1225         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1226 
1227         // Clear approvals from the previous owner
1228         _approve(address(0), tokenId, prevOwnership.addr);
1229 
1230         // Underflow of the sender's balance is impossible because we check for
1231         // ownership above and the recipient's balance can't realistically overflow.
1232         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1233         unchecked {
1234             _addressData[prevOwnership.addr].balance -= 1;
1235             _addressData[prevOwnership.addr].numberBurned += 1;
1236 
1237             // Keep track of who burned the token, and the timestamp of burning.
1238             _ownerships[tokenId].addr = prevOwnership.addr;
1239             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1240             _ownerships[tokenId].burned = true;
1241 
1242             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1243             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1244             uint256 nextTokenId = tokenId + 1;
1245             if (_ownerships[nextTokenId].addr == address(0)) {
1246                 // This will suffice for checking _exists(nextTokenId),
1247                 // as a burned slot cannot contain the zero address.
1248                 if (nextTokenId < _currentIndex) {
1249                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1250                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1251                 }
1252             }
1253         }
1254 
1255         emit Transfer(prevOwnership.addr, address(0), tokenId);
1256         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1257 
1258         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1259         unchecked {
1260             _burnCounter++;
1261         }
1262     }
1263 
1264     /**
1265      * @dev Approve `to` to operate on `tokenId`
1266      *
1267      * Emits a {Approval} event.
1268      */
1269     function _approve(
1270         address to,
1271         uint256 tokenId,
1272         address owner
1273     ) private {
1274         _tokenApprovals[tokenId] = to;
1275         emit Approval(owner, to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1280      *
1281      * @param from address representing the previous owner of the given token ID
1282      * @param to target address that will receive the tokens
1283      * @param tokenId uint256 ID of the token to be transferred
1284      * @param _data bytes optional data to send along with the call
1285      * @return bool whether the call correctly returned the expected magic value
1286      */
1287     function _checkContractOnERC721Received(
1288         address from,
1289         address to,
1290         uint256 tokenId,
1291         bytes memory _data
1292     ) private returns (bool) {
1293         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1294             return retval == IERC721Receiver(to).onERC721Received.selector;
1295         } catch (bytes memory reason) {
1296             if (reason.length == 0) {
1297                 revert TransferToNonERC721ReceiverImplementer();
1298             } else {
1299                 assembly {
1300                     revert(add(32, reason), mload(reason))
1301                 }
1302             }
1303         }
1304     }
1305 
1306     /**
1307      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1308      * And also called before burning one token.
1309      *
1310      * startTokenId - the first token id to be transferred
1311      * quantity - the amount to be transferred
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` will be minted for `to`.
1318      * - When `to` is zero, `tokenId` will be burned by `from`.
1319      * - `from` and `to` are never both zero.
1320      */
1321     function _beforeTokenTransfers(
1322         address from,
1323         address to,
1324         uint256 startTokenId,
1325         uint256 quantity
1326     ) internal virtual {}
1327 
1328     /**
1329      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1330      * minting.
1331      * And also called after one token has been burned.
1332      *
1333      * startTokenId - the first token id to be transferred
1334      * quantity - the amount to be transferred
1335      *
1336      * Calling conditions:
1337      *
1338      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1339      * transferred to `to`.
1340      * - When `from` is zero, `tokenId` has been minted for `to`.
1341      * - When `to` is zero, `tokenId` has been burned by `from`.
1342      * - `from` and `to` are never both zero.
1343      */
1344     function _afterTokenTransfers(
1345         address from,
1346         address to,
1347         uint256 startTokenId,
1348         uint256 quantity
1349     ) internal virtual {}
1350 
1351     
1352 }
1353 // File: Contract.sol
1354 
1355 
1356 pragma solidity ^0.8.0;
1357 
1358 
1359 contract CryptoKungfu is ERC721A, Ownable {
1360     uint256 public immutable cost = 0.009 ether;
1361     uint32 public immutable maxMint = 10;
1362     uint32 public MAXSUPPLY = 5000;
1363     bool public started = true;
1364     mapping(address => bool) public freeClaimed;
1365     string  public baseURI;
1366 
1367     constructor()
1368     ERC721A ("CryptoKungfu", "CKF") {
1369         _safeMint(msg.sender, 1);
1370     }
1371 
1372     function _baseURI() internal view override(ERC721A) returns (string memory) {
1373         return baseURI;
1374     }
1375 
1376     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1377         return 0;
1378     }
1379 
1380     function setBaseURI(string memory uri) public onlyOwner {
1381         baseURI = uri;
1382     }
1383 
1384     function mint(uint32 amount) public payable {
1385         require(tx.origin == msg.sender, "pls don't use contract call");
1386         require(started,"not yet started");
1387         require(totalSupply() + amount <= MAXSUPPLY,"sold out");
1388         require(amount <= maxMint,"max 10 amount");
1389         if(freeClaimed[msg.sender])
1390         {
1391             require(msg.value >= amount * cost,"insufficient");
1392         }
1393         else 
1394         {
1395             freeClaimed[msg.sender] = true;
1396             require(msg.value >= (amount-1) * cost,"insufficient");
1397         }
1398         _safeMint(msg.sender, amount);
1399     }
1400 
1401     function enableMint(bool mintStarted) external onlyOwner {
1402       started = mintStarted;
1403     }
1404 
1405     function getMintedFree(address addr) public view returns (bool){
1406         return freeClaimed[addr];
1407     }
1408 
1409     function setMaxSupply(uint32 max) external onlyOwner {
1410         MAXSUPPLY = max;
1411     }
1412 
1413     function withdraw() public onlyOwner {
1414         (bool success, ) = payable(msg.sender).call{
1415             value: address(this).balance
1416         }("");
1417         require(success, "failed");
1418     }
1419 }