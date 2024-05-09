1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 /**  
5 
6   _  ___      _           ____               
7  | |/ (_) ___| | __ ____ |  _ \ __ _ ___ ___ 
8  | ' /| |/ __| |/ /|_  / | |_) / _` / __/ __|
9  | . \| | (__|   <  / /  |  __/ (_| \__ \__ \
10  |_|\_\_|\___|_|\_\/___| |_|   \__,_|___/___/
11                                              
12 
13 **/
14 
15 /// @author NFTprest (https://twitter.com/NFTprest)
16 
17 
18 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
19 
20 
21 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev These functions deal with verification of Merkle Trees proofs.
27  *
28  * The proofs can be generated using the JavaScript library
29  * https://github.com/miguelmota/merkletreejs[merkletreejs].
30  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
31  *
32  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
33  *
34  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
35  * hashing, or use a hash function other than keccak256 for hashing leaves.
36  * This is because the concatenation of a sorted pair of internal nodes in
37  * the merkle tree could be reinterpreted as a leaf value.
38  */
39 library MerkleProof {
40     /**
41      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
42      * defined by `root`. For this, a `proof` must be provided, containing
43      * sibling hashes on the branch from the leaf to the root of the tree. Each
44      * pair of leaves and each pair of pre-images are assumed to be sorted.
45      */
46     function verify(
47         bytes32[] memory proof,
48         bytes32 root,
49         bytes32 leaf
50     ) internal pure returns (bool) {
51         return processProof(proof, leaf) == root;
52     }
53 
54     /**
55      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
56      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
57      * hash matches the root of the tree. When processing the proof, the pairs
58      * of leafs & pre-images are assumed to be sorted.
59      *
60      * _Available since v4.4._
61      */
62     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
63         bytes32 computedHash = leaf;
64         for (uint256 i = 0; i < proof.length; i++) {
65             bytes32 proofElement = proof[i];
66             if (computedHash <= proofElement) {
67                 // Hash(current computed hash + current element of the proof)
68                 computedHash = _efficientHash(computedHash, proofElement);
69             } else {
70                 // Hash(current element of the proof + current computed hash)
71                 computedHash = _efficientHash(proofElement, computedHash);
72             }
73         }
74         return computedHash;
75     }
76 
77     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
78         assembly {
79             mstore(0x00, a)
80             mstore(0x20, b)
81             value := keccak256(0x00, 0x40)
82         }
83     }
84 }
85 
86 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Contract module that helps prevent reentrant calls to a function.
95  *
96  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
97  * available, which can be applied to functions to make sure there are no nested
98  * (reentrant) calls to them.
99  *
100  * Note that because there is a single `nonReentrant` guard, functions marked as
101  * `nonReentrant` may not call one another. This can be worked around by making
102  * those functions `private`, and then adding `external` `nonReentrant` entry
103  * points to them.
104  *
105  * TIP: If you would like to learn more about reentrancy and alternative ways
106  * to protect against it, check out our blog post
107  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
108  */
109 abstract contract ReentrancyGuard {
110     // Booleans are more expensive than uint256 or any type that takes up a full
111     // word because each write operation emits an extra SLOAD to first read the
112     // slot's contents, replace the bits taken up by the boolean, and then write
113     // back. This is the compiler's defense against contract upgrades and
114     // pointer aliasing, and it cannot be disabled.
115 
116     // The values being non-zero value makes deployment a bit more expensive,
117     // but in exchange the refund on every call to nonReentrant will be lower in
118     // amount. Since refunds are capped to a percentage of the total
119     // transaction's gas, it is best to keep them low in cases like this one, to
120     // increase the likelihood of the full refund coming into effect.
121     uint256 private constant _NOT_ENTERED = 1;
122     uint256 private constant _ENTERED = 2;
123 
124     uint256 private _status;
125 
126     constructor() {
127         _status = _NOT_ENTERED;
128     }
129 
130     /**
131      * @dev Prevents a contract from calling itself, directly or indirectly.
132      * Calling a `nonReentrant` function from another `nonReentrant`
133      * function is not supported. It is possible to prevent this from happening
134      * by making the `nonReentrant` function external, and making it call a
135      * `private` function that does the actual work.
136      */
137     modifier nonReentrant() {
138         // On the first call to nonReentrant, _notEntered will be true
139         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
140 
141         // Any calls to nonReentrant after this point will fail
142         _status = _ENTERED;
143 
144         _;
145 
146         // By storing the original value once again, a refund is triggered (see
147         // https://eips.ethereum.org/EIPS/eip-2200)
148         _status = _NOT_ENTERED;
149     }
150 }
151 
152 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 abstract contract Context {
170     function _msgSender() internal view virtual returns (address) {
171         return msg.sender;
172     }
173 
174     function _msgData() internal view virtual returns (bytes calldata) {
175         return msg.data;
176     }
177 }
178 
179 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
180 
181 
182 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 
187 /**
188  * @dev Contract module which provides a basic access control mechanism, where
189  * there is an account (an owner) that can be granted exclusive access to
190  * specific functions.
191  *
192  * By default, the owner account will be the one that deploys the contract. This
193  * can later be changed with {transferOwnership}.
194  *
195  * This module is used through inheritance. It will make available the modifier
196  * `onlyOwner`, which can be applied to your functions to restrict their use to
197  * the owner.
198  */
199 abstract contract Ownable is Context {
200     address private _owner;
201 
202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204     /**
205      * @dev Initializes the contract setting the deployer as the initial owner.
206      */
207     constructor() {
208         _transferOwnership(_msgSender());
209     }
210 
211     /**
212      * @dev Returns the address of the current owner.
213      */
214     function owner() public view virtual returns (address) {
215         return _owner;
216     }
217 
218     /**
219      * @dev Throws if called by any account other than the owner.
220      */
221     modifier onlyOwner() {
222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
223         _;
224     }
225 
226     /**
227      * @dev Leaves the contract without owner. It will not be possible to call
228      * `onlyOwner` functions anymore. Can only be called by the current owner.
229      *
230      * NOTE: Renouncing ownership will leave the contract without an owner,
231      * thereby removing any functionality that is only available to the owner.
232      */
233     function renounceOwnership() public virtual onlyOwner {
234         _transferOwnership(address(0));
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         _transferOwnership(newOwner);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Internal function without access restriction.
249      */
250     function _transferOwnership(address newOwner) internal virtual {
251         address oldOwner = _owner;
252         _owner = newOwner;
253         emit OwnershipTransferred(oldOwner, newOwner);
254     }
255 }
256 
257 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
258 
259 
260 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
261 
262 pragma solidity ^0.8.1;
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      *
285      * [IMPORTANT]
286      * ====
287      * You shouldn't rely on `isContract` to protect against flash loan attacks!
288      *
289      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
290      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
291      * constructor.
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies on extcodesize/address.code.length, which returns 0
296         // for contracts in construction, since the code is only stored at the end
297         // of the constructor execution.
298 
299         return account.code.length > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         (bool success, ) = recipient.call{value: amount}("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain `call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value
376     ) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(
387         address target,
388         bytes memory data,
389         uint256 value,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         require(isContract(target), "Address: call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.call{value: value}(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
406         return functionStaticCall(target, data, "Address: low-level static call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal view returns (bytes memory) {
420         require(isContract(target), "Address: static call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.staticcall(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a delegate call.
429      *
430      * _Available since v3.4._
431      */
432     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
433         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal returns (bytes memory) {
447         require(isContract(target), "Address: delegate call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.delegatecall(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
455      * revert reason using the provided one.
456      *
457      * _Available since v4.3._
458      */
459     function verifyCallResult(
460         bool success,
461         bytes memory returndata,
462         string memory errorMessage
463     ) internal pure returns (bytes memory) {
464         if (success) {
465             return returndata;
466         } else {
467             // Look for revert reason and bubble it up if present
468             if (returndata.length > 0) {
469                 // The easiest way to bubble the revert reason is using memory via assembly
470 
471                 assembly {
472                     let returndata_size := mload(returndata)
473                     revert(add(32, returndata), returndata_size)
474                 }
475             } else {
476                 revert(errorMessage);
477             }
478         }
479     }
480 }
481 
482 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Interface of the ERC165 standard, as defined in the
491  * https://eips.ethereum.org/EIPS/eip-165[EIP].
492  *
493  * Implementers can declare support of contract interfaces, which can then be
494  * queried by others ({ERC165Checker}).
495  *
496  * For an implementation, see {ERC165}.
497  */
498 interface IERC165 {
499     /**
500      * @dev Returns true if this contract implements the interface defined by
501      * `interfaceId`. See the corresponding
502      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
503      * to learn more about how these ids are created.
504      *
505      * This function call must use less than 30 000 gas.
506      */
507     function supportsInterface(bytes4 interfaceId) external view returns (bool);
508 }
509 
510 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @dev Implementation of the {IERC165} interface.
520  *
521  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
522  * for the additional interface id that will be supported. For example:
523  *
524  * ```solidity
525  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
527  * }
528  * ```
529  *
530  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
531  */
532 abstract contract ERC165 is IERC165 {
533     /**
534      * @dev See {IERC165-supportsInterface}.
535      */
536     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537         return interfaceId == type(IERC165).interfaceId;
538     }
539 }
540 
541 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
542 
543 
544 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @dev _Available since v3.1._
551  */
552 interface IERC1155Receiver is IERC165 {
553     /**
554      * @dev Handles the receipt of a single ERC1155 token type. This function is
555      * called at the end of a `safeTransferFrom` after the balance has been updated.
556      *
557      * NOTE: To accept the transfer, this must return
558      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
559      * (i.e. 0xf23a6e61, or its own function selector).
560      *
561      * @param operator The address which initiated the transfer (i.e. msg.sender)
562      * @param from The address which previously owned the token
563      * @param id The ID of the token being transferred
564      * @param value The amount of tokens being transferred
565      * @param data Additional data with no specified format
566      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
567      */
568     function onERC1155Received(
569         address operator,
570         address from,
571         uint256 id,
572         uint256 value,
573         bytes calldata data
574     ) external returns (bytes4);
575 
576     /**
577      * @dev Handles the receipt of a multiple ERC1155 token types. This function
578      * is called at the end of a `safeBatchTransferFrom` after the balances have
579      * been updated.
580      *
581      * NOTE: To accept the transfer(s), this must return
582      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
583      * (i.e. 0xbc197c81, or its own function selector).
584      *
585      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
586      * @param from The address which previously owned the token
587      * @param ids An array containing ids of each token being transferred (order and length must match values array)
588      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
589      * @param data Additional data with no specified format
590      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
591      */
592     function onERC1155BatchReceived(
593         address operator,
594         address from,
595         uint256[] calldata ids,
596         uint256[] calldata values,
597         bytes calldata data
598     ) external returns (bytes4);
599 }
600 
601 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 
609 /**
610  * @dev Required interface of an ERC1155 compliant contract, as defined in the
611  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
612  *
613  * _Available since v3.1._
614  */
615 interface IERC1155 is IERC165 {
616     /**
617      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
618      */
619     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
620 
621     /**
622      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
623      * transfers.
624      */
625     event TransferBatch(
626         address indexed operator,
627         address indexed from,
628         address indexed to,
629         uint256[] ids,
630         uint256[] values
631     );
632 
633     /**
634      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
635      * `approved`.
636      */
637     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
638 
639     /**
640      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
641      *
642      * If an {URI} event was emitted for `id`, the standard
643      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
644      * returned by {IERC1155MetadataURI-uri}.
645      */
646     event URI(string value, uint256 indexed id);
647 
648     /**
649      * @dev Returns the amount of tokens of token type `id` owned by `account`.
650      *
651      * Requirements:
652      *
653      * - `account` cannot be the zero address.
654      */
655     function balanceOf(address account, uint256 id) external view returns (uint256);
656 
657     /**
658      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
659      *
660      * Requirements:
661      *
662      * - `accounts` and `ids` must have the same length.
663      */
664     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
665         external
666         view
667         returns (uint256[] memory);
668 
669     /**
670      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
671      *
672      * Emits an {ApprovalForAll} event.
673      *
674      * Requirements:
675      *
676      * - `operator` cannot be the caller.
677      */
678     function setApprovalForAll(address operator, bool approved) external;
679 
680     /**
681      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
682      *
683      * See {setApprovalForAll}.
684      */
685     function isApprovedForAll(address account, address operator) external view returns (bool);
686 
687     /**
688      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
689      *
690      * Emits a {TransferSingle} event.
691      *
692      * Requirements:
693      *
694      * - `to` cannot be the zero address.
695      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
696      * - `from` must have a balance of tokens of type `id` of at least `amount`.
697      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
698      * acceptance magic value.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 id,
704         uint256 amount,
705         bytes calldata data
706     ) external;
707 
708     /**
709      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
710      *
711      * Emits a {TransferBatch} event.
712      *
713      * Requirements:
714      *
715      * - `ids` and `amounts` must have the same length.
716      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
717      * acceptance magic value.
718      */
719     function safeBatchTransferFrom(
720         address from,
721         address to,
722         uint256[] calldata ids,
723         uint256[] calldata amounts,
724         bytes calldata data
725     ) external;
726 }
727 
728 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
729 
730 
731 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 /**
737  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
738  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
739  *
740  * _Available since v3.1._
741  */
742 interface IERC1155MetadataURI is IERC1155 {
743     /**
744      * @dev Returns the URI for token type `id`.
745      *
746      * If the `\{id\}` substring is present in the URI, it must be replaced by
747      * clients with the actual token type ID.
748      */
749     function uri(uint256 id) external view returns (string memory);
750 }
751 
752 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
753 
754 
755 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 
760 
761 
762 
763 
764 
765 /**
766  * @dev Implementation of the basic standard multi-token.
767  * See https://eips.ethereum.org/EIPS/eip-1155
768  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
769  *
770  * _Available since v3.1._
771  */
772 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
773     using Address for address;
774 
775     // Mapping from token ID to account balances
776     mapping(uint256 => mapping(address => uint256)) private _balances;
777 
778     // Mapping from account to operator approvals
779     mapping(address => mapping(address => bool)) private _operatorApprovals;
780 
781     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
782     string private _uri;
783 
784     /**
785      * @dev See {_setURI}.
786      */
787     constructor(string memory uri_) {
788         _setURI(uri_);
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
795         return
796             interfaceId == type(IERC1155).interfaceId ||
797             interfaceId == type(IERC1155MetadataURI).interfaceId ||
798             super.supportsInterface(interfaceId);
799     }
800 
801     /**
802      * @dev See {IERC1155MetadataURI-uri}.
803      *
804      * This implementation returns the same URI for *all* token types. It relies
805      * on the token type ID substitution mechanism
806      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
807      *
808      * Clients calling this function must replace the `\{id\}` substring with the
809      * actual token type ID.
810      */
811     function uri(uint256) public view virtual override returns (string memory) {
812         return _uri;
813     }
814 
815     /**
816      * @dev See {IERC1155-balanceOf}.
817      *
818      * Requirements:
819      *
820      * - `account` cannot be the zero address.
821      */
822     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
823         require(account != address(0), "ERC1155: address zero is not a valid owner");
824         return _balances[id][account];
825     }
826 
827     /**
828      * @dev See {IERC1155-balanceOfBatch}.
829      *
830      * Requirements:
831      *
832      * - `accounts` and `ids` must have the same length.
833      */
834     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
835         public
836         view
837         virtual
838         override
839         returns (uint256[] memory)
840     {
841         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
842 
843         uint256[] memory batchBalances = new uint256[](accounts.length);
844 
845         for (uint256 i = 0; i < accounts.length; ++i) {
846             batchBalances[i] = balanceOf(accounts[i], ids[i]);
847         }
848 
849         return batchBalances;
850     }
851 
852     /**
853      * @dev See {IERC1155-setApprovalForAll}.
854      */
855     function setApprovalForAll(address operator, bool approved) public virtual override {
856         _setApprovalForAll(_msgSender(), operator, approved);
857     }
858 
859     /**
860      * @dev See {IERC1155-isApprovedForAll}.
861      */
862     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
863         return _operatorApprovals[account][operator];
864     }
865 
866     /**
867      * @dev See {IERC1155-safeTransferFrom}.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 id,
873         uint256 amount,
874         bytes memory data
875     ) public virtual override {
876         require(
877             from == _msgSender() || isApprovedForAll(from, _msgSender()),
878             "ERC1155: caller is not owner nor approved"
879         );
880         _safeTransferFrom(from, to, id, amount, data);
881     }
882 
883     /**
884      * @dev See {IERC1155-safeBatchTransferFrom}.
885      */
886     function safeBatchTransferFrom(
887         address from,
888         address to,
889         uint256[] memory ids,
890         uint256[] memory amounts,
891         bytes memory data
892     ) public virtual override {
893         require(
894             from == _msgSender() || isApprovedForAll(from, _msgSender()),
895             "ERC1155: transfer caller is not owner nor approved"
896         );
897         _safeBatchTransferFrom(from, to, ids, amounts, data);
898     }
899 
900     /**
901      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
902      *
903      * Emits a {TransferSingle} event.
904      *
905      * Requirements:
906      *
907      * - `to` cannot be the zero address.
908      * - `from` must have a balance of tokens of type `id` of at least `amount`.
909      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
910      * acceptance magic value.
911      */
912     function _safeTransferFrom(
913         address from,
914         address to,
915         uint256 id,
916         uint256 amount,
917         bytes memory data
918     ) internal virtual {
919         require(to != address(0), "ERC1155: transfer to the zero address");
920 
921         address operator = _msgSender();
922         uint256[] memory ids = _asSingletonArray(id);
923         uint256[] memory amounts = _asSingletonArray(amount);
924 
925         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
926 
927         uint256 fromBalance = _balances[id][from];
928         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
929         unchecked {
930             _balances[id][from] = fromBalance - amount;
931         }
932         _balances[id][to] += amount;
933 
934         emit TransferSingle(operator, from, to, id, amount);
935 
936         _afterTokenTransfer(operator, from, to, ids, amounts, data);
937 
938         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
939     }
940 
941     /**
942      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
943      *
944      * Emits a {TransferBatch} event.
945      *
946      * Requirements:
947      *
948      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
949      * acceptance magic value.
950      */
951     function _safeBatchTransferFrom(
952         address from,
953         address to,
954         uint256[] memory ids,
955         uint256[] memory amounts,
956         bytes memory data
957     ) internal virtual {
958         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
959         require(to != address(0), "ERC1155: transfer to the zero address");
960 
961         address operator = _msgSender();
962 
963         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
964 
965         for (uint256 i = 0; i < ids.length; ++i) {
966             uint256 id = ids[i];
967             uint256 amount = amounts[i];
968 
969             uint256 fromBalance = _balances[id][from];
970             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
971             unchecked {
972                 _balances[id][from] = fromBalance - amount;
973             }
974             _balances[id][to] += amount;
975         }
976 
977         emit TransferBatch(operator, from, to, ids, amounts);
978 
979         _afterTokenTransfer(operator, from, to, ids, amounts, data);
980 
981         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
982     }
983 
984     /**
985      * @dev Sets a new URI for all token types, by relying on the token type ID
986      * substitution mechanism
987      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
988      *
989      * By this mechanism, any occurrence of the `\{id\}` substring in either the
990      * URI or any of the amounts in the JSON file at said URI will be replaced by
991      * clients with the token type ID.
992      *
993      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
994      * interpreted by clients as
995      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
996      * for token type ID 0x4cce0.
997      *
998      * See {uri}.
999      *
1000      * Because these URIs cannot be meaningfully represented by the {URI} event,
1001      * this function emits no events.
1002      */
1003     function _setURI(string memory newuri) internal virtual {
1004         _uri = newuri;
1005     }
1006 
1007     /**
1008      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1009      *
1010      * Emits a {TransferSingle} event.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1016      * acceptance magic value.
1017      */
1018     function _mint(
1019         address to,
1020         uint256 id,
1021         uint256 amount,
1022         bytes memory data
1023     ) internal virtual {
1024         require(to != address(0), "ERC1155: mint to the zero address");
1025 
1026         address operator = _msgSender();
1027         uint256[] memory ids = _asSingletonArray(id);
1028         uint256[] memory amounts = _asSingletonArray(amount);
1029 
1030         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1031 
1032         _balances[id][to] += amount;
1033         emit TransferSingle(operator, address(0), to, id, amount);
1034 
1035         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1036 
1037         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1038     }
1039 
1040     /**
1041      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1042      *
1043      * Requirements:
1044      *
1045      * - `ids` and `amounts` must have the same length.
1046      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1047      * acceptance magic value.
1048      */
1049     function _mintBatch(
1050         address to,
1051         uint256[] memory ids,
1052         uint256[] memory amounts,
1053         bytes memory data
1054     ) internal virtual {
1055         require(to != address(0), "ERC1155: mint to the zero address");
1056         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1057 
1058         address operator = _msgSender();
1059 
1060         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1061 
1062         for (uint256 i = 0; i < ids.length; i++) {
1063             _balances[ids[i]][to] += amounts[i];
1064         }
1065 
1066         emit TransferBatch(operator, address(0), to, ids, amounts);
1067 
1068         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1069 
1070         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1071     }
1072 
1073     /**
1074      * @dev Destroys `amount` tokens of token type `id` from `from`
1075      *
1076      * Requirements:
1077      *
1078      * - `from` cannot be the zero address.
1079      * - `from` must have at least `amount` tokens of token type `id`.
1080      */
1081     function _burn(
1082         address from,
1083         uint256 id,
1084         uint256 amount
1085     ) internal virtual {
1086         require(from != address(0), "ERC1155: burn from the zero address");
1087 
1088         address operator = _msgSender();
1089         uint256[] memory ids = _asSingletonArray(id);
1090         uint256[] memory amounts = _asSingletonArray(amount);
1091 
1092         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1093 
1094         uint256 fromBalance = _balances[id][from];
1095         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1096         unchecked {
1097             _balances[id][from] = fromBalance - amount;
1098         }
1099 
1100         emit TransferSingle(operator, from, address(0), id, amount);
1101 
1102         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1103     }
1104 
1105     /**
1106      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1107      *
1108      * Requirements:
1109      *
1110      * - `ids` and `amounts` must have the same length.
1111      */
1112     function _burnBatch(
1113         address from,
1114         uint256[] memory ids,
1115         uint256[] memory amounts
1116     ) internal virtual {
1117         require(from != address(0), "ERC1155: burn from the zero address");
1118         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1119 
1120         address operator = _msgSender();
1121 
1122         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1123 
1124         for (uint256 i = 0; i < ids.length; i++) {
1125             uint256 id = ids[i];
1126             uint256 amount = amounts[i];
1127 
1128             uint256 fromBalance = _balances[id][from];
1129             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1130             unchecked {
1131                 _balances[id][from] = fromBalance - amount;
1132             }
1133         }
1134 
1135         emit TransferBatch(operator, from, address(0), ids, amounts);
1136 
1137         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1138     }
1139 
1140     /**
1141      * @dev Approve `operator` to operate on all of `owner` tokens
1142      *
1143      * Emits a {ApprovalForAll} event.
1144      */
1145     function _setApprovalForAll(
1146         address owner,
1147         address operator,
1148         bool approved
1149     ) internal virtual {
1150         require(owner != operator, "ERC1155: setting approval status for self");
1151         _operatorApprovals[owner][operator] = approved;
1152         emit ApprovalForAll(owner, operator, approved);
1153     }
1154 
1155     /**
1156      * @dev Hook that is called before any token transfer. This includes minting
1157      * and burning, as well as batched variants.
1158      *
1159      * The same hook is called on both single and batched variants. For single
1160      * transfers, the length of the `id` and `amount` arrays will be 1.
1161      *
1162      * Calling conditions (for each `id` and `amount` pair):
1163      *
1164      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1165      * of token type `id` will be  transferred to `to`.
1166      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1167      * for `to`.
1168      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1169      * will be burned.
1170      * - `from` and `to` are never both zero.
1171      * - `ids` and `amounts` have the same, non-zero length.
1172      *
1173      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1174      */
1175     function _beforeTokenTransfer(
1176         address operator,
1177         address from,
1178         address to,
1179         uint256[] memory ids,
1180         uint256[] memory amounts,
1181         bytes memory data
1182     ) internal virtual {}
1183 
1184     /**
1185      * @dev Hook that is called after any token transfer. This includes minting
1186      * and burning, as well as batched variants.
1187      *
1188      * The same hook is called on both single and batched variants. For single
1189      * transfers, the length of the `id` and `amount` arrays will be 1.
1190      *
1191      * Calling conditions (for each `id` and `amount` pair):
1192      *
1193      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1194      * of token type `id` will be  transferred to `to`.
1195      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1196      * for `to`.
1197      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1198      * will be burned.
1199      * - `from` and `to` are never both zero.
1200      * - `ids` and `amounts` have the same, non-zero length.
1201      *
1202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1203      */
1204     function _afterTokenTransfer(
1205         address operator,
1206         address from,
1207         address to,
1208         uint256[] memory ids,
1209         uint256[] memory amounts,
1210         bytes memory data
1211     ) internal virtual {}
1212 
1213     function _doSafeTransferAcceptanceCheck(
1214         address operator,
1215         address from,
1216         address to,
1217         uint256 id,
1218         uint256 amount,
1219         bytes memory data
1220     ) private {
1221         if (to.isContract()) {
1222             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1223                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1224                     revert("ERC1155: ERC1155Receiver rejected tokens");
1225                 }
1226             } catch Error(string memory reason) {
1227                 revert(reason);
1228             } catch {
1229                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1230             }
1231         }
1232     }
1233 
1234     function _doSafeBatchTransferAcceptanceCheck(
1235         address operator,
1236         address from,
1237         address to,
1238         uint256[] memory ids,
1239         uint256[] memory amounts,
1240         bytes memory data
1241     ) private {
1242         if (to.isContract()) {
1243             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1244                 bytes4 response
1245             ) {
1246                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1247                     revert("ERC1155: ERC1155Receiver rejected tokens");
1248                 }
1249             } catch Error(string memory reason) {
1250                 revert(reason);
1251             } catch {
1252                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1253             }
1254         }
1255     }
1256 
1257     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1258         uint256[] memory array = new uint256[](1);
1259         array[0] = element;
1260 
1261         return array;
1262     }
1263 }
1264 
1265 
1266 // File: contracts/KickzPassGenesis.sol
1267 
1268 pragma solidity ^0.8.13;
1269 
1270 contract KickzPassGenesis is ERC1155, Ownable, ReentrancyGuard {
1271     
1272   string public constant name = "Kickz Pass Genesis";
1273   string public constant symbol = "KPG";
1274 
1275   uint private constant MAX_SUPPLY = 250;
1276   uint private constant PASS_ID = 1;
1277 
1278   uint public passCount = 0;
1279   
1280   bool public isMintOpen = false;
1281 
1282   //TODO: Update for production 
1283   bytes32 public merkleRoot = 0xab1c094c9ebd4c5e3b64166d167b0387321c5a976d4812b7c6e3ba6a3e07c962;
1284 
1285   mapping(address => uint) public mintCount;
1286 
1287   constructor() ERC1155("ipfs://QmSvvYeC9rg9eb8iLV2gSuJX5T6YpYAyGnjrS8A4xmufJE/metadata.json") {}
1288 
1289 
1290   function whiteListMint(bytes32[] calldata merkleProof) external nonReentrant{
1291     require(passCount < MAX_SUPPLY, "Sold out");
1292     require(mintCount[msg.sender] < 1, "At mint limit");
1293     require(MerkleProof.verify(merkleProof, merkleRoot,keccak256(abi.encodePacked(msg.sender))), "Proof invalid");
1294     require(isMintOpen, "Mint not open");
1295 
1296     mintCount[msg.sender]++;
1297     passCount++;
1298     _mint(msg.sender, PASS_ID, 1, "");
1299   }
1300   
1301   function setMintOpen() external onlyOwner{
1302     isMintOpen = !isMintOpen;
1303   }
1304 
1305   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
1306     merkleRoot = _merkleRoot;
1307   }
1308 
1309   function ownerMint(address to, uint amount) external onlyOwner {
1310     require(passCount + amount <= MAX_SUPPLY, "Sold out");
1311     passCount += amount;
1312     _mint(to, PASS_ID, amount, "");
1313   }
1314 
1315   function setURI(string memory uri) external onlyOwner {
1316     _setURI(uri);
1317   }
1318 
1319   function totalSupply() external view returns (uint256) {
1320     return passCount;
1321   }
1322 }