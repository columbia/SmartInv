1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/Context.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev Provides information about the current execution context, including the
65  * sender of the transaction and its data. While these are generally available
66  * via msg.sender and msg.data, they should not be accessed in such a direct
67  * manner, since when dealing with meta-transactions the account sending and
68  * paying for execution may not be the actual sender (as far as an application
69  * is concerned).
70  *
71  * This contract is only required for intermediate, library-like contracts.
72  */
73 abstract contract Context {
74     function _msgSender() internal view virtual returns (address) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view virtual returns (bytes calldata) {
79         return msg.data;
80     }
81 }
82 
83 // File: @openzeppelin/contracts/access/Ownable.sol
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 
91 /**
92  * @dev Contract module which provides a basic access control mechanism, where
93  * there is an account (an owner) that can be granted exclusive access to
94  * specific functions.
95  *
96  * By default, the owner account will be the one that deploys the contract. This
97  * can later be changed with {transferOwnership}.
98  *
99  * This module is used through inheritance. It will make available the modifier
100  * `onlyOwner`, which can be applied to your functions to restrict their use to
101  * the owner.
102  */
103 abstract contract Ownable is Context {
104     address private _owner;
105 
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     /**
109      * @dev Initializes the contract setting the deployer as the initial owner.
110      */
111     constructor() {
112         _transferOwnership(_msgSender());
113     }
114 
115     /**
116      * @dev Returns the address of the current owner.
117      */
118     function owner() public view virtual returns (address) {
119         return _owner;
120     }
121 
122     /**
123      * @dev Throws if called by any account other than the owner.
124      */
125     modifier onlyOwner() {
126         require(owner() == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129 
130     /**
131      * @dev Leaves the contract without owner. It will not be possible to call
132      * `onlyOwner` functions anymore. Can only be called by the current owner.
133      *
134      * NOTE: Renouncing ownership will leave the contract without an owner,
135      * thereby removing any functionality that is only available to the owner.
136      */
137     function renounceOwnership() public virtual onlyOwner {
138         _transferOwnership(address(0));
139     }
140 
141     /**
142      * @dev Transfers ownership of the contract to a new account (`newOwner`).
143      * Can only be called by the current owner.
144      */
145     function transferOwnership(address newOwner) public virtual onlyOwner {
146         require(newOwner != address(0), "Ownable: new owner is the zero address");
147         _transferOwnership(newOwner);
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Internal function without access restriction.
153      */
154     function _transferOwnership(address newOwner) internal virtual {
155         address oldOwner = _owner;
156         _owner = newOwner;
157         emit OwnershipTransferred(oldOwner, newOwner);
158     }
159 }
160 
161 // File: @openzeppelin/contracts/utils/Address.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @dev Collection of functions related to the address type
170  */
171 library Address {
172     /**
173      * @dev Returns true if `account` is a contract.
174      *
175      * [IMPORTANT]
176      * ====
177      * It is unsafe to assume that an address for which this function returns
178      * false is an externally-owned account (EOA) and not a contract.
179      *
180      * Among others, `isContract` will return false for the following
181      * types of addresses:
182      *
183      *  - an externally-owned account
184      *  - a contract in construction
185      *  - an address where a contract will be created
186      *  - an address where a contract lived, but was destroyed
187      * ====
188      */
189     function isContract(address account) internal view returns (bool) {
190         // This method relies on extcodesize, which returns 0 for contracts in
191         // construction, since the code is only stored at the end of the
192         // constructor execution.
193 
194         uint256 size;
195         assembly {
196             size := extcodesize(account)
197         }
198         return size > 0;
199     }
200 
201     /**
202      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
203      * `recipient`, forwarding all available gas and reverting on errors.
204      *
205      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
206      * of certain opcodes, possibly making contracts go over the 2300 gas limit
207      * imposed by `transfer`, making them unable to receive funds via
208      * `transfer`. {sendValue} removes this limitation.
209      *
210      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
211      *
212      * IMPORTANT: because control is transferred to `recipient`, care must be
213      * taken to not create reentrancy vulnerabilities. Consider using
214      * {ReentrancyGuard} or the
215      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
216      */
217     function sendValue(address payable recipient, uint256 amount) internal {
218         require(address(this).balance >= amount, "Address: insufficient balance");
219 
220         (bool success, ) = recipient.call{value: amount}("");
221         require(success, "Address: unable to send value, recipient may have reverted");
222     }
223 
224     /**
225      * @dev Performs a Solidity function call using a low level `call`. A
226      * plain `call` is an unsafe replacement for a function call: use this
227      * function instead.
228      *
229      * If `target` reverts with a revert reason, it is bubbled up by this
230      * function (like regular Solidity function calls).
231      *
232      * Returns the raw returned data. To convert to the expected return value,
233      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
234      *
235      * Requirements:
236      *
237      * - `target` must be a contract.
238      * - calling `target` with `data` must not revert.
239      *
240      * _Available since v3.1._
241      */
242     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionCall(target, data, "Address: low-level call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
248      * `errorMessage` as a fallback revert reason when `target` reverts.
249      *
250      * _Available since v3.1._
251      */
252     function functionCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, 0, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but also transferring `value` wei to `target`.
263      *
264      * Requirements:
265      *
266      * - the calling contract must have an ETH balance of at least `value`.
267      * - the called Solidity function must be `payable`.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(
272         address target,
273         bytes memory data,
274         uint256 value
275     ) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
281      * with `errorMessage` as a fallback revert reason when `target` reverts.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(address(this).balance >= value, "Address: insufficient balance for call");
292         require(isContract(target), "Address: call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.call{value: value}(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
305         return functionStaticCall(target, data, "Address: low-level static call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a static call.
311      *
312      * _Available since v3.3._
313      */
314     function functionStaticCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal view returns (bytes memory) {
319         require(isContract(target), "Address: static call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.staticcall(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but performing a delegate call.
328      *
329      * _Available since v3.4._
330      */
331     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
332         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
337      * but performing a delegate call.
338      *
339      * _Available since v3.4._
340      */
341     function functionDelegateCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(isContract(target), "Address: delegate call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.delegatecall(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
354      * revert reason using the provided one.
355      *
356      * _Available since v4.3._
357      */
358     function verifyCallResult(
359         bool success,
360         bytes memory returndata,
361         string memory errorMessage
362     ) internal pure returns (bytes memory) {
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 assembly {
371                     let returndata_size := mload(returndata)
372                     revert(add(32, returndata), returndata_size)
373                 }
374             } else {
375                 revert(errorMessage);
376             }
377         }
378     }
379 }
380 
381 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @dev Interface of the ERC165 standard, as defined in the
390  * https://eips.ethereum.org/EIPS/eip-165[EIP].
391  *
392  * Implementers can declare support of contract interfaces, which can then be
393  * queried by others ({ERC165Checker}).
394  *
395  * For an implementation, see {ERC165}.
396  */
397 interface IERC165 {
398     /**
399      * @dev Returns true if this contract implements the interface defined by
400      * `interfaceId`. See the corresponding
401      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
402      * to learn more about how these ids are created.
403      *
404      * This function call must use less than 30 000 gas.
405      */
406     function supportsInterface(bytes4 interfaceId) external view returns (bool);
407 }
408 
409 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
410 
411 
412 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 
417 /**
418  * @dev Implementation of the {IERC165} interface.
419  *
420  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
421  * for the additional interface id that will be supported. For example:
422  *
423  * ```solidity
424  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
425  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
426  * }
427  * ```
428  *
429  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
430  */
431 abstract contract ERC165 is IERC165 {
432     /**
433      * @dev See {IERC165-supportsInterface}.
434      */
435     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
436         return interfaceId == type(IERC165).interfaceId;
437     }
438 }
439 
440 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
441 
442 
443 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 
448 /**
449  * @dev _Available since v3.1._
450  */
451 interface IERC1155Receiver is IERC165 {
452     /**
453         @dev Handles the receipt of a single ERC1155 token type. This function is
454         called at the end of a `safeTransferFrom` after the balance has been updated.
455         To accept the transfer, this must return
456         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
457         (i.e. 0xf23a6e61, or its own function selector).
458         @param operator The address which initiated the transfer (i.e. msg.sender)
459         @param from The address which previously owned the token
460         @param id The ID of the token being transferred
461         @param value The amount of tokens being transferred
462         @param data Additional data with no specified format
463         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
464     */
465     function onERC1155Received(
466         address operator,
467         address from,
468         uint256 id,
469         uint256 value,
470         bytes calldata data
471     ) external returns (bytes4);
472 
473     /**
474         @dev Handles the receipt of a multiple ERC1155 token types. This function
475         is called at the end of a `safeBatchTransferFrom` after the balances have
476         been updated. To accept the transfer(s), this must return
477         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
478         (i.e. 0xbc197c81, or its own function selector).
479         @param operator The address which initiated the batch transfer (i.e. msg.sender)
480         @param from The address which previously owned the token
481         @param ids An array containing ids of each token being transferred (order and length must match values array)
482         @param values An array containing amounts of each token being transferred (order and length must match ids array)
483         @param data Additional data with no specified format
484         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
485     */
486     function onERC1155BatchReceived(
487         address operator,
488         address from,
489         uint256[] calldata ids,
490         uint256[] calldata values,
491         bytes calldata data
492     ) external returns (bytes4);
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Required interface of an ERC1155 compliant contract, as defined in the
505  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
506  *
507  * _Available since v3.1._
508  */
509 interface IERC1155 is IERC165 {
510     /**
511      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
512      */
513     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
514 
515     /**
516      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
517      * transfers.
518      */
519     event TransferBatch(
520         address indexed operator,
521         address indexed from,
522         address indexed to,
523         uint256[] ids,
524         uint256[] values
525     );
526 
527     /**
528      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
529      * `approved`.
530      */
531     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
532 
533     /**
534      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
535      *
536      * If an {URI} event was emitted for `id`, the standard
537      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
538      * returned by {IERC1155MetadataURI-uri}.
539      */
540     event URI(string value, uint256 indexed id);
541 
542     /**
543      * @dev Returns the amount of tokens of token type `id` owned by `account`.
544      *
545      * Requirements:
546      *
547      * - `account` cannot be the zero address.
548      */
549     function balanceOf(address account, uint256 id) external view returns (uint256);
550 
551     /**
552      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
553      *
554      * Requirements:
555      *
556      * - `accounts` and `ids` must have the same length.
557      */
558     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
559         external
560         view
561         returns (uint256[] memory);
562 
563     /**
564      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
565      *
566      * Emits an {ApprovalForAll} event.
567      *
568      * Requirements:
569      *
570      * - `operator` cannot be the caller.
571      */
572     function setApprovalForAll(address operator, bool approved) external;
573 
574     /**
575      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
576      *
577      * See {setApprovalForAll}.
578      */
579     function isApprovedForAll(address account, address operator) external view returns (bool);
580 
581     /**
582      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
583      *
584      * Emits a {TransferSingle} event.
585      *
586      * Requirements:
587      *
588      * - `to` cannot be the zero address.
589      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
590      * - `from` must have a balance of tokens of type `id` of at least `amount`.
591      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
592      * acceptance magic value.
593      */
594     function safeTransferFrom(
595         address from,
596         address to,
597         uint256 id,
598         uint256 amount,
599         bytes calldata data
600     ) external;
601 
602     /**
603      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
604      *
605      * Emits a {TransferBatch} event.
606      *
607      * Requirements:
608      *
609      * - `ids` and `amounts` must have the same length.
610      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
611      * acceptance magic value.
612      */
613     function safeBatchTransferFrom(
614         address from,
615         address to,
616         uint256[] calldata ids,
617         uint256[] calldata amounts,
618         bytes calldata data
619     ) external;
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
632  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
633  *
634  * _Available since v3.1._
635  */
636 interface IERC1155MetadataURI is IERC1155 {
637     /**
638      * @dev Returns the URI for token type `id`.
639      *
640      * If the `\{id\}` substring is present in the URI, it must be replaced by
641      * clients with the actual token type ID.
642      */
643     function uri(uint256 id) external view returns (string memory);
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
647 
648 
649 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 
654 
655 
656 
657 
658 
659 /**
660  * @dev Implementation of the basic standard multi-token.
661  * See https://eips.ethereum.org/EIPS/eip-1155
662  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
663  *
664  * _Available since v3.1._
665  */
666 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
667     using Address for address;
668 
669     // Mapping from token ID to account balances
670     mapping(uint256 => mapping(address => uint256)) private _balances;
671 
672     // Mapping from account to operator approvals
673     mapping(address => mapping(address => bool)) private _operatorApprovals;
674 
675     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
676     string private _uri;
677 
678     /**
679      * @dev See {_setURI}.
680      */
681     constructor(string memory uri_) {
682         _setURI(uri_);
683     }
684 
685     /**
686      * @dev See {IERC165-supportsInterface}.
687      */
688     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
689         return
690             interfaceId == type(IERC1155).interfaceId ||
691             interfaceId == type(IERC1155MetadataURI).interfaceId ||
692             super.supportsInterface(interfaceId);
693     }
694 
695     /**
696      * @dev See {IERC1155MetadataURI-uri}.
697      *
698      * This implementation returns the same URI for *all* token types. It relies
699      * on the token type ID substitution mechanism
700      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
701      *
702      * Clients calling this function must replace the `\{id\}` substring with the
703      * actual token type ID.
704      */
705     function uri(uint256) public view virtual override returns (string memory) {
706         return _uri;
707     }
708 
709     /**
710      * @dev See {IERC1155-balanceOf}.
711      *
712      * Requirements:
713      *
714      * - `account` cannot be the zero address.
715      */
716     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
717         require(account != address(0), "ERC1155: balance query for the zero address");
718         return _balances[id][account];
719     }
720 
721     /**
722      * @dev See {IERC1155-balanceOfBatch}.
723      *
724      * Requirements:
725      *
726      * - `accounts` and `ids` must have the same length.
727      */
728     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
729         public
730         view
731         virtual
732         override
733         returns (uint256[] memory)
734     {
735         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
736 
737         uint256[] memory batchBalances = new uint256[](accounts.length);
738 
739         for (uint256 i = 0; i < accounts.length; ++i) {
740             batchBalances[i] = balanceOf(accounts[i], ids[i]);
741         }
742 
743         return batchBalances;
744     }
745 
746     /**
747      * @dev See {IERC1155-setApprovalForAll}.
748      */
749     function setApprovalForAll(address operator, bool approved) public virtual override {
750         _setApprovalForAll(_msgSender(), operator, approved);
751     }
752 
753     /**
754      * @dev See {IERC1155-isApprovedForAll}.
755      */
756     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
757         return _operatorApprovals[account][operator];
758     }
759 
760     /**
761      * @dev See {IERC1155-safeTransferFrom}.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 id,
767         uint256 amount,
768         bytes memory data
769     ) public virtual override {
770         require(
771             from == _msgSender() || isApprovedForAll(from, _msgSender()),
772             "ERC1155: caller is not owner nor approved"
773         );
774         _safeTransferFrom(from, to, id, amount, data);
775     }
776 
777     /**
778      * @dev See {IERC1155-safeBatchTransferFrom}.
779      */
780     function safeBatchTransferFrom(
781         address from,
782         address to,
783         uint256[] memory ids,
784         uint256[] memory amounts,
785         bytes memory data
786     ) public virtual override {
787         require(
788             from == _msgSender() || isApprovedForAll(from, _msgSender()),
789             "ERC1155: transfer caller is not owner nor approved"
790         );
791         _safeBatchTransferFrom(from, to, ids, amounts, data);
792     }
793 
794     /**
795      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
796      *
797      * Emits a {TransferSingle} event.
798      *
799      * Requirements:
800      *
801      * - `to` cannot be the zero address.
802      * - `from` must have a balance of tokens of type `id` of at least `amount`.
803      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
804      * acceptance magic value.
805      */
806     function _safeTransferFrom(
807         address from,
808         address to,
809         uint256 id,
810         uint256 amount,
811         bytes memory data
812     ) internal virtual {
813         require(to != address(0), "ERC1155: transfer to the zero address");
814 
815         address operator = _msgSender();
816 
817         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
818 
819         uint256 fromBalance = _balances[id][from];
820         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
821         unchecked {
822             _balances[id][from] = fromBalance - amount;
823         }
824         _balances[id][to] += amount;
825 
826         emit TransferSingle(operator, from, to, id, amount);
827 
828         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
829     }
830 
831     /**
832      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
833      *
834      * Emits a {TransferBatch} event.
835      *
836      * Requirements:
837      *
838      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
839      * acceptance magic value.
840      */
841     function _safeBatchTransferFrom(
842         address from,
843         address to,
844         uint256[] memory ids,
845         uint256[] memory amounts,
846         bytes memory data
847     ) internal virtual {
848         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
849         require(to != address(0), "ERC1155: transfer to the zero address");
850 
851         address operator = _msgSender();
852 
853         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
854 
855         for (uint256 i = 0; i < ids.length; ++i) {
856             uint256 id = ids[i];
857             uint256 amount = amounts[i];
858 
859             uint256 fromBalance = _balances[id][from];
860             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
861             unchecked {
862                 _balances[id][from] = fromBalance - amount;
863             }
864             _balances[id][to] += amount;
865         }
866 
867         emit TransferBatch(operator, from, to, ids, amounts);
868 
869         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
870     }
871 
872     /**
873      * @dev Sets a new URI for all token types, by relying on the token type ID
874      * substitution mechanism
875      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
876      *
877      * By this mechanism, any occurrence of the `\{id\}` substring in either the
878      * URI or any of the amounts in the JSON file at said URI will be replaced by
879      * clients with the token type ID.
880      *
881      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
882      * interpreted by clients as
883      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
884      * for token type ID 0x4cce0.
885      *
886      * See {uri}.
887      *
888      * Because these URIs cannot be meaningfully represented by the {URI} event,
889      * this function emits no events.
890      */
891     function _setURI(string memory newuri) internal virtual {
892         _uri = newuri;
893     }
894 
895     /**
896      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
897      *
898      * Emits a {TransferSingle} event.
899      *
900      * Requirements:
901      *
902      * - `to` cannot be the zero address.
903      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
904      * acceptance magic value.
905      */
906     function _mint(
907         address to,
908         uint256 id,
909         uint256 amount,
910         bytes memory data
911     ) internal virtual {
912         require(to != address(0), "ERC1155: mint to the zero address");
913 
914         address operator = _msgSender();
915 
916         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
917 
918         _balances[id][to] += amount;
919         emit TransferSingle(operator, address(0), to, id, amount);
920 
921         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
922     }
923 
924     /**
925      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
926      *
927      * Requirements:
928      *
929      * - `ids` and `amounts` must have the same length.
930      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
931      * acceptance magic value.
932      */
933     function _mintBatch(
934         address to,
935         uint256[] memory ids,
936         uint256[] memory amounts,
937         bytes memory data
938     ) internal virtual {
939         require(to != address(0), "ERC1155: mint to the zero address");
940         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
941 
942         address operator = _msgSender();
943 
944         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
945 
946         for (uint256 i = 0; i < ids.length; i++) {
947             _balances[ids[i]][to] += amounts[i];
948         }
949 
950         emit TransferBatch(operator, address(0), to, ids, amounts);
951 
952         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
953     }
954 
955     /**
956      * @dev Destroys `amount` tokens of token type `id` from `from`
957      *
958      * Requirements:
959      *
960      * - `from` cannot be the zero address.
961      * - `from` must have at least `amount` tokens of token type `id`.
962      */
963     function _burn(
964         address from,
965         uint256 id,
966         uint256 amount
967     ) internal virtual {
968         require(from != address(0), "ERC1155: burn from the zero address");
969 
970         address operator = _msgSender();
971 
972         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
973 
974         uint256 fromBalance = _balances[id][from];
975         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
976         unchecked {
977             _balances[id][from] = fromBalance - amount;
978         }
979 
980         emit TransferSingle(operator, from, address(0), id, amount);
981     }
982 
983     /**
984      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
985      *
986      * Requirements:
987      *
988      * - `ids` and `amounts` must have the same length.
989      */
990     function _burnBatch(
991         address from,
992         uint256[] memory ids,
993         uint256[] memory amounts
994     ) internal virtual {
995         require(from != address(0), "ERC1155: burn from the zero address");
996         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
997 
998         address operator = _msgSender();
999 
1000         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1001 
1002         for (uint256 i = 0; i < ids.length; i++) {
1003             uint256 id = ids[i];
1004             uint256 amount = amounts[i];
1005 
1006             uint256 fromBalance = _balances[id][from];
1007             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1008             unchecked {
1009                 _balances[id][from] = fromBalance - amount;
1010             }
1011         }
1012 
1013         emit TransferBatch(operator, from, address(0), ids, amounts);
1014     }
1015 
1016     /**
1017      * @dev Approve `operator` to operate on all of `owner` tokens
1018      *
1019      * Emits a {ApprovalForAll} event.
1020      */
1021     function _setApprovalForAll(
1022         address owner,
1023         address operator,
1024         bool approved
1025     ) internal virtual {
1026         require(owner != operator, "ERC1155: setting approval status for self");
1027         _operatorApprovals[owner][operator] = approved;
1028         emit ApprovalForAll(owner, operator, approved);
1029     }
1030 
1031     /**
1032      * @dev Hook that is called before any token transfer. This includes minting
1033      * and burning, as well as batched variants.
1034      *
1035      * The same hook is called on both single and batched variants. For single
1036      * transfers, the length of the `id` and `amount` arrays will be 1.
1037      *
1038      * Calling conditions (for each `id` and `amount` pair):
1039      *
1040      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1041      * of token type `id` will be  transferred to `to`.
1042      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1043      * for `to`.
1044      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1045      * will be burned.
1046      * - `from` and `to` are never both zero.
1047      * - `ids` and `amounts` have the same, non-zero length.
1048      *
1049      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1050      */
1051     function _beforeTokenTransfer(
1052         address operator,
1053         address from,
1054         address to,
1055         uint256[] memory ids,
1056         uint256[] memory amounts,
1057         bytes memory data
1058     ) internal virtual {}
1059 
1060     function _doSafeTransferAcceptanceCheck(
1061         address operator,
1062         address from,
1063         address to,
1064         uint256 id,
1065         uint256 amount,
1066         bytes memory data
1067     ) private {
1068         if (to.isContract()) {
1069             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1070                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1071                     revert("ERC1155: ERC1155Receiver rejected tokens");
1072                 }
1073             } catch Error(string memory reason) {
1074                 revert(reason);
1075             } catch {
1076                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1077             }
1078         }
1079     }
1080 
1081     function _doSafeBatchTransferAcceptanceCheck(
1082         address operator,
1083         address from,
1084         address to,
1085         uint256[] memory ids,
1086         uint256[] memory amounts,
1087         bytes memory data
1088     ) private {
1089         if (to.isContract()) {
1090             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1091                 bytes4 response
1092             ) {
1093                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1094                     revert("ERC1155: ERC1155Receiver rejected tokens");
1095                 }
1096             } catch Error(string memory reason) {
1097                 revert(reason);
1098             } catch {
1099                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1100             }
1101         }
1102     }
1103 
1104     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1105         uint256[] memory array = new uint256[](1);
1106         array[0] = element;
1107 
1108         return array;
1109     }
1110 }
1111 
1112 // File: YuckPass.sol
1113 
1114 
1115 pragma solidity >=0.8.0 <0.9.0;
1116 
1117 
1118 
1119 
1120 library OpenSeaGasFreeListing { 
1121     /**
1122     @notice Returns whether the operator is an OpenSea proxy for the owner, thus
1123     allowing it to list without the token owner paying gas.
1124     @dev ERC{721,1155}.isApprovedForAll should be overriden to also check if
1125     this function returns true.
1126      */
1127     function isApprovedForAll(address owner, address operator) internal view returns (bool) {
1128         ProxyRegistry registry;
1129         assembly {
1130             switch chainid()
1131             case 1 {
1132                 // mainnet
1133                 registry := 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1134             }
1135             case 4 {
1136                 // rinkeby
1137                 registry := 0xf57b2c51ded3a29e6891aba85459d600256cf317
1138             }
1139         }
1140 
1141         return address(registry) != address(0) && address(registry.proxies(owner)) == operator;
1142     }
1143 }
1144 
1145 contract OwnableDelegateProxy {}
1146 
1147 contract ProxyRegistry {
1148     mapping(address => OwnableDelegateProxy) public proxies;
1149 }
1150 
1151 contract YuckPass is ERC1155, Ownable {
1152 
1153   uint public constant YUCKY = 0;
1154   uint public constant GOLD = 1;
1155   uint public constant SILVER = 2;
1156   uint public constant BRONZE = 3;
1157 
1158   uint public YUCKY_MAX_TOKENS = 3;
1159   uint public GOLD_MAX_TOKENS = 330;
1160   uint public SILVER_MAX_TOKENS = 1000;
1161   uint public BRONZE_MAX_TOKENS = 2000;
1162 
1163   uint public YUCKY_NUM_MINITED = 0;
1164   uint public GOLD_NUM_MINITED = 0;
1165   uint public SILVER_NUM_MINITED = 0;
1166   uint public BRONZE_NUM_MINITED = 0;
1167 
1168   uint public MAX_TOKENS = YUCKY_MAX_TOKENS + GOLD_MAX_TOKENS + SILVER_MAX_TOKENS + BRONZE_MAX_TOKENS;
1169   uint public numMinted = 0;
1170 
1171   uint public yuckyPriceWei = 0 ether; // 0
1172   uint public goldPriceWei = 0.25 ether; // 1
1173   uint public silverPriceWei = 0.08 ether; // 2
1174   uint public bronzePriceWei = 0.03 ether; // 3
1175 
1176   // All members of First Buyer whitelist.
1177   bytes32 public firstBuyersMerkleRoot;
1178 
1179   // All members of YuckList whitelist.
1180   bytes32 public yuckListMerkleRoot;
1181 
1182   mapping (address => uint) public sale1NumMinted;
1183   mapping (address => uint) public sale2NumMinted;
1184   mapping (address => uint) public publicNumMinted;
1185 
1186   // Whitelist types (which whitelist is the caller on).
1187   uint public constant FIRST_BUYERS = 1;
1188   uint public constant YUCKLIST = 2;
1189 
1190   // Sale state:
1191   // 0: Closed
1192   // 1: Open to First Buyer whitelist. Each address can mint 1.
1193   // 2: Open to First Buyer + YuckList whitelists. Each address can mint 3.
1194   // 3: Open to Public. Each address can mint 5.
1195   uint256 public saleState = 0;
1196 
1197   string private _contractUri = "https://yuckpass.com/yuckpass/metadata/contract.json";
1198 
1199   string public name = "YuckPass";
1200   string public symbol = "YUCK";
1201 
1202   constructor() public ERC1155("https://yuckpass.com/yuckpass/metadata/tokens/{id}.json") {}
1203 
1204   function mint(uint passType, uint amount) public payable {
1205     require(saleState == 3, "Public mint is not open");
1206     /**
1207     * Sale 3:
1208     * Public. 5 per address. 
1209     */
1210     publicNumMinted[msg.sender] = publicNumMinted[msg.sender] + amount;
1211     require(publicNumMinted[msg.sender] <= 3, "Cannot mint more than 3 per address in this phase");
1212     _internalMint(passType, amount);
1213   }
1214 
1215   function earlyMint(uint passType, uint amount, uint whitelistType, bytes32[] calldata merkleProof) public payable {
1216     require(saleState > 0, "Sale is not open");
1217     if (saleState == 1) {
1218       /**
1219        * Sale 1: 
1220        * First Buyers only. 1 per address.
1221        */
1222       sale1NumMinted[msg.sender] = sale1NumMinted[msg.sender] + amount;
1223       require(sale1NumMinted[msg.sender] == 1, "Cannot mint more than 1 per address in this phase.");
1224       
1225       require(whitelistType == FIRST_BUYERS, "Must use First Buyers whitelist");
1226       verifyMerkle(msg.sender, merkleProof, FIRST_BUYERS);
1227 
1228     } else if (saleState == 2) {
1229       /**
1230        * Sale 2: 
1231        * First Buyers or YuckList. 2 per address.
1232        */
1233       sale2NumMinted[msg.sender] = sale2NumMinted[msg.sender] + amount;
1234       require(sale2NumMinted[msg.sender] <= 2, "Cannot mint more than 2 per address in this phase.");
1235 
1236       verifyMerkle(msg.sender, merkleProof, whitelistType);
1237       
1238     } else {
1239       revert("The early sale is over. Use the public mint function instead.");
1240     }
1241 
1242     _internalMint(passType, amount);
1243   }
1244 
1245   function _internalMint(uint passType, uint amount) internal {
1246     incrementNumMintedTier(passType, amount);
1247     if (passType == GOLD) {
1248       checkPayment(goldPriceWei * amount);
1249     }
1250     else if (passType == SILVER) {
1251       checkPayment(silverPriceWei * amount);
1252     } 
1253     else if (passType == BRONZE) {
1254       checkPayment(bronzePriceWei * amount);
1255     } else {
1256       revert("Invalid pass type");
1257     }
1258     _mint(msg.sender, passType, amount, "");
1259   }
1260 
1261   function ownerMint(uint passType, uint amount) public onlyOwner {
1262     incrementNumMintedTier(passType, amount);
1263     require(passType == YUCKY || passType == GOLD || passType == SILVER || passType == BRONZE, "Invalid passType");
1264     _mint(msg.sender, passType, amount, "");
1265   }
1266 
1267   function incrementNumMintedTier(uint passType, uint amount) internal {
1268     if (passType == YUCKY) {
1269       YUCKY_NUM_MINITED = YUCKY_NUM_MINITED + amount;
1270       require(YUCKY_NUM_MINITED <= YUCKY_MAX_TOKENS, "Minting would exceed yucky max tokens");
1271     }
1272     else if (passType == GOLD) {
1273       GOLD_NUM_MINITED = GOLD_NUM_MINITED + amount;
1274       require(GOLD_NUM_MINITED <= GOLD_MAX_TOKENS, "Minting would exceed gold max tokens");
1275     }
1276     else if (passType == SILVER) {
1277       SILVER_NUM_MINITED = SILVER_NUM_MINITED + amount;
1278       require(SILVER_NUM_MINITED <= SILVER_MAX_TOKENS, "Minting would exceed silver max tokens");
1279     } 
1280     else if (passType == BRONZE) {
1281       BRONZE_NUM_MINITED = BRONZE_NUM_MINITED + amount;
1282       require(BRONZE_NUM_MINITED <= BRONZE_MAX_TOKENS, "Minting would exceed bronze max tokens");
1283     } else {
1284       revert("Invalid pass type");
1285     }
1286     numMinted = numMinted + amount;
1287   }
1288 
1289   function incrementNumMinted(uint amount) internal {
1290     numMinted = numMinted + amount;
1291     require(numMinted <= MAX_TOKENS, "Minting would exceed max tokens");
1292   }
1293 
1294   function verifyMerkle(address addr, bytes32[] calldata proof, uint whitelistType) internal view {
1295     require(isOnWhitelist(addr, proof, whitelistType), "User is not on whitelist");
1296   }
1297 
1298   function isOnWhitelist(address addr, bytes32[] calldata proof, uint whitelistType) public view returns (bool) {
1299     bytes32 root;
1300     if (whitelistType == FIRST_BUYERS) {
1301       root = firstBuyersMerkleRoot;
1302     } else if (whitelistType == YUCKLIST) {
1303       root = yuckListMerkleRoot;
1304     } else {
1305       revert("Invalid whitelistType, must be 1 or 2");
1306     }
1307     bytes32 leaf = keccak256(abi.encodePacked(addr));
1308     return MerkleProof.verify(proof, root, leaf);
1309   }
1310 
1311   function checkPayment(uint amountRequired) internal {
1312     require(msg.value >= amountRequired, "Not enough funds sent");
1313   }
1314 
1315   function setFirstBuyersMerkleRoot(bytes32 newMerkle) public onlyOwner {
1316     firstBuyersMerkleRoot = newMerkle;
1317   }
1318 
1319   function setYuckListMerkleRoot(bytes32 newMerkle) public onlyOwner {
1320     yuckListMerkleRoot = newMerkle;
1321   }
1322 
1323   function setSaleState(uint newState) public onlyOwner {
1324     require(newState >= 0 && newState <= 3, "Invalid state");
1325     saleState = newState;
1326   }
1327 
1328   function withdraw() public onlyOwner {
1329     uint balance = address(this).balance;
1330     payable(msg.sender).transfer(balance);
1331   }
1332 
1333   function setBaseUri(string calldata newUri) public onlyOwner {
1334     _setURI(newUri);
1335   }
1336 
1337   function setContractUri(string calldata newUri) public onlyOwner {
1338     _contractUri = newUri;
1339   }
1340 
1341   function setGoldPriceWei(uint newPrice) public onlyOwner {
1342     goldPriceWei = newPrice;
1343   }
1344 
1345   function setSilverPriceWei(uint newPrice) public onlyOwner {
1346     silverPriceWei = newPrice;
1347   }
1348 
1349   function setBronzePriceWei(uint newPrice) public onlyOwner {
1350     bronzePriceWei = newPrice;
1351   }
1352 
1353   function setBronzeMaxTokens(uint newMax) public onlyOwner {
1354     BRONZE_MAX_TOKENS = newMax;
1355   }
1356 
1357   function setSilverMaxTokens(uint newMax) public onlyOwner {
1358     SILVER_MAX_TOKENS = newMax;
1359   }
1360 
1361   function setGoldMaxTokens(uint newMax) public onlyOwner {
1362     GOLD_MAX_TOKENS = newMax;
1363   }
1364 
1365   function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1366     return OpenSeaGasFreeListing.isApprovedForAll(owner, operator) || super.isApprovedForAll(owner, operator);
1367   }
1368 
1369   function contractURI() public view returns (string memory) {
1370     return _contractUri;
1371   }
1372 }