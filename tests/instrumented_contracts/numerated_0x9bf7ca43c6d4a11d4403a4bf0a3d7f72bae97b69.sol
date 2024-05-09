1 /*
2  ___________  _____   _______ 
3 |  _  | ___ \/ _ \ \ / /  __ \
4 | | | | |_/ / /_\ \ V /| /  \/
5 | | | | ___ \  _  |\ / | |    
6 \ \_/ / |_/ / | | || | | \__/\
7  \___/\____/\_| |_/\_/  \____/
8                               
9 Otherside Bored Ape Yacht Club 
10 The OG Yugalabs BAYC Apes now facing left and coming with Cashprizes when minting a Winning ID
11 
12 Total Supply: 10000
13 First NFT per Wallet Free
14 Mint #2 - #10 0.0025 ETH each
15 10 Max per Wallet 
16 
17 Twitter: https://twitter.com/OBoredApeYC
18 Telegram: https://t.me/OthersideBoredApeYC
19 
20 */
21 // SPDX-License-Identifier: MIT
22 
23 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
24 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Contract module that helps prevent reentrant calls to a function.
30  *
31  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
32  * available, which can be applied to functions to make sure there are no nested
33  * (reentrant) calls to them.
34  *
35  * Note that because there is a single `nonReentrant` guard, functions marked as
36  * `nonReentrant` may not call one another. This can be worked around by making
37  * those functions `private`, and then adding `external` `nonReentrant` entry
38  * points to them.
39  *
40  * TIP: If you would like to learn more about reentrancy and alternative ways
41  * to protect against it, check out our blog post
42  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
43  */
44 abstract contract ReentrancyGuard {
45     // Booleans are more expensive than uint256 or any type that takes up a full
46     // word because each write operation emits an extra SLOAD to first read the
47     // slot's contents, replace the bits taken up by the boolean, and then write
48     // back. This is the compiler's defense against contract upgrades and
49     // pointer aliasing, and it cannot be disabled.
50 
51     // The values being non-zero value makes deployment a bit more expensive,
52     // but in exchange the refund on every call to nonReentrant will be lower in
53     // amount. Since refunds are capped to a percentage of the total
54     // transaction's gas, it is best to keep them low in cases like this one, to
55     // increase the likelihood of the full refund coming into effect.
56     uint256 private constant _NOT_ENTERED = 1;
57     uint256 private constant _ENTERED = 2;
58 
59     uint256 private _status;
60 
61     constructor() {
62         _status = _NOT_ENTERED;
63     }
64 
65     /**
66      * @dev Prevents a contract from calling itself, directly or indirectly.
67      * Calling a `nonReentrant` function from another `nonReentrant`
68      * function is not supported. It is possible to prevent this from happening
69      * by making the `nonReentrant` function external, and making it call a
70      * `private` function that does the actual work.
71      */
72     modifier nonReentrant() {
73         // On the first call to nonReentrant, _notEntered will be true
74         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
75 
76         // Any calls to nonReentrant after this point will fail
77         _status = _ENTERED;
78 
79         _;
80 
81         // By storing the original value once again, a refund is triggered (see
82         // https://eips.ethereum.org/EIPS/eip-2200)
83         _status = _NOT_ENTERED;
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Strings.sol
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev String operations.
95  */
96 library Strings {
97     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
101      */
102     function toString(uint256 value) internal pure returns (string memory) {
103         // Inspired by OraclizeAPI's implementation - MIT licence
104         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
105 
106         if (value == 0) {
107             return "0";
108         }
109         uint256 temp = value;
110         uint256 digits;
111         while (temp != 0) {
112             digits++;
113             temp /= 10;
114         }
115         bytes memory buffer = new bytes(digits);
116         while (value != 0) {
117             digits -= 1;
118             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
119             value /= 10;
120         }
121         return string(buffer);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
126      */
127     function toHexString(uint256 value) internal pure returns (string memory) {
128         if (value == 0) {
129             return "0x00";
130         }
131         uint256 temp = value;
132         uint256 length = 0;
133         while (temp != 0) {
134             length++;
135             temp >>= 8;
136         }
137         return toHexString(value, length);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
142      */
143     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
144         bytes memory buffer = new bytes(2 * length + 2);
145         buffer[0] = "0";
146         buffer[1] = "x";
147         for (uint256 i = 2 * length + 1; i > 1; --i) {
148             buffer[i] = _HEX_SYMBOLS[value & 0xf];
149             value >>= 4;
150         }
151         require(value == 0, "Strings: hex length insufficient");
152         return string(buffer);
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/Context.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev Provides information about the current execution context, including the
165  * sender of the transaction and its data. While these are generally available
166  * via msg.sender and msg.data, they should not be accessed in such a direct
167  * manner, since when dealing with meta-transactions the account sending and
168  * paying for execution may not be the actual sender (as far as an application
169  * is concerned).
170  *
171  * This contract is only required for intermediate, library-like contracts.
172  */
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes calldata) {
179         return msg.data;
180     }
181 }
182 
183 // File: @openzeppelin/contracts/utils/Address.sol
184 
185 
186 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
187 
188 pragma solidity ^0.8.1;
189 
190 /**
191  * @dev Collection of functions related to the address type
192  */
193 library Address {
194     /**
195      * @dev Returns true if `account` is a contract.
196      *
197      * [IMPORTANT]
198      * ====
199      * It is unsafe to assume that an address for which this function returns
200      * false is an externally-owned account (EOA) and not a contract.
201      *
202      * Among others, `isContract` will return false for the following
203      * types of addresses:
204      *
205      *  - an externally-owned account
206      *  - a contract in construction
207      *  - an address where a contract will be created
208      *  - an address where a contract lived, but was destroyed
209      * ====
210      *
211      * [IMPORTANT]
212      * ====
213      * You shouldn't rely on `isContract` to protect against flash loan attacks!
214      *
215      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
216      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
217      * constructor.
218      * ====
219      */
220     function isContract(address account) internal view returns (bool) {
221         // This method relies on extcodesize/address.code.length, which returns 0
222         // for contracts in construction, since the code is only stored at the end
223         // of the constructor execution.
224 
225         return account.code.length > 0;
226     }
227 
228     /**
229      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
230      * `recipient`, forwarding all available gas and reverting on errors.
231      *
232      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
233      * of certain opcodes, possibly making contracts go over the 2300 gas limit
234      * imposed by `transfer`, making them unable to receive funds via
235      * `transfer`. {sendValue} removes this limitation.
236      *
237      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
238      *
239      * IMPORTANT: because control is transferred to `recipient`, care must be
240      * taken to not create reentrancy vulnerabilities. Consider using
241      * {ReentrancyGuard} or the
242      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
243      */
244     function sendValue(address payable recipient, uint256 amount) internal {
245         require(address(this).balance >= amount, "Address: insufficient balance");
246 
247         (bool success, ) = recipient.call{value: amount}("");
248         require(success, "Address: unable to send value, recipient may have reverted");
249     }
250 
251     /**
252      * @dev Performs a Solidity function call using a low level `call`. A
253      * plain `call` is an unsafe replacement for a function call: use this
254      * function instead.
255      *
256      * If `target` reverts with a revert reason, it is bubbled up by this
257      * function (like regular Solidity function calls).
258      *
259      * Returns the raw returned data. To convert to the expected return value,
260      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
261      *
262      * Requirements:
263      *
264      * - `target` must be a contract.
265      * - calling `target` with `data` must not revert.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
270         return functionCall(target, data, "Address: low-level call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
275      * `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal returns (bytes memory) {
284         return functionCallWithValue(target, data, 0, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but also transferring `value` wei to `target`.
290      *
291      * Requirements:
292      *
293      * - the calling contract must have an ETH balance of at least `value`.
294      * - the called Solidity function must be `payable`.
295      *
296      * _Available since v3.1._
297      */
298     function functionCallWithValue(
299         address target,
300         bytes memory data,
301         uint256 value
302     ) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
308      * with `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         require(address(this).balance >= value, "Address: insufficient balance for call");
319         require(isContract(target), "Address: call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.call{value: value}(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but performing a static call.
328      *
329      * _Available since v3.3._
330      */
331     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
332         return functionStaticCall(target, data, "Address: low-level static call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal view returns (bytes memory) {
346         require(isContract(target), "Address: static call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.staticcall(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a delegate call.
355      *
356      * _Available since v3.4._
357      */
358     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
359         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(isContract(target), "Address: delegate call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.delegatecall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
381      * revert reason using the provided one.
382      *
383      * _Available since v4.3._
384      */
385     function verifyCallResult(
386         bool success,
387         bytes memory returndata,
388         string memory errorMessage
389     ) internal pure returns (bytes memory) {
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @title ERC721 token receiver interface
417  * @dev Interface for any contract that wants to support safeTransfers
418  * from ERC721 asset contracts.
419  */
420 interface IERC721Receiver {
421     /**
422      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
423      * by `operator` from `from`, this function is called.
424      *
425      * It must return its Solidity selector to confirm the token transfer.
426      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
427      *
428      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
429      */
430     function onERC721Received(
431         address operator,
432         address from,
433         uint256 tokenId,
434         bytes calldata data
435     ) external returns (bytes4);
436 }
437 
438 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev Interface of the ERC165 standard, as defined in the
447  * https://eips.ethereum.org/EIPS/eip-165[EIP].
448  *
449  * Implementers can declare support of contract interfaces, which can then be
450  * queried by others ({ERC165Checker}).
451  *
452  * For an implementation, see {ERC165}.
453  */
454 interface IERC165 {
455     /**
456      * @dev Returns true if this contract implements the interface defined by
457      * `interfaceId`. See the corresponding
458      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
459      * to learn more about how these ids are created.
460      *
461      * This function call must use less than 30 000 gas.
462      */
463     function supportsInterface(bytes4 interfaceId) external view returns (bool);
464 }
465 
466 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 
474 /**
475  * @dev Implementation of the {IERC165} interface.
476  *
477  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
478  * for the additional interface id that will be supported. For example:
479  *
480  * ```solidity
481  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
483  * }
484  * ```
485  *
486  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
487  */
488 abstract contract ERC165 is IERC165 {
489     /**
490      * @dev See {IERC165-supportsInterface}.
491      */
492     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493         return interfaceId == type(IERC165).interfaceId;
494     }
495 }
496 
497 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev Required interface of an ERC721 compliant contract.
507  */
508 interface IERC721 is IERC165 {
509     /**
510      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
511      */
512     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
513 
514     /**
515      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
516      */
517     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
518 
519     /**
520      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
521      */
522     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
523 
524     /**
525      * @dev Returns the number of tokens in ``owner``'s account.
526      */
527     function balanceOf(address owner) external view returns (uint256 balance);
528 
529     /**
530      * @dev Returns the owner of the `tokenId` token.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must exist.
535      */
536     function ownerOf(uint256 tokenId) external view returns (address owner);
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
540      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
541      *
542      * Requirements:
543      *
544      * - `from` cannot be the zero address.
545      * - `to` cannot be the zero address.
546      * - `tokenId` token must exist and be owned by `from`.
547      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
548      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
549      *
550      * Emits a {Transfer} event.
551      */
552     function safeTransferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) external;
557 
558     /**
559      * @dev Transfers `tokenId` token from `from` to `to`.
560      *
561      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must be owned by `from`.
568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
569      *
570      * Emits a {Transfer} event.
571      */
572     function transferFrom(
573         address from,
574         address to,
575         uint256 tokenId
576     ) external;
577 
578     /**
579      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
580      * The approval is cleared when the token is transferred.
581      *
582      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
583      *
584      * Requirements:
585      *
586      * - The caller must own the token or be an approved operator.
587      * - `tokenId` must exist.
588      *
589      * Emits an {Approval} event.
590      */
591     function approve(address to, uint256 tokenId) external;
592 
593     /**
594      * @dev Returns the account approved for `tokenId` token.
595      *
596      * Requirements:
597      *
598      * - `tokenId` must exist.
599      */
600     function getApproved(uint256 tokenId) external view returns (address operator);
601 
602     /**
603      * @dev Approve or remove `operator` as an operator for the caller.
604      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
605      *
606      * Requirements:
607      *
608      * - The `operator` cannot be the caller.
609      *
610      * Emits an {ApprovalForAll} event.
611      */
612     function setApprovalForAll(address operator, bool _approved) external;
613 
614     /**
615      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
616      *
617      * See {setApprovalForAll}
618      */
619     function isApprovedForAll(address owner, address operator) external view returns (bool);
620 
621     /**
622      * @dev Safely transfers `tokenId` token from `from` to `to`.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
631      *
632      * Emits a {Transfer} event.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId,
638         bytes calldata data
639     ) external;
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
643 
644 
645 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 
650 /**
651  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
652  * @dev See https://eips.ethereum.org/EIPS/eip-721
653  */
654 interface IERC721Metadata is IERC721 {
655     /**
656      * @dev Returns the token collection name.
657      */
658     function name() external view returns (string memory);
659 
660     /**
661      * @dev Returns the token collection symbol.
662      */
663     function symbol() external view returns (string memory);
664 
665     /**
666      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
667      */
668     function tokenURI(uint256 tokenId) external view returns (string memory);
669 }
670 
671 // File: contracts/new.sol
672 
673 
674 
675 
676 pragma solidity ^0.8.4;
677 
678 
679 
680 
681 
682 
683 
684 
685 error ApprovalCallerNotOwnerNorApproved();
686 error ApprovalQueryForNonexistentToken();
687 error ApproveToCaller();
688 error ApprovalToCurrentOwner();
689 error BalanceQueryForZeroAddress();
690 error MintToZeroAddress();
691 error MintZeroQuantity();
692 error OwnerQueryForNonexistentToken();
693 error TransferCallerNotOwnerNorApproved();
694 error TransferFromIncorrectOwner();
695 error TransferToNonERC721ReceiverImplementer();
696 error TransferToZeroAddress();
697 error URIQueryForNonexistentToken();
698 
699 /**
700  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
701  * the Metadata extension. Built to optimize for lower gas during batch mints.
702  *
703  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
704  *
705  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
706  *
707  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
708  */
709 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
710     using Address for address;
711     using Strings for uint256;
712 
713     // Compiler will pack this into a single 256bit word.
714     struct TokenOwnership {
715         // The address of the owner.
716         address addr;
717         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
718         uint64 startTimestamp;
719         // Whether the token has been burned.
720         bool burned;
721     }
722 
723     // Compiler will pack this into a single 256bit word.
724     struct AddressData {
725         // Realistically, 2**64-1 is more than enough.
726         uint64 balance;
727         // Keeps track of mint count with minimal overhead for tokenomics.
728         uint64 numberMinted;
729         // Keeps track of burn count with minimal overhead for tokenomics.
730         uint64 numberBurned;
731         // For miscellaneous variable(s) pertaining to the address
732         // (e.g. number of whitelist mint slots used).
733         // If there are multiple variables, please pack them into a uint64.
734         uint64 aux;
735     }
736 
737     // The tokenId of the next token to be minted.
738     uint256 internal _currentIndex;
739 
740     // The number of tokens burned.
741     uint256 internal _burnCounter;
742 
743     // Token name
744     string private _name;
745 
746     // Token symbol
747     string private _symbol;
748 
749     // Mapping from token ID to ownership details
750     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
751     mapping(uint256 => TokenOwnership) internal _ownerships;
752 
753     // Mapping owner address to address data
754     mapping(address => AddressData) private _addressData;
755 
756     // Mapping from token ID to approved address
757     mapping(uint256 => address) private _tokenApprovals;
758 
759     // Mapping from owner to operator approvals
760     mapping(address => mapping(address => bool)) private _operatorApprovals;
761 
762     constructor(string memory name_, string memory symbol_) {
763         _name = name_;
764         _symbol = symbol_;
765         _currentIndex = _startTokenId();
766     }
767 
768     /**
769      * To change the starting tokenId, please override this function.
770      */
771     function _startTokenId() internal view virtual returns (uint256) {
772         return 0;
773     }
774 
775     /**
776      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
777      */
778     function totalSupply() public view returns (uint256) {
779         // Counter underflow is impossible as _burnCounter cannot be incremented
780         // more than _currentIndex - _startTokenId() times
781         unchecked {
782             return _currentIndex - _burnCounter - _startTokenId();
783         }
784     }
785 
786     /**
787      * Returns the total amount of tokens minted in the contract.
788      */
789     function _totalMinted() internal view returns (uint256) {
790         // Counter underflow is impossible as _currentIndex does not decrement,
791         // and it is initialized to _startTokenId()
792         unchecked {
793             return _currentIndex - _startTokenId();
794         }
795     }
796 
797     /**
798      * @dev See {IERC165-supportsInterface}.
799      */
800     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
801         return
802             interfaceId == type(IERC721).interfaceId ||
803             interfaceId == type(IERC721Metadata).interfaceId ||
804             super.supportsInterface(interfaceId);
805     }
806 
807     /**
808      * @dev See {IERC721-balanceOf}.
809      */
810     function balanceOf(address owner) public view override returns (uint256) {
811         if (owner == address(0)) revert BalanceQueryForZeroAddress();
812         return uint256(_addressData[owner].balance);
813     }
814 
815     /**
816      * Returns the number of tokens minted by `owner`.
817      */
818     function _numberMinted(address owner) internal view returns (uint256) {
819         return uint256(_addressData[owner].numberMinted);
820     }
821 
822     /**
823      * Returns the number of tokens burned by or on behalf of `owner`.
824      */
825     function _numberBurned(address owner) internal view returns (uint256) {
826         return uint256(_addressData[owner].numberBurned);
827     }
828 
829     /**
830      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
831      */
832     function _getAux(address owner) internal view returns (uint64) {
833         return _addressData[owner].aux;
834     }
835 
836     /**
837      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
838      * If there are multiple variables, please pack them into a uint64.
839      */
840     function _setAux(address owner, uint64 aux) internal {
841         _addressData[owner].aux = aux;
842     }
843 
844     /**
845      * Gas spent here starts off proportional to the maximum mint batch size.
846      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
847      */
848     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
849         uint256 curr = tokenId;
850 
851         unchecked {
852             if (_startTokenId() <= curr && curr < _currentIndex) {
853                 TokenOwnership memory ownership = _ownerships[curr];
854                 if (!ownership.burned) {
855                     if (ownership.addr != address(0)) {
856                         return ownership;
857                     }
858                     // Invariant:
859                     // There will always be an ownership that has an address and is not burned
860                     // before an ownership that does not have an address and is not burned.
861                     // Hence, curr will not underflow.
862                     while (true) {
863                         curr--;
864                         ownership = _ownerships[curr];
865                         if (ownership.addr != address(0)) {
866                             return ownership;
867                         }
868                     }
869                 }
870             }
871         }
872         revert OwnerQueryForNonexistentToken();
873     }
874 
875     /**
876      * @dev See {IERC721-ownerOf}.
877      */
878     function ownerOf(uint256 tokenId) public view override returns (address) {
879         return _ownershipOf(tokenId).addr;
880     }
881 
882     /**
883      * @dev See {IERC721Metadata-name}.
884      */
885     function name() public view virtual override returns (string memory) {
886         return _name;
887     }
888 
889     /**
890      * @dev See {IERC721Metadata-symbol}.
891      */
892     function symbol() public view virtual override returns (string memory) {
893         return _symbol;
894     }
895 
896     /**
897      * @dev See {IERC721Metadata-tokenURI}.
898      */
899     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
900         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
901 
902         string memory baseURI = _baseURI();
903         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
904     }
905 
906     /**
907      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
908      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
909      * by default, can be overriden in child contracts.
910      */
911     function _baseURI() internal view virtual returns (string memory) {
912         return '';
913     }
914 
915     /**
916      * @dev See {IERC721-approve}.
917      */
918     function approve(address to, uint256 tokenId) public override {
919         address owner = ERC721A.ownerOf(tokenId);
920         if (to == owner) revert ApprovalToCurrentOwner();
921 
922         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
923             revert ApprovalCallerNotOwnerNorApproved();
924         }
925 
926         _approve(to, tokenId, owner);
927     }
928 
929     /**
930      * @dev See {IERC721-getApproved}.
931      */
932     function getApproved(uint256 tokenId) public view override returns (address) {
933         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
934 
935         return _tokenApprovals[tokenId];
936     }
937 
938     /**
939      * @dev See {IERC721-setApprovalForAll}.
940      */
941     function setApprovalForAll(address operator, bool approved) public virtual override {
942         if (operator == _msgSender()) revert ApproveToCaller();
943 
944         _operatorApprovals[_msgSender()][operator] = approved;
945         emit ApprovalForAll(_msgSender(), operator, approved);
946     }
947 
948     /**
949      * @dev See {IERC721-isApprovedForAll}.
950      */
951     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
952         return _operatorApprovals[owner][operator];
953     }
954 
955     /**
956      * @dev See {IERC721-transferFrom}.
957      */
958     function transferFrom(
959         address from,
960         address to,
961         uint256 tokenId
962     ) public virtual override {
963         _transfer(from, to, tokenId);
964     }
965 
966     /**
967      * @dev See {IERC721-safeTransferFrom}.
968      */
969     function safeTransferFrom(
970         address from,
971         address to,
972         uint256 tokenId
973     ) public virtual override {
974         safeTransferFrom(from, to, tokenId, '');
975     }
976 
977     /**
978      * @dev See {IERC721-safeTransferFrom}.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) public virtual override {
986         _transfer(from, to, tokenId);
987         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
988             revert TransferToNonERC721ReceiverImplementer();
989         }
990     }
991 
992     /**
993      * @dev Returns whether `tokenId` exists.
994      *
995      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
996      *
997      * Tokens start existing when they are minted (`_mint`),
998      */
999     function _exists(uint256 tokenId) internal view returns (bool) {
1000         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1001             !_ownerships[tokenId].burned;
1002     }
1003 
1004     function _safeMint(address to, uint256 quantity) internal {
1005         _safeMint(to, quantity, '');
1006     }
1007 
1008     /**
1009      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1010      *
1011      * Requirements:
1012      *
1013      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1014      * - `quantity` must be greater than 0.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _safeMint(
1019         address to,
1020         uint256 quantity,
1021         bytes memory _data
1022     ) internal {
1023         _mint(to, quantity, _data, true);
1024     }
1025 
1026     /**
1027      * @dev Mints `quantity` tokens and transfers them to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `quantity` must be greater than 0.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _mint(
1037         address to,
1038         uint256 quantity,
1039         bytes memory _data,
1040         bool safe
1041     ) internal {
1042         uint256 startTokenId = _currentIndex;
1043         if (to == address(0)) revert MintToZeroAddress();
1044         if (quantity == 0) revert MintZeroQuantity();
1045 
1046         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1047 
1048         // Overflows are incredibly unrealistic.
1049         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1050         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1051         unchecked {
1052             _addressData[to].balance += uint64(quantity);
1053             _addressData[to].numberMinted += uint64(quantity);
1054 
1055             _ownerships[startTokenId].addr = to;
1056             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1057 
1058             uint256 updatedIndex = startTokenId;
1059             uint256 end = updatedIndex + quantity;
1060 
1061             if (safe && to.isContract()) {
1062                 do {
1063                     emit Transfer(address(0), to, updatedIndex);
1064                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1065                         revert TransferToNonERC721ReceiverImplementer();
1066                     }
1067                 } while (updatedIndex != end);
1068                 // Reentrancy protection
1069                 if (_currentIndex != startTokenId) revert();
1070             } else {
1071                 do {
1072                     emit Transfer(address(0), to, updatedIndex++);
1073                 } while (updatedIndex != end);
1074             }
1075             _currentIndex = updatedIndex;
1076         }
1077         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1078     }
1079 
1080     /**
1081      * @dev Transfers `tokenId` from `from` to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - `to` cannot be the zero address.
1086      * - `tokenId` token must be owned by `from`.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _transfer(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) private {
1095         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1096 
1097         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1098 
1099         bool isApprovedOrOwner = (_msgSender() == from ||
1100             isApprovedForAll(from, _msgSender()) ||
1101             getApproved(tokenId) == _msgSender());
1102 
1103         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1104         if (to == address(0)) revert TransferToZeroAddress();
1105 
1106         _beforeTokenTransfers(from, to, tokenId, 1);
1107 
1108         // Clear approvals from the previous owner
1109         _approve(address(0), tokenId, from);
1110 
1111         // Underflow of the sender's balance is impossible because we check for
1112         // ownership above and the recipient's balance can't realistically overflow.
1113         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1114         unchecked {
1115             _addressData[from].balance -= 1;
1116             _addressData[to].balance += 1;
1117 
1118             TokenOwnership storage currSlot = _ownerships[tokenId];
1119             currSlot.addr = to;
1120             currSlot.startTimestamp = uint64(block.timestamp);
1121 
1122             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1123             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1124             uint256 nextTokenId = tokenId + 1;
1125             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1126             if (nextSlot.addr == address(0)) {
1127                 // This will suffice for checking _exists(nextTokenId),
1128                 // as a burned slot cannot contain the zero address.
1129                 if (nextTokenId != _currentIndex) {
1130                     nextSlot.addr = from;
1131                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1132                 }
1133             }
1134         }
1135 
1136         emit Transfer(from, to, tokenId);
1137         _afterTokenTransfers(from, to, tokenId, 1);
1138     }
1139 
1140     /**
1141      * @dev This is equivalent to _burn(tokenId, false)
1142      */
1143     function _burn(uint256 tokenId) internal virtual {
1144         _burn(tokenId, false);
1145     }
1146 
1147     /**
1148      * @dev Destroys `tokenId`.
1149      * The approval is cleared when the token is burned.
1150      *
1151      * Requirements:
1152      *
1153      * - `tokenId` must exist.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1158         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1159 
1160         address from = prevOwnership.addr;
1161 
1162         if (approvalCheck) {
1163             bool isApprovedOrOwner = (_msgSender() == from ||
1164                 isApprovedForAll(from, _msgSender()) ||
1165                 getApproved(tokenId) == _msgSender());
1166 
1167             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1168         }
1169 
1170         _beforeTokenTransfers(from, address(0), tokenId, 1);
1171 
1172         // Clear approvals from the previous owner
1173         _approve(address(0), tokenId, from);
1174 
1175         // Underflow of the sender's balance is impossible because we check for
1176         // ownership above and the recipient's balance can't realistically overflow.
1177         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1178         unchecked {
1179             AddressData storage addressData = _addressData[from];
1180             addressData.balance -= 1;
1181             addressData.numberBurned += 1;
1182 
1183             // Keep track of who burned the token, and the timestamp of burning.
1184             TokenOwnership storage currSlot = _ownerships[tokenId];
1185             currSlot.addr = from;
1186             currSlot.startTimestamp = uint64(block.timestamp);
1187             currSlot.burned = true;
1188 
1189             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1190             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1191             uint256 nextTokenId = tokenId + 1;
1192             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1193             if (nextSlot.addr == address(0)) {
1194                 // This will suffice for checking _exists(nextTokenId),
1195                 // as a burned slot cannot contain the zero address.
1196                 if (nextTokenId != _currentIndex) {
1197                     nextSlot.addr = from;
1198                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1199                 }
1200             }
1201         }
1202 
1203         emit Transfer(from, address(0), tokenId);
1204         _afterTokenTransfers(from, address(0), tokenId, 1);
1205 
1206         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1207         unchecked {
1208             _burnCounter++;
1209         }
1210     }
1211 
1212     /**
1213      * @dev Approve `to` to operate on `tokenId`
1214      *
1215      * Emits a {Approval} event.
1216      */
1217     function _approve(
1218         address to,
1219         uint256 tokenId,
1220         address owner
1221     ) private {
1222         _tokenApprovals[tokenId] = to;
1223         emit Approval(owner, to, tokenId);
1224     }
1225 
1226     /**
1227      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1228      *
1229      * @param from address representing the previous owner of the given token ID
1230      * @param to target address that will receive the tokens
1231      * @param tokenId uint256 ID of the token to be transferred
1232      * @param _data bytes optional data to send along with the call
1233      * @return bool whether the call correctly returned the expected magic value
1234      */
1235     function _checkContractOnERC721Received(
1236         address from,
1237         address to,
1238         uint256 tokenId,
1239         bytes memory _data
1240     ) private returns (bool) {
1241         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1242             return retval == IERC721Receiver(to).onERC721Received.selector;
1243         } catch (bytes memory reason) {
1244             if (reason.length == 0) {
1245                 revert TransferToNonERC721ReceiverImplementer();
1246             } else {
1247                 assembly {
1248                     revert(add(32, reason), mload(reason))
1249                 }
1250             }
1251         }
1252     }
1253 
1254     /**
1255      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1256      * And also called before burning one token.
1257      *
1258      * startTokenId - the first token id to be transferred
1259      * quantity - the amount to be transferred
1260      *
1261      * Calling conditions:
1262      *
1263      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1264      * transferred to `to`.
1265      * - When `from` is zero, `tokenId` will be minted for `to`.
1266      * - When `to` is zero, `tokenId` will be burned by `from`.
1267      * - `from` and `to` are never both zero.
1268      */
1269     function _beforeTokenTransfers(
1270         address from,
1271         address to,
1272         uint256 startTokenId,
1273         uint256 quantity
1274     ) internal virtual {}
1275 
1276     /**
1277      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1278      * minting.
1279      * And also called after one token has been burned.
1280      *
1281      * startTokenId - the first token id to be transferred
1282      * quantity - the amount to be transferred
1283      *
1284      * Calling conditions:
1285      *
1286      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1287      * transferred to `to`.
1288      * - When `from` is zero, `tokenId` has been minted for `to`.
1289      * - When `to` is zero, `tokenId` has been burned by `from`.
1290      * - `from` and `to` are never both zero.
1291      */
1292     function _afterTokenTransfers(
1293         address from,
1294         address to,
1295         uint256 startTokenId,
1296         uint256 quantity
1297     ) internal virtual {}
1298 }
1299 
1300 abstract contract Ownable is Context {
1301     address private _owner;
1302 
1303     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1304 
1305     /**
1306      * @dev Initializes the contract setting the deployer as the initial owner.
1307      */
1308     constructor() {
1309         _transferOwnership(_msgSender());
1310     }
1311 
1312     /**
1313      * @dev Returns the address of the current owner.
1314      */
1315     function owner() public view virtual returns (address) {
1316         return _owner;
1317     }
1318 
1319     /**
1320      * @dev Throws if called by any account other than the owner.
1321      */
1322     modifier onlyOwner() {
1323         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1324         _;
1325     }
1326 
1327     /**
1328      * @dev Leaves the contract without owner. It will not be possible to call
1329      * `onlyOwner` functions anymore. Can only be called by the current owner.
1330      *
1331      * NOTE: Renouncing ownership will leave the contract without an owner,
1332      * thereby removing any functionality that is only available to the owner.
1333      */
1334     function renounceOwnership() public virtual onlyOwner {
1335         _transferOwnership(address(0));
1336     }
1337 
1338     /**
1339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1340      * Can only be called by the current owner.
1341      */
1342     function transferOwnership(address newOwner) public virtual onlyOwner {
1343         require(newOwner != address(0), "Ownable: new owner is the zero address");
1344         _transferOwnership(newOwner);
1345     }
1346 
1347     /**
1348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1349      * Internal function without access restriction.
1350      */
1351     function _transferOwnership(address newOwner) internal virtual {
1352         address oldOwner = _owner;
1353         _owner = newOwner;
1354         emit OwnershipTransferred(oldOwner, newOwner);
1355     }
1356 }
1357     pragma solidity ^0.8.7;
1358     
1359     contract OBAYC is ERC721A, Ownable, ReentrancyGuard {
1360     using Strings for uint256;
1361 
1362 
1363   string private uriPrefix ;
1364   string private uriSuffix = ".json";
1365   string public hiddenURL;
1366 
1367   uint256 public cost = 0.0025 ether;
1368   uint256 public whiteListCost = 0.0025 ether ;
1369   
1370   uint16 public maxSupply = 10000;
1371   uint8 public maxMintAmountPerTx = 10;
1372   uint8 public maxFreeMintAmountPerWallet = 1;
1373   uint256 public freeNFTAlreadyMinted = 0;
1374   uint256 public  NUM_FREE_MINTS = 1000;
1375                                                              
1376   bool public WLpaused = false;
1377   bool public paused = true;
1378   bool public reveal =false;
1379   mapping (address => uint8) public NFTPerWLAddress;
1380   mapping (address => uint8) public NFTPerPublicAddress;
1381   mapping (address => bool) public isWhitelisted;
1382  
1383     constructor(
1384     string memory _tokenName,
1385     string memory _tokenSymbol,
1386     string memory _hiddenMetadataUri
1387   ) ERC721A(_tokenName, _tokenSymbol) {
1388     
1389   }
1390 
1391   
1392  
1393  
1394   function mint(uint256 _mintAmount)
1395       external
1396       payable
1397   {
1398     require(!paused, "The contract is paused!");
1399     require(totalSupply() + _mintAmount < maxSupply + 1, "No more");
1400 
1401     if(freeNFTAlreadyMinted + _mintAmount > NUM_FREE_MINTS){
1402         require(
1403             (cost * _mintAmount) <= msg.value,
1404             "Incorrect ETH value sent"
1405         );
1406     }
1407      else {
1408         if (balanceOf(msg.sender) + _mintAmount > maxFreeMintAmountPerWallet) {
1409         require(
1410             (cost * _mintAmount) <= msg.value,
1411             "Incorrect ETH value sent"
1412         );
1413         require(
1414             _mintAmount <= maxMintAmountPerTx,
1415             "Max mints per transaction exceeded"
1416         );
1417         } else {
1418             require(
1419                 _mintAmount <= maxFreeMintAmountPerWallet,
1420                 "Max mints per transaction exceeded"
1421             );
1422             freeNFTAlreadyMinted += _mintAmount;
1423         }
1424     }
1425     _safeMint(msg.sender, _mintAmount);
1426   }
1427 
1428   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1429      uint16 totalSupply = uint16(totalSupply());
1430     require(totalSupply + _mintAmount <= maxSupply, "Excedes max supply.");
1431      _safeMint(_receiver , _mintAmount);
1432      delete _mintAmount;
1433      delete _receiver;
1434      delete totalSupply;
1435   }
1436 
1437   function Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1438      uint16 totalSupply = uint16(totalSupply());
1439      uint totalAmount =   _amountPerAddress * addresses.length;
1440     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1441      for (uint256 i = 0; i < addresses.length; i++) {
1442             _safeMint(addresses[i], _amountPerAddress);
1443         }
1444 
1445      delete _amountPerAddress;
1446      delete totalSupply;
1447   }
1448 
1449  
1450 
1451   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1452       maxSupply = _maxSupply;
1453   }
1454 
1455 
1456 
1457    
1458   function tokenURI(uint256 _tokenId)
1459     public
1460     view
1461     virtual
1462     override
1463     returns (string memory)
1464   {
1465     require(
1466       _exists(_tokenId),
1467       "ERC721Metadata: URI query for nonexistent token"
1468     );
1469     
1470   
1471 if ( reveal == false)
1472 {
1473     return hiddenURL;
1474 }
1475     
1476 
1477     string memory currentBaseURI = _baseURI();
1478     return bytes(currentBaseURI).length > 0
1479         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1480         : "";
1481   }
1482  
1483    function setWLPaused() external onlyOwner {
1484     WLpaused = !WLpaused;
1485   }
1486   function setWLCost(uint256 _cost) external onlyOwner {
1487     whiteListCost = _cost;
1488     delete _cost;
1489   }
1490 
1491 
1492 
1493  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1494     maxFreeMintAmountPerWallet = _limit;
1495    delete _limit;
1496 
1497 }
1498 
1499     
1500   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1501         for(uint8 i = 0; i < entries.length; i++) {
1502             isWhitelisted[entries[i]] = true;
1503         }   
1504     }
1505 
1506     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1507         for(uint8 i = 0; i < entries.length; i++) {
1508              isWhitelisted[entries[i]] = false;
1509         }
1510     }
1511 
1512 
1513 
1514     function whitelistMint(uint256 _mintAmount)
1515       external
1516       payable
1517   {
1518     require(!WLpaused, "Whitelist minting is over!");
1519      require(isWhitelisted[msg.sender],  "You are not whitelisted");
1520 
1521     require(totalSupply() + _mintAmount < maxSupply + 1, "No more");
1522 
1523     if(freeNFTAlreadyMinted + _mintAmount > NUM_FREE_MINTS){
1524         require(
1525             (whiteListCost * _mintAmount) <= msg.value,
1526             "Incorrect ETH value sent"
1527         );
1528     }
1529      else {
1530         if (balanceOf(msg.sender) + _mintAmount > maxFreeMintAmountPerWallet) {
1531         require(
1532             (whiteListCost * _mintAmount) <= msg.value,
1533             "Incorrect ETH value sent"
1534         );
1535         require(
1536             _mintAmount <= maxMintAmountPerTx,
1537             "Max mints per transaction exceeded"
1538         );
1539         } else {
1540             require(
1541                 _mintAmount <= maxFreeMintAmountPerWallet,
1542                 "Max mints per transaction exceeded"
1543             );
1544             freeNFTAlreadyMinted += _mintAmount;
1545         }
1546     }
1547     _safeMint(msg.sender, _mintAmount);
1548   }
1549 
1550   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1551     uriPrefix = _uriPrefix;
1552   }
1553    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1554     hiddenURL = _uriPrefix;
1555   }
1556 
1557 
1558   function setPaused() external onlyOwner {
1559     paused = !paused;
1560     WLpaused = true;
1561   }
1562 
1563   function setCost(uint _cost) external onlyOwner{
1564       cost = _cost;
1565 
1566   }
1567 
1568  function setRevealed() external onlyOwner{
1569      reveal = !reveal;
1570  }
1571 
1572   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1573       maxMintAmountPerTx = _maxtx;
1574 
1575   }
1576 
1577  
1578 
1579   function withdraw() public onlyOwner nonReentrant {
1580     // This will transfer the remaining contract balance to the owner.
1581     // Do not remove this otherwise you will not be able to withdraw the funds.
1582     // =============================================================================
1583     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1584     require(os);
1585     // =============================================================================
1586   }
1587 
1588 
1589   function _baseURI() internal view  override returns (string memory) {
1590     return uriPrefix;
1591   }
1592 }