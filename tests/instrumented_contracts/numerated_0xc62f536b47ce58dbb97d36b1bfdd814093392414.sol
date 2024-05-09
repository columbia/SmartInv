1 // SPDX-License-Identifier: MIT
2 
3 /**
4  _____                     _               ____               
5 |  ___|__  _   _ _ __   __| | ___ _ __ ___|  _ \ __ _ ___ ___ 
6 | |_ / _ \| | | | '_ \ / _` |/ _ \ '__/ __| |_) / _` / __/ __|
7 |  _| (_) | |_| | | | | (_| |  __/ |  \__ \  __/ (_| \__ \__ \
8 |_|  \___/ \__,_|_| |_|\__,_|\___|_|  |___/_|   \__,_|___/___/
9 
10 */
11 
12 
13 pragma solidity ^0.8.0;
14 /**
15  * @dev These functions deal with verification of Merkle Trees proofs.
16  *
17  * The proofs can be generated using the JavaScript library
18  * https://github.com/miguelmota/merkletreejs[merkletreejs].
19  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
20  *
21  * See `test/utils/cryptography/MerkleProof.test.js` fo
22 r some examples.
23  *
24  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
25  * hashing, or use a hash function other than keccak256 for hashing leaves.
26  * This is because the concatenation of a sorted pair of internal nodes in
27  * the merkle tree could be reinterpreted as a leaf value.
28  */
29 
30 library MerkleProof {
31     /**
32      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
33      * defined by `root`. For this, a `proof` must be provided, containing
34      * sibling hashes on the branch from the leaf to the root of the tree. Each
35      * pair of leaves and each pair of pre-images are assumed to be sorted.
36      */
37     function verify(
38         bytes32[] memory proof,
39         bytes32 root,
40         bytes32 leaf
41     ) internal pure returns (bool) {
42         return processProof(proof, leaf) == root;
43     }
44 
45     /**
46      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
47      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
48      * hash matches the root of the tree. When processing the proof, the pairs
49      * of leafs & pre-images are assumed to be sorted.
50      *
51      * _Available since v4.4._
52      */
53     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
54         bytes32 computedHash = leaf;
55         for (uint256 i = 0; i < proof.length; i++) {
56             bytes32 proofElement = proof[i];
57             if (computedHash <= proofElement) {
58                 // Hash(current computed hash + current element of the proof)
59                 computedHash = _efficientHash(computedHash, proofElement);
60             } else {
61                 // Hash(current element of the proof + current computed hash)
62                 computedHash = _efficientHash(proofElement, computedHash);
63             }
64         }
65         return computedHash;
66     }
67 
68     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
69         assembly {
70             mstore(0x00, a)
71             mstore(0x20, b)
72             value := keccak256(0x00, 0x40)
73         }
74     }
75 }
76 
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _transferOwnership(address(0));
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _transferOwnership(newOwner);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Internal function without access restriction.
169      */
170     function _transferOwnership(address newOwner) internal virtual {
171         address oldOwner = _owner;
172         _owner = newOwner;
173         emit OwnershipTransferred(oldOwner, newOwner);
174     }
175 }
176 
177 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
178 
179 
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      */
204     function isContract(address account) internal view returns (bool) {
205         // This method relies on extcodesize, which returns 0 for contracts in
206         // construction, since the code is only stored at the end of the
207         // constructor execution.
208 
209         uint256 size;
210         assembly {
211             size := extcodesize(account)
212         }
213         return size > 0;
214     }
215 
216     /**
217      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
218      * `recipient`, forwarding all available gas and reverting on errors.
219      *
220      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
221      * of certain opcodes, possibly making contracts go over the 2300 gas limit
222      * imposed by `transfer`, making them unable to receive funds via
223      * `transfer`. {sendValue} removes this limitation.
224      *
225      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
226      *
227      * IMPORTANT: because control is transferred to `recipient`, care must be
228      * taken to not create reentrancy vulnerabilities. Consider using
229      * {ReentrancyGuard} or the
230      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
231      */
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(address(this).balance >= amount, "Address: insufficient balance");
234 
235         (bool success, ) = recipient.call{value: amount}("");
236         require(success, "Address: unable to send value, recipient may have reverted");
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain `call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
263      * `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, 0, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but also transferring `value` wei to `target`.
278      *
279      * Requirements:
280      *
281      * - the calling contract must have an ETH balance of at least `value`.
282      * - the called Solidity function must be `payable`.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(
287         address target,
288         bytes memory data,
289         uint256 value
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
296      * with `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         require(address(this).balance >= value, "Address: insufficient balance for call");
307         require(isContract(target), "Address: call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.call{value: value}(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
320         return functionStaticCall(target, data, "Address: low-level static call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal view returns (bytes memory) {
334         require(isContract(target), "Address: static call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.staticcall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(isContract(target), "Address: delegate call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.delegatecall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
369      * revert reason using the provided one.
370      *
371      * _Available since v4.3._
372      */
373     function verifyCallResult(
374         bool success,
375         bytes memory returndata,
376         string memory errorMessage
377     ) internal pure returns (bytes memory) {
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
397 
398 
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @dev Interface of the ERC165 standard, as defined in the
404  * https://eips.ethereum.org/EIPS/eip-165[EIP].
405  *
406  * Implementers can declare support of contract interfaces, which can then be
407  * queried by others ({ERC165Checker}).
408  *
409  * For an implementation, see {ERC165}.
410  */
411 interface IERC165 {
412     /**
413      * @dev Returns true if this contract implements the interface defined by
414      * `interfaceId`. See the corresponding
415      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
416      * to learn more about how these ids are created.
417      *
418      * This function call must use less than 30 000 gas.
419      */
420     function supportsInterface(bytes4 interfaceId) external view returns (bool);
421 }
422 
423 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
424 
425 
426 
427 pragma solidity ^0.8.0;
428 
429 
430 /**
431  * @dev Implementation of the {IERC165} interface.
432  *
433  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
434  * for the additional interface id that will be supported. For example:
435  *
436  * ```solidity
437  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
438  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
439  * }
440  * ```
441  *
442  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
443  */
444 abstract contract ERC165 is IERC165 {
445     /**
446      * @dev See {IERC165-supportsInterface}.
447      */
448     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449         return interfaceId == type(IERC165).interfaceId;
450     }
451 }
452 
453 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
454 
455 
456 
457 pragma solidity ^0.8.0;
458 
459 
460 /**
461  * @dev _Available since v3.1._
462  */
463 interface IERC1155Receiver is IERC165 {
464     /**
465         @dev Handles the receipt of a single ERC1155 token type. This function is
466         called at the end of a `safeTransferFrom` after the balance has been updated.
467         To accept the transfer, this must return
468         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
469         (i.e. 0xf23a6e61, or its own function selector).
470         @param operator The address which initiated the transfer (i.e. msg.sender)
471         @param from The address which previously owned the token
472         @param id The ID of the token being transferred
473         @param value The amount of tokens being transferred
474         @param data Additional data with no specified format
475         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
476     */
477     function onERC1155Received(
478         address operator,
479         address from,
480         uint256 id,
481         uint256 value,
482         bytes calldata data
483     ) external returns (bytes4);
484 
485     /**
486         @dev Handles the receipt of a multiple ERC1155 token types. This function
487         is called at the end of a `safeBatchTransferFrom` after the balances have
488         been updated. To accept the transfer(s), this must return
489         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
490         (i.e. 0xbc197c81, or its own function selector).
491         @param operator The address which initiated the batch transfer (i.e. msg.sender)
492         @param from The address which previously owned the token
493         @param ids An array containing ids of each token being transferred (order and length must match values array)
494         @param values An array containing amounts of each token being transferred (order and length must match ids array)
495         @param data Additional data with no specified format
496         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
497     */
498     function onERC1155BatchReceived(
499         address operator,
500         address from,
501         uint256[] calldata ids,
502         uint256[] calldata values,
503         bytes calldata data
504     ) external returns (bytes4);
505 }
506 
507 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
508 
509 
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @dev Required interface of an ERC1155 compliant contract, as defined in the
516  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
517  *
518  * _Available since v3.1._
519  */
520 interface IERC1155 is IERC165 {
521     /**
522      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
523      */
524     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
525 
526     /**
527      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
528      * transfers.
529      */
530     event TransferBatch(
531         address indexed operator,
532         address indexed from,
533         address indexed to,
534         uint256[] ids,
535         uint256[] values
536     );
537 
538     /**
539      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
540      * `approved`.
541      */
542     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
543 
544     /**
545      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
546      *
547      * If an {URI} event was emitted for `id`, the standard
548      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
549      * returned by {IERC1155MetadataURI-uri}.
550      */
551     event URI(string value, uint256 indexed id);
552 
553     /**
554      * @dev Returns the amount of tokens of token type `id` owned by `account`.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      */
560     function balanceOf(address account, uint256 id) external view returns (uint256);
561 
562     /**
563      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
564      *
565      * Requirements:
566      *
567      * - `accounts` and `ids` must have the same length.
568      */
569     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
570         external
571         view
572         returns (uint256[] memory);
573 
574     /**
575      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
576      *
577      * Emits an {ApprovalForAll} event.
578      *
579      * Requirements:
580      *
581      * - `operator` cannot be the caller.
582      */
583     function setApprovalForAll(address operator, bool approved) external;
584 
585     /**
586      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
587      *
588      * See {setApprovalForAll}.
589      */
590     function isApprovedForAll(address account, address operator) external view returns (bool);
591 
592     /**
593      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
594      *
595      * Emits a {TransferSingle} event.
596      *
597      * Requirements:
598      *
599      * - `to` cannot be the zero address.
600      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
601      * - `from` must have a balance of tokens of type `id` of at least `amount`.
602      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
603      * acceptance magic value.
604      */
605     function safeTransferFrom(
606         address from,
607         address to,
608         uint256 id,
609         uint256 amount,
610         bytes calldata data
611     ) external;
612 
613     /**
614      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
615      *
616      * Emits a {TransferBatch} event.
617      *
618      * Requirements:
619      *
620      * - `ids` and `amounts` must have the same length.
621      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
622      * acceptance magic value.
623      */
624     function safeBatchTransferFrom(
625         address from,
626         address to,
627         uint256[] calldata ids,
628         uint256[] calldata amounts,
629         bytes calldata data
630     ) external;
631 }
632 
633 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
634 
635 
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
642  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
643  *
644  * _Available since v3.1._
645  */
646 interface IERC1155MetadataURI is IERC1155 {
647     /**
648      * @dev Returns the URI for token type `id`.
649      *
650      * If the `\{id\}` substring is present in the URI, it must be replaced by
651      * clients with the actual token type ID.
652      */
653     function uri(uint256 id) external view returns (string memory);
654 }
655 
656 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
657 
658 
659 
660 pragma solidity ^0.8.0;
661 
662 
663 
664 
665 
666 
667 
668 /**
669  * @dev Implementation of the basic standard multi-token.
670  * See https://eips.ethereum.org/EIPS/eip-1155
671  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
672  *
673  * _Available since v3.1._
674  */
675 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
676     using Address for address;
677 
678     // Mapping from token ID to account balances
679     mapping(uint256 => mapping(address => uint256)) private _balances;
680 
681     // Mapping from account to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683 
684     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
685     string private _uri;
686 
687     /**
688      * @dev See {_setURI}.
689      */
690     constructor(string memory uri_) {
691         _setURI(uri_);
692     }
693 
694     /**
695      * @dev See {IERC165-supportsInterface}.
696      */
697     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
698         return
699             interfaceId == type(IERC1155).interfaceId ||
700             interfaceId == type(IERC1155MetadataURI).interfaceId ||
701             super.supportsInterface(interfaceId);
702     }
703 
704     /**
705      * @dev See {IERC1155MetadataURI-uri}.
706      *
707      * This implementation returns the same URI for *all* token types. It relies
708      * on the token type ID substitution mechanism
709      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
710      *
711      * Clients calling this function must replace the `\{id\}` substring with the
712      * actual token type ID.
713      */
714     function uri(uint256) public view virtual override returns (string memory) {
715         return _uri;
716     }
717 
718     /**
719      * @dev See {IERC1155-balanceOf}.
720      *
721      * Requirements:
722      *
723      * - `account` cannot be the zero address.
724      */
725     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
726         require(account != address(0), "ERC1155: balance query for the zero address");
727         return _balances[id][account];
728     }
729 
730     /**
731      * @dev See {IERC1155-balanceOfBatch}.
732      *
733      * Requirements:
734      *
735      * - `accounts` and `ids` must have the same length.
736      */
737     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
738         public
739         view
740         virtual
741         override
742         returns (uint256[] memory)
743     {
744         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
745 
746         uint256[] memory batchBalances = new uint256[](accounts.length);
747 
748         for (uint256 i = 0; i < accounts.length; ++i) {
749             batchBalances[i] = balanceOf(accounts[i], ids[i]);
750         }
751 
752         return batchBalances;
753     }
754 
755     /**
756      * @dev See {IERC1155-setApprovalForAll}.
757      */
758     function setApprovalForAll(address operator, bool approved) public virtual override {
759         _setApprovalForAll(_msgSender(), operator, approved);
760     }
761 
762     /**
763      * @dev See {IERC1155-isApprovedForAll}.
764      */
765     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
766         return _operatorApprovals[account][operator];
767     }
768 
769     /**
770      * @dev See {IERC1155-safeTransferFrom}.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 id,
776         uint256 amount,
777         bytes memory data
778     ) public virtual override {
779         require(
780             from == _msgSender() || isApprovedForAll(from, _msgSender()),
781             "ERC1155: caller is not owner nor approved"
782         );
783         _safeTransferFrom(from, to, id, amount, data);
784     }
785 
786     /**
787      * @dev See {IERC1155-safeBatchTransferFrom}.
788      */
789     function safeBatchTransferFrom(
790         address from,
791         address to,
792         uint256[] memory ids,
793         uint256[] memory amounts,
794         bytes memory data
795     ) public virtual override {
796         require(
797             from == _msgSender() || isApprovedForAll(from, _msgSender()),
798             "ERC1155: transfer caller is not owner nor approved"
799         );
800         _safeBatchTransferFrom(from, to, ids, amounts, data);
801     }
802 
803     /**
804      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
805      *
806      * Emits a {TransferSingle} event.
807      *
808      * Requirements:
809      *
810      * - `to` cannot be the zero address.
811      * - `from` must have a balance of tokens of type `id` of at least `amount`.
812      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
813      * acceptance magic value.
814      */
815     function _safeTransferFrom(
816         address from,
817         address to,
818         uint256 id,
819         uint256 amount,
820         bytes memory data
821     ) internal virtual {
822         require(to != address(0), "ERC1155: transfer to the zero address");
823 
824         address operator = _msgSender();
825 
826         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
827 
828         uint256 fromBalance = _balances[id][from];
829         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
830         unchecked {
831             _balances[id][from] = fromBalance - amount;
832         }
833         _balances[id][to] += amount;
834 
835         emit TransferSingle(operator, from, to, id, amount);
836 
837         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
838     }
839 
840     /**
841      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
842      *
843      * Emits a {TransferBatch} event.
844      *
845      * Requirements:
846      *
847      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
848      * acceptance magic value.
849      */
850     function _safeBatchTransferFrom(
851         address from,
852         address to,
853         uint256[] memory ids,
854         uint256[] memory amounts,
855         bytes memory data
856     ) internal virtual {
857         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
858         require(to != address(0), "ERC1155: transfer to the zero address");
859 
860         address operator = _msgSender();
861 
862         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
863 
864         for (uint256 i = 0; i < ids.length; ++i) {
865             uint256 id = ids[i];
866             uint256 amount = amounts[i];
867 
868             uint256 fromBalance = _balances[id][from];
869             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
870             unchecked {
871                 _balances[id][from] = fromBalance - amount;
872             }
873             _balances[id][to] += amount;
874         }
875 
876         emit TransferBatch(operator, from, to, ids, amounts);
877 
878         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
879     }
880 
881     /**
882      * @dev Sets a new URI for all token types, by relying on the token type ID
883      * substitution mechanism
884      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
885      *
886      * By this mechanism, any occurrence of the `\{id\}` substring in either the
887      * URI or any of the amounts in the JSON file at said URI will be replaced by
888      * clients with the token type ID.
889      *
890      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
891      * interpreted by clients as
892      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
893      * for token type ID 0x4cce0.
894      *
895      * See {uri}.
896      *
897      * Because these URIs cannot be meaningfully represented by the {URI} event,
898      * this function emits no events.
899      */
900     function _setURI(string memory newuri) internal virtual {
901         _uri = newuri;
902     }
903 
904     /**
905      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
906      *
907      * Emits a {TransferSingle} event.
908      *
909      * Requirements:
910      *
911      * - `to` cannot be the zero address.
912      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
913      * acceptance magic value.
914      */
915     function _mint(
916         address to,
917         uint256 id,
918         uint256 amount,
919         bytes memory data
920     ) internal virtual {
921         require(to != address(0), "ERC1155: mint to the zero address");
922 
923         address operator = _msgSender();
924 
925         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
926 
927         _balances[id][to] += amount;
928         emit TransferSingle(operator, address(0), to, id, amount);
929 
930         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
931     }
932 
933     /**
934      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
935      *
936      * Requirements:
937      *
938      * - `ids` and `amounts` must have the same length.
939      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
940      * acceptance magic value.
941      */
942     function _mintBatch(
943         address to,
944         uint256[] memory ids,
945         uint256[] memory amounts,
946         bytes memory data
947     ) internal virtual {
948         require(to != address(0), "ERC1155: mint to the zero address");
949         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
950 
951         address operator = _msgSender();
952 
953         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
954 
955         for (uint256 i = 0; i < ids.length; i++) {
956             _balances[ids[i]][to] += amounts[i];
957         }
958 
959         emit TransferBatch(operator, address(0), to, ids, amounts);
960 
961         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
962     }
963 
964     /**
965      * @dev Destroys `amount` tokens of token type `id` from `from`
966      *
967      * Requirements:
968      *
969      * - `from` cannot be the zero address.
970      * - `from` must have at least `amount` tokens of token type `id`.
971      */
972     function _burn(
973         address from,
974         uint256 id,
975         uint256 amount
976     ) internal virtual {
977         require(from != address(0), "ERC1155: burn from the zero address");
978 
979         address operator = _msgSender();
980 
981         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
982 
983         uint256 fromBalance = _balances[id][from];
984         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
985         unchecked {
986             _balances[id][from] = fromBalance - amount;
987         }
988 
989         emit TransferSingle(operator, from, address(0), id, amount);
990     }
991 
992     /**
993      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
994      *
995      * Requirements:
996      *
997      * - `ids` and `amounts` must have the same length.
998      */
999     function _burnBatch(
1000         address from,
1001         uint256[] memory ids,
1002         uint256[] memory amounts
1003     ) internal virtual {
1004         require(from != address(0), "ERC1155: burn from the zero address");
1005         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1006 
1007         address operator = _msgSender();
1008 
1009         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1010 
1011         for (uint256 i = 0; i < ids.length; i++) {
1012             uint256 id = ids[i];
1013             uint256 amount = amounts[i];
1014 
1015             uint256 fromBalance = _balances[id][from];
1016             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1017             unchecked {
1018                 _balances[id][from] = fromBalance - amount;
1019             }
1020         }
1021 
1022         emit TransferBatch(operator, from, address(0), ids, amounts);
1023     }
1024 
1025     /**
1026      * @dev Approve `operator` to operate on all of `owner` tokens
1027      *
1028      * Emits a {ApprovalForAll} event.
1029      */
1030     function _setApprovalForAll(
1031         address owner,
1032         address operator,
1033         bool approved
1034     ) internal virtual {
1035         require(owner != operator, "ERC1155: setting approval status for self");
1036         _operatorApprovals[owner][operator] = approved;
1037         emit ApprovalForAll(owner, operator, approved);
1038     }
1039 
1040     /**
1041      * @dev Hook that is called before any token transfer. This includes minting
1042      * and burning, as well as batched variants.
1043      *
1044      * The same hook is called on both single and batched variants. For single
1045      * transfers, the length of the `id` and `amount` arrays will be 1.
1046      *
1047      * Calling conditions (for each `id` and `amount` pair):
1048      *
1049      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1050      * of token type `id` will be  transferred to `to`.
1051      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1052      * for `to`.
1053      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1054      * will be burned.
1055      * - `from` and `to` are never both zero.
1056      * - `ids` and `amounts` have the same, non-zero length.
1057      *
1058      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1059      */
1060     function _beforeTokenTransfer(
1061         address operator,
1062         address from,
1063         address to,
1064         uint256[] memory ids,
1065         uint256[] memory amounts,
1066         bytes memory data
1067     ) internal virtual {}
1068 
1069     function _doSafeTransferAcceptanceCheck(
1070         address operator,
1071         address from,
1072         address to,
1073         uint256 id,
1074         uint256 amount,
1075         bytes memory data
1076     ) private {
1077         if (to.isContract()) {
1078             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1079                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1080                     revert("ERC1155: ERC1155Receiver rejected tokens");
1081                 }
1082             } catch Error(string memory reason) {
1083                 revert(reason);
1084             } catch {
1085                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1086             }
1087         }
1088     }
1089 
1090     function _doSafeBatchTransferAcceptanceCheck(
1091         address operator,
1092         address from,
1093         address to,
1094         uint256[] memory ids,
1095         uint256[] memory amounts,
1096         bytes memory data
1097     ) private {
1098         if (to.isContract()) {
1099             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1100                 bytes4 response
1101             ) {
1102                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1103                     revert("ERC1155: ERC1155Receiver rejected tokens");
1104                 }
1105             } catch Error(string memory reason) {
1106                 revert(reason);
1107             } catch {
1108                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1109             }
1110         }
1111     }
1112 
1113     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1114         uint256[] memory array = new uint256[](1);
1115         array[0] = element;
1116 
1117         return array;
1118     }
1119 }
1120 
1121 pragma solidity ^0.8.0;
1122 
1123 contract FoundersPass is ERC1155, Ownable {
1124     
1125 	uint256 PLATINUM = 0;
1126 	uint256 GOLD = 1;
1127 	uint256 SILVER = 2;
1128 
1129 	string public name = "DANKBOTS Founders Pass";
1130 	string public symbol = "DBFP";
1131 
1132 	mapping( uint => string ) public tokenURI;
1133 	mapping( uint => uint ) public maxSupply;
1134 	mapping( uint => uint ) public totalSupply;
1135 	mapping( uint => bool ) public paused;
1136 	mapping( uint => bytes32 ) public merkleRoot;
1137 	mapping( address => bool ) public claimed;
1138 
1139 	constructor() ERC1155("") {
1140 		maxSupply[ PLATINUM ] = 150;
1141 		maxSupply[ GOLD ] = 500;
1142 		maxSupply[ SILVER ] = 1500;
1143 
1144 		totalSupply[ PLATINUM ] = 0;
1145 		totalSupply[ GOLD ] = 0;
1146 		totalSupply[ SILVER ] = 0;
1147 
1148 		merkleRoot[ PLATINUM ] = 0x6c4d5a5092dad726cab2fd5b1f4b0720f87a42bde0bcd8053786b30331197226;
1149 		merkleRoot[ GOLD ] = 0xed6c5004597908fc4ab0534bf54d52bccfa4432fda29f0da4443ead07f770f51;
1150 		merkleRoot[ SILVER ] = 0x65a8be9fe46cda3439452a46d2fbca79065065b7eb45fb6fd612a010f8c026ff;
1151 
1152 		tokenURI[ PLATINUM ] = "data:application/json;base64,eyJpbWFnZSI6ICJpcGZzOi8vUW1ZeGRLbkJ4eXNSZW5jR0QzcXBwS1NlVUI1M3ZMNDRyWUJLWW9yU3J5NWt4VC9QbGF0aW51bV9Gb3VuZGVycy5tcDQiLCAibmFtZSI6ICJEQU5LQk9UUyBQbGF0aW51bSBGb3VuZGVycyBQYXNzIiwgInRva2VuSWQiOiAwLCAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAibWVtYmVyc2hpcCB0aWVyIiwgInZhbHVlIjogIlBsYXRpbnVtIn0sIHsidHJhaXRfdHlwZSI6ICJhcnRpc3QiLCAidmFsdWUiOiAiQ2VtIFRlemNhbiJ9LCB7InRyYWl0X3R5cGUiOiAibXVzaWMiLCAidmFsdWUiOiAiRE5LQlRTIFRIRU1FIC8vIE1yLiBPaXpvIn1dfQ==";
1153 		tokenURI[ GOLD ] = "data:application/json;base64,eyJpbWFnZSI6ICJpcGZzOi8vUW1ZeGRLbkJ4eXNSZW5jR0QzcXBwS1NlVUI1M3ZMNDRyWUJLWW9yU3J5NWt4VC9Hb2xkX0ZvdW5kZXJzLm1wNCIsICJuYW1lIjogIkRBTktCT1RTIEdvbGQgRm91bmRlcnMgUGFzcyIsICJ0b2tlbklkIjogMSwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1lbWJlcnNoaXAgdGllciIsICJ2YWx1ZSI6ICJHb2xkIn0sIHsidHJhaXRfdHlwZSI6ICJhcnRpc3QiLCAidmFsdWUiOiAiQ2VtIFRlemNhbiJ9LCB7InRyYWl0X3R5cGUiOiAibXVzaWMiLCAidmFsdWUiOiAiRE5LQlRTIEJPUCAvLyBNci4gT2l6byJ9XX0=";
1154 		tokenURI[ SILVER ] = "data:application/json;base64,eyJpbWFnZSI6ICJpcGZzOi8vUW1ZeGRLbkJ4eXNSZW5jR0QzcXBwS1NlVUI1M3ZMNDRyWUJLWW9yU3J5NWt4VC9TaWx2ZXJfRm91bmRlcnMubXA0IiwgIm5hbWUiOiAiREFOS0JPVFMgU2lsdmVyIEZvdW5kZXJzIFBhc3MiLCAidG9rZW5JZCI6IDIsICJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6ICJtZW1iZXJzaGlwIHRpZXIiLCAidmFsdWUiOiAiU2lsdmVyIn0sIHsidHJhaXRfdHlwZSI6ICJhcnRpc3QiLCAidmFsdWUiOiAiQ2VtIFRlemNhbiJ9LCB7InRyYWl0X3R5cGUiOiAibXVzaWMiLCAidmFsdWUiOiAiRE5LQlRTIEdST09WRSAvLyBDb2NvIE1hZ251c3NvbiJ9XX0=";
1155 	}
1156 
1157 	function setTokenURI( uint _id, string memory _uri ) 
1158 	external 
1159 	onlyOwner {
1160 		tokenURI[_id] = _uri;
1161 		emit URI( _uri, _id );
1162 	}
1163 
1164 	function uri( uint _id ) 
1165 	public 
1166 	override
1167 	view 
1168 	returns ( string memory ) {
1169 		return tokenURI[ _id ];
1170 	}
1171 
1172 	function setMaxSupply( uint _id, uint256 _maxSupply ) 
1173 	external 
1174 	onlyOwner {
1175 		maxSupply[ _id ] = _maxSupply;
1176 	}
1177 
1178 	function setPaused( uint _id, bool _paused ) 
1179 	external 
1180 	onlyOwner {
1181 		paused[ _id ] = _paused;
1182 	}
1183 
1184 	function setMerkleRoot( uint _id, bytes32 _root ) 
1185 	external 
1186 	onlyOwner {
1187 		merkleRoot[ _id ] = _root;
1188 	}
1189 
1190 	function mint(address _to, uint _id, uint _amount) 
1191 	external 
1192 	onlyOwner {
1193 		require( _id >= 0, "Invalid token id" );
1194 		require( totalSupply[ _id ] + _amount <= maxSupply[ _id ], "Max mint limit reached!" );
1195 		_mint( _to, _id, _amount, "" );
1196 		totalSupply[ _id ] += _amount;
1197 	}
1198 
1199 	function mintPublic( bytes32[] calldata _merkleProof, uint256 _id ) 
1200 	public 
1201 	payable {
1202 		require( _id >= 0, "Invalid token id" );
1203 		require( ! paused[ _id ], "Cannot mint while paused" );
1204 		require( totalSupply[ _id ] + 1 <= maxSupply[ _id ], "Max mint limit reached!" );
1205 		require( ! claimed[ msg.sender ], "Address has already claimed!" );
1206 
1207 		if ( msg.sender != owner() ) {
1208 			bytes32 leaf = keccak256( abi.encodePacked( msg.sender ) );
1209 			require( MerkleProof.verify( _merkleProof, merkleRoot[ _id ], leaf ), "Invalid proof" );
1210 		}
1211 
1212 		_mint( msg.sender, _id, 1, "" );
1213 		claimed[ msg.sender ] = true;
1214 		totalSupply[ _id ] += 1;
1215 	}
1216 }