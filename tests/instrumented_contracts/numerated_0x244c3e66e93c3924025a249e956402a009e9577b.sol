1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev String operations.
5  */
6 library Strings {
7     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
8     uint8 private constant _ADDRESS_LENGTH = 20;
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
68      */
69     function toHexString(address addr) internal pure returns (string memory) {
70         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Address.sol
75 
76 
77 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
78 
79 pragma solidity ^0.8.1;
80 
81 /**
82  * @dev Collection of functions related to the address type
83  */
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      *
102      * [IMPORTANT]
103      * ====
104      * You shouldn't rely on `isContract` to protect against flash loan attacks!
105      *
106      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
107      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
108      * constructor.
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize/address.code.length, which returns 0
113         // for contracts in construction, since the code is only stored at the end
114         // of the constructor execution.
115 
116         return account.code.length > 0;
117     }
118 
119     /**
120      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
121      * `recipient`, forwarding all available gas and reverting on errors.
122      *
123      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
124      * of certain opcodes, possibly making contracts go over the 2300 gas limit
125      * imposed by `transfer`, making them unable to receive funds via
126      * `transfer`. {sendValue} removes this limitation.
127      *
128      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
129      *
130      * IMPORTANT: because control is transferred to `recipient`, care must be
131      * taken to not create reentrancy vulnerabilities. Consider using
132      * {ReentrancyGuard} or the
133      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
134      */
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         (bool success, ) = recipient.call{value: amount}("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain `call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
199      * with `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         require(isContract(target), "Address: call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.call{value: value}(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
223         return functionStaticCall(target, data, "Address: low-level static call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a static call.
229      *
230      * _Available since v3.3._
231      */
232     function functionStaticCall(
233         address target,
234         bytes memory data,
235         string memory errorMessage
236     ) internal view returns (bytes memory) {
237         require(isContract(target), "Address: static call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.staticcall(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a delegate call.
256      *
257      * _Available since v3.4._
258      */
259     function functionDelegateCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(isContract(target), "Address: delegate call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.delegatecall(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
272      * revert reason using the provided one.
273      *
274      * _Available since v4.3._
275      */
276     function verifyCallResult(
277         bool success,
278         bytes memory returndata,
279         string memory errorMessage
280     ) internal pure returns (bytes memory) {
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287                 /// @solidity memory-safe-assembly
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
300 
301 
302 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Contract module that helps prevent reentrant calls to a function.
308  *
309  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
310  * available, which can be applied to functions to make sure there are no nested
311  * (reentrant) calls to them.
312  *
313  * Note that because there is a single `nonReentrant` guard, functions marked as
314  * `nonReentrant` may not call one another. This can be worked around by making
315  * those functions `private`, and then adding `external` `nonReentrant` entry
316  * points to them.
317  *
318  * TIP: If you would like to learn more about reentrancy and alternative ways
319  * to protect against it, check out our blog post
320  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
321  */
322 abstract contract ReentrancyGuard {
323     // Booleans are more expensive than uint256 or any type that takes up a full
324     // word because each write operation emits an extra SLOAD to first read the
325     // slot's contents, replace the bits taken up by the boolean, and then write
326     // back. This is the compiler's defense against contract upgrades and
327     // pointer aliasing, and it cannot be disabled.
328 
329     // The values being non-zero value makes deployment a bit more expensive,
330     // but in exchange the refund on every call to nonReentrant will be lower in
331     // amount. Since refunds are capped to a percentage of the total
332     // transaction's gas, it is best to keep them low in cases like this one, to
333     // increase the likelihood of the full refund coming into effect.
334     uint256 private constant _NOT_ENTERED = 1;
335     uint256 private constant _ENTERED = 2;
336 
337     uint256 private _status;
338 
339     constructor() {
340         _status = _NOT_ENTERED;
341     }
342 
343     /**
344      * @dev Prevents a contract from calling itself, directly or indirectly.
345      * Calling a `nonReentrant` function from another `nonReentrant`
346      * function is not supported. It is possible to prevent this from happening
347      * by making the `nonReentrant` function external, and making it call a
348      * `private` function that does the actual work.
349      */
350     modifier nonReentrant() {
351         // On the first call to nonReentrant, _notEntered will be true
352         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
353 
354         // Any calls to nonReentrant after this point will fail
355         _status = _ENTERED;
356 
357         _;
358 
359         // By storing the original value once again, a refund is triggered (see
360         // https://eips.ethereum.org/EIPS/eip-2200)
361         _status = _NOT_ENTERED;
362     }
363 }
364 
365 // File: @openzeppelin/contracts/utils/Context.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 /**
373  * @dev Provides information about the current execution context, including the
374  * sender of the transaction and its data. While these are generally available
375  * via msg.sender and msg.data, they should not be accessed in such a direct
376  * manner, since when dealing with meta-transactions the account sending and
377  * paying for execution may not be the actual sender (as far as an application
378  * is concerned).
379  *
380  * This contract is only required for intermediate, library-like contracts.
381  */
382 abstract contract Context {
383     function _msgSender() internal view virtual returns (address) {
384         return msg.sender;
385     }
386 
387     function _msgData() internal view virtual returns (bytes calldata) {
388         return msg.data;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/access/Ownable.sol
393 
394 
395 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev Contract module which provides a basic access control mechanism, where
402  * there is an account (an owner) that can be granted exclusive access to
403  * specific functions.
404  *
405  * By default, the owner account will be the one that deploys the contract. This
406  * can later be changed with {transferOwnership}.
407  *
408  * This module is used through inheritance. It will make available the modifier
409  * `onlyOwner`, which can be applied to your functions to restrict their use to
410  * the owner.
411  */
412 abstract contract Ownable is Context {
413     address private _owner;
414 
415     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
416 
417     /**
418      * @dev Initializes the contract setting the deployer as the initial owner.
419      */
420     constructor() {
421         _transferOwnership(_msgSender());
422     }
423 
424     /**
425      * @dev Throws if called by any account other than the owner.
426      */
427     modifier onlyOwner() {
428         _checkOwner();
429         _;
430     }
431 
432     /**
433      * @dev Returns the address of the current owner.
434      */
435     function owner() public view virtual returns (address) {
436         return _owner;
437     }
438 
439     /**
440      * @dev Throws if the sender is not the owner.
441      */
442     function _checkOwner() internal view virtual {
443         require(owner() == _msgSender(), "Ownable: caller is not the owner");
444     }
445 
446     /**
447      * @dev Leaves the contract without owner. It will not be possible to call
448      * `onlyOwner` functions anymore. Can only be called by the current owner.
449      *
450      * NOTE: Renouncing ownership will leave the contract without an owner,
451      * thereby removing any functionality that is only available to the owner.
452      */
453     function renounceOwnership() public virtual onlyOwner {
454         _transferOwnership(address(0));
455     }
456 
457     /**
458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
459      * Can only be called by the current owner.
460      */
461     function transferOwnership(address newOwner) public virtual onlyOwner {
462         require(newOwner != address(0), "Ownable: new owner is the zero address");
463         _transferOwnership(newOwner);
464     }
465 
466     /**
467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
468      * Internal function without access restriction.
469      */
470     function _transferOwnership(address newOwner) internal virtual {
471         address oldOwner = _owner;
472         _owner = newOwner;
473         emit OwnershipTransferred(oldOwner, newOwner);
474     }
475 }
476 
477 // File: erc721a/contracts/IERC721A.sol
478 
479 
480 // ERC721A Contracts v4.1.0
481 // Creator: Chiru Labs
482 
483 pragma solidity ^0.8.4;
484 
485 /**
486  * @dev Interface of an ERC721A compliant contract.
487  */
488 interface IERC721A {
489     /**
490      * The caller must own the token or be an approved operator.
491      */
492     error ApprovalCallerNotOwnerNorApproved();
493 
494     /**
495      * The token does not exist.
496      */
497     error ApprovalQueryForNonexistentToken();
498 
499     /**
500      * The caller cannot approve to their own address.
501      */
502     error ApproveToCaller();
503 
504     /**
505      * Cannot query the balance for the zero address.
506      */
507     error BalanceQueryForZeroAddress();
508 
509     /**
510      * Cannot mint to the zero address.
511      */
512     error MintToZeroAddress();
513 
514     /**
515      * The quantity of tokens minted must be more than zero.
516      */
517     error MintZeroQuantity();
518 
519     /**
520      * The token does not exist.
521      */
522     error OwnerQueryForNonexistentToken();
523 
524     /**
525      * The caller must own the token or be an approved operator.
526      */
527     error TransferCallerNotOwnerNorApproved();
528 
529     /**
530      * The token must be owned by `from`.
531      */
532     error TransferFromIncorrectOwner();
533 
534     /**
535      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
536      */
537     error TransferToNonERC721ReceiverImplementer();
538 
539     /**
540      * Cannot transfer to the zero address.
541      */
542     error TransferToZeroAddress();
543 
544     /**
545      * The token does not exist.
546      */
547     error URIQueryForNonexistentToken();
548 
549     /**
550      * The `quantity` minted with ERC2309 exceeds the safety limit.
551      */
552     error MintERC2309QuantityExceedsLimit();
553 
554     /**
555      * The `extraData` cannot be set on an unintialized ownership slot.
556      */
557     error OwnershipNotInitializedForExtraData();
558 
559     struct TokenOwnership {
560         // The address of the owner.
561         address addr;
562         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
563         uint64 startTimestamp;
564         // Whether the token has been burned.
565         bool burned;
566         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
567         uint24 extraData;
568     }
569 
570     /**
571      * @dev Returns the total amount of tokens stored by the contract.
572      *
573      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
574      */
575     function totalSupply() external view returns (uint256);
576 
577     // ==============================
578     //            IERC165
579     // ==============================
580 
581     /**
582      * @dev Returns true if this contract implements the interface defined by
583      * `interfaceId`. See the corresponding
584      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
585      * to learn more about how these ids are created.
586      *
587      * This function call must use less than 30 000 gas.
588      */
589     function supportsInterface(bytes4 interfaceId) external view returns (bool);
590 
591     // ==============================
592     //            IERC721
593     // ==============================
594 
595     /**
596      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
597      */
598     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
602      */
603     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
604 
605     /**
606      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
607      */
608     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
609 
610     /**
611      * @dev Returns the number of tokens in ``owner``'s account.
612      */
613     function balanceOf(address owner) external view returns (uint256 balance);
614 
615     /**
616      * @dev Returns the owner of the `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function ownerOf(uint256 tokenId) external view returns (address owner);
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must exist and be owned by `from`.
632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
634      *
635      * Emits a {Transfer} event.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId,
641         bytes calldata data
642     ) external;
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Transfers `tokenId` token from `from` to `to`.
666      *
667      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
686      * The approval is cleared when the token is transferred.
687      *
688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) external;
698 
699     /**
700      * @dev Approve or remove `operator` as an operator for the caller.
701      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
702      *
703      * Requirements:
704      *
705      * - The `operator` cannot be the caller.
706      *
707      * Emits an {ApprovalForAll} event.
708      */
709     function setApprovalForAll(address operator, bool _approved) external;
710 
711     /**
712      * @dev Returns the account approved for `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function getApproved(uint256 tokenId) external view returns (address operator);
719 
720     /**
721      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
722      *
723      * See {setApprovalForAll}
724      */
725     function isApprovedForAll(address owner, address operator) external view returns (bool);
726 
727     // ==============================
728     //        IERC721Metadata
729     // ==============================
730 
731     /**
732      * @dev Returns the token collection name.
733      */
734     function name() external view returns (string memory);
735 
736     /**
737      * @dev Returns the token collection symbol.
738      */
739     function symbol() external view returns (string memory);
740 
741     /**
742      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
743      */
744     function tokenURI(uint256 tokenId) external view returns (string memory);
745 
746     // ==============================
747     //            IERC2309
748     // ==============================
749 
750     /**
751      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
752      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
753      */
754     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
755 }
756 
757 // File: erc721a/contracts/ERC721A.sol
758 
759 
760 // ERC721A Contracts v4.1.0
761 // Creator: Chiru Labs
762 
763 pragma solidity ^0.8.4;
764 
765 
766 /**
767  * @dev ERC721 token receiver interface.
768  */
769 interface ERC721A__IERC721Receiver {
770     function onERC721Received(
771         address operator,
772         address from,
773         uint256 tokenId,
774         bytes calldata data
775     ) external returns (bytes4);
776 }
777 
778 /**
779  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
780  * including the Metadata extension. Built to optimize for lower gas during batch mints.
781  *
782  * Assumes serials are sequentially minted starting at `_startTokenId()`
783  * (defaults to 0, e.g. 0, 1, 2, 3..).
784  *
785  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
786  *
787  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
788  */
789 contract ERC721A is IERC721A {
790     // Mask of an entry in packed address data.
791     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
792 
793     // The bit position of `numberMinted` in packed address data.
794     uint256 private constant BITPOS_NUMBER_MINTED = 64;
795 
796     // The bit position of `numberBurned` in packed address data.
797     uint256 private constant BITPOS_NUMBER_BURNED = 128;
798 
799     // The bit position of `aux` in packed address data.
800     uint256 private constant BITPOS_AUX = 192;
801 
802     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
803     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
804 
805     // The bit position of `startTimestamp` in packed ownership.
806     uint256 private constant BITPOS_START_TIMESTAMP = 160;
807 
808     // The bit mask of the `burned` bit in packed ownership.
809     uint256 private constant BITMASK_BURNED = 1 << 224;
810 
811     // The bit position of the `nextInitialized` bit in packed ownership.
812     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
813 
814     // The bit mask of the `nextInitialized` bit in packed ownership.
815     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
816 
817     // The bit position of `extraData` in packed ownership.
818     uint256 private constant BITPOS_EXTRA_DATA = 232;
819 
820     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
821     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
822 
823     // The mask of the lower 160 bits for addresses.
824     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
825 
826     // The maximum `quantity` that can be minted with `_mintERC2309`.
827     // This limit is to prevent overflows on the address data entries.
828     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
829     // is required to cause an overflow, which is unrealistic.
830     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
831 
832     // The tokenId of the next token to be minted.
833     uint256 private _currentIndex;
834 
835     // The number of tokens burned.
836     uint256 private _burnCounter;
837 
838     // Token name
839     string private _name;
840 
841     // Token symbol
842     string private _symbol;
843 
844     // Mapping from token ID to ownership details
845     // An empty struct value does not necessarily mean the token is unowned.
846     // See `_packedOwnershipOf` implementation for details.
847     //
848     // Bits Layout:
849     // - [0..159]   `addr`
850     // - [160..223] `startTimestamp`
851     // - [224]      `burned`
852     // - [225]      `nextInitialized`
853     // - [232..255] `extraData`
854     mapping(uint256 => uint256) private _packedOwnerships;
855 
856     // Mapping owner address to address data.
857     //
858     // Bits Layout:
859     // - [0..63]    `balance`
860     // - [64..127]  `numberMinted`
861     // - [128..191] `numberBurned`
862     // - [192..255] `aux`
863     mapping(address => uint256) private _packedAddressData;
864 
865     // Mapping from token ID to approved address.
866     mapping(uint256 => address) private _tokenApprovals;
867 
868     // Mapping from owner to operator approvals
869     mapping(address => mapping(address => bool)) private _operatorApprovals;
870 
871     constructor(string memory name_, string memory symbol_) {
872         _name = name_;
873         _symbol = symbol_;
874         _currentIndex = _startTokenId();
875     }
876 
877     /**
878      * @dev Returns the starting token ID.
879      * To change the starting token ID, please override this function.
880      */
881     function _startTokenId() internal view virtual returns (uint256) {
882         return 0;
883     }
884 
885     /**
886      * @dev Returns the next token ID to be minted.
887      */
888     function _nextTokenId() internal view returns (uint256) {
889         return _currentIndex;
890     }
891 
892     /**
893      * @dev Returns the total number of tokens in existence.
894      * Burned tokens will reduce the count.
895      * To get the total number of tokens minted, please see `_totalMinted`.
896      */
897     function totalSupply() public view override returns (uint256) {
898         // Counter underflow is impossible as _burnCounter cannot be incremented
899         // more than `_currentIndex - _startTokenId()` times.
900         unchecked {
901             return _currentIndex - _burnCounter - _startTokenId();
902         }
903     }
904 
905     /**
906      * @dev Returns the total amount of tokens minted in the contract.
907      */
908     function _totalMinted() internal view returns (uint256) {
909         // Counter underflow is impossible as _currentIndex does not decrement,
910         // and it is initialized to `_startTokenId()`
911         unchecked {
912             return _currentIndex - _startTokenId();
913         }
914     }
915 
916     /**
917      * @dev Returns the total number of tokens burned.
918      */
919     function _totalBurned() internal view returns (uint256) {
920         return _burnCounter;
921     }
922 
923     /**
924      * @dev See {IERC165-supportsInterface}.
925      */
926     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
927         // The interface IDs are constants representing the first 4 bytes of the XOR of
928         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
929         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
930         return
931             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
932             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
933             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
934     }
935 
936     /**
937      * @dev See {IERC721-balanceOf}.
938      */
939     function balanceOf(address owner) public view override returns (uint256) {
940         if (owner == address(0)) revert BalanceQueryForZeroAddress();
941         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
942     }
943 
944     /**
945      * Returns the number of tokens minted by `owner`.
946      */
947     function _numberMinted(address owner) internal view returns (uint256) {
948         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
949     }
950 
951     /**
952      * Returns the number of tokens burned by or on behalf of `owner`.
953      */
954     function _numberBurned(address owner) internal view returns (uint256) {
955         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
956     }
957 
958     /**
959      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
960      */
961     function _getAux(address owner) internal view returns (uint64) {
962         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
963     }
964 
965     /**
966      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
967      * If there are multiple variables, please pack them into a uint64.
968      */
969     function _setAux(address owner, uint64 aux) internal {
970         uint256 packed = _packedAddressData[owner];
971         uint256 auxCasted;
972         // Cast `aux` with assembly to avoid redundant masking.
973         assembly {
974             auxCasted := aux
975         }
976         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
977         _packedAddressData[owner] = packed;
978     }
979 
980     /**
981      * Returns the packed ownership data of `tokenId`.
982      */
983     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
984         uint256 curr = tokenId;
985 
986         unchecked {
987             if (_startTokenId() <= curr)
988                 if (curr < _currentIndex) {
989                     uint256 packed = _packedOwnerships[curr];
990                     // If not burned.
991                     if (packed & BITMASK_BURNED == 0) {
992                         // Invariant:
993                         // There will always be an ownership that has an address and is not burned
994                         // before an ownership that does not have an address and is not burned.
995                         // Hence, curr will not underflow.
996                         //
997                         // We can directly compare the packed value.
998                         // If the address is zero, packed is zero.
999                         while (packed == 0) {
1000                             packed = _packedOwnerships[--curr];
1001                         }
1002                         return packed;
1003                     }
1004                 }
1005         }
1006         revert OwnerQueryForNonexistentToken();
1007     }
1008 
1009     /**
1010      * Returns the unpacked `TokenOwnership` struct from `packed`.
1011      */
1012     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1013         ownership.addr = address(uint160(packed));
1014         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1015         ownership.burned = packed & BITMASK_BURNED != 0;
1016         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1017     }
1018 
1019     /**
1020      * Returns the unpacked `TokenOwnership` struct at `index`.
1021      */
1022     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1023         return _unpackedOwnership(_packedOwnerships[index]);
1024     }
1025 
1026     /**
1027      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1028      */
1029     function _initializeOwnershipAt(uint256 index) internal {
1030         if (_packedOwnerships[index] == 0) {
1031             _packedOwnerships[index] = _packedOwnershipOf(index);
1032         }
1033     }
1034 
1035     /**
1036      * Gas spent here starts off proportional to the maximum mint batch size.
1037      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1038      */
1039     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1040         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1041     }
1042 
1043     /**
1044      * @dev Packs ownership data into a single uint256.
1045      */
1046     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1047         assembly {
1048             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1049             owner := and(owner, BITMASK_ADDRESS)
1050             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1051             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1052         }
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-ownerOf}.
1057      */
1058     function ownerOf(uint256 tokenId) public view override returns (address) {
1059         return address(uint160(_packedOwnershipOf(tokenId)));
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Metadata-name}.
1064      */
1065     function name() public view virtual override returns (string memory) {
1066         return _name;
1067     }
1068 
1069     /**
1070      * @dev See {IERC721Metadata-symbol}.
1071      */
1072     function symbol() public view virtual override returns (string memory) {
1073         return _symbol;
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Metadata-tokenURI}.
1078      */
1079     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1080         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1081 
1082         string memory baseURI = _baseURI();
1083         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1084     }
1085 
1086     /**
1087      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1088      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1089      * by default, it can be overridden in child contracts.
1090      */
1091     function _baseURI() internal view virtual returns (string memory) {
1092         return '';
1093     }
1094 
1095     /**
1096      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1097      */
1098     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1099         // For branchless setting of the `nextInitialized` flag.
1100         assembly {
1101             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1102             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1103         }
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-approve}.
1108      */
1109     function approve(address to, uint256 tokenId) public override {
1110         address owner = ownerOf(tokenId);
1111 
1112         if (_msgSenderERC721A() != owner)
1113             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1114                 revert ApprovalCallerNotOwnerNorApproved();
1115             }
1116 
1117         _tokenApprovals[tokenId] = to;
1118         emit Approval(owner, to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-getApproved}.
1123      */
1124     function getApproved(uint256 tokenId) public view override returns (address) {
1125         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1126 
1127         return _tokenApprovals[tokenId];
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-setApprovalForAll}.
1132      */
1133     function setApprovalForAll(address operator, bool approved) public virtual override {
1134         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1135 
1136         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1137         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-isApprovedForAll}.
1142      */
1143     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1144         return _operatorApprovals[owner][operator];
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-safeTransferFrom}.
1149      */
1150     function safeTransferFrom(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) public virtual override {
1155         safeTransferFrom(from, to, tokenId, '');
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-safeTransferFrom}.
1160      */
1161     function safeTransferFrom(
1162         address from,
1163         address to,
1164         uint256 tokenId,
1165         bytes memory _data
1166     ) public virtual override {
1167         transferFrom(from, to, tokenId);
1168         if (to.code.length != 0)
1169             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1170                 revert TransferToNonERC721ReceiverImplementer();
1171             }
1172     }
1173 
1174     /**
1175      * @dev Returns whether `tokenId` exists.
1176      *
1177      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1178      *
1179      * Tokens start existing when they are minted (`_mint`),
1180      */
1181     function _exists(uint256 tokenId) internal view returns (bool) {
1182         return
1183             _startTokenId() <= tokenId &&
1184             tokenId < _currentIndex && // If within bounds,
1185             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1186     }
1187 
1188     /**
1189      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1190      */
1191     function _safeMint(address to, uint256 quantity) internal {
1192         _safeMint(to, quantity, '');
1193     }
1194 
1195     /**
1196      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1197      *
1198      * Requirements:
1199      *
1200      * - If `to` refers to a smart contract, it must implement
1201      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1202      * - `quantity` must be greater than 0.
1203      *
1204      * See {_mint}.
1205      *
1206      * Emits a {Transfer} event for each mint.
1207      */
1208     function _safeMint(
1209         address to,
1210         uint256 quantity,
1211         bytes memory _data
1212     ) internal {
1213         _mint(to, quantity);
1214 
1215         unchecked {
1216             if (to.code.length != 0) {
1217                 uint256 end = _currentIndex;
1218                 uint256 index = end - quantity;
1219                 do {
1220                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1221                         revert TransferToNonERC721ReceiverImplementer();
1222                     }
1223                 } while (index < end);
1224                 // Reentrancy protection.
1225                 if (_currentIndex != end) revert();
1226             }
1227         }
1228     }
1229 
1230     /**
1231      * @dev Mints `quantity` tokens and transfers them to `to`.
1232      *
1233      * Requirements:
1234      *
1235      * - `to` cannot be the zero address.
1236      * - `quantity` must be greater than 0.
1237      *
1238      * Emits a {Transfer} event for each mint.
1239      */
1240     function _mint(address to, uint256 quantity) internal {
1241         uint256 startTokenId = _currentIndex;
1242         if (to == address(0)) revert MintToZeroAddress();
1243         if (quantity == 0) revert MintZeroQuantity();
1244 
1245         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1246 
1247         // Overflows are incredibly unrealistic.
1248         // `balance` and `numberMinted` have a maximum limit of 2**64.
1249         // `tokenId` has a maximum limit of 2**256.
1250         unchecked {
1251             // Updates:
1252             // - `balance += quantity`.
1253             // - `numberMinted += quantity`.
1254             //
1255             // We can directly add to the `balance` and `numberMinted`.
1256             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1257 
1258             // Updates:
1259             // - `address` to the owner.
1260             // - `startTimestamp` to the timestamp of minting.
1261             // - `burned` to `false`.
1262             // - `nextInitialized` to `quantity == 1`.
1263             _packedOwnerships[startTokenId] = _packOwnershipData(
1264                 to,
1265                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1266             );
1267 
1268             uint256 tokenId = startTokenId;
1269             uint256 end = startTokenId + quantity;
1270             do {
1271                 emit Transfer(address(0), to, tokenId++);
1272             } while (tokenId < end);
1273 
1274             _currentIndex = end;
1275         }
1276         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1277     }
1278 
1279     /**
1280      * @dev Mints `quantity` tokens and transfers them to `to`.
1281      *
1282      * This function is intended for efficient minting only during contract creation.
1283      *
1284      * It emits only one {ConsecutiveTransfer} as defined in
1285      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1286      * instead of a sequence of {Transfer} event(s).
1287      *
1288      * Calling this function outside of contract creation WILL make your contract
1289      * non-compliant with the ERC721 standard.
1290      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1291      * {ConsecutiveTransfer} event is only permissible during contract creation.
1292      *
1293      * Requirements:
1294      *
1295      * - `to` cannot be the zero address.
1296      * - `quantity` must be greater than 0.
1297      *
1298      * Emits a {ConsecutiveTransfer} event.
1299      */
1300     function _mintERC2309(address to, uint256 quantity) internal {
1301         uint256 startTokenId = _currentIndex;
1302         if (to == address(0)) revert MintToZeroAddress();
1303         if (quantity == 0) revert MintZeroQuantity();
1304         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1305 
1306         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1307 
1308         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1309         unchecked {
1310             // Updates:
1311             // - `balance += quantity`.
1312             // - `numberMinted += quantity`.
1313             //
1314             // We can directly add to the `balance` and `numberMinted`.
1315             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1316 
1317             // Updates:
1318             // - `address` to the owner.
1319             // - `startTimestamp` to the timestamp of minting.
1320             // - `burned` to `false`.
1321             // - `nextInitialized` to `quantity == 1`.
1322             _packedOwnerships[startTokenId] = _packOwnershipData(
1323                 to,
1324                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1325             );
1326 
1327             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1328 
1329             _currentIndex = startTokenId + quantity;
1330         }
1331         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1332     }
1333 
1334     /**
1335      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1336      */
1337     function _getApprovedAddress(uint256 tokenId)
1338         private
1339         view
1340         returns (uint256 approvedAddressSlot, address approvedAddress)
1341     {
1342         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1343         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1344         assembly {
1345             // Compute the slot.
1346             mstore(0x00, tokenId)
1347             mstore(0x20, tokenApprovalsPtr.slot)
1348             approvedAddressSlot := keccak256(0x00, 0x40)
1349             // Load the slot's value from storage.
1350             approvedAddress := sload(approvedAddressSlot)
1351         }
1352     }
1353 
1354     /**
1355      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1356      */
1357     function _isOwnerOrApproved(
1358         address approvedAddress,
1359         address from,
1360         address msgSender
1361     ) private pure returns (bool result) {
1362         assembly {
1363             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1364             from := and(from, BITMASK_ADDRESS)
1365             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1366             msgSender := and(msgSender, BITMASK_ADDRESS)
1367             // `msgSender == from || msgSender == approvedAddress`.
1368             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1369         }
1370     }
1371 
1372     /**
1373      * @dev Transfers `tokenId` from `from` to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - `to` cannot be the zero address.
1378      * - `tokenId` token must be owned by `from`.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function transferFrom(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) public virtual override {
1387         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1388 
1389         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1390 
1391         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1392 
1393         // The nested ifs save around 20+ gas over a compound boolean condition.
1394         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1395             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1396 
1397         if (to == address(0)) revert TransferToZeroAddress();
1398 
1399         _beforeTokenTransfers(from, to, tokenId, 1);
1400 
1401         // Clear approvals from the previous owner.
1402         assembly {
1403             if approvedAddress {
1404                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1405                 sstore(approvedAddressSlot, 0)
1406             }
1407         }
1408 
1409         // Underflow of the sender's balance is impossible because we check for
1410         // ownership above and the recipient's balance can't realistically overflow.
1411         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1412         unchecked {
1413             // We can directly increment and decrement the balances.
1414             --_packedAddressData[from]; // Updates: `balance -= 1`.
1415             ++_packedAddressData[to]; // Updates: `balance += 1`.
1416 
1417             // Updates:
1418             // - `address` to the next owner.
1419             // - `startTimestamp` to the timestamp of transfering.
1420             // - `burned` to `false`.
1421             // - `nextInitialized` to `true`.
1422             _packedOwnerships[tokenId] = _packOwnershipData(
1423                 to,
1424                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1425             );
1426 
1427             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1428             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1429                 uint256 nextTokenId = tokenId + 1;
1430                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1431                 if (_packedOwnerships[nextTokenId] == 0) {
1432                     // If the next slot is within bounds.
1433                     if (nextTokenId != _currentIndex) {
1434                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1435                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1436                     }
1437                 }
1438             }
1439         }
1440 
1441         emit Transfer(from, to, tokenId);
1442         _afterTokenTransfers(from, to, tokenId, 1);
1443     }
1444 
1445     /**
1446      * @dev Equivalent to `_burn(tokenId, false)`.
1447      */
1448     function _burn(uint256 tokenId) internal virtual {
1449         _burn(tokenId, false);
1450     }
1451 
1452     /**
1453      * @dev Destroys `tokenId`.
1454      * The approval is cleared when the token is burned.
1455      *
1456      * Requirements:
1457      *
1458      * - `tokenId` must exist.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1463         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1464 
1465         address from = address(uint160(prevOwnershipPacked));
1466 
1467         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1468 
1469         if (approvalCheck) {
1470             // The nested ifs save around 20+ gas over a compound boolean condition.
1471             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1472                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1473         }
1474 
1475         _beforeTokenTransfers(from, address(0), tokenId, 1);
1476 
1477         // Clear approvals from the previous owner.
1478         assembly {
1479             if approvedAddress {
1480                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1481                 sstore(approvedAddressSlot, 0)
1482             }
1483         }
1484 
1485         // Underflow of the sender's balance is impossible because we check for
1486         // ownership above and the recipient's balance can't realistically overflow.
1487         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1488         unchecked {
1489             // Updates:
1490             // - `balance -= 1`.
1491             // - `numberBurned += 1`.
1492             //
1493             // We can directly decrement the balance, and increment the number burned.
1494             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1495             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1496 
1497             // Updates:
1498             // - `address` to the last owner.
1499             // - `startTimestamp` to the timestamp of burning.
1500             // - `burned` to `true`.
1501             // - `nextInitialized` to `true`.
1502             _packedOwnerships[tokenId] = _packOwnershipData(
1503                 from,
1504                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1505             );
1506 
1507             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1508             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1509                 uint256 nextTokenId = tokenId + 1;
1510                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1511                 if (_packedOwnerships[nextTokenId] == 0) {
1512                     // If the next slot is within bounds.
1513                     if (nextTokenId != _currentIndex) {
1514                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1515                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1516                     }
1517                 }
1518             }
1519         }
1520 
1521         emit Transfer(from, address(0), tokenId);
1522         _afterTokenTransfers(from, address(0), tokenId, 1);
1523 
1524         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1525         unchecked {
1526             _burnCounter++;
1527         }
1528     }
1529 
1530     /**
1531      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1532      *
1533      * @param from address representing the previous owner of the given token ID
1534      * @param to target address that will receive the tokens
1535      * @param tokenId uint256 ID of the token to be transferred
1536      * @param _data bytes optional data to send along with the call
1537      * @return bool whether the call correctly returned the expected magic value
1538      */
1539     function _checkContractOnERC721Received(
1540         address from,
1541         address to,
1542         uint256 tokenId,
1543         bytes memory _data
1544     ) private returns (bool) {
1545         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1546             bytes4 retval
1547         ) {
1548             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1549         } catch (bytes memory reason) {
1550             if (reason.length == 0) {
1551                 revert TransferToNonERC721ReceiverImplementer();
1552             } else {
1553                 assembly {
1554                     revert(add(32, reason), mload(reason))
1555                 }
1556             }
1557         }
1558     }
1559 
1560     /**
1561      * @dev Directly sets the extra data for the ownership data `index`.
1562      */
1563     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1564         uint256 packed = _packedOwnerships[index];
1565         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1566         uint256 extraDataCasted;
1567         // Cast `extraData` with assembly to avoid redundant masking.
1568         assembly {
1569             extraDataCasted := extraData
1570         }
1571         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1572         _packedOwnerships[index] = packed;
1573     }
1574 
1575     /**
1576      * @dev Returns the next extra data for the packed ownership data.
1577      * The returned result is shifted into position.
1578      */
1579     function _nextExtraData(
1580         address from,
1581         address to,
1582         uint256 prevOwnershipPacked
1583     ) private view returns (uint256) {
1584         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1585         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1586     }
1587 
1588     /**
1589      * @dev Called during each token transfer to set the 24bit `extraData` field.
1590      * Intended to be overridden by the cosumer contract.
1591      *
1592      * `previousExtraData` - the value of `extraData` before transfer.
1593      *
1594      * Calling conditions:
1595      *
1596      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1597      * transferred to `to`.
1598      * - When `from` is zero, `tokenId` will be minted for `to`.
1599      * - When `to` is zero, `tokenId` will be burned by `from`.
1600      * - `from` and `to` are never both zero.
1601      */
1602     function _extraData(
1603         address from,
1604         address to,
1605         uint24 previousExtraData
1606     ) internal view virtual returns (uint24) {}
1607 
1608     /**
1609      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1610      * This includes minting.
1611      * And also called before burning one token.
1612      *
1613      * startTokenId - the first token id to be transferred
1614      * quantity - the amount to be transferred
1615      *
1616      * Calling conditions:
1617      *
1618      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1619      * transferred to `to`.
1620      * - When `from` is zero, `tokenId` will be minted for `to`.
1621      * - When `to` is zero, `tokenId` will be burned by `from`.
1622      * - `from` and `to` are never both zero.
1623      */
1624     function _beforeTokenTransfers(
1625         address from,
1626         address to,
1627         uint256 startTokenId,
1628         uint256 quantity
1629     ) internal virtual {}
1630 
1631     /**
1632      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1633      * This includes minting.
1634      * And also called after one token has been burned.
1635      *
1636      * startTokenId - the first token id to be transferred
1637      * quantity - the amount to be transferred
1638      *
1639      * Calling conditions:
1640      *
1641      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1642      * transferred to `to`.
1643      * - When `from` is zero, `tokenId` has been minted for `to`.
1644      * - When `to` is zero, `tokenId` has been burned by `from`.
1645      * - `from` and `to` are never both zero.
1646      */
1647     function _afterTokenTransfers(
1648         address from,
1649         address to,
1650         uint256 startTokenId,
1651         uint256 quantity
1652     ) internal virtual {}
1653 
1654     /**
1655      * @dev Returns the message sender (defaults to `msg.sender`).
1656      *
1657      * If you are writing GSN compatible contracts, you need to override this function.
1658      */
1659     function _msgSenderERC721A() internal view virtual returns (address) {
1660         return msg.sender;
1661     }
1662 
1663     /**
1664      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1665      */
1666     function _toString(uint256 value) internal pure returns (string memory ptr) {
1667         assembly {
1668             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1669             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1670             // We will need 1 32-byte word to store the length,
1671             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1672             ptr := add(mload(0x40), 128)
1673             // Update the free memory pointer to allocate.
1674             mstore(0x40, ptr)
1675 
1676             // Cache the end of the memory to calculate the length later.
1677             let end := ptr
1678 
1679             // We write the string from the rightmost digit to the leftmost digit.
1680             // The following is essentially a do-while loop that also handles the zero case.
1681             // Costs a bit more than early returning for the zero case,
1682             // but cheaper in terms of deployment and overall runtime costs.
1683             for {
1684                 // Initialize and perform the first pass without check.
1685                 let temp := value
1686                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1687                 ptr := sub(ptr, 1)
1688                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1689                 mstore8(ptr, add(48, mod(temp, 10)))
1690                 temp := div(temp, 10)
1691             } temp {
1692                 // Keep dividing `temp` until zero.
1693                 temp := div(temp, 10)
1694             } {
1695                 // Body of the for loop.
1696                 ptr := sub(ptr, 1)
1697                 mstore8(ptr, add(48, mod(temp, 10)))
1698             }
1699 
1700             let length := sub(end, ptr)
1701             // Move the pointer 32 bytes leftwards to make room for the length.
1702             ptr := sub(ptr, 32)
1703             // Store the length.
1704             mstore(ptr, length)
1705         }
1706     }
1707 }
1708 
1709 
1710 
1711 pragma solidity ^0.8.0;
1712 
1713 
1714 
1715 
1716 
1717 
1718 contract Queen is ERC721A, Ownable, ReentrancyGuard {
1719   using Address for address;
1720   using Strings for uint;
1721 
1722   string  public  baseTokenURI = "ipfs://QmaeEV1MJ4JhN2894jCdYjefMakLSZAc4usiHcDeBYmSYK/";
1723 
1724   uint256 public  maxSupply = 9600;
1725   uint256 public  MAX_MINTS_PER_TX = 100;
1726   uint256 public  FREE_MINTS_PER_TX = 100;
1727   uint256 public  PUBLIC_SALE_PRICE = 0.001 ether;
1728   uint256 public  TOTAL_FREE_MINTS = 0;
1729   bool public isPublicSaleActive = true;
1730 
1731   constructor() ERC721A("Elizabeth II NFT", "QUEEN") {
1732 
1733   }
1734 
1735   function mint(uint256 numberOfTokens)
1736       external
1737       payable
1738   {
1739     require(isPublicSaleActive, "Public sale is not open");
1740     require(
1741       totalSupply() + numberOfTokens <= maxSupply,
1742       "Maximum supply exceeded"
1743     );
1744     if(totalSupply() + numberOfTokens > TOTAL_FREE_MINTS || numberOfTokens > FREE_MINTS_PER_TX){
1745         require(
1746             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1747             "Incorrect ETH value sent"
1748         );
1749     }
1750     _safeMint(msg.sender, numberOfTokens);
1751   }
1752 
1753   function setBaseURI(string memory baseURI)
1754     public
1755     onlyOwner
1756   {
1757     baseTokenURI = baseURI;
1758   }
1759 
1760   function _startTokenId() internal view virtual override returns (uint256) {
1761         return 1;
1762     }
1763 
1764   function treasuryMint(uint quantity, address user)
1765     public
1766     onlyOwner
1767   {
1768     require(
1769       quantity > 0,
1770       "Invalid mint amount"
1771     );
1772     require(
1773       totalSupply() + quantity <= maxSupply,
1774       "Maximum supply exceeded"
1775     );
1776     _safeMint(user, quantity);
1777   }
1778 
1779   function withdraw()
1780     public
1781     onlyOwner
1782     nonReentrant
1783   {
1784     Address.sendValue(payable(msg.sender), address(this).balance);
1785   }
1786 
1787   function tokenURI(uint _tokenId)
1788     public
1789     view
1790     virtual
1791     override
1792     returns (string memory)
1793   {
1794     require(
1795       _exists(_tokenId),
1796       "ERC721Metadata: URI query for nonexistent token"
1797     );
1798     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1799   }
1800 
1801   function _baseURI()
1802     internal
1803     view
1804     virtual
1805     override
1806     returns (string memory)
1807   {
1808     return baseTokenURI;
1809   }
1810 
1811   function setIsPublicSaleActive(bool _isPublicSaleActive)
1812       external
1813       onlyOwner
1814   {
1815       isPublicSaleActive = _isPublicSaleActive;
1816   }
1817 
1818   function setNumFreeMints(uint256 _numfreemints)
1819       external
1820       onlyOwner
1821   {
1822       TOTAL_FREE_MINTS = _numfreemints;
1823   }
1824 
1825   function setSalePrice(uint256 _price)
1826       external
1827       onlyOwner
1828   {
1829       PUBLIC_SALE_PRICE = _price;
1830   }
1831 
1832   function setMaxLimitPerTransaction(uint256 _limit)
1833       external
1834       onlyOwner
1835   {
1836       MAX_MINTS_PER_TX = _limit;
1837   }
1838 
1839 }