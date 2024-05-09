1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12     uint8 private constant _ADDRESS_LENGTH = 20;
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 
70     /**
71      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
72      */
73     function toHexString(address addr) internal pure returns (string memory) {
74         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Address.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
82 
83 pragma solidity ^0.8.1;
84 
85 /**
86  * @dev Collection of functions related to the address type
87  */
88 library Address {
89     /**
90      * @dev Returns true if `account` is a contract.
91      *
92      * [IMPORTANT]
93      * ====
94      * It is unsafe to assume that an address for which this function returns
95      * false is an externally-owned account (EOA) and not a contract.
96      *
97      * Among others, `isContract` will return false for the following
98      * types of addresses:
99      *
100      *  - an externally-owned account
101      *  - a contract in construction
102      *  - an address where a contract will be created
103      *  - an address where a contract lived, but was destroyed
104      * ====
105      *
106      * [IMPORTANT]
107      * ====
108      * You shouldn't rely on `isContract` to protect against flash loan attacks!
109      *
110      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
111      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
112      * constructor.
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize/address.code.length, which returns 0
117         // for contracts in construction, since the code is only stored at the end
118         // of the constructor execution.
119 
120         return account.code.length > 0;
121     }
122 
123     /**
124      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
125      * `recipient`, forwarding all available gas and reverting on errors.
126      *
127      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
128      * of certain opcodes, possibly making contracts go over the 2300 gas limit
129      * imposed by `transfer`, making them unable to receive funds via
130      * `transfer`. {sendValue} removes this limitation.
131      *
132      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
133      *
134      * IMPORTANT: because control is transferred to `recipient`, care must be
135      * taken to not create reentrancy vulnerabilities. Consider using
136      * {ReentrancyGuard} or the
137      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
138      */
139     function sendValue(address payable recipient, uint256 amount) internal {
140         require(address(this).balance >= amount, "Address: insufficient balance");
141 
142         (bool success, ) = recipient.call{value: amount}("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain `call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but also transferring `value` wei to `target`.
185      *
186      * Requirements:
187      *
188      * - the calling contract must have an ETH balance of at least `value`.
189      * - the called Solidity function must be `payable`.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
203      * with `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         require(isContract(target), "Address: call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.call{value: value}(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal view returns (bytes memory) {
241         require(isContract(target), "Address: static call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.staticcall(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(isContract(target), "Address: delegate call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.delegatecall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
276      * revert reason using the provided one.
277      *
278      * _Available since v4.3._
279      */
280     function verifyCallResult(
281         bool success,
282         bytes memory returndata,
283         string memory errorMessage
284     ) internal pure returns (bytes memory) {
285         if (success) {
286             return returndata;
287         } else {
288             // Look for revert reason and bubble it up if present
289             if (returndata.length > 0) {
290                 // The easiest way to bubble the revert reason is using memory via assembly
291                 /// @solidity memory-safe-assembly
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 
303 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Contract module that helps prevent reentrant calls to a function.
312  *
313  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
314  * available, which can be applied to functions to make sure there are no nested
315  * (reentrant) calls to them.
316  *
317  * Note that because there is a single `nonReentrant` guard, functions marked as
318  * `nonReentrant` may not call one another. This can be worked around by making
319  * those functions `private`, and then adding `external` `nonReentrant` entry
320  * points to them.
321  *
322  * TIP: If you would like to learn more about reentrancy and alternative ways
323  * to protect against it, check out our blog post
324  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
325  */
326 abstract contract ReentrancyGuard {
327     // Booleans are more expensive than uint256 or any type that takes up a full
328     // word because each write operation emits an extra SLOAD to first read the
329     // slot's contents, replace the bits taken up by the boolean, and then write
330     // back. This is the compiler's defense against contract upgrades and
331     // pointer aliasing, and it cannot be disabled.
332 
333     // The values being non-zero value makes deployment a bit more expensive,
334     // but in exchange the refund on every call to nonReentrant will be lower in
335     // amount. Since refunds are capped to a percentage of the total
336     // transaction's gas, it is best to keep them low in cases like this one, to
337     // increase the likelihood of the full refund coming into effect.
338     uint256 private constant _NOT_ENTERED = 1;
339     uint256 private constant _ENTERED = 2;
340 
341     uint256 private _status;
342 
343     constructor() {
344         _status = _NOT_ENTERED;
345     }
346 
347     /**
348      * @dev Prevents a contract from calling itself, directly or indirectly.
349      * Calling a `nonReentrant` function from another `nonReentrant`
350      * function is not supported. It is possible to prevent this from happening
351      * by making the `nonReentrant` function external, and making it call a
352      * `private` function that does the actual work.
353      */
354     modifier nonReentrant() {
355         // On the first call to nonReentrant, _notEntered will be true
356         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
357 
358         // Any calls to nonReentrant after this point will fail
359         _status = _ENTERED;
360 
361         _;
362 
363         // By storing the original value once again, a refund is triggered (see
364         // https://eips.ethereum.org/EIPS/eip-2200)
365         _status = _NOT_ENTERED;
366     }
367 }
368 
369 // File: @openzeppelin/contracts/utils/Context.sol
370 
371 
372 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Provides information about the current execution context, including the
378  * sender of the transaction and its data. While these are generally available
379  * via msg.sender and msg.data, they should not be accessed in such a direct
380  * manner, since when dealing with meta-transactions the account sending and
381  * paying for execution may not be the actual sender (as far as an application
382  * is concerned).
383  *
384  * This contract is only required for intermediate, library-like contracts.
385  */
386 abstract contract Context {
387     function _msgSender() internal view virtual returns (address) {
388         return msg.sender;
389     }
390 
391     function _msgData() internal view virtual returns (bytes calldata) {
392         return msg.data;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/access/Ownable.sol
397 
398 
399 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev Contract module which provides a basic access control mechanism, where
406  * there is an account (an owner) that can be granted exclusive access to
407  * specific functions.
408  *
409  * By default, the owner account will be the one that deploys the contract. This
410  * can later be changed with {transferOwnership}.
411  *
412  * This module is used through inheritance. It will make available the modifier
413  * `onlyOwner`, which can be applied to your functions to restrict their use to
414  * the owner.
415  */
416 abstract contract Ownable is Context {
417     address private _owner;
418 
419     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
420 
421     /**
422      * @dev Initializes the contract setting the deployer as the initial owner.
423      */
424     constructor() {
425         _transferOwnership(_msgSender());
426     }
427 
428     /**
429      * @dev Throws if called by any account other than the owner.
430      */
431     modifier onlyOwner() {
432         _checkOwner();
433         _;
434     }
435 
436     /**
437      * @dev Returns the address of the current owner.
438      */
439     function owner() public view virtual returns (address) {
440         return _owner;
441     }
442 
443     /**
444      * @dev Throws if the sender is not the owner.
445      */
446     function _checkOwner() internal view virtual {
447         require(owner() == _msgSender(), "Ownable: caller is not the owner");
448     }
449 
450     /**
451      * @dev Leaves the contract without owner. It will not be possible to call
452      * `onlyOwner` functions anymore. Can only be called by the current owner.
453      *
454      * NOTE: Renouncing ownership will leave the contract without an owner,
455      * thereby removing any functionality that is only available to the owner.
456      */
457     function renounceOwnership() public virtual onlyOwner {
458         _transferOwnership(address(0));
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Can only be called by the current owner.
464      */
465     function transferOwnership(address newOwner) public virtual onlyOwner {
466         require(newOwner != address(0), "Ownable: new owner is the zero address");
467         _transferOwnership(newOwner);
468     }
469 
470     /**
471      * @dev Transfers ownership of the contract to a new account (`newOwner`).
472      * Internal function without access restriction.
473      */
474     function _transferOwnership(address newOwner) internal virtual {
475         address oldOwner = _owner;
476         _owner = newOwner;
477         emit OwnershipTransferred(oldOwner, newOwner);
478     }
479 }
480 
481 // File: erc721a/contracts/IERC721A.sol
482 
483 
484 // ERC721A Contracts v4.1.0
485 // Creator: Chiru Labs
486 
487 pragma solidity ^0.8.4;
488 
489 /**
490  * @dev Interface of an ERC721A compliant contract.
491  */
492 interface IERC721A {
493     /**
494      * The caller must own the token or be an approved operator.
495      */
496     error ApprovalCallerNotOwnerNorApproved();
497 
498     /**
499      * The token does not exist.
500      */
501     error ApprovalQueryForNonexistentToken();
502 
503     /**
504      * The caller cannot approve to their own address.
505      */
506     error ApproveToCaller();
507 
508     /**
509      * Cannot query the balance for the zero address.
510      */
511     error BalanceQueryForZeroAddress();
512 
513     /**
514      * Cannot mint to the zero address.
515      */
516     error MintToZeroAddress();
517 
518     /**
519      * The quantity of tokens minted must be more than zero.
520      */
521     error MintZeroQuantity();
522 
523     /**
524      * The token does not exist.
525      */
526     error OwnerQueryForNonexistentToken();
527 
528     /**
529      * The caller must own the token or be an approved operator.
530      */
531     error TransferCallerNotOwnerNorApproved();
532 
533     /**
534      * The token must be owned by `from`.
535      */
536     error TransferFromIncorrectOwner();
537 
538     /**
539      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
540      */
541     error TransferToNonERC721ReceiverImplementer();
542 
543     /**
544      * Cannot transfer to the zero address.
545      */
546     error TransferToZeroAddress();
547 
548     /**
549      * The token does not exist.
550      */
551     error URIQueryForNonexistentToken();
552 
553     /**
554      * The `quantity` minted with ERC2309 exceeds the safety limit.
555      */
556     error MintERC2309QuantityExceedsLimit();
557 
558     /**
559      * The `extraData` cannot be set on an unintialized ownership slot.
560      */
561     error OwnershipNotInitializedForExtraData();
562 
563     struct TokenOwnership {
564         // The address of the owner.
565         address addr;
566         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
567         uint64 startTimestamp;
568         // Whether the token has been burned.
569         bool burned;
570         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
571         uint24 extraData;
572     }
573 
574     /**
575      * @dev Returns the total amount of tokens stored by the contract.
576      *
577      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
578      */
579     function totalSupply() external view returns (uint256);
580 
581     // ==============================
582     //            IERC165
583     // ==============================
584 
585     /**
586      * @dev Returns true if this contract implements the interface defined by
587      * `interfaceId`. See the corresponding
588      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
589      * to learn more about how these ids are created.
590      *
591      * This function call must use less than 30 000 gas.
592      */
593     function supportsInterface(bytes4 interfaceId) external view returns (bool);
594 
595     // ==============================
596     //            IERC721
597     // ==============================
598 
599     /**
600      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
601      */
602     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
603 
604     /**
605      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
606      */
607     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
608 
609     /**
610      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
611      */
612     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
613 
614     /**
615      * @dev Returns the number of tokens in ``owner``'s account.
616      */
617     function balanceOf(address owner) external view returns (uint256 balance);
618 
619     /**
620      * @dev Returns the owner of the `tokenId` token.
621      *
622      * Requirements:
623      *
624      * - `tokenId` must exist.
625      */
626     function ownerOf(uint256 tokenId) external view returns (address owner);
627 
628     /**
629      * @dev Safely transfers `tokenId` token from `from` to `to`.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must exist and be owned by `from`.
636      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
637      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
638      *
639      * Emits a {Transfer} event.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 tokenId,
645         bytes calldata data
646     ) external;
647 
648     /**
649      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
650      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
651      *
652      * Requirements:
653      *
654      * - `from` cannot be the zero address.
655      * - `to` cannot be the zero address.
656      * - `tokenId` token must exist and be owned by `from`.
657      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
658      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
659      *
660      * Emits a {Transfer} event.
661      */
662     function safeTransferFrom(
663         address from,
664         address to,
665         uint256 tokenId
666     ) external;
667 
668     /**
669      * @dev Transfers `tokenId` token from `from` to `to`.
670      *
671      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
672      *
673      * Requirements:
674      *
675      * - `from` cannot be the zero address.
676      * - `to` cannot be the zero address.
677      * - `tokenId` token must be owned by `from`.
678      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
679      *
680      * Emits a {Transfer} event.
681      */
682     function transferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) external;
687 
688     /**
689      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
690      * The approval is cleared when the token is transferred.
691      *
692      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
693      *
694      * Requirements:
695      *
696      * - The caller must own the token or be an approved operator.
697      * - `tokenId` must exist.
698      *
699      * Emits an {Approval} event.
700      */
701     function approve(address to, uint256 tokenId) external;
702 
703     /**
704      * @dev Approve or remove `operator` as an operator for the caller.
705      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
706      *
707      * Requirements:
708      *
709      * - The `operator` cannot be the caller.
710      *
711      * Emits an {ApprovalForAll} event.
712      */
713     function setApprovalForAll(address operator, bool _approved) external;
714 
715     /**
716      * @dev Returns the account approved for `tokenId` token.
717      *
718      * Requirements:
719      *
720      * - `tokenId` must exist.
721      */
722     function getApproved(uint256 tokenId) external view returns (address operator);
723 
724     /**
725      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
726      *
727      * See {setApprovalForAll}
728      */
729     function isApprovedForAll(address owner, address operator) external view returns (bool);
730 
731     // ==============================
732     //        IERC721Metadata
733     // ==============================
734 
735     /**
736      * @dev Returns the token collection name.
737      */
738     function name() external view returns (string memory);
739 
740     /**
741      * @dev Returns the token collection symbol.
742      */
743     function symbol() external view returns (string memory);
744 
745     /**
746      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
747      */
748     function tokenURI(uint256 tokenId) external view returns (string memory);
749 
750     // ==============================
751     //            IERC2309
752     // ==============================
753 
754     /**
755      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
756      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
757      */
758     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
759 }
760 
761 // File: erc721a/contracts/ERC721A.sol
762 
763 
764 // ERC721A Contracts v4.1.0
765 // Creator: Chiru Labs
766 
767 pragma solidity ^0.8.4;
768 
769 
770 /**
771  * @dev ERC721 token receiver interface.
772  */
773 interface ERC721A__IERC721Receiver {
774     function onERC721Received(
775         address operator,
776         address from,
777         uint256 tokenId,
778         bytes calldata data
779     ) external returns (bytes4);
780 }
781 
782 /**
783  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
784  * including the Metadata extension. Built to optimize for lower gas during batch mints.
785  *
786  * Assumes serials are sequentially minted starting at `_startTokenId()`
787  * (defaults to 0, e.g. 0, 1, 2, 3..).
788  *
789  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
790  *
791  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
792  */
793 contract ERC721A is IERC721A {
794     // Mask of an entry in packed address data.
795     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
796 
797     // The bit position of `numberMinted` in packed address data.
798     uint256 private constant BITPOS_NUMBER_MINTED = 64;
799 
800     // The bit position of `numberBurned` in packed address data.
801     uint256 private constant BITPOS_NUMBER_BURNED = 128;
802 
803     // The bit position of `aux` in packed address data.
804     uint256 private constant BITPOS_AUX = 192;
805 
806     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
807     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
808 
809     // The bit position of `startTimestamp` in packed ownership.
810     uint256 private constant BITPOS_START_TIMESTAMP = 160;
811 
812     // The bit mask of the `burned` bit in packed ownership.
813     uint256 private constant BITMASK_BURNED = 1 << 224;
814 
815     // The bit position of the `nextInitialized` bit in packed ownership.
816     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
817 
818     // The bit mask of the `nextInitialized` bit in packed ownership.
819     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
820 
821     // The bit position of `extraData` in packed ownership.
822     uint256 private constant BITPOS_EXTRA_DATA = 232;
823 
824     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
825     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
826 
827     // The mask of the lower 160 bits for addresses.
828     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
829 
830     // The maximum `quantity` that can be minted with `_mintERC2309`.
831     // This limit is to prevent overflows on the address data entries.
832     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
833     // is required to cause an overflow, which is unrealistic.
834     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
835 
836     // The tokenId of the next token to be minted.
837     uint256 private _currentIndex;
838 
839     // The number of tokens burned.
840     uint256 private _burnCounter;
841 
842     // Token name
843     string private _name;
844 
845     // Token symbol
846     string private _symbol;
847 
848     // Mapping from token ID to ownership details
849     // An empty struct value does not necessarily mean the token is unowned.
850     // See `_packedOwnershipOf` implementation for details.
851     //
852     // Bits Layout:
853     // - [0..159]   `addr`
854     // - [160..223] `startTimestamp`
855     // - [224]      `burned`
856     // - [225]      `nextInitialized`
857     // - [232..255] `extraData`
858     mapping(uint256 => uint256) private _packedOwnerships;
859 
860     // Mapping owner address to address data.
861     //
862     // Bits Layout:
863     // - [0..63]    `balance`
864     // - [64..127]  `numberMinted`
865     // - [128..191] `numberBurned`
866     // - [192..255] `aux`
867     mapping(address => uint256) private _packedAddressData;
868 
869     // Mapping from token ID to approved address.
870     mapping(uint256 => address) private _tokenApprovals;
871 
872     // Mapping from owner to operator approvals
873     mapping(address => mapping(address => bool)) private _operatorApprovals;
874 
875     constructor(string memory name_, string memory symbol_) {
876         _name = name_;
877         _symbol = symbol_;
878         _currentIndex = _startTokenId();
879     }
880 
881     /**
882      * @dev Returns the starting token ID.
883      * To change the starting token ID, please override this function.
884      */
885     function _startTokenId() internal view virtual returns (uint256) {
886         return 0;
887     }
888 
889     /**
890      * @dev Returns the next token ID to be minted.
891      */
892     function _nextTokenId() internal view returns (uint256) {
893         return _currentIndex;
894     }
895 
896     /**
897      * @dev Returns the total number of tokens in existence.
898      * Burned tokens will reduce the count.
899      * To get the total number of tokens minted, please see `_totalMinted`.
900      */
901     function totalSupply() public view override returns (uint256) {
902         // Counter underflow is impossible as _burnCounter cannot be incremented
903         // more than `_currentIndex - _startTokenId()` times.
904         unchecked {
905             return _currentIndex - _burnCounter - _startTokenId();
906         }
907     }
908 
909     /**
910      * @dev Returns the total amount of tokens minted in the contract.
911      */
912     function _totalMinted() internal view returns (uint256) {
913         // Counter underflow is impossible as _currentIndex does not decrement,
914         // and it is initialized to `_startTokenId()`
915         unchecked {
916             return _currentIndex - _startTokenId();
917         }
918     }
919 
920     /**
921      * @dev Returns the total number of tokens burned.
922      */
923     function _totalBurned() internal view returns (uint256) {
924         return _burnCounter;
925     }
926 
927     /**
928      * @dev See {IERC165-supportsInterface}.
929      */
930     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
931         // The interface IDs are constants representing the first 4 bytes of the XOR of
932         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
933         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
934         return
935             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
936             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
937             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
938     }
939 
940     /**
941      * @dev See {IERC721-balanceOf}.
942      */
943     function balanceOf(address owner) public view override returns (uint256) {
944         if (owner == address(0)) revert BalanceQueryForZeroAddress();
945         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
946     }
947 
948     /**
949      * Returns the number of tokens minted by `owner`.
950      */
951     function _numberMinted(address owner) internal view returns (uint256) {
952         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
953     }
954 
955     /**
956      * Returns the number of tokens burned by or on behalf of `owner`.
957      */
958     function _numberBurned(address owner) internal view returns (uint256) {
959         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
960     }
961 
962     /**
963      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
964      */
965     function _getAux(address owner) internal view returns (uint64) {
966         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
967     }
968 
969     /**
970      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
971      * If there are multiple variables, please pack them into a uint64.
972      */
973     function _setAux(address owner, uint64 aux) internal {
974         uint256 packed = _packedAddressData[owner];
975         uint256 auxCasted;
976         // Cast `aux` with assembly to avoid redundant masking.
977         assembly {
978             auxCasted := aux
979         }
980         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
981         _packedAddressData[owner] = packed;
982     }
983 
984     /**
985      * Returns the packed ownership data of `tokenId`.
986      */
987     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
988         uint256 curr = tokenId;
989 
990         unchecked {
991             if (_startTokenId() <= curr)
992                 if (curr < _currentIndex) {
993                     uint256 packed = _packedOwnerships[curr];
994                     // If not burned.
995                     if (packed & BITMASK_BURNED == 0) {
996                         // Invariant:
997                         // There will always be an ownership that has an address and is not burned
998                         // before an ownership that does not have an address and is not burned.
999                         // Hence, curr will not underflow.
1000                         //
1001                         // We can directly compare the packed value.
1002                         // If the address is zero, packed is zero.
1003                         while (packed == 0) {
1004                             packed = _packedOwnerships[--curr];
1005                         }
1006                         return packed;
1007                     }
1008                 }
1009         }
1010         revert OwnerQueryForNonexistentToken();
1011     }
1012 
1013     /**
1014      * Returns the unpacked `TokenOwnership` struct from `packed`.
1015      */
1016     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1017         ownership.addr = address(uint160(packed));
1018         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1019         ownership.burned = packed & BITMASK_BURNED != 0;
1020         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1021     }
1022 
1023     /**
1024      * Returns the unpacked `TokenOwnership` struct at `index`.
1025      */
1026     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1027         return _unpackedOwnership(_packedOwnerships[index]);
1028     }
1029 
1030     /**
1031      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1032      */
1033     function _initializeOwnershipAt(uint256 index) internal {
1034         if (_packedOwnerships[index] == 0) {
1035             _packedOwnerships[index] = _packedOwnershipOf(index);
1036         }
1037     }
1038 
1039     /**
1040      * Gas spent here starts off proportional to the maximum mint batch size.
1041      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1042      */
1043     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1044         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1045     }
1046 
1047     /**
1048      * @dev Packs ownership data into a single uint256.
1049      */
1050     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1051         assembly {
1052             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1053             owner := and(owner, BITMASK_ADDRESS)
1054             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1055             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1056         }
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-ownerOf}.
1061      */
1062     function ownerOf(uint256 tokenId) public view override returns (address) {
1063         return address(uint160(_packedOwnershipOf(tokenId)));
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Metadata-name}.
1068      */
1069     function name() public view virtual override returns (string memory) {
1070         return _name;
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Metadata-symbol}.
1075      */
1076     function symbol() public view virtual override returns (string memory) {
1077         return _symbol;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Metadata-tokenURI}.
1082      */
1083     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1084         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1085 
1086         string memory baseURI = _baseURI();
1087         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1088     }
1089 
1090     /**
1091      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1092      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1093      * by default, it can be overridden in child contracts.
1094      */
1095     function _baseURI() internal view virtual returns (string memory) {
1096         return '';
1097     }
1098 
1099     /**
1100      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1101      */
1102     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1103         // For branchless setting of the `nextInitialized` flag.
1104         assembly {
1105             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1106             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1107         }
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-approve}.
1112      */
1113     function approve(address to, uint256 tokenId) public override {
1114         address owner = ownerOf(tokenId);
1115 
1116         if (_msgSenderERC721A() != owner)
1117             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1118                 revert ApprovalCallerNotOwnerNorApproved();
1119             }
1120 
1121         _tokenApprovals[tokenId] = to;
1122         emit Approval(owner, to, tokenId);
1123     }
1124 
1125     /**
1126      * @dev See {IERC721-getApproved}.
1127      */
1128     function getApproved(uint256 tokenId) public view override returns (address) {
1129         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1130 
1131         return _tokenApprovals[tokenId];
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-setApprovalForAll}.
1136      */
1137     function setApprovalForAll(address operator, bool approved) public virtual override {
1138         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1139 
1140         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1141         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-isApprovedForAll}.
1146      */
1147     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1148         return _operatorApprovals[owner][operator];
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-safeTransferFrom}.
1153      */
1154     function safeTransferFrom(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) public virtual override {
1159         safeTransferFrom(from, to, tokenId, '');
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-safeTransferFrom}.
1164      */
1165     function safeTransferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) public virtual override {
1171         transferFrom(from, to, tokenId);
1172         if (to.code.length != 0)
1173             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1174                 revert TransferToNonERC721ReceiverImplementer();
1175             }
1176     }
1177 
1178     /**
1179      * @dev Returns whether `tokenId` exists.
1180      *
1181      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1182      *
1183      * Tokens start existing when they are minted (`_mint`),
1184      */
1185     function _exists(uint256 tokenId) internal view returns (bool) {
1186         return
1187             _startTokenId() <= tokenId &&
1188             tokenId < _currentIndex && // If within bounds,
1189             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1190     }
1191 
1192     /**
1193      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1194      */
1195     function _safeMint(address to, uint256 quantity) internal {
1196         _safeMint(to, quantity, '');
1197     }
1198 
1199     /**
1200      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - If `to` refers to a smart contract, it must implement
1205      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1206      * - `quantity` must be greater than 0.
1207      *
1208      * See {_mint}.
1209      *
1210      * Emits a {Transfer} event for each mint.
1211      */
1212     function _safeMint(
1213         address to,
1214         uint256 quantity,
1215         bytes memory _data
1216     ) internal {
1217         _mint(to, quantity);
1218 
1219         unchecked {
1220             if (to.code.length != 0) {
1221                 uint256 end = _currentIndex;
1222                 uint256 index = end - quantity;
1223                 do {
1224                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1225                         revert TransferToNonERC721ReceiverImplementer();
1226                     }
1227                 } while (index < end);
1228                 // Reentrancy protection.
1229                 if (_currentIndex != end) revert();
1230             }
1231         }
1232     }
1233 
1234     /**
1235      * @dev Mints `quantity` tokens and transfers them to `to`.
1236      *
1237      * Requirements:
1238      *
1239      * - `to` cannot be the zero address.
1240      * - `quantity` must be greater than 0.
1241      *
1242      * Emits a {Transfer} event for each mint.
1243      */
1244     function _mint(address to, uint256 quantity) internal {
1245         uint256 startTokenId = _currentIndex;
1246         if (to == address(0)) revert MintToZeroAddress();
1247         if (quantity == 0) revert MintZeroQuantity();
1248 
1249         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1250 
1251         // Overflows are incredibly unrealistic.
1252         // `balance` and `numberMinted` have a maximum limit of 2**64.
1253         // `tokenId` has a maximum limit of 2**256.
1254         unchecked {
1255             // Updates:
1256             // - `balance += quantity`.
1257             // - `numberMinted += quantity`.
1258             //
1259             // We can directly add to the `balance` and `numberMinted`.
1260             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1261 
1262             // Updates:
1263             // - `address` to the owner.
1264             // - `startTimestamp` to the timestamp of minting.
1265             // - `burned` to `false`.
1266             // - `nextInitialized` to `quantity == 1`.
1267             _packedOwnerships[startTokenId] = _packOwnershipData(
1268                 to,
1269                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1270             );
1271 
1272             uint256 tokenId = startTokenId;
1273             uint256 end = startTokenId + quantity;
1274             do {
1275                 emit Transfer(address(0), to, tokenId++);
1276             } while (tokenId < end);
1277 
1278             _currentIndex = end;
1279         }
1280         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1281     }
1282 
1283     /**
1284      * @dev Mints `quantity` tokens and transfers them to `to`.
1285      *
1286      * This function is intended for efficient minting only during contract creation.
1287      *
1288      * It emits only one {ConsecutiveTransfer} as defined in
1289      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1290      * instead of a sequence of {Transfer} event(s).
1291      *
1292      * Calling this function outside of contract creation WILL make your contract
1293      * non-compliant with the ERC721 standard.
1294      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1295      * {ConsecutiveTransfer} event is only permissible during contract creation.
1296      *
1297      * Requirements:
1298      *
1299      * - `to` cannot be the zero address.
1300      * - `quantity` must be greater than 0.
1301      *
1302      * Emits a {ConsecutiveTransfer} event.
1303      */
1304     function _mintERC2309(address to, uint256 quantity) internal {
1305         uint256 startTokenId = _currentIndex;
1306         if (to == address(0)) revert MintToZeroAddress();
1307         if (quantity == 0) revert MintZeroQuantity();
1308         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1309 
1310         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1311 
1312         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1313         unchecked {
1314             // Updates:
1315             // - `balance += quantity`.
1316             // - `numberMinted += quantity`.
1317             //
1318             // We can directly add to the `balance` and `numberMinted`.
1319             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1320 
1321             // Updates:
1322             // - `address` to the owner.
1323             // - `startTimestamp` to the timestamp of minting.
1324             // - `burned` to `false`.
1325             // - `nextInitialized` to `quantity == 1`.
1326             _packedOwnerships[startTokenId] = _packOwnershipData(
1327                 to,
1328                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1329             );
1330 
1331             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1332 
1333             _currentIndex = startTokenId + quantity;
1334         }
1335         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1336     }
1337 
1338     /**
1339      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1340      */
1341     function _getApprovedAddress(uint256 tokenId)
1342         private
1343         view
1344         returns (uint256 approvedAddressSlot, address approvedAddress)
1345     {
1346         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1347         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1348         assembly {
1349             // Compute the slot.
1350             mstore(0x00, tokenId)
1351             mstore(0x20, tokenApprovalsPtr.slot)
1352             approvedAddressSlot := keccak256(0x00, 0x40)
1353             // Load the slot's value from storage.
1354             approvedAddress := sload(approvedAddressSlot)
1355         }
1356     }
1357 
1358     /**
1359      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1360      */
1361     function _isOwnerOrApproved(
1362         address approvedAddress,
1363         address from,
1364         address msgSender
1365     ) private pure returns (bool result) {
1366         assembly {
1367             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1368             from := and(from, BITMASK_ADDRESS)
1369             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1370             msgSender := and(msgSender, BITMASK_ADDRESS)
1371             // `msgSender == from || msgSender == approvedAddress`.
1372             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1373         }
1374     }
1375 
1376     /**
1377      * @dev Transfers `tokenId` from `from` to `to`.
1378      *
1379      * Requirements:
1380      *
1381      * - `to` cannot be the zero address.
1382      * - `tokenId` token must be owned by `from`.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function transferFrom(
1387         address from,
1388         address to,
1389         uint256 tokenId
1390     ) public virtual override {
1391         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1392 
1393         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1394 
1395         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1396 
1397         // The nested ifs save around 20+ gas over a compound boolean condition.
1398         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1399             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1400 
1401         if (to == address(0)) revert TransferToZeroAddress();
1402 
1403         _beforeTokenTransfers(from, to, tokenId, 1);
1404 
1405         // Clear approvals from the previous owner.
1406         assembly {
1407             if approvedAddress {
1408                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1409                 sstore(approvedAddressSlot, 0)
1410             }
1411         }
1412 
1413         // Underflow of the sender's balance is impossible because we check for
1414         // ownership above and the recipient's balance can't realistically overflow.
1415         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1416         unchecked {
1417             // We can directly increment and decrement the balances.
1418             --_packedAddressData[from]; // Updates: `balance -= 1`.
1419             ++_packedAddressData[to]; // Updates: `balance += 1`.
1420 
1421             // Updates:
1422             // - `address` to the next owner.
1423             // - `startTimestamp` to the timestamp of transfering.
1424             // - `burned` to `false`.
1425             // - `nextInitialized` to `true`.
1426             _packedOwnerships[tokenId] = _packOwnershipData(
1427                 to,
1428                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1429             );
1430 
1431             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1432             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1433                 uint256 nextTokenId = tokenId + 1;
1434                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1435                 if (_packedOwnerships[nextTokenId] == 0) {
1436                     // If the next slot is within bounds.
1437                     if (nextTokenId != _currentIndex) {
1438                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1439                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1440                     }
1441                 }
1442             }
1443         }
1444 
1445         emit Transfer(from, to, tokenId);
1446         _afterTokenTransfers(from, to, tokenId, 1);
1447     }
1448 
1449     /**
1450      * @dev Equivalent to `_burn(tokenId, false)`.
1451      */
1452     function _burn(uint256 tokenId) internal virtual {
1453         _burn(tokenId, false);
1454     }
1455 
1456     /**
1457      * @dev Destroys `tokenId`.
1458      * The approval is cleared when the token is burned.
1459      *
1460      * Requirements:
1461      *
1462      * - `tokenId` must exist.
1463      *
1464      * Emits a {Transfer} event.
1465      */
1466     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1467         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1468 
1469         address from = address(uint160(prevOwnershipPacked));
1470 
1471         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1472 
1473         if (approvalCheck) {
1474             // The nested ifs save around 20+ gas over a compound boolean condition.
1475             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1476                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1477         }
1478 
1479         _beforeTokenTransfers(from, address(0), tokenId, 1);
1480 
1481         // Clear approvals from the previous owner.
1482         assembly {
1483             if approvedAddress {
1484                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1485                 sstore(approvedAddressSlot, 0)
1486             }
1487         }
1488 
1489         // Underflow of the sender's balance is impossible because we check for
1490         // ownership above and the recipient's balance can't realistically overflow.
1491         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1492         unchecked {
1493             // Updates:
1494             // - `balance -= 1`.
1495             // - `numberBurned += 1`.
1496             //
1497             // We can directly decrement the balance, and increment the number burned.
1498             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1499             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1500 
1501             // Updates:
1502             // - `address` to the last owner.
1503             // - `startTimestamp` to the timestamp of burning.
1504             // - `burned` to `true`.
1505             // - `nextInitialized` to `true`.
1506             _packedOwnerships[tokenId] = _packOwnershipData(
1507                 from,
1508                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1509             );
1510 
1511             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1512             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1513                 uint256 nextTokenId = tokenId + 1;
1514                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1515                 if (_packedOwnerships[nextTokenId] == 0) {
1516                     // If the next slot is within bounds.
1517                     if (nextTokenId != _currentIndex) {
1518                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1519                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1520                     }
1521                 }
1522             }
1523         }
1524 
1525         emit Transfer(from, address(0), tokenId);
1526         _afterTokenTransfers(from, address(0), tokenId, 1);
1527 
1528         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1529         unchecked {
1530             _burnCounter++;
1531         }
1532     }
1533 
1534     /**
1535      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1536      *
1537      * @param from address representing the previous owner of the given token ID
1538      * @param to target address that will receive the tokens
1539      * @param tokenId uint256 ID of the token to be transferred
1540      * @param _data bytes optional data to send along with the call
1541      * @return bool whether the call correctly returned the expected magic value
1542      */
1543     function _checkContractOnERC721Received(
1544         address from,
1545         address to,
1546         uint256 tokenId,
1547         bytes memory _data
1548     ) private returns (bool) {
1549         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1550             bytes4 retval
1551         ) {
1552             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1553         } catch (bytes memory reason) {
1554             if (reason.length == 0) {
1555                 revert TransferToNonERC721ReceiverImplementer();
1556             } else {
1557                 assembly {
1558                     revert(add(32, reason), mload(reason))
1559                 }
1560             }
1561         }
1562     }
1563 
1564     /**
1565      * @dev Directly sets the extra data for the ownership data `index`.
1566      */
1567     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1568         uint256 packed = _packedOwnerships[index];
1569         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1570         uint256 extraDataCasted;
1571         // Cast `extraData` with assembly to avoid redundant masking.
1572         assembly {
1573             extraDataCasted := extraData
1574         }
1575         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1576         _packedOwnerships[index] = packed;
1577     }
1578 
1579     /**
1580      * @dev Returns the next extra data for the packed ownership data.
1581      * The returned result is shifted into position.
1582      */
1583     function _nextExtraData(
1584         address from,
1585         address to,
1586         uint256 prevOwnershipPacked
1587     ) private view returns (uint256) {
1588         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1589         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1590     }
1591 
1592     /**
1593      * @dev Called during each token transfer to set the 24bit `extraData` field.
1594      * Intended to be overridden by the cosumer contract.
1595      *
1596      * `previousExtraData` - the value of `extraData` before transfer.
1597      *
1598      * Calling conditions:
1599      *
1600      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1601      * transferred to `to`.
1602      * - When `from` is zero, `tokenId` will be minted for `to`.
1603      * - When `to` is zero, `tokenId` will be burned by `from`.
1604      * - `from` and `to` are never both zero.
1605      */
1606     function _extraData(
1607         address from,
1608         address to,
1609         uint24 previousExtraData
1610     ) internal view virtual returns (uint24) {}
1611 
1612     /**
1613      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1614      * This includes minting.
1615      * And also called before burning one token.
1616      *
1617      * startTokenId - the first token id to be transferred
1618      * quantity - the amount to be transferred
1619      *
1620      * Calling conditions:
1621      *
1622      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1623      * transferred to `to`.
1624      * - When `from` is zero, `tokenId` will be minted for `to`.
1625      * - When `to` is zero, `tokenId` will be burned by `from`.
1626      * - `from` and `to` are never both zero.
1627      */
1628     function _beforeTokenTransfers(
1629         address from,
1630         address to,
1631         uint256 startTokenId,
1632         uint256 quantity
1633     ) internal virtual {}
1634 
1635     /**
1636      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1637      * This includes minting.
1638      * And also called after one token has been burned.
1639      *
1640      * startTokenId - the first token id to be transferred
1641      * quantity - the amount to be transferred
1642      *
1643      * Calling conditions:
1644      *
1645      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1646      * transferred to `to`.
1647      * - When `from` is zero, `tokenId` has been minted for `to`.
1648      * - When `to` is zero, `tokenId` has been burned by `from`.
1649      * - `from` and `to` are never both zero.
1650      */
1651     function _afterTokenTransfers(
1652         address from,
1653         address to,
1654         uint256 startTokenId,
1655         uint256 quantity
1656     ) internal virtual {}
1657 
1658     /**
1659      * @dev Returns the message sender (defaults to `msg.sender`).
1660      *
1661      * If you are writing GSN compatible contracts, you need to override this function.
1662      */
1663     function _msgSenderERC721A() internal view virtual returns (address) {
1664         return msg.sender;
1665     }
1666 
1667     /**
1668      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1669      */
1670     function _toString(uint256 value) internal pure returns (string memory ptr) {
1671         assembly {
1672             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1673             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1674             // We will need 1 32-byte word to store the length,
1675             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1676             ptr := add(mload(0x40), 128)
1677             // Update the free memory pointer to allocate.
1678             mstore(0x40, ptr)
1679 
1680             // Cache the end of the memory to calculate the length later.
1681             let end := ptr
1682 
1683             // We write the string from the rightmost digit to the leftmost digit.
1684             // The following is essentially a do-while loop that also handles the zero case.
1685             // Costs a bit more than early returning for the zero case,
1686             // but cheaper in terms of deployment and overall runtime costs.
1687             for {
1688                 // Initialize and perform the first pass without check.
1689                 let temp := value
1690                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1691                 ptr := sub(ptr, 1)
1692                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1693                 mstore8(ptr, add(48, mod(temp, 10)))
1694                 temp := div(temp, 10)
1695             } temp {
1696                 // Keep dividing `temp` until zero.
1697                 temp := div(temp, 10)
1698             } {
1699                 // Body of the for loop.
1700                 ptr := sub(ptr, 1)
1701                 mstore8(ptr, add(48, mod(temp, 10)))
1702             }
1703 
1704             let length := sub(end, ptr)
1705             // Move the pointer 32 bytes leftwards to make room for the length.
1706             ptr := sub(ptr, 32)
1707             // Store the length.
1708             mstore(ptr, length)
1709         }
1710     }
1711 }
1712 
1713 // File: contracts/Tem.sol
1714 
1715 
1716 
1717 
1718 pragma solidity ^0.8.4;
1719 
1720 
1721 
1722 contract KungFuPepeClub is ERC721A, Ownable, ReentrancyGuard {
1723     using Address for address;
1724     using Strings for uint;
1725     string  public baseTokenURI = "ipfs://bafybeifiaiw3k63icqnt2mnd6msaskqxhkl6uq4zh2ktnyfrdiau5ch3we/";
1726     uint256 public MAX_SUPPLY = 4888;
1727     uint256 public MAX_FREE_SUPPLY = 4888;
1728     uint256 public MAX_PER_TX = 20;
1729     uint256 public PRICE = 0.003 ether;
1730     uint256 public MAX_FREE_PER_WALLET = 1;
1731     bool public state = false;
1732 
1733     mapping(address => uint256) public qtyFreeMinted;
1734 
1735     constructor() ERC721A("KungFu Pepe Club", "KFPC") {}
1736 
1737 
1738     function candy(address to, uint count) external onlyOwner {
1739 		require(
1740 			_totalMinted() + count <= MAX_SUPPLY,
1741 			'Exceeds max supply'
1742 		);
1743 		_safeMint(to, count);
1744 	}
1745 
1746     function mint(uint256 amount) external payable
1747     {
1748         require(state, "Minting is not live.");
1749 		require(amount <= MAX_PER_TX,"Exceeds NFT per transaction limit");
1750 		require(_totalMinted() + amount <= MAX_SUPPLY,"Exceeds max supply");
1751 
1752         uint payForCount = amount;
1753         uint mintedSoFar = qtyFreeMinted[msg.sender];
1754         if(mintedSoFar < MAX_FREE_PER_WALLET) {
1755             uint remainingFreeMints = MAX_FREE_PER_WALLET - mintedSoFar;
1756             if(amount > remainingFreeMints) {
1757                 payForCount = amount - remainingFreeMints;
1758             }
1759             else {
1760                 payForCount = 0;
1761             }
1762         }
1763 
1764 		require(
1765 			msg.value >= payForCount * PRICE,
1766 			'Ether value sent is not sufficient'
1767 		);
1768     	qtyFreeMinted[msg.sender] += amount;
1769 
1770         _safeMint(msg.sender, amount);
1771     }
1772 
1773     function setBaseURI(string memory baseURI) public onlyOwner
1774     {
1775         baseTokenURI = baseURI;
1776     }
1777 
1778     function _startTokenId() internal view virtual override returns (uint256) {
1779         return 1;
1780     }
1781     function withdraw() public onlyOwner nonReentrant {
1782         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1783         require(os);
1784     }
1785 
1786     function tokenURI(uint tokenId)
1787 		public
1788 		view
1789 		override
1790 		returns (string memory)
1791 	{
1792         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1793 
1794         return bytes(_baseURI()).length > 0 
1795             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1796             : baseTokenURI;
1797 	}
1798 
1799     function _baseURI() internal view virtual override returns (string memory)
1800     {
1801         return baseTokenURI;
1802     }
1803 
1804 
1805     function setState(bool _state) external onlyOwner
1806     {
1807         state = _state;
1808     }
1809 
1810     function setPrice(uint256 _price) external onlyOwner
1811     {
1812         PRICE = _price;
1813     }
1814 
1815     function setMaxLimitPerTransaction(uint256 _limit) external onlyOwner
1816     {
1817         MAX_PER_TX = _limit;
1818     }
1819 
1820     function setLimitFreeMintPerWallet(uint256 _limit) external onlyOwner
1821     {
1822         MAX_FREE_PER_WALLET = _limit;
1823     }
1824 
1825     function setMaxFreeAmount(uint256 _amount) external onlyOwner
1826     {
1827         MAX_FREE_SUPPLY = _amount;
1828     }
1829 
1830 }