1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16     uint8 private constant _ADDRESS_LENGTH = 20;
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 
74     /**
75      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
76      */
77     function toHexString(address addr) internal pure returns (string memory) {
78         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Address.sol
83 
84 
85 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
86 
87 pragma solidity ^0.8.1;
88 
89 /**
90  * @dev Collection of functions related to the address type
91  */
92 library Address {
93     /**
94      * @dev Returns true if `account` is a contract.
95      *
96      * [IMPORTANT]
97      * ====
98      * It is unsafe to assume that an address for which this function returns
99      * false is an externally-owned account (EOA) and not a contract.
100      *
101      * Among others, `isContract` will return false for the following
102      * types of addresses:
103      *
104      *  - an externally-owned account
105      *  - a contract in construction
106      *  - an address where a contract will be created
107      *  - an address where a contract lived, but was destroyed
108      * ====
109      *
110      * [IMPORTANT]
111      * ====
112      * You shouldn't rely on `isContract` to protect against flash loan attacks!
113      *
114      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
115      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
116      * constructor.
117      * ====
118      */
119     function isContract(address account) internal view returns (bool) {
120         // This method relies on extcodesize/address.code.length, which returns 0
121         // for contracts in construction, since the code is only stored at the end
122         // of the constructor execution.
123 
124         return account.code.length > 0;
125     }
126 
127     /**
128      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
129      * `recipient`, forwarding all available gas and reverting on errors.
130      *
131      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
132      * of certain opcodes, possibly making contracts go over the 2300 gas limit
133      * imposed by `transfer`, making them unable to receive funds via
134      * `transfer`. {sendValue} removes this limitation.
135      *
136      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
137      *
138      * IMPORTANT: because control is transferred to `recipient`, care must be
139      * taken to not create reentrancy vulnerabilities. Consider using
140      * {ReentrancyGuard} or the
141      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
142      */
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     /**
151      * @dev Performs a Solidity function call using a low level `call`. A
152      * plain `call` is an unsafe replacement for a function call: use this
153      * function instead.
154      *
155      * If `target` reverts with a revert reason, it is bubbled up by this
156      * function (like regular Solidity function calls).
157      *
158      * Returns the raw returned data. To convert to the expected return value,
159      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
160      *
161      * Requirements:
162      *
163      * - `target` must be a contract.
164      * - calling `target` with `data` must not revert.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
207      * with `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(address(this).balance >= value, "Address: insufficient balance for call");
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value: value}(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal view returns (bytes memory) {
245         require(isContract(target), "Address: static call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.staticcall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(isContract(target), "Address: delegate call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.delegatecall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
280      * revert reason using the provided one.
281      *
282      * _Available since v4.3._
283      */
284     function verifyCallResult(
285         bool success,
286         bytes memory returndata,
287         string memory errorMessage
288     ) internal pure returns (bytes memory) {
289         if (success) {
290             return returndata;
291         } else {
292             // Look for revert reason and bubble it up if present
293             if (returndata.length > 0) {
294                 // The easiest way to bubble the revert reason is using memory via assembly
295                 /// @solidity memory-safe-assembly
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Contract module that helps prevent reentrant calls to a function.
316  *
317  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
318  * available, which can be applied to functions to make sure there are no nested
319  * (reentrant) calls to them.
320  *
321  * Note that because there is a single `nonReentrant` guard, functions marked as
322  * `nonReentrant` may not call one another. This can be worked around by making
323  * those functions `private`, and then adding `external` `nonReentrant` entry
324  * points to them.
325  *
326  * TIP: If you would like to learn more about reentrancy and alternative ways
327  * to protect against it, check out our blog post
328  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
329  */
330 abstract contract ReentrancyGuard {
331     // Booleans are more expensive than uint256 or any type that takes up a full
332     // word because each write operation emits an extra SLOAD to first read the
333     // slot's contents, replace the bits taken up by the boolean, and then write
334     // back. This is the compiler's defense against contract upgrades and
335     // pointer aliasing, and it cannot be disabled.
336 
337     // The values being non-zero value makes deployment a bit more expensive,
338     // but in exchange the refund on every call to nonReentrant will be lower in
339     // amount. Since refunds are capped to a percentage of the total
340     // transaction's gas, it is best to keep them low in cases like this one, to
341     // increase the likelihood of the full refund coming into effect.
342     uint256 private constant _NOT_ENTERED = 1;
343     uint256 private constant _ENTERED = 2;
344 
345     uint256 private _status;
346 
347     constructor() {
348         _status = _NOT_ENTERED;
349     }
350 
351     /**
352      * @dev Prevents a contract from calling itself, directly or indirectly.
353      * Calling a `nonReentrant` function from another `nonReentrant`
354      * function is not supported. It is possible to prevent this from happening
355      * by making the `nonReentrant` function external, and making it call a
356      * `private` function that does the actual work.
357      */
358     modifier nonReentrant() {
359         // On the first call to nonReentrant, _notEntered will be true
360         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
361 
362         // Any calls to nonReentrant after this point will fail
363         _status = _ENTERED;
364 
365         _;
366 
367         // By storing the original value once again, a refund is triggered (see
368         // https://eips.ethereum.org/EIPS/eip-2200)
369         _status = _NOT_ENTERED;
370     }
371 }
372 
373 // File: @openzeppelin/contracts/utils/Context.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev Provides information about the current execution context, including the
382  * sender of the transaction and its data. While these are generally available
383  * via msg.sender and msg.data, they should not be accessed in such a direct
384  * manner, since when dealing with meta-transactions the account sending and
385  * paying for execution may not be the actual sender (as far as an application
386  * is concerned).
387  *
388  * This contract is only required for intermediate, library-like contracts.
389  */
390 abstract contract Context {
391     function _msgSender() internal view virtual returns (address) {
392         return msg.sender;
393     }
394 
395     function _msgData() internal view virtual returns (bytes calldata) {
396         return msg.data;
397     }
398 }
399 
400 // File: @openzeppelin/contracts/access/Ownable.sol
401 
402 
403 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 
408 /**
409  * @dev Contract module which provides a basic access control mechanism, where
410  * there is an account (an owner) that can be granted exclusive access to
411  * specific functions.
412  *
413  * By default, the owner account will be the one that deploys the contract. This
414  * can later be changed with {transferOwnership}.
415  *
416  * This module is used through inheritance. It will make available the modifier
417  * `onlyOwner`, which can be applied to your functions to restrict their use to
418  * the owner.
419  */
420 abstract contract Ownable is Context {
421     address private _owner;
422 
423     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
424 
425     /**
426      * @dev Initializes the contract setting the deployer as the initial owner.
427      */
428     constructor() {
429         _transferOwnership(_msgSender());
430     }
431 
432     /**
433      * @dev Throws if called by any account other than the owner.
434      */
435     modifier onlyOwner() {
436         _checkOwner();
437         _;
438     }
439 
440     /**
441      * @dev Returns the address of the current owner.
442      */
443     function owner() public view virtual returns (address) {
444         return _owner;
445     }
446 
447     /**
448      * @dev Throws if the sender is not the owner.
449      */
450     function _checkOwner() internal view virtual {
451         require(owner() == _msgSender(), "Ownable: caller is not the owner");
452     }
453 
454     /**
455      * @dev Leaves the contract without owner. It will not be possible to call
456      * `onlyOwner` functions anymore. Can only be called by the current owner.
457      *
458      * NOTE: Renouncing ownership will leave the contract without an owner,
459      * thereby removing any functionality that is only available to the owner.
460      */
461     function renounceOwnership() public virtual onlyOwner {
462         _transferOwnership(address(0));
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Can only be called by the current owner.
468      */
469     function transferOwnership(address newOwner) public virtual onlyOwner {
470         require(newOwner != address(0), "Ownable: new owner is the zero address");
471         _transferOwnership(newOwner);
472     }
473 
474     /**
475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
476      * Internal function without access restriction.
477      */
478     function _transferOwnership(address newOwner) internal virtual {
479         address oldOwner = _owner;
480         _owner = newOwner;
481         emit OwnershipTransferred(oldOwner, newOwner);
482     }
483 }
484 
485 // File: erc721a/contracts/IERC721A.sol
486 
487 
488 // ERC721A Contracts v4.1.0
489 // Creator: Chiru Labs
490 
491 pragma solidity ^0.8.4;
492 
493 /**
494  * @dev Interface of an ERC721A compliant contract.
495  */
496 interface IERC721A {
497     /**
498      * The caller must own the token or be an approved operator.
499      */
500     error ApprovalCallerNotOwnerNorApproved();
501 
502     /**
503      * The token does not exist.
504      */
505     error ApprovalQueryForNonexistentToken();
506 
507     /**
508      * The caller cannot approve to their own address.
509      */
510     error ApproveToCaller();
511 
512     /**
513      * Cannot query the balance for the zero address.
514      */
515     error BalanceQueryForZeroAddress();
516 
517     /**
518      * Cannot mint to the zero address.
519      */
520     error MintToZeroAddress();
521 
522     /**
523      * The quantity of tokens minted must be more than zero.
524      */
525     error MintZeroQuantity();
526 
527     /**
528      * The token does not exist.
529      */
530     error OwnerQueryForNonexistentToken();
531 
532     /**
533      * The caller must own the token or be an approved operator.
534      */
535     error TransferCallerNotOwnerNorApproved();
536 
537     /**
538      * The token must be owned by `from`.
539      */
540     error TransferFromIncorrectOwner();
541 
542     /**
543      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
544      */
545     error TransferToNonERC721ReceiverImplementer();
546 
547     /**
548      * Cannot transfer to the zero address.
549      */
550     error TransferToZeroAddress();
551 
552     /**
553      * The token does not exist.
554      */
555     error URIQueryForNonexistentToken();
556 
557     /**
558      * The `quantity` minted with ERC2309 exceeds the safety limit.
559      */
560     error MintERC2309QuantityExceedsLimit();
561 
562     /**
563      * The `extraData` cannot be set on an unintialized ownership slot.
564      */
565     error OwnershipNotInitializedForExtraData();
566 
567     struct TokenOwnership {
568         // The address of the owner.
569         address addr;
570         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
571         uint64 startTimestamp;
572         // Whether the token has been burned.
573         bool burned;
574         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
575         uint24 extraData;
576     }
577 
578     /**
579      * @dev Returns the total amount of tokens stored by the contract.
580      *
581      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
582      */
583     function totalSupply() external view returns (uint256);
584 
585     // ==============================
586     //            IERC165
587     // ==============================
588 
589     /**
590      * @dev Returns true if this contract implements the interface defined by
591      * `interfaceId`. See the corresponding
592      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
593      * to learn more about how these ids are created.
594      *
595      * This function call must use less than 30 000 gas.
596      */
597     function supportsInterface(bytes4 interfaceId) external view returns (bool);
598 
599     // ==============================
600     //            IERC721
601     // ==============================
602 
603     /**
604      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
605      */
606     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
607 
608     /**
609      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
610      */
611     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
612 
613     /**
614      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
615      */
616     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
617 
618     /**
619      * @dev Returns the number of tokens in ``owner``'s account.
620      */
621     function balanceOf(address owner) external view returns (uint256 balance);
622 
623     /**
624      * @dev Returns the owner of the `tokenId` token.
625      *
626      * Requirements:
627      *
628      * - `tokenId` must exist.
629      */
630     function ownerOf(uint256 tokenId) external view returns (address owner);
631 
632     /**
633      * @dev Safely transfers `tokenId` token from `from` to `to`.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must exist and be owned by `from`.
640      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
641      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
642      *
643      * Emits a {Transfer} event.
644      */
645     function safeTransferFrom(
646         address from,
647         address to,
648         uint256 tokenId,
649         bytes calldata data
650     ) external;
651 
652     /**
653      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
654      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must exist and be owned by `from`.
661      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
663      *
664      * Emits a {Transfer} event.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId
670     ) external;
671 
672     /**
673      * @dev Transfers `tokenId` token from `from` to `to`.
674      *
675      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
676      *
677      * Requirements:
678      *
679      * - `from` cannot be the zero address.
680      * - `to` cannot be the zero address.
681      * - `tokenId` token must be owned by `from`.
682      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
683      *
684      * Emits a {Transfer} event.
685      */
686     function transferFrom(
687         address from,
688         address to,
689         uint256 tokenId
690     ) external;
691 
692     /**
693      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
694      * The approval is cleared when the token is transferred.
695      *
696      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
697      *
698      * Requirements:
699      *
700      * - The caller must own the token or be an approved operator.
701      * - `tokenId` must exist.
702      *
703      * Emits an {Approval} event.
704      */
705     function approve(address to, uint256 tokenId) external;
706 
707     /**
708      * @dev Approve or remove `operator` as an operator for the caller.
709      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
710      *
711      * Requirements:
712      *
713      * - The `operator` cannot be the caller.
714      *
715      * Emits an {ApprovalForAll} event.
716      */
717     function setApprovalForAll(address operator, bool _approved) external;
718 
719     /**
720      * @dev Returns the account approved for `tokenId` token.
721      *
722      * Requirements:
723      *
724      * - `tokenId` must exist.
725      */
726     function getApproved(uint256 tokenId) external view returns (address operator);
727 
728     /**
729      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
730      *
731      * See {setApprovalForAll}
732      */
733     function isApprovedForAll(address owner, address operator) external view returns (bool);
734 
735     // ==============================
736     //        IERC721Metadata
737     // ==============================
738 
739     /**
740      * @dev Returns the token collection name.
741      */
742     function name() external view returns (string memory);
743 
744     /**
745      * @dev Returns the token collection symbol.
746      */
747     function symbol() external view returns (string memory);
748 
749     /**
750      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
751      */
752     function tokenURI(uint256 tokenId) external view returns (string memory);
753 
754     // ==============================
755     //            IERC2309
756     // ==============================
757 
758     /**
759      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
760      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
761      */
762     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
763 }
764 
765 // File: erc721a/contracts/ERC721A.sol
766 
767 
768 // ERC721A Contracts v4.1.0
769 // Creator: Chiru Labs
770 
771 pragma solidity ^0.8.4;
772 
773 
774 /**
775  * @dev ERC721 token receiver interface.
776  */
777 interface ERC721A__IERC721Receiver {
778     function onERC721Received(
779         address operator,
780         address from,
781         uint256 tokenId,
782         bytes calldata data
783     ) external returns (bytes4);
784 }
785 
786 /**
787  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
788  * including the Metadata extension. Built to optimize for lower gas during batch mints.
789  *
790  * Assumes serials are sequentially minted starting at `_startTokenId()`
791  * (defaults to 0, e.g. 0, 1, 2, 3..).
792  *
793  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
794  *
795  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
796  */
797 contract ERC721A is IERC721A {
798     // Mask of an entry in packed address data.
799     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
800 
801     // The bit position of `numberMinted` in packed address data.
802     uint256 private constant BITPOS_NUMBER_MINTED = 64;
803 
804     // The bit position of `numberBurned` in packed address data.
805     uint256 private constant BITPOS_NUMBER_BURNED = 128;
806 
807     // The bit position of `aux` in packed address data.
808     uint256 private constant BITPOS_AUX = 192;
809 
810     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
811     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
812 
813     // The bit position of `startTimestamp` in packed ownership.
814     uint256 private constant BITPOS_START_TIMESTAMP = 160;
815 
816     // The bit mask of the `burned` bit in packed ownership.
817     uint256 private constant BITMASK_BURNED = 1 << 224;
818 
819     // The bit position of the `nextInitialized` bit in packed ownership.
820     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
821 
822     // The bit mask of the `nextInitialized` bit in packed ownership.
823     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
824 
825     // The bit position of `extraData` in packed ownership.
826     uint256 private constant BITPOS_EXTRA_DATA = 232;
827 
828     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
829     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
830 
831     // The mask of the lower 160 bits for addresses.
832     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
833 
834     // The maximum `quantity` that can be minted with `_mintERC2309`.
835     // This limit is to prevent overflows on the address data entries.
836     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
837     // is required to cause an overflow, which is unrealistic.
838     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
839 
840     // The tokenId of the next token to be minted.
841     uint256 private _currentIndex;
842 
843     // The number of tokens burned.
844     uint256 private _burnCounter;
845 
846     // Token name
847     string private _name;
848 
849     // Token symbol
850     string private _symbol;
851 
852     // Mapping from token ID to ownership details
853     // An empty struct value does not necessarily mean the token is unowned.
854     // See `_packedOwnershipOf` implementation for details.
855     //
856     // Bits Layout:
857     // - [0..159]   `addr`
858     // - [160..223] `startTimestamp`
859     // - [224]      `burned`
860     // - [225]      `nextInitialized`
861     // - [232..255] `extraData`
862     mapping(uint256 => uint256) private _packedOwnerships;
863 
864     // Mapping owner address to address data.
865     //
866     // Bits Layout:
867     // - [0..63]    `balance`
868     // - [64..127]  `numberMinted`
869     // - [128..191] `numberBurned`
870     // - [192..255] `aux`
871     mapping(address => uint256) private _packedAddressData;
872 
873     // Mapping from token ID to approved address.
874     mapping(uint256 => address) private _tokenApprovals;
875 
876     // Mapping from owner to operator approvals
877     mapping(address => mapping(address => bool)) private _operatorApprovals;
878 
879     constructor(string memory name_, string memory symbol_) {
880         _name = name_;
881         _symbol = symbol_;
882         _currentIndex = _startTokenId();
883     }
884 
885     /**
886      * @dev Returns the starting token ID.
887      * To change the starting token ID, please override this function.
888      */
889     function _startTokenId() internal view virtual returns (uint256) {
890         return 0;
891     }
892 
893     /**
894      * @dev Returns the next token ID to be minted.
895      */
896     function _nextTokenId() internal view returns (uint256) {
897         return _currentIndex;
898     }
899 
900     /**
901      * @dev Returns the total number of tokens in existence.
902      * Burned tokens will reduce the count.
903      * To get the total number of tokens minted, please see `_totalMinted`.
904      */
905     function totalSupply() public view override returns (uint256) {
906         // Counter underflow is impossible as _burnCounter cannot be incremented
907         // more than `_currentIndex - _startTokenId()` times.
908         unchecked {
909             return _currentIndex - _burnCounter - _startTokenId();
910         }
911     }
912 
913     /**
914      * @dev Returns the total amount of tokens minted in the contract.
915      */
916     function _totalMinted() internal view returns (uint256) {
917         // Counter underflow is impossible as _currentIndex does not decrement,
918         // and it is initialized to `_startTokenId()`
919         unchecked {
920             return _currentIndex - _startTokenId();
921         }
922     }
923 
924     /**
925      * @dev Returns the total number of tokens burned.
926      */
927     function _totalBurned() internal view returns (uint256) {
928         return _burnCounter;
929     }
930 
931     /**
932      * @dev See {IERC165-supportsInterface}.
933      */
934     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
935         // The interface IDs are constants representing the first 4 bytes of the XOR of
936         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
937         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
938         return
939             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
940             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
941             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
942     }
943 
944     /**
945      * @dev See {IERC721-balanceOf}.
946      */
947     function balanceOf(address owner) public view override returns (uint256) {
948         if (owner == address(0)) revert BalanceQueryForZeroAddress();
949         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
950     }
951 
952     /**
953      * Returns the number of tokens minted by `owner`.
954      */
955     function _numberMinted(address owner) internal view returns (uint256) {
956         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
957     }
958 
959     /**
960      * Returns the number of tokens burned by or on behalf of `owner`.
961      */
962     function _numberBurned(address owner) internal view returns (uint256) {
963         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
964     }
965 
966     /**
967      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
968      */
969     function _getAux(address owner) internal view returns (uint64) {
970         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
971     }
972 
973     /**
974      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
975      * If there are multiple variables, please pack them into a uint64.
976      */
977     function _setAux(address owner, uint64 aux) internal {
978         uint256 packed = _packedAddressData[owner];
979         uint256 auxCasted;
980         // Cast `aux` with assembly to avoid redundant masking.
981         assembly {
982             auxCasted := aux
983         }
984         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
985         _packedAddressData[owner] = packed;
986     }
987 
988     /**
989      * Returns the packed ownership data of `tokenId`.
990      */
991     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
992         uint256 curr = tokenId;
993 
994         unchecked {
995             if (_startTokenId() <= curr)
996                 if (curr < _currentIndex) {
997                     uint256 packed = _packedOwnerships[curr];
998                     // If not burned.
999                     if (packed & BITMASK_BURNED == 0) {
1000                         // Invariant:
1001                         // There will always be an ownership that has an address and is not burned
1002                         // before an ownership that does not have an address and is not burned.
1003                         // Hence, curr will not underflow.
1004                         //
1005                         // We can directly compare the packed value.
1006                         // If the address is zero, packed is zero.
1007                         while (packed == 0) {
1008                             packed = _packedOwnerships[--curr];
1009                         }
1010                         return packed;
1011                     }
1012                 }
1013         }
1014         revert OwnerQueryForNonexistentToken();
1015     }
1016 
1017     /**
1018      * Returns the unpacked `TokenOwnership` struct from `packed`.
1019      */
1020     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1021         ownership.addr = address(uint160(packed));
1022         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1023         ownership.burned = packed & BITMASK_BURNED != 0;
1024         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1025     }
1026 
1027     /**
1028      * Returns the unpacked `TokenOwnership` struct at `index`.
1029      */
1030     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1031         return _unpackedOwnership(_packedOwnerships[index]);
1032     }
1033 
1034     /**
1035      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1036      */
1037     function _initializeOwnershipAt(uint256 index) internal {
1038         if (_packedOwnerships[index] == 0) {
1039             _packedOwnerships[index] = _packedOwnershipOf(index);
1040         }
1041     }
1042 
1043     /**
1044      * Gas spent here starts off proportional to the maximum mint batch size.
1045      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1046      */
1047     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1048         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1049     }
1050 
1051     /**
1052      * @dev Packs ownership data into a single uint256.
1053      */
1054     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1055         assembly {
1056             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1057             owner := and(owner, BITMASK_ADDRESS)
1058             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1059             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1060         }
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-ownerOf}.
1065      */
1066     function ownerOf(uint256 tokenId) public view override returns (address) {
1067         return address(uint160(_packedOwnershipOf(tokenId)));
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Metadata-name}.
1072      */
1073     function name() public view virtual override returns (string memory) {
1074         return _name;
1075     }
1076 
1077     /**
1078      * @dev See {IERC721Metadata-symbol}.
1079      */
1080     function symbol() public view virtual override returns (string memory) {
1081         return _symbol;
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Metadata-tokenURI}.
1086      */
1087     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1088         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1089 
1090         string memory baseURI = _baseURI();
1091         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1092     }
1093 
1094     /**
1095      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1096      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1097      * by default, it can be overridden in child contracts.
1098      */
1099     function _baseURI() internal view virtual returns (string memory) {
1100         return '';
1101     }
1102 
1103     /**
1104      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1105      */
1106     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1107         // For branchless setting of the `nextInitialized` flag.
1108         assembly {
1109             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1110             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1111         }
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-approve}.
1116      */
1117     function approve(address to, uint256 tokenId) public override {
1118         address owner = ownerOf(tokenId);
1119 
1120         if (_msgSenderERC721A() != owner)
1121             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1122                 revert ApprovalCallerNotOwnerNorApproved();
1123             }
1124 
1125         _tokenApprovals[tokenId] = to;
1126         emit Approval(owner, to, tokenId);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-getApproved}.
1131      */
1132     function getApproved(uint256 tokenId) public view override returns (address) {
1133         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1134 
1135         return _tokenApprovals[tokenId];
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-setApprovalForAll}.
1140      */
1141     function setApprovalForAll(address operator, bool approved) public virtual override {
1142         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1143 
1144         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1145         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-isApprovedForAll}.
1150      */
1151     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1152         return _operatorApprovals[owner][operator];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-safeTransferFrom}.
1157      */
1158     function safeTransferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) public virtual override {
1163         safeTransferFrom(from, to, tokenId, '');
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-safeTransferFrom}.
1168      */
1169     function safeTransferFrom(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) public virtual override {
1175         transferFrom(from, to, tokenId);
1176         if (to.code.length != 0)
1177             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1178                 revert TransferToNonERC721ReceiverImplementer();
1179             }
1180     }
1181 
1182     /**
1183      * @dev Returns whether `tokenId` exists.
1184      *
1185      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1186      *
1187      * Tokens start existing when they are minted (`_mint`),
1188      */
1189     function _exists(uint256 tokenId) internal view returns (bool) {
1190         return
1191             _startTokenId() <= tokenId &&
1192             tokenId < _currentIndex && // If within bounds,
1193             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1194     }
1195 
1196     /**
1197      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1198      */
1199     function _safeMint(address to, uint256 quantity) internal {
1200         _safeMint(to, quantity, '');
1201     }
1202 
1203     /**
1204      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1205      *
1206      * Requirements:
1207      *
1208      * - If `to` refers to a smart contract, it must implement
1209      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1210      * - `quantity` must be greater than 0.
1211      *
1212      * See {_mint}.
1213      *
1214      * Emits a {Transfer} event for each mint.
1215      */
1216     function _safeMint(
1217         address to,
1218         uint256 quantity,
1219         bytes memory _data
1220     ) internal {
1221         _mint(to, quantity);
1222 
1223         unchecked {
1224             if (to.code.length != 0) {
1225                 uint256 end = _currentIndex;
1226                 uint256 index = end - quantity;
1227                 do {
1228                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1229                         revert TransferToNonERC721ReceiverImplementer();
1230                     }
1231                 } while (index < end);
1232                 // Reentrancy protection.
1233                 if (_currentIndex != end) revert();
1234             }
1235         }
1236     }
1237 
1238     /**
1239      * @dev Mints `quantity` tokens and transfers them to `to`.
1240      *
1241      * Requirements:
1242      *
1243      * - `to` cannot be the zero address.
1244      * - `quantity` must be greater than 0.
1245      *
1246      * Emits a {Transfer} event for each mint.
1247      */
1248     function _mint(address to, uint256 quantity) internal {
1249         uint256 startTokenId = _currentIndex;
1250         if (to == address(0)) revert MintToZeroAddress();
1251         if (quantity == 0) revert MintZeroQuantity();
1252 
1253         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1254 
1255         // Overflows are incredibly unrealistic.
1256         // `balance` and `numberMinted` have a maximum limit of 2**64.
1257         // `tokenId` has a maximum limit of 2**256.
1258         unchecked {
1259             // Updates:
1260             // - `balance += quantity`.
1261             // - `numberMinted += quantity`.
1262             //
1263             // We can directly add to the `balance` and `numberMinted`.
1264             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1265 
1266             // Updates:
1267             // - `address` to the owner.
1268             // - `startTimestamp` to the timestamp of minting.
1269             // - `burned` to `false`.
1270             // - `nextInitialized` to `quantity == 1`.
1271             _packedOwnerships[startTokenId] = _packOwnershipData(
1272                 to,
1273                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1274             );
1275 
1276             uint256 tokenId = startTokenId;
1277             uint256 end = startTokenId + quantity;
1278             do {
1279                 emit Transfer(address(0), to, tokenId++);
1280             } while (tokenId < end);
1281 
1282             _currentIndex = end;
1283         }
1284         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1285     }
1286 
1287     /**
1288      * @dev Mints `quantity` tokens and transfers them to `to`.
1289      *
1290      * This function is intended for efficient minting only during contract creation.
1291      *
1292      * It emits only one {ConsecutiveTransfer} as defined in
1293      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1294      * instead of a sequence of {Transfer} event(s).
1295      *
1296      * Calling this function outside of contract creation WILL make your contract
1297      * non-compliant with the ERC721 standard.
1298      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1299      * {ConsecutiveTransfer} event is only permissible during contract creation.
1300      *
1301      * Requirements:
1302      *
1303      * - `to` cannot be the zero address.
1304      * - `quantity` must be greater than 0.
1305      *
1306      * Emits a {ConsecutiveTransfer} event.
1307      */
1308     function _mintERC2309(address to, uint256 quantity) internal {
1309         uint256 startTokenId = _currentIndex;
1310         if (to == address(0)) revert MintToZeroAddress();
1311         if (quantity == 0) revert MintZeroQuantity();
1312         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1313 
1314         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1315 
1316         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1317         unchecked {
1318             // Updates:
1319             // - `balance += quantity`.
1320             // - `numberMinted += quantity`.
1321             //
1322             // We can directly add to the `balance` and `numberMinted`.
1323             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1324 
1325             // Updates:
1326             // - `address` to the owner.
1327             // - `startTimestamp` to the timestamp of minting.
1328             // - `burned` to `false`.
1329             // - `nextInitialized` to `quantity == 1`.
1330             _packedOwnerships[startTokenId] = _packOwnershipData(
1331                 to,
1332                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1333             );
1334 
1335             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1336 
1337             _currentIndex = startTokenId + quantity;
1338         }
1339         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1340     }
1341 
1342     /**
1343      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1344      */
1345     function _getApprovedAddress(uint256 tokenId)
1346         private
1347         view
1348         returns (uint256 approvedAddressSlot, address approvedAddress)
1349     {
1350         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1351         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1352         assembly {
1353             // Compute the slot.
1354             mstore(0x00, tokenId)
1355             mstore(0x20, tokenApprovalsPtr.slot)
1356             approvedAddressSlot := keccak256(0x00, 0x40)
1357             // Load the slot's value from storage.
1358             approvedAddress := sload(approvedAddressSlot)
1359         }
1360     }
1361 
1362     /**
1363      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1364      */
1365     function _isOwnerOrApproved(
1366         address approvedAddress,
1367         address from,
1368         address msgSender
1369     ) private pure returns (bool result) {
1370         assembly {
1371             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1372             from := and(from, BITMASK_ADDRESS)
1373             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1374             msgSender := and(msgSender, BITMASK_ADDRESS)
1375             // `msgSender == from || msgSender == approvedAddress`.
1376             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1377         }
1378     }
1379 
1380     /**
1381      * @dev Transfers `tokenId` from `from` to `to`.
1382      *
1383      * Requirements:
1384      *
1385      * - `to` cannot be the zero address.
1386      * - `tokenId` token must be owned by `from`.
1387      *
1388      * Emits a {Transfer} event.
1389      */
1390     function transferFrom(
1391         address from,
1392         address to,
1393         uint256 tokenId
1394     ) public virtual override {
1395         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1396 
1397         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1398 
1399         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1400 
1401         // The nested ifs save around 20+ gas over a compound boolean condition.
1402         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1403             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1404 
1405         if (to == address(0)) revert TransferToZeroAddress();
1406 
1407         _beforeTokenTransfers(from, to, tokenId, 1);
1408 
1409         // Clear approvals from the previous owner.
1410         assembly {
1411             if approvedAddress {
1412                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1413                 sstore(approvedAddressSlot, 0)
1414             }
1415         }
1416 
1417         // Underflow of the sender's balance is impossible because we check for
1418         // ownership above and the recipient's balance can't realistically overflow.
1419         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1420         unchecked {
1421             // We can directly increment and decrement the balances.
1422             --_packedAddressData[from]; // Updates: `balance -= 1`.
1423             ++_packedAddressData[to]; // Updates: `balance += 1`.
1424 
1425             // Updates:
1426             // - `address` to the next owner.
1427             // - `startTimestamp` to the timestamp of transfering.
1428             // - `burned` to `false`.
1429             // - `nextInitialized` to `true`.
1430             _packedOwnerships[tokenId] = _packOwnershipData(
1431                 to,
1432                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1433             );
1434 
1435             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1436             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1437                 uint256 nextTokenId = tokenId + 1;
1438                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1439                 if (_packedOwnerships[nextTokenId] == 0) {
1440                     // If the next slot is within bounds.
1441                     if (nextTokenId != _currentIndex) {
1442                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1443                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1444                     }
1445                 }
1446             }
1447         }
1448 
1449         emit Transfer(from, to, tokenId);
1450         _afterTokenTransfers(from, to, tokenId, 1);
1451     }
1452 
1453     /**
1454      * @dev Equivalent to `_burn(tokenId, false)`.
1455      */
1456     function _burn(uint256 tokenId) internal virtual {
1457         _burn(tokenId, false);
1458     }
1459 
1460     /**
1461      * @dev Destroys `tokenId`.
1462      * The approval is cleared when the token is burned.
1463      *
1464      * Requirements:
1465      *
1466      * - `tokenId` must exist.
1467      *
1468      * Emits a {Transfer} event.
1469      */
1470     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1471         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1472 
1473         address from = address(uint160(prevOwnershipPacked));
1474 
1475         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1476 
1477         if (approvalCheck) {
1478             // The nested ifs save around 20+ gas over a compound boolean condition.
1479             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1480                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1481         }
1482 
1483         _beforeTokenTransfers(from, address(0), tokenId, 1);
1484 
1485         // Clear approvals from the previous owner.
1486         assembly {
1487             if approvedAddress {
1488                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1489                 sstore(approvedAddressSlot, 0)
1490             }
1491         }
1492 
1493         // Underflow of the sender's balance is impossible because we check for
1494         // ownership above and the recipient's balance can't realistically overflow.
1495         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1496         unchecked {
1497             // Updates:
1498             // - `balance -= 1`.
1499             // - `numberBurned += 1`.
1500             //
1501             // We can directly decrement the balance, and increment the number burned.
1502             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1503             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1504 
1505             // Updates:
1506             // - `address` to the last owner.
1507             // - `startTimestamp` to the timestamp of burning.
1508             // - `burned` to `true`.
1509             // - `nextInitialized` to `true`.
1510             _packedOwnerships[tokenId] = _packOwnershipData(
1511                 from,
1512                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1513             );
1514 
1515             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1516             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1517                 uint256 nextTokenId = tokenId + 1;
1518                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1519                 if (_packedOwnerships[nextTokenId] == 0) {
1520                     // If the next slot is within bounds.
1521                     if (nextTokenId != _currentIndex) {
1522                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1523                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1524                     }
1525                 }
1526             }
1527         }
1528 
1529         emit Transfer(from, address(0), tokenId);
1530         _afterTokenTransfers(from, address(0), tokenId, 1);
1531 
1532         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1533         unchecked {
1534             _burnCounter++;
1535         }
1536     }
1537 
1538     /**
1539      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1540      *
1541      * @param from address representing the previous owner of the given token ID
1542      * @param to target address that will receive the tokens
1543      * @param tokenId uint256 ID of the token to be transferred
1544      * @param _data bytes optional data to send along with the call
1545      * @return bool whether the call correctly returned the expected magic value
1546      */
1547     function _checkContractOnERC721Received(
1548         address from,
1549         address to,
1550         uint256 tokenId,
1551         bytes memory _data
1552     ) private returns (bool) {
1553         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1554             bytes4 retval
1555         ) {
1556             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1557         } catch (bytes memory reason) {
1558             if (reason.length == 0) {
1559                 revert TransferToNonERC721ReceiverImplementer();
1560             } else {
1561                 assembly {
1562                     revert(add(32, reason), mload(reason))
1563                 }
1564             }
1565         }
1566     }
1567 
1568     /**
1569      * @dev Directly sets the extra data for the ownership data `index`.
1570      */
1571     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1572         uint256 packed = _packedOwnerships[index];
1573         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1574         uint256 extraDataCasted;
1575         // Cast `extraData` with assembly to avoid redundant masking.
1576         assembly {
1577             extraDataCasted := extraData
1578         }
1579         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1580         _packedOwnerships[index] = packed;
1581     }
1582 
1583     /**
1584      * @dev Returns the next extra data for the packed ownership data.
1585      * The returned result is shifted into position.
1586      */
1587     function _nextExtraData(
1588         address from,
1589         address to,
1590         uint256 prevOwnershipPacked
1591     ) private view returns (uint256) {
1592         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1593         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1594     }
1595 
1596     /**
1597      * @dev Called during each token transfer to set the 24bit `extraData` field.
1598      * Intended to be overridden by the cosumer contract.
1599      *
1600      * `previousExtraData` - the value of `extraData` before transfer.
1601      *
1602      * Calling conditions:
1603      *
1604      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1605      * transferred to `to`.
1606      * - When `from` is zero, `tokenId` will be minted for `to`.
1607      * - When `to` is zero, `tokenId` will be burned by `from`.
1608      * - `from` and `to` are never both zero.
1609      */
1610     function _extraData(
1611         address from,
1612         address to,
1613         uint24 previousExtraData
1614     ) internal view virtual returns (uint24) {}
1615 
1616     /**
1617      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1618      * This includes minting.
1619      * And also called before burning one token.
1620      *
1621      * startTokenId - the first token id to be transferred
1622      * quantity - the amount to be transferred
1623      *
1624      * Calling conditions:
1625      *
1626      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1627      * transferred to `to`.
1628      * - When `from` is zero, `tokenId` will be minted for `to`.
1629      * - When `to` is zero, `tokenId` will be burned by `from`.
1630      * - `from` and `to` are never both zero.
1631      */
1632     function _beforeTokenTransfers(
1633         address from,
1634         address to,
1635         uint256 startTokenId,
1636         uint256 quantity
1637     ) internal virtual {}
1638 
1639     /**
1640      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1641      * This includes minting.
1642      * And also called after one token has been burned.
1643      *
1644      * startTokenId - the first token id to be transferred
1645      * quantity - the amount to be transferred
1646      *
1647      * Calling conditions:
1648      *
1649      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1650      * transferred to `to`.
1651      * - When `from` is zero, `tokenId` has been minted for `to`.
1652      * - When `to` is zero, `tokenId` has been burned by `from`.
1653      * - `from` and `to` are never both zero.
1654      */
1655     function _afterTokenTransfers(
1656         address from,
1657         address to,
1658         uint256 startTokenId,
1659         uint256 quantity
1660     ) internal virtual {}
1661 
1662     /**
1663      * @dev Returns the message sender (defaults to `msg.sender`).
1664      *
1665      * If you are writing GSN compatible contracts, you need to override this function.
1666      */
1667     function _msgSenderERC721A() internal view virtual returns (address) {
1668         return msg.sender;
1669     }
1670 
1671     /**
1672      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1673      */
1674     function _toString(uint256 value) internal pure returns (string memory ptr) {
1675         assembly {
1676             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1677             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1678             // We will need 1 32-byte word to store the length,
1679             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1680             ptr := add(mload(0x40), 128)
1681             // Update the free memory pointer to allocate.
1682             mstore(0x40, ptr)
1683 
1684             // Cache the end of the memory to calculate the length later.
1685             let end := ptr
1686 
1687             // We write the string from the rightmost digit to the leftmost digit.
1688             // The following is essentially a do-while loop that also handles the zero case.
1689             // Costs a bit more than early returning for the zero case,
1690             // but cheaper in terms of deployment and overall runtime costs.
1691             for {
1692                 // Initialize and perform the first pass without check.
1693                 let temp := value
1694                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1695                 ptr := sub(ptr, 1)
1696                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1697                 mstore8(ptr, add(48, mod(temp, 10)))
1698                 temp := div(temp, 10)
1699             } temp {
1700                 // Keep dividing `temp` until zero.
1701                 temp := div(temp, 10)
1702             } {
1703                 // Body of the for loop.
1704                 ptr := sub(ptr, 1)
1705                 mstore8(ptr, add(48, mod(temp, 10)))
1706             }
1707 
1708             let length := sub(end, ptr)
1709             // Move the pointer 32 bytes leftwards to make room for the length.
1710             ptr := sub(ptr, 32)
1711             // Store the length.
1712             mstore(ptr, length)
1713         }
1714     }
1715 }
1716 
1717 // File: contract.sol
1718 
1719 
1720 pragma solidity ^0.8.7;
1721 
1722 
1723 
1724 
1725 
1726 
1727 contract MergeDarkApe is ERC721A, Ownable, ReentrancyGuard {
1728   using Address for address;
1729   using Strings for uint;
1730 
1731   string  public  baseTokenURI = "https://retest-blush.vercel.app/mergedarkape/";
1732   bool public isPublicSaleActive = true;
1733 
1734   uint256 public  maxSupply = 10000;
1735   uint256 public  MAX_MINTS_PER_TX = 35;
1736   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1737   uint256 public  NUM_FREE_MINTS = 7777;
1738   uint256 public  MAX_FREE_PER_WALLET = 2;
1739   uint256 public  freeNFTAlreadyMinted = 0;
1740 
1741   constructor() ERC721A("Merge Dark Ape", "MDA") {}
1742 
1743   function mint(uint256 numberOfTokens) external payable
1744   {
1745     require(isPublicSaleActive, "Public sale is paused.");
1746     require(totalSupply() + numberOfTokens < maxSupply + 1, "Maximum supply exceeded.");
1747 
1748     require(numberOfTokens <= MAX_MINTS_PER_TX, "Maximum mints per transaction exceeded.");
1749 
1750     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS)
1751     {
1752         require(PUBLIC_SALE_PRICE * numberOfTokens <= msg.value, "Invalid ETH value sent. Error Code: 1");
1753     } 
1754     else 
1755     {
1756         uint sender_balance = balanceOf(msg.sender);
1757         
1758         if (sender_balance + numberOfTokens > MAX_FREE_PER_WALLET) 
1759         { 
1760             if (sender_balance < MAX_FREE_PER_WALLET)
1761             {
1762                 uint free_available = MAX_FREE_PER_WALLET - sender_balance;
1763                 uint to_be_paid = numberOfTokens - free_available;
1764                 require(PUBLIC_SALE_PRICE * to_be_paid <= msg.value, "Invalid ETH value sent. Error Code: 2");
1765 
1766                 freeNFTAlreadyMinted += free_available;
1767             }
1768             else
1769             {
1770                 require(PUBLIC_SALE_PRICE * numberOfTokens <= msg.value, "Invalid ETH value sent. Error Code: 3");
1771             }
1772         }  
1773         else 
1774         {
1775             require(numberOfTokens <= MAX_FREE_PER_WALLET, "Maximum mints per transaction exceeded");
1776             freeNFTAlreadyMinted += numberOfTokens;
1777         }
1778     }
1779 
1780     _safeMint(msg.sender, numberOfTokens);
1781   }
1782 
1783   function setBaseURI(string memory baseURI)
1784     public
1785     onlyOwner
1786   {
1787     baseTokenURI = baseURI;
1788   }
1789 
1790   function treasuryMint(uint quantity)
1791     public
1792     onlyOwner
1793   {
1794     require(quantity > 0, "Invalid mint amount");
1795     require(totalSupply() + quantity <= maxSupply, "Maximum supply exceeded");
1796 
1797     _safeMint(msg.sender, quantity);
1798   }
1799 
1800   function withdraw()
1801     public
1802     onlyOwner
1803     nonReentrant
1804   {
1805     Address.sendValue(payable(msg.sender), address(this).balance);
1806   }
1807 
1808   function tokenURI(uint _tokenId)
1809     public
1810     view
1811     virtual
1812     override
1813     returns (string memory)
1814   {
1815     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1816     
1817     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1818   }
1819 
1820   function _baseURI()
1821     internal
1822     view
1823     virtual
1824     override
1825     returns (string memory)
1826   {
1827     return baseTokenURI;
1828   }
1829 
1830   function getIsPublicSaleActive() 
1831     public
1832     view 
1833     returns (bool) {
1834       return isPublicSaleActive;
1835   }
1836 
1837   function getFreeNftAlreadyMinted() 
1838     public
1839     view 
1840     returns (uint256) {
1841       return freeNFTAlreadyMinted;
1842   }
1843 
1844   function setIsPublicSaleActive(bool _isPublicSaleActive)
1845       external
1846       onlyOwner
1847   {
1848       isPublicSaleActive = _isPublicSaleActive;
1849   }
1850 
1851   function setNumFreeMints(uint256 _numfreemints)
1852       external
1853       onlyOwner
1854   {
1855       NUM_FREE_MINTS = _numfreemints;
1856   }
1857 
1858   function getSalePrice()
1859   public
1860   view
1861   returns (uint256)
1862   {
1863     return PUBLIC_SALE_PRICE;
1864   }
1865 
1866   function setSalePrice(uint256 _price)
1867       external
1868       onlyOwner
1869   {
1870       PUBLIC_SALE_PRICE = _price;
1871   }
1872 
1873   function setMaxLimitPerTransaction(uint256 _limit)
1874       external
1875       onlyOwner
1876   {
1877       MAX_MINTS_PER_TX = _limit;
1878   }
1879 
1880   function setFreeLimitPerWallet(uint256 _limit)
1881       external
1882       onlyOwner
1883   {
1884       MAX_FREE_PER_WALLET = _limit;
1885   }
1886 }