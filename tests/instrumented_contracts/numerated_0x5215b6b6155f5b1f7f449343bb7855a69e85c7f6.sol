1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
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
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
83 
84 pragma solidity ^0.8.1;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      *
107      * [IMPORTANT]
108      * ====
109      * You shouldn't rely on `isContract` to protect against flash loan attacks!
110      *
111      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
112      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
113      * constructor.
114      * ====
115      */
116     function isContract(address account) internal view returns (bool) {
117         // This method relies on extcodesize/address.code.length, which returns 0
118         // for contracts in construction, since the code is only stored at the end
119         // of the constructor execution.
120 
121         return account.code.length > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292                 /// @solidity memory-safe-assembly
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Contract module that helps prevent reentrant calls to a function.
313  *
314  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
315  * available, which can be applied to functions to make sure there are no nested
316  * (reentrant) calls to them.
317  *
318  * Note that because there is a single `nonReentrant` guard, functions marked as
319  * `nonReentrant` may not call one another. This can be worked around by making
320  * those functions `private`, and then adding `external` `nonReentrant` entry
321  * points to them.
322  *
323  * TIP: If you would like to learn more about reentrancy and alternative ways
324  * to protect against it, check out our blog post
325  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
326  */
327 abstract contract ReentrancyGuard {
328     // Booleans are more expensive than uint256 or any type that takes up a full
329     // word because each write operation emits an extra SLOAD to first read the
330     // slot's contents, replace the bits taken up by the boolean, and then write
331     // back. This is the compiler's defense against contract upgrades and
332     // pointer aliasing, and it cannot be disabled.
333 
334     // The values being non-zero value makes deployment a bit more expensive,
335     // but in exchange the refund on every call to nonReentrant will be lower in
336     // amount. Since refunds are capped to a percentage of the total
337     // transaction's gas, it is best to keep them low in cases like this one, to
338     // increase the likelihood of the full refund coming into effect.
339     uint256 private constant _NOT_ENTERED = 1;
340     uint256 private constant _ENTERED = 2;
341 
342     uint256 private _status;
343 
344     constructor() {
345         _status = _NOT_ENTERED;
346     }
347 
348     /**
349      * @dev Prevents a contract from calling itself, directly or indirectly.
350      * Calling a `nonReentrant` function from another `nonReentrant`
351      * function is not supported. It is possible to prevent this from happening
352      * by making the `nonReentrant` function external, and making it call a
353      * `private` function that does the actual work.
354      */
355     modifier nonReentrant() {
356         // On the first call to nonReentrant, _notEntered will be true
357         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
358 
359         // Any calls to nonReentrant after this point will fail
360         _status = _ENTERED;
361 
362         _;
363 
364         // By storing the original value once again, a refund is triggered (see
365         // https://eips.ethereum.org/EIPS/eip-2200)
366         _status = _NOT_ENTERED;
367     }
368 }
369 
370 // File: @openzeppelin/contracts/utils/Context.sol
371 
372 
373 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @dev Provides information about the current execution context, including the
379  * sender of the transaction and its data. While these are generally available
380  * via msg.sender and msg.data, they should not be accessed in such a direct
381  * manner, since when dealing with meta-transactions the account sending and
382  * paying for execution may not be the actual sender (as far as an application
383  * is concerned).
384  *
385  * This contract is only required for intermediate, library-like contracts.
386  */
387 abstract contract Context {
388     function _msgSender() internal view virtual returns (address) {
389         return msg.sender;
390     }
391 
392     function _msgData() internal view virtual returns (bytes calldata) {
393         return msg.data;
394     }
395 }
396 
397 // File: @openzeppelin/contracts/access/Ownable.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 /**
406  * @dev Contract module which provides a basic access control mechanism, where
407  * there is an account (an owner) that can be granted exclusive access to
408  * specific functions.
409  *
410  * By default, the owner account will be the one that deploys the contract. This
411  * can later be changed with {transferOwnership}.
412  *
413  * This module is used through inheritance. It will make available the modifier
414  * `onlyOwner`, which can be applied to your functions to restrict their use to
415  * the owner.
416  */
417 abstract contract Ownable is Context {
418     address private _owner;
419 
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421 
422     /**
423      * @dev Initializes the contract setting the deployer as the initial owner.
424      */
425     constructor() {
426         _transferOwnership(_msgSender());
427     }
428 
429     /**
430      * @dev Throws if called by any account other than the owner.
431      */
432     modifier onlyOwner() {
433         _checkOwner();
434         _;
435     }
436 
437     /**
438      * @dev Returns the address of the current owner.
439      */
440     function owner() public view virtual returns (address) {
441         return _owner;
442     }
443 
444     /**
445      * @dev Throws if the sender is not the owner.
446      */
447     function _checkOwner() internal view virtual {
448         require(owner() == _msgSender(), "Ownable: caller is not the owner");
449     }
450 
451     /**
452      * @dev Leaves the contract without owner. It will not be possible to call
453      * `onlyOwner` functions anymore. Can only be called by the current owner.
454      *
455      * NOTE: Renouncing ownership will leave the contract without an owner,
456      * thereby removing any functionality that is only available to the owner.
457      */
458     function renounceOwnership() public virtual onlyOwner {
459         _transferOwnership(address(0));
460     }
461 
462     /**
463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
464      * Can only be called by the current owner.
465      */
466     function transferOwnership(address newOwner) public virtual onlyOwner {
467         require(newOwner != address(0), "Ownable: new owner is the zero address");
468         _transferOwnership(newOwner);
469     }
470 
471     /**
472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
473      * Internal function without access restriction.
474      */
475     function _transferOwnership(address newOwner) internal virtual {
476         address oldOwner = _owner;
477         _owner = newOwner;
478         emit OwnershipTransferred(oldOwner, newOwner);
479     }
480 }
481 
482 // File: erc721a/contracts/IERC721A.sol
483 
484 
485 // ERC721A Contracts v4.1.0
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
765 
766 pragma solidity ^0.8.4;
767 
768 
769 /**
770  * @dev ERC721 token receiver interface.
771  */
772 interface ERC721A__IERC721Receiver {
773     function onERC721Received(
774         address operator,
775         address from,
776         uint256 tokenId,
777         bytes calldata data
778     ) external returns (bytes4);
779 }
780 
781 /**
782  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
783  * including the Metadata extension. Built to optimize for lower gas during batch mints.
784  *
785  * Assumes serials are sequentially minted starting at `_startTokenId()`
786  * (defaults to 0, e.g. 0, 1, 2, 3..).
787  *
788  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
789  *
790  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
791  */
792 contract ERC721A is IERC721A {
793     // Mask of an entry in packed address data.
794     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
795 
796     // The bit position of `numberMinted` in packed address data.
797     uint256 private constant BITPOS_NUMBER_MINTED = 64;
798 
799     // The bit position of `numberBurned` in packed address data.
800     uint256 private constant BITPOS_NUMBER_BURNED = 128;
801 
802     // The bit position of `aux` in packed address data.
803     uint256 private constant BITPOS_AUX = 192;
804 
805     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
806     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
807 
808     // The bit position of `startTimestamp` in packed ownership.
809     uint256 private constant BITPOS_START_TIMESTAMP = 160;
810 
811     // The bit mask of the `burned` bit in packed ownership.
812     uint256 private constant BITMASK_BURNED = 1 << 224;
813 
814     // The bit position of the `nextInitialized` bit in packed ownership.
815     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
816 
817     // The bit mask of the `nextInitialized` bit in packed ownership.
818     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
819 
820     // The bit position of `extraData` in packed ownership.
821     uint256 private constant BITPOS_EXTRA_DATA = 232;
822 
823     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
824     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
825 
826     // The mask of the lower 160 bits for addresses.
827     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
828 
829     // The maximum `quantity` that can be minted with `_mintERC2309`.
830     // This limit is to prevent overflows on the address data entries.
831     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
832     // is required to cause an overflow, which is unrealistic.
833     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
834 
835     // The tokenId of the next token to be minted.
836     uint256 private _currentIndex;
837 
838     // The number of tokens burned.
839     uint256 private _burnCounter;
840 
841     // Token name
842     string private _name;
843 
844     // Token symbol
845     string private _symbol;
846 
847     // Mapping from token ID to ownership details
848     // An empty struct value does not necessarily mean the token is unowned.
849     // See `_packedOwnershipOf` implementation for details.
850     //
851     // Bits Layout:
852     // - [0..159]   `addr`
853     // - [160..223] `startTimestamp`
854     // - [224]      `burned`
855     // - [225]      `nextInitialized`
856     // - [232..255] `extraData`
857     mapping(uint256 => uint256) private _packedOwnerships;
858 
859     // Mapping owner address to address data.
860     //
861     // Bits Layout:
862     // - [0..63]    `balance`
863     // - [64..127]  `numberMinted`
864     // - [128..191] `numberBurned`
865     // - [192..255] `aux`
866     mapping(address => uint256) private _packedAddressData;
867 
868     // Mapping from token ID to approved address.
869     mapping(uint256 => address) private _tokenApprovals;
870 
871     // Mapping from owner to operator approvals
872     mapping(address => mapping(address => bool)) private _operatorApprovals;
873 
874     constructor(string memory name_, string memory symbol_) {
875         _name = name_;
876         _symbol = symbol_;
877         _currentIndex = _startTokenId();
878     }
879 
880     /**
881      * @dev Returns the starting token ID.
882      * To change the starting token ID, please override this function.
883      */
884     function _startTokenId() internal view virtual returns (uint256) {
885         return 0;
886     }
887 
888     /**
889      * @dev Returns the next token ID to be minted.
890      */
891     function _nextTokenId() internal view returns (uint256) {
892         return _currentIndex;
893     }
894 
895     /**
896      * @dev Returns the total number of tokens in existence.
897      * Burned tokens will reduce the count.
898      * To get the total number of tokens minted, please see `_totalMinted`.
899      */
900     function totalSupply() public view override returns (uint256) {
901         // Counter underflow is impossible as _burnCounter cannot be incremented
902         // more than `_currentIndex - _startTokenId()` times.
903         unchecked {
904             return _currentIndex - _burnCounter - _startTokenId();
905         }
906     }
907 
908     /**
909      * @dev Returns the total amount of tokens minted in the contract.
910      */
911     function _totalMinted() internal view returns (uint256) {
912         // Counter underflow is impossible as _currentIndex does not decrement,
913         // and it is initialized to `_startTokenId()`
914         unchecked {
915             return _currentIndex - _startTokenId();
916         }
917     }
918 
919     /**
920      * @dev Returns the total number of tokens burned.
921      */
922     function _totalBurned() internal view returns (uint256) {
923         return _burnCounter;
924     }
925 
926     /**
927      * @dev See {IERC165-supportsInterface}.
928      */
929     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
930         // The interface IDs are constants representing the first 4 bytes of the XOR of
931         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
932         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
933         return
934             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
935             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
936             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
937     }
938 
939     /**
940      * @dev See {IERC721-balanceOf}.
941      */
942     function balanceOf(address owner) public view override returns (uint256) {
943         if (owner == address(0)) revert BalanceQueryForZeroAddress();
944         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
945     }
946 
947     /**
948      * Returns the number of tokens minted by `owner`.
949      */
950     function _numberMinted(address owner) internal view returns (uint256) {
951         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
952     }
953 
954     /**
955      * Returns the number of tokens burned by or on behalf of `owner`.
956      */
957     function _numberBurned(address owner) internal view returns (uint256) {
958         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
959     }
960 
961     /**
962      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
963      */
964     function _getAux(address owner) internal view returns (uint64) {
965         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
966     }
967 
968     /**
969      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
970      * If there are multiple variables, please pack them into a uint64.
971      */
972     function _setAux(address owner, uint64 aux) internal {
973         uint256 packed = _packedAddressData[owner];
974         uint256 auxCasted;
975         // Cast `aux` with assembly to avoid redundant masking.
976         assembly {
977             auxCasted := aux
978         }
979         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
980         _packedAddressData[owner] = packed;
981     }
982 
983     /**
984      * Returns the packed ownership data of `tokenId`.
985      */
986     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
987         uint256 curr = tokenId;
988 
989         unchecked {
990             if (_startTokenId() <= curr)
991                 if (curr < _currentIndex) {
992                     uint256 packed = _packedOwnerships[curr];
993                     // If not burned.
994                     if (packed & BITMASK_BURNED == 0) {
995                         // Invariant:
996                         // There will always be an ownership that has an address and is not burned
997                         // before an ownership that does not have an address and is not burned.
998                         // Hence, curr will not underflow.
999                         //
1000                         // We can directly compare the packed value.
1001                         // If the address is zero, packed is zero.
1002                         while (packed == 0) {
1003                             packed = _packedOwnerships[--curr];
1004                         }
1005                         return packed;
1006                     }
1007                 }
1008         }
1009         revert OwnerQueryForNonexistentToken();
1010     }
1011 
1012     /**
1013      * Returns the unpacked `TokenOwnership` struct from `packed`.
1014      */
1015     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1016         ownership.addr = address(uint160(packed));
1017         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1018         ownership.burned = packed & BITMASK_BURNED != 0;
1019         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1020     }
1021 
1022     /**
1023      * Returns the unpacked `TokenOwnership` struct at `index`.
1024      */
1025     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1026         return _unpackedOwnership(_packedOwnerships[index]);
1027     }
1028 
1029     /**
1030      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1031      */
1032     function _initializeOwnershipAt(uint256 index) internal {
1033         if (_packedOwnerships[index] == 0) {
1034             _packedOwnerships[index] = _packedOwnershipOf(index);
1035         }
1036     }
1037 
1038     /**
1039      * Gas spent here starts off proportional to the maximum mint batch size.
1040      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1041      */
1042     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1043         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1044     }
1045 
1046     /**
1047      * @dev Packs ownership data into a single uint256.
1048      */
1049     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1050         assembly {
1051             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1052             owner := and(owner, BITMASK_ADDRESS)
1053             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1054             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1055         }
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-ownerOf}.
1060      */
1061     function ownerOf(uint256 tokenId) public view override returns (address) {
1062         return address(uint160(_packedOwnershipOf(tokenId)));
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Metadata-name}.
1067      */
1068     function name() public view virtual override returns (string memory) {
1069         return _name;
1070     }
1071 
1072     /**
1073      * @dev See {IERC721Metadata-symbol}.
1074      */
1075     function symbol() public view virtual override returns (string memory) {
1076         return _symbol;
1077     }
1078 
1079     /**
1080      * @dev See {IERC721Metadata-tokenURI}.
1081      */
1082     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1083         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1084 
1085         string memory baseURI = _baseURI();
1086         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1087     }
1088 
1089     /**
1090      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1091      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1092      * by default, it can be overridden in child contracts.
1093      */
1094     function _baseURI() internal view virtual returns (string memory) {
1095         return '';
1096     }
1097 
1098     /**
1099      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1100      */
1101     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1102         // For branchless setting of the `nextInitialized` flag.
1103         assembly {
1104             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1105             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1106         }
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-approve}.
1111      */
1112     function approve(address to, uint256 tokenId) public override {
1113         address owner = ownerOf(tokenId);
1114 
1115         if (_msgSenderERC721A() != owner)
1116             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1117                 revert ApprovalCallerNotOwnerNorApproved();
1118             }
1119 
1120         _tokenApprovals[tokenId] = to;
1121         emit Approval(owner, to, tokenId);
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-getApproved}.
1126      */
1127     function getApproved(uint256 tokenId) public view override returns (address) {
1128         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1129 
1130         return _tokenApprovals[tokenId];
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-setApprovalForAll}.
1135      */
1136     function setApprovalForAll(address operator, bool approved) public virtual override {
1137         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1138 
1139         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1140         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-isApprovedForAll}.
1145      */
1146     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1147         return _operatorApprovals[owner][operator];
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-safeTransferFrom}.
1152      */
1153     function safeTransferFrom(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) public virtual override {
1158         safeTransferFrom(from, to, tokenId, '');
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-safeTransferFrom}.
1163      */
1164     function safeTransferFrom(
1165         address from,
1166         address to,
1167         uint256 tokenId,
1168         bytes memory _data
1169     ) public virtual override {
1170         transferFrom(from, to, tokenId);
1171         if (to.code.length != 0)
1172             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1173                 revert TransferToNonERC721ReceiverImplementer();
1174             }
1175     }
1176 
1177     /**
1178      * @dev Returns whether `tokenId` exists.
1179      *
1180      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1181      *
1182      * Tokens start existing when they are minted (`_mint`),
1183      */
1184     function _exists(uint256 tokenId) internal view returns (bool) {
1185         return
1186             _startTokenId() <= tokenId &&
1187             tokenId < _currentIndex && // If within bounds,
1188             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1189     }
1190 
1191     /**
1192      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1193      */
1194     function _safeMint(address to, uint256 quantity) internal {
1195         _safeMint(to, quantity, '');
1196     }
1197 
1198     /**
1199      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1200      *
1201      * Requirements:
1202      *
1203      * - If `to` refers to a smart contract, it must implement
1204      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1205      * - `quantity` must be greater than 0.
1206      *
1207      * See {_mint}.
1208      *
1209      * Emits a {Transfer} event for each mint.
1210      */
1211     function _safeMint(
1212         address to,
1213         uint256 quantity,
1214         bytes memory _data
1215     ) internal {
1216         _mint(to, quantity);
1217 
1218         unchecked {
1219             if (to.code.length != 0) {
1220                 uint256 end = _currentIndex;
1221                 uint256 index = end - quantity;
1222                 do {
1223                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1224                         revert TransferToNonERC721ReceiverImplementer();
1225                     }
1226                 } while (index < end);
1227                 // Reentrancy protection.
1228                 if (_currentIndex != end) revert();
1229             }
1230         }
1231     }
1232 
1233     /**
1234      * @dev Mints `quantity` tokens and transfers them to `to`.
1235      *
1236      * Requirements:
1237      *
1238      * - `to` cannot be the zero address.
1239      * - `quantity` must be greater than 0.
1240      *
1241      * Emits a {Transfer} event for each mint.
1242      */
1243     function _mint(address to, uint256 quantity) internal {
1244         uint256 startTokenId = _currentIndex;
1245         if (to == address(0)) revert MintToZeroAddress();
1246         if (quantity == 0) revert MintZeroQuantity();
1247 
1248         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1249 
1250         // Overflows are incredibly unrealistic.
1251         // `balance` and `numberMinted` have a maximum limit of 2**64.
1252         // `tokenId` has a maximum limit of 2**256.
1253         unchecked {
1254             // Updates:
1255             // - `balance += quantity`.
1256             // - `numberMinted += quantity`.
1257             //
1258             // We can directly add to the `balance` and `numberMinted`.
1259             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1260 
1261             // Updates:
1262             // - `address` to the owner.
1263             // - `startTimestamp` to the timestamp of minting.
1264             // - `burned` to `false`.
1265             // - `nextInitialized` to `quantity == 1`.
1266             _packedOwnerships[startTokenId] = _packOwnershipData(
1267                 to,
1268                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1269             );
1270 
1271             uint256 tokenId = startTokenId;
1272             uint256 end = startTokenId + quantity;
1273             do {
1274                 emit Transfer(address(0), to, tokenId++);
1275             } while (tokenId < end);
1276 
1277             _currentIndex = end;
1278         }
1279         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1280     }
1281 
1282     /**
1283      * @dev Mints `quantity` tokens and transfers them to `to`.
1284      *
1285      * This function is intended for efficient minting only during contract creation.
1286      *
1287      * It emits only one {ConsecutiveTransfer} as defined in
1288      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1289      * instead of a sequence of {Transfer} event(s).
1290      *
1291      * Calling this function outside of contract creation WILL make your contract
1292      * non-compliant with the ERC721 standard.
1293      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1294      * {ConsecutiveTransfer} event is only permissible during contract creation.
1295      *
1296      * Requirements:
1297      *
1298      * - `to` cannot be the zero address.
1299      * - `quantity` must be greater than 0.
1300      *
1301      * Emits a {ConsecutiveTransfer} event.
1302      */
1303     function _mintERC2309(address to, uint256 quantity) internal {
1304         uint256 startTokenId = _currentIndex;
1305         if (to == address(0)) revert MintToZeroAddress();
1306         if (quantity == 0) revert MintZeroQuantity();
1307         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1308 
1309         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1310 
1311         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1312         unchecked {
1313             // Updates:
1314             // - `balance += quantity`.
1315             // - `numberMinted += quantity`.
1316             //
1317             // We can directly add to the `balance` and `numberMinted`.
1318             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1319 
1320             // Updates:
1321             // - `address` to the owner.
1322             // - `startTimestamp` to the timestamp of minting.
1323             // - `burned` to `false`.
1324             // - `nextInitialized` to `quantity == 1`.
1325             _packedOwnerships[startTokenId] = _packOwnershipData(
1326                 to,
1327                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1328             );
1329 
1330             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1331 
1332             _currentIndex = startTokenId + quantity;
1333         }
1334         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1335     }
1336 
1337     /**
1338      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1339      */
1340     function _getApprovedAddress(uint256 tokenId)
1341         private
1342         view
1343         returns (uint256 approvedAddressSlot, address approvedAddress)
1344     {
1345         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1346         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1347         assembly {
1348             // Compute the slot.
1349             mstore(0x00, tokenId)
1350             mstore(0x20, tokenApprovalsPtr.slot)
1351             approvedAddressSlot := keccak256(0x00, 0x40)
1352             // Load the slot's value from storage.
1353             approvedAddress := sload(approvedAddressSlot)
1354         }
1355     }
1356 
1357     /**
1358      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1359      */
1360     function _isOwnerOrApproved(
1361         address approvedAddress,
1362         address from,
1363         address msgSender
1364     ) private pure returns (bool result) {
1365         assembly {
1366             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1367             from := and(from, BITMASK_ADDRESS)
1368             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1369             msgSender := and(msgSender, BITMASK_ADDRESS)
1370             // `msgSender == from || msgSender == approvedAddress`.
1371             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1372         }
1373     }
1374 
1375     /**
1376      * @dev Transfers `tokenId` from `from` to `to`.
1377      *
1378      * Requirements:
1379      *
1380      * - `to` cannot be the zero address.
1381      * - `tokenId` token must be owned by `from`.
1382      *
1383      * Emits a {Transfer} event.
1384      */
1385     function transferFrom(
1386         address from,
1387         address to,
1388         uint256 tokenId
1389     ) public virtual override {
1390         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1391 
1392         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1393 
1394         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1395 
1396         // The nested ifs save around 20+ gas over a compound boolean condition.
1397         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1398             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1399 
1400         if (to == address(0)) revert TransferToZeroAddress();
1401 
1402         _beforeTokenTransfers(from, to, tokenId, 1);
1403 
1404         // Clear approvals from the previous owner.
1405         assembly {
1406             if approvedAddress {
1407                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1408                 sstore(approvedAddressSlot, 0)
1409             }
1410         }
1411 
1412         // Underflow of the sender's balance is impossible because we check for
1413         // ownership above and the recipient's balance can't realistically overflow.
1414         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1415         unchecked {
1416             // We can directly increment and decrement the balances.
1417             --_packedAddressData[from]; // Updates: `balance -= 1`.
1418             ++_packedAddressData[to]; // Updates: `balance += 1`.
1419 
1420             // Updates:
1421             // - `address` to the next owner.
1422             // - `startTimestamp` to the timestamp of transfering.
1423             // - `burned` to `false`.
1424             // - `nextInitialized` to `true`.
1425             _packedOwnerships[tokenId] = _packOwnershipData(
1426                 to,
1427                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1428             );
1429 
1430             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1431             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1432                 uint256 nextTokenId = tokenId + 1;
1433                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1434                 if (_packedOwnerships[nextTokenId] == 0) {
1435                     // If the next slot is within bounds.
1436                     if (nextTokenId != _currentIndex) {
1437                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1438                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1439                     }
1440                 }
1441             }
1442         }
1443 
1444         emit Transfer(from, to, tokenId);
1445         _afterTokenTransfers(from, to, tokenId, 1);
1446     }
1447 
1448     /**
1449      * @dev Equivalent to `_burn(tokenId, false)`.
1450      */
1451     function _burn(uint256 tokenId) internal virtual {
1452         _burn(tokenId, false);
1453     }
1454 
1455     /**
1456      * @dev Destroys `tokenId`.
1457      * The approval is cleared when the token is burned.
1458      *
1459      * Requirements:
1460      *
1461      * - `tokenId` must exist.
1462      *
1463      * Emits a {Transfer} event.
1464      */
1465     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1466         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1467 
1468         address from = address(uint160(prevOwnershipPacked));
1469 
1470         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1471 
1472         if (approvalCheck) {
1473             // The nested ifs save around 20+ gas over a compound boolean condition.
1474             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1475                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1476         }
1477 
1478         _beforeTokenTransfers(from, address(0), tokenId, 1);
1479 
1480         // Clear approvals from the previous owner.
1481         assembly {
1482             if approvedAddress {
1483                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1484                 sstore(approvedAddressSlot, 0)
1485             }
1486         }
1487 
1488         // Underflow of the sender's balance is impossible because we check for
1489         // ownership above and the recipient's balance can't realistically overflow.
1490         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1491         unchecked {
1492             // Updates:
1493             // - `balance -= 1`.
1494             // - `numberBurned += 1`.
1495             //
1496             // We can directly decrement the balance, and increment the number burned.
1497             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1498             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1499 
1500             // Updates:
1501             // - `address` to the last owner.
1502             // - `startTimestamp` to the timestamp of burning.
1503             // - `burned` to `true`.
1504             // - `nextInitialized` to `true`.
1505             _packedOwnerships[tokenId] = _packOwnershipData(
1506                 from,
1507                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1508             );
1509 
1510             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1511             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1512                 uint256 nextTokenId = tokenId + 1;
1513                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1514                 if (_packedOwnerships[nextTokenId] == 0) {
1515                     // If the next slot is within bounds.
1516                     if (nextTokenId != _currentIndex) {
1517                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1518                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1519                     }
1520                 }
1521             }
1522         }
1523 
1524         emit Transfer(from, address(0), tokenId);
1525         _afterTokenTransfers(from, address(0), tokenId, 1);
1526 
1527         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1528         unchecked {
1529             _burnCounter++;
1530         }
1531     }
1532 
1533     /**
1534      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1535      *
1536      * @param from address representing the previous owner of the given token ID
1537      * @param to target address that will receive the tokens
1538      * @param tokenId uint256 ID of the token to be transferred
1539      * @param _data bytes optional data to send along with the call
1540      * @return bool whether the call correctly returned the expected magic value
1541      */
1542     function _checkContractOnERC721Received(
1543         address from,
1544         address to,
1545         uint256 tokenId,
1546         bytes memory _data
1547     ) private returns (bool) {
1548         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1549             bytes4 retval
1550         ) {
1551             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1552         } catch (bytes memory reason) {
1553             if (reason.length == 0) {
1554                 revert TransferToNonERC721ReceiverImplementer();
1555             } else {
1556                 assembly {
1557                     revert(add(32, reason), mload(reason))
1558                 }
1559             }
1560         }
1561     }
1562 
1563     /**
1564      * @dev Directly sets the extra data for the ownership data `index`.
1565      */
1566     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1567         uint256 packed = _packedOwnerships[index];
1568         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1569         uint256 extraDataCasted;
1570         // Cast `extraData` with assembly to avoid redundant masking.
1571         assembly {
1572             extraDataCasted := extraData
1573         }
1574         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1575         _packedOwnerships[index] = packed;
1576     }
1577 
1578     /**
1579      * @dev Returns the next extra data for the packed ownership data.
1580      * The returned result is shifted into position.
1581      */
1582     function _nextExtraData(
1583         address from,
1584         address to,
1585         uint256 prevOwnershipPacked
1586     ) private view returns (uint256) {
1587         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1588         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1589     }
1590 
1591     /**
1592      * @dev Called during each token transfer to set the 24bit `extraData` field.
1593      * Intended to be overridden by the cosumer contract.
1594      *
1595      * `previousExtraData` - the value of `extraData` before transfer.
1596      *
1597      * Calling conditions:
1598      *
1599      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1600      * transferred to `to`.
1601      * - When `from` is zero, `tokenId` will be minted for `to`.
1602      * - When `to` is zero, `tokenId` will be burned by `from`.
1603      * - `from` and `to` are never both zero.
1604      */
1605     function _extraData(
1606         address from,
1607         address to,
1608         uint24 previousExtraData
1609     ) internal view virtual returns (uint24) {}
1610 
1611     /**
1612      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1613      * This includes minting.
1614      * And also called before burning one token.
1615      *
1616      * startTokenId - the first token id to be transferred
1617      * quantity - the amount to be transferred
1618      *
1619      * Calling conditions:
1620      *
1621      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1622      * transferred to `to`.
1623      * - When `from` is zero, `tokenId` will be minted for `to`.
1624      * - When `to` is zero, `tokenId` will be burned by `from`.
1625      * - `from` and `to` are never both zero.
1626      */
1627     function _beforeTokenTransfers(
1628         address from,
1629         address to,
1630         uint256 startTokenId,
1631         uint256 quantity
1632     ) internal virtual {}
1633 
1634     /**
1635      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1636      * This includes minting.
1637      * And also called after one token has been burned.
1638      *
1639      * startTokenId - the first token id to be transferred
1640      * quantity - the amount to be transferred
1641      *
1642      * Calling conditions:
1643      *
1644      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1645      * transferred to `to`.
1646      * - When `from` is zero, `tokenId` has been minted for `to`.
1647      * - When `to` is zero, `tokenId` has been burned by `from`.
1648      * - `from` and `to` are never both zero.
1649      */
1650     function _afterTokenTransfers(
1651         address from,
1652         address to,
1653         uint256 startTokenId,
1654         uint256 quantity
1655     ) internal virtual {}
1656 
1657     /**
1658      * @dev Returns the message sender (defaults to `msg.sender`).
1659      *
1660      * If you are writing GSN compatible contracts, you need to override this function.
1661      */
1662     function _msgSenderERC721A() internal view virtual returns (address) {
1663         return msg.sender;
1664     }
1665 
1666     /**
1667      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1668      */
1669     function _toString(uint256 value) internal pure returns (string memory ptr) {
1670         assembly {
1671             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1672             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1673             // We will need 1 32-byte word to store the length,
1674             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1675             ptr := add(mload(0x40), 128)
1676             // Update the free memory pointer to allocate.
1677             mstore(0x40, ptr)
1678 
1679             // Cache the end of the memory to calculate the length later.
1680             let end := ptr
1681 
1682             // We write the string from the rightmost digit to the leftmost digit.
1683             // The following is essentially a do-while loop that also handles the zero case.
1684             // Costs a bit more than early returning for the zero case,
1685             // but cheaper in terms of deployment and overall runtime costs.
1686             for {
1687                 // Initialize and perform the first pass without check.
1688                 let temp := value
1689                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1690                 ptr := sub(ptr, 1)
1691                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1692                 mstore8(ptr, add(48, mod(temp, 10)))
1693                 temp := div(temp, 10)
1694             } temp {
1695                 // Keep dividing `temp` until zero.
1696                 temp := div(temp, 10)
1697             } {
1698                 // Body of the for loop.
1699                 ptr := sub(ptr, 1)
1700                 mstore8(ptr, add(48, mod(temp, 10)))
1701             }
1702 
1703             let length := sub(end, ptr)
1704             // Move the pointer 32 bytes leftwards to make room for the length.
1705             ptr := sub(ptr, 32)
1706             // Store the length.
1707             mstore(ptr, length)
1708         }
1709     }
1710 }
1711 
1712 // File: contract.sol
1713 
1714 
1715 pragma solidity ^0.8.7;
1716 
1717 
1718 
1719 
1720 
1721 
1722 contract WomenApepeYachtClub is ERC721A, Ownable, ReentrancyGuard {
1723   using Address for address;
1724   using Strings for uint;
1725 
1726   string  public  baseTokenURI = "";
1727   bool public isPublicSaleActive = false;
1728 
1729   uint256 public  maxSupply = 6666;
1730   uint256 public  MAX_MINTS_PER_TX = 10;
1731   uint256 public  PUBLIC_SALE_PRICE = 0.006 ether;
1732   uint256 public  NUM_FREE_MINTS = 6666;
1733   uint256 public  MAX_FREE_PER_WALLET = 1;
1734   uint256 public  freeNFTAlreadyMinted = 0;
1735 
1736   constructor() ERC721A("WomenApepeYachtClub", "WAYC") {}
1737 
1738   function mint(uint256 numberOfTokens) external payable
1739   {
1740     require(isPublicSaleActive, "Public sale is paused.");
1741     require(totalSupply() + numberOfTokens < maxSupply + 1, "Maximum supply exceeded.");
1742 
1743     require(numberOfTokens <= MAX_MINTS_PER_TX, "Maximum mints per transaction exceeded.");
1744 
1745     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS)
1746     {
1747         require(PUBLIC_SALE_PRICE * numberOfTokens <= msg.value, "Invalid ETH value sent. Error Code: 1");
1748     } 
1749     else 
1750     {
1751         uint sender_balance = balanceOf(msg.sender);
1752         
1753         if (sender_balance + numberOfTokens > MAX_FREE_PER_WALLET) 
1754         { 
1755             if (sender_balance < MAX_FREE_PER_WALLET)
1756             {
1757                 uint free_available = MAX_FREE_PER_WALLET - sender_balance;
1758                 uint to_be_paid = numberOfTokens - free_available;
1759                 require(PUBLIC_SALE_PRICE * to_be_paid <= msg.value, "Invalid ETH value sent. Error Code: 2");
1760 
1761                 freeNFTAlreadyMinted += free_available;
1762             }
1763             else
1764             {
1765                 require(PUBLIC_SALE_PRICE * numberOfTokens <= msg.value, "Invalid ETH value sent. Error Code: 3");
1766             }
1767         }  
1768         else 
1769         {
1770             require(numberOfTokens <= MAX_FREE_PER_WALLET, "Maximum mints per transaction exceeded");
1771             freeNFTAlreadyMinted += numberOfTokens;
1772         }
1773     }
1774 
1775     _safeMint(msg.sender, numberOfTokens);
1776   }
1777 
1778   function setBaseURI(string memory baseURI)
1779     public
1780     onlyOwner
1781   {
1782     baseTokenURI = baseURI;
1783   }
1784 
1785   function treasuryMint(uint quantity)
1786     public
1787     onlyOwner
1788   {
1789     require(quantity > 0, "Invalid mint amount");
1790     require(totalSupply() + quantity <= maxSupply, "Maximum supply exceeded");
1791 
1792     _safeMint(msg.sender, quantity);
1793   }
1794 
1795   function withdraw()
1796     public
1797     onlyOwner
1798     nonReentrant
1799   {
1800     Address.sendValue(payable(msg.sender), address(this).balance);
1801   }
1802 
1803   function tokenURI(uint _tokenId)
1804     public
1805     view
1806     virtual
1807     override
1808     returns (string memory)
1809   {
1810     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1811     
1812     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1813   }
1814 
1815   function _baseURI()
1816     internal
1817     view
1818     virtual
1819     override
1820     returns (string memory)
1821   {
1822     return baseTokenURI;
1823   }
1824 
1825   function getIsPublicSaleActive() 
1826     public
1827     view 
1828     returns (bool) {
1829       return isPublicSaleActive;
1830   }
1831 
1832   function getFreeNftAlreadyMinted() 
1833     public
1834     view 
1835     returns (uint256) {
1836       return freeNFTAlreadyMinted;
1837   }
1838 
1839   function setIsPublicSaleActive(bool _isPublicSaleActive)
1840       external
1841       onlyOwner
1842   {
1843       isPublicSaleActive = _isPublicSaleActive;
1844   }
1845 
1846   function setNumFreeMints(uint256 _numfreemints)
1847       external
1848       onlyOwner
1849   {
1850       NUM_FREE_MINTS = _numfreemints;
1851   }
1852 
1853   function getSalePrice()
1854   public
1855   view
1856   returns (uint256)
1857   {
1858     return PUBLIC_SALE_PRICE;
1859   }
1860 
1861   function setSalePrice(uint256 _price)
1862       external
1863       onlyOwner
1864   {
1865       PUBLIC_SALE_PRICE = _price;
1866   }
1867 
1868   function setMaxLimitPerTransaction(uint256 _limit)
1869       external
1870       onlyOwner
1871   {
1872       MAX_MINTS_PER_TX = _limit;
1873   }
1874 
1875   function setFreeLimitPerWallet(uint256 _limit)
1876       external
1877       onlyOwner
1878   {
1879       MAX_FREE_PER_WALLET = _limit;
1880   }
1881 }