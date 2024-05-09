1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15     uint8 private constant _ADDRESS_LENGTH = 20;
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
75      */
76     function toHexString(address addr) internal pure returns (string memory) {
77         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Address.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
85 
86 pragma solidity ^0.8.1;
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      *
109      * [IMPORTANT]
110      * ====
111      * You shouldn't rely on `isContract` to protect against flash loan attacks!
112      *
113      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
114      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
115      * constructor.
116      * ====
117      */
118     function isContract(address account) internal view returns (bool) {
119         // This method relies on extcodesize/address.code.length, which returns 0
120         // for contracts in construction, since the code is only stored at the end
121         // of the constructor execution.
122 
123         return account.code.length > 0;
124     }
125 
126     /**
127      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
128      * `recipient`, forwarding all available gas and reverting on errors.
129      *
130      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
131      * of certain opcodes, possibly making contracts go over the 2300 gas limit
132      * imposed by `transfer`, making them unable to receive funds via
133      * `transfer`. {sendValue} removes this limitation.
134      *
135      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
136      *
137      * IMPORTANT: because control is transferred to `recipient`, care must be
138      * taken to not create reentrancy vulnerabilities. Consider using
139      * {ReentrancyGuard} or the
140      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
141      */
142     function sendValue(address payable recipient, uint256 amount) internal {
143         require(address(this).balance >= amount, "Address: insufficient balance");
144 
145         (bool success, ) = recipient.call{value: amount}("");
146         require(success, "Address: unable to send value, recipient may have reverted");
147     }
148 
149     /**
150      * @dev Performs a Solidity function call using a low level `call`. A
151      * plain `call` is an unsafe replacement for a function call: use this
152      * function instead.
153      *
154      * If `target` reverts with a revert reason, it is bubbled up by this
155      * function (like regular Solidity function calls).
156      *
157      * Returns the raw returned data. To convert to the expected return value,
158      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
159      *
160      * Requirements:
161      *
162      * - `target` must be a contract.
163      * - calling `target` with `data` must not revert.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168         return functionCall(target, data, "Address: low-level call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
173      * `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, 0, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187      * but also transferring `value` wei to `target`.
188      *
189      * Requirements:
190      *
191      * - the calling contract must have an ETH balance of at least `value`.
192      * - the called Solidity function must be `payable`.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206      * with `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(address(this).balance >= value, "Address: insufficient balance for call");
217         require(isContract(target), "Address: call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.call{value: value}(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
230         return functionStaticCall(target, data, "Address: low-level static call failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal view returns (bytes memory) {
244         require(isContract(target), "Address: static call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.staticcall(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         require(isContract(target), "Address: delegate call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.delegatecall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
279      * revert reason using the provided one.
280      *
281      * _Available since v4.3._
282      */
283     function verifyCallResult(
284         bool success,
285         bytes memory returndata,
286         string memory errorMessage
287     ) internal pure returns (bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294                 /// @solidity memory-safe-assembly
295                 assembly {
296                     let returndata_size := mload(returndata)
297                     revert(add(32, returndata), returndata_size)
298                 }
299             } else {
300                 revert(errorMessage);
301             }
302         }
303     }
304 }
305 
306 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Contract module that helps prevent reentrant calls to a function.
315  *
316  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
317  * available, which can be applied to functions to make sure there are no nested
318  * (reentrant) calls to them.
319  *
320  * Note that because there is a single `nonReentrant` guard, functions marked as
321  * `nonReentrant` may not call one another. This can be worked around by making
322  * those functions `private`, and then adding `external` `nonReentrant` entry
323  * points to them.
324  *
325  * TIP: If you would like to learn more about reentrancy and alternative ways
326  * to protect against it, check out our blog post
327  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
328  */
329 abstract contract ReentrancyGuard {
330     // Booleans are more expensive than uint256 or any type that takes up a full
331     // word because each write operation emits an extra SLOAD to first read the
332     // slot's contents, replace the bits taken up by the boolean, and then write
333     // back. This is the compiler's defense against contract upgrades and
334     // pointer aliasing, and it cannot be disabled.
335 
336     // The values being non-zero value makes deployment a bit more expensive,
337     // but in exchange the refund on every call to nonReentrant will be lower in
338     // amount. Since refunds are capped to a percentage of the total
339     // transaction's gas, it is best to keep them low in cases like this one, to
340     // increase the likelihood of the full refund coming into effect.
341     uint256 private constant _NOT_ENTERED = 1;
342     uint256 private constant _ENTERED = 2;
343 
344     uint256 private _status;
345 
346     constructor() {
347         _status = _NOT_ENTERED;
348     }
349 
350     /**
351      * @dev Prevents a contract from calling itself, directly or indirectly.
352      * Calling a `nonReentrant` function from another `nonReentrant`
353      * function is not supported. It is possible to prevent this from happening
354      * by making the `nonReentrant` function external, and making it call a
355      * `private` function that does the actual work.
356      */
357     modifier nonReentrant() {
358         // On the first call to nonReentrant, _notEntered will be true
359         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
360 
361         // Any calls to nonReentrant after this point will fail
362         _status = _ENTERED;
363 
364         _;
365 
366         // By storing the original value once again, a refund is triggered (see
367         // https://eips.ethereum.org/EIPS/eip-2200)
368         _status = _NOT_ENTERED;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/utils/Context.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Provides information about the current execution context, including the
381  * sender of the transaction and its data. While these are generally available
382  * via msg.sender and msg.data, they should not be accessed in such a direct
383  * manner, since when dealing with meta-transactions the account sending and
384  * paying for execution may not be the actual sender (as far as an application
385  * is concerned).
386  *
387  * This contract is only required for intermediate, library-like contracts.
388  */
389 abstract contract Context {
390     function _msgSender() internal view virtual returns (address) {
391         return msg.sender;
392     }
393 
394     function _msgData() internal view virtual returns (bytes calldata) {
395         return msg.data;
396     }
397 }
398 
399 // File: @openzeppelin/contracts/access/Ownable.sol
400 
401 
402 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 
407 /**
408  * @dev Contract module which provides a basic access control mechanism, where
409  * there is an account (an owner) that can be granted exclusive access to
410  * specific functions.
411  *
412  * By default, the owner account will be the one that deploys the contract. This
413  * can later be changed with {transferOwnership}.
414  *
415  * This module is used through inheritance. It will make available the modifier
416  * `onlyOwner`, which can be applied to your functions to restrict their use to
417  * the owner.
418  */
419 abstract contract Ownable is Context {
420     address private _owner;
421 
422     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
423 
424     /**
425      * @dev Initializes the contract setting the deployer as the initial owner.
426      */
427     constructor() {
428         _transferOwnership(_msgSender());
429     }
430 
431     /**
432      * @dev Throws if called by any account other than the owner.
433      */
434     modifier onlyOwner() {
435         _checkOwner();
436         _;
437     }
438 
439     /**
440      * @dev Returns the address of the current owner.
441      */
442     function owner() public view virtual returns (address) {
443         return _owner;
444     }
445 
446     /**
447      * @dev Throws if the sender is not the owner.
448      */
449     function _checkOwner() internal view virtual {
450         require(owner() == _msgSender(), "Ownable: caller is not the owner");
451     }
452 
453     /**
454      * @dev Leaves the contract without owner. It will not be possible to call
455      * `onlyOwner` functions anymore. Can only be called by the current owner.
456      *
457      * NOTE: Renouncing ownership will leave the contract without an owner,
458      * thereby removing any functionality that is only available to the owner.
459      */
460     function renounceOwnership() public virtual onlyOwner {
461         _transferOwnership(address(0));
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public virtual onlyOwner {
469         require(newOwner != address(0), "Ownable: new owner is the zero address");
470         _transferOwnership(newOwner);
471     }
472 
473     /**
474      * @dev Transfers ownership of the contract to a new account (`newOwner`).
475      * Internal function without access restriction.
476      */
477     function _transferOwnership(address newOwner) internal virtual {
478         address oldOwner = _owner;
479         _owner = newOwner;
480         emit OwnershipTransferred(oldOwner, newOwner);
481     }
482 }
483 
484 // File: erc721a/contracts/IERC721A.sol
485 
486 
487 // ERC721A Contracts v4.2.2
488 // Creator: Chiru Labs
489 
490 pragma solidity ^0.8.4;
491 
492 /**
493  * @dev Interface of ERC721A.
494  */
495 interface IERC721A {
496     /**
497      * The caller must own the token or be an approved operator.
498      */
499     error ApprovalCallerNotOwnerNorApproved();
500 
501     /**
502      * The token does not exist.
503      */
504     error ApprovalQueryForNonexistentToken();
505 
506     /**
507      * The caller cannot approve to their own address.
508      */
509     error ApproveToCaller();
510 
511     /**
512      * Cannot query the balance for the zero address.
513      */
514     error BalanceQueryForZeroAddress();
515 
516     /**
517      * Cannot mint to the zero address.
518      */
519     error MintToZeroAddress();
520 
521     /**
522      * The quantity of tokens minted must be more than zero.
523      */
524     error MintZeroQuantity();
525 
526     /**
527      * The token does not exist.
528      */
529     error OwnerQueryForNonexistentToken();
530 
531     /**
532      * The caller must own the token or be an approved operator.
533      */
534     error TransferCallerNotOwnerNorApproved();
535 
536     /**
537      * The token must be owned by `from`.
538      */
539     error TransferFromIncorrectOwner();
540 
541     /**
542      * Cannot safely transfer to a contract that does not implement the
543      * ERC721Receiver interface.
544      */
545     error TransferToNonERC721ReceiverImplementer();
546 
547     /**
548      * Cannot transfer to the zero address.
549      */
550     error TransferToZeroAddress();
551 
552     /**
553      * The token does not exist.
554      */
555     error URIQueryForNonexistentToken();
556 
557     /**
558      * The `quantity` minted with ERC2309 exceeds the safety limit.
559      */
560     error MintERC2309QuantityExceedsLimit();
561 
562     /**
563      * The `extraData` cannot be set on an unintialized ownership slot.
564      */
565     error OwnershipNotInitializedForExtraData();
566 
567     // =============================================================
568     //                            STRUCTS
569     // =============================================================
570 
571     struct TokenOwnership {
572         // The address of the owner.
573         address addr;
574         // Stores the start time of ownership with minimal overhead for tokenomics.
575         uint64 startTimestamp;
576         // Whether the token has been burned.
577         bool burned;
578         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
579         uint24 extraData;
580     }
581 
582     // =============================================================
583     //                         TOKEN COUNTERS
584     // =============================================================
585 
586     /**
587      * @dev Returns the total number of tokens in existence.
588      * Burned tokens will reduce the count.
589      * To get the total number of tokens minted, please see {_totalMinted}.
590      */
591     function totalSupply() external view returns (uint256);
592 
593     // =============================================================
594     //                            IERC165
595     // =============================================================
596 
597     /**
598      * @dev Returns true if this contract implements the interface defined by
599      * `interfaceId`. See the corresponding
600      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
601      * to learn more about how these ids are created.
602      *
603      * This function call must use less than 30000 gas.
604      */
605     function supportsInterface(bytes4 interfaceId) external view returns (bool);
606 
607     // =============================================================
608     //                            IERC721
609     // =============================================================
610 
611     /**
612      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
613      */
614     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
615 
616     /**
617      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
618      */
619     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
620 
621     /**
622      * @dev Emitted when `owner` enables or disables
623      * (`approved`) `operator` to manage all of its assets.
624      */
625     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
626 
627     /**
628      * @dev Returns the number of tokens in `owner`'s account.
629      */
630     function balanceOf(address owner) external view returns (uint256 balance);
631 
632     /**
633      * @dev Returns the owner of the `tokenId` token.
634      *
635      * Requirements:
636      *
637      * - `tokenId` must exist.
638      */
639     function ownerOf(uint256 tokenId) external view returns (address owner);
640 
641     /**
642      * @dev Safely transfers `tokenId` token from `from` to `to`,
643      * checking first that contract recipients are aware of the ERC721 protocol
644      * to prevent tokens from being forever locked.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must exist and be owned by `from`.
651      * - If the caller is not `from`, it must be have been allowed to move
652      * this token by either {approve} or {setApprovalForAll}.
653      * - If `to` refers to a smart contract, it must implement
654      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId,
662         bytes calldata data
663     ) external;
664 
665     /**
666      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) external;
673 
674     /**
675      * @dev Transfers `tokenId` from `from` to `to`.
676      *
677      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
678      * whenever possible.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must be owned by `from`.
685      * - If the caller is not `from`, it must be approved to move this token
686      * by either {approve} or {setApprovalForAll}.
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
700      * Only a single account can be approved at a time, so approving the
701      * zero address clears previous approvals.
702      *
703      * Requirements:
704      *
705      * - The caller must own the token or be an approved operator.
706      * - `tokenId` must exist.
707      *
708      * Emits an {Approval} event.
709      */
710     function approve(address to, uint256 tokenId) external;
711 
712     /**
713      * @dev Approve or remove `operator` as an operator for the caller.
714      * Operators can call {transferFrom} or {safeTransferFrom}
715      * for any token owned by the caller.
716      *
717      * Requirements:
718      *
719      * - The `operator` cannot be the caller.
720      *
721      * Emits an {ApprovalForAll} event.
722      */
723     function setApprovalForAll(address operator, bool _approved) external;
724 
725     /**
726      * @dev Returns the account approved for `tokenId` token.
727      *
728      * Requirements:
729      *
730      * - `tokenId` must exist.
731      */
732     function getApproved(uint256 tokenId) external view returns (address operator);
733 
734     /**
735      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
736      *
737      * See {setApprovalForAll}.
738      */
739     function isApprovedForAll(address owner, address operator) external view returns (bool);
740 
741     // =============================================================
742     //                        IERC721Metadata
743     // =============================================================
744 
745     /**
746      * @dev Returns the token collection name.
747      */
748     function name() external view returns (string memory);
749 
750     /**
751      * @dev Returns the token collection symbol.
752      */
753     function symbol() external view returns (string memory);
754 
755     /**
756      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
757      */
758     function tokenURI(uint256 tokenId) external view returns (string memory);
759 
760     // =============================================================
761     //                           IERC2309
762     // =============================================================
763 
764     /**
765      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
766      * (inclusive) is transferred from `from` to `to`, as defined in the
767      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
768      *
769      * See {_mintERC2309} for more details.
770      */
771     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
772 }
773 
774 // File: erc721a/contracts/ERC721A.sol
775 
776 
777 // ERC721A Contracts v4.2.2
778 // Creator: Chiru Labs
779 
780 pragma solidity ^0.8.4;
781 
782 
783 /**
784  * @dev Interface of ERC721 token receiver.
785  */
786 interface ERC721A__IERC721Receiver {
787     function onERC721Received(
788         address operator,
789         address from,
790         uint256 tokenId,
791         bytes calldata data
792     ) external returns (bytes4);
793 }
794 
795 /**
796  * @title ERC721A
797  *
798  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
799  * Non-Fungible Token Standard, including the Metadata extension.
800  * Optimized for lower gas during batch mints.
801  *
802  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
803  * starting from `_startTokenId()`.
804  *
805  * Assumptions:
806  *
807  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
808  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
809  */
810 contract ERC721A is IERC721A {
811     // Reference type for token approval.
812     struct TokenApprovalRef {
813         address value;
814     }
815 
816     // =============================================================
817     //                           CONSTANTS
818     // =============================================================
819 
820     // Mask of an entry in packed address data.
821     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
822 
823     // The bit position of `numberMinted` in packed address data.
824     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
825 
826     // The bit position of `numberBurned` in packed address data.
827     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
828 
829     // The bit position of `aux` in packed address data.
830     uint256 private constant _BITPOS_AUX = 192;
831 
832     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
833     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
834 
835     // The bit position of `startTimestamp` in packed ownership.
836     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
837 
838     // The bit mask of the `burned` bit in packed ownership.
839     uint256 private constant _BITMASK_BURNED = 1 << 224;
840 
841     // The bit position of the `nextInitialized` bit in packed ownership.
842     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
843 
844     // The bit mask of the `nextInitialized` bit in packed ownership.
845     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
846 
847     // The bit position of `extraData` in packed ownership.
848     uint256 private constant _BITPOS_EXTRA_DATA = 232;
849 
850     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
851     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
852 
853     // The mask of the lower 160 bits for addresses.
854     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
855 
856     // The maximum `quantity` that can be minted with {_mintERC2309}.
857     // This limit is to prevent overflows on the address data entries.
858     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
859     // is required to cause an overflow, which is unrealistic.
860     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
861 
862     // The `Transfer` event signature is given by:
863     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
864     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
865         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
866 
867     // =============================================================
868     //                            STORAGE
869     // =============================================================
870 
871     // The next token ID to be minted.
872     uint256 private _currentIndex;
873 
874     // The number of tokens burned.
875     uint256 private _burnCounter;
876 
877     // Token name
878     string private _name;
879 
880     // Token symbol
881     string private _symbol;
882 
883     // Mapping from token ID to ownership details
884     // An empty struct value does not necessarily mean the token is unowned.
885     // See {_packedOwnershipOf} implementation for details.
886     //
887     // Bits Layout:
888     // - [0..159]   `addr`
889     // - [160..223] `startTimestamp`
890     // - [224]      `burned`
891     // - [225]      `nextInitialized`
892     // - [232..255] `extraData`
893     mapping(uint256 => uint256) private _packedOwnerships;
894 
895     // Mapping owner address to address data.
896     //
897     // Bits Layout:
898     // - [0..63]    `balance`
899     // - [64..127]  `numberMinted`
900     // - [128..191] `numberBurned`
901     // - [192..255] `aux`
902     mapping(address => uint256) private _packedAddressData;
903 
904     // Mapping from token ID to approved address.
905     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
906 
907     // Mapping from owner to operator approvals
908     mapping(address => mapping(address => bool)) private _operatorApprovals;
909 
910     // =============================================================
911     //                          CONSTRUCTOR
912     // =============================================================
913 
914     constructor(string memory name_, string memory symbol_) {
915         _name = name_;
916         _symbol = symbol_;
917         _currentIndex = _startTokenId();
918     }
919 
920     // =============================================================
921     //                   TOKEN COUNTING OPERATIONS
922     // =============================================================
923 
924     /**
925      * @dev Returns the starting token ID.
926      * To change the starting token ID, please override this function.
927      */
928     function _startTokenId() internal view virtual returns (uint256) {
929         return 0;
930     }
931 
932     /**
933      * @dev Returns the next token ID to be minted.
934      */
935     function _nextTokenId() internal view virtual returns (uint256) {
936         return _currentIndex;
937     }
938 
939     /**
940      * @dev Returns the total number of tokens in existence.
941      * Burned tokens will reduce the count.
942      * To get the total number of tokens minted, please see {_totalMinted}.
943      */
944     function totalSupply() public view virtual override returns (uint256) {
945         // Counter underflow is impossible as _burnCounter cannot be incremented
946         // more than `_currentIndex - _startTokenId()` times.
947         unchecked {
948             return _currentIndex - _burnCounter - _startTokenId();
949         }
950     }
951 
952     /**
953      * @dev Returns the total amount of tokens minted in the contract.
954      */
955     function _totalMinted() internal view virtual returns (uint256) {
956         // Counter underflow is impossible as `_currentIndex` does not decrement,
957         // and it is initialized to `_startTokenId()`.
958         unchecked {
959             return _currentIndex - _startTokenId();
960         }
961     }
962 
963     /**
964      * @dev Returns the total number of tokens burned.
965      */
966     function _totalBurned() internal view virtual returns (uint256) {
967         return _burnCounter;
968     }
969 
970     // =============================================================
971     //                    ADDRESS DATA OPERATIONS
972     // =============================================================
973 
974     /**
975      * @dev Returns the number of tokens in `owner`'s account.
976      */
977     function balanceOf(address owner) public view virtual override returns (uint256) {
978         if (owner == address(0)) revert BalanceQueryForZeroAddress();
979         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
980     }
981 
982     /**
983      * Returns the number of tokens minted by `owner`.
984      */
985     function _numberMinted(address owner) internal view returns (uint256) {
986         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
987     }
988 
989     /**
990      * Returns the number of tokens burned by or on behalf of `owner`.
991      */
992     function _numberBurned(address owner) internal view returns (uint256) {
993         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
994     }
995 
996     /**
997      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
998      */
999     function _getAux(address owner) internal view returns (uint64) {
1000         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1001     }
1002 
1003     /**
1004      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1005      * If there are multiple variables, please pack them into a uint64.
1006      */
1007     function _setAux(address owner, uint64 aux) internal virtual {
1008         uint256 packed = _packedAddressData[owner];
1009         uint256 auxCasted;
1010         // Cast `aux` with assembly to avoid redundant masking.
1011         assembly {
1012             auxCasted := aux
1013         }
1014         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1015         _packedAddressData[owner] = packed;
1016     }
1017 
1018     // =============================================================
1019     //                            IERC165
1020     // =============================================================
1021 
1022     /**
1023      * @dev Returns true if this contract implements the interface defined by
1024      * `interfaceId`. See the corresponding
1025      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1026      * to learn more about how these ids are created.
1027      *
1028      * This function call must use less than 30000 gas.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1031         // The interface IDs are constants representing the first 4 bytes
1032         // of the XOR of all function selectors in the interface.
1033         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1034         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1035         return
1036             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1037             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1038             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1039     }
1040 
1041     // =============================================================
1042     //                        IERC721Metadata
1043     // =============================================================
1044 
1045     /**
1046      * @dev Returns the token collection name.
1047      */
1048     function name() public view virtual override returns (string memory) {
1049         return _name;
1050     }
1051 
1052     /**
1053      * @dev Returns the token collection symbol.
1054      */
1055     function symbol() public view virtual override returns (string memory) {
1056         return _symbol;
1057     }
1058 
1059     /**
1060      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1061      */
1062     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1063         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1064 
1065         string memory baseURI = _baseURI();
1066         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1067     }
1068 
1069     /**
1070      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1071      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1072      * by default, it can be overridden in child contracts.
1073      */
1074     function _baseURI() internal view virtual returns (string memory) {
1075         return '';
1076     }
1077 
1078     // =============================================================
1079     //                     OWNERSHIPS OPERATIONS
1080     // =============================================================
1081 
1082     /**
1083      * @dev Returns the owner of the `tokenId` token.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must exist.
1088      */
1089     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1090         return address(uint160(_packedOwnershipOf(tokenId)));
1091     }
1092 
1093     /**
1094      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1095      * It gradually moves to O(1) as tokens get transferred around over time.
1096      */
1097     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1098         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1099     }
1100 
1101     /**
1102      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1103      */
1104     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1105         return _unpackedOwnership(_packedOwnerships[index]);
1106     }
1107 
1108     /**
1109      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1110      */
1111     function _initializeOwnershipAt(uint256 index) internal virtual {
1112         if (_packedOwnerships[index] == 0) {
1113             _packedOwnerships[index] = _packedOwnershipOf(index);
1114         }
1115     }
1116 
1117     /**
1118      * Returns the packed ownership data of `tokenId`.
1119      */
1120     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1121         uint256 curr = tokenId;
1122 
1123         unchecked {
1124             if (_startTokenId() <= curr)
1125                 if (curr < _currentIndex) {
1126                     uint256 packed = _packedOwnerships[curr];
1127                     // If not burned.
1128                     if (packed & _BITMASK_BURNED == 0) {
1129                         // Invariant:
1130                         // There will always be an initialized ownership slot
1131                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1132                         // before an unintialized ownership slot
1133                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1134                         // Hence, `curr` will not underflow.
1135                         //
1136                         // We can directly compare the packed value.
1137                         // If the address is zero, packed will be zero.
1138                         while (packed == 0) {
1139                             packed = _packedOwnerships[--curr];
1140                         }
1141                         return packed;
1142                     }
1143                 }
1144         }
1145         revert OwnerQueryForNonexistentToken();
1146     }
1147 
1148     /**
1149      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1150      */
1151     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1152         ownership.addr = address(uint160(packed));
1153         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1154         ownership.burned = packed & _BITMASK_BURNED != 0;
1155         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1156     }
1157 
1158     /**
1159      * @dev Packs ownership data into a single uint256.
1160      */
1161     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1162         assembly {
1163             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1164             owner := and(owner, _BITMASK_ADDRESS)
1165             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1166             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1167         }
1168     }
1169 
1170     /**
1171      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1172      */
1173     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1174         // For branchless setting of the `nextInitialized` flag.
1175         assembly {
1176             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1177             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1178         }
1179     }
1180 
1181     // =============================================================
1182     //                      APPROVAL OPERATIONS
1183     // =============================================================
1184 
1185     /**
1186      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1187      * The approval is cleared when the token is transferred.
1188      *
1189      * Only a single account can be approved at a time, so approving the
1190      * zero address clears previous approvals.
1191      *
1192      * Requirements:
1193      *
1194      * - The caller must own the token or be an approved operator.
1195      * - `tokenId` must exist.
1196      *
1197      * Emits an {Approval} event.
1198      */
1199     function approve(address to, uint256 tokenId) public virtual override {
1200         address owner = ownerOf(tokenId);
1201 
1202         if (_msgSenderERC721A() != owner)
1203             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1204                 revert ApprovalCallerNotOwnerNorApproved();
1205             }
1206 
1207         _tokenApprovals[tokenId].value = to;
1208         emit Approval(owner, to, tokenId);
1209     }
1210 
1211     /**
1212      * @dev Returns the account approved for `tokenId` token.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      */
1218     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1219         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1220 
1221         return _tokenApprovals[tokenId].value;
1222     }
1223 
1224     /**
1225      * @dev Approve or remove `operator` as an operator for the caller.
1226      * Operators can call {transferFrom} or {safeTransferFrom}
1227      * for any token owned by the caller.
1228      *
1229      * Requirements:
1230      *
1231      * - The `operator` cannot be the caller.
1232      *
1233      * Emits an {ApprovalForAll} event.
1234      */
1235     function setApprovalForAll(address operator, bool approved) public virtual override {
1236         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1237 
1238         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1239         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1240     }
1241 
1242     /**
1243      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1244      *
1245      * See {setApprovalForAll}.
1246      */
1247     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1248         return _operatorApprovals[owner][operator];
1249     }
1250 
1251     /**
1252      * @dev Returns whether `tokenId` exists.
1253      *
1254      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1255      *
1256      * Tokens start existing when they are minted. See {_mint}.
1257      */
1258     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1259         return
1260             _startTokenId() <= tokenId &&
1261             tokenId < _currentIndex && // If within bounds,
1262             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1263     }
1264 
1265     /**
1266      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1267      */
1268     function _isSenderApprovedOrOwner(
1269         address approvedAddress,
1270         address owner,
1271         address msgSender
1272     ) private pure returns (bool result) {
1273         assembly {
1274             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1275             owner := and(owner, _BITMASK_ADDRESS)
1276             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1277             msgSender := and(msgSender, _BITMASK_ADDRESS)
1278             // `msgSender == owner || msgSender == approvedAddress`.
1279             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1280         }
1281     }
1282 
1283     /**
1284      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1285      */
1286     function _getApprovedSlotAndAddress(uint256 tokenId)
1287         private
1288         view
1289         returns (uint256 approvedAddressSlot, address approvedAddress)
1290     {
1291         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1292         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1293         assembly {
1294             approvedAddressSlot := tokenApproval.slot
1295             approvedAddress := sload(approvedAddressSlot)
1296         }
1297     }
1298 
1299     // =============================================================
1300     //                      TRANSFER OPERATIONS
1301     // =============================================================
1302 
1303     /**
1304      * @dev Transfers `tokenId` from `from` to `to`.
1305      *
1306      * Requirements:
1307      *
1308      * - `from` cannot be the zero address.
1309      * - `to` cannot be the zero address.
1310      * - `tokenId` token must be owned by `from`.
1311      * - If the caller is not `from`, it must be approved to move this token
1312      * by either {approve} or {setApprovalForAll}.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function transferFrom(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) public virtual override {
1321         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1322 
1323         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1324 
1325         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1326 
1327         // The nested ifs save around 20+ gas over a compound boolean condition.
1328         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1329             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1330 
1331         if (to == address(0)) revert TransferToZeroAddress();
1332 
1333         _beforeTokenTransfers(from, to, tokenId, 1);
1334 
1335         // Clear approvals from the previous owner.
1336         assembly {
1337             if approvedAddress {
1338                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1339                 sstore(approvedAddressSlot, 0)
1340             }
1341         }
1342 
1343         // Underflow of the sender's balance is impossible because we check for
1344         // ownership above and the recipient's balance can't realistically overflow.
1345         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1346         unchecked {
1347             // We can directly increment and decrement the balances.
1348             --_packedAddressData[from]; // Updates: `balance -= 1`.
1349             ++_packedAddressData[to]; // Updates: `balance += 1`.
1350 
1351             // Updates:
1352             // - `address` to the next owner.
1353             // - `startTimestamp` to the timestamp of transfering.
1354             // - `burned` to `false`.
1355             // - `nextInitialized` to `true`.
1356             _packedOwnerships[tokenId] = _packOwnershipData(
1357                 to,
1358                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1359             );
1360 
1361             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1362             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1363                 uint256 nextTokenId = tokenId + 1;
1364                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1365                 if (_packedOwnerships[nextTokenId] == 0) {
1366                     // If the next slot is within bounds.
1367                     if (nextTokenId != _currentIndex) {
1368                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1369                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1370                     }
1371                 }
1372             }
1373         }
1374 
1375         emit Transfer(from, to, tokenId);
1376         _afterTokenTransfers(from, to, tokenId, 1);
1377     }
1378 
1379     /**
1380      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1381      */
1382     function safeTransferFrom(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) public virtual override {
1387         safeTransferFrom(from, to, tokenId, '');
1388     }
1389 
1390     /**
1391      * @dev Safely transfers `tokenId` token from `from` to `to`.
1392      *
1393      * Requirements:
1394      *
1395      * - `from` cannot be the zero address.
1396      * - `to` cannot be the zero address.
1397      * - `tokenId` token must exist and be owned by `from`.
1398      * - If the caller is not `from`, it must be approved to move this token
1399      * by either {approve} or {setApprovalForAll}.
1400      * - If `to` refers to a smart contract, it must implement
1401      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1402      *
1403      * Emits a {Transfer} event.
1404      */
1405     function safeTransferFrom(
1406         address from,
1407         address to,
1408         uint256 tokenId,
1409         bytes memory _data
1410     ) public virtual override {
1411         transferFrom(from, to, tokenId);
1412         if (to.code.length != 0)
1413             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1414                 revert TransferToNonERC721ReceiverImplementer();
1415             }
1416     }
1417 
1418     /**
1419      * @dev Hook that is called before a set of serially-ordered token IDs
1420      * are about to be transferred. This includes minting.
1421      * And also called before burning one token.
1422      *
1423      * `startTokenId` - the first token ID to be transferred.
1424      * `quantity` - the amount to be transferred.
1425      *
1426      * Calling conditions:
1427      *
1428      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1429      * transferred to `to`.
1430      * - When `from` is zero, `tokenId` will be minted for `to`.
1431      * - When `to` is zero, `tokenId` will be burned by `from`.
1432      * - `from` and `to` are never both zero.
1433      */
1434     function _beforeTokenTransfers(
1435         address from,
1436         address to,
1437         uint256 startTokenId,
1438         uint256 quantity
1439     ) internal virtual {}
1440 
1441     /**
1442      * @dev Hook that is called after a set of serially-ordered token IDs
1443      * have been transferred. This includes minting.
1444      * And also called after one token has been burned.
1445      *
1446      * `startTokenId` - the first token ID to be transferred.
1447      * `quantity` - the amount to be transferred.
1448      *
1449      * Calling conditions:
1450      *
1451      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1452      * transferred to `to`.
1453      * - When `from` is zero, `tokenId` has been minted for `to`.
1454      * - When `to` is zero, `tokenId` has been burned by `from`.
1455      * - `from` and `to` are never both zero.
1456      */
1457     function _afterTokenTransfers(
1458         address from,
1459         address to,
1460         uint256 startTokenId,
1461         uint256 quantity
1462     ) internal virtual {}
1463 
1464     /**
1465      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1466      *
1467      * `from` - Previous owner of the given token ID.
1468      * `to` - Target address that will receive the token.
1469      * `tokenId` - Token ID to be transferred.
1470      * `_data` - Optional data to send along with the call.
1471      *
1472      * Returns whether the call correctly returned the expected magic value.
1473      */
1474     function _checkContractOnERC721Received(
1475         address from,
1476         address to,
1477         uint256 tokenId,
1478         bytes memory _data
1479     ) private returns (bool) {
1480         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1481             bytes4 retval
1482         ) {
1483             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1484         } catch (bytes memory reason) {
1485             if (reason.length == 0) {
1486                 revert TransferToNonERC721ReceiverImplementer();
1487             } else {
1488                 assembly {
1489                     revert(add(32, reason), mload(reason))
1490                 }
1491             }
1492         }
1493     }
1494 
1495     // =============================================================
1496     //                        MINT OPERATIONS
1497     // =============================================================
1498 
1499     /**
1500      * @dev Mints `quantity` tokens and transfers them to `to`.
1501      *
1502      * Requirements:
1503      *
1504      * - `to` cannot be the zero address.
1505      * - `quantity` must be greater than 0.
1506      *
1507      * Emits a {Transfer} event for each mint.
1508      */
1509     function _mint(address to, uint256 quantity) internal virtual {
1510         uint256 startTokenId = _currentIndex;
1511         if (quantity == 0) revert MintZeroQuantity();
1512 
1513         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1514 
1515         // Overflows are incredibly unrealistic.
1516         // `balance` and `numberMinted` have a maximum limit of 2**64.
1517         // `tokenId` has a maximum limit of 2**256.
1518         unchecked {
1519             // Updates:
1520             // - `balance += quantity`.
1521             // - `numberMinted += quantity`.
1522             //
1523             // We can directly add to the `balance` and `numberMinted`.
1524             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1525 
1526             // Updates:
1527             // - `address` to the owner.
1528             // - `startTimestamp` to the timestamp of minting.
1529             // - `burned` to `false`.
1530             // - `nextInitialized` to `quantity == 1`.
1531             _packedOwnerships[startTokenId] = _packOwnershipData(
1532                 to,
1533                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1534             );
1535 
1536             uint256 toMasked;
1537             uint256 end = startTokenId + quantity;
1538 
1539             // Use assembly to loop and emit the `Transfer` event for gas savings.
1540             assembly {
1541                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1542                 toMasked := and(to, _BITMASK_ADDRESS)
1543                 // Emit the `Transfer` event.
1544                 log4(
1545                     0, // Start of data (0, since no data).
1546                     0, // End of data (0, since no data).
1547                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1548                     0, // `address(0)`.
1549                     toMasked, // `to`.
1550                     startTokenId // `tokenId`.
1551                 )
1552 
1553                 for {
1554                     let tokenId := add(startTokenId, 1)
1555                 } iszero(eq(tokenId, end)) {
1556                     tokenId := add(tokenId, 1)
1557                 } {
1558                     // Emit the `Transfer` event. Similar to above.
1559                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1560                 }
1561             }
1562             if (toMasked == 0) revert MintToZeroAddress();
1563 
1564             _currentIndex = end;
1565         }
1566         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1567     }
1568 
1569     /**
1570      * @dev Mints `quantity` tokens and transfers them to `to`.
1571      *
1572      * This function is intended for efficient minting only during contract creation.
1573      *
1574      * It emits only one {ConsecutiveTransfer} as defined in
1575      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1576      * instead of a sequence of {Transfer} event(s).
1577      *
1578      * Calling this function outside of contract creation WILL make your contract
1579      * non-compliant with the ERC721 standard.
1580      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1581      * {ConsecutiveTransfer} event is only permissible during contract creation.
1582      *
1583      * Requirements:
1584      *
1585      * - `to` cannot be the zero address.
1586      * - `quantity` must be greater than 0.
1587      *
1588      * Emits a {ConsecutiveTransfer} event.
1589      */
1590     function _mintERC2309(address to, uint256 quantity) internal virtual {
1591         uint256 startTokenId = _currentIndex;
1592         if (to == address(0)) revert MintToZeroAddress();
1593         if (quantity == 0) revert MintZeroQuantity();
1594         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1595 
1596         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1597 
1598         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1599         unchecked {
1600             // Updates:
1601             // - `balance += quantity`.
1602             // - `numberMinted += quantity`.
1603             //
1604             // We can directly add to the `balance` and `numberMinted`.
1605             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1606 
1607             // Updates:
1608             // - `address` to the owner.
1609             // - `startTimestamp` to the timestamp of minting.
1610             // - `burned` to `false`.
1611             // - `nextInitialized` to `quantity == 1`.
1612             _packedOwnerships[startTokenId] = _packOwnershipData(
1613                 to,
1614                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1615             );
1616 
1617             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1618 
1619             _currentIndex = startTokenId + quantity;
1620         }
1621         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1622     }
1623 
1624     /**
1625      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1626      *
1627      * Requirements:
1628      *
1629      * - If `to` refers to a smart contract, it must implement
1630      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1631      * - `quantity` must be greater than 0.
1632      *
1633      * See {_mint}.
1634      *
1635      * Emits a {Transfer} event for each mint.
1636      */
1637     function _safeMint(
1638         address to,
1639         uint256 quantity,
1640         bytes memory _data
1641     ) internal virtual {
1642         _mint(to, quantity);
1643 
1644         unchecked {
1645             if (to.code.length != 0) {
1646                 uint256 end = _currentIndex;
1647                 uint256 index = end - quantity;
1648                 do {
1649                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1650                         revert TransferToNonERC721ReceiverImplementer();
1651                     }
1652                 } while (index < end);
1653                 // Reentrancy protection.
1654                 if (_currentIndex != end) revert();
1655             }
1656         }
1657     }
1658 
1659     /**
1660      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1661      */
1662     function _safeMint(address to, uint256 quantity) internal virtual {
1663         _safeMint(to, quantity, '');
1664     }
1665 
1666     // =============================================================
1667     //                        BURN OPERATIONS
1668     // =============================================================
1669 
1670     /**
1671      * @dev Equivalent to `_burn(tokenId, false)`.
1672      */
1673     function _burn(uint256 tokenId) internal virtual {
1674         _burn(tokenId, false);
1675     }
1676 
1677     /**
1678      * @dev Destroys `tokenId`.
1679      * The approval is cleared when the token is burned.
1680      *
1681      * Requirements:
1682      *
1683      * - `tokenId` must exist.
1684      *
1685      * Emits a {Transfer} event.
1686      */
1687     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1688         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1689 
1690         address from = address(uint160(prevOwnershipPacked));
1691 
1692         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1693 
1694         if (approvalCheck) {
1695             // The nested ifs save around 20+ gas over a compound boolean condition.
1696             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1697                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1698         }
1699 
1700         _beforeTokenTransfers(from, address(0), tokenId, 1);
1701 
1702         // Clear approvals from the previous owner.
1703         assembly {
1704             if approvedAddress {
1705                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1706                 sstore(approvedAddressSlot, 0)
1707             }
1708         }
1709 
1710         // Underflow of the sender's balance is impossible because we check for
1711         // ownership above and the recipient's balance can't realistically overflow.
1712         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1713         unchecked {
1714             // Updates:
1715             // - `balance -= 1`.
1716             // - `numberBurned += 1`.
1717             //
1718             // We can directly decrement the balance, and increment the number burned.
1719             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1720             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1721 
1722             // Updates:
1723             // - `address` to the last owner.
1724             // - `startTimestamp` to the timestamp of burning.
1725             // - `burned` to `true`.
1726             // - `nextInitialized` to `true`.
1727             _packedOwnerships[tokenId] = _packOwnershipData(
1728                 from,
1729                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1730             );
1731 
1732             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1733             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1734                 uint256 nextTokenId = tokenId + 1;
1735                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1736                 if (_packedOwnerships[nextTokenId] == 0) {
1737                     // If the next slot is within bounds.
1738                     if (nextTokenId != _currentIndex) {
1739                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1740                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1741                     }
1742                 }
1743             }
1744         }
1745 
1746         emit Transfer(from, address(0), tokenId);
1747         _afterTokenTransfers(from, address(0), tokenId, 1);
1748 
1749         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1750         unchecked {
1751             _burnCounter++;
1752         }
1753     }
1754 
1755     // =============================================================
1756     //                     EXTRA DATA OPERATIONS
1757     // =============================================================
1758 
1759     /**
1760      * @dev Directly sets the extra data for the ownership data `index`.
1761      */
1762     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1763         uint256 packed = _packedOwnerships[index];
1764         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1765         uint256 extraDataCasted;
1766         // Cast `extraData` with assembly to avoid redundant masking.
1767         assembly {
1768             extraDataCasted := extraData
1769         }
1770         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1771         _packedOwnerships[index] = packed;
1772     }
1773 
1774     /**
1775      * @dev Called during each token transfer to set the 24bit `extraData` field.
1776      * Intended to be overridden by the cosumer contract.
1777      *
1778      * `previousExtraData` - the value of `extraData` before transfer.
1779      *
1780      * Calling conditions:
1781      *
1782      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1783      * transferred to `to`.
1784      * - When `from` is zero, `tokenId` will be minted for `to`.
1785      * - When `to` is zero, `tokenId` will be burned by `from`.
1786      * - `from` and `to` are never both zero.
1787      */
1788     function _extraData(
1789         address from,
1790         address to,
1791         uint24 previousExtraData
1792     ) internal view virtual returns (uint24) {}
1793 
1794     /**
1795      * @dev Returns the next extra data for the packed ownership data.
1796      * The returned result is shifted into position.
1797      */
1798     function _nextExtraData(
1799         address from,
1800         address to,
1801         uint256 prevOwnershipPacked
1802     ) private view returns (uint256) {
1803         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1804         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1805     }
1806 
1807     // =============================================================
1808     //                       OTHER OPERATIONS
1809     // =============================================================
1810 
1811     /**
1812      * @dev Returns the message sender (defaults to `msg.sender`).
1813      *
1814      * If you are writing GSN compatible contracts, you need to override this function.
1815      */
1816     function _msgSenderERC721A() internal view virtual returns (address) {
1817         return msg.sender;
1818     }
1819 
1820     /**
1821      * @dev Converts a uint256 to its ASCII string decimal representation.
1822      */
1823     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1824         assembly {
1825             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1826             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1827             // We will need 1 32-byte word to store the length,
1828             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1829             str := add(mload(0x40), 0x80)
1830             // Update the free memory pointer to allocate.
1831             mstore(0x40, str)
1832 
1833             // Cache the end of the memory to calculate the length later.
1834             let end := str
1835 
1836             // We write the string from rightmost digit to leftmost digit.
1837             // The following is essentially a do-while loop that also handles the zero case.
1838             // prettier-ignore
1839             for { let temp := value } 1 {} {
1840                 str := sub(str, 1)
1841                 // Write the character to the pointer.
1842                 // The ASCII index of the '0' character is 48.
1843                 mstore8(str, add(48, mod(temp, 10)))
1844                 // Keep dividing `temp` until zero.
1845                 temp := div(temp, 10)
1846                 // prettier-ignore
1847                 if iszero(temp) { break }
1848             }
1849 
1850             let length := sub(end, str)
1851             // Move the pointer 32 bytes leftwards to make room for the length.
1852             str := sub(str, 0x20)
1853             // Store the length.
1854             mstore(str, length)
1855         }
1856     }
1857 }
1858 
1859 // File: contracts/MoonOwls.sol
1860 
1861 
1862 
1863 pragma solidity ^0.8.0;
1864 
1865 
1866 
1867 
1868 
1869 
1870 contract MoonOwlsNFT is ERC721A, Ownable, ReentrancyGuard {
1871   using Address for address;
1872   using Strings for uint;
1873   string  public  baseTokenURI = "ipfs://QmUEpwCJk2smphjucTSNhQRHUWRJsTCFmfAR1FuVSK6hvt";
1874 
1875   uint256 public  maxSupply = 1500;
1876   uint256 public  MAX_MINTS_PER_TX = 2;
1877   uint256 public  PUBLIC_SALE_PRICE = .0065 ether;
1878   
1879   bool private addwhitelistaddress;
1880   bool public IsWhitelistSaleActive = false;
1881   bool public isPublicSaleActive = false;
1882   
1883   constructor() ERC721A("Moon Owls NFT", "MOOWL") {
1884 
1885   }
1886   
1887   function mint(uint256 numberOfTokens)
1888       external
1889       payable
1890   {
1891     require(isPublicSaleActive, "Public sale is not open");
1892     require(
1893       totalSupply() + numberOfTokens <= maxSupply,
1894       "Maximum supply exceeded"
1895     );
1896     require(
1897             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1898             "Incorrect ETH value sent"
1899     );
1900     _safeMint(msg.sender, numberOfTokens);
1901   }
1902 
1903   function whiteListMint(uint256 numberOfTokens )
1904      external
1905      payable
1906   {
1907     require(IsWhitelistSaleActive, "Whitelistsale not live" );
1908     require(addwhitelistaddress, "are you whitelsted" );
1909     _safeMint(msg.sender, numberOfTokens);
1910   }
1911   
1912   function setBaseURI(string memory baseURI)
1913     public
1914     onlyOwner
1915   {
1916     baseTokenURI = baseURI;
1917   }
1918   
1919   function _startTokenId() internal view virtual override returns (uint256) {
1920         return 1;
1921     }
1922 
1923   function treasuryMint(uint numberOfTokens, address user)
1924     public
1925     onlyOwner
1926   {
1927     require(
1928       numberOfTokens > 0,
1929       "Invalid mint amount"
1930     );
1931     require(
1932       totalSupply() + numberOfTokens <= maxSupply,
1933       "Maximum supply exceeded"
1934     );
1935     _safeMint(user, numberOfTokens);
1936   }
1937 
1938   function setwhitelistapprovedaddress(bool _addwhitelistaddress)
1939      external
1940      onlyOwner
1941   {
1942     addwhitelistaddress = _addwhitelistaddress;
1943   }
1944 
1945   function tokenURI(uint _tokenId)
1946     public
1947     view
1948     virtual
1949     override
1950     returns (string memory)
1951   {
1952     require(
1953       _exists(_tokenId),
1954       "ERC721Metadata: URI query for nonexistent token"
1955     );
1956     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1957   }
1958 
1959   function _baseURI()
1960     internal
1961     view
1962     virtual
1963     override
1964     returns (string memory)
1965   {
1966     return baseTokenURI;
1967   }
1968 
1969   function setIsPublicSaleActive(bool _isPublicSaleActive)
1970       external
1971       onlyOwner
1972   {
1973       isPublicSaleActive = _isPublicSaleActive;
1974   }
1975   
1976   function setIsWhitelistsaleActive(bool _IsWhitelistSaleActive)
1977       external
1978       onlyOwner
1979     {
1980          IsWhitelistSaleActive = _IsWhitelistSaleActive; 
1981     }
1982 
1983   function setSalePrice(uint256 _price)
1984       external
1985       onlyOwner
1986   {
1987       PUBLIC_SALE_PRICE = _price;
1988   }
1989 
1990   function setMaxLimitPerTransaction(uint256 _limit)
1991       external
1992       onlyOwner
1993   {
1994       MAX_MINTS_PER_TX = _limit;
1995   }
1996   
1997 
1998   function withdraw()
1999     public
2000     onlyOwner
2001     nonReentrant
2002   {
2003     Address.sendValue(payable(msg.sender), address(this).balance);
2004   }
2005 }