1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/security/Pausable.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Contract module which allows children to implement an emergency stop
123  * mechanism that can be triggered by an authorized account.
124  *
125  * This module is used through inheritance. It will make available the
126  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
127  * the functions of your contract. Note that they will not be pausable by
128  * simply including this module, only once the modifiers are put in place.
129  */
130 abstract contract Pausable is Context {
131     /**
132      * @dev Emitted when the pause is triggered by `account`.
133      */
134     event Paused(address account);
135 
136     /**
137      * @dev Emitted when the pause is lifted by `account`.
138      */
139     event Unpaused(address account);
140 
141     bool private _paused;
142 
143     /**
144      * @dev Initializes the contract in unpaused state.
145      */
146     constructor() {
147         _paused = false;
148     }
149 
150     /**
151      * @dev Modifier to make a function callable only when the contract is not paused.
152      *
153      * Requirements:
154      *
155      * - The contract must not be paused.
156      */
157     modifier whenNotPaused() {
158         _requireNotPaused();
159         _;
160     }
161 
162     /**
163      * @dev Modifier to make a function callable only when the contract is paused.
164      *
165      * Requirements:
166      *
167      * - The contract must be paused.
168      */
169     modifier whenPaused() {
170         _requirePaused();
171         _;
172     }
173 
174     /**
175      * @dev Returns true if the contract is paused, and false otherwise.
176      */
177     function paused() public view virtual returns (bool) {
178         return _paused;
179     }
180 
181     /**
182      * @dev Throws if the contract is paused.
183      */
184     function _requireNotPaused() internal view virtual {
185         require(!paused(), "Pausable: paused");
186     }
187 
188     /**
189      * @dev Throws if the contract is not paused.
190      */
191     function _requirePaused() internal view virtual {
192         require(paused(), "Pausable: not paused");
193     }
194 
195     /**
196      * @dev Triggers stopped state.
197      *
198      * Requirements:
199      *
200      * - The contract must not be paused.
201      */
202     function _pause() internal virtual whenNotPaused {
203         _paused = true;
204         emit Paused(_msgSender());
205     }
206 
207     /**
208      * @dev Returns to normal state.
209      *
210      * Requirements:
211      *
212      * - The contract must be paused.
213      */
214     function _unpause() internal virtual whenPaused {
215         _paused = false;
216         emit Unpaused(_msgSender());
217     }
218 }
219 
220 // File: @openzeppelin/contracts/utils/Strings.sol
221 
222 
223 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev String operations.
229  */
230 library Strings {
231     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
232     uint8 private constant _ADDRESS_LENGTH = 20;
233 
234     /**
235      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
236      */
237     function toString(uint256 value) internal pure returns (string memory) {
238         // Inspired by OraclizeAPI's implementation - MIT licence
239         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
240 
241         if (value == 0) {
242             return "0";
243         }
244         uint256 temp = value;
245         uint256 digits;
246         while (temp != 0) {
247             digits++;
248             temp /= 10;
249         }
250         bytes memory buffer = new bytes(digits);
251         while (value != 0) {
252             digits -= 1;
253             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
254             value /= 10;
255         }
256         return string(buffer);
257     }
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
261      */
262     function toHexString(uint256 value) internal pure returns (string memory) {
263         if (value == 0) {
264             return "0x00";
265         }
266         uint256 temp = value;
267         uint256 length = 0;
268         while (temp != 0) {
269             length++;
270             temp >>= 8;
271         }
272         return toHexString(value, length);
273     }
274 
275     /**
276      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
277      */
278     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
279         bytes memory buffer = new bytes(2 * length + 2);
280         buffer[0] = "0";
281         buffer[1] = "x";
282         for (uint256 i = 2 * length + 1; i > 1; --i) {
283             buffer[i] = _HEX_SYMBOLS[value & 0xf];
284             value >>= 4;
285         }
286         require(value == 0, "Strings: hex length insufficient");
287         return string(buffer);
288     }
289 
290     /**
291      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
292      */
293     function toHexString(address addr) internal pure returns (string memory) {
294         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/Address.sol
299 
300 
301 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
302 
303 pragma solidity ^0.8.1;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      *
326      * [IMPORTANT]
327      * ====
328      * You shouldn't rely on `isContract` to protect against flash loan attacks!
329      *
330      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
331      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
332      * constructor.
333      * ====
334      */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies on extcodesize/address.code.length, which returns 0
337         // for contracts in construction, since the code is only stored at the end
338         // of the constructor execution.
339 
340         return account.code.length > 0;
341     }
342 
343     /**
344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345      * `recipient`, forwarding all available gas and reverting on errors.
346      *
347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
349      * imposed by `transfer`, making them unable to receive funds via
350      * `transfer`. {sendValue} removes this limitation.
351      *
352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353      *
354      * IMPORTANT: because control is transferred to `recipient`, care must be
355      * taken to not create reentrancy vulnerabilities. Consider using
356      * {ReentrancyGuard} or the
357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358      */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(address(this).balance >= amount, "Address: insufficient balance");
361 
362         (bool success, ) = recipient.call{value: amount}("");
363         require(success, "Address: unable to send value, recipient may have reverted");
364     }
365 
366     /**
367      * @dev Performs a Solidity function call using a low level `call`. A
368      * plain `call` is an unsafe replacement for a function call: use this
369      * function instead.
370      *
371      * If `target` reverts with a revert reason, it is bubbled up by this
372      * function (like regular Solidity function calls).
373      *
374      * Returns the raw returned data. To convert to the expected return value,
375      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
376      *
377      * Requirements:
378      *
379      * - `target` must be a contract.
380      * - calling `target` with `data` must not revert.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionCall(target, data, "Address: low-level call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
390      * `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, 0, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but also transferring `value` wei to `target`.
405      *
406      * Requirements:
407      *
408      * - the calling contract must have an ETH balance of at least `value`.
409      * - the called Solidity function must be `payable`.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value
417     ) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
423      * with `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCallWithValue(
428         address target,
429         bytes memory data,
430         uint256 value,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         require(isContract(target), "Address: call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.call{value: value}(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
447         return functionStaticCall(target, data, "Address: low-level static call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal view returns (bytes memory) {
461         require(isContract(target), "Address: static call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.staticcall(data);
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
474         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
479      * but performing a delegate call.
480      *
481      * _Available since v3.4._
482      */
483     function functionDelegateCall(
484         address target,
485         bytes memory data,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(isContract(target), "Address: delegate call to non-contract");
489 
490         (bool success, bytes memory returndata) = target.delegatecall(data);
491         return verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
496      * revert reason using the provided one.
497      *
498      * _Available since v4.3._
499      */
500     function verifyCallResult(
501         bool success,
502         bytes memory returndata,
503         string memory errorMessage
504     ) internal pure returns (bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511                 /// @solidity memory-safe-assembly
512                 assembly {
513                     let returndata_size := mload(returndata)
514                     revert(add(32, returndata), returndata_size)
515                 }
516             } else {
517                 revert(errorMessage);
518             }
519         }
520     }
521 }
522 
523 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev Contract module that helps prevent reentrant calls to a function.
532  *
533  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
534  * available, which can be applied to functions to make sure there are no nested
535  * (reentrant) calls to them.
536  *
537  * Note that because there is a single `nonReentrant` guard, functions marked as
538  * `nonReentrant` may not call one another. This can be worked around by making
539  * those functions `private`, and then adding `external` `nonReentrant` entry
540  * points to them.
541  *
542  * TIP: If you would like to learn more about reentrancy and alternative ways
543  * to protect against it, check out our blog post
544  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
545  */
546 abstract contract ReentrancyGuard {
547     // Booleans are more expensive than uint256 or any type that takes up a full
548     // word because each write operation emits an extra SLOAD to first read the
549     // slot's contents, replace the bits taken up by the boolean, and then write
550     // back. This is the compiler's defense against contract upgrades and
551     // pointer aliasing, and it cannot be disabled.
552 
553     // The values being non-zero value makes deployment a bit more expensive,
554     // but in exchange the refund on every call to nonReentrant will be lower in
555     // amount. Since refunds are capped to a percentage of the total
556     // transaction's gas, it is best to keep them low in cases like this one, to
557     // increase the likelihood of the full refund coming into effect.
558     uint256 private constant _NOT_ENTERED = 1;
559     uint256 private constant _ENTERED = 2;
560 
561     uint256 private _status;
562 
563     constructor() {
564         _status = _NOT_ENTERED;
565     }
566 
567     /**
568      * @dev Prevents a contract from calling itself, directly or indirectly.
569      * Calling a `nonReentrant` function from another `nonReentrant`
570      * function is not supported. It is possible to prevent this from happening
571      * by making the `nonReentrant` function external, and making it call a
572      * `private` function that does the actual work.
573      */
574     modifier nonReentrant() {
575         // On the first call to nonReentrant, _notEntered will be true
576         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
577 
578         // Any calls to nonReentrant after this point will fail
579         _status = _ENTERED;
580 
581         _;
582 
583         // By storing the original value once again, a refund is triggered (see
584         // https://eips.ethereum.org/EIPS/eip-2200)
585         _status = _NOT_ENTERED;
586     }
587 }
588 
589 // File: erc721a/contracts/IERC721A.sol
590 
591 
592 // ERC721A Contracts v4.2.2
593 // Creator: Chiru Labs
594 
595 pragma solidity ^0.8.4;
596 
597 /**
598  * @dev Interface of ERC721A.
599  */
600 interface IERC721A {
601     /**
602      * The caller must own the token or be an approved operator.
603      */
604     error ApprovalCallerNotOwnerNorApproved();
605 
606     /**
607      * The token does not exist.
608      */
609     error ApprovalQueryForNonexistentToken();
610 
611     /**
612      * The caller cannot approve to their own address.
613      */
614     error ApproveToCaller();
615 
616     /**
617      * Cannot query the balance for the zero address.
618      */
619     error BalanceQueryForZeroAddress();
620 
621     /**
622      * Cannot mint to the zero address.
623      */
624     error MintToZeroAddress();
625 
626     /**
627      * The quantity of tokens minted must be more than zero.
628      */
629     error MintZeroQuantity();
630 
631     /**
632      * The token does not exist.
633      */
634     error OwnerQueryForNonexistentToken();
635 
636     /**
637      * The caller must own the token or be an approved operator.
638      */
639     error TransferCallerNotOwnerNorApproved();
640 
641     /**
642      * The token must be owned by `from`.
643      */
644     error TransferFromIncorrectOwner();
645 
646     /**
647      * Cannot safely transfer to a contract that does not implement the
648      * ERC721Receiver interface.
649      */
650     error TransferToNonERC721ReceiverImplementer();
651 
652     /**
653      * Cannot transfer to the zero address.
654      */
655     error TransferToZeroAddress();
656 
657     /**
658      * The token does not exist.
659      */
660     error URIQueryForNonexistentToken();
661 
662     /**
663      * The `quantity` minted with ERC2309 exceeds the safety limit.
664      */
665     error MintERC2309QuantityExceedsLimit();
666 
667     /**
668      * The `extraData` cannot be set on an unintialized ownership slot.
669      */
670     error OwnershipNotInitializedForExtraData();
671 
672     // =============================================================
673     //                            STRUCTS
674     // =============================================================
675 
676     struct TokenOwnership {
677         // The address of the owner.
678         address addr;
679         // Stores the start time of ownership with minimal overhead for tokenomics.
680         uint64 startTimestamp;
681         // Whether the token has been burned.
682         bool burned;
683         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
684         uint24 extraData;
685     }
686 
687     // =============================================================
688     //                         TOKEN COUNTERS
689     // =============================================================
690 
691     /**
692      * @dev Returns the total number of tokens in existence.
693      * Burned tokens will reduce the count.
694      * To get the total number of tokens minted, please see {_totalMinted}.
695      */
696     function totalSupply() external view returns (uint256);
697 
698     // =============================================================
699     //                            IERC165
700     // =============================================================
701 
702     /**
703      * @dev Returns true if this contract implements the interface defined by
704      * `interfaceId`. See the corresponding
705      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
706      * to learn more about how these ids are created.
707      *
708      * This function call must use less than 30000 gas.
709      */
710     function supportsInterface(bytes4 interfaceId) external view returns (bool);
711 
712     // =============================================================
713     //                            IERC721
714     // =============================================================
715 
716     /**
717      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
718      */
719     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
720 
721     /**
722      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
723      */
724     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
725 
726     /**
727      * @dev Emitted when `owner` enables or disables
728      * (`approved`) `operator` to manage all of its assets.
729      */
730     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
731 
732     /**
733      * @dev Returns the number of tokens in `owner`'s account.
734      */
735     function balanceOf(address owner) external view returns (uint256 balance);
736 
737     /**
738      * @dev Returns the owner of the `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function ownerOf(uint256 tokenId) external view returns (address owner);
745 
746     /**
747      * @dev Safely transfers `tokenId` token from `from` to `to`,
748      * checking first that contract recipients are aware of the ERC721 protocol
749      * to prevent tokens from being forever locked.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must exist and be owned by `from`.
756      * - If the caller is not `from`, it must be have been allowed to move
757      * this token by either {approve} or {setApprovalForAll}.
758      * - If `to` refers to a smart contract, it must implement
759      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
760      *
761      * Emits a {Transfer} event.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes calldata data
768     ) external;
769 
770     /**
771      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
772      */
773     function safeTransferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) external;
778 
779     /**
780      * @dev Transfers `tokenId` from `from` to `to`.
781      *
782      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
783      * whenever possible.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must be owned by `from`.
790      * - If the caller is not `from`, it must be approved to move this token
791      * by either {approve} or {setApprovalForAll}.
792      *
793      * Emits a {Transfer} event.
794      */
795     function transferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) external;
800 
801     /**
802      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
803      * The approval is cleared when the token is transferred.
804      *
805      * Only a single account can be approved at a time, so approving the
806      * zero address clears previous approvals.
807      *
808      * Requirements:
809      *
810      * - The caller must own the token or be an approved operator.
811      * - `tokenId` must exist.
812      *
813      * Emits an {Approval} event.
814      */
815     function approve(address to, uint256 tokenId) external;
816 
817     /**
818      * @dev Approve or remove `operator` as an operator for the caller.
819      * Operators can call {transferFrom} or {safeTransferFrom}
820      * for any token owned by the caller.
821      *
822      * Requirements:
823      *
824      * - The `operator` cannot be the caller.
825      *
826      * Emits an {ApprovalForAll} event.
827      */
828     function setApprovalForAll(address operator, bool _approved) external;
829 
830     /**
831      * @dev Returns the account approved for `tokenId` token.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      */
837     function getApproved(uint256 tokenId) external view returns (address operator);
838 
839     /**
840      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
841      *
842      * See {setApprovalForAll}.
843      */
844     function isApprovedForAll(address owner, address operator) external view returns (bool);
845 
846     // =============================================================
847     //                        IERC721Metadata
848     // =============================================================
849 
850     /**
851      * @dev Returns the token collection name.
852      */
853     function name() external view returns (string memory);
854 
855     /**
856      * @dev Returns the token collection symbol.
857      */
858     function symbol() external view returns (string memory);
859 
860     /**
861      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
862      */
863     function tokenURI(uint256 tokenId) external view returns (string memory);
864 
865     // =============================================================
866     //                           IERC2309
867     // =============================================================
868 
869     /**
870      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
871      * (inclusive) is transferred from `from` to `to`, as defined in the
872      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
873      *
874      * See {_mintERC2309} for more details.
875      */
876     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
877 }
878 
879 // File: erc721a/contracts/ERC721A.sol
880 
881 
882 // ERC721A Contracts v4.2.2
883 // Creator: Chiru Labs
884 
885 pragma solidity ^0.8.4;
886 
887 
888 /**
889  * @dev Interface of ERC721 token receiver.
890  */
891 interface ERC721A__IERC721Receiver {
892     function onERC721Received(
893         address operator,
894         address from,
895         uint256 tokenId,
896         bytes calldata data
897     ) external returns (bytes4);
898 }
899 
900 /**
901  * @title ERC721A
902  *
903  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
904  * Non-Fungible Token Standard, including the Metadata extension.
905  * Optimized for lower gas during batch mints.
906  *
907  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
908  * starting from `_startTokenId()`.
909  *
910  * Assumptions:
911  *
912  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
913  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
914  */
915 contract ERC721A is IERC721A {
916     // Reference type for token approval.
917     struct TokenApprovalRef {
918         address value;
919     }
920 
921     // =============================================================
922     //                           CONSTANTS
923     // =============================================================
924 
925     // Mask of an entry in packed address data.
926     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
927 
928     // The bit position of `numberMinted` in packed address data.
929     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
930 
931     // The bit position of `numberBurned` in packed address data.
932     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
933 
934     // The bit position of `aux` in packed address data.
935     uint256 private constant _BITPOS_AUX = 192;
936 
937     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
938     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
939 
940     // The bit position of `startTimestamp` in packed ownership.
941     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
942 
943     // The bit mask of the `burned` bit in packed ownership.
944     uint256 private constant _BITMASK_BURNED = 1 << 224;
945 
946     // The bit position of the `nextInitialized` bit in packed ownership.
947     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
948 
949     // The bit mask of the `nextInitialized` bit in packed ownership.
950     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
951 
952     // The bit position of `extraData` in packed ownership.
953     uint256 private constant _BITPOS_EXTRA_DATA = 232;
954 
955     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
956     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
957 
958     // The mask of the lower 160 bits for addresses.
959     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
960 
961     // The maximum `quantity` that can be minted with {_mintERC2309}.
962     // This limit is to prevent overflows on the address data entries.
963     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
964     // is required to cause an overflow, which is unrealistic.
965     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
966 
967     // The `Transfer` event signature is given by:
968     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
969     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
970         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
971 
972     // =============================================================
973     //                            STORAGE
974     // =============================================================
975 
976     // The next token ID to be minted.
977     uint256 private _currentIndex;
978 
979     // The number of tokens burned.
980     uint256 private _burnCounter;
981 
982     // Token name
983     string private _name;
984 
985     // Token symbol
986     string private _symbol;
987 
988     // Mapping from token ID to ownership details
989     // An empty struct value does not necessarily mean the token is unowned.
990     // See {_packedOwnershipOf} implementation for details.
991     //
992     // Bits Layout:
993     // - [0..159]   `addr`
994     // - [160..223] `startTimestamp`
995     // - [224]      `burned`
996     // - [225]      `nextInitialized`
997     // - [232..255] `extraData`
998     mapping(uint256 => uint256) private _packedOwnerships;
999 
1000     // Mapping owner address to address data.
1001     //
1002     // Bits Layout:
1003     // - [0..63]    `balance`
1004     // - [64..127]  `numberMinted`
1005     // - [128..191] `numberBurned`
1006     // - [192..255] `aux`
1007     mapping(address => uint256) private _packedAddressData;
1008 
1009     // Mapping from token ID to approved address.
1010     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1011 
1012     // Mapping from owner to operator approvals
1013     mapping(address => mapping(address => bool)) private _operatorApprovals;
1014 
1015     // =============================================================
1016     //                          CONSTRUCTOR
1017     // =============================================================
1018 
1019     constructor(string memory name_, string memory symbol_) {
1020         _name = name_;
1021         _symbol = symbol_;
1022         _currentIndex = _startTokenId();
1023     }
1024 
1025     // =============================================================
1026     //                   TOKEN COUNTING OPERATIONS
1027     // =============================================================
1028 
1029     /**
1030      * @dev Returns the starting token ID.
1031      * To change the starting token ID, please override this function.
1032      */
1033     function _startTokenId() internal view virtual returns (uint256) {
1034         return 0;
1035     }
1036 
1037     /**
1038      * @dev Returns the next token ID to be minted.
1039      */
1040     function _nextTokenId() internal view virtual returns (uint256) {
1041         return _currentIndex;
1042     }
1043 
1044     /**
1045      * @dev Returns the total number of tokens in existence.
1046      * Burned tokens will reduce the count.
1047      * To get the total number of tokens minted, please see {_totalMinted}.
1048      */
1049     function totalSupply() public view virtual override returns (uint256) {
1050         // Counter underflow is impossible as _burnCounter cannot be incremented
1051         // more than `_currentIndex - _startTokenId()` times.
1052         unchecked {
1053             return _currentIndex - _burnCounter - _startTokenId();
1054         }
1055     }
1056 
1057     /**
1058      * @dev Returns the total amount of tokens minted in the contract.
1059      */
1060     function _totalMinted() internal view virtual returns (uint256) {
1061         // Counter underflow is impossible as `_currentIndex` does not decrement,
1062         // and it is initialized to `_startTokenId()`.
1063         unchecked {
1064             return _currentIndex - _startTokenId();
1065         }
1066     }
1067 
1068     /**
1069      * @dev Returns the total number of tokens burned.
1070      */
1071     function _totalBurned() internal view virtual returns (uint256) {
1072         return _burnCounter;
1073     }
1074 
1075     // =============================================================
1076     //                    ADDRESS DATA OPERATIONS
1077     // =============================================================
1078 
1079     /**
1080      * @dev Returns the number of tokens in `owner`'s account.
1081      */
1082     function balanceOf(address owner) public view virtual override returns (uint256) {
1083         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1084         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1085     }
1086 
1087     /**
1088      * Returns the number of tokens minted by `owner`.
1089      */
1090     function _numberMinted(address owner) internal view returns (uint256) {
1091         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1092     }
1093 
1094     /**
1095      * Returns the number of tokens burned by or on behalf of `owner`.
1096      */
1097     function _numberBurned(address owner) internal view returns (uint256) {
1098         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1099     }
1100 
1101     /**
1102      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1103      */
1104     function _getAux(address owner) internal view returns (uint64) {
1105         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1106     }
1107 
1108     /**
1109      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1110      * If there are multiple variables, please pack them into a uint64.
1111      */
1112     function _setAux(address owner, uint64 aux) internal virtual {
1113         uint256 packed = _packedAddressData[owner];
1114         uint256 auxCasted;
1115         // Cast `aux` with assembly to avoid redundant masking.
1116         assembly {
1117             auxCasted := aux
1118         }
1119         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1120         _packedAddressData[owner] = packed;
1121     }
1122 
1123     // =============================================================
1124     //                            IERC165
1125     // =============================================================
1126 
1127     /**
1128      * @dev Returns true if this contract implements the interface defined by
1129      * `interfaceId`. See the corresponding
1130      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1131      * to learn more about how these ids are created.
1132      *
1133      * This function call must use less than 30000 gas.
1134      */
1135     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1136         // The interface IDs are constants representing the first 4 bytes
1137         // of the XOR of all function selectors in the interface.
1138         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1139         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1140         return
1141             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1142             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1143             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1144     }
1145 
1146     // =============================================================
1147     //                        IERC721Metadata
1148     // =============================================================
1149 
1150     /**
1151      * @dev Returns the token collection name.
1152      */
1153     function name() public view virtual override returns (string memory) {
1154         return _name;
1155     }
1156 
1157     /**
1158      * @dev Returns the token collection symbol.
1159      */
1160     function symbol() public view virtual override returns (string memory) {
1161         return _symbol;
1162     }
1163 
1164     /**
1165      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1166      */
1167     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1168         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1169 
1170         string memory baseURI = _baseURI();
1171         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1172     }
1173 
1174     /**
1175      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1176      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1177      * by default, it can be overridden in child contracts.
1178      */
1179     function _baseURI() internal view virtual returns (string memory) {
1180         return '';
1181     }
1182 
1183     // =============================================================
1184     //                     OWNERSHIPS OPERATIONS
1185     // =============================================================
1186 
1187     /**
1188      * @dev Returns the owner of the `tokenId` token.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      */
1194     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1195         return address(uint160(_packedOwnershipOf(tokenId)));
1196     }
1197 
1198     /**
1199      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1200      * It gradually moves to O(1) as tokens get transferred around over time.
1201      */
1202     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1203         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1204     }
1205 
1206     /**
1207      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1208      */
1209     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1210         return _unpackedOwnership(_packedOwnerships[index]);
1211     }
1212 
1213     /**
1214      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1215      */
1216     function _initializeOwnershipAt(uint256 index) internal virtual {
1217         if (_packedOwnerships[index] == 0) {
1218             _packedOwnerships[index] = _packedOwnershipOf(index);
1219         }
1220     }
1221 
1222     /**
1223      * Returns the packed ownership data of `tokenId`.
1224      */
1225     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1226         uint256 curr = tokenId;
1227 
1228         unchecked {
1229             if (_startTokenId() <= curr)
1230                 if (curr < _currentIndex) {
1231                     uint256 packed = _packedOwnerships[curr];
1232                     // If not burned.
1233                     if (packed & _BITMASK_BURNED == 0) {
1234                         // Invariant:
1235                         // There will always be an initialized ownership slot
1236                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1237                         // before an unintialized ownership slot
1238                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1239                         // Hence, `curr` will not underflow.
1240                         //
1241                         // We can directly compare the packed value.
1242                         // If the address is zero, packed will be zero.
1243                         while (packed == 0) {
1244                             packed = _packedOwnerships[--curr];
1245                         }
1246                         return packed;
1247                     }
1248                 }
1249         }
1250         revert OwnerQueryForNonexistentToken();
1251     }
1252 
1253     /**
1254      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1255      */
1256     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1257         ownership.addr = address(uint160(packed));
1258         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1259         ownership.burned = packed & _BITMASK_BURNED != 0;
1260         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1261     }
1262 
1263     /**
1264      * @dev Packs ownership data into a single uint256.
1265      */
1266     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1267         assembly {
1268             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1269             owner := and(owner, _BITMASK_ADDRESS)
1270             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1271             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1272         }
1273     }
1274 
1275     /**
1276      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1277      */
1278     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1279         // For branchless setting of the `nextInitialized` flag.
1280         assembly {
1281             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1282             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1283         }
1284     }
1285 
1286     // =============================================================
1287     //                      APPROVAL OPERATIONS
1288     // =============================================================
1289 
1290     /**
1291      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1292      * The approval is cleared when the token is transferred.
1293      *
1294      * Only a single account can be approved at a time, so approving the
1295      * zero address clears previous approvals.
1296      *
1297      * Requirements:
1298      *
1299      * - The caller must own the token or be an approved operator.
1300      * - `tokenId` must exist.
1301      *
1302      * Emits an {Approval} event.
1303      */
1304     function approve(address to, uint256 tokenId) public virtual override {
1305         address owner = ownerOf(tokenId);
1306 
1307         if (_msgSenderERC721A() != owner)
1308             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1309                 revert ApprovalCallerNotOwnerNorApproved();
1310             }
1311 
1312         _tokenApprovals[tokenId].value = to;
1313         emit Approval(owner, to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev Returns the account approved for `tokenId` token.
1318      *
1319      * Requirements:
1320      *
1321      * - `tokenId` must exist.
1322      */
1323     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1324         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1325 
1326         return _tokenApprovals[tokenId].value;
1327     }
1328 
1329     /**
1330      * @dev Approve or remove `operator` as an operator for the caller.
1331      * Operators can call {transferFrom} or {safeTransferFrom}
1332      * for any token owned by the caller.
1333      *
1334      * Requirements:
1335      *
1336      * - The `operator` cannot be the caller.
1337      *
1338      * Emits an {ApprovalForAll} event.
1339      */
1340     function setApprovalForAll(address operator, bool approved) public virtual override {
1341         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1342 
1343         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1344         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1345     }
1346 
1347     /**
1348      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1349      *
1350      * See {setApprovalForAll}.
1351      */
1352     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1353         return _operatorApprovals[owner][operator];
1354     }
1355 
1356     /**
1357      * @dev Returns whether `tokenId` exists.
1358      *
1359      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1360      *
1361      * Tokens start existing when they are minted. See {_mint}.
1362      */
1363     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1364         return
1365             _startTokenId() <= tokenId &&
1366             tokenId < _currentIndex && // If within bounds,
1367             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1368     }
1369 
1370     /**
1371      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1372      */
1373     function _isSenderApprovedOrOwner(
1374         address approvedAddress,
1375         address owner,
1376         address msgSender
1377     ) private pure returns (bool result) {
1378         assembly {
1379             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1380             owner := and(owner, _BITMASK_ADDRESS)
1381             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1382             msgSender := and(msgSender, _BITMASK_ADDRESS)
1383             // `msgSender == owner || msgSender == approvedAddress`.
1384             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1385         }
1386     }
1387 
1388     /**
1389      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1390      */
1391     function _getApprovedSlotAndAddress(uint256 tokenId)
1392         private
1393         view
1394         returns (uint256 approvedAddressSlot, address approvedAddress)
1395     {
1396         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1397         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1398         assembly {
1399             approvedAddressSlot := tokenApproval.slot
1400             approvedAddress := sload(approvedAddressSlot)
1401         }
1402     }
1403 
1404     // =============================================================
1405     //                      TRANSFER OPERATIONS
1406     // =============================================================
1407 
1408     /**
1409      * @dev Transfers `tokenId` from `from` to `to`.
1410      *
1411      * Requirements:
1412      *
1413      * - `from` cannot be the zero address.
1414      * - `to` cannot be the zero address.
1415      * - `tokenId` token must be owned by `from`.
1416      * - If the caller is not `from`, it must be approved to move this token
1417      * by either {approve} or {setApprovalForAll}.
1418      *
1419      * Emits a {Transfer} event.
1420      */
1421     function transferFrom(
1422         address from,
1423         address to,
1424         uint256 tokenId
1425     ) public virtual override {
1426         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1427 
1428         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1429 
1430         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1431 
1432         // The nested ifs save around 20+ gas over a compound boolean condition.
1433         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1434             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1435 
1436         if (to == address(0)) revert TransferToZeroAddress();
1437 
1438         _beforeTokenTransfers(from, to, tokenId, 1);
1439 
1440         // Clear approvals from the previous owner.
1441         assembly {
1442             if approvedAddress {
1443                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1444                 sstore(approvedAddressSlot, 0)
1445             }
1446         }
1447 
1448         // Underflow of the sender's balance is impossible because we check for
1449         // ownership above and the recipient's balance can't realistically overflow.
1450         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1451         unchecked {
1452             // We can directly increment and decrement the balances.
1453             --_packedAddressData[from]; // Updates: `balance -= 1`.
1454             ++_packedAddressData[to]; // Updates: `balance += 1`.
1455 
1456             // Updates:
1457             // - `address` to the next owner.
1458             // - `startTimestamp` to the timestamp of transfering.
1459             // - `burned` to `false`.
1460             // - `nextInitialized` to `true`.
1461             _packedOwnerships[tokenId] = _packOwnershipData(
1462                 to,
1463                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1464             );
1465 
1466             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1467             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1468                 uint256 nextTokenId = tokenId + 1;
1469                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1470                 if (_packedOwnerships[nextTokenId] == 0) {
1471                     // If the next slot is within bounds.
1472                     if (nextTokenId != _currentIndex) {
1473                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1474                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1475                     }
1476                 }
1477             }
1478         }
1479 
1480         emit Transfer(from, to, tokenId);
1481         _afterTokenTransfers(from, to, tokenId, 1);
1482     }
1483 
1484     /**
1485      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1486      */
1487     function safeTransferFrom(
1488         address from,
1489         address to,
1490         uint256 tokenId
1491     ) public virtual override {
1492         safeTransferFrom(from, to, tokenId, '');
1493     }
1494 
1495     /**
1496      * @dev Safely transfers `tokenId` token from `from` to `to`.
1497      *
1498      * Requirements:
1499      *
1500      * - `from` cannot be the zero address.
1501      * - `to` cannot be the zero address.
1502      * - `tokenId` token must exist and be owned by `from`.
1503      * - If the caller is not `from`, it must be approved to move this token
1504      * by either {approve} or {setApprovalForAll}.
1505      * - If `to` refers to a smart contract, it must implement
1506      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1507      *
1508      * Emits a {Transfer} event.
1509      */
1510     function safeTransferFrom(
1511         address from,
1512         address to,
1513         uint256 tokenId,
1514         bytes memory _data
1515     ) public virtual override {
1516         transferFrom(from, to, tokenId);
1517         if (to.code.length != 0)
1518             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1519                 revert TransferToNonERC721ReceiverImplementer();
1520             }
1521     }
1522 
1523     /**
1524      * @dev Hook that is called before a set of serially-ordered token IDs
1525      * are about to be transferred. This includes minting.
1526      * And also called before burning one token.
1527      *
1528      * `startTokenId` - the first token ID to be transferred.
1529      * `quantity` - the amount to be transferred.
1530      *
1531      * Calling conditions:
1532      *
1533      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1534      * transferred to `to`.
1535      * - When `from` is zero, `tokenId` will be minted for `to`.
1536      * - When `to` is zero, `tokenId` will be burned by `from`.
1537      * - `from` and `to` are never both zero.
1538      */
1539     function _beforeTokenTransfers(
1540         address from,
1541         address to,
1542         uint256 startTokenId,
1543         uint256 quantity
1544     ) internal virtual {}
1545 
1546     /**
1547      * @dev Hook that is called after a set of serially-ordered token IDs
1548      * have been transferred. This includes minting.
1549      * And also called after one token has been burned.
1550      *
1551      * `startTokenId` - the first token ID to be transferred.
1552      * `quantity` - the amount to be transferred.
1553      *
1554      * Calling conditions:
1555      *
1556      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1557      * transferred to `to`.
1558      * - When `from` is zero, `tokenId` has been minted for `to`.
1559      * - When `to` is zero, `tokenId` has been burned by `from`.
1560      * - `from` and `to` are never both zero.
1561      */
1562     function _afterTokenTransfers(
1563         address from,
1564         address to,
1565         uint256 startTokenId,
1566         uint256 quantity
1567     ) internal virtual {}
1568 
1569     /**
1570      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1571      *
1572      * `from` - Previous owner of the given token ID.
1573      * `to` - Target address that will receive the token.
1574      * `tokenId` - Token ID to be transferred.
1575      * `_data` - Optional data to send along with the call.
1576      *
1577      * Returns whether the call correctly returned the expected magic value.
1578      */
1579     function _checkContractOnERC721Received(
1580         address from,
1581         address to,
1582         uint256 tokenId,
1583         bytes memory _data
1584     ) private returns (bool) {
1585         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1586             bytes4 retval
1587         ) {
1588             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1589         } catch (bytes memory reason) {
1590             if (reason.length == 0) {
1591                 revert TransferToNonERC721ReceiverImplementer();
1592             } else {
1593                 assembly {
1594                     revert(add(32, reason), mload(reason))
1595                 }
1596             }
1597         }
1598     }
1599 
1600     // =============================================================
1601     //                        MINT OPERATIONS
1602     // =============================================================
1603 
1604     /**
1605      * @dev Mints `quantity` tokens and transfers them to `to`.
1606      *
1607      * Requirements:
1608      *
1609      * - `to` cannot be the zero address.
1610      * - `quantity` must be greater than 0.
1611      *
1612      * Emits a {Transfer} event for each mint.
1613      */
1614     function _mint(address to, uint256 quantity) internal virtual {
1615         uint256 startTokenId = _currentIndex;
1616         if (quantity == 0) revert MintZeroQuantity();
1617 
1618         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1619 
1620         // Overflows are incredibly unrealistic.
1621         // `balance` and `numberMinted` have a maximum limit of 2**64.
1622         // `tokenId` has a maximum limit of 2**256.
1623         unchecked {
1624             // Updates:
1625             // - `balance += quantity`.
1626             // - `numberMinted += quantity`.
1627             //
1628             // We can directly add to the `balance` and `numberMinted`.
1629             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1630 
1631             // Updates:
1632             // - `address` to the owner.
1633             // - `startTimestamp` to the timestamp of minting.
1634             // - `burned` to `false`.
1635             // - `nextInitialized` to `quantity == 1`.
1636             _packedOwnerships[startTokenId] = _packOwnershipData(
1637                 to,
1638                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1639             );
1640 
1641             uint256 toMasked;
1642             uint256 end = startTokenId + quantity;
1643 
1644             // Use assembly to loop and emit the `Transfer` event for gas savings.
1645             assembly {
1646                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1647                 toMasked := and(to, _BITMASK_ADDRESS)
1648                 // Emit the `Transfer` event.
1649                 log4(
1650                     0, // Start of data (0, since no data).
1651                     0, // End of data (0, since no data).
1652                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1653                     0, // `address(0)`.
1654                     toMasked, // `to`.
1655                     startTokenId // `tokenId`.
1656                 )
1657 
1658                 for {
1659                     let tokenId := add(startTokenId, 1)
1660                 } iszero(eq(tokenId, end)) {
1661                     tokenId := add(tokenId, 1)
1662                 } {
1663                     // Emit the `Transfer` event. Similar to above.
1664                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1665                 }
1666             }
1667             if (toMasked == 0) revert MintToZeroAddress();
1668 
1669             _currentIndex = end;
1670         }
1671         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1672     }
1673 
1674     /**
1675      * @dev Mints `quantity` tokens and transfers them to `to`.
1676      *
1677      * This function is intended for efficient minting only during contract creation.
1678      *
1679      * It emits only one {ConsecutiveTransfer} as defined in
1680      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1681      * instead of a sequence of {Transfer} event(s).
1682      *
1683      * Calling this function outside of contract creation WILL make your contract
1684      * non-compliant with the ERC721 standard.
1685      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1686      * {ConsecutiveTransfer} event is only permissible during contract creation.
1687      *
1688      * Requirements:
1689      *
1690      * - `to` cannot be the zero address.
1691      * - `quantity` must be greater than 0.
1692      *
1693      * Emits a {ConsecutiveTransfer} event.
1694      */
1695     function _mintERC2309(address to, uint256 quantity) internal virtual {
1696         uint256 startTokenId = _currentIndex;
1697         if (to == address(0)) revert MintToZeroAddress();
1698         if (quantity == 0) revert MintZeroQuantity();
1699         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1700 
1701         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1702 
1703         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1704         unchecked {
1705             // Updates:
1706             // - `balance += quantity`.
1707             // - `numberMinted += quantity`.
1708             //
1709             // We can directly add to the `balance` and `numberMinted`.
1710             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1711 
1712             // Updates:
1713             // - `address` to the owner.
1714             // - `startTimestamp` to the timestamp of minting.
1715             // - `burned` to `false`.
1716             // - `nextInitialized` to `quantity == 1`.
1717             _packedOwnerships[startTokenId] = _packOwnershipData(
1718                 to,
1719                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1720             );
1721 
1722             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1723 
1724             _currentIndex = startTokenId + quantity;
1725         }
1726         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1727     }
1728 
1729     /**
1730      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1731      *
1732      * Requirements:
1733      *
1734      * - If `to` refers to a smart contract, it must implement
1735      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1736      * - `quantity` must be greater than 0.
1737      *
1738      * See {_mint}.
1739      *
1740      * Emits a {Transfer} event for each mint.
1741      */
1742     function _safeMint(
1743         address to,
1744         uint256 quantity,
1745         bytes memory _data
1746     ) internal virtual {
1747         _mint(to, quantity);
1748 
1749         unchecked {
1750             if (to.code.length != 0) {
1751                 uint256 end = _currentIndex;
1752                 uint256 index = end - quantity;
1753                 do {
1754                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1755                         revert TransferToNonERC721ReceiverImplementer();
1756                     }
1757                 } while (index < end);
1758                 // Reentrancy protection.
1759                 if (_currentIndex != end) revert();
1760             }
1761         }
1762     }
1763 
1764     /**
1765      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1766      */
1767     function _safeMint(address to, uint256 quantity) internal virtual {
1768         _safeMint(to, quantity, '');
1769     }
1770 
1771     // =============================================================
1772     //                        BURN OPERATIONS
1773     // =============================================================
1774 
1775     /**
1776      * @dev Equivalent to `_burn(tokenId, false)`.
1777      */
1778     function _burn(uint256 tokenId) internal virtual {
1779         _burn(tokenId, false);
1780     }
1781 
1782     /**
1783      * @dev Destroys `tokenId`.
1784      * The approval is cleared when the token is burned.
1785      *
1786      * Requirements:
1787      *
1788      * - `tokenId` must exist.
1789      *
1790      * Emits a {Transfer} event.
1791      */
1792     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1793         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1794 
1795         address from = address(uint160(prevOwnershipPacked));
1796 
1797         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1798 
1799         if (approvalCheck) {
1800             // The nested ifs save around 20+ gas over a compound boolean condition.
1801             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1802                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1803         }
1804 
1805         _beforeTokenTransfers(from, address(0), tokenId, 1);
1806 
1807         // Clear approvals from the previous owner.
1808         assembly {
1809             if approvedAddress {
1810                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1811                 sstore(approvedAddressSlot, 0)
1812             }
1813         }
1814 
1815         // Underflow of the sender's balance is impossible because we check for
1816         // ownership above and the recipient's balance can't realistically overflow.
1817         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1818         unchecked {
1819             // Updates:
1820             // - `balance -= 1`.
1821             // - `numberBurned += 1`.
1822             //
1823             // We can directly decrement the balance, and increment the number burned.
1824             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1825             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1826 
1827             // Updates:
1828             // - `address` to the last owner.
1829             // - `startTimestamp` to the timestamp of burning.
1830             // - `burned` to `true`.
1831             // - `nextInitialized` to `true`.
1832             _packedOwnerships[tokenId] = _packOwnershipData(
1833                 from,
1834                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1835             );
1836 
1837             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1838             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1839                 uint256 nextTokenId = tokenId + 1;
1840                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1841                 if (_packedOwnerships[nextTokenId] == 0) {
1842                     // If the next slot is within bounds.
1843                     if (nextTokenId != _currentIndex) {
1844                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1845                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1846                     }
1847                 }
1848             }
1849         }
1850 
1851         emit Transfer(from, address(0), tokenId);
1852         _afterTokenTransfers(from, address(0), tokenId, 1);
1853 
1854         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1855         unchecked {
1856             _burnCounter++;
1857         }
1858     }
1859 
1860     // =============================================================
1861     //                     EXTRA DATA OPERATIONS
1862     // =============================================================
1863 
1864     /**
1865      * @dev Directly sets the extra data for the ownership data `index`.
1866      */
1867     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1868         uint256 packed = _packedOwnerships[index];
1869         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1870         uint256 extraDataCasted;
1871         // Cast `extraData` with assembly to avoid redundant masking.
1872         assembly {
1873             extraDataCasted := extraData
1874         }
1875         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1876         _packedOwnerships[index] = packed;
1877     }
1878 
1879     /**
1880      * @dev Called during each token transfer to set the 24bit `extraData` field.
1881      * Intended to be overridden by the cosumer contract.
1882      *
1883      * `previousExtraData` - the value of `extraData` before transfer.
1884      *
1885      * Calling conditions:
1886      *
1887      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1888      * transferred to `to`.
1889      * - When `from` is zero, `tokenId` will be minted for `to`.
1890      * - When `to` is zero, `tokenId` will be burned by `from`.
1891      * - `from` and `to` are never both zero.
1892      */
1893     function _extraData(
1894         address from,
1895         address to,
1896         uint24 previousExtraData
1897     ) internal view virtual returns (uint24) {}
1898 
1899     /**
1900      * @dev Returns the next extra data for the packed ownership data.
1901      * The returned result is shifted into position.
1902      */
1903     function _nextExtraData(
1904         address from,
1905         address to,
1906         uint256 prevOwnershipPacked
1907     ) private view returns (uint256) {
1908         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1909         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1910     }
1911 
1912     // =============================================================
1913     //                       OTHER OPERATIONS
1914     // =============================================================
1915 
1916     /**
1917      * @dev Returns the message sender (defaults to `msg.sender`).
1918      *
1919      * If you are writing GSN compatible contracts, you need to override this function.
1920      */
1921     function _msgSenderERC721A() internal view virtual returns (address) {
1922         return msg.sender;
1923     }
1924 
1925     /**
1926      * @dev Converts a uint256 to its ASCII string decimal representation.
1927      */
1928     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1929         assembly {
1930             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1931             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1932             // We will need 1 32-byte word to store the length,
1933             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1934             str := add(mload(0x40), 0x80)
1935             // Update the free memory pointer to allocate.
1936             mstore(0x40, str)
1937 
1938             // Cache the end of the memory to calculate the length later.
1939             let end := str
1940 
1941             // We write the string from rightmost digit to leftmost digit.
1942             // The following is essentially a do-while loop that also handles the zero case.
1943             // prettier-ignore
1944             for { let temp := value } 1 {} {
1945                 str := sub(str, 1)
1946                 // Write the character to the pointer.
1947                 // The ASCII index of the '0' character is 48.
1948                 mstore8(str, add(48, mod(temp, 10)))
1949                 // Keep dividing `temp` until zero.
1950                 temp := div(temp, 10)
1951                 // prettier-ignore
1952                 if iszero(temp) { break }
1953             }
1954 
1955             let length := sub(end, str)
1956             // Move the pointer 32 bytes leftwards to make room for the length.
1957             str := sub(str, 0x20)
1958             // Store the length.
1959             mstore(str, length)
1960         }
1961     }
1962 }
1963 
1964 // File: contracts/VitalikDaigaku.sol
1965 
1966 
1967 
1968 
1969 
1970 
1971 
1972 
1973 
1974 
1975 
1976 pragma solidity ^0.8.7;
1977 
1978 contract VitalikDaigaku is ERC721A, Ownable, ReentrancyGuard {
1979   using Address for address;
1980   using Strings for uint;
1981 
1982   string  public  baseTokenURI = "";
1983   uint256  public  Max_Supply = 3000;
1984   uint256 public  Max_Per_TX = 10;
1985   uint256 public  Price = 0.001 ether;
1986   uint256 public  Num_Free_Mints = 1000;
1987   uint256 public  Max_Free_Per_Wallet = 1;
1988   bool public isMintActive = true;
1989 
1990   constructor(
1991 
1992   ) ERC721A("VitalikDaigaku", "VBD") {
1993 
1994   }
1995 
1996   function mint(uint256 numberOfTokens)
1997       external
1998       payable
1999   {
2000     require(isMintActive, "Mint not active yet");
2001     require(totalSupply() + numberOfTokens < Max_Supply + 1, "No more");
2002 
2003     if(totalSupply() > Num_Free_Mints){
2004         require(
2005             (Price * numberOfTokens) <= msg.value,
2006             "Incorrect ETH value sent"
2007         );
2008     } else {
2009         if (numberOfTokens > Max_Free_Per_Wallet) {
2010         require(
2011             (Price * numberOfTokens) <= msg.value,
2012             "Incorrect ETH value sent"
2013         );
2014         require(
2015             numberOfTokens <= Max_Per_TX,
2016             "Max mints per transaction exceeded"
2017         );
2018         } else {
2019             require(
2020                 numberOfTokens <= Max_Free_Per_Wallet,
2021                 "Max mints per transaction exceeded"
2022             );
2023         }
2024     }
2025     _safeMint(msg.sender, numberOfTokens);
2026   }
2027 
2028   function setBaseURI(string memory baseURI)
2029     public
2030     onlyOwner
2031   {
2032     baseTokenURI = baseURI;
2033   }
2034 
2035   function _startTokenId() internal override view virtual returns (uint256) {
2036     return 1;
2037   }
2038 
2039   function treasuryMint(uint quantity)
2040     public
2041     onlyOwner
2042   {
2043     require(
2044       quantity > 0,
2045       "Invalid mint amount"
2046     );
2047     require(
2048       totalSupply() + quantity <= Max_Supply,
2049       "Maximum supply exceeded"
2050     );
2051     _safeMint(msg.sender, quantity);
2052   }
2053 
2054   function withdraw()
2055     public
2056     onlyOwner
2057     nonReentrant
2058   {
2059     Address.sendValue(payable(msg.sender), address(this).balance);
2060   }
2061 
2062   function tokenURI(uint _tokenId)
2063     public
2064     view
2065     virtual
2066     override
2067     returns (string memory)
2068   {
2069     require(
2070       _exists(_tokenId),
2071       "ERC721Metadata: URI query for nonexistent token"
2072     );
2073     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
2074   }
2075 
2076   function _baseURI()
2077     internal
2078     view
2079     virtual
2080     override
2081     returns (string memory)
2082   {
2083     return baseTokenURI;
2084   }
2085 
2086   function setIsMintActive(bool _isMintActive)
2087       external
2088       onlyOwner
2089   {
2090       isMintActive = _isMintActive;
2091   }
2092 
2093   function setNumFreeMints(uint256 _numfreemints)
2094       external
2095       onlyOwner
2096   {
2097       Num_Free_Mints = _numfreemints;
2098   }
2099 
2100   function setMaxSupply(uint256 _Max_Supply)
2101       external
2102       onlyOwner
2103   {
2104       Max_Supply = _Max_Supply;
2105   }
2106 
2107   function setSalePrice(uint256 _Price)
2108       external
2109       onlyOwner
2110   {
2111       Price = _Price;
2112   }
2113 
2114   function setMaxLimitPerTransaction(uint256 _limit)
2115       external
2116       onlyOwner
2117   {
2118       Max_Per_TX = _limit;
2119   }
2120 
2121   function setFreeLimitPerWallet(uint256 _limit)
2122       external
2123       onlyOwner
2124   {
2125       Max_Free_Per_Wallet = _limit;
2126   }
2127 }