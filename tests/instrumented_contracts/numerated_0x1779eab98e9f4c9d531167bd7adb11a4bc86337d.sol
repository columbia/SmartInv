1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-26
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Strings.sol
7 
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
490 // Creator: Chiru Labs
491 
492 pragma solidity ^0.8.4;
493 
494 /**
495  * @dev Interface of an ERC721A compliant contract.
496  */
497 interface IERC721A {
498     /**
499      * The caller must own the token or be an approved operator.
500      */
501     error ApprovalCallerNotOwnerNorApproved();
502 
503     /**
504      * The token does not exist.
505      */
506     error ApprovalQueryForNonexistentToken();
507 
508     /**
509      * The caller cannot approve to their own address.
510      */
511     error ApproveToCaller();
512 
513     /**
514      * Cannot query the balance for the zero address.
515      */
516     error BalanceQueryForZeroAddress();
517 
518     /**
519      * Cannot mint to the zero address.
520      */
521     error MintToZeroAddress();
522 
523     /**
524      * The quantity of tokens minted must be more than zero.
525      */
526     error MintZeroQuantity();
527 
528     /**
529      * The token does not exist.
530      */
531     error OwnerQueryForNonexistentToken();
532 
533     /**
534      * The caller must own the token or be an approved operator.
535      */
536     error TransferCallerNotOwnerNorApproved();
537 
538     /**
539      * The token must be owned by `from`.
540      */
541     error TransferFromIncorrectOwner();
542 
543     /**
544      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
545      */
546     error TransferToNonERC721ReceiverImplementer();
547 
548     /**
549      * Cannot transfer to the zero address.
550      */
551     error TransferToZeroAddress();
552 
553     /**
554      * The token does not exist.
555      */
556     error URIQueryForNonexistentToken();
557 
558     /**
559      * The `quantity` minted with ERC2309 exceeds the safety limit.
560      */
561     error MintERC2309QuantityExceedsLimit();
562 
563     /**
564      * The `extraData` cannot be set on an unintialized ownership slot.
565      */
566     error OwnershipNotInitializedForExtraData();
567 
568     struct TokenOwnership {
569         // The address of the owner.
570         address addr;
571         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
572         uint64 startTimestamp;
573         // Whether the token has been burned.
574         bool burned;
575         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
576         uint24 extraData;
577     }
578 
579     /**
580      * @dev Returns the total amount of tokens stored by the contract.
581      *
582      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
583      */
584     function totalSupply() external view returns (uint256);
585 
586     // ==============================
587     //            IERC165
588     // ==============================
589 
590     /**
591      * @dev Returns true if this contract implements the interface defined by
592      * `interfaceId`. See the corresponding
593      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
594      * to learn more about how these ids are created.
595      *
596      * This function call must use less than 30 000 gas.
597      */
598     function supportsInterface(bytes4 interfaceId) external view returns (bool);
599 
600     // ==============================
601     //            IERC721
602     // ==============================
603 
604     /**
605      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
606      */
607     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
608 
609     /**
610      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
611      */
612     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
613 
614     /**
615      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
616      */
617     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
618 
619     /**
620      * @dev Returns the number of tokens in ``owner``'s account.
621      */
622     function balanceOf(address owner) external view returns (uint256 balance);
623 
624     /**
625      * @dev Returns the owner of the `tokenId` token.
626      *
627      * Requirements:
628      *
629      * - `tokenId` must exist.
630      */
631     function ownerOf(uint256 tokenId) external view returns (address owner);
632 
633     /**
634      * @dev Safely transfers `tokenId` token from `from` to `to`.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must exist and be owned by `from`.
641      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
642      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
643      *
644      * Emits a {Transfer} event.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId,
650         bytes calldata data
651     ) external;
652 
653     /**
654      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
655      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
656      *
657      * Requirements:
658      *
659      * - `from` cannot be the zero address.
660      * - `to` cannot be the zero address.
661      * - `tokenId` token must exist and be owned by `from`.
662      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
663      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
664      *
665      * Emits a {Transfer} event.
666      */
667     function safeTransferFrom(
668         address from,
669         address to,
670         uint256 tokenId
671     ) external;
672 
673     /**
674      * @dev Transfers `tokenId` token from `from` to `to`.
675      *
676      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
677      *
678      * Requirements:
679      *
680      * - `from` cannot be the zero address.
681      * - `to` cannot be the zero address.
682      * - `tokenId` token must be owned by `from`.
683      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
684      *
685      * Emits a {Transfer} event.
686      */
687     function transferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) external;
692 
693     /**
694      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
695      * The approval is cleared when the token is transferred.
696      *
697      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
698      *
699      * Requirements:
700      *
701      * - The caller must own the token or be an approved operator.
702      * - `tokenId` must exist.
703      *
704      * Emits an {Approval} event.
705      */
706     function approve(address to, uint256 tokenId) external;
707 
708     /**
709      * @dev Approve or remove `operator` as an operator for the caller.
710      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
711      *
712      * Requirements:
713      *
714      * - The `operator` cannot be the caller.
715      *
716      * Emits an {ApprovalForAll} event.
717      */
718     function setApprovalForAll(address operator, bool _approved) external;
719 
720     /**
721      * @dev Returns the account approved for `tokenId` token.
722      *
723      * Requirements:
724      *
725      * - `tokenId` must exist.
726      */
727     function getApproved(uint256 tokenId) external view returns (address operator);
728 
729     /**
730      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
731      *
732      * See {setApprovalForAll}
733      */
734     function isApprovedForAll(address owner, address operator) external view returns (bool);
735 
736     // ==============================
737     //        IERC721Metadata
738     // ==============================
739 
740     /**
741      * @dev Returns the token collection name.
742      */
743     function name() external view returns (string memory);
744 
745     /**
746      * @dev Returns the token collection symbol.
747      */
748     function symbol() external view returns (string memory);
749 
750     /**
751      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
752      */
753     function tokenURI(uint256 tokenId) external view returns (string memory);
754 
755     // ==============================
756     //            IERC2309
757     // ==============================
758 
759     /**
760      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
761      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
762      */
763     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
764 }
765 
766 // File: erc721a/contracts/ERC721A.sol
767 
768 
769 // ERC721A Contracts v4.1.0
770 // Creator: Chiru Labs
771 
772 pragma solidity ^0.8.4;
773 
774 
775 /**
776  * @dev ERC721 token receiver interface.
777  */
778 interface ERC721A__IERC721Receiver {
779     function onERC721Received(
780         address operator,
781         address from,
782         uint256 tokenId,
783         bytes calldata data
784     ) external returns (bytes4);
785 }
786 
787 /**
788  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
789  * including the Metadata extension. Built to optimize for lower gas during batch mints.
790  *
791  * Assumes serials are sequentially minted starting at `_startTokenId()`
792  * (defaults to 0, e.g. 0, 1, 2, 3..).
793  *
794  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
795  *
796  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
797  */
798 contract ERC721A is IERC721A {
799     // Mask of an entry in packed address data.
800     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
801 
802     // The bit position of `numberMinted` in packed address data.
803     uint256 private constant BITPOS_NUMBER_MINTED = 64;
804 
805     // The bit position of `numberBurned` in packed address data.
806     uint256 private constant BITPOS_NUMBER_BURNED = 128;
807 
808     // The bit position of `aux` in packed address data.
809     uint256 private constant BITPOS_AUX = 192;
810 
811     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
812     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
813 
814     // The bit position of `startTimestamp` in packed ownership.
815     uint256 private constant BITPOS_START_TIMESTAMP = 160;
816 
817     // The bit mask of the `burned` bit in packed ownership.
818     uint256 private constant BITMASK_BURNED = 1 << 224;
819 
820     // The bit position of the `nextInitialized` bit in packed ownership.
821     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
822 
823     // The bit mask of the `nextInitialized` bit in packed ownership.
824     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
825 
826     // The bit position of `extraData` in packed ownership.
827     uint256 private constant BITPOS_EXTRA_DATA = 232;
828 
829     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
830     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
831 
832     // The mask of the lower 160 bits for addresses.
833     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
834 
835     // The maximum `quantity` that can be minted with `_mintERC2309`.
836     // This limit is to prevent overflows on the address data entries.
837     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
838     // is required to cause an overflow, which is unrealistic.
839     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
840 
841     // The tokenId of the next token to be minted.
842     uint256 private _currentIndex;
843 
844     // The number of tokens burned.
845     uint256 private _burnCounter;
846 
847     // Token name
848     string private _name;
849 
850     // Token symbol
851     string private _symbol;
852 
853     // Mapping from token ID to ownership details
854     // An empty struct value does not necessarily mean the token is unowned.
855     // See `_packedOwnershipOf` implementation for details.
856     //
857     // Bits Layout:
858     // - [0..159]   `addr`
859     // - [160..223] `startTimestamp`
860     // - [224]      `burned`
861     // - [225]      `nextInitialized`
862     // - [232..255] `extraData`
863     mapping(uint256 => uint256) private _packedOwnerships;
864 
865     // Mapping owner address to address data.
866     //
867     // Bits Layout:
868     // - [0..63]    `balance`
869     // - [64..127]  `numberMinted`
870     // - [128..191] `numberBurned`
871     // - [192..255] `aux`
872     mapping(address => uint256) private _packedAddressData;
873 
874     // Mapping from token ID to approved address.
875     mapping(uint256 => address) private _tokenApprovals;
876 
877     // Mapping from owner to operator approvals
878     mapping(address => mapping(address => bool)) private _operatorApprovals;
879 
880     constructor(string memory name_, string memory symbol_) {
881         _name = name_;
882         _symbol = symbol_;
883         _currentIndex = _startTokenId();
884     }
885 
886     /**
887      * @dev Returns the starting token ID.
888      * To change the starting token ID, please override this function.
889      */
890     function _startTokenId() internal view virtual returns (uint256) {
891         return 0;
892     }
893 
894     /**
895      * @dev Returns the next token ID to be minted.
896      */
897     function _nextTokenId() internal view returns (uint256) {
898         return _currentIndex;
899     }
900 
901     /**
902      * @dev Returns the total number of tokens in existence.
903      * Burned tokens will reduce the count.
904      * To get the total number of tokens minted, please see `_totalMinted`.
905      */
906     function totalSupply() public view override returns (uint256) {
907         // Counter underflow is impossible as _burnCounter cannot be incremented
908         // more than `_currentIndex - _startTokenId()` times.
909         unchecked {
910             return _currentIndex - _burnCounter - _startTokenId();
911         }
912     }
913 
914     /**
915      * @dev Returns the total amount of tokens minted in the contract.
916      */
917     function _totalMinted() internal view returns (uint256) {
918         // Counter underflow is impossible as _currentIndex does not decrement,
919         // and it is initialized to `_startTokenId()`
920         unchecked {
921             return _currentIndex - _startTokenId();
922         }
923     }
924 
925     /**
926      * @dev Returns the total number of tokens burned.
927      */
928     function _totalBurned() internal view returns (uint256) {
929         return _burnCounter;
930     }
931 
932     /**
933      * @dev See {IERC165-supportsInterface}.
934      */
935     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
936         // The interface IDs are constants representing the first 4 bytes of the XOR of
937         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
938         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
939         return
940             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
941             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
942             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
943     }
944 
945     /**
946      * @dev See {IERC721-balanceOf}.
947      */
948     function balanceOf(address owner) public view override returns (uint256) {
949         if (owner == address(0)) revert BalanceQueryForZeroAddress();
950         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
951     }
952 
953     /**
954      * Returns the number of tokens minted by `owner`.
955      */
956     function _numberMinted(address owner) internal view returns (uint256) {
957         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
958     }
959 
960     /**
961      * Returns the number of tokens burned by or on behalf of `owner`.
962      */
963     function _numberBurned(address owner) internal view returns (uint256) {
964         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
965     }
966 
967     /**
968      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
969      */
970     function _getAux(address owner) internal view returns (uint64) {
971         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
972     }
973 
974     /**
975      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
976      * If there are multiple variables, please pack them into a uint64.
977      */
978     function _setAux(address owner, uint64 aux) internal {
979         uint256 packed = _packedAddressData[owner];
980         uint256 auxCasted;
981         // Cast `aux` with assembly to avoid redundant masking.
982         assembly {
983             auxCasted := aux
984         }
985         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
986         _packedAddressData[owner] = packed;
987     }
988 
989     /**
990      * Returns the packed ownership data of `tokenId`.
991      */
992     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
993         uint256 curr = tokenId;
994 
995         unchecked {
996             if (_startTokenId() <= curr)
997                 if (curr < _currentIndex) {
998                     uint256 packed = _packedOwnerships[curr];
999                     // If not burned.
1000                     if (packed & BITMASK_BURNED == 0) {
1001                         // Invariant:
1002                         // There will always be an ownership that has an address and is not burned
1003                         // before an ownership that does not have an address and is not burned.
1004                         // Hence, curr will not underflow.
1005                         //
1006                         // We can directly compare the packed value.
1007                         // If the address is zero, packed is zero.
1008                         while (packed == 0) {
1009                             packed = _packedOwnerships[--curr];
1010                         }
1011                         return packed;
1012                     }
1013                 }
1014         }
1015         revert OwnerQueryForNonexistentToken();
1016     }
1017 
1018     /**
1019      * Returns the unpacked `TokenOwnership` struct from `packed`.
1020      */
1021     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1022         ownership.addr = address(uint160(packed));
1023         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1024         ownership.burned = packed & BITMASK_BURNED != 0;
1025         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1026     }
1027 
1028     /**
1029      * Returns the unpacked `TokenOwnership` struct at `index`.
1030      */
1031     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1032         return _unpackedOwnership(_packedOwnerships[index]);
1033     }
1034 
1035     /**
1036      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1037      */
1038     function _initializeOwnershipAt(uint256 index) internal {
1039         if (_packedOwnerships[index] == 0) {
1040             _packedOwnerships[index] = _packedOwnershipOf(index);
1041         }
1042     }
1043 
1044     /**
1045      * Gas spent here starts off proportional to the maximum mint batch size.
1046      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1047      */
1048     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1049         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1050     }
1051 
1052     /**
1053      * @dev Packs ownership data into a single uint256.
1054      */
1055     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1056         assembly {
1057             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1058             owner := and(owner, BITMASK_ADDRESS)
1059             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1060             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1061         }
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-ownerOf}.
1066      */
1067     function ownerOf(uint256 tokenId) public view override returns (address) {
1068         return address(uint160(_packedOwnershipOf(tokenId)));
1069     }
1070 
1071     /**
1072      * @dev See {IERC721Metadata-name}.
1073      */
1074     function name() public view virtual override returns (string memory) {
1075         return _name;
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-symbol}.
1080      */
1081     function symbol() public view virtual override returns (string memory) {
1082         return _symbol;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-tokenURI}.
1087      */
1088     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1089         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1090 
1091         string memory baseURI = _baseURI();
1092         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1093     }
1094 
1095     /**
1096      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1097      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1098      * by default, it can be overridden in child contracts.
1099      */
1100     function _baseURI() internal view virtual returns (string memory) {
1101         return '';
1102     }
1103 
1104     /**
1105      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1106      */
1107     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1108         // For branchless setting of the `nextInitialized` flag.
1109         assembly {
1110             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1111             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1112         }
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-approve}.
1117      */
1118     function approve(address to, uint256 tokenId) public override {
1119         address owner = ownerOf(tokenId);
1120 
1121         if (_msgSenderERC721A() != owner)
1122             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1123                 revert ApprovalCallerNotOwnerNorApproved();
1124             }
1125 
1126         _tokenApprovals[tokenId] = to;
1127         emit Approval(owner, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-getApproved}.
1132      */
1133     function getApproved(uint256 tokenId) public view override returns (address) {
1134         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1135 
1136         return _tokenApprovals[tokenId];
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-setApprovalForAll}.
1141      */
1142     function setApprovalForAll(address operator, bool approved) public virtual override {
1143         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1144 
1145         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1146         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-isApprovedForAll}.
1151      */
1152     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1153         return _operatorApprovals[owner][operator];
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-safeTransferFrom}.
1158      */
1159     function safeTransferFrom(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) public virtual override {
1164         safeTransferFrom(from, to, tokenId, '');
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-safeTransferFrom}.
1169      */
1170     function safeTransferFrom(
1171         address from,
1172         address to,
1173         uint256 tokenId,
1174         bytes memory _data
1175     ) public virtual override {
1176         transferFrom(from, to, tokenId);
1177         if (to.code.length != 0)
1178             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1179                 revert TransferToNonERC721ReceiverImplementer();
1180             }
1181     }
1182 
1183     /**
1184      * @dev Returns whether `tokenId` exists.
1185      *
1186      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1187      *
1188      * Tokens start existing when they are minted (`_mint`),
1189      */
1190     function _exists(uint256 tokenId) internal view returns (bool) {
1191         return
1192             _startTokenId() <= tokenId &&
1193             tokenId < _currentIndex && // If within bounds,
1194             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1195     }
1196 
1197     /**
1198      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1199      */
1200     function _safeMint(address to, uint256 quantity) internal {
1201         _safeMint(to, quantity, '');
1202     }
1203 
1204     /**
1205      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1206      *
1207      * Requirements:
1208      *
1209      * - If `to` refers to a smart contract, it must implement
1210      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * See {_mint}.
1214      *
1215      * Emits a {Transfer} event for each mint.
1216      */
1217     function _safeMint(
1218         address to,
1219         uint256 quantity,
1220         bytes memory _data
1221     ) internal {
1222         _mint(to, quantity);
1223 
1224         unchecked {
1225             if (to.code.length != 0) {
1226                 uint256 end = _currentIndex;
1227                 uint256 index = end - quantity;
1228                 do {
1229                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1230                         revert TransferToNonERC721ReceiverImplementer();
1231                     }
1232                 } while (index < end);
1233                 // Reentrancy protection.
1234                 if (_currentIndex != end) revert();
1235             }
1236         }
1237     }
1238 
1239     /**
1240      * @dev Mints `quantity` tokens and transfers them to `to`.
1241      *
1242      * Requirements:
1243      *
1244      * - `to` cannot be the zero address.
1245      * - `quantity` must be greater than 0.
1246      *
1247      * Emits a {Transfer} event for each mint.
1248      */
1249     function _mint(address to, uint256 quantity) internal {
1250         uint256 startTokenId = _currentIndex;
1251         if (to == address(0)) revert MintToZeroAddress();
1252         if (quantity == 0) revert MintZeroQuantity();
1253 
1254         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1255 
1256         // Overflows are incredibly unrealistic.
1257         // `balance` and `numberMinted` have a maximum limit of 2**64.
1258         // `tokenId` has a maximum limit of 2**256.
1259         unchecked {
1260             // Updates:
1261             // - `balance += quantity`.
1262             // - `numberMinted += quantity`.
1263             //
1264             // We can directly add to the `balance` and `numberMinted`.
1265             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1266 
1267             // Updates:
1268             // - `address` to the owner.
1269             // - `startTimestamp` to the timestamp of minting.
1270             // - `burned` to `false`.
1271             // - `nextInitialized` to `quantity == 1`.
1272             _packedOwnerships[startTokenId] = _packOwnershipData(
1273                 to,
1274                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1275             );
1276 
1277             uint256 tokenId = startTokenId;
1278             uint256 end = startTokenId + quantity;
1279             do {
1280                 emit Transfer(address(0), to, tokenId++);
1281             } while (tokenId < end);
1282 
1283             _currentIndex = end;
1284         }
1285         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1286     }
1287 
1288     /**
1289      * @dev Mints `quantity` tokens and transfers them to `to`.
1290      *
1291      * This function is intended for efficient minting only during contract creation.
1292      *
1293      * It emits only one {ConsecutiveTransfer} as defined in
1294      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1295      * instead of a sequence of {Transfer} event(s).
1296      *
1297      * Calling this function outside of contract creation WILL make your contract
1298      * non-compliant with the ERC721 standard.
1299      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1300      * {ConsecutiveTransfer} event is only permissible during contract creation.
1301      *
1302      * Requirements:
1303      *
1304      * - `to` cannot be the zero address.
1305      * - `quantity` must be greater than 0.
1306      *
1307      * Emits a {ConsecutiveTransfer} event.
1308      */
1309     function _mintERC2309(address to, uint256 quantity) internal {
1310         uint256 startTokenId = _currentIndex;
1311         if (to == address(0)) revert MintToZeroAddress();
1312         if (quantity == 0) revert MintZeroQuantity();
1313         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1314 
1315         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1316 
1317         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1318         unchecked {
1319             // Updates:
1320             // - `balance += quantity`.
1321             // - `numberMinted += quantity`.
1322             //
1323             // We can directly add to the `balance` and `numberMinted`.
1324             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1325 
1326             // Updates:
1327             // - `address` to the owner.
1328             // - `startTimestamp` to the timestamp of minting.
1329             // - `burned` to `false`.
1330             // - `nextInitialized` to `quantity == 1`.
1331             _packedOwnerships[startTokenId] = _packOwnershipData(
1332                 to,
1333                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1334             );
1335 
1336             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1337 
1338             _currentIndex = startTokenId + quantity;
1339         }
1340         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1341     }
1342 
1343     /**
1344      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1345      */
1346     function _getApprovedAddress(uint256 tokenId)
1347         private
1348         view
1349         returns (uint256 approvedAddressSlot, address approvedAddress)
1350     {
1351         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1352         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1353         assembly {
1354             // Compute the slot.
1355             mstore(0x00, tokenId)
1356             mstore(0x20, tokenApprovalsPtr.slot)
1357             approvedAddressSlot := keccak256(0x00, 0x40)
1358             // Load the slot's value from storage.
1359             approvedAddress := sload(approvedAddressSlot)
1360         }
1361     }
1362 
1363     /**
1364      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1365      */
1366     function _isOwnerOrApproved(
1367         address approvedAddress,
1368         address from,
1369         address msgSender
1370     ) private pure returns (bool result) {
1371         assembly {
1372             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1373             from := and(from, BITMASK_ADDRESS)
1374             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1375             msgSender := and(msgSender, BITMASK_ADDRESS)
1376             // `msgSender == from || msgSender == approvedAddress`.
1377             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1378         }
1379     }
1380 
1381     /**
1382      * @dev Transfers `tokenId` from `from` to `to`.
1383      *
1384      * Requirements:
1385      *
1386      * - `to` cannot be the zero address.
1387      * - `tokenId` token must be owned by `from`.
1388      *
1389      * Emits a {Transfer} event.
1390      */
1391     function transferFrom(
1392         address from,
1393         address to,
1394         uint256 tokenId
1395     ) public virtual override {
1396         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1397 
1398         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1399 
1400         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1401 
1402         // The nested ifs save around 20+ gas over a compound boolean condition.
1403         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1404             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1405 
1406         if (to == address(0)) revert TransferToZeroAddress();
1407 
1408         _beforeTokenTransfers(from, to, tokenId, 1);
1409 
1410         // Clear approvals from the previous owner.
1411         assembly {
1412             if approvedAddress {
1413                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1414                 sstore(approvedAddressSlot, 0)
1415             }
1416         }
1417 
1418         // Underflow of the sender's balance is impossible because we check for
1419         // ownership above and the recipient's balance can't realistically overflow.
1420         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1421         unchecked {
1422             // We can directly increment and decrement the balances.
1423             --_packedAddressData[from]; // Updates: `balance -= 1`.
1424             ++_packedAddressData[to]; // Updates: `balance += 1`.
1425 
1426             // Updates:
1427             // - `address` to the next owner.
1428             // - `startTimestamp` to the timestamp of transfering.
1429             // - `burned` to `false`.
1430             // - `nextInitialized` to `true`.
1431             _packedOwnerships[tokenId] = _packOwnershipData(
1432                 to,
1433                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1434             );
1435 
1436             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1437             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1438                 uint256 nextTokenId = tokenId + 1;
1439                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1440                 if (_packedOwnerships[nextTokenId] == 0) {
1441                     // If the next slot is within bounds.
1442                     if (nextTokenId != _currentIndex) {
1443                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1444                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1445                     }
1446                 }
1447             }
1448         }
1449 
1450         emit Transfer(from, to, tokenId);
1451         _afterTokenTransfers(from, to, tokenId, 1);
1452     }
1453 
1454     /**
1455      * @dev Equivalent to `_burn(tokenId, false)`.
1456      */
1457     function _burn(uint256 tokenId) internal virtual {
1458         _burn(tokenId, false);
1459     }
1460 
1461     /**
1462      * @dev Destroys `tokenId`.
1463      * The approval is cleared when the token is burned.
1464      *
1465      * Requirements:
1466      *
1467      * - `tokenId` must exist.
1468      *
1469      * Emits a {Transfer} event.
1470      */
1471     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1472         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1473 
1474         address from = address(uint160(prevOwnershipPacked));
1475 
1476         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1477 
1478         if (approvalCheck) {
1479             // The nested ifs save around 20+ gas over a compound boolean condition.
1480             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1481                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1482         }
1483 
1484         _beforeTokenTransfers(from, address(0), tokenId, 1);
1485 
1486         // Clear approvals from the previous owner.
1487         assembly {
1488             if approvedAddress {
1489                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1490                 sstore(approvedAddressSlot, 0)
1491             }
1492         }
1493 
1494         // Underflow of the sender's balance is impossible because we check for
1495         // ownership above and the recipient's balance can't realistically overflow.
1496         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1497         unchecked {
1498             // Updates:
1499             // - `balance -= 1`.
1500             // - `numberBurned += 1`.
1501             //
1502             // We can directly decrement the balance, and increment the number burned.
1503             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1504             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1505 
1506             // Updates:
1507             // - `address` to the last owner.
1508             // - `startTimestamp` to the timestamp of burning.
1509             // - `burned` to `true`.
1510             // - `nextInitialized` to `true`.
1511             _packedOwnerships[tokenId] = _packOwnershipData(
1512                 from,
1513                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1514             );
1515 
1516             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1517             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1518                 uint256 nextTokenId = tokenId + 1;
1519                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1520                 if (_packedOwnerships[nextTokenId] == 0) {
1521                     // If the next slot is within bounds.
1522                     if (nextTokenId != _currentIndex) {
1523                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1524                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1525                     }
1526                 }
1527             }
1528         }
1529 
1530         emit Transfer(from, address(0), tokenId);
1531         _afterTokenTransfers(from, address(0), tokenId, 1);
1532 
1533         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1534         unchecked {
1535             _burnCounter++;
1536         }
1537     }
1538 
1539     /**
1540      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1541      *
1542      * @param from address representing the previous owner of the given token ID
1543      * @param to target address that will receive the tokens
1544      * @param tokenId uint256 ID of the token to be transferred
1545      * @param _data bytes optional data to send along with the call
1546      * @return bool whether the call correctly returned the expected magic value
1547      */
1548     function _checkContractOnERC721Received(
1549         address from,
1550         address to,
1551         uint256 tokenId,
1552         bytes memory _data
1553     ) private returns (bool) {
1554         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1555             bytes4 retval
1556         ) {
1557             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1558         } catch (bytes memory reason) {
1559             if (reason.length == 0) {
1560                 revert TransferToNonERC721ReceiverImplementer();
1561             } else {
1562                 assembly {
1563                     revert(add(32, reason), mload(reason))
1564                 }
1565             }
1566         }
1567     }
1568 
1569     /**
1570      * @dev Directly sets the extra data for the ownership data `index`.
1571      */
1572     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1573         uint256 packed = _packedOwnerships[index];
1574         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1575         uint256 extraDataCasted;
1576         // Cast `extraData` with assembly to avoid redundant masking.
1577         assembly {
1578             extraDataCasted := extraData
1579         }
1580         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1581         _packedOwnerships[index] = packed;
1582     }
1583 
1584     /**
1585      * @dev Returns the next extra data for the packed ownership data.
1586      * The returned result is shifted into position.
1587      */
1588     function _nextExtraData(
1589         address from,
1590         address to,
1591         uint256 prevOwnershipPacked
1592     ) private view returns (uint256) {
1593         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1594         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1595     }
1596 
1597     /**
1598      * @dev Called during each token transfer to set the 24bit `extraData` field.
1599      * Intended to be overridden by the cosumer contract.
1600      *
1601      * `previousExtraData` - the value of `extraData` before transfer.
1602      *
1603      * Calling conditions:
1604      *
1605      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1606      * transferred to `to`.
1607      * - When `from` is zero, `tokenId` will be minted for `to`.
1608      * - When `to` is zero, `tokenId` will be burned by `from`.
1609      * - `from` and `to` are never both zero.
1610      */
1611     function _extraData(
1612         address from,
1613         address to,
1614         uint24 previousExtraData
1615     ) internal view virtual returns (uint24) {}
1616 
1617     /**
1618      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1619      * This includes minting.
1620      * And also called before burning one token.
1621      *
1622      * startTokenId - the first token id to be transferred
1623      * quantity - the amount to be transferred
1624      *
1625      * Calling conditions:
1626      *
1627      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1628      * transferred to `to`.
1629      * - When `from` is zero, `tokenId` will be minted for `to`.
1630      * - When `to` is zero, `tokenId` will be burned by `from`.
1631      * - `from` and `to` are never both zero.
1632      */
1633     function _beforeTokenTransfers(
1634         address from,
1635         address to,
1636         uint256 startTokenId,
1637         uint256 quantity
1638     ) internal virtual {}
1639 
1640     /**
1641      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1642      * This includes minting.
1643      * And also called after one token has been burned.
1644      *
1645      * startTokenId - the first token id to be transferred
1646      * quantity - the amount to be transferred
1647      *
1648      * Calling conditions:
1649      *
1650      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1651      * transferred to `to`.
1652      * - When `from` is zero, `tokenId` has been minted for `to`.
1653      * - When `to` is zero, `tokenId` has been burned by `from`.
1654      * - `from` and `to` are never both zero.
1655      */
1656     function _afterTokenTransfers(
1657         address from,
1658         address to,
1659         uint256 startTokenId,
1660         uint256 quantity
1661     ) internal virtual {}
1662 
1663     /**
1664      * @dev Returns the message sender (defaults to `msg.sender`).
1665      *
1666      * If you are writing GSN compatible contracts, you need to override this function.
1667      */
1668     function _msgSenderERC721A() internal view virtual returns (address) {
1669         return msg.sender;
1670     }
1671 
1672     /**
1673      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1674      */
1675     function _toString(uint256 value) internal pure returns (string memory ptr) {
1676         assembly {
1677             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1678             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1679             // We will need 1 32-byte word to store the length,
1680             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1681             ptr := add(mload(0x40), 128)
1682             // Update the free memory pointer to allocate.
1683             mstore(0x40, ptr)
1684 
1685             // Cache the end of the memory to calculate the length later.
1686             let end := ptr
1687 
1688             // We write the string from the rightmost digit to the leftmost digit.
1689             // The following is essentially a do-while loop that also handles the zero case.
1690             // Costs a bit more than early returning for the zero case,
1691             // but cheaper in terms of deployment and overall runtime costs.
1692             for {
1693                 // Initialize and perform the first pass without check.
1694                 let temp := value
1695                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1696                 ptr := sub(ptr, 1)
1697                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1698                 mstore8(ptr, add(48, mod(temp, 10)))
1699                 temp := div(temp, 10)
1700             } temp {
1701                 // Keep dividing `temp` until zero.
1702                 temp := div(temp, 10)
1703             } {
1704                 // Body of the for loop.
1705                 ptr := sub(ptr, 1)
1706                 mstore8(ptr, add(48, mod(temp, 10)))
1707             }
1708 
1709             let length := sub(end, ptr)
1710             // Move the pointer 32 bytes leftwards to make room for the length.
1711             ptr := sub(ptr, 32)
1712             // Store the length.
1713             mstore(ptr, length)
1714         }
1715     }
1716 }
1717 
1718 // File: contracts/Tem.sol
1719 
1720 
1721 
1722 
1723 pragma solidity ^0.8.4;
1724 
1725 
1726 
1727 contract city is ERC721A, Ownable, ReentrancyGuard {
1728     using Address for address;
1729     using Strings for uint;
1730     string  public baseTokenURI = "ipfs://QmYXJ9YyYhLfGURKYDSUwQiNA9XF8WT9dSak9MGbcJiG1J/";
1731     uint256 public MAX_SUPPLY = 1111;
1732     uint256 public MAX_FREE_SUPPLY = 111;
1733     uint256 public MAX_PER_TX = 3;
1734     uint256 public PRICE = 0.0036 ether;
1735     uint256 public MAX_FREE_PER_WALLET = 10;
1736     bool public status = true;
1737     bool public revealed = false;
1738 
1739     mapping(address => uint256) public perWalletFreeMinted;
1740 
1741     constructor() ERC721A("city", "cy") {}
1742 
1743 
1744     function devMint(address to, uint amount) external onlyOwner {
1745 		require(
1746 			_totalMinted() + amount <= MAX_SUPPLY,
1747 			'Exceeds max supply'
1748 		);
1749 		_safeMint(to, amount);
1750 	}
1751 
1752     function OwnerBatchMint(uint256 amount) external onlyOwner
1753     {
1754         require(
1755 			_totalMinted() + amount <= MAX_SUPPLY,
1756 			'Exceeds max supply'
1757 		);
1758         _safeMint(msg.sender, amount);
1759     }
1760 
1761     function mint(uint256 amount) external payable
1762     {
1763         
1764 		require(amount <= MAX_PER_TX,"Exceeds NFT per transaction limit");
1765 		require(_totalMinted() + amount <= MAX_SUPPLY,"Exceeds max supply");
1766         require(status, "Minting is not live yet.");
1767         uint payForCount = amount;
1768         uint minted = perWalletFreeMinted[msg.sender];
1769         if(minted < MAX_FREE_PER_WALLET && _totalMinted()<MAX_FREE_SUPPLY) {
1770             uint remainingFreeMints = MAX_FREE_PER_WALLET - minted;
1771             if(amount > remainingFreeMints) {
1772                 payForCount = amount - remainingFreeMints;
1773             }
1774             else {
1775                 payForCount = 0;
1776             }
1777         }
1778 
1779 		require(
1780 			msg.value >= payForCount * PRICE,
1781 			'Ether value sent is not sufficient'
1782 		);
1783     	perWalletFreeMinted[msg.sender] += amount;
1784 
1785         _safeMint(msg.sender, amount);
1786     }
1787 
1788     function setBaseURI(string memory baseURI) public onlyOwner
1789     {
1790         baseTokenURI = baseURI;
1791     }
1792 
1793     function _startTokenId() internal view virtual override returns (uint256) {
1794         return 1;
1795     }
1796     function withdraw() public onlyOwner nonReentrant {
1797         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1798         require(os);
1799     }
1800 
1801     
1802     function tokenURI(uint tokenId)
1803 		public
1804 		view
1805 		override
1806 		returns (string memory)
1807 	{
1808         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1809 
1810         return bytes(_baseURI()).length > 0 
1811             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1812             : baseTokenURI;
1813 	}
1814 
1815     function _baseURI() internal view virtual override returns (string memory)
1816     {
1817         return baseTokenURI;
1818     }
1819 
1820     function reveal(bool _revealed) external onlyOwner
1821     {
1822         revealed = _revealed;
1823     }
1824 
1825     function setStatus(bool _status) external onlyOwner
1826     {
1827         status = _status;
1828     }
1829 
1830     function setPrice(uint256 _price) external onlyOwner
1831     {
1832         PRICE = _price;
1833     }
1834 
1835     function setMaxLimitPerTransaction(uint256 _limit) external onlyOwner
1836     {
1837         MAX_PER_TX = _limit;
1838     }
1839 
1840     function setLimitFreeMintPerWallet(uint256 _limit) external onlyOwner
1841     {
1842         MAX_FREE_PER_WALLET = _limit;
1843     }
1844 
1845     function setMaxFreeAmount(uint256 _amount) external onlyOwner
1846     {
1847         MAX_FREE_SUPPLY = _amount;
1848     }
1849 
1850 }