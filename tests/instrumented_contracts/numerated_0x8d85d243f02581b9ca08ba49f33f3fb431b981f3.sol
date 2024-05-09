1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId,
88         bytes calldata data
89     ) external;
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns the account approved for `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function getApproved(uint256 tokenId) external view returns (address operator);
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
176 
177 
178 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 
183 /**
184  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
185  * @dev See https://eips.ethereum.org/EIPS/eip-721
186  */
187 interface IERC721Metadata is IERC721 {
188     /**
189      * @dev Returns the token collection name.
190      */
191     function name() external view returns (string memory);
192 
193     /**
194      * @dev Returns the token collection symbol.
195      */
196     function symbol() external view returns (string memory);
197 
198     /**
199      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
200      */
201     function tokenURI(uint256 tokenId) external view returns (string memory);
202 }
203 
204 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
205 
206 
207 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 
212 /**
213  * @dev Implementation of the {IERC165} interface.
214  *
215  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
216  * for the additional interface id that will be supported. For example:
217  *
218  * ```solidity
219  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
220  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
221  * }
222  * ```
223  *
224  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
225  */
226 abstract contract ERC165 is IERC165 {
227     /**
228      * @dev See {IERC165-supportsInterface}.
229      */
230     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
231         return interfaceId == type(IERC165).interfaceId;
232     }
233 }
234 
235 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
236 
237 
238 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @title ERC721 token receiver interface
244  * @dev Interface for any contract that wants to support safeTransfers
245  * from ERC721 asset contracts.
246  */
247 interface IERC721Receiver {
248     /**
249      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
250      * by `operator` from `from`, this function is called.
251      *
252      * It must return its Solidity selector to confirm the token transfer.
253      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
254      *
255      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
256      */
257     function onERC721Received(
258         address operator,
259         address from,
260         uint256 tokenId,
261         bytes calldata data
262     ) external returns (bytes4);
263 }
264 
265 // File: @openzeppelin/contracts/utils/Address.sol
266 
267 
268 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
269 
270 pragma solidity ^0.8.1;
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      *
293      * [IMPORTANT]
294      * ====
295      * You shouldn't rely on `isContract` to protect against flash loan attacks!
296      *
297      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
298      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
299      * constructor.
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies on extcodesize/address.code.length, which returns 0
304         // for contracts in construction, since the code is only stored at the end
305         // of the constructor execution.
306 
307         return account.code.length > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         (bool success, ) = recipient.call{value: amount}("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain `call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(address(this).balance >= value, "Address: insufficient balance for call");
401         require(isContract(target), "Address: call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.call{value: value}(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
414         return functionStaticCall(target, data, "Address: low-level static call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal view returns (bytes memory) {
428         require(isContract(target), "Address: static call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.staticcall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
441         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(isContract(target), "Address: delegate call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.delegatecall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
463      * revert reason using the provided one.
464      *
465      * _Available since v4.3._
466      */
467     function verifyCallResult(
468         bool success,
469         bytes memory returndata,
470         string memory errorMessage
471     ) internal pure returns (bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478                 /// @solidity memory-safe-assembly
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/utils/Context.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev Provides information about the current execution context, including the
499  * sender of the transaction and its data. While these are generally available
500  * via msg.sender and msg.data, they should not be accessed in such a direct
501  * manner, since when dealing with meta-transactions the account sending and
502  * paying for execution may not be the actual sender (as far as an application
503  * is concerned).
504  *
505  * This contract is only required for intermediate, library-like contracts.
506  */
507 abstract contract Context {
508     function _msgSender() internal view virtual returns (address) {
509         return msg.sender;
510     }
511 
512     function _msgData() internal view virtual returns (bytes calldata) {
513         return msg.data;
514     }
515 }
516 
517 // File: @openzeppelin/contracts/access/Ownable.sol
518 
519 
520 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Contract module which provides a basic access control mechanism, where
527  * there is an account (an owner) that can be granted exclusive access to
528  * specific functions.
529  *
530  * By default, the owner account will be the one that deploys the contract. This
531  * can later be changed with {transferOwnership}.
532  *
533  * This module is used through inheritance. It will make available the modifier
534  * `onlyOwner`, which can be applied to your functions to restrict their use to
535  * the owner.
536  */
537 abstract contract Ownable is Context {
538     address private _owner;
539 
540     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
541 
542     /**
543      * @dev Initializes the contract setting the deployer as the initial owner.
544      */
545     constructor() {
546         _transferOwnership(_msgSender());
547     }
548 
549     /**
550      * @dev Throws if called by any account other than the owner.
551      */
552     modifier onlyOwner() {
553         _checkOwner();
554         _;
555     }
556 
557     /**
558      * @dev Returns the address of the current owner.
559      */
560     function owner() public view virtual returns (address) {
561         return _owner;
562     }
563 
564     /**
565      * @dev Throws if the sender is not the owner.
566      */
567     function _checkOwner() internal view virtual {
568         require(owner() == _msgSender(), "Ownable: caller is not the owner");
569     }
570 
571     /**
572      * @dev Leaves the contract without owner. It will not be possible to call
573      * `onlyOwner` functions anymore. Can only be called by the current owner.
574      *
575      * NOTE: Renouncing ownership will leave the contract without an owner,
576      * thereby removing any functionality that is only available to the owner.
577      */
578     function renounceOwnership() public virtual onlyOwner {
579         _transferOwnership(address(0));
580     }
581 
582     /**
583      * @dev Transfers ownership of the contract to a new account (`newOwner`).
584      * Can only be called by the current owner.
585      */
586     function transferOwnership(address newOwner) public virtual onlyOwner {
587         require(newOwner != address(0), "Ownable: new owner is the zero address");
588         _transferOwnership(newOwner);
589     }
590 
591     /**
592      * @dev Transfers ownership of the contract to a new account (`newOwner`).
593      * Internal function without access restriction.
594      */
595     function _transferOwnership(address newOwner) internal virtual {
596         address oldOwner = _owner;
597         _owner = newOwner;
598         emit OwnershipTransferred(oldOwner, newOwner);
599     }
600 }
601 
602 // File: @openzeppelin/contracts/utils/Strings.sol
603 
604 
605 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev String operations.
611  */
612 library Strings {
613     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
614     uint8 private constant _ADDRESS_LENGTH = 20;
615 
616     /**
617      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
618      */
619     function toString(uint256 value) internal pure returns (string memory) {
620         // Inspired by OraclizeAPI's implementation - MIT licence
621         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
622 
623         if (value == 0) {
624             return "0";
625         }
626         uint256 temp = value;
627         uint256 digits;
628         while (temp != 0) {
629             digits++;
630             temp /= 10;
631         }
632         bytes memory buffer = new bytes(digits);
633         while (value != 0) {
634             digits -= 1;
635             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
636             value /= 10;
637         }
638         return string(buffer);
639     }
640 
641     /**
642      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
643      */
644     function toHexString(uint256 value) internal pure returns (string memory) {
645         if (value == 0) {
646             return "0x00";
647         }
648         uint256 temp = value;
649         uint256 length = 0;
650         while (temp != 0) {
651             length++;
652             temp >>= 8;
653         }
654         return toHexString(value, length);
655     }
656 
657     /**
658      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
659      */
660     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
661         bytes memory buffer = new bytes(2 * length + 2);
662         buffer[0] = "0";
663         buffer[1] = "x";
664         for (uint256 i = 2 * length + 1; i > 1; --i) {
665             buffer[i] = _HEX_SYMBOLS[value & 0xf];
666             value >>= 4;
667         }
668         require(value == 0, "Strings: hex length insufficient");
669         return string(buffer);
670     }
671 
672     /**
673      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
674      */
675     function toHexString(address addr) internal pure returns (string memory) {
676         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
677     }
678 }
679 
680 // File: erc721a/contracts/IERC721A.sol
681 
682 
683 // ERC721A Contracts v4.2.3
684 // Creator: Chiru Labs
685 
686 pragma solidity ^0.8.4;
687 
688 /**
689  * @dev Interface of ERC721A.
690  */
691 interface IERC721A {
692     /**
693      * The caller must own the token or be an approved operator.
694      */
695     error ApprovalCallerNotOwnerNorApproved();
696 
697     /**
698      * The token does not exist.
699      */
700     error ApprovalQueryForNonexistentToken();
701 
702     /**
703      * Cannot query the balance for the zero address.
704      */
705     error BalanceQueryForZeroAddress();
706 
707     /**
708      * Cannot mint to the zero address.
709      */
710     error MintToZeroAddress();
711 
712     /**
713      * The quantity of tokens minted must be more than zero.
714      */
715     error MintZeroQuantity();
716 
717     /**
718      * The token does not exist.
719      */
720     error OwnerQueryForNonexistentToken();
721 
722     /**
723      * The caller must own the token or be an approved operator.
724      */
725     error TransferCallerNotOwnerNorApproved();
726 
727     /**
728      * The token must be owned by `from`.
729      */
730     error TransferFromIncorrectOwner();
731 
732     /**
733      * Cannot safely transfer to a contract that does not implement the
734      * ERC721Receiver interface.
735      */
736     error TransferToNonERC721ReceiverImplementer();
737 
738     /**
739      * Cannot transfer to the zero address.
740      */
741     error TransferToZeroAddress();
742 
743     /**
744      * The token does not exist.
745      */
746     error URIQueryForNonexistentToken();
747 
748     /**
749      * The `quantity` minted with ERC2309 exceeds the safety limit.
750      */
751     error MintERC2309QuantityExceedsLimit();
752 
753     /**
754      * The `extraData` cannot be set on an unintialized ownership slot.
755      */
756     error OwnershipNotInitializedForExtraData();
757 
758     // =============================================================
759     //                            STRUCTS
760     // =============================================================
761 
762     struct TokenOwnership {
763         // The address of the owner.
764         address addr;
765         // Stores the start time of ownership with minimal overhead for tokenomics.
766         uint64 startTimestamp;
767         // Whether the token has been burned.
768         bool burned;
769         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
770         uint24 extraData;
771     }
772 
773     // =============================================================
774     //                         TOKEN COUNTERS
775     // =============================================================
776 
777     /**
778      * @dev Returns the total number of tokens in existence.
779      * Burned tokens will reduce the count.
780      * To get the total number of tokens minted, please see {_totalMinted}.
781      */
782     function totalSupply() external view returns (uint256);
783 
784     // =============================================================
785     //                            IERC165
786     // =============================================================
787 
788     /**
789      * @dev Returns true if this contract implements the interface defined by
790      * `interfaceId`. See the corresponding
791      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
792      * to learn more about how these ids are created.
793      *
794      * This function call must use less than 30000 gas.
795      */
796     function supportsInterface(bytes4 interfaceId) external view returns (bool);
797 
798     // =============================================================
799     //                            IERC721
800     // =============================================================
801 
802     /**
803      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
804      */
805     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
806 
807     /**
808      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
809      */
810     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
811 
812     /**
813      * @dev Emitted when `owner` enables or disables
814      * (`approved`) `operator` to manage all of its assets.
815      */
816     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
817 
818     /**
819      * @dev Returns the number of tokens in `owner`'s account.
820      */
821     function balanceOf(address owner) external view returns (uint256 balance);
822 
823     /**
824      * @dev Returns the owner of the `tokenId` token.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function ownerOf(uint256 tokenId) external view returns (address owner);
831 
832     /**
833      * @dev Safely transfers `tokenId` token from `from` to `to`,
834      * checking first that contract recipients are aware of the ERC721 protocol
835      * to prevent tokens from being forever locked.
836      *
837      * Requirements:
838      *
839      * - `from` cannot be the zero address.
840      * - `to` cannot be the zero address.
841      * - `tokenId` token must exist and be owned by `from`.
842      * - If the caller is not `from`, it must be have been allowed to move
843      * this token by either {approve} or {setApprovalForAll}.
844      * - If `to` refers to a smart contract, it must implement
845      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
846      *
847      * Emits a {Transfer} event.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId,
853         bytes calldata data
854     ) external payable;
855 
856     /**
857      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) external payable;
864 
865     /**
866      * @dev Transfers `tokenId` from `from` to `to`.
867      *
868      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
869      * whenever possible.
870      *
871      * Requirements:
872      *
873      * - `from` cannot be the zero address.
874      * - `to` cannot be the zero address.
875      * - `tokenId` token must be owned by `from`.
876      * - If the caller is not `from`, it must be approved to move this token
877      * by either {approve} or {setApprovalForAll}.
878      *
879      * Emits a {Transfer} event.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) external payable;
886 
887     /**
888      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
889      * The approval is cleared when the token is transferred.
890      *
891      * Only a single account can be approved at a time, so approving the
892      * zero address clears previous approvals.
893      *
894      * Requirements:
895      *
896      * - The caller must own the token or be an approved operator.
897      * - `tokenId` must exist.
898      *
899      * Emits an {Approval} event.
900      */
901     function approve(address to, uint256 tokenId) external payable;
902 
903     /**
904      * @dev Approve or remove `operator` as an operator for the caller.
905      * Operators can call {transferFrom} or {safeTransferFrom}
906      * for any token owned by the caller.
907      *
908      * Requirements:
909      *
910      * - The `operator` cannot be the caller.
911      *
912      * Emits an {ApprovalForAll} event.
913      */
914     function setApprovalForAll(address operator, bool _approved) external;
915 
916     /**
917      * @dev Returns the account approved for `tokenId` token.
918      *
919      * Requirements:
920      *
921      * - `tokenId` must exist.
922      */
923     function getApproved(uint256 tokenId) external view returns (address operator);
924 
925     /**
926      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
927      *
928      * See {setApprovalForAll}.
929      */
930     function isApprovedForAll(address owner, address operator) external view returns (bool);
931 
932     // =============================================================
933     //                        IERC721Metadata
934     // =============================================================
935 
936     /**
937      * @dev Returns the token collection name.
938      */
939     function name() external view returns (string memory);
940 
941     /**
942      * @dev Returns the token collection symbol.
943      */
944     function symbol() external view returns (string memory);
945 
946     /**
947      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
948      */
949     function tokenURI(uint256 tokenId) external view returns (string memory);
950 
951     // =============================================================
952     //                           IERC2309
953     // =============================================================
954 
955     /**
956      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
957      * (inclusive) is transferred from `from` to `to`, as defined in the
958      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
959      *
960      * See {_mintERC2309} for more details.
961      */
962     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
963 }
964 
965 // File: erc721a/contracts/ERC721A.sol
966 
967 
968 // ERC721A Contracts v4.2.3
969 // Creator: Chiru Labs
970 
971 pragma solidity ^0.8.4;
972 
973 
974 /**
975  * @dev Interface of ERC721 token receiver.
976  */
977 interface ERC721A__IERC721Receiver {
978     function onERC721Received(
979         address operator,
980         address from,
981         uint256 tokenId,
982         bytes calldata data
983     ) external returns (bytes4);
984 }
985 
986 /**
987  * @title ERC721A
988  *
989  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
990  * Non-Fungible Token Standard, including the Metadata extension.
991  * Optimized for lower gas during batch mints.
992  *
993  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
994  * starting from `_startTokenId()`.
995  *
996  * Assumptions:
997  *
998  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
999  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1000  */
1001 contract ERC721A is IERC721A {
1002     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1003     struct TokenApprovalRef {
1004         address value;
1005     }
1006 
1007     // =============================================================
1008     //                           CONSTANTS
1009     // =============================================================
1010 
1011     // Mask of an entry in packed address data.
1012     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1013 
1014     // The bit position of `numberMinted` in packed address data.
1015     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1016 
1017     // The bit position of `numberBurned` in packed address data.
1018     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1019 
1020     // The bit position of `aux` in packed address data.
1021     uint256 private constant _BITPOS_AUX = 192;
1022 
1023     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1024     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1025 
1026     // The bit position of `startTimestamp` in packed ownership.
1027     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1028 
1029     // The bit mask of the `burned` bit in packed ownership.
1030     uint256 private constant _BITMASK_BURNED = 1 << 224;
1031 
1032     // The bit position of the `nextInitialized` bit in packed ownership.
1033     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1034 
1035     // The bit mask of the `nextInitialized` bit in packed ownership.
1036     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1037 
1038     // The bit position of `extraData` in packed ownership.
1039     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1040 
1041     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1042     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1043 
1044     // The mask of the lower 160 bits for addresses.
1045     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1046 
1047     // The maximum `quantity` that can be minted with {_mintERC2309}.
1048     // This limit is to prevent overflows on the address data entries.
1049     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1050     // is required to cause an overflow, which is unrealistic.
1051     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1052 
1053     // The `Transfer` event signature is given by:
1054     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1055     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1056         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1057 
1058     // =============================================================
1059     //                            STORAGE
1060     // =============================================================
1061 
1062     // The next token ID to be minted.
1063     uint256 private _currentIndex;
1064 
1065     // The number of tokens burned.
1066     uint256 private _burnCounter;
1067 
1068     // Token name
1069     string private _name;
1070 
1071     // Token symbol
1072     string private _symbol;
1073 
1074     // Mapping from token ID to ownership details
1075     // An empty struct value does not necessarily mean the token is unowned.
1076     // See {_packedOwnershipOf} implementation for details.
1077     //
1078     // Bits Layout:
1079     // - [0..159]   `addr`
1080     // - [160..223] `startTimestamp`
1081     // - [224]      `burned`
1082     // - [225]      `nextInitialized`
1083     // - [232..255] `extraData`
1084     mapping(uint256 => uint256) private _packedOwnerships;
1085 
1086     // Mapping owner address to address data.
1087     //
1088     // Bits Layout:
1089     // - [0..63]    `balance`
1090     // - [64..127]  `numberMinted`
1091     // - [128..191] `numberBurned`
1092     // - [192..255] `aux`
1093     mapping(address => uint256) private _packedAddressData;
1094 
1095     // Mapping from token ID to approved address.
1096     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1097 
1098     // Mapping from owner to operator approvals
1099     mapping(address => mapping(address => bool)) private _operatorApprovals;
1100 
1101     // =============================================================
1102     //                          CONSTRUCTOR
1103     // =============================================================
1104 
1105     constructor(string memory name_, string memory symbol_) {
1106         _name = name_;
1107         _symbol = symbol_;
1108         _currentIndex = _startTokenId();
1109     }
1110 
1111     // =============================================================
1112     //                   TOKEN COUNTING OPERATIONS
1113     // =============================================================
1114 
1115     /**
1116      * @dev Returns the starting token ID.
1117      * To change the starting token ID, please override this function.
1118      */
1119     function _startTokenId() internal view virtual returns (uint256) {
1120         return 0;
1121     }
1122 
1123     /**
1124      * @dev Returns the next token ID to be minted.
1125      */
1126     function _nextTokenId() internal view virtual returns (uint256) {
1127         return _currentIndex;
1128     }
1129 
1130     /**
1131      * @dev Returns the total number of tokens in existence.
1132      * Burned tokens will reduce the count.
1133      * To get the total number of tokens minted, please see {_totalMinted}.
1134      */
1135     function totalSupply() public view virtual override returns (uint256) {
1136         // Counter underflow is impossible as _burnCounter cannot be incremented
1137         // more than `_currentIndex - _startTokenId()` times.
1138         unchecked {
1139             return _currentIndex - _burnCounter - _startTokenId();
1140         }
1141     }
1142 
1143     /**
1144      * @dev Returns the total amount of tokens minted in the contract.
1145      */
1146     function _totalMinted() internal view virtual returns (uint256) {
1147         // Counter underflow is impossible as `_currentIndex` does not decrement,
1148         // and it is initialized to `_startTokenId()`.
1149         unchecked {
1150             return _currentIndex - _startTokenId();
1151         }
1152     }
1153 
1154     /**
1155      * @dev Returns the total number of tokens burned.
1156      */
1157     function _totalBurned() internal view virtual returns (uint256) {
1158         return _burnCounter;
1159     }
1160 
1161     // =============================================================
1162     //                    ADDRESS DATA OPERATIONS
1163     // =============================================================
1164 
1165     /**
1166      * @dev Returns the number of tokens in `owner`'s account.
1167      */
1168     function balanceOf(address owner) public view virtual override returns (uint256) {
1169         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1170         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1171     }
1172 
1173     /**
1174      * Returns the number of tokens minted by `owner`.
1175      */
1176     function _numberMinted(address owner) internal view returns (uint256) {
1177         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1178     }
1179 
1180     /**
1181      * Returns the number of tokens burned by or on behalf of `owner`.
1182      */
1183     function _numberBurned(address owner) internal view returns (uint256) {
1184         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1185     }
1186 
1187     /**
1188      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1189      */
1190     function _getAux(address owner) internal view returns (uint64) {
1191         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1192     }
1193 
1194     /**
1195      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1196      * If there are multiple variables, please pack them into a uint64.
1197      */
1198     function _setAux(address owner, uint64 aux) internal virtual {
1199         uint256 packed = _packedAddressData[owner];
1200         uint256 auxCasted;
1201         // Cast `aux` with assembly to avoid redundant masking.
1202         assembly {
1203             auxCasted := aux
1204         }
1205         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1206         _packedAddressData[owner] = packed;
1207     }
1208 
1209     // =============================================================
1210     //                            IERC165
1211     // =============================================================
1212 
1213     /**
1214      * @dev Returns true if this contract implements the interface defined by
1215      * `interfaceId`. See the corresponding
1216      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1217      * to learn more about how these ids are created.
1218      *
1219      * This function call must use less than 30000 gas.
1220      */
1221     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1222         // The interface IDs are constants representing the first 4 bytes
1223         // of the XOR of all function selectors in the interface.
1224         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1225         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1226         return
1227             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1228             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1229             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1230     }
1231 
1232     // =============================================================
1233     //                        IERC721Metadata
1234     // =============================================================
1235 
1236     /**
1237      * @dev Returns the token collection name.
1238      */
1239     function name() public view virtual override returns (string memory) {
1240         return _name;
1241     }
1242 
1243     /**
1244      * @dev Returns the token collection symbol.
1245      */
1246     function symbol() public view virtual override returns (string memory) {
1247         return _symbol;
1248     }
1249 
1250     /**
1251      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1252      */
1253     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1254         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1255 
1256         string memory baseURI = _baseURI();
1257         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1258     }
1259 
1260     /**
1261      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1262      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1263      * by default, it can be overridden in child contracts.
1264      */
1265     function _baseURI() internal view virtual returns (string memory) {
1266         return '';
1267     }
1268 
1269     // =============================================================
1270     //                     OWNERSHIPS OPERATIONS
1271     // =============================================================
1272 
1273     /**
1274      * @dev Returns the owner of the `tokenId` token.
1275      *
1276      * Requirements:
1277      *
1278      * - `tokenId` must exist.
1279      */
1280     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1281         return address(uint160(_packedOwnershipOf(tokenId)));
1282     }
1283 
1284     /**
1285      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1286      * It gradually moves to O(1) as tokens get transferred around over time.
1287      */
1288     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1289         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1290     }
1291 
1292     /**
1293      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1294      */
1295     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1296         return _unpackedOwnership(_packedOwnerships[index]);
1297     }
1298 
1299     /**
1300      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1301      */
1302     function _initializeOwnershipAt(uint256 index) internal virtual {
1303         if (_packedOwnerships[index] == 0) {
1304             _packedOwnerships[index] = _packedOwnershipOf(index);
1305         }
1306     }
1307 
1308     /**
1309      * Returns the packed ownership data of `tokenId`.
1310      */
1311     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1312         uint256 curr = tokenId;
1313 
1314         unchecked {
1315             if (_startTokenId() <= curr)
1316                 if (curr < _currentIndex) {
1317                     uint256 packed = _packedOwnerships[curr];
1318                     // If not burned.
1319                     if (packed & _BITMASK_BURNED == 0) {
1320                         // Invariant:
1321                         // There will always be an initialized ownership slot
1322                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1323                         // before an unintialized ownership slot
1324                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1325                         // Hence, `curr` will not underflow.
1326                         //
1327                         // We can directly compare the packed value.
1328                         // If the address is zero, packed will be zero.
1329                         while (packed == 0) {
1330                             packed = _packedOwnerships[--curr];
1331                         }
1332                         return packed;
1333                     }
1334                 }
1335         }
1336         revert OwnerQueryForNonexistentToken();
1337     }
1338 
1339     /**
1340      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1341      */
1342     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1343         ownership.addr = address(uint160(packed));
1344         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1345         ownership.burned = packed & _BITMASK_BURNED != 0;
1346         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1347     }
1348 
1349     /**
1350      * @dev Packs ownership data into a single uint256.
1351      */
1352     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1353         assembly {
1354             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1355             owner := and(owner, _BITMASK_ADDRESS)
1356             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1357             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1358         }
1359     }
1360 
1361     /**
1362      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1363      */
1364     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1365         // For branchless setting of the `nextInitialized` flag.
1366         assembly {
1367             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1368             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1369         }
1370     }
1371 
1372     // =============================================================
1373     //                      APPROVAL OPERATIONS
1374     // =============================================================
1375 
1376     /**
1377      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1378      * The approval is cleared when the token is transferred.
1379      *
1380      * Only a single account can be approved at a time, so approving the
1381      * zero address clears previous approvals.
1382      *
1383      * Requirements:
1384      *
1385      * - The caller must own the token or be an approved operator.
1386      * - `tokenId` must exist.
1387      *
1388      * Emits an {Approval} event.
1389      */
1390     function approve(address to, uint256 tokenId) public payable virtual override {
1391         address owner = ownerOf(tokenId);
1392 
1393         if (_msgSenderERC721A() != owner)
1394             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1395                 revert ApprovalCallerNotOwnerNorApproved();
1396             }
1397 
1398         _tokenApprovals[tokenId].value = to;
1399         emit Approval(owner, to, tokenId);
1400     }
1401 
1402     /**
1403      * @dev Returns the account approved for `tokenId` token.
1404      *
1405      * Requirements:
1406      *
1407      * - `tokenId` must exist.
1408      */
1409     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1410         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1411 
1412         return _tokenApprovals[tokenId].value;
1413     }
1414 
1415     /**
1416      * @dev Approve or remove `operator` as an operator for the caller.
1417      * Operators can call {transferFrom} or {safeTransferFrom}
1418      * for any token owned by the caller.
1419      *
1420      * Requirements:
1421      *
1422      * - The `operator` cannot be the caller.
1423      *
1424      * Emits an {ApprovalForAll} event.
1425      */
1426     function setApprovalForAll(address operator, bool approved) public virtual override {
1427         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1428         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1429     }
1430 
1431     /**
1432      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1433      *
1434      * See {setApprovalForAll}.
1435      */
1436     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1437         return _operatorApprovals[owner][operator];
1438     }
1439 
1440     /**
1441      * @dev Returns whether `tokenId` exists.
1442      *
1443      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1444      *
1445      * Tokens start existing when they are minted. See {_mint}.
1446      */
1447     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1448         return
1449             _startTokenId() <= tokenId &&
1450             tokenId < _currentIndex && // If within bounds,
1451             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1452     }
1453 
1454     /**
1455      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1456      */
1457     function _isSenderApprovedOrOwner(
1458         address approvedAddress,
1459         address owner,
1460         address msgSender
1461     ) private pure returns (bool result) {
1462         assembly {
1463             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1464             owner := and(owner, _BITMASK_ADDRESS)
1465             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1466             msgSender := and(msgSender, _BITMASK_ADDRESS)
1467             // `msgSender == owner || msgSender == approvedAddress`.
1468             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1469         }
1470     }
1471 
1472     /**
1473      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1474      */
1475     function _getApprovedSlotAndAddress(uint256 tokenId)
1476         private
1477         view
1478         returns (uint256 approvedAddressSlot, address approvedAddress)
1479     {
1480         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1481         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1482         assembly {
1483             approvedAddressSlot := tokenApproval.slot
1484             approvedAddress := sload(approvedAddressSlot)
1485         }
1486     }
1487 
1488     // =============================================================
1489     //                      TRANSFER OPERATIONS
1490     // =============================================================
1491 
1492     /**
1493      * @dev Transfers `tokenId` from `from` to `to`.
1494      *
1495      * Requirements:
1496      *
1497      * - `from` cannot be the zero address.
1498      * - `to` cannot be the zero address.
1499      * - `tokenId` token must be owned by `from`.
1500      * - If the caller is not `from`, it must be approved to move this token
1501      * by either {approve} or {setApprovalForAll}.
1502      *
1503      * Emits a {Transfer} event.
1504      */
1505     function transferFrom(
1506         address from,
1507         address to,
1508         uint256 tokenId
1509     ) public payable virtual override {
1510         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1511 
1512         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1513 
1514         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1515 
1516         // The nested ifs save around 20+ gas over a compound boolean condition.
1517         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1518             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1519 
1520         if (to == address(0)) revert TransferToZeroAddress();
1521 
1522         _beforeTokenTransfers(from, to, tokenId, 1);
1523 
1524         // Clear approvals from the previous owner.
1525         assembly {
1526             if approvedAddress {
1527                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1528                 sstore(approvedAddressSlot, 0)
1529             }
1530         }
1531 
1532         // Underflow of the sender's balance is impossible because we check for
1533         // ownership above and the recipient's balance can't realistically overflow.
1534         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1535         unchecked {
1536             // We can directly increment and decrement the balances.
1537             --_packedAddressData[from]; // Updates: `balance -= 1`.
1538             ++_packedAddressData[to]; // Updates: `balance += 1`.
1539 
1540             // Updates:
1541             // - `address` to the next owner.
1542             // - `startTimestamp` to the timestamp of transfering.
1543             // - `burned` to `false`.
1544             // - `nextInitialized` to `true`.
1545             _packedOwnerships[tokenId] = _packOwnershipData(
1546                 to,
1547                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1548             );
1549 
1550             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1551             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1552                 uint256 nextTokenId = tokenId + 1;
1553                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1554                 if (_packedOwnerships[nextTokenId] == 0) {
1555                     // If the next slot is within bounds.
1556                     if (nextTokenId != _currentIndex) {
1557                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1558                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1559                     }
1560                 }
1561             }
1562         }
1563 
1564         emit Transfer(from, to, tokenId);
1565         _afterTokenTransfers(from, to, tokenId, 1);
1566     }
1567 
1568     /**
1569      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1570      */
1571     function safeTransferFrom(
1572         address from,
1573         address to,
1574         uint256 tokenId
1575     ) public payable virtual override {
1576         safeTransferFrom(from, to, tokenId, '');
1577     }
1578 
1579     /**
1580      * @dev Safely transfers `tokenId` token from `from` to `to`.
1581      *
1582      * Requirements:
1583      *
1584      * - `from` cannot be the zero address.
1585      * - `to` cannot be the zero address.
1586      * - `tokenId` token must exist and be owned by `from`.
1587      * - If the caller is not `from`, it must be approved to move this token
1588      * by either {approve} or {setApprovalForAll}.
1589      * - If `to` refers to a smart contract, it must implement
1590      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1591      *
1592      * Emits a {Transfer} event.
1593      */
1594     function safeTransferFrom(
1595         address from,
1596         address to,
1597         uint256 tokenId,
1598         bytes memory _data
1599     ) public payable virtual override {
1600         transferFrom(from, to, tokenId);
1601         if (to.code.length != 0)
1602             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1603                 revert TransferToNonERC721ReceiverImplementer();
1604             }
1605     }
1606 
1607     /**
1608      * @dev Hook that is called before a set of serially-ordered token IDs
1609      * are about to be transferred. This includes minting.
1610      * And also called before burning one token.
1611      *
1612      * `startTokenId` - the first token ID to be transferred.
1613      * `quantity` - the amount to be transferred.
1614      *
1615      * Calling conditions:
1616      *
1617      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1618      * transferred to `to`.
1619      * - When `from` is zero, `tokenId` will be minted for `to`.
1620      * - When `to` is zero, `tokenId` will be burned by `from`.
1621      * - `from` and `to` are never both zero.
1622      */
1623     function _beforeTokenTransfers(
1624         address from,
1625         address to,
1626         uint256 startTokenId,
1627         uint256 quantity
1628     ) internal virtual {}
1629 
1630     /**
1631      * @dev Hook that is called after a set of serially-ordered token IDs
1632      * have been transferred. This includes minting.
1633      * And also called after one token has been burned.
1634      *
1635      * `startTokenId` - the first token ID to be transferred.
1636      * `quantity` - the amount to be transferred.
1637      *
1638      * Calling conditions:
1639      *
1640      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1641      * transferred to `to`.
1642      * - When `from` is zero, `tokenId` has been minted for `to`.
1643      * - When `to` is zero, `tokenId` has been burned by `from`.
1644      * - `from` and `to` are never both zero.
1645      */
1646     function _afterTokenTransfers(
1647         address from,
1648         address to,
1649         uint256 startTokenId,
1650         uint256 quantity
1651     ) internal virtual {}
1652 
1653     /**
1654      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1655      *
1656      * `from` - Previous owner of the given token ID.
1657      * `to` - Target address that will receive the token.
1658      * `tokenId` - Token ID to be transferred.
1659      * `_data` - Optional data to send along with the call.
1660      *
1661      * Returns whether the call correctly returned the expected magic value.
1662      */
1663     function _checkContractOnERC721Received(
1664         address from,
1665         address to,
1666         uint256 tokenId,
1667         bytes memory _data
1668     ) private returns (bool) {
1669         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1670             bytes4 retval
1671         ) {
1672             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1673         } catch (bytes memory reason) {
1674             if (reason.length == 0) {
1675                 revert TransferToNonERC721ReceiverImplementer();
1676             } else {
1677                 assembly {
1678                     revert(add(32, reason), mload(reason))
1679                 }
1680             }
1681         }
1682     }
1683 
1684     // =============================================================
1685     //                        MINT OPERATIONS
1686     // =============================================================
1687 
1688     /**
1689      * @dev Mints `quantity` tokens and transfers them to `to`.
1690      *
1691      * Requirements:
1692      *
1693      * - `to` cannot be the zero address.
1694      * - `quantity` must be greater than 0.
1695      *
1696      * Emits a {Transfer} event for each mint.
1697      */
1698     function _mint(address to, uint256 quantity) internal virtual {
1699         uint256 startTokenId = _currentIndex;
1700         if (quantity == 0) revert MintZeroQuantity();
1701 
1702         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1703 
1704         // Overflows are incredibly unrealistic.
1705         // `balance` and `numberMinted` have a maximum limit of 2**64.
1706         // `tokenId` has a maximum limit of 2**256.
1707         unchecked {
1708             // Updates:
1709             // - `balance += quantity`.
1710             // - `numberMinted += quantity`.
1711             //
1712             // We can directly add to the `balance` and `numberMinted`.
1713             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1714 
1715             // Updates:
1716             // - `address` to the owner.
1717             // - `startTimestamp` to the timestamp of minting.
1718             // - `burned` to `false`.
1719             // - `nextInitialized` to `quantity == 1`.
1720             _packedOwnerships[startTokenId] = _packOwnershipData(
1721                 to,
1722                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1723             );
1724 
1725             uint256 toMasked;
1726             uint256 end = startTokenId + quantity;
1727 
1728             // Use assembly to loop and emit the `Transfer` event for gas savings.
1729             // The duplicated `log4` removes an extra check and reduces stack juggling.
1730             // The assembly, together with the surrounding Solidity code, have been
1731             // delicately arranged to nudge the compiler into producing optimized opcodes.
1732             assembly {
1733                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1734                 toMasked := and(to, _BITMASK_ADDRESS)
1735                 // Emit the `Transfer` event.
1736                 log4(
1737                     0, // Start of data (0, since no data).
1738                     0, // End of data (0, since no data).
1739                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1740                     0, // `address(0)`.
1741                     toMasked, // `to`.
1742                     startTokenId // `tokenId`.
1743                 )
1744 
1745                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1746                 // that overflows uint256 will make the loop run out of gas.
1747                 // The compiler will optimize the `iszero` away for performance.
1748                 for {
1749                     let tokenId := add(startTokenId, 1)
1750                 } iszero(eq(tokenId, end)) {
1751                     tokenId := add(tokenId, 1)
1752                 } {
1753                     // Emit the `Transfer` event. Similar to above.
1754                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1755                 }
1756             }
1757             if (toMasked == 0) revert MintToZeroAddress();
1758 
1759             _currentIndex = end;
1760         }
1761         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1762     }
1763 
1764     /**
1765      * @dev Mints `quantity` tokens and transfers them to `to`.
1766      *
1767      * This function is intended for efficient minting only during contract creation.
1768      *
1769      * It emits only one {ConsecutiveTransfer} as defined in
1770      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1771      * instead of a sequence of {Transfer} event(s).
1772      *
1773      * Calling this function outside of contract creation WILL make your contract
1774      * non-compliant with the ERC721 standard.
1775      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1776      * {ConsecutiveTransfer} event is only permissible during contract creation.
1777      *
1778      * Requirements:
1779      *
1780      * - `to` cannot be the zero address.
1781      * - `quantity` must be greater than 0.
1782      *
1783      * Emits a {ConsecutiveTransfer} event.
1784      */
1785     function _mintERC2309(address to, uint256 quantity) internal virtual {
1786         uint256 startTokenId = _currentIndex;
1787         if (to == address(0)) revert MintToZeroAddress();
1788         if (quantity == 0) revert MintZeroQuantity();
1789         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1790 
1791         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1792 
1793         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1794         unchecked {
1795             // Updates:
1796             // - `balance += quantity`.
1797             // - `numberMinted += quantity`.
1798             //
1799             // We can directly add to the `balance` and `numberMinted`.
1800             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1801 
1802             // Updates:
1803             // - `address` to the owner.
1804             // - `startTimestamp` to the timestamp of minting.
1805             // - `burned` to `false`.
1806             // - `nextInitialized` to `quantity == 1`.
1807             _packedOwnerships[startTokenId] = _packOwnershipData(
1808                 to,
1809                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1810             );
1811 
1812             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1813 
1814             _currentIndex = startTokenId + quantity;
1815         }
1816         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1817     }
1818 
1819     /**
1820      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1821      *
1822      * Requirements:
1823      *
1824      * - If `to` refers to a smart contract, it must implement
1825      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1826      * - `quantity` must be greater than 0.
1827      *
1828      * See {_mint}.
1829      *
1830      * Emits a {Transfer} event for each mint.
1831      */
1832     function _safeMint(
1833         address to,
1834         uint256 quantity,
1835         bytes memory _data
1836     ) internal virtual {
1837         _mint(to, quantity);
1838 
1839         unchecked {
1840             if (to.code.length != 0) {
1841                 uint256 end = _currentIndex;
1842                 uint256 index = end - quantity;
1843                 do {
1844                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1845                         revert TransferToNonERC721ReceiverImplementer();
1846                     }
1847                 } while (index < end);
1848                 // Reentrancy protection.
1849                 if (_currentIndex != end) revert();
1850             }
1851         }
1852     }
1853 
1854     /**
1855      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1856      */
1857     function _safeMint(address to, uint256 quantity) internal virtual {
1858         _safeMint(to, quantity, '');
1859     }
1860 
1861     // =============================================================
1862     //                        BURN OPERATIONS
1863     // =============================================================
1864 
1865     /**
1866      * @dev Equivalent to `_burn(tokenId, false)`.
1867      */
1868     function _burn(uint256 tokenId) internal virtual {
1869         _burn(tokenId, false);
1870     }
1871 
1872     /**
1873      * @dev Destroys `tokenId`.
1874      * The approval is cleared when the token is burned.
1875      *
1876      * Requirements:
1877      *
1878      * - `tokenId` must exist.
1879      *
1880      * Emits a {Transfer} event.
1881      */
1882     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1883         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1884 
1885         address from = address(uint160(prevOwnershipPacked));
1886 
1887         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1888 
1889         if (approvalCheck) {
1890             // The nested ifs save around 20+ gas over a compound boolean condition.
1891             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1892                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1893         }
1894 
1895         _beforeTokenTransfers(from, address(0), tokenId, 1);
1896 
1897         // Clear approvals from the previous owner.
1898         assembly {
1899             if approvedAddress {
1900                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1901                 sstore(approvedAddressSlot, 0)
1902             }
1903         }
1904 
1905         // Underflow of the sender's balance is impossible because we check for
1906         // ownership above and the recipient's balance can't realistically overflow.
1907         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1908         unchecked {
1909             // Updates:
1910             // - `balance -= 1`.
1911             // - `numberBurned += 1`.
1912             //
1913             // We can directly decrement the balance, and increment the number burned.
1914             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1915             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1916 
1917             // Updates:
1918             // - `address` to the last owner.
1919             // - `startTimestamp` to the timestamp of burning.
1920             // - `burned` to `true`.
1921             // - `nextInitialized` to `true`.
1922             _packedOwnerships[tokenId] = _packOwnershipData(
1923                 from,
1924                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1925             );
1926 
1927             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1928             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1929                 uint256 nextTokenId = tokenId + 1;
1930                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1931                 if (_packedOwnerships[nextTokenId] == 0) {
1932                     // If the next slot is within bounds.
1933                     if (nextTokenId != _currentIndex) {
1934                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1935                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1936                     }
1937                 }
1938             }
1939         }
1940 
1941         emit Transfer(from, address(0), tokenId);
1942         _afterTokenTransfers(from, address(0), tokenId, 1);
1943 
1944         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1945         unchecked {
1946             _burnCounter++;
1947         }
1948     }
1949 
1950     // =============================================================
1951     //                     EXTRA DATA OPERATIONS
1952     // =============================================================
1953 
1954     /**
1955      * @dev Directly sets the extra data for the ownership data `index`.
1956      */
1957     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1958         uint256 packed = _packedOwnerships[index];
1959         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1960         uint256 extraDataCasted;
1961         // Cast `extraData` with assembly to avoid redundant masking.
1962         assembly {
1963             extraDataCasted := extraData
1964         }
1965         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1966         _packedOwnerships[index] = packed;
1967     }
1968 
1969     /**
1970      * @dev Called during each token transfer to set the 24bit `extraData` field.
1971      * Intended to be overridden by the cosumer contract.
1972      *
1973      * `previousExtraData` - the value of `extraData` before transfer.
1974      *
1975      * Calling conditions:
1976      *
1977      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1978      * transferred to `to`.
1979      * - When `from` is zero, `tokenId` will be minted for `to`.
1980      * - When `to` is zero, `tokenId` will be burned by `from`.
1981      * - `from` and `to` are never both zero.
1982      */
1983     function _extraData(
1984         address from,
1985         address to,
1986         uint24 previousExtraData
1987     ) internal view virtual returns (uint24) {}
1988 
1989     /**
1990      * @dev Returns the next extra data for the packed ownership data.
1991      * The returned result is shifted into position.
1992      */
1993     function _nextExtraData(
1994         address from,
1995         address to,
1996         uint256 prevOwnershipPacked
1997     ) private view returns (uint256) {
1998         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1999         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2000     }
2001 
2002     // =============================================================
2003     //                       OTHER OPERATIONS
2004     // =============================================================
2005 
2006     /**
2007      * @dev Returns the message sender (defaults to `msg.sender`).
2008      *
2009      * If you are writing GSN compatible contracts, you need to override this function.
2010      */
2011     function _msgSenderERC721A() internal view virtual returns (address) {
2012         return msg.sender;
2013     }
2014 
2015     /**
2016      * @dev Converts a uint256 to its ASCII string decimal representation.
2017      */
2018     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2019         assembly {
2020             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2021             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2022             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2023             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2024             let m := add(mload(0x40), 0xa0)
2025             // Update the free memory pointer to allocate.
2026             mstore(0x40, m)
2027             // Assign the `str` to the end.
2028             str := sub(m, 0x20)
2029             // Zeroize the slot after the string.
2030             mstore(str, 0)
2031 
2032             // Cache the end of the memory to calculate the length later.
2033             let end := str
2034 
2035             // We write the string from rightmost digit to leftmost digit.
2036             // The following is essentially a do-while loop that also handles the zero case.
2037             // prettier-ignore
2038             for { let temp := value } 1 {} {
2039                 str := sub(str, 1)
2040                 // Write the character to the pointer.
2041                 // The ASCII index of the '0' character is 48.
2042                 mstore8(str, add(48, mod(temp, 10)))
2043                 // Keep dividing `temp` until zero.
2044                 temp := div(temp, 10)
2045                 // prettier-ignore
2046                 if iszero(temp) { break }
2047             }
2048 
2049             let length := sub(end, str)
2050             // Move the pointer 32 bytes leftwards to make room for the length.
2051             str := sub(str, 0x20)
2052             // Store the length.
2053             mstore(str, length)
2054         }
2055     }
2056 }
2057 
2058 // File: contracts/ConnectionsByAnon.sol
2059 
2060 
2061 
2062 pragma solidity ^0.8.7;
2063 
2064 
2065 
2066 
2067 
2068 
2069 
2070 
2071 
2072 
2073 
2074 contract ConnectionsByAnon is ERC721A, Ownable {
2075 
2076     using Strings for uint256;
2077 
2078     string private baseURI ;
2079 
2080     uint256 public price = 0.004 ether;
2081 
2082     uint256 public maxPerTx = 10;
2083 
2084     uint256 public maxFreePerWallet = 5;
2085 
2086     uint256 public totalFree = 888;
2087 
2088     uint256 public maxSupply = 888;
2089 
2090     bool public mintEnabled = true;
2091     
2092     uint   public totalFreeMinted = 0;
2093 
2094     mapping(address => uint256) private _mintedFreeAmount;
2095 
2096     constructor() ERC721A("Connections by Anon", "CONNECTION") {}
2097 
2098    function mint(uint256 count) external payable {
2099         uint256 cost = price;
2100         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
2101             (_mintedFreeAmount[msg.sender] < maxFreePerWallet));
2102 
2103         if (isFree) { 
2104             require(mintEnabled, "Mint is not live yet");
2105             require(totalSupply() + count <= maxSupply, "No more");
2106             require(count <= maxPerTx, "Max per TX reached.");
2107             if(count >= (maxFreePerWallet - _mintedFreeAmount[msg.sender]))
2108             {
2109              require(msg.value >= (count * cost) - ((maxFreePerWallet - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
2110              _mintedFreeAmount[msg.sender] = maxFreePerWallet;
2111              totalFreeMinted += maxFreePerWallet;
2112             }
2113             else if(count < (maxFreePerWallet - _mintedFreeAmount[msg.sender]))
2114             {
2115              require(msg.value >= 0, "Please send the exact ETH amount");
2116              _mintedFreeAmount[msg.sender] += count;
2117              totalFreeMinted += count;
2118             }
2119         }
2120         else{
2121         require(mintEnabled, "Mint is not live yet");
2122         require(msg.value >= count * cost, "Please send the exact ETH amount");
2123         require(totalSupply() + count <= maxSupply, "Sold out");
2124         require(count <= maxPerTx, "Max per TX reached.");
2125         }
2126 
2127         _safeMint(msg.sender, count);
2128     }
2129 
2130     function tokenURI(uint256 tokenId)
2131         public view virtual override returns (string memory) {
2132         require(
2133             _exists(tokenId),
2134             "ERC721Metadata: URI query for nonexistent token"
2135         );
2136         return string(abi.encodePacked(baseURI, tokenId.toString()));
2137     }
2138 
2139     function setBaseURI(string memory uri) public onlyOwner {
2140         baseURI = uri;
2141     }
2142 
2143     function setFreeAmount(uint256 amount) external onlyOwner {
2144         totalFree = amount;
2145     }
2146 
2147     function setPrice(uint256 _newPrice) external onlyOwner {
2148         price = _newPrice;
2149     }
2150 
2151     function toggleMint() external onlyOwner {
2152         mintEnabled = !mintEnabled;
2153     }
2154 
2155     function withdraw() external onlyOwner {
2156         (bool success, ) = payable(msg.sender).call{
2157             value: address(this).balance
2158         }("");
2159         require(success, "Transfer failed.");
2160     }
2161     
2162 }