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
487 // ERC721A Contracts v4.2.3
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
507      * Cannot query the balance for the zero address.
508      */
509     error BalanceQueryForZeroAddress();
510 
511     /**
512      * Cannot mint to the zero address.
513      */
514     error MintToZeroAddress();
515 
516     /**
517      * The quantity of tokens minted must be more than zero.
518      */
519     error MintZeroQuantity();
520 
521     /**
522      * The token does not exist.
523      */
524     error OwnerQueryForNonexistentToken();
525 
526     /**
527      * The caller must own the token or be an approved operator.
528      */
529     error TransferCallerNotOwnerNorApproved();
530 
531     /**
532      * The token must be owned by `from`.
533      */
534     error TransferFromIncorrectOwner();
535 
536     /**
537      * Cannot safely transfer to a contract that does not implement the
538      * ERC721Receiver interface.
539      */
540     error TransferToNonERC721ReceiverImplementer();
541 
542     /**
543      * Cannot transfer to the zero address.
544      */
545     error TransferToZeroAddress();
546 
547     /**
548      * The token does not exist.
549      */
550     error URIQueryForNonexistentToken();
551 
552     /**
553      * The `quantity` minted with ERC2309 exceeds the safety limit.
554      */
555     error MintERC2309QuantityExceedsLimit();
556 
557     /**
558      * The `extraData` cannot be set on an unintialized ownership slot.
559      */
560     error OwnershipNotInitializedForExtraData();
561 
562     // =============================================================
563     //                            STRUCTS
564     // =============================================================
565 
566     struct TokenOwnership {
567         // The address of the owner.
568         address addr;
569         // Stores the start time of ownership with minimal overhead for tokenomics.
570         uint64 startTimestamp;
571         // Whether the token has been burned.
572         bool burned;
573         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
574         uint24 extraData;
575     }
576 
577     // =============================================================
578     //                         TOKEN COUNTERS
579     // =============================================================
580 
581     /**
582      * @dev Returns the total number of tokens in existence.
583      * Burned tokens will reduce the count.
584      * To get the total number of tokens minted, please see {_totalMinted}.
585      */
586     function totalSupply() external view returns (uint256);
587 
588     // =============================================================
589     //                            IERC165
590     // =============================================================
591 
592     /**
593      * @dev Returns true if this contract implements the interface defined by
594      * `interfaceId`. See the corresponding
595      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
596      * to learn more about how these ids are created.
597      *
598      * This function call must use less than 30000 gas.
599      */
600     function supportsInterface(bytes4 interfaceId) external view returns (bool);
601 
602     // =============================================================
603     //                            IERC721
604     // =============================================================
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
617      * @dev Emitted when `owner` enables or disables
618      * (`approved`) `operator` to manage all of its assets.
619      */
620     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
621 
622     /**
623      * @dev Returns the number of tokens in `owner`'s account.
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
637      * @dev Safely transfers `tokenId` token from `from` to `to`,
638      * checking first that contract recipients are aware of the ERC721 protocol
639      * to prevent tokens from being forever locked.
640      *
641      * Requirements:
642      *
643      * - `from` cannot be the zero address.
644      * - `to` cannot be the zero address.
645      * - `tokenId` token must exist and be owned by `from`.
646      * - If the caller is not `from`, it must be have been allowed to move
647      * this token by either {approve} or {setApprovalForAll}.
648      * - If `to` refers to a smart contract, it must implement
649      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
650      *
651      * Emits a {Transfer} event.
652      */
653     function safeTransferFrom(
654         address from,
655         address to,
656         uint256 tokenId,
657         bytes calldata data
658     ) external payable;
659 
660     /**
661      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId
667     ) external payable;
668 
669     /**
670      * @dev Transfers `tokenId` from `from` to `to`.
671      *
672      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
673      * whenever possible.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must be owned by `from`.
680      * - If the caller is not `from`, it must be approved to move this token
681      * by either {approve} or {setApprovalForAll}.
682      *
683      * Emits a {Transfer} event.
684      */
685     function transferFrom(
686         address from,
687         address to,
688         uint256 tokenId
689     ) external payable;
690 
691     /**
692      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
693      * The approval is cleared when the token is transferred.
694      *
695      * Only a single account can be approved at a time, so approving the
696      * zero address clears previous approvals.
697      *
698      * Requirements:
699      *
700      * - The caller must own the token or be an approved operator.
701      * - `tokenId` must exist.
702      *
703      * Emits an {Approval} event.
704      */
705     function approve(address to, uint256 tokenId) external payable;
706 
707     /**
708      * @dev Approve or remove `operator` as an operator for the caller.
709      * Operators can call {transferFrom} or {safeTransferFrom}
710      * for any token owned by the caller.
711      *
712      * Requirements:
713      *
714      * - The `operator` cannot be the caller.
715      *
716      * Emits an {ApprovalForAll} event.
717      */
718     function setApprovalForAll(address operator, bool _approved) external;
719 
720     /**
721      * @dev Returns the account approved for `tokenId` token.
722      *
723      * Requirements:
724      *
725      * - `tokenId` must exist.
726      */
727     function getApproved(uint256 tokenId) external view returns (address operator);
728 
729     /**
730      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
731      *
732      * See {setApprovalForAll}.
733      */
734     function isApprovedForAll(address owner, address operator) external view returns (bool);
735 
736     // =============================================================
737     //                        IERC721Metadata
738     // =============================================================
739 
740     /**
741      * @dev Returns the token collection name.
742      */
743     function name() external view returns (string memory);
744 
745     /**
746      * @dev Returns the token collection symbol.
747      */
748     function symbol() external view returns (string memory);
749 
750     /**
751      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
752      */
753     function tokenURI(uint256 tokenId) external view returns (string memory);
754 
755     // =============================================================
756     //                           IERC2309
757     // =============================================================
758 
759     /**
760      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
761      * (inclusive) is transferred from `from` to `to`, as defined in the
762      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
763      *
764      * See {_mintERC2309} for more details.
765      */
766     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
767 }
768 
769 // File: erc721a/contracts/ERC721A.sol
770 
771 
772 // ERC721A Contracts v4.2.3
773 // Creator: Chiru Labs
774 
775 pragma solidity ^0.8.4;
776 
777 
778 /**
779  * @dev Interface of ERC721 token receiver.
780  */
781 interface ERC721A__IERC721Receiver {
782     function onERC721Received(
783         address operator,
784         address from,
785         uint256 tokenId,
786         bytes calldata data
787     ) external returns (bytes4);
788 }
789 
790 /**
791  * @title ERC721A
792  *
793  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
794  * Non-Fungible Token Standard, including the Metadata extension.
795  * Optimized for lower gas during batch mints.
796  *
797  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
798  * starting from `_startTokenId()`.
799  *
800  * Assumptions:
801  *
802  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
803  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
804  */
805 contract ERC721A is IERC721A {
806     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
807     struct TokenApprovalRef {
808         address value;
809     }
810 
811     // =============================================================
812     //                           CONSTANTS
813     // =============================================================
814 
815     // Mask of an entry in packed address data.
816     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
817 
818     // The bit position of `numberMinted` in packed address data.
819     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
820 
821     // The bit position of `numberBurned` in packed address data.
822     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
823 
824     // The bit position of `aux` in packed address data.
825     uint256 private constant _BITPOS_AUX = 192;
826 
827     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
828     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
829 
830     // The bit position of `startTimestamp` in packed ownership.
831     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
832 
833     // The bit mask of the `burned` bit in packed ownership.
834     uint256 private constant _BITMASK_BURNED = 1 << 224;
835 
836     // The bit position of the `nextInitialized` bit in packed ownership.
837     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
838 
839     // The bit mask of the `nextInitialized` bit in packed ownership.
840     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
841 
842     // The bit position of `extraData` in packed ownership.
843     uint256 private constant _BITPOS_EXTRA_DATA = 232;
844 
845     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
846     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
847 
848     // The mask of the lower 160 bits for addresses.
849     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
850 
851     // The maximum `quantity` that can be minted with {_mintERC2309}.
852     // This limit is to prevent overflows on the address data entries.
853     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
854     // is required to cause an overflow, which is unrealistic.
855     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
856 
857     // The `Transfer` event signature is given by:
858     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
859     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
860         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
861 
862     // =============================================================
863     //                            STORAGE
864     // =============================================================
865 
866     // The next token ID to be minted.
867     uint256 private _currentIndex;
868 
869     // The number of tokens burned.
870     uint256 private _burnCounter;
871 
872     // Token name
873     string private _name;
874 
875     // Token symbol
876     string private _symbol;
877 
878     // Mapping from token ID to ownership details
879     // An empty struct value does not necessarily mean the token is unowned.
880     // See {_packedOwnershipOf} implementation for details.
881     //
882     // Bits Layout:
883     // - [0..159]   `addr`
884     // - [160..223] `startTimestamp`
885     // - [224]      `burned`
886     // - [225]      `nextInitialized`
887     // - [232..255] `extraData`
888     mapping(uint256 => uint256) private _packedOwnerships;
889 
890     // Mapping owner address to address data.
891     //
892     // Bits Layout:
893     // - [0..63]    `balance`
894     // - [64..127]  `numberMinted`
895     // - [128..191] `numberBurned`
896     // - [192..255] `aux`
897     mapping(address => uint256) private _packedAddressData;
898 
899     // Mapping from token ID to approved address.
900     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
901 
902     // Mapping from owner to operator approvals
903     mapping(address => mapping(address => bool)) private _operatorApprovals;
904 
905     // =============================================================
906     //                          CONSTRUCTOR
907     // =============================================================
908 
909     constructor(string memory name_, string memory symbol_) {
910         _name = name_;
911         _symbol = symbol_;
912         _currentIndex = _startTokenId();
913     }
914 
915     // =============================================================
916     //                   TOKEN COUNTING OPERATIONS
917     // =============================================================
918 
919     /**
920      * @dev Returns the starting token ID.
921      * To change the starting token ID, please override this function.
922      */
923     function _startTokenId() internal view virtual returns (uint256) {
924         return 0;
925     }
926 
927     /**
928      * @dev Returns the next token ID to be minted.
929      */
930     function _nextTokenId() internal view virtual returns (uint256) {
931         return _currentIndex;
932     }
933 
934     /**
935      * @dev Returns the total number of tokens in existence.
936      * Burned tokens will reduce the count.
937      * To get the total number of tokens minted, please see {_totalMinted}.
938      */
939     function totalSupply() public view virtual override returns (uint256) {
940         // Counter underflow is impossible as _burnCounter cannot be incremented
941         // more than `_currentIndex - _startTokenId()` times.
942         unchecked {
943             return _currentIndex - _burnCounter - _startTokenId();
944         }
945     }
946 
947     /**
948      * @dev Returns the total amount of tokens minted in the contract.
949      */
950     function _totalMinted() internal view virtual returns (uint256) {
951         // Counter underflow is impossible as `_currentIndex` does not decrement,
952         // and it is initialized to `_startTokenId()`.
953         unchecked {
954             return _currentIndex - _startTokenId();
955         }
956     }
957 
958     /**
959      * @dev Returns the total number of tokens burned.
960      */
961     function _totalBurned() internal view virtual returns (uint256) {
962         return _burnCounter;
963     }
964 
965     // =============================================================
966     //                    ADDRESS DATA OPERATIONS
967     // =============================================================
968 
969     /**
970      * @dev Returns the number of tokens in `owner`'s account.
971      */
972     function balanceOf(address owner) public view virtual override returns (uint256) {
973         if (owner == address(0)) revert BalanceQueryForZeroAddress();
974         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
975     }
976 
977     /**
978      * Returns the number of tokens minted by `owner`.
979      */
980     function _numberMinted(address owner) internal view returns (uint256) {
981         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
982     }
983 
984     /**
985      * Returns the number of tokens burned by or on behalf of `owner`.
986      */
987     function _numberBurned(address owner) internal view returns (uint256) {
988         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
989     }
990 
991     /**
992      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
993      */
994     function _getAux(address owner) internal view returns (uint64) {
995         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
996     }
997 
998     /**
999      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1000      * If there are multiple variables, please pack them into a uint64.
1001      */
1002     function _setAux(address owner, uint64 aux) internal virtual {
1003         uint256 packed = _packedAddressData[owner];
1004         uint256 auxCasted;
1005         // Cast `aux` with assembly to avoid redundant masking.
1006         assembly {
1007             auxCasted := aux
1008         }
1009         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1010         _packedAddressData[owner] = packed;
1011     }
1012 
1013     // =============================================================
1014     //                            IERC165
1015     // =============================================================
1016 
1017     /**
1018      * @dev Returns true if this contract implements the interface defined by
1019      * `interfaceId`. See the corresponding
1020      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1021      * to learn more about how these ids are created.
1022      *
1023      * This function call must use less than 30000 gas.
1024      */
1025     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1026         // The interface IDs are constants representing the first 4 bytes
1027         // of the XOR of all function selectors in the interface.
1028         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1029         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1030         return
1031             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1032             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1033             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1034     }
1035 
1036     // =============================================================
1037     //                        IERC721Metadata
1038     // =============================================================
1039 
1040     /**
1041      * @dev Returns the token collection name.
1042      */
1043     function name() public view virtual override returns (string memory) {
1044         return _name;
1045     }
1046 
1047     /**
1048      * @dev Returns the token collection symbol.
1049      */
1050     function symbol() public view virtual override returns (string memory) {
1051         return _symbol;
1052     }
1053 
1054     /**
1055      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1056      */
1057     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1058         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1059 
1060         string memory baseURI = _baseURI();
1061         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1062     }
1063 
1064     /**
1065      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1066      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1067      * by default, it can be overridden in child contracts.
1068      */
1069     function _baseURI() internal view virtual returns (string memory) {
1070         return '';
1071     }
1072 
1073     // =============================================================
1074     //                     OWNERSHIPS OPERATIONS
1075     // =============================================================
1076 
1077     /**
1078      * @dev Returns the owner of the `tokenId` token.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must exist.
1083      */
1084     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1085         return address(uint160(_packedOwnershipOf(tokenId)));
1086     }
1087 
1088     /**
1089      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1090      * It gradually moves to O(1) as tokens get transferred around over time.
1091      */
1092     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1093         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1094     }
1095 
1096     /**
1097      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1098      */
1099     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1100         return _unpackedOwnership(_packedOwnerships[index]);
1101     }
1102 
1103     /**
1104      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1105      */
1106     function _initializeOwnershipAt(uint256 index) internal virtual {
1107         if (_packedOwnerships[index] == 0) {
1108             _packedOwnerships[index] = _packedOwnershipOf(index);
1109         }
1110     }
1111 
1112     /**
1113      * Returns the packed ownership data of `tokenId`.
1114      */
1115     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1116         uint256 curr = tokenId;
1117 
1118         unchecked {
1119             if (_startTokenId() <= curr)
1120                 if (curr < _currentIndex) {
1121                     uint256 packed = _packedOwnerships[curr];
1122                     // If not burned.
1123                     if (packed & _BITMASK_BURNED == 0) {
1124                         // Invariant:
1125                         // There will always be an initialized ownership slot
1126                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1127                         // before an unintialized ownership slot
1128                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1129                         // Hence, `curr` will not underflow.
1130                         //
1131                         // We can directly compare the packed value.
1132                         // If the address is zero, packed will be zero.
1133                         while (packed == 0) {
1134                             packed = _packedOwnerships[--curr];
1135                         }
1136                         return packed;
1137                     }
1138                 }
1139         }
1140         revert OwnerQueryForNonexistentToken();
1141     }
1142 
1143     /**
1144      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1145      */
1146     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1147         ownership.addr = address(uint160(packed));
1148         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1149         ownership.burned = packed & _BITMASK_BURNED != 0;
1150         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1151     }
1152 
1153     /**
1154      * @dev Packs ownership data into a single uint256.
1155      */
1156     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1157         assembly {
1158             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1159             owner := and(owner, _BITMASK_ADDRESS)
1160             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1161             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1162         }
1163     }
1164 
1165     /**
1166      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1167      */
1168     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1169         // For branchless setting of the `nextInitialized` flag.
1170         assembly {
1171             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1172             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1173         }
1174     }
1175 
1176     // =============================================================
1177     //                      APPROVAL OPERATIONS
1178     // =============================================================
1179 
1180     /**
1181      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1182      * The approval is cleared when the token is transferred.
1183      *
1184      * Only a single account can be approved at a time, so approving the
1185      * zero address clears previous approvals.
1186      *
1187      * Requirements:
1188      *
1189      * - The caller must own the token or be an approved operator.
1190      * - `tokenId` must exist.
1191      *
1192      * Emits an {Approval} event.
1193      */
1194     function approve(address to, uint256 tokenId) public payable virtual override {
1195         address owner = ownerOf(tokenId);
1196 
1197         if (_msgSenderERC721A() != owner)
1198             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1199                 revert ApprovalCallerNotOwnerNorApproved();
1200             }
1201 
1202         _tokenApprovals[tokenId].value = to;
1203         emit Approval(owner, to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev Returns the account approved for `tokenId` token.
1208      *
1209      * Requirements:
1210      *
1211      * - `tokenId` must exist.
1212      */
1213     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1214         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1215 
1216         return _tokenApprovals[tokenId].value;
1217     }
1218 
1219     /**
1220      * @dev Approve or remove `operator` as an operator for the caller.
1221      * Operators can call {transferFrom} or {safeTransferFrom}
1222      * for any token owned by the caller.
1223      *
1224      * Requirements:
1225      *
1226      * - The `operator` cannot be the caller.
1227      *
1228      * Emits an {ApprovalForAll} event.
1229      */
1230     function setApprovalForAll(address operator, bool approved) public virtual override {
1231         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1232         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1233     }
1234 
1235     /**
1236      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1237      *
1238      * See {setApprovalForAll}.
1239      */
1240     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1241         return _operatorApprovals[owner][operator];
1242     }
1243 
1244     /**
1245      * @dev Returns whether `tokenId` exists.
1246      *
1247      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1248      *
1249      * Tokens start existing when they are minted. See {_mint}.
1250      */
1251     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1252         return
1253             _startTokenId() <= tokenId &&
1254             tokenId < _currentIndex && // If within bounds,
1255             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1256     }
1257 
1258     /**
1259      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1260      */
1261     function _isSenderApprovedOrOwner(
1262         address approvedAddress,
1263         address owner,
1264         address msgSender
1265     ) private pure returns (bool result) {
1266         assembly {
1267             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1268             owner := and(owner, _BITMASK_ADDRESS)
1269             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1270             msgSender := and(msgSender, _BITMASK_ADDRESS)
1271             // `msgSender == owner || msgSender == approvedAddress`.
1272             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1273         }
1274     }
1275 
1276     /**
1277      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1278      */
1279     function _getApprovedSlotAndAddress(uint256 tokenId)
1280         private
1281         view
1282         returns (uint256 approvedAddressSlot, address approvedAddress)
1283     {
1284         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1285         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1286         assembly {
1287             approvedAddressSlot := tokenApproval.slot
1288             approvedAddress := sload(approvedAddressSlot)
1289         }
1290     }
1291 
1292     // =============================================================
1293     //                      TRANSFER OPERATIONS
1294     // =============================================================
1295 
1296     /**
1297      * @dev Transfers `tokenId` from `from` to `to`.
1298      *
1299      * Requirements:
1300      *
1301      * - `from` cannot be the zero address.
1302      * - `to` cannot be the zero address.
1303      * - `tokenId` token must be owned by `from`.
1304      * - If the caller is not `from`, it must be approved to move this token
1305      * by either {approve} or {setApprovalForAll}.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function transferFrom(
1310         address from,
1311         address to,
1312         uint256 tokenId
1313     ) public payable virtual override {
1314         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1315 
1316         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1317 
1318         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1319 
1320         // The nested ifs save around 20+ gas over a compound boolean condition.
1321         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1322             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1323 
1324         if (to == address(0)) revert TransferToZeroAddress();
1325 
1326         _beforeTokenTransfers(from, to, tokenId, 1);
1327 
1328         // Clear approvals from the previous owner.
1329         assembly {
1330             if approvedAddress {
1331                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1332                 sstore(approvedAddressSlot, 0)
1333             }
1334         }
1335 
1336         // Underflow of the sender's balance is impossible because we check for
1337         // ownership above and the recipient's balance can't realistically overflow.
1338         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1339         unchecked {
1340             // We can directly increment and decrement the balances.
1341             --_packedAddressData[from]; // Updates: `balance -= 1`.
1342             ++_packedAddressData[to]; // Updates: `balance += 1`.
1343 
1344             // Updates:
1345             // - `address` to the next owner.
1346             // - `startTimestamp` to the timestamp of transfering.
1347             // - `burned` to `false`.
1348             // - `nextInitialized` to `true`.
1349             _packedOwnerships[tokenId] = _packOwnershipData(
1350                 to,
1351                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1352             );
1353 
1354             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1355             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1356                 uint256 nextTokenId = tokenId + 1;
1357                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1358                 if (_packedOwnerships[nextTokenId] == 0) {
1359                     // If the next slot is within bounds.
1360                     if (nextTokenId != _currentIndex) {
1361                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1362                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1363                     }
1364                 }
1365             }
1366         }
1367 
1368         emit Transfer(from, to, tokenId);
1369         _afterTokenTransfers(from, to, tokenId, 1);
1370     }
1371 
1372     /**
1373      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1374      */
1375     function safeTransferFrom(
1376         address from,
1377         address to,
1378         uint256 tokenId
1379     ) public payable virtual override {
1380         safeTransferFrom(from, to, tokenId, '');
1381     }
1382 
1383     /**
1384      * @dev Safely transfers `tokenId` token from `from` to `to`.
1385      *
1386      * Requirements:
1387      *
1388      * - `from` cannot be the zero address.
1389      * - `to` cannot be the zero address.
1390      * - `tokenId` token must exist and be owned by `from`.
1391      * - If the caller is not `from`, it must be approved to move this token
1392      * by either {approve} or {setApprovalForAll}.
1393      * - If `to` refers to a smart contract, it must implement
1394      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1395      *
1396      * Emits a {Transfer} event.
1397      */
1398     function safeTransferFrom(
1399         address from,
1400         address to,
1401         uint256 tokenId,
1402         bytes memory _data
1403     ) public payable virtual override {
1404         transferFrom(from, to, tokenId);
1405         if (to.code.length != 0)
1406             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1407                 revert TransferToNonERC721ReceiverImplementer();
1408             }
1409     }
1410 
1411     /**
1412      * @dev Hook that is called before a set of serially-ordered token IDs
1413      * are about to be transferred. This includes minting.
1414      * And also called before burning one token.
1415      *
1416      * `startTokenId` - the first token ID to be transferred.
1417      * `quantity` - the amount to be transferred.
1418      *
1419      * Calling conditions:
1420      *
1421      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1422      * transferred to `to`.
1423      * - When `from` is zero, `tokenId` will be minted for `to`.
1424      * - When `to` is zero, `tokenId` will be burned by `from`.
1425      * - `from` and `to` are never both zero.
1426      */
1427     function _beforeTokenTransfers(
1428         address from,
1429         address to,
1430         uint256 startTokenId,
1431         uint256 quantity
1432     ) internal virtual {}
1433 
1434     /**
1435      * @dev Hook that is called after a set of serially-ordered token IDs
1436      * have been transferred. This includes minting.
1437      * And also called after one token has been burned.
1438      *
1439      * `startTokenId` - the first token ID to be transferred.
1440      * `quantity` - the amount to be transferred.
1441      *
1442      * Calling conditions:
1443      *
1444      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1445      * transferred to `to`.
1446      * - When `from` is zero, `tokenId` has been minted for `to`.
1447      * - When `to` is zero, `tokenId` has been burned by `from`.
1448      * - `from` and `to` are never both zero.
1449      */
1450     function _afterTokenTransfers(
1451         address from,
1452         address to,
1453         uint256 startTokenId,
1454         uint256 quantity
1455     ) internal virtual {}
1456 
1457     /**
1458      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1459      *
1460      * `from` - Previous owner of the given token ID.
1461      * `to` - Target address that will receive the token.
1462      * `tokenId` - Token ID to be transferred.
1463      * `_data` - Optional data to send along with the call.
1464      *
1465      * Returns whether the call correctly returned the expected magic value.
1466      */
1467     function _checkContractOnERC721Received(
1468         address from,
1469         address to,
1470         uint256 tokenId,
1471         bytes memory _data
1472     ) private returns (bool) {
1473         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1474             bytes4 retval
1475         ) {
1476             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1477         } catch (bytes memory reason) {
1478             if (reason.length == 0) {
1479                 revert TransferToNonERC721ReceiverImplementer();
1480             } else {
1481                 assembly {
1482                     revert(add(32, reason), mload(reason))
1483                 }
1484             }
1485         }
1486     }
1487 
1488     // =============================================================
1489     //                        MINT OPERATIONS
1490     // =============================================================
1491 
1492     /**
1493      * @dev Mints `quantity` tokens and transfers them to `to`.
1494      *
1495      * Requirements:
1496      *
1497      * - `to` cannot be the zero address.
1498      * - `quantity` must be greater than 0.
1499      *
1500      * Emits a {Transfer} event for each mint.
1501      */
1502     function _mint(address to, uint256 quantity) internal virtual {
1503         uint256 startTokenId = _currentIndex;
1504         if (quantity == 0) revert MintZeroQuantity();
1505 
1506         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1507 
1508         // Overflows are incredibly unrealistic.
1509         // `balance` and `numberMinted` have a maximum limit of 2**64.
1510         // `tokenId` has a maximum limit of 2**256.
1511         unchecked {
1512             // Updates:
1513             // - `balance += quantity`.
1514             // - `numberMinted += quantity`.
1515             //
1516             // We can directly add to the `balance` and `numberMinted`.
1517             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1518 
1519             // Updates:
1520             // - `address` to the owner.
1521             // - `startTimestamp` to the timestamp of minting.
1522             // - `burned` to `false`.
1523             // - `nextInitialized` to `quantity == 1`.
1524             _packedOwnerships[startTokenId] = _packOwnershipData(
1525                 to,
1526                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1527             );
1528 
1529             uint256 toMasked;
1530             uint256 end = startTokenId + quantity;
1531 
1532             // Use assembly to loop and emit the `Transfer` event for gas savings.
1533             // The duplicated `log4` removes an extra check and reduces stack juggling.
1534             // The assembly, together with the surrounding Solidity code, have been
1535             // delicately arranged to nudge the compiler into producing optimized opcodes.
1536             assembly {
1537                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1538                 toMasked := and(to, _BITMASK_ADDRESS)
1539                 // Emit the `Transfer` event.
1540                 log4(
1541                     0, // Start of data (0, since no data).
1542                     0, // End of data (0, since no data).
1543                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1544                     0, // `address(0)`.
1545                     toMasked, // `to`.
1546                     startTokenId // `tokenId`.
1547                 )
1548 
1549                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1550                 // that overflows uint256 will make the loop run out of gas.
1551                 // The compiler will optimize the `iszero` away for performance.
1552                 for {
1553                     let tokenId := add(startTokenId, 1)
1554                 } iszero(eq(tokenId, end)) {
1555                     tokenId := add(tokenId, 1)
1556                 } {
1557                     // Emit the `Transfer` event. Similar to above.
1558                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1559                 }
1560             }
1561             if (toMasked == 0) revert MintToZeroAddress();
1562 
1563             _currentIndex = end;
1564         }
1565         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1566     }
1567 
1568     /**
1569      * @dev Mints `quantity` tokens and transfers them to `to`.
1570      *
1571      * This function is intended for efficient minting only during contract creation.
1572      *
1573      * It emits only one {ConsecutiveTransfer} as defined in
1574      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1575      * instead of a sequence of {Transfer} event(s).
1576      *
1577      * Calling this function outside of contract creation WILL make your contract
1578      * non-compliant with the ERC721 standard.
1579      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1580      * {ConsecutiveTransfer} event is only permissible during contract creation.
1581      *
1582      * Requirements:
1583      *
1584      * - `to` cannot be the zero address.
1585      * - `quantity` must be greater than 0.
1586      *
1587      * Emits a {ConsecutiveTransfer} event.
1588      */
1589     function _mintERC2309(address to, uint256 quantity) internal virtual {
1590         uint256 startTokenId = _currentIndex;
1591         if (to == address(0)) revert MintToZeroAddress();
1592         if (quantity == 0) revert MintZeroQuantity();
1593         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1594 
1595         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1596 
1597         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1598         unchecked {
1599             // Updates:
1600             // - `balance += quantity`.
1601             // - `numberMinted += quantity`.
1602             //
1603             // We can directly add to the `balance` and `numberMinted`.
1604             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1605 
1606             // Updates:
1607             // - `address` to the owner.
1608             // - `startTimestamp` to the timestamp of minting.
1609             // - `burned` to `false`.
1610             // - `nextInitialized` to `quantity == 1`.
1611             _packedOwnerships[startTokenId] = _packOwnershipData(
1612                 to,
1613                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1614             );
1615 
1616             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1617 
1618             _currentIndex = startTokenId + quantity;
1619         }
1620         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1621     }
1622 
1623     /**
1624      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1625      *
1626      * Requirements:
1627      *
1628      * - If `to` refers to a smart contract, it must implement
1629      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1630      * - `quantity` must be greater than 0.
1631      *
1632      * See {_mint}.
1633      *
1634      * Emits a {Transfer} event for each mint.
1635      */
1636     function _safeMint(
1637         address to,
1638         uint256 quantity,
1639         bytes memory _data
1640     ) internal virtual {
1641         _mint(to, quantity);
1642 
1643         unchecked {
1644             if (to.code.length != 0) {
1645                 uint256 end = _currentIndex;
1646                 uint256 index = end - quantity;
1647                 do {
1648                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1649                         revert TransferToNonERC721ReceiverImplementer();
1650                     }
1651                 } while (index < end);
1652                 // Reentrancy protection.
1653                 if (_currentIndex != end) revert();
1654             }
1655         }
1656     }
1657 
1658     /**
1659      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1660      */
1661     function _safeMint(address to, uint256 quantity) internal virtual {
1662         _safeMint(to, quantity, '');
1663     }
1664 
1665     // =============================================================
1666     //                        BURN OPERATIONS
1667     // =============================================================
1668 
1669     /**
1670      * @dev Equivalent to `_burn(tokenId, false)`.
1671      */
1672     function _burn(uint256 tokenId) internal virtual {
1673         _burn(tokenId, false);
1674     }
1675 
1676     /**
1677      * @dev Destroys `tokenId`.
1678      * The approval is cleared when the token is burned.
1679      *
1680      * Requirements:
1681      *
1682      * - `tokenId` must exist.
1683      *
1684      * Emits a {Transfer} event.
1685      */
1686     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1687         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1688 
1689         address from = address(uint160(prevOwnershipPacked));
1690 
1691         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1692 
1693         if (approvalCheck) {
1694             // The nested ifs save around 20+ gas over a compound boolean condition.
1695             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1696                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1697         }
1698 
1699         _beforeTokenTransfers(from, address(0), tokenId, 1);
1700 
1701         // Clear approvals from the previous owner.
1702         assembly {
1703             if approvedAddress {
1704                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1705                 sstore(approvedAddressSlot, 0)
1706             }
1707         }
1708 
1709         // Underflow of the sender's balance is impossible because we check for
1710         // ownership above and the recipient's balance can't realistically overflow.
1711         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1712         unchecked {
1713             // Updates:
1714             // - `balance -= 1`.
1715             // - `numberBurned += 1`.
1716             //
1717             // We can directly decrement the balance, and increment the number burned.
1718             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1719             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1720 
1721             // Updates:
1722             // - `address` to the last owner.
1723             // - `startTimestamp` to the timestamp of burning.
1724             // - `burned` to `true`.
1725             // - `nextInitialized` to `true`.
1726             _packedOwnerships[tokenId] = _packOwnershipData(
1727                 from,
1728                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1729             );
1730 
1731             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1732             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1733                 uint256 nextTokenId = tokenId + 1;
1734                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1735                 if (_packedOwnerships[nextTokenId] == 0) {
1736                     // If the next slot is within bounds.
1737                     if (nextTokenId != _currentIndex) {
1738                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1739                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1740                     }
1741                 }
1742             }
1743         }
1744 
1745         emit Transfer(from, address(0), tokenId);
1746         _afterTokenTransfers(from, address(0), tokenId, 1);
1747 
1748         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1749         unchecked {
1750             _burnCounter++;
1751         }
1752     }
1753 
1754     // =============================================================
1755     //                     EXTRA DATA OPERATIONS
1756     // =============================================================
1757 
1758     /**
1759      * @dev Directly sets the extra data for the ownership data `index`.
1760      */
1761     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1762         uint256 packed = _packedOwnerships[index];
1763         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1764         uint256 extraDataCasted;
1765         // Cast `extraData` with assembly to avoid redundant masking.
1766         assembly {
1767             extraDataCasted := extraData
1768         }
1769         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1770         _packedOwnerships[index] = packed;
1771     }
1772 
1773     /**
1774      * @dev Called during each token transfer to set the 24bit `extraData` field.
1775      * Intended to be overridden by the cosumer contract.
1776      *
1777      * `previousExtraData` - the value of `extraData` before transfer.
1778      *
1779      * Calling conditions:
1780      *
1781      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1782      * transferred to `to`.
1783      * - When `from` is zero, `tokenId` will be minted for `to`.
1784      * - When `to` is zero, `tokenId` will be burned by `from`.
1785      * - `from` and `to` are never both zero.
1786      */
1787     function _extraData(
1788         address from,
1789         address to,
1790         uint24 previousExtraData
1791     ) internal view virtual returns (uint24) {}
1792 
1793     /**
1794      * @dev Returns the next extra data for the packed ownership data.
1795      * The returned result is shifted into position.
1796      */
1797     function _nextExtraData(
1798         address from,
1799         address to,
1800         uint256 prevOwnershipPacked
1801     ) private view returns (uint256) {
1802         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1803         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1804     }
1805 
1806     // =============================================================
1807     //                       OTHER OPERATIONS
1808     // =============================================================
1809 
1810     /**
1811      * @dev Returns the message sender (defaults to `msg.sender`).
1812      *
1813      * If you are writing GSN compatible contracts, you need to override this function.
1814      */
1815     function _msgSenderERC721A() internal view virtual returns (address) {
1816         return msg.sender;
1817     }
1818 
1819     /**
1820      * @dev Converts a uint256 to its ASCII string decimal representation.
1821      */
1822     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1823         assembly {
1824             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1825             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1826             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1827             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1828             let m := add(mload(0x40), 0xa0)
1829             // Update the free memory pointer to allocate.
1830             mstore(0x40, m)
1831             // Assign the `str` to the end.
1832             str := sub(m, 0x20)
1833             // Zeroize the slot after the string.
1834             mstore(str, 0)
1835 
1836             // Cache the end of the memory to calculate the length later.
1837             let end := str
1838 
1839             // We write the string from rightmost digit to leftmost digit.
1840             // The following is essentially a do-while loop that also handles the zero case.
1841             // prettier-ignore
1842             for { let temp := value } 1 {} {
1843                 str := sub(str, 1)
1844                 // Write the character to the pointer.
1845                 // The ASCII index of the '0' character is 48.
1846                 mstore8(str, add(48, mod(temp, 10)))
1847                 // Keep dividing `temp` until zero.
1848                 temp := div(temp, 10)
1849                 // prettier-ignore
1850                 if iszero(temp) { break }
1851             }
1852 
1853             let length := sub(end, str)
1854             // Move the pointer 32 bytes leftwards to make room for the length.
1855             str := sub(str, 0x20)
1856             // Store the length.
1857             mstore(str, length)
1858         }
1859     }
1860 }
1861 
1862 // File: contracts/BYCM.sol
1863 
1864 
1865 
1866 
1867 
1868 
1869 
1870 
1871 
1872 
1873 pragma solidity ^0.8.4;
1874 
1875 
1876 
1877 
1878 
1879 
1880 contract BoredMachine is Ownable, ERC721A, ReentrancyGuard {
1881 
1882     
1883     uint256 constant public MaxSupply = 8000;
1884     
1885 
1886     uint256 public publicPrice = 0.0015 ether;
1887 
1888     uint256 constant public MaxPerTX = 10;
1889     uint256 constant public MaxPerWallet = 100;
1890 
1891     string public revealedURI;
1892     string private hiddenURI;
1893 
1894     
1895 
1896     bool public paused = false;
1897     bool public revealed = false;
1898     bool public publicSale = false;
1899 
1900     
1901     
1902     
1903     
1904 
1905     
1906     mapping(address => uint256) public numUserMints;
1907 
1908     constructor(string memory _name, string memory _symbol, string memory _baseUri, string memory _hiddenMetadataUri) ERC721A("Bored Machine", "BRDMCH") { }
1909 
1910     function Ownermint(uint256 quantity, address receiver) public onlyOwner mintCompliance(quantity) {
1911         _safeMint(receiver, quantity);
1912     }
1913 
1914     function _startTokenId() internal view virtual override returns (uint256) {
1915         return 1;
1916     }
1917 
1918     
1919     modifier mintCompliance(uint256 quantity) { 
1920         require(!paused, "Contract is paused");
1921         require(totalSupply() + quantity <= MaxSupply, "Not enough mints left");
1922         require(tx.origin == msg.sender, "No contract minting");
1923         _;
1924     }
1925 
1926     function ThePrice(uint256 price) private {
1927        if (msg.value < price) {
1928             revert("Not enough ETH sent");
1929         }
1930     }
1931 
1932     function publicMint(uint256 quantity) external payable mintCompliance(quantity) {
1933         require(publicSale, "Public sale inactive");
1934         require(quantity <= MaxPerTX, "Quantity too high");
1935 
1936         uint256 price = publicPrice;
1937         uint256 currMints = numUserMints[msg.sender];
1938                 
1939         
1940         ThePrice(price * quantity);
1941 
1942         numUserMints[msg.sender] = (currMints + quantity);
1943 
1944         _safeMint(msg.sender, quantity);
1945     }
1946 
1947     
1948     function walletOfOwner(address _owner) public view returns (uint256[] memory)
1949     {
1950         uint256 ownerTokenCount = balanceOf(_owner);
1951         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1952         uint256 currentTokenId = 1;
1953         uint256 ownedTokenIndex = 0;
1954 
1955         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MaxSupply) {
1956             address currentTokenOwner = ownerOf(currentTokenId);
1957 
1958             if (currentTokenOwner == _owner) {
1959                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1960 
1961                 ownedTokenIndex++;
1962             }
1963 
1964         currentTokenId++;
1965         }
1966 
1967         return ownedTokenIds;
1968     }
1969 
1970     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1971         
1972         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1973         
1974         if (revealed) {
1975             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
1976         }
1977         else {
1978             return hiddenURI;
1979         }
1980     }
1981   
1982     function revealCollection(bool _revealed, string memory _baseUri) public onlyOwner {
1983         revealed = _revealed;
1984         revealedURI = _baseUri;
1985     }
1986 
1987     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1988         hiddenURI = _hiddenMetadataUri;
1989     }
1990 
1991   function setRevealed(bool _state) public onlyOwner {
1992         revealed = _state;
1993     }
1994   function setBaseURI(string memory _baseUri) public onlyOwner {
1995         revealedURI = _baseUri;
1996     }
1997 
1998     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
1999         publicPrice = _publicPrice;
2000     }
2001 
2002     function setPaused(bool _state) public onlyOwner {
2003         paused = _state;
2004     }
2005 
2006     function setPublicEnabled(bool _state) public onlyOwner {
2007         publicSale = _state;
2008     }
2009     
2010     function withdraw() external onlyOwner nonReentrant {
2011         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2012         require(success, "Transfer failed.");
2013     }
2014 
2015 }