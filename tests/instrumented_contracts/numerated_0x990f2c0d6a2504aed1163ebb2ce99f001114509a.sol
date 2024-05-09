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
592 // ERC721A Contracts v4.2.3
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
612      * Cannot query the balance for the zero address.
613      */
614     error BalanceQueryForZeroAddress();
615 
616     /**
617      * Cannot mint to the zero address.
618      */
619     error MintToZeroAddress();
620 
621     /**
622      * The quantity of tokens minted must be more than zero.
623      */
624     error MintZeroQuantity();
625 
626     /**
627      * The token does not exist.
628      */
629     error OwnerQueryForNonexistentToken();
630 
631     /**
632      * The caller must own the token or be an approved operator.
633      */
634     error TransferCallerNotOwnerNorApproved();
635 
636     /**
637      * The token must be owned by `from`.
638      */
639     error TransferFromIncorrectOwner();
640 
641     /**
642      * Cannot safely transfer to a contract that does not implement the
643      * ERC721Receiver interface.
644      */
645     error TransferToNonERC721ReceiverImplementer();
646 
647     /**
648      * Cannot transfer to the zero address.
649      */
650     error TransferToZeroAddress();
651 
652     /**
653      * The token does not exist.
654      */
655     error URIQueryForNonexistentToken();
656 
657     /**
658      * The `quantity` minted with ERC2309 exceeds the safety limit.
659      */
660     error MintERC2309QuantityExceedsLimit();
661 
662     /**
663      * The `extraData` cannot be set on an unintialized ownership slot.
664      */
665     error OwnershipNotInitializedForExtraData();
666 
667     // =============================================================
668     //                            STRUCTS
669     // =============================================================
670 
671     struct TokenOwnership {
672         // The address of the owner.
673         address addr;
674         // Stores the start time of ownership with minimal overhead for tokenomics.
675         uint64 startTimestamp;
676         // Whether the token has been burned.
677         bool burned;
678         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
679         uint24 extraData;
680     }
681 
682     // =============================================================
683     //                         TOKEN COUNTERS
684     // =============================================================
685 
686     /**
687      * @dev Returns the total number of tokens in existence.
688      * Burned tokens will reduce the count.
689      * To get the total number of tokens minted, please see {_totalMinted}.
690      */
691     function totalSupply() external view returns (uint256);
692 
693     // =============================================================
694     //                            IERC165
695     // =============================================================
696 
697     /**
698      * @dev Returns true if this contract implements the interface defined by
699      * `interfaceId`. See the corresponding
700      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
701      * to learn more about how these ids are created.
702      *
703      * This function call must use less than 30000 gas.
704      */
705     function supportsInterface(bytes4 interfaceId) external view returns (bool);
706 
707     // =============================================================
708     //                            IERC721
709     // =============================================================
710 
711     /**
712      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
713      */
714     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
715 
716     /**
717      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
718      */
719     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
720 
721     /**
722      * @dev Emitted when `owner` enables or disables
723      * (`approved`) `operator` to manage all of its assets.
724      */
725     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
726 
727     /**
728      * @dev Returns the number of tokens in `owner`'s account.
729      */
730     function balanceOf(address owner) external view returns (uint256 balance);
731 
732     /**
733      * @dev Returns the owner of the `tokenId` token.
734      *
735      * Requirements:
736      *
737      * - `tokenId` must exist.
738      */
739     function ownerOf(uint256 tokenId) external view returns (address owner);
740 
741     /**
742      * @dev Safely transfers `tokenId` token from `from` to `to`,
743      * checking first that contract recipients are aware of the ERC721 protocol
744      * to prevent tokens from being forever locked.
745      *
746      * Requirements:
747      *
748      * - `from` cannot be the zero address.
749      * - `to` cannot be the zero address.
750      * - `tokenId` token must exist and be owned by `from`.
751      * - If the caller is not `from`, it must be have been allowed to move
752      * this token by either {approve} or {setApprovalForAll}.
753      * - If `to` refers to a smart contract, it must implement
754      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes calldata data
763     ) external payable;
764 
765     /**
766      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) external payable;
773 
774     /**
775      * @dev Transfers `tokenId` from `from` to `to`.
776      *
777      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
778      * whenever possible.
779      *
780      * Requirements:
781      *
782      * - `from` cannot be the zero address.
783      * - `to` cannot be the zero address.
784      * - `tokenId` token must be owned by `from`.
785      * - If the caller is not `from`, it must be approved to move this token
786      * by either {approve} or {setApprovalForAll}.
787      *
788      * Emits a {Transfer} event.
789      */
790     function transferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) external payable;
795 
796     /**
797      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
798      * The approval is cleared when the token is transferred.
799      *
800      * Only a single account can be approved at a time, so approving the
801      * zero address clears previous approvals.
802      *
803      * Requirements:
804      *
805      * - The caller must own the token or be an approved operator.
806      * - `tokenId` must exist.
807      *
808      * Emits an {Approval} event.
809      */
810     function approve(address to, uint256 tokenId) external payable;
811 
812     /**
813      * @dev Approve or remove `operator` as an operator for the caller.
814      * Operators can call {transferFrom} or {safeTransferFrom}
815      * for any token owned by the caller.
816      *
817      * Requirements:
818      *
819      * - The `operator` cannot be the caller.
820      *
821      * Emits an {ApprovalForAll} event.
822      */
823     function setApprovalForAll(address operator, bool _approved) external;
824 
825     /**
826      * @dev Returns the account approved for `tokenId` token.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      */
832     function getApproved(uint256 tokenId) external view returns (address operator);
833 
834     /**
835      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
836      *
837      * See {setApprovalForAll}.
838      */
839     function isApprovedForAll(address owner, address operator) external view returns (bool);
840 
841     // =============================================================
842     //                        IERC721Metadata
843     // =============================================================
844 
845     /**
846      * @dev Returns the token collection name.
847      */
848     function name() external view returns (string memory);
849 
850     /**
851      * @dev Returns the token collection symbol.
852      */
853     function symbol() external view returns (string memory);
854 
855     /**
856      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
857      */
858     function tokenURI(uint256 tokenId) external view returns (string memory);
859 
860     // =============================================================
861     //                           IERC2309
862     // =============================================================
863 
864     /**
865      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
866      * (inclusive) is transferred from `from` to `to`, as defined in the
867      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
868      *
869      * See {_mintERC2309} for more details.
870      */
871     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
872 }
873 
874 // File: erc721a/contracts/ERC721A.sol
875 
876 
877 // ERC721A Contracts v4.2.3
878 // Creator: Chiru Labs
879 
880 pragma solidity ^0.8.4;
881 
882 
883 /**
884  * @dev Interface of ERC721 token receiver.
885  */
886 interface ERC721A__IERC721Receiver {
887     function onERC721Received(
888         address operator,
889         address from,
890         uint256 tokenId,
891         bytes calldata data
892     ) external returns (bytes4);
893 }
894 
895 /**
896  * @title ERC721A
897  *
898  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
899  * Non-Fungible Token Standard, including the Metadata extension.
900  * Optimized for lower gas during batch mints.
901  *
902  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
903  * starting from `_startTokenId()`.
904  *
905  * Assumptions:
906  *
907  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
908  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
909  */
910 contract ERC721A is IERC721A {
911     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
912     struct TokenApprovalRef {
913         address value;
914     }
915 
916     // =============================================================
917     //                           CONSTANTS
918     // =============================================================
919 
920     // Mask of an entry in packed address data.
921     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
922 
923     // The bit position of `numberMinted` in packed address data.
924     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
925 
926     // The bit position of `numberBurned` in packed address data.
927     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
928 
929     // The bit position of `aux` in packed address data.
930     uint256 private constant _BITPOS_AUX = 192;
931 
932     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
933     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
934 
935     // The bit position of `startTimestamp` in packed ownership.
936     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
937 
938     // The bit mask of the `burned` bit in packed ownership.
939     uint256 private constant _BITMASK_BURNED = 1 << 224;
940 
941     // The bit position of the `nextInitialized` bit in packed ownership.
942     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
943 
944     // The bit mask of the `nextInitialized` bit in packed ownership.
945     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
946 
947     // The bit position of `extraData` in packed ownership.
948     uint256 private constant _BITPOS_EXTRA_DATA = 232;
949 
950     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
951     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
952 
953     // The mask of the lower 160 bits for addresses.
954     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
955 
956     // The maximum `quantity` that can be minted with {_mintERC2309}.
957     // This limit is to prevent overflows on the address data entries.
958     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
959     // is required to cause an overflow, which is unrealistic.
960     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
961 
962     // The `Transfer` event signature is given by:
963     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
964     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
965         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
966 
967     // =============================================================
968     //                            STORAGE
969     // =============================================================
970 
971     // The next token ID to be minted.
972     uint256 private _currentIndex;
973 
974     // The number of tokens burned.
975     uint256 private _burnCounter;
976 
977     // Token name
978     string private _name;
979 
980     // Token symbol
981     string private _symbol;
982 
983     // Mapping from token ID to ownership details
984     // An empty struct value does not necessarily mean the token is unowned.
985     // See {_packedOwnershipOf} implementation for details.
986     //
987     // Bits Layout:
988     // - [0..159]   `addr`
989     // - [160..223] `startTimestamp`
990     // - [224]      `burned`
991     // - [225]      `nextInitialized`
992     // - [232..255] `extraData`
993     mapping(uint256 => uint256) private _packedOwnerships;
994 
995     // Mapping owner address to address data.
996     //
997     // Bits Layout:
998     // - [0..63]    `balance`
999     // - [64..127]  `numberMinted`
1000     // - [128..191] `numberBurned`
1001     // - [192..255] `aux`
1002     mapping(address => uint256) private _packedAddressData;
1003 
1004     // Mapping from token ID to approved address.
1005     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1006 
1007     // Mapping from owner to operator approvals
1008     mapping(address => mapping(address => bool)) private _operatorApprovals;
1009 
1010     // =============================================================
1011     //                          CONSTRUCTOR
1012     // =============================================================
1013 
1014     constructor(string memory name_, string memory symbol_) {
1015         _name = name_;
1016         _symbol = symbol_;
1017         _currentIndex = _startTokenId();
1018     }
1019 
1020     // =============================================================
1021     //                   TOKEN COUNTING OPERATIONS
1022     // =============================================================
1023 
1024     /**
1025      * @dev Returns the starting token ID.
1026      * To change the starting token ID, please override this function.
1027      */
1028     function _startTokenId() internal view virtual returns (uint256) {
1029         return 0;
1030     }
1031 
1032     /**
1033      * @dev Returns the next token ID to be minted.
1034      */
1035     function _nextTokenId() internal view virtual returns (uint256) {
1036         return _currentIndex;
1037     }
1038 
1039     /**
1040      * @dev Returns the total number of tokens in existence.
1041      * Burned tokens will reduce the count.
1042      * To get the total number of tokens minted, please see {_totalMinted}.
1043      */
1044     function totalSupply() public view virtual override returns (uint256) {
1045         // Counter underflow is impossible as _burnCounter cannot be incremented
1046         // more than `_currentIndex - _startTokenId()` times.
1047         unchecked {
1048             return _currentIndex - _burnCounter - _startTokenId();
1049         }
1050     }
1051 
1052     /**
1053      * @dev Returns the total amount of tokens minted in the contract.
1054      */
1055     function _totalMinted() internal view virtual returns (uint256) {
1056         // Counter underflow is impossible as `_currentIndex` does not decrement,
1057         // and it is initialized to `_startTokenId()`.
1058         unchecked {
1059             return _currentIndex - _startTokenId();
1060         }
1061     }
1062 
1063     /**
1064      * @dev Returns the total number of tokens burned.
1065      */
1066     function _totalBurned() internal view virtual returns (uint256) {
1067         return _burnCounter;
1068     }
1069 
1070     // =============================================================
1071     //                    ADDRESS DATA OPERATIONS
1072     // =============================================================
1073 
1074     /**
1075      * @dev Returns the number of tokens in `owner`'s account.
1076      */
1077     function balanceOf(address owner) public view virtual override returns (uint256) {
1078         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1079         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1080     }
1081 
1082     /**
1083      * Returns the number of tokens minted by `owner`.
1084      */
1085     function _numberMinted(address owner) internal view returns (uint256) {
1086         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1087     }
1088 
1089     /**
1090      * Returns the number of tokens burned by or on behalf of `owner`.
1091      */
1092     function _numberBurned(address owner) internal view returns (uint256) {
1093         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1094     }
1095 
1096     /**
1097      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1098      */
1099     function _getAux(address owner) internal view returns (uint64) {
1100         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1101     }
1102 
1103     /**
1104      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1105      * If there are multiple variables, please pack them into a uint64.
1106      */
1107     function _setAux(address owner, uint64 aux) internal virtual {
1108         uint256 packed = _packedAddressData[owner];
1109         uint256 auxCasted;
1110         // Cast `aux` with assembly to avoid redundant masking.
1111         assembly {
1112             auxCasted := aux
1113         }
1114         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1115         _packedAddressData[owner] = packed;
1116     }
1117 
1118     // =============================================================
1119     //                            IERC165
1120     // =============================================================
1121 
1122     /**
1123      * @dev Returns true if this contract implements the interface defined by
1124      * `interfaceId`. See the corresponding
1125      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1126      * to learn more about how these ids are created.
1127      *
1128      * This function call must use less than 30000 gas.
1129      */
1130     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1131         // The interface IDs are constants representing the first 4 bytes
1132         // of the XOR of all function selectors in the interface.
1133         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1134         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1135         return
1136             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1137             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1138             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1139     }
1140 
1141     // =============================================================
1142     //                        IERC721Metadata
1143     // =============================================================
1144 
1145     /**
1146      * @dev Returns the token collection name.
1147      */
1148     function name() public view virtual override returns (string memory) {
1149         return _name;
1150     }
1151 
1152     /**
1153      * @dev Returns the token collection symbol.
1154      */
1155     function symbol() public view virtual override returns (string memory) {
1156         return _symbol;
1157     }
1158 
1159     /**
1160      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1161      */
1162     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1163         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1164 
1165         string memory baseURI = _baseURI();
1166         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1167     }
1168 
1169     /**
1170      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1171      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1172      * by default, it can be overridden in child contracts.
1173      */
1174     function _baseURI() internal view virtual returns (string memory) {
1175         return '';
1176     }
1177 
1178     // =============================================================
1179     //                     OWNERSHIPS OPERATIONS
1180     // =============================================================
1181 
1182     /**
1183      * @dev Returns the owner of the `tokenId` token.
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must exist.
1188      */
1189     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1190         return address(uint160(_packedOwnershipOf(tokenId)));
1191     }
1192 
1193     /**
1194      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1195      * It gradually moves to O(1) as tokens get transferred around over time.
1196      */
1197     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1198         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1199     }
1200 
1201     /**
1202      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1203      */
1204     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1205         return _unpackedOwnership(_packedOwnerships[index]);
1206     }
1207 
1208     /**
1209      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1210      */
1211     function _initializeOwnershipAt(uint256 index) internal virtual {
1212         if (_packedOwnerships[index] == 0) {
1213             _packedOwnerships[index] = _packedOwnershipOf(index);
1214         }
1215     }
1216 
1217     /**
1218      * Returns the packed ownership data of `tokenId`.
1219      */
1220     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1221         uint256 curr = tokenId;
1222 
1223         unchecked {
1224             if (_startTokenId() <= curr)
1225                 if (curr < _currentIndex) {
1226                     uint256 packed = _packedOwnerships[curr];
1227                     // If not burned.
1228                     if (packed & _BITMASK_BURNED == 0) {
1229                         // Invariant:
1230                         // There will always be an initialized ownership slot
1231                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1232                         // before an unintialized ownership slot
1233                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1234                         // Hence, `curr` will not underflow.
1235                         //
1236                         // We can directly compare the packed value.
1237                         // If the address is zero, packed will be zero.
1238                         while (packed == 0) {
1239                             packed = _packedOwnerships[--curr];
1240                         }
1241                         return packed;
1242                     }
1243                 }
1244         }
1245         revert OwnerQueryForNonexistentToken();
1246     }
1247 
1248     /**
1249      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1250      */
1251     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1252         ownership.addr = address(uint160(packed));
1253         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1254         ownership.burned = packed & _BITMASK_BURNED != 0;
1255         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1256     }
1257 
1258     /**
1259      * @dev Packs ownership data into a single uint256.
1260      */
1261     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1262         assembly {
1263             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1264             owner := and(owner, _BITMASK_ADDRESS)
1265             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1266             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1267         }
1268     }
1269 
1270     /**
1271      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1272      */
1273     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1274         // For branchless setting of the `nextInitialized` flag.
1275         assembly {
1276             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1277             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1278         }
1279     }
1280 
1281     // =============================================================
1282     //                      APPROVAL OPERATIONS
1283     // =============================================================
1284 
1285     /**
1286      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1287      * The approval is cleared when the token is transferred.
1288      *
1289      * Only a single account can be approved at a time, so approving the
1290      * zero address clears previous approvals.
1291      *
1292      * Requirements:
1293      *
1294      * - The caller must own the token or be an approved operator.
1295      * - `tokenId` must exist.
1296      *
1297      * Emits an {Approval} event.
1298      */
1299     function approve(address to, uint256 tokenId) public payable virtual override {
1300         address owner = ownerOf(tokenId);
1301 
1302         if (_msgSenderERC721A() != owner)
1303             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1304                 revert ApprovalCallerNotOwnerNorApproved();
1305             }
1306 
1307         _tokenApprovals[tokenId].value = to;
1308         emit Approval(owner, to, tokenId);
1309     }
1310 
1311     /**
1312      * @dev Returns the account approved for `tokenId` token.
1313      *
1314      * Requirements:
1315      *
1316      * - `tokenId` must exist.
1317      */
1318     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1319         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1320 
1321         return _tokenApprovals[tokenId].value;
1322     }
1323 
1324     /**
1325      * @dev Approve or remove `operator` as an operator for the caller.
1326      * Operators can call {transferFrom} or {safeTransferFrom}
1327      * for any token owned by the caller.
1328      *
1329      * Requirements:
1330      *
1331      * - The `operator` cannot be the caller.
1332      *
1333      * Emits an {ApprovalForAll} event.
1334      */
1335     function setApprovalForAll(address operator, bool approved) public virtual override {
1336         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1337         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1338     }
1339 
1340     /**
1341      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1342      *
1343      * See {setApprovalForAll}.
1344      */
1345     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1346         return _operatorApprovals[owner][operator];
1347     }
1348 
1349     /**
1350      * @dev Returns whether `tokenId` exists.
1351      *
1352      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1353      *
1354      * Tokens start existing when they are minted. See {_mint}.
1355      */
1356     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1357         return
1358             _startTokenId() <= tokenId &&
1359             tokenId < _currentIndex && // If within bounds,
1360             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1361     }
1362 
1363     /**
1364      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1365      */
1366     function _isSenderApprovedOrOwner(
1367         address approvedAddress,
1368         address owner,
1369         address msgSender
1370     ) private pure returns (bool result) {
1371         assembly {
1372             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1373             owner := and(owner, _BITMASK_ADDRESS)
1374             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1375             msgSender := and(msgSender, _BITMASK_ADDRESS)
1376             // `msgSender == owner || msgSender == approvedAddress`.
1377             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1378         }
1379     }
1380 
1381     /**
1382      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1383      */
1384     function _getApprovedSlotAndAddress(uint256 tokenId)
1385         private
1386         view
1387         returns (uint256 approvedAddressSlot, address approvedAddress)
1388     {
1389         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1390         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1391         assembly {
1392             approvedAddressSlot := tokenApproval.slot
1393             approvedAddress := sload(approvedAddressSlot)
1394         }
1395     }
1396 
1397     // =============================================================
1398     //                      TRANSFER OPERATIONS
1399     // =============================================================
1400 
1401     /**
1402      * @dev Transfers `tokenId` from `from` to `to`.
1403      *
1404      * Requirements:
1405      *
1406      * - `from` cannot be the zero address.
1407      * - `to` cannot be the zero address.
1408      * - `tokenId` token must be owned by `from`.
1409      * - If the caller is not `from`, it must be approved to move this token
1410      * by either {approve} or {setApprovalForAll}.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function transferFrom(
1415         address from,
1416         address to,
1417         uint256 tokenId
1418     ) public payable virtual override {
1419         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1420 
1421         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1422 
1423         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1424 
1425         // The nested ifs save around 20+ gas over a compound boolean condition.
1426         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1427             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1428 
1429         if (to == address(0)) revert TransferToZeroAddress();
1430 
1431         _beforeTokenTransfers(from, to, tokenId, 1);
1432 
1433         // Clear approvals from the previous owner.
1434         assembly {
1435             if approvedAddress {
1436                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1437                 sstore(approvedAddressSlot, 0)
1438             }
1439         }
1440 
1441         // Underflow of the sender's balance is impossible because we check for
1442         // ownership above and the recipient's balance can't realistically overflow.
1443         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1444         unchecked {
1445             // We can directly increment and decrement the balances.
1446             --_packedAddressData[from]; // Updates: `balance -= 1`.
1447             ++_packedAddressData[to]; // Updates: `balance += 1`.
1448 
1449             // Updates:
1450             // - `address` to the next owner.
1451             // - `startTimestamp` to the timestamp of transfering.
1452             // - `burned` to `false`.
1453             // - `nextInitialized` to `true`.
1454             _packedOwnerships[tokenId] = _packOwnershipData(
1455                 to,
1456                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1457             );
1458 
1459             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1460             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1461                 uint256 nextTokenId = tokenId + 1;
1462                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1463                 if (_packedOwnerships[nextTokenId] == 0) {
1464                     // If the next slot is within bounds.
1465                     if (nextTokenId != _currentIndex) {
1466                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1467                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1468                     }
1469                 }
1470             }
1471         }
1472 
1473         emit Transfer(from, to, tokenId);
1474         _afterTokenTransfers(from, to, tokenId, 1);
1475     }
1476 
1477     /**
1478      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1479      */
1480     function safeTransferFrom(
1481         address from,
1482         address to,
1483         uint256 tokenId
1484     ) public payable virtual override {
1485         safeTransferFrom(from, to, tokenId, '');
1486     }
1487 
1488     /**
1489      * @dev Safely transfers `tokenId` token from `from` to `to`.
1490      *
1491      * Requirements:
1492      *
1493      * - `from` cannot be the zero address.
1494      * - `to` cannot be the zero address.
1495      * - `tokenId` token must exist and be owned by `from`.
1496      * - If the caller is not `from`, it must be approved to move this token
1497      * by either {approve} or {setApprovalForAll}.
1498      * - If `to` refers to a smart contract, it must implement
1499      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1500      *
1501      * Emits a {Transfer} event.
1502      */
1503     function safeTransferFrom(
1504         address from,
1505         address to,
1506         uint256 tokenId,
1507         bytes memory _data
1508     ) public payable virtual override {
1509         transferFrom(from, to, tokenId);
1510         if (to.code.length != 0)
1511             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1512                 revert TransferToNonERC721ReceiverImplementer();
1513             }
1514     }
1515 
1516     /**
1517      * @dev Hook that is called before a set of serially-ordered token IDs
1518      * are about to be transferred. This includes minting.
1519      * And also called before burning one token.
1520      *
1521      * `startTokenId` - the first token ID to be transferred.
1522      * `quantity` - the amount to be transferred.
1523      *
1524      * Calling conditions:
1525      *
1526      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1527      * transferred to `to`.
1528      * - When `from` is zero, `tokenId` will be minted for `to`.
1529      * - When `to` is zero, `tokenId` will be burned by `from`.
1530      * - `from` and `to` are never both zero.
1531      */
1532     function _beforeTokenTransfers(
1533         address from,
1534         address to,
1535         uint256 startTokenId,
1536         uint256 quantity
1537     ) internal virtual {}
1538 
1539     /**
1540      * @dev Hook that is called after a set of serially-ordered token IDs
1541      * have been transferred. This includes minting.
1542      * And also called after one token has been burned.
1543      *
1544      * `startTokenId` - the first token ID to be transferred.
1545      * `quantity` - the amount to be transferred.
1546      *
1547      * Calling conditions:
1548      *
1549      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1550      * transferred to `to`.
1551      * - When `from` is zero, `tokenId` has been minted for `to`.
1552      * - When `to` is zero, `tokenId` has been burned by `from`.
1553      * - `from` and `to` are never both zero.
1554      */
1555     function _afterTokenTransfers(
1556         address from,
1557         address to,
1558         uint256 startTokenId,
1559         uint256 quantity
1560     ) internal virtual {}
1561 
1562     /**
1563      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1564      *
1565      * `from` - Previous owner of the given token ID.
1566      * `to` - Target address that will receive the token.
1567      * `tokenId` - Token ID to be transferred.
1568      * `_data` - Optional data to send along with the call.
1569      *
1570      * Returns whether the call correctly returned the expected magic value.
1571      */
1572     function _checkContractOnERC721Received(
1573         address from,
1574         address to,
1575         uint256 tokenId,
1576         bytes memory _data
1577     ) private returns (bool) {
1578         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1579             bytes4 retval
1580         ) {
1581             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1582         } catch (bytes memory reason) {
1583             if (reason.length == 0) {
1584                 revert TransferToNonERC721ReceiverImplementer();
1585             } else {
1586                 assembly {
1587                     revert(add(32, reason), mload(reason))
1588                 }
1589             }
1590         }
1591     }
1592 
1593     // =============================================================
1594     //                        MINT OPERATIONS
1595     // =============================================================
1596 
1597     /**
1598      * @dev Mints `quantity` tokens and transfers them to `to`.
1599      *
1600      * Requirements:
1601      *
1602      * - `to` cannot be the zero address.
1603      * - `quantity` must be greater than 0.
1604      *
1605      * Emits a {Transfer} event for each mint.
1606      */
1607     function _mint(address to, uint256 quantity) internal virtual {
1608         uint256 startTokenId = _currentIndex;
1609         if (quantity == 0) revert MintZeroQuantity();
1610 
1611         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1612 
1613         // Overflows are incredibly unrealistic.
1614         // `balance` and `numberMinted` have a maximum limit of 2**64.
1615         // `tokenId` has a maximum limit of 2**256.
1616         unchecked {
1617             // Updates:
1618             // - `balance += quantity`.
1619             // - `numberMinted += quantity`.
1620             //
1621             // We can directly add to the `balance` and `numberMinted`.
1622             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1623 
1624             // Updates:
1625             // - `address` to the owner.
1626             // - `startTimestamp` to the timestamp of minting.
1627             // - `burned` to `false`.
1628             // - `nextInitialized` to `quantity == 1`.
1629             _packedOwnerships[startTokenId] = _packOwnershipData(
1630                 to,
1631                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1632             );
1633 
1634             uint256 toMasked;
1635             uint256 end = startTokenId + quantity;
1636 
1637             // Use assembly to loop and emit the `Transfer` event for gas savings.
1638             // The duplicated `log4` removes an extra check and reduces stack juggling.
1639             // The assembly, together with the surrounding Solidity code, have been
1640             // delicately arranged to nudge the compiler into producing optimized opcodes.
1641             assembly {
1642                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1643                 toMasked := and(to, _BITMASK_ADDRESS)
1644                 // Emit the `Transfer` event.
1645                 log4(
1646                     0, // Start of data (0, since no data).
1647                     0, // End of data (0, since no data).
1648                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1649                     0, // `address(0)`.
1650                     toMasked, // `to`.
1651                     startTokenId // `tokenId`.
1652                 )
1653 
1654                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1655                 // that overflows uint256 will make the loop run out of gas.
1656                 // The compiler will optimize the `iszero` away for performance.
1657                 for {
1658                     let tokenId := add(startTokenId, 1)
1659                 } iszero(eq(tokenId, end)) {
1660                     tokenId := add(tokenId, 1)
1661                 } {
1662                     // Emit the `Transfer` event. Similar to above.
1663                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1664                 }
1665             }
1666             if (toMasked == 0) revert MintToZeroAddress();
1667 
1668             _currentIndex = end;
1669         }
1670         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1671     }
1672 
1673     /**
1674      * @dev Mints `quantity` tokens and transfers them to `to`.
1675      *
1676      * This function is intended for efficient minting only during contract creation.
1677      *
1678      * It emits only one {ConsecutiveTransfer} as defined in
1679      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1680      * instead of a sequence of {Transfer} event(s).
1681      *
1682      * Calling this function outside of contract creation WILL make your contract
1683      * non-compliant with the ERC721 standard.
1684      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1685      * {ConsecutiveTransfer} event is only permissible during contract creation.
1686      *
1687      * Requirements:
1688      *
1689      * - `to` cannot be the zero address.
1690      * - `quantity` must be greater than 0.
1691      *
1692      * Emits a {ConsecutiveTransfer} event.
1693      */
1694     function _mintERC2309(address to, uint256 quantity) internal virtual {
1695         uint256 startTokenId = _currentIndex;
1696         if (to == address(0)) revert MintToZeroAddress();
1697         if (quantity == 0) revert MintZeroQuantity();
1698         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1699 
1700         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1701 
1702         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1703         unchecked {
1704             // Updates:
1705             // - `balance += quantity`.
1706             // - `numberMinted += quantity`.
1707             //
1708             // We can directly add to the `balance` and `numberMinted`.
1709             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1710 
1711             // Updates:
1712             // - `address` to the owner.
1713             // - `startTimestamp` to the timestamp of minting.
1714             // - `burned` to `false`.
1715             // - `nextInitialized` to `quantity == 1`.
1716             _packedOwnerships[startTokenId] = _packOwnershipData(
1717                 to,
1718                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1719             );
1720 
1721             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1722 
1723             _currentIndex = startTokenId + quantity;
1724         }
1725         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1726     }
1727 
1728     /**
1729      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1730      *
1731      * Requirements:
1732      *
1733      * - If `to` refers to a smart contract, it must implement
1734      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1735      * - `quantity` must be greater than 0.
1736      *
1737      * See {_mint}.
1738      *
1739      * Emits a {Transfer} event for each mint.
1740      */
1741     function _safeMint(
1742         address to,
1743         uint256 quantity,
1744         bytes memory _data
1745     ) internal virtual {
1746         _mint(to, quantity);
1747 
1748         unchecked {
1749             if (to.code.length != 0) {
1750                 uint256 end = _currentIndex;
1751                 uint256 index = end - quantity;
1752                 do {
1753                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1754                         revert TransferToNonERC721ReceiverImplementer();
1755                     }
1756                 } while (index < end);
1757                 // Reentrancy protection.
1758                 if (_currentIndex != end) revert();
1759             }
1760         }
1761     }
1762 
1763     /**
1764      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1765      */
1766     function _safeMint(address to, uint256 quantity) internal virtual {
1767         _safeMint(to, quantity, '');
1768     }
1769 
1770     // =============================================================
1771     //                        BURN OPERATIONS
1772     // =============================================================
1773 
1774     /**
1775      * @dev Equivalent to `_burn(tokenId, false)`.
1776      */
1777     function _burn(uint256 tokenId) internal virtual {
1778         _burn(tokenId, false);
1779     }
1780 
1781     /**
1782      * @dev Destroys `tokenId`.
1783      * The approval is cleared when the token is burned.
1784      *
1785      * Requirements:
1786      *
1787      * - `tokenId` must exist.
1788      *
1789      * Emits a {Transfer} event.
1790      */
1791     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1792         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1793 
1794         address from = address(uint160(prevOwnershipPacked));
1795 
1796         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1797 
1798         if (approvalCheck) {
1799             // The nested ifs save around 20+ gas over a compound boolean condition.
1800             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1801                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1802         }
1803 
1804         _beforeTokenTransfers(from, address(0), tokenId, 1);
1805 
1806         // Clear approvals from the previous owner.
1807         assembly {
1808             if approvedAddress {
1809                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1810                 sstore(approvedAddressSlot, 0)
1811             }
1812         }
1813 
1814         // Underflow of the sender's balance is impossible because we check for
1815         // ownership above and the recipient's balance can't realistically overflow.
1816         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1817         unchecked {
1818             // Updates:
1819             // - `balance -= 1`.
1820             // - `numberBurned += 1`.
1821             //
1822             // We can directly decrement the balance, and increment the number burned.
1823             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1824             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1825 
1826             // Updates:
1827             // - `address` to the last owner.
1828             // - `startTimestamp` to the timestamp of burning.
1829             // - `burned` to `true`.
1830             // - `nextInitialized` to `true`.
1831             _packedOwnerships[tokenId] = _packOwnershipData(
1832                 from,
1833                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1834             );
1835 
1836             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1837             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1838                 uint256 nextTokenId = tokenId + 1;
1839                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1840                 if (_packedOwnerships[nextTokenId] == 0) {
1841                     // If the next slot is within bounds.
1842                     if (nextTokenId != _currentIndex) {
1843                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1844                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1845                     }
1846                 }
1847             }
1848         }
1849 
1850         emit Transfer(from, address(0), tokenId);
1851         _afterTokenTransfers(from, address(0), tokenId, 1);
1852 
1853         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1854         unchecked {
1855             _burnCounter++;
1856         }
1857     }
1858 
1859     // =============================================================
1860     //                     EXTRA DATA OPERATIONS
1861     // =============================================================
1862 
1863     /**
1864      * @dev Directly sets the extra data for the ownership data `index`.
1865      */
1866     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1867         uint256 packed = _packedOwnerships[index];
1868         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1869         uint256 extraDataCasted;
1870         // Cast `extraData` with assembly to avoid redundant masking.
1871         assembly {
1872             extraDataCasted := extraData
1873         }
1874         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1875         _packedOwnerships[index] = packed;
1876     }
1877 
1878     /**
1879      * @dev Called during each token transfer to set the 24bit `extraData` field.
1880      * Intended to be overridden by the cosumer contract.
1881      *
1882      * `previousExtraData` - the value of `extraData` before transfer.
1883      *
1884      * Calling conditions:
1885      *
1886      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1887      * transferred to `to`.
1888      * - When `from` is zero, `tokenId` will be minted for `to`.
1889      * - When `to` is zero, `tokenId` will be burned by `from`.
1890      * - `from` and `to` are never both zero.
1891      */
1892     function _extraData(
1893         address from,
1894         address to,
1895         uint24 previousExtraData
1896     ) internal view virtual returns (uint24) {}
1897 
1898     /**
1899      * @dev Returns the next extra data for the packed ownership data.
1900      * The returned result is shifted into position.
1901      */
1902     function _nextExtraData(
1903         address from,
1904         address to,
1905         uint256 prevOwnershipPacked
1906     ) private view returns (uint256) {
1907         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1908         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1909     }
1910 
1911     // =============================================================
1912     //                       OTHER OPERATIONS
1913     // =============================================================
1914 
1915     /**
1916      * @dev Returns the message sender (defaults to `msg.sender`).
1917      *
1918      * If you are writing GSN compatible contracts, you need to override this function.
1919      */
1920     function _msgSenderERC721A() internal view virtual returns (address) {
1921         return msg.sender;
1922     }
1923 
1924     /**
1925      * @dev Converts a uint256 to its ASCII string decimal representation.
1926      */
1927     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1928         assembly {
1929             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1930             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1931             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1932             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1933             let m := add(mload(0x40), 0xa0)
1934             // Update the free memory pointer to allocate.
1935             mstore(0x40, m)
1936             // Assign the `str` to the end.
1937             str := sub(m, 0x20)
1938             // Zeroize the slot after the string.
1939             mstore(str, 0)
1940 
1941             // Cache the end of the memory to calculate the length later.
1942             let end := str
1943 
1944             // We write the string from rightmost digit to leftmost digit.
1945             // The following is essentially a do-while loop that also handles the zero case.
1946             // prettier-ignore
1947             for { let temp := value } 1 {} {
1948                 str := sub(str, 1)
1949                 // Write the character to the pointer.
1950                 // The ASCII index of the '0' character is 48.
1951                 mstore8(str, add(48, mod(temp, 10)))
1952                 // Keep dividing `temp` until zero.
1953                 temp := div(temp, 10)
1954                 // prettier-ignore
1955                 if iszero(temp) { break }
1956             }
1957 
1958             let length := sub(end, str)
1959             // Move the pointer 32 bytes leftwards to make room for the length.
1960             str := sub(str, 0x20)
1961             // Store the length.
1962             mstore(str, length)
1963         }
1964     }
1965 }
1966 
1967 // File: contracts/SCENES.sol
1968 
1969 
1970 
1971 
1972 
1973 
1974 
1975 
1976 
1977 
1978 
1979 pragma solidity ^0.8.7;
1980 
1981 contract SCENES is ERC721A, Ownable, ReentrancyGuard {
1982   using Address for address;
1983   using Strings for uint;
1984 
1985   string  public  baseTokenURI = "";
1986   uint256  public  Max_Supply = 3333;
1987   uint256 public  Max_Per_TX = 10;
1988   uint256 public  Price = 0.001 ether;
1989   uint256 public  Num_Free_Mints = 888;
1990   uint256 public  Max_Free_Per_Wallet = 1;
1991   bool public isMintActive = true;
1992 
1993   constructor(
1994 
1995   ) ERC721A("SCENES I The Mystery of Minamata", "SIMM") {
1996 
1997   }
1998 
1999   function mint(uint256 numberOfTokens)
2000       external
2001       payable
2002   {
2003     require(isMintActive, "Mint not active yet");
2004     require(totalSupply() + numberOfTokens < Max_Supply + 1, "No more");
2005 
2006     if(totalSupply() > Num_Free_Mints){
2007         require(
2008             (Price * numberOfTokens) <= msg.value,
2009             "Incorrect ETH value sent"
2010         );
2011     } else {
2012         if (numberOfTokens > Max_Free_Per_Wallet) {
2013         require(
2014             (Price * numberOfTokens) <= msg.value,
2015             "Incorrect ETH value sent"
2016         );
2017         require(
2018             numberOfTokens <= Max_Per_TX,
2019             "Max mints per transaction exceeded"
2020         );
2021         } else {
2022             require(
2023                 numberOfTokens <= Max_Free_Per_Wallet,
2024                 "Max mints per transaction exceeded"
2025             );
2026         }
2027     }
2028     _safeMint(msg.sender, numberOfTokens);
2029   }
2030 
2031   function setBaseURI(string memory baseURI)
2032     public
2033     onlyOwner
2034   {
2035     baseTokenURI = baseURI;
2036   }
2037 
2038   function _startTokenId() internal override view virtual returns (uint256) {
2039     return 1;
2040   }
2041 
2042   function mintTo(uint256 numberOfTokens, address _receiver)
2043     public
2044     onlyOwner
2045   {
2046     _safeMint(_receiver, numberOfTokens);
2047   }
2048 
2049   function treasuryMint(uint quantity)
2050     public
2051     onlyOwner
2052   {
2053     require(
2054       quantity > 0,
2055       "Invalid mint amount"
2056     );
2057     require(
2058       totalSupply() + quantity <= Max_Supply,
2059       "Maximum supply exceeded"
2060     );
2061     _safeMint(msg.sender, quantity);
2062   }
2063 
2064   function withdraw()
2065     public
2066     onlyOwner
2067     nonReentrant
2068   {
2069     Address.sendValue(payable(msg.sender), address(this).balance);
2070   }
2071 
2072   function tokenURI(uint _tokenId)
2073     public
2074     view
2075     virtual
2076     override
2077     returns (string memory)
2078   {
2079     require(
2080       _exists(_tokenId),
2081       "ERC721Metadata: URI query for nonexistent token"
2082     );
2083     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
2084   }
2085 
2086   function _baseURI()
2087     internal
2088     view
2089     virtual
2090     override
2091     returns (string memory)
2092   {
2093     return baseTokenURI;
2094   }
2095 
2096   function setIsMintActive(bool _isMintActive)
2097       external
2098       onlyOwner
2099   {
2100       isMintActive = _isMintActive;
2101   }
2102 
2103   function setNumFreeMints(uint256 _numfreemints)
2104       external
2105       onlyOwner
2106   {
2107       Num_Free_Mints = _numfreemints;
2108   }
2109 
2110   function setMaxSupply(uint256 _Max_Supply)
2111       external
2112       onlyOwner
2113   {
2114       Max_Supply = _Max_Supply;
2115   }
2116 
2117   function setSalePrice(uint256 _Price)
2118       external
2119       onlyOwner
2120   {
2121       Price = _Price;
2122   }
2123 
2124   function setMaxLimitPerTransaction(uint256 _limit)
2125       external
2126       onlyOwner
2127   {
2128       Max_Per_TX = _limit;
2129   }
2130 
2131   function setFreeLimitPerWallet(uint256 _limit)
2132       external
2133       onlyOwner
2134   {
2135       Max_Free_Per_Wallet = _limit;
2136   }
2137 }