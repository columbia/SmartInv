1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-07-20
7 */
8 
9 // File: @openzeppelin/contracts/utils/Strings.sol
10 
11 // SPDX-License-Identifier: MIT
12 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21     uint8 private constant _ADDRESS_LENGTH = 20;
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 
79     /**
80      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
81      */
82     function toHexString(address addr) internal pure returns (string memory) {
83         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Address.sol
88 
89 
90 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
91 
92 pragma solidity ^0.8.1;
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      *
115      * [IMPORTANT]
116      * ====
117      * You shouldn't rely on `isContract` to protect against flash loan attacks!
118      *
119      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
120      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
121      * constructor.
122      * ====
123      */
124     function isContract(address account) internal view returns (bool) {
125         // This method relies on extcodesize/address.code.length, which returns 0
126         // for contracts in construction, since the code is only stored at the end
127         // of the constructor execution.
128 
129         return account.code.length > 0;
130     }
131 
132     /**
133      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
134      * `recipient`, forwarding all available gas and reverting on errors.
135      *
136      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
137      * of certain opcodes, possibly making contracts go over the 2300 gas limit
138      * imposed by `transfer`, making them unable to receive funds via
139      * `transfer`. {sendValue} removes this limitation.
140      *
141      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
142      *
143      * IMPORTANT: because control is transferred to `recipient`, care must be
144      * taken to not create reentrancy vulnerabilities. Consider using
145      * {ReentrancyGuard} or the
146      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
147      */
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain `call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         require(isContract(target), "Address: call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.call{value: value}(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
236         return functionStaticCall(target, data, "Address: low-level static call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal view returns (bytes memory) {
250         require(isContract(target), "Address: static call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.staticcall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(isContract(target), "Address: delegate call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
285      * revert reason using the provided one.
286      *
287      * _Available since v4.3._
288      */
289     function verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300                 /// @solidity memory-safe-assembly
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 
312 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Contract module that helps prevent reentrant calls to a function.
321  *
322  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
323  * available, which can be applied to functions to make sure there are no nested
324  * (reentrant) calls to them.
325  *
326  * Note that because there is a single `nonReentrant` guard, functions marked as
327  * `nonReentrant` may not call one another. This can be worked around by making
328  * those functions `private`, and then adding `external` `nonReentrant` entry
329  * points to them.
330  *
331  * TIP: If you would like to learn more about reentrancy and alternative ways
332  * to protect against it, check out our blog post
333  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
334  */
335 abstract contract ReentrancyGuard {
336     // Booleans are more expensive than uint256 or any type that takes up a full
337     // word because each write operation emits an extra SLOAD to first read the
338     // slot's contents, replace the bits taken up by the boolean, and then write
339     // back. This is the compiler's defense against contract upgrades and
340     // pointer aliasing, and it cannot be disabled.
341 
342     // The values being non-zero value makes deployment a bit more expensive,
343     // but in exchange the refund on every call to nonReentrant will be lower in
344     // amount. Since refunds are capped to a percentage of the total
345     // transaction's gas, it is best to keep them low in cases like this one, to
346     // increase the likelihood of the full refund coming into effect.
347     uint256 private constant _NOT_ENTERED = 1;
348     uint256 private constant _ENTERED = 2;
349 
350     uint256 private _status;
351 
352     constructor() {
353         _status = _NOT_ENTERED;
354     }
355 
356     /**
357      * @dev Prevents a contract from calling itself, directly or indirectly.
358      * Calling a `nonReentrant` function from another `nonReentrant`
359      * function is not supported. It is possible to prevent this from happening
360      * by making the `nonReentrant` function external, and making it call a
361      * `private` function that does the actual work.
362      */
363     modifier nonReentrant() {
364         // On the first call to nonReentrant, _notEntered will be true
365         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
366 
367         // Any calls to nonReentrant after this point will fail
368         _status = _ENTERED;
369 
370         _;
371 
372         // By storing the original value once again, a refund is triggered (see
373         // https://eips.ethereum.org/EIPS/eip-2200)
374         _status = _NOT_ENTERED;
375     }
376 }
377 
378 // File: @openzeppelin/contracts/utils/Context.sol
379 
380 
381 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev Provides information about the current execution context, including the
387  * sender of the transaction and its data. While these are generally available
388  * via msg.sender and msg.data, they should not be accessed in such a direct
389  * manner, since when dealing with meta-transactions the account sending and
390  * paying for execution may not be the actual sender (as far as an application
391  * is concerned).
392  *
393  * This contract is only required for intermediate, library-like contracts.
394  */
395 abstract contract Context {
396     function _msgSender() internal view virtual returns (address) {
397         return msg.sender;
398     }
399 
400     function _msgData() internal view virtual returns (bytes calldata) {
401         return msg.data;
402     }
403 }
404 
405 // File: @openzeppelin/contracts/access/Ownable.sol
406 
407 
408 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 
413 /**
414  * @dev Contract module which provides a basic access control mechanism, where
415  * there is an account (an owner) that can be granted exclusive access to
416  * specific functions.
417  *
418  * By default, the owner account will be the one that deploys the contract. This
419  * can later be changed with {transferOwnership}.
420  *
421  * This module is used through inheritance. It will make available the modifier
422  * `onlyOwner`, which can be applied to your functions to restrict their use to
423  * the owner.
424  */
425 abstract contract Ownable is Context {
426     address private _owner;
427 
428     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
429 
430     /**
431      * @dev Initializes the contract setting the deployer as the initial owner.
432      */
433     constructor() {
434         _transferOwnership(_msgSender());
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         _checkOwner();
442         _;
443     }
444 
445     /**
446      * @dev Returns the address of the current owner.
447      */
448     function owner() public view virtual returns (address) {
449         return _owner;
450     }
451 
452     /**
453      * @dev Throws if the sender is not the owner.
454      */
455     function _checkOwner() internal view virtual {
456         require(owner() == _msgSender(), "Ownable: caller is not the owner");
457     }
458 
459     /**
460      * @dev Leaves the contract without owner. It will not be possible to call
461      * `onlyOwner` functions anymore. Can only be called by the current owner.
462      *
463      * NOTE: Renouncing ownership will leave the contract without an owner,
464      * thereby removing any functionality that is only available to the owner.
465      */
466     function renounceOwnership() public virtual onlyOwner {
467         _transferOwnership(address(0));
468     }
469 
470     /**
471      * @dev Transfers ownership of the contract to a new account (`newOwner`).
472      * Can only be called by the current owner.
473      */
474     function transferOwnership(address newOwner) public virtual onlyOwner {
475         require(newOwner != address(0), "Ownable: new owner is the zero address");
476         _transferOwnership(newOwner);
477     }
478 
479     /**
480      * @dev Transfers ownership of the contract to a new account (`newOwner`).
481      * Internal function without access restriction.
482      */
483     function _transferOwnership(address newOwner) internal virtual {
484         address oldOwner = _owner;
485         _owner = newOwner;
486         emit OwnershipTransferred(oldOwner, newOwner);
487     }
488 }
489 
490 // File: erc721a/contracts/IERC721A.sol
491 
492 
493 // ERC721A Contracts v4.1.0
494 
495 pragma solidity ^0.8.4;
496 
497 /**
498  * @dev Interface of an ERC721A compliant contract.
499  */
500 interface IERC721A {
501     /**
502      * The caller must own the token or be an approved operator.
503      */
504     error ApprovalCallerNotOwnerNorApproved();
505 
506     /**
507      * The token does not exist.
508      */
509     error ApprovalQueryForNonexistentToken();
510 
511     /**
512      * The caller cannot approve to their own address.
513      */
514     error ApproveToCaller();
515 
516     /**
517      * Cannot query the balance for the zero address.
518      */
519     error BalanceQueryForZeroAddress();
520 
521     /**
522      * Cannot mint to the zero address.
523      */
524     error MintToZeroAddress();
525 
526     /**
527      * The quantity of tokens minted must be more than zero.
528      */
529     error MintZeroQuantity();
530 
531     /**
532      * The token does not exist.
533      */
534     error OwnerQueryForNonexistentToken();
535 
536     /**
537      * The caller must own the token or be an approved operator.
538      */
539     error TransferCallerNotOwnerNorApproved();
540 
541     /**
542      * The token must be owned by `from`.
543      */
544     error TransferFromIncorrectOwner();
545 
546     /**
547      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
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
571     struct TokenOwnership {
572         // The address of the owner.
573         address addr;
574         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
575         uint64 startTimestamp;
576         // Whether the token has been burned.
577         bool burned;
578         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
579         uint24 extraData;
580     }
581 
582     /**
583      * @dev Returns the total amount of tokens stored by the contract.
584      *
585      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
586      */
587     function totalSupply() external view returns (uint256);
588 
589     // ==============================
590     //            IERC165
591     // ==============================
592 
593     /**
594      * @dev Returns true if this contract implements the interface defined by
595      * `interfaceId`. See the corresponding
596      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
597      * to learn more about how these ids are created.
598      *
599      * This function call must use less than 30 000 gas.
600      */
601     function supportsInterface(bytes4 interfaceId) external view returns (bool);
602 
603     // ==============================
604     //            IERC721
605     // ==============================
606 
607     /**
608      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
609      */
610     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
611 
612     /**
613      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
614      */
615     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
616 
617     /**
618      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
619      */
620     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
621 
622     /**
623      * @dev Returns the number of tokens in ``owner``'s account.
624      */
625     function balanceOf(address owner) external view returns (uint256 balance);
626 
627     /**
628      * @dev Returns the owner of the `tokenId` token.
629      *
630      * Requirements:
631      *
632      * - `tokenId` must exist.
633      */
634     function ownerOf(uint256 tokenId) external view returns (address owner);
635 
636     /**
637      * @dev Safely transfers `tokenId` token from `from` to `to`.
638      *
639      * Requirements:
640      *
641      * - `from` cannot be the zero address.
642      * - `to` cannot be the zero address.
643      * - `tokenId` token must exist and be owned by `from`.
644      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
645      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
646      *
647      * Emits a {Transfer} event.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 tokenId,
653         bytes calldata data
654     ) external;
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
658      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must exist and be owned by `from`.
665      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
666      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
667      *
668      * Emits a {Transfer} event.
669      */
670     function safeTransferFrom(
671         address from,
672         address to,
673         uint256 tokenId
674     ) external;
675 
676     /**
677      * @dev Transfers `tokenId` token from `from` to `to`.
678      *
679      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      *
688      * Emits a {Transfer} event.
689      */
690     function transferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) external;
695 
696     /**
697      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
698      * The approval is cleared when the token is transferred.
699      *
700      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
701      *
702      * Requirements:
703      *
704      * - The caller must own the token or be an approved operator.
705      * - `tokenId` must exist.
706      *
707      * Emits an {Approval} event.
708      */
709     function approve(address to, uint256 tokenId) external;
710 
711     /**
712      * @dev Approve or remove `operator` as an operator for the caller.
713      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
714      *
715      * Requirements:
716      *
717      * - The `operator` cannot be the caller.
718      *
719      * Emits an {ApprovalForAll} event.
720      */
721     function setApprovalForAll(address operator, bool _approved) external;
722 
723     /**
724      * @dev Returns the account approved for `tokenId` token.
725      *
726      * Requirements:
727      *
728      * - `tokenId` must exist.
729      */
730     function getApproved(uint256 tokenId) external view returns (address operator);
731 
732     /**
733      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
734      *
735      * See {setApprovalForAll}
736      */
737     function isApprovedForAll(address owner, address operator) external view returns (bool);
738 
739     // ==============================
740     //        IERC721Metadata
741     // ==============================
742 
743     /**
744      * @dev Returns the token collection name.
745      */
746     function name() external view returns (string memory);
747 
748     /**
749      * @dev Returns the token collection symbol.
750      */
751     function symbol() external view returns (string memory);
752 
753     /**
754      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
755      */
756     function tokenURI(uint256 tokenId) external view returns (string memory);
757 
758     // ==============================
759     //            IERC2309
760     // ==============================
761 
762     /**
763      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
764      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
765      */
766     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
767 }
768 
769 // File: erc721a/contracts/ERC721A.sol
770 
771 
772 // ERC721A Contracts v4.1.0
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
1720 // File: contract.sol
1721 
1722 
1723 pragma solidity ^0.8.7;
1724 
1725 
1726 
1727 
1728 
1729 
1730 contract LilMissMrMan is ERC721A, Ownable, ReentrancyGuard {
1731   using Address for address;
1732   using Strings for uint;
1733 
1734   string  public  baseTokenURI = "";
1735   bool public isPublicSaleActive = false;
1736 
1737   uint256 public  maxSupply = 3333;
1738   uint256 public  MAX_MINTS_PER_TX = 20;
1739   uint256 public  PUBLIC_SALE_PRICE = 0.0015 ether;
1740   uint256 public  NUM_FREE_MINTS = 1111;
1741   uint256 public  MAX_FREE_PER_WALLET = 1;
1742   uint256 public  freeNFTAlreadyMinted = 0;
1743 
1744   constructor() ERC721A("LilMissMrMan", "LMMM") {}
1745 
1746   function mint(uint256 numberOfTokens) external payable
1747   {
1748     require(isPublicSaleActive, "Public sale is paused.");
1749     require(totalSupply() + numberOfTokens < maxSupply + 1, "Maximum supply exceeded.");
1750 
1751     require(numberOfTokens <= MAX_MINTS_PER_TX, "Maximum mints per transaction exceeded.");
1752 
1753     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS)
1754     {
1755         require(PUBLIC_SALE_PRICE * numberOfTokens <= msg.value, "Invalid ETH value sent. Error Code: 1");
1756     } 
1757     else 
1758     {
1759         uint sender_balance = balanceOf(msg.sender);
1760         
1761         if (sender_balance + numberOfTokens > MAX_FREE_PER_WALLET) 
1762         { 
1763             if (sender_balance < MAX_FREE_PER_WALLET)
1764             {
1765                 uint free_available = MAX_FREE_PER_WALLET - sender_balance;
1766                 uint to_be_paid = numberOfTokens - free_available;
1767                 require(PUBLIC_SALE_PRICE * to_be_paid <= msg.value, "Invalid ETH value sent. Error Code: 2");
1768 
1769                 freeNFTAlreadyMinted += free_available;
1770             }
1771             else
1772             {
1773                 require(PUBLIC_SALE_PRICE * numberOfTokens <= msg.value, "Invalid ETH value sent. Error Code: 3");
1774             }
1775         }  
1776         else 
1777         {
1778             require(numberOfTokens <= MAX_FREE_PER_WALLET, "Maximum mints per transaction exceeded");
1779             freeNFTAlreadyMinted += numberOfTokens;
1780         }
1781     }
1782 
1783     _safeMint(msg.sender, numberOfTokens);
1784   }
1785 
1786   function setBaseURI(string memory baseURI)
1787     public
1788     onlyOwner
1789   {
1790     baseTokenURI = baseURI;
1791   }
1792 
1793   function treasuryMint(uint quantity)
1794     public
1795     onlyOwner
1796   {
1797     require(quantity > 0, "Invalid mint amount");
1798     require(totalSupply() + quantity <= maxSupply, "Maximum supply exceeded");
1799 
1800     _safeMint(msg.sender, quantity);
1801   }
1802 
1803   function withdraw()
1804     public
1805     onlyOwner
1806     nonReentrant
1807   {
1808     Address.sendValue(payable(msg.sender), address(this).balance);
1809   }
1810 
1811   function tokenURI(uint _tokenId)
1812     public
1813     view
1814     virtual
1815     override
1816     returns (string memory)
1817   {
1818     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1819     
1820     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString()));
1821   }
1822 
1823   function _baseURI()
1824     internal
1825     view
1826     virtual
1827     override
1828     returns (string memory)
1829   {
1830     return baseTokenURI;
1831   }
1832 
1833   function getIsPublicSaleActive() 
1834     public
1835     view 
1836     returns (bool) {
1837       return isPublicSaleActive;
1838   }
1839 
1840   function getFreeNftAlreadyMinted() 
1841     public
1842     view 
1843     returns (uint256) {
1844       return freeNFTAlreadyMinted;
1845   }
1846 
1847   function setIsPublicSaleActive(bool _isPublicSaleActive)
1848       external
1849       onlyOwner
1850   {
1851       isPublicSaleActive = _isPublicSaleActive;
1852   }
1853 
1854   function setNumFreeMints(uint256 _numfreemints)
1855       external
1856       onlyOwner
1857   {
1858       NUM_FREE_MINTS = _numfreemints;
1859   }
1860 
1861   function getSalePrice()
1862   public
1863   view
1864   returns (uint256)
1865   {
1866     return PUBLIC_SALE_PRICE;
1867   }
1868 
1869   function setSalePrice(uint256 _price)
1870       external
1871       onlyOwner
1872   {
1873       PUBLIC_SALE_PRICE = _price;
1874   }
1875 
1876   function setMaxLimitPerTransaction(uint256 _limit)
1877       external
1878       onlyOwner
1879   {
1880       MAX_MINTS_PER_TX = _limit;
1881   }
1882 
1883   function setFreeLimitPerWallet(uint256 _limit)
1884       external
1885       onlyOwner
1886   {
1887       MAX_FREE_PER_WALLET = _limit;
1888   }
1889 }