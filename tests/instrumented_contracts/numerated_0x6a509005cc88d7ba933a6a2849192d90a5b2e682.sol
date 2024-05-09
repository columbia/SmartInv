1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.3;
4 
5 
6 
7 // Part: Base64
8 
9 /// @title Base64
10 /// @notice Provides a function for encoding some bytes in base64
11 /// @author Brecht Devos <brecht@loopring.org>
12 library Base64 {
13   bytes internal constant TABLE =
14     'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
15 
16   /// @notice Encodes some bytes to the base64 representation
17   function encode(bytes memory data) internal pure returns (string memory) {
18     uint len = data.length;
19     if (len == 0) return '';
20     // multiply by 4/3 rounded up
21     uint encodedLen = 4 * ((len + 2) / 3);
22     // Add some extra buffer at the end
23     bytes memory result = new bytes(encodedLen + 32);
24     bytes memory table = TABLE;
25     assembly {
26       let tablePtr := add(table, 1)
27       let resultPtr := add(result, 32)
28       for {
29         let i := 0
30       } lt(i, len) {
31 
32       } {
33         i := add(i, 3)
34         let input := and(mload(add(data, i)), 0xffffff)
35         let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
36         out := shl(8, out)
37         out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
38         out := shl(8, out)
39         out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
40         out := shl(8, out)
41         out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
42         out := shl(224, out)
43         mstore(resultPtr, out)
44         resultPtr := add(resultPtr, 4)
45       }
46       switch mod(len, 3)
47       case 1 {
48         mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
49       }
50       case 2 {
51         mstore(sub(resultPtr, 1), shl(248, 0x3d))
52       }
53       mstore(result, encodedLen)
54     }
55     return string(result);
56   }
57 }
58 
59 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Address
60 
61 /**
62  * @dev Collection of functions related to the address type
63  */
64 library Address {
65     /**
66      * @dev Returns true if `account` is a contract.
67      *
68      * [IMPORTANT]
69      * ====
70      * It is unsafe to assume that an address for which this function returns
71      * false is an externally-owned account (EOA) and not a contract.
72      *
73      * Among others, `isContract` will return false for the following
74      * types of addresses:
75      *
76      *  - an externally-owned account
77      *  - a contract in construction
78      *  - an address where a contract will be created
79      *  - an address where a contract lived, but was destroyed
80      * ====
81      */
82     function isContract(address account) internal view returns (bool) {
83         // This method relies on extcodesize, which returns 0 for contracts in
84         // construction, since the code is only stored at the end of the
85         // constructor execution.
86 
87         uint256 size;
88         assembly {
89             size := extcodesize(account)
90         }
91         return size > 0;
92     }
93 
94     /**
95      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
96      * `recipient`, forwarding all available gas and reverting on errors.
97      *
98      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
99      * of certain opcodes, possibly making contracts go over the 2300 gas limit
100      * imposed by `transfer`, making them unable to receive funds via
101      * `transfer`. {sendValue} removes this limitation.
102      *
103      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
104      *
105      * IMPORTANT: because control is transferred to `recipient`, care must be
106      * taken to not create reentrancy vulnerabilities. Consider using
107      * {ReentrancyGuard} or the
108      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
109      */
110     function sendValue(address payable recipient, uint256 amount) internal {
111         require(address(this).balance >= amount, "Address: insufficient balance");
112 
113         (bool success, ) = recipient.call{value: amount}("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     /**
118      * @dev Performs a Solidity function call using a low level `call`. A
119      * plain `call` is an unsafe replacement for a function call: use this
120      * function instead.
121      *
122      * If `target` reverts with a revert reason, it is bubbled up by this
123      * function (like regular Solidity function calls).
124      *
125      * Returns the raw returned data. To convert to the expected return value,
126      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
127      *
128      * Requirements:
129      *
130      * - `target` must be a contract.
131      * - calling `target` with `data` must not revert.
132      *
133      * _Available since v3.1._
134      */
135     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
136         return functionCall(target, data, "Address: low-level call failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
141      * `errorMessage` as a fallback revert reason when `target` reverts.
142      *
143      * _Available since v3.1._
144      */
145     function functionCall(
146         address target,
147         bytes memory data,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         return functionCallWithValue(target, data, 0, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but also transferring `value` wei to `target`.
156      *
157      * Requirements:
158      *
159      * - the calling contract must have an ETH balance of at least `value`.
160      * - the called Solidity function must be `payable`.
161      *
162      * _Available since v3.1._
163      */
164     function functionCallWithValue(
165         address target,
166         bytes memory data,
167         uint256 value
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
174      * with `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCallWithValue(
179         address target,
180         bytes memory data,
181         uint256 value,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         require(address(this).balance >= value, "Address: insufficient balance for call");
185         require(isContract(target), "Address: call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.call{value: value}(data);
188         return verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but performing a static call.
194      *
195      * _Available since v3.3._
196      */
197     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
198         return functionStaticCall(target, data, "Address: low-level static call failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
203      * but performing a static call.
204      *
205      * _Available since v3.3._
206      */
207     function functionStaticCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal view returns (bytes memory) {
212         require(isContract(target), "Address: static call to non-contract");
213 
214         (bool success, bytes memory returndata) = target.staticcall(data);
215         return verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but performing a delegate call.
221      *
222      * _Available since v3.4._
223      */
224     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
230      * but performing a delegate call.
231      *
232      * _Available since v3.4._
233      */
234     function functionDelegateCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         require(isContract(target), "Address: delegate call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.delegatecall(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
247      * revert reason using the provided one.
248      *
249      * _Available since v4.3._
250      */
251     function verifyCallResult(
252         bool success,
253         bytes memory returndata,
254         string memory errorMessage
255     ) internal pure returns (bytes memory) {
256         if (success) {
257             return returndata;
258         } else {
259             // Look for revert reason and bubble it up if present
260             if (returndata.length > 0) {
261                 // The easiest way to bubble the revert reason is using memory via assembly
262 
263                 assembly {
264                     let returndata_size := mload(returndata)
265                     revert(add(32, returndata), returndata_size)
266                 }
267             } else {
268                 revert(errorMessage);
269             }
270         }
271     }
272 }
273 
274 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Context
275 
276 /**
277  * @dev Provides information about the current execution context, including the
278  * sender of the transaction and its data. While these are generally available
279  * via msg.sender and msg.data, they should not be accessed in such a direct
280  * manner, since when dealing with meta-transactions the account sending and
281  * paying for execution may not be the actual sender (as far as an application
282  * is concerned).
283  *
284  * This contract is only required for intermediate, library-like contracts.
285  */
286 abstract contract Context {
287     function _msgSender() internal view virtual returns (address) {
288         return msg.sender;
289     }
290 
291     function _msgData() internal view virtual returns (bytes calldata) {
292         return msg.data;
293     }
294 }
295 
296 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC165
297 
298 /**
299  * @dev Interface of the ERC165 standard, as defined in the
300  * https://eips.ethereum.org/EIPS/eip-165[EIP].
301  *
302  * Implementers can declare support of contract interfaces, which can then be
303  * queried by others ({ERC165Checker}).
304  *
305  * For an implementation, see {ERC165}.
306  */
307 interface IERC165 {
308     /**
309      * @dev Returns true if this contract implements the interface defined by
310      * `interfaceId`. See the corresponding
311      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
312      * to learn more about how these ids are created.
313      *
314      * This function call must use less than 30 000 gas.
315      */
316     function supportsInterface(bytes4 interfaceId) external view returns (bool);
317 }
318 
319 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ReentrancyGuard
320 
321 /**
322  * @dev Contract module that helps prevent reentrant calls to a function.
323  *
324  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
325  * available, which can be applied to functions to make sure there are no nested
326  * (reentrant) calls to them.
327  *
328  * Note that because there is a single `nonReentrant` guard, functions marked as
329  * `nonReentrant` may not call one another. This can be worked around by making
330  * those functions `private`, and then adding `external` `nonReentrant` entry
331  * points to them.
332  *
333  * TIP: If you would like to learn more about reentrancy and alternative ways
334  * to protect against it, check out our blog post
335  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
336  */
337 abstract contract ReentrancyGuard {
338     // Booleans are more expensive than uint256 or any type that takes up a full
339     // word because each write operation emits an extra SLOAD to first read the
340     // slot's contents, replace the bits taken up by the boolean, and then write
341     // back. This is the compiler's defense against contract upgrades and
342     // pointer aliasing, and it cannot be disabled.
343 
344     // The values being non-zero value makes deployment a bit more expensive,
345     // but in exchange the refund on every call to nonReentrant will be lower in
346     // amount. Since refunds are capped to a percentage of the total
347     // transaction's gas, it is best to keep them low in cases like this one, to
348     // increase the likelihood of the full refund coming into effect.
349     uint256 private constant _NOT_ENTERED = 1;
350     uint256 private constant _ENTERED = 2;
351 
352     uint256 private _status;
353 
354     constructor() {
355         _status = _NOT_ENTERED;
356     }
357 
358     /**
359      * @dev Prevents a contract from calling itself, directly or indirectly.
360      * Calling a `nonReentrant` function from another `nonReentrant`
361      * function is not supported. It is possible to prevent this from happening
362      * by making the `nonReentrant` function external, and make it call a
363      * `private` function that does the actual work.
364      */
365     modifier nonReentrant() {
366         // On the first call to nonReentrant, _notEntered will be true
367         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
368 
369         // Any calls to nonReentrant after this point will fail
370         _status = _ENTERED;
371 
372         _;
373 
374         // By storing the original value once again, a refund is triggered (see
375         // https://eips.ethereum.org/EIPS/eip-2200)
376         _status = _NOT_ENTERED;
377     }
378 }
379 
380 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC165
381 
382 /**
383  * @dev Implementation of the {IERC165} interface.
384  *
385  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
386  * for the additional interface id that will be supported. For example:
387  *
388  * ```solidity
389  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
390  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
391  * }
392  * ```
393  *
394  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
395  */
396 abstract contract ERC165 is IERC165 {
397     /**
398      * @dev See {IERC165-supportsInterface}.
399      */
400     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
401         return interfaceId == type(IERC165).interfaceId;
402     }
403 }
404 
405 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC1155
406 
407 /**
408  * @dev Required interface of an ERC1155 compliant contract, as defined in the
409  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
410  *
411  * _Available since v3.1._
412  */
413 interface IERC1155 is IERC165 {
414     /**
415      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
416      */
417     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
418 
419     /**
420      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
421      * transfers.
422      */
423     event TransferBatch(
424         address indexed operator,
425         address indexed from,
426         address indexed to,
427         uint256[] ids,
428         uint256[] values
429     );
430 
431     /**
432      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
433      * `approved`.
434      */
435     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
436 
437     /**
438      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
439      *
440      * If an {URI} event was emitted for `id`, the standard
441      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
442      * returned by {IERC1155MetadataURI-uri}.
443      */
444     event URI(string value, uint256 indexed id);
445 
446     /**
447      * @dev Returns the amount of tokens of token type `id` owned by `account`.
448      *
449      * Requirements:
450      *
451      * - `account` cannot be the zero address.
452      */
453     function balanceOf(address account, uint256 id) external view returns (uint256);
454 
455     /**
456      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
457      *
458      * Requirements:
459      *
460      * - `accounts` and `ids` must have the same length.
461      */
462     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
463         external
464         view
465         returns (uint256[] memory);
466 
467     /**
468      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
469      *
470      * Emits an {ApprovalForAll} event.
471      *
472      * Requirements:
473      *
474      * - `operator` cannot be the caller.
475      */
476     function setApprovalForAll(address operator, bool approved) external;
477 
478     /**
479      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
480      *
481      * See {setApprovalForAll}.
482      */
483     function isApprovedForAll(address account, address operator) external view returns (bool);
484 
485     /**
486      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
487      *
488      * Emits a {TransferSingle} event.
489      *
490      * Requirements:
491      *
492      * - `to` cannot be the zero address.
493      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
494      * - `from` must have a balance of tokens of type `id` of at least `amount`.
495      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
496      * acceptance magic value.
497      */
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 id,
502         uint256 amount,
503         bytes calldata data
504     ) external;
505 
506     /**
507      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
508      *
509      * Emits a {TransferBatch} event.
510      *
511      * Requirements:
512      *
513      * - `ids` and `amounts` must have the same length.
514      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
515      * acceptance magic value.
516      */
517     function safeBatchTransferFrom(
518         address from,
519         address to,
520         uint256[] calldata ids,
521         uint256[] calldata amounts,
522         bytes calldata data
523     ) external;
524 }
525 
526 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC1155Receiver
527 
528 /**
529  * @dev _Available since v3.1._
530  */
531 interface IERC1155Receiver is IERC165 {
532     /**
533         @dev Handles the receipt of a single ERC1155 token type. This function is
534         called at the end of a `safeTransferFrom` after the balance has been updated.
535         To accept the transfer, this must return
536         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
537         (i.e. 0xf23a6e61, or its own function selector).
538         @param operator The address which initiated the transfer (i.e. msg.sender)
539         @param from The address which previously owned the token
540         @param id The ID of the token being transferred
541         @param value The amount of tokens being transferred
542         @param data Additional data with no specified format
543         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
544     */
545     function onERC1155Received(
546         address operator,
547         address from,
548         uint256 id,
549         uint256 value,
550         bytes calldata data
551     ) external returns (bytes4);
552 
553     /**
554         @dev Handles the receipt of a multiple ERC1155 token types. This function
555         is called at the end of a `safeBatchTransferFrom` after the balances have
556         been updated. To accept the transfer(s), this must return
557         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
558         (i.e. 0xbc197c81, or its own function selector).
559         @param operator The address which initiated the batch transfer (i.e. msg.sender)
560         @param from The address which previously owned the token
561         @param ids An array containing ids of each token being transferred (order and length must match values array)
562         @param values An array containing amounts of each token being transferred (order and length must match ids array)
563         @param data Additional data with no specified format
564         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
565     */
566     function onERC1155BatchReceived(
567         address operator,
568         address from,
569         uint256[] calldata ids,
570         uint256[] calldata values,
571         bytes calldata data
572     ) external returns (bytes4);
573 }
574 
575 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC721
576 
577 /**
578  * @dev Required interface of an ERC721 compliant contract.
579  */
580 interface IERC721 is IERC165 {
581     /**
582      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
583      */
584     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
588      */
589     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
590 
591     /**
592      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
593      */
594     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
595 
596     /**
597      * @dev Returns the number of tokens in ``owner``'s account.
598      */
599     function balanceOf(address owner) external view returns (uint256 balance);
600 
601     /**
602      * @dev Returns the owner of the `tokenId` token.
603      *
604      * Requirements:
605      *
606      * - `tokenId` must exist.
607      */
608     function ownerOf(uint256 tokenId) external view returns (address owner);
609 
610     /**
611      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
612      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must exist and be owned by `from`.
619      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
621      *
622      * Emits a {Transfer} event.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId
628     ) external;
629 
630     /**
631      * @dev Transfers `tokenId` token from `from` to `to`.
632      *
633      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must be owned by `from`.
640      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
641      *
642      * Emits a {Transfer} event.
643      */
644     function transferFrom(
645         address from,
646         address to,
647         uint256 tokenId
648     ) external;
649 
650     /**
651      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
652      * The approval is cleared when the token is transferred.
653      *
654      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
655      *
656      * Requirements:
657      *
658      * - The caller must own the token or be an approved operator.
659      * - `tokenId` must exist.
660      *
661      * Emits an {Approval} event.
662      */
663     function approve(address to, uint256 tokenId) external;
664 
665     /**
666      * @dev Returns the account approved for `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function getApproved(uint256 tokenId) external view returns (address operator);
673 
674     /**
675      * @dev Approve or remove `operator` as an operator for the caller.
676      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
677      *
678      * Requirements:
679      *
680      * - The `operator` cannot be the caller.
681      *
682      * Emits an {ApprovalForAll} event.
683      */
684     function setApprovalForAll(address operator, bool _approved) external;
685 
686     /**
687      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
688      *
689      * See {setApprovalForAll}
690      */
691     function isApprovedForAll(address owner, address operator) external view returns (bool);
692 
693     /**
694      * @dev Safely transfers `tokenId` token from `from` to `to`.
695      *
696      * Requirements:
697      *
698      * - `from` cannot be the zero address.
699      * - `to` cannot be the zero address.
700      * - `tokenId` token must exist and be owned by `from`.
701      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
702      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
703      *
704      * Emits a {Transfer} event.
705      */
706     function safeTransferFrom(
707         address from,
708         address to,
709         uint256 tokenId,
710         bytes calldata data
711     ) external;
712 }
713 
714 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Ownable
715 
716 /**
717  * @dev Contract module which provides a basic access control mechanism, where
718  * there is an account (an owner) that can be granted exclusive access to
719  * specific functions.
720  *
721  * By default, the owner account will be the one that deploys the contract. This
722  * can later be changed with {transferOwnership}.
723  *
724  * This module is used through inheritance. It will make available the modifier
725  * `onlyOwner`, which can be applied to your functions to restrict their use to
726  * the owner.
727  */
728 abstract contract Ownable is Context {
729     address private _owner;
730 
731     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
732 
733     /**
734      * @dev Initializes the contract setting the deployer as the initial owner.
735      */
736     constructor() {
737         _setOwner(_msgSender());
738     }
739 
740     /**
741      * @dev Returns the address of the current owner.
742      */
743     function owner() public view virtual returns (address) {
744         return _owner;
745     }
746 
747     /**
748      * @dev Throws if called by any account other than the owner.
749      */
750     modifier onlyOwner() {
751         require(owner() == _msgSender(), "Ownable: caller is not the owner");
752         _;
753     }
754 
755     /**
756      * @dev Leaves the contract without owner. It will not be possible to call
757      * `onlyOwner` functions anymore. Can only be called by the current owner.
758      *
759      * NOTE: Renouncing ownership will leave the contract without an owner,
760      * thereby removing any functionality that is only available to the owner.
761      */
762     function renounceOwnership() public virtual onlyOwner {
763         _setOwner(address(0));
764     }
765 
766     /**
767      * @dev Transfers ownership of the contract to a new account (`newOwner`).
768      * Can only be called by the current owner.
769      */
770     function transferOwnership(address newOwner) public virtual onlyOwner {
771         require(newOwner != address(0), "Ownable: new owner is the zero address");
772         _setOwner(newOwner);
773     }
774 
775     function _setOwner(address newOwner) private {
776         address oldOwner = _owner;
777         _owner = newOwner;
778         emit OwnershipTransferred(oldOwner, newOwner);
779     }
780 }
781 
782 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC1155MetadataURI
783 
784 /**
785  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
786  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
787  *
788  * _Available since v3.1._
789  */
790 interface IERC1155MetadataURI is IERC1155 {
791     /**
792      * @dev Returns the URI for token type `id`.
793      *
794      * If the `\{id\}` substring is present in the URI, it must be replaced by
795      * clients with the actual token type ID.
796      */
797     function uri(uint256 id) external view returns (string memory);
798 }
799 
800 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC1155
801 
802 /**
803  * @dev Implementation of the basic standard multi-token.
804  * See https://eips.ethereum.org/EIPS/eip-1155
805  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
806  *
807  * _Available since v3.1._
808  */
809 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
810     using Address for address;
811 
812     // Mapping from token ID to account balances
813     mapping(uint256 => mapping(address => uint256)) private _balances;
814 
815     // Mapping from account to operator approvals
816     mapping(address => mapping(address => bool)) private _operatorApprovals;
817 
818     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
819     string private _uri;
820 
821     /**
822      * @dev See {_setURI}.
823      */
824     constructor(string memory uri_) {
825         _setURI(uri_);
826     }
827 
828     /**
829      * @dev See {IERC165-supportsInterface}.
830      */
831     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
832         return
833             interfaceId == type(IERC1155).interfaceId ||
834             interfaceId == type(IERC1155MetadataURI).interfaceId ||
835             super.supportsInterface(interfaceId);
836     }
837 
838     /**
839      * @dev See {IERC1155MetadataURI-uri}.
840      *
841      * This implementation returns the same URI for *all* token types. It relies
842      * on the token type ID substitution mechanism
843      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
844      *
845      * Clients calling this function must replace the `\{id\}` substring with the
846      * actual token type ID.
847      */
848     function uri(uint256) public view virtual override returns (string memory) {
849         return _uri;
850     }
851 
852     /**
853      * @dev See {IERC1155-balanceOf}.
854      *
855      * Requirements:
856      *
857      * - `account` cannot be the zero address.
858      */
859     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
860         require(account != address(0), "ERC1155: balance query for the zero address");
861         return _balances[id][account];
862     }
863 
864     /**
865      * @dev See {IERC1155-balanceOfBatch}.
866      *
867      * Requirements:
868      *
869      * - `accounts` and `ids` must have the same length.
870      */
871     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
872         public
873         view
874         virtual
875         override
876         returns (uint256[] memory)
877     {
878         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
879 
880         uint256[] memory batchBalances = new uint256[](accounts.length);
881 
882         for (uint256 i = 0; i < accounts.length; ++i) {
883             batchBalances[i] = balanceOf(accounts[i], ids[i]);
884         }
885 
886         return batchBalances;
887     }
888 
889     /**
890      * @dev See {IERC1155-setApprovalForAll}.
891      */
892     function setApprovalForAll(address operator, bool approved) public virtual override {
893         require(_msgSender() != operator, "ERC1155: setting approval status for self");
894 
895         _operatorApprovals[_msgSender()][operator] = approved;
896         emit ApprovalForAll(_msgSender(), operator, approved);
897     }
898 
899     /**
900      * @dev See {IERC1155-isApprovedForAll}.
901      */
902     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
903         return _operatorApprovals[account][operator];
904     }
905 
906     /**
907      * @dev See {IERC1155-safeTransferFrom}.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 id,
913         uint256 amount,
914         bytes memory data
915     ) public virtual override {
916         require(
917             from == _msgSender() || isApprovedForAll(from, _msgSender()),
918             "ERC1155: caller is not owner nor approved"
919         );
920         _safeTransferFrom(from, to, id, amount, data);
921     }
922 
923     /**
924      * @dev See {IERC1155-safeBatchTransferFrom}.
925      */
926     function safeBatchTransferFrom(
927         address from,
928         address to,
929         uint256[] memory ids,
930         uint256[] memory amounts,
931         bytes memory data
932     ) public virtual override {
933         require(
934             from == _msgSender() || isApprovedForAll(from, _msgSender()),
935             "ERC1155: transfer caller is not owner nor approved"
936         );
937         _safeBatchTransferFrom(from, to, ids, amounts, data);
938     }
939 
940     /**
941      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
942      *
943      * Emits a {TransferSingle} event.
944      *
945      * Requirements:
946      *
947      * - `to` cannot be the zero address.
948      * - `from` must have a balance of tokens of type `id` of at least `amount`.
949      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
950      * acceptance magic value.
951      */
952     function _safeTransferFrom(
953         address from,
954         address to,
955         uint256 id,
956         uint256 amount,
957         bytes memory data
958     ) internal virtual {
959         require(to != address(0), "ERC1155: transfer to the zero address");
960 
961         address operator = _msgSender();
962 
963         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
964 
965         uint256 fromBalance = _balances[id][from];
966         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
967         unchecked {
968             _balances[id][from] = fromBalance - amount;
969         }
970         _balances[id][to] += amount;
971 
972         emit TransferSingle(operator, from, to, id, amount);
973 
974         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
975     }
976 
977     /**
978      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
979      *
980      * Emits a {TransferBatch} event.
981      *
982      * Requirements:
983      *
984      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
985      * acceptance magic value.
986      */
987     function _safeBatchTransferFrom(
988         address from,
989         address to,
990         uint256[] memory ids,
991         uint256[] memory amounts,
992         bytes memory data
993     ) internal virtual {
994         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
995         require(to != address(0), "ERC1155: transfer to the zero address");
996 
997         address operator = _msgSender();
998 
999         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1000 
1001         for (uint256 i = 0; i < ids.length; ++i) {
1002             uint256 id = ids[i];
1003             uint256 amount = amounts[i];
1004 
1005             uint256 fromBalance = _balances[id][from];
1006             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1007             unchecked {
1008                 _balances[id][from] = fromBalance - amount;
1009             }
1010             _balances[id][to] += amount;
1011         }
1012 
1013         emit TransferBatch(operator, from, to, ids, amounts);
1014 
1015         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1016     }
1017 
1018     /**
1019      * @dev Sets a new URI for all token types, by relying on the token type ID
1020      * substitution mechanism
1021      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1022      *
1023      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1024      * URI or any of the amounts in the JSON file at said URI will be replaced by
1025      * clients with the token type ID.
1026      *
1027      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1028      * interpreted by clients as
1029      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1030      * for token type ID 0x4cce0.
1031      *
1032      * See {uri}.
1033      *
1034      * Because these URIs cannot be meaningfully represented by the {URI} event,
1035      * this function emits no events.
1036      */
1037     function _setURI(string memory newuri) internal virtual {
1038         _uri = newuri;
1039     }
1040 
1041     /**
1042      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1043      *
1044      * Emits a {TransferSingle} event.
1045      *
1046      * Requirements:
1047      *
1048      * - `account` cannot be the zero address.
1049      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1050      * acceptance magic value.
1051      */
1052     function _mint(
1053         address account,
1054         uint256 id,
1055         uint256 amount,
1056         bytes memory data
1057     ) internal virtual {
1058         require(account != address(0), "ERC1155: mint to the zero address");
1059 
1060         address operator = _msgSender();
1061 
1062         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1063 
1064         _balances[id][account] += amount;
1065         emit TransferSingle(operator, address(0), account, id, amount);
1066 
1067         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1068     }
1069 
1070     /**
1071      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1072      *
1073      * Requirements:
1074      *
1075      * - `ids` and `amounts` must have the same length.
1076      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1077      * acceptance magic value.
1078      */
1079     function _mintBatch(
1080         address to,
1081         uint256[] memory ids,
1082         uint256[] memory amounts,
1083         bytes memory data
1084     ) internal virtual {
1085         require(to != address(0), "ERC1155: mint to the zero address");
1086         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1087 
1088         address operator = _msgSender();
1089 
1090         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1091 
1092         for (uint256 i = 0; i < ids.length; i++) {
1093             _balances[ids[i]][to] += amounts[i];
1094         }
1095 
1096         emit TransferBatch(operator, address(0), to, ids, amounts);
1097 
1098         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1099     }
1100 
1101     /**
1102      * @dev Destroys `amount` tokens of token type `id` from `account`
1103      *
1104      * Requirements:
1105      *
1106      * - `account` cannot be the zero address.
1107      * - `account` must have at least `amount` tokens of token type `id`.
1108      */
1109     function _burn(
1110         address account,
1111         uint256 id,
1112         uint256 amount
1113     ) internal virtual {
1114         require(account != address(0), "ERC1155: burn from the zero address");
1115 
1116         address operator = _msgSender();
1117 
1118         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1119 
1120         uint256 accountBalance = _balances[id][account];
1121         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1122         unchecked {
1123             _balances[id][account] = accountBalance - amount;
1124         }
1125 
1126         emit TransferSingle(operator, account, address(0), id, amount);
1127     }
1128 
1129     /**
1130      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1131      *
1132      * Requirements:
1133      *
1134      * - `ids` and `amounts` must have the same length.
1135      */
1136     function _burnBatch(
1137         address account,
1138         uint256[] memory ids,
1139         uint256[] memory amounts
1140     ) internal virtual {
1141         require(account != address(0), "ERC1155: burn from the zero address");
1142         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1143 
1144         address operator = _msgSender();
1145 
1146         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1147 
1148         for (uint256 i = 0; i < ids.length; i++) {
1149             uint256 id = ids[i];
1150             uint256 amount = amounts[i];
1151 
1152             uint256 accountBalance = _balances[id][account];
1153             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1154             unchecked {
1155                 _balances[id][account] = accountBalance - amount;
1156             }
1157         }
1158 
1159         emit TransferBatch(operator, account, address(0), ids, amounts);
1160     }
1161 
1162     /**
1163      * @dev Hook that is called before any token transfer. This includes minting
1164      * and burning, as well as batched variants.
1165      *
1166      * The same hook is called on both single and batched variants. For single
1167      * transfers, the length of the `id` and `amount` arrays will be 1.
1168      *
1169      * Calling conditions (for each `id` and `amount` pair):
1170      *
1171      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1172      * of token type `id` will be  transferred to `to`.
1173      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1174      * for `to`.
1175      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1176      * will be burned.
1177      * - `from` and `to` are never both zero.
1178      * - `ids` and `amounts` have the same, non-zero length.
1179      *
1180      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1181      */
1182     function _beforeTokenTransfer(
1183         address operator,
1184         address from,
1185         address to,
1186         uint256[] memory ids,
1187         uint256[] memory amounts,
1188         bytes memory data
1189     ) internal virtual {}
1190 
1191     function _doSafeTransferAcceptanceCheck(
1192         address operator,
1193         address from,
1194         address to,
1195         uint256 id,
1196         uint256 amount,
1197         bytes memory data
1198     ) private {
1199         if (to.isContract()) {
1200             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1201                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1202                     revert("ERC1155: ERC1155Receiver rejected tokens");
1203                 }
1204             } catch Error(string memory reason) {
1205                 revert(reason);
1206             } catch {
1207                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1208             }
1209         }
1210     }
1211 
1212     function _doSafeBatchTransferAcceptanceCheck(
1213         address operator,
1214         address from,
1215         address to,
1216         uint256[] memory ids,
1217         uint256[] memory amounts,
1218         bytes memory data
1219     ) private {
1220         if (to.isContract()) {
1221             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1222                 bytes4 response
1223             ) {
1224                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1225                     revert("ERC1155: ERC1155Receiver rejected tokens");
1226                 }
1227             } catch Error(string memory reason) {
1228                 revert(reason);
1229             } catch {
1230                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1231             }
1232         }
1233     }
1234 
1235     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1236         uint256[] memory array = new uint256[](1);
1237         array[0] = element;
1238 
1239         return array;
1240     }
1241 }
1242 
1243 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC1155Supply
1244 
1245 /**
1246  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1247  *
1248  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1249  * clearly identified. Note: While a totalSupply of 1 might mean the
1250  * corresponding is an NFT, there is no guarantees that no other token with the
1251  * same id are not going to be minted.
1252  */
1253 abstract contract ERC1155Supply is ERC1155 {
1254     mapping(uint256 => uint256) private _totalSupply;
1255 
1256     /**
1257      * @dev Total amount of tokens in with a given id.
1258      */
1259     function totalSupply(uint256 id) public view virtual returns (uint256) {
1260         return _totalSupply[id];
1261     }
1262 
1263     /**
1264      * @dev Indicates weither any token exist with a given id, or not.
1265      */
1266     function exists(uint256 id) public view virtual returns (bool) {
1267         return ERC1155Supply.totalSupply(id) > 0;
1268     }
1269 
1270     /**
1271      * @dev See {ERC1155-_mint}.
1272      */
1273     function _mint(
1274         address account,
1275         uint256 id,
1276         uint256 amount,
1277         bytes memory data
1278     ) internal virtual override {
1279         super._mint(account, id, amount, data);
1280         _totalSupply[id] += amount;
1281     }
1282 
1283     /**
1284      * @dev See {ERC1155-_mintBatch}.
1285      */
1286     function _mintBatch(
1287         address to,
1288         uint256[] memory ids,
1289         uint256[] memory amounts,
1290         bytes memory data
1291     ) internal virtual override {
1292         super._mintBatch(to, ids, amounts, data);
1293         for (uint256 i = 0; i < ids.length; ++i) {
1294             _totalSupply[ids[i]] += amounts[i];
1295         }
1296     }
1297 
1298     /**
1299      * @dev See {ERC1155-_burn}.
1300      */
1301     function _burn(
1302         address account,
1303         uint256 id,
1304         uint256 amount
1305     ) internal virtual override {
1306         super._burn(account, id, amount);
1307         _totalSupply[id] -= amount;
1308     }
1309 
1310     /**
1311      * @dev See {ERC1155-_burnBatch}.
1312      */
1313     function _burnBatch(
1314         address account,
1315         uint256[] memory ids,
1316         uint256[] memory amounts
1317     ) internal virtual override {
1318         super._burnBatch(account, ids, amounts);
1319         for (uint256 i = 0; i < ids.length; ++i) {
1320             _totalSupply[ids[i]] -= amounts[i];
1321         }
1322     }
1323 }
1324 
1325 // Part: ProvablyRareGem
1326 
1327 /// @title Provably Rare Gems
1328 /// @author Sorawit Suriyakarn (swit.eth / https://twitter.com/nomorebear)
1329 contract ProvablyRareGem is ERC1155Supply, ReentrancyGuard {
1330   event Create(uint indexed kind);
1331   event Mine(address indexed miner, uint indexed kind);
1332 
1333   struct Gem {
1334     string name; // Gem name
1335     string color; // Gem color
1336     bytes32 entropy; // Additional mining entropy. bytes32(0) means can't mine.
1337     uint difficulty; // Current difficulity level. Must be non decreasing
1338     uint gemsPerMine; // Amount of gems to distribute per mine
1339     uint multiplier; // Difficulty multiplier times 1e4. Must be between 1e4 and 1e10
1340     address crafter; // Address that can craft gems
1341     address manager; // Current gem manager
1342     address pendingManager; // Pending gem manager to be transferred to
1343   }
1344 
1345   mapping(uint => Gem) public gems;
1346   mapping(address => uint) public nonce;
1347   uint public gemCount;
1348 
1349   constructor() ERC1155('GEM') {}
1350 
1351   /// @dev Creates a new gem type. The manager can craft a portion of gems + can premine
1352   function create(
1353     string calldata name,
1354     string calldata color,
1355     uint difficulty,
1356     uint gemsPerMine,
1357     uint multiplier,
1358     address crafter,
1359     address manager
1360   ) external returns (uint) {
1361     require(difficulty > 0 && difficulty <= 2**128, 'bad difficulty');
1362     require(gemsPerMine > 0 && gemsPerMine <= 1e6, 'bad gems per mine');
1363     require(multiplier >= 1e4 && multiplier <= 1e10, 'bad multiplier');
1364     require(manager != address(0), 'bad manager');
1365     return _create(name, color, difficulty, gemsPerMine, multiplier, crafter, manager);
1366   }
1367 
1368   /// @dev Mines new gemstones. Puts kind you want to mine + your salt and tests your luck!
1369   function mine(uint kind, uint salt) external nonReentrant {
1370     uint val = luck(kind, salt);
1371     nonce[msg.sender]++;
1372     require(kind < gemCount, 'gem kind not exist');
1373     uint diff = gems[kind].difficulty;
1374     require(val <= type(uint).max / diff, 'salt not good enough');
1375     gems[kind].difficulty = (diff * gems[kind].multiplier) / 10000 + 1;
1376     _mint(msg.sender, kind, gems[kind].gemsPerMine, '');
1377   }
1378 
1379   /// @dev Updates gem mining entropy. Can be called by gem manager or crafter.
1380   function updateEntropy(uint kind, bytes32 entropy) external {
1381     require(kind < gemCount, 'gem kind not exist');
1382     require(gems[kind].manager == msg.sender || gems[kind].crafter == msg.sender, 'unauthorized');
1383     gems[kind].entropy = entropy;
1384   }
1385 
1386   /// @dev Updates gem metadata info. Must only be called by the gem manager.
1387   function updateGemInfo(
1388     uint kind,
1389     string calldata name,
1390     string calldata color
1391   ) external {
1392     require(kind < gemCount, 'gem kind not exist');
1393     require(gems[kind].manager == msg.sender, 'not gem manager');
1394     gems[kind].name = name;
1395     gems[kind].color = color;
1396   }
1397 
1398   /// @dev Updates gem mining information. Must only be called by the gem manager.
1399   function updateMiningData(
1400     uint kind,
1401     uint difficulty,
1402     uint multiplier,
1403     uint gemsPerMine
1404   ) external {
1405     require(kind < gemCount, 'gem kind not exist');
1406     require(gems[kind].manager == msg.sender, 'not gem manager');
1407     require(difficulty > 0 && difficulty <= 2**128, 'bad difficulty');
1408     require(multiplier >= 1e4 && multiplier <= 1e10, 'bad multiplier');
1409     require(gemsPerMine > 0 && gemsPerMine <= 1e6, 'bad gems per mine');
1410     gems[kind].difficulty = difficulty;
1411     gems[kind].multiplier = multiplier;
1412     gems[kind].gemsPerMine = gemsPerMine;
1413   }
1414 
1415   /// @dev Renounce management ownership for the given gem kinds.
1416   function renounceManager(uint[] calldata kinds) external {
1417     for (uint idx = 0; idx < kinds.length; idx++) {
1418       uint kind = kinds[idx];
1419       require(kind < gemCount, 'gem kind not exist');
1420       require(gems[kind].manager == msg.sender, 'not gem manager');
1421       gems[kind].manager = address(0);
1422       gems[kind].pendingManager = address(0);
1423     }
1424   }
1425 
1426   /// @dev Updates gem crafter. Must only be called by the gem manager.
1427   function updateCrafter(uint[] calldata kinds, address crafter) external {
1428     for (uint idx = 0; idx < kinds.length; idx++) {
1429       uint kind = kinds[idx];
1430       require(kind < gemCount, 'gem kind not exist');
1431       require(gems[kind].manager == msg.sender, 'not gem manager');
1432       gems[kind].crafter = crafter;
1433     }
1434   }
1435 
1436   /// @dev Transfers management ownership for the given gem kinds to another address.
1437   function transferManager(uint[] calldata kinds, address to) external {
1438     for (uint idx = 0; idx < kinds.length; idx++) {
1439       uint kind = kinds[idx];
1440       require(kind < gemCount, 'gem kind not exist');
1441       require(gems[kind].manager == msg.sender, 'not gem manager');
1442       gems[kind].pendingManager = to;
1443     }
1444   }
1445 
1446   /// @dev Accepts management position for the given gem kinds.
1447   function acceptManager(uint[] calldata kinds) external {
1448     for (uint idx = 0; idx < kinds.length; idx++) {
1449       uint kind = kinds[idx];
1450       require(kind < gemCount, 'gem kind not exist');
1451       require(gems[kind].pendingManager == msg.sender, 'not pending manager');
1452       gems[kind].pendingManager = address(0);
1453       gems[kind].manager = msg.sender;
1454     }
1455   }
1456 
1457   /// @dev Mints gems by crafter. Hopefully, crafter is a good guy. Craft gemsPerMine if amount = 0.
1458   function craft(
1459     uint kind,
1460     uint amount,
1461     address to
1462   ) external nonReentrant {
1463     require(kind < gemCount, 'gem kind not exist');
1464     require(gems[kind].crafter == msg.sender, 'not gem crafter');
1465     uint realAmount = amount == 0 ? gems[kind].gemsPerMine : amount;
1466     _mint(to, kind, realAmount, '');
1467   }
1468 
1469   /// @dev Returns your luck given salt and gem kind. The smaller the value, the more success chance.
1470   function luck(uint kind, uint salt) public view returns (uint) {
1471     require(kind < gemCount, 'gem kind not exist');
1472     bytes32 entropy = gems[kind].entropy;
1473     require(entropy != bytes32(0), 'no entropy');
1474     bytes memory data = abi.encodePacked(
1475       block.chainid,
1476       entropy,
1477       address(this),
1478       msg.sender,
1479       kind,
1480       nonce[msg.sender],
1481       salt
1482     );
1483     return uint(keccak256(data));
1484   }
1485 
1486   /// @dev Internal function for creating a new gem kind
1487   function _create(
1488     string memory name,
1489     string memory color,
1490     uint difficulty,
1491     uint gemsPerMine,
1492     uint multiplier,
1493     address crafter,
1494     address manager
1495   ) internal returns (uint) {
1496     uint kind = gemCount++;
1497     gems[kind] = Gem({
1498       name: name,
1499       color: color,
1500       entropy: bytes32(0),
1501       difficulty: difficulty,
1502       gemsPerMine: gemsPerMine,
1503       multiplier: multiplier,
1504       crafter: crafter,
1505       manager: manager,
1506       pendingManager: address(0)
1507     });
1508     emit Create(kind);
1509     return kind;
1510   }
1511 
1512   // prettier-ignore
1513   function uri(uint kind) public view override returns (string memory) {
1514     require(kind < gemCount, 'gem kind not exist');
1515     string memory output = string(abi.encodePacked(
1516         '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: ',
1517         gems[kind].color,
1518         '; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="white" /><text x="10" y="20" class="base">',
1519         gems[kind].name,
1520         '</text><text x="10" y="40" class="base">',
1521         '</text></svg>'
1522     ));
1523     string memory json = Base64.encode(bytes(string(abi.encodePacked(
1524       '{ "name": "',
1525       gems[kind].name,
1526       '", ',
1527       '"description" : ',
1528       '"Provably Rare Gems", ',
1529       '"image": "data:image/svg+xml;base64,',
1530       Base64.encode(bytes(output)),
1531       '}'
1532     ))));
1533     return string(abi.encodePacked('data:application/json;base64,', json));
1534   }
1535 }
1536 
1537 // File: BLOOTGemCrafter.sol
1538 
1539 /// @title BLOOT GEM Crafter
1540 /// @author Sorawit Suriyakarn (swit.eth / https://twitter.com/nomorebear)
1541 contract BLOOTGemCrafter is Ownable, ReentrancyGuard {
1542   IERC721 public immutable NFT;
1543   ProvablyRareGem public immutable GEM;
1544   uint public immutable FIRST_KIND;
1545 
1546   event Start(bytes32 hashseed);
1547   event Craft(uint indexed kind, uint amount);
1548   event Claim(uint indexed id, address indexed claimer);
1549 
1550   bytes32 public hashseed;
1551   mapping(uint => uint) public crafted;
1552   mapping(uint => bool) public claimed;
1553 
1554   // prettier-ignore
1555   constructor(IERC721 _nft, ProvablyRareGem _gem) {
1556     NFT = _nft;
1557     GEM = _gem;
1558     FIRST_KIND = _gem.gemCount();
1559     _gem.create('Violet Useless Rock of ALPHA', '#9966CC', 8**2, 64, 10000, address(this), msg.sender);
1560     _gem.create('Goldy Pebble of LOOKS RARE', '#FFC87C', 8**3, 32, 10001, address(this), msg.sender);
1561     _gem.create('Translucent River Rock of HODL', '#A8C3BC', 8**4, 16, 10005, address(this), msg.sender);
1562     _gem.create('Blue Ice Scrap of UP ONLY', '#0F52BA', 8**5, 8, 10010, address(this), msg.sender);
1563     _gem.create('Blushing Rock of PROBABLY NOTHING', '#E0115F', 8**6, 4, 10030, address(this), msg.sender);
1564     _gem.create('Mossy Riverside Pebble of LFG', '#50C878', 8**7, 2, 10100, address(this), msg.sender);
1565     _gem.create('The Lovely Rock of GOAT', '#FC74E4', 8**8, 1, 10300, address(this), msg.sender);
1566     _gem.create('#00FF00 of OG', '#00FF00', 8**9, 1, 11000, address(this), msg.sender);
1567     _gem.create('#0000FF of WAGMI', '#0000FF', 8**10, 1, 20000, address(this), msg.sender);
1568     _gem.create('#FF0000 of THE MOON', '#FF0000', 8**11, 1, 50000, address(this), msg.sender);
1569   }
1570 
1571   /// @dev Called once to start the claim and generate hash seed.
1572   function start() external onlyOwner {
1573     require(hashseed == bytes32(0), 'already started');
1574     hashseed = blockhash(block.number - 1);
1575     for (uint offset = 0; offset < 10; offset++) {
1576       GEM.updateEntropy(FIRST_KIND + offset, hashseed);
1577     }
1578   }
1579 
1580   /// @dev Called by gem manager to craft gems. Can't craft more than 10% of supply.
1581   function craft(uint kind, uint amount) external nonReentrant onlyOwner {
1582     require(amount != 0, 'zero amount craft');
1583     crafted[kind] += amount;
1584     GEM.craft(kind, amount, msg.sender);
1585     emit Craft(kind, amount);
1586     require(crafted[kind] <= GEM.totalSupply(kind) / 10, 'too many crafts');
1587   }
1588 
1589   /// @dev Returns the list of initial GEM distribution for the given NFT ID.
1590   function airdrop(uint id) public view returns (uint[4] memory kinds) {
1591     require(hashseed != bytes32(0), 'not yet started');
1592     uint[10] memory chances = [uint(1), 1, 3, 6, 10, 20, 30, 100, 300, 1000];
1593     uint count = 0;
1594     for (uint idx = 0; idx < 4; idx++) {
1595       kinds[idx] = FIRST_KIND;
1596     }
1597     for (uint offset = 9; offset > 0; offset--) {
1598       uint seed = uint(keccak256(abi.encodePacked(hashseed, offset, id)));
1599       if (seed % chances[offset] == 0) {
1600         kinds[count++] = FIRST_KIND + offset;
1601       }
1602       if (count == 4) break;
1603     }
1604   }
1605 
1606   /// @dev Called by NFT owners to get a welcome pack of gems. Each NFT ID can claim once.
1607   function claim(uint id) external nonReentrant {
1608     _claim(id);
1609   }
1610 
1611   /// @dev Called by NFT owners to get a welcome pack of gems for multiple NFTs.
1612   function multiClaim(uint[] calldata ids) external nonReentrant {
1613     for (uint idx = 0; idx < ids.length; idx++) {
1614       _claim(ids[idx]);
1615     }
1616   }
1617 
1618   function _claim(uint id) internal {
1619     require(msg.sender == NFT.ownerOf(id), 'not nft owner');
1620     require(!claimed[id], 'already claimed');
1621     claimed[id] = true;
1622     uint[4] memory kinds = airdrop(id);
1623     for (uint idx = 0; idx < 4; idx++) {
1624       GEM.craft(kinds[idx], 0, msg.sender);
1625     }
1626     emit Claim(id, msg.sender);
1627   }
1628 }