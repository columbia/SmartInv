1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
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
486 // Creator: Chiru Labs
487 
488 pragma solidity ^0.8.4;
489 
490 /**
491  * @dev Interface of an ERC721A compliant contract.
492  */
493 interface IERC721A {
494     /**
495      * The caller must own the token or be an approved operator.
496      */
497     error ApprovalCallerNotOwnerNorApproved();
498 
499     /**
500      * The token does not exist.
501      */
502     error ApprovalQueryForNonexistentToken();
503 
504     /**
505      * The caller cannot approve to their own address.
506      */
507     error ApproveToCaller();
508 
509     /**
510      * Cannot query the balance for the zero address.
511      */
512     error BalanceQueryForZeroAddress();
513 
514     /**
515      * Cannot mint to the zero address.
516      */
517     error MintToZeroAddress();
518 
519     /**
520      * The quantity of tokens minted must be more than zero.
521      */
522     error MintZeroQuantity();
523 
524     /**
525      * The token does not exist.
526      */
527     error OwnerQueryForNonexistentToken();
528 
529     /**
530      * The caller must own the token or be an approved operator.
531      */
532     error TransferCallerNotOwnerNorApproved();
533 
534     /**
535      * The token must be owned by `from`.
536      */
537     error TransferFromIncorrectOwner();
538 
539     /**
540      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
541      */
542     error TransferToNonERC721ReceiverImplementer();
543 
544     /**
545      * Cannot transfer to the zero address.
546      */
547     error TransferToZeroAddress();
548 
549     /**
550      * The token does not exist.
551      */
552     error URIQueryForNonexistentToken();
553 
554     /**
555      * The `quantity` minted with ERC2309 exceeds the safety limit.
556      */
557     error MintERC2309QuantityExceedsLimit();
558 
559     /**
560      * The `extraData` cannot be set on an unintialized ownership slot.
561      */
562     error OwnershipNotInitializedForExtraData();
563 
564     struct TokenOwnership {
565         // The address of the owner.
566         address addr;
567         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
568         uint64 startTimestamp;
569         // Whether the token has been burned.
570         bool burned;
571         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
572         uint24 extraData;
573     }
574 
575     /**
576      * @dev Returns the total amount of tokens stored by the contract.
577      *
578      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
579      */
580     function totalSupply() external view returns (uint256);
581 
582     // ==============================
583     //            IERC165
584     // ==============================
585 
586     /**
587      * @dev Returns true if this contract implements the interface defined by
588      * `interfaceId`. See the corresponding
589      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
590      * to learn more about how these ids are created.
591      *
592      * This function call must use less than 30 000 gas.
593      */
594     function supportsInterface(bytes4 interfaceId) external view returns (bool);
595 
596     // ==============================
597     //            IERC721
598     // ==============================
599 
600     /**
601      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
602      */
603     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
604 
605     /**
606      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
607      */
608     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
609 
610     /**
611      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
612      */
613     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
614 
615     /**
616      * @dev Returns the number of tokens in ``owner``'s account.
617      */
618     function balanceOf(address owner) external view returns (uint256 balance);
619 
620     /**
621      * @dev Returns the owner of the `tokenId` token.
622      *
623      * Requirements:
624      *
625      * - `tokenId` must exist.
626      */
627     function ownerOf(uint256 tokenId) external view returns (address owner);
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`.
631      *
632      * Requirements:
633      *
634      * - `from` cannot be the zero address.
635      * - `to` cannot be the zero address.
636      * - `tokenId` token must exist and be owned by `from`.
637      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
639      *
640      * Emits a {Transfer} event.
641      */
642     function safeTransferFrom(
643         address from,
644         address to,
645         uint256 tokenId,
646         bytes calldata data
647     ) external;
648 
649     /**
650      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
651      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must exist and be owned by `from`.
658      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
659      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
660      *
661      * Emits a {Transfer} event.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId
667     ) external;
668 
669     /**
670      * @dev Transfers `tokenId` token from `from` to `to`.
671      *
672      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
673      *
674      * Requirements:
675      *
676      * - `from` cannot be the zero address.
677      * - `to` cannot be the zero address.
678      * - `tokenId` token must be owned by `from`.
679      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
680      *
681      * Emits a {Transfer} event.
682      */
683     function transferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) external;
688 
689     /**
690      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
691      * The approval is cleared when the token is transferred.
692      *
693      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
694      *
695      * Requirements:
696      *
697      * - The caller must own the token or be an approved operator.
698      * - `tokenId` must exist.
699      *
700      * Emits an {Approval} event.
701      */
702     function approve(address to, uint256 tokenId) external;
703 
704     /**
705      * @dev Approve or remove `operator` as an operator for the caller.
706      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
707      *
708      * Requirements:
709      *
710      * - The `operator` cannot be the caller.
711      *
712      * Emits an {ApprovalForAll} event.
713      */
714     function setApprovalForAll(address operator, bool _approved) external;
715 
716     /**
717      * @dev Returns the account approved for `tokenId` token.
718      *
719      * Requirements:
720      *
721      * - `tokenId` must exist.
722      */
723     function getApproved(uint256 tokenId) external view returns (address operator);
724 
725     /**
726      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
727      *
728      * See {setApprovalForAll}
729      */
730     function isApprovedForAll(address owner, address operator) external view returns (bool);
731 
732     // ==============================
733     //        IERC721Metadata
734     // ==============================
735 
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 
751     // ==============================
752     //            IERC2309
753     // ==============================
754 
755     /**
756      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
757      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
758      */
759     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
760 }
761 
762 // File: erc721a/contracts/ERC721A.sol
763 
764 
765 // ERC721A Contracts v4.1.0
766 // Creator: Chiru Labs
767 
768 pragma solidity ^0.8.4;
769 
770 
771 /**
772  * @dev ERC721 token receiver interface.
773  */
774 interface ERC721A__IERC721Receiver {
775     function onERC721Received(
776         address operator,
777         address from,
778         uint256 tokenId,
779         bytes calldata data
780     ) external returns (bytes4);
781 }
782 
783 /**
784  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
785  * including the Metadata extension. Built to optimize for lower gas during batch mints.
786  *
787  * Assumes serials are sequentially minted starting at `_startTokenId()`
788  * (defaults to 0, e.g. 0, 1, 2, 3..).
789  *
790  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
791  *
792  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
793  */
794 contract ERC721A is IERC721A {
795     // Mask of an entry in packed address data.
796     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
797 
798     // The bit position of `numberMinted` in packed address data.
799     uint256 private constant BITPOS_NUMBER_MINTED = 64;
800 
801     // The bit position of `numberBurned` in packed address data.
802     uint256 private constant BITPOS_NUMBER_BURNED = 128;
803 
804     // The bit position of `aux` in packed address data.
805     uint256 private constant BITPOS_AUX = 192;
806 
807     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
808     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
809 
810     // The bit position of `startTimestamp` in packed ownership.
811     uint256 private constant BITPOS_START_TIMESTAMP = 160;
812 
813     // The bit mask of the `burned` bit in packed ownership.
814     uint256 private constant BITMASK_BURNED = 1 << 224;
815 
816     // The bit position of the `nextInitialized` bit in packed ownership.
817     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
818 
819     // The bit mask of the `nextInitialized` bit in packed ownership.
820     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
821 
822     // The bit position of `extraData` in packed ownership.
823     uint256 private constant BITPOS_EXTRA_DATA = 232;
824 
825     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
826     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
827 
828     // The mask of the lower 160 bits for addresses.
829     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
830 
831     // The maximum `quantity` that can be minted with `_mintERC2309`.
832     // This limit is to prevent overflows on the address data entries.
833     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
834     // is required to cause an overflow, which is unrealistic.
835     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
836 
837     // The tokenId of the next token to be minted.
838     uint256 private _currentIndex;
839 
840     // The number of tokens burned.
841     uint256 private _burnCounter;
842 
843     // Token name
844     string private _name;
845 
846     // Token symbol
847     string private _symbol;
848 
849     // Mapping from token ID to ownership details
850     // An empty struct value does not necessarily mean the token is unowned.
851     // See `_packedOwnershipOf` implementation for details.
852     //
853     // Bits Layout:
854     // - [0..159]   `addr`
855     // - [160..223] `startTimestamp`
856     // - [224]      `burned`
857     // - [225]      `nextInitialized`
858     // - [232..255] `extraData`
859     mapping(uint256 => uint256) private _packedOwnerships;
860 
861     // Mapping owner address to address data.
862     //
863     // Bits Layout:
864     // - [0..63]    `balance`
865     // - [64..127]  `numberMinted`
866     // - [128..191] `numberBurned`
867     // - [192..255] `aux`
868     mapping(address => uint256) private _packedAddressData;
869 
870     // Mapping from token ID to approved address.
871     mapping(uint256 => address) private _tokenApprovals;
872 
873     // Mapping from owner to operator approvals
874     mapping(address => mapping(address => bool)) private _operatorApprovals;
875 
876     constructor(string memory name_, string memory symbol_) {
877         _name = name_;
878         _symbol = symbol_;
879         _currentIndex = _startTokenId();
880     }
881 
882     /**
883      * @dev Returns the starting token ID.
884      * To change the starting token ID, please override this function.
885      */
886     function _startTokenId() internal view virtual returns (uint256) {
887         return 0;
888     }
889 
890     /**
891      * @dev Returns the next token ID to be minted.
892      */
893     function _nextTokenId() internal view returns (uint256) {
894         return _currentIndex;
895     }
896 
897     /**
898      * @dev Returns the total number of tokens in existence.
899      * Burned tokens will reduce the count.
900      * To get the total number of tokens minted, please see `_totalMinted`.
901      */
902     function totalSupply() public view override returns (uint256) {
903         // Counter underflow is impossible as _burnCounter cannot be incremented
904         // more than `_currentIndex - _startTokenId()` times.
905         unchecked {
906             return _currentIndex - _burnCounter - _startTokenId();
907         }
908     }
909 
910     /**
911      * @dev Returns the total amount of tokens minted in the contract.
912      */
913     function _totalMinted() internal view returns (uint256) {
914         // Counter underflow is impossible as _currentIndex does not decrement,
915         // and it is initialized to `_startTokenId()`
916         unchecked {
917             return _currentIndex - _startTokenId();
918         }
919     }
920 
921     /**
922      * @dev Returns the total number of tokens burned.
923      */
924     function _totalBurned() internal view returns (uint256) {
925         return _burnCounter;
926     }
927 
928     /**
929      * @dev See {IERC165-supportsInterface}.
930      */
931     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
932         // The interface IDs are constants representing the first 4 bytes of the XOR of
933         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
934         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
935         return
936             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
937             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
938             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
939     }
940 
941     /**
942      * @dev See {IERC721-balanceOf}.
943      */
944     function balanceOf(address owner) public view override returns (uint256) {
945         if (owner == address(0)) revert BalanceQueryForZeroAddress();
946         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
947     }
948 
949     /**
950      * Returns the number of tokens minted by `owner`.
951      */
952     function _numberMinted(address owner) internal view returns (uint256) {
953         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
954     }
955 
956     /**
957      * Returns the number of tokens burned by or on behalf of `owner`.
958      */
959     function _numberBurned(address owner) internal view returns (uint256) {
960         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
961     }
962 
963     /**
964      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
965      */
966     function _getAux(address owner) internal view returns (uint64) {
967         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
968     }
969 
970     /**
971      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
972      * If there are multiple variables, please pack them into a uint64.
973      */
974     function _setAux(address owner, uint64 aux) internal {
975         uint256 packed = _packedAddressData[owner];
976         uint256 auxCasted;
977         // Cast `aux` with assembly to avoid redundant masking.
978         assembly {
979             auxCasted := aux
980         }
981         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
982         _packedAddressData[owner] = packed;
983     }
984 
985     /**
986      * Returns the packed ownership data of `tokenId`.
987      */
988     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
989         uint256 curr = tokenId;
990 
991         unchecked {
992             if (_startTokenId() <= curr)
993                 if (curr < _currentIndex) {
994                     uint256 packed = _packedOwnerships[curr];
995                     // If not burned.
996                     if (packed & BITMASK_BURNED == 0) {
997                         // Invariant:
998                         // There will always be an ownership that has an address and is not burned
999                         // before an ownership that does not have an address and is not burned.
1000                         // Hence, curr will not underflow.
1001                         //
1002                         // We can directly compare the packed value.
1003                         // If the address is zero, packed is zero.
1004                         while (packed == 0) {
1005                             packed = _packedOwnerships[--curr];
1006                         }
1007                         return packed;
1008                     }
1009                 }
1010         }
1011         revert OwnerQueryForNonexistentToken();
1012     }
1013 
1014     /**
1015      * Returns the unpacked `TokenOwnership` struct from `packed`.
1016      */
1017     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1018         ownership.addr = address(uint160(packed));
1019         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1020         ownership.burned = packed & BITMASK_BURNED != 0;
1021         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1022     }
1023 
1024     /**
1025      * Returns the unpacked `TokenOwnership` struct at `index`.
1026      */
1027     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1028         return _unpackedOwnership(_packedOwnerships[index]);
1029     }
1030 
1031     /**
1032      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1033      */
1034     function _initializeOwnershipAt(uint256 index) internal {
1035         if (_packedOwnerships[index] == 0) {
1036             _packedOwnerships[index] = _packedOwnershipOf(index);
1037         }
1038     }
1039 
1040     /**
1041      * Gas spent here starts off proportional to the maximum mint batch size.
1042      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1043      */
1044     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1045         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1046     }
1047 
1048     /**
1049      * @dev Packs ownership data into a single uint256.
1050      */
1051     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1052         assembly {
1053             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1054             owner := and(owner, BITMASK_ADDRESS)
1055             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1056             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1057         }
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-ownerOf}.
1062      */
1063     function ownerOf(uint256 tokenId) public view override returns (address) {
1064         return address(uint160(_packedOwnershipOf(tokenId)));
1065     }
1066 
1067     /**
1068      * @dev See {IERC721Metadata-name}.
1069      */
1070     function name() public view virtual override returns (string memory) {
1071         return _name;
1072     }
1073 
1074     /**
1075      * @dev See {IERC721Metadata-symbol}.
1076      */
1077     function symbol() public view virtual override returns (string memory) {
1078         return _symbol;
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Metadata-tokenURI}.
1083      */
1084     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1085         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1086 
1087         string memory baseURI = _baseURI();
1088         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1089     }
1090 
1091     /**
1092      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1093      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1094      * by default, it can be overridden in child contracts.
1095      */
1096     function _baseURI() internal view virtual returns (string memory) {
1097         return '';
1098     }
1099 
1100     /**
1101      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1102      */
1103     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1104         // For branchless setting of the `nextInitialized` flag.
1105         assembly {
1106             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1107             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1108         }
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-approve}.
1113      */
1114     function approve(address to, uint256 tokenId) public override {
1115         address owner = ownerOf(tokenId);
1116 
1117         if (_msgSenderERC721A() != owner)
1118             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1119                 revert ApprovalCallerNotOwnerNorApproved();
1120             }
1121 
1122         _tokenApprovals[tokenId] = to;
1123         emit Approval(owner, to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-getApproved}.
1128      */
1129     function getApproved(uint256 tokenId) public view override returns (address) {
1130         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1131 
1132         return _tokenApprovals[tokenId];
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-setApprovalForAll}.
1137      */
1138     function setApprovalForAll(address operator, bool approved) public virtual override {
1139         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1140 
1141         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1142         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-isApprovedForAll}.
1147      */
1148     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1149         return _operatorApprovals[owner][operator];
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-safeTransferFrom}.
1154      */
1155     function safeTransferFrom(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) public virtual override {
1160         safeTransferFrom(from, to, tokenId, '');
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-safeTransferFrom}.
1165      */
1166     function safeTransferFrom(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes memory _data
1171     ) public virtual override {
1172         transferFrom(from, to, tokenId);
1173         if (to.code.length != 0)
1174             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1175                 revert TransferToNonERC721ReceiverImplementer();
1176             }
1177     }
1178 
1179     /**
1180      * @dev Returns whether `tokenId` exists.
1181      *
1182      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1183      *
1184      * Tokens start existing when they are minted (`_mint`),
1185      */
1186     function _exists(uint256 tokenId) internal view returns (bool) {
1187         return
1188             _startTokenId() <= tokenId &&
1189             tokenId < _currentIndex && // If within bounds,
1190             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1191     }
1192 
1193     /**
1194      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1195      */
1196     function _safeMint(address to, uint256 quantity) internal {
1197         _safeMint(to, quantity, '');
1198     }
1199 
1200     /**
1201      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1202      *
1203      * Requirements:
1204      *
1205      * - If `to` refers to a smart contract, it must implement
1206      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1207      * - `quantity` must be greater than 0.
1208      *
1209      * See {_mint}.
1210      *
1211      * Emits a {Transfer} event for each mint.
1212      */
1213     function _safeMint(
1214         address to,
1215         uint256 quantity,
1216         bytes memory _data
1217     ) internal {
1218         _mint(to, quantity);
1219 
1220         unchecked {
1221             if (to.code.length != 0) {
1222                 uint256 end = _currentIndex;
1223                 uint256 index = end - quantity;
1224                 do {
1225                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1226                         revert TransferToNonERC721ReceiverImplementer();
1227                     }
1228                 } while (index < end);
1229                 // Reentrancy protection.
1230                 if (_currentIndex != end) revert();
1231             }
1232         }
1233     }
1234 
1235     /**
1236      * @dev Mints `quantity` tokens and transfers them to `to`.
1237      *
1238      * Requirements:
1239      *
1240      * - `to` cannot be the zero address.
1241      * - `quantity` must be greater than 0.
1242      *
1243      * Emits a {Transfer} event for each mint.
1244      */
1245     function _mint(address to, uint256 quantity) internal {
1246         uint256 startTokenId = _currentIndex;
1247         if (to == address(0)) revert MintToZeroAddress();
1248         if (quantity == 0) revert MintZeroQuantity();
1249 
1250         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1251 
1252         // Overflows are incredibly unrealistic.
1253         // `balance` and `numberMinted` have a maximum limit of 2**64.
1254         // `tokenId` has a maximum limit of 2**256.
1255         unchecked {
1256             // Updates:
1257             // - `balance += quantity`.
1258             // - `numberMinted += quantity`.
1259             //
1260             // We can directly add to the `balance` and `numberMinted`.
1261             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1262 
1263             // Updates:
1264             // - `address` to the owner.
1265             // - `startTimestamp` to the timestamp of minting.
1266             // - `burned` to `false`.
1267             // - `nextInitialized` to `quantity == 1`.
1268             _packedOwnerships[startTokenId] = _packOwnershipData(
1269                 to,
1270                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1271             );
1272 
1273             uint256 tokenId = startTokenId;
1274             uint256 end = startTokenId + quantity;
1275             do {
1276                 emit Transfer(address(0), to, tokenId++);
1277             } while (tokenId < end);
1278 
1279             _currentIndex = end;
1280         }
1281         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1282     }
1283 
1284     /**
1285      * @dev Mints `quantity` tokens and transfers them to `to`.
1286      *
1287      * This function is intended for efficient minting only during contract creation.
1288      *
1289      * It emits only one {ConsecutiveTransfer} as defined in
1290      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1291      * instead of a sequence of {Transfer} event(s).
1292      *
1293      * Calling this function outside of contract creation WILL make your contract
1294      * non-compliant with the ERC721 standard.
1295      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1296      * {ConsecutiveTransfer} event is only permissible during contract creation.
1297      *
1298      * Requirements:
1299      *
1300      * - `to` cannot be the zero address.
1301      * - `quantity` must be greater than 0.
1302      *
1303      * Emits a {ConsecutiveTransfer} event.
1304      */
1305     function _mintERC2309(address to, uint256 quantity) internal {
1306         uint256 startTokenId = _currentIndex;
1307         if (to == address(0)) revert MintToZeroAddress();
1308         if (quantity == 0) revert MintZeroQuantity();
1309         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1310 
1311         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1312 
1313         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1314         unchecked {
1315             // Updates:
1316             // - `balance += quantity`.
1317             // - `numberMinted += quantity`.
1318             //
1319             // We can directly add to the `balance` and `numberMinted`.
1320             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1321 
1322             // Updates:
1323             // - `address` to the owner.
1324             // - `startTimestamp` to the timestamp of minting.
1325             // - `burned` to `false`.
1326             // - `nextInitialized` to `quantity == 1`.
1327             _packedOwnerships[startTokenId] = _packOwnershipData(
1328                 to,
1329                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1330             );
1331 
1332             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1333 
1334             _currentIndex = startTokenId + quantity;
1335         }
1336         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1337     }
1338 
1339     /**
1340      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1341      */
1342     function _getApprovedAddress(uint256 tokenId)
1343         private
1344         view
1345         returns (uint256 approvedAddressSlot, address approvedAddress)
1346     {
1347         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1348         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1349         assembly {
1350             // Compute the slot.
1351             mstore(0x00, tokenId)
1352             mstore(0x20, tokenApprovalsPtr.slot)
1353             approvedAddressSlot := keccak256(0x00, 0x40)
1354             // Load the slot's value from storage.
1355             approvedAddress := sload(approvedAddressSlot)
1356         }
1357     }
1358 
1359     /**
1360      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1361      */
1362     function _isOwnerOrApproved(
1363         address approvedAddress,
1364         address from,
1365         address msgSender
1366     ) private pure returns (bool result) {
1367         assembly {
1368             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1369             from := and(from, BITMASK_ADDRESS)
1370             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1371             msgSender := and(msgSender, BITMASK_ADDRESS)
1372             // `msgSender == from || msgSender == approvedAddress`.
1373             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1374         }
1375     }
1376 
1377     /**
1378      * @dev Transfers `tokenId` from `from` to `to`.
1379      *
1380      * Requirements:
1381      *
1382      * - `to` cannot be the zero address.
1383      * - `tokenId` token must be owned by `from`.
1384      *
1385      * Emits a {Transfer} event.
1386      */
1387     function transferFrom(
1388         address from,
1389         address to,
1390         uint256 tokenId
1391     ) public virtual override {
1392         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1393 
1394         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1395 
1396         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1397 
1398         // The nested ifs save around 20+ gas over a compound boolean condition.
1399         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1400             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1401 
1402         if (to == address(0)) revert TransferToZeroAddress();
1403 
1404         _beforeTokenTransfers(from, to, tokenId, 1);
1405 
1406         // Clear approvals from the previous owner.
1407         assembly {
1408             if approvedAddress {
1409                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1410                 sstore(approvedAddressSlot, 0)
1411             }
1412         }
1413 
1414         // Underflow of the sender's balance is impossible because we check for
1415         // ownership above and the recipient's balance can't realistically overflow.
1416         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1417         unchecked {
1418             // We can directly increment and decrement the balances.
1419             --_packedAddressData[from]; // Updates: `balance -= 1`.
1420             ++_packedAddressData[to]; // Updates: `balance += 1`.
1421 
1422             // Updates:
1423             // - `address` to the next owner.
1424             // - `startTimestamp` to the timestamp of transfering.
1425             // - `burned` to `false`.
1426             // - `nextInitialized` to `true`.
1427             _packedOwnerships[tokenId] = _packOwnershipData(
1428                 to,
1429                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1430             );
1431 
1432             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1433             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1434                 uint256 nextTokenId = tokenId + 1;
1435                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1436                 if (_packedOwnerships[nextTokenId] == 0) {
1437                     // If the next slot is within bounds.
1438                     if (nextTokenId != _currentIndex) {
1439                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1440                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1441                     }
1442                 }
1443             }
1444         }
1445 
1446         emit Transfer(from, to, tokenId);
1447         _afterTokenTransfers(from, to, tokenId, 1);
1448     }
1449 
1450     /**
1451      * @dev Equivalent to `_burn(tokenId, false)`.
1452      */
1453     function _burn(uint256 tokenId) internal virtual {
1454         _burn(tokenId, false);
1455     }
1456 
1457     /**
1458      * @dev Destroys `tokenId`.
1459      * The approval is cleared when the token is burned.
1460      *
1461      * Requirements:
1462      *
1463      * - `tokenId` must exist.
1464      *
1465      * Emits a {Transfer} event.
1466      */
1467     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1468         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1469 
1470         address from = address(uint160(prevOwnershipPacked));
1471 
1472         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1473 
1474         if (approvalCheck) {
1475             // The nested ifs save around 20+ gas over a compound boolean condition.
1476             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1477                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1478         }
1479 
1480         _beforeTokenTransfers(from, address(0), tokenId, 1);
1481 
1482         // Clear approvals from the previous owner.
1483         assembly {
1484             if approvedAddress {
1485                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1486                 sstore(approvedAddressSlot, 0)
1487             }
1488         }
1489 
1490         // Underflow of the sender's balance is impossible because we check for
1491         // ownership above and the recipient's balance can't realistically overflow.
1492         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1493         unchecked {
1494             // Updates:
1495             // - `balance -= 1`.
1496             // - `numberBurned += 1`.
1497             //
1498             // We can directly decrement the balance, and increment the number burned.
1499             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1500             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1501 
1502             // Updates:
1503             // - `address` to the last owner.
1504             // - `startTimestamp` to the timestamp of burning.
1505             // - `burned` to `true`.
1506             // - `nextInitialized` to `true`.
1507             _packedOwnerships[tokenId] = _packOwnershipData(
1508                 from,
1509                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1510             );
1511 
1512             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1513             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1514                 uint256 nextTokenId = tokenId + 1;
1515                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1516                 if (_packedOwnerships[nextTokenId] == 0) {
1517                     // If the next slot is within bounds.
1518                     if (nextTokenId != _currentIndex) {
1519                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1520                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1521                     }
1522                 }
1523             }
1524         }
1525 
1526         emit Transfer(from, address(0), tokenId);
1527         _afterTokenTransfers(from, address(0), tokenId, 1);
1528 
1529         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1530         unchecked {
1531             _burnCounter++;
1532         }
1533     }
1534 
1535     /**
1536      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1537      *
1538      * @param from address representing the previous owner of the given token ID
1539      * @param to target address that will receive the tokens
1540      * @param tokenId uint256 ID of the token to be transferred
1541      * @param _data bytes optional data to send along with the call
1542      * @return bool whether the call correctly returned the expected magic value
1543      */
1544     function _checkContractOnERC721Received(
1545         address from,
1546         address to,
1547         uint256 tokenId,
1548         bytes memory _data
1549     ) private returns (bool) {
1550         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1551             bytes4 retval
1552         ) {
1553             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1554         } catch (bytes memory reason) {
1555             if (reason.length == 0) {
1556                 revert TransferToNonERC721ReceiverImplementer();
1557             } else {
1558                 assembly {
1559                     revert(add(32, reason), mload(reason))
1560                 }
1561             }
1562         }
1563     }
1564 
1565     /**
1566      * @dev Directly sets the extra data for the ownership data `index`.
1567      */
1568     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1569         uint256 packed = _packedOwnerships[index];
1570         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1571         uint256 extraDataCasted;
1572         // Cast `extraData` with assembly to avoid redundant masking.
1573         assembly {
1574             extraDataCasted := extraData
1575         }
1576         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1577         _packedOwnerships[index] = packed;
1578     }
1579 
1580     /**
1581      * @dev Returns the next extra data for the packed ownership data.
1582      * The returned result is shifted into position.
1583      */
1584     function _nextExtraData(
1585         address from,
1586         address to,
1587         uint256 prevOwnershipPacked
1588     ) private view returns (uint256) {
1589         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1590         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1591     }
1592 
1593     /**
1594      * @dev Called during each token transfer to set the 24bit `extraData` field.
1595      * Intended to be overridden by the cosumer contract.
1596      *
1597      * `previousExtraData` - the value of `extraData` before transfer.
1598      *
1599      * Calling conditions:
1600      *
1601      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1602      * transferred to `to`.
1603      * - When `from` is zero, `tokenId` will be minted for `to`.
1604      * - When `to` is zero, `tokenId` will be burned by `from`.
1605      * - `from` and `to` are never both zero.
1606      */
1607     function _extraData(
1608         address from,
1609         address to,
1610         uint24 previousExtraData
1611     ) internal view virtual returns (uint24) {}
1612 
1613     /**
1614      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1615      * This includes minting.
1616      * And also called before burning one token.
1617      *
1618      * startTokenId - the first token id to be transferred
1619      * quantity - the amount to be transferred
1620      *
1621      * Calling conditions:
1622      *
1623      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1624      * transferred to `to`.
1625      * - When `from` is zero, `tokenId` will be minted for `to`.
1626      * - When `to` is zero, `tokenId` will be burned by `from`.
1627      * - `from` and `to` are never both zero.
1628      */
1629     function _beforeTokenTransfers(
1630         address from,
1631         address to,
1632         uint256 startTokenId,
1633         uint256 quantity
1634     ) internal virtual {}
1635 
1636     /**
1637      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1638      * This includes minting.
1639      * And also called after one token has been burned.
1640      *
1641      * startTokenId - the first token id to be transferred
1642      * quantity - the amount to be transferred
1643      *
1644      * Calling conditions:
1645      *
1646      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1647      * transferred to `to`.
1648      * - When `from` is zero, `tokenId` has been minted for `to`.
1649      * - When `to` is zero, `tokenId` has been burned by `from`.
1650      * - `from` and `to` are never both zero.
1651      */
1652     function _afterTokenTransfers(
1653         address from,
1654         address to,
1655         uint256 startTokenId,
1656         uint256 quantity
1657     ) internal virtual {}
1658 
1659     /**
1660      * @dev Returns the message sender (defaults to `msg.sender`).
1661      *
1662      * If you are writing GSN compatible contracts, you need to override this function.
1663      */
1664     function _msgSenderERC721A() internal view virtual returns (address) {
1665         return msg.sender;
1666     }
1667 
1668     /**
1669      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1670      */
1671     function _toString(uint256 value) internal pure returns (string memory ptr) {
1672         assembly {
1673             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1674             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1675             // We will need 1 32-byte word to store the length,
1676             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1677             ptr := add(mload(0x40), 128)
1678             // Update the free memory pointer to allocate.
1679             mstore(0x40, ptr)
1680 
1681             // Cache the end of the memory to calculate the length later.
1682             let end := ptr
1683 
1684             // We write the string from the rightmost digit to the leftmost digit.
1685             // The following is essentially a do-while loop that also handles the zero case.
1686             // Costs a bit more than early returning for the zero case,
1687             // but cheaper in terms of deployment and overall runtime costs.
1688             for {
1689                 // Initialize and perform the first pass without check.
1690                 let temp := value
1691                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1692                 ptr := sub(ptr, 1)
1693                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1694                 mstore8(ptr, add(48, mod(temp, 10)))
1695                 temp := div(temp, 10)
1696             } temp {
1697                 // Keep dividing `temp` until zero.
1698                 temp := div(temp, 10)
1699             } {
1700                 // Body of the for loop.
1701                 ptr := sub(ptr, 1)
1702                 mstore8(ptr, add(48, mod(temp, 10)))
1703             }
1704 
1705             let length := sub(end, ptr)
1706             // Move the pointer 32 bytes leftwards to make room for the length.
1707             ptr := sub(ptr, 32)
1708             // Store the length.
1709             mstore(ptr, length)
1710         }
1711     }
1712 }
1713 
1714 // File: contracts/Tem.sol
1715 
1716 
1717 
1718 
1719 pragma solidity ^0.8.4;
1720 
1721 
1722 
1723 contract DirtyKong is ERC721A, Ownable, ReentrancyGuard {
1724     using Address for address;
1725     using Strings for uint;
1726     string  public baseTokenURI = "ipfs://bafybeigfwavc3wcdg5cb4l4v5strxdtecfdin3v7uwqef7z6gszih2lhyq/";
1727     uint256 public MAX_SUPPLY = 5555;
1728     uint256 public MAX_FREE_SUPPLY = 5555;
1729     uint256 public MAX_PER_TX = 20;
1730     uint256 public PRICE = 0.003 ether;
1731     uint256 public MAX_FREE_PER_WALLET = 1;
1732     bool public initialize = false;
1733     bool public revealed = false;
1734 
1735     mapping(address => uint256) public qtyFreeMinted;
1736 
1737     constructor() ERC721A("Dirty Kong", "DK") {}
1738 
1739 
1740     function devMint(address to, uint count) external onlyOwner {
1741 		require(
1742 			_totalMinted() + count <= MAX_SUPPLY,
1743 			'Exceeds max supply'
1744 		);
1745 		_safeMint(to, count);
1746 	}
1747 
1748     function mint(uint256 amount) external payable
1749     {
1750         require(initialize, "Minting is not live yet.");
1751 		require(amount <= MAX_PER_TX,"Exceeds NFT per transaction limit");
1752 		require(_totalMinted() + amount <= MAX_SUPPLY,"Exceeds max supply");
1753 
1754         uint payForCount = amount;
1755         uint mintedSoFar = qtyFreeMinted[msg.sender];
1756         if(mintedSoFar < MAX_FREE_PER_WALLET) {
1757             uint remainingFreeMints = MAX_FREE_PER_WALLET - mintedSoFar;
1758             if(amount > remainingFreeMints) {
1759                 payForCount = amount - remainingFreeMints;
1760             }
1761             else {
1762                 payForCount = 0;
1763             }
1764         }
1765 
1766 		require(
1767 			msg.value >= payForCount * PRICE,
1768 			'Ether value sent is not sufficient'
1769 		);
1770     	qtyFreeMinted[msg.sender] += amount;
1771 
1772         _safeMint(msg.sender, amount);
1773     }
1774 
1775     function setBaseURI(string memory baseURI) public onlyOwner
1776     {
1777         baseTokenURI = baseURI;
1778     }
1779 
1780     function _startTokenId() internal view virtual override returns (uint256) {
1781         return 1;
1782     }
1783     function withdraw() public onlyOwner nonReentrant {
1784         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1785         require(os);
1786     }
1787 
1788     function tokenURI(uint tokenId)
1789 		public
1790 		view
1791 		override
1792 		returns (string memory)
1793 	{
1794         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1795 
1796         return bytes(_baseURI()).length > 0 
1797             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1798             : baseTokenURI;
1799 	}
1800 
1801     function _baseURI() internal view virtual override returns (string memory)
1802     {
1803         return baseTokenURI;
1804     }
1805 
1806     function reveal(bool _revealed) external onlyOwner
1807     {
1808         revealed = _revealed;
1809     }
1810 
1811     function setInitialize(bool _initialize) external onlyOwner
1812     {
1813         initialize = _initialize;
1814     }
1815 
1816     function setPrice(uint256 _price) external onlyOwner
1817     {
1818         PRICE = _price;
1819     }
1820 
1821     function setMaxLimitPerTransaction(uint256 _limit) external onlyOwner
1822     {
1823         MAX_PER_TX = _limit;
1824     }
1825 
1826     function setLimitFreeMintPerWallet(uint256 _limit) external onlyOwner
1827     {
1828         MAX_FREE_PER_WALLET = _limit;
1829     }
1830 
1831     function setMaxFreeAmount(uint256 _amount) external onlyOwner
1832     {
1833         MAX_FREE_SUPPLY = _amount;
1834     }
1835 
1836 }