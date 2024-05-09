1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-08
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
70 }
71 
72 
73 // File: Context.sol
74 
75 
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 
100 // File: Ownable.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _setOwner(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _setOwner(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _setOwner(newOwner);
164     }
165 
166     function _setOwner(address newOwner) private {
167         address oldOwner = _owner;
168         _owner = newOwner;
169         emit OwnershipTransferred(oldOwner, newOwner);
170     }
171 }
172 
173 
174 // File: Address.sol
175 
176 
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Collection of functions related to the address type
182  */
183 library Address {
184     /**
185      * @dev Returns true if `account` is a contract.
186      *
187      * [IMPORTANT]
188      * ====
189      * It is unsafe to assume that an address for which this function returns
190      * false is an externally-owned account (EOA) and not a contract.
191      *
192      * Among others, `isContract` will return false for the following
193      * types of addresses:
194      *
195      *  - an externally-owned account
196      *  - a contract in construction
197      *  - an address where a contract will be created
198      *  - an address where a contract lived, but was destroyed
199      * ====
200      */
201     function isContract(address account) internal view returns (bool) {
202         // This method relies on extcodesize, which returns 0 for contracts in
203         // construction, since the code is only stored at the end of the
204         // constructor execution.
205 
206         uint256 size;
207         assembly {
208             size := extcodesize(account)
209         }
210         return size > 0;
211     }
212 
213     /**
214      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
215      * `recipient`, forwarding all available gas and reverting on errors.
216      *
217      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
218      * of certain opcodes, possibly making contracts go over the 2300 gas limit
219      * imposed by `transfer`, making them unable to receive funds via
220      * `transfer`. {sendValue} removes this limitation.
221      *
222      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
223      *
224      * IMPORTANT: because control is transferred to `recipient`, care must be
225      * taken to not create reentrancy vulnerabilities. Consider using
226      * {ReentrancyGuard} or the
227      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
228      */
229     function sendValue(address payable recipient, uint256 amount) internal {
230         require(address(this).balance >= amount, "Address: insufficient balance");
231 
232         (bool success, ) = recipient.call{value: amount}("");
233         require(success, "Address: unable to send value, recipient may have reverted");
234     }
235 
236     /**
237      * @dev Performs a Solidity function call using a low level `call`. A
238      * plain `call` is an unsafe replacement for a function call: use this
239      * function instead.
240      *
241      * If `target` reverts with a revert reason, it is bubbled up by this
242      * function (like regular Solidity function calls).
243      *
244      * Returns the raw returned data. To convert to the expected return value,
245      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
246      *
247      * Requirements:
248      *
249      * - `target` must be a contract.
250      * - calling `target` with `data` must not revert.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionCall(target, data, "Address: low-level call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
260      * `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         return functionCallWithValue(target, data, 0, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but also transferring `value` wei to `target`.
275      *
276      * Requirements:
277      *
278      * - the calling contract must have an ETH balance of at least `value`.
279      * - the called Solidity function must be `payable`.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
293      * with `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(address(this).balance >= value, "Address: insufficient balance for call");
304         require(isContract(target), "Address: call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.call{value: value}(data);
307         return _verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but performing a static call.
313      *
314      * _Available since v3.3._
315      */
316     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
317         return functionStaticCall(target, data, "Address: low-level static call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal view returns (bytes memory) {
331         require(isContract(target), "Address: static call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.staticcall(data);
334         return _verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a delegate call.
340      *
341      * _Available since v3.4._
342      */
343     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(isContract(target), "Address: delegate call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.delegatecall(data);
361         return _verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     function _verifyCallResult(
365         bool success,
366         bytes memory returndata,
367         string memory errorMessage
368     ) private pure returns (bytes memory) {
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @dev Contract module that helps prevent reentrant calls to a function.
393  *
394  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
395  * available, which can be applied to functions to make sure there are no nested
396  * (reentrant) calls to them.
397  *
398  * Note that because there is a single `nonReentrant` guard, functions marked as
399  * `nonReentrant` may not call one another. This can be worked around by making
400  * those functions `private`, and then adding `external` `nonReentrant` entry
401  * points to them.
402  *
403  * TIP: If you would like to learn more about reentrancy and alternative ways
404  * to protect against it, check out our blog post
405  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
406  */
407 abstract contract ReentrancyGuard {
408     // Booleans are more expensive than uint256 or any type that takes up a full
409     // word because each write operation emits an extra SLOAD to first read the
410     // slot's contents, replace the bits taken up by the boolean, and then write
411     // back. This is the compiler's defense against contract upgrades and
412     // pointer aliasing, and it cannot be disabled.
413 
414     // The values being non-zero value makes deployment a bit more expensive,
415     // but in exchange the refund on every call to nonReentrant will be lower in
416     // amount. Since refunds are capped to a percentage of the total
417     // transaction's gas, it is best to keep them low in cases like this one, to
418     // increase the likelihood of the full refund coming into effect.
419     uint256 private constant _NOT_ENTERED = 1;
420     uint256 private constant _ENTERED = 2;
421 
422     uint256 private _status;
423 
424     constructor() {
425         _status = _NOT_ENTERED;
426     }
427 
428     /**
429      * @dev Prevents a contract from calling itself, directly or indirectly.
430      * Calling a `nonReentrant` function from another `nonReentrant`
431      * function is not supported. It is possible to prevent this from happening
432      * by making the `nonReentrant` function external, and making it call a
433      * `private` function that does the actual work.
434      */
435     modifier nonReentrant() {
436         // On the first call to nonReentrant, _notEntered will be true
437         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
438 
439         // Any calls to nonReentrant after this point will fail
440         _status = _ENTERED;
441 
442         _;
443 
444         // By storing the original value once again, a refund is triggered (see
445         // https://eips.ethereum.org/EIPS/eip-2200)
446         _status = _NOT_ENTERED;
447     }
448 }
449 
450 
451 // File: IERC721Receiver.sol
452 
453 
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @title ERC721 token receiver interface
459  * @dev Interface for any contract that wants to support safeTransfers
460  * from ERC721 asset contracts.
461  */
462 interface IERC721Receiver {
463     /**
464      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
465      * by `operator` from `from`, this function is called.
466      *
467      * It must return its Solidity selector to confirm the token transfer.
468      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
469      *
470      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
471      */
472     function onERC721Received(
473         address operator,
474         address from,
475         uint256 tokenId,
476         bytes calldata data
477     ) external returns (bytes4);
478 }
479 
480 
481 // File: IERC165.sol
482 
483 
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev Interface of the ERC165 standard, as defined in the
489  * https://eips.ethereum.org/EIPS/eip-165[EIP].
490  *
491  * Implementers can declare support of contract interfaces, which can then be
492  * queried by others ({ERC165Checker}).
493  *
494  * For an implementation, see {ERC165}.
495  */
496 interface IERC165 {
497     /**
498      * @dev Returns true if this contract implements the interface defined by
499      * `interfaceId`. See the corresponding
500      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
501      * to learn more about how these ids are created.
502      *
503      * This function call must use less than 30 000 gas.
504      */
505     function supportsInterface(bytes4 interfaceId) external view returns (bool);
506 }
507 
508 
509 // File: ERC165.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Implementation of the {IERC165} interface.
518  *
519  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
520  * for the additional interface id that will be supported. For example:
521  *
522  * ```solidity
523  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
525  * }
526  * ```
527  *
528  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
529  */
530 abstract contract ERC165 is IERC165 {
531     /**
532      * @dev See {IERC165-supportsInterface}.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         return interfaceId == type(IERC165).interfaceId;
536     }
537 }
538 
539 
540 // File: IERC721.sol
541 
542 
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @dev Required interface of an ERC721 compliant contract.
549  */
550 interface IERC721 is IERC165 {
551     /**
552      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
553      */
554     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
555 
556     /**
557      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
558      */
559     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
563      */
564     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
565 
566     /**
567      * @dev Returns the number of tokens in ``owner``'s account.
568      */
569     function balanceOf(address owner) external view returns (uint256 balance);
570 
571     /**
572      * @dev Returns the owner of the `tokenId` token.
573      *
574      * Requirements:
575      *
576      * - `tokenId` must exist.
577      */
578     function ownerOf(uint256 tokenId) external view returns (address owner);
579 
580     /**
581      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
582      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
583      *
584      * Requirements:
585      *
586      * - `from` cannot be the zero address.
587      * - `to` cannot be the zero address.
588      * - `tokenId` token must exist and be owned by `from`.
589      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
590      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
591      *
592      * Emits a {Transfer} event.
593      */
594     function safeTransferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) external;
599 
600     /**
601      * @dev Transfers `tokenId` token from `from` to `to`.
602      *
603      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must be owned by `from`.
610      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
611      *
612      * Emits a {Transfer} event.
613      */
614     function transferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
622      * The approval is cleared when the token is transferred.
623      *
624      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
625      *
626      * Requirements:
627      *
628      * - The caller must own the token or be an approved operator.
629      * - `tokenId` must exist.
630      *
631      * Emits an {Approval} event.
632      */
633     function approve(address to, uint256 tokenId) external;
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
645      * @dev Approve or remove `operator` as an operator for the caller.
646      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
647      *
648      * Requirements:
649      *
650      * - The `operator` cannot be the caller.
651      *
652      * Emits an {ApprovalForAll} event.
653      */
654     function setApprovalForAll(address operator, bool _approved) external;
655 
656     /**
657      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
658      *
659      * See {setApprovalForAll}
660      */
661     function isApprovedForAll(address owner, address operator) external view returns (bool);
662 
663     /**
664      * @dev Safely transfers `tokenId` token from `from` to `to`.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId,
680         bytes calldata data
681     ) external;
682 }
683 
684 
685 
686 // File: IERC721Metadata.sol
687 
688 
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
714 
715 // ERC721A Contracts v3.3.0
716 // Creator: Chiru Labs
717 
718 pragma solidity ^0.8.4;
719 
720 
721 /**
722  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
723  * the Metadata extension. Built to optimize for lower gas during batch mints.
724  *
725  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
726  *
727  * Assumes that an owner cannot have more than 2**128 - 1 (max value of uint128) of supply.
728  *
729  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
730  */
731 
732 error ApprovalCallerNotOwnerNorApproved();
733 error ApprovalQueryForNonexistentToken();
734 error ApproveToCaller();
735 error ApprovalToCurrentOwner();
736 error BalanceQueryForZeroAddress();
737 error MintedQueryForZeroAddress();
738 error MintToZeroAddress();
739 error MintZeroQuantity();
740 error OwnerQueryForNonexistentToken();
741 error TransferCallerNotOwnerNorApproved();
742 error TransferFromIncorrectOwner();
743 error TransferToNonERC721ReceiverImplementer();
744 error TransferToNonERC721ReceiverImplementerFunction();
745 error MintToNonERC721ReceiverImplementer();
746 error TransferToZeroAddress();
747 error URIQueryForNonexistentToken();
748 
749 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, ReentrancyGuard {
750     using Address for address;
751     using Strings for uint256;
752 
753     struct TokenOwnership {
754         address addr;
755         uint64 startTimestamp;
756     }
757 
758     // Compiler will pack this into a single 256bit word.
759     struct AddressData {
760         // Realistically, 2**64-1 is more than enough.
761         uint128 balance;
762         // Keeps track of mint count with minimal overhead for tokenomics.
763         uint128 numberMinted;
764     }
765 
766     uint256 internal _currentIndex = 1;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to ownership details
775     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
776     mapping(uint256 => TokenOwnership) internal _ownerships;
777 
778     // Mapping owner address to address data
779     mapping(address => AddressData) private _addressData;
780 
781     // Mapping from token ID to approved address
782     mapping(uint256 => address) private _tokenApprovals;
783 
784     // Mapping from owner to operator approvals
785     mapping(address => mapping(address => bool)) private _operatorApprovals;
786 
787     constructor(string memory name_, string memory symbol_) {
788         _name = name_;
789         _symbol = symbol_;
790     }
791 
792     /**
793      * @dev Returns _currentIndex.
794      */
795     function totalSupply() public view returns (uint256) {
796         return (_currentIndex-1);
797     }
798 
799     /**
800      * @dev See {IERC165-supportsInterface}.
801      */
802     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
803         return
804             interfaceId == type(IERC721).interfaceId ||
805             interfaceId == type(IERC721Metadata).interfaceId ||
806             super.supportsInterface(interfaceId);
807     }
808 
809     /**
810      * @dev See {IERC721-balanceOf}.
811      */
812     function balanceOf(address owner) public view override returns (uint256) {
813         if (owner == address(0)) revert BalanceQueryForZeroAddress();
814         return uint256(_addressData[owner].balance);
815     }
816 
817     /**
818      * Returns the number of tokens minted by `owner`.
819      */
820     function _numberMinted(address owner) internal view returns (uint256) {
821         if (owner == address(0)) revert MintedQueryForZeroAddress();
822         return uint256(_addressData[owner].numberMinted);
823     }
824 
825     /**
826      * Gas spent here starts off proportional to the maximum mint batch size.
827      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
828      */
829     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
830         uint256 curr = tokenId;
831 
832         unchecked {
833             if ( (1 <= curr && curr < _currentIndex) ) {
834                 TokenOwnership memory ownership = _ownerships[curr];
835                 if (ownership.addr != address(0)) {
836                     return ownership;
837                 }
838                 // think about it... won't underflow ;)
839                 while (true) {
840                     curr--;
841                     ownership = _ownerships[curr];
842                     if (ownership.addr != address(0)) {
843                         return ownership;
844                     }
845                 }
846             }
847         } // unchecked
848         revert OwnerQueryForNonexistentToken();
849     }
850 
851     /**
852      * @dev See {IERC721-ownerOf}.
853      */
854     function ownerOf(uint256 tokenId) public view override returns (address) {
855         return _ownershipOf(tokenId).addr;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-name}.
860      */
861     function name() public view virtual override returns (string memory) {
862         return _name;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-symbol}.
867      */
868     function symbol() public view virtual override returns (string memory) {
869         return _symbol;
870     }
871 
872     /**
873      * @dev See {IERC721Metadata-tokenURI}.
874      */
875     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
876         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
877 
878         string memory baseURI = _baseURI();
879         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
880     }
881 
882     /**
883      * @dev Base URI for {tokenURI}. Empty
884      * by default, can be overriden in child contracts.
885      */
886     function _baseURI() internal view virtual returns (string memory) {
887         return '';
888     }
889 
890     /**
891      * @dev See {IERC721-approve}.
892      */
893     function approve(address to, uint256 tokenId) public override {
894         address owner = ERC721A.ownerOf(tokenId);
895         if (to == owner) revert ApprovalToCurrentOwner();
896 
897         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
898             revert ApprovalCallerNotOwnerNorApproved();
899         }
900 
901         _approve(to, tokenId, owner);
902     }
903 
904     /**
905      * @dev See {IERC721-getApproved}.
906      */
907     function getApproved(uint256 tokenId) public view override returns (address) {
908         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
909 
910         return _tokenApprovals[tokenId];
911     }
912 
913     /**
914      * @dev See {IERC721-setApprovalForAll}.
915      */
916     function setApprovalForAll(address operator, bool approved) public override {
917         if (operator == _msgSender()) revert ApproveToCaller();
918 
919         _operatorApprovals[_msgSender()][operator] = approved;
920         emit ApprovalForAll(_msgSender(), operator, approved);
921     }
922 
923     /**
924      * @dev See {IERC721-isApprovedForAll}.
925      */
926     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
927         return _operatorApprovals[owner][operator];
928     }
929 
930     /**
931      * @dev See {IERC721-transferFrom}.
932      */
933     function transferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) public override {
938         _transfer(from, to, tokenId);
939     }
940 
941     /**
942      * @dev See {IERC721-safeTransferFrom}.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) public override {
949         safeTransferFrom(from, to, tokenId, '');
950     }
951 
952     /**
953      * @dev See {IERC721-safeTransferFrom}.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) public override {
961         _transfer(from, to, tokenId);
962         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
963             revert TransferToNonERC721ReceiverImplementer();
964         }
965     }
966 
967     /**
968      * @dev Returns whether `tokenId` exists.
969      *
970      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
971      *
972      * Tokens start existing when they are minted (`_mint`),
973      */
974     function _exists(uint256 tokenId) internal view returns (bool) {
975         return tokenId < _currentIndex;
976     }
977 
978     /**
979      * @dev Safely mints `quantity` tokens and transfers them to `to`.
980      *
981      * Requirements:
982      *
983      * - If `to` refers to a smart contract, it must implement
984      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
985      * - `quantity` must be greater than 0.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _safeMint(
990         address to,
991         uint256 quantity
992     ) internal {
993         if (to == address(0)) revert MintToZeroAddress();
994         if (quantity == 0) revert MintZeroQuantity();
995 
996         // Overflows are incredibly unrealistic
997         // balance or numberMinted overflow if current value of either + quantity > (2**128) - 1
998         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
999         unchecked {
1000             _addressData[to].balance += uint128(quantity);
1001             _addressData[to].numberMinted += uint128(quantity);
1002 
1003             _ownerships[_currentIndex].addr = to;
1004             _ownerships[_currentIndex].startTimestamp = uint64(block.timestamp);
1005 
1006             uint256 updatedIndex = _currentIndex;
1007 
1008             for (uint256 i = 0; i < quantity; i++) {
1009                 emit Transfer(address(0), to, updatedIndex);
1010                 if (!_checkOnERC721Received(address(0), to, updatedIndex, '')) {
1011                     revert MintToNonERC721ReceiverImplementer();
1012                 }
1013                 updatedIndex++;
1014 
1015             }
1016 
1017             _currentIndex = updatedIndex;
1018         } // unchecked
1019     }
1020 
1021     /**
1022      * @dev Transfers `tokenId` from `from` to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) private nonReentrant {
1036         if (to == address(0)) revert TransferToZeroAddress();
1037 
1038         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1039         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1040 
1041         bool isApprovedOrOwner = (_msgSender() == from ||
1042             isApprovedForAll(from, _msgSender()) ||
1043             getApproved(tokenId) == _msgSender());
1044 
1045         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1046 
1047         // Clear approvals from the previous owner
1048         _approve(address(0), tokenId, from);
1049 
1050         // Underflow of the sender's balance is impossible because we check for
1051         // ownership above and the recipient's balance can't realistically overflow.
1052         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1053         //      Me: meh, I'm not convinced the underflow is safe from re-entrancy attacks 
1054         // (comes down to a race condition); to still save gas I modified this 
1055         // to be nonReentrant to be safe
1056         unchecked {
1057             _addressData[from].balance -= 1;
1058             _addressData[to].balance += 1;
1059 
1060             _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1061 
1062             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1063             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1064             uint256 nextTokenId = tokenId + 1;
1065             if (_ownerships[nextTokenId].addr == address(0)) {
1066                 if (_exists(nextTokenId)) {
1067                     _ownerships[nextTokenId] = TokenOwnership(
1068                         prevOwnership.addr,
1069                         prevOwnership.startTimestamp
1070                     );
1071                 }
1072             }
1073         } // unchecked
1074 
1075         emit Transfer(from, to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev Approve `to` to operate on `tokenId`
1080      *
1081      * Emits a {Approval} event.
1082      */
1083     function _approve(
1084         address to,
1085         uint256 tokenId,
1086         address owner
1087     ) private {
1088         _tokenApprovals[tokenId] = to;
1089         emit Approval(owner, to, tokenId);
1090     }
1091 
1092     /**
1093      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1094      *
1095      * @param from address representing the previous owner of the given token ID
1096      * @param to target address that will receive the tokens
1097      * @param tokenId uint256 ID of the token to be transferred
1098      * @param _data bytes optional data to send along with the call
1099      * @return bool whether the call correctly returned the expected magic value
1100      */
1101     function _checkOnERC721Received(
1102         address from,
1103         address to,
1104         uint256 tokenId,
1105         bytes memory _data
1106     ) private returns (bool) {
1107         if (to.isContract()) {
1108             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1109                 return retval == IERC721Receiver(to).onERC721Received.selector;
1110             } catch (bytes memory reason) {
1111                 if (reason.length == 0) {
1112                     revert TransferToNonERC721ReceiverImplementerFunction();
1113                 } else {
1114                     assembly {
1115                         revert(add(32, reason), mload(reason))
1116                     }
1117                 }
1118             }
1119         } else {
1120             return true;
1121         }
1122     }
1123 }
1124 
1125 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1126 
1127 pragma solidity ^0.8.0;
1128 
1129 /**
1130  * @dev These functions deal with verification of Merkle Tree proofs.
1131  *
1132  * The proofs can be generated using the JavaScript library
1133  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1134  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1135  *
1136  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1137  *
1138  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1139  * hashing, or use a hash function other than keccak256 for hashing leaves.
1140  * This is because the concatenation of a sorted pair of internal nodes in
1141  * the merkle tree could be reinterpreted as a leaf value.
1142  */
1143 library MerkleProof {
1144     /**
1145      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1146      * defined by `root`. For this, a `proof` must be provided, containing
1147      * sibling hashes on the branch from the leaf to the root of the tree. Each
1148      * pair of leaves and each pair of pre-images are assumed to be sorted.
1149      */
1150     function verify(
1151         bytes32[] memory proof,
1152         bytes32 root,
1153         bytes32 leaf
1154     ) internal pure returns (bool) {
1155         return processProof(proof, leaf) == root;
1156     }
1157 
1158     /**
1159      * @dev Calldata version of {verify}
1160      *
1161      * _Available since v4.7._
1162      */
1163     function verifyCalldata(
1164         bytes32[] calldata proof,
1165         bytes32 root,
1166         bytes32 leaf
1167     ) internal pure returns (bool) {
1168         return processProofCalldata(proof, leaf) == root;
1169     }
1170 
1171     /**
1172      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1173      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1174      * hash matches the root of the tree. When processing the proof, the pairs
1175      * of leafs & pre-images are assumed to be sorted.
1176      *
1177      * _Available since v4.4._
1178      */
1179     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1180         bytes32 computedHash = leaf;
1181         for (uint256 i = 0; i < proof.length; i++) {
1182             computedHash = _hashPair(computedHash, proof[i]);
1183         }
1184         return computedHash;
1185     }
1186 
1187     /**
1188      * @dev Calldata version of {processProof}
1189      *
1190      * _Available since v4.7._
1191      */
1192     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1193         bytes32 computedHash = leaf;
1194         for (uint256 i = 0; i < proof.length; i++) {
1195             computedHash = _hashPair(computedHash, proof[i]);
1196         }
1197         return computedHash;
1198     }
1199 
1200     /**
1201      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1202      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1203      *
1204      * _Available since v4.7._
1205      */
1206     function multiProofVerify(
1207         bytes32[] memory proof,
1208         bool[] memory proofFlags,
1209         bytes32 root,
1210         bytes32[] memory leaves
1211     ) internal pure returns (bool) {
1212         return processMultiProof(proof, proofFlags, leaves) == root;
1213     }
1214 
1215     /**
1216      * @dev Calldata version of {multiProofVerify}
1217      *
1218      * _Available since v4.7._
1219      */
1220     function multiProofVerifyCalldata(
1221         bytes32[] calldata proof,
1222         bool[] calldata proofFlags,
1223         bytes32 root,
1224         bytes32[] memory leaves
1225     ) internal pure returns (bool) {
1226         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1227     }
1228 
1229     /**
1230      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1231      * consuming from one or the other at each step according to the instructions given by
1232      * `proofFlags`.
1233      *
1234      * _Available since v4.7._
1235      */
1236     function processMultiProof(
1237         bytes32[] memory proof,
1238         bool[] memory proofFlags,
1239         bytes32[] memory leaves
1240     ) internal pure returns (bytes32 merkleRoot) {
1241         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1242         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1243         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1244         // the merkle tree.
1245         uint256 leavesLen = leaves.length;
1246         uint256 totalHashes = proofFlags.length;
1247 
1248         // Check proof validity.
1249         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1250 
1251         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1252         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1253         bytes32[] memory hashes = new bytes32[](totalHashes);
1254         uint256 leafPos = 0;
1255         uint256 hashPos = 0;
1256         uint256 proofPos = 0;
1257         // At each step, we compute the next hash using two values:
1258         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1259         //   get the next hash.
1260         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1261         //   `proof` array.
1262         for (uint256 i = 0; i < totalHashes; i++) {
1263             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1264             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1265             hashes[i] = _hashPair(a, b);
1266         }
1267 
1268         if (totalHashes > 0) {
1269             return hashes[totalHashes - 1];
1270         } else if (leavesLen > 0) {
1271             return leaves[0];
1272         } else {
1273             return proof[0];
1274         }
1275     }
1276 
1277     /**
1278      * @dev Calldata version of {processMultiProof}
1279      *
1280      * _Available since v4.7._
1281      */
1282     function processMultiProofCalldata(
1283         bytes32[] calldata proof,
1284         bool[] calldata proofFlags,
1285         bytes32[] memory leaves
1286     ) internal pure returns (bytes32 merkleRoot) {
1287         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1288         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1289         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1290         // the merkle tree.
1291         uint256 leavesLen = leaves.length;
1292         uint256 totalHashes = proofFlags.length;
1293 
1294         // Check proof validity.
1295         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1296 
1297         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1298         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1299         bytes32[] memory hashes = new bytes32[](totalHashes);
1300         uint256 leafPos = 0;
1301         uint256 hashPos = 0;
1302         uint256 proofPos = 0;
1303         // At each step, we compute the next hash using two values:
1304         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1305         //   get the next hash.
1306         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1307         //   `proof` array.
1308         for (uint256 i = 0; i < totalHashes; i++) {
1309             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1310             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1311             hashes[i] = _hashPair(a, b);
1312         }
1313 
1314         if (totalHashes > 0) {
1315             return hashes[totalHashes - 1];
1316         } else if (leavesLen > 0) {
1317             return leaves[0];
1318         } else {
1319             return proof[0];
1320         }
1321     }
1322 
1323     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1324         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1325     }
1326 
1327     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1328         /// @solidity memory-safe-assembly
1329         assembly {
1330             mstore(0x00, a)
1331             mstore(0x20, b)
1332             value := keccak256(0x00, 0x40)
1333         }
1334     }
1335 }
1336 
1337 pragma solidity >=0.8.4 <0.9.0;
1338 
1339 error MintFromContract();
1340 error MerkleProofInvalid();
1341 error PreSaleInactive();
1342 error PublicSaleInactive();
1343 error WithdrawFailed();
1344 error ExceedsMaxSupply();
1345 error ExceedsTeamMintLimit();
1346 error ExceedsOGMintLimit();
1347 error ExceedsRektMintLimit();
1348 error ExceedsPublicMintLimit();
1349 
1350 contract RDHA is ERC721A, Ownable {  
1351     using Strings for uint256;
1352 
1353     uint256 public max_supply = 2222;
1354 
1355     bool public pre_sale    = false;
1356     bool public public_sale = false;
1357     bool public revealed    = false;
1358 
1359     uint256 public mint_limit_team   = 10; // per wallet
1360     uint256 public mint_limit_og     = 2;  // per wallet
1361     uint256 public mint_limit_rekt   = 1;  // per wallet
1362     uint256 public mint_limit_public = 1;  // per wallet
1363 
1364     bytes32 public merkle_root_team;
1365     bytes32 public merkle_root_og;
1366     bytes32 public merkle_root_rekt;
1367 
1368     string private _myBaseURI;
1369     string private _myHiddenURI;
1370 
1371 	constructor() ERC721A("Rekted Diamond Hands Academy", "RDHA") {}
1372 
1373     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1374          max_supply = _maxSupply;
1375     }
1376 
1377     function setPreSale(bool _preSale) external onlyOwner {
1378         pre_sale = _preSale;
1379     }
1380     function setPublicSale(bool _publicSale) external onlyOwner {
1381         public_sale = _publicSale;
1382     }
1383 
1384     function setRevealed(bool _revealed) external onlyOwner {
1385         revealed = _revealed;
1386     }
1387 
1388     function setMintLimitTeam(uint256 _mintLimit) external onlyOwner {
1389         mint_limit_team = _mintLimit;
1390     }
1391     function setMintLimitOG(uint256 _mintLimit) external onlyOwner {
1392         mint_limit_og = _mintLimit;
1393     }
1394     function setMintLimitRekt(uint256 _mintLimit) external onlyOwner {
1395         mint_limit_rekt = _mintLimit;
1396     }
1397     function setMintLimitPublic(uint256 _mintLimit) external onlyOwner {
1398         mint_limit_public = _mintLimit;
1399     }
1400 
1401     function setMerkleRootTeam(bytes32 _merkleRoot) external onlyOwner {
1402         merkle_root_team = _merkleRoot;
1403     }
1404     function setMerkleRootOG(bytes32 _merkleRoot) external onlyOwner {
1405         merkle_root_og = _merkleRoot;
1406     }
1407     function setMerkleRootRekt(bytes32 _merkleRoot) external onlyOwner {
1408         merkle_root_rekt = _merkleRoot;
1409     }
1410 
1411     function setMyBaseURI(string memory _myNewBaseURI) external onlyOwner {
1412         _myBaseURI = _myNewBaseURI;
1413     }
1414     function setMyHiddenURI(string memory _myNewHiddenURI) external onlyOwner {
1415         _myHiddenURI = _myNewHiddenURI;
1416     }
1417 
1418     function tokenURI(uint256 _tokenId) public view virtual override(ERC721A) returns (string memory) {
1419         if (!_exists(_tokenId)) revert URIQueryForNonexistentToken();
1420        
1421         if (revealed) {
1422             return bytes(_myBaseURI).length != 0 ? string(abi.encodePacked(_myBaseURI, _tokenId.toString(), ".json")) : "";
1423         } else {
1424             return bytes(_myHiddenURI).length != 0 ? _myHiddenURI : "";
1425         }
1426     }
1427 
1428     // note v0.8.0 checks safe math by default :)
1429     function mint(uint256 _mintAmount, bytes32[] calldata _merkleProof) external nonReentrant {
1430         if (!pre_sale) revert PreSaleInactive();
1431         if (tx.origin != _msgSender()) revert MintFromContract();
1432         if (totalSupply() + _mintAmount > max_supply) revert ExceedsMaxSupply();
1433 
1434         if (MerkleProof.verify(_merkleProof, merkle_root_team, keccak256(abi.encodePacked(_msgSender())))) {
1435             if (_numberMinted(_msgSender()) + _mintAmount > mint_limit_team) revert ExceedsTeamMintLimit();
1436         } 
1437         else if (MerkleProof.verify(_merkleProof, merkle_root_og, keccak256(abi.encodePacked(_msgSender())))) {
1438             if (_numberMinted(_msgSender()) + _mintAmount > mint_limit_og) revert ExceedsOGMintLimit();
1439         } 
1440         else if (MerkleProof.verify(_merkleProof, merkle_root_rekt, keccak256(abi.encodePacked(_msgSender())))) {
1441             if (_numberMinted(_msgSender()) + _mintAmount > mint_limit_rekt) revert ExceedsRektMintLimit();
1442         } 
1443         else {
1444             revert MerkleProofInvalid();
1445         }
1446         _safeMint(_msgSender(), _mintAmount);
1447     }
1448 
1449     function publicMint(uint256 _mintAmount) external nonReentrant {
1450         if (!public_sale) revert PublicSaleInactive();
1451         if (tx.origin != _msgSender()) revert MintFromContract();
1452         if (totalSupply() + _mintAmount > max_supply) revert ExceedsMaxSupply();
1453         if (_numberMinted(_msgSender()) + _mintAmount > mint_limit_public) revert ExceedsPublicMintLimit();
1454 
1455         _safeMint(_msgSender(), _mintAmount);
1456     }
1457 
1458     function ownerMint(uint256 _mintAmount) external onlyOwner {
1459         if (totalSupply() + _mintAmount > max_supply) revert ExceedsMaxSupply();
1460         _safeMint(_msgSender(), _mintAmount);
1461     }
1462 
1463     event DonationReceived(address sender, uint256 amount);
1464     receive() external payable {
1465         emit DonationReceived(msg.sender, msg.value);
1466     }
1467 
1468     function withdraw() external payable nonReentrant {
1469 
1470         (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1471         if (!success) revert WithdrawFailed();
1472     }
1473 }