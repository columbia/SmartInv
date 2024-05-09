1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Contract module that helps prevent reentrant calls to a function.
305  *
306  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
307  * available, which can be applied to functions to make sure there are no nested
308  * (reentrant) calls to them.
309  *
310  * Note that because there is a single `nonReentrant` guard, functions marked as
311  * `nonReentrant` may not call one another. This can be worked around by making
312  * those functions `private`, and then adding `external` `nonReentrant` entry
313  * points to them.
314  *
315  * TIP: If you would like to learn more about reentrancy and alternative ways
316  * to protect against it, check out our blog post
317  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
318  */
319 abstract contract ReentrancyGuard {
320     // Booleans are more expensive than uint256 or any type that takes up a full
321     // word because each write operation emits an extra SLOAD to first read the
322     // slot's contents, replace the bits taken up by the boolean, and then write
323     // back. This is the compiler's defense against contract upgrades and
324     // pointer aliasing, and it cannot be disabled.
325 
326     // The values being non-zero value makes deployment a bit more expensive,
327     // but in exchange the refund on every call to nonReentrant will be lower in
328     // amount. Since refunds are capped to a percentage of the total
329     // transaction's gas, it is best to keep them low in cases like this one, to
330     // increase the likelihood of the full refund coming into effect.
331     uint256 private constant _NOT_ENTERED = 1;
332     uint256 private constant _ENTERED = 2;
333 
334     uint256 private _status;
335 
336     constructor() {
337         _status = _NOT_ENTERED;
338     }
339 
340     /**
341      * @dev Prevents a contract from calling itself, directly or indirectly.
342      * Calling a `nonReentrant` function from another `nonReentrant`
343      * function is not supported. It is possible to prevent this from happening
344      * by making the `nonReentrant` function external, and making it call a
345      * `private` function that does the actual work.
346      */
347     modifier nonReentrant() {
348         // On the first call to nonReentrant, _notEntered will be true
349         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
350 
351         // Any calls to nonReentrant after this point will fail
352         _status = _ENTERED;
353 
354         _;
355 
356         // By storing the original value once again, a refund is triggered (see
357         // https://eips.ethereum.org/EIPS/eip-2200)
358         _status = _NOT_ENTERED;
359     }
360 }
361 
362 // File: @openzeppelin/contracts/utils/Context.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Provides information about the current execution context, including the
371  * sender of the transaction and its data. While these are generally available
372  * via msg.sender and msg.data, they should not be accessed in such a direct
373  * manner, since when dealing with meta-transactions the account sending and
374  * paying for execution may not be the actual sender (as far as an application
375  * is concerned).
376  *
377  * This contract is only required for intermediate, library-like contracts.
378  */
379 abstract contract Context {
380     function _msgSender() internal view virtual returns (address) {
381         return msg.sender;
382     }
383 
384     function _msgData() internal view virtual returns (bytes calldata) {
385         return msg.data;
386     }
387 }
388 
389 // File: @openzeppelin/contracts/security/Pausable.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Contract module which allows children to implement an emergency stop
399  * mechanism that can be triggered by an authorized account.
400  *
401  * This module is used through inheritance. It will make available the
402  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
403  * the functions of your contract. Note that they will not be pausable by
404  * simply including this module, only once the modifiers are put in place.
405  */
406 abstract contract Pausable is Context {
407     /**
408      * @dev Emitted when the pause is triggered by `account`.
409      */
410     event Paused(address account);
411 
412     /**
413      * @dev Emitted when the pause is lifted by `account`.
414      */
415     event Unpaused(address account);
416 
417     bool private _paused;
418 
419     /**
420      * @dev Initializes the contract in unpaused state.
421      */
422     constructor() {
423         _paused = false;
424     }
425 
426     /**
427      * @dev Returns true if the contract is paused, and false otherwise.
428      */
429     function paused() public view virtual returns (bool) {
430         return _paused;
431     }
432 
433     /**
434      * @dev Modifier to make a function callable only when the contract is not paused.
435      *
436      * Requirements:
437      *
438      * - The contract must not be paused.
439      */
440     modifier whenNotPaused() {
441         require(!paused(), "Pausable: paused");
442         _;
443     }
444 
445     /**
446      * @dev Modifier to make a function callable only when the contract is paused.
447      *
448      * Requirements:
449      *
450      * - The contract must be paused.
451      */
452     modifier whenPaused() {
453         require(paused(), "Pausable: not paused");
454         _;
455     }
456 
457     /**
458      * @dev Triggers stopped state.
459      *
460      * Requirements:
461      *
462      * - The contract must not be paused.
463      */
464     function _pause() internal virtual whenNotPaused {
465         _paused = true;
466         emit Paused(_msgSender());
467     }
468 
469     /**
470      * @dev Returns to normal state.
471      *
472      * Requirements:
473      *
474      * - The contract must be paused.
475      */
476     function _unpause() internal virtual whenPaused {
477         _paused = false;
478         emit Unpaused(_msgSender());
479     }
480 }
481 
482 // File: @openzeppelin/contracts/access/Ownable.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 
490 /**
491  * @dev Contract module which provides a basic access control mechanism, where
492  * there is an account (an owner) that can be granted exclusive access to
493  * specific functions.
494  *
495  * By default, the owner account will be the one that deploys the contract. This
496  * can later be changed with {transferOwnership}.
497  *
498  * This module is used through inheritance. It will make available the modifier
499  * `onlyOwner`, which can be applied to your functions to restrict their use to
500  * the owner.
501  */
502 abstract contract Ownable is Context {
503     address private _owner;
504 
505     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
506 
507     /**
508      * @dev Initializes the contract setting the deployer as the initial owner.
509      */
510     constructor() {
511         _transferOwnership(_msgSender());
512     }
513 
514     /**
515      * @dev Returns the address of the current owner.
516      */
517     function owner() public view virtual returns (address) {
518         return _owner;
519     }
520 
521     /**
522      * @dev Throws if called by any account other than the owner.
523      */
524     modifier onlyOwner() {
525         require(owner() == _msgSender(), "Ownable: caller is not the owner");
526         _;
527     }
528 
529     /**
530      * @dev Leaves the contract without owner. It will not be possible to call
531      * `onlyOwner` functions anymore. Can only be called by the current owner.
532      *
533      * NOTE: Renouncing ownership will leave the contract without an owner,
534      * thereby removing any functionality that is only available to the owner.
535      */
536     function renounceOwnership() public virtual onlyOwner {
537         _transferOwnership(address(0));
538     }
539 
540     /**
541      * @dev Transfers ownership of the contract to a new account (`newOwner`).
542      * Can only be called by the current owner.
543      */
544     function transferOwnership(address newOwner) public virtual onlyOwner {
545         require(newOwner != address(0), "Ownable: new owner is the zero address");
546         _transferOwnership(newOwner);
547     }
548 
549     /**
550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
551      * Internal function without access restriction.
552      */
553     function _transferOwnership(address newOwner) internal virtual {
554         address oldOwner = _owner;
555         _owner = newOwner;
556         emit OwnershipTransferred(oldOwner, newOwner);
557     }
558 }
559 
560 // File: erc721a/contracts/IERC721A.sol
561 
562 
563 // ERC721A Contracts v4.0.0
564 // Creator: Chiru Labs
565 
566 pragma solidity ^0.8.4;
567 
568 /**
569  * @dev Interface of an ERC721A compliant contract.
570  */
571 interface IERC721A {
572     /**
573      * The caller must own the token or be an approved operator.
574      */
575     error ApprovalCallerNotOwnerNorApproved();
576 
577     /**
578      * The token does not exist.
579      */
580     error ApprovalQueryForNonexistentToken();
581 
582     /**
583      * The caller cannot approve to their own address.
584      */
585     error ApproveToCaller();
586 
587     /**
588      * The caller cannot approve to the current owner.
589      */
590     error ApprovalToCurrentOwner();
591 
592     /**
593      * Cannot query the balance for the zero address.
594      */
595     error BalanceQueryForZeroAddress();
596 
597     /**
598      * Cannot mint to the zero address.
599      */
600     error MintToZeroAddress();
601 
602     /**
603      * The quantity of tokens minted must be more than zero.
604      */
605     error MintZeroQuantity();
606 
607     /**
608      * The token does not exist.
609      */
610     error OwnerQueryForNonexistentToken();
611 
612     /**
613      * The caller must own the token or be an approved operator.
614      */
615     error TransferCallerNotOwnerNorApproved();
616 
617     /**
618      * The token must be owned by `from`.
619      */
620     error TransferFromIncorrectOwner();
621 
622     /**
623      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
624      */
625     error TransferToNonERC721ReceiverImplementer();
626 
627     /**
628      * Cannot transfer to the zero address.
629      */
630     error TransferToZeroAddress();
631 
632     /**
633      * The token does not exist.
634      */
635     error URIQueryForNonexistentToken();
636 
637     struct TokenOwnership {
638         // The address of the owner.
639         address addr;
640         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
641         uint64 startTimestamp;
642         // Whether the token has been burned.
643         bool burned;
644     }
645 
646     /**
647      * @dev Returns the total amount of tokens stored by the contract.
648      *
649      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
650      */
651     function totalSupply() external view returns (uint256);
652 
653     // ==============================
654     //            IERC165
655     // ==============================
656 
657     /**
658      * @dev Returns true if this contract implements the interface defined by
659      * `interfaceId`. See the corresponding
660      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
661      * to learn more about how these ids are created.
662      *
663      * This function call must use less than 30 000 gas.
664      */
665     function supportsInterface(bytes4 interfaceId) external view returns (bool);
666 
667     // ==============================
668     //            IERC721
669     // ==============================
670 
671     /**
672      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
673      */
674     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
675 
676     /**
677      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
678      */
679     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
680 
681     /**
682      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
683      */
684     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
685 
686     /**
687      * @dev Returns the number of tokens in ``owner``'s account.
688      */
689     function balanceOf(address owner) external view returns (uint256 balance);
690 
691     /**
692      * @dev Returns the owner of the `tokenId` token.
693      *
694      * Requirements:
695      *
696      * - `tokenId` must exist.
697      */
698     function ownerOf(uint256 tokenId) external view returns (address owner);
699 
700     /**
701      * @dev Safely transfers `tokenId` token from `from` to `to`.
702      *
703      * Requirements:
704      *
705      * - `from` cannot be the zero address.
706      * - `to` cannot be the zero address.
707      * - `tokenId` token must exist and be owned by `from`.
708      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
709      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
710      *
711      * Emits a {Transfer} event.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId,
717         bytes calldata data
718     ) external;
719 
720     /**
721      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
722      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
723      *
724      * Requirements:
725      *
726      * - `from` cannot be the zero address.
727      * - `to` cannot be the zero address.
728      * - `tokenId` token must exist and be owned by `from`.
729      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
730      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
731      *
732      * Emits a {Transfer} event.
733      */
734     function safeTransferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) external;
739 
740     /**
741      * @dev Transfers `tokenId` token from `from` to `to`.
742      *
743      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must be owned by `from`.
750      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
751      *
752      * Emits a {Transfer} event.
753      */
754     function transferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) external;
759 
760     /**
761      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
762      * The approval is cleared when the token is transferred.
763      *
764      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
765      *
766      * Requirements:
767      *
768      * - The caller must own the token or be an approved operator.
769      * - `tokenId` must exist.
770      *
771      * Emits an {Approval} event.
772      */
773     function approve(address to, uint256 tokenId) external;
774 
775     /**
776      * @dev Approve or remove `operator` as an operator for the caller.
777      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
778      *
779      * Requirements:
780      *
781      * - The `operator` cannot be the caller.
782      *
783      * Emits an {ApprovalForAll} event.
784      */
785     function setApprovalForAll(address operator, bool _approved) external;
786 
787     /**
788      * @dev Returns the account approved for `tokenId` token.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must exist.
793      */
794     function getApproved(uint256 tokenId) external view returns (address operator);
795 
796     /**
797      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
798      *
799      * See {setApprovalForAll}
800      */
801     function isApprovedForAll(address owner, address operator) external view returns (bool);
802 
803     // ==============================
804     //        IERC721Metadata
805     // ==============================
806 
807     /**
808      * @dev Returns the token collection name.
809      */
810     function name() external view returns (string memory);
811 
812     /**
813      * @dev Returns the token collection symbol.
814      */
815     function symbol() external view returns (string memory);
816 
817     /**
818      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
819      */
820     function tokenURI(uint256 tokenId) external view returns (string memory);
821 }
822 
823 // File: erc721a/contracts/ERC721A.sol
824 
825 
826 // ERC721A Contracts v4.0.0
827 // Creator: Chiru Labs
828 
829 pragma solidity ^0.8.4;
830 
831 
832 /**
833  * @dev ERC721 token receiver interface.
834  */
835 interface ERC721A__IERC721Receiver {
836     function onERC721Received(
837         address operator,
838         address from,
839         uint256 tokenId,
840         bytes calldata data
841     ) external returns (bytes4);
842 }
843 
844 /**
845  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
846  * the Metadata extension. Built to optimize for lower gas during batch mints.
847  *
848  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
849  *
850  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
851  *
852  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
853  */
854 contract ERC721A is IERC721A {
855     // Mask of an entry in packed address data.
856     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
857 
858     // The bit position of `numberMinted` in packed address data.
859     uint256 private constant BITPOS_NUMBER_MINTED = 64;
860 
861     // The bit position of `numberBurned` in packed address data.
862     uint256 private constant BITPOS_NUMBER_BURNED = 128;
863 
864     // The bit position of `aux` in packed address data.
865     uint256 private constant BITPOS_AUX = 192;
866 
867     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
868     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
869 
870     // The bit position of `startTimestamp` in packed ownership.
871     uint256 private constant BITPOS_START_TIMESTAMP = 160;
872 
873     // The bit mask of the `burned` bit in packed ownership.
874     uint256 private constant BITMASK_BURNED = 1 << 224;
875     
876     // The bit position of the `nextInitialized` bit in packed ownership.
877     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
878 
879     // The bit mask of the `nextInitialized` bit in packed ownership.
880     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
881 
882     // The tokenId of the next token to be minted.
883     uint256 private _currentIndex;
884 
885     // The number of tokens burned.
886     uint256 private _burnCounter;
887 
888     // Token name
889     string private _name;
890 
891     // Token symbol
892     string private _symbol;
893 
894     // Mapping from token ID to ownership details
895     // An empty struct value does not necessarily mean the token is unowned.
896     // See `_packedOwnershipOf` implementation for details.
897     //
898     // Bits Layout:
899     // - [0..159]   `addr`
900     // - [160..223] `startTimestamp`
901     // - [224]      `burned`
902     // - [225]      `nextInitialized`
903     mapping(uint256 => uint256) private _packedOwnerships;
904 
905     // Mapping owner address to address data.
906     //
907     // Bits Layout:
908     // - [0..63]    `balance`
909     // - [64..127]  `numberMinted`
910     // - [128..191] `numberBurned`
911     // - [192..255] `aux`
912     mapping(address => uint256) private _packedAddressData;
913 
914     // Mapping from token ID to approved address.
915     mapping(uint256 => address) private _tokenApprovals;
916 
917     // Mapping from owner to operator approvals
918     mapping(address => mapping(address => bool)) private _operatorApprovals;
919 
920     constructor(string memory name_, string memory symbol_) {
921         _name = name_;
922         _symbol = symbol_;
923         _currentIndex = _startTokenId();
924     }
925 
926     /**
927      * @dev Returns the starting token ID. 
928      * To change the starting token ID, please override this function.
929      */
930     function _startTokenId() internal view virtual returns (uint256) {
931         return 0;
932     }
933 
934     /**
935      * @dev Returns the next token ID to be minted.
936      */
937     function _nextTokenId() internal view returns (uint256) {
938         return _currentIndex;
939     }
940 
941     /**
942      * @dev Returns the total number of tokens in existence.
943      * Burned tokens will reduce the count. 
944      * To get the total number of tokens minted, please see `_totalMinted`.
945      */
946     function totalSupply() public view override returns (uint256) {
947         // Counter underflow is impossible as _burnCounter cannot be incremented
948         // more than `_currentIndex - _startTokenId()` times.
949         unchecked {
950             return _currentIndex - _burnCounter - _startTokenId();
951         }
952     }
953 
954     /**
955      * @dev Returns the total amount of tokens minted in the contract.
956      */
957     function _totalMinted() internal view returns (uint256) {
958         // Counter underflow is impossible as _currentIndex does not decrement,
959         // and it is initialized to `_startTokenId()`
960         unchecked {
961             return _currentIndex - _startTokenId();
962         }
963     }
964 
965     /**
966      * @dev Returns the total number of tokens burned.
967      */
968     function _totalBurned() internal view returns (uint256) {
969         return _burnCounter;
970     }
971 
972     /**
973      * @dev See {IERC165-supportsInterface}.
974      */
975     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
976         // The interface IDs are constants representing the first 4 bytes of the XOR of
977         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
978         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
979         return
980             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
981             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
982             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
983     }
984 
985     /**
986      * @dev See {IERC721-balanceOf}.
987      */
988     function balanceOf(address owner) public view override returns (uint256) {
989         if (owner == address(0)) revert BalanceQueryForZeroAddress();
990         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
991     }
992 
993     /**
994      * Returns the number of tokens minted by `owner`.
995      */
996     function _numberMinted(address owner) internal view returns (uint256) {
997         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
998     }
999 
1000     /**
1001      * Returns the number of tokens burned by or on behalf of `owner`.
1002      */
1003     function _numberBurned(address owner) internal view returns (uint256) {
1004         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1005     }
1006 
1007     /**
1008      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1009      */
1010     function _getAux(address owner) internal view returns (uint64) {
1011         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1012     }
1013 
1014     /**
1015      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1016      * If there are multiple variables, please pack them into a uint64.
1017      */
1018     function _setAux(address owner, uint64 aux) internal {
1019         uint256 packed = _packedAddressData[owner];
1020         uint256 auxCasted;
1021         assembly { // Cast aux without masking.
1022             auxCasted := aux
1023         }
1024         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1025         _packedAddressData[owner] = packed;
1026     }
1027 
1028     /**
1029      * Returns the packed ownership data of `tokenId`.
1030      */
1031     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1032         uint256 curr = tokenId;
1033 
1034         unchecked {
1035             if (_startTokenId() <= curr)
1036                 if (curr < _currentIndex) {
1037                     uint256 packed = _packedOwnerships[curr];
1038                     // If not burned.
1039                     if (packed & BITMASK_BURNED == 0) {
1040                         // Invariant:
1041                         // There will always be an ownership that has an address and is not burned
1042                         // before an ownership that does not have an address and is not burned.
1043                         // Hence, curr will not underflow.
1044                         //
1045                         // We can directly compare the packed value.
1046                         // If the address is zero, packed is zero.
1047                         while (packed == 0) {
1048                             packed = _packedOwnerships[--curr];
1049                         }
1050                         return packed;
1051                     }
1052                 }
1053         }
1054         revert OwnerQueryForNonexistentToken();
1055     }
1056 
1057     /**
1058      * Returns the unpacked `TokenOwnership` struct from `packed`.
1059      */
1060     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1061         ownership.addr = address(uint160(packed));
1062         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1063         ownership.burned = packed & BITMASK_BURNED != 0;
1064     }
1065 
1066     /**
1067      * Returns the unpacked `TokenOwnership` struct at `index`.
1068      */
1069     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1070         return _unpackedOwnership(_packedOwnerships[index]);
1071     }
1072 
1073     /**
1074      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1075      */
1076     function _initializeOwnershipAt(uint256 index) internal {
1077         if (_packedOwnerships[index] == 0) {
1078             _packedOwnerships[index] = _packedOwnershipOf(index);
1079         }
1080     }
1081 
1082     /**
1083      * Gas spent here starts off proportional to the maximum mint batch size.
1084      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1085      */
1086     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1087         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-ownerOf}.
1092      */
1093     function ownerOf(uint256 tokenId) public view override returns (address) {
1094         return address(uint160(_packedOwnershipOf(tokenId)));
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Metadata-name}.
1099      */
1100     function name() public view virtual override returns (string memory) {
1101         return _name;
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Metadata-symbol}.
1106      */
1107     function symbol() public view virtual override returns (string memory) {
1108         return _symbol;
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Metadata-tokenURI}.
1113      */
1114     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1115         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1116 
1117         string memory baseURI = _baseURI();
1118         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1119     }
1120 
1121     /**
1122      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1123      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1124      * by default, can be overriden in child contracts.
1125      */
1126     function _baseURI() internal view virtual returns (string memory) {
1127         return '';
1128     }
1129 
1130     /**
1131      * @dev Casts the address to uint256 without masking.
1132      */
1133     function _addressToUint256(address value) private pure returns (uint256 result) {
1134         assembly {
1135             result := value
1136         }
1137     }
1138 
1139     /**
1140      * @dev Casts the boolean to uint256 without branching.
1141      */
1142     function _boolToUint256(bool value) private pure returns (uint256 result) {
1143         assembly {
1144             result := value
1145         }
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-approve}.
1150      */
1151     function approve(address to, uint256 tokenId) public override {
1152         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1153         if (to == owner) revert ApprovalToCurrentOwner();
1154 
1155         if (_msgSenderERC721A() != owner)
1156             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1157                 revert ApprovalCallerNotOwnerNorApproved();
1158             }
1159 
1160         _tokenApprovals[tokenId] = to;
1161         emit Approval(owner, to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev See {IERC721-getApproved}.
1166      */
1167     function getApproved(uint256 tokenId) public view override returns (address) {
1168         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1169 
1170         return _tokenApprovals[tokenId];
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-setApprovalForAll}.
1175      */
1176     function setApprovalForAll(address operator, bool approved) public virtual override {
1177         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1178 
1179         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1180         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-isApprovedForAll}.
1185      */
1186     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1187         return _operatorApprovals[owner][operator];
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-transferFrom}.
1192      */
1193     function transferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) public virtual override {
1198         _transfer(from, to, tokenId);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-safeTransferFrom}.
1203      */
1204     function safeTransferFrom(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) public virtual override {
1209         safeTransferFrom(from, to, tokenId, '');
1210     }
1211 
1212     /**
1213      * @dev See {IERC721-safeTransferFrom}.
1214      */
1215     function safeTransferFrom(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) public virtual override {
1221         _transfer(from, to, tokenId);
1222         if (to.code.length != 0)
1223             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1224                 revert TransferToNonERC721ReceiverImplementer();
1225             }
1226     }
1227 
1228     /**
1229      * @dev Returns whether `tokenId` exists.
1230      *
1231      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1232      *
1233      * Tokens start existing when they are minted (`_mint`),
1234      */
1235     function _exists(uint256 tokenId) internal view returns (bool) {
1236         return
1237             _startTokenId() <= tokenId &&
1238             tokenId < _currentIndex && // If within bounds,
1239             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1240     }
1241 
1242     /**
1243      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1244      */
1245     function _safeMint(address to, uint256 quantity) internal {
1246         _safeMint(to, quantity, '');
1247     }
1248 
1249     /**
1250      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1251      *
1252      * Requirements:
1253      *
1254      * - If `to` refers to a smart contract, it must implement
1255      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1256      * - `quantity` must be greater than 0.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _safeMint(
1261         address to,
1262         uint256 quantity,
1263         bytes memory _data
1264     ) internal {
1265         uint256 startTokenId = _currentIndex;
1266         if (to == address(0)) revert MintToZeroAddress();
1267         if (quantity == 0) revert MintZeroQuantity();
1268 
1269         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1270 
1271         // Overflows are incredibly unrealistic.
1272         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1273         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1274         unchecked {
1275             // Updates:
1276             // - `balance += quantity`.
1277             // - `numberMinted += quantity`.
1278             //
1279             // We can directly add to the balance and number minted.
1280             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1281 
1282             // Updates:
1283             // - `address` to the owner.
1284             // - `startTimestamp` to the timestamp of minting.
1285             // - `burned` to `false`.
1286             // - `nextInitialized` to `quantity == 1`.
1287             _packedOwnerships[startTokenId] =
1288                 _addressToUint256(to) |
1289                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1290                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1291 
1292             uint256 updatedIndex = startTokenId;
1293             uint256 end = updatedIndex + quantity;
1294 
1295             if (to.code.length != 0) {
1296                 do {
1297                     emit Transfer(address(0), to, updatedIndex);
1298                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1299                         revert TransferToNonERC721ReceiverImplementer();
1300                     }
1301                 } while (updatedIndex < end);
1302                 // Reentrancy protection
1303                 if (_currentIndex != startTokenId) revert();
1304             } else {
1305                 do {
1306                     emit Transfer(address(0), to, updatedIndex++);
1307                 } while (updatedIndex < end);
1308             }
1309             _currentIndex = updatedIndex;
1310         }
1311         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1312     }
1313 
1314     /**
1315      * @dev Mints `quantity` tokens and transfers them to `to`.
1316      *
1317      * Requirements:
1318      *
1319      * - `to` cannot be the zero address.
1320      * - `quantity` must be greater than 0.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function _mint(address to, uint256 quantity) internal {
1325         uint256 startTokenId = _currentIndex;
1326         if (to == address(0)) revert MintToZeroAddress();
1327         if (quantity == 0) revert MintZeroQuantity();
1328 
1329         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1330 
1331         // Overflows are incredibly unrealistic.
1332         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1333         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1334         unchecked {
1335             // Updates:
1336             // - `balance += quantity`.
1337             // - `numberMinted += quantity`.
1338             //
1339             // We can directly add to the balance and number minted.
1340             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1341 
1342             // Updates:
1343             // - `address` to the owner.
1344             // - `startTimestamp` to the timestamp of minting.
1345             // - `burned` to `false`.
1346             // - `nextInitialized` to `quantity == 1`.
1347             _packedOwnerships[startTokenId] =
1348                 _addressToUint256(to) |
1349                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1350                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1351 
1352             uint256 updatedIndex = startTokenId;
1353             uint256 end = updatedIndex + quantity;
1354 
1355             do {
1356                 emit Transfer(address(0), to, updatedIndex++);
1357             } while (updatedIndex < end);
1358 
1359             _currentIndex = updatedIndex;
1360         }
1361         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1362     }
1363 
1364     /**
1365      * @dev Transfers `tokenId` from `from` to `to`.
1366      *
1367      * Requirements:
1368      *
1369      * - `to` cannot be the zero address.
1370      * - `tokenId` token must be owned by `from`.
1371      *
1372      * Emits a {Transfer} event.
1373      */
1374     function _transfer(
1375         address from,
1376         address to,
1377         uint256 tokenId
1378     ) private {
1379         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1380 
1381         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1382 
1383         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1384             isApprovedForAll(from, _msgSenderERC721A()) ||
1385             getApproved(tokenId) == _msgSenderERC721A());
1386 
1387         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1388         if (to == address(0)) revert TransferToZeroAddress();
1389 
1390         _beforeTokenTransfers(from, to, tokenId, 1);
1391 
1392         // Clear approvals from the previous owner.
1393         delete _tokenApprovals[tokenId];
1394 
1395         // Underflow of the sender's balance is impossible because we check for
1396         // ownership above and the recipient's balance can't realistically overflow.
1397         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1398         unchecked {
1399             // We can directly increment and decrement the balances.
1400             --_packedAddressData[from]; // Updates: `balance -= 1`.
1401             ++_packedAddressData[to]; // Updates: `balance += 1`.
1402 
1403             // Updates:
1404             // - `address` to the next owner.
1405             // - `startTimestamp` to the timestamp of transfering.
1406             // - `burned` to `false`.
1407             // - `nextInitialized` to `true`.
1408             _packedOwnerships[tokenId] =
1409                 _addressToUint256(to) |
1410                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1411                 BITMASK_NEXT_INITIALIZED;
1412 
1413             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1414             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1415                 uint256 nextTokenId = tokenId + 1;
1416                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1417                 if (_packedOwnerships[nextTokenId] == 0) {
1418                     // If the next slot is within bounds.
1419                     if (nextTokenId != _currentIndex) {
1420                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1421                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1422                     }
1423                 }
1424             }
1425         }
1426 
1427         emit Transfer(from, to, tokenId);
1428         _afterTokenTransfers(from, to, tokenId, 1);
1429     }
1430 
1431     /**
1432      * @dev Equivalent to `_burn(tokenId, false)`.
1433      */
1434     function _burn(uint256 tokenId) internal virtual {
1435         _burn(tokenId, false);
1436     }
1437 
1438     /**
1439      * @dev Destroys `tokenId`.
1440      * The approval is cleared when the token is burned.
1441      *
1442      * Requirements:
1443      *
1444      * - `tokenId` must exist.
1445      *
1446      * Emits a {Transfer} event.
1447      */
1448     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1449         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1450 
1451         address from = address(uint160(prevOwnershipPacked));
1452 
1453         if (approvalCheck) {
1454             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1455                 isApprovedForAll(from, _msgSenderERC721A()) ||
1456                 getApproved(tokenId) == _msgSenderERC721A());
1457 
1458             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1459         }
1460 
1461         _beforeTokenTransfers(from, address(0), tokenId, 1);
1462 
1463         // Clear approvals from the previous owner.
1464         delete _tokenApprovals[tokenId];
1465 
1466         // Underflow of the sender's balance is impossible because we check for
1467         // ownership above and the recipient's balance can't realistically overflow.
1468         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1469         unchecked {
1470             // Updates:
1471             // - `balance -= 1`.
1472             // - `numberBurned += 1`.
1473             //
1474             // We can directly decrement the balance, and increment the number burned.
1475             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1476             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1477 
1478             // Updates:
1479             // - `address` to the last owner.
1480             // - `startTimestamp` to the timestamp of burning.
1481             // - `burned` to `true`.
1482             // - `nextInitialized` to `true`.
1483             _packedOwnerships[tokenId] =
1484                 _addressToUint256(from) |
1485                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1486                 BITMASK_BURNED | 
1487                 BITMASK_NEXT_INITIALIZED;
1488 
1489             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1490             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1491                 uint256 nextTokenId = tokenId + 1;
1492                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1493                 if (_packedOwnerships[nextTokenId] == 0) {
1494                     // If the next slot is within bounds.
1495                     if (nextTokenId != _currentIndex) {
1496                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1497                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1498                     }
1499                 }
1500             }
1501         }
1502 
1503         emit Transfer(from, address(0), tokenId);
1504         _afterTokenTransfers(from, address(0), tokenId, 1);
1505 
1506         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1507         unchecked {
1508             _burnCounter++;
1509         }
1510     }
1511 
1512     /**
1513      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1514      *
1515      * @param from address representing the previous owner of the given token ID
1516      * @param to target address that will receive the tokens
1517      * @param tokenId uint256 ID of the token to be transferred
1518      * @param _data bytes optional data to send along with the call
1519      * @return bool whether the call correctly returned the expected magic value
1520      */
1521     function _checkContractOnERC721Received(
1522         address from,
1523         address to,
1524         uint256 tokenId,
1525         bytes memory _data
1526     ) private returns (bool) {
1527         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1528             bytes4 retval
1529         ) {
1530             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1531         } catch (bytes memory reason) {
1532             if (reason.length == 0) {
1533                 revert TransferToNonERC721ReceiverImplementer();
1534             } else {
1535                 assembly {
1536                     revert(add(32, reason), mload(reason))
1537                 }
1538             }
1539         }
1540     }
1541 
1542     /**
1543      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1544      * And also called before burning one token.
1545      *
1546      * startTokenId - the first token id to be transferred
1547      * quantity - the amount to be transferred
1548      *
1549      * Calling conditions:
1550      *
1551      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1552      * transferred to `to`.
1553      * - When `from` is zero, `tokenId` will be minted for `to`.
1554      * - When `to` is zero, `tokenId` will be burned by `from`.
1555      * - `from` and `to` are never both zero.
1556      */
1557     function _beforeTokenTransfers(
1558         address from,
1559         address to,
1560         uint256 startTokenId,
1561         uint256 quantity
1562     ) internal virtual {}
1563 
1564     /**
1565      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1566      * minting.
1567      * And also called after one token has been burned.
1568      *
1569      * startTokenId - the first token id to be transferred
1570      * quantity - the amount to be transferred
1571      *
1572      * Calling conditions:
1573      *
1574      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1575      * transferred to `to`.
1576      * - When `from` is zero, `tokenId` has been minted for `to`.
1577      * - When `to` is zero, `tokenId` has been burned by `from`.
1578      * - `from` and `to` are never both zero.
1579      */
1580     function _afterTokenTransfers(
1581         address from,
1582         address to,
1583         uint256 startTokenId,
1584         uint256 quantity
1585     ) internal virtual {}
1586 
1587     /**
1588      * @dev Returns the message sender (defaults to `msg.sender`).
1589      *
1590      * If you are writing GSN compatible contracts, you need to override this function.
1591      */
1592     function _msgSenderERC721A() internal view virtual returns (address) {
1593         return msg.sender;
1594     }
1595 
1596     /**
1597      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1598      */
1599     function _toString(uint256 value) internal pure returns (string memory ptr) {
1600         assembly {
1601             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1602             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1603             // We will need 1 32-byte word to store the length, 
1604             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1605             ptr := add(mload(0x40), 128)
1606             // Update the free memory pointer to allocate.
1607             mstore(0x40, ptr)
1608 
1609             // Cache the end of the memory to calculate the length later.
1610             let end := ptr
1611 
1612             // We write the string from the rightmost digit to the leftmost digit.
1613             // The following is essentially a do-while loop that also handles the zero case.
1614             // Costs a bit more than early returning for the zero case,
1615             // but cheaper in terms of deployment and overall runtime costs.
1616             for { 
1617                 // Initialize and perform the first pass without check.
1618                 let temp := value
1619                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1620                 ptr := sub(ptr, 1)
1621                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1622                 mstore8(ptr, add(48, mod(temp, 10)))
1623                 temp := div(temp, 10)
1624             } temp { 
1625                 // Keep dividing `temp` until zero.
1626                 temp := div(temp, 10)
1627             } { // Body of the for loop.
1628                 ptr := sub(ptr, 1)
1629                 mstore8(ptr, add(48, mod(temp, 10)))
1630             }
1631             
1632             let length := sub(end, ptr)
1633             // Move the pointer 32 bytes leftwards to make room for the length.
1634             ptr := sub(ptr, 32)
1635             // Store the length.
1636             mstore(ptr, length)
1637         }
1638     }
1639 }
1640 
1641 // File: contracts/CYN NFT2.sol
1642 
1643 
1644 
1645 pragma solidity ^0.8.4;
1646 
1647 
1648 
1649 
1650 
1651 
1652 
1653 contract CYNNFT is ERC721A, Ownable, Pausable, ReentrancyGuard {
1654     using Strings for uint256;
1655 
1656     string public baseURI;
1657 
1658     uint256 public price = 0.0045 ether;
1659 
1660     uint256 public maxPerTx = 3;
1661 
1662     uint256 public maxFreePerWallet = 3;
1663 
1664     uint256 public totalFree = 1500;
1665 
1666     uint256 public maxSupply = 9999;
1667 
1668     bool public mintEnabled = false;
1669 
1670     address public coldWallet = 0x0971AF56814a12127962DfDbf71877a60bE7b3A0; 
1671 
1672     mapping(address => uint256) private _mintedFreeAmount;
1673 
1674     constructor() ERC721A("CYN NFT", "CYNNFT") {
1675         _safeMint(msg.sender, 10);
1676         setBaseURI("https://gateway.pinata.cloud/ipfs/QmVLDPbtkaVNiwc6dtWSMokovQWZrKHhQj1yPQv3AWSTYV/CYN.json");
1677     }
1678 
1679     function mint(uint256 count) external payable {
1680         uint256 cost = price;
1681         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1682             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1683 
1684         if (isFree) {
1685             cost = 0;
1686         }
1687 
1688         require(msg.value >= count * cost, "Please send the exact amount.");
1689         require(totalSupply() + count < maxSupply + 1, "No more left");
1690         require(mintEnabled, "Minting is not live yet");
1691         require(count < maxPerTx + 1, "Max per TX reached.");
1692 
1693         if (isFree) {
1694             _mintedFreeAmount[msg.sender] += count;
1695         }
1696 
1697         _safeMint(msg.sender, count);
1698     }
1699 
1700     function _baseURI() internal view virtual override returns (string memory) {
1701         return baseURI;
1702     }
1703 
1704     function tokenURI(uint256 tokenId)
1705         public
1706         view
1707         virtual
1708         override
1709         returns (string memory)
1710     {
1711         require(
1712             _exists(tokenId),
1713             "ERC721Metadata: URI query for nonexistent token"
1714         );
1715         return _baseURI();
1716     }
1717 
1718     function setBaseURI(string memory uri) public onlyOwner {
1719         baseURI = uri;
1720     }
1721 
1722     function setFreeAmount(uint256 amount) external onlyOwner {
1723         totalFree = amount;
1724     }
1725 
1726     function setPrice(uint256 _newPrice) external onlyOwner {
1727         price = _newPrice;
1728     }
1729 
1730      function setMaxSupply(uint256 _newSupply) external onlyOwner {
1731         maxSupply = _newSupply;
1732     }
1733 
1734     function enableMint() external onlyOwner {
1735         mintEnabled = !mintEnabled;
1736     }
1737 
1738     /// @notice only owner can withdraw the money
1739      function withdrawMoney() external onlyOwner nonReentrant {
1740         (bool success, ) = coldWallet.call{value: address(this).balance}("");
1741         require(success, "Transfer failed.");
1742     }  
1743 }