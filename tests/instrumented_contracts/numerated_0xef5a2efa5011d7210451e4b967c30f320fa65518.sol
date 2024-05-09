1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-29
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
491 // ERC721A Contracts v4.2.2
492 // Creator: Chiru Labs
493 
494 pragma solidity ^0.8.4;
495 
496 /**
497  * @dev Interface of ERC721A.
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
546      * Cannot safely transfer to a contract that does not implement the
547      * ERC721Receiver interface.
548      */
549     error TransferToNonERC721ReceiverImplementer();
550 
551     /**
552      * Cannot transfer to the zero address.
553      */
554     error TransferToZeroAddress();
555 
556     /**
557      * The token does not exist.
558      */
559     error URIQueryForNonexistentToken();
560 
561     /**
562      * The `quantity` minted with ERC2309 exceeds the safety limit.
563      */
564     error MintERC2309QuantityExceedsLimit();
565 
566     /**
567      * The `extraData` cannot be set on an unintialized ownership slot.
568      */
569     error OwnershipNotInitializedForExtraData();
570 
571     // =============================================================
572     //                            STRUCTS
573     // =============================================================
574 
575     struct TokenOwnership {
576         // The address of the owner.
577         address addr;
578         // Stores the start time of ownership with minimal overhead for tokenomics.
579         uint64 startTimestamp;
580         // Whether the token has been burned.
581         bool burned;
582         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
583         uint24 extraData;
584     }
585 
586     // =============================================================
587     //                         TOKEN COUNTERS
588     // =============================================================
589 
590     /**
591      * @dev Returns the total number of tokens in existence.
592      * Burned tokens will reduce the count.
593      * To get the total number of tokens minted, please see {_totalMinted}.
594      */
595     function totalSupply() external view returns (uint256);
596 
597     // =============================================================
598     //                            IERC165
599     // =============================================================
600 
601     /**
602      * @dev Returns true if this contract implements the interface defined by
603      * `interfaceId`. See the corresponding
604      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
605      * to learn more about how these ids are created.
606      *
607      * This function call must use less than 30000 gas.
608      */
609     function supportsInterface(bytes4 interfaceId) external view returns (bool);
610 
611     // =============================================================
612     //                            IERC721
613     // =============================================================
614 
615     /**
616      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
617      */
618     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
619 
620     /**
621      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
622      */
623     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
624 
625     /**
626      * @dev Emitted when `owner` enables or disables
627      * (`approved`) `operator` to manage all of its assets.
628      */
629     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
630 
631     /**
632      * @dev Returns the number of tokens in `owner`'s account.
633      */
634     function balanceOf(address owner) external view returns (uint256 balance);
635 
636     /**
637      * @dev Returns the owner of the `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function ownerOf(uint256 tokenId) external view returns (address owner);
644 
645     /**
646      * @dev Safely transfers `tokenId` token from `from` to `to`,
647      * checking first that contract recipients are aware of the ERC721 protocol
648      * to prevent tokens from being forever locked.
649      *
650      * Requirements:
651      *
652      * - `from` cannot be the zero address.
653      * - `to` cannot be the zero address.
654      * - `tokenId` token must exist and be owned by `from`.
655      * - If the caller is not `from`, it must be have been allowed to move
656      * this token by either {approve} or {setApprovalForAll}.
657      * - If `to` refers to a smart contract, it must implement
658      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
659      *
660      * Emits a {Transfer} event.
661      */
662     function safeTransferFrom(
663         address from,
664         address to,
665         uint256 tokenId,
666         bytes calldata data
667     ) external;
668 
669     /**
670      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external;
677 
678     /**
679      * @dev Transfers `tokenId` from `from` to `to`.
680      *
681      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
682      * whenever possible.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must be owned by `from`.
689      * - If the caller is not `from`, it must be approved to move this token
690      * by either {approve} or {setApprovalForAll}.
691      *
692      * Emits a {Transfer} event.
693      */
694     function transferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) external;
699 
700     /**
701      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
702      * The approval is cleared when the token is transferred.
703      *
704      * Only a single account can be approved at a time, so approving the
705      * zero address clears previous approvals.
706      *
707      * Requirements:
708      *
709      * - The caller must own the token or be an approved operator.
710      * - `tokenId` must exist.
711      *
712      * Emits an {Approval} event.
713      */
714     function approve(address to, uint256 tokenId) external;
715 
716     /**
717      * @dev Approve or remove `operator` as an operator for the caller.
718      * Operators can call {transferFrom} or {safeTransferFrom}
719      * for any token owned by the caller.
720      *
721      * Requirements:
722      *
723      * - The `operator` cannot be the caller.
724      *
725      * Emits an {ApprovalForAll} event.
726      */
727     function setApprovalForAll(address operator, bool _approved) external;
728 
729     /**
730      * @dev Returns the account approved for `tokenId` token.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function getApproved(uint256 tokenId) external view returns (address operator);
737 
738     /**
739      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
740      *
741      * See {setApprovalForAll}.
742      */
743     function isApprovedForAll(address owner, address operator) external view returns (bool);
744 
745     // =============================================================
746     //                        IERC721Metadata
747     // =============================================================
748 
749     /**
750      * @dev Returns the token collection name.
751      */
752     function name() external view returns (string memory);
753 
754     /**
755      * @dev Returns the token collection symbol.
756      */
757     function symbol() external view returns (string memory);
758 
759     /**
760      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
761      */
762     function tokenURI(uint256 tokenId) external view returns (string memory);
763 
764     // =============================================================
765     //                           IERC2309
766     // =============================================================
767 
768     /**
769      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
770      * (inclusive) is transferred from `from` to `to`, as defined in the
771      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
772      *
773      * See {_mintERC2309} for more details.
774      */
775     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
776 }
777 
778 // File: erc721a/contracts/ERC721A.sol
779 
780 
781 // ERC721A Contracts v4.2.2
782 // Creator: Chiru Labs
783 
784 pragma solidity ^0.8.4;
785 
786 
787 /**
788  * @dev Interface of ERC721 token receiver.
789  */
790 interface ERC721A__IERC721Receiver {
791     function onERC721Received(
792         address operator,
793         address from,
794         uint256 tokenId,
795         bytes calldata data
796     ) external returns (bytes4);
797 }
798 
799 /**
800  * @title ERC721A
801  *
802  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
803  * Non-Fungible Token Standard, including the Metadata extension.
804  * Optimized for lower gas during batch mints.
805  *
806  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
807  * starting from `_startTokenId()`.
808  *
809  * Assumptions:
810  *
811  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
812  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
813  */
814 contract ERC721A is IERC721A {
815     // Reference type for token approval.
816     struct TokenApprovalRef {
817         address value;
818     }
819 
820     // =============================================================
821     //                           CONSTANTS
822     // =============================================================
823 
824     // Mask of an entry in packed address data.
825     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
826 
827     // The bit position of `numberMinted` in packed address data.
828     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
829 
830     // The bit position of `numberBurned` in packed address data.
831     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
832 
833     // The bit position of `aux` in packed address data.
834     uint256 private constant _BITPOS_AUX = 192;
835 
836     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
837     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
838 
839     // The bit position of `startTimestamp` in packed ownership.
840     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
841 
842     // The bit mask of the `burned` bit in packed ownership.
843     uint256 private constant _BITMASK_BURNED = 1 << 224;
844 
845     // The bit position of the `nextInitialized` bit in packed ownership.
846     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
847 
848     // The bit mask of the `nextInitialized` bit in packed ownership.
849     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
850 
851     // The bit position of `extraData` in packed ownership.
852     uint256 private constant _BITPOS_EXTRA_DATA = 232;
853 
854     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
855     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
856 
857     // The mask of the lower 160 bits for addresses.
858     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
859 
860     // The maximum `quantity` that can be minted with {_mintERC2309}.
861     // This limit is to prevent overflows on the address data entries.
862     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
863     // is required to cause an overflow, which is unrealistic.
864     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
865 
866     // The `Transfer` event signature is given by:
867     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
868     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
869         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
870 
871     // =============================================================
872     //                            STORAGE
873     // =============================================================
874 
875     // The next token ID to be minted.
876     uint256 private _currentIndex;
877 
878     // The number of tokens burned.
879     uint256 private _burnCounter;
880 
881     // Token name
882     string private _name;
883 
884     // Token symbol
885     string private _symbol;
886 
887     // Mapping from token ID to ownership details
888     // An empty struct value does not necessarily mean the token is unowned.
889     // See {_packedOwnershipOf} implementation for details.
890     //
891     // Bits Layout:
892     // - [0..159]   `addr`
893     // - [160..223] `startTimestamp`
894     // - [224]      `burned`
895     // - [225]      `nextInitialized`
896     // - [232..255] `extraData`
897     mapping(uint256 => uint256) private _packedOwnerships;
898 
899     // Mapping owner address to address data.
900     //
901     // Bits Layout:
902     // - [0..63]    `balance`
903     // - [64..127]  `numberMinted`
904     // - [128..191] `numberBurned`
905     // - [192..255] `aux`
906     mapping(address => uint256) private _packedAddressData;
907 
908     // Mapping from token ID to approved address.
909     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
910 
911     // Mapping from owner to operator approvals
912     mapping(address => mapping(address => bool)) private _operatorApprovals;
913 
914     // =============================================================
915     //                          CONSTRUCTOR
916     // =============================================================
917 
918     constructor(string memory name_, string memory symbol_) {
919         _name = name_;
920         _symbol = symbol_;
921         _currentIndex = _startTokenId();
922     }
923 
924     // =============================================================
925     //                   TOKEN COUNTING OPERATIONS
926     // =============================================================
927 
928     /**
929      * @dev Returns the starting token ID.
930      * To change the starting token ID, please override this function.
931      */
932     function _startTokenId() internal view virtual returns (uint256) {
933         return 0;
934     }
935 
936     /**
937      * @dev Returns the next token ID to be minted.
938      */
939     function _nextTokenId() internal view virtual returns (uint256) {
940         return _currentIndex;
941     }
942 
943     /**
944      * @dev Returns the total number of tokens in existence.
945      * Burned tokens will reduce the count.
946      * To get the total number of tokens minted, please see {_totalMinted}.
947      */
948     function totalSupply() public view virtual override returns (uint256) {
949         // Counter underflow is impossible as _burnCounter cannot be incremented
950         // more than `_currentIndex - _startTokenId()` times.
951         unchecked {
952             return _currentIndex - _burnCounter - _startTokenId();
953         }
954     }
955 
956     /**
957      * @dev Returns the total amount of tokens minted in the contract.
958      */
959     function _totalMinted() internal view virtual returns (uint256) {
960         // Counter underflow is impossible as `_currentIndex` does not decrement,
961         // and it is initialized to `_startTokenId()`.
962         unchecked {
963             return _currentIndex - _startTokenId();
964         }
965     }
966 
967     /**
968      * @dev Returns the total number of tokens burned.
969      */
970     function _totalBurned() internal view virtual returns (uint256) {
971         return _burnCounter;
972     }
973 
974     // =============================================================
975     //                    ADDRESS DATA OPERATIONS
976     // =============================================================
977 
978     /**
979      * @dev Returns the number of tokens in `owner`'s account.
980      */
981     function balanceOf(address owner) public view virtual override returns (uint256) {
982         if (owner == address(0)) revert BalanceQueryForZeroAddress();
983         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
984     }
985 
986     /**
987      * Returns the number of tokens minted by `owner`.
988      */
989     function _numberMinted(address owner) internal view returns (uint256) {
990         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
991     }
992 
993     /**
994      * Returns the number of tokens burned by or on behalf of `owner`.
995      */
996     function _numberBurned(address owner) internal view returns (uint256) {
997         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
998     }
999 
1000     /**
1001      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1002      */
1003     function _getAux(address owner) internal view returns (uint64) {
1004         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1005     }
1006 
1007     /**
1008      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1009      * If there are multiple variables, please pack them into a uint64.
1010      */
1011     function _setAux(address owner, uint64 aux) internal virtual {
1012         uint256 packed = _packedAddressData[owner];
1013         uint256 auxCasted;
1014         // Cast `aux` with assembly to avoid redundant masking.
1015         assembly {
1016             auxCasted := aux
1017         }
1018         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1019         _packedAddressData[owner] = packed;
1020     }
1021 
1022     // =============================================================
1023     //                            IERC165
1024     // =============================================================
1025 
1026     /**
1027      * @dev Returns true if this contract implements the interface defined by
1028      * `interfaceId`. See the corresponding
1029      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1030      * to learn more about how these ids are created.
1031      *
1032      * This function call must use less than 30000 gas.
1033      */
1034     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1035         // The interface IDs are constants representing the first 4 bytes
1036         // of the XOR of all function selectors in the interface.
1037         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1038         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1039         return
1040             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1041             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1042             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1043     }
1044 
1045     // =============================================================
1046     //                        IERC721Metadata
1047     // =============================================================
1048 
1049     /**
1050      * @dev Returns the token collection name.
1051      */
1052     function name() public view virtual override returns (string memory) {
1053         return _name;
1054     }
1055 
1056     /**
1057      * @dev Returns the token collection symbol.
1058      */
1059     function symbol() public view virtual override returns (string memory) {
1060         return _symbol;
1061     }
1062 
1063     /**
1064      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1065      */
1066     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1067         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1068 
1069         string memory baseURI = _baseURI();
1070         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1071     }
1072 
1073     /**
1074      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1075      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1076      * by default, it can be overridden in child contracts.
1077      */
1078     function _baseURI() internal view virtual returns (string memory) {
1079         return '';
1080     }
1081 
1082     // =============================================================
1083     //                     OWNERSHIPS OPERATIONS
1084     // =============================================================
1085 
1086     /**
1087      * @dev Returns the owner of the `tokenId` token.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      */
1093     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1094         return address(uint160(_packedOwnershipOf(tokenId)));
1095     }
1096 
1097     /**
1098      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1099      * It gradually moves to O(1) as tokens get transferred around over time.
1100      */
1101     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1102         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1103     }
1104 
1105     /**
1106      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1107      */
1108     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1109         return _unpackedOwnership(_packedOwnerships[index]);
1110     }
1111 
1112     /**
1113      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1114      */
1115     function _initializeOwnershipAt(uint256 index) internal virtual {
1116         if (_packedOwnerships[index] == 0) {
1117             _packedOwnerships[index] = _packedOwnershipOf(index);
1118         }
1119     }
1120 
1121     /**
1122      * Returns the packed ownership data of `tokenId`.
1123      */
1124     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1125         uint256 curr = tokenId;
1126 
1127         unchecked {
1128             if (_startTokenId() <= curr)
1129                 if (curr < _currentIndex) {
1130                     uint256 packed = _packedOwnerships[curr];
1131                     // If not burned.
1132                     if (packed & _BITMASK_BURNED == 0) {
1133                         // Invariant:
1134                         // There will always be an initialized ownership slot
1135                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1136                         // before an unintialized ownership slot
1137                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1138                         // Hence, `curr` will not underflow.
1139                         //
1140                         // We can directly compare the packed value.
1141                         // If the address is zero, packed will be zero.
1142                         while (packed == 0) {
1143                             packed = _packedOwnerships[--curr];
1144                         }
1145                         return packed;
1146                     }
1147                 }
1148         }
1149         revert OwnerQueryForNonexistentToken();
1150     }
1151 
1152     /**
1153      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1154      */
1155     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1156         ownership.addr = address(uint160(packed));
1157         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1158         ownership.burned = packed & _BITMASK_BURNED != 0;
1159         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1160     }
1161 
1162     /**
1163      * @dev Packs ownership data into a single uint256.
1164      */
1165     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1166         assembly {
1167             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1168             owner := and(owner, _BITMASK_ADDRESS)
1169             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1170             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1171         }
1172     }
1173 
1174     /**
1175      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1176      */
1177     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1178         // For branchless setting of the `nextInitialized` flag.
1179         assembly {
1180             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1181             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1182         }
1183     }
1184 
1185     // =============================================================
1186     //                      APPROVAL OPERATIONS
1187     // =============================================================
1188 
1189     /**
1190      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1191      * The approval is cleared when the token is transferred.
1192      *
1193      * Only a single account can be approved at a time, so approving the
1194      * zero address clears previous approvals.
1195      *
1196      * Requirements:
1197      *
1198      * - The caller must own the token or be an approved operator.
1199      * - `tokenId` must exist.
1200      *
1201      * Emits an {Approval} event.
1202      */
1203     function approve(address to, uint256 tokenId) public virtual override {
1204         address owner = ownerOf(tokenId);
1205 
1206         if (_msgSenderERC721A() != owner)
1207             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1208                 revert ApprovalCallerNotOwnerNorApproved();
1209             }
1210 
1211         _tokenApprovals[tokenId].value = to;
1212         emit Approval(owner, to, tokenId);
1213     }
1214 
1215     /**
1216      * @dev Returns the account approved for `tokenId` token.
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must exist.
1221      */
1222     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1223         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1224 
1225         return _tokenApprovals[tokenId].value;
1226     }
1227 
1228     /**
1229      * @dev Approve or remove `operator` as an operator for the caller.
1230      * Operators can call {transferFrom} or {safeTransferFrom}
1231      * for any token owned by the caller.
1232      *
1233      * Requirements:
1234      *
1235      * - The `operator` cannot be the caller.
1236      *
1237      * Emits an {ApprovalForAll} event.
1238      */
1239     function setApprovalForAll(address operator, bool approved) public virtual override {
1240         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1241 
1242         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1243         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1244     }
1245 
1246     /**
1247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1248      *
1249      * See {setApprovalForAll}.
1250      */
1251     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1252         return _operatorApprovals[owner][operator];
1253     }
1254 
1255     /**
1256      * @dev Returns whether `tokenId` exists.
1257      *
1258      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1259      *
1260      * Tokens start existing when they are minted. See {_mint}.
1261      */
1262     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1263         return
1264             _startTokenId() <= tokenId &&
1265             tokenId < _currentIndex && // If within bounds,
1266             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1267     }
1268 
1269     /**
1270      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1271      */
1272     function _isSenderApprovedOrOwner(
1273         address approvedAddress,
1274         address owner,
1275         address msgSender
1276     ) private pure returns (bool result) {
1277         assembly {
1278             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1279             owner := and(owner, _BITMASK_ADDRESS)
1280             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1281             msgSender := and(msgSender, _BITMASK_ADDRESS)
1282             // `msgSender == owner || msgSender == approvedAddress`.
1283             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1289      */
1290     function _getApprovedSlotAndAddress(uint256 tokenId)
1291         private
1292         view
1293         returns (uint256 approvedAddressSlot, address approvedAddress)
1294     {
1295         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1296         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1297         assembly {
1298             approvedAddressSlot := tokenApproval.slot
1299             approvedAddress := sload(approvedAddressSlot)
1300         }
1301     }
1302 
1303     // =============================================================
1304     //                      TRANSFER OPERATIONS
1305     // =============================================================
1306 
1307     /**
1308      * @dev Transfers `tokenId` from `from` to `to`.
1309      *
1310      * Requirements:
1311      *
1312      * - `from` cannot be the zero address.
1313      * - `to` cannot be the zero address.
1314      * - `tokenId` token must be owned by `from`.
1315      * - If the caller is not `from`, it must be approved to move this token
1316      * by either {approve} or {setApprovalForAll}.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function transferFrom(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) public virtual override {
1325         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1326 
1327         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1328 
1329         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1330 
1331         // The nested ifs save around 20+ gas over a compound boolean condition.
1332         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1333             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1334 
1335         if (to == address(0)) revert TransferToZeroAddress();
1336 
1337         _beforeTokenTransfers(from, to, tokenId, 1);
1338 
1339         // Clear approvals from the previous owner.
1340         assembly {
1341             if approvedAddress {
1342                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1343                 sstore(approvedAddressSlot, 0)
1344             }
1345         }
1346 
1347         // Underflow of the sender's balance is impossible because we check for
1348         // ownership above and the recipient's balance can't realistically overflow.
1349         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1350         unchecked {
1351             // We can directly increment and decrement the balances.
1352             --_packedAddressData[from]; // Updates: `balance -= 1`.
1353             ++_packedAddressData[to]; // Updates: `balance += 1`.
1354 
1355             // Updates:
1356             // - `address` to the next owner.
1357             // - `startTimestamp` to the timestamp of transfering.
1358             // - `burned` to `false`.
1359             // - `nextInitialized` to `true`.
1360             _packedOwnerships[tokenId] = _packOwnershipData(
1361                 to,
1362                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1363             );
1364 
1365             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1366             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1367                 uint256 nextTokenId = tokenId + 1;
1368                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1369                 if (_packedOwnerships[nextTokenId] == 0) {
1370                     // If the next slot is within bounds.
1371                     if (nextTokenId != _currentIndex) {
1372                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1373                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1374                     }
1375                 }
1376             }
1377         }
1378 
1379         emit Transfer(from, to, tokenId);
1380         _afterTokenTransfers(from, to, tokenId, 1);
1381     }
1382 
1383     /**
1384      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1385      */
1386     function safeTransferFrom(
1387         address from,
1388         address to,
1389         uint256 tokenId
1390     ) public virtual override {
1391         safeTransferFrom(from, to, tokenId, '');
1392     }
1393 
1394     /**
1395      * @dev Safely transfers `tokenId` token from `from` to `to`.
1396      *
1397      * Requirements:
1398      *
1399      * - `from` cannot be the zero address.
1400      * - `to` cannot be the zero address.
1401      * - `tokenId` token must exist and be owned by `from`.
1402      * - If the caller is not `from`, it must be approved to move this token
1403      * by either {approve} or {setApprovalForAll}.
1404      * - If `to` refers to a smart contract, it must implement
1405      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1406      *
1407      * Emits a {Transfer} event.
1408      */
1409     function safeTransferFrom(
1410         address from,
1411         address to,
1412         uint256 tokenId,
1413         bytes memory _data
1414     ) public virtual override {
1415         transferFrom(from, to, tokenId);
1416         if (to.code.length != 0)
1417             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1418                 revert TransferToNonERC721ReceiverImplementer();
1419             }
1420     }
1421 
1422     /**
1423      * @dev Hook that is called before a set of serially-ordered token IDs
1424      * are about to be transferred. This includes minting.
1425      * And also called before burning one token.
1426      *
1427      * `startTokenId` - the first token ID to be transferred.
1428      * `quantity` - the amount to be transferred.
1429      *
1430      * Calling conditions:
1431      *
1432      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1433      * transferred to `to`.
1434      * - When `from` is zero, `tokenId` will be minted for `to`.
1435      * - When `to` is zero, `tokenId` will be burned by `from`.
1436      * - `from` and `to` are never both zero.
1437      */
1438     function _beforeTokenTransfers(
1439         address from,
1440         address to,
1441         uint256 startTokenId,
1442         uint256 quantity
1443     ) internal virtual {}
1444 
1445     /**
1446      * @dev Hook that is called after a set of serially-ordered token IDs
1447      * have been transferred. This includes minting.
1448      * And also called after one token has been burned.
1449      *
1450      * `startTokenId` - the first token ID to be transferred.
1451      * `quantity` - the amount to be transferred.
1452      *
1453      * Calling conditions:
1454      *
1455      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1456      * transferred to `to`.
1457      * - When `from` is zero, `tokenId` has been minted for `to`.
1458      * - When `to` is zero, `tokenId` has been burned by `from`.
1459      * - `from` and `to` are never both zero.
1460      */
1461     function _afterTokenTransfers(
1462         address from,
1463         address to,
1464         uint256 startTokenId,
1465         uint256 quantity
1466     ) internal virtual {}
1467 
1468     /**
1469      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1470      *
1471      * `from` - Previous owner of the given token ID.
1472      * `to` - Target address that will receive the token.
1473      * `tokenId` - Token ID to be transferred.
1474      * `_data` - Optional data to send along with the call.
1475      *
1476      * Returns whether the call correctly returned the expected magic value.
1477      */
1478     function _checkContractOnERC721Received(
1479         address from,
1480         address to,
1481         uint256 tokenId,
1482         bytes memory _data
1483     ) private returns (bool) {
1484         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1485             bytes4 retval
1486         ) {
1487             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1488         } catch (bytes memory reason) {
1489             if (reason.length == 0) {
1490                 revert TransferToNonERC721ReceiverImplementer();
1491             } else {
1492                 assembly {
1493                     revert(add(32, reason), mload(reason))
1494                 }
1495             }
1496         }
1497     }
1498 
1499     // =============================================================
1500     //                        MINT OPERATIONS
1501     // =============================================================
1502 
1503     /**
1504      * @dev Mints `quantity` tokens and transfers them to `to`.
1505      *
1506      * Requirements:
1507      *
1508      * - `to` cannot be the zero address.
1509      * - `quantity` must be greater than 0.
1510      *
1511      * Emits a {Transfer} event for each mint.
1512      */
1513     function _mint(address to, uint256 quantity) internal virtual {
1514         uint256 startTokenId = _currentIndex;
1515         if (quantity == 0) revert MintZeroQuantity();
1516 
1517         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1518 
1519         // Overflows are incredibly unrealistic.
1520         // `balance` and `numberMinted` have a maximum limit of 2**64.
1521         // `tokenId` has a maximum limit of 2**256.
1522         unchecked {
1523             // Updates:
1524             // - `balance += quantity`.
1525             // - `numberMinted += quantity`.
1526             //
1527             // We can directly add to the `balance` and `numberMinted`.
1528             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1529 
1530             // Updates:
1531             // - `address` to the owner.
1532             // - `startTimestamp` to the timestamp of minting.
1533             // - `burned` to `false`.
1534             // - `nextInitialized` to `quantity == 1`.
1535             _packedOwnerships[startTokenId] = _packOwnershipData(
1536                 to,
1537                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1538             );
1539 
1540             uint256 toMasked;
1541             uint256 end = startTokenId + quantity;
1542 
1543             // Use assembly to loop and emit the `Transfer` event for gas savings.
1544             assembly {
1545                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1546                 toMasked := and(to, _BITMASK_ADDRESS)
1547                 // Emit the `Transfer` event.
1548                 log4(
1549                     0, // Start of data (0, since no data).
1550                     0, // End of data (0, since no data).
1551                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1552                     0, // `address(0)`.
1553                     toMasked, // `to`.
1554                     startTokenId // `tokenId`.
1555                 )
1556 
1557                 for {
1558                     let tokenId := add(startTokenId, 1)
1559                 } iszero(eq(tokenId, end)) {
1560                     tokenId := add(tokenId, 1)
1561                 } {
1562                     // Emit the `Transfer` event. Similar to above.
1563                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1564                 }
1565             }
1566             if (toMasked == 0) revert MintToZeroAddress();
1567 
1568             _currentIndex = end;
1569         }
1570         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1571     }
1572 
1573     /**
1574      * @dev Mints `quantity` tokens and transfers them to `to`.
1575      *
1576      * This function is intended for efficient minting only during contract creation.
1577      *
1578      * It emits only one {ConsecutiveTransfer} as defined in
1579      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1580      * instead of a sequence of {Transfer} event(s).
1581      *
1582      * Calling this function outside of contract creation WILL make your contract
1583      * non-compliant with the ERC721 standard.
1584      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1585      * {ConsecutiveTransfer} event is only permissible during contract creation.
1586      *
1587      * Requirements:
1588      *
1589      * - `to` cannot be the zero address.
1590      * - `quantity` must be greater than 0.
1591      *
1592      * Emits a {ConsecutiveTransfer} event.
1593      */
1594     function _mintERC2309(address to, uint256 quantity) internal virtual {
1595         uint256 startTokenId = _currentIndex;
1596         if (to == address(0)) revert MintToZeroAddress();
1597         if (quantity == 0) revert MintZeroQuantity();
1598         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1599 
1600         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1601 
1602         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1603         unchecked {
1604             // Updates:
1605             // - `balance += quantity`.
1606             // - `numberMinted += quantity`.
1607             //
1608             // We can directly add to the `balance` and `numberMinted`.
1609             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1610 
1611             // Updates:
1612             // - `address` to the owner.
1613             // - `startTimestamp` to the timestamp of minting.
1614             // - `burned` to `false`.
1615             // - `nextInitialized` to `quantity == 1`.
1616             _packedOwnerships[startTokenId] = _packOwnershipData(
1617                 to,
1618                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1619             );
1620 
1621             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1622 
1623             _currentIndex = startTokenId + quantity;
1624         }
1625         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1626     }
1627 
1628     /**
1629      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1630      *
1631      * Requirements:
1632      *
1633      * - If `to` refers to a smart contract, it must implement
1634      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1635      * - `quantity` must be greater than 0.
1636      *
1637      * See {_mint}.
1638      *
1639      * Emits a {Transfer} event for each mint.
1640      */
1641     function _safeMint(
1642         address to,
1643         uint256 quantity,
1644         bytes memory _data
1645     ) internal virtual {
1646         _mint(to, quantity);
1647 
1648         unchecked {
1649             if (to.code.length != 0) {
1650                 uint256 end = _currentIndex;
1651                 uint256 index = end - quantity;
1652                 do {
1653                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1654                         revert TransferToNonERC721ReceiverImplementer();
1655                     }
1656                 } while (index < end);
1657                 // Reentrancy protection.
1658                 if (_currentIndex != end) revert();
1659             }
1660         }
1661     }
1662 
1663     /**
1664      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1665      */
1666     function _safeMint(address to, uint256 quantity) internal virtual {
1667         _safeMint(to, quantity, '');
1668     }
1669 
1670     // =============================================================
1671     //                        BURN OPERATIONS
1672     // =============================================================
1673 
1674     /**
1675      * @dev Equivalent to `_burn(tokenId, false)`.
1676      */
1677     function _burn(uint256 tokenId) internal virtual {
1678         _burn(tokenId, false);
1679     }
1680 
1681     /**
1682      * @dev Destroys `tokenId`.
1683      * The approval is cleared when the token is burned.
1684      *
1685      * Requirements:
1686      *
1687      * - `tokenId` must exist.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1692         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1693 
1694         address from = address(uint160(prevOwnershipPacked));
1695 
1696         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1697 
1698         if (approvalCheck) {
1699             // The nested ifs save around 20+ gas over a compound boolean condition.
1700             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1701                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1702         }
1703 
1704         _beforeTokenTransfers(from, address(0), tokenId, 1);
1705 
1706         // Clear approvals from the previous owner.
1707         assembly {
1708             if approvedAddress {
1709                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1710                 sstore(approvedAddressSlot, 0)
1711             }
1712         }
1713 
1714         // Underflow of the sender's balance is impossible because we check for
1715         // ownership above and the recipient's balance can't realistically overflow.
1716         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1717         unchecked {
1718             // Updates:
1719             // - `balance -= 1`.
1720             // - `numberBurned += 1`.
1721             //
1722             // We can directly decrement the balance, and increment the number burned.
1723             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1724             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1725 
1726             // Updates:
1727             // - `address` to the last owner.
1728             // - `startTimestamp` to the timestamp of burning.
1729             // - `burned` to `true`.
1730             // - `nextInitialized` to `true`.
1731             _packedOwnerships[tokenId] = _packOwnershipData(
1732                 from,
1733                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1734             );
1735 
1736             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1737             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1738                 uint256 nextTokenId = tokenId + 1;
1739                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1740                 if (_packedOwnerships[nextTokenId] == 0) {
1741                     // If the next slot is within bounds.
1742                     if (nextTokenId != _currentIndex) {
1743                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1744                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1745                     }
1746                 }
1747             }
1748         }
1749 
1750         emit Transfer(from, address(0), tokenId);
1751         _afterTokenTransfers(from, address(0), tokenId, 1);
1752 
1753         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1754         unchecked {
1755             _burnCounter++;
1756         }
1757     }
1758 
1759     // =============================================================
1760     //                     EXTRA DATA OPERATIONS
1761     // =============================================================
1762 
1763     /**
1764      * @dev Directly sets the extra data for the ownership data `index`.
1765      */
1766     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1767         uint256 packed = _packedOwnerships[index];
1768         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1769         uint256 extraDataCasted;
1770         // Cast `extraData` with assembly to avoid redundant masking.
1771         assembly {
1772             extraDataCasted := extraData
1773         }
1774         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1775         _packedOwnerships[index] = packed;
1776     }
1777 
1778     /**
1779      * @dev Called during each token transfer to set the 24bit `extraData` field.
1780      * Intended to be overridden by the cosumer contract.
1781      *
1782      * `previousExtraData` - the value of `extraData` before transfer.
1783      *
1784      * Calling conditions:
1785      *
1786      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1787      * transferred to `to`.
1788      * - When `from` is zero, `tokenId` will be minted for `to`.
1789      * - When `to` is zero, `tokenId` will be burned by `from`.
1790      * - `from` and `to` are never both zero.
1791      */
1792     function _extraData(
1793         address from,
1794         address to,
1795         uint24 previousExtraData
1796     ) internal view virtual returns (uint24) {}
1797 
1798     /**
1799      * @dev Returns the next extra data for the packed ownership data.
1800      * The returned result is shifted into position.
1801      */
1802     function _nextExtraData(
1803         address from,
1804         address to,
1805         uint256 prevOwnershipPacked
1806     ) private view returns (uint256) {
1807         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1808         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1809     }
1810 
1811     // =============================================================
1812     //                       OTHER OPERATIONS
1813     // =============================================================
1814 
1815     /**
1816      * @dev Returns the message sender (defaults to `msg.sender`).
1817      *
1818      * If you are writing GSN compatible contracts, you need to override this function.
1819      */
1820     function _msgSenderERC721A() internal view virtual returns (address) {
1821         return msg.sender;
1822     }
1823 
1824     /**
1825      * @dev Converts a uint256 to its ASCII string decimal representation.
1826      */
1827     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1828         assembly {
1829             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1830             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1831             // We will need 1 32-byte word to store the length,
1832             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1833             str := add(mload(0x40), 0x80)
1834             // Update the free memory pointer to allocate.
1835             mstore(0x40, str)
1836 
1837             // Cache the end of the memory to calculate the length later.
1838             let end := str
1839 
1840             // We write the string from rightmost digit to leftmost digit.
1841             // The following is essentially a do-while loop that also handles the zero case.
1842             // prettier-ignore
1843             for { let temp := value } 1 {} {
1844                 str := sub(str, 1)
1845                 // Write the character to the pointer.
1846                 // The ASCII index of the '0' character is 48.
1847                 mstore8(str, add(48, mod(temp, 10)))
1848                 // Keep dividing `temp` until zero.
1849                 temp := div(temp, 10)
1850                 // prettier-ignore
1851                 if iszero(temp) { break }
1852             }
1853 
1854             let length := sub(end, str)
1855             // Move the pointer 32 bytes leftwards to make room for the length.
1856             str := sub(str, 0x20)
1857             // Store the length.
1858             mstore(str, length)
1859         }
1860     }
1861 }
1862 
1863 // File: contracts/Aidigidaigaku.sol
1864 
1865 
1866 
1867 pragma solidity ^0.8.2;
1868 
1869 
1870 
1871 
1872 
1873 
1874 contract AiDigiDaigaku is ERC721A, Ownable, ReentrancyGuard {
1875     enum Status {
1876         Waiting,
1877         Started,
1878         Finished
1879     }
1880     using Strings for uint256;
1881     
1882     string private baseURI;
1883     uint256 public constant FREE_MINT_SUPPLY = 200;
1884     uint256 public constant MAX_FREE_MINT_PER_ADDR = 1;
1885     uint256 public constant MAX_MINT_PER_ADDR = 5;
1886     uint256 public PUBLIC_PRICE = .004 * 10**18;
1887     uint256 public constant MAX_SUPPLY = 1500;
1888     uint256 public INSTANT_FREE_MINTED = 1;
1889 
1890     bool public paused = false;
1891     bool public isPublicSaleActive = false;
1892 
1893     event Minted(address minter, uint256 amount);
1894 
1895     constructor(string memory initBaseURI) ERC721A("Ai DigiDaigaku", "AIDIGI") {
1896         baseURI = initBaseURI;
1897         _safeMint(msg.sender, MAX_FREE_MINT_PER_ADDR);
1898     }
1899 
1900     function mint(uint256 quantity) external payable nonReentrant {
1901         require(isPublicSaleActive, "Public sale is not open");
1902         require(tx.origin == msg.sender, "-Contract call not allowed-");
1903         require(
1904             numberMinted(msg.sender) + quantity <= MAX_MINT_PER_ADDR,
1905             "-This is more than allowed-"
1906         );
1907         require(
1908             totalSupply() + quantity <= MAX_SUPPLY,
1909             "-Not enough quantity-"
1910         );
1911 
1912         uint256 _cost;
1913         if (INSTANT_FREE_MINTED < FREE_MINT_SUPPLY) {
1914             uint256 remainFreeAmont = (numberMinted(msg.sender) <
1915                 MAX_FREE_MINT_PER_ADDR)
1916                 ? (MAX_FREE_MINT_PER_ADDR - numberMinted(msg.sender))
1917                 : 0;
1918 
1919             _cost =
1920                 PUBLIC_PRICE *
1921                 (
1922                     (quantity <= remainFreeAmont)
1923                         ? 0
1924                         : (quantity - remainFreeAmont)
1925                 );
1926 
1927             INSTANT_FREE_MINTED += (
1928                 (quantity <= remainFreeAmont) ? quantity : remainFreeAmont
1929             );
1930         } else {
1931             _cost = PUBLIC_PRICE * quantity;
1932         }
1933         require(msg.value >= _cost, "-Not enough ETH-");
1934         _safeMint(msg.sender, quantity);
1935         emit Minted(msg.sender, quantity);
1936     }
1937 
1938 
1939     function tokenURI(uint256 _tokenId)
1940         public
1941         view
1942         virtual
1943         override
1944         returns (string memory)
1945     {
1946         require(
1947             _exists(_tokenId),
1948             "ERC721Metadata: URI query for nonexistent token"
1949         );
1950         return
1951             string(
1952                 abi.encodePacked(baseURI, "/", _tokenId.toString(), ".json")
1953             );
1954     }
1955 
1956     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1957         baseURI = newBaseURI;
1958     }
1959 
1960     function _baseURI() internal view override returns (string memory) {
1961         return baseURI;
1962     }
1963 
1964     function numberMinted(address owner) public view returns (uint256) {
1965         return _numberMinted(owner);
1966     }
1967     
1968     function setpublic(bool _isPublicSaleActive)
1969       external
1970       onlyOwner
1971   {
1972       isPublicSaleActive = _isPublicSaleActive;
1973   }
1974 
1975     function treasurymint(uint quantity, address user)
1976     public
1977     onlyOwner
1978   {
1979     require(
1980       quantity > 0,
1981       "Invalid mint amount"
1982     );
1983     require(
1984       totalSupply() + quantity <= MAX_SUPPLY,
1985       "Maximum supply exceeded"
1986     );
1987     _safeMint(user, quantity);
1988   }
1989     
1990     function _startTokenId() internal view virtual override returns (uint256) {
1991         return 1;
1992     }
1993 
1994     function withdraw(address payable recipient)
1995         external
1996         onlyOwner
1997         nonReentrant
1998     {
1999         uint256 balance = address(this).balance;
2000         (bool success, ) = recipient.call{value: balance}("");
2001         require(success, "-Withdraw failed-");
2002     }
2003 
2004     function setprice(uint256 __price) external onlyOwner {
2005         PUBLIC_PRICE = __price;
2006     }
2007 }