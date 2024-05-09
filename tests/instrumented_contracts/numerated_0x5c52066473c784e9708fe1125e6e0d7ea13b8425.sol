1 /***
2  *     ____  ____  ____ ___  _   ____  _     ____  ________  _   ____  _____ ____  _____ ____ 
3  *    /  __\/  _ \/  _ \\  \//  /  __\/ \ /\/  _ \/  __/\  \//  /  __\/  __//  __\/  __// ___\
4  *    | | //| / \|| | // \  /   |  \/|| | ||| | \|| |  _ \  /   |  \/||  \  |  \/||  \  |    \
5  *    | |_\\| |-||| |_\\ / /    |  __/| \_/|| |_/|| |_// / /    |  __/|  /_ |  __/|  /_ \___ |
6  *    \____/\_/ \|\____//_/     \_/   \____/\____/\____\/_/     \_/   \____\\_/   \____\\____/
7  *                                                                                            
8  */
9 
10 // File: @openzeppelin/contracts/utils/Strings.sol
11 
12 
13 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22     uint8 private constant _ADDRESS_LENGTH = 20;
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
51      */
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
67      */
68     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
69         bytes memory buffer = new bytes(2 * length + 2);
70         buffer[0] = "0";
71         buffer[1] = "x";
72         for (uint256 i = 2 * length + 1; i > 1; --i) {
73             buffer[i] = _HEX_SYMBOLS[value & 0xf];
74             value >>= 4;
75         }
76         require(value == 0, "Strings: hex length insufficient");
77         return string(buffer);
78     }
79 
80     /**
81      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
82      */
83     function toHexString(address addr) internal pure returns (string memory) {
84         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
85     }
86 }
87 
88 // File: @openzeppelin/contracts/utils/Address.sol
89 
90 
91 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
92 
93 pragma solidity ^0.8.1;
94 
95 /**
96  * @dev Collection of functions related to the address type
97  */
98 library Address {
99     /**
100      * @dev Returns true if `account` is a contract.
101      *
102      * [IMPORTANT]
103      * ====
104      * It is unsafe to assume that an address for which this function returns
105      * false is an externally-owned account (EOA) and not a contract.
106      *
107      * Among others, `isContract` will return false for the following
108      * types of addresses:
109      *
110      *  - an externally-owned account
111      *  - a contract in construction
112      *  - an address where a contract will be created
113      *  - an address where a contract lived, but was destroyed
114      * ====
115      *
116      * [IMPORTANT]
117      * ====
118      * You shouldn't rely on `isContract` to protect against flash loan attacks!
119      *
120      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
121      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
122      * constructor.
123      * ====
124      */
125     function isContract(address account) internal view returns (bool) {
126         // This method relies on extcodesize/address.code.length, which returns 0
127         // for contracts in construction, since the code is only stored at the end
128         // of the constructor execution.
129 
130         return account.code.length > 0;
131     }
132 
133     /**
134      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
135      * `recipient`, forwarding all available gas and reverting on errors.
136      *
137      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
138      * of certain opcodes, possibly making contracts go over the 2300 gas limit
139      * imposed by `transfer`, making them unable to receive funds via
140      * `transfer`. {sendValue} removes this limitation.
141      *
142      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
143      *
144      * IMPORTANT: because control is transferred to `recipient`, care must be
145      * taken to not create reentrancy vulnerabilities. Consider using
146      * {ReentrancyGuard} or the
147      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
148      */
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(address(this).balance >= amount, "Address: insufficient balance");
151 
152         (bool success, ) = recipient.call{value: amount}("");
153         require(success, "Address: unable to send value, recipient may have reverted");
154     }
155 
156     /**
157      * @dev Performs a Solidity function call using a low level `call`. A
158      * plain `call` is an unsafe replacement for a function call: use this
159      * function instead.
160      *
161      * If `target` reverts with a revert reason, it is bubbled up by this
162      * function (like regular Solidity function calls).
163      *
164      * Returns the raw returned data. To convert to the expected return value,
165      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
166      *
167      * Requirements:
168      *
169      * - `target` must be a contract.
170      * - calling `target` with `data` must not revert.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionCall(target, data, "Address: low-level call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
180      * `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but also transferring `value` wei to `target`.
195      *
196      * Requirements:
197      *
198      * - the calling contract must have an ETH balance of at least `value`.
199      * - the called Solidity function must be `payable`.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
213      * with `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value,
221         string memory errorMessage
222     ) internal returns (bytes memory) {
223         require(address(this).balance >= value, "Address: insufficient balance for call");
224         require(isContract(target), "Address: call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.call{value: value}(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
237         return functionStaticCall(target, data, "Address: low-level static call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal view returns (bytes memory) {
251         require(isContract(target), "Address: static call to non-contract");
252 
253         (bool success, bytes memory returndata) = target.staticcall(data);
254         return verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         require(isContract(target), "Address: delegate call to non-contract");
279 
280         (bool success, bytes memory returndata) = target.delegatecall(data);
281         return verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
286      * revert reason using the provided one.
287      *
288      * _Available since v4.3._
289      */
290     function verifyCallResult(
291         bool success,
292         bytes memory returndata,
293         string memory errorMessage
294     ) internal pure returns (bytes memory) {
295         if (success) {
296             return returndata;
297         } else {
298             // Look for revert reason and bubble it up if present
299             if (returndata.length > 0) {
300                 // The easiest way to bubble the revert reason is using memory via assembly
301                 /// @solidity memory-safe-assembly
302                 assembly {
303                     let returndata_size := mload(returndata)
304                     revert(add(32, returndata), returndata_size)
305                 }
306             } else {
307                 revert(errorMessage);
308             }
309         }
310     }
311 }
312 
313 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
314 
315 
316 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Contract module that helps prevent reentrant calls to a function.
322  *
323  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
324  * available, which can be applied to functions to make sure there are no nested
325  * (reentrant) calls to them.
326  *
327  * Note that because there is a single `nonReentrant` guard, functions marked as
328  * `nonReentrant` may not call one another. This can be worked around by making
329  * those functions `private`, and then adding `external` `nonReentrant` entry
330  * points to them.
331  *
332  * TIP: If you would like to learn more about reentrancy and alternative ways
333  * to protect against it, check out our blog post
334  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
335  */
336 abstract contract ReentrancyGuard {
337     // Booleans are more expensive than uint256 or any type that takes up a full
338     // word because each write operation emits an extra SLOAD to first read the
339     // slot's contents, replace the bits taken up by the boolean, and then write
340     // back. This is the compiler's defense against contract upgrades and
341     // pointer aliasing, and it cannot be disabled.
342 
343     // The values being non-zero value makes deployment a bit more expensive,
344     // but in exchange the refund on every call to nonReentrant will be lower in
345     // amount. Since refunds are capped to a percentage of the total
346     // transaction's gas, it is best to keep them low in cases like this one, to
347     // increase the likelihood of the full refund coming into effect.
348     uint256 private constant _NOT_ENTERED = 1;
349     uint256 private constant _ENTERED = 2;
350 
351     uint256 private _status;
352 
353     constructor() {
354         _status = _NOT_ENTERED;
355     }
356 
357     /**
358      * @dev Prevents a contract from calling itself, directly or indirectly.
359      * Calling a `nonReentrant` function from another `nonReentrant`
360      * function is not supported. It is possible to prevent this from happening
361      * by making the `nonReentrant` function external, and making it call a
362      * `private` function that does the actual work.
363      */
364     modifier nonReentrant() {
365         // On the first call to nonReentrant, _notEntered will be true
366         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
367 
368         // Any calls to nonReentrant after this point will fail
369         _status = _ENTERED;
370 
371         _;
372 
373         // By storing the original value once again, a refund is triggered (see
374         // https://eips.ethereum.org/EIPS/eip-2200)
375         _status = _NOT_ENTERED;
376     }
377 }
378 
379 // File: @openzeppelin/contracts/utils/Context.sol
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev Provides information about the current execution context, including the
388  * sender of the transaction and its data. While these are generally available
389  * via msg.sender and msg.data, they should not be accessed in such a direct
390  * manner, since when dealing with meta-transactions the account sending and
391  * paying for execution may not be the actual sender (as far as an application
392  * is concerned).
393  *
394  * This contract is only required for intermediate, library-like contracts.
395  */
396 abstract contract Context {
397     function _msgSender() internal view virtual returns (address) {
398         return msg.sender;
399     }
400 
401     function _msgData() internal view virtual returns (bytes calldata) {
402         return msg.data;
403     }
404 }
405 
406 // File: @openzeppelin/contracts/access/Ownable.sol
407 
408 
409 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 
414 /**
415  * @dev Contract module which provides a basic access control mechanism, where
416  * there is an account (an owner) that can be granted exclusive access to
417  * specific functions.
418  *
419  * By default, the owner account will be the one that deploys the contract. This
420  * can later be changed with {transferOwnership}.
421  *
422  * This module is used through inheritance. It will make available the modifier
423  * `onlyOwner`, which can be applied to your functions to restrict their use to
424  * the owner.
425  */
426 abstract contract Ownable is Context {
427     address private _owner;
428 
429     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
430 
431     /**
432      * @dev Initializes the contract setting the deployer as the initial owner.
433      */
434     constructor() {
435         _transferOwnership(_msgSender());
436     }
437 
438     /**
439      * @dev Throws if called by any account other than the owner.
440      */
441     modifier onlyOwner() {
442         _checkOwner();
443         _;
444     }
445 
446     /**
447      * @dev Returns the address of the current owner.
448      */
449     function owner() public view virtual returns (address) {
450         return _owner;
451     }
452 
453     /**
454      * @dev Throws if the sender is not the owner.
455      */
456     function _checkOwner() internal view virtual {
457         require(owner() == _msgSender(), "Ownable: caller is not the owner");
458     }
459 
460     /**
461      * @dev Leaves the contract without owner. It will not be possible to call
462      * `onlyOwner` functions anymore. Can only be called by the current owner.
463      *
464      * NOTE: Renouncing ownership will leave the contract without an owner,
465      * thereby removing any functionality that is only available to the owner.
466      */
467     function renounceOwnership() public virtual onlyOwner {
468         _transferOwnership(address(0));
469     }
470 
471     /**
472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
473      * Can only be called by the current owner.
474      */
475     function transferOwnership(address newOwner) public virtual onlyOwner {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         _transferOwnership(newOwner);
478     }
479 
480     /**
481      * @dev Transfers ownership of the contract to a new account (`newOwner`).
482      * Internal function without access restriction.
483      */
484     function _transferOwnership(address newOwner) internal virtual {
485         address oldOwner = _owner;
486         _owner = newOwner;
487         emit OwnershipTransferred(oldOwner, newOwner);
488     }
489 }
490 
491 // File: erc721a/contracts/IERC721A.sol
492 
493 
494 // ERC721A Contracts v4.2.2
495 // Creator: Chiru Labs
496 
497 pragma solidity ^0.8.4;
498 
499 /**
500  * @dev Interface of ERC721A.
501  */
502 interface IERC721A {
503     /**
504      * The caller must own the token or be an approved operator.
505      */
506     error ApprovalCallerNotOwnerNorApproved();
507 
508     /**
509      * The token does not exist.
510      */
511     error ApprovalQueryForNonexistentToken();
512 
513     /**
514      * The caller cannot approve to their own address.
515      */
516     error ApproveToCaller();
517 
518     /**
519      * Cannot query the balance for the zero address.
520      */
521     error BalanceQueryForZeroAddress();
522 
523     /**
524      * Cannot mint to the zero address.
525      */
526     error MintToZeroAddress();
527 
528     /**
529      * The quantity of tokens minted must be more than zero.
530      */
531     error MintZeroQuantity();
532 
533     /**
534      * The token does not exist.
535      */
536     error OwnerQueryForNonexistentToken();
537 
538     /**
539      * The caller must own the token or be an approved operator.
540      */
541     error TransferCallerNotOwnerNorApproved();
542 
543     /**
544      * The token must be owned by `from`.
545      */
546     error TransferFromIncorrectOwner();
547 
548     /**
549      * Cannot safely transfer to a contract that does not implement the
550      * ERC721Receiver interface.
551      */
552     error TransferToNonERC721ReceiverImplementer();
553 
554     /**
555      * Cannot transfer to the zero address.
556      */
557     error TransferToZeroAddress();
558 
559     /**
560      * The token does not exist.
561      */
562     error URIQueryForNonexistentToken();
563 
564     /**
565      * The `quantity` minted with ERC2309 exceeds the safety limit.
566      */
567     error MintERC2309QuantityExceedsLimit();
568 
569     /**
570      * The `extraData` cannot be set on an unintialized ownership slot.
571      */
572     error OwnershipNotInitializedForExtraData();
573 
574     // =============================================================
575     //                            STRUCTS
576     // =============================================================
577 
578     struct TokenOwnership {
579         // The address of the owner.
580         address addr;
581         // Stores the start time of ownership with minimal overhead for tokenomics.
582         uint64 startTimestamp;
583         // Whether the token has been burned.
584         bool burned;
585         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
586         uint24 extraData;
587     }
588 
589     // =============================================================
590     //                         TOKEN COUNTERS
591     // =============================================================
592 
593     /**
594      * @dev Returns the total number of tokens in existence.
595      * Burned tokens will reduce the count.
596      * To get the total number of tokens minted, please see {_totalMinted}.
597      */
598     function totalSupply() external view returns (uint256);
599 
600     // =============================================================
601     //                            IERC165
602     // =============================================================
603 
604     /**
605      * @dev Returns true if this contract implements the interface defined by
606      * `interfaceId`. See the corresponding
607      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
608      * to learn more about how these ids are created.
609      *
610      * This function call must use less than 30000 gas.
611      */
612     function supportsInterface(bytes4 interfaceId) external view returns (bool);
613 
614     // =============================================================
615     //                            IERC721
616     // =============================================================
617 
618     /**
619      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
620      */
621     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
622 
623     /**
624      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
625      */
626     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
627 
628     /**
629      * @dev Emitted when `owner` enables or disables
630      * (`approved`) `operator` to manage all of its assets.
631      */
632     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
633 
634     /**
635      * @dev Returns the number of tokens in `owner`'s account.
636      */
637     function balanceOf(address owner) external view returns (uint256 balance);
638 
639     /**
640      * @dev Returns the owner of the `tokenId` token.
641      *
642      * Requirements:
643      *
644      * - `tokenId` must exist.
645      */
646     function ownerOf(uint256 tokenId) external view returns (address owner);
647 
648     /**
649      * @dev Safely transfers `tokenId` token from `from` to `to`,
650      * checking first that contract recipients are aware of the ERC721 protocol
651      * to prevent tokens from being forever locked.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must exist and be owned by `from`.
658      * - If the caller is not `from`, it must be have been allowed to move
659      * this token by either {approve} or {setApprovalForAll}.
660      * - If `to` refers to a smart contract, it must implement
661      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
662      *
663      * Emits a {Transfer} event.
664      */
665     function safeTransferFrom(
666         address from,
667         address to,
668         uint256 tokenId,
669         bytes calldata data
670     ) external;
671 
672     /**
673      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) external;
680 
681     /**
682      * @dev Transfers `tokenId` from `from` to `to`.
683      *
684      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
685      * whenever possible.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must be owned by `from`.
692      * - If the caller is not `from`, it must be approved to move this token
693      * by either {approve} or {setApprovalForAll}.
694      *
695      * Emits a {Transfer} event.
696      */
697     function transferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) external;
702 
703     /**
704      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
705      * The approval is cleared when the token is transferred.
706      *
707      * Only a single account can be approved at a time, so approving the
708      * zero address clears previous approvals.
709      *
710      * Requirements:
711      *
712      * - The caller must own the token or be an approved operator.
713      * - `tokenId` must exist.
714      *
715      * Emits an {Approval} event.
716      */
717     function approve(address to, uint256 tokenId) external;
718 
719     /**
720      * @dev Approve or remove `operator` as an operator for the caller.
721      * Operators can call {transferFrom} or {safeTransferFrom}
722      * for any token owned by the caller.
723      *
724      * Requirements:
725      *
726      * - The `operator` cannot be the caller.
727      *
728      * Emits an {ApprovalForAll} event.
729      */
730     function setApprovalForAll(address operator, bool _approved) external;
731 
732     /**
733      * @dev Returns the account approved for `tokenId` token.
734      *
735      * Requirements:
736      *
737      * - `tokenId` must exist.
738      */
739     function getApproved(uint256 tokenId) external view returns (address operator);
740 
741     /**
742      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
743      *
744      * See {setApprovalForAll}.
745      */
746     function isApprovedForAll(address owner, address operator) external view returns (bool);
747 
748     // =============================================================
749     //                        IERC721Metadata
750     // =============================================================
751 
752     /**
753      * @dev Returns the token collection name.
754      */
755     function name() external view returns (string memory);
756 
757     /**
758      * @dev Returns the token collection symbol.
759      */
760     function symbol() external view returns (string memory);
761 
762     /**
763      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
764      */
765     function tokenURI(uint256 tokenId) external view returns (string memory);
766 
767     // =============================================================
768     //                           IERC2309
769     // =============================================================
770 
771     /**
772      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
773      * (inclusive) is transferred from `from` to `to`, as defined in the
774      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
775      *
776      * See {_mintERC2309} for more details.
777      */
778     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
779 }
780 
781 // File: erc721a/contracts/ERC721A.sol
782 
783 
784 // ERC721A Contracts v4.2.2
785 // Creator: Chiru Labs
786 
787 pragma solidity ^0.8.4;
788 
789 
790 /**
791  * @dev Interface of ERC721 token receiver.
792  */
793 interface ERC721A__IERC721Receiver {
794     function onERC721Received(
795         address operator,
796         address from,
797         uint256 tokenId,
798         bytes calldata data
799     ) external returns (bytes4);
800 }
801 
802 /**
803  * @title ERC721A
804  *
805  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
806  * Non-Fungible Token Standard, including the Metadata extension.
807  * Optimized for lower gas during batch mints.
808  *
809  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
810  * starting from `_startTokenId()`.
811  *
812  * Assumptions:
813  *
814  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
815  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
816  */
817 contract ERC721A is IERC721A {
818     // Reference type for token approval.
819     struct TokenApprovalRef {
820         address value;
821     }
822 
823     // =============================================================
824     //                           CONSTANTS
825     // =============================================================
826 
827     // Mask of an entry in packed address data.
828     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
829 
830     // The bit position of `numberMinted` in packed address data.
831     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
832 
833     // The bit position of `numberBurned` in packed address data.
834     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
835 
836     // The bit position of `aux` in packed address data.
837     uint256 private constant _BITPOS_AUX = 192;
838 
839     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
840     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
841 
842     // The bit position of `startTimestamp` in packed ownership.
843     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
844 
845     // The bit mask of the `burned` bit in packed ownership.
846     uint256 private constant _BITMASK_BURNED = 1 << 224;
847 
848     // The bit position of the `nextInitialized` bit in packed ownership.
849     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
850 
851     // The bit mask of the `nextInitialized` bit in packed ownership.
852     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
853 
854     // The bit position of `extraData` in packed ownership.
855     uint256 private constant _BITPOS_EXTRA_DATA = 232;
856 
857     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
858     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
859 
860     // The mask of the lower 160 bits for addresses.
861     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
862 
863     // The maximum `quantity` that can be minted with {_mintERC2309}.
864     // This limit is to prevent overflows on the address data entries.
865     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
866     // is required to cause an overflow, which is unrealistic.
867     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
868 
869     // The `Transfer` event signature is given by:
870     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
871     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
872         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
873 
874     // =============================================================
875     //                            STORAGE
876     // =============================================================
877 
878     // The next token ID to be minted.
879     uint256 private _currentIndex;
880 
881     // The number of tokens burned.
882     uint256 private _burnCounter;
883 
884     // Token name
885     string private _name;
886 
887     // Token symbol
888     string private _symbol;
889 
890     // Mapping from token ID to ownership details
891     // An empty struct value does not necessarily mean the token is unowned.
892     // See {_packedOwnershipOf} implementation for details.
893     //
894     // Bits Layout:
895     // - [0..159]   `addr`
896     // - [160..223] `startTimestamp`
897     // - [224]      `burned`
898     // - [225]      `nextInitialized`
899     // - [232..255] `extraData`
900     mapping(uint256 => uint256) private _packedOwnerships;
901 
902     // Mapping owner address to address data.
903     //
904     // Bits Layout:
905     // - [0..63]    `balance`
906     // - [64..127]  `numberMinted`
907     // - [128..191] `numberBurned`
908     // - [192..255] `aux`
909     mapping(address => uint256) private _packedAddressData;
910 
911     // Mapping from token ID to approved address.
912     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
913 
914     // Mapping from owner to operator approvals
915     mapping(address => mapping(address => bool)) private _operatorApprovals;
916 
917     // =============================================================
918     //                          CONSTRUCTOR
919     // =============================================================
920 
921     constructor(string memory name_, string memory symbol_) {
922         _name = name_;
923         _symbol = symbol_;
924         _currentIndex = _startTokenId();
925     }
926 
927     // =============================================================
928     //                   TOKEN COUNTING OPERATIONS
929     // =============================================================
930 
931     /**
932      * @dev Returns the starting token ID.
933      * To change the starting token ID, please override this function.
934      */
935     function _startTokenId() internal view virtual returns (uint256) {
936         return 0;
937     }
938 
939     /**
940      * @dev Returns the next token ID to be minted.
941      */
942     function _nextTokenId() internal view virtual returns (uint256) {
943         return _currentIndex;
944     }
945 
946     /**
947      * @dev Returns the total number of tokens in existence.
948      * Burned tokens will reduce the count.
949      * To get the total number of tokens minted, please see {_totalMinted}.
950      */
951     function totalSupply() public view virtual override returns (uint256) {
952         // Counter underflow is impossible as _burnCounter cannot be incremented
953         // more than `_currentIndex - _startTokenId()` times.
954         unchecked {
955             return _currentIndex - _burnCounter - _startTokenId();
956         }
957     }
958 
959     /**
960      * @dev Returns the total amount of tokens minted in the contract.
961      */
962     function _totalMinted() internal view virtual returns (uint256) {
963         // Counter underflow is impossible as `_currentIndex` does not decrement,
964         // and it is initialized to `_startTokenId()`.
965         unchecked {
966             return _currentIndex - _startTokenId();
967         }
968     }
969 
970     /**
971      * @dev Returns the total number of tokens burned.
972      */
973     function _totalBurned() internal view virtual returns (uint256) {
974         return _burnCounter;
975     }
976 
977     // =============================================================
978     //                    ADDRESS DATA OPERATIONS
979     // =============================================================
980 
981     /**
982      * @dev Returns the number of tokens in `owner`'s account.
983      */
984     function balanceOf(address owner) public view virtual override returns (uint256) {
985         if (owner == address(0)) revert BalanceQueryForZeroAddress();
986         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
987     }
988 
989     /**
990      * Returns the number of tokens minted by `owner`.
991      */
992     function _numberMinted(address owner) internal view returns (uint256) {
993         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
994     }
995 
996     /**
997      * Returns the number of tokens burned by or on behalf of `owner`.
998      */
999     function _numberBurned(address owner) internal view returns (uint256) {
1000         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1001     }
1002 
1003     /**
1004      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1005      */
1006     function _getAux(address owner) internal view returns (uint64) {
1007         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1008     }
1009 
1010     /**
1011      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1012      * If there are multiple variables, please pack them into a uint64.
1013      */
1014     function _setAux(address owner, uint64 aux) internal virtual {
1015         uint256 packed = _packedAddressData[owner];
1016         uint256 auxCasted;
1017         // Cast `aux` with assembly to avoid redundant masking.
1018         assembly {
1019             auxCasted := aux
1020         }
1021         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1022         _packedAddressData[owner] = packed;
1023     }
1024 
1025     // =============================================================
1026     //                            IERC165
1027     // =============================================================
1028 
1029     /**
1030      * @dev Returns true if this contract implements the interface defined by
1031      * `interfaceId`. See the corresponding
1032      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1033      * to learn more about how these ids are created.
1034      *
1035      * This function call must use less than 30000 gas.
1036      */
1037     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1038         // The interface IDs are constants representing the first 4 bytes
1039         // of the XOR of all function selectors in the interface.
1040         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1041         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1042         return
1043             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1044             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1045             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1046     }
1047 
1048     // =============================================================
1049     //                        IERC721Metadata
1050     // =============================================================
1051 
1052     /**
1053      * @dev Returns the token collection name.
1054      */
1055     function name() public view virtual override returns (string memory) {
1056         return _name;
1057     }
1058 
1059     /**
1060      * @dev Returns the token collection symbol.
1061      */
1062     function symbol() public view virtual override returns (string memory) {
1063         return _symbol;
1064     }
1065 
1066     /**
1067      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1068      */
1069     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1070         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1071 
1072         string memory baseURI = _baseURI();
1073         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1074     }
1075 
1076     /**
1077      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1078      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1079      * by default, it can be overridden in child contracts.
1080      */
1081     function _baseURI() internal view virtual returns (string memory) {
1082         return '';
1083     }
1084 
1085     // =============================================================
1086     //                     OWNERSHIPS OPERATIONS
1087     // =============================================================
1088 
1089     /**
1090      * @dev Returns the owner of the `tokenId` token.
1091      *
1092      * Requirements:
1093      *
1094      * - `tokenId` must exist.
1095      */
1096     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1097         return address(uint160(_packedOwnershipOf(tokenId)));
1098     }
1099 
1100     /**
1101      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1102      * It gradually moves to O(1) as tokens get transferred around over time.
1103      */
1104     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1105         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1106     }
1107 
1108     /**
1109      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1110      */
1111     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1112         return _unpackedOwnership(_packedOwnerships[index]);
1113     }
1114 
1115     /**
1116      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1117      */
1118     function _initializeOwnershipAt(uint256 index) internal virtual {
1119         if (_packedOwnerships[index] == 0) {
1120             _packedOwnerships[index] = _packedOwnershipOf(index);
1121         }
1122     }
1123 
1124     /**
1125      * Returns the packed ownership data of `tokenId`.
1126      */
1127     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1128         uint256 curr = tokenId;
1129 
1130         unchecked {
1131             if (_startTokenId() <= curr)
1132                 if (curr < _currentIndex) {
1133                     uint256 packed = _packedOwnerships[curr];
1134                     // If not burned.
1135                     if (packed & _BITMASK_BURNED == 0) {
1136                         // Invariant:
1137                         // There will always be an initialized ownership slot
1138                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1139                         // before an unintialized ownership slot
1140                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1141                         // Hence, `curr` will not underflow.
1142                         //
1143                         // We can directly compare the packed value.
1144                         // If the address is zero, packed will be zero.
1145                         while (packed == 0) {
1146                             packed = _packedOwnerships[--curr];
1147                         }
1148                         return packed;
1149                     }
1150                 }
1151         }
1152         revert OwnerQueryForNonexistentToken();
1153     }
1154 
1155     /**
1156      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1157      */
1158     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1159         ownership.addr = address(uint160(packed));
1160         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1161         ownership.burned = packed & _BITMASK_BURNED != 0;
1162         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1163     }
1164 
1165     /**
1166      * @dev Packs ownership data into a single uint256.
1167      */
1168     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1169         assembly {
1170             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1171             owner := and(owner, _BITMASK_ADDRESS)
1172             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1173             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1174         }
1175     }
1176 
1177     /**
1178      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1179      */
1180     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1181         // For branchless setting of the `nextInitialized` flag.
1182         assembly {
1183             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1184             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1185         }
1186     }
1187 
1188     // =============================================================
1189     //                      APPROVAL OPERATIONS
1190     // =============================================================
1191 
1192     /**
1193      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1194      * The approval is cleared when the token is transferred.
1195      *
1196      * Only a single account can be approved at a time, so approving the
1197      * zero address clears previous approvals.
1198      *
1199      * Requirements:
1200      *
1201      * - The caller must own the token or be an approved operator.
1202      * - `tokenId` must exist.
1203      *
1204      * Emits an {Approval} event.
1205      */
1206     function approve(address to, uint256 tokenId) public virtual override {
1207         address owner = ownerOf(tokenId);
1208 
1209         if (_msgSenderERC721A() != owner)
1210             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1211                 revert ApprovalCallerNotOwnerNorApproved();
1212             }
1213 
1214         _tokenApprovals[tokenId].value = to;
1215         emit Approval(owner, to, tokenId);
1216     }
1217 
1218     /**
1219      * @dev Returns the account approved for `tokenId` token.
1220      *
1221      * Requirements:
1222      *
1223      * - `tokenId` must exist.
1224      */
1225     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1226         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1227 
1228         return _tokenApprovals[tokenId].value;
1229     }
1230 
1231     /**
1232      * @dev Approve or remove `operator` as an operator for the caller.
1233      * Operators can call {transferFrom} or {safeTransferFrom}
1234      * for any token owned by the caller.
1235      *
1236      * Requirements:
1237      *
1238      * - The `operator` cannot be the caller.
1239      *
1240      * Emits an {ApprovalForAll} event.
1241      */
1242     function setApprovalForAll(address operator, bool approved) public virtual override {
1243         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1244 
1245         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1246         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1247     }
1248 
1249     /**
1250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1251      *
1252      * See {setApprovalForAll}.
1253      */
1254     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1255         return _operatorApprovals[owner][operator];
1256     }
1257 
1258     /**
1259      * @dev Returns whether `tokenId` exists.
1260      *
1261      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1262      *
1263      * Tokens start existing when they are minted. See {_mint}.
1264      */
1265     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1266         return
1267             _startTokenId() <= tokenId &&
1268             tokenId < _currentIndex && // If within bounds,
1269             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1270     }
1271 
1272     /**
1273      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1274      */
1275     function _isSenderApprovedOrOwner(
1276         address approvedAddress,
1277         address owner,
1278         address msgSender
1279     ) private pure returns (bool result) {
1280         assembly {
1281             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1282             owner := and(owner, _BITMASK_ADDRESS)
1283             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1284             msgSender := and(msgSender, _BITMASK_ADDRESS)
1285             // `msgSender == owner || msgSender == approvedAddress`.
1286             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1287         }
1288     }
1289 
1290     /**
1291      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1292      */
1293     function _getApprovedSlotAndAddress(uint256 tokenId)
1294         private
1295         view
1296         returns (uint256 approvedAddressSlot, address approvedAddress)
1297     {
1298         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1299         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1300         assembly {
1301             approvedAddressSlot := tokenApproval.slot
1302             approvedAddress := sload(approvedAddressSlot)
1303         }
1304     }
1305 
1306     // =============================================================
1307     //                      TRANSFER OPERATIONS
1308     // =============================================================
1309 
1310     /**
1311      * @dev Transfers `tokenId` from `from` to `to`.
1312      *
1313      * Requirements:
1314      *
1315      * - `from` cannot be the zero address.
1316      * - `to` cannot be the zero address.
1317      * - `tokenId` token must be owned by `from`.
1318      * - If the caller is not `from`, it must be approved to move this token
1319      * by either {approve} or {setApprovalForAll}.
1320      *
1321      * Emits a {Transfer} event.
1322      */
1323     function transferFrom(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) public virtual override {
1328         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1329 
1330         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1331 
1332         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1333 
1334         // The nested ifs save around 20+ gas over a compound boolean condition.
1335         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1336             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1337 
1338         if (to == address(0)) revert TransferToZeroAddress();
1339 
1340         _beforeTokenTransfers(from, to, tokenId, 1);
1341 
1342         // Clear approvals from the previous owner.
1343         assembly {
1344             if approvedAddress {
1345                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1346                 sstore(approvedAddressSlot, 0)
1347             }
1348         }
1349 
1350         // Underflow of the sender's balance is impossible because we check for
1351         // ownership above and the recipient's balance can't realistically overflow.
1352         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1353         unchecked {
1354             // We can directly increment and decrement the balances.
1355             --_packedAddressData[from]; // Updates: `balance -= 1`.
1356             ++_packedAddressData[to]; // Updates: `balance += 1`.
1357 
1358             // Updates:
1359             // - `address` to the next owner.
1360             // - `startTimestamp` to the timestamp of transfering.
1361             // - `burned` to `false`.
1362             // - `nextInitialized` to `true`.
1363             _packedOwnerships[tokenId] = _packOwnershipData(
1364                 to,
1365                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1366             );
1367 
1368             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1369             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1370                 uint256 nextTokenId = tokenId + 1;
1371                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1372                 if (_packedOwnerships[nextTokenId] == 0) {
1373                     // If the next slot is within bounds.
1374                     if (nextTokenId != _currentIndex) {
1375                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1376                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1377                     }
1378                 }
1379             }
1380         }
1381 
1382         emit Transfer(from, to, tokenId);
1383         _afterTokenTransfers(from, to, tokenId, 1);
1384     }
1385 
1386     /**
1387      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1388      */
1389     function safeTransferFrom(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) public virtual override {
1394         safeTransferFrom(from, to, tokenId, '');
1395     }
1396 
1397     /**
1398      * @dev Safely transfers `tokenId` token from `from` to `to`.
1399      *
1400      * Requirements:
1401      *
1402      * - `from` cannot be the zero address.
1403      * - `to` cannot be the zero address.
1404      * - `tokenId` token must exist and be owned by `from`.
1405      * - If the caller is not `from`, it must be approved to move this token
1406      * by either {approve} or {setApprovalForAll}.
1407      * - If `to` refers to a smart contract, it must implement
1408      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1409      *
1410      * Emits a {Transfer} event.
1411      */
1412     function safeTransferFrom(
1413         address from,
1414         address to,
1415         uint256 tokenId,
1416         bytes memory _data
1417     ) public virtual override {
1418         transferFrom(from, to, tokenId);
1419         if (to.code.length != 0)
1420             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1421                 revert TransferToNonERC721ReceiverImplementer();
1422             }
1423     }
1424 
1425     /**
1426      * @dev Hook that is called before a set of serially-ordered token IDs
1427      * are about to be transferred. This includes minting.
1428      * And also called before burning one token.
1429      *
1430      * `startTokenId` - the first token ID to be transferred.
1431      * `quantity` - the amount to be transferred.
1432      *
1433      * Calling conditions:
1434      *
1435      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1436      * transferred to `to`.
1437      * - When `from` is zero, `tokenId` will be minted for `to`.
1438      * - When `to` is zero, `tokenId` will be burned by `from`.
1439      * - `from` and `to` are never both zero.
1440      */
1441     function _beforeTokenTransfers(
1442         address from,
1443         address to,
1444         uint256 startTokenId,
1445         uint256 quantity
1446     ) internal virtual {}
1447 
1448     /**
1449      * @dev Hook that is called after a set of serially-ordered token IDs
1450      * have been transferred. This includes minting.
1451      * And also called after one token has been burned.
1452      *
1453      * `startTokenId` - the first token ID to be transferred.
1454      * `quantity` - the amount to be transferred.
1455      *
1456      * Calling conditions:
1457      *
1458      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1459      * transferred to `to`.
1460      * - When `from` is zero, `tokenId` has been minted for `to`.
1461      * - When `to` is zero, `tokenId` has been burned by `from`.
1462      * - `from` and `to` are never both zero.
1463      */
1464     function _afterTokenTransfers(
1465         address from,
1466         address to,
1467         uint256 startTokenId,
1468         uint256 quantity
1469     ) internal virtual {}
1470 
1471     /**
1472      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1473      *
1474      * `from` - Previous owner of the given token ID.
1475      * `to` - Target address that will receive the token.
1476      * `tokenId` - Token ID to be transferred.
1477      * `_data` - Optional data to send along with the call.
1478      *
1479      * Returns whether the call correctly returned the expected magic value.
1480      */
1481     function _checkContractOnERC721Received(
1482         address from,
1483         address to,
1484         uint256 tokenId,
1485         bytes memory _data
1486     ) private returns (bool) {
1487         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1488             bytes4 retval
1489         ) {
1490             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1491         } catch (bytes memory reason) {
1492             if (reason.length == 0) {
1493                 revert TransferToNonERC721ReceiverImplementer();
1494             } else {
1495                 assembly {
1496                     revert(add(32, reason), mload(reason))
1497                 }
1498             }
1499         }
1500     }
1501 
1502     // =============================================================
1503     //                        MINT OPERATIONS
1504     // =============================================================
1505 
1506     /**
1507      * @dev Mints `quantity` tokens and transfers them to `to`.
1508      *
1509      * Requirements:
1510      *
1511      * - `to` cannot be the zero address.
1512      * - `quantity` must be greater than 0.
1513      *
1514      * Emits a {Transfer} event for each mint.
1515      */
1516     function _mint(address to, uint256 quantity) internal virtual {
1517         uint256 startTokenId = _currentIndex;
1518         if (quantity == 0) revert MintZeroQuantity();
1519 
1520         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1521 
1522         // Overflows are incredibly unrealistic.
1523         // `balance` and `numberMinted` have a maximum limit of 2**64.
1524         // `tokenId` has a maximum limit of 2**256.
1525         unchecked {
1526             // Updates:
1527             // - `balance += quantity`.
1528             // - `numberMinted += quantity`.
1529             //
1530             // We can directly add to the `balance` and `numberMinted`.
1531             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1532 
1533             // Updates:
1534             // - `address` to the owner.
1535             // - `startTimestamp` to the timestamp of minting.
1536             // - `burned` to `false`.
1537             // - `nextInitialized` to `quantity == 1`.
1538             _packedOwnerships[startTokenId] = _packOwnershipData(
1539                 to,
1540                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1541             );
1542 
1543             uint256 toMasked;
1544             uint256 end = startTokenId + quantity;
1545 
1546             // Use assembly to loop and emit the `Transfer` event for gas savings.
1547             assembly {
1548                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1549                 toMasked := and(to, _BITMASK_ADDRESS)
1550                 // Emit the `Transfer` event.
1551                 log4(
1552                     0, // Start of data (0, since no data).
1553                     0, // End of data (0, since no data).
1554                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1555                     0, // `address(0)`.
1556                     toMasked, // `to`.
1557                     startTokenId // `tokenId`.
1558                 )
1559 
1560                 for {
1561                     let tokenId := add(startTokenId, 1)
1562                 } iszero(eq(tokenId, end)) {
1563                     tokenId := add(tokenId, 1)
1564                 } {
1565                     // Emit the `Transfer` event. Similar to above.
1566                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1567                 }
1568             }
1569             if (toMasked == 0) revert MintToZeroAddress();
1570 
1571             _currentIndex = end;
1572         }
1573         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1574     }
1575 
1576     /**
1577      * @dev Mints `quantity` tokens and transfers them to `to`.
1578      *
1579      * This function is intended for efficient minting only during contract creation.
1580      *
1581      * It emits only one {ConsecutiveTransfer} as defined in
1582      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1583      * instead of a sequence of {Transfer} event(s).
1584      *
1585      * Calling this function outside of contract creation WILL make your contract
1586      * non-compliant with the ERC721 standard.
1587      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1588      * {ConsecutiveTransfer} event is only permissible during contract creation.
1589      *
1590      * Requirements:
1591      *
1592      * - `to` cannot be the zero address.
1593      * - `quantity` must be greater than 0.
1594      *
1595      * Emits a {ConsecutiveTransfer} event.
1596      */
1597     function _mintERC2309(address to, uint256 quantity) internal virtual {
1598         uint256 startTokenId = _currentIndex;
1599         if (to == address(0)) revert MintToZeroAddress();
1600         if (quantity == 0) revert MintZeroQuantity();
1601         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1602 
1603         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1604 
1605         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1606         unchecked {
1607             // Updates:
1608             // - `balance += quantity`.
1609             // - `numberMinted += quantity`.
1610             //
1611             // We can directly add to the `balance` and `numberMinted`.
1612             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1613 
1614             // Updates:
1615             // - `address` to the owner.
1616             // - `startTimestamp` to the timestamp of minting.
1617             // - `burned` to `false`.
1618             // - `nextInitialized` to `quantity == 1`.
1619             _packedOwnerships[startTokenId] = _packOwnershipData(
1620                 to,
1621                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1622             );
1623 
1624             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1625 
1626             _currentIndex = startTokenId + quantity;
1627         }
1628         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1629     }
1630 
1631     /**
1632      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1633      *
1634      * Requirements:
1635      *
1636      * - If `to` refers to a smart contract, it must implement
1637      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1638      * - `quantity` must be greater than 0.
1639      *
1640      * See {_mint}.
1641      *
1642      * Emits a {Transfer} event for each mint.
1643      */
1644     function _safeMint(
1645         address to,
1646         uint256 quantity,
1647         bytes memory _data
1648     ) internal virtual {
1649         _mint(to, quantity);
1650 
1651         unchecked {
1652             if (to.code.length != 0) {
1653                 uint256 end = _currentIndex;
1654                 uint256 index = end - quantity;
1655                 do {
1656                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1657                         revert TransferToNonERC721ReceiverImplementer();
1658                     }
1659                 } while (index < end);
1660                 // Reentrancy protection.
1661                 if (_currentIndex != end) revert();
1662             }
1663         }
1664     }
1665 
1666     /**
1667      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1668      */
1669     function _safeMint(address to, uint256 quantity) internal virtual {
1670         _safeMint(to, quantity, '');
1671     }
1672 
1673     // =============================================================
1674     //                        BURN OPERATIONS
1675     // =============================================================
1676 
1677     /**
1678      * @dev Equivalent to `_burn(tokenId, false)`.
1679      */
1680     function _burn(uint256 tokenId) internal virtual {
1681         _burn(tokenId, false);
1682     }
1683 
1684     /**
1685      * @dev Destroys `tokenId`.
1686      * The approval is cleared when the token is burned.
1687      *
1688      * Requirements:
1689      *
1690      * - `tokenId` must exist.
1691      *
1692      * Emits a {Transfer} event.
1693      */
1694     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1695         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1696 
1697         address from = address(uint160(prevOwnershipPacked));
1698 
1699         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1700 
1701         if (approvalCheck) {
1702             // The nested ifs save around 20+ gas over a compound boolean condition.
1703             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1704                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1705         }
1706 
1707         _beforeTokenTransfers(from, address(0), tokenId, 1);
1708 
1709         // Clear approvals from the previous owner.
1710         assembly {
1711             if approvedAddress {
1712                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1713                 sstore(approvedAddressSlot, 0)
1714             }
1715         }
1716 
1717         // Underflow of the sender's balance is impossible because we check for
1718         // ownership above and the recipient's balance can't realistically overflow.
1719         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1720         unchecked {
1721             // Updates:
1722             // - `balance -= 1`.
1723             // - `numberBurned += 1`.
1724             //
1725             // We can directly decrement the balance, and increment the number burned.
1726             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1727             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1728 
1729             // Updates:
1730             // - `address` to the last owner.
1731             // - `startTimestamp` to the timestamp of burning.
1732             // - `burned` to `true`.
1733             // - `nextInitialized` to `true`.
1734             _packedOwnerships[tokenId] = _packOwnershipData(
1735                 from,
1736                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1737             );
1738 
1739             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1740             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1741                 uint256 nextTokenId = tokenId + 1;
1742                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1743                 if (_packedOwnerships[nextTokenId] == 0) {
1744                     // If the next slot is within bounds.
1745                     if (nextTokenId != _currentIndex) {
1746                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1747                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1748                     }
1749                 }
1750             }
1751         }
1752 
1753         emit Transfer(from, address(0), tokenId);
1754         _afterTokenTransfers(from, address(0), tokenId, 1);
1755 
1756         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1757         unchecked {
1758             _burnCounter++;
1759         }
1760     }
1761 
1762     // =============================================================
1763     //                     EXTRA DATA OPERATIONS
1764     // =============================================================
1765 
1766     /**
1767      * @dev Directly sets the extra data for the ownership data `index`.
1768      */
1769     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1770         uint256 packed = _packedOwnerships[index];
1771         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1772         uint256 extraDataCasted;
1773         // Cast `extraData` with assembly to avoid redundant masking.
1774         assembly {
1775             extraDataCasted := extraData
1776         }
1777         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1778         _packedOwnerships[index] = packed;
1779     }
1780 
1781     /**
1782      * @dev Called during each token transfer to set the 24bit `extraData` field.
1783      * Intended to be overridden by the cosumer contract.
1784      *
1785      * `previousExtraData` - the value of `extraData` before transfer.
1786      *
1787      * Calling conditions:
1788      *
1789      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1790      * transferred to `to`.
1791      * - When `from` is zero, `tokenId` will be minted for `to`.
1792      * - When `to` is zero, `tokenId` will be burned by `from`.
1793      * - `from` and `to` are never both zero.
1794      */
1795     function _extraData(
1796         address from,
1797         address to,
1798         uint24 previousExtraData
1799     ) internal view virtual returns (uint24) {}
1800 
1801     /**
1802      * @dev Returns the next extra data for the packed ownership data.
1803      * The returned result is shifted into position.
1804      */
1805     function _nextExtraData(
1806         address from,
1807         address to,
1808         uint256 prevOwnershipPacked
1809     ) private view returns (uint256) {
1810         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1811         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1812     }
1813 
1814     // =============================================================
1815     //                       OTHER OPERATIONS
1816     // =============================================================
1817 
1818     /**
1819      * @dev Returns the message sender (defaults to `msg.sender`).
1820      *
1821      * If you are writing GSN compatible contracts, you need to override this function.
1822      */
1823     function _msgSenderERC721A() internal view virtual returns (address) {
1824         return msg.sender;
1825     }
1826 
1827     /**
1828      * @dev Converts a uint256 to its ASCII string decimal representation.
1829      */
1830     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1831         assembly {
1832             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1833             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1834             // We will need 1 32-byte word to store the length,
1835             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1836             str := add(mload(0x40), 0x80)
1837             // Update the free memory pointer to allocate.
1838             mstore(0x40, str)
1839 
1840             // Cache the end of the memory to calculate the length later.
1841             let end := str
1842 
1843             // We write the string from rightmost digit to leftmost digit.
1844             // The following is essentially a do-while loop that also handles the zero case.
1845             // prettier-ignore
1846             for { let temp := value } 1 {} {
1847                 str := sub(str, 1)
1848                 // Write the character to the pointer.
1849                 // The ASCII index of the '0' character is 48.
1850                 mstore8(str, add(48, mod(temp, 10)))
1851                 // Keep dividing `temp` until zero.
1852                 temp := div(temp, 10)
1853                 // prettier-ignore
1854                 if iszero(temp) { break }
1855             }
1856 
1857             let length := sub(end, str)
1858             // Move the pointer 32 bytes leftwards to make room for the length.
1859             str := sub(str, 0x20)
1860             // Store the length.
1861             mstore(str, length)
1862         }
1863     }
1864 }
1865 
1866 // File: hardhat/console.sol
1867 
1868 
1869 pragma solidity >= 0.4.22 <0.9.0;
1870 
1871 library console {
1872 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1873 
1874 	function _sendLogPayload(bytes memory payload) private view {
1875 		uint256 payloadLength = payload.length;
1876 		address consoleAddress = CONSOLE_ADDRESS;
1877 		assembly {
1878 			let payloadStart := add(payload, 32)
1879 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1880 		}
1881 	}
1882 
1883 	function log() internal view {
1884 		_sendLogPayload(abi.encodeWithSignature("log()"));
1885 	}
1886 
1887 	function logInt(int256 p0) internal view {
1888 		_sendLogPayload(abi.encodeWithSignature("log(int256)", p0));
1889 	}
1890 
1891 	function logUint(uint256 p0) internal view {
1892 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
1893 	}
1894 
1895 	function logString(string memory p0) internal view {
1896 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1897 	}
1898 
1899 	function logBool(bool p0) internal view {
1900 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1901 	}
1902 
1903 	function logAddress(address p0) internal view {
1904 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1905 	}
1906 
1907 	function logBytes(bytes memory p0) internal view {
1908 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1909 	}
1910 
1911 	function logBytes1(bytes1 p0) internal view {
1912 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1913 	}
1914 
1915 	function logBytes2(bytes2 p0) internal view {
1916 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1917 	}
1918 
1919 	function logBytes3(bytes3 p0) internal view {
1920 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1921 	}
1922 
1923 	function logBytes4(bytes4 p0) internal view {
1924 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1925 	}
1926 
1927 	function logBytes5(bytes5 p0) internal view {
1928 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1929 	}
1930 
1931 	function logBytes6(bytes6 p0) internal view {
1932 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1933 	}
1934 
1935 	function logBytes7(bytes7 p0) internal view {
1936 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1937 	}
1938 
1939 	function logBytes8(bytes8 p0) internal view {
1940 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1941 	}
1942 
1943 	function logBytes9(bytes9 p0) internal view {
1944 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1945 	}
1946 
1947 	function logBytes10(bytes10 p0) internal view {
1948 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1949 	}
1950 
1951 	function logBytes11(bytes11 p0) internal view {
1952 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1953 	}
1954 
1955 	function logBytes12(bytes12 p0) internal view {
1956 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1957 	}
1958 
1959 	function logBytes13(bytes13 p0) internal view {
1960 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1961 	}
1962 
1963 	function logBytes14(bytes14 p0) internal view {
1964 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1965 	}
1966 
1967 	function logBytes15(bytes15 p0) internal view {
1968 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1969 	}
1970 
1971 	function logBytes16(bytes16 p0) internal view {
1972 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1973 	}
1974 
1975 	function logBytes17(bytes17 p0) internal view {
1976 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1977 	}
1978 
1979 	function logBytes18(bytes18 p0) internal view {
1980 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1981 	}
1982 
1983 	function logBytes19(bytes19 p0) internal view {
1984 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1985 	}
1986 
1987 	function logBytes20(bytes20 p0) internal view {
1988 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1989 	}
1990 
1991 	function logBytes21(bytes21 p0) internal view {
1992 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1993 	}
1994 
1995 	function logBytes22(bytes22 p0) internal view {
1996 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1997 	}
1998 
1999 	function logBytes23(bytes23 p0) internal view {
2000 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
2001 	}
2002 
2003 	function logBytes24(bytes24 p0) internal view {
2004 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
2005 	}
2006 
2007 	function logBytes25(bytes25 p0) internal view {
2008 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
2009 	}
2010 
2011 	function logBytes26(bytes26 p0) internal view {
2012 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
2013 	}
2014 
2015 	function logBytes27(bytes27 p0) internal view {
2016 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
2017 	}
2018 
2019 	function logBytes28(bytes28 p0) internal view {
2020 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
2021 	}
2022 
2023 	function logBytes29(bytes29 p0) internal view {
2024 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
2025 	}
2026 
2027 	function logBytes30(bytes30 p0) internal view {
2028 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
2029 	}
2030 
2031 	function logBytes31(bytes31 p0) internal view {
2032 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
2033 	}
2034 
2035 	function logBytes32(bytes32 p0) internal view {
2036 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
2037 	}
2038 
2039 	function log(uint256 p0) internal view {
2040 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
2041 	}
2042 
2043 	function log(string memory p0) internal view {
2044 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
2045 	}
2046 
2047 	function log(bool p0) internal view {
2048 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
2049 	}
2050 
2051 	function log(address p0) internal view {
2052 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
2053 	}
2054 
2055 	function log(uint256 p0, uint256 p1) internal view {
2056 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256)", p0, p1));
2057 	}
2058 
2059 	function log(uint256 p0, string memory p1) internal view {
2060 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string)", p0, p1));
2061 	}
2062 
2063 	function log(uint256 p0, bool p1) internal view {
2064 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool)", p0, p1));
2065 	}
2066 
2067 	function log(uint256 p0, address p1) internal view {
2068 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address)", p0, p1));
2069 	}
2070 
2071 	function log(string memory p0, uint256 p1) internal view {
2072 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
2073 	}
2074 
2075 	function log(string memory p0, string memory p1) internal view {
2076 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
2077 	}
2078 
2079 	function log(string memory p0, bool p1) internal view {
2080 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
2081 	}
2082 
2083 	function log(string memory p0, address p1) internal view {
2084 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
2085 	}
2086 
2087 	function log(bool p0, uint256 p1) internal view {
2088 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256)", p0, p1));
2089 	}
2090 
2091 	function log(bool p0, string memory p1) internal view {
2092 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
2093 	}
2094 
2095 	function log(bool p0, bool p1) internal view {
2096 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
2097 	}
2098 
2099 	function log(bool p0, address p1) internal view {
2100 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
2101 	}
2102 
2103 	function log(address p0, uint256 p1) internal view {
2104 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256)", p0, p1));
2105 	}
2106 
2107 	function log(address p0, string memory p1) internal view {
2108 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
2109 	}
2110 
2111 	function log(address p0, bool p1) internal view {
2112 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
2113 	}
2114 
2115 	function log(address p0, address p1) internal view {
2116 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
2117 	}
2118 
2119 	function log(uint256 p0, uint256 p1, uint256 p2) internal view {
2120 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256)", p0, p1, p2));
2121 	}
2122 
2123 	function log(uint256 p0, uint256 p1, string memory p2) internal view {
2124 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string)", p0, p1, p2));
2125 	}
2126 
2127 	function log(uint256 p0, uint256 p1, bool p2) internal view {
2128 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool)", p0, p1, p2));
2129 	}
2130 
2131 	function log(uint256 p0, uint256 p1, address p2) internal view {
2132 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address)", p0, p1, p2));
2133 	}
2134 
2135 	function log(uint256 p0, string memory p1, uint256 p2) internal view {
2136 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256)", p0, p1, p2));
2137 	}
2138 
2139 	function log(uint256 p0, string memory p1, string memory p2) internal view {
2140 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string)", p0, p1, p2));
2141 	}
2142 
2143 	function log(uint256 p0, string memory p1, bool p2) internal view {
2144 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool)", p0, p1, p2));
2145 	}
2146 
2147 	function log(uint256 p0, string memory p1, address p2) internal view {
2148 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address)", p0, p1, p2));
2149 	}
2150 
2151 	function log(uint256 p0, bool p1, uint256 p2) internal view {
2152 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256)", p0, p1, p2));
2153 	}
2154 
2155 	function log(uint256 p0, bool p1, string memory p2) internal view {
2156 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string)", p0, p1, p2));
2157 	}
2158 
2159 	function log(uint256 p0, bool p1, bool p2) internal view {
2160 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool)", p0, p1, p2));
2161 	}
2162 
2163 	function log(uint256 p0, bool p1, address p2) internal view {
2164 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address)", p0, p1, p2));
2165 	}
2166 
2167 	function log(uint256 p0, address p1, uint256 p2) internal view {
2168 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256)", p0, p1, p2));
2169 	}
2170 
2171 	function log(uint256 p0, address p1, string memory p2) internal view {
2172 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string)", p0, p1, p2));
2173 	}
2174 
2175 	function log(uint256 p0, address p1, bool p2) internal view {
2176 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool)", p0, p1, p2));
2177 	}
2178 
2179 	function log(uint256 p0, address p1, address p2) internal view {
2180 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address)", p0, p1, p2));
2181 	}
2182 
2183 	function log(string memory p0, uint256 p1, uint256 p2) internal view {
2184 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256)", p0, p1, p2));
2185 	}
2186 
2187 	function log(string memory p0, uint256 p1, string memory p2) internal view {
2188 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string)", p0, p1, p2));
2189 	}
2190 
2191 	function log(string memory p0, uint256 p1, bool p2) internal view {
2192 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool)", p0, p1, p2));
2193 	}
2194 
2195 	function log(string memory p0, uint256 p1, address p2) internal view {
2196 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address)", p0, p1, p2));
2197 	}
2198 
2199 	function log(string memory p0, string memory p1, uint256 p2) internal view {
2200 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256)", p0, p1, p2));
2201 	}
2202 
2203 	function log(string memory p0, string memory p1, string memory p2) internal view {
2204 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
2205 	}
2206 
2207 	function log(string memory p0, string memory p1, bool p2) internal view {
2208 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
2209 	}
2210 
2211 	function log(string memory p0, string memory p1, address p2) internal view {
2212 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
2213 	}
2214 
2215 	function log(string memory p0, bool p1, uint256 p2) internal view {
2216 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256)", p0, p1, p2));
2217 	}
2218 
2219 	function log(string memory p0, bool p1, string memory p2) internal view {
2220 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
2221 	}
2222 
2223 	function log(string memory p0, bool p1, bool p2) internal view {
2224 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
2225 	}
2226 
2227 	function log(string memory p0, bool p1, address p2) internal view {
2228 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
2229 	}
2230 
2231 	function log(string memory p0, address p1, uint256 p2) internal view {
2232 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2));
2233 	}
2234 
2235 	function log(string memory p0, address p1, string memory p2) internal view {
2236 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
2237 	}
2238 
2239 	function log(string memory p0, address p1, bool p2) internal view {
2240 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
2241 	}
2242 
2243 	function log(string memory p0, address p1, address p2) internal view {
2244 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
2245 	}
2246 
2247 	function log(bool p0, uint256 p1, uint256 p2) internal view {
2248 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256)", p0, p1, p2));
2249 	}
2250 
2251 	function log(bool p0, uint256 p1, string memory p2) internal view {
2252 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string)", p0, p1, p2));
2253 	}
2254 
2255 	function log(bool p0, uint256 p1, bool p2) internal view {
2256 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool)", p0, p1, p2));
2257 	}
2258 
2259 	function log(bool p0, uint256 p1, address p2) internal view {
2260 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address)", p0, p1, p2));
2261 	}
2262 
2263 	function log(bool p0, string memory p1, uint256 p2) internal view {
2264 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256)", p0, p1, p2));
2265 	}
2266 
2267 	function log(bool p0, string memory p1, string memory p2) internal view {
2268 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
2269 	}
2270 
2271 	function log(bool p0, string memory p1, bool p2) internal view {
2272 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
2273 	}
2274 
2275 	function log(bool p0, string memory p1, address p2) internal view {
2276 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
2277 	}
2278 
2279 	function log(bool p0, bool p1, uint256 p2) internal view {
2280 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256)", p0, p1, p2));
2281 	}
2282 
2283 	function log(bool p0, bool p1, string memory p2) internal view {
2284 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
2285 	}
2286 
2287 	function log(bool p0, bool p1, bool p2) internal view {
2288 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
2289 	}
2290 
2291 	function log(bool p0, bool p1, address p2) internal view {
2292 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
2293 	}
2294 
2295 	function log(bool p0, address p1, uint256 p2) internal view {
2296 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256)", p0, p1, p2));
2297 	}
2298 
2299 	function log(bool p0, address p1, string memory p2) internal view {
2300 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
2301 	}
2302 
2303 	function log(bool p0, address p1, bool p2) internal view {
2304 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
2305 	}
2306 
2307 	function log(bool p0, address p1, address p2) internal view {
2308 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
2309 	}
2310 
2311 	function log(address p0, uint256 p1, uint256 p2) internal view {
2312 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256)", p0, p1, p2));
2313 	}
2314 
2315 	function log(address p0, uint256 p1, string memory p2) internal view {
2316 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string)", p0, p1, p2));
2317 	}
2318 
2319 	function log(address p0, uint256 p1, bool p2) internal view {
2320 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool)", p0, p1, p2));
2321 	}
2322 
2323 	function log(address p0, uint256 p1, address p2) internal view {
2324 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address)", p0, p1, p2));
2325 	}
2326 
2327 	function log(address p0, string memory p1, uint256 p2) internal view {
2328 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256)", p0, p1, p2));
2329 	}
2330 
2331 	function log(address p0, string memory p1, string memory p2) internal view {
2332 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
2333 	}
2334 
2335 	function log(address p0, string memory p1, bool p2) internal view {
2336 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
2337 	}
2338 
2339 	function log(address p0, string memory p1, address p2) internal view {
2340 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
2341 	}
2342 
2343 	function log(address p0, bool p1, uint256 p2) internal view {
2344 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256)", p0, p1, p2));
2345 	}
2346 
2347 	function log(address p0, bool p1, string memory p2) internal view {
2348 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2349 	}
2350 
2351 	function log(address p0, bool p1, bool p2) internal view {
2352 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2353 	}
2354 
2355 	function log(address p0, bool p1, address p2) internal view {
2356 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2357 	}
2358 
2359 	function log(address p0, address p1, uint256 p2) internal view {
2360 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256)", p0, p1, p2));
2361 	}
2362 
2363 	function log(address p0, address p1, string memory p2) internal view {
2364 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2365 	}
2366 
2367 	function log(address p0, address p1, bool p2) internal view {
2368 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2369 	}
2370 
2371 	function log(address p0, address p1, address p2) internal view {
2372 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2373 	}
2374 
2375 	function log(uint256 p0, uint256 p1, uint256 p2, uint256 p3) internal view {
2376 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,uint256)", p0, p1, p2, p3));
2377 	}
2378 
2379 	function log(uint256 p0, uint256 p1, uint256 p2, string memory p3) internal view {
2380 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,string)", p0, p1, p2, p3));
2381 	}
2382 
2383 	function log(uint256 p0, uint256 p1, uint256 p2, bool p3) internal view {
2384 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,bool)", p0, p1, p2, p3));
2385 	}
2386 
2387 	function log(uint256 p0, uint256 p1, uint256 p2, address p3) internal view {
2388 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,address)", p0, p1, p2, p3));
2389 	}
2390 
2391 	function log(uint256 p0, uint256 p1, string memory p2, uint256 p3) internal view {
2392 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,uint256)", p0, p1, p2, p3));
2393 	}
2394 
2395 	function log(uint256 p0, uint256 p1, string memory p2, string memory p3) internal view {
2396 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,string)", p0, p1, p2, p3));
2397 	}
2398 
2399 	function log(uint256 p0, uint256 p1, string memory p2, bool p3) internal view {
2400 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,bool)", p0, p1, p2, p3));
2401 	}
2402 
2403 	function log(uint256 p0, uint256 p1, string memory p2, address p3) internal view {
2404 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,address)", p0, p1, p2, p3));
2405 	}
2406 
2407 	function log(uint256 p0, uint256 p1, bool p2, uint256 p3) internal view {
2408 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,uint256)", p0, p1, p2, p3));
2409 	}
2410 
2411 	function log(uint256 p0, uint256 p1, bool p2, string memory p3) internal view {
2412 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,string)", p0, p1, p2, p3));
2413 	}
2414 
2415 	function log(uint256 p0, uint256 p1, bool p2, bool p3) internal view {
2416 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,bool)", p0, p1, p2, p3));
2417 	}
2418 
2419 	function log(uint256 p0, uint256 p1, bool p2, address p3) internal view {
2420 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,address)", p0, p1, p2, p3));
2421 	}
2422 
2423 	function log(uint256 p0, uint256 p1, address p2, uint256 p3) internal view {
2424 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,uint256)", p0, p1, p2, p3));
2425 	}
2426 
2427 	function log(uint256 p0, uint256 p1, address p2, string memory p3) internal view {
2428 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,string)", p0, p1, p2, p3));
2429 	}
2430 
2431 	function log(uint256 p0, uint256 p1, address p2, bool p3) internal view {
2432 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,bool)", p0, p1, p2, p3));
2433 	}
2434 
2435 	function log(uint256 p0, uint256 p1, address p2, address p3) internal view {
2436 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,address)", p0, p1, p2, p3));
2437 	}
2438 
2439 	function log(uint256 p0, string memory p1, uint256 p2, uint256 p3) internal view {
2440 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,uint256)", p0, p1, p2, p3));
2441 	}
2442 
2443 	function log(uint256 p0, string memory p1, uint256 p2, string memory p3) internal view {
2444 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,string)", p0, p1, p2, p3));
2445 	}
2446 
2447 	function log(uint256 p0, string memory p1, uint256 p2, bool p3) internal view {
2448 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,bool)", p0, p1, p2, p3));
2449 	}
2450 
2451 	function log(uint256 p0, string memory p1, uint256 p2, address p3) internal view {
2452 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,address)", p0, p1, p2, p3));
2453 	}
2454 
2455 	function log(uint256 p0, string memory p1, string memory p2, uint256 p3) internal view {
2456 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,uint256)", p0, p1, p2, p3));
2457 	}
2458 
2459 	function log(uint256 p0, string memory p1, string memory p2, string memory p3) internal view {
2460 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,string)", p0, p1, p2, p3));
2461 	}
2462 
2463 	function log(uint256 p0, string memory p1, string memory p2, bool p3) internal view {
2464 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,bool)", p0, p1, p2, p3));
2465 	}
2466 
2467 	function log(uint256 p0, string memory p1, string memory p2, address p3) internal view {
2468 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,address)", p0, p1, p2, p3));
2469 	}
2470 
2471 	function log(uint256 p0, string memory p1, bool p2, uint256 p3) internal view {
2472 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,uint256)", p0, p1, p2, p3));
2473 	}
2474 
2475 	function log(uint256 p0, string memory p1, bool p2, string memory p3) internal view {
2476 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,string)", p0, p1, p2, p3));
2477 	}
2478 
2479 	function log(uint256 p0, string memory p1, bool p2, bool p3) internal view {
2480 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,bool)", p0, p1, p2, p3));
2481 	}
2482 
2483 	function log(uint256 p0, string memory p1, bool p2, address p3) internal view {
2484 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,address)", p0, p1, p2, p3));
2485 	}
2486 
2487 	function log(uint256 p0, string memory p1, address p2, uint256 p3) internal view {
2488 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,uint256)", p0, p1, p2, p3));
2489 	}
2490 
2491 	function log(uint256 p0, string memory p1, address p2, string memory p3) internal view {
2492 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,string)", p0, p1, p2, p3));
2493 	}
2494 
2495 	function log(uint256 p0, string memory p1, address p2, bool p3) internal view {
2496 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,bool)", p0, p1, p2, p3));
2497 	}
2498 
2499 	function log(uint256 p0, string memory p1, address p2, address p3) internal view {
2500 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,address)", p0, p1, p2, p3));
2501 	}
2502 
2503 	function log(uint256 p0, bool p1, uint256 p2, uint256 p3) internal view {
2504 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,uint256)", p0, p1, p2, p3));
2505 	}
2506 
2507 	function log(uint256 p0, bool p1, uint256 p2, string memory p3) internal view {
2508 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,string)", p0, p1, p2, p3));
2509 	}
2510 
2511 	function log(uint256 p0, bool p1, uint256 p2, bool p3) internal view {
2512 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,bool)", p0, p1, p2, p3));
2513 	}
2514 
2515 	function log(uint256 p0, bool p1, uint256 p2, address p3) internal view {
2516 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,address)", p0, p1, p2, p3));
2517 	}
2518 
2519 	function log(uint256 p0, bool p1, string memory p2, uint256 p3) internal view {
2520 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,uint256)", p0, p1, p2, p3));
2521 	}
2522 
2523 	function log(uint256 p0, bool p1, string memory p2, string memory p3) internal view {
2524 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,string)", p0, p1, p2, p3));
2525 	}
2526 
2527 	function log(uint256 p0, bool p1, string memory p2, bool p3) internal view {
2528 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,bool)", p0, p1, p2, p3));
2529 	}
2530 
2531 	function log(uint256 p0, bool p1, string memory p2, address p3) internal view {
2532 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,address)", p0, p1, p2, p3));
2533 	}
2534 
2535 	function log(uint256 p0, bool p1, bool p2, uint256 p3) internal view {
2536 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,uint256)", p0, p1, p2, p3));
2537 	}
2538 
2539 	function log(uint256 p0, bool p1, bool p2, string memory p3) internal view {
2540 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,string)", p0, p1, p2, p3));
2541 	}
2542 
2543 	function log(uint256 p0, bool p1, bool p2, bool p3) internal view {
2544 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,bool)", p0, p1, p2, p3));
2545 	}
2546 
2547 	function log(uint256 p0, bool p1, bool p2, address p3) internal view {
2548 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,address)", p0, p1, p2, p3));
2549 	}
2550 
2551 	function log(uint256 p0, bool p1, address p2, uint256 p3) internal view {
2552 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,uint256)", p0, p1, p2, p3));
2553 	}
2554 
2555 	function log(uint256 p0, bool p1, address p2, string memory p3) internal view {
2556 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,string)", p0, p1, p2, p3));
2557 	}
2558 
2559 	function log(uint256 p0, bool p1, address p2, bool p3) internal view {
2560 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,bool)", p0, p1, p2, p3));
2561 	}
2562 
2563 	function log(uint256 p0, bool p1, address p2, address p3) internal view {
2564 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,address)", p0, p1, p2, p3));
2565 	}
2566 
2567 	function log(uint256 p0, address p1, uint256 p2, uint256 p3) internal view {
2568 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,uint256)", p0, p1, p2, p3));
2569 	}
2570 
2571 	function log(uint256 p0, address p1, uint256 p2, string memory p3) internal view {
2572 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,string)", p0, p1, p2, p3));
2573 	}
2574 
2575 	function log(uint256 p0, address p1, uint256 p2, bool p3) internal view {
2576 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,bool)", p0, p1, p2, p3));
2577 	}
2578 
2579 	function log(uint256 p0, address p1, uint256 p2, address p3) internal view {
2580 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,address)", p0, p1, p2, p3));
2581 	}
2582 
2583 	function log(uint256 p0, address p1, string memory p2, uint256 p3) internal view {
2584 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,uint256)", p0, p1, p2, p3));
2585 	}
2586 
2587 	function log(uint256 p0, address p1, string memory p2, string memory p3) internal view {
2588 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,string)", p0, p1, p2, p3));
2589 	}
2590 
2591 	function log(uint256 p0, address p1, string memory p2, bool p3) internal view {
2592 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,bool)", p0, p1, p2, p3));
2593 	}
2594 
2595 	function log(uint256 p0, address p1, string memory p2, address p3) internal view {
2596 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,address)", p0, p1, p2, p3));
2597 	}
2598 
2599 	function log(uint256 p0, address p1, bool p2, uint256 p3) internal view {
2600 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,uint256)", p0, p1, p2, p3));
2601 	}
2602 
2603 	function log(uint256 p0, address p1, bool p2, string memory p3) internal view {
2604 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,string)", p0, p1, p2, p3));
2605 	}
2606 
2607 	function log(uint256 p0, address p1, bool p2, bool p3) internal view {
2608 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,bool)", p0, p1, p2, p3));
2609 	}
2610 
2611 	function log(uint256 p0, address p1, bool p2, address p3) internal view {
2612 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,address)", p0, p1, p2, p3));
2613 	}
2614 
2615 	function log(uint256 p0, address p1, address p2, uint256 p3) internal view {
2616 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,uint256)", p0, p1, p2, p3));
2617 	}
2618 
2619 	function log(uint256 p0, address p1, address p2, string memory p3) internal view {
2620 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,string)", p0, p1, p2, p3));
2621 	}
2622 
2623 	function log(uint256 p0, address p1, address p2, bool p3) internal view {
2624 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,bool)", p0, p1, p2, p3));
2625 	}
2626 
2627 	function log(uint256 p0, address p1, address p2, address p3) internal view {
2628 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,address)", p0, p1, p2, p3));
2629 	}
2630 
2631 	function log(string memory p0, uint256 p1, uint256 p2, uint256 p3) internal view {
2632 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,uint256)", p0, p1, p2, p3));
2633 	}
2634 
2635 	function log(string memory p0, uint256 p1, uint256 p2, string memory p3) internal view {
2636 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,string)", p0, p1, p2, p3));
2637 	}
2638 
2639 	function log(string memory p0, uint256 p1, uint256 p2, bool p3) internal view {
2640 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,bool)", p0, p1, p2, p3));
2641 	}
2642 
2643 	function log(string memory p0, uint256 p1, uint256 p2, address p3) internal view {
2644 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,address)", p0, p1, p2, p3));
2645 	}
2646 
2647 	function log(string memory p0, uint256 p1, string memory p2, uint256 p3) internal view {
2648 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,uint256)", p0, p1, p2, p3));
2649 	}
2650 
2651 	function log(string memory p0, uint256 p1, string memory p2, string memory p3) internal view {
2652 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,string)", p0, p1, p2, p3));
2653 	}
2654 
2655 	function log(string memory p0, uint256 p1, string memory p2, bool p3) internal view {
2656 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,bool)", p0, p1, p2, p3));
2657 	}
2658 
2659 	function log(string memory p0, uint256 p1, string memory p2, address p3) internal view {
2660 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,address)", p0, p1, p2, p3));
2661 	}
2662 
2663 	function log(string memory p0, uint256 p1, bool p2, uint256 p3) internal view {
2664 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,uint256)", p0, p1, p2, p3));
2665 	}
2666 
2667 	function log(string memory p0, uint256 p1, bool p2, string memory p3) internal view {
2668 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,string)", p0, p1, p2, p3));
2669 	}
2670 
2671 	function log(string memory p0, uint256 p1, bool p2, bool p3) internal view {
2672 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,bool)", p0, p1, p2, p3));
2673 	}
2674 
2675 	function log(string memory p0, uint256 p1, bool p2, address p3) internal view {
2676 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,address)", p0, p1, p2, p3));
2677 	}
2678 
2679 	function log(string memory p0, uint256 p1, address p2, uint256 p3) internal view {
2680 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,uint256)", p0, p1, p2, p3));
2681 	}
2682 
2683 	function log(string memory p0, uint256 p1, address p2, string memory p3) internal view {
2684 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,string)", p0, p1, p2, p3));
2685 	}
2686 
2687 	function log(string memory p0, uint256 p1, address p2, bool p3) internal view {
2688 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,bool)", p0, p1, p2, p3));
2689 	}
2690 
2691 	function log(string memory p0, uint256 p1, address p2, address p3) internal view {
2692 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,address)", p0, p1, p2, p3));
2693 	}
2694 
2695 	function log(string memory p0, string memory p1, uint256 p2, uint256 p3) internal view {
2696 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,uint256)", p0, p1, p2, p3));
2697 	}
2698 
2699 	function log(string memory p0, string memory p1, uint256 p2, string memory p3) internal view {
2700 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,string)", p0, p1, p2, p3));
2701 	}
2702 
2703 	function log(string memory p0, string memory p1, uint256 p2, bool p3) internal view {
2704 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,bool)", p0, p1, p2, p3));
2705 	}
2706 
2707 	function log(string memory p0, string memory p1, uint256 p2, address p3) internal view {
2708 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,address)", p0, p1, p2, p3));
2709 	}
2710 
2711 	function log(string memory p0, string memory p1, string memory p2, uint256 p3) internal view {
2712 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint256)", p0, p1, p2, p3));
2713 	}
2714 
2715 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2716 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2717 	}
2718 
2719 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2720 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2721 	}
2722 
2723 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2724 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2725 	}
2726 
2727 	function log(string memory p0, string memory p1, bool p2, uint256 p3) internal view {
2728 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint256)", p0, p1, p2, p3));
2729 	}
2730 
2731 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2732 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2733 	}
2734 
2735 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2736 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2737 	}
2738 
2739 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2740 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2741 	}
2742 
2743 	function log(string memory p0, string memory p1, address p2, uint256 p3) internal view {
2744 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint256)", p0, p1, p2, p3));
2745 	}
2746 
2747 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2748 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2749 	}
2750 
2751 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2752 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2753 	}
2754 
2755 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2756 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2757 	}
2758 
2759 	function log(string memory p0, bool p1, uint256 p2, uint256 p3) internal view {
2760 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,uint256)", p0, p1, p2, p3));
2761 	}
2762 
2763 	function log(string memory p0, bool p1, uint256 p2, string memory p3) internal view {
2764 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,string)", p0, p1, p2, p3));
2765 	}
2766 
2767 	function log(string memory p0, bool p1, uint256 p2, bool p3) internal view {
2768 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,bool)", p0, p1, p2, p3));
2769 	}
2770 
2771 	function log(string memory p0, bool p1, uint256 p2, address p3) internal view {
2772 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,address)", p0, p1, p2, p3));
2773 	}
2774 
2775 	function log(string memory p0, bool p1, string memory p2, uint256 p3) internal view {
2776 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint256)", p0, p1, p2, p3));
2777 	}
2778 
2779 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2780 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2781 	}
2782 
2783 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2784 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2785 	}
2786 
2787 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2788 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2789 	}
2790 
2791 	function log(string memory p0, bool p1, bool p2, uint256 p3) internal view {
2792 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint256)", p0, p1, p2, p3));
2793 	}
2794 
2795 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2796 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2797 	}
2798 
2799 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2800 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2801 	}
2802 
2803 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2804 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2805 	}
2806 
2807 	function log(string memory p0, bool p1, address p2, uint256 p3) internal view {
2808 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint256)", p0, p1, p2, p3));
2809 	}
2810 
2811 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2812 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2813 	}
2814 
2815 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2816 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2817 	}
2818 
2819 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2820 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2821 	}
2822 
2823 	function log(string memory p0, address p1, uint256 p2, uint256 p3) internal view {
2824 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,uint256)", p0, p1, p2, p3));
2825 	}
2826 
2827 	function log(string memory p0, address p1, uint256 p2, string memory p3) internal view {
2828 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,string)", p0, p1, p2, p3));
2829 	}
2830 
2831 	function log(string memory p0, address p1, uint256 p2, bool p3) internal view {
2832 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,bool)", p0, p1, p2, p3));
2833 	}
2834 
2835 	function log(string memory p0, address p1, uint256 p2, address p3) internal view {
2836 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,address)", p0, p1, p2, p3));
2837 	}
2838 
2839 	function log(string memory p0, address p1, string memory p2, uint256 p3) internal view {
2840 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint256)", p0, p1, p2, p3));
2841 	}
2842 
2843 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2844 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2845 	}
2846 
2847 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2848 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2849 	}
2850 
2851 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2852 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2853 	}
2854 
2855 	function log(string memory p0, address p1, bool p2, uint256 p3) internal view {
2856 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint256)", p0, p1, p2, p3));
2857 	}
2858 
2859 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2860 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2861 	}
2862 
2863 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2864 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2865 	}
2866 
2867 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2868 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2869 	}
2870 
2871 	function log(string memory p0, address p1, address p2, uint256 p3) internal view {
2872 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint256)", p0, p1, p2, p3));
2873 	}
2874 
2875 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2876 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2877 	}
2878 
2879 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2880 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2881 	}
2882 
2883 	function log(string memory p0, address p1, address p2, address p3) internal view {
2884 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2885 	}
2886 
2887 	function log(bool p0, uint256 p1, uint256 p2, uint256 p3) internal view {
2888 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,uint256)", p0, p1, p2, p3));
2889 	}
2890 
2891 	function log(bool p0, uint256 p1, uint256 p2, string memory p3) internal view {
2892 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,string)", p0, p1, p2, p3));
2893 	}
2894 
2895 	function log(bool p0, uint256 p1, uint256 p2, bool p3) internal view {
2896 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,bool)", p0, p1, p2, p3));
2897 	}
2898 
2899 	function log(bool p0, uint256 p1, uint256 p2, address p3) internal view {
2900 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,address)", p0, p1, p2, p3));
2901 	}
2902 
2903 	function log(bool p0, uint256 p1, string memory p2, uint256 p3) internal view {
2904 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,uint256)", p0, p1, p2, p3));
2905 	}
2906 
2907 	function log(bool p0, uint256 p1, string memory p2, string memory p3) internal view {
2908 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,string)", p0, p1, p2, p3));
2909 	}
2910 
2911 	function log(bool p0, uint256 p1, string memory p2, bool p3) internal view {
2912 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,bool)", p0, p1, p2, p3));
2913 	}
2914 
2915 	function log(bool p0, uint256 p1, string memory p2, address p3) internal view {
2916 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,address)", p0, p1, p2, p3));
2917 	}
2918 
2919 	function log(bool p0, uint256 p1, bool p2, uint256 p3) internal view {
2920 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,uint256)", p0, p1, p2, p3));
2921 	}
2922 
2923 	function log(bool p0, uint256 p1, bool p2, string memory p3) internal view {
2924 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,string)", p0, p1, p2, p3));
2925 	}
2926 
2927 	function log(bool p0, uint256 p1, bool p2, bool p3) internal view {
2928 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,bool)", p0, p1, p2, p3));
2929 	}
2930 
2931 	function log(bool p0, uint256 p1, bool p2, address p3) internal view {
2932 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,address)", p0, p1, p2, p3));
2933 	}
2934 
2935 	function log(bool p0, uint256 p1, address p2, uint256 p3) internal view {
2936 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,uint256)", p0, p1, p2, p3));
2937 	}
2938 
2939 	function log(bool p0, uint256 p1, address p2, string memory p3) internal view {
2940 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,string)", p0, p1, p2, p3));
2941 	}
2942 
2943 	function log(bool p0, uint256 p1, address p2, bool p3) internal view {
2944 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,bool)", p0, p1, p2, p3));
2945 	}
2946 
2947 	function log(bool p0, uint256 p1, address p2, address p3) internal view {
2948 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,address)", p0, p1, p2, p3));
2949 	}
2950 
2951 	function log(bool p0, string memory p1, uint256 p2, uint256 p3) internal view {
2952 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,uint256)", p0, p1, p2, p3));
2953 	}
2954 
2955 	function log(bool p0, string memory p1, uint256 p2, string memory p3) internal view {
2956 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,string)", p0, p1, p2, p3));
2957 	}
2958 
2959 	function log(bool p0, string memory p1, uint256 p2, bool p3) internal view {
2960 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,bool)", p0, p1, p2, p3));
2961 	}
2962 
2963 	function log(bool p0, string memory p1, uint256 p2, address p3) internal view {
2964 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,address)", p0, p1, p2, p3));
2965 	}
2966 
2967 	function log(bool p0, string memory p1, string memory p2, uint256 p3) internal view {
2968 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint256)", p0, p1, p2, p3));
2969 	}
2970 
2971 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2972 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2973 	}
2974 
2975 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2976 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2977 	}
2978 
2979 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2980 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2981 	}
2982 
2983 	function log(bool p0, string memory p1, bool p2, uint256 p3) internal view {
2984 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint256)", p0, p1, p2, p3));
2985 	}
2986 
2987 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2988 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2989 	}
2990 
2991 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2992 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2993 	}
2994 
2995 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2996 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2997 	}
2998 
2999 	function log(bool p0, string memory p1, address p2, uint256 p3) internal view {
3000 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint256)", p0, p1, p2, p3));
3001 	}
3002 
3003 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
3004 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
3005 	}
3006 
3007 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
3008 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
3009 	}
3010 
3011 	function log(bool p0, string memory p1, address p2, address p3) internal view {
3012 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
3013 	}
3014 
3015 	function log(bool p0, bool p1, uint256 p2, uint256 p3) internal view {
3016 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,uint256)", p0, p1, p2, p3));
3017 	}
3018 
3019 	function log(bool p0, bool p1, uint256 p2, string memory p3) internal view {
3020 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,string)", p0, p1, p2, p3));
3021 	}
3022 
3023 	function log(bool p0, bool p1, uint256 p2, bool p3) internal view {
3024 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,bool)", p0, p1, p2, p3));
3025 	}
3026 
3027 	function log(bool p0, bool p1, uint256 p2, address p3) internal view {
3028 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,address)", p0, p1, p2, p3));
3029 	}
3030 
3031 	function log(bool p0, bool p1, string memory p2, uint256 p3) internal view {
3032 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint256)", p0, p1, p2, p3));
3033 	}
3034 
3035 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
3036 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
3037 	}
3038 
3039 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
3040 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
3041 	}
3042 
3043 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
3044 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
3045 	}
3046 
3047 	function log(bool p0, bool p1, bool p2, uint256 p3) internal view {
3048 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint256)", p0, p1, p2, p3));
3049 	}
3050 
3051 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
3052 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
3053 	}
3054 
3055 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
3056 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
3057 	}
3058 
3059 	function log(bool p0, bool p1, bool p2, address p3) internal view {
3060 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
3061 	}
3062 
3063 	function log(bool p0, bool p1, address p2, uint256 p3) internal view {
3064 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint256)", p0, p1, p2, p3));
3065 	}
3066 
3067 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
3068 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
3069 	}
3070 
3071 	function log(bool p0, bool p1, address p2, bool p3) internal view {
3072 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
3073 	}
3074 
3075 	function log(bool p0, bool p1, address p2, address p3) internal view {
3076 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
3077 	}
3078 
3079 	function log(bool p0, address p1, uint256 p2, uint256 p3) internal view {
3080 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,uint256)", p0, p1, p2, p3));
3081 	}
3082 
3083 	function log(bool p0, address p1, uint256 p2, string memory p3) internal view {
3084 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,string)", p0, p1, p2, p3));
3085 	}
3086 
3087 	function log(bool p0, address p1, uint256 p2, bool p3) internal view {
3088 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,bool)", p0, p1, p2, p3));
3089 	}
3090 
3091 	function log(bool p0, address p1, uint256 p2, address p3) internal view {
3092 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,address)", p0, p1, p2, p3));
3093 	}
3094 
3095 	function log(bool p0, address p1, string memory p2, uint256 p3) internal view {
3096 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint256)", p0, p1, p2, p3));
3097 	}
3098 
3099 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
3100 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
3101 	}
3102 
3103 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
3104 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
3105 	}
3106 
3107 	function log(bool p0, address p1, string memory p2, address p3) internal view {
3108 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
3109 	}
3110 
3111 	function log(bool p0, address p1, bool p2, uint256 p3) internal view {
3112 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint256)", p0, p1, p2, p3));
3113 	}
3114 
3115 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
3116 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
3117 	}
3118 
3119 	function log(bool p0, address p1, bool p2, bool p3) internal view {
3120 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
3121 	}
3122 
3123 	function log(bool p0, address p1, bool p2, address p3) internal view {
3124 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
3125 	}
3126 
3127 	function log(bool p0, address p1, address p2, uint256 p3) internal view {
3128 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint256)", p0, p1, p2, p3));
3129 	}
3130 
3131 	function log(bool p0, address p1, address p2, string memory p3) internal view {
3132 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
3133 	}
3134 
3135 	function log(bool p0, address p1, address p2, bool p3) internal view {
3136 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
3137 	}
3138 
3139 	function log(bool p0, address p1, address p2, address p3) internal view {
3140 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
3141 	}
3142 
3143 	function log(address p0, uint256 p1, uint256 p2, uint256 p3) internal view {
3144 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,uint256)", p0, p1, p2, p3));
3145 	}
3146 
3147 	function log(address p0, uint256 p1, uint256 p2, string memory p3) internal view {
3148 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,string)", p0, p1, p2, p3));
3149 	}
3150 
3151 	function log(address p0, uint256 p1, uint256 p2, bool p3) internal view {
3152 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,bool)", p0, p1, p2, p3));
3153 	}
3154 
3155 	function log(address p0, uint256 p1, uint256 p2, address p3) internal view {
3156 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,address)", p0, p1, p2, p3));
3157 	}
3158 
3159 	function log(address p0, uint256 p1, string memory p2, uint256 p3) internal view {
3160 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,uint256)", p0, p1, p2, p3));
3161 	}
3162 
3163 	function log(address p0, uint256 p1, string memory p2, string memory p3) internal view {
3164 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,string)", p0, p1, p2, p3));
3165 	}
3166 
3167 	function log(address p0, uint256 p1, string memory p2, bool p3) internal view {
3168 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,bool)", p0, p1, p2, p3));
3169 	}
3170 
3171 	function log(address p0, uint256 p1, string memory p2, address p3) internal view {
3172 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,address)", p0, p1, p2, p3));
3173 	}
3174 
3175 	function log(address p0, uint256 p1, bool p2, uint256 p3) internal view {
3176 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,uint256)", p0, p1, p2, p3));
3177 	}
3178 
3179 	function log(address p0, uint256 p1, bool p2, string memory p3) internal view {
3180 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,string)", p0, p1, p2, p3));
3181 	}
3182 
3183 	function log(address p0, uint256 p1, bool p2, bool p3) internal view {
3184 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,bool)", p0, p1, p2, p3));
3185 	}
3186 
3187 	function log(address p0, uint256 p1, bool p2, address p3) internal view {
3188 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,address)", p0, p1, p2, p3));
3189 	}
3190 
3191 	function log(address p0, uint256 p1, address p2, uint256 p3) internal view {
3192 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,uint256)", p0, p1, p2, p3));
3193 	}
3194 
3195 	function log(address p0, uint256 p1, address p2, string memory p3) internal view {
3196 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,string)", p0, p1, p2, p3));
3197 	}
3198 
3199 	function log(address p0, uint256 p1, address p2, bool p3) internal view {
3200 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,bool)", p0, p1, p2, p3));
3201 	}
3202 
3203 	function log(address p0, uint256 p1, address p2, address p3) internal view {
3204 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,address)", p0, p1, p2, p3));
3205 	}
3206 
3207 	function log(address p0, string memory p1, uint256 p2, uint256 p3) internal view {
3208 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,uint256)", p0, p1, p2, p3));
3209 	}
3210 
3211 	function log(address p0, string memory p1, uint256 p2, string memory p3) internal view {
3212 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,string)", p0, p1, p2, p3));
3213 	}
3214 
3215 	function log(address p0, string memory p1, uint256 p2, bool p3) internal view {
3216 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,bool)", p0, p1, p2, p3));
3217 	}
3218 
3219 	function log(address p0, string memory p1, uint256 p2, address p3) internal view {
3220 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,address)", p0, p1, p2, p3));
3221 	}
3222 
3223 	function log(address p0, string memory p1, string memory p2, uint256 p3) internal view {
3224 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint256)", p0, p1, p2, p3));
3225 	}
3226 
3227 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
3228 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
3229 	}
3230 
3231 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
3232 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
3233 	}
3234 
3235 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
3236 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
3237 	}
3238 
3239 	function log(address p0, string memory p1, bool p2, uint256 p3) internal view {
3240 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint256)", p0, p1, p2, p3));
3241 	}
3242 
3243 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
3244 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
3245 	}
3246 
3247 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
3248 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
3249 	}
3250 
3251 	function log(address p0, string memory p1, bool p2, address p3) internal view {
3252 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
3253 	}
3254 
3255 	function log(address p0, string memory p1, address p2, uint256 p3) internal view {
3256 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint256)", p0, p1, p2, p3));
3257 	}
3258 
3259 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
3260 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
3261 	}
3262 
3263 	function log(address p0, string memory p1, address p2, bool p3) internal view {
3264 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
3265 	}
3266 
3267 	function log(address p0, string memory p1, address p2, address p3) internal view {
3268 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
3269 	}
3270 
3271 	function log(address p0, bool p1, uint256 p2, uint256 p3) internal view {
3272 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,uint256)", p0, p1, p2, p3));
3273 	}
3274 
3275 	function log(address p0, bool p1, uint256 p2, string memory p3) internal view {
3276 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,string)", p0, p1, p2, p3));
3277 	}
3278 
3279 	function log(address p0, bool p1, uint256 p2, bool p3) internal view {
3280 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,bool)", p0, p1, p2, p3));
3281 	}
3282 
3283 	function log(address p0, bool p1, uint256 p2, address p3) internal view {
3284 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,address)", p0, p1, p2, p3));
3285 	}
3286 
3287 	function log(address p0, bool p1, string memory p2, uint256 p3) internal view {
3288 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint256)", p0, p1, p2, p3));
3289 	}
3290 
3291 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
3292 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
3293 	}
3294 
3295 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
3296 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
3297 	}
3298 
3299 	function log(address p0, bool p1, string memory p2, address p3) internal view {
3300 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
3301 	}
3302 
3303 	function log(address p0, bool p1, bool p2, uint256 p3) internal view {
3304 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint256)", p0, p1, p2, p3));
3305 	}
3306 
3307 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
3308 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
3309 	}
3310 
3311 	function log(address p0, bool p1, bool p2, bool p3) internal view {
3312 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
3313 	}
3314 
3315 	function log(address p0, bool p1, bool p2, address p3) internal view {
3316 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
3317 	}
3318 
3319 	function log(address p0, bool p1, address p2, uint256 p3) internal view {
3320 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint256)", p0, p1, p2, p3));
3321 	}
3322 
3323 	function log(address p0, bool p1, address p2, string memory p3) internal view {
3324 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
3325 	}
3326 
3327 	function log(address p0, bool p1, address p2, bool p3) internal view {
3328 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
3329 	}
3330 
3331 	function log(address p0, bool p1, address p2, address p3) internal view {
3332 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
3333 	}
3334 
3335 	function log(address p0, address p1, uint256 p2, uint256 p3) internal view {
3336 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,uint256)", p0, p1, p2, p3));
3337 	}
3338 
3339 	function log(address p0, address p1, uint256 p2, string memory p3) internal view {
3340 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,string)", p0, p1, p2, p3));
3341 	}
3342 
3343 	function log(address p0, address p1, uint256 p2, bool p3) internal view {
3344 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,bool)", p0, p1, p2, p3));
3345 	}
3346 
3347 	function log(address p0, address p1, uint256 p2, address p3) internal view {
3348 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,address)", p0, p1, p2, p3));
3349 	}
3350 
3351 	function log(address p0, address p1, string memory p2, uint256 p3) internal view {
3352 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint256)", p0, p1, p2, p3));
3353 	}
3354 
3355 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3356 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3357 	}
3358 
3359 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3360 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3361 	}
3362 
3363 	function log(address p0, address p1, string memory p2, address p3) internal view {
3364 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3365 	}
3366 
3367 	function log(address p0, address p1, bool p2, uint256 p3) internal view {
3368 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint256)", p0, p1, p2, p3));
3369 	}
3370 
3371 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3372 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3373 	}
3374 
3375 	function log(address p0, address p1, bool p2, bool p3) internal view {
3376 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3377 	}
3378 
3379 	function log(address p0, address p1, bool p2, address p3) internal view {
3380 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3381 	}
3382 
3383 	function log(address p0, address p1, address p2, uint256 p3) internal view {
3384 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint256)", p0, p1, p2, p3));
3385 	}
3386 
3387 	function log(address p0, address p1, address p2, string memory p3) internal view {
3388 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3389 	}
3390 
3391 	function log(address p0, address p1, address p2, bool p3) internal view {
3392 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3393 	}
3394 
3395 	function log(address p0, address p1, address p2, address p3) internal view {
3396 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3397 	}
3398 
3399 }
3400 
3401 // File: contracts/jajjjdjjdjjt.sol
3402 
3403 //SPDX-License-Identifier: Unlicense
3404 
3405 pragma solidity ^0.8.4;
3406 
3407 
3408 
3409 
3410 
3411 
3412 
3413 contract BabyPudgyPepes is ERC721A, Ownable, ReentrancyGuard {
3414     using Address for address;
3415     using Strings for uint;
3416 
3417     string  public baseTokenURI = "ipfs://bafybeif5bkkrbgkcr6cka5gcmxyu5cyvy5l7atxp5ajndynlyjivrbmy6q";
3418     uint256 public MAX_SUPPLY = 8888;
3419     uint256 public MAX_FREE_SUPPLY = 8888;
3420     uint256 public MAX_PER_TX = 10;
3421     uint256 public PRICE = 0.003 ether;
3422     uint256 public MAX_FREE_PER_WALLET = 2;
3423     uint256 public maxFreePerTx = 2;
3424     bool public initialize = true;
3425     bool public revealed = true;
3426 
3427     mapping(address => uint256) public qtyFreeMinted;
3428 
3429     constructor() ERC721A("BabyPudgyPepes", "BPP") {}
3430 
3431     function PublicMint(uint256 amount) external payable
3432     {
3433         uint256 cost = PRICE;
3434         uint256 num = amount > 0 ? amount : 1;
3435         bool free = ((totalSupply() + num < MAX_FREE_SUPPLY + 1) &&
3436             (qtyFreeMinted[msg.sender] + num <= MAX_FREE_PER_WALLET));
3437         if (free) {
3438             cost = 0;
3439             qtyFreeMinted[msg.sender] += num;
3440             require(num < maxFreePerTx + 1, "Max per TX reached.");
3441         } else {
3442             require(num < MAX_PER_TX + 1, "Max per TX reached.");
3443         }
3444 
3445         require(initialize, "Minting is not live yet.");
3446         require(msg.value >= num * cost, "Please send the exact amount.");
3447         require(totalSupply() + num < MAX_SUPPLY + 1, "No more");
3448 
3449         _safeMint(msg.sender, num);
3450     }
3451 
3452     function setBaseURI(string memory baseURI) public onlyOwner
3453     {
3454         baseTokenURI = baseURI;
3455     }
3456 
3457     function withdraw() public onlyOwner nonReentrant
3458     {
3459         Address.sendValue(payable(msg.sender), address(this).balance);
3460     }
3461 
3462     function tokenURI(uint _tokenId) public view virtual override returns (string memory)
3463     {
3464         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
3465 
3466         return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
3467     }
3468 
3469     function _baseURI() internal view virtual override returns (string memory)
3470     {
3471         return baseTokenURI;
3472     }
3473 
3474     function reveal(bool _revealed) external onlyOwner
3475     {
3476         revealed = _revealed;
3477     }
3478 
3479     function setInitialize(bool _initialize) external onlyOwner
3480     {
3481         initialize = _initialize;
3482     }
3483 
3484     function setPrice(uint256 _price) external onlyOwner
3485     {
3486         PRICE = _price;
3487     }
3488 
3489     function setMaxLimitPerTransaction(uint256 _limit) external onlyOwner
3490     {
3491         MAX_PER_TX = _limit;
3492     }
3493 
3494     function setLimitFreeMintPerWallet(uint256 _limit) external onlyOwner
3495     {
3496         MAX_FREE_PER_WALLET = _limit;
3497     }
3498 
3499     function setMaxFreeAmount(uint256 _amount) external onlyOwner
3500     {
3501         MAX_FREE_SUPPLY = _amount;
3502     }
3503 }