1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
70 }
71 
72 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Contract module that helps prevent reentrant calls to a function.
81  *
82  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
83  * available, which can be applied to functions to make sure there are no nested
84  * (reentrant) calls to them.
85  *
86  * Note that because there is a single `nonReentrant` guard, functions marked as
87  * `nonReentrant` may not call one another. This can be worked around by making
88  * those functions `private`, and then adding `external` `nonReentrant` entry
89  * points to them.
90  *
91  * TIP: If you would like to learn more about reentrancy and alternative ways
92  * to protect against it, check out our blog post
93  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
94  */
95 abstract contract ReentrancyGuard {
96     // Booleans are more expensive than uint256 or any type that takes up a full
97     // word because each write operation emits an extra SLOAD to first read the
98     // slot's contents, replace the bits taken up by the boolean, and then write
99     // back. This is the compiler's defense against contract upgrades and
100     // pointer aliasing, and it cannot be disabled.
101 
102     // The values being non-zero value makes deployment a bit more expensive,
103     // but in exchange the refund on every call to nonReentrant will be lower in
104     // amount. Since refunds are capped to a percentage of the total
105     // transaction's gas, it is best to keep them low in cases like this one, to
106     // increase the likelihood of the full refund coming into effect.
107     uint256 private constant _NOT_ENTERED = 1;
108     uint256 private constant _ENTERED = 2;
109 
110     uint256 private _status;
111 
112     constructor() {
113         _status = _NOT_ENTERED;
114     }
115 
116     /**
117      * @dev Prevents a contract from calling itself, directly or indirectly.
118      * Calling a `nonReentrant` function from another `nonReentrant`
119      * function is not supported. It is possible to prevent this from happening
120      * by making the `nonReentrant` function external, and making it call a
121      * `private` function that does the actual work.
122      */
123     modifier nonReentrant() {
124         // On the first call to nonReentrant, _notEntered will be true
125         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
126 
127         // Any calls to nonReentrant after this point will fail
128         _status = _ENTERED;
129 
130         _;
131 
132         // By storing the original value once again, a refund is triggered (see
133         // https://eips.ethereum.org/EIPS/eip-2200)
134         _status = _NOT_ENTERED;
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Address.sol
139 
140 
141 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
142 
143 pragma solidity ^0.8.1;
144 
145 /**
146  * @dev Collection of functions related to the address type
147  */
148 library Address {
149     /**
150      * @dev Returns true if `account` is a contract.
151      *
152      * [IMPORTANT]
153      * ====
154      * It is unsafe to assume that an address for which this function returns
155      * false is an externally-owned account (EOA) and not a contract.
156      *
157      * Among others, `isContract` will return false for the following
158      * types of addresses:
159      *
160      *  - an externally-owned account
161      *  - a contract in construction
162      *  - an address where a contract will be created
163      *  - an address where a contract lived, but was destroyed
164      * ====
165      *
166      * [IMPORTANT]
167      * ====
168      * You shouldn't rely on `isContract` to protect against flash loan attacks!
169      *
170      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
171      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
172      * constructor.
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // This method relies on extcodesize/address.code.length, which returns 0
177         // for contracts in construction, since the code is only stored at the end
178         // of the constructor execution.
179 
180         return account.code.length > 0;
181     }
182 
183     /**
184      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
185      * `recipient`, forwarding all available gas and reverting on errors.
186      *
187      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
188      * of certain opcodes, possibly making contracts go over the 2300 gas limit
189      * imposed by `transfer`, making them unable to receive funds via
190      * `transfer`. {sendValue} removes this limitation.
191      *
192      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
193      *
194      * IMPORTANT: because control is transferred to `recipient`, care must be
195      * taken to not create reentrancy vulnerabilities. Consider using
196      * {ReentrancyGuard} or the
197      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
198      */
199     function sendValue(address payable recipient, uint256 amount) internal {
200         require(address(this).balance >= amount, "Address: insufficient balance");
201 
202         (bool success, ) = recipient.call{value: amount}("");
203         require(success, "Address: unable to send value, recipient may have reverted");
204     }
205 
206     /**
207      * @dev Performs a Solidity function call using a low level `call`. A
208      * plain `call` is an unsafe replacement for a function call: use this
209      * function instead.
210      *
211      * If `target` reverts with a revert reason, it is bubbled up by this
212      * function (like regular Solidity function calls).
213      *
214      * Returns the raw returned data. To convert to the expected return value,
215      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
216      *
217      * Requirements:
218      *
219      * - `target` must be a contract.
220      * - calling `target` with `data` must not revert.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionCall(target, data, "Address: low-level call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
230      * `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, 0, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but also transferring `value` wei to `target`.
245      *
246      * Requirements:
247      *
248      * - the calling contract must have an ETH balance of at least `value`.
249      * - the called Solidity function must be `payable`.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value
257     ) internal returns (bytes memory) {
258         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
263      * with `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(address(this).balance >= value, "Address: insufficient balance for call");
274         require(isContract(target), "Address: call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.call{value: value}(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
287         return functionStaticCall(target, data, "Address: low-level static call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a static call.
293      *
294      * _Available since v3.3._
295      */
296     function functionStaticCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal view returns (bytes memory) {
301         require(isContract(target), "Address: static call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.staticcall(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but performing a delegate call.
310      *
311      * _Available since v3.4._
312      */
313     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
319      * but performing a delegate call.
320      *
321      * _Available since v3.4._
322      */
323     function functionDelegateCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(isContract(target), "Address: delegate call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.delegatecall(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
336      * revert reason using the provided one.
337      *
338      * _Available since v4.3._
339      */
340     function verifyCallResult(
341         bool success,
342         bytes memory returndata,
343         string memory errorMessage
344     ) internal pure returns (bytes memory) {
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 assembly {
353                     let returndata_size := mload(returndata)
354                     revert(add(32, returndata), returndata_size)
355                 }
356             } else {
357                 revert(errorMessage);
358             }
359         }
360     }
361 }
362 
363 // File: @openzeppelin/contracts/utils/Context.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Provides information about the current execution context, including the
372  * sender of the transaction and its data. While these are generally available
373  * via msg.sender and msg.data, they should not be accessed in such a direct
374  * manner, since when dealing with meta-transactions the account sending and
375  * paying for execution may not be the actual sender (as far as an application
376  * is concerned).
377  *
378  * This contract is only required for intermediate, library-like contracts.
379  */
380 abstract contract Context {
381     function _msgSender() internal view virtual returns (address) {
382         return msg.sender;
383     }
384 
385     function _msgData() internal view virtual returns (bytes calldata) {
386         return msg.data;
387     }
388 }
389 
390 // File: @openzeppelin/contracts/access/Ownable.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev Contract module which provides a basic access control mechanism, where
400  * there is an account (an owner) that can be granted exclusive access to
401  * specific functions.
402  *
403  * By default, the owner account will be the one that deploys the contract. This
404  * can later be changed with {transferOwnership}.
405  *
406  * This module is used through inheritance. It will make available the modifier
407  * `onlyOwner`, which can be applied to your functions to restrict their use to
408  * the owner.
409  */
410 abstract contract Ownable is Context {
411     address private _owner;
412 
413     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
414 
415     /**
416      * @dev Initializes the contract setting the deployer as the initial owner.
417      */
418     constructor() {
419         _transferOwnership(_msgSender());
420     }
421 
422     /**
423      * @dev Returns the address of the current owner.
424      */
425     function owner() public view virtual returns (address) {
426         return _owner;
427     }
428 
429     /**
430      * @dev Throws if called by any account other than the owner.
431      */
432     modifier onlyOwner() {
433         require(owner() == _msgSender(), "Ownable: caller is not the owner");
434         _;
435     }
436 
437     /**
438      * @dev Leaves the contract without owner. It will not be possible to call
439      * `onlyOwner` functions anymore. Can only be called by the current owner.
440      *
441      * NOTE: Renouncing ownership will leave the contract without an owner,
442      * thereby removing any functionality that is only available to the owner.
443      */
444     function renounceOwnership() public virtual onlyOwner {
445         _transferOwnership(address(0));
446     }
447 
448     /**
449      * @dev Transfers ownership of the contract to a new account (`newOwner`).
450      * Can only be called by the current owner.
451      */
452     function transferOwnership(address newOwner) public virtual onlyOwner {
453         require(newOwner != address(0), "Ownable: new owner is the zero address");
454         _transferOwnership(newOwner);
455     }
456 
457     /**
458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
459      * Internal function without access restriction.
460      */
461     function _transferOwnership(address newOwner) internal virtual {
462         address oldOwner = _owner;
463         _owner = newOwner;
464         emit OwnershipTransferred(oldOwner, newOwner);
465     }
466 }
467 
468 // File: erc721a/contracts/IERC721A.sol
469 
470 
471 // ERC721A Contracts v4.1.0
472 // Creator: Chiru Labs
473 
474 pragma solidity ^0.8.4;
475 
476 /**
477  * @dev Interface of an ERC721A compliant contract.
478  */
479 interface IERC721A {
480     /**
481      * The caller must own the token or be an approved operator.
482      */
483     error ApprovalCallerNotOwnerNorApproved();
484 
485     /**
486      * The token does not exist.
487      */
488     error ApprovalQueryForNonexistentToken();
489 
490     /**
491      * The caller cannot approve to their own address.
492      */
493     error ApproveToCaller();
494 
495     /**
496      * Cannot query the balance for the zero address.
497      */
498     error BalanceQueryForZeroAddress();
499 
500     /**
501      * Cannot mint to the zero address.
502      */
503     error MintToZeroAddress();
504 
505     /**
506      * The quantity of tokens minted must be more than zero.
507      */
508     error MintZeroQuantity();
509 
510     /**
511      * The token does not exist.
512      */
513     error OwnerQueryForNonexistentToken();
514 
515     /**
516      * The caller must own the token or be an approved operator.
517      */
518     error TransferCallerNotOwnerNorApproved();
519 
520     /**
521      * The token must be owned by `from`.
522      */
523     error TransferFromIncorrectOwner();
524 
525     /**
526      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
527      */
528     error TransferToNonERC721ReceiverImplementer();
529 
530     /**
531      * Cannot transfer to the zero address.
532      */
533     error TransferToZeroAddress();
534 
535     /**
536      * The token does not exist.
537      */
538     error URIQueryForNonexistentToken();
539 
540     /**
541      * The `quantity` minted with ERC2309 exceeds the safety limit.
542      */
543     error MintERC2309QuantityExceedsLimit();
544 
545     /**
546      * The `extraData` cannot be set on an unintialized ownership slot.
547      */
548     error OwnershipNotInitializedForExtraData();
549 
550     struct TokenOwnership {
551         // The address of the owner.
552         address addr;
553         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
554         uint64 startTimestamp;
555         // Whether the token has been burned.
556         bool burned;
557         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
558         uint24 extraData;
559     }
560 
561     /**
562      * @dev Returns the total amount of tokens stored by the contract.
563      *
564      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
565      */
566     function totalSupply() external view returns (uint256);
567 
568     // ==============================
569     //            IERC165
570     // ==============================
571 
572     /**
573      * @dev Returns true if this contract implements the interface defined by
574      * `interfaceId`. See the corresponding
575      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
576      * to learn more about how these ids are created.
577      *
578      * This function call must use less than 30 000 gas.
579      */
580     function supportsInterface(bytes4 interfaceId) external view returns (bool);
581 
582     // ==============================
583     //            IERC721
584     // ==============================
585 
586     /**
587      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
588      */
589     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
590 
591     /**
592      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
593      */
594     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
595 
596     /**
597      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
598      */
599     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
600 
601     /**
602      * @dev Returns the number of tokens in ``owner``'s account.
603      */
604     function balanceOf(address owner) external view returns (uint256 balance);
605 
606     /**
607      * @dev Returns the owner of the `tokenId` token.
608      *
609      * Requirements:
610      *
611      * - `tokenId` must exist.
612      */
613     function ownerOf(uint256 tokenId) external view returns (address owner);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes calldata data
633     ) external;
634 
635     /**
636      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
637      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
638      *
639      * Requirements:
640      *
641      * - `from` cannot be the zero address.
642      * - `to` cannot be the zero address.
643      * - `tokenId` token must exist and be owned by `from`.
644      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
645      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
646      *
647      * Emits a {Transfer} event.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) external;
654 
655     /**
656      * @dev Transfers `tokenId` token from `from` to `to`.
657      *
658      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must be owned by `from`.
665      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
666      *
667      * Emits a {Transfer} event.
668      */
669     function transferFrom(
670         address from,
671         address to,
672         uint256 tokenId
673     ) external;
674 
675     /**
676      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
677      * The approval is cleared when the token is transferred.
678      *
679      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
680      *
681      * Requirements:
682      *
683      * - The caller must own the token or be an approved operator.
684      * - `tokenId` must exist.
685      *
686      * Emits an {Approval} event.
687      */
688     function approve(address to, uint256 tokenId) external;
689 
690     /**
691      * @dev Approve or remove `operator` as an operator for the caller.
692      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
693      *
694      * Requirements:
695      *
696      * - The `operator` cannot be the caller.
697      *
698      * Emits an {ApprovalForAll} event.
699      */
700     function setApprovalForAll(address operator, bool _approved) external;
701 
702     /**
703      * @dev Returns the account approved for `tokenId` token.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      */
709     function getApproved(uint256 tokenId) external view returns (address operator);
710 
711     /**
712      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
713      *
714      * See {setApprovalForAll}
715      */
716     function isApprovedForAll(address owner, address operator) external view returns (bool);
717 
718     // ==============================
719     //        IERC721Metadata
720     // ==============================
721 
722     /**
723      * @dev Returns the token collection name.
724      */
725     function name() external view returns (string memory);
726 
727     /**
728      * @dev Returns the token collection symbol.
729      */
730     function symbol() external view returns (string memory);
731 
732     /**
733      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
734      */
735     function tokenURI(uint256 tokenId) external view returns (string memory);
736 
737     // ==============================
738     //            IERC2309
739     // ==============================
740 
741     /**
742      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
743      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
744      */
745     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
746 }
747 
748 // File: erc721a/contracts/ERC721A.sol
749 
750 
751 // ERC721A Contracts v4.1.0
752 // Creator: Chiru Labs
753 
754 pragma solidity ^0.8.4;
755 
756 
757 /**
758  * @dev ERC721 token receiver interface.
759  */
760 interface ERC721A__IERC721Receiver {
761     function onERC721Received(
762         address operator,
763         address from,
764         uint256 tokenId,
765         bytes calldata data
766     ) external returns (bytes4);
767 }
768 
769 /**
770  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
771  * including the Metadata extension. Built to optimize for lower gas during batch mints.
772  *
773  * Assumes serials are sequentially minted starting at `_startTokenId()`
774  * (defaults to 0, e.g. 0, 1, 2, 3..).
775  *
776  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
777  *
778  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
779  */
780 contract ERC721A is IERC721A {
781     // Mask of an entry in packed address data.
782     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
783 
784     // The bit position of `numberMinted` in packed address data.
785     uint256 private constant BITPOS_NUMBER_MINTED = 64;
786 
787     // The bit position of `numberBurned` in packed address data.
788     uint256 private constant BITPOS_NUMBER_BURNED = 128;
789 
790     // The bit position of `aux` in packed address data.
791     uint256 private constant BITPOS_AUX = 192;
792 
793     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
794     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
795 
796     // The bit position of `startTimestamp` in packed ownership.
797     uint256 private constant BITPOS_START_TIMESTAMP = 160;
798 
799     // The bit mask of the `burned` bit in packed ownership.
800     uint256 private constant BITMASK_BURNED = 1 << 224;
801 
802     // The bit position of the `nextInitialized` bit in packed ownership.
803     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
804 
805     // The bit mask of the `nextInitialized` bit in packed ownership.
806     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
807 
808     // The bit position of `extraData` in packed ownership.
809     uint256 private constant BITPOS_EXTRA_DATA = 232;
810 
811     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
812     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
813 
814     // The mask of the lower 160 bits for addresses.
815     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
816 
817     // The maximum `quantity` that can be minted with `_mintERC2309`.
818     // This limit is to prevent overflows on the address data entries.
819     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
820     // is required to cause an overflow, which is unrealistic.
821     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
822 
823     // The tokenId of the next token to be minted.
824     uint256 private _currentIndex;
825 
826     // The number of tokens burned.
827     uint256 private _burnCounter;
828 
829     // Token name
830     string private _name;
831 
832     // Token symbol
833     string private _symbol;
834 
835     // Mapping from token ID to ownership details
836     // An empty struct value does not necessarily mean the token is unowned.
837     // See `_packedOwnershipOf` implementation for details.
838     //
839     // Bits Layout:
840     // - [0..159]   `addr`
841     // - [160..223] `startTimestamp`
842     // - [224]      `burned`
843     // - [225]      `nextInitialized`
844     // - [232..255] `extraData`
845     mapping(uint256 => uint256) private _packedOwnerships;
846 
847     // Mapping owner address to address data.
848     //
849     // Bits Layout:
850     // - [0..63]    `balance`
851     // - [64..127]  `numberMinted`
852     // - [128..191] `numberBurned`
853     // - [192..255] `aux`
854     mapping(address => uint256) private _packedAddressData;
855 
856     // Mapping from token ID to approved address.
857     mapping(uint256 => address) private _tokenApprovals;
858 
859     // Mapping from owner to operator approvals
860     mapping(address => mapping(address => bool)) private _operatorApprovals;
861 
862     constructor(string memory name_, string memory symbol_) {
863         _name = name_;
864         _symbol = symbol_;
865         _currentIndex = _startTokenId();
866     }
867 
868     /**
869      * @dev Returns the starting token ID.
870      * To change the starting token ID, please override this function.
871      */
872     function _startTokenId() internal view virtual returns (uint256) {
873         return 0;
874     }
875 
876     /**
877      * @dev Returns the next token ID to be minted.
878      */
879     function _nextTokenId() internal view returns (uint256) {
880         return _currentIndex;
881     }
882 
883     /**
884      * @dev Returns the total number of tokens in existence.
885      * Burned tokens will reduce the count.
886      * To get the total number of tokens minted, please see `_totalMinted`.
887      */
888     function totalSupply() public view override returns (uint256) {
889         // Counter underflow is impossible as _burnCounter cannot be incremented
890         // more than `_currentIndex - _startTokenId()` times.
891         unchecked {
892             return _currentIndex - _burnCounter - _startTokenId();
893         }
894     }
895 
896     /**
897      * @dev Returns the total amount of tokens minted in the contract.
898      */
899     function _totalMinted() internal view returns (uint256) {
900         // Counter underflow is impossible as _currentIndex does not decrement,
901         // and it is initialized to `_startTokenId()`
902         unchecked {
903             return _currentIndex - _startTokenId();
904         }
905     }
906 
907     /**
908      * @dev Returns the total number of tokens burned.
909      */
910     function _totalBurned() internal view returns (uint256) {
911         return _burnCounter;
912     }
913 
914     /**
915      * @dev See {IERC165-supportsInterface}.
916      */
917     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
918         // The interface IDs are constants representing the first 4 bytes of the XOR of
919         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
920         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
921         return
922             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
923             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
924             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
925     }
926 
927     /**
928      * @dev See {IERC721-balanceOf}.
929      */
930     function balanceOf(address owner) public view override returns (uint256) {
931         if (owner == address(0)) revert BalanceQueryForZeroAddress();
932         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
933     }
934 
935     /**
936      * Returns the number of tokens minted by `owner`.
937      */
938     function _numberMinted(address owner) internal view returns (uint256) {
939         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
940     }
941 
942     /**
943      * Returns the number of tokens burned by or on behalf of `owner`.
944      */
945     function _numberBurned(address owner) internal view returns (uint256) {
946         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
947     }
948 
949     /**
950      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
951      */
952     function _getAux(address owner) internal view returns (uint64) {
953         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
954     }
955 
956     /**
957      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
958      * If there are multiple variables, please pack them into a uint64.
959      */
960     function _setAux(address owner, uint64 aux) internal {
961         uint256 packed = _packedAddressData[owner];
962         uint256 auxCasted;
963         // Cast `aux` with assembly to avoid redundant masking.
964         assembly {
965             auxCasted := aux
966         }
967         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
968         _packedAddressData[owner] = packed;
969     }
970 
971     /**
972      * Returns the packed ownership data of `tokenId`.
973      */
974     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
975         uint256 curr = tokenId;
976 
977         unchecked {
978             if (_startTokenId() <= curr)
979                 if (curr < _currentIndex) {
980                     uint256 packed = _packedOwnerships[curr];
981                     // If not burned.
982                     if (packed & BITMASK_BURNED == 0) {
983                         // Invariant:
984                         // There will always be an ownership that has an address and is not burned
985                         // before an ownership that does not have an address and is not burned.
986                         // Hence, curr will not underflow.
987                         //
988                         // We can directly compare the packed value.
989                         // If the address is zero, packed is zero.
990                         while (packed == 0) {
991                             packed = _packedOwnerships[--curr];
992                         }
993                         return packed;
994                     }
995                 }
996         }
997         revert OwnerQueryForNonexistentToken();
998     }
999 
1000     /**
1001      * Returns the unpacked `TokenOwnership` struct from `packed`.
1002      */
1003     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1004         ownership.addr = address(uint160(packed));
1005         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1006         ownership.burned = packed & BITMASK_BURNED != 0;
1007         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1008     }
1009 
1010     /**
1011      * Returns the unpacked `TokenOwnership` struct at `index`.
1012      */
1013     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1014         return _unpackedOwnership(_packedOwnerships[index]);
1015     }
1016 
1017     /**
1018      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1019      */
1020     function _initializeOwnershipAt(uint256 index) internal {
1021         if (_packedOwnerships[index] == 0) {
1022             _packedOwnerships[index] = _packedOwnershipOf(index);
1023         }
1024     }
1025 
1026     /**
1027      * Gas spent here starts off proportional to the maximum mint batch size.
1028      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1029      */
1030     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1031         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1032     }
1033 
1034     /**
1035      * @dev Packs ownership data into a single uint256.
1036      */
1037     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1038         assembly {
1039             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1040             owner := and(owner, BITMASK_ADDRESS)
1041             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1042             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1043         }
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-ownerOf}.
1048      */
1049     function ownerOf(uint256 tokenId) public view override returns (address) {
1050         return address(uint160(_packedOwnershipOf(tokenId)));
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Metadata-name}.
1055      */
1056     function name() public view virtual override returns (string memory) {
1057         return _name;
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Metadata-symbol}.
1062      */
1063     function symbol() public view virtual override returns (string memory) {
1064         return _symbol;
1065     }
1066 
1067     /**
1068      * @dev See {IERC721Metadata-tokenURI}.
1069      */
1070     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1071         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1072 
1073         string memory baseURI = _baseURI();
1074         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1075     }
1076 
1077     /**
1078      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1079      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1080      * by default, it can be overridden in child contracts.
1081      */
1082     function _baseURI() internal view virtual returns (string memory) {
1083         return '';
1084     }
1085 
1086     /**
1087      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1088      */
1089     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1090         // For branchless setting of the `nextInitialized` flag.
1091         assembly {
1092             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1093             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1094         }
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-approve}.
1099      */
1100     function approve(address to, uint256 tokenId) public override {
1101         address owner = ownerOf(tokenId);
1102 
1103         if (_msgSenderERC721A() != owner)
1104             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1105                 revert ApprovalCallerNotOwnerNorApproved();
1106             }
1107 
1108         _tokenApprovals[tokenId] = to;
1109         emit Approval(owner, to, tokenId);
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-getApproved}.
1114      */
1115     function getApproved(uint256 tokenId) public view override returns (address) {
1116         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1117 
1118         return _tokenApprovals[tokenId];
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-setApprovalForAll}.
1123      */
1124     function setApprovalForAll(address operator, bool approved) public virtual override {
1125         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1126 
1127         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1128         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-isApprovedForAll}.
1133      */
1134     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1135         return _operatorApprovals[owner][operator];
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-safeTransferFrom}.
1140      */
1141     function safeTransferFrom(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) public virtual override {
1146         safeTransferFrom(from, to, tokenId, '');
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-safeTransferFrom}.
1151      */
1152     function safeTransferFrom(
1153         address from,
1154         address to,
1155         uint256 tokenId,
1156         bytes memory _data
1157     ) public virtual override {
1158         transferFrom(from, to, tokenId);
1159         if (to.code.length != 0)
1160             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1161                 revert TransferToNonERC721ReceiverImplementer();
1162             }
1163     }
1164 
1165     /**
1166      * @dev Returns whether `tokenId` exists.
1167      *
1168      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1169      *
1170      * Tokens start existing when they are minted (`_mint`),
1171      */
1172     function _exists(uint256 tokenId) internal view returns (bool) {
1173         return
1174             _startTokenId() <= tokenId &&
1175             tokenId < _currentIndex && // If within bounds,
1176             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1177     }
1178 
1179     /**
1180      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1181      */
1182     function _safeMint(address to, uint256 quantity) internal {
1183         _safeMint(to, quantity, '');
1184     }
1185 
1186     /**
1187      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1188      *
1189      * Requirements:
1190      *
1191      * - If `to` refers to a smart contract, it must implement
1192      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1193      * - `quantity` must be greater than 0.
1194      *
1195      * See {_mint}.
1196      *
1197      * Emits a {Transfer} event for each mint.
1198      */
1199     function _safeMint(
1200         address to,
1201         uint256 quantity,
1202         bytes memory _data
1203     ) internal {
1204         _mint(to, quantity);
1205 
1206         unchecked {
1207             if (to.code.length != 0) {
1208                 uint256 end = _currentIndex;
1209                 uint256 index = end - quantity;
1210                 do {
1211                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1212                         revert TransferToNonERC721ReceiverImplementer();
1213                     }
1214                 } while (index < end);
1215                 // Reentrancy protection.
1216                 if (_currentIndex != end) revert();
1217             }
1218         }
1219     }
1220 
1221     /**
1222      * @dev Mints `quantity` tokens and transfers them to `to`.
1223      *
1224      * Requirements:
1225      *
1226      * - `to` cannot be the zero address.
1227      * - `quantity` must be greater than 0.
1228      *
1229      * Emits a {Transfer} event for each mint.
1230      */
1231     function _mint(address to, uint256 quantity) internal {
1232         uint256 startTokenId = _currentIndex;
1233         if (to == address(0)) revert MintToZeroAddress();
1234         if (quantity == 0) revert MintZeroQuantity();
1235 
1236         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1237 
1238         // Overflows are incredibly unrealistic.
1239         // `balance` and `numberMinted` have a maximum limit of 2**64.
1240         // `tokenId` has a maximum limit of 2**256.
1241         unchecked {
1242             // Updates:
1243             // - `balance += quantity`.
1244             // - `numberMinted += quantity`.
1245             //
1246             // We can directly add to the `balance` and `numberMinted`.
1247             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1248 
1249             // Updates:
1250             // - `address` to the owner.
1251             // - `startTimestamp` to the timestamp of minting.
1252             // - `burned` to `false`.
1253             // - `nextInitialized` to `quantity == 1`.
1254             _packedOwnerships[startTokenId] = _packOwnershipData(
1255                 to,
1256                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1257             );
1258 
1259             uint256 tokenId = startTokenId;
1260             uint256 end = startTokenId + quantity;
1261             do {
1262                 emit Transfer(address(0), to, tokenId++);
1263             } while (tokenId < end);
1264 
1265             _currentIndex = end;
1266         }
1267         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1268     }
1269 
1270     /**
1271      * @dev Mints `quantity` tokens and transfers them to `to`.
1272      *
1273      * This function is intended for efficient minting only during contract creation.
1274      *
1275      * It emits only one {ConsecutiveTransfer} as defined in
1276      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1277      * instead of a sequence of {Transfer} event(s).
1278      *
1279      * Calling this function outside of contract creation WILL make your contract
1280      * non-compliant with the ERC721 standard.
1281      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1282      * {ConsecutiveTransfer} event is only permissible during contract creation.
1283      *
1284      * Requirements:
1285      *
1286      * - `to` cannot be the zero address.
1287      * - `quantity` must be greater than 0.
1288      *
1289      * Emits a {ConsecutiveTransfer} event.
1290      */
1291     function _mintERC2309(address to, uint256 quantity) internal {
1292         uint256 startTokenId = _currentIndex;
1293         if (to == address(0)) revert MintToZeroAddress();
1294         if (quantity == 0) revert MintZeroQuantity();
1295         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1296 
1297         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1298 
1299         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1300         unchecked {
1301             // Updates:
1302             // - `balance += quantity`.
1303             // - `numberMinted += quantity`.
1304             //
1305             // We can directly add to the `balance` and `numberMinted`.
1306             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1307 
1308             // Updates:
1309             // - `address` to the owner.
1310             // - `startTimestamp` to the timestamp of minting.
1311             // - `burned` to `false`.
1312             // - `nextInitialized` to `quantity == 1`.
1313             _packedOwnerships[startTokenId] = _packOwnershipData(
1314                 to,
1315                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1316             );
1317 
1318             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1319 
1320             _currentIndex = startTokenId + quantity;
1321         }
1322         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1323     }
1324 
1325     /**
1326      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1327      */
1328     function _getApprovedAddress(uint256 tokenId)
1329         private
1330         view
1331         returns (uint256 approvedAddressSlot, address approvedAddress)
1332     {
1333         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1334         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1335         assembly {
1336             // Compute the slot.
1337             mstore(0x00, tokenId)
1338             mstore(0x20, tokenApprovalsPtr.slot)
1339             approvedAddressSlot := keccak256(0x00, 0x40)
1340             // Load the slot's value from storage.
1341             approvedAddress := sload(approvedAddressSlot)
1342         }
1343     }
1344 
1345     /**
1346      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1347      */
1348     function _isOwnerOrApproved(
1349         address approvedAddress,
1350         address from,
1351         address msgSender
1352     ) private pure returns (bool result) {
1353         assembly {
1354             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1355             from := and(from, BITMASK_ADDRESS)
1356             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1357             msgSender := and(msgSender, BITMASK_ADDRESS)
1358             // `msgSender == from || msgSender == approvedAddress`.
1359             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1360         }
1361     }
1362 
1363     /**
1364      * @dev Transfers `tokenId` from `from` to `to`.
1365      *
1366      * Requirements:
1367      *
1368      * - `to` cannot be the zero address.
1369      * - `tokenId` token must be owned by `from`.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function transferFrom(
1374         address from,
1375         address to,
1376         uint256 tokenId
1377     ) public virtual override {
1378         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1379 
1380         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1381 
1382         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1383 
1384         // The nested ifs save around 20+ gas over a compound boolean condition.
1385         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1386             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1387 
1388         if (to == address(0)) revert TransferToZeroAddress();
1389 
1390         _beforeTokenTransfers(from, to, tokenId, 1);
1391 
1392         // Clear approvals from the previous owner.
1393         assembly {
1394             if approvedAddress {
1395                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1396                 sstore(approvedAddressSlot, 0)
1397             }
1398         }
1399 
1400         // Underflow of the sender's balance is impossible because we check for
1401         // ownership above and the recipient's balance can't realistically overflow.
1402         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1403         unchecked {
1404             // We can directly increment and decrement the balances.
1405             --_packedAddressData[from]; // Updates: `balance -= 1`.
1406             ++_packedAddressData[to]; // Updates: `balance += 1`.
1407 
1408             // Updates:
1409             // - `address` to the next owner.
1410             // - `startTimestamp` to the timestamp of transfering.
1411             // - `burned` to `false`.
1412             // - `nextInitialized` to `true`.
1413             _packedOwnerships[tokenId] = _packOwnershipData(
1414                 to,
1415                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1416             );
1417 
1418             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1419             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1420                 uint256 nextTokenId = tokenId + 1;
1421                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1422                 if (_packedOwnerships[nextTokenId] == 0) {
1423                     // If the next slot is within bounds.
1424                     if (nextTokenId != _currentIndex) {
1425                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1426                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1427                     }
1428                 }
1429             }
1430         }
1431 
1432         emit Transfer(from, to, tokenId);
1433         _afterTokenTransfers(from, to, tokenId, 1);
1434     }
1435 
1436     /**
1437      * @dev Equivalent to `_burn(tokenId, false)`.
1438      */
1439     function _burn(uint256 tokenId) internal virtual {
1440         _burn(tokenId, false);
1441     }
1442 
1443     /**
1444      * @dev Destroys `tokenId`.
1445      * The approval is cleared when the token is burned.
1446      *
1447      * Requirements:
1448      *
1449      * - `tokenId` must exist.
1450      *
1451      * Emits a {Transfer} event.
1452      */
1453     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1454         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1455 
1456         address from = address(uint160(prevOwnershipPacked));
1457 
1458         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1459 
1460         if (approvalCheck) {
1461             // The nested ifs save around 20+ gas over a compound boolean condition.
1462             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1463                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1464         }
1465 
1466         _beforeTokenTransfers(from, address(0), tokenId, 1);
1467 
1468         // Clear approvals from the previous owner.
1469         assembly {
1470             if approvedAddress {
1471                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1472                 sstore(approvedAddressSlot, 0)
1473             }
1474         }
1475 
1476         // Underflow of the sender's balance is impossible because we check for
1477         // ownership above and the recipient's balance can't realistically overflow.
1478         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1479         unchecked {
1480             // Updates:
1481             // - `balance -= 1`.
1482             // - `numberBurned += 1`.
1483             //
1484             // We can directly decrement the balance, and increment the number burned.
1485             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1486             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1487 
1488             // Updates:
1489             // - `address` to the last owner.
1490             // - `startTimestamp` to the timestamp of burning.
1491             // - `burned` to `true`.
1492             // - `nextInitialized` to `true`.
1493             _packedOwnerships[tokenId] = _packOwnershipData(
1494                 from,
1495                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1496             );
1497 
1498             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1499             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1500                 uint256 nextTokenId = tokenId + 1;
1501                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1502                 if (_packedOwnerships[nextTokenId] == 0) {
1503                     // If the next slot is within bounds.
1504                     if (nextTokenId != _currentIndex) {
1505                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1506                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1507                     }
1508                 }
1509             }
1510         }
1511 
1512         emit Transfer(from, address(0), tokenId);
1513         _afterTokenTransfers(from, address(0), tokenId, 1);
1514 
1515         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1516         unchecked {
1517             _burnCounter++;
1518         }
1519     }
1520 
1521     /**
1522      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1523      *
1524      * @param from address representing the previous owner of the given token ID
1525      * @param to target address that will receive the tokens
1526      * @param tokenId uint256 ID of the token to be transferred
1527      * @param _data bytes optional data to send along with the call
1528      * @return bool whether the call correctly returned the expected magic value
1529      */
1530     function _checkContractOnERC721Received(
1531         address from,
1532         address to,
1533         uint256 tokenId,
1534         bytes memory _data
1535     ) private returns (bool) {
1536         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1537             bytes4 retval
1538         ) {
1539             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1540         } catch (bytes memory reason) {
1541             if (reason.length == 0) {
1542                 revert TransferToNonERC721ReceiverImplementer();
1543             } else {
1544                 assembly {
1545                     revert(add(32, reason), mload(reason))
1546                 }
1547             }
1548         }
1549     }
1550 
1551     /**
1552      * @dev Directly sets the extra data for the ownership data `index`.
1553      */
1554     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1555         uint256 packed = _packedOwnerships[index];
1556         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1557         uint256 extraDataCasted;
1558         // Cast `extraData` with assembly to avoid redundant masking.
1559         assembly {
1560             extraDataCasted := extraData
1561         }
1562         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1563         _packedOwnerships[index] = packed;
1564     }
1565 
1566     /**
1567      * @dev Returns the next extra data for the packed ownership data.
1568      * The returned result is shifted into position.
1569      */
1570     function _nextExtraData(
1571         address from,
1572         address to,
1573         uint256 prevOwnershipPacked
1574     ) private view returns (uint256) {
1575         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1576         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1577     }
1578 
1579     /**
1580      * @dev Called during each token transfer to set the 24bit `extraData` field.
1581      * Intended to be overridden by the cosumer contract.
1582      *
1583      * `previousExtraData` - the value of `extraData` before transfer.
1584      *
1585      * Calling conditions:
1586      *
1587      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1588      * transferred to `to`.
1589      * - When `from` is zero, `tokenId` will be minted for `to`.
1590      * - When `to` is zero, `tokenId` will be burned by `from`.
1591      * - `from` and `to` are never both zero.
1592      */
1593     function _extraData(
1594         address from,
1595         address to,
1596         uint24 previousExtraData
1597     ) internal view virtual returns (uint24) {}
1598 
1599     /**
1600      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1601      * This includes minting.
1602      * And also called before burning one token.
1603      *
1604      * startTokenId - the first token id to be transferred
1605      * quantity - the amount to be transferred
1606      *
1607      * Calling conditions:
1608      *
1609      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1610      * transferred to `to`.
1611      * - When `from` is zero, `tokenId` will be minted for `to`.
1612      * - When `to` is zero, `tokenId` will be burned by `from`.
1613      * - `from` and `to` are never both zero.
1614      */
1615     function _beforeTokenTransfers(
1616         address from,
1617         address to,
1618         uint256 startTokenId,
1619         uint256 quantity
1620     ) internal virtual {}
1621 
1622     /**
1623      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1624      * This includes minting.
1625      * And also called after one token has been burned.
1626      *
1627      * startTokenId - the first token id to be transferred
1628      * quantity - the amount to be transferred
1629      *
1630      * Calling conditions:
1631      *
1632      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1633      * transferred to `to`.
1634      * - When `from` is zero, `tokenId` has been minted for `to`.
1635      * - When `to` is zero, `tokenId` has been burned by `from`.
1636      * - `from` and `to` are never both zero.
1637      */
1638     function _afterTokenTransfers(
1639         address from,
1640         address to,
1641         uint256 startTokenId,
1642         uint256 quantity
1643     ) internal virtual {}
1644 
1645     /**
1646      * @dev Returns the message sender (defaults to `msg.sender`).
1647      *
1648      * If you are writing GSN compatible contracts, you need to override this function.
1649      */
1650     function _msgSenderERC721A() internal view virtual returns (address) {
1651         return msg.sender;
1652     }
1653 
1654     /**
1655      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1656      */
1657     function _toString(uint256 value) internal pure returns (string memory ptr) {
1658         assembly {
1659             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1660             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1661             // We will need 1 32-byte word to store the length,
1662             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1663             ptr := add(mload(0x40), 128)
1664             // Update the free memory pointer to allocate.
1665             mstore(0x40, ptr)
1666 
1667             // Cache the end of the memory to calculate the length later.
1668             let end := ptr
1669 
1670             // We write the string from the rightmost digit to the leftmost digit.
1671             // The following is essentially a do-while loop that also handles the zero case.
1672             // Costs a bit more than early returning for the zero case,
1673             // but cheaper in terms of deployment and overall runtime costs.
1674             for {
1675                 // Initialize and perform the first pass without check.
1676                 let temp := value
1677                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1678                 ptr := sub(ptr, 1)
1679                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1680                 mstore8(ptr, add(48, mod(temp, 10)))
1681                 temp := div(temp, 10)
1682             } temp {
1683                 // Keep dividing `temp` until zero.
1684                 temp := div(temp, 10)
1685             } {
1686                 // Body of the for loop.
1687                 ptr := sub(ptr, 1)
1688                 mstore8(ptr, add(48, mod(temp, 10)))
1689             }
1690 
1691             let length := sub(end, ptr)
1692             // Move the pointer 32 bytes leftwards to make room for the length.
1693             ptr := sub(ptr, 32)
1694             // Store the length.
1695             mstore(ptr, length)
1696         }
1697     }
1698 }
1699 
1700 // File: contracts/OWSCv2.sol
1701 
1702 
1703 pragma solidity ^0.8.11;
1704 
1705 /////////////////////////////////////////////////////////////////////////////////
1706 //╭━━━┳━╮╱╭┳━━━╮╭╮╭╮╭┳━━━┳━━━┳╮╱╱╭━━━╮╭━━━┳━━━┳━━━┳━━┳━━━┳╮╱╱╱╭━━━┳╮╱╱╭╮╱╭┳━━╮///
1707 //┃╭━╮┃┃╰╮┃┃╭━━╯┃┃┃┃┃┃╭━╮┃╭━╮┃┃╱╱╰╮╭╮┃┃╭━╮┃╭━╮┃╭━╮┣┫┣┫╭━╮┃┃╱╱╱┃╭━╮┃┃╱╱┃┃╱┃┃╭╮┃///
1708 //┃┃╱┃┃╭╮╰╯┃╰━━╮┃┃┃┃┃┃┃╱┃┃╰━╯┃┃╱╱╱┃┃┃┃┃╰━━┫┃╱┃┃┃╱╰╯┃┃┃┃╱┃┃┃╱╱╱┃┃╱╰┫┃╱╱┃┃╱┃┃╰╯╰╮//
1709 //┃┃╱┃┃┃╰╮┃┃╭━━╯┃╰╯╰╯┃┃╱┃┃╭╮╭┫┃╱╭╮┃┃┃┃╰━━╮┃┃╱┃┃┃╱╭╮┃┃┃╰━╯┃┃╱╭╮┃┃╱╭┫┃╱╭┫┃╱┃┃╭━╮┃//
1710 //┃╰━╯┃┃╱┃┃┃╰━━╮╰╮╭╮╭┫╰━╯┃┃┃╰┫╰━╯┣╯╰╯┃┃╰━╯┃╰━╯┃╰━╯┣┫┣┫╭━╮┃╰━╯┃┃╰━╯┃╰━╯┃╰━╯┃╰━╯┃//
1711 //╰━━━┻╯╱╰━┻━━━╯╱╰╯╰╯╰━━━┻╯╰━┻━━━┻━━━╯╰━━━┻━━━┻━━━┻━━┻╯╱╰┻━━━╯╰━━━┻━━━┻━━━┻━━━╯//
1712 /////////////////////////////////////////////////////////////////////////////////
1713 
1714 
1715 
1716 
1717 
1718 
1719 
1720 
1721 
1722 error PrivateMintNotStarted();
1723 error PublicMintNotStarted();
1724 error InsufficientPayment();
1725 error NotInWhitelist();
1726 error ExceedSupply();
1727 error ExceedMaxPerWallet();
1728 
1729 
1730 
1731 contract OneWorldSocialClub is ERC721A, Ownable, ReentrancyGuard {
1732     using Strings for uint256;
1733 
1734 
1735     // ===== Variables =====
1736     uint16 constant devSupply = 500;
1737     uint16 constant presaleSupply = 1000;
1738     uint16 constant collectionSupply = 10000;
1739     bool public privatePaused = true;
1740     bool public publicPaused = true;    
1741     uint256 public mintPrice = 0.02 ether;
1742     uint256 public presalePrice = 0 ether;
1743     string public baseExtension = ".json";
1744     string baseURI;
1745     bool public revealed = false;
1746     string public notRevealedUri;
1747     uint256 public publicsaleMaxItemsPerWallet = 11;
1748     uint256 public presaleMaxItemsPerWallet = 1;
1749    
1750 
1751 
1752 
1753     // ===== Constructor =====
1754     constructor(
1755         string memory _initBaseURI,
1756         string memory _initNotRevealedUri)
1757         ERC721A("One World Social CLub", "OWSC") 
1758         {
1759             setBaseURI(_initBaseURI);
1760             setNotRevealedURI(_initNotRevealedUri);
1761         }
1762         
1763 
1764 
1765 
1766     function _baseURI() internal view virtual override returns (string memory) {
1767         return baseURI;
1768     }
1769 
1770 
1771     // ===== Dev mint =====
1772     function devMint(uint256 quantity) external onlyOwner {
1773         if(quantity > devSupply) revert ExceedSupply();
1774 
1775         _mint(msg.sender, quantity);
1776               
1777     }
1778 
1779     // ===== Pre-Sale mint =====
1780     function privateMint(uint256 quantity) public payable nonReentrant {
1781         require(!privatePaused);
1782         if(msg.value < presalePrice * quantity) revert InsufficientPayment();
1783         if(totalSupply() + quantity > presaleSupply) revert ExceedSupply();
1784         if(_numberMinted(msg.sender) + quantity > presaleMaxItemsPerWallet) revert ExceedMaxPerWallet();
1785     
1786         _mint(msg.sender, quantity);
1787             
1788     }
1789 
1790     // ===== Public mint =====
1791     function mint(uint256 quantity) public payable nonReentrant {
1792         require(!publicPaused);
1793         if(msg.value < mintPrice * quantity) revert InsufficientPayment();
1794         if(_numberMinted(msg.sender) + quantity > publicsaleMaxItemsPerWallet) revert ExceedMaxPerWallet();
1795         if(totalSupply() + quantity > collectionSupply) revert ExceedSupply();
1796         
1797         _mint(msg.sender, quantity);
1798     
1799         
1800        
1801     }
1802 
1803     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
1804         uint256 _balance = balanceOf(address_);
1805         uint256[] memory _tokens = new uint256[] (_balance);
1806         uint256 _index;
1807         uint256 _loopThrough = totalSupply();
1808         for (uint256 i = 0; i < _loopThrough; i++) {
1809             bool _exists = _exists(i);
1810             if (_exists) {
1811                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
1812             }
1813             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
1814         }
1815         return _tokens;
1816     }
1817 
1818     // ===== Reveal =====
1819     function tokenURI(uint256 tokenId)
1820     public
1821     view
1822     virtual
1823     override(ERC721A)
1824     returns (string memory)
1825   {
1826     require(
1827       _exists(tokenId),
1828       "ERC721AMetadata: URI query for nonexistent token"
1829     );
1830     
1831     if(revealed == false) {
1832         return notRevealedUri;
1833     }
1834 
1835     string memory currentBaseURI = _baseURI();
1836     return bytes(currentBaseURI).length > 0
1837         ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
1838         : "";
1839   }
1840     
1841 
1842     // ===== Withdraw =====
1843     function withdraw() external payable onlyOwner {
1844         (bool success, ) = payable(owner()).call{value: address(this).balance}("");
1845         require(success);
1846     }
1847 
1848 
1849 
1850     // ===== Metadata URI =====
1851     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1852     baseURI = _newBaseURI;
1853   }
1854 
1855     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1856     notRevealedUri = _notRevealedURI;
1857   }
1858 
1859     function reveal(bool _state) public onlyOwner {
1860         revealed = _state;
1861   }
1862 
1863     function publicMintPaused(bool _state) public onlyOwner {
1864         publicPaused = _state;
1865   }
1866 
1867     function privateMintPaused(bool _state) public onlyOwner {
1868         privatePaused = _state;
1869     }
1870 
1871     function setPresaleMaxItemsPerWallet(uint256 value) external onlyOwner {
1872         presaleMaxItemsPerWallet = value;
1873     }
1874 
1875     function setpublicsaleMaxItemsPerWallet(uint256 value) external onlyOwner {
1876         publicsaleMaxItemsPerWallet = value;
1877     }
1878 
1879     function setPresalePrice(uint256 value) external onlyOwner {
1880         presalePrice = value;
1881     }
1882 
1883     function setMintPrice(uint256 value) external onlyOwner {
1884         mintPrice = value;
1885     }
1886 
1887 }