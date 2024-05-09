1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Address.sol
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Interface of the ERC165 standard, as defined in the
235  * https://eips.ethereum.org/EIPS/eip-165[EIP].
236  *
237  * Implementers can declare support of contract interfaces, which can then be
238  * queried by others ({ERC165Checker}).
239  *
240  * For an implementation, see {ERC165}.
241  */
242 interface IERC165 {
243     /**
244      * @dev Returns true if this contract implements the interface defined by
245      * `interfaceId`. See the corresponding
246      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
247      * to learn more about how these ids are created.
248      *
249      * This function call must use less than 30 000 gas.
250      */
251     function supportsInterface(bytes4 interfaceId) external view returns (bool);
252 }
253 
254 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
255 
256 
257 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Implementation of the {IERC165} interface.
264  *
265  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
266  * for the additional interface id that will be supported. For example:
267  *
268  * ```solidity
269  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
270  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
271  * }
272  * ```
273  *
274  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
275  */
276 abstract contract ERC165 is IERC165 {
277     /**
278      * @dev See {IERC165-supportsInterface}.
279      */
280     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
281         return interfaceId == type(IERC165).interfaceId;
282     }
283 }
284 
285 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
286 
287 
288 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 
293 /**
294  * @dev _Available since v3.1._
295  */
296 interface IERC1155Receiver is IERC165 {
297     /**
298      * @dev Handles the receipt of a single ERC1155 token type. This function is
299      * called at the end of a `safeTransferFrom` after the balance has been updated.
300      *
301      * NOTE: To accept the transfer, this must return
302      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
303      * (i.e. 0xf23a6e61, or its own function selector).
304      *
305      * @param operator The address which initiated the transfer (i.e. msg.sender)
306      * @param from The address which previously owned the token
307      * @param id The ID of the token being transferred
308      * @param value The amount of tokens being transferred
309      * @param data Additional data with no specified format
310      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
311      */
312     function onERC1155Received(
313         address operator,
314         address from,
315         uint256 id,
316         uint256 value,
317         bytes calldata data
318     ) external returns (bytes4);
319 
320     /**
321      * @dev Handles the receipt of a multiple ERC1155 token types. This function
322      * is called at the end of a `safeBatchTransferFrom` after the balances have
323      * been updated.
324      *
325      * NOTE: To accept the transfer(s), this must return
326      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
327      * (i.e. 0xbc197c81, or its own function selector).
328      *
329      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
330      * @param from The address which previously owned the token
331      * @param ids An array containing ids of each token being transferred (order and length must match values array)
332      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
333      * @param data Additional data with no specified format
334      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
335      */
336     function onERC1155BatchReceived(
337         address operator,
338         address from,
339         uint256[] calldata ids,
340         uint256[] calldata values,
341         bytes calldata data
342     ) external returns (bytes4);
343 }
344 
345 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
346 
347 
348 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 
353 /**
354  * @dev Required interface of an ERC1155 compliant contract, as defined in the
355  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
356  *
357  * _Available since v3.1._
358  */
359 interface IERC1155 is IERC165 {
360     /**
361      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
362      */
363     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
364 
365     /**
366      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
367      * transfers.
368      */
369     event TransferBatch(
370         address indexed operator,
371         address indexed from,
372         address indexed to,
373         uint256[] ids,
374         uint256[] values
375     );
376 
377     /**
378      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
379      * `approved`.
380      */
381     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
382 
383     /**
384      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
385      *
386      * If an {URI} event was emitted for `id`, the standard
387      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
388      * returned by {IERC1155MetadataURI-uri}.
389      */
390     event URI(string value, uint256 indexed id);
391 
392     /**
393      * @dev Returns the amount of tokens of token type `id` owned by `account`.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      */
399     function balanceOf(address account, uint256 id) external view returns (uint256);
400 
401     /**
402      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
403      *
404      * Requirements:
405      *
406      * - `accounts` and `ids` must have the same length.
407      */
408     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
409         external
410         view
411         returns (uint256[] memory);
412 
413     /**
414      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
415      *
416      * Emits an {ApprovalForAll} event.
417      *
418      * Requirements:
419      *
420      * - `operator` cannot be the caller.
421      */
422     function setApprovalForAll(address operator, bool approved) external;
423 
424     /**
425      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
426      *
427      * See {setApprovalForAll}.
428      */
429     function isApprovedForAll(address account, address operator) external view returns (bool);
430 
431     /**
432      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
433      *
434      * Emits a {TransferSingle} event.
435      *
436      * Requirements:
437      *
438      * - `to` cannot be the zero address.
439      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
440      * - `from` must have a balance of tokens of type `id` of at least `amount`.
441      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
442      * acceptance magic value.
443      */
444     function safeTransferFrom(
445         address from,
446         address to,
447         uint256 id,
448         uint256 amount,
449         bytes calldata data
450     ) external;
451 
452     /**
453      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
454      *
455      * Emits a {TransferBatch} event.
456      *
457      * Requirements:
458      *
459      * - `ids` and `amounts` must have the same length.
460      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
461      * acceptance magic value.
462      */
463     function safeBatchTransferFrom(
464         address from,
465         address to,
466         uint256[] calldata ids,
467         uint256[] calldata amounts,
468         bytes calldata data
469     ) external;
470 }
471 
472 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 
480 /**
481  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
482  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
483  *
484  * _Available since v3.1._
485  */
486 interface IERC1155MetadataURI is IERC1155 {
487     /**
488      * @dev Returns the URI for token type `id`.
489      *
490      * If the `\{id\}` substring is present in the URI, it must be replaced by
491      * clients with the actual token type ID.
492      */
493     function uri(uint256 id) external view returns (string memory);
494 }
495 
496 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
497 
498 
499 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev These functions deal with verification of Merkle Trees proofs.
505  *
506  * The proofs can be generated using the JavaScript library
507  * https://github.com/miguelmota/merkletreejs[merkletreejs].
508  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
509  *
510  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
511  */
512 library MerkleProof {
513     /**
514      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
515      * defined by `root`. For this, a `proof` must be provided, containing
516      * sibling hashes on the branch from the leaf to the root of the tree. Each
517      * pair of leaves and each pair of pre-images are assumed to be sorted.
518      */
519     function verify(
520         bytes32[] memory proof,
521         bytes32 root,
522         bytes32 leaf
523     ) internal pure returns (bool) {
524         return processProof(proof, leaf) == root;
525     }
526 
527     /**
528      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
529      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
530      * hash matches the root of the tree. When processing the proof, the pairs
531      * of leafs & pre-images are assumed to be sorted.
532      *
533      * _Available since v4.4._
534      */
535     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
536         bytes32 computedHash = leaf;
537         for (uint256 i = 0; i < proof.length; i++) {
538             bytes32 proofElement = proof[i];
539             if (computedHash <= proofElement) {
540                 // Hash(current computed hash + current element of the proof)
541                 computedHash = _efficientHash(computedHash, proofElement);
542             } else {
543                 // Hash(current element of the proof + current computed hash)
544                 computedHash = _efficientHash(proofElement, computedHash);
545             }
546         }
547         return computedHash;
548     }
549 
550     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
551         assembly {
552             mstore(0x00, a)
553             mstore(0x20, b)
554             value := keccak256(0x00, 0x40)
555         }
556     }
557 }
558 
559 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Contract module that helps prevent reentrant calls to a function.
568  *
569  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
570  * available, which can be applied to functions to make sure there are no nested
571  * (reentrant) calls to them.
572  *
573  * Note that because there is a single `nonReentrant` guard, functions marked as
574  * `nonReentrant` may not call one another. This can be worked around by making
575  * those functions `private`, and then adding `external` `nonReentrant` entry
576  * points to them.
577  *
578  * TIP: If you would like to learn more about reentrancy and alternative ways
579  * to protect against it, check out our blog post
580  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
581  */
582 abstract contract ReentrancyGuard {
583     // Booleans are more expensive than uint256 or any type that takes up a full
584     // word because each write operation emits an extra SLOAD to first read the
585     // slot's contents, replace the bits taken up by the boolean, and then write
586     // back. This is the compiler's defense against contract upgrades and
587     // pointer aliasing, and it cannot be disabled.
588 
589     // The values being non-zero value makes deployment a bit more expensive,
590     // but in exchange the refund on every call to nonReentrant will be lower in
591     // amount. Since refunds are capped to a percentage of the total
592     // transaction's gas, it is best to keep them low in cases like this one, to
593     // increase the likelihood of the full refund coming into effect.
594     uint256 private constant _NOT_ENTERED = 1;
595     uint256 private constant _ENTERED = 2;
596 
597     uint256 private _status;
598 
599     constructor() {
600         _status = _NOT_ENTERED;
601     }
602 
603     /**
604      * @dev Prevents a contract from calling itself, directly or indirectly.
605      * Calling a `nonReentrant` function from another `nonReentrant`
606      * function is not supported. It is possible to prevent this from happening
607      * by making the `nonReentrant` function external, and making it call a
608      * `private` function that does the actual work.
609      */
610     modifier nonReentrant() {
611         // On the first call to nonReentrant, _notEntered will be true
612         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
613 
614         // Any calls to nonReentrant after this point will fail
615         _status = _ENTERED;
616 
617         _;
618 
619         // By storing the original value once again, a refund is triggered (see
620         // https://eips.ethereum.org/EIPS/eip-2200)
621         _status = _NOT_ENTERED;
622     }
623 }
624 
625 // File: @openzeppelin/contracts/utils/Context.sol
626 
627 
628 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev Provides information about the current execution context, including the
634  * sender of the transaction and its data. While these are generally available
635  * via msg.sender and msg.data, they should not be accessed in such a direct
636  * manner, since when dealing with meta-transactions the account sending and
637  * paying for execution may not be the actual sender (as far as an application
638  * is concerned).
639  *
640  * This contract is only required for intermediate, library-like contracts.
641  */
642 abstract contract Context {
643     function _msgSender() internal view virtual returns (address) {
644         return msg.sender;
645     }
646 
647     function _msgData() internal view virtual returns (bytes calldata) {
648         return msg.data;
649     }
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
653 
654 
655 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 
660 
661 
662 
663 
664 
665 /**
666  * @dev Implementation of the basic standard multi-token.
667  * See https://eips.ethereum.org/EIPS/eip-1155
668  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
669  *
670  * _Available since v3.1._
671  */
672 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
673     using Address for address;
674 
675     // Mapping from token ID to account balances
676     mapping(uint256 => mapping(address => uint256)) private _balances;
677 
678     // Mapping from account to operator approvals
679     mapping(address => mapping(address => bool)) private _operatorApprovals;
680 
681     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
682     string private _uri;
683 
684     /**
685      * @dev See {_setURI}.
686      */
687     constructor(string memory uri_) {
688         _setURI(uri_);
689     }
690 
691     /**
692      * @dev See {IERC165-supportsInterface}.
693      */
694     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
695         return
696             interfaceId == type(IERC1155).interfaceId ||
697             interfaceId == type(IERC1155MetadataURI).interfaceId ||
698             super.supportsInterface(interfaceId);
699     }
700 
701     /**
702      * @dev See {IERC1155MetadataURI-uri}.
703      *
704      * This implementation returns the same URI for *all* token types. It relies
705      * on the token type ID substitution mechanism
706      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
707      *
708      * Clients calling this function must replace the `\{id\}` substring with the
709      * actual token type ID.
710      */
711     function uri(uint256) public view virtual override returns (string memory) {
712         return _uri;
713     }
714 
715     /**
716      * @dev See {IERC1155-balanceOf}.
717      *
718      * Requirements:
719      *
720      * - `account` cannot be the zero address.
721      */
722     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
723         require(account != address(0), "ERC1155: balance query for the zero address");
724         return _balances[id][account];
725     }
726 
727     /**
728      * @dev See {IERC1155-balanceOfBatch}.
729      *
730      * Requirements:
731      *
732      * - `accounts` and `ids` must have the same length.
733      */
734     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
735         public
736         view
737         virtual
738         override
739         returns (uint256[] memory)
740     {
741         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
742 
743         uint256[] memory batchBalances = new uint256[](accounts.length);
744 
745         for (uint256 i = 0; i < accounts.length; ++i) {
746             batchBalances[i] = balanceOf(accounts[i], ids[i]);
747         }
748 
749         return batchBalances;
750     }
751 
752     /**
753      * @dev See {IERC1155-setApprovalForAll}.
754      */
755     function setApprovalForAll(address operator, bool approved) public virtual override {
756         _setApprovalForAll(_msgSender(), operator, approved);
757     }
758 
759     /**
760      * @dev See {IERC1155-isApprovedForAll}.
761      */
762     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
763         return _operatorApprovals[account][operator];
764     }
765 
766     /**
767      * @dev See {IERC1155-safeTransferFrom}.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 id,
773         uint256 amount,
774         bytes memory data
775     ) public virtual override {
776         require(
777             from == _msgSender() || isApprovedForAll(from, _msgSender()),
778             "ERC1155: caller is not owner nor approved"
779         );
780         _safeTransferFrom(from, to, id, amount, data);
781     }
782 
783     /**
784      * @dev See {IERC1155-safeBatchTransferFrom}.
785      */
786     function safeBatchTransferFrom(
787         address from,
788         address to,
789         uint256[] memory ids,
790         uint256[] memory amounts,
791         bytes memory data
792     ) public virtual override {
793         require(
794             from == _msgSender() || isApprovedForAll(from, _msgSender()),
795             "ERC1155: transfer caller is not owner nor approved"
796         );
797         _safeBatchTransferFrom(from, to, ids, amounts, data);
798     }
799 
800     /**
801      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
802      *
803      * Emits a {TransferSingle} event.
804      *
805      * Requirements:
806      *
807      * - `to` cannot be the zero address.
808      * - `from` must have a balance of tokens of type `id` of at least `amount`.
809      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
810      * acceptance magic value.
811      */
812     function _safeTransferFrom(
813         address from,
814         address to,
815         uint256 id,
816         uint256 amount,
817         bytes memory data
818     ) internal virtual {
819         require(to != address(0), "ERC1155: transfer to the zero address");
820 
821         address operator = _msgSender();
822         uint256[] memory ids = _asSingletonArray(id);
823         uint256[] memory amounts = _asSingletonArray(amount);
824 
825         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
826 
827         uint256 fromBalance = _balances[id][from];
828         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
829         unchecked {
830             _balances[id][from] = fromBalance - amount;
831         }
832         _balances[id][to] += amount;
833 
834         emit TransferSingle(operator, from, to, id, amount);
835 
836         _afterTokenTransfer(operator, from, to, ids, amounts, data);
837 
838         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
839     }
840 
841     /**
842      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
843      *
844      * Emits a {TransferBatch} event.
845      *
846      * Requirements:
847      *
848      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
849      * acceptance magic value.
850      */
851     function _safeBatchTransferFrom(
852         address from,
853         address to,
854         uint256[] memory ids,
855         uint256[] memory amounts,
856         bytes memory data
857     ) internal virtual {
858         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
859         require(to != address(0), "ERC1155: transfer to the zero address");
860 
861         address operator = _msgSender();
862 
863         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
864 
865         for (uint256 i = 0; i < ids.length; ++i) {
866             uint256 id = ids[i];
867             uint256 amount = amounts[i];
868 
869             uint256 fromBalance = _balances[id][from];
870             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
871             unchecked {
872                 _balances[id][from] = fromBalance - amount;
873             }
874             _balances[id][to] += amount;
875         }
876 
877         emit TransferBatch(operator, from, to, ids, amounts);
878 
879         _afterTokenTransfer(operator, from, to, ids, amounts, data);
880 
881         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
882     }
883 
884     /**
885      * @dev Sets a new URI for all token types, by relying on the token type ID
886      * substitution mechanism
887      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
888      *
889      * By this mechanism, any occurrence of the `\{id\}` substring in either the
890      * URI or any of the amounts in the JSON file at said URI will be replaced by
891      * clients with the token type ID.
892      *
893      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
894      * interpreted by clients as
895      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
896      * for token type ID 0x4cce0.
897      *
898      * See {uri}.
899      *
900      * Because these URIs cannot be meaningfully represented by the {URI} event,
901      * this function emits no events.
902      */
903     function _setURI(string memory newuri) internal virtual {
904         _uri = newuri;
905     }
906 
907     /**
908      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
909      *
910      * Emits a {TransferSingle} event.
911      *
912      * Requirements:
913      *
914      * - `to` cannot be the zero address.
915      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
916      * acceptance magic value.
917      */
918     function _mint(
919         address to,
920         uint256 id,
921         uint256 amount,
922         bytes memory data
923     ) internal virtual {
924         require(to != address(0), "ERC1155: mint to the zero address");
925 
926         address operator = _msgSender();
927         uint256[] memory ids = _asSingletonArray(id);
928         uint256[] memory amounts = _asSingletonArray(amount);
929 
930         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
931 
932         _balances[id][to] += amount;
933         emit TransferSingle(operator, address(0), to, id, amount);
934 
935         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
936 
937         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
938     }
939 
940     /**
941      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
942      *
943      * Requirements:
944      *
945      * - `ids` and `amounts` must have the same length.
946      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
947      * acceptance magic value.
948      */
949     function _mintBatch(
950         address to,
951         uint256[] memory ids,
952         uint256[] memory amounts,
953         bytes memory data
954     ) internal virtual {
955         require(to != address(0), "ERC1155: mint to the zero address");
956         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
957 
958         address operator = _msgSender();
959 
960         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
961 
962         for (uint256 i = 0; i < ids.length; i++) {
963             _balances[ids[i]][to] += amounts[i];
964         }
965 
966         emit TransferBatch(operator, address(0), to, ids, amounts);
967 
968         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
969 
970         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
971     }
972 
973     /**
974      * @dev Destroys `amount` tokens of token type `id` from `from`
975      *
976      * Requirements:
977      *
978      * - `from` cannot be the zero address.
979      * - `from` must have at least `amount` tokens of token type `id`.
980      */
981     function _burn(
982         address from,
983         uint256 id,
984         uint256 amount
985     ) internal virtual {
986         require(from != address(0), "ERC1155: burn from the zero address");
987 
988         address operator = _msgSender();
989         uint256[] memory ids = _asSingletonArray(id);
990         uint256[] memory amounts = _asSingletonArray(amount);
991 
992         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
993 
994         uint256 fromBalance = _balances[id][from];
995         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
996         unchecked {
997             _balances[id][from] = fromBalance - amount;
998         }
999 
1000         emit TransferSingle(operator, from, address(0), id, amount);
1001 
1002         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1003     }
1004 
1005     /**
1006      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1007      *
1008      * Requirements:
1009      *
1010      * - `ids` and `amounts` must have the same length.
1011      */
1012     function _burnBatch(
1013         address from,
1014         uint256[] memory ids,
1015         uint256[] memory amounts
1016     ) internal virtual {
1017         require(from != address(0), "ERC1155: burn from the zero address");
1018         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1019 
1020         address operator = _msgSender();
1021 
1022         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1023 
1024         for (uint256 i = 0; i < ids.length; i++) {
1025             uint256 id = ids[i];
1026             uint256 amount = amounts[i];
1027 
1028             uint256 fromBalance = _balances[id][from];
1029             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1030             unchecked {
1031                 _balances[id][from] = fromBalance - amount;
1032             }
1033         }
1034 
1035         emit TransferBatch(operator, from, address(0), ids, amounts);
1036 
1037         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1038     }
1039 
1040     /**
1041      * @dev Approve `operator` to operate on all of `owner` tokens
1042      *
1043      * Emits a {ApprovalForAll} event.
1044      */
1045     function _setApprovalForAll(
1046         address owner,
1047         address operator,
1048         bool approved
1049     ) internal virtual {
1050         require(owner != operator, "ERC1155: setting approval status for self");
1051         _operatorApprovals[owner][operator] = approved;
1052         emit ApprovalForAll(owner, operator, approved);
1053     }
1054 
1055     /**
1056      * @dev Hook that is called before any token transfer. This includes minting
1057      * and burning, as well as batched variants.
1058      *
1059      * The same hook is called on both single and batched variants. For single
1060      * transfers, the length of the `id` and `amount` arrays will be 1.
1061      *
1062      * Calling conditions (for each `id` and `amount` pair):
1063      *
1064      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1065      * of token type `id` will be  transferred to `to`.
1066      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1067      * for `to`.
1068      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1069      * will be burned.
1070      * - `from` and `to` are never both zero.
1071      * - `ids` and `amounts` have the same, non-zero length.
1072      *
1073      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1074      */
1075     function _beforeTokenTransfer(
1076         address operator,
1077         address from,
1078         address to,
1079         uint256[] memory ids,
1080         uint256[] memory amounts,
1081         bytes memory data
1082     ) internal virtual {}
1083 
1084     /**
1085      * @dev Hook that is called after any token transfer. This includes minting
1086      * and burning, as well as batched variants.
1087      *
1088      * The same hook is called on both single and batched variants. For single
1089      * transfers, the length of the `id` and `amount` arrays will be 1.
1090      *
1091      * Calling conditions (for each `id` and `amount` pair):
1092      *
1093      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1094      * of token type `id` will be  transferred to `to`.
1095      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1096      * for `to`.
1097      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1098      * will be burned.
1099      * - `from` and `to` are never both zero.
1100      * - `ids` and `amounts` have the same, non-zero length.
1101      *
1102      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1103      */
1104     function _afterTokenTransfer(
1105         address operator,
1106         address from,
1107         address to,
1108         uint256[] memory ids,
1109         uint256[] memory amounts,
1110         bytes memory data
1111     ) internal virtual {}
1112 
1113     function _doSafeTransferAcceptanceCheck(
1114         address operator,
1115         address from,
1116         address to,
1117         uint256 id,
1118         uint256 amount,
1119         bytes memory data
1120     ) private {
1121         if (to.isContract()) {
1122             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1123                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1124                     revert("ERC1155: ERC1155Receiver rejected tokens");
1125                 }
1126             } catch Error(string memory reason) {
1127                 revert(reason);
1128             } catch {
1129                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1130             }
1131         }
1132     }
1133 
1134     function _doSafeBatchTransferAcceptanceCheck(
1135         address operator,
1136         address from,
1137         address to,
1138         uint256[] memory ids,
1139         uint256[] memory amounts,
1140         bytes memory data
1141     ) private {
1142         if (to.isContract()) {
1143             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1144                 bytes4 response
1145             ) {
1146                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1147                     revert("ERC1155: ERC1155Receiver rejected tokens");
1148                 }
1149             } catch Error(string memory reason) {
1150                 revert(reason);
1151             } catch {
1152                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1153             }
1154         }
1155     }
1156 
1157     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1158         uint256[] memory array = new uint256[](1);
1159         array[0] = element;
1160 
1161         return array;
1162     }
1163 }
1164 
1165 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1166 
1167 
1168 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 
1173 /**
1174  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1175  * own tokens and those that they have been approved to use.
1176  *
1177  * _Available since v3.1._
1178  */
1179 abstract contract ERC1155Burnable is ERC1155 {
1180     function burn(
1181         address account,
1182         uint256 id,
1183         uint256 value
1184     ) public virtual {
1185         require(
1186             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1187             "ERC1155: caller is not owner nor approved"
1188         );
1189 
1190         _burn(account, id, value);
1191     }
1192 
1193     function burnBatch(
1194         address account,
1195         uint256[] memory ids,
1196         uint256[] memory values
1197     ) public virtual {
1198         require(
1199             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1200             "ERC1155: caller is not owner nor approved"
1201         );
1202 
1203         _burnBatch(account, ids, values);
1204     }
1205 }
1206 
1207 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1208 
1209 
1210 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 /**
1216  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1217  *
1218  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1219  * clearly identified. Note: While a totalSupply of 1 might mean the
1220  * corresponding is an NFT, there is no guarantees that no other token with the
1221  * same id are not going to be minted.
1222  */
1223 abstract contract ERC1155Supply is ERC1155 {
1224     mapping(uint256 => uint256) private _totalSupply;
1225 
1226     /**
1227      * @dev Total amount of tokens in with a given id.
1228      */
1229     function totalSupply(uint256 id) public view virtual returns (uint256) {
1230         return _totalSupply[id];
1231     }
1232 
1233     /**
1234      * @dev Indicates whether any token exist with a given id, or not.
1235      */
1236     function exists(uint256 id) public view virtual returns (bool) {
1237         return ERC1155Supply.totalSupply(id) > 0;
1238     }
1239 
1240     /**
1241      * @dev See {ERC1155-_beforeTokenTransfer}.
1242      */
1243     function _beforeTokenTransfer(
1244         address operator,
1245         address from,
1246         address to,
1247         uint256[] memory ids,
1248         uint256[] memory amounts,
1249         bytes memory data
1250     ) internal virtual override {
1251         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1252 
1253         if (from == address(0)) {
1254             for (uint256 i = 0; i < ids.length; ++i) {
1255                 _totalSupply[ids[i]] += amounts[i];
1256             }
1257         }
1258 
1259         if (to == address(0)) {
1260             for (uint256 i = 0; i < ids.length; ++i) {
1261                 uint256 id = ids[i];
1262                 uint256 amount = amounts[i];
1263                 uint256 supply = _totalSupply[id];
1264                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1265                 unchecked {
1266                     _totalSupply[id] = supply - amount;
1267                 }
1268             }
1269         }
1270     }
1271 }
1272 
1273 // File: @openzeppelin/contracts/access/Ownable.sol
1274 
1275 
1276 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1277 
1278 pragma solidity ^0.8.0;
1279 
1280 
1281 /**
1282  * @dev Contract module which provides a basic access control mechanism, where
1283  * there is an account (an owner) that can be granted exclusive access to
1284  * specific functions.
1285  *
1286  * By default, the owner account will be the one that deploys the contract. This
1287  * can later be changed with {transferOwnership}.
1288  *
1289  * This module is used through inheritance. It will make available the modifier
1290  * `onlyOwner`, which can be applied to your functions to restrict their use to
1291  * the owner.
1292  */
1293 abstract contract Ownable is Context {
1294     address private _owner;
1295 
1296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1297 
1298     /**
1299      * @dev Initializes the contract setting the deployer as the initial owner.
1300      */
1301     constructor() {
1302         _transferOwnership(_msgSender());
1303     }
1304 
1305     /**
1306      * @dev Returns the address of the current owner.
1307      */
1308     function owner() public view virtual returns (address) {
1309         return _owner;
1310     }
1311 
1312     /**
1313      * @dev Throws if called by any account other than the owner.
1314      */
1315     modifier onlyOwner() {
1316         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1317         _;
1318     }
1319 
1320     /**
1321      * @dev Leaves the contract without owner. It will not be possible to call
1322      * `onlyOwner` functions anymore. Can only be called by the current owner.
1323      *
1324      * NOTE: Renouncing ownership will leave the contract without an owner,
1325      * thereby removing any functionality that is only available to the owner.
1326      */
1327     function renounceOwnership() public virtual onlyOwner {
1328         _transferOwnership(address(0));
1329     }
1330 
1331     /**
1332      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1333      * Can only be called by the current owner.
1334      */
1335     function transferOwnership(address newOwner) public virtual onlyOwner {
1336         require(newOwner != address(0), "Ownable: new owner is the zero address");
1337         _transferOwnership(newOwner);
1338     }
1339 
1340     /**
1341      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1342      * Internal function without access restriction.
1343      */
1344     function _transferOwnership(address newOwner) internal virtual {
1345         address oldOwner = _owner;
1346         _owner = newOwner;
1347         emit OwnershipTransferred(oldOwner, newOwner);
1348     }
1349 }
1350 
1351 // File: @openzeppelin/contracts/utils/Strings.sol
1352 
1353 
1354 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1355 
1356 pragma solidity ^0.8.0;
1357 
1358 /**
1359  * @dev String operations.
1360  */
1361 library Strings {
1362     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1363 
1364     /**
1365      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1366      */
1367     function toString(uint256 value) internal pure returns (string memory) {
1368         // Inspired by OraclizeAPI's implementation - MIT licence
1369         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1370 
1371         if (value == 0) {
1372             return "0";
1373         }
1374         uint256 temp = value;
1375         uint256 digits;
1376         while (temp != 0) {
1377             digits++;
1378             temp /= 10;
1379         }
1380         bytes memory buffer = new bytes(digits);
1381         while (value != 0) {
1382             digits -= 1;
1383             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1384             value /= 10;
1385         }
1386         return string(buffer);
1387     }
1388 
1389     /**
1390      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1391      */
1392     function toHexString(uint256 value) internal pure returns (string memory) {
1393         if (value == 0) {
1394             return "0x00";
1395         }
1396         uint256 temp = value;
1397         uint256 length = 0;
1398         while (temp != 0) {
1399             length++;
1400             temp >>= 8;
1401         }
1402         return toHexString(value, length);
1403     }
1404 
1405     /**
1406      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1407      */
1408     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1409         bytes memory buffer = new bytes(2 * length + 2);
1410         buffer[0] = "0";
1411         buffer[1] = "x";
1412         for (uint256 i = 2 * length + 1; i > 1; --i) {
1413             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1414             value >>= 4;
1415         }
1416         require(value == 0, "Strings: hex length insufficient");
1417         return string(buffer);
1418     }
1419 }
1420 
1421 // File: contracts/MysteryShells.sol
1422 
1423 
1424 
1425 pragma solidity ^0.8.0;
1426 
1427 
1428 
1429 
1430 
1431 
1432 
1433 
1434 //Mystery Shells by Cyber Turtles
1435 //Developed by Rosie - @RosieX_eth
1436 
1437 contract MysteryShells is ERC1155, ERC1155Supply, ERC1155Burnable, Ownable, ReentrancyGuard {
1438     string public name_;
1439     string public symbol_; 
1440     string public metadataURI_;
1441 
1442     constructor(string memory _name, string memory _symbol, string memory _uri) ERC1155(_uri) {
1443         name_ = _name;
1444         symbol_ = _symbol;
1445         metadataURI_ = _uri;
1446     } 
1447 
1448     uint256 public publicStartTime = 1652652000;
1449     uint256 public publicEndTime = 1652824800;
1450     uint256 public allowlistStartTime = 1652824800;
1451     uint256 public allowlistEndTime = 1652911200;
1452     uint256 public mShellPrice = 0.02 ether;
1453     uint256 public maxTxn = 25;
1454 
1455     bool public paused = true;
1456     bytes32 public allowlistMerkleRoot;
1457     mapping(address => bool) public allowlistClaimed;
1458 
1459     modifier isPublicOpen
1460     {
1461         require(block.timestamp > publicStartTime && block.timestamp < publicEndTime, "Mint window is closed!");
1462         _;
1463     }
1464 
1465     modifier isAllowlistOpen
1466     {
1467         require(block.timestamp > allowlistStartTime && block.timestamp < allowlistEndTime, "Mint window is closed!");
1468         _;
1469     }
1470 
1471     function mintShell(uint256 amount) external payable isPublicOpen {
1472         require(!paused, "Mint is paused");
1473         require(amount > 0 && amount < maxTxn + 1, "Mint amount incorrect");
1474         require(msg.value >= amount * mShellPrice, "Incorrect ETH amount");
1475 
1476         _mint(msg.sender, 0, amount, "");
1477     }
1478 
1479     function freeMint(bytes32[] calldata _merkleProof) external isAllowlistOpen {
1480         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1481         require(!paused, "Mint is paused");
1482         require(MerkleProof.verify(_merkleProof, allowlistMerkleRoot, leaf), "Proof not on allowlist");
1483         require(!allowlistClaimed[msg.sender], "Already claimed");
1484 
1485         allowlistClaimed[msg.sender] = true;
1486         _mint(msg.sender, 0, 1, "");
1487     }
1488 
1489     //VIEWS
1490     function uri(uint256 _id) public view override returns (string memory) {
1491             require(totalSupply(_id) > 0, "URI: nonexistent token");
1492             
1493             return string(abi.encodePacked(metadataURI_,Strings.toString(_id)));
1494     } 
1495 
1496     function name() public view returns (string memory) {
1497         return name_;
1498     }
1499 
1500     function symbol() public view returns (string memory) {
1501         return symbol_;
1502     }  
1503 
1504     //ADMIN FUNCTIONS
1505     function setBaseURI(string memory baseURI) external onlyOwner{
1506         metadataURI_ = baseURI;
1507     }
1508 
1509     function setPrice(uint256 price) external onlyOwner {
1510         mShellPrice = price * 1 ether;
1511     }
1512 
1513     function setPaused(bool paused_) external onlyOwner{
1514         paused = paused_;
1515     }
1516 
1517     function setPublicSaleTime(uint256 start, uint256 end) external onlyOwner{
1518         publicStartTime = start;
1519         publicEndTime = end;
1520     }
1521 
1522     function setAllowlistSaleTime(uint256 start, uint256 end) external onlyOwner{
1523         allowlistStartTime = start;
1524         allowlistEndTime = end;
1525     }
1526 
1527     function setMaxTxn(uint256 max) external onlyOwner{
1528         maxTxn = max;
1529     }
1530     
1531     function mint(address account, uint256 id, uint256 amount) external onlyOwner {
1532         _mint(account, id, amount, "");
1533     }   
1534 
1535     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) external onlyOwner {
1536         _mintBatch(to,ids,amounts,data);
1537     }
1538 
1539     function withdrawMoney() external onlyOwner nonReentrant {
1540         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1541         require(success, "Transfer failed.");
1542     }
1543 
1544     //OVERRIDES
1545     function _mint(
1546         address account,
1547         uint256 id,
1548         uint256 amount,
1549         bytes memory data
1550     ) internal virtual override{
1551         super._mint(account, id, amount, data);
1552     }
1553 
1554     function _mintBatch(
1555         address to,
1556         uint256[] memory ids,
1557         uint256[] memory amounts,
1558         bytes memory data
1559     ) internal virtual override {
1560         super._mintBatch(to, ids, amounts, data);
1561     }
1562 
1563     function _burn(
1564         address account,
1565         uint256 id,
1566         uint256 amount
1567     ) internal virtual override{
1568         super._burn(account, id, amount);
1569     }
1570 
1571     function _burnBatch(
1572         address account,
1573         uint256[] memory ids,
1574         uint256[] memory amounts
1575     ) internal virtual override {
1576         super._burnBatch(account, ids, amounts);
1577     }  
1578 
1579     function _beforeTokenTransfer(
1580         address operator,
1581         address from,
1582         address to,
1583         uint256[] memory ids,
1584         uint256[] memory amounts,
1585         bytes memory data
1586     ) internal virtual override(ERC1155, ERC1155Supply) {
1587         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1588     }  
1589 
1590     function supportsInterface(bytes4 interfaceId) 
1591         public 
1592         view 
1593         virtual 
1594         override
1595         (ERC1155) returns (bool) {
1596         return super.supportsInterface(interfaceId);
1597     }
1598 }