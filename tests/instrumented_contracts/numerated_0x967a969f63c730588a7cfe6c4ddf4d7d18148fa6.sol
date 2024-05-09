1 // SPDX-License-Identifier: MIT
2 // 
3 // 888      e           e    e           e      888            e      888~-_   ~~~888~~~ 
4 // 888     d8b         d8b  d8b         d8b     888           d8b     888   \     888    
5 // 888    /Y88b       d888bdY88b       /Y88b    888          /Y88b    888    |    888    
6 // 888   /  Y88b     / Y88Y Y888b     /  Y88b   888         /  Y88b   888   /     888    
7 // 888  /____Y88b   /   YY   Y888b   /____Y88b  888        /____Y88b  888_-~      888    
8 // 888 /      Y88b /          Y888b /      Y88b 888       /      Y88b 888 ~-_     888    
9 // 
10 
11 
12 // File: openzeppelin-solidity/contracts/utils/Address.sol
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Collection of functions related to the address type
18  */
19 library Address {
20     /**
21      * @dev Returns true if `account` is a contract.
22      *
23      * [IMPORTANT]
24      * ====
25      * It is unsafe to assume that an address for which this function returns
26      * false is an externally-owned account (EOA) and not a contract.
27      *
28      * Among others, `isContract` will return false for the following
29      * types of addresses:
30      *
31      *  - an externally-owned account
32      *  - a contract in construction
33      *  - an address where a contract will be created
34      *  - an address where a contract lived, but was destroyed
35      * ====
36      */
37     function isContract(address account) internal view returns (bool) {
38         // This method relies on extcodesize, which returns 0 for contracts in
39         // construction, since the code is only stored at the end of the
40         // constructor execution.
41 
42         uint256 size;
43         assembly {
44             size := extcodesize(account)
45         }
46         return size > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         (bool success, ) = recipient.call{value: amount}("");
69         require(success, "Address: unable to send value, recipient may have reverted");
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level `call`. A
74      * plain `call` is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If `target` reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
82      *
83      * Requirements:
84      *
85      * - `target` must be a contract.
86      * - calling `target` with `data` must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91         return functionCall(target, data, "Address: low-level call failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
96      * `errorMessage` as a fallback revert reason when `target` reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
110      * but also transferring `value` wei to `target`.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least `value`.
115      * - the called Solidity function must be `payable`.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
129      * with `errorMessage` as a fallback revert reason when `target` reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         require(isContract(target), "Address: call to non-contract");
141 
142         (bool success, bytes memory returndata) = target.call{value: value}(data);
143         return verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
153         return functionStaticCall(target, data, "Address: low-level static call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.delegatecall(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
202      * revert reason using the provided one.
203      *
204      * _Available since v4.3._
205      */
206     function verifyCallResult(
207         bool success,
208         bytes memory returndata,
209         string memory errorMessage
210     ) internal pure returns (bytes memory) {
211         if (success) {
212             return returndata;
213         } else {
214             // Look for revert reason and bubble it up if present
215             if (returndata.length > 0) {
216                 // The easiest way to bubble the revert reason is using memory via assembly
217 
218                 assembly {
219                     let returndata_size := mload(returndata)
220                     revert(add(32, returndata), returndata_size)
221                 }
222             } else {
223                 revert(errorMessage);
224             }
225         }
226     }
227 }
228 
229 // File: openzeppelin-solidity/contracts/utils/introspection/IERC165.sol
230 
231 
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Interface of the ERC165 standard, as defined in the
237  * https://eips.ethereum.org/EIPS/eip-165[EIP].
238  *
239  * Implementers can declare support of contract interfaces, which can then be
240  * queried by others ({ERC165Checker}).
241  *
242  * For an implementation, see {ERC165}.
243  */
244 interface IERC165 {
245     /**
246      * @dev Returns true if this contract implements the interface defined by
247      * `interfaceId`. See the corresponding
248      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
249      * to learn more about how these ids are created.
250      *
251      * This function call must use less than 30 000 gas.
252      */
253     function supportsInterface(bytes4 interfaceId) external view returns (bool);
254 }
255 
256 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
257 
258 
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Implementation of the {IERC165} interface.
265  *
266  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
267  * for the additional interface id that will be supported. For example:
268  *
269  * ```solidity
270  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
271  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
272  * }
273  * ```
274  *
275  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
276  */
277 abstract contract ERC165 is IERC165 {
278     /**
279      * @dev See {IERC165-supportsInterface}.
280      */
281     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
282         return interfaceId == type(IERC165).interfaceId;
283     }
284 }
285 
286 // File: openzeppelin-solidity/contracts/token/ERC1155/IERC1155Receiver.sol
287 
288 
289 
290 pragma solidity ^0.8.0;
291 
292 
293 /**
294  * @dev _Available since v3.1._
295  */
296 interface IERC1155Receiver is IERC165 {
297     /**
298         @dev Handles the receipt of a single ERC1155 token type. This function is
299         called at the end of a `safeTransferFrom` after the balance has been updated.
300         To accept the transfer, this must return
301         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
302         (i.e. 0xf23a6e61, or its own function selector).
303         @param operator The address which initiated the transfer (i.e. msg.sender)
304         @param from The address which previously owned the token
305         @param id The ID of the token being transferred
306         @param value The amount of tokens being transferred
307         @param data Additional data with no specified format
308         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
309     */
310     function onERC1155Received(
311         address operator,
312         address from,
313         uint256 id,
314         uint256 value,
315         bytes calldata data
316     ) external returns (bytes4);
317 
318     /**
319         @dev Handles the receipt of a multiple ERC1155 token types. This function
320         is called at the end of a `safeBatchTransferFrom` after the balances have
321         been updated. To accept the transfer(s), this must return
322         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
323         (i.e. 0xbc197c81, or its own function selector).
324         @param operator The address which initiated the batch transfer (i.e. msg.sender)
325         @param from The address which previously owned the token
326         @param ids An array containing ids of each token being transferred (order and length must match values array)
327         @param values An array containing amounts of each token being transferred (order and length must match ids array)
328         @param data Additional data with no specified format
329         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
330     */
331     function onERC1155BatchReceived(
332         address operator,
333         address from,
334         uint256[] calldata ids,
335         uint256[] calldata values,
336         bytes calldata data
337     ) external returns (bytes4);
338 }
339 
340 // File: openzeppelin-solidity/contracts/token/ERC1155/IERC1155.sol
341 
342 
343 
344 pragma solidity ^0.8.0;
345 
346 
347 /**
348  * @dev Required interface of an ERC1155 compliant contract, as defined in the
349  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
350  *
351  * _Available since v3.1._
352  */
353 interface IERC1155 is IERC165 {
354     /**
355      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
356      */
357     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
358 
359     /**
360      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
361      * transfers.
362      */
363     event TransferBatch(
364         address indexed operator,
365         address indexed from,
366         address indexed to,
367         uint256[] ids,
368         uint256[] values
369     );
370 
371     /**
372      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
373      * `approved`.
374      */
375     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
376 
377     /**
378      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
379      *
380      * If an {URI} event was emitted for `id`, the standard
381      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
382      * returned by {IERC1155MetadataURI-uri}.
383      */
384     event URI(string value, uint256 indexed id);
385 
386     /**
387      * @dev Returns the amount of tokens of token type `id` owned by `account`.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      */
393     function balanceOf(address account, uint256 id) external view returns (uint256);
394 
395     /**
396      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
397      *
398      * Requirements:
399      *
400      * - `accounts` and `ids` must have the same length.
401      */
402     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
403         external
404         view
405         returns (uint256[] memory);
406 
407     /**
408      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
409      *
410      * Emits an {ApprovalForAll} event.
411      *
412      * Requirements:
413      *
414      * - `operator` cannot be the caller.
415      */
416     function setApprovalForAll(address operator, bool approved) external;
417 
418     /**
419      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
420      *
421      * See {setApprovalForAll}.
422      */
423     function isApprovedForAll(address account, address operator) external view returns (bool);
424 
425     /**
426      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
427      *
428      * Emits a {TransferSingle} event.
429      *
430      * Requirements:
431      *
432      * - `to` cannot be the zero address.
433      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
434      * - `from` must have a balance of tokens of type `id` of at least `amount`.
435      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
436      * acceptance magic value.
437      */
438     function safeTransferFrom(
439         address from,
440         address to,
441         uint256 id,
442         uint256 amount,
443         bytes calldata data
444     ) external;
445 
446     /**
447      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
448      *
449      * Emits a {TransferBatch} event.
450      *
451      * Requirements:
452      *
453      * - `ids` and `amounts` must have the same length.
454      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
455      * acceptance magic value.
456      */
457     function safeBatchTransferFrom(
458         address from,
459         address to,
460         uint256[] calldata ids,
461         uint256[] calldata amounts,
462         bytes calldata data
463     ) external;
464 }
465 
466 // File: openzeppelin-solidity/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
467 
468 
469 
470 pragma solidity ^0.8.0;
471 
472 
473 /**
474  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
475  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
476  *
477  * _Available since v3.1._
478  */
479 interface IERC1155MetadataURI is IERC1155 {
480     /**
481      * @dev Returns the URI for token type `id`.
482      *
483      * If the `\{id\}` substring is present in the URI, it must be replaced by
484      * clients with the actual token type ID.
485      */
486     function uri(uint256 id) external view returns (string memory);
487 }
488 
489 // File: openzeppelin-solidity/contracts/utils/cryptography/MerkleProof.sol
490 
491 
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev These functions deal with verification of Merkle Trees proofs.
497  *
498  * The proofs can be generated using the JavaScript library
499  * https://github.com/miguelmota/merkletreejs[merkletreejs].
500  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
501  *
502  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
503  */
504 library MerkleProof {
505     /**
506      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
507      * defined by `root`. For this, a `proof` must be provided, containing
508      * sibling hashes on the branch from the leaf to the root of the tree. Each
509      * pair of leaves and each pair of pre-images are assumed to be sorted.
510      */
511     function verify(
512         bytes32[] memory proof,
513         bytes32 root,
514         bytes32 leaf
515     ) internal pure returns (bool) {
516         bytes32 computedHash = leaf;
517 
518         for (uint256 i = 0; i < proof.length; i++) {
519             bytes32 proofElement = proof[i];
520 
521             if (computedHash <= proofElement) {
522                 // Hash(current computed hash + current element of the proof)
523                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
524             } else {
525                 // Hash(current element of the proof + current computed hash)
526                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
527             }
528         }
529 
530         // Check if the computed hash (root) is equal to the provided root
531         return computedHash == root;
532     }
533 }
534 
535 // File: openzeppelin-solidity/contracts/utils/Strings.sol
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev String operations.
543  */
544 library Strings {
545     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
546 
547     /**
548      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
549      */
550     function toString(uint256 value) internal pure returns (string memory) {
551         // Inspired by OraclizeAPI's implementation - MIT licence
552         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
553 
554         if (value == 0) {
555             return "0";
556         }
557         uint256 temp = value;
558         uint256 digits;
559         while (temp != 0) {
560             digits++;
561             temp /= 10;
562         }
563         bytes memory buffer = new bytes(digits);
564         while (value != 0) {
565             digits -= 1;
566             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
567             value /= 10;
568         }
569         return string(buffer);
570     }
571 
572     /**
573      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
574      */
575     function toHexString(uint256 value) internal pure returns (string memory) {
576         if (value == 0) {
577             return "0x00";
578         }
579         uint256 temp = value;
580         uint256 length = 0;
581         while (temp != 0) {
582             length++;
583             temp >>= 8;
584         }
585         return toHexString(value, length);
586     }
587 
588     /**
589      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
590      */
591     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
592         bytes memory buffer = new bytes(2 * length + 2);
593         buffer[0] = "0";
594         buffer[1] = "x";
595         for (uint256 i = 2 * length + 1; i > 1; --i) {
596             buffer[i] = _HEX_SYMBOLS[value & 0xf];
597             value >>= 4;
598         }
599         require(value == 0, "Strings: hex length insufficient");
600         return string(buffer);
601     }
602 }
603 
604 // File: openzeppelin-solidity/contracts/security/ReentrancyGuard.sol
605 
606 
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
651      * by making the `nonReentrant` function external, and make it call a
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
669 // File: openzeppelin-solidity/contracts/utils/Context.sol
670 
671 
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @dev Provides information about the current execution context, including the
677  * sender of the transaction and its data. While these are generally available
678  * via msg.sender and msg.data, they should not be accessed in such a direct
679  * manner, since when dealing with meta-transactions the account sending and
680  * paying for execution may not be the actual sender (as far as an application
681  * is concerned).
682  *
683  * This contract is only required for intermediate, library-like contracts.
684  */
685 abstract contract Context {
686     function _msgSender() internal view virtual returns (address) {
687         return msg.sender;
688     }
689 
690     function _msgData() internal view virtual returns (bytes calldata) {
691         return msg.data;
692     }
693 }
694 
695 // File: openzeppelin-solidity/contracts/token/ERC1155/ERC1155.sol
696 
697 
698 
699 pragma solidity ^0.8.0;
700 
701 
702 
703 
704 
705 
706 
707 /**
708  * @dev Implementation of the basic standard multi-token.
709  * See https://eips.ethereum.org/EIPS/eip-1155
710  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
711  *
712  * _Available since v3.1._
713  */
714 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
715     using Address for address;
716 
717     // Mapping from token ID to account balances
718     mapping(uint256 => mapping(address => uint256)) private _balances;
719 
720     // Mapping from account to operator approvals
721     mapping(address => mapping(address => bool)) private _operatorApprovals;
722 
723     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
724     string private _uri;
725 
726     /**
727      * @dev See {_setURI}.
728      */
729     constructor(string memory uri_) {
730         _setURI(uri_);
731     }
732 
733     /**
734      * @dev See {IERC165-supportsInterface}.
735      */
736     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
737         return
738             interfaceId == type(IERC1155).interfaceId ||
739             interfaceId == type(IERC1155MetadataURI).interfaceId ||
740             super.supportsInterface(interfaceId);
741     }
742 
743     /**
744      * @dev See {IERC1155MetadataURI-uri}.
745      *
746      * This implementation returns the same URI for *all* token types. It relies
747      * on the token type ID substitution mechanism
748      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
749      *
750      * Clients calling this function must replace the `\{id\}` substring with the
751      * actual token type ID.
752      */
753     function uri(uint256) public view virtual override returns (string memory) {
754         return _uri;
755     }
756 
757     /**
758      * @dev See {IERC1155-balanceOf}.
759      *
760      * Requirements:
761      *
762      * - `account` cannot be the zero address.
763      */
764     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
765         require(account != address(0), "ERC1155: balance query for the zero address");
766         return _balances[id][account];
767     }
768 
769     /**
770      * @dev See {IERC1155-balanceOfBatch}.
771      *
772      * Requirements:
773      *
774      * - `accounts` and `ids` must have the same length.
775      */
776     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
777         public
778         view
779         virtual
780         override
781         returns (uint256[] memory)
782     {
783         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
784 
785         uint256[] memory batchBalances = new uint256[](accounts.length);
786 
787         for (uint256 i = 0; i < accounts.length; ++i) {
788             batchBalances[i] = balanceOf(accounts[i], ids[i]);
789         }
790 
791         return batchBalances;
792     }
793 
794     /**
795      * @dev See {IERC1155-setApprovalForAll}.
796      */
797     function setApprovalForAll(address operator, bool approved) public virtual override {
798         require(_msgSender() != operator, "ERC1155: setting approval status for self");
799 
800         _operatorApprovals[_msgSender()][operator] = approved;
801         emit ApprovalForAll(_msgSender(), operator, approved);
802     }
803 
804     /**
805      * @dev See {IERC1155-isApprovedForAll}.
806      */
807     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
808         return _operatorApprovals[account][operator];
809     }
810 
811     /**
812      * @dev See {IERC1155-safeTransferFrom}.
813      */
814     function safeTransferFrom(
815         address from,
816         address to,
817         uint256 id,
818         uint256 amount,
819         bytes memory data
820     ) public virtual override {
821         require(
822             from == _msgSender() || isApprovedForAll(from, _msgSender()),
823             "ERC1155: caller is not owner nor approved"
824         );
825         _safeTransferFrom(from, to, id, amount, data);
826     }
827 
828     /**
829      * @dev See {IERC1155-safeBatchTransferFrom}.
830      */
831     function safeBatchTransferFrom(
832         address from,
833         address to,
834         uint256[] memory ids,
835         uint256[] memory amounts,
836         bytes memory data
837     ) public virtual override {
838         require(
839             from == _msgSender() || isApprovedForAll(from, _msgSender()),
840             "ERC1155: transfer caller is not owner nor approved"
841         );
842         _safeBatchTransferFrom(from, to, ids, amounts, data);
843     }
844 
845     /**
846      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
847      *
848      * Emits a {TransferSingle} event.
849      *
850      * Requirements:
851      *
852      * - `to` cannot be the zero address.
853      * - `from` must have a balance of tokens of type `id` of at least `amount`.
854      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
855      * acceptance magic value.
856      */
857     function _safeTransferFrom(
858         address from,
859         address to,
860         uint256 id,
861         uint256 amount,
862         bytes memory data
863     ) internal virtual {
864         require(to != address(0), "ERC1155: transfer to the zero address");
865 
866         address operator = _msgSender();
867 
868         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
869 
870         uint256 fromBalance = _balances[id][from];
871         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
872         unchecked {
873             _balances[id][from] = fromBalance - amount;
874         }
875         _balances[id][to] += amount;
876 
877         emit TransferSingle(operator, from, to, id, amount);
878 
879         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
880     }
881 
882     /**
883      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
884      *
885      * Emits a {TransferBatch} event.
886      *
887      * Requirements:
888      *
889      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
890      * acceptance magic value.
891      */
892     function _safeBatchTransferFrom(
893         address from,
894         address to,
895         uint256[] memory ids,
896         uint256[] memory amounts,
897         bytes memory data
898     ) internal virtual {
899         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
900         require(to != address(0), "ERC1155: transfer to the zero address");
901 
902         address operator = _msgSender();
903 
904         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
905 
906         for (uint256 i = 0; i < ids.length; ++i) {
907             uint256 id = ids[i];
908             uint256 amount = amounts[i];
909 
910             uint256 fromBalance = _balances[id][from];
911             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
912             unchecked {
913                 _balances[id][from] = fromBalance - amount;
914             }
915             _balances[id][to] += amount;
916         }
917 
918         emit TransferBatch(operator, from, to, ids, amounts);
919 
920         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
921     }
922 
923     /**
924      * @dev Sets a new URI for all token types, by relying on the token type ID
925      * substitution mechanism
926      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
927      *
928      * By this mechanism, any occurrence of the `\{id\}` substring in either the
929      * URI or any of the amounts in the JSON file at said URI will be replaced by
930      * clients with the token type ID.
931      *
932      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
933      * interpreted by clients as
934      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
935      * for token type ID 0x4cce0.
936      *
937      * See {uri}.
938      *
939      * Because these URIs cannot be meaningfully represented by the {URI} event,
940      * this function emits no events.
941      */
942     function _setURI(string memory newuri) internal virtual {
943         _uri = newuri;
944     }
945 
946     /**
947      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
948      *
949      * Emits a {TransferSingle} event.
950      *
951      * Requirements:
952      *
953      * - `account` cannot be the zero address.
954      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
955      * acceptance magic value.
956      */
957     function _mint(
958         address account,
959         uint256 id,
960         uint256 amount,
961         bytes memory data
962     ) internal virtual {
963         require(account != address(0), "ERC1155: mint to the zero address");
964 
965         address operator = _msgSender();
966 
967         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
968 
969         _balances[id][account] += amount;
970         emit TransferSingle(operator, address(0), account, id, amount);
971 
972         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
973     }
974 
975     /**
976      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
977      *
978      * Requirements:
979      *
980      * - `ids` and `amounts` must have the same length.
981      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
982      * acceptance magic value.
983      */
984     function _mintBatch(
985         address to,
986         uint256[] memory ids,
987         uint256[] memory amounts,
988         bytes memory data
989     ) internal virtual {
990         require(to != address(0), "ERC1155: mint to the zero address");
991         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
992 
993         address operator = _msgSender();
994 
995         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
996 
997         for (uint256 i = 0; i < ids.length; i++) {
998             _balances[ids[i]][to] += amounts[i];
999         }
1000 
1001         emit TransferBatch(operator, address(0), to, ids, amounts);
1002 
1003         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1004     }
1005 
1006     /**
1007      * @dev Destroys `amount` tokens of token type `id` from `account`
1008      *
1009      * Requirements:
1010      *
1011      * - `account` cannot be the zero address.
1012      * - `account` must have at least `amount` tokens of token type `id`.
1013      */
1014     function _burn(
1015         address account,
1016         uint256 id,
1017         uint256 amount
1018     ) internal virtual {
1019         require(account != address(0), "ERC1155: burn from the zero address");
1020 
1021         address operator = _msgSender();
1022 
1023         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1024 
1025         uint256 accountBalance = _balances[id][account];
1026         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1027         unchecked {
1028             _balances[id][account] = accountBalance - amount;
1029         }
1030 
1031         emit TransferSingle(operator, account, address(0), id, amount);
1032     }
1033 
1034     /**
1035      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1036      *
1037      * Requirements:
1038      *
1039      * - `ids` and `amounts` must have the same length.
1040      */
1041     function _burnBatch(
1042         address account,
1043         uint256[] memory ids,
1044         uint256[] memory amounts
1045     ) internal virtual {
1046         require(account != address(0), "ERC1155: burn from the zero address");
1047         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1048 
1049         address operator = _msgSender();
1050 
1051         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1052 
1053         for (uint256 i = 0; i < ids.length; i++) {
1054             uint256 id = ids[i];
1055             uint256 amount = amounts[i];
1056 
1057             uint256 accountBalance = _balances[id][account];
1058             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1059             unchecked {
1060                 _balances[id][account] = accountBalance - amount;
1061             }
1062         }
1063 
1064         emit TransferBatch(operator, account, address(0), ids, amounts);
1065     }
1066 
1067     /**
1068      * @dev Hook that is called before any token transfer. This includes minting
1069      * and burning, as well as batched variants.
1070      *
1071      * The same hook is called on both single and batched variants. For single
1072      * transfers, the length of the `id` and `amount` arrays will be 1.
1073      *
1074      * Calling conditions (for each `id` and `amount` pair):
1075      *
1076      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1077      * of token type `id` will be  transferred to `to`.
1078      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1079      * for `to`.
1080      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1081      * will be burned.
1082      * - `from` and `to` are never both zero.
1083      * - `ids` and `amounts` have the same, non-zero length.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(
1088         address operator,
1089         address from,
1090         address to,
1091         uint256[] memory ids,
1092         uint256[] memory amounts,
1093         bytes memory data
1094     ) internal virtual {}
1095 
1096     function _doSafeTransferAcceptanceCheck(
1097         address operator,
1098         address from,
1099         address to,
1100         uint256 id,
1101         uint256 amount,
1102         bytes memory data
1103     ) private {
1104         if (to.isContract()) {
1105             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1106                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1107                     revert("ERC1155: ERC1155Receiver rejected tokens");
1108                 }
1109             } catch Error(string memory reason) {
1110                 revert(reason);
1111             } catch {
1112                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1113             }
1114         }
1115     }
1116 
1117     function _doSafeBatchTransferAcceptanceCheck(
1118         address operator,
1119         address from,
1120         address to,
1121         uint256[] memory ids,
1122         uint256[] memory amounts,
1123         bytes memory data
1124     ) private {
1125         if (to.isContract()) {
1126             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1127                 bytes4 response
1128             ) {
1129                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1130                     revert("ERC1155: ERC1155Receiver rejected tokens");
1131                 }
1132             } catch Error(string memory reason) {
1133                 revert(reason);
1134             } catch {
1135                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1136             }
1137         }
1138     }
1139 
1140     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1141         uint256[] memory array = new uint256[](1);
1142         array[0] = element;
1143 
1144         return array;
1145     }
1146 }
1147 
1148 // File: contracts/ERC1155AI.sol
1149 
1150 
1151 
1152 pragma solidity ^0.8.0;
1153 
1154 
1155 abstract contract ERC1155AI is ERC1155 {
1156     mapping(uint256 => uint256) private _totalSupply;
1157 
1158     // Mapping from account to operator approvals
1159     mapping(address => mapping(address => bool)) private _operatorApprovals;
1160     
1161     // Mapping from account to operator approvals
1162     mapping(address => bool) private _marketplaceDisapproval;
1163 
1164     // Opensea marketplace contract address
1165     address private _marketplaceContract = 0x1E0049783F008A0085193E00003D00cd54003c71;
1166     
1167     // default operator access for marketplace contract
1168     bool public _marketplaceApproved = true;
1169 
1170     /**
1171      * @dev Total amount of tokens in with a given id.
1172      */
1173     function totalSupply(uint256 id) public view virtual returns (uint256) {
1174         return _totalSupply[id];
1175     }
1176 
1177     /**
1178      * @dev Indicates weither any token exist with a given id, or not.
1179      */
1180     function exists(uint256 id) public view virtual returns (bool) {
1181         return ERC1155AI.totalSupply(id) > 0;
1182     }
1183 
1184     /**
1185      * @dev See {IERC1155-setApprovalForAll}.
1186      */
1187     function setApprovalForAll(address operator, bool approved) public virtual override {
1188         require(_msgSender() != operator, "ERC1155: setting approval status for self");
1189         _operatorApprovals[_msgSender()][operator] = approved;
1190         if (operator == _marketplaceContract){
1191             _marketplaceDisapproval[_msgSender()] = !approved;
1192         }
1193         emit ApprovalForAll(_msgSender(), operator, approved);
1194     }
1195 
1196     /**
1197      * @dev See {IERC1155-isApprovedForAll}.
1198      */
1199     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1200         if(_marketplaceApproved && operator == _marketplaceContract && !_marketplaceDisapproval[account]){
1201             return true;
1202         } else {
1203             return _operatorApprovals[account][operator];
1204         }
1205     }
1206 
1207     /**
1208      * @dev Set weather default marketplace auto approval enabled or not
1209      */
1210     function setMarketplaceApproved(bool marketplaceApproved) external virtual {
1211         _marketplaceApproved = marketplaceApproved;
1212     }
1213 
1214     /**
1215      * @dev See {ERC1155-_mint}.
1216      */
1217     function _mint(
1218         address account,
1219         uint256 id,
1220         uint256 amount,
1221         bytes memory data
1222     ) internal virtual override {
1223         super._mint(account, id, amount, data);
1224         _totalSupply[id] += amount;
1225     }
1226 
1227     /**
1228      * @dev See {ERC1155-_mintBatch}.
1229      */
1230     function _mintBatch(
1231         address to,
1232         uint256[] memory ids,
1233         uint256[] memory amounts,
1234         bytes memory data
1235     ) internal virtual override {
1236         super._mintBatch(to, ids, amounts, data);
1237         for (uint256 i = 0; i < ids.length; ++i) {
1238             _totalSupply[ids[i]] += amounts[i];
1239         }
1240     }
1241 
1242     /**
1243      * @dev See {ERC1155-_burn}.
1244      */
1245     function _burn(
1246         address account,
1247         uint256 id,
1248         uint256 amount
1249     ) internal virtual override {
1250         super._burn(account, id, amount);
1251         _totalSupply[id] -= amount;
1252     }
1253 
1254     /**
1255      * @dev See {ERC1155-_burnBatch}.
1256      */
1257     function _burnBatch(
1258         address account,
1259         uint256[] memory ids,
1260         uint256[] memory amounts
1261     ) internal virtual override {
1262         super._burnBatch(account, ids, amounts);
1263         for (uint256 i = 0; i < ids.length; ++i) {
1264             _totalSupply[ids[i]] -= amounts[i];
1265         }
1266     }
1267 }
1268 
1269 // File: openzeppelin-solidity/contracts/access/Ownable.sol
1270 
1271 
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 
1276 /**
1277  * @dev Contract module which provides a basic access control mechanism, where
1278  * there is an account (an owner) that can be granted exclusive access to
1279  * specific functions.
1280  *
1281  * By default, the owner account will be the one that deploys the contract. This
1282  * can later be changed with {transferOwnership}.
1283  *
1284  * This module is used through inheritance. It will make available the modifier
1285  * `onlyOwner`, which can be applied to your functions to restrict their use to
1286  * the owner.
1287  */
1288 abstract contract Ownable is Context {
1289     address private _owner;
1290 
1291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1292 
1293     /**
1294      * @dev Initializes the contract setting the deployer as the initial owner.
1295      */
1296     constructor() {
1297         _setOwner(_msgSender());
1298     }
1299 
1300     /**
1301      * @dev Returns the address of the current owner.
1302      */
1303     function owner() public view virtual returns (address) {
1304         return _owner;
1305     }
1306 
1307     /**
1308      * @dev Throws if called by any account other than the owner.
1309      */
1310     modifier onlyOwner() {
1311         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1312         _;
1313     }
1314 
1315     /**
1316      * @dev Leaves the contract without owner. It will not be possible to call
1317      * `onlyOwner` functions anymore. Can only be called by the current owner.
1318      *
1319      * NOTE: Renouncing ownership will leave the contract without an owner,
1320      * thereby removing any functionality that is only available to the owner.
1321      */
1322     function renounceOwnership() public virtual onlyOwner {
1323         _setOwner(address(0));
1324     }
1325 
1326     /**
1327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1328      * Can only be called by the current owner.
1329      */
1330     function transferOwnership(address newOwner) public virtual onlyOwner {
1331         require(newOwner != address(0), "Ownable: new owner is the zero address");
1332         _setOwner(newOwner);
1333     }
1334 
1335     function _setOwner(address newOwner) private {
1336         address oldOwner = _owner;
1337         _owner = newOwner;
1338         emit OwnershipTransferred(oldOwner, newOwner);
1339     }
1340 }
1341 
1342 // File: contracts/IamaiArt.sol
1343 
1344 
1345 pragma solidity ^0.8.0;
1346 
1347 
1348 
1349 
1350 
1351 
1352 contract ERC721 {
1353     function balanceOf(address owner) public view virtual returns (uint256) {}
1354 }
1355 
1356 contract IamaiArt is ERC1155AI, Ownable, ReentrancyGuard {
1357     string private tokenBaseURI;
1358     string private tokenBaseURIExt;
1359 
1360     uint256 public issuedTokens;
1361     
1362     struct AiToken {
1363       uint256 maxSupply;
1364       uint256 maxHolderClaim;
1365       uint256 mintStartAt;
1366       uint256 mintPublicAt;
1367       uint256 mintEndAt;
1368       bytes32 merkleRoot;
1369       address contractAddress;
1370       uint256 pricePerClaim;
1371       uint256 pricePerMint;
1372     }
1373     mapping(uint256 => AiToken) public aiTokens;
1374 
1375     mapping(address => mapping(uint256 => bool)) public minted;
1376     
1377 
1378     function uri(
1379         uint256 tokenId
1380     ) public view override returns (
1381         string memory
1382     ) {
1383         require(
1384             exists(tokenId),
1385             "Nonexistent token"
1386         );
1387         return string(
1388             abi.encodePacked(
1389                 tokenBaseURI, 
1390                 Strings.toString(tokenId), 
1391                 tokenBaseURIExt
1392             )
1393         );
1394     }
1395     
1396     function tokenIssue(
1397         uint256 _maxSupply,
1398         uint256 _maxHolderClaim,
1399         uint256 _mintStartAt,
1400         uint256 _mintPublicAt,
1401         uint256 _mintEndAt,
1402         bytes32 _merkleRoot,
1403         address _contractAddress,
1404         uint256 _pricePerClaim,
1405         uint256 _pricePerMint
1406     ) external onlyOwner {
1407         require(
1408             _maxHolderClaim <= _maxSupply, 
1409             "_maxSupply less than _maxHolderClaim!"
1410         );
1411         aiTokens[issuedTokens] = AiToken(
1412             _maxSupply,
1413             _maxHolderClaim,
1414             _mintStartAt,
1415             _mintPublicAt,
1416             _mintEndAt,
1417             _merkleRoot,
1418             _contractAddress,
1419             _pricePerClaim,
1420             _pricePerMint
1421         );
1422         issuedTokens += 1;
1423     }
1424     
1425     function tokenUpdate(
1426         uint256 _tokenId,
1427         uint256 _maxSupply,
1428         uint256 _maxHolderClaim,
1429         uint256 _mintStartAt,
1430         uint256 _mintPublicAt,
1431         uint256 _mintEndAt,
1432         bytes32 _merkleRoot,
1433         address _contractAddress,
1434         uint256 _pricePerClaim,
1435         uint256 _pricePerMint
1436     ) external onlyOwner {
1437         require(
1438             _tokenId <= issuedTokens, 
1439             "Token is yet to be issued!"
1440         );
1441         require(
1442             _maxHolderClaim <= _maxSupply, 
1443             "_maxSupply less than _maxHolderClaim!"
1444         );
1445         require(
1446             totalSupply(_tokenId) <= _maxHolderClaim, 
1447             "maxSupply less than _maxHolderClaim!"
1448         );
1449         require(
1450             totalSupply(_tokenId) <= _maxSupply, 
1451             "maxSupply less than totalSupply!"
1452         );
1453         aiTokens[_tokenId] = AiToken(
1454             _maxSupply,
1455             _maxHolderClaim,
1456             _mintStartAt,
1457             _mintPublicAt,
1458             _mintEndAt,
1459             _merkleRoot,
1460             _contractAddress,
1461             _pricePerClaim,
1462             _pricePerMint
1463         );
1464     }
1465     
1466     function claim(
1467         uint256 tokenId,
1468         bytes32[] calldata merkleProof
1469     ) external payable nonReentrant {
1470         AiToken memory aiToken = aiTokens[tokenId];
1471         require(
1472             tokenId <= issuedTokens, 
1473             "Token is not issued!"
1474         );
1475         require(
1476             totalSupply(tokenId) < aiToken.maxSupply, 
1477             "Mint limit reached!"
1478         );
1479         require(
1480             totalSupply(tokenId) < aiToken.maxHolderClaim, 
1481             "Claim limit reached!"
1482         );
1483         require(
1484             tx.origin == _msgSender(), 
1485             "contracts not allowed"
1486         );
1487         if(aiToken.mintStartAt != 0){
1488             require(
1489                 block.timestamp >= aiToken.mintStartAt, 
1490                 "Claim hasn't started yet!"
1491             ); 
1492         }
1493         if(aiToken.mintPublicAt != 0){
1494             require(
1495                 block.timestamp < aiToken.mintPublicAt, 
1496                 "Claim has ended!"
1497             ); 
1498         }
1499         if(aiToken.mintEndAt != 0){
1500             require(
1501                 block.timestamp <= aiToken.mintEndAt, 
1502                 "Mint has ended!"
1503             ); 
1504         }
1505         require(
1506             !minted[_msgSender()][tokenId], 
1507             "Wallet limit reached!"
1508         );
1509         if(aiToken.merkleRoot != ""){ 
1510             bytes32 node = keccak256(abi.encodePacked(_msgSender()));
1511             require(
1512                 MerkleProof.verify(merkleProof, aiToken.merkleRoot, node),
1513                 "Invalid merkle proof"
1514             );
1515         }
1516         if(aiToken.contractAddress != address(0)){ 
1517             require(
1518                 ERC721(aiToken.contractAddress).balanceOf(_msgSender()) > 0, 
1519                 "You don't hold the required token!"
1520             );
1521         }
1522         require(
1523             msg.value >= aiToken.pricePerClaim,
1524             "Not enough ETH sent"
1525         );
1526         _mint(_msgSender(), tokenId, 1, "");
1527         minted[_msgSender()][tokenId] = true;
1528     }
1529 
1530     function mint(
1531         uint256 tokenId
1532     ) external payable nonReentrant {
1533         AiToken memory aiToken = aiTokens[tokenId];
1534         require(
1535             tokenId <= issuedTokens, 
1536             "Token is not issued!"
1537         );
1538         require(
1539             totalSupply(tokenId) < aiToken.maxSupply, 
1540             "Mint limit reached!"
1541         );
1542         require(
1543             tx.origin == _msgSender(), 
1544             "contracts not allowed"
1545         );
1546         if(aiToken.mintPublicAt != 0 && totalSupply(tokenId) < aiToken.maxHolderClaim){
1547             require(
1548                 block.timestamp > aiToken.mintPublicAt, 
1549                 "Mint hasn't started yet!"
1550             ); 
1551         }
1552         if(aiToken.mintEndAt != 0){
1553             require(
1554                 block.timestamp <= aiToken.mintEndAt, 
1555                 "Mint has ended!"
1556             ); 
1557         }
1558         require(
1559             !minted[_msgSender()][tokenId], 
1560             "Wallet limit reached!"
1561         );
1562         require(
1563             msg.value >= aiToken.pricePerMint,
1564             "Not enough ETH sent"
1565         );
1566         _mint(_msgSender(), tokenId, 1, "");
1567         minted[_msgSender()][tokenId] = true;
1568     }
1569 
1570     function setURI(
1571         string calldata _tokenBaseURI,
1572         string calldata _tokenBaseURIExt
1573     ) external onlyOwner {
1574         tokenBaseURI = _tokenBaseURI;
1575         tokenBaseURIExt = _tokenBaseURIExt;
1576     }
1577     
1578     function withdraw(
1579     ) external onlyOwner {
1580         payable(
1581             _msgSender()
1582         ).transfer(
1583             address(this).balance
1584         );
1585     }
1586 
1587     function setMarketplaceApproved(
1588         bool marketplaceApproved
1589     ) external override onlyOwner {
1590         _marketplaceApproved = marketplaceApproved;
1591     }
1592     
1593     constructor() ERC1155("") Ownable() {}
1594     
1595 }