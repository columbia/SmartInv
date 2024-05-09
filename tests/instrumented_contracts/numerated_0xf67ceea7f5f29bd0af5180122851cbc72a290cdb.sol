1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-11
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19     uint8 private constant _ADDRESS_LENGTH = 20;
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 
77     /**
78      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
79      */
80     function toHexString(address addr) internal pure returns (string memory) {
81         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Address.sol
86 
87 
88 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
89 
90 pragma solidity ^0.8.1;
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      *
113      * [IMPORTANT]
114      * ====
115      * You shouldn't rely on `isContract` to protect against flash loan attacks!
116      *
117      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
118      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
119      * constructor.
120      * ====
121      */
122     function isContract(address account) internal view returns (bool) {
123         // This method relies on extcodesize/address.code.length, which returns 0
124         // for contracts in construction, since the code is only stored at the end
125         // of the constructor execution.
126 
127         return account.code.length > 0;
128     }
129 
130     /**
131      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
132      * `recipient`, forwarding all available gas and reverting on errors.
133      *
134      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
135      * of certain opcodes, possibly making contracts go over the 2300 gas limit
136      * imposed by `transfer`, making them unable to receive funds via
137      * `transfer`. {sendValue} removes this limitation.
138      *
139      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
140      *
141      * IMPORTANT: because control is transferred to `recipient`, care must be
142      * taken to not create reentrancy vulnerabilities. Consider using
143      * {ReentrancyGuard} or the
144      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
145      */
146     function sendValue(address payable recipient, uint256 amount) internal {
147         require(address(this).balance >= amount, "Address: insufficient balance");
148 
149         (bool success, ) = recipient.call{value: amount}("");
150         require(success, "Address: unable to send value, recipient may have reverted");
151     }
152 
153     /**
154      * @dev Performs a Solidity function call using a low level `call`. A
155      * plain `call` is an unsafe replacement for a function call: use this
156      * function instead.
157      *
158      * If `target` reverts with a revert reason, it is bubbled up by this
159      * function (like regular Solidity function calls).
160      *
161      * Returns the raw returned data. To convert to the expected return value,
162      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
163      *
164      * Requirements:
165      *
166      * - `target` must be a contract.
167      * - calling `target` with `data` must not revert.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionCall(target, data, "Address: low-level call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
177      * `errorMessage` as a fallback revert reason when `target` reverts.
178      *
179      * _Available since v3.1._
180      */
181     function functionCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, 0, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but also transferring `value` wei to `target`.
192      *
193      * Requirements:
194      *
195      * - the calling contract must have an ETH balance of at least `value`.
196      * - the called Solidity function must be `payable`.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value
204     ) internal returns (bytes memory) {
205         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
210      * with `errorMessage` as a fallback revert reason when `target` reverts.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(address(this).balance >= value, "Address: insufficient balance for call");
221         require(isContract(target), "Address: call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.call{value: value}(data);
224         return verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
234         return functionStaticCall(target, data, "Address: low-level static call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
239      * but performing a static call.
240      *
241      * _Available since v3.3._
242      */
243     function functionStaticCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal view returns (bytes memory) {
248         require(isContract(target), "Address: static call to non-contract");
249 
250         (bool success, bytes memory returndata) = target.staticcall(data);
251         return verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
266      * but performing a delegate call.
267      *
268      * _Available since v3.4._
269      */
270     function functionDelegateCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(isContract(target), "Address: delegate call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.delegatecall(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
283      * revert reason using the provided one.
284      *
285      * _Available since v4.3._
286      */
287     function verifyCallResult(
288         bool success,
289         bytes memory returndata,
290         string memory errorMessage
291     ) internal pure returns (bytes memory) {
292         if (success) {
293             return returndata;
294         } else {
295             // Look for revert reason and bubble it up if present
296             if (returndata.length > 0) {
297                 // The easiest way to bubble the revert reason is using memory via assembly
298                 /// @solidity memory-safe-assembly
299                 assembly {
300                     let returndata_size := mload(returndata)
301                     revert(add(32, returndata), returndata_size)
302                 }
303             } else {
304                 revert(errorMessage);
305             }
306         }
307     }
308 }
309 
310 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @dev Contract module that helps prevent reentrant calls to a function.
319  *
320  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
321  * available, which can be applied to functions to make sure there are no nested
322  * (reentrant) calls to them.
323  *
324  * Note that because there is a single `nonReentrant` guard, functions marked as
325  * `nonReentrant` may not call one another. This can be worked around by making
326  * those functions `private`, and then adding `external` `nonReentrant` entry
327  * points to them.
328  *
329  * TIP: If you would like to learn more about reentrancy and alternative ways
330  * to protect against it, check out our blog post
331  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
332  */
333 abstract contract ReentrancyGuard {
334     // Booleans are more expensive than uint256 or any type that takes up a full
335     // word because each write operation emits an extra SLOAD to first read the
336     // slot's contents, replace the bits taken up by the boolean, and then write
337     // back. This is the compiler's defense against contract upgrades and
338     // pointer aliasing, and it cannot be disabled.
339 
340     // The values being non-zero value makes deployment a bit more expensive,
341     // but in exchange the refund on every call to nonReentrant will be lower in
342     // amount. Since refunds are capped to a percentage of the total
343     // transaction's gas, it is best to keep them low in cases like this one, to
344     // increase the likelihood of the full refund coming into effect.
345     uint256 private constant _NOT_ENTERED = 1;
346     uint256 private constant _ENTERED = 2;
347 
348     uint256 private _status;
349 
350     constructor() {
351         _status = _NOT_ENTERED;
352     }
353 
354     /**
355      * @dev Prevents a contract from calling itself, directly or indirectly.
356      * Calling a `nonReentrant` function from another `nonReentrant`
357      * function is not supported. It is possible to prevent this from happening
358      * by making the `nonReentrant` function external, and making it call a
359      * `private` function that does the actual work.
360      */
361     modifier nonReentrant() {
362         // On the first call to nonReentrant, _notEntered will be true
363         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
364 
365         // Any calls to nonReentrant after this point will fail
366         _status = _ENTERED;
367 
368         _;
369 
370         // By storing the original value once again, a refund is triggered (see
371         // https://eips.ethereum.org/EIPS/eip-2200)
372         _status = _NOT_ENTERED;
373     }
374 }
375 
376 // File: @openzeppelin/contracts/utils/Context.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 /**
384  * @dev Provides information about the current execution context, including the
385  * sender of the transaction and its data. While these are generally available
386  * via msg.sender and msg.data, they should not be accessed in such a direct
387  * manner, since when dealing with meta-transactions the account sending and
388  * paying for execution may not be the actual sender (as far as an application
389  * is concerned).
390  *
391  * This contract is only required for intermediate, library-like contracts.
392  */
393 abstract contract Context {
394     function _msgSender() internal view virtual returns (address) {
395         return msg.sender;
396     }
397 
398     function _msgData() internal view virtual returns (bytes calldata) {
399         return msg.data;
400     }
401 }
402 
403 // File: @openzeppelin/contracts/access/Ownable.sol
404 
405 
406 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 
411 /**
412  * @dev Contract module which provides a basic access control mechanism, where
413  * there is an account (an owner) that can be granted exclusive access to
414  * specific functions.
415  *
416  * By default, the owner account will be the one that deploys the contract. This
417  * can later be changed with {transferOwnership}.
418  *
419  * This module is used through inheritance. It will make available the modifier
420  * `onlyOwner`, which can be applied to your functions to restrict their use to
421  * the owner.
422  */
423 abstract contract Ownable is Context {
424     address private _owner;
425 
426     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
427 
428     /**
429      * @dev Initializes the contract setting the deployer as the initial owner.
430      */
431     constructor() {
432         _transferOwnership(_msgSender());
433     }
434 
435     /**
436      * @dev Throws if called by any account other than the owner.
437      */
438     modifier onlyOwner() {
439         _checkOwner();
440         _;
441     }
442 
443     /**
444      * @dev Returns the address of the current owner.
445      */
446     function owner() public view virtual returns (address) {
447         return _owner;
448     }
449 
450     /**
451      * @dev Throws if the sender is not the owner.
452      */
453     function _checkOwner() internal view virtual {
454         require(owner() == _msgSender(), "Ownable: caller is not the owner");
455     }
456 
457     /**
458      * @dev Leaves the contract without owner. It will not be possible to call
459      * `onlyOwner` functions anymore. Can only be called by the current owner.
460      *
461      * NOTE: Renouncing ownership will leave the contract without an owner,
462      * thereby removing any functionality that is only available to the owner.
463      */
464     function renounceOwnership() public virtual onlyOwner {
465         _transferOwnership(address(0));
466     }
467 
468     /**
469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
470      * Can only be called by the current owner.
471      */
472     function transferOwnership(address newOwner) public virtual onlyOwner {
473         require(newOwner != address(0), "Ownable: new owner is the zero address");
474         _transferOwnership(newOwner);
475     }
476 
477     /**
478      * @dev Transfers ownership of the contract to a new account (`newOwner`).
479      * Internal function without access restriction.
480      */
481     function _transferOwnership(address newOwner) internal virtual {
482         address oldOwner = _owner;
483         _owner = newOwner;
484         emit OwnershipTransferred(oldOwner, newOwner);
485     }
486 }
487 
488 // File: erc721a/contracts/IERC721A.sol
489 
490 
491 // ERC721A Contracts v4.1.0
492 // Creator: Chiru Labs
493 
494 pragma solidity ^0.8.4;
495 
496 /**
497  * @dev Interface of an ERC721A compliant contract.
498  */
499 interface IERC721A {
500     /**
501      * The caller must own the token or be an approved operator.
502      */
503     error ApprovalCallerNotOwnerNorApproved();
504 
505     /**
506      * The token does not exist.
507      */
508     error ApprovalQueryForNonexistentToken();
509 
510     /**
511      * The caller cannot approve to their own address.
512      */
513     error ApproveToCaller();
514 
515     /**
516      * Cannot query the balance for the zero address.
517      */
518     error BalanceQueryForZeroAddress();
519 
520     /**
521      * Cannot mint to the zero address.
522      */
523     error MintToZeroAddress();
524 
525     /**
526      * The quantity of tokens minted must be more than zero.
527      */
528     error MintZeroQuantity();
529 
530     /**
531      * The token does not exist.
532      */
533     error OwnerQueryForNonexistentToken();
534 
535     /**
536      * The caller must own the token or be an approved operator.
537      */
538     error TransferCallerNotOwnerNorApproved();
539 
540     /**
541      * The token must be owned by `from`.
542      */
543     error TransferFromIncorrectOwner();
544 
545     /**
546      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
547      */
548     error TransferToNonERC721ReceiverImplementer();
549 
550     /**
551      * Cannot transfer to the zero address.
552      */
553     error TransferToZeroAddress();
554 
555     /**
556      * The token does not exist.
557      */
558     error URIQueryForNonexistentToken();
559 
560     /**
561      * The `quantity` minted with ERC2309 exceeds the safety limit.
562      */
563     error MintERC2309QuantityExceedsLimit();
564 
565     /**
566      * The `extraData` cannot be set on an unintialized ownership slot.
567      */
568     error OwnershipNotInitializedForExtraData();
569 
570     struct TokenOwnership {
571         // The address of the owner.
572         address addr;
573         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
574         uint64 startTimestamp;
575         // Whether the token has been burned.
576         bool burned;
577         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
578         uint24 extraData;
579     }
580 
581     /**
582      * @dev Returns the total amount of tokens stored by the contract.
583      *
584      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
585      */
586     function totalSupply() external view returns (uint256);
587 
588     // ==============================
589     //            IERC165
590     // ==============================
591 
592     /**
593      * @dev Returns true if this contract implements the interface defined by
594      * `interfaceId`. See the corresponding
595      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
596      * to learn more about how these ids are created.
597      *
598      * This function call must use less than 30 000 gas.
599      */
600     function supportsInterface(bytes4 interfaceId) external view returns (bool);
601 
602     // ==============================
603     //            IERC721
604     // ==============================
605 
606     /**
607      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
608      */
609     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
610 
611     /**
612      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
613      */
614     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
615 
616     /**
617      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
618      */
619     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
620 
621     /**
622      * @dev Returns the number of tokens in ``owner``'s account.
623      */
624     function balanceOf(address owner) external view returns (uint256 balance);
625 
626     /**
627      * @dev Returns the owner of the `tokenId` token.
628      *
629      * Requirements:
630      *
631      * - `tokenId` must exist.
632      */
633     function ownerOf(uint256 tokenId) external view returns (address owner);
634 
635     /**
636      * @dev Safely transfers `tokenId` token from `from` to `to`.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
645      *
646      * Emits a {Transfer} event.
647      */
648     function safeTransferFrom(
649         address from,
650         address to,
651         uint256 tokenId,
652         bytes calldata data
653     ) external;
654 
655     /**
656      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
657      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must exist and be owned by `from`.
664      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
666      *
667      * Emits a {Transfer} event.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId
673     ) external;
674 
675     /**
676      * @dev Transfers `tokenId` token from `from` to `to`.
677      *
678      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must be owned by `from`.
685      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
686      *
687      * Emits a {Transfer} event.
688      */
689     function transferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) external;
694 
695     /**
696      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
697      * The approval is cleared when the token is transferred.
698      *
699      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
700      *
701      * Requirements:
702      *
703      * - The caller must own the token or be an approved operator.
704      * - `tokenId` must exist.
705      *
706      * Emits an {Approval} event.
707      */
708     function approve(address to, uint256 tokenId) external;
709 
710     /**
711      * @dev Approve or remove `operator` as an operator for the caller.
712      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
713      *
714      * Requirements:
715      *
716      * - The `operator` cannot be the caller.
717      *
718      * Emits an {ApprovalForAll} event.
719      */
720     function setApprovalForAll(address operator, bool _approved) external;
721 
722     /**
723      * @dev Returns the account approved for `tokenId` token.
724      *
725      * Requirements:
726      *
727      * - `tokenId` must exist.
728      */
729     function getApproved(uint256 tokenId) external view returns (address operator);
730 
731     /**
732      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
733      *
734      * See {setApprovalForAll}
735      */
736     function isApprovedForAll(address owner, address operator) external view returns (bool);
737 
738     // ==============================
739     //        IERC721Metadata
740     // ==============================
741 
742     /**
743      * @dev Returns the token collection name.
744      */
745     function name() external view returns (string memory);
746 
747     /**
748      * @dev Returns the token collection symbol.
749      */
750     function symbol() external view returns (string memory);
751 
752     /**
753      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
754      */
755     function tokenURI(uint256 tokenId) external view returns (string memory);
756 
757     // ==============================
758     //            IERC2309
759     // ==============================
760 
761     /**
762      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
763      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
764      */
765     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
766 }
767 
768 // File: erc721a/contracts/ERC721A.sol
769 
770 
771 // ERC721A Contracts v4.1.0
772 // Creator: Chiru Labs
773 
774 pragma solidity ^0.8.4;
775 
776 
777 /**
778  * @dev ERC721 token receiver interface.
779  */
780 interface ERC721A__IERC721Receiver {
781     function onERC721Received(
782         address operator,
783         address from,
784         uint256 tokenId,
785         bytes calldata data
786     ) external returns (bytes4);
787 }
788 
789 /**
790  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
791  * including the Metadata extension. Built to optimize for lower gas during batch mints.
792  *
793  * Assumes serials are sequentially minted starting at `_startTokenId()`
794  * (defaults to 0, e.g. 0, 1, 2, 3..).
795  *
796  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
797  *
798  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
799  */
800 contract ERC721A is IERC721A {
801     // Mask of an entry in packed address data.
802     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
803 
804     // The bit position of `numberMinted` in packed address data.
805     uint256 private constant BITPOS_NUMBER_MINTED = 64;
806 
807     // The bit position of `numberBurned` in packed address data.
808     uint256 private constant BITPOS_NUMBER_BURNED = 128;
809 
810     // The bit position of `aux` in packed address data.
811     uint256 private constant BITPOS_AUX = 192;
812 
813     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
814     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
815 
816     // The bit position of `startTimestamp` in packed ownership.
817     uint256 private constant BITPOS_START_TIMESTAMP = 160;
818 
819     // The bit mask of the `burned` bit in packed ownership.
820     uint256 private constant BITMASK_BURNED = 1 << 224;
821 
822     // The bit position of the `nextInitialized` bit in packed ownership.
823     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
824 
825     // The bit mask of the `nextInitialized` bit in packed ownership.
826     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
827 
828     // The bit position of `extraData` in packed ownership.
829     uint256 private constant BITPOS_EXTRA_DATA = 232;
830 
831     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
832     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
833 
834     // The mask of the lower 160 bits for addresses.
835     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
836 
837     // The maximum `quantity` that can be minted with `_mintERC2309`.
838     // This limit is to prevent overflows on the address data entries.
839     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
840     // is required to cause an overflow, which is unrealistic.
841     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
842 
843     // The tokenId of the next token to be minted.
844     uint256 private _currentIndex;
845 
846     // The number of tokens burned.
847     uint256 private _burnCounter;
848 
849     // Token name
850     string private _name;
851 
852     // Token symbol
853     string private _symbol;
854 
855     // Mapping from token ID to ownership details
856     // An empty struct value does not necessarily mean the token is unowned.
857     // See `_packedOwnershipOf` implementation for details.
858     //
859     // Bits Layout:
860     // - [0..159]   `addr`
861     // - [160..223] `startTimestamp`
862     // - [224]      `burned`
863     // - [225]      `nextInitialized`
864     // - [232..255] `extraData`
865     mapping(uint256 => uint256) private _packedOwnerships;
866 
867     // Mapping owner address to address data.
868     //
869     // Bits Layout:
870     // - [0..63]    `balance`
871     // - [64..127]  `numberMinted`
872     // - [128..191] `numberBurned`
873     // - [192..255] `aux`
874     mapping(address => uint256) private _packedAddressData;
875 
876     // Mapping from token ID to approved address.
877     mapping(uint256 => address) private _tokenApprovals;
878 
879     // Mapping from owner to operator approvals
880     mapping(address => mapping(address => bool)) private _operatorApprovals;
881 
882     constructor(string memory name_, string memory symbol_) {
883         _name = name_;
884         _symbol = symbol_;
885         _currentIndex = _startTokenId();
886     }
887 
888     /**
889      * @dev Returns the starting token ID.
890      * To change the starting token ID, please override this function.
891      */
892     function _startTokenId() internal view virtual returns (uint256) {
893         return 0;
894     }
895 
896     /**
897      * @dev Returns the next token ID to be minted.
898      */
899     function _nextTokenId() internal view returns (uint256) {
900         return _currentIndex;
901     }
902 
903     /**
904      * @dev Returns the total number of tokens in existence.
905      * Burned tokens will reduce the count.
906      * To get the total number of tokens minted, please see `_totalMinted`.
907      */
908     function totalSupply() public view override returns (uint256) {
909         // Counter underflow is impossible as _burnCounter cannot be incremented
910         // more than `_currentIndex - _startTokenId()` times.
911         unchecked {
912             return _currentIndex - _burnCounter - _startTokenId();
913         }
914     }
915 
916     /**
917      * @dev Returns the total amount of tokens minted in the contract.
918      */
919     function _totalMinted() internal view returns (uint256) {
920         // Counter underflow is impossible as _currentIndex does not decrement,
921         // and it is initialized to `_startTokenId()`
922         unchecked {
923             return _currentIndex - _startTokenId();
924         }
925     }
926 
927     /**
928      * @dev Returns the total number of tokens burned.
929      */
930     function _totalBurned() internal view returns (uint256) {
931         return _burnCounter;
932     }
933 
934     /**
935      * @dev See {IERC165-supportsInterface}.
936      */
937     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
938         // The interface IDs are constants representing the first 4 bytes of the XOR of
939         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
940         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
941         return
942             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
943             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
944             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
945     }
946 
947     /**
948      * @dev See {IERC721-balanceOf}.
949      */
950     function balanceOf(address owner) public view override returns (uint256) {
951         if (owner == address(0)) revert BalanceQueryForZeroAddress();
952         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
953     }
954 
955     /**
956      * Returns the number of tokens minted by `owner`.
957      */
958     function _numberMinted(address owner) internal view returns (uint256) {
959         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
960     }
961 
962     /**
963      * Returns the number of tokens burned by or on behalf of `owner`.
964      */
965     function _numberBurned(address owner) internal view returns (uint256) {
966         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
967     }
968 
969     /**
970      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
971      */
972     function _getAux(address owner) internal view returns (uint64) {
973         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
974     }
975 
976     /**
977      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
978      * If there are multiple variables, please pack them into a uint64.
979      */
980     function _setAux(address owner, uint64 aux) internal {
981         uint256 packed = _packedAddressData[owner];
982         uint256 auxCasted;
983         // Cast `aux` with assembly to avoid redundant masking.
984         assembly {
985             auxCasted := aux
986         }
987         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
988         _packedAddressData[owner] = packed;
989     }
990 
991     /**
992      * Returns the packed ownership data of `tokenId`.
993      */
994     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
995         uint256 curr = tokenId;
996 
997         unchecked {
998             if (_startTokenId() <= curr)
999                 if (curr < _currentIndex) {
1000                     uint256 packed = _packedOwnerships[curr];
1001                     // If not burned.
1002                     if (packed & BITMASK_BURNED == 0) {
1003                         // Invariant:
1004                         // There will always be an ownership that has an address and is not burned
1005                         // before an ownership that does not have an address and is not burned.
1006                         // Hence, curr will not underflow.
1007                         //
1008                         // We can directly compare the packed value.
1009                         // If the address is zero, packed is zero.
1010                         while (packed == 0) {
1011                             packed = _packedOwnerships[--curr];
1012                         }
1013                         return packed;
1014                     }
1015                 }
1016         }
1017         revert OwnerQueryForNonexistentToken();
1018     }
1019 
1020     /**
1021      * Returns the unpacked `TokenOwnership` struct from `packed`.
1022      */
1023     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1024         ownership.addr = address(uint160(packed));
1025         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1026         ownership.burned = packed & BITMASK_BURNED != 0;
1027         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1028     }
1029 
1030     /**
1031      * Returns the unpacked `TokenOwnership` struct at `index`.
1032      */
1033     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1034         return _unpackedOwnership(_packedOwnerships[index]);
1035     }
1036 
1037     /**
1038      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1039      */
1040     function _initializeOwnershipAt(uint256 index) internal {
1041         if (_packedOwnerships[index] == 0) {
1042             _packedOwnerships[index] = _packedOwnershipOf(index);
1043         }
1044     }
1045 
1046     /**
1047      * Gas spent here starts off proportional to the maximum mint batch size.
1048      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1049      */
1050     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1051         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1052     }
1053 
1054     /**
1055      * @dev Packs ownership data into a single uint256.
1056      */
1057     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1058         assembly {
1059             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1060             owner := and(owner, BITMASK_ADDRESS)
1061             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1062             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1063         }
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-ownerOf}.
1068      */
1069     function ownerOf(uint256 tokenId) public view override returns (address) {
1070         return address(uint160(_packedOwnershipOf(tokenId)));
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Metadata-name}.
1075      */
1076     function name() public view virtual override returns (string memory) {
1077         return _name;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Metadata-symbol}.
1082      */
1083     function symbol() public view virtual override returns (string memory) {
1084         return _symbol;
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Metadata-tokenURI}.
1089      */
1090     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1091         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1092 
1093         string memory baseURI = _baseURI();
1094         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1095     }
1096 
1097     /**
1098      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1099      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1100      * by default, it can be overridden in child contracts.
1101      */
1102     function _baseURI() internal view virtual returns (string memory) {
1103         return '';
1104     }
1105 
1106     /**
1107      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1108      */
1109     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1110         // For branchless setting of the `nextInitialized` flag.
1111         assembly {
1112             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1113             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1114         }
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-approve}.
1119      */
1120     function approve(address to, uint256 tokenId) public override {
1121         address owner = ownerOf(tokenId);
1122 
1123         if (_msgSenderERC721A() != owner)
1124             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1125                 revert ApprovalCallerNotOwnerNorApproved();
1126             }
1127 
1128         _tokenApprovals[tokenId] = to;
1129         emit Approval(owner, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-getApproved}.
1134      */
1135     function getApproved(uint256 tokenId) public view override returns (address) {
1136         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1137 
1138         return _tokenApprovals[tokenId];
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-setApprovalForAll}.
1143      */
1144     function setApprovalForAll(address operator, bool approved) public virtual override {
1145         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1146 
1147         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1148         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-isApprovedForAll}.
1153      */
1154     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1155         return _operatorApprovals[owner][operator];
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-safeTransferFrom}.
1160      */
1161     function safeTransferFrom(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) public virtual override {
1166         safeTransferFrom(from, to, tokenId, '');
1167     }
1168 
1169     /**
1170      * @dev See {IERC721-safeTransferFrom}.
1171      */
1172     function safeTransferFrom(
1173         address from,
1174         address to,
1175         uint256 tokenId,
1176         bytes memory _data
1177     ) public virtual override {
1178         transferFrom(from, to, tokenId);
1179         if (to.code.length != 0)
1180             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1181                 revert TransferToNonERC721ReceiverImplementer();
1182             }
1183     }
1184 
1185     /**
1186      * @dev Returns whether `tokenId` exists.
1187      *
1188      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1189      *
1190      * Tokens start existing when they are minted (`_mint`),
1191      */
1192     function _exists(uint256 tokenId) internal view returns (bool) {
1193         return
1194             _startTokenId() <= tokenId &&
1195             tokenId < _currentIndex && // If within bounds,
1196             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1197     }
1198 
1199     /**
1200      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1201      */
1202     function _safeMint(address to, uint256 quantity) internal {
1203         _safeMint(to, quantity, '');
1204     }
1205 
1206     /**
1207      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1208      *
1209      * Requirements:
1210      *
1211      * - If `to` refers to a smart contract, it must implement
1212      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1213      * - `quantity` must be greater than 0.
1214      *
1215      * See {_mint}.
1216      *
1217      * Emits a {Transfer} event for each mint.
1218      */
1219     function _safeMint(
1220         address to,
1221         uint256 quantity,
1222         bytes memory _data
1223     ) internal {
1224         _mint(to, quantity);
1225 
1226         unchecked {
1227             if (to.code.length != 0) {
1228                 uint256 end = _currentIndex;
1229                 uint256 index = end - quantity;
1230                 do {
1231                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1232                         revert TransferToNonERC721ReceiverImplementer();
1233                     }
1234                 } while (index < end);
1235                 // Reentrancy protection.
1236                 if (_currentIndex != end) revert();
1237             }
1238         }
1239     }
1240 
1241     /**
1242      * @dev Mints `quantity` tokens and transfers them to `to`.
1243      *
1244      * Requirements:
1245      *
1246      * - `to` cannot be the zero address.
1247      * - `quantity` must be greater than 0.
1248      *
1249      * Emits a {Transfer} event for each mint.
1250      */
1251     function _mint(address to, uint256 quantity) internal {
1252         uint256 startTokenId = _currentIndex;
1253         if (to == address(0)) revert MintToZeroAddress();
1254         if (quantity == 0) revert MintZeroQuantity();
1255 
1256         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1257 
1258         // Overflows are incredibly unrealistic.
1259         // `balance` and `numberMinted` have a maximum limit of 2**64.
1260         // `tokenId` has a maximum limit of 2**256.
1261         unchecked {
1262             // Updates:
1263             // - `balance += quantity`.
1264             // - `numberMinted += quantity`.
1265             //
1266             // We can directly add to the `balance` and `numberMinted`.
1267             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1268 
1269             // Updates:
1270             // - `address` to the owner.
1271             // - `startTimestamp` to the timestamp of minting.
1272             // - `burned` to `false`.
1273             // - `nextInitialized` to `quantity == 1`.
1274             _packedOwnerships[startTokenId] = _packOwnershipData(
1275                 to,
1276                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1277             );
1278 
1279             uint256 tokenId = startTokenId;
1280             uint256 end = startTokenId + quantity;
1281             do {
1282                 emit Transfer(address(0), to, tokenId++);
1283             } while (tokenId < end);
1284 
1285             _currentIndex = end;
1286         }
1287         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1288     }
1289 
1290     /**
1291      * @dev Mints `quantity` tokens and transfers them to `to`.
1292      *
1293      * This function is intended for efficient minting only during contract creation.
1294      *
1295      * It emits only one {ConsecutiveTransfer} as defined in
1296      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1297      * instead of a sequence of {Transfer} event(s).
1298      *
1299      * Calling this function outside of contract creation WILL make your contract
1300      * non-compliant with the ERC721 standard.
1301      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1302      * {ConsecutiveTransfer} event is only permissible during contract creation.
1303      *
1304      * Requirements:
1305      *
1306      * - `to` cannot be the zero address.
1307      * - `quantity` must be greater than 0.
1308      *
1309      * Emits a {ConsecutiveTransfer} event.
1310      */
1311     function _mintERC2309(address to, uint256 quantity) internal {
1312         uint256 startTokenId = _currentIndex;
1313         if (to == address(0)) revert MintToZeroAddress();
1314         if (quantity == 0) revert MintZeroQuantity();
1315         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1316 
1317         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1318 
1319         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1320         unchecked {
1321             // Updates:
1322             // - `balance += quantity`.
1323             // - `numberMinted += quantity`.
1324             //
1325             // We can directly add to the `balance` and `numberMinted`.
1326             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1327 
1328             // Updates:
1329             // - `address` to the owner.
1330             // - `startTimestamp` to the timestamp of minting.
1331             // - `burned` to `false`.
1332             // - `nextInitialized` to `quantity == 1`.
1333             _packedOwnerships[startTokenId] = _packOwnershipData(
1334                 to,
1335                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1336             );
1337 
1338             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1339 
1340             _currentIndex = startTokenId + quantity;
1341         }
1342         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1343     }
1344 
1345     /**
1346      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1347      */
1348     function _getApprovedAddress(uint256 tokenId)
1349         private
1350         view
1351         returns (uint256 approvedAddressSlot, address approvedAddress)
1352     {
1353         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1354         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1355         assembly {
1356             // Compute the slot.
1357             mstore(0x00, tokenId)
1358             mstore(0x20, tokenApprovalsPtr.slot)
1359             approvedAddressSlot := keccak256(0x00, 0x40)
1360             // Load the slot's value from storage.
1361             approvedAddress := sload(approvedAddressSlot)
1362         }
1363     }
1364 
1365     /**
1366      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1367      */
1368     function _isOwnerOrApproved(
1369         address approvedAddress,
1370         address from,
1371         address msgSender
1372     ) private pure returns (bool result) {
1373         assembly {
1374             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1375             from := and(from, BITMASK_ADDRESS)
1376             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1377             msgSender := and(msgSender, BITMASK_ADDRESS)
1378             // `msgSender == from || msgSender == approvedAddress`.
1379             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1380         }
1381     }
1382 
1383     /**
1384      * @dev Transfers `tokenId` from `from` to `to`.
1385      *
1386      * Requirements:
1387      *
1388      * - `to` cannot be the zero address.
1389      * - `tokenId` token must be owned by `from`.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function transferFrom(
1394         address from,
1395         address to,
1396         uint256 tokenId
1397     ) public virtual override {
1398         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1399 
1400         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1401 
1402         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1403 
1404         // The nested ifs save around 20+ gas over a compound boolean condition.
1405         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1406             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1407 
1408         if (to == address(0)) revert TransferToZeroAddress();
1409 
1410         _beforeTokenTransfers(from, to, tokenId, 1);
1411 
1412         // Clear approvals from the previous owner.
1413         assembly {
1414             if approvedAddress {
1415                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1416                 sstore(approvedAddressSlot, 0)
1417             }
1418         }
1419 
1420         // Underflow of the sender's balance is impossible because we check for
1421         // ownership above and the recipient's balance can't realistically overflow.
1422         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1423         unchecked {
1424             // We can directly increment and decrement the balances.
1425             --_packedAddressData[from]; // Updates: `balance -= 1`.
1426             ++_packedAddressData[to]; // Updates: `balance += 1`.
1427 
1428             // Updates:
1429             // - `address` to the next owner.
1430             // - `startTimestamp` to the timestamp of transfering.
1431             // - `burned` to `false`.
1432             // - `nextInitialized` to `true`.
1433             _packedOwnerships[tokenId] = _packOwnershipData(
1434                 to,
1435                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1436             );
1437 
1438             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1439             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1440                 uint256 nextTokenId = tokenId + 1;
1441                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1442                 if (_packedOwnerships[nextTokenId] == 0) {
1443                     // If the next slot is within bounds.
1444                     if (nextTokenId != _currentIndex) {
1445                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1446                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1447                     }
1448                 }
1449             }
1450         }
1451 
1452         emit Transfer(from, to, tokenId);
1453         _afterTokenTransfers(from, to, tokenId, 1);
1454     }
1455 
1456     /**
1457      * @dev Equivalent to `_burn(tokenId, false)`.
1458      */
1459     function _burn(uint256 tokenId) internal virtual {
1460         _burn(tokenId, false);
1461     }
1462 
1463     /**
1464      * @dev Destroys `tokenId`.
1465      * The approval is cleared when the token is burned.
1466      *
1467      * Requirements:
1468      *
1469      * - `tokenId` must exist.
1470      *
1471      * Emits a {Transfer} event.
1472      */
1473     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1474         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1475 
1476         address from = address(uint160(prevOwnershipPacked));
1477 
1478         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1479 
1480         if (approvalCheck) {
1481             // The nested ifs save around 20+ gas over a compound boolean condition.
1482             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1483                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1484         }
1485 
1486         _beforeTokenTransfers(from, address(0), tokenId, 1);
1487 
1488         // Clear approvals from the previous owner.
1489         assembly {
1490             if approvedAddress {
1491                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1492                 sstore(approvedAddressSlot, 0)
1493             }
1494         }
1495 
1496         // Underflow of the sender's balance is impossible because we check for
1497         // ownership above and the recipient's balance can't realistically overflow.
1498         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1499         unchecked {
1500             // Updates:
1501             // - `balance -= 1`.
1502             // - `numberBurned += 1`.
1503             //
1504             // We can directly decrement the balance, and increment the number burned.
1505             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1506             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1507 
1508             // Updates:
1509             // - `address` to the last owner.
1510             // - `startTimestamp` to the timestamp of burning.
1511             // - `burned` to `true`.
1512             // - `nextInitialized` to `true`.
1513             _packedOwnerships[tokenId] = _packOwnershipData(
1514                 from,
1515                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1516             );
1517 
1518             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1519             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1520                 uint256 nextTokenId = tokenId + 1;
1521                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1522                 if (_packedOwnerships[nextTokenId] == 0) {
1523                     // If the next slot is within bounds.
1524                     if (nextTokenId != _currentIndex) {
1525                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1526                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1527                     }
1528                 }
1529             }
1530         }
1531 
1532         emit Transfer(from, address(0), tokenId);
1533         _afterTokenTransfers(from, address(0), tokenId, 1);
1534 
1535         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1536         unchecked {
1537             _burnCounter++;
1538         }
1539     }
1540 
1541     /**
1542      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1543      *
1544      * @param from address representing the previous owner of the given token ID
1545      * @param to target address that will receive the tokens
1546      * @param tokenId uint256 ID of the token to be transferred
1547      * @param _data bytes optional data to send along with the call
1548      * @return bool whether the call correctly returned the expected magic value
1549      */
1550     function _checkContractOnERC721Received(
1551         address from,
1552         address to,
1553         uint256 tokenId,
1554         bytes memory _data
1555     ) private returns (bool) {
1556         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1557             bytes4 retval
1558         ) {
1559             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1560         } catch (bytes memory reason) {
1561             if (reason.length == 0) {
1562                 revert TransferToNonERC721ReceiverImplementer();
1563             } else {
1564                 assembly {
1565                     revert(add(32, reason), mload(reason))
1566                 }
1567             }
1568         }
1569     }
1570 
1571     /**
1572      * @dev Directly sets the extra data for the ownership data `index`.
1573      */
1574     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1575         uint256 packed = _packedOwnerships[index];
1576         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1577         uint256 extraDataCasted;
1578         // Cast `extraData` with assembly to avoid redundant masking.
1579         assembly {
1580             extraDataCasted := extraData
1581         }
1582         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1583         _packedOwnerships[index] = packed;
1584     }
1585 
1586     /**
1587      * @dev Returns the next extra data for the packed ownership data.
1588      * The returned result is shifted into position.
1589      */
1590     function _nextExtraData(
1591         address from,
1592         address to,
1593         uint256 prevOwnershipPacked
1594     ) private view returns (uint256) {
1595         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1596         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1597     }
1598 
1599     /**
1600      * @dev Called during each token transfer to set the 24bit `extraData` field.
1601      * Intended to be overridden by the cosumer contract.
1602      *
1603      * `previousExtraData` - the value of `extraData` before transfer.
1604      *
1605      * Calling conditions:
1606      *
1607      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1608      * transferred to `to`.
1609      * - When `from` is zero, `tokenId` will be minted for `to`.
1610      * - When `to` is zero, `tokenId` will be burned by `from`.
1611      * - `from` and `to` are never both zero.
1612      */
1613     function _extraData(
1614         address from,
1615         address to,
1616         uint24 previousExtraData
1617     ) internal view virtual returns (uint24) {}
1618 
1619     /**
1620      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1621      * This includes minting.
1622      * And also called before burning one token.
1623      *
1624      * startTokenId - the first token id to be transferred
1625      * quantity - the amount to be transferred
1626      *
1627      * Calling conditions:
1628      *
1629      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1630      * transferred to `to`.
1631      * - When `from` is zero, `tokenId` will be minted for `to`.
1632      * - When `to` is zero, `tokenId` will be burned by `from`.
1633      * - `from` and `to` are never both zero.
1634      */
1635     function _beforeTokenTransfers(
1636         address from,
1637         address to,
1638         uint256 startTokenId,
1639         uint256 quantity
1640     ) internal virtual {}
1641 
1642     /**
1643      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1644      * This includes minting.
1645      * And also called after one token has been burned.
1646      *
1647      * startTokenId - the first token id to be transferred
1648      * quantity - the amount to be transferred
1649      *
1650      * Calling conditions:
1651      *
1652      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1653      * transferred to `to`.
1654      * - When `from` is zero, `tokenId` has been minted for `to`.
1655      * - When `to` is zero, `tokenId` has been burned by `from`.
1656      * - `from` and `to` are never both zero.
1657      */
1658     function _afterTokenTransfers(
1659         address from,
1660         address to,
1661         uint256 startTokenId,
1662         uint256 quantity
1663     ) internal virtual {}
1664 
1665     /**
1666      * @dev Returns the message sender (defaults to `msg.sender`).
1667      *
1668      * If you are writing GSN compatible contracts, you need to override this function.
1669      */
1670     function _msgSenderERC721A() internal view virtual returns (address) {
1671         return msg.sender;
1672     }
1673 
1674     /**
1675      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1676      */
1677     function _toString(uint256 value) internal pure returns (string memory ptr) {
1678         assembly {
1679             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1680             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1681             // We will need 1 32-byte word to store the length,
1682             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1683             ptr := add(mload(0x40), 128)
1684             // Update the free memory pointer to allocate.
1685             mstore(0x40, ptr)
1686 
1687             // Cache the end of the memory to calculate the length later.
1688             let end := ptr
1689 
1690             // We write the string from the rightmost digit to the leftmost digit.
1691             // The following is essentially a do-while loop that also handles the zero case.
1692             // Costs a bit more than early returning for the zero case,
1693             // but cheaper in terms of deployment and overall runtime costs.
1694             for {
1695                 // Initialize and perform the first pass without check.
1696                 let temp := value
1697                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1698                 ptr := sub(ptr, 1)
1699                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1700                 mstore8(ptr, add(48, mod(temp, 10)))
1701                 temp := div(temp, 10)
1702             } temp {
1703                 // Keep dividing `temp` until zero.
1704                 temp := div(temp, 10)
1705             } {
1706                 // Body of the for loop.
1707                 ptr := sub(ptr, 1)
1708                 mstore8(ptr, add(48, mod(temp, 10)))
1709             }
1710 
1711             let length := sub(end, ptr)
1712             // Move the pointer 32 bytes leftwards to make room for the length.
1713             ptr := sub(ptr, 32)
1714             // Store the length.
1715             mstore(ptr, length)
1716         }
1717     }
1718 }
1719 
1720 // File: contracts/The Australians.sol
1721 
1722 pragma solidity ^0.8.0;
1723 
1724 
1725 
1726 
1727 
1728 
1729 contract TheAustralians is ERC721A, Ownable, ReentrancyGuard {
1730   using Address for address;
1731   using Strings for uint;
1732 
1733   string  public  baseTokenURI = "ipfs://QmUDZyuR5g6WcvGg5mhak5BqrBnmHgxgNbn6UpKNZsfU6g/";
1734 
1735   uint256 public  maxSupply = 6969;
1736   uint256 public  MAX_MINTS_PER_TX = 20;
1737   uint256 public  maxPerAddress = 100;
1738   uint256 public  FREE_MINTS_PER_TX = 5;
1739   uint256 public  PUBLIC_SALE_PRICE = 0.002 ether;
1740   uint256 public  TOTAL_FREE_MINTS = 6969;
1741   bool public isPublicSaleActive = false;
1742 
1743   constructor() ERC721A("The Australians", "AUSSIES") {
1744 
1745   }
1746 
1747   function mint(uint256 numberOfTokens)
1748       external
1749       payable
1750   {
1751     require(isPublicSaleActive, "Public sale is not open");
1752     require(
1753       totalSupply() + numberOfTokens <= maxSupply,
1754       "Maximum supply exceeded"
1755     );
1756     if(totalSupply() + numberOfTokens > TOTAL_FREE_MINTS || numberOfTokens > FREE_MINTS_PER_TX){
1757         require(
1758             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1759             "Incorrect ETH value sent"
1760         );
1761     }
1762     _safeMint(msg.sender, numberOfTokens);
1763   }
1764 
1765   function setBaseURI(string memory baseURI)
1766     public
1767     onlyOwner
1768   {
1769     baseTokenURI = baseURI;
1770   }
1771 
1772   function _startTokenId() internal view virtual override returns (uint256) {
1773         return 1;
1774     }
1775 
1776   function treasuryMint(uint quantity, address user)
1777     public
1778     onlyOwner
1779   {
1780     require(
1781       quantity > 0,
1782       "Invalid mint amount"
1783     );
1784     require(
1785       totalSupply() + quantity <= maxSupply,
1786       "Maximum supply exceeded"
1787     );
1788     _safeMint(user, quantity);
1789   }
1790 
1791   function withdraw()
1792     public
1793     onlyOwner
1794     nonReentrant
1795   {
1796     Address.sendValue(payable(msg.sender), address(this).balance);
1797   }
1798 
1799   function tokenURI(uint _tokenId)
1800     public
1801     view
1802     virtual
1803     override
1804     returns (string memory)
1805   {
1806     require(
1807       _exists(_tokenId),
1808       "ERC721Metadata: URI query for nonexistent token"
1809     );
1810     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1811   }
1812 
1813   function _baseURI()
1814     internal
1815     view
1816     virtual
1817     override
1818     returns (string memory)
1819   {
1820     return baseTokenURI;
1821   }
1822 
1823   function setIsPublicSaleActive(bool _isPublicSaleActive)
1824       external
1825       onlyOwner
1826   {
1827       isPublicSaleActive = _isPublicSaleActive;
1828   }
1829 
1830   function setNumFreeMints(uint256 _numfreemints)
1831       external
1832       onlyOwner
1833   {
1834       TOTAL_FREE_MINTS = _numfreemints;
1835   }
1836 
1837   function setSalePrice(uint256 _price)
1838       external
1839       onlyOwner
1840   {
1841       PUBLIC_SALE_PRICE = _price;
1842   }
1843 
1844   function setMaxLimitPerTransaction(uint256 _limit)
1845       external
1846       onlyOwner
1847   {
1848       MAX_MINTS_PER_TX = _limit;
1849   }
1850 
1851 }