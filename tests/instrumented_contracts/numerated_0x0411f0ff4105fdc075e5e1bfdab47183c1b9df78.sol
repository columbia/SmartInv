1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
176 
177 
178 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 
183 /**
184  * @dev Implementation of the {IERC165} interface.
185  *
186  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
187  * for the additional interface id that will be supported. For example:
188  *
189  * ```solidity
190  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
191  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
192  * }
193  * ```
194  *
195  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
196  */
197 abstract contract ERC165 is IERC165 {
198     /**
199      * @dev See {IERC165-supportsInterface}.
200      */
201     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
202         return interfaceId == type(IERC165).interfaceId;
203     }
204 }
205 
206 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
207 
208 
209 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
210 
211 pragma solidity ^0.8.0;
212 
213 
214 /**
215  * @dev _Available since v3.1._
216  */
217 interface IERC1155Receiver is IERC165 {
218     /**
219         @dev Handles the receipt of a single ERC1155 token type. This function is
220         called at the end of a `safeTransferFrom` after the balance has been updated.
221         To accept the transfer, this must return
222         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
223         (i.e. 0xf23a6e61, or its own function selector).
224         @param operator The address which initiated the transfer (i.e. msg.sender)
225         @param from The address which previously owned the token
226         @param id The ID of the token being transferred
227         @param value The amount of tokens being transferred
228         @param data Additional data with no specified format
229         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
230     */
231     function onERC1155Received(
232         address operator,
233         address from,
234         uint256 id,
235         uint256 value,
236         bytes calldata data
237     ) external returns (bytes4);
238 
239     /**
240         @dev Handles the receipt of a multiple ERC1155 token types. This function
241         is called at the end of a `safeBatchTransferFrom` after the balances have
242         been updated. To accept the transfer(s), this must return
243         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
244         (i.e. 0xbc197c81, or its own function selector).
245         @param operator The address which initiated the batch transfer (i.e. msg.sender)
246         @param from The address which previously owned the token
247         @param ids An array containing ids of each token being transferred (order and length must match values array)
248         @param values An array containing amounts of each token being transferred (order and length must match ids array)
249         @param data Additional data with no specified format
250         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
251     */
252     function onERC1155BatchReceived(
253         address operator,
254         address from,
255         uint256[] calldata ids,
256         uint256[] calldata values,
257         bytes calldata data
258     ) external returns (bytes4);
259 }
260 
261 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
262 
263 
264 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 
269 /**
270  * @dev Required interface of an ERC1155 compliant contract, as defined in the
271  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
272  *
273  * _Available since v3.1._
274  */
275 interface IERC1155 is IERC165 {
276     /**
277      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
278      */
279     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
280 
281     /**
282      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
283      * transfers.
284      */
285     event TransferBatch(
286         address indexed operator,
287         address indexed from,
288         address indexed to,
289         uint256[] ids,
290         uint256[] values
291     );
292 
293     /**
294      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
295      * `approved`.
296      */
297     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
298 
299     /**
300      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
301      *
302      * If an {URI} event was emitted for `id`, the standard
303      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
304      * returned by {IERC1155MetadataURI-uri}.
305      */
306     event URI(string value, uint256 indexed id);
307 
308     /**
309      * @dev Returns the amount of tokens of token type `id` owned by `account`.
310      *
311      * Requirements:
312      *
313      * - `account` cannot be the zero address.
314      */
315     function balanceOf(address account, uint256 id) external view returns (uint256);
316 
317     /**
318      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
319      *
320      * Requirements:
321      *
322      * - `accounts` and `ids` must have the same length.
323      */
324     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
325         external
326         view
327         returns (uint256[] memory);
328 
329     /**
330      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
331      *
332      * Emits an {ApprovalForAll} event.
333      *
334      * Requirements:
335      *
336      * - `operator` cannot be the caller.
337      */
338     function setApprovalForAll(address operator, bool approved) external;
339 
340     /**
341      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
342      *
343      * See {setApprovalForAll}.
344      */
345     function isApprovedForAll(address account, address operator) external view returns (bool);
346 
347     /**
348      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
349      *
350      * Emits a {TransferSingle} event.
351      *
352      * Requirements:
353      *
354      * - `to` cannot be the zero address.
355      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
356      * - `from` must have a balance of tokens of type `id` of at least `amount`.
357      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
358      * acceptance magic value.
359      */
360     function safeTransferFrom(
361         address from,
362         address to,
363         uint256 id,
364         uint256 amount,
365         bytes calldata data
366     ) external;
367 
368     /**
369      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
370      *
371      * Emits a {TransferBatch} event.
372      *
373      * Requirements:
374      *
375      * - `ids` and `amounts` must have the same length.
376      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
377      * acceptance magic value.
378      */
379     function safeBatchTransferFrom(
380         address from,
381         address to,
382         uint256[] calldata ids,
383         uint256[] calldata amounts,
384         bytes calldata data
385     ) external;
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
389 
390 
391 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 
396 /**
397  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
398  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
399  *
400  * _Available since v3.1._
401  */
402 interface IERC1155MetadataURI is IERC1155 {
403     /**
404      * @dev Returns the URI for token type `id`.
405      *
406      * If the `\{id\}` substring is present in the URI, it must be replaced by
407      * clients with the actual token type ID.
408      */
409     function uri(uint256 id) external view returns (string memory);
410 }
411 
412 // File: @openzeppelin/contracts/utils/Context.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 /**
420  * @dev Provides information about the current execution context, including the
421  * sender of the transaction and its data. While these are generally available
422  * via msg.sender and msg.data, they should not be accessed in such a direct
423  * manner, since when dealing with meta-transactions the account sending and
424  * paying for execution may not be the actual sender (as far as an application
425  * is concerned).
426  *
427  * This contract is only required for intermediate, library-like contracts.
428  */
429 abstract contract Context {
430     function _msgSender() internal view virtual returns (address) {
431         return msg.sender;
432     }
433 
434     function _msgData() internal view virtual returns (bytes calldata) {
435         return msg.data;
436     }
437 }
438 
439 // File: @openzeppelin/contracts/access/Ownable.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 
447 /**
448  * @dev Contract module which provides a basic access control mechanism, where
449  * there is an account (an owner) that can be granted exclusive access to
450  * specific functions.
451  *
452  * By default, the owner account will be the one that deploys the contract. This
453  * can later be changed with {transferOwnership}.
454  *
455  * This module is used through inheritance. It will make available the modifier
456  * `onlyOwner`, which can be applied to your functions to restrict their use to
457  * the owner.
458  */
459 abstract contract Ownable is Context {
460     address private _owner;
461 
462     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
463 
464     /**
465      * @dev Initializes the contract setting the deployer as the initial owner.
466      */
467     constructor() {
468         _transferOwnership(_msgSender());
469     }
470 
471     /**
472      * @dev Returns the address of the current owner.
473      */
474     function owner() public view virtual returns (address) {
475         return _owner;
476     }
477 
478     /**
479      * @dev Throws if called by any account other than the owner.
480      */
481     modifier onlyOwner() {
482         require(owner() == _msgSender(), "Ownable: caller is not the owner");
483         _;
484     }
485 
486     /**
487      * @dev Leaves the contract without owner. It will not be possible to call
488      * `onlyOwner` functions anymore. Can only be called by the current owner.
489      *
490      * NOTE: Renouncing ownership will leave the contract without an owner,
491      * thereby removing any functionality that is only available to the owner.
492      */
493     function renounceOwnership() public virtual onlyOwner {
494         _transferOwnership(address(0));
495     }
496 
497     /**
498      * @dev Transfers ownership of the contract to a new account (`newOwner`).
499      * Can only be called by the current owner.
500      */
501     function transferOwnership(address newOwner) public virtual onlyOwner {
502         require(newOwner != address(0), "Ownable: new owner is the zero address");
503         _transferOwnership(newOwner);
504     }
505 
506     /**
507      * @dev Transfers ownership of the contract to a new account (`newOwner`).
508      * Internal function without access restriction.
509      */
510     function _transferOwnership(address newOwner) internal virtual {
511         address oldOwner = _owner;
512         _owner = newOwner;
513         emit OwnershipTransferred(oldOwner, newOwner);
514     }
515 }
516 
517 // File: @openzeppelin/contracts/utils/Address.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev Collection of functions related to the address type
526  */
527 library Address {
528     /**
529      * @dev Returns true if `account` is a contract.
530      *
531      * [IMPORTANT]
532      * ====
533      * It is unsafe to assume that an address for which this function returns
534      * false is an externally-owned account (EOA) and not a contract.
535      *
536      * Among others, `isContract` will return false for the following
537      * types of addresses:
538      *
539      *  - an externally-owned account
540      *  - a contract in construction
541      *  - an address where a contract will be created
542      *  - an address where a contract lived, but was destroyed
543      * ====
544      */
545     function isContract(address account) internal view returns (bool) {
546         // This method relies on extcodesize, which returns 0 for contracts in
547         // construction, since the code is only stored at the end of the
548         // constructor execution.
549 
550         uint256 size;
551         assembly {
552             size := extcodesize(account)
553         }
554         return size > 0;
555     }
556 
557     /**
558      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
559      * `recipient`, forwarding all available gas and reverting on errors.
560      *
561      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
562      * of certain opcodes, possibly making contracts go over the 2300 gas limit
563      * imposed by `transfer`, making them unable to receive funds via
564      * `transfer`. {sendValue} removes this limitation.
565      *
566      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
567      *
568      * IMPORTANT: because control is transferred to `recipient`, care must be
569      * taken to not create reentrancy vulnerabilities. Consider using
570      * {ReentrancyGuard} or the
571      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
572      */
573     function sendValue(address payable recipient, uint256 amount) internal {
574         require(address(this).balance >= amount, "Address: insufficient balance");
575 
576         (bool success, ) = recipient.call{value: amount}("");
577         require(success, "Address: unable to send value, recipient may have reverted");
578     }
579 
580     /**
581      * @dev Performs a Solidity function call using a low level `call`. A
582      * plain `call` is an unsafe replacement for a function call: use this
583      * function instead.
584      *
585      * If `target` reverts with a revert reason, it is bubbled up by this
586      * function (like regular Solidity function calls).
587      *
588      * Returns the raw returned data. To convert to the expected return value,
589      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
590      *
591      * Requirements:
592      *
593      * - `target` must be a contract.
594      * - calling `target` with `data` must not revert.
595      *
596      * _Available since v3.1._
597      */
598     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
599         return functionCall(target, data, "Address: low-level call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
604      * `errorMessage` as a fallback revert reason when `target` reverts.
605      *
606      * _Available since v3.1._
607      */
608     function functionCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal returns (bytes memory) {
613         return functionCallWithValue(target, data, 0, errorMessage);
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
618      * but also transferring `value` wei to `target`.
619      *
620      * Requirements:
621      *
622      * - the calling contract must have an ETH balance of at least `value`.
623      * - the called Solidity function must be `payable`.
624      *
625      * _Available since v3.1._
626      */
627     function functionCallWithValue(
628         address target,
629         bytes memory data,
630         uint256 value
631     ) internal returns (bytes memory) {
632         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
637      * with `errorMessage` as a fallback revert reason when `target` reverts.
638      *
639      * _Available since v3.1._
640      */
641     function functionCallWithValue(
642         address target,
643         bytes memory data,
644         uint256 value,
645         string memory errorMessage
646     ) internal returns (bytes memory) {
647         require(address(this).balance >= value, "Address: insufficient balance for call");
648         require(isContract(target), "Address: call to non-contract");
649 
650         (bool success, bytes memory returndata) = target.call{value: value}(data);
651         return verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
656      * but performing a static call.
657      *
658      * _Available since v3.3._
659      */
660     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
661         return functionStaticCall(target, data, "Address: low-level static call failed");
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
666      * but performing a static call.
667      *
668      * _Available since v3.3._
669      */
670     function functionStaticCall(
671         address target,
672         bytes memory data,
673         string memory errorMessage
674     ) internal view returns (bytes memory) {
675         require(isContract(target), "Address: static call to non-contract");
676 
677         (bool success, bytes memory returndata) = target.staticcall(data);
678         return verifyCallResult(success, returndata, errorMessage);
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
683      * but performing a delegate call.
684      *
685      * _Available since v3.4._
686      */
687     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
688         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
693      * but performing a delegate call.
694      *
695      * _Available since v3.4._
696      */
697     function functionDelegateCall(
698         address target,
699         bytes memory data,
700         string memory errorMessage
701     ) internal returns (bytes memory) {
702         require(isContract(target), "Address: delegate call to non-contract");
703 
704         (bool success, bytes memory returndata) = target.delegatecall(data);
705         return verifyCallResult(success, returndata, errorMessage);
706     }
707 
708     /**
709      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
710      * revert reason using the provided one.
711      *
712      * _Available since v4.3._
713      */
714     function verifyCallResult(
715         bool success,
716         bytes memory returndata,
717         string memory errorMessage
718     ) internal pure returns (bytes memory) {
719         if (success) {
720             return returndata;
721         } else {
722             // Look for revert reason and bubble it up if present
723             if (returndata.length > 0) {
724                 // The easiest way to bubble the revert reason is using memory via assembly
725 
726                 assembly {
727                     let returndata_size := mload(returndata)
728                     revert(add(32, returndata), returndata_size)
729                 }
730             } else {
731                 revert(errorMessage);
732             }
733         }
734     }
735 }
736 
737 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 
746 
747 
748 
749 
750 /**
751  * @dev Implementation of the basic standard multi-token.
752  * See https://eips.ethereum.org/EIPS/eip-1155
753  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
754  *
755  * _Available since v3.1._
756  */
757 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
758     using Address for address;
759 
760     // Mapping from token ID to account balances
761     mapping(uint256 => mapping(address => uint256)) private _balances;
762 
763     // Mapping from account to operator approvals
764     mapping(address => mapping(address => bool)) private _operatorApprovals;
765 
766     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
767     string private _uri;
768 
769     /**
770      * @dev See {_setURI}.
771      */
772     constructor(string memory uri_) {
773         _setURI(uri_);
774     }
775 
776     /**
777      * @dev See {IERC165-supportsInterface}.
778      */
779     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
780         return
781             interfaceId == type(IERC1155).interfaceId ||
782             interfaceId == type(IERC1155MetadataURI).interfaceId ||
783             super.supportsInterface(interfaceId);
784     }
785 
786     /**
787      * @dev See {IERC1155MetadataURI-uri}.
788      *
789      * This implementation returns the same URI for *all* token types. It relies
790      * on the token type ID substitution mechanism
791      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
792      *
793      * Clients calling this function must replace the `\{id\}` substring with the
794      * actual token type ID.
795      */
796     function uri(uint256) public view virtual override returns (string memory) {
797         return _uri;
798     }
799 
800     /**
801      * @dev See {IERC1155-balanceOf}.
802      *
803      * Requirements:
804      *
805      * - `account` cannot be the zero address.
806      */
807     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
808         require(account != address(0), "ERC1155: balance query for the zero address");
809         return _balances[id][account];
810     }
811 
812     /**
813      * @dev See {IERC1155-balanceOfBatch}.
814      *
815      * Requirements:
816      *
817      * - `accounts` and `ids` must have the same length.
818      */
819     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
820         public
821         view
822         virtual
823         override
824         returns (uint256[] memory)
825     {
826         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
827 
828         uint256[] memory batchBalances = new uint256[](accounts.length);
829 
830         for (uint256 i = 0; i < accounts.length; ++i) {
831             batchBalances[i] = balanceOf(accounts[i], ids[i]);
832         }
833 
834         return batchBalances;
835     }
836 
837     /**
838      * @dev See {IERC1155-setApprovalForAll}.
839      */
840     function setApprovalForAll(address operator, bool approved) public virtual override {
841         _setApprovalForAll(_msgSender(), operator, approved);
842     }
843 
844     /**
845      * @dev See {IERC1155-isApprovedForAll}.
846      */
847     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
848         return _operatorApprovals[account][operator];
849     }
850 
851     /**
852      * @dev See {IERC1155-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 id,
858         uint256 amount,
859         bytes memory data
860     ) public virtual override {
861         require(
862             from == _msgSender() || isApprovedForAll(from, _msgSender()),
863             "ERC1155: caller is not owner nor approved"
864         );
865         _safeTransferFrom(from, to, id, amount, data);
866     }
867 
868     /**
869      * @dev See {IERC1155-safeBatchTransferFrom}.
870      */
871     function safeBatchTransferFrom(
872         address from,
873         address to,
874         uint256[] memory ids,
875         uint256[] memory amounts,
876         bytes memory data
877     ) public virtual override {
878         require(
879             from == _msgSender() || isApprovedForAll(from, _msgSender()),
880             "ERC1155: transfer caller is not owner nor approved"
881         );
882         _safeBatchTransferFrom(from, to, ids, amounts, data);
883     }
884 
885     /**
886      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
887      *
888      * Emits a {TransferSingle} event.
889      *
890      * Requirements:
891      *
892      * - `to` cannot be the zero address.
893      * - `from` must have a balance of tokens of type `id` of at least `amount`.
894      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
895      * acceptance magic value.
896      */
897     function _safeTransferFrom(
898         address from,
899         address to,
900         uint256 id,
901         uint256 amount,
902         bytes memory data
903     ) internal virtual {
904         require(to != address(0), "ERC1155: transfer to the zero address");
905 
906         address operator = _msgSender();
907 
908         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
909 
910         uint256 fromBalance = _balances[id][from];
911         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
912         unchecked {
913             _balances[id][from] = fromBalance - amount;
914         }
915         _balances[id][to] += amount;
916 
917         emit TransferSingle(operator, from, to, id, amount);
918 
919         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
920     }
921 
922     /**
923      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
924      *
925      * Emits a {TransferBatch} event.
926      *
927      * Requirements:
928      *
929      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
930      * acceptance magic value.
931      */
932     function _safeBatchTransferFrom(
933         address from,
934         address to,
935         uint256[] memory ids,
936         uint256[] memory amounts,
937         bytes memory data
938     ) internal virtual {
939         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
940         require(to != address(0), "ERC1155: transfer to the zero address");
941 
942         address operator = _msgSender();
943 
944         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
945 
946         for (uint256 i = 0; i < ids.length; ++i) {
947             uint256 id = ids[i];
948             uint256 amount = amounts[i];
949 
950             uint256 fromBalance = _balances[id][from];
951             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
952             unchecked {
953                 _balances[id][from] = fromBalance - amount;
954             }
955             _balances[id][to] += amount;
956         }
957 
958         emit TransferBatch(operator, from, to, ids, amounts);
959 
960         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
961     }
962 
963     /**
964      * @dev Sets a new URI for all token types, by relying on the token type ID
965      * substitution mechanism
966      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
967      *
968      * By this mechanism, any occurrence of the `\{id\}` substring in either the
969      * URI or any of the amounts in the JSON file at said URI will be replaced by
970      * clients with the token type ID.
971      *
972      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
973      * interpreted by clients as
974      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
975      * for token type ID 0x4cce0.
976      *
977      * See {uri}.
978      *
979      * Because these URIs cannot be meaningfully represented by the {URI} event,
980      * this function emits no events.
981      */
982     function _setURI(string memory newuri) internal virtual {
983         _uri = newuri;
984     }
985 
986     /**
987      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
988      *
989      * Emits a {TransferSingle} event.
990      *
991      * Requirements:
992      *
993      * - `to` cannot be the zero address.
994      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
995      * acceptance magic value.
996      */
997     function _mint(
998         address to,
999         uint256 id,
1000         uint256 amount,
1001         bytes memory data
1002     ) internal virtual {
1003         require(to != address(0), "ERC1155: mint to the zero address");
1004 
1005         address operator = _msgSender();
1006 
1007         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1008 
1009         _balances[id][to] += amount;
1010         emit TransferSingle(operator, address(0), to, id, amount);
1011 
1012         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1013     }
1014 
1015     /**
1016      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1017      *
1018      * Requirements:
1019      *
1020      * - `ids` and `amounts` must have the same length.
1021      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1022      * acceptance magic value.
1023      */
1024     function _mintBatch(
1025         address to,
1026         uint256[] memory ids,
1027         uint256[] memory amounts,
1028         bytes memory data
1029     ) internal virtual {
1030         require(to != address(0), "ERC1155: mint to the zero address");
1031         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1032 
1033         address operator = _msgSender();
1034 
1035         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1036 
1037         for (uint256 i = 0; i < ids.length; i++) {
1038             _balances[ids[i]][to] += amounts[i];
1039         }
1040 
1041         emit TransferBatch(operator, address(0), to, ids, amounts);
1042 
1043         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1044     }
1045 
1046     /**
1047      * @dev Destroys `amount` tokens of token type `id` from `from`
1048      *
1049      * Requirements:
1050      *
1051      * - `from` cannot be the zero address.
1052      * - `from` must have at least `amount` tokens of token type `id`.
1053      */
1054     function _burn(
1055         address from,
1056         uint256 id,
1057         uint256 amount
1058     ) internal virtual {
1059         require(from != address(0), "ERC1155: burn from the zero address");
1060 
1061         address operator = _msgSender();
1062 
1063         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1064 
1065         uint256 fromBalance = _balances[id][from];
1066         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1067         unchecked {
1068             _balances[id][from] = fromBalance - amount;
1069         }
1070 
1071         emit TransferSingle(operator, from, address(0), id, amount);
1072     }
1073 
1074     /**
1075      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1076      *
1077      * Requirements:
1078      *
1079      * - `ids` and `amounts` must have the same length.
1080      */
1081     function _burnBatch(
1082         address from,
1083         uint256[] memory ids,
1084         uint256[] memory amounts
1085     ) internal virtual {
1086         require(from != address(0), "ERC1155: burn from the zero address");
1087         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1088 
1089         address operator = _msgSender();
1090 
1091         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1092 
1093         for (uint256 i = 0; i < ids.length; i++) {
1094             uint256 id = ids[i];
1095             uint256 amount = amounts[i];
1096 
1097             uint256 fromBalance = _balances[id][from];
1098             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1099             unchecked {
1100                 _balances[id][from] = fromBalance - amount;
1101             }
1102         }
1103 
1104         emit TransferBatch(operator, from, address(0), ids, amounts);
1105     }
1106 
1107     /**
1108      * @dev Approve `operator` to operate on all of `owner` tokens
1109      *
1110      * Emits a {ApprovalForAll} event.
1111      */
1112     function _setApprovalForAll(
1113         address owner,
1114         address operator,
1115         bool approved
1116     ) internal virtual {
1117         require(owner != operator, "ERC1155: setting approval status for self");
1118         _operatorApprovals[owner][operator] = approved;
1119         emit ApprovalForAll(owner, operator, approved);
1120     }
1121 
1122     /**
1123      * @dev Hook that is called before any token transfer. This includes minting
1124      * and burning, as well as batched variants.
1125      *
1126      * The same hook is called on both single and batched variants. For single
1127      * transfers, the length of the `id` and `amount` arrays will be 1.
1128      *
1129      * Calling conditions (for each `id` and `amount` pair):
1130      *
1131      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1132      * of token type `id` will be  transferred to `to`.
1133      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1134      * for `to`.
1135      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1136      * will be burned.
1137      * - `from` and `to` are never both zero.
1138      * - `ids` and `amounts` have the same, non-zero length.
1139      *
1140      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1141      */
1142     function _beforeTokenTransfer(
1143         address operator,
1144         address from,
1145         address to,
1146         uint256[] memory ids,
1147         uint256[] memory amounts,
1148         bytes memory data
1149     ) internal virtual {}
1150 
1151     function _doSafeTransferAcceptanceCheck(
1152         address operator,
1153         address from,
1154         address to,
1155         uint256 id,
1156         uint256 amount,
1157         bytes memory data
1158     ) private {
1159         if (to.isContract()) {
1160             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1161                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1162                     revert("ERC1155: ERC1155Receiver rejected tokens");
1163                 }
1164             } catch Error(string memory reason) {
1165                 revert(reason);
1166             } catch {
1167                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1168             }
1169         }
1170     }
1171 
1172     function _doSafeBatchTransferAcceptanceCheck(
1173         address operator,
1174         address from,
1175         address to,
1176         uint256[] memory ids,
1177         uint256[] memory amounts,
1178         bytes memory data
1179     ) private {
1180         if (to.isContract()) {
1181             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1182                 bytes4 response
1183             ) {
1184                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1185                     revert("ERC1155: ERC1155Receiver rejected tokens");
1186                 }
1187             } catch Error(string memory reason) {
1188                 revert(reason);
1189             } catch {
1190                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1191             }
1192         }
1193     }
1194 
1195     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1196         uint256[] memory array = new uint256[](1);
1197         array[0] = element;
1198 
1199         return array;
1200     }
1201 }
1202 
1203 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1204 
1205 
1206 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 /**
1211  * @dev Interface of the ERC20 standard as defined in the EIP.
1212  */
1213 interface IERC20 {
1214     /**
1215      * @dev Returns the amount of tokens in existence.
1216      */
1217     function totalSupply() external view returns (uint256);
1218 
1219     /**
1220      * @dev Returns the amount of tokens owned by `account`.
1221      */
1222     function balanceOf(address account) external view returns (uint256);
1223 
1224     /**
1225      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1226      *
1227      * Returns a boolean value indicating whether the operation succeeded.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function transfer(address recipient, uint256 amount) external returns (bool);
1232 
1233     /**
1234      * @dev Returns the remaining number of tokens that `spender` will be
1235      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1236      * zero by default.
1237      *
1238      * This value changes when {approve} or {transferFrom} are called.
1239      */
1240     function allowance(address owner, address spender) external view returns (uint256);
1241 
1242     /**
1243      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1244      *
1245      * Returns a boolean value indicating whether the operation succeeded.
1246      *
1247      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1248      * that someone may use both the old and the new allowance by unfortunate
1249      * transaction ordering. One possible solution to mitigate this race
1250      * condition is to first reduce the spender's allowance to 0 and set the
1251      * desired value afterwards:
1252      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1253      *
1254      * Emits an {Approval} event.
1255      */
1256     function approve(address spender, uint256 amount) external returns (bool);
1257 
1258     /**
1259      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1260      * allowance mechanism. `amount` is then deducted from the caller's
1261      * allowance.
1262      *
1263      * Returns a boolean value indicating whether the operation succeeded.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function transferFrom(
1268         address sender,
1269         address recipient,
1270         uint256 amount
1271     ) external returns (bool);
1272 
1273     /**
1274      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1275      * another (`to`).
1276      *
1277      * Note that `value` may be zero.
1278      */
1279     event Transfer(address indexed from, address indexed to, uint256 value);
1280 
1281     /**
1282      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1283      * a call to {approve}. `value` is the new allowance.
1284      */
1285     event Approval(address indexed owner, address indexed spender, uint256 value);
1286 }
1287 
1288 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1289 
1290 
1291 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1292 
1293 pragma solidity ^0.8.0;
1294 
1295 
1296 
1297 /**
1298  * @title SafeERC20
1299  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1300  * contract returns false). Tokens that return no value (and instead revert or
1301  * throw on failure) are also supported, non-reverting calls are assumed to be
1302  * successful.
1303  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1304  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1305  */
1306 library SafeERC20 {
1307     using Address for address;
1308 
1309     function safeTransfer(
1310         IERC20 token,
1311         address to,
1312         uint256 value
1313     ) internal {
1314         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1315     }
1316 
1317     function safeTransferFrom(
1318         IERC20 token,
1319         address from,
1320         address to,
1321         uint256 value
1322     ) internal {
1323         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1324     }
1325 
1326     /**
1327      * @dev Deprecated. This function has issues similar to the ones found in
1328      * {IERC20-approve}, and its usage is discouraged.
1329      *
1330      * Whenever possible, use {safeIncreaseAllowance} and
1331      * {safeDecreaseAllowance} instead.
1332      */
1333     function safeApprove(
1334         IERC20 token,
1335         address spender,
1336         uint256 value
1337     ) internal {
1338         // safeApprove should only be called when setting an initial allowance,
1339         // or when resetting it to zero. To increase and decrease it, use
1340         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1341         require(
1342             (value == 0) || (token.allowance(address(this), spender) == 0),
1343             "SafeERC20: approve from non-zero to non-zero allowance"
1344         );
1345         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1346     }
1347 
1348     function safeIncreaseAllowance(
1349         IERC20 token,
1350         address spender,
1351         uint256 value
1352     ) internal {
1353         uint256 newAllowance = token.allowance(address(this), spender) + value;
1354         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1355     }
1356 
1357     function safeDecreaseAllowance(
1358         IERC20 token,
1359         address spender,
1360         uint256 value
1361     ) internal {
1362         unchecked {
1363             uint256 oldAllowance = token.allowance(address(this), spender);
1364             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1365             uint256 newAllowance = oldAllowance - value;
1366             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1367         }
1368     }
1369 
1370     /**
1371      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1372      * on the return value: the return value is optional (but if data is returned, it must not be false).
1373      * @param token The token targeted by the call.
1374      * @param data The call data (encoded using abi.encode or one of its variants).
1375      */
1376     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1377         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1378         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1379         // the target address contains contract code and also asserts for success in the low-level call.
1380 
1381         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1382         if (returndata.length > 0) {
1383             // Return data is optional
1384             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1385         }
1386     }
1387 }
1388 
1389 // File: contracts/ShiryoCards1155.sol
1390 
1391 
1392 interface IShiryoRandomCards {
1393       function randomCards(uint256 _amount, uint256 _deck) external returns (uint8[] memory);
1394 }
1395 
1396 pragma solidity ^0.8.0;
1397 pragma experimental ABIEncoderV2;
1398 
1399 contract ShiryoCards is Ownable, ERC1155 {
1400     using SafeERC20 for IERC20;
1401     using SafeMath for uint256;
1402 
1403     modifier onlyClevel() {
1404         require(msg.sender == walletA || msg.sender == walletB || msg.sender == owner());
1405     _;
1406     }
1407 
1408     address walletA;
1409     address walletB;
1410     uint256 walletBPercentage = 15;
1411 
1412     uint256 public constant TOTAL_BASE_CARDS = 150;
1413     uint256 public constant TOTAL_FOUNDER_CARDS = 25;
1414 
1415     uint256 public constant MAX_AMOUNT_OPEN = 10;
1416     uint256 public constant MAX_AMOUNT_SWAP = 10;
1417 
1418     uint256 public swapFee = 0.01 ether;
1419 
1420     address public founderPackAddress;
1421     address public normalPackAddress;
1422     uint256 public cardsPerNormalPack = 5;
1423     uint256 public activeDeck = 1;
1424 
1425 
1426     address public nftAddress = address(0x0);
1427 
1428     mapping(address => uint256[]) public lastUnpackedByAddress;
1429 
1430 
1431     IShiryoRandomCards cardDealer;
1432 
1433     constructor(address _founder, address _normal, address _cardDealer, address _walletA, address _walletB)
1434         ERC1155("https://api.cards.shiryo.com/card/{id}.json")
1435     {
1436         founderPackAddress = _founder;
1437         normalPackAddress = _normal;
1438         cardDealer = IShiryoRandomCards(_cardDealer);
1439         walletA = _walletA;
1440         walletB = _walletB;
1441     }
1442 
1443     function openPacks(address packContract, uint256 _amount) public {
1444         require(_amount > 0, "Can't open zero packs.");
1445         require(_amount <= MAX_AMOUNT_OPEN, "Can't open zero packs.");
1446 
1447         // opening a pack means
1448         // transfer the pack(s) to this address
1449         // the balance of this address on the pack contracts = number opened
1450         IERC20(packContract).safeTransferFrom(
1451             msg.sender,
1452             address(this),
1453             _amount
1454         );
1455 
1456        
1457         uint256 amountBaseCards = _amount * cardsPerNormalPack;
1458         uint256 amountFounderCards = 0;
1459 
1460         if (packContract==founderPackAddress){
1461             amountFounderCards = _amount; // 1 additional founder card per founder pack
1462         }
1463 
1464         lastUnpackedByAddress[msg.sender] = new uint8[](amountBaseCards+amountFounderCards);
1465 
1466         uint8  [] memory baseCards = cardDealer.randomCards(amountBaseCards, activeDeck);
1467       
1468     
1469         for (uint256 c = 0; c < baseCards.length; c++) {
1470             _mint(msg.sender, uint256(baseCards[c]), 1, "");
1471             lastUnpackedByAddress[msg.sender][c] = baseCards[c];
1472         }
1473 
1474         for (uint256 f = 0; f < amountFounderCards; f++) {
1475             uint256 Fcard = TOTAL_BASE_CARDS+random(TOTAL_FOUNDER_CARDS)+1;
1476             _mint(msg.sender, Fcard, 1, "");
1477             lastUnpackedByAddress[msg.sender][amountBaseCards+f] = Fcard;
1478         }
1479 
1480     }
1481 
1482     function swapCards(uint256[] memory _cardsToSwap) public payable {
1483         require(_cardsToSwap.length <= MAX_AMOUNT_SWAP, "Too many to swap");
1484 
1485         // NFT holders don't have a fee for swapping cards.
1486         if (
1487             !(nftAddress != address(0x0) &&
1488                 IERC721(nftAddress).balanceOf(msg.sender) > 0)
1489         ) {
1490             require(msg.value >= swapFee, "Swap fee not met");
1491         }
1492 
1493         uint8  [] memory newCards  = cardDealer.randomCards(_cardsToSwap.length, activeDeck);
1494 
1495         for (uint256 c = 0; c < _cardsToSwap.length; c++) {
1496             _burn(msg.sender, _cardsToSwap[c], 1); // burn the old first
1497             _mint(msg.sender, uint256(newCards[c]), 1, "");
1498         }
1499         lastUnpackedByAddress[msg.sender] = newCards;
1500     }
1501 
1502     function lastUnpackedCards(address _user)
1503         public
1504         view
1505         returns (uint256[] memory)
1506     {
1507         return lastUnpackedByAddress[_user];
1508     }
1509 
1510     function totalCards() public pure returns (uint256){
1511         return TOTAL_BASE_CARDS+TOTAL_FOUNDER_CARDS;
1512     }
1513 
1514     function balancesOf(address _user) public view returns (uint256[] memory) {
1515         uint256[] memory balances = new uint256[](totalCards());
1516         for (uint256 i = 1; i <= totalCards(); i++) {
1517             balances[i - 1] = balanceOf(_user, i);
1518         }
1519         return balances;
1520     }
1521 
1522     function totalCardsOf(address _user) public view returns (uint256) {
1523         uint256 total = 0;
1524         for (uint256 i = 1; i <= totalCards(); i++) {
1525             total+= balanceOf(_user, i);
1526         }
1527         return total;
1528     }
1529 
1530     // pseudo random selection of integer in range
1531     uint256 nonce;
1532 
1533     function random(uint256 _range) internal returns (uint256) {
1534         uint256 rnd = uint256(
1535             keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))
1536         ) % _range;
1537         nonce++;
1538         return rnd;
1539     }
1540 
1541     // owner functions
1542     function setNFTAddress(address _nft) external onlyOwner {
1543         nftAddress = _nft;
1544     }
1545 
1546    function setSwapFee(uint256 _fee) external onlyOwner {
1547            swapFee = _fee;
1548     }
1549 
1550     function withdraw_all() external onlyClevel {
1551         require (address(this).balance > 0);
1552         uint256 amountB = SafeMath.div(address(this).balance,100).mul(walletBPercentage);
1553         uint256 amountA = address(this).balance.sub(amountB);
1554         payable(walletA).transfer(amountA);
1555         payable(walletB).transfer(amountB);
1556     }
1557 
1558     function setWalletA(address _walletA) external {
1559         require (msg.sender == walletA, "Who are you?");
1560         require (_walletA != address(0x0), "Invalid wallet");
1561         walletA = _walletA;
1562     }
1563 
1564     function setWalletB(address _walletB) external {
1565         require (msg.sender == walletB, "Who are you?");
1566         require (_walletB != address(0x0), "Invalid wallet.");
1567         walletB = _walletB;
1568     }
1569 
1570     function setWalletBPercentage(uint256 _percentage) external onlyOwner {
1571         require (_percentage>walletBPercentage && _percentage<=100, "Invalid new slice.");
1572         walletBPercentage = _percentage;
1573     }
1574 
1575 }
1576 
1577 // File: @openzeppelin/contracts/math/SafeMath.sol
1578 /**
1579 * @dev Wrappers over Solidity's arithmetic operations with added overflow
1580 * checks.
1581 *
1582 * Arithmetic operations in Solidity wrap on overflow. This can easily result
1583 * in bugs, because programmers usually assume that an overflow raises an
1584 * error, which is the standard behavior in high level programming languages.
1585 * `SafeMath` restores this intuition by reverting the transaction when an
1586 * operation overflows.
1587 *
1588 * Using this library instead of the unchecked operations eliminates an entire
1589 * class of bugs, so it's recommended to use it always.
1590 */
1591 library SafeMath {
1592   /**
1593    * @dev Returns the addition of two unsigned integers, with an overflow flag.
1594    *
1595    * _Available since v3.4._
1596    */
1597   function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1598       uint256 c = a + b;
1599       if (c < a) return (false, 0);
1600       return (true, c);
1601   }
1602   /**
1603    * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1604    *
1605    * _Available since v3.4._
1606    */
1607   function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1608       if (b > a) return (false, 0);
1609       return (true, a - b);
1610   }
1611   /**
1612    * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1613    *
1614    * _Available since v3.4._
1615    */
1616   function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1617       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1618       // benefit is lost if 'b' is also tested.
1619       // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1620       if (a == 0) return (true, 0);
1621       uint256 c = a * b;
1622       if (c / a != b) return (false, 0);
1623       return (true, c);
1624   }
1625   /**
1626    * @dev Returns the division of two unsigned integers, with a division by zero flag.
1627    *
1628    * _Available since v3.4._
1629    */
1630   function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1631       if (b == 0) return (false, 0);
1632       return (true, a / b);
1633   }
1634   /**
1635    * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1636    *
1637    * _Available since v3.4._
1638    */
1639   function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1640       if (b == 0) return (false, 0);
1641       return (true, a % b);
1642   }
1643   /**
1644    * @dev Returns the addition of two unsigned integers, reverting on
1645    * overflow.
1646    *
1647    * Counterpart to Solidity's `+` operator.
1648    *
1649    * Requirements:
1650    *
1651    * - Addition cannot overflow.
1652    */
1653   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1654       uint256 c = a + b;
1655       require(c >= a, "SafeMath: addition overflow");
1656       return c;
1657   }
1658   /**
1659    * @dev Returns the subtraction of two unsigned integers, reverting on
1660    * overflow (when the result is negative).
1661    *
1662    * Counterpart to Solidity's `-` operator.
1663    *
1664    * Requirements:
1665    *
1666    * - Subtraction cannot overflow.
1667    */
1668   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1669       require(b <= a, "SafeMath: subtraction overflow");
1670       return a - b;
1671   }
1672   /**
1673    * @dev Returns the multiplication of two unsigned integers, reverting on
1674    * overflow.
1675    *
1676    * Counterpart to Solidity's `*` operator.
1677    *
1678    * Requirements:
1679    *
1680    * - Multiplication cannot overflow.
1681    */
1682   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1683       if (a == 0) return 0;
1684       uint256 c = a * b;
1685       require(c / a == b, "SafeMath: multiplication overflow");
1686       return c;
1687   }
1688   /**
1689    * @dev Returns the integer division of two unsigned integers, reverting on
1690    * division by zero. The result is rounded towards zero.
1691    *
1692    * Counterpart to Solidity's `/` operator. Note: this function uses a
1693    * `revert` opcode (which leaves remaining gas untouched) while Solidity
1694    * uses an invalid opcode to revert (consuming all remaining gas).
1695    *
1696    * Requirements:
1697    *
1698    * - The divisor cannot be zero.
1699    */
1700   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1701       require(b > 0, "SafeMath: division by zero");
1702       return a / b;
1703   }
1704   /**
1705    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1706    * reverting when dividing by zero.
1707    *
1708    * Counterpart to Solidity's `%` operator. This function uses a `revert`
1709    * opcode (which leaves remaining gas untouched) while Solidity uses an
1710    * invalid opcode to revert (consuming all remaining gas).
1711    *
1712    * Requirements:
1713    *
1714    * - The divisor cannot be zero.
1715    */
1716   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1717       require(b > 0, "SafeMath: modulo by zero");
1718       return a % b;
1719   }
1720   /**
1721    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1722    * overflow (when the result is negative).
1723    *
1724    * CAUTION: This function is deprecated because it requires allocating memory for the error
1725    * message unnecessarily. For custom revert reasons use {trySub}.
1726    *
1727    * Counterpart to Solidity's `-` operator.
1728    *
1729    * Requirements:
1730    *
1731    * - Subtraction cannot overflow.
1732    */
1733   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1734       require(b <= a, errorMessage);
1735       return a - b;
1736   }
1737   /**
1738    * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1739    * division by zero. The result is rounded towards zero.
1740    *
1741    * CAUTION: This function is deprecated because it requires allocating memory for the error
1742    * message unnecessarily. For custom revert reasons use {tryDiv}.
1743    *
1744    * Counterpart to Solidity's `/` operator. Note: this function uses a
1745    * `revert` opcode (which leaves remaining gas untouched) while Solidity
1746    * uses an invalid opcode to revert (consuming all remaining gas).
1747    *
1748    * Requirements:
1749    *
1750    * - The divisor cannot be zero.
1751    */
1752   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1753       require(b > 0, errorMessage);
1754       return a / b;
1755   }
1756   /**
1757    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1758    * reverting with custom message when dividing by zero.
1759    *
1760    * CAUTION: This function is deprecated because it requires allocating memory for the error
1761    * message unnecessarily. For custom revert reasons use {tryMod}.
1762    *
1763    * Counterpart to Solidity's `%` operator. This function uses a `revert`
1764    * opcode (which leaves remaining gas untouched) while Solidity uses an
1765    * invalid opcode to revert (consuming all remaining gas).
1766    *
1767    * Requirements:
1768    *
1769    * - The divisor cannot be zero.
1770    */
1771   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1772       require(b > 0, errorMessage);
1773       return a % b;
1774   }
1775 }