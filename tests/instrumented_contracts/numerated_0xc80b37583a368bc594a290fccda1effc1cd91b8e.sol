1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev These functions deal with verification of Merkle Trees proofs.
56  *
57  * The proofs can be generated using the JavaScript library
58  * https://github.com/miguelmota/merkletreejs[merkletreejs].
59  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
60  *
61  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
62  *
63  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
64  * hashing, or use a hash function other than keccak256 for hashing leaves.
65  * This is because the concatenation of a sorted pair of internal nodes in
66  * the merkle tree could be reinterpreted as a leaf value.
67  */
68 library MerkleProof {
69     /**
70      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
71      * defined by `root`. For this, a `proof` must be provided, containing
72      * sibling hashes on the branch from the leaf to the root of the tree. Each
73      * pair of leaves and each pair of pre-images are assumed to be sorted.
74      */
75     function verify(
76         bytes32[] memory proof,
77         bytes32 root,
78         bytes32 leaf
79     ) internal pure returns (bool) {
80         return processProof(proof, leaf) == root;
81     }
82 
83     /**
84      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
85      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
86      * hash matches the root of the tree. When processing the proof, the pairs
87      * of leafs & pre-images are assumed to be sorted.
88      *
89      * _Available since v4.4._
90      */
91     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
92         bytes32 computedHash = leaf;
93         for (uint256 i = 0; i < proof.length; i++) {
94             bytes32 proofElement = proof[i];
95             if (computedHash <= proofElement) {
96                 // Hash(current computed hash + current element of the proof)
97                 computedHash = _efficientHash(computedHash, proofElement);
98             } else {
99                 // Hash(current element of the proof + current computed hash)
100                 computedHash = _efficientHash(proofElement, computedHash);
101             }
102         }
103         return computedHash;
104     }
105 
106     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
107         assembly {
108             mstore(0x00, a)
109             mstore(0x20, b)
110             value := keccak256(0x00, 0x40)
111         }
112     }
113 }
114 
115 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev String operations.
124  */
125 library Strings {
126     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
130      */
131     function toString(uint256 value) internal pure returns (string memory) {
132         // Inspired by OraclizeAPI's implementation - MIT licence
133         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
134 
135         if (value == 0) {
136             return "0";
137         }
138         uint256 temp = value;
139         uint256 digits;
140         while (temp != 0) {
141             digits++;
142             temp /= 10;
143         }
144         bytes memory buffer = new bytes(digits);
145         while (value != 0) {
146             digits -= 1;
147             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
148             value /= 10;
149         }
150         return string(buffer);
151     }
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
155      */
156     function toHexString(uint256 value) internal pure returns (string memory) {
157         if (value == 0) {
158             return "0x00";
159         }
160         uint256 temp = value;
161         uint256 length = 0;
162         while (temp != 0) {
163             length++;
164             temp >>= 8;
165         }
166         return toHexString(value, length);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
171      */
172     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
173         bytes memory buffer = new bytes(2 * length + 2);
174         buffer[0] = "0";
175         buffer[1] = "x";
176         for (uint256 i = 2 * length + 1; i > 1; --i) {
177             buffer[i] = _HEX_SYMBOLS[value & 0xf];
178             value >>= 4;
179         }
180         require(value == 0, "Strings: hex length insufficient");
181         return string(buffer);
182     }
183 }
184 
185 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
186 
187 
188 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev Contract module that helps prevent reentrant calls to a function.
194  *
195  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
196  * available, which can be applied to functions to make sure there are no nested
197  * (reentrant) calls to them.
198  *
199  * Note that because there is a single `nonReentrant` guard, functions marked as
200  * `nonReentrant` may not call one another. This can be worked around by making
201  * those functions `private`, and then adding `external` `nonReentrant` entry
202  * points to them.
203  *
204  * TIP: If you would like to learn more about reentrancy and alternative ways
205  * to protect against it, check out our blog post
206  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
207  */
208 abstract contract ReentrancyGuard {
209     // Booleans are more expensive than uint256 or any type that takes up a full
210     // word because each write operation emits an extra SLOAD to first read the
211     // slot's contents, replace the bits taken up by the boolean, and then write
212     // back. This is the compiler's defense against contract upgrades and
213     // pointer aliasing, and it cannot be disabled.
214 
215     // The values being non-zero value makes deployment a bit more expensive,
216     // but in exchange the refund on every call to nonReentrant will be lower in
217     // amount. Since refunds are capped to a percentage of the total
218     // transaction's gas, it is best to keep them low in cases like this one, to
219     // increase the likelihood of the full refund coming into effect.
220     uint256 private constant _NOT_ENTERED = 1;
221     uint256 private constant _ENTERED = 2;
222 
223     uint256 private _status;
224 
225     constructor() {
226         _status = _NOT_ENTERED;
227     }
228 
229     /**
230      * @dev Prevents a contract from calling itself, directly or indirectly.
231      * Calling a `nonReentrant` function from another `nonReentrant`
232      * function is not supported. It is possible to prevent this from happening
233      * by making the `nonReentrant` function external, and making it call a
234      * `private` function that does the actual work.
235      */
236     modifier nonReentrant() {
237         // On the first call to nonReentrant, _notEntered will be true
238         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
239 
240         // Any calls to nonReentrant after this point will fail
241         _status = _ENTERED;
242 
243         _;
244 
245         // By storing the original value once again, a refund is triggered (see
246         // https://eips.ethereum.org/EIPS/eip-2200)
247         _status = _NOT_ENTERED;
248     }
249 }
250 
251 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Provides information about the current execution context, including the
260  * sender of the transaction and its data. While these are generally available
261  * via msg.sender and msg.data, they should not be accessed in such a direct
262  * manner, since when dealing with meta-transactions the account sending and
263  * paying for execution may not be the actual sender (as far as an application
264  * is concerned).
265  *
266  * This contract is only required for intermediate, library-like contracts.
267  */
268 abstract contract Context {
269     function _msgSender() internal view virtual returns (address) {
270         return msg.sender;
271     }
272 
273     function _msgData() internal view virtual returns (bytes calldata) {
274         return msg.data;
275     }
276 }
277 
278 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 
286 /**
287  * @dev Contract module which provides a basic access control mechanism, where
288  * there is an account (an owner) that can be granted exclusive access to
289  * specific functions.
290  *
291  * By default, the owner account will be the one that deploys the contract. This
292  * can later be changed with {transferOwnership}.
293  *
294  * This module is used through inheritance. It will make available the modifier
295  * `onlyOwner`, which can be applied to your functions to restrict their use to
296  * the owner.
297  */
298 abstract contract Ownable is Context {
299     address private _owner;
300 
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303     /**
304      * @dev Initializes the contract setting the deployer as the initial owner.
305      */
306     constructor() {
307         _transferOwnership(_msgSender());
308     }
309 
310     /**
311      * @dev Returns the address of the current owner.
312      */
313     function owner() public view virtual returns (address) {
314         return _owner;
315     }
316 
317     /**
318      * @dev Throws if called by any account other than the owner.
319      */
320     modifier onlyOwner() {
321         require(owner() == _msgSender(), "Ownable: caller is not the owner");
322         _;
323     }
324 
325     /**
326      * @dev Leaves the contract without owner. It will not be possible to call
327      * `onlyOwner` functions anymore. Can only be called by the current owner.
328      *
329      * NOTE: Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public virtual onlyOwner {
333         _transferOwnership(address(0));
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Can only be called by the current owner.
339      */
340     function transferOwnership(address newOwner) public virtual onlyOwner {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         _transferOwnership(newOwner);
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      * Internal function without access restriction.
348      */
349     function _transferOwnership(address newOwner) internal virtual {
350         address oldOwner = _owner;
351         _owner = newOwner;
352         emit OwnershipTransferred(oldOwner, newOwner);
353     }
354 }
355 
356 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
357 
358 
359 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
360 
361 pragma solidity ^0.8.1;
362 
363 /**
364  * @dev Collection of functions related to the address type
365  */
366 library Address {
367     /**
368      * @dev Returns true if `account` is a contract.
369      *
370      * [IMPORTANT]
371      * ====
372      * It is unsafe to assume that an address for which this function returns
373      * false is an externally-owned account (EOA) and not a contract.
374      *
375      * Among others, `isContract` will return false for the following
376      * types of addresses:
377      *
378      *  - an externally-owned account
379      *  - a contract in construction
380      *  - an address where a contract will be created
381      *  - an address where a contract lived, but was destroyed
382      * ====
383      *
384      * [IMPORTANT]
385      * ====
386      * You shouldn't rely on `isContract` to protect against flash loan attacks!
387      *
388      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
389      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
390      * constructor.
391      * ====
392      */
393     function isContract(address account) internal view returns (bool) {
394         // This method relies on extcodesize/address.code.length, which returns 0
395         // for contracts in construction, since the code is only stored at the end
396         // of the constructor execution.
397 
398         return account.code.length > 0;
399     }
400 
401     /**
402      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
403      * `recipient`, forwarding all available gas and reverting on errors.
404      *
405      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
406      * of certain opcodes, possibly making contracts go over the 2300 gas limit
407      * imposed by `transfer`, making them unable to receive funds via
408      * `transfer`. {sendValue} removes this limitation.
409      *
410      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
411      *
412      * IMPORTANT: because control is transferred to `recipient`, care must be
413      * taken to not create reentrancy vulnerabilities. Consider using
414      * {ReentrancyGuard} or the
415      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
416      */
417     function sendValue(address payable recipient, uint256 amount) internal {
418         require(address(this).balance >= amount, "Address: insufficient balance");
419 
420         (bool success, ) = recipient.call{value: amount}("");
421         require(success, "Address: unable to send value, recipient may have reverted");
422     }
423 
424     /**
425      * @dev Performs a Solidity function call using a low level `call`. A
426      * plain `call` is an unsafe replacement for a function call: use this
427      * function instead.
428      *
429      * If `target` reverts with a revert reason, it is bubbled up by this
430      * function (like regular Solidity function calls).
431      *
432      * Returns the raw returned data. To convert to the expected return value,
433      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
434      *
435      * Requirements:
436      *
437      * - `target` must be a contract.
438      * - calling `target` with `data` must not revert.
439      *
440      * _Available since v3.1._
441      */
442     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
443         return functionCall(target, data, "Address: low-level call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
448      * `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         return functionCallWithValue(target, data, 0, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but also transferring `value` wei to `target`.
463      *
464      * Requirements:
465      *
466      * - the calling contract must have an ETH balance of at least `value`.
467      * - the called Solidity function must be `payable`.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(
472         address target,
473         bytes memory data,
474         uint256 value
475     ) internal returns (bytes memory) {
476         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
481      * with `errorMessage` as a fallback revert reason when `target` reverts.
482      *
483      * _Available since v3.1._
484      */
485     function functionCallWithValue(
486         address target,
487         bytes memory data,
488         uint256 value,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(address(this).balance >= value, "Address: insufficient balance for call");
492         require(isContract(target), "Address: call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.call{value: value}(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but performing a static call.
501      *
502      * _Available since v3.3._
503      */
504     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
505         return functionStaticCall(target, data, "Address: low-level static call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
510      * but performing a static call.
511      *
512      * _Available since v3.3._
513      */
514     function functionStaticCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal view returns (bytes memory) {
519         require(isContract(target), "Address: static call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.staticcall(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but performing a delegate call.
528      *
529      * _Available since v3.4._
530      */
531     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
532         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
537      * but performing a delegate call.
538      *
539      * _Available since v3.4._
540      */
541     function functionDelegateCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(isContract(target), "Address: delegate call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.delegatecall(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
554      * revert reason using the provided one.
555      *
556      * _Available since v4.3._
557      */
558     function verifyCallResult(
559         bool success,
560         bytes memory returndata,
561         string memory errorMessage
562     ) internal pure returns (bytes memory) {
563         if (success) {
564             return returndata;
565         } else {
566             // Look for revert reason and bubble it up if present
567             if (returndata.length > 0) {
568                 // The easiest way to bubble the revert reason is using memory via assembly
569 
570                 assembly {
571                     let returndata_size := mload(returndata)
572                     revert(add(32, returndata), returndata_size)
573                 }
574             } else {
575                 revert(errorMessage);
576             }
577         }
578     }
579 }
580 
581 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @dev Interface of the ERC165 standard, as defined in the
590  * https://eips.ethereum.org/EIPS/eip-165[EIP].
591  *
592  * Implementers can declare support of contract interfaces, which can then be
593  * queried by others ({ERC165Checker}).
594  *
595  * For an implementation, see {ERC165}.
596  */
597 interface IERC165 {
598     /**
599      * @dev Returns true if this contract implements the interface defined by
600      * `interfaceId`. See the corresponding
601      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
602      * to learn more about how these ids are created.
603      *
604      * This function call must use less than 30 000 gas.
605      */
606     function supportsInterface(bytes4 interfaceId) external view returns (bool);
607 }
608 
609 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @dev Implementation of the {IERC165} interface.
619  *
620  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
621  * for the additional interface id that will be supported. For example:
622  *
623  * ```solidity
624  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
625  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
626  * }
627  * ```
628  *
629  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
630  */
631 abstract contract ERC165 is IERC165 {
632     /**
633      * @dev See {IERC165-supportsInterface}.
634      */
635     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636         return interfaceId == type(IERC165).interfaceId;
637     }
638 }
639 
640 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
641 
642 
643 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @dev _Available since v3.1._
650  */
651 interface IERC1155Receiver is IERC165 {
652     /**
653      * @dev Handles the receipt of a single ERC1155 token type. This function is
654      * called at the end of a `safeTransferFrom` after the balance has been updated.
655      *
656      * NOTE: To accept the transfer, this must return
657      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
658      * (i.e. 0xf23a6e61, or its own function selector).
659      *
660      * @param operator The address which initiated the transfer (i.e. msg.sender)
661      * @param from The address which previously owned the token
662      * @param id The ID of the token being transferred
663      * @param value The amount of tokens being transferred
664      * @param data Additional data with no specified format
665      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
666      */
667     function onERC1155Received(
668         address operator,
669         address from,
670         uint256 id,
671         uint256 value,
672         bytes calldata data
673     ) external returns (bytes4);
674 
675     /**
676      * @dev Handles the receipt of a multiple ERC1155 token types. This function
677      * is called at the end of a `safeBatchTransferFrom` after the balances have
678      * been updated.
679      *
680      * NOTE: To accept the transfer(s), this must return
681      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
682      * (i.e. 0xbc197c81, or its own function selector).
683      *
684      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
685      * @param from The address which previously owned the token
686      * @param ids An array containing ids of each token being transferred (order and length must match values array)
687      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
688      * @param data Additional data with no specified format
689      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
690      */
691     function onERC1155BatchReceived(
692         address operator,
693         address from,
694         uint256[] calldata ids,
695         uint256[] calldata values,
696         bytes calldata data
697     ) external returns (bytes4);
698 }
699 
700 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @dev Required interface of an ERC1155 compliant contract, as defined in the
710  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
711  *
712  * _Available since v3.1._
713  */
714 interface IERC1155 is IERC165 {
715     /**
716      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
717      */
718     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
719 
720     /**
721      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
722      * transfers.
723      */
724     event TransferBatch(
725         address indexed operator,
726         address indexed from,
727         address indexed to,
728         uint256[] ids,
729         uint256[] values
730     );
731 
732     /**
733      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
734      * `approved`.
735      */
736     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
737 
738     /**
739      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
740      *
741      * If an {URI} event was emitted for `id`, the standard
742      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
743      * returned by {IERC1155MetadataURI-uri}.
744      */
745     event URI(string value, uint256 indexed id);
746 
747     /**
748      * @dev Returns the amount of tokens of token type `id` owned by `account`.
749      *
750      * Requirements:
751      *
752      * - `account` cannot be the zero address.
753      */
754     function balanceOf(address account, uint256 id) external view returns (uint256);
755 
756     /**
757      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
758      *
759      * Requirements:
760      *
761      * - `accounts` and `ids` must have the same length.
762      */
763     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
764         external
765         view
766         returns (uint256[] memory);
767 
768     /**
769      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
770      *
771      * Emits an {ApprovalForAll} event.
772      *
773      * Requirements:
774      *
775      * - `operator` cannot be the caller.
776      */
777     function setApprovalForAll(address operator, bool approved) external;
778 
779     /**
780      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
781      *
782      * See {setApprovalForAll}.
783      */
784     function isApprovedForAll(address account, address operator) external view returns (bool);
785 
786     /**
787      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
788      *
789      * Emits a {TransferSingle} event.
790      *
791      * Requirements:
792      *
793      * - `to` cannot be the zero address.
794      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
795      * - `from` must have a balance of tokens of type `id` of at least `amount`.
796      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
797      * acceptance magic value.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 id,
803         uint256 amount,
804         bytes calldata data
805     ) external;
806 
807     /**
808      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
809      *
810      * Emits a {TransferBatch} event.
811      *
812      * Requirements:
813      *
814      * - `ids` and `amounts` must have the same length.
815      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
816      * acceptance magic value.
817      */
818     function safeBatchTransferFrom(
819         address from,
820         address to,
821         uint256[] calldata ids,
822         uint256[] calldata amounts,
823         bytes calldata data
824     ) external;
825 }
826 
827 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
828 
829 
830 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
831 
832 pragma solidity ^0.8.0;
833 
834 
835 /**
836  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
837  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
838  *
839  * _Available since v3.1._
840  */
841 interface IERC1155MetadataURI is IERC1155 {
842     /**
843      * @dev Returns the URI for token type `id`.
844      *
845      * If the `\{id\}` substring is present in the URI, it must be replaced by
846      * clients with the actual token type ID.
847      */
848     function uri(uint256 id) external view returns (string memory);
849 }
850 
851 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
852 
853 
854 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
855 
856 pragma solidity ^0.8.0;
857 
858 
859 
860 
861 
862 
863 
864 /**
865  * @dev Implementation of the basic standard multi-token.
866  * See https://eips.ethereum.org/EIPS/eip-1155
867  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
868  *
869  * _Available since v3.1._
870  */
871 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
872     using Address for address;
873 
874     // Mapping from token ID to account balances
875     mapping(uint256 => mapping(address => uint256)) private _balances;
876 
877     // Mapping from account to operator approvals
878     mapping(address => mapping(address => bool)) private _operatorApprovals;
879 
880     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
881     string private _uri;
882 
883     /**
884      * @dev See {_setURI}.
885      */
886     constructor(string memory uri_) {
887         _setURI(uri_);
888     }
889 
890     /**
891      * @dev See {IERC165-supportsInterface}.
892      */
893     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
894         return
895             interfaceId == type(IERC1155).interfaceId ||
896             interfaceId == type(IERC1155MetadataURI).interfaceId ||
897             super.supportsInterface(interfaceId);
898     }
899 
900     /**
901      * @dev See {IERC1155MetadataURI-uri}.
902      *
903      * This implementation returns the same URI for *all* token types. It relies
904      * on the token type ID substitution mechanism
905      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
906      *
907      * Clients calling this function must replace the `\{id\}` substring with the
908      * actual token type ID.
909      */
910     function uri(uint256) public view virtual override returns (string memory) {
911         return _uri;
912     }
913 
914     /**
915      * @dev See {IERC1155-balanceOf}.
916      *
917      * Requirements:
918      *
919      * - `account` cannot be the zero address.
920      */
921     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
922         require(account != address(0), "ERC1155: balance query for the zero address");
923         return _balances[id][account];
924     }
925 
926     /**
927      * @dev See {IERC1155-balanceOfBatch}.
928      *
929      * Requirements:
930      *
931      * - `accounts` and `ids` must have the same length.
932      */
933     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
934         public
935         view
936         virtual
937         override
938         returns (uint256[] memory)
939     {
940         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
941 
942         uint256[] memory batchBalances = new uint256[](accounts.length);
943 
944         for (uint256 i = 0; i < accounts.length; ++i) {
945             batchBalances[i] = balanceOf(accounts[i], ids[i]);
946         }
947 
948         return batchBalances;
949     }
950 
951     /**
952      * @dev See {IERC1155-setApprovalForAll}.
953      */
954     function setApprovalForAll(address operator, bool approved) public virtual override {
955         _setApprovalForAll(_msgSender(), operator, approved);
956     }
957 
958     /**
959      * @dev See {IERC1155-isApprovedForAll}.
960      */
961     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
962         return _operatorApprovals[account][operator];
963     }
964 
965     /**
966      * @dev See {IERC1155-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 id,
972         uint256 amount,
973         bytes memory data
974     ) public virtual override {
975         require(
976             from == _msgSender() || isApprovedForAll(from, _msgSender()),
977             "ERC1155: caller is not owner nor approved"
978         );
979         _safeTransferFrom(from, to, id, amount, data);
980     }
981 
982     /**
983      * @dev See {IERC1155-safeBatchTransferFrom}.
984      */
985     function safeBatchTransferFrom(
986         address from,
987         address to,
988         uint256[] memory ids,
989         uint256[] memory amounts,
990         bytes memory data
991     ) public virtual override {
992         require(
993             from == _msgSender() || isApprovedForAll(from, _msgSender()),
994             "ERC1155: transfer caller is not owner nor approved"
995         );
996         _safeBatchTransferFrom(from, to, ids, amounts, data);
997     }
998 
999     /**
1000      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1001      *
1002      * Emits a {TransferSingle} event.
1003      *
1004      * Requirements:
1005      *
1006      * - `to` cannot be the zero address.
1007      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1008      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1009      * acceptance magic value.
1010      */
1011     function _safeTransferFrom(
1012         address from,
1013         address to,
1014         uint256 id,
1015         uint256 amount,
1016         bytes memory data
1017     ) internal virtual {
1018         require(to != address(0), "ERC1155: transfer to the zero address");
1019 
1020         address operator = _msgSender();
1021         uint256[] memory ids = _asSingletonArray(id);
1022         uint256[] memory amounts = _asSingletonArray(amount);
1023 
1024         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1025 
1026         uint256 fromBalance = _balances[id][from];
1027         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1028         unchecked {
1029             _balances[id][from] = fromBalance - amount;
1030         }
1031         _balances[id][to] += amount;
1032 
1033         emit TransferSingle(operator, from, to, id, amount);
1034 
1035         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1036 
1037         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1038     }
1039 
1040     /**
1041      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1042      *
1043      * Emits a {TransferBatch} event.
1044      *
1045      * Requirements:
1046      *
1047      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1048      * acceptance magic value.
1049      */
1050     function _safeBatchTransferFrom(
1051         address from,
1052         address to,
1053         uint256[] memory ids,
1054         uint256[] memory amounts,
1055         bytes memory data
1056     ) internal virtual {
1057         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1058         require(to != address(0), "ERC1155: transfer to the zero address");
1059 
1060         address operator = _msgSender();
1061 
1062         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1063 
1064         for (uint256 i = 0; i < ids.length; ++i) {
1065             uint256 id = ids[i];
1066             uint256 amount = amounts[i];
1067 
1068             uint256 fromBalance = _balances[id][from];
1069             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1070             unchecked {
1071                 _balances[id][from] = fromBalance - amount;
1072             }
1073             _balances[id][to] += amount;
1074         }
1075 
1076         emit TransferBatch(operator, from, to, ids, amounts);
1077 
1078         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1079 
1080         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1081     }
1082 
1083     /**
1084      * @dev Sets a new URI for all token types, by relying on the token type ID
1085      * substitution mechanism
1086      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1087      *
1088      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1089      * URI or any of the amounts in the JSON file at said URI will be replaced by
1090      * clients with the token type ID.
1091      *
1092      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1093      * interpreted by clients as
1094      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1095      * for token type ID 0x4cce0.
1096      *
1097      * See {uri}.
1098      *
1099      * Because these URIs cannot be meaningfully represented by the {URI} event,
1100      * this function emits no events.
1101      */
1102     function _setURI(string memory newuri) internal virtual {
1103         _uri = newuri;
1104     }
1105 
1106     /**
1107      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1108      *
1109      * Emits a {TransferSingle} event.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1115      * acceptance magic value.
1116      */
1117     function _mint(
1118         address to,
1119         uint256 id,
1120         uint256 amount,
1121         bytes memory data
1122     ) internal virtual {
1123         require(to != address(0), "ERC1155: mint to the zero address");
1124 
1125         address operator = _msgSender();
1126         uint256[] memory ids = _asSingletonArray(id);
1127         uint256[] memory amounts = _asSingletonArray(amount);
1128 
1129         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1130 
1131         _balances[id][to] += amount;
1132         emit TransferSingle(operator, address(0), to, id, amount);
1133 
1134         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1135 
1136         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1137     }
1138 
1139     /**
1140      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1141      *
1142      * Requirements:
1143      *
1144      * - `ids` and `amounts` must have the same length.
1145      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1146      * acceptance magic value.
1147      */
1148     function _mintBatch(
1149         address to,
1150         uint256[] memory ids,
1151         uint256[] memory amounts,
1152         bytes memory data
1153     ) internal virtual {
1154         require(to != address(0), "ERC1155: mint to the zero address");
1155         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1156 
1157         address operator = _msgSender();
1158 
1159         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1160 
1161         for (uint256 i = 0; i < ids.length; i++) {
1162             _balances[ids[i]][to] += amounts[i];
1163         }
1164 
1165         emit TransferBatch(operator, address(0), to, ids, amounts);
1166 
1167         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1168 
1169         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1170     }
1171 
1172     /**
1173      * @dev Destroys `amount` tokens of token type `id` from `from`
1174      *
1175      * Requirements:
1176      *
1177      * - `from` cannot be the zero address.
1178      * - `from` must have at least `amount` tokens of token type `id`.
1179      */
1180     function _burn(
1181         address from,
1182         uint256 id,
1183         uint256 amount
1184     ) internal virtual {
1185         require(from != address(0), "ERC1155: burn from the zero address");
1186 
1187         address operator = _msgSender();
1188         uint256[] memory ids = _asSingletonArray(id);
1189         uint256[] memory amounts = _asSingletonArray(amount);
1190 
1191         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1192 
1193         uint256 fromBalance = _balances[id][from];
1194         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1195         unchecked {
1196             _balances[id][from] = fromBalance - amount;
1197         }
1198 
1199         emit TransferSingle(operator, from, address(0), id, amount);
1200 
1201         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1202     }
1203 
1204     /**
1205      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1206      *
1207      * Requirements:
1208      *
1209      * - `ids` and `amounts` must have the same length.
1210      */
1211     function _burnBatch(
1212         address from,
1213         uint256[] memory ids,
1214         uint256[] memory amounts
1215     ) internal virtual {
1216         require(from != address(0), "ERC1155: burn from the zero address");
1217         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1218 
1219         address operator = _msgSender();
1220 
1221         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1222 
1223         for (uint256 i = 0; i < ids.length; i++) {
1224             uint256 id = ids[i];
1225             uint256 amount = amounts[i];
1226 
1227             uint256 fromBalance = _balances[id][from];
1228             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1229             unchecked {
1230                 _balances[id][from] = fromBalance - amount;
1231             }
1232         }
1233 
1234         emit TransferBatch(operator, from, address(0), ids, amounts);
1235 
1236         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1237     }
1238 
1239     /**
1240      * @dev Approve `operator` to operate on all of `owner` tokens
1241      *
1242      * Emits a {ApprovalForAll} event.
1243      */
1244     function _setApprovalForAll(
1245         address owner,
1246         address operator,
1247         bool approved
1248     ) internal virtual {
1249         require(owner != operator, "ERC1155: setting approval status for self");
1250         _operatorApprovals[owner][operator] = approved;
1251         emit ApprovalForAll(owner, operator, approved);
1252     }
1253 
1254     /**
1255      * @dev Hook that is called before any token transfer. This includes minting
1256      * and burning, as well as batched variants.
1257      *
1258      * The same hook is called on both single and batched variants. For single
1259      * transfers, the length of the `id` and `amount` arrays will be 1.
1260      *
1261      * Calling conditions (for each `id` and `amount` pair):
1262      *
1263      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1264      * of token type `id` will be  transferred to `to`.
1265      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1266      * for `to`.
1267      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1268      * will be burned.
1269      * - `from` and `to` are never both zero.
1270      * - `ids` and `amounts` have the same, non-zero length.
1271      *
1272      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1273      */
1274     function _beforeTokenTransfer(
1275         address operator,
1276         address from,
1277         address to,
1278         uint256[] memory ids,
1279         uint256[] memory amounts,
1280         bytes memory data
1281     ) internal virtual {}
1282 
1283     /**
1284      * @dev Hook that is called after any token transfer. This includes minting
1285      * and burning, as well as batched variants.
1286      *
1287      * The same hook is called on both single and batched variants. For single
1288      * transfers, the length of the `id` and `amount` arrays will be 1.
1289      *
1290      * Calling conditions (for each `id` and `amount` pair):
1291      *
1292      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1293      * of token type `id` will be  transferred to `to`.
1294      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1295      * for `to`.
1296      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1297      * will be burned.
1298      * - `from` and `to` are never both zero.
1299      * - `ids` and `amounts` have the same, non-zero length.
1300      *
1301      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1302      */
1303     function _afterTokenTransfer(
1304         address operator,
1305         address from,
1306         address to,
1307         uint256[] memory ids,
1308         uint256[] memory amounts,
1309         bytes memory data
1310     ) internal virtual {}
1311 
1312     function _doSafeTransferAcceptanceCheck(
1313         address operator,
1314         address from,
1315         address to,
1316         uint256 id,
1317         uint256 amount,
1318         bytes memory data
1319     ) private {
1320         if (to.isContract()) {
1321             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1322                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1323                     revert("ERC1155: ERC1155Receiver rejected tokens");
1324                 }
1325             } catch Error(string memory reason) {
1326                 revert(reason);
1327             } catch {
1328                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1329             }
1330         }
1331     }
1332 
1333     function _doSafeBatchTransferAcceptanceCheck(
1334         address operator,
1335         address from,
1336         address to,
1337         uint256[] memory ids,
1338         uint256[] memory amounts,
1339         bytes memory data
1340     ) private {
1341         if (to.isContract()) {
1342             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1343                 bytes4 response
1344             ) {
1345                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1346                     revert("ERC1155: ERC1155Receiver rejected tokens");
1347                 }
1348             } catch Error(string memory reason) {
1349                 revert(reason);
1350             } catch {
1351                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1352             }
1353         }
1354     }
1355 
1356     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1357         uint256[] memory array = new uint256[](1);
1358         array[0] = element;
1359 
1360         return array;
1361     }
1362 }
1363 
1364 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1365 
1366 
1367 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1368 
1369 pragma solidity ^0.8.0;
1370 
1371 
1372 /**
1373  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1374  *
1375  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1376  * clearly identified. Note: While a totalSupply of 1 might mean the
1377  * corresponding is an NFT, there is no guarantees that no other token with the
1378  * same id are not going to be minted.
1379  */
1380 abstract contract ERC1155Supply is ERC1155 {
1381     mapping(uint256 => uint256) private _totalSupply;
1382 
1383     /**
1384      * @dev Total amount of tokens in with a given id.
1385      */
1386     function totalSupply(uint256 id) public view virtual returns (uint256) {
1387         return _totalSupply[id];
1388     }
1389 
1390     /**
1391      * @dev Indicates whether any token exist with a given id, or not.
1392      */
1393     function exists(uint256 id) public view virtual returns (bool) {
1394         return ERC1155Supply.totalSupply(id) > 0;
1395     }
1396 
1397     /**
1398      * @dev See {ERC1155-_beforeTokenTransfer}.
1399      */
1400     function _beforeTokenTransfer(
1401         address operator,
1402         address from,
1403         address to,
1404         uint256[] memory ids,
1405         uint256[] memory amounts,
1406         bytes memory data
1407     ) internal virtual override {
1408         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1409 
1410         if (from == address(0)) {
1411             for (uint256 i = 0; i < ids.length; ++i) {
1412                 _totalSupply[ids[i]] += amounts[i];
1413             }
1414         }
1415 
1416         if (to == address(0)) {
1417             for (uint256 i = 0; i < ids.length; ++i) {
1418                 uint256 id = ids[i];
1419                 uint256 amount = amounts[i];
1420                 uint256 supply = _totalSupply[id];
1421                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1422                 unchecked {
1423                     _totalSupply[id] = supply - amount;
1424                 }
1425             }
1426         }
1427     }
1428 }
1429 
1430 // File: omega.sol
1431 
1432 pragma solidity 0.8.7;
1433 
1434 /// SPDX-License-Identifier: UNLICENSED
1435 
1436 
1437 
1438 
1439 
1440 
1441 
1442 
1443 contract OmegaAlpha is ERC1155, ERC1155Supply, ReentrancyGuard, Ownable {
1444    
1445     using Strings for uint256;
1446     using Counters for Counters.Counter;
1447 
1448     Counters.Counter private _tokenIdTracker;
1449     
1450     bytes32 public OGmerkleRoot = 0x7f3b3801871c7a7e75b656612a741bd43c3c37c447d6e0ac1c688776085cfd32;
1451     bytes32 public WLmerkleRoot = 0x200586ee0c6321574e27a59d35f0e1a25475dec8c7e18f2ebfbcaee55e31a823;
1452 
1453     string public baseURI;
1454     string public baseExtension = ".json";
1455 
1456     uint256 public OGWLPrice = 0.066 ether;
1457     uint256 public WLPrice = 0.077 ether;
1458     uint256 public PublicPrice = 0.088 ether;
1459 
1460     uint256 public maxSupply = 333;
1461 
1462     bool public WLOpen = true;
1463     bool public PublicOpen = false;
1464 
1465     mapping (address => bool) public whitelistClaimed;
1466 
1467     mapping (address => bool) public publicClaimed;
1468 
1469     address[] private teamWallets = 
1470     [0x0e93545Edad0Ba8884bCEe70618c3D8D4D73d5B4, 0x222536857ddfD70Ed5ded3E1A0C2cCF4fB1ED9d3, 0xE4214F3ceA99B31f6bE6219FDF646EB4646936AC, 
1471     0xC4b72816dB9913A69D5A0AF41b477b51c8f598d3, 0xb84d84019Af5EeBf81b378E98567068dCB9B622b, 0x453f2a8e2ee8107E056BC71CDBF29322a1B73a53, 
1472     0x6ed655ED54910C1f85391f8e755F92927A381439, 0x1e868E0F5948Fc94ed99DDe0d0AbA939E7677b47, 0xe7858696eB520464E6415fB06fDB5ed9D157F9d8, 
1473     0xb94872bc787343e194c069FFeB7621cBea41FF73, 0x96232D041648046c17f428B3D7b5B8363944188b, 0x3fC1fF9fDb1a893B53870C993DE55FEe97Bf4DdB, 
1474     0xf402a5C9d709ED5b384Ba29f82445667F924EABF, 0xC54e976001aDAd914552eC95f3c14Aba80f47615, 0xBe68a874d11277AC4A6398b82dEf700553d74C3F, 
1475     0x111bb952E44fb1D43BD1D8861e965E0b0EcF5Df4, 0x12c8594991f6488CA330945850bBA200a992a185, 0xf932755165312e18b62484B9A23B517Cc07a7ba2,
1476     0x5B90eea54ed61a690db4429eC503436fFB3ACe91, 0xC54e976001aDAd914552eC95f3c14Aba80f47615, 0xa65C1768400Fe2c8355aA58595bf09FBE1a69631,
1477     0x643DcBC92592A2B24d9CAC834713f112Ceb8Ba60];
1478     
1479     constructor(string memory _initBaseURI) ERC1155(_initBaseURI)
1480     {
1481         setBaseURI(_initBaseURI);
1482 
1483         for(uint256 i=0; i<10; i++)
1484         {
1485             _tokenIdTracker.increment();
1486             _mint(msg.sender, 1, 1, "");
1487         }
1488         
1489         for(uint256 i=0; i<teamWallets.length; i++)
1490         {
1491             _tokenIdTracker.increment();
1492             _mint(teamWallets[i], 1, 1, "");
1493         }
1494     }   
1495 
1496     modifier onlySender {
1497         require(msg.sender == tx.origin);
1498         _;
1499     }
1500 
1501     function closeWL() public onlyOwner
1502     {
1503         WLOpen = false;
1504         PublicOpen = true;
1505     }
1506 
1507     modifier WLPhase()
1508     {
1509         require(WLOpen == true);
1510         _;
1511     }
1512 
1513     modifier PublicPhase()
1514     {
1515         require(PublicOpen == true);
1516         _;
1517     }
1518 
1519 
1520     function setMerkleRootOG(bytes32 incomingBytes) public onlyOwner
1521     {
1522         OGmerkleRoot = incomingBytes;
1523     }
1524 
1525     function setMerkleRootWL(bytes32 incomingBytes) public onlyOwner
1526     {
1527         WLmerkleRoot = incomingBytes;
1528     }
1529 
1530     function whitelistOG(bytes32[] calldata _merkleProof) public payable nonReentrant onlySender WLPhase
1531     {
1532         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1533         require(MerkleProof.verify(_merkleProof, OGmerkleRoot, leaf), "Invalid proof.");
1534         require(whitelistClaimed[msg.sender] == false);
1535         require(totalSupply() < maxSupply);
1536         require(msg.value >= OGWLPrice);
1537         
1538         whitelistClaimed[msg.sender] = true;
1539         _tokenIdTracker.increment();
1540         _mint(msg.sender, 1, 1, ""); 
1541     }
1542 
1543     function whitelistWL(bytes32[] calldata _merkleProof) public payable nonReentrant onlySender WLPhase
1544     {
1545         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1546         require(MerkleProof.verify(_merkleProof, WLmerkleRoot, leaf), "Invalid proof.");
1547         require(whitelistClaimed[msg.sender] == false);
1548         require(totalSupply() < maxSupply);
1549         require(msg.value >= WLPrice);
1550         
1551         whitelistClaimed[msg.sender] = true;
1552         _tokenIdTracker.increment();
1553         _mint(msg.sender, 1, 1, ""); 
1554     }
1555 
1556     function publicSale() public payable nonReentrant onlySender PublicPhase
1557     {
1558         require(msg.value >= PublicPrice);
1559         require(publicClaimed[msg.sender] == false);
1560         require(totalSupply() < maxSupply);
1561 
1562         publicClaimed[msg.sender] = true;
1563         _tokenIdTracker.increment();
1564         _mint(msg.sender, 1, 1, "");
1565         
1566     }
1567    
1568     function withdrawContractEther(address payable recipient) external onlyOwner
1569     {
1570         recipient.transfer(getBalance());
1571     }
1572     function getBalance() public view returns(uint)
1573     {
1574         return address(this).balance;
1575     }
1576     function totalSupply() public view returns (uint256) {
1577             return _tokenIdTracker.current();
1578     }
1579    
1580     function _baseURI() internal view virtual returns (string memory) {
1581         return baseURI;
1582     }
1583    
1584     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1585         baseURI = _newBaseURI;
1586     }
1587    
1588     function uri(uint256 tokenId) public view override virtual returns (string memory)
1589     {
1590         string memory currentBaseURI = _baseURI();
1591         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1592     }
1593 
1594     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1595         internal
1596         override(ERC1155, ERC1155Supply)
1597     {
1598         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1599     }
1600    
1601 
1602 }