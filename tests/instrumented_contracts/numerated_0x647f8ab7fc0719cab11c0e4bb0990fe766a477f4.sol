1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 
7 
8 
9 //    _____________  __    ________________  __  ________
10 //   / ____/_  __/ |/ /   / ____/ ____/ __ \/  |/  / ___/
11 //  / /_    / /  |   /   / / __/ __/ / /_/ / /|_/ /\__ \ 
12 // / __/   / /  /   |   / /_/ / /___/ _, _/ /  / /___/ / 
13 ///_/     /_/  /_/|_|   \____/_____/_/ |_/_/  /_//____/  
14                                                        
15 
16 
17                                                                                
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26     uint8 private constant _ADDRESS_LENGTH = 20;
27 
28     /**
29      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
30      */
31     function toString(uint256 value) internal pure returns (string memory) {
32         // Inspired by OraclizeAPI's implementation - MIT licence
33         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
34 
35         if (value == 0) {
36             return "0";
37         }
38         uint256 temp = value;
39         uint256 digits;
40         while (temp != 0) {
41             digits++;
42             temp /= 10;
43         }
44         bytes memory buffer = new bytes(digits);
45         while (value != 0) {
46             digits -= 1;
47             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
48             value /= 10;
49         }
50         return string(buffer);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
55      */
56     function toHexString(uint256 value) internal pure returns (string memory) {
57         if (value == 0) {
58             return "0x00";
59         }
60         uint256 temp = value;
61         uint256 length = 0;
62         while (temp != 0) {
63             length++;
64             temp >>= 8;
65         }
66         return toHexString(value, length);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
71      */
72     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
73         bytes memory buffer = new bytes(2 * length + 2);
74         buffer[0] = "0";
75         buffer[1] = "x";
76         for (uint256 i = 2 * length + 1; i > 1; --i) {
77             buffer[i] = _HEX_SYMBOLS[value & 0xf];
78             value >>= 4;
79         }
80         require(value == 0, "Strings: hex length insufficient");
81         return string(buffer);
82     }
83 
84     /**
85      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
86      */
87     function toHexString(address addr) internal pure returns (string memory) {
88         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/Address.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
96 
97 pragma solidity ^0.8.1;
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      *
120      * [IMPORTANT]
121      * ====
122      * You shouldn't rely on `isContract` to protect against flash loan attacks!
123      *
124      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
125      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
126      * constructor.
127      * ====
128      */
129     function isContract(address account) internal view returns (bool) {
130         // This method relies on extcodesize/address.code.length, which returns 0
131         // for contracts in construction, since the code is only stored at the end
132         // of the constructor execution.
133 
134         return account.code.length > 0;
135     }
136 
137     /**
138      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
139      * `recipient`, forwarding all available gas and reverting on errors.
140      *
141      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
142      * of certain opcodes, possibly making contracts go over the 2300 gas limit
143      * imposed by `transfer`, making them unable to receive funds via
144      * `transfer`. {sendValue} removes this limitation.
145      *
146      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
147      *
148      * IMPORTANT: because control is transferred to `recipient`, care must be
149      * taken to not create reentrancy vulnerabilities. Consider using
150      * {ReentrancyGuard} or the
151      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
152      */
153     function sendValue(address payable recipient, uint256 amount) internal {
154         require(address(this).balance >= amount, "Address: insufficient balance");
155 
156         (bool success, ) = recipient.call{value: amount}("");
157         require(success, "Address: unable to send value, recipient may have reverted");
158     }
159 
160     /**
161      * @dev Performs a Solidity function call using a low level `call`. A
162      * plain `call` is an unsafe replacement for a function call: use this
163      * function instead.
164      *
165      * If `target` reverts with a revert reason, it is bubbled up by this
166      * function (like regular Solidity function calls).
167      *
168      * Returns the raw returned data. To convert to the expected return value,
169      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
170      *
171      * Requirements:
172      *
173      * - `target` must be a contract.
174      * - calling `target` with `data` must not revert.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionCall(target, data, "Address: low-level call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
184      * `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, 0, errorMessage);
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
198      * but also transferring `value` wei to `target`.
199      *
200      * Requirements:
201      *
202      * - the calling contract must have an ETH balance of at least `value`.
203      * - the called Solidity function must be `payable`.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
217      * with `errorMessage` as a fallback revert reason when `target` reverts.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value,
225         string memory errorMessage
226     ) internal returns (bytes memory) {
227         require(address(this).balance >= value, "Address: insufficient balance for call");
228         require(isContract(target), "Address: call to non-contract");
229 
230         (bool success, bytes memory returndata) = target.call{value: value}(data);
231         return verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
241         return functionStaticCall(target, data, "Address: low-level static call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
246      * but performing a static call.
247      *
248      * _Available since v3.3._
249      */
250     function functionStaticCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal view returns (bytes memory) {
255         require(isContract(target), "Address: static call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.staticcall(data);
258         return verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
273      * but performing a delegate call.
274      *
275      * _Available since v3.4._
276      */
277     function functionDelegateCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         require(isContract(target), "Address: delegate call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.delegatecall(data);
285         return verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
290      * revert reason using the provided one.
291      *
292      * _Available since v4.3._
293      */
294     function verifyCallResult(
295         bool success,
296         bytes memory returndata,
297         string memory errorMessage
298     ) internal pure returns (bytes memory) {
299         if (success) {
300             return returndata;
301         } else {
302             // Look for revert reason and bubble it up if present
303             if (returndata.length > 0) {
304                 // The easiest way to bubble the revert reason is using memory via assembly
305                 /// @solidity memory-safe-assembly
306                 assembly {
307                     let returndata_size := mload(returndata)
308                     revert(add(32, returndata), returndata_size)
309                 }
310             } else {
311                 revert(errorMessage);
312             }
313         }
314     }
315 }
316 
317 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev Contract module that helps prevent reentrant calls to a function.
326  *
327  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
328  * available, which can be applied to functions to make sure there are no nested
329  * (reentrant) calls to them.
330  *
331  * Note that because there is a single `nonReentrant` guard, functions marked as
332  * `nonReentrant` may not call one another. This can be worked around by making
333  * those functions `private`, and then adding `external` `nonReentrant` entry
334  * points to them.
335  *
336  * TIP: If you would like to learn more about reentrancy and alternative ways
337  * to protect against it, check out our blog post
338  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
339  */
340 abstract contract ReentrancyGuard {
341     // Booleans are more expensive than uint256 or any type that takes up a full
342     // word because each write operation emits an extra SLOAD to first read the
343     // slot's contents, replace the bits taken up by the boolean, and then write
344     // back. This is the compiler's defense against contract upgrades and
345     // pointer aliasing, and it cannot be disabled.
346 
347     // The values being non-zero value makes deployment a bit more expensive,
348     // but in exchange the refund on every call to nonReentrant will be lower in
349     // amount. Since refunds are capped to a percentage of the total
350     // transaction's gas, it is best to keep them low in cases like this one, to
351     // increase the likelihood of the full refund coming into effect.
352     uint256 private constant _NOT_ENTERED = 1;
353     uint256 private constant _ENTERED = 2;
354 
355     uint256 private _status;
356 
357     constructor() {
358         _status = _NOT_ENTERED;
359     }
360 
361     /**
362      * @dev Prevents a contract from calling itself, directly or indirectly.
363      * Calling a `nonReentrant` function from another `nonReentrant`
364      * function is not supported. It is possible to prevent this from happening
365      * by making the `nonReentrant` function external, and making it call a
366      * `private` function that does the actual work.
367      */
368     modifier nonReentrant() {
369         // On the first call to nonReentrant, _notEntered will be true
370         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
371 
372         // Any calls to nonReentrant after this point will fail
373         _status = _ENTERED;
374 
375         _;
376 
377         // By storing the original value once again, a refund is triggered (see
378         // https://eips.ethereum.org/EIPS/eip-2200)
379         _status = _NOT_ENTERED;
380     }
381 }
382 
383 // File: @openzeppelin/contracts/utils/Context.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 /**
391  * @dev Provides information about the current execution context, including the
392  * sender of the transaction and its data. While these are generally available
393  * via msg.sender and msg.data, they should not be accessed in such a direct
394  * manner, since when dealing with meta-transactions the account sending and
395  * paying for execution may not be the actual sender (as far as an application
396  * is concerned).
397  *
398  * This contract is only required for intermediate, library-like contracts.
399  */
400 abstract contract Context {
401     function _msgSender() internal view virtual returns (address) {
402         return msg.sender;
403     }
404 
405     function _msgData() internal view virtual returns (bytes calldata) {
406         return msg.data;
407     }
408 }
409 
410 // File: @openzeppelin/contracts/access/Ownable.sol
411 
412 
413 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 
418 /**
419  * @dev Contract module which provides a basic access control mechanism, where
420  * there is an account (an owner) that can be granted exclusive access to
421  * specific functions.
422  *
423  * By default, the owner account will be the one that deploys the contract. This
424  * can later be changed with {transferOwnership}.
425  *
426  * This module is used through inheritance. It will make available the modifier
427  * `onlyOwner`, which can be applied to your functions to restrict their use to
428  * the owner.
429  */
430 abstract contract Ownable is Context {
431     address private _owner;
432 
433     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
434 
435     /**
436      * @dev Initializes the contract setting the deployer as the initial owner.
437      */
438     constructor() {
439         _transferOwnership(_msgSender());
440     }
441 
442     /**
443      * @dev Throws if called by any account other than the owner.
444      */
445     modifier onlyOwner() {
446         _checkOwner();
447         _;
448     }
449 
450     /**
451      * @dev Returns the address of the current owner.
452      */
453     function owner() public view virtual returns (address) {
454         return _owner;
455     }
456 
457     /**
458      * @dev Throws if the sender is not the owner.
459      */
460     function _checkOwner() internal view virtual {
461         require(owner() == _msgSender(), "Ownable: caller is not the owner");
462     }
463 
464     /**
465      * @dev Leaves the contract without owner. It will not be possible to call
466      * `onlyOwner` functions anymore. Can only be called by the current owner.
467      *
468      * NOTE: Renouncing ownership will leave the contract without an owner,
469      * thereby removing any functionality that is only available to the owner.
470      */
471     function renounceOwnership() public virtual onlyOwner {
472         _transferOwnership(address(0));
473     }
474 
475     /**
476      * @dev Transfers ownership of the contract to a new account (`newOwner`).
477      * Can only be called by the current owner.
478      */
479     function transferOwnership(address newOwner) public virtual onlyOwner {
480         require(newOwner != address(0), "Ownable: new owner is the zero address");
481         _transferOwnership(newOwner);
482     }
483 
484     /**
485      * @dev Transfers ownership of the contract to a new account (`newOwner`).
486      * Internal function without access restriction.
487      */
488     function _transferOwnership(address newOwner) internal virtual {
489         address oldOwner = _owner;
490         _owner = newOwner;
491         emit OwnershipTransferred(oldOwner, newOwner);
492     }
493 }
494 
495 // File: erc721a/contracts/IERC721A.sol
496 
497 
498 // ERC721A Contracts v4.1.0
499 // Creator: Chiru Labs
500 
501 pragma solidity ^0.8.4;
502 
503 /**
504  * @dev Interface of an ERC721A compliant contract.
505  */
506 interface IERC721A {
507     /**
508      * The caller must own the token or be an approved operator.
509      */
510     error ApprovalCallerNotOwnerNorApproved();
511 
512     /**
513      * The token does not exist.
514      */
515     error ApprovalQueryForNonexistentToken();
516 
517     /**
518      * The caller cannot approve to their own address.
519      */
520     error ApproveToCaller();
521 
522     /**
523      * Cannot query the balance for the zero address.
524      */
525     error BalanceQueryForZeroAddress();
526 
527     /**
528      * Cannot mint to the zero address.
529      */
530     error MintToZeroAddress();
531 
532     /**
533      * The quantity of tokens minted must be more than zero.
534      */
535     error MintZeroQuantity();
536 
537     /**
538      * The token does not exist.
539      */
540     error OwnerQueryForNonexistentToken();
541 
542     /**
543      * The caller must own the token or be an approved operator.
544      */
545     error TransferCallerNotOwnerNorApproved();
546 
547     /**
548      * The token must be owned by `from`.
549      */
550     error TransferFromIncorrectOwner();
551 
552     /**
553      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
554      */
555     error TransferToNonERC721ReceiverImplementer();
556 
557     /**
558      * Cannot transfer to the zero address.
559      */
560     error TransferToZeroAddress();
561 
562     /**
563      * The token does not exist.
564      */
565     error URIQueryForNonexistentToken();
566 
567     /**
568      * The `quantity` minted with ERC2309 exceeds the safety limit.
569      */
570     error MintERC2309QuantityExceedsLimit();
571 
572     /**
573      * The `extraData` cannot be set on an unintialized ownership slot.
574      */
575     error OwnershipNotInitializedForExtraData();
576 
577     struct TokenOwnership {
578         // The address of the owner.
579         address addr;
580         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
581         uint64 startTimestamp;
582         // Whether the token has been burned.
583         bool burned;
584         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
585         uint24 extraData;
586     }
587 
588     /**
589      * @dev Returns the total amount of tokens stored by the contract.
590      *
591      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
592      */
593     function totalSupply() external view returns (uint256);
594 
595     // ==============================
596     //            IERC165
597     // ==============================
598 
599     /**
600      * @dev Returns true if this contract implements the interface defined by
601      * `interfaceId`. See the corresponding
602      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
603      * to learn more about how these ids are created.
604      *
605      * This function call must use less than 30 000 gas.
606      */
607     function supportsInterface(bytes4 interfaceId) external view returns (bool);
608 
609     // ==============================
610     //            IERC721
611     // ==============================
612 
613     /**
614      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
615      */
616     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
617 
618     /**
619      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
620      */
621     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
622 
623     /**
624      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
625      */
626     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
627 
628     /**
629      * @dev Returns the number of tokens in ``owner``'s account.
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
643      * @dev Safely transfers `tokenId` token from `from` to `to`.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must exist and be owned by `from`.
650      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
651      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
652      *
653      * Emits a {Transfer} event.
654      */
655     function safeTransferFrom(
656         address from,
657         address to,
658         uint256 tokenId,
659         bytes calldata data
660     ) external;
661 
662     /**
663      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
664      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) external;
681 
682     /**
683      * @dev Transfers `tokenId` token from `from` to `to`.
684      *
685      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must be owned by `from`.
692      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
693      *
694      * Emits a {Transfer} event.
695      */
696     function transferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) external;
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
707      *
708      * Requirements:
709      *
710      * - The caller must own the token or be an approved operator.
711      * - `tokenId` must exist.
712      *
713      * Emits an {Approval} event.
714      */
715     function approve(address to, uint256 tokenId) external;
716 
717     /**
718      * @dev Approve or remove `operator` as an operator for the caller.
719      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
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
741      * See {setApprovalForAll}
742      */
743     function isApprovedForAll(address owner, address operator) external view returns (bool);
744 
745     // ==============================
746     //        IERC721Metadata
747     // ==============================
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
764     // ==============================
765     //            IERC2309
766     // ==============================
767 
768     /**
769      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
770      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
771      */
772     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
773 }
774 
775 // File: erc721a/contracts/ERC721A.sol
776 
777 
778 // ERC721A Contracts v4.1.0
779 // Creator: Chiru Labs
780 
781 pragma solidity ^0.8.4;
782 
783 
784 /**
785  * @dev ERC721 token receiver interface.
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
797  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
798  * including the Metadata extension. Built to optimize for lower gas during batch mints.
799  *
800  * Assumes serials are sequentially minted starting at `_startTokenId()`
801  * (defaults to 0, e.g. 0, 1, 2, 3..).
802  *
803  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
804  *
805  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
806  */
807 contract ERC721A is IERC721A {
808     // Mask of an entry in packed address data.
809     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
810 
811     // The bit position of `numberMinted` in packed address data.
812     uint256 private constant BITPOS_NUMBER_MINTED = 64;
813 
814     // The bit position of `numberBurned` in packed address data.
815     uint256 private constant BITPOS_NUMBER_BURNED = 128;
816 
817     // The bit position of `aux` in packed address data.
818     uint256 private constant BITPOS_AUX = 192;
819 
820     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
821     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
822 
823     // The bit position of `startTimestamp` in packed ownership.
824     uint256 private constant BITPOS_START_TIMESTAMP = 160;
825 
826     // The bit mask of the `burned` bit in packed ownership.
827     uint256 private constant BITMASK_BURNED = 1 << 224;
828 
829     // The bit position of the `nextInitialized` bit in packed ownership.
830     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
831 
832     // The bit mask of the `nextInitialized` bit in packed ownership.
833     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
834 
835     // The bit position of `extraData` in packed ownership.
836     uint256 private constant BITPOS_EXTRA_DATA = 232;
837 
838     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
839     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
840 
841     // The mask of the lower 160 bits for addresses.
842     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
843 
844     // The maximum `quantity` that can be minted with `_mintERC2309`.
845     // This limit is to prevent overflows on the address data entries.
846     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
847     // is required to cause an overflow, which is unrealistic.
848     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
849 
850     // The tokenId of the next token to be minted.
851     uint256 private _currentIndex;
852 
853     // The number of tokens burned.
854     uint256 private _burnCounter;
855 
856     // Token name
857     string private _name;
858 
859     // Token symbol
860     string private _symbol;
861 
862     // Mapping from token ID to ownership details
863     // An empty struct value does not necessarily mean the token is unowned.
864     // See `_packedOwnershipOf` implementation for details.
865     //
866     // Bits Layout:
867     // - [0..159]   `addr`
868     // - [160..223] `startTimestamp`
869     // - [224]      `burned`
870     // - [225]      `nextInitialized`
871     // - [232..255] `extraData`
872     mapping(uint256 => uint256) private _packedOwnerships;
873 
874     // Mapping owner address to address data.
875     //
876     // Bits Layout:
877     // - [0..63]    `balance`
878     // - [64..127]  `numberMinted`
879     // - [128..191] `numberBurned`
880     // - [192..255] `aux`
881     mapping(address => uint256) private _packedAddressData;
882 
883     // Mapping from token ID to approved address.
884     mapping(uint256 => address) private _tokenApprovals;
885 
886     // Mapping from owner to operator approvals
887     mapping(address => mapping(address => bool)) private _operatorApprovals;
888 
889     constructor(string memory name_, string memory symbol_) {
890         _name = name_;
891         _symbol = symbol_;
892         _currentIndex = _startTokenId();
893     }
894 
895     /**
896      * @dev Returns the starting token ID.
897      * To change the starting token ID, please override this function.
898      */
899     function _startTokenId() internal view virtual returns (uint256) {
900         return 0;
901     }
902 
903     /**
904      * @dev Returns the next token ID to be minted.
905      */
906     function _nextTokenId() internal view returns (uint256) {
907         return _currentIndex;
908     }
909 
910     /**
911      * @dev Returns the total number of tokens in existence.
912      * Burned tokens will reduce the count.
913      * To get the total number of tokens minted, please see `_totalMinted`.
914      */
915     function totalSupply() public view override returns (uint256) {
916         // Counter underflow is impossible as _burnCounter cannot be incremented
917         // more than `_currentIndex - _startTokenId()` times.
918         unchecked {
919             return _currentIndex - _burnCounter - _startTokenId();
920         }
921     }
922 
923     /**
924      * @dev Returns the total amount of tokens minted in the contract.
925      */
926     function _totalMinted() internal view returns (uint256) {
927         // Counter underflow is impossible as _currentIndex does not decrement,
928         // and it is initialized to `_startTokenId()`
929         unchecked {
930             return _currentIndex - _startTokenId();
931         }
932     }
933 
934     /**
935      * @dev Returns the total number of tokens burned.
936      */
937     function _totalBurned() internal view returns (uint256) {
938         return _burnCounter;
939     }
940 
941     /**
942      * @dev See {IERC165-supportsInterface}.
943      */
944     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
945         // The interface IDs are constants representing the first 4 bytes of the XOR of
946         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
947         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
948         return
949             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
950             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
951             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
952     }
953 
954     /**
955      * @dev See {IERC721-balanceOf}.
956      */
957     function balanceOf(address owner) public view override returns (uint256) {
958         if (owner == address(0)) revert BalanceQueryForZeroAddress();
959         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
960     }
961 
962     /**
963      * Returns the number of tokens minted by `owner`.
964      */
965     function _numberMinted(address owner) internal view returns (uint256) {
966         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
967     }
968 
969     /**
970      * Returns the number of tokens burned by or on behalf of `owner`.
971      */
972     function _numberBurned(address owner) internal view returns (uint256) {
973         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
974     }
975 
976     /**
977      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
978      */
979     function _getAux(address owner) internal view returns (uint64) {
980         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
981     }
982 
983     /**
984      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
985      * If there are multiple variables, please pack them into a uint64.
986      */
987     function _setAux(address owner, uint64 aux) internal {
988         uint256 packed = _packedAddressData[owner];
989         uint256 auxCasted;
990         // Cast `aux` with assembly to avoid redundant masking.
991         assembly {
992             auxCasted := aux
993         }
994         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
995         _packedAddressData[owner] = packed;
996     }
997 
998     /**
999      * Returns the packed ownership data of `tokenId`.
1000      */
1001     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1002         uint256 curr = tokenId;
1003 
1004         unchecked {
1005             if (_startTokenId() <= curr)
1006                 if (curr < _currentIndex) {
1007                     uint256 packed = _packedOwnerships[curr];
1008                     // If not burned.
1009                     if (packed & BITMASK_BURNED == 0) {
1010                         // Invariant:
1011                         // There will always be an ownership that has an address and is not burned
1012                         // before an ownership that does not have an address and is not burned.
1013                         // Hence, curr will not underflow.
1014                         //
1015                         // We can directly compare the packed value.
1016                         // If the address is zero, packed is zero.
1017                         while (packed == 0) {
1018                             packed = _packedOwnerships[--curr];
1019                         }
1020                         return packed;
1021                     }
1022                 }
1023         }
1024         revert OwnerQueryForNonexistentToken();
1025     }
1026 
1027     /**
1028      * Returns the unpacked `TokenOwnership` struct from `packed`.
1029      */
1030     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1031         ownership.addr = address(uint160(packed));
1032         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1033         ownership.burned = packed & BITMASK_BURNED != 0;
1034         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1035     }
1036 
1037     /**
1038      * Returns the unpacked `TokenOwnership` struct at `index`.
1039      */
1040     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1041         return _unpackedOwnership(_packedOwnerships[index]);
1042     }
1043 
1044     /**
1045      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1046      */
1047     function _initializeOwnershipAt(uint256 index) internal {
1048         if (_packedOwnerships[index] == 0) {
1049             _packedOwnerships[index] = _packedOwnershipOf(index);
1050         }
1051     }
1052 
1053     /**
1054      * Gas spent here starts off proportional to the maximum mint batch size.
1055      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1056      */
1057     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1058         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1059     }
1060 
1061     /**
1062      * @dev Packs ownership data into a single uint256.
1063      */
1064     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1065         assembly {
1066             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1067             owner := and(owner, BITMASK_ADDRESS)
1068             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1069             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1070         }
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-ownerOf}.
1075      */
1076     function ownerOf(uint256 tokenId) public view override returns (address) {
1077         return address(uint160(_packedOwnershipOf(tokenId)));
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Metadata-name}.
1082      */
1083     function name() public view virtual override returns (string memory) {
1084         return _name;
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Metadata-symbol}.
1089      */
1090     function symbol() public view virtual override returns (string memory) {
1091         return _symbol;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Metadata-tokenURI}.
1096      */
1097     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1098         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1099 
1100         string memory baseURI = _baseURI();
1101         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1102     }
1103 
1104     /**
1105      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1106      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1107      * by default, it can be overridden in child contracts.
1108      */
1109     function _baseURI() internal view virtual returns (string memory) {
1110         return '';
1111     }
1112 
1113     /**
1114      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1115      */
1116     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1117         // For branchless setting of the `nextInitialized` flag.
1118         assembly {
1119             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1120             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1121         }
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-approve}.
1126      */
1127     function approve(address to, uint256 tokenId) public override {
1128         address owner = ownerOf(tokenId);
1129 
1130         if (_msgSenderERC721A() != owner)
1131             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1132                 revert ApprovalCallerNotOwnerNorApproved();
1133             }
1134 
1135         _tokenApprovals[tokenId] = to;
1136         emit Approval(owner, to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-getApproved}.
1141      */
1142     function getApproved(uint256 tokenId) public view override returns (address) {
1143         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1144 
1145         return _tokenApprovals[tokenId];
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-setApprovalForAll}.
1150      */
1151     function setApprovalForAll(address operator, bool approved) public virtual override {
1152         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1153 
1154         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1155         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-isApprovedForAll}.
1160      */
1161     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1162         return _operatorApprovals[owner][operator];
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-safeTransferFrom}.
1167      */
1168     function safeTransferFrom(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) public virtual override {
1173         safeTransferFrom(from, to, tokenId, '');
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-safeTransferFrom}.
1178      */
1179     function safeTransferFrom(
1180         address from,
1181         address to,
1182         uint256 tokenId,
1183         bytes memory _data
1184     ) public virtual override {
1185         transferFrom(from, to, tokenId);
1186         if (to.code.length != 0)
1187             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1188                 revert TransferToNonERC721ReceiverImplementer();
1189             }
1190     }
1191 
1192     /**
1193      * @dev Returns whether `tokenId` exists.
1194      *
1195      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1196      *
1197      * Tokens start existing when they are minted (`_mint`),
1198      */
1199     function _exists(uint256 tokenId) internal view returns (bool) {
1200         return
1201             _startTokenId() <= tokenId &&
1202             tokenId < _currentIndex && // If within bounds,
1203             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1204     }
1205 
1206     /**
1207      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1208      */
1209     function _safeMint(address to, uint256 quantity) internal {
1210         _safeMint(to, quantity, '');
1211     }
1212 
1213     /**
1214      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1215      *
1216      * Requirements:
1217      *
1218      * - If `to` refers to a smart contract, it must implement
1219      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1220      * - `quantity` must be greater than 0.
1221      *
1222      * See {_mint}.
1223      *
1224      * Emits a {Transfer} event for each mint.
1225      */
1226     function _safeMint(
1227         address to,
1228         uint256 quantity,
1229         bytes memory _data
1230     ) internal {
1231         _mint(to, quantity);
1232 
1233         unchecked {
1234             if (to.code.length != 0) {
1235                 uint256 end = _currentIndex;
1236                 uint256 index = end - quantity;
1237                 do {
1238                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1239                         revert TransferToNonERC721ReceiverImplementer();
1240                     }
1241                 } while (index < end);
1242                 // Reentrancy protection.
1243                 if (_currentIndex != end) revert();
1244             }
1245         }
1246     }
1247 
1248     /**
1249      * @dev Mints `quantity` tokens and transfers them to `to`.
1250      *
1251      * Requirements:
1252      *
1253      * - `to` cannot be the zero address.
1254      * - `quantity` must be greater than 0.
1255      *
1256      * Emits a {Transfer} event for each mint.
1257      */
1258     function _mint(address to, uint256 quantity) internal {
1259         uint256 startTokenId = _currentIndex;
1260         if (to == address(0)) revert MintToZeroAddress();
1261         if (quantity == 0) revert MintZeroQuantity();
1262 
1263         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1264 
1265         // Overflows are incredibly unrealistic.
1266         // `balance` and `numberMinted` have a maximum limit of 2**64.
1267         // `tokenId` has a maximum limit of 2**256.
1268         unchecked {
1269             // Updates:
1270             // - `balance += quantity`.
1271             // - `numberMinted += quantity`.
1272             //
1273             // We can directly add to the `balance` and `numberMinted`.
1274             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1275 
1276             // Updates:
1277             // - `address` to the owner.
1278             // - `startTimestamp` to the timestamp of minting.
1279             // - `burned` to `false`.
1280             // - `nextInitialized` to `quantity == 1`.
1281             _packedOwnerships[startTokenId] = _packOwnershipData(
1282                 to,
1283                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1284             );
1285 
1286             uint256 tokenId = startTokenId;
1287             uint256 end = startTokenId + quantity;
1288             do {
1289                 emit Transfer(address(0), to, tokenId++);
1290             } while (tokenId < end);
1291 
1292             _currentIndex = end;
1293         }
1294         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1295     }
1296 
1297     /**
1298      * @dev Mints `quantity` tokens and transfers them to `to`.
1299      *
1300      * This function is intended for efficient minting only during contract creation.
1301      *
1302      * It emits only one {ConsecutiveTransfer} as defined in
1303      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1304      * instead of a sequence of {Transfer} event(s).
1305      *
1306      * Calling this function outside of contract creation WILL make your contract
1307      * non-compliant with the ERC721 standard.
1308      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1309      * {ConsecutiveTransfer} event is only permissible during contract creation.
1310      *
1311      * Requirements:
1312      *
1313      * - `to` cannot be the zero address.
1314      * - `quantity` must be greater than 0.
1315      *
1316      * Emits a {ConsecutiveTransfer} event.
1317      */
1318     function _mintERC2309(address to, uint256 quantity) internal {
1319         uint256 startTokenId = _currentIndex;
1320         if (to == address(0)) revert MintToZeroAddress();
1321         if (quantity == 0) revert MintZeroQuantity();
1322         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1323 
1324         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1325 
1326         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1327         unchecked {
1328             // Updates:
1329             // - `balance += quantity`.
1330             // - `numberMinted += quantity`.
1331             //
1332             // We can directly add to the `balance` and `numberMinted`.
1333             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1334 
1335             // Updates:
1336             // - `address` to the owner.
1337             // - `startTimestamp` to the timestamp of minting.
1338             // - `burned` to `false`.
1339             // - `nextInitialized` to `quantity == 1`.
1340             _packedOwnerships[startTokenId] = _packOwnershipData(
1341                 to,
1342                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1343             );
1344 
1345             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1346 
1347             _currentIndex = startTokenId + quantity;
1348         }
1349         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1350     }
1351 
1352     /**
1353      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1354      */
1355     function _getApprovedAddress(uint256 tokenId)
1356         private
1357         view
1358         returns (uint256 approvedAddressSlot, address approvedAddress)
1359     {
1360         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1361         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1362         assembly {
1363             // Compute the slot.
1364             mstore(0x00, tokenId)
1365             mstore(0x20, tokenApprovalsPtr.slot)
1366             approvedAddressSlot := keccak256(0x00, 0x40)
1367             // Load the slot's value from storage.
1368             approvedAddress := sload(approvedAddressSlot)
1369         }
1370     }
1371 
1372     /**
1373      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1374      */
1375     function _isOwnerOrApproved(
1376         address approvedAddress,
1377         address from,
1378         address msgSender
1379     ) private pure returns (bool result) {
1380         assembly {
1381             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1382             from := and(from, BITMASK_ADDRESS)
1383             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1384             msgSender := and(msgSender, BITMASK_ADDRESS)
1385             // `msgSender == from || msgSender == approvedAddress`.
1386             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1387         }
1388     }
1389 
1390     /**
1391      * @dev Transfers `tokenId` from `from` to `to`.
1392      *
1393      * Requirements:
1394      *
1395      * - `to` cannot be the zero address.
1396      * - `tokenId` token must be owned by `from`.
1397      *
1398      * Emits a {Transfer} event.
1399      */
1400     function transferFrom(
1401         address from,
1402         address to,
1403         uint256 tokenId
1404     ) public virtual override {
1405         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1406 
1407         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1408 
1409         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1410 
1411         // The nested ifs save around 20+ gas over a compound boolean condition.
1412         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1413             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1414 
1415         if (to == address(0)) revert TransferToZeroAddress();
1416 
1417         _beforeTokenTransfers(from, to, tokenId, 1);
1418 
1419         // Clear approvals from the previous owner.
1420         assembly {
1421             if approvedAddress {
1422                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1423                 sstore(approvedAddressSlot, 0)
1424             }
1425         }
1426 
1427         // Underflow of the sender's balance is impossible because we check for
1428         // ownership above and the recipient's balance can't realistically overflow.
1429         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1430         unchecked {
1431             // We can directly increment and decrement the balances.
1432             --_packedAddressData[from]; // Updates: `balance -= 1`.
1433             ++_packedAddressData[to]; // Updates: `balance += 1`.
1434 
1435             // Updates:
1436             // - `address` to the next owner.
1437             // - `startTimestamp` to the timestamp of transfering.
1438             // - `burned` to `false`.
1439             // - `nextInitialized` to `true`.
1440             _packedOwnerships[tokenId] = _packOwnershipData(
1441                 to,
1442                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1443             );
1444 
1445             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1446             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1447                 uint256 nextTokenId = tokenId + 1;
1448                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1449                 if (_packedOwnerships[nextTokenId] == 0) {
1450                     // If the next slot is within bounds.
1451                     if (nextTokenId != _currentIndex) {
1452                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1453                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1454                     }
1455                 }
1456             }
1457         }
1458 
1459         emit Transfer(from, to, tokenId);
1460         _afterTokenTransfers(from, to, tokenId, 1);
1461     }
1462 
1463     /**
1464      * @dev Equivalent to `_burn(tokenId, false)`.
1465      */
1466     function _burn(uint256 tokenId) internal virtual {
1467         _burn(tokenId, false);
1468     }
1469 
1470     /**
1471      * @dev Destroys `tokenId`.
1472      * The approval is cleared when the token is burned.
1473      *
1474      * Requirements:
1475      *
1476      * - `tokenId` must exist.
1477      *
1478      * Emits a {Transfer} event.
1479      */
1480     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1481         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1482 
1483         address from = address(uint160(prevOwnershipPacked));
1484 
1485         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1486 
1487         if (approvalCheck) {
1488             // The nested ifs save around 20+ gas over a compound boolean condition.
1489             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1490                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1491         }
1492 
1493         _beforeTokenTransfers(from, address(0), tokenId, 1);
1494 
1495         // Clear approvals from the previous owner.
1496         assembly {
1497             if approvedAddress {
1498                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1499                 sstore(approvedAddressSlot, 0)
1500             }
1501         }
1502 
1503         // Underflow of the sender's balance is impossible because we check for
1504         // ownership above and the recipient's balance can't realistically overflow.
1505         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1506         unchecked {
1507             // Updates:
1508             // - `balance -= 1`.
1509             // - `numberBurned += 1`.
1510             //
1511             // We can directly decrement the balance, and increment the number burned.
1512             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1513             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1514 
1515             // Updates:
1516             // - `address` to the last owner.
1517             // - `startTimestamp` to the timestamp of burning.
1518             // - `burned` to `true`.
1519             // - `nextInitialized` to `true`.
1520             _packedOwnerships[tokenId] = _packOwnershipData(
1521                 from,
1522                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1523             );
1524 
1525             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1526             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1527                 uint256 nextTokenId = tokenId + 1;
1528                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1529                 if (_packedOwnerships[nextTokenId] == 0) {
1530                     // If the next slot is within bounds.
1531                     if (nextTokenId != _currentIndex) {
1532                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1533                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1534                     }
1535                 }
1536             }
1537         }
1538 
1539         emit Transfer(from, address(0), tokenId);
1540         _afterTokenTransfers(from, address(0), tokenId, 1);
1541 
1542         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1543         unchecked {
1544             _burnCounter++;
1545         }
1546     }
1547 
1548     /**
1549      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1550      *
1551      * @param from address representing the previous owner of the given token ID
1552      * @param to target address that will receive the tokens
1553      * @param tokenId uint256 ID of the token to be transferred
1554      * @param _data bytes optional data to send along with the call
1555      * @return bool whether the call correctly returned the expected magic value
1556      */
1557     function _checkContractOnERC721Received(
1558         address from,
1559         address to,
1560         uint256 tokenId,
1561         bytes memory _data
1562     ) private returns (bool) {
1563         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1564             bytes4 retval
1565         ) {
1566             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1567         } catch (bytes memory reason) {
1568             if (reason.length == 0) {
1569                 revert TransferToNonERC721ReceiverImplementer();
1570             } else {
1571                 assembly {
1572                     revert(add(32, reason), mload(reason))
1573                 }
1574             }
1575         }
1576     }
1577 
1578     /**
1579      * @dev Directly sets the extra data for the ownership data `index`.
1580      */
1581     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1582         uint256 packed = _packedOwnerships[index];
1583         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1584         uint256 extraDataCasted;
1585         // Cast `extraData` with assembly to avoid redundant masking.
1586         assembly {
1587             extraDataCasted := extraData
1588         }
1589         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1590         _packedOwnerships[index] = packed;
1591     }
1592 
1593     /**
1594      * @dev Returns the next extra data for the packed ownership data.
1595      * The returned result is shifted into position.
1596      */
1597     function _nextExtraData(
1598         address from,
1599         address to,
1600         uint256 prevOwnershipPacked
1601     ) private view returns (uint256) {
1602         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1603         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1604     }
1605 
1606     /**
1607      * @dev Called during each token transfer to set the 24bit `extraData` field.
1608      * Intended to be overridden by the cosumer contract.
1609      *
1610      * `previousExtraData` - the value of `extraData` before transfer.
1611      *
1612      * Calling conditions:
1613      *
1614      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1615      * transferred to `to`.
1616      * - When `from` is zero, `tokenId` will be minted for `to`.
1617      * - When `to` is zero, `tokenId` will be burned by `from`.
1618      * - `from` and `to` are never both zero.
1619      */
1620     function _extraData(
1621         address from,
1622         address to,
1623         uint24 previousExtraData
1624     ) internal view virtual returns (uint24) {}
1625 
1626     /**
1627      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1628      * This includes minting.
1629      * And also called before burning one token.
1630      *
1631      * startTokenId - the first token id to be transferred
1632      * quantity - the amount to be transferred
1633      *
1634      * Calling conditions:
1635      *
1636      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1637      * transferred to `to`.
1638      * - When `from` is zero, `tokenId` will be minted for `to`.
1639      * - When `to` is zero, `tokenId` will be burned by `from`.
1640      * - `from` and `to` are never both zero.
1641      */
1642     function _beforeTokenTransfers(
1643         address from,
1644         address to,
1645         uint256 startTokenId,
1646         uint256 quantity
1647     ) internal virtual {}
1648 
1649     /**
1650      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1651      * This includes minting.
1652      * And also called after one token has been burned.
1653      *
1654      * startTokenId - the first token id to be transferred
1655      * quantity - the amount to be transferred
1656      *
1657      * Calling conditions:
1658      *
1659      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1660      * transferred to `to`.
1661      * - When `from` is zero, `tokenId` has been minted for `to`.
1662      * - When `to` is zero, `tokenId` has been burned by `from`.
1663      * - `from` and `to` are never both zero.
1664      */
1665     function _afterTokenTransfers(
1666         address from,
1667         address to,
1668         uint256 startTokenId,
1669         uint256 quantity
1670     ) internal virtual {}
1671 
1672     /**
1673      * @dev Returns the message sender (defaults to `msg.sender`).
1674      *
1675      * If you are writing GSN compatible contracts, you need to override this function.
1676      */
1677     function _msgSenderERC721A() internal view virtual returns (address) {
1678         return msg.sender;
1679     }
1680 
1681     /**
1682      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1683      */
1684     function _toString(uint256 value) internal pure returns (string memory ptr) {
1685         assembly {
1686             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1687             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1688             // We will need 1 32-byte word to store the length,
1689             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1690             ptr := add(mload(0x40), 128)
1691             // Update the free memory pointer to allocate.
1692             mstore(0x40, ptr)
1693 
1694             // Cache the end of the memory to calculate the length later.
1695             let end := ptr
1696 
1697             // We write the string from the rightmost digit to the leftmost digit.
1698             // The following is essentially a do-while loop that also handles the zero case.
1699             // Costs a bit more than early returning for the zero case,
1700             // but cheaper in terms of deployment and overall runtime costs.
1701             for {
1702                 // Initialize and perform the first pass without check.
1703                 let temp := value
1704                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1705                 ptr := sub(ptr, 1)
1706                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1707                 mstore8(ptr, add(48, mod(temp, 10)))
1708                 temp := div(temp, 10)
1709             } temp {
1710                 // Keep dividing `temp` until zero.
1711                 temp := div(temp, 10)
1712             } {
1713                 // Body of the for loop.
1714                 ptr := sub(ptr, 1)
1715                 mstore8(ptr, add(48, mod(temp, 10)))
1716             }
1717 
1718             let length := sub(end, ptr)
1719             // Move the pointer 32 bytes leftwards to make room for the length.
1720             ptr := sub(ptr, 32)
1721             // Store the length.
1722             mstore(ptr, length)
1723         }
1724     }
1725 }
1726 
1727 pragma solidity ^0.8.0;
1728 
1729 contract FTXGERMS is ERC721A, Ownable, ReentrancyGuard {
1730     using Address for address;
1731     using Strings for uint;
1732 
1733     string public baseTokenURI = "ipfs://bafybeib3n4fz7jnkcxiaddmuvdsfh5puvd34yjqukj3xg4ajzowfkl3kga/";
1734 
1735     uint256   public price = 0.005 ether;
1736     uint256   public maxPerTransaction = 10;
1737     uint256   public maxFreePerWallet = 1;
1738     uint256   public totalFree = 2000;
1739     uint256   public maxSupply = 2000;
1740     bool   public mintEnabled = false;
1741 
1742     mapping(address => uint256) private _mintedFreeAmount;
1743 
1744     constructor() ERC721A("FTX GERMS", "FTXG"){
1745 
1746     }
1747 
1748 //                      -FUNCTIONS-
1749 
1750     function mint(uint256 count) external payable {
1751         uint256 cost = price;
1752         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1753             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1754 
1755         if (isFree) {
1756             cost = 0;
1757             _mintedFreeAmount[msg.sender] += count;
1758         }
1759 
1760         require(msg.value >= count * cost, "Please send the right amount.");
1761         require(totalSupply() + count <= maxSupply, "Gone.");
1762         require(mintEnabled, "Minting hasn't started yet.");
1763         require(count <= maxPerTransaction, "Max per transaction reached.");
1764 
1765         _safeMint(msg.sender, count);
1766     }
1767 
1768   function setBaseURI(string memory baseURI)
1769     public
1770     onlyOwner
1771   {
1772     baseTokenURI = baseURI;
1773   }
1774 
1775     function _startTokenId() internal view virtual override returns (uint256) {
1776         return 1;
1777     }
1778 
1779     function ownerfunction(uint256 amt) external onlyOwner
1780     {
1781     require(totalSupply() + amt < maxSupply + 1,"too many!");
1782 
1783     _safeMint(msg.sender, amt);
1784     }
1785 
1786     function withdraw() external onlyOwner nonReentrant {
1787         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1788         require(success, "Transfer failed.");
1789     }
1790 
1791 
1792 function tokenURI(uint _tokenId)
1793     public
1794     view
1795     virtual
1796     override
1797     returns (string memory)
1798   {
1799     require(
1800       _exists(_tokenId),
1801       "ERC721Metadata: URI query for nonexistent token"
1802     );
1803     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1804   }
1805 
1806  function _baseURI()
1807     internal
1808     view
1809     virtual
1810     override
1811     returns (string memory)
1812   {
1813     return baseTokenURI;
1814   }
1815     function toggleMinting() external onlyOwner {
1816       mintEnabled = !mintEnabled;
1817     }
1818 
1819     function setPrice(uint256 price_) external onlyOwner {
1820         price = price_;
1821     }
1822 
1823 }