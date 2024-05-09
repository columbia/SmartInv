1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-20
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 // SPDX-License-Identifier: MIT
8 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17     uint8 private constant _ADDRESS_LENGTH = 20;
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 
75     /**
76      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
77      */
78     function toHexString(address addr) internal pure returns (string memory) {
79         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/Address.sol
84 
85 
86 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
87 
88 pragma solidity ^0.8.1;
89 
90 /**
91  * @dev Collection of functions related to the address type
92  */
93 library Address {
94     /**
95      * @dev Returns true if `account` is a contract.
96      *
97      * [IMPORTANT]
98      * ====
99      * It is unsafe to assume that an address for which this function returns
100      * false is an externally-owned account (EOA) and not a contract.
101      *
102      * Among others, `isContract` will return false for the following
103      * types of addresses:
104      *
105      *  - an externally-owned account
106      *  - a contract in construction
107      *  - an address where a contract will be created
108      *  - an address where a contract lived, but was destroyed
109      * ====
110      *
111      * [IMPORTANT]
112      * ====
113      * You shouldn't rely on `isContract` to protect against flash loan attacks!
114      *
115      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
116      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
117      * constructor.
118      * ====
119      */
120     function isContract(address account) internal view returns (bool) {
121         // This method relies on extcodesize/address.code.length, which returns 0
122         // for contracts in construction, since the code is only stored at the end
123         // of the constructor execution.
124 
125         return account.code.length > 0;
126     }
127 
128     /**
129      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
130      * `recipient`, forwarding all available gas and reverting on errors.
131      *
132      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
133      * of certain opcodes, possibly making contracts go over the 2300 gas limit
134      * imposed by `transfer`, making them unable to receive funds via
135      * `transfer`. {sendValue} removes this limitation.
136      *
137      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
138      *
139      * IMPORTANT: because control is transferred to `recipient`, care must be
140      * taken to not create reentrancy vulnerabilities. Consider using
141      * {ReentrancyGuard} or the
142      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
143      */
144     function sendValue(address payable recipient, uint256 amount) internal {
145         require(address(this).balance >= amount, "Address: insufficient balance");
146 
147         (bool success, ) = recipient.call{value: amount}("");
148         require(success, "Address: unable to send value, recipient may have reverted");
149     }
150 
151     /**
152      * @dev Performs a Solidity function call using a low level `call`. A
153      * plain `call` is an unsafe replacement for a function call: use this
154      * function instead.
155      *
156      * If `target` reverts with a revert reason, it is bubbled up by this
157      * function (like regular Solidity function calls).
158      *
159      * Returns the raw returned data. To convert to the expected return value,
160      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
161      *
162      * Requirements:
163      *
164      * - `target` must be a contract.
165      * - calling `target` with `data` must not revert.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionCall(target, data, "Address: low-level call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
175      * `errorMessage` as a fallback revert reason when `target` reverts.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, 0, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but also transferring `value` wei to `target`.
190      *
191      * Requirements:
192      *
193      * - the calling contract must have an ETH balance of at least `value`.
194      * - the called Solidity function must be `payable`.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(
199         address target,
200         bytes memory data,
201         uint256 value
202     ) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
208      * with `errorMessage` as a fallback revert reason when `target` reverts.
209      *
210      * _Available since v3.1._
211      */
212     function functionCallWithValue(
213         address target,
214         bytes memory data,
215         uint256 value,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         require(address(this).balance >= value, "Address: insufficient balance for call");
219         require(isContract(target), "Address: call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.call{value: value}(data);
222         return verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227      * but performing a static call.
228      *
229      * _Available since v3.3._
230      */
231     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
232         return functionStaticCall(target, data, "Address: low-level static call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal view returns (bytes memory) {
246         require(isContract(target), "Address: static call to non-contract");
247 
248         (bool success, bytes memory returndata) = target.staticcall(data);
249         return verifyCallResult(success, returndata, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but performing a delegate call.
255      *
256      * _Available since v3.4._
257      */
258     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
259         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(
269         address target,
270         bytes memory data,
271         string memory errorMessage
272     ) internal returns (bytes memory) {
273         require(isContract(target), "Address: delegate call to non-contract");
274 
275         (bool success, bytes memory returndata) = target.delegatecall(data);
276         return verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
281      * revert reason using the provided one.
282      *
283      * _Available since v4.3._
284      */
285     function verifyCallResult(
286         bool success,
287         bytes memory returndata,
288         string memory errorMessage
289     ) internal pure returns (bytes memory) {
290         if (success) {
291             return returndata;
292         } else {
293             // Look for revert reason and bubble it up if present
294             if (returndata.length > 0) {
295                 // The easiest way to bubble the revert reason is using memory via assembly
296                 /// @solidity memory-safe-assembly
297                 assembly {
298                     let returndata_size := mload(returndata)
299                     revert(add(32, returndata), returndata_size)
300                 }
301             } else {
302                 revert(errorMessage);
303             }
304         }
305     }
306 }
307 
308 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
309 
310 
311 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev Contract module that helps prevent reentrant calls to a function.
317  *
318  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
319  * available, which can be applied to functions to make sure there are no nested
320  * (reentrant) calls to them.
321  *
322  * Note that because there is a single `nonReentrant` guard, functions marked as
323  * `nonReentrant` may not call one another. This can be worked around by making
324  * those functions `private`, and then adding `external` `nonReentrant` entry
325  * points to them.
326  *
327  * TIP: If you would like to learn more about reentrancy and alternative ways
328  * to protect against it, check out our blog post
329  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
330  */
331 abstract contract ReentrancyGuard {
332     // Booleans are more expensive than uint256 or any type that takes up a full
333     // word because each write operation emits an extra SLOAD to first read the
334     // slot's contents, replace the bits taken up by the boolean, and then write
335     // back. This is the compiler's defense against contract upgrades and
336     // pointer aliasing, and it cannot be disabled.
337 
338     // The values being non-zero value makes deployment a bit more expensive,
339     // but in exchange the refund on every call to nonReentrant will be lower in
340     // amount. Since refunds are capped to a percentage of the total
341     // transaction's gas, it is best to keep them low in cases like this one, to
342     // increase the likelihood of the full refund coming into effect.
343     uint256 private constant _NOT_ENTERED = 1;
344     uint256 private constant _ENTERED = 2;
345 
346     uint256 private _status;
347 
348     constructor() {
349         _status = _NOT_ENTERED;
350     }
351 
352     /**
353      * @dev Prevents a contract from calling itself, directly or indirectly.
354      * Calling a `nonReentrant` function from another `nonReentrant`
355      * function is not supported. It is possible to prevent this from happening
356      * by making the `nonReentrant` function external, and making it call a
357      * `private` function that does the actual work.
358      */
359     modifier nonReentrant() {
360         // On the first call to nonReentrant, _notEntered will be true
361         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
362 
363         // Any calls to nonReentrant after this point will fail
364         _status = _ENTERED;
365 
366         _;
367 
368         // By storing the original value once again, a refund is triggered (see
369         // https://eips.ethereum.org/EIPS/eip-2200)
370         _status = _NOT_ENTERED;
371     }
372 }
373 
374 // File: @openzeppelin/contracts/utils/Context.sol
375 
376 
377 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @dev Provides information about the current execution context, including the
383  * sender of the transaction and its data. While these are generally available
384  * via msg.sender and msg.data, they should not be accessed in such a direct
385  * manner, since when dealing with meta-transactions the account sending and
386  * paying for execution may not be the actual sender (as far as an application
387  * is concerned).
388  *
389  * This contract is only required for intermediate, library-like contracts.
390  */
391 abstract contract Context {
392     function _msgSender() internal view virtual returns (address) {
393         return msg.sender;
394     }
395 
396     function _msgData() internal view virtual returns (bytes calldata) {
397         return msg.data;
398     }
399 }
400 
401 // File: @openzeppelin/contracts/access/Ownable.sol
402 
403 
404 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 
409 /**
410  * @dev Contract module which provides a basic access control mechanism, where
411  * there is an account (an owner) that can be granted exclusive access to
412  * specific functions.
413  *
414  * By default, the owner account will be the one that deploys the contract. This
415  * can later be changed with {transferOwnership}.
416  *
417  * This module is used through inheritance. It will make available the modifier
418  * `onlyOwner`, which can be applied to your functions to restrict their use to
419  * the owner.
420  */
421 abstract contract Ownable is Context {
422     address private _owner;
423 
424     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
425 
426     /**
427      * @dev Initializes the contract setting the deployer as the initial owner.
428      */
429     constructor() {
430         _transferOwnership(_msgSender());
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         _checkOwner();
438         _;
439     }
440 
441     /**
442      * @dev Returns the address of the current owner.
443      */
444     function owner() public view virtual returns (address) {
445         return _owner;
446     }
447 
448     /**
449      * @dev Throws if the sender is not the owner.
450      */
451     function _checkOwner() internal view virtual {
452         require(owner() == _msgSender(), "Ownable: caller is not the owner");
453     }
454 
455     /**
456      * @dev Leaves the contract without owner. It will not be possible to call
457      * `onlyOwner` functions anymore. Can only be called by the current owner.
458      *
459      * NOTE: Renouncing ownership will leave the contract without an owner,
460      * thereby removing any functionality that is only available to the owner.
461      */
462     function renounceOwnership() public virtual onlyOwner {
463         _transferOwnership(address(0));
464     }
465 
466     /**
467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
468      * Can only be called by the current owner.
469      */
470     function transferOwnership(address newOwner) public virtual onlyOwner {
471         require(newOwner != address(0), "Ownable: new owner is the zero address");
472         _transferOwnership(newOwner);
473     }
474 
475     /**
476      * @dev Transfers ownership of the contract to a new account (`newOwner`).
477      * Internal function without access restriction.
478      */
479     function _transferOwnership(address newOwner) internal virtual {
480         address oldOwner = _owner;
481         _owner = newOwner;
482         emit OwnershipTransferred(oldOwner, newOwner);
483     }
484 }
485 
486 // File: erc721a/contracts/IERC721A.sol
487 
488 
489 // ERC721A Contracts v4.1.0
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
769 
770 pragma solidity ^0.8.4;
771 
772 
773 /**
774  * @dev ERC721 token receiver interface.
775  */
776 interface ERC721A__IERC721Receiver {
777     function onERC721Received(
778         address operator,
779         address from,
780         uint256 tokenId,
781         bytes calldata data
782     ) external returns (bytes4);
783 }
784 
785 /**
786  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
787  * including the Metadata extension. Built to optimize for lower gas during batch mints.
788  *
789  * Assumes serials are sequentially minted starting at `_startTokenId()`
790  * (defaults to 0, e.g. 0, 1, 2, 3..).
791  *
792  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
793  *
794  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
795  */
796 contract ERC721A is IERC721A {
797     // Mask of an entry in packed address data.
798     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
799 
800     // The bit position of `numberMinted` in packed address data.
801     uint256 private constant BITPOS_NUMBER_MINTED = 64;
802 
803     // The bit position of `numberBurned` in packed address data.
804     uint256 private constant BITPOS_NUMBER_BURNED = 128;
805 
806     // The bit position of `aux` in packed address data.
807     uint256 private constant BITPOS_AUX = 192;
808 
809     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
810     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
811 
812     // The bit position of `startTimestamp` in packed ownership.
813     uint256 private constant BITPOS_START_TIMESTAMP = 160;
814 
815     // The bit mask of the `burned` bit in packed ownership.
816     uint256 private constant BITMASK_BURNED = 1 << 224;
817 
818     // The bit position of the `nextInitialized` bit in packed ownership.
819     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
820 
821     // The bit mask of the `nextInitialized` bit in packed ownership.
822     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
823 
824     // The bit position of `extraData` in packed ownership.
825     uint256 private constant BITPOS_EXTRA_DATA = 232;
826 
827     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
828     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
829 
830     // The mask of the lower 160 bits for addresses.
831     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
832 
833     // The maximum `quantity` that can be minted with `_mintERC2309`.
834     // This limit is to prevent overflows on the address data entries.
835     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
836     // is required to cause an overflow, which is unrealistic.
837     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
838 
839     // The tokenId of the next token to be minted.
840     uint256 private _currentIndex;
841 
842     // The number of tokens burned.
843     uint256 private _burnCounter;
844 
845     // Token name
846     string private _name;
847 
848     // Token symbol
849     string private _symbol;
850 
851     // Mapping from token ID to ownership details
852     // An empty struct value does not necessarily mean the token is unowned.
853     // See `_packedOwnershipOf` implementation for details.
854     //
855     // Bits Layout:
856     // - [0..159]   `addr`
857     // - [160..223] `startTimestamp`
858     // - [224]      `burned`
859     // - [225]      `nextInitialized`
860     // - [232..255] `extraData`
861     mapping(uint256 => uint256) private _packedOwnerships;
862 
863     // Mapping owner address to address data.
864     //
865     // Bits Layout:
866     // - [0..63]    `balance`
867     // - [64..127]  `numberMinted`
868     // - [128..191] `numberBurned`
869     // - [192..255] `aux`
870     mapping(address => uint256) private _packedAddressData;
871 
872     // Mapping from token ID to approved address.
873     mapping(uint256 => address) private _tokenApprovals;
874 
875     // Mapping from owner to operator approvals
876     mapping(address => mapping(address => bool)) private _operatorApprovals;
877 
878     constructor(string memory name_, string memory symbol_) {
879         _name = name_;
880         _symbol = symbol_;
881         _currentIndex = _startTokenId();
882     }
883 
884     /**
885      * @dev Returns the starting token ID.
886      * To change the starting token ID, please override this function.
887      */
888     function _startTokenId() internal view virtual returns (uint256) {
889         return 0;
890     }
891 
892     /**
893      * @dev Returns the next token ID to be minted.
894      */
895     function _nextTokenId() internal view returns (uint256) {
896         return _currentIndex;
897     }
898 
899     /**
900      * @dev Returns the total number of tokens in existence.
901      * Burned tokens will reduce the count.
902      * To get the total number of tokens minted, please see `_totalMinted`.
903      */
904     function totalSupply() public view override returns (uint256) {
905         // Counter underflow is impossible as _burnCounter cannot be incremented
906         // more than `_currentIndex - _startTokenId()` times.
907         unchecked {
908             return _currentIndex - _burnCounter - _startTokenId();
909         }
910     }
911 
912     /**
913      * @dev Returns the total amount of tokens minted in the contract.
914      */
915     function _totalMinted() internal view returns (uint256) {
916         // Counter underflow is impossible as _currentIndex does not decrement,
917         // and it is initialized to `_startTokenId()`
918         unchecked {
919             return _currentIndex - _startTokenId();
920         }
921     }
922 
923     /**
924      * @dev Returns the total number of tokens burned.
925      */
926     function _totalBurned() internal view returns (uint256) {
927         return _burnCounter;
928     }
929 
930     /**
931      * @dev See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
934         // The interface IDs are constants representing the first 4 bytes of the XOR of
935         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
936         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
937         return
938             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
939             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
940             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
941     }
942 
943     /**
944      * @dev See {IERC721-balanceOf}.
945      */
946     function balanceOf(address owner) public view override returns (uint256) {
947         if (owner == address(0)) revert BalanceQueryForZeroAddress();
948         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
949     }
950 
951     /**
952      * Returns the number of tokens minted by `owner`.
953      */
954     function _numberMinted(address owner) internal view returns (uint256) {
955         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
956     }
957 
958     /**
959      * Returns the number of tokens burned by or on behalf of `owner`.
960      */
961     function _numberBurned(address owner) internal view returns (uint256) {
962         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
963     }
964 
965     /**
966      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
967      */
968     function _getAux(address owner) internal view returns (uint64) {
969         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
970     }
971 
972     /**
973      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
974      * If there are multiple variables, please pack them into a uint64.
975      */
976     function _setAux(address owner, uint64 aux) internal {
977         uint256 packed = _packedAddressData[owner];
978         uint256 auxCasted;
979         // Cast `aux` with assembly to avoid redundant masking.
980         assembly {
981             auxCasted := aux
982         }
983         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
984         _packedAddressData[owner] = packed;
985     }
986 
987     /**
988      * Returns the packed ownership data of `tokenId`.
989      */
990     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
991         uint256 curr = tokenId;
992 
993         unchecked {
994             if (_startTokenId() <= curr)
995                 if (curr < _currentIndex) {
996                     uint256 packed = _packedOwnerships[curr];
997                     // If not burned.
998                     if (packed & BITMASK_BURNED == 0) {
999                         // Invariant:
1000                         // There will always be an ownership that has an address and is not burned
1001                         // before an ownership that does not have an address and is not burned.
1002                         // Hence, curr will not underflow.
1003                         //
1004                         // We can directly compare the packed value.
1005                         // If the address is zero, packed is zero.
1006                         while (packed == 0) {
1007                             packed = _packedOwnerships[--curr];
1008                         }
1009                         return packed;
1010                     }
1011                 }
1012         }
1013         revert OwnerQueryForNonexistentToken();
1014     }
1015 
1016     /**
1017      * Returns the unpacked `TokenOwnership` struct from `packed`.
1018      */
1019     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1020         ownership.addr = address(uint160(packed));
1021         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1022         ownership.burned = packed & BITMASK_BURNED != 0;
1023         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1024     }
1025 
1026     /**
1027      * Returns the unpacked `TokenOwnership` struct at `index`.
1028      */
1029     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1030         return _unpackedOwnership(_packedOwnerships[index]);
1031     }
1032 
1033     /**
1034      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1035      */
1036     function _initializeOwnershipAt(uint256 index) internal {
1037         if (_packedOwnerships[index] == 0) {
1038             _packedOwnerships[index] = _packedOwnershipOf(index);
1039         }
1040     }
1041 
1042     /**
1043      * Gas spent here starts off proportional to the maximum mint batch size.
1044      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1045      */
1046     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1047         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1048     }
1049 
1050     /**
1051      * @dev Packs ownership data into a single uint256.
1052      */
1053     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1054         assembly {
1055             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1056             owner := and(owner, BITMASK_ADDRESS)
1057             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1058             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1059         }
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-ownerOf}.
1064      */
1065     function ownerOf(uint256 tokenId) public view override returns (address) {
1066         return address(uint160(_packedOwnershipOf(tokenId)));
1067     }
1068 
1069     /**
1070      * @dev See {IERC721Metadata-name}.
1071      */
1072     function name() public view virtual override returns (string memory) {
1073         return _name;
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Metadata-symbol}.
1078      */
1079     function symbol() public view virtual override returns (string memory) {
1080         return _symbol;
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Metadata-tokenURI}.
1085      */
1086     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1087         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1088 
1089         string memory baseURI = _baseURI();
1090         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1091     }
1092 
1093     /**
1094      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1095      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1096      * by default, it can be overridden in child contracts.
1097      */
1098     function _baseURI() internal view virtual returns (string memory) {
1099         return '';
1100     }
1101 
1102     /**
1103      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1104      */
1105     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1106         // For branchless setting of the `nextInitialized` flag.
1107         assembly {
1108             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1109             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1110         }
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-approve}.
1115      */
1116     function approve(address to, uint256 tokenId) public override {
1117         address owner = ownerOf(tokenId);
1118 
1119         if (_msgSenderERC721A() != owner)
1120             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1121                 revert ApprovalCallerNotOwnerNorApproved();
1122             }
1123 
1124         _tokenApprovals[tokenId] = to;
1125         emit Approval(owner, to, tokenId);
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-getApproved}.
1130      */
1131     function getApproved(uint256 tokenId) public view override returns (address) {
1132         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1133 
1134         return _tokenApprovals[tokenId];
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-setApprovalForAll}.
1139      */
1140     function setApprovalForAll(address operator, bool approved) public virtual override {
1141         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1142 
1143         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1144         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-isApprovedForAll}.
1149      */
1150     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1151         return _operatorApprovals[owner][operator];
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-safeTransferFrom}.
1156      */
1157     function safeTransferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) public virtual override {
1162         safeTransferFrom(from, to, tokenId, '');
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-safeTransferFrom}.
1167      */
1168     function safeTransferFrom(
1169         address from,
1170         address to,
1171         uint256 tokenId,
1172         bytes memory _data
1173     ) public virtual override {
1174         transferFrom(from, to, tokenId);
1175         if (to.code.length != 0)
1176             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1177                 revert TransferToNonERC721ReceiverImplementer();
1178             }
1179     }
1180 
1181     /**
1182      * @dev Returns whether `tokenId` exists.
1183      *
1184      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1185      *
1186      * Tokens start existing when they are minted (`_mint`),
1187      */
1188     function _exists(uint256 tokenId) internal view returns (bool) {
1189         return
1190             _startTokenId() <= tokenId &&
1191             tokenId < _currentIndex && // If within bounds,
1192             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1193     }
1194 
1195     /**
1196      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1197      */
1198     function _safeMint(address to, uint256 quantity) internal {
1199         _safeMint(to, quantity, '');
1200     }
1201 
1202     /**
1203      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1204      *
1205      * Requirements:
1206      *
1207      * - If `to` refers to a smart contract, it must implement
1208      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1209      * - `quantity` must be greater than 0.
1210      *
1211      * See {_mint}.
1212      *
1213      * Emits a {Transfer} event for each mint.
1214      */
1215     function _safeMint(
1216         address to,
1217         uint256 quantity,
1218         bytes memory _data
1219     ) internal {
1220         _mint(to, quantity);
1221 
1222         unchecked {
1223             if (to.code.length != 0) {
1224                 uint256 end = _currentIndex;
1225                 uint256 index = end - quantity;
1226                 do {
1227                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1228                         revert TransferToNonERC721ReceiverImplementer();
1229                     }
1230                 } while (index < end);
1231                 // Reentrancy protection.
1232                 if (_currentIndex != end) revert();
1233             }
1234         }
1235     }
1236 
1237     /**
1238      * @dev Mints `quantity` tokens and transfers them to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - `to` cannot be the zero address.
1243      * - `quantity` must be greater than 0.
1244      *
1245      * Emits a {Transfer} event for each mint.
1246      */
1247     function _mint(address to, uint256 quantity) internal {
1248         uint256 startTokenId = _currentIndex;
1249         if (to == address(0)) revert MintToZeroAddress();
1250         if (quantity == 0) revert MintZeroQuantity();
1251 
1252         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1253 
1254         // Overflows are incredibly unrealistic.
1255         // `balance` and `numberMinted` have a maximum limit of 2**64.
1256         // `tokenId` has a maximum limit of 2**256.
1257         unchecked {
1258             // Updates:
1259             // - `balance += quantity`.
1260             // - `numberMinted += quantity`.
1261             //
1262             // We can directly add to the `balance` and `numberMinted`.
1263             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1264 
1265             // Updates:
1266             // - `address` to the owner.
1267             // - `startTimestamp` to the timestamp of minting.
1268             // - `burned` to `false`.
1269             // - `nextInitialized` to `quantity == 1`.
1270             _packedOwnerships[startTokenId] = _packOwnershipData(
1271                 to,
1272                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1273             );
1274 
1275             uint256 tokenId = startTokenId;
1276             uint256 end = startTokenId + quantity;
1277             do {
1278                 emit Transfer(address(0), to, tokenId++);
1279             } while (tokenId < end);
1280 
1281             _currentIndex = end;
1282         }
1283         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1284     }
1285 
1286     /**
1287      * @dev Mints `quantity` tokens and transfers them to `to`.
1288      *
1289      * This function is intended for efficient minting only during contract creation.
1290      *
1291      * It emits only one {ConsecutiveTransfer} as defined in
1292      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1293      * instead of a sequence of {Transfer} event(s).
1294      *
1295      * Calling this function outside of contract creation WILL make your contract
1296      * non-compliant with the ERC721 standard.
1297      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1298      * {ConsecutiveTransfer} event is only permissible during contract creation.
1299      *
1300      * Requirements:
1301      *
1302      * - `to` cannot be the zero address.
1303      * - `quantity` must be greater than 0.
1304      *
1305      * Emits a {ConsecutiveTransfer} event.
1306      */
1307     function _mintERC2309(address to, uint256 quantity) internal {
1308         uint256 startTokenId = _currentIndex;
1309         if (to == address(0)) revert MintToZeroAddress();
1310         if (quantity == 0) revert MintZeroQuantity();
1311         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1312 
1313         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1314 
1315         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1316         unchecked {
1317             // Updates:
1318             // - `balance += quantity`.
1319             // - `numberMinted += quantity`.
1320             //
1321             // We can directly add to the `balance` and `numberMinted`.
1322             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1323 
1324             // Updates:
1325             // - `address` to the owner.
1326             // - `startTimestamp` to the timestamp of minting.
1327             // - `burned` to `false`.
1328             // - `nextInitialized` to `quantity == 1`.
1329             _packedOwnerships[startTokenId] = _packOwnershipData(
1330                 to,
1331                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1332             );
1333 
1334             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1335 
1336             _currentIndex = startTokenId + quantity;
1337         }
1338         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1339     }
1340 
1341     /**
1342      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1343      */
1344     function _getApprovedAddress(uint256 tokenId)
1345         private
1346         view
1347         returns (uint256 approvedAddressSlot, address approvedAddress)
1348     {
1349         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1350         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1351         assembly {
1352             // Compute the slot.
1353             mstore(0x00, tokenId)
1354             mstore(0x20, tokenApprovalsPtr.slot)
1355             approvedAddressSlot := keccak256(0x00, 0x40)
1356             // Load the slot's value from storage.
1357             approvedAddress := sload(approvedAddressSlot)
1358         }
1359     }
1360 
1361     /**
1362      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1363      */
1364     function _isOwnerOrApproved(
1365         address approvedAddress,
1366         address from,
1367         address msgSender
1368     ) private pure returns (bool result) {
1369         assembly {
1370             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1371             from := and(from, BITMASK_ADDRESS)
1372             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1373             msgSender := and(msgSender, BITMASK_ADDRESS)
1374             // `msgSender == from || msgSender == approvedAddress`.
1375             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1376         }
1377     }
1378 
1379     /**
1380      * @dev Transfers `tokenId` from `from` to `to`.
1381      *
1382      * Requirements:
1383      *
1384      * - `to` cannot be the zero address.
1385      * - `tokenId` token must be owned by `from`.
1386      *
1387      * Emits a {Transfer} event.
1388      */
1389     function transferFrom(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) public virtual override {
1394         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1395 
1396         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1397 
1398         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1399 
1400         // The nested ifs save around 20+ gas over a compound boolean condition.
1401         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1402             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1403 
1404         if (to == address(0)) revert TransferToZeroAddress();
1405 
1406         _beforeTokenTransfers(from, to, tokenId, 1);
1407 
1408         // Clear approvals from the previous owner.
1409         assembly {
1410             if approvedAddress {
1411                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1412                 sstore(approvedAddressSlot, 0)
1413             }
1414         }
1415 
1416         // Underflow of the sender's balance is impossible because we check for
1417         // ownership above and the recipient's balance can't realistically overflow.
1418         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1419         unchecked {
1420             // We can directly increment and decrement the balances.
1421             --_packedAddressData[from]; // Updates: `balance -= 1`.
1422             ++_packedAddressData[to]; // Updates: `balance += 1`.
1423 
1424             // Updates:
1425             // - `address` to the next owner.
1426             // - `startTimestamp` to the timestamp of transfering.
1427             // - `burned` to `false`.
1428             // - `nextInitialized` to `true`.
1429             _packedOwnerships[tokenId] = _packOwnershipData(
1430                 to,
1431                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1432             );
1433 
1434             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1435             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1436                 uint256 nextTokenId = tokenId + 1;
1437                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1438                 if (_packedOwnerships[nextTokenId] == 0) {
1439                     // If the next slot is within bounds.
1440                     if (nextTokenId != _currentIndex) {
1441                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1442                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1443                     }
1444                 }
1445             }
1446         }
1447 
1448         emit Transfer(from, to, tokenId);
1449         _afterTokenTransfers(from, to, tokenId, 1);
1450     }
1451 
1452     /**
1453      * @dev Equivalent to `_burn(tokenId, false)`.
1454      */
1455     function _burn(uint256 tokenId) internal virtual {
1456         _burn(tokenId, false);
1457     }
1458 
1459     /**
1460      * @dev Destroys `tokenId`.
1461      * The approval is cleared when the token is burned.
1462      *
1463      * Requirements:
1464      *
1465      * - `tokenId` must exist.
1466      *
1467      * Emits a {Transfer} event.
1468      */
1469     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1470         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1471 
1472         address from = address(uint160(prevOwnershipPacked));
1473 
1474         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1475 
1476         if (approvalCheck) {
1477             // The nested ifs save around 20+ gas over a compound boolean condition.
1478             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1479                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1480         }
1481 
1482         _beforeTokenTransfers(from, address(0), tokenId, 1);
1483 
1484         // Clear approvals from the previous owner.
1485         assembly {
1486             if approvedAddress {
1487                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1488                 sstore(approvedAddressSlot, 0)
1489             }
1490         }
1491 
1492         // Underflow of the sender's balance is impossible because we check for
1493         // ownership above and the recipient's balance can't realistically overflow.
1494         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1495         unchecked {
1496             // Updates:
1497             // - `balance -= 1`.
1498             // - `numberBurned += 1`.
1499             //
1500             // We can directly decrement the balance, and increment the number burned.
1501             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1502             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1503 
1504             // Updates:
1505             // - `address` to the last owner.
1506             // - `startTimestamp` to the timestamp of burning.
1507             // - `burned` to `true`.
1508             // - `nextInitialized` to `true`.
1509             _packedOwnerships[tokenId] = _packOwnershipData(
1510                 from,
1511                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1512             );
1513 
1514             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1515             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1516                 uint256 nextTokenId = tokenId + 1;
1517                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1518                 if (_packedOwnerships[nextTokenId] == 0) {
1519                     // If the next slot is within bounds.
1520                     if (nextTokenId != _currentIndex) {
1521                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1522                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1523                     }
1524                 }
1525             }
1526         }
1527 
1528         emit Transfer(from, address(0), tokenId);
1529         _afterTokenTransfers(from, address(0), tokenId, 1);
1530 
1531         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1532         unchecked {
1533             _burnCounter++;
1534         }
1535     }
1536 
1537     /**
1538      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1539      *
1540      * @param from address representing the previous owner of the given token ID
1541      * @param to target address that will receive the tokens
1542      * @param tokenId uint256 ID of the token to be transferred
1543      * @param _data bytes optional data to send along with the call
1544      * @return bool whether the call correctly returned the expected magic value
1545      */
1546     function _checkContractOnERC721Received(
1547         address from,
1548         address to,
1549         uint256 tokenId,
1550         bytes memory _data
1551     ) private returns (bool) {
1552         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1553             bytes4 retval
1554         ) {
1555             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1556         } catch (bytes memory reason) {
1557             if (reason.length == 0) {
1558                 revert TransferToNonERC721ReceiverImplementer();
1559             } else {
1560                 assembly {
1561                     revert(add(32, reason), mload(reason))
1562                 }
1563             }
1564         }
1565     }
1566 
1567     /**
1568      * @dev Directly sets the extra data for the ownership data `index`.
1569      */
1570     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1571         uint256 packed = _packedOwnerships[index];
1572         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1573         uint256 extraDataCasted;
1574         // Cast `extraData` with assembly to avoid redundant masking.
1575         assembly {
1576             extraDataCasted := extraData
1577         }
1578         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1579         _packedOwnerships[index] = packed;
1580     }
1581 
1582     /**
1583      * @dev Returns the next extra data for the packed ownership data.
1584      * The returned result is shifted into position.
1585      */
1586     function _nextExtraData(
1587         address from,
1588         address to,
1589         uint256 prevOwnershipPacked
1590     ) private view returns (uint256) {
1591         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1592         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1593     }
1594 
1595     /**
1596      * @dev Called during each token transfer to set the 24bit `extraData` field.
1597      * Intended to be overridden by the cosumer contract.
1598      *
1599      * `previousExtraData` - the value of `extraData` before transfer.
1600      *
1601      * Calling conditions:
1602      *
1603      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1604      * transferred to `to`.
1605      * - When `from` is zero, `tokenId` will be minted for `to`.
1606      * - When `to` is zero, `tokenId` will be burned by `from`.
1607      * - `from` and `to` are never both zero.
1608      */
1609     function _extraData(
1610         address from,
1611         address to,
1612         uint24 previousExtraData
1613     ) internal view virtual returns (uint24) {}
1614 
1615     /**
1616      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1617      * This includes minting.
1618      * And also called before burning one token.
1619      *
1620      * startTokenId - the first token id to be transferred
1621      * quantity - the amount to be transferred
1622      *
1623      * Calling conditions:
1624      *
1625      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1626      * transferred to `to`.
1627      * - When `from` is zero, `tokenId` will be minted for `to`.
1628      * - When `to` is zero, `tokenId` will be burned by `from`.
1629      * - `from` and `to` are never both zero.
1630      */
1631     function _beforeTokenTransfers(
1632         address from,
1633         address to,
1634         uint256 startTokenId,
1635         uint256 quantity
1636     ) internal virtual {}
1637 
1638     /**
1639      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1640      * This includes minting.
1641      * And also called after one token has been burned.
1642      *
1643      * startTokenId - the first token id to be transferred
1644      * quantity - the amount to be transferred
1645      *
1646      * Calling conditions:
1647      *
1648      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1649      * transferred to `to`.
1650      * - When `from` is zero, `tokenId` has been minted for `to`.
1651      * - When `to` is zero, `tokenId` has been burned by `from`.
1652      * - `from` and `to` are never both zero.
1653      */
1654     function _afterTokenTransfers(
1655         address from,
1656         address to,
1657         uint256 startTokenId,
1658         uint256 quantity
1659     ) internal virtual {}
1660 
1661     /**
1662      * @dev Returns the message sender (defaults to `msg.sender`).
1663      *
1664      * If you are writing GSN compatible contracts, you need to override this function.
1665      */
1666     function _msgSenderERC721A() internal view virtual returns (address) {
1667         return msg.sender;
1668     }
1669 
1670     /**
1671      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1672      */
1673     function _toString(uint256 value) internal pure returns (string memory ptr) {
1674         assembly {
1675             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1676             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1677             // We will need 1 32-byte word to store the length,
1678             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1679             ptr := add(mload(0x40), 128)
1680             // Update the free memory pointer to allocate.
1681             mstore(0x40, ptr)
1682 
1683             // Cache the end of the memory to calculate the length later.
1684             let end := ptr
1685 
1686             // We write the string from the rightmost digit to the leftmost digit.
1687             // The following is essentially a do-while loop that also handles the zero case.
1688             // Costs a bit more than early returning for the zero case,
1689             // but cheaper in terms of deployment and overall runtime costs.
1690             for {
1691                 // Initialize and perform the first pass without check.
1692                 let temp := value
1693                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1694                 ptr := sub(ptr, 1)
1695                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1696                 mstore8(ptr, add(48, mod(temp, 10)))
1697                 temp := div(temp, 10)
1698             } temp {
1699                 // Keep dividing `temp` until zero.
1700                 temp := div(temp, 10)
1701             } {
1702                 // Body of the for loop.
1703                 ptr := sub(ptr, 1)
1704                 mstore8(ptr, add(48, mod(temp, 10)))
1705             }
1706 
1707             let length := sub(end, ptr)
1708             // Move the pointer 32 bytes leftwards to make room for the length.
1709             ptr := sub(ptr, 32)
1710             // Store the length.
1711             mstore(ptr, length)
1712         }
1713     }
1714 }
1715 
1716 // File: contract.sol
1717 
1718 
1719 pragma solidity ^0.8.7;
1720 
1721 
1722 
1723 
1724 
1725 
1726 contract Potatoztown is ERC721A, Ownable, ReentrancyGuard {
1727   using Address for address;
1728   using Strings for uint;
1729 
1730   string  public  baseTokenURI = "";
1731   bool public isPublicSaleActive = false;
1732 
1733   uint256 public  maxSupply = 5555;
1734   uint256 public  MAX_MINTS_PER_TX = 20;
1735   uint256 public  PUBLIC_SALE_PRICE = 0.003 ether;
1736   uint256 public  NUM_FREE_MINTS = 5555;
1737   uint256 public  MAX_FREE_PER_WALLET = 1;
1738   uint256 public  freeNFTAlreadyMinted = 0;
1739 
1740   constructor() ERC721A("potatoztown", "POTATOZ") {}
1741 
1742   function mint(uint256 numberOfTokens) external payable
1743   {
1744     require(isPublicSaleActive, "Public sale is paused.");
1745     require(totalSupply() + numberOfTokens < maxSupply + 1, "Maximum supply exceeded.");
1746 
1747     require(numberOfTokens <= MAX_MINTS_PER_TX, "Maximum mints per transaction exceeded.");
1748 
1749     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS)
1750     {
1751         require(PUBLIC_SALE_PRICE * numberOfTokens <= msg.value, "Invalid ETH value sent. Error Code: 1");
1752     } 
1753     else 
1754     {
1755         uint sender_balance = balanceOf(msg.sender);
1756         
1757         if (sender_balance + numberOfTokens > MAX_FREE_PER_WALLET) 
1758         { 
1759             if (sender_balance < MAX_FREE_PER_WALLET)
1760             {
1761                 uint free_available = MAX_FREE_PER_WALLET - sender_balance;
1762                 uint to_be_paid = numberOfTokens - free_available;
1763                 require(PUBLIC_SALE_PRICE * to_be_paid <= msg.value, "Invalid ETH value sent. Error Code: 2");
1764 
1765                 freeNFTAlreadyMinted += free_available;
1766             }
1767             else
1768             {
1769                 require(PUBLIC_SALE_PRICE * numberOfTokens <= msg.value, "Invalid ETH value sent. Error Code: 3");
1770             }
1771         }  
1772         else 
1773         {
1774             require(numberOfTokens <= MAX_FREE_PER_WALLET, "Maximum mints per transaction exceeded");
1775             freeNFTAlreadyMinted += numberOfTokens;
1776         }
1777     }
1778 
1779     _safeMint(msg.sender, numberOfTokens);
1780   }
1781 
1782   function setBaseURI(string memory baseURI)
1783     public
1784     onlyOwner
1785   {
1786     baseTokenURI = baseURI;
1787   }
1788 
1789   function treasuryMint(uint quantity)
1790     public
1791     onlyOwner
1792   {
1793     require(quantity > 0, "Invalid mint amount");
1794     require(totalSupply() + quantity <= maxSupply, "Maximum supply exceeded");
1795 
1796     _safeMint(msg.sender, quantity);
1797   }
1798 
1799   function withdraw()
1800     public
1801     onlyOwner
1802     nonReentrant
1803   {
1804     Address.sendValue(payable(msg.sender), address(this).balance);
1805   }
1806 
1807   function tokenURI(uint _tokenId)
1808     public
1809     view
1810     virtual
1811     override
1812     returns (string memory)
1813   {
1814     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1815     
1816     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1817   }
1818 
1819   function _baseURI()
1820     internal
1821     view
1822     virtual
1823     override
1824     returns (string memory)
1825   {
1826     return baseTokenURI;
1827   }
1828 
1829   function getIsPublicSaleActive() 
1830     public
1831     view 
1832     returns (bool) {
1833       return isPublicSaleActive;
1834   }
1835 
1836   function getFreeNftAlreadyMinted() 
1837     public
1838     view 
1839     returns (uint256) {
1840       return freeNFTAlreadyMinted;
1841   }
1842 
1843   function setIsPublicSaleActive(bool _isPublicSaleActive)
1844       external
1845       onlyOwner
1846   {
1847       isPublicSaleActive = _isPublicSaleActive;
1848   }
1849 
1850   function setNumFreeMints(uint256 _numfreemints)
1851       external
1852       onlyOwner
1853   {
1854       NUM_FREE_MINTS = _numfreemints;
1855   }
1856 
1857   function getSalePrice()
1858   public
1859   view
1860   returns (uint256)
1861   {
1862     return PUBLIC_SALE_PRICE;
1863   }
1864 
1865   function setSalePrice(uint256 _price)
1866       external
1867       onlyOwner
1868   {
1869       PUBLIC_SALE_PRICE = _price;
1870   }
1871 
1872   function setMaxLimitPerTransaction(uint256 _limit)
1873       external
1874       onlyOwner
1875   {
1876       MAX_MINTS_PER_TX = _limit;
1877   }
1878 
1879   function setFreeLimitPerWallet(uint256 _limit)
1880       external
1881       onlyOwner
1882   {
1883       MAX_FREE_PER_WALLET = _limit;
1884   }
1885 }