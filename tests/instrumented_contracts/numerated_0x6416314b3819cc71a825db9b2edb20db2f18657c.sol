1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16     uint8 private constant _ADDRESS_LENGTH = 20;
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 
74     /**
75      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
76      */
77     function toHexString(address addr) internal pure returns (string memory) {
78         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Address.sol
83 
84 
85 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
86 
87 pragma solidity ^0.8.1;
88 
89 /**
90  * @dev Collection of functions related to the address type
91  */
92 library Address {
93     /**
94      * @dev Returns true if `account` is a contract.
95      *
96      * [IMPORTANT]
97      * ====
98      * It is unsafe to assume that an address for which this function returns
99      * false is an externally-owned account (EOA) and not a contract.
100      *
101      * Among others, `isContract` will return false for the following
102      * types of addresses:
103      *
104      *  - an externally-owned account
105      *  - a contract in construction
106      *  - an address where a contract will be created
107      *  - an address where a contract lived, but was destroyed
108      * ====
109      *
110      * [IMPORTANT]
111      * ====
112      * You shouldn't rely on `isContract` to protect against flash loan attacks!
113      *
114      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
115      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
116      * constructor.
117      * ====
118      */
119     function isContract(address account) internal view returns (bool) {
120         // This method relies on extcodesize/address.code.length, which returns 0
121         // for contracts in construction, since the code is only stored at the end
122         // of the constructor execution.
123 
124         return account.code.length > 0;
125     }
126 
127     /**
128      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
129      * `recipient`, forwarding all available gas and reverting on errors.
130      *
131      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
132      * of certain opcodes, possibly making contracts go over the 2300 gas limit
133      * imposed by `transfer`, making them unable to receive funds via
134      * `transfer`. {sendValue} removes this limitation.
135      *
136      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
137      *
138      * IMPORTANT: because control is transferred to `recipient`, care must be
139      * taken to not create reentrancy vulnerabilities. Consider using
140      * {ReentrancyGuard} or the
141      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
142      */
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     /**
151      * @dev Performs a Solidity function call using a low level `call`. A
152      * plain `call` is an unsafe replacement for a function call: use this
153      * function instead.
154      *
155      * If `target` reverts with a revert reason, it is bubbled up by this
156      * function (like regular Solidity function calls).
157      *
158      * Returns the raw returned data. To convert to the expected return value,
159      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
160      *
161      * Requirements:
162      *
163      * - `target` must be a contract.
164      * - calling `target` with `data` must not revert.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
207      * with `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(address(this).balance >= value, "Address: insufficient balance for call");
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value: value}(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal view returns (bytes memory) {
245         require(isContract(target), "Address: static call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.staticcall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(isContract(target), "Address: delegate call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.delegatecall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
280      * revert reason using the provided one.
281      *
282      * _Available since v4.3._
283      */
284     function verifyCallResult(
285         bool success,
286         bytes memory returndata,
287         string memory errorMessage
288     ) internal pure returns (bytes memory) {
289         if (success) {
290             return returndata;
291         } else {
292             // Look for revert reason and bubble it up if present
293             if (returndata.length > 0) {
294                 // The easiest way to bubble the revert reason is using memory via assembly
295                 /// @solidity memory-safe-assembly
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Contract module that helps prevent reentrant calls to a function.
316  *
317  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
318  * available, which can be applied to functions to make sure there are no nested
319  * (reentrant) calls to them.
320  *
321  * Note that because there is a single `nonReentrant` guard, functions marked as
322  * `nonReentrant` may not call one another. This can be worked around by making
323  * those functions `private`, and then adding `external` `nonReentrant` entry
324  * points to them.
325  *
326  * TIP: If you would like to learn more about reentrancy and alternative ways
327  * to protect against it, check out our blog post
328  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
329  */
330 abstract contract ReentrancyGuard {
331     // Booleans are more expensive than uint256 or any type that takes up a full
332     // word because each write operation emits an extra SLOAD to first read the
333     // slot's contents, replace the bits taken up by the boolean, and then write
334     // back. This is the compiler's defense against contract upgrades and
335     // pointer aliasing, and it cannot be disabled.
336 
337     // The values being non-zero value makes deployment a bit more expensive,
338     // but in exchange the refund on every call to nonReentrant will be lower in
339     // amount. Since refunds are capped to a percentage of the total
340     // transaction's gas, it is best to keep them low in cases like this one, to
341     // increase the likelihood of the full refund coming into effect.
342     uint256 private constant _NOT_ENTERED = 1;
343     uint256 private constant _ENTERED = 2;
344 
345     uint256 private _status;
346 
347     constructor() {
348         _status = _NOT_ENTERED;
349     }
350 
351     /**
352      * @dev Prevents a contract from calling itself, directly or indirectly.
353      * Calling a `nonReentrant` function from another `nonReentrant`
354      * function is not supported. It is possible to prevent this from happening
355      * by making the `nonReentrant` function external, and making it call a
356      * `private` function that does the actual work.
357      */
358     modifier nonReentrant() {
359         // On the first call to nonReentrant, _notEntered will be true
360         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
361 
362         // Any calls to nonReentrant after this point will fail
363         _status = _ENTERED;
364 
365         _;
366 
367         // By storing the original value once again, a refund is triggered (see
368         // https://eips.ethereum.org/EIPS/eip-2200)
369         _status = _NOT_ENTERED;
370     }
371 }
372 
373 // File: @openzeppelin/contracts/utils/Context.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev Provides information about the current execution context, including the
382  * sender of the transaction and its data. While these are generally available
383  * via msg.sender and msg.data, they should not be accessed in such a direct
384  * manner, since when dealing with meta-transactions the account sending and
385  * paying for execution may not be the actual sender (as far as an application
386  * is concerned).
387  *
388  * This contract is only required for intermediate, library-like contracts.
389  */
390 abstract contract Context {
391     function _msgSender() internal view virtual returns (address) {
392         return msg.sender;
393     }
394 
395     function _msgData() internal view virtual returns (bytes calldata) {
396         return msg.data;
397     }
398 }
399 
400 // File: @openzeppelin/contracts/access/Ownable.sol
401 
402 
403 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 
408 /**
409  * @dev Contract module which provides a basic access control mechanism, where
410  * there is an account (an owner) that can be granted exclusive access to
411  * specific functions.
412  *
413  * By default, the owner account will be the one that deploys the contract. This
414  * can later be changed with {transferOwnership}.
415  *
416  * This module is used through inheritance. It will make available the modifier
417  * `onlyOwner`, which can be applied to your functions to restrict their use to
418  * the owner.
419  */
420 abstract contract Ownable is Context {
421     address private _owner;
422 
423     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
424 
425     /**
426      * @dev Initializes the contract setting the deployer as the initial owner.
427      */
428     constructor() {
429         _transferOwnership(_msgSender());
430     }
431 
432     /**
433      * @dev Throws if called by any account other than the owner.
434      */
435     modifier onlyOwner() {
436         _checkOwner();
437         _;
438     }
439 
440     /**
441      * @dev Returns the address of the current owner.
442      */
443     function owner() public view virtual returns (address) {
444         return _owner;
445     }
446 
447     /**
448      * @dev Throws if the sender is not the owner.
449      */
450     function _checkOwner() internal view virtual {
451         require(owner() == _msgSender(), "Ownable: caller is not the owner");
452     }
453 
454     /**
455      * @dev Leaves the contract without owner. It will not be possible to call
456      * `onlyOwner` functions anymore. Can only be called by the current owner.
457      *
458      * NOTE: Renouncing ownership will leave the contract without an owner,
459      * thereby removing any functionality that is only available to the owner.
460      */
461     function renounceOwnership() public virtual onlyOwner {
462         _transferOwnership(address(0));
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Can only be called by the current owner.
468      */
469     function transferOwnership(address newOwner) public virtual onlyOwner {
470         require(newOwner != address(0), "Ownable: new owner is the zero address");
471         _transferOwnership(newOwner);
472     }
473 
474     /**
475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
476      * Internal function without access restriction.
477      */
478     function _transferOwnership(address newOwner) internal virtual {
479         address oldOwner = _owner;
480         _owner = newOwner;
481         emit OwnershipTransferred(oldOwner, newOwner);
482     }
483 }
484 
485 // File: erc721a/contracts/IERC721A.sol
486 
487 
488 // ERC721A Contracts v4.2.0
489 // Creator: Chiru Labs
490 
491 pragma solidity ^0.8.4;
492 
493 /**
494  * @dev Interface of ERC721A.
495  */
496 interface IERC721A {
497     /**
498      * The caller must own the token or be an approved operator.
499      */
500     error ApprovalCallerNotOwnerNorApproved();
501 
502     /**
503      * The token does not exist.
504      */
505     error ApprovalQueryForNonexistentToken();
506 
507     /**
508      * The caller cannot approve to their own address.
509      */
510     error ApproveToCaller();
511 
512     /**
513      * Cannot query the balance for the zero address.
514      */
515     error BalanceQueryForZeroAddress();
516 
517     /**
518      * Cannot mint to the zero address.
519      */
520     error MintToZeroAddress();
521 
522     /**
523      * The quantity of tokens minted must be more than zero.
524      */
525     error MintZeroQuantity();
526 
527     /**
528      * The token does not exist.
529      */
530     error OwnerQueryForNonexistentToken();
531 
532     /**
533      * The caller must own the token or be an approved operator.
534      */
535     error TransferCallerNotOwnerNorApproved();
536 
537     /**
538      * The token must be owned by `from`.
539      */
540     error TransferFromIncorrectOwner();
541 
542     /**
543      * Cannot safely transfer to a contract that does not implement the
544      * ERC721Receiver interface.
545      */
546     error TransferToNonERC721ReceiverImplementer();
547 
548     /**
549      * Cannot transfer to the zero address.
550      */
551     error TransferToZeroAddress();
552 
553     /**
554      * The token does not exist.
555      */
556     error URIQueryForNonexistentToken();
557 
558     /**
559      * The `quantity` minted with ERC2309 exceeds the safety limit.
560      */
561     error MintERC2309QuantityExceedsLimit();
562 
563     /**
564      * The `extraData` cannot be set on an unintialized ownership slot.
565      */
566     error OwnershipNotInitializedForExtraData();
567 
568     // =============================================================
569     //                            STRUCTS
570     // =============================================================
571 
572     struct TokenOwnership {
573         // The address of the owner.
574         address addr;
575         // Stores the start time of ownership with minimal overhead for tokenomics.
576         uint64 startTimestamp;
577         // Whether the token has been burned.
578         bool burned;
579         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
580         uint24 extraData;
581     }
582 
583     // =============================================================
584     //                         TOKEN COUNTERS
585     // =============================================================
586 
587     /**
588      * @dev Returns the total number of tokens in existence.
589      * Burned tokens will reduce the count.
590      * To get the total number of tokens minted, please see {_totalMinted}.
591      */
592     function totalSupply() external view returns (uint256);
593 
594     // =============================================================
595     //                            IERC165
596     // =============================================================
597 
598     /**
599      * @dev Returns true if this contract implements the interface defined by
600      * `interfaceId`. See the corresponding
601      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
602      * to learn more about how these ids are created.
603      *
604      * This function call must use less than 30000 gas.
605      */
606     function supportsInterface(bytes4 interfaceId) external view returns (bool);
607 
608     // =============================================================
609     //                            IERC721
610     // =============================================================
611 
612     /**
613      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
614      */
615     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
616 
617     /**
618      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
619      */
620     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
621 
622     /**
623      * @dev Emitted when `owner` enables or disables
624      * (`approved`) `operator` to manage all of its assets.
625      */
626     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
627 
628     /**
629      * @dev Returns the number of tokens in `owner`'s account.
630      */
631     function balanceOf(address owner) external view returns (uint256 balance);
632 
633     /**
634      * @dev Returns the owner of the `tokenId` token.
635      *
636      * Requirements:
637      *
638      * - `tokenId` must exist.
639      */
640     function ownerOf(uint256 tokenId) external view returns (address owner);
641 
642     /**
643      * @dev Safely transfers `tokenId` token from `from` to `to`,
644      * checking first that contract recipients are aware of the ERC721 protocol
645      * to prevent tokens from being forever locked.
646      *
647      * Requirements:
648      *
649      * - `from` cannot be the zero address.
650      * - `to` cannot be the zero address.
651      * - `tokenId` token must exist and be owned by `from`.
652      * - If the caller is not `from`, it must be have been allowed to move
653      * this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement
655      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
656      *
657      * Emits a {Transfer} event.
658      */
659     function safeTransferFrom(
660         address from,
661         address to,
662         uint256 tokenId,
663         bytes calldata data
664     ) external;
665 
666     /**
667      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId
673     ) external;
674 
675     /**
676      * @dev Transfers `tokenId` from `from` to `to`.
677      *
678      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
679      * whenever possible.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token
687      * by either {approve} or {setApprovalForAll}.
688      *
689      * Emits a {Transfer} event.
690      */
691     function transferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) external;
696 
697     /**
698      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
699      * The approval is cleared when the token is transferred.
700      *
701      * Only a single account can be approved at a time, so approving the
702      * zero address clears previous approvals.
703      *
704      * Requirements:
705      *
706      * - The caller must own the token or be an approved operator.
707      * - `tokenId` must exist.
708      *
709      * Emits an {Approval} event.
710      */
711     function approve(address to, uint256 tokenId) external;
712 
713     /**
714      * @dev Approve or remove `operator` as an operator for the caller.
715      * Operators can call {transferFrom} or {safeTransferFrom}
716      * for any token owned by the caller.
717      *
718      * Requirements:
719      *
720      * - The `operator` cannot be the caller.
721      *
722      * Emits an {ApprovalForAll} event.
723      */
724     function setApprovalForAll(address operator, bool _approved) external;
725 
726     /**
727      * @dev Returns the account approved for `tokenId` token.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function getApproved(uint256 tokenId) external view returns (address operator);
734 
735     /**
736      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
737      *
738      * See {setApprovalForAll}.
739      */
740     function isApprovedForAll(address owner, address operator) external view returns (bool);
741 
742     // =============================================================
743     //                        IERC721Metadata
744     // =============================================================
745 
746     /**
747      * @dev Returns the token collection name.
748      */
749     function name() external view returns (string memory);
750 
751     /**
752      * @dev Returns the token collection symbol.
753      */
754     function symbol() external view returns (string memory);
755 
756     /**
757      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
758      */
759     function tokenURI(uint256 tokenId) external view returns (string memory);
760 
761     // =============================================================
762     //                           IERC2309
763     // =============================================================
764 
765     /**
766      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
767      * (inclusive) is transferred from `from` to `to`, as defined in the
768      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
769      *
770      * See {_mintERC2309} for more details.
771      */
772     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
773 }
774 
775 // File: erc721a/contracts/ERC721A.sol
776 
777 
778 // ERC721A Contracts v4.2.0
779 // Creator: Chiru Labs
780 
781 pragma solidity ^0.8.4;
782 
783 
784 /**
785  * @dev Interface of ERC721 token receiver.
786  */
787 interface ERC721A__IERC721Receiver {
788     function onERC721Received(
789         address operator,
790         address from,
791         uint256 tokenId,
792         bytes calldata data
793     ) external returns (bytes4);
794 }
795 
796 /**
797  * @title ERC721A
798  *
799  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
800  * Non-Fungible Token Standard, including the Metadata extension.
801  * Optimized for lower gas during batch mints.
802  *
803  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
804  * starting from `_startTokenId()`.
805  *
806  * Assumptions:
807  *
808  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
809  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
810  */
811 contract ERC721A is IERC721A {
812     // Reference type for token approval.
813     struct TokenApprovalRef {
814         address value;
815     }
816 
817     // =============================================================
818     //                           CONSTANTS
819     // =============================================================
820 
821     // Mask of an entry in packed address data.
822     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
823 
824     // The bit position of `numberMinted` in packed address data.
825     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
826 
827     // The bit position of `numberBurned` in packed address data.
828     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
829 
830     // The bit position of `aux` in packed address data.
831     uint256 private constant _BITPOS_AUX = 192;
832 
833     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
834     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
835 
836     // The bit position of `startTimestamp` in packed ownership.
837     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
838 
839     // The bit mask of the `burned` bit in packed ownership.
840     uint256 private constant _BITMASK_BURNED = 1 << 224;
841 
842     // The bit position of the `nextInitialized` bit in packed ownership.
843     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
844 
845     // The bit mask of the `nextInitialized` bit in packed ownership.
846     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
847 
848     // The bit position of `extraData` in packed ownership.
849     uint256 private constant _BITPOS_EXTRA_DATA = 232;
850 
851     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
852     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
853 
854     // The mask of the lower 160 bits for addresses.
855     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
856 
857     // The maximum `quantity` that can be minted with {_mintERC2309}.
858     // This limit is to prevent overflows on the address data entries.
859     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
860     // is required to cause an overflow, which is unrealistic.
861     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
862 
863     // The `Transfer` event signature is given by:
864     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
865     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
866         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
867 
868     // =============================================================
869     //                            STORAGE
870     // =============================================================
871 
872     // The next token ID to be minted.
873     uint256 private _currentIndex;
874 
875     // The number of tokens burned.
876     uint256 private _burnCounter;
877 
878     // Token name
879     string private _name;
880 
881     // Token symbol
882     string private _symbol;
883 
884     // Mapping from token ID to ownership details
885     // An empty struct value does not necessarily mean the token is unowned.
886     // See {_packedOwnershipOf} implementation for details.
887     //
888     // Bits Layout:
889     // - [0..159]   `addr`
890     // - [160..223] `startTimestamp`
891     // - [224]      `burned`
892     // - [225]      `nextInitialized`
893     // - [232..255] `extraData`
894     mapping(uint256 => uint256) private _packedOwnerships;
895 
896     // Mapping owner address to address data.
897     //
898     // Bits Layout:
899     // - [0..63]    `balance`
900     // - [64..127]  `numberMinted`
901     // - [128..191] `numberBurned`
902     // - [192..255] `aux`
903     mapping(address => uint256) private _packedAddressData;
904 
905     // Mapping from token ID to approved address.
906     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
907 
908     // Mapping from owner to operator approvals
909     mapping(address => mapping(address => bool)) private _operatorApprovals;
910 
911     // =============================================================
912     //                          CONSTRUCTOR
913     // =============================================================
914 
915     constructor(string memory name_, string memory symbol_) {
916         _name = name_;
917         _symbol = symbol_;
918         _currentIndex = _startTokenId();
919     }
920 
921     // =============================================================
922     //                   TOKEN COUNTING OPERATIONS
923     // =============================================================
924 
925     /**
926      * @dev Returns the starting token ID.
927      * To change the starting token ID, please override this function.
928      */
929     function _startTokenId() internal view virtual returns (uint256) {
930         return 0;
931     }
932 
933     /**
934      * @dev Returns the next token ID to be minted.
935      */
936     function _nextTokenId() internal view virtual returns (uint256) {
937         return _currentIndex;
938     }
939 
940     /**
941      * @dev Returns the total number of tokens in existence.
942      * Burned tokens will reduce the count.
943      * To get the total number of tokens minted, please see {_totalMinted}.
944      */
945     function totalSupply() public view virtual override returns (uint256) {
946         // Counter underflow is impossible as _burnCounter cannot be incremented
947         // more than `_currentIndex - _startTokenId()` times.
948         unchecked {
949             return _currentIndex - _burnCounter - _startTokenId();
950         }
951     }
952 
953     /**
954      * @dev Returns the total amount of tokens minted in the contract.
955      */
956     function _totalMinted() internal view virtual returns (uint256) {
957         // Counter underflow is impossible as `_currentIndex` does not decrement,
958         // and it is initialized to `_startTokenId()`.
959         unchecked {
960             return _currentIndex - _startTokenId();
961         }
962     }
963 
964     /**
965      * @dev Returns the total number of tokens burned.
966      */
967     function _totalBurned() internal view virtual returns (uint256) {
968         return _burnCounter;
969     }
970 
971     // =============================================================
972     //                    ADDRESS DATA OPERATIONS
973     // =============================================================
974 
975     /**
976      * @dev Returns the number of tokens in `owner`'s account.
977      */
978     function balanceOf(address owner) public view virtual override returns (uint256) {
979         if (owner == address(0)) revert BalanceQueryForZeroAddress();
980         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
981     }
982 
983     /**
984      * Returns the number of tokens minted by `owner`.
985      */
986     function _numberMinted(address owner) internal view returns (uint256) {
987         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
988     }
989 
990     /**
991      * Returns the number of tokens burned by or on behalf of `owner`.
992      */
993     function _numberBurned(address owner) internal view returns (uint256) {
994         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
995     }
996 
997     /**
998      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
999      */
1000     function _getAux(address owner) internal view returns (uint64) {
1001         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1002     }
1003 
1004     /**
1005      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1006      * If there are multiple variables, please pack them into a uint64.
1007      */
1008     function _setAux(address owner, uint64 aux) internal virtual {
1009         uint256 packed = _packedAddressData[owner];
1010         uint256 auxCasted;
1011         // Cast `aux` with assembly to avoid redundant masking.
1012         assembly {
1013             auxCasted := aux
1014         }
1015         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1016         _packedAddressData[owner] = packed;
1017     }
1018 
1019     // =============================================================
1020     //                            IERC165
1021     // =============================================================
1022 
1023     /**
1024      * @dev Returns true if this contract implements the interface defined by
1025      * `interfaceId`. See the corresponding
1026      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1027      * to learn more about how these ids are created.
1028      *
1029      * This function call must use less than 30000 gas.
1030      */
1031     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1032         // The interface IDs are constants representing the first 4 bytes
1033         // of the XOR of all function selectors in the interface.
1034         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1035         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1036         return
1037             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1038             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1039             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1040     }
1041 
1042     // =============================================================
1043     //                        IERC721Metadata
1044     // =============================================================
1045 
1046     /**
1047      * @dev Returns the token collection name.
1048      */
1049     function name() public view virtual override returns (string memory) {
1050         return _name;
1051     }
1052 
1053     /**
1054      * @dev Returns the token collection symbol.
1055      */
1056     function symbol() public view virtual override returns (string memory) {
1057         return _symbol;
1058     }
1059 
1060     /**
1061      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1062      */
1063     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1064         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1065 
1066         string memory baseURI = _baseURI();
1067         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1068     }
1069 
1070     /**
1071      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1072      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1073      * by default, it can be overridden in child contracts.
1074      */
1075     function _baseURI() internal view virtual returns (string memory) {
1076         return '';
1077     }
1078 
1079     // =============================================================
1080     //                     OWNERSHIPS OPERATIONS
1081     // =============================================================
1082 
1083     /**
1084      * @dev Returns the owner of the `tokenId` token.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      */
1090     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1091         return address(uint160(_packedOwnershipOf(tokenId)));
1092     }
1093 
1094     /**
1095      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1096      * It gradually moves to O(1) as tokens get transferred around over time.
1097      */
1098     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1099         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1100     }
1101 
1102     /**
1103      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1104      */
1105     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1106         return _unpackedOwnership(_packedOwnerships[index]);
1107     }
1108 
1109     /**
1110      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1111      */
1112     function _initializeOwnershipAt(uint256 index) internal virtual {
1113         if (_packedOwnerships[index] == 0) {
1114             _packedOwnerships[index] = _packedOwnershipOf(index);
1115         }
1116     }
1117 
1118     /**
1119      * Returns the packed ownership data of `tokenId`.
1120      */
1121     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1122         uint256 curr = tokenId;
1123 
1124         unchecked {
1125             if (_startTokenId() <= curr)
1126                 if (curr < _currentIndex) {
1127                     uint256 packed = _packedOwnerships[curr];
1128                     // If not burned.
1129                     if (packed & _BITMASK_BURNED == 0) {
1130                         // Invariant:
1131                         // There will always be an initialized ownership slot
1132                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1133                         // before an unintialized ownership slot
1134                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1135                         // Hence, `curr` will not underflow.
1136                         //
1137                         // We can directly compare the packed value.
1138                         // If the address is zero, packed will be zero.
1139                         while (packed == 0) {
1140                             packed = _packedOwnerships[--curr];
1141                         }
1142                         return packed;
1143                     }
1144                 }
1145         }
1146         revert OwnerQueryForNonexistentToken();
1147     }
1148 
1149     /**
1150      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1151      */
1152     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1153         ownership.addr = address(uint160(packed));
1154         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1155         ownership.burned = packed & _BITMASK_BURNED != 0;
1156         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1157     }
1158 
1159     /**
1160      * @dev Packs ownership data into a single uint256.
1161      */
1162     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1163         assembly {
1164             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1165             owner := and(owner, _BITMASK_ADDRESS)
1166             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1167             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1168         }
1169     }
1170 
1171     /**
1172      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1173      */
1174     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1175         // For branchless setting of the `nextInitialized` flag.
1176         assembly {
1177             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1178             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1179         }
1180     }
1181 
1182     // =============================================================
1183     //                      APPROVAL OPERATIONS
1184     // =============================================================
1185 
1186     /**
1187      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1188      * The approval is cleared when the token is transferred.
1189      *
1190      * Only a single account can be approved at a time, so approving the
1191      * zero address clears previous approvals.
1192      *
1193      * Requirements:
1194      *
1195      * - The caller must own the token or be an approved operator.
1196      * - `tokenId` must exist.
1197      *
1198      * Emits an {Approval} event.
1199      */
1200     function approve(address to, uint256 tokenId) public virtual override {
1201         address owner = ownerOf(tokenId);
1202 
1203         if (_msgSenderERC721A() != owner)
1204             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1205                 revert ApprovalCallerNotOwnerNorApproved();
1206             }
1207 
1208         _tokenApprovals[tokenId].value = to;
1209         emit Approval(owner, to, tokenId);
1210     }
1211 
1212     /**
1213      * @dev Returns the account approved for `tokenId` token.
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must exist.
1218      */
1219     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1220         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1221 
1222         return _tokenApprovals[tokenId].value;
1223     }
1224 
1225     /**
1226      * @dev Approve or remove `operator` as an operator for the caller.
1227      * Operators can call {transferFrom} or {safeTransferFrom}
1228      * for any token owned by the caller.
1229      *
1230      * Requirements:
1231      *
1232      * - The `operator` cannot be the caller.
1233      *
1234      * Emits an {ApprovalForAll} event.
1235      */
1236     function setApprovalForAll(address operator, bool approved) public virtual override {
1237         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1238 
1239         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1240         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1241     }
1242 
1243     /**
1244      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1245      *
1246      * See {setApprovalForAll}.
1247      */
1248     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1249         return _operatorApprovals[owner][operator];
1250     }
1251 
1252     /**
1253      * @dev Returns whether `tokenId` exists.
1254      *
1255      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1256      *
1257      * Tokens start existing when they are minted. See {_mint}.
1258      */
1259     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1260         return
1261             _startTokenId() <= tokenId &&
1262             tokenId < _currentIndex && // If within bounds,
1263             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1264     }
1265 
1266     /**
1267      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1268      */
1269     function _isSenderApprovedOrOwner(
1270         address approvedAddress,
1271         address owner,
1272         address msgSender
1273     ) private pure returns (bool result) {
1274         assembly {
1275             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1276             owner := and(owner, _BITMASK_ADDRESS)
1277             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1278             msgSender := and(msgSender, _BITMASK_ADDRESS)
1279             // `msgSender == owner || msgSender == approvedAddress`.
1280             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1281         }
1282     }
1283 
1284     /**
1285      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1286      */
1287     function _getApprovedSlotAndAddress(uint256 tokenId)
1288         private
1289         view
1290         returns (uint256 approvedAddressSlot, address approvedAddress)
1291     {
1292         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1293         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1294         assembly {
1295             approvedAddressSlot := tokenApproval.slot
1296             approvedAddress := sload(approvedAddressSlot)
1297         }
1298     }
1299 
1300     // =============================================================
1301     //                      TRANSFER OPERATIONS
1302     // =============================================================
1303 
1304     /**
1305      * @dev Transfers `tokenId` from `from` to `to`.
1306      *
1307      * Requirements:
1308      *
1309      * - `from` cannot be the zero address.
1310      * - `to` cannot be the zero address.
1311      * - `tokenId` token must be owned by `from`.
1312      * - If the caller is not `from`, it must be approved to move this token
1313      * by either {approve} or {setApprovalForAll}.
1314      *
1315      * Emits a {Transfer} event.
1316      */
1317     function transferFrom(
1318         address from,
1319         address to,
1320         uint256 tokenId
1321     ) public virtual override {
1322         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1323 
1324         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1325 
1326         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1327 
1328         // The nested ifs save around 20+ gas over a compound boolean condition.
1329         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1330             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1331 
1332         if (to == address(0)) revert TransferToZeroAddress();
1333 
1334         _beforeTokenTransfers(from, to, tokenId, 1);
1335 
1336         // Clear approvals from the previous owner.
1337         assembly {
1338             if approvedAddress {
1339                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1340                 sstore(approvedAddressSlot, 0)
1341             }
1342         }
1343 
1344         // Underflow of the sender's balance is impossible because we check for
1345         // ownership above and the recipient's balance can't realistically overflow.
1346         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1347         unchecked {
1348             // We can directly increment and decrement the balances.
1349             --_packedAddressData[from]; // Updates: `balance -= 1`.
1350             ++_packedAddressData[to]; // Updates: `balance += 1`.
1351 
1352             // Updates:
1353             // - `address` to the next owner.
1354             // - `startTimestamp` to the timestamp of transfering.
1355             // - `burned` to `false`.
1356             // - `nextInitialized` to `true`.
1357             _packedOwnerships[tokenId] = _packOwnershipData(
1358                 to,
1359                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1360             );
1361 
1362             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1363             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1364                 uint256 nextTokenId = tokenId + 1;
1365                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1366                 if (_packedOwnerships[nextTokenId] == 0) {
1367                     // If the next slot is within bounds.
1368                     if (nextTokenId != _currentIndex) {
1369                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1370                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1371                     }
1372                 }
1373             }
1374         }
1375 
1376         emit Transfer(from, to, tokenId);
1377         _afterTokenTransfers(from, to, tokenId, 1);
1378     }
1379 
1380     /**
1381      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1382      */
1383     function safeTransferFrom(
1384         address from,
1385         address to,
1386         uint256 tokenId
1387     ) public virtual override {
1388         safeTransferFrom(from, to, tokenId, '');
1389     }
1390 
1391     /**
1392      * @dev Safely transfers `tokenId` token from `from` to `to`.
1393      *
1394      * Requirements:
1395      *
1396      * - `from` cannot be the zero address.
1397      * - `to` cannot be the zero address.
1398      * - `tokenId` token must exist and be owned by `from`.
1399      * - If the caller is not `from`, it must be approved to move this token
1400      * by either {approve} or {setApprovalForAll}.
1401      * - If `to` refers to a smart contract, it must implement
1402      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1403      *
1404      * Emits a {Transfer} event.
1405      */
1406     function safeTransferFrom(
1407         address from,
1408         address to,
1409         uint256 tokenId,
1410         bytes memory _data
1411     ) public virtual override {
1412         transferFrom(from, to, tokenId);
1413         if (to.code.length != 0)
1414             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1415                 revert TransferToNonERC721ReceiverImplementer();
1416             }
1417     }
1418 
1419     /**
1420      * @dev Hook that is called before a set of serially-ordered token IDs
1421      * are about to be transferred. This includes minting.
1422      * And also called before burning one token.
1423      *
1424      * `startTokenId` - the first token ID to be transferred.
1425      * `quantity` - the amount to be transferred.
1426      *
1427      * Calling conditions:
1428      *
1429      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1430      * transferred to `to`.
1431      * - When `from` is zero, `tokenId` will be minted for `to`.
1432      * - When `to` is zero, `tokenId` will be burned by `from`.
1433      * - `from` and `to` are never both zero.
1434      */
1435     function _beforeTokenTransfers(
1436         address from,
1437         address to,
1438         uint256 startTokenId,
1439         uint256 quantity
1440     ) internal virtual {}
1441 
1442     /**
1443      * @dev Hook that is called after a set of serially-ordered token IDs
1444      * have been transferred. This includes minting.
1445      * And also called after one token has been burned.
1446      *
1447      * `startTokenId` - the first token ID to be transferred.
1448      * `quantity` - the amount to be transferred.
1449      *
1450      * Calling conditions:
1451      *
1452      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1453      * transferred to `to`.
1454      * - When `from` is zero, `tokenId` has been minted for `to`.
1455      * - When `to` is zero, `tokenId` has been burned by `from`.
1456      * - `from` and `to` are never both zero.
1457      */
1458     function _afterTokenTransfers(
1459         address from,
1460         address to,
1461         uint256 startTokenId,
1462         uint256 quantity
1463     ) internal virtual {}
1464 
1465     /**
1466      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1467      *
1468      * `from` - Previous owner of the given token ID.
1469      * `to` - Target address that will receive the token.
1470      * `tokenId` - Token ID to be transferred.
1471      * `_data` - Optional data to send along with the call.
1472      *
1473      * Returns whether the call correctly returned the expected magic value.
1474      */
1475     function _checkContractOnERC721Received(
1476         address from,
1477         address to,
1478         uint256 tokenId,
1479         bytes memory _data
1480     ) private returns (bool) {
1481         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1482             bytes4 retval
1483         ) {
1484             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1485         } catch (bytes memory reason) {
1486             if (reason.length == 0) {
1487                 revert TransferToNonERC721ReceiverImplementer();
1488             } else {
1489                 assembly {
1490                     revert(add(32, reason), mload(reason))
1491                 }
1492             }
1493         }
1494     }
1495 
1496     // =============================================================
1497     //                        MINT OPERATIONS
1498     // =============================================================
1499 
1500     /**
1501      * @dev Mints `quantity` tokens and transfers them to `to`.
1502      *
1503      * Requirements:
1504      *
1505      * - `to` cannot be the zero address.
1506      * - `quantity` must be greater than 0.
1507      *
1508      * Emits a {Transfer} event for each mint.
1509      */
1510     function _mint(address to, uint256 quantity) internal virtual {
1511         uint256 startTokenId = _currentIndex;
1512         if (quantity == 0) revert MintZeroQuantity();
1513 
1514         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1515 
1516         // Overflows are incredibly unrealistic.
1517         // `balance` and `numberMinted` have a maximum limit of 2**64.
1518         // `tokenId` has a maximum limit of 2**256.
1519         unchecked {
1520             // Updates:
1521             // - `balance += quantity`.
1522             // - `numberMinted += quantity`.
1523             //
1524             // We can directly add to the `balance` and `numberMinted`.
1525             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1526 
1527             // Updates:
1528             // - `address` to the owner.
1529             // - `startTimestamp` to the timestamp of minting.
1530             // - `burned` to `false`.
1531             // - `nextInitialized` to `quantity == 1`.
1532             _packedOwnerships[startTokenId] = _packOwnershipData(
1533                 to,
1534                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1535             );
1536 
1537             uint256 toMasked;
1538             uint256 end = startTokenId + quantity;
1539 
1540             // Use assembly to loop and emit the `Transfer` event for gas savings.
1541             assembly {
1542                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1543                 toMasked := and(to, _BITMASK_ADDRESS)
1544                 // Emit the `Transfer` event.
1545                 log4(
1546                     0, // Start of data (0, since no data).
1547                     0, // End of data (0, since no data).
1548                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1549                     0, // `address(0)`.
1550                     toMasked, // `to`.
1551                     startTokenId // `tokenId`.
1552                 )
1553 
1554                 for {
1555                     let tokenId := add(startTokenId, 1)
1556                 } iszero(eq(tokenId, end)) {
1557                     tokenId := add(tokenId, 1)
1558                 } {
1559                     // Emit the `Transfer` event. Similar to above.
1560                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1561                 }
1562             }
1563             if (toMasked == 0) revert MintToZeroAddress();
1564 
1565             _currentIndex = end;
1566         }
1567         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1568     }
1569 
1570     /**
1571      * @dev Mints `quantity` tokens and transfers them to `to`.
1572      *
1573      * This function is intended for efficient minting only during contract creation.
1574      *
1575      * It emits only one {ConsecutiveTransfer} as defined in
1576      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1577      * instead of a sequence of {Transfer} event(s).
1578      *
1579      * Calling this function outside of contract creation WILL make your contract
1580      * non-compliant with the ERC721 standard.
1581      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1582      * {ConsecutiveTransfer} event is only permissible during contract creation.
1583      *
1584      * Requirements:
1585      *
1586      * - `to` cannot be the zero address.
1587      * - `quantity` must be greater than 0.
1588      *
1589      * Emits a {ConsecutiveTransfer} event.
1590      */
1591     function _mintERC2309(address to, uint256 quantity) internal virtual {
1592         uint256 startTokenId = _currentIndex;
1593         if (to == address(0)) revert MintToZeroAddress();
1594         if (quantity == 0) revert MintZeroQuantity();
1595         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1596 
1597         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1598 
1599         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1600         unchecked {
1601             // Updates:
1602             // - `balance += quantity`.
1603             // - `numberMinted += quantity`.
1604             //
1605             // We can directly add to the `balance` and `numberMinted`.
1606             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1607 
1608             // Updates:
1609             // - `address` to the owner.
1610             // - `startTimestamp` to the timestamp of minting.
1611             // - `burned` to `false`.
1612             // - `nextInitialized` to `quantity == 1`.
1613             _packedOwnerships[startTokenId] = _packOwnershipData(
1614                 to,
1615                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1616             );
1617 
1618             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1619 
1620             _currentIndex = startTokenId + quantity;
1621         }
1622         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1623     }
1624 
1625     /**
1626      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1627      *
1628      * Requirements:
1629      *
1630      * - If `to` refers to a smart contract, it must implement
1631      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1632      * - `quantity` must be greater than 0.
1633      *
1634      * See {_mint}.
1635      *
1636      * Emits a {Transfer} event for each mint.
1637      */
1638     function _safeMint(
1639         address to,
1640         uint256 quantity,
1641         bytes memory _data
1642     ) internal virtual {
1643         _mint(to, quantity);
1644 
1645         unchecked {
1646             if (to.code.length != 0) {
1647                 uint256 end = _currentIndex;
1648                 uint256 index = end - quantity;
1649                 do {
1650                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1651                         revert TransferToNonERC721ReceiverImplementer();
1652                     }
1653                 } while (index < end);
1654                 // Reentrancy protection.
1655                 if (_currentIndex != end) revert();
1656             }
1657         }
1658     }
1659 
1660     /**
1661      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1662      */
1663     function _safeMint(address to, uint256 quantity) internal virtual {
1664         _safeMint(to, quantity, '');
1665     }
1666 
1667     // =============================================================
1668     //                        BURN OPERATIONS
1669     // =============================================================
1670 
1671     /**
1672      * @dev Equivalent to `_burn(tokenId, false)`.
1673      */
1674     function _burn(uint256 tokenId) internal virtual {
1675         _burn(tokenId, false);
1676     }
1677 
1678     /**
1679      * @dev Destroys `tokenId`.
1680      * The approval is cleared when the token is burned.
1681      *
1682      * Requirements:
1683      *
1684      * - `tokenId` must exist.
1685      *
1686      * Emits a {Transfer} event.
1687      */
1688     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1689         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1690 
1691         address from = address(uint160(prevOwnershipPacked));
1692 
1693         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1694 
1695         if (approvalCheck) {
1696             // The nested ifs save around 20+ gas over a compound boolean condition.
1697             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1698                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1699         }
1700 
1701         _beforeTokenTransfers(from, address(0), tokenId, 1);
1702 
1703         // Clear approvals from the previous owner.
1704         assembly {
1705             if approvedAddress {
1706                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1707                 sstore(approvedAddressSlot, 0)
1708             }
1709         }
1710 
1711         // Underflow of the sender's balance is impossible because we check for
1712         // ownership above and the recipient's balance can't realistically overflow.
1713         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1714         unchecked {
1715             // Updates:
1716             // - `balance -= 1`.
1717             // - `numberBurned += 1`.
1718             //
1719             // We can directly decrement the balance, and increment the number burned.
1720             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1721             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1722 
1723             // Updates:
1724             // - `address` to the last owner.
1725             // - `startTimestamp` to the timestamp of burning.
1726             // - `burned` to `true`.
1727             // - `nextInitialized` to `true`.
1728             _packedOwnerships[tokenId] = _packOwnershipData(
1729                 from,
1730                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1731             );
1732 
1733             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1734             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1735                 uint256 nextTokenId = tokenId + 1;
1736                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1737                 if (_packedOwnerships[nextTokenId] == 0) {
1738                     // If the next slot is within bounds.
1739                     if (nextTokenId != _currentIndex) {
1740                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1741                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1742                     }
1743                 }
1744             }
1745         }
1746 
1747         emit Transfer(from, address(0), tokenId);
1748         _afterTokenTransfers(from, address(0), tokenId, 1);
1749 
1750         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1751         unchecked {
1752             _burnCounter++;
1753         }
1754     }
1755 
1756     // =============================================================
1757     //                     EXTRA DATA OPERATIONS
1758     // =============================================================
1759 
1760     /**
1761      * @dev Directly sets the extra data for the ownership data `index`.
1762      */
1763     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1764         uint256 packed = _packedOwnerships[index];
1765         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1766         uint256 extraDataCasted;
1767         // Cast `extraData` with assembly to avoid redundant masking.
1768         assembly {
1769             extraDataCasted := extraData
1770         }
1771         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1772         _packedOwnerships[index] = packed;
1773     }
1774 
1775     /**
1776      * @dev Called during each token transfer to set the 24bit `extraData` field.
1777      * Intended to be overridden by the cosumer contract.
1778      *
1779      * `previousExtraData` - the value of `extraData` before transfer.
1780      *
1781      * Calling conditions:
1782      *
1783      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1784      * transferred to `to`.
1785      * - When `from` is zero, `tokenId` will be minted for `to`.
1786      * - When `to` is zero, `tokenId` will be burned by `from`.
1787      * - `from` and `to` are never both zero.
1788      */
1789     function _extraData(
1790         address from,
1791         address to,
1792         uint24 previousExtraData
1793     ) internal view virtual returns (uint24) {}
1794 
1795     /**
1796      * @dev Returns the next extra data for the packed ownership data.
1797      * The returned result is shifted into position.
1798      */
1799     function _nextExtraData(
1800         address from,
1801         address to,
1802         uint256 prevOwnershipPacked
1803     ) private view returns (uint256) {
1804         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1805         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1806     }
1807 
1808     // =============================================================
1809     //                       OTHER OPERATIONS
1810     // =============================================================
1811 
1812     /**
1813      * @dev Returns the message sender (defaults to `msg.sender`).
1814      *
1815      * If you are writing GSN compatible contracts, you need to override this function.
1816      */
1817     function _msgSenderERC721A() internal view virtual returns (address) {
1818         return msg.sender;
1819     }
1820 
1821     /**
1822      * @dev Converts a uint256 to its ASCII string decimal representation.
1823      */
1824     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1825         assembly {
1826             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1827             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1828             // We will need 1 32-byte word to store the length,
1829             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1830             ptr := add(mload(0x40), 128)
1831             // Update the free memory pointer to allocate.
1832             mstore(0x40, ptr)
1833 
1834             // Cache the end of the memory to calculate the length later.
1835             let end := ptr
1836 
1837             // We write the string from the rightmost digit to the leftmost digit.
1838             // The following is essentially a do-while loop that also handles the zero case.
1839             // Costs a bit more than early returning for the zero case,
1840             // but cheaper in terms of deployment and overall runtime costs.
1841             for {
1842                 // Initialize and perform the first pass without check.
1843                 let temp := value
1844                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1845                 ptr := sub(ptr, 1)
1846                 // Write the character to the pointer.
1847                 // The ASCII index of the '0' character is 48.
1848                 mstore8(ptr, add(48, mod(temp, 10)))
1849                 temp := div(temp, 10)
1850             } temp {
1851                 // Keep dividing `temp` until zero.
1852                 temp := div(temp, 10)
1853             } {
1854                 // Body of the for loop.
1855                 ptr := sub(ptr, 1)
1856                 mstore8(ptr, add(48, mod(temp, 10)))
1857             }
1858 
1859             let length := sub(end, ptr)
1860             // Move the pointer 32 bytes leftwards to make room for the length.
1861             ptr := sub(ptr, 32)
1862             // Store the length.
1863             mstore(ptr, length)
1864         }
1865     }
1866 }
1867 
1868 // File: contracts/avacadoez.sol
1869 
1870 
1871 
1872 pragma solidity ^0.8.0;
1873 
1874 
1875 
1876 
1877 
1878 
1879 contract Avacadoez is ERC721A, Ownable, ReentrancyGuard {
1880   using Address for address;
1881   using Strings for uint;
1882   bool public revealed = false;
1883   bool public paused = false;
1884   
1885 
1886   string private revealedURI = "ipfs://QmSzJCfAgzBzFek61MtGHLEK3TuFmRU5XzKiA8RZDoap7n/";
1887 
1888   string private hiddenURI = "ipfs://QmTvKx87xe31PhYy18ZehVCAqh1cE6EMHNk4W3zeQPdBvV/hidden.json";
1889 
1890   uint256 public  maxSupply = 7777;
1891   uint256 public  Max_Guac_Per_Tx = 3;
1892   uint256 public  Free_Guac_Per_Tx = 1;
1893   uint256 public  Public_Guac_Price = 0.0069 ether;
1894   uint256 public  Toatl_Free_Guac = 3000;
1895   bool public isPublicSaleActive = false;
1896   
1897 
1898   constructor() ERC721A("Avacadoez", "AVCDO") {
1899 
1900   }
1901 
1902   function mint(uint256 numberOfTokens)
1903       external
1904       payable
1905   {
1906     require(isPublicSaleActive, "Public sale is not open");
1907     require(
1908       totalSupply() + numberOfTokens <= maxSupply,
1909       "Maximum supply exceeded"
1910     );
1911     if(totalSupply() + numberOfTokens > Toatl_Free_Guac || numberOfTokens > Free_Guac_Per_Tx){
1912         require(
1913             (Public_Guac_Price * numberOfTokens) <= msg.value,
1914             "Incorrect ETH value sent"
1915         );
1916     }
1917     _safeMint(msg.sender, numberOfTokens);
1918   }
1919   
1920 
1921   function _startTokenId() internal view virtual override returns (uint256) {
1922         return 1;
1923     }
1924 
1925   function treasuryMint(uint quantity, address user)
1926     public
1927     onlyOwner
1928   {
1929     require(
1930       quantity > 0,
1931       "Invalid mint amount"
1932     );
1933     require(
1934       totalSupply() + quantity <= maxSupply,
1935       "Maximum supply exceeded"
1936     );
1937     _safeMint(user, quantity);
1938   }
1939 
1940   function withdraw()
1941     public
1942     onlyOwner
1943     nonReentrant
1944   {
1945     Address.sendValue(payable(msg.sender), address(this).balance);
1946   }
1947 
1948   function setIsPublicSaleActive(bool _isPublicSaleActive)
1949       external
1950       onlyOwner
1951   {
1952       isPublicSaleActive = _isPublicSaleActive;
1953   }
1954 
1955   function setNumFreeMints(uint256 _numfreemints)
1956       external
1957       onlyOwner
1958   {
1959       Toatl_Free_Guac = _numfreemints;
1960   }
1961 
1962   function setSalePrice(uint256 _price)
1963       external
1964       onlyOwner
1965   {
1966       Public_Guac_Price = _price;
1967   }
1968 
1969   function setMaxLimitPerTransaction(uint256 _limit)
1970       external
1971       onlyOwner
1972   {
1973       Max_Guac_Per_Tx = _limit;
1974   }
1975   
1976   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1977         // Note: You don't REALLY need this require statement since nothing should be querying for non-existing tokens after reveal.
1978             // That said, it's a public view method so gas efficiency shouldn't come into play.
1979         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1980         
1981         if (revealed) {
1982             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
1983         }
1984         else {
1985             return hiddenURI;
1986         }
1987     }
1988   
1989   function revealCollection(bool _revealed, string memory _baseUri) public onlyOwner {
1990         revealed = _revealed;
1991         revealedURI = _baseUri;
1992     }
1993 
1994     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1995         hiddenURI = _hiddenMetadataUri;
1996     }
1997 
1998   function setRevealed(bool _state) public onlyOwner {
1999         revealed = _state;
2000     }
2001   function setBaseURI(string memory _baseUri) public onlyOwner {
2002         revealedURI = _baseUri;
2003     }
2004   
2005 
2006 }