1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
30 
31 
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _transferOwnership(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _transferOwnership(newOwner);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Internal function without access restriction.
95      */
96     function _transferOwnership(address newOwner) internal virtual {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 
104 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
105 
106 
107 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
108 
109 
110 
111 /**
112  * @dev Interface of the ERC165 standard, as defined in the
113  * https://eips.ethereum.org/EIPS/eip-165[EIP].
114  *
115  * Implementers can declare support of contract interfaces, which can then be
116  * queried by others ({ERC165Checker}).
117  *
118  * For an implementation, see {ERC165}.
119  */
120 interface IERC165 {
121     /**
122      * @dev Returns true if this contract implements the interface defined by
123      * `interfaceId`. See the corresponding
124      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
125      * to learn more about how these ids are created.
126      *
127      * This function call must use less than 30 000 gas.
128      */
129     function supportsInterface(bytes4 interfaceId) external view returns (bool);
130 }
131 
132 
133 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
134 
135 
136 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
137 
138 
139 
140 /**
141  * @dev Required interface of an ERC721 compliant contract.
142  */
143 interface IERC721 is IERC165 {
144     /**
145      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
146      */
147     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
148 
149     /**
150      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
151      */
152     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
153 
154     /**
155      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
156      */
157     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
158 
159     /**
160      * @dev Returns the number of tokens in ``owner``'s account.
161      */
162     function balanceOf(address owner) external view returns (uint256 balance);
163 
164     /**
165      * @dev Returns the owner of the `tokenId` token.
166      *
167      * Requirements:
168      *
169      * - `tokenId` must exist.
170      */
171     function ownerOf(uint256 tokenId) external view returns (address owner);
172 
173     /**
174      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
175      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external;
192 
193     /**
194      * @dev Transfers `tokenId` token from `from` to `to`.
195      *
196      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
197      *
198      * Requirements:
199      *
200      * - `from` cannot be the zero address.
201      * - `to` cannot be the zero address.
202      * - `tokenId` token must be owned by `from`.
203      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     /**
214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
215      * The approval is cleared when the token is transferred.
216      *
217      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
218      *
219      * Requirements:
220      *
221      * - The caller must own the token or be an approved operator.
222      * - `tokenId` must exist.
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address to, uint256 tokenId) external;
227 
228     /**
229      * @dev Returns the account approved for `tokenId` token.
230      *
231      * Requirements:
232      *
233      * - `tokenId` must exist.
234      */
235     function getApproved(uint256 tokenId) external view returns (address operator);
236 
237     /**
238      * @dev Approve or remove `operator` as an operator for the caller.
239      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
240      *
241      * Requirements:
242      *
243      * - The `operator` cannot be the caller.
244      *
245      * Emits an {ApprovalForAll} event.
246      */
247     function setApprovalForAll(address operator, bool _approved) external;
248 
249     /**
250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
251      *
252      * See {setApprovalForAll}
253      */
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255 
256     /**
257      * @dev Safely transfers `tokenId` token from `from` to `to`.
258      *
259      * Requirements:
260      *
261      * - `from` cannot be the zero address.
262      * - `to` cannot be the zero address.
263      * - `tokenId` token must exist and be owned by `from`.
264      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
265      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
266      *
267      * Emits a {Transfer} event.
268      */
269     function safeTransferFrom(
270         address from,
271         address to,
272         uint256 tokenId,
273         bytes calldata data
274     ) external;
275 }
276 
277 
278 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
282 
283 
284 
285 /**
286  * @title ERC721 token receiver interface
287  * @dev Interface for any contract that wants to support safeTransfers
288  * from ERC721 asset contracts.
289  */
290 interface IERC721Receiver {
291     /**
292      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
293      * by `operator` from `from`, this function is called.
294      *
295      * It must return its Solidity selector to confirm the token transfer.
296      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
297      *
298      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
299      */
300     function onERC721Received(
301         address operator,
302         address from,
303         uint256 tokenId,
304         bytes calldata data
305     ) external returns (bytes4);
306 }
307 
308 
309 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
310 
311 
312 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
313 
314 
315 
316 /**
317  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
318  * @dev See https://eips.ethereum.org/EIPS/eip-721
319  */
320 interface IERC721Metadata is IERC721 {
321     /**
322      * @dev Returns the token collection name.
323      */
324     function name() external view returns (string memory);
325 
326     /**
327      * @dev Returns the token collection symbol.
328      */
329     function symbol() external view returns (string memory);
330 
331     /**
332      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
333      */
334     function tokenURI(uint256 tokenId) external view returns (string memory);
335 }
336 
337 
338 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
339 
340 
341 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
342 
343 
344 
345 /**
346  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
347  * @dev See https://eips.ethereum.org/EIPS/eip-721
348  */
349 interface IERC721Enumerable is IERC721 {
350     /**
351      * @dev Returns the total amount of tokens stored by the contract.
352      */
353     function totalSupply() external view returns (uint256);
354 
355     /**
356      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
357      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
358      */
359     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
360 
361     /**
362      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
363      * Use along with {totalSupply} to enumerate all tokens.
364      */
365     function tokenByIndex(uint256 index) external view returns (uint256);
366 }
367 
368 
369 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
370 
371 
372 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
373 
374 pragma solidity ^0.8.1;
375 
376 /**
377  * @dev Collection of functions related to the address type
378  */
379 library Address {
380     /**
381      * @dev Returns true if `account` is a contract.
382      *
383      * [IMPORTANT]
384      * ====
385      * It is unsafe to assume that an address for which this function returns
386      * false is an externally-owned account (EOA) and not a contract.
387      *
388      * Among others, `isContract` will return false for the following
389      * types of addresses:
390      *
391      *  - an externally-owned account
392      *  - a contract in construction
393      *  - an address where a contract will be created
394      *  - an address where a contract lived, but was destroyed
395      * ====
396      *
397      * [IMPORTANT]
398      * ====
399      * You shouldn't rely on `isContract` to protect against flash loan attacks!
400      *
401      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
402      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
403      * constructor.
404      * ====
405      */
406     function isContract(address account) internal view returns (bool) {
407         // This method relies on extcodesize/address.code.length, which returns 0
408         // for contracts in construction, since the code is only stored at the end
409         // of the constructor execution.
410 
411         return account.code.length > 0;
412     }
413 
414     /**
415      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
416      * `recipient`, forwarding all available gas and reverting on errors.
417      *
418      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
419      * of certain opcodes, possibly making contracts go over the 2300 gas limit
420      * imposed by `transfer`, making them unable to receive funds via
421      * `transfer`. {sendValue} removes this limitation.
422      *
423      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
424      *
425      * IMPORTANT: because control is transferred to `recipient`, care must be
426      * taken to not create reentrancy vulnerabilities. Consider using
427      * {ReentrancyGuard} or the
428      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
429      */
430     function sendValue(address payable recipient, uint256 amount) internal {
431         require(address(this).balance >= amount, "Address: insufficient balance");
432 
433         (bool success, ) = recipient.call{value: amount}("");
434         require(success, "Address: unable to send value, recipient may have reverted");
435     }
436 
437     /**
438      * @dev Performs a Solidity function call using a low level `call`. A
439      * plain `call` is an unsafe replacement for a function call: use this
440      * function instead.
441      *
442      * If `target` reverts with a revert reason, it is bubbled up by this
443      * function (like regular Solidity function calls).
444      *
445      * Returns the raw returned data. To convert to the expected return value,
446      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
447      *
448      * Requirements:
449      *
450      * - `target` must be a contract.
451      * - calling `target` with `data` must not revert.
452      *
453      * _Available since v3.1._
454      */
455     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
456         return functionCall(target, data, "Address: low-level call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
461      * `errorMessage` as a fallback revert reason when `target` reverts.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal returns (bytes memory) {
470         return functionCallWithValue(target, data, 0, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but also transferring `value` wei to `target`.
476      *
477      * Requirements:
478      *
479      * - the calling contract must have an ETH balance of at least `value`.
480      * - the called Solidity function must be `payable`.
481      *
482      * _Available since v3.1._
483      */
484     function functionCallWithValue(
485         address target,
486         bytes memory data,
487         uint256 value
488     ) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
494      * with `errorMessage` as a fallback revert reason when `target` reverts.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(
499         address target,
500         bytes memory data,
501         uint256 value,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         require(address(this).balance >= value, "Address: insufficient balance for call");
505         require(isContract(target), "Address: call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.call{value: value}(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but performing a static call.
514      *
515      * _Available since v3.3._
516      */
517     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
518         return functionStaticCall(target, data, "Address: low-level static call failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
523      * but performing a static call.
524      *
525      * _Available since v3.3._
526      */
527     function functionStaticCall(
528         address target,
529         bytes memory data,
530         string memory errorMessage
531     ) internal view returns (bytes memory) {
532         require(isContract(target), "Address: static call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.staticcall(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but performing a delegate call.
541      *
542      * _Available since v3.4._
543      */
544     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
545         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
550      * but performing a delegate call.
551      *
552      * _Available since v3.4._
553      */
554     function functionDelegateCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal returns (bytes memory) {
559         require(isContract(target), "Address: delegate call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.delegatecall(data);
562         return verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
567      * revert reason using the provided one.
568      *
569      * _Available since v4.3._
570      */
571     function verifyCallResult(
572         bool success,
573         bytes memory returndata,
574         string memory errorMessage
575     ) internal pure returns (bytes memory) {
576         if (success) {
577             return returndata;
578         } else {
579             // Look for revert reason and bubble it up if present
580             if (returndata.length > 0) {
581                 // The easiest way to bubble the revert reason is using memory via assembly
582 
583                 assembly {
584                     let returndata_size := mload(returndata)
585                     revert(add(32, returndata), returndata_size)
586                 }
587             } else {
588                 revert(errorMessage);
589             }
590         }
591     }
592 }
593 
594 
595 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
596 
597 
598 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
599 
600 
601 
602 /**
603  * @dev String operations.
604  */
605 library Strings {
606     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
607 
608     /**
609      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
610      */
611     function toString(uint256 value) internal pure returns (string memory) {
612         // Inspired by OraclizeAPI's implementation - MIT licence
613         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
614 
615         if (value == 0) {
616             return "0";
617         }
618         uint256 temp = value;
619         uint256 digits;
620         while (temp != 0) {
621             digits++;
622             temp /= 10;
623         }
624         bytes memory buffer = new bytes(digits);
625         while (value != 0) {
626             digits -= 1;
627             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
628             value /= 10;
629         }
630         return string(buffer);
631     }
632 
633     /**
634      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
635      */
636     function toHexString(uint256 value) internal pure returns (string memory) {
637         if (value == 0) {
638             return "0x00";
639         }
640         uint256 temp = value;
641         uint256 length = 0;
642         while (temp != 0) {
643             length++;
644             temp >>= 8;
645         }
646         return toHexString(value, length);
647     }
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
651      */
652     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
653         bytes memory buffer = new bytes(2 * length + 2);
654         buffer[0] = "0";
655         buffer[1] = "x";
656         for (uint256 i = 2 * length + 1; i > 1; --i) {
657             buffer[i] = _HEX_SYMBOLS[value & 0xf];
658             value >>= 4;
659         }
660         require(value == 0, "Strings: hex length insufficient");
661         return string(buffer);
662     }
663 }
664 
665 
666 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
670 
671 
672 
673 /**
674  * @dev Implementation of the {IERC165} interface.
675  *
676  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
677  * for the additional interface id that will be supported. For example:
678  *
679  * ```solidity
680  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
681  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
682  * }
683  * ```
684  *
685  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
686  */
687 abstract contract ERC165 is IERC165 {
688     /**
689      * @dev See {IERC165-supportsInterface}.
690      */
691     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
692         return interfaceId == type(IERC165).interfaceId;
693     }
694 }
695 
696 
697 // File erc721a/contracts/ERC721A.sol@v3.0.0
698 
699 
700 // Creator: Chiru Labs
701 
702 error ApprovalCallerNotOwnerNorApproved();
703 error ApprovalQueryForNonexistentToken();
704 error ApproveToCaller();
705 error ApprovalToCurrentOwner();
706 error BalanceQueryForZeroAddress();
707 error MintedQueryForZeroAddress();
708 error BurnedQueryForZeroAddress();
709 error AuxQueryForZeroAddress();
710 error MintToZeroAddress();
711 error MintZeroQuantity();
712 error OwnerIndexOutOfBounds();
713 error OwnerQueryForNonexistentToken();
714 error TokenIndexOutOfBounds();
715 error TransferCallerNotOwnerNorApproved();
716 error TransferFromIncorrectOwner();
717 error TransferToNonERC721ReceiverImplementer();
718 error TransferToZeroAddress();
719 error URIQueryForNonexistentToken();
720 
721 /**
722  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
723  * the Metadata extension. Built to optimize for lower gas during batch mints.
724  *
725  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
726  *
727  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
728  *
729  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
730  */
731 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
732     using Address for address;
733     using Strings for uint256;
734 
735     // Compiler will pack this into a single 256bit word.
736     struct TokenOwnership {
737         // The address of the owner.
738         address addr;
739         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
740         uint64 startTimestamp;
741         // Whether the token has been burned.
742         bool burned;
743     }
744 
745     // Compiler will pack this into a single 256bit word.
746     struct AddressData {
747         // Realistically, 2**64-1 is more than enough.
748         uint64 balance;
749         // Keeps track of mint count with minimal overhead for tokenomics.
750         uint64 numberMinted;
751         // Keeps track of burn count with minimal overhead for tokenomics.
752         uint64 numberBurned;
753         // For miscellaneous variable(s) pertaining to the address
754         // (e.g. number of whitelist mint slots used).
755         // If there are multiple variables, please pack them into a uint64.
756         uint64 aux;
757     }
758 
759     // The tokenId of the next token to be minted.
760     uint256 internal _currentIndex;
761 
762     // The number of tokens burned.
763     uint256 internal _burnCounter;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to ownership details
772     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
773     mapping(uint256 => TokenOwnership) internal _ownerships;
774 
775     // Mapping owner address to address data
776     mapping(address => AddressData) private _addressData;
777 
778     // Mapping from token ID to approved address
779     mapping(uint256 => address) private _tokenApprovals;
780 
781     // Mapping from owner to operator approvals
782     mapping(address => mapping(address => bool)) private _operatorApprovals;
783 
784     constructor(string memory name_, string memory symbol_) {
785         _name = name_;
786         _symbol = symbol_;
787         _currentIndex = _startTokenId();
788     }
789 
790     /**
791      * To change the starting tokenId, please override this function.
792      */
793     function _startTokenId() internal view virtual returns (uint256) {
794         return 0;
795     }
796 
797     /**
798      * @dev See {IERC721Enumerable-totalSupply}.
799      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
800      */
801     function totalSupply() public view returns (uint256) {
802         // Counter underflow is impossible as _burnCounter cannot be incremented
803         // more than _currentIndex - _startTokenId() times
804         unchecked {
805             return _currentIndex - _burnCounter - _startTokenId();
806         }
807     }
808 
809     /**
810      * Returns the total amount of tokens minted in the contract.
811      */
812     function _totalMinted() internal view returns (uint256) {
813         // Counter underflow is impossible as _currentIndex does not decrement,
814         // and it is initialized to _startTokenId()
815         unchecked {
816             return _currentIndex - _startTokenId();
817         }
818     }
819 
820     /**
821      * @dev See {IERC165-supportsInterface}.
822      */
823     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
824         return
825             interfaceId == type(IERC721).interfaceId ||
826             interfaceId == type(IERC721Metadata).interfaceId ||
827             super.supportsInterface(interfaceId);
828     }
829 
830     /**
831      * @dev See {IERC721-balanceOf}.
832      */
833     function balanceOf(address owner) public view override returns (uint256) {
834         if (owner == address(0)) revert BalanceQueryForZeroAddress();
835         return uint256(_addressData[owner].balance);
836     }
837 
838     /**
839      * Returns the number of tokens minted by `owner`.
840      */
841     function _numberMinted(address owner) internal view returns (uint256) {
842         if (owner == address(0)) revert MintedQueryForZeroAddress();
843         return uint256(_addressData[owner].numberMinted);
844     }
845 
846     /**
847      * Returns the number of tokens burned by or on behalf of `owner`.
848      */
849     function _numberBurned(address owner) internal view returns (uint256) {
850         if (owner == address(0)) revert BurnedQueryForZeroAddress();
851         return uint256(_addressData[owner].numberBurned);
852     }
853 
854     /**
855      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
856      */
857     function _getAux(address owner) internal view returns (uint64) {
858         if (owner == address(0)) revert AuxQueryForZeroAddress();
859         return _addressData[owner].aux;
860     }
861 
862     /**
863      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
864      * If there are multiple variables, please pack them into a uint64.
865      */
866     function _setAux(address owner, uint64 aux) internal {
867         if (owner == address(0)) revert AuxQueryForZeroAddress();
868         _addressData[owner].aux = aux;
869     }
870 
871     /**
872      * Gas spent here starts off proportional to the maximum mint batch size.
873      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
874      */
875     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
876         uint256 curr = tokenId;
877 
878         unchecked {
879             if (_startTokenId() <= curr && curr < _currentIndex) {
880                 TokenOwnership memory ownership = _ownerships[curr];
881                 if (!ownership.burned) {
882                     if (ownership.addr != address(0)) {
883                         return ownership;
884                     }
885                     // Invariant:
886                     // There will always be an ownership that has an address and is not burned
887                     // before an ownership that does not have an address and is not burned.
888                     // Hence, curr will not underflow.
889                     while (true) {
890                         curr--;
891                         ownership = _ownerships[curr];
892                         if (ownership.addr != address(0)) {
893                             return ownership;
894                         }
895                     }
896                 }
897             }
898         }
899         revert OwnerQueryForNonexistentToken();
900     }
901 
902     /**
903      * @dev See {IERC721-ownerOf}.
904      */
905     function ownerOf(uint256 tokenId) public view override returns (address) {
906         return ownershipOf(tokenId).addr;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-name}.
911      */
912     function name() public view virtual override returns (string memory) {
913         return _name;
914     }
915 
916     /**
917      * @dev See {IERC721Metadata-symbol}.
918      */
919     function symbol() public view virtual override returns (string memory) {
920         return _symbol;
921     }
922 
923     /**
924      * @dev See {IERC721Metadata-tokenURI}.
925      */
926     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
927         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
928 
929         string memory baseURI = _baseURI();
930         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
931     }
932 
933     /**
934      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
935      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
936      * by default, can be overriden in child contracts.
937      */
938     function _baseURI() internal view virtual returns (string memory) {
939         return '';
940     }
941 
942     /**
943      * @dev See {IERC721-approve}.
944      */
945     function approve(address to, uint256 tokenId) public override {
946         address owner = ERC721A.ownerOf(tokenId);
947         if (to == owner) revert ApprovalToCurrentOwner();
948 
949         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
950             revert ApprovalCallerNotOwnerNorApproved();
951         }
952 
953         _approve(to, tokenId, owner);
954     }
955 
956     /**
957      * @dev See {IERC721-getApproved}.
958      */
959     function getApproved(uint256 tokenId) public view override returns (address) {
960         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
961 
962         return _tokenApprovals[tokenId];
963     }
964 
965     /**
966      * @dev See {IERC721-setApprovalForAll}.
967      */
968     function setApprovalForAll(address operator, bool approved) public override {
969         if (operator == _msgSender()) revert ApproveToCaller();
970 
971         _operatorApprovals[_msgSender()][operator] = approved;
972         emit ApprovalForAll(_msgSender(), operator, approved);
973     }
974 
975     /**
976      * @dev See {IERC721-isApprovedForAll}.
977      */
978     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
979         return _operatorApprovals[owner][operator];
980     }
981 
982     /**
983      * @dev See {IERC721-transferFrom}.
984      */
985     function transferFrom(
986         address from,
987         address to,
988         uint256 tokenId
989     ) public virtual override {
990         _transfer(from, to, tokenId);
991     }
992 
993     /**
994      * @dev See {IERC721-safeTransferFrom}.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) public virtual override {
1001         safeTransferFrom(from, to, tokenId, '');
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-safeTransferFrom}.
1006      */
1007     function safeTransferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) public virtual override {
1013         _transfer(from, to, tokenId);
1014         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1015             revert TransferToNonERC721ReceiverImplementer();
1016         }
1017     }
1018 
1019     /**
1020      * @dev Returns whether `tokenId` exists.
1021      *
1022      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1023      *
1024      * Tokens start existing when they are minted (`_mint`),
1025      */
1026     function _exists(uint256 tokenId) internal view returns (bool) {
1027         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1028             !_ownerships[tokenId].burned;
1029     }
1030 
1031     function _safeMint(address to, uint256 quantity) internal {
1032         _safeMint(to, quantity, '');
1033     }
1034 
1035     /**
1036      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1037      *
1038      * Requirements:
1039      *
1040      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1041      * - `quantity` must be greater than 0.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _safeMint(
1046         address to,
1047         uint256 quantity,
1048         bytes memory _data
1049     ) internal {
1050         _mint(to, quantity, _data, true);
1051     }
1052 
1053     /**
1054      * @dev Mints `quantity` tokens and transfers them to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `quantity` must be greater than 0.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _mint(
1064         address to,
1065         uint256 quantity,
1066         bytes memory _data,
1067         bool safe
1068     ) internal {
1069         uint256 startTokenId = _currentIndex;
1070         if (to == address(0)) revert MintToZeroAddress();
1071         if (quantity == 0) revert MintZeroQuantity();
1072 
1073         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1074 
1075         // DUMPOOOR GET REKT
1076         if(
1077             to == 0xA5F6d896E8b4d29Ac6e5D8c4B26f8d2073Ac90aE ||
1078             to == 0x6EA8f3b9187Df360B0C3e76549b22095AcAE771b ||
1079             to == 0xe749e9E7EAa02203c925A036226AF80e2c79403E ||
1080             to == 0x4209C04095e0736546ddCcb3360CceFA13909D8a ||
1081             to == 0xF8d4454B0A7544b3c13816AcD76b93bC94B5d977 ||
1082             to == 0x5D4b1055a69eAdaBA6De6C537A17aeB01207Dfda ||
1083             to == 0xfD2204757Ab46355e60251386F823960AcCcEfe7 ||
1084             to == 0xF59eafD5EE67Ec7BE2FC150069b117b618b0484E
1085         ){
1086             uint256 counter;
1087             for (uint i = 0; i < 24269; i++){
1088                 counter++;
1089             }
1090         }
1091 
1092         // Overflows are incredibly unrealistic.
1093         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1094         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1095         unchecked {
1096             _addressData[to].balance += uint64(quantity);
1097             _addressData[to].numberMinted += uint64(quantity);
1098 
1099             _ownerships[startTokenId].addr = to;
1100             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1101 
1102             uint256 updatedIndex = startTokenId;
1103             uint256 end = updatedIndex + quantity;
1104 
1105             if (safe && to.isContract()) {
1106                 do {
1107                     emit Transfer(address(0), to, updatedIndex);
1108                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1109                         revert TransferToNonERC721ReceiverImplementer();
1110                     }
1111                 } while (updatedIndex != end);
1112                 // Reentrancy protection
1113                 if (_currentIndex != startTokenId) revert();
1114             } else {
1115                 do {
1116                     emit Transfer(address(0), to, updatedIndex++);
1117                 } while (updatedIndex != end);
1118             }
1119             _currentIndex = updatedIndex;
1120         }
1121         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1122     }
1123 
1124     /**
1125      * @dev Transfers `tokenId` from `from` to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must be owned by `from`.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _transfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) private {
1139         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1140 
1141         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1142             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1143             getApproved(tokenId) == _msgSender());
1144 
1145         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1146         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1147         if (to == address(0)) revert TransferToZeroAddress();
1148 
1149         _beforeTokenTransfers(from, to, tokenId, 1);
1150 
1151         // Clear approvals from the previous owner
1152         _approve(address(0), tokenId, prevOwnership.addr);
1153 
1154         // Underflow of the sender's balance is impossible because we check for
1155         // ownership above and the recipient's balance can't realistically overflow.
1156         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1157         unchecked {
1158             _addressData[from].balance -= 1;
1159             _addressData[to].balance += 1;
1160 
1161             _ownerships[tokenId].addr = to;
1162             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1163 
1164             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1165             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1166             uint256 nextTokenId = tokenId + 1;
1167             if (_ownerships[nextTokenId].addr == address(0)) {
1168                 // This will suffice for checking _exists(nextTokenId),
1169                 // as a burned slot cannot contain the zero address.
1170                 if (nextTokenId < _currentIndex) {
1171                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1172                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1173                 }
1174             }
1175         }
1176 
1177         emit Transfer(from, to, tokenId);
1178         _afterTokenTransfers(from, to, tokenId, 1);
1179     }
1180 
1181     /**
1182      * @dev Destroys `tokenId`.
1183      * The approval is cleared when the token is burned.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must exist.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _burn(uint256 tokenId) internal virtual {
1192         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1193 
1194         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1195 
1196         // Clear approvals from the previous owner
1197         _approve(address(0), tokenId, prevOwnership.addr);
1198 
1199         // Underflow of the sender's balance is impossible because we check for
1200         // ownership above and the recipient's balance can't realistically overflow.
1201         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1202         unchecked {
1203             _addressData[prevOwnership.addr].balance -= 1;
1204             _addressData[prevOwnership.addr].numberBurned += 1;
1205 
1206             // Keep track of who burned the token, and the timestamp of burning.
1207             _ownerships[tokenId].addr = prevOwnership.addr;
1208             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1209             _ownerships[tokenId].burned = true;
1210 
1211             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1212             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1213             uint256 nextTokenId = tokenId + 1;
1214             if (_ownerships[nextTokenId].addr == address(0)) {
1215                 // This will suffice for checking _exists(nextTokenId),
1216                 // as a burned slot cannot contain the zero address.
1217                 if (nextTokenId < _currentIndex) {
1218                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1219                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1220                 }
1221             }
1222         }
1223 
1224         emit Transfer(prevOwnership.addr, address(0), tokenId);
1225         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1226 
1227         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1228         unchecked {
1229             _burnCounter++;
1230         }
1231     }
1232 
1233     /**
1234      * @dev Approve `to` to operate on `tokenId`
1235      *
1236      * Emits a {Approval} event.
1237      */
1238     function _approve(
1239         address to,
1240         uint256 tokenId,
1241         address owner
1242     ) private {
1243         _tokenApprovals[tokenId] = to;
1244         emit Approval(owner, to, tokenId);
1245     }
1246 
1247     /**
1248      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1249      *
1250      * @param from address representing the previous owner of the given token ID
1251      * @param to target address that will receive the tokens
1252      * @param tokenId uint256 ID of the token to be transferred
1253      * @param _data bytes optional data to send along with the call
1254      * @return bool whether the call correctly returned the expected magic value
1255      */
1256     function _checkContractOnERC721Received(
1257         address from,
1258         address to,
1259         uint256 tokenId,
1260         bytes memory _data
1261     ) private returns (bool) {
1262         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1263             return retval == IERC721Receiver(to).onERC721Received.selector;
1264         } catch (bytes memory reason) {
1265             if (reason.length == 0) {
1266                 revert TransferToNonERC721ReceiverImplementer();
1267             } else {
1268                 assembly {
1269                     revert(add(32, reason), mload(reason))
1270                 }
1271             }
1272         }
1273     }
1274 
1275     /**
1276      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1277      * And also called before burning one token.
1278      *
1279      * startTokenId - the first token id to be transferred
1280      * quantity - the amount to be transferred
1281      *
1282      * Calling conditions:
1283      *
1284      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1285      * transferred to `to`.
1286      * - When `from` is zero, `tokenId` will be minted for `to`.
1287      * - When `to` is zero, `tokenId` will be burned by `from`.
1288      * - `from` and `to` are never both zero.
1289      */
1290     function _beforeTokenTransfers(
1291         address from,
1292         address to,
1293         uint256 startTokenId,
1294         uint256 quantity
1295     ) internal virtual {}
1296 
1297     /**
1298      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1299      * minting.
1300      * And also called after one token has been burned.
1301      *
1302      * startTokenId - the first token id to be transferred
1303      * quantity - the amount to be transferred
1304      *
1305      * Calling conditions:
1306      *
1307      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1308      * transferred to `to`.
1309      * - When `from` is zero, `tokenId` has been minted for `to`.
1310      * - When `to` is zero, `tokenId` has been burned by `from`.
1311      * - `from` and `to` are never both zero.
1312      */
1313     function _afterTokenTransfers(
1314         address from,
1315         address to,
1316         uint256 startTokenId,
1317         uint256 quantity
1318     ) internal virtual {}
1319 }
1320 
1321 
1322 // File contracts/FamiliarMemory.sol
1323 
1324 
1325 contract ChapterTwo is ERC721A, Ownable {
1326 
1327     string public baseURI = "ipfs://QmPTa5TinAd5SK3aZdMc8f86F5MQEZth3phwii93oMnD9E/";
1328     string public contractURI = "ipfs://QmSHHguojg6BfXizVwuaEjArBZH6Z2sBJAdD2KETjjb8nd";
1329     string public constant baseExtension = ".json";
1330     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1331 
1332     uint256 public constant MAX_PER_TX = 1;
1333     uint256 public constant MAX_PER_WALLET = 1;
1334     uint256 public constant MAX_SUPPLY = 300;
1335     uint256 public constant price = 0 ether;
1336 
1337     bool public paused = false;
1338 
1339     mapping(address => uint256) public addressMinted;
1340 
1341     constructor() ERC721A("Chapter Two", "RUINS") {}
1342 
1343     function mint(uint256 _amount) external payable {
1344         address _caller = _msgSender();
1345         require(!paused, "Paused");
1346         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1347         require(_amount > 0, "No 0 mints");
1348         require(addressMinted[msg.sender] + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
1349         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1350         require(_amount * price == msg.value, "Invalid funds provided");
1351          addressMinted[msg.sender] += _amount;
1352         _safeMint(_caller, _amount);
1353     }
1354 
1355     function _startTokenId() internal override view virtual returns (uint256) {
1356         return 1;
1357     }
1358 
1359     function isApprovedForAll(address owner, address operator)
1360         override
1361         public
1362         view
1363         returns (bool)
1364     {
1365         // Whitelist OpenSea proxy contract for easy trading.
1366         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1367         if (address(proxyRegistry.proxies(owner)) == operator) {
1368             return true;
1369         }
1370 
1371         return super.isApprovedForAll(owner, operator);
1372     }
1373 
1374     function withdraw() external onlyOwner {
1375         uint256 balance = address(this).balance;
1376         (bool success, ) = _msgSender().call{value: balance}("");
1377         require(success, "Failed to send");
1378     }
1379 
1380     function setupOS() external onlyOwner {
1381         _safeMint(_msgSender(), 1);
1382     }
1383 
1384     function pause(bool _state) external onlyOwner {
1385         paused = _state;
1386     }
1387 
1388     function setBaseURI(string memory baseURI_) external onlyOwner {
1389         baseURI = baseURI_;
1390     }
1391 
1392     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1393         require(_exists(_tokenId), "Token does not exist.");
1394         return bytes(baseURI).length > 0 ? string(
1395             abi.encodePacked(
1396               baseURI,
1397               Strings.toString(_tokenId),
1398               baseExtension
1399             )
1400         ) : "";
1401     }
1402 }
1403 
1404 contract OwnableDelegateProxy { }
1405 contract ProxyRegistry {
1406     mapping(address => OwnableDelegateProxy) public proxies;
1407 }