1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev These functions deal with verification of Merkle Trees proofs.
76  *
77  * The proofs can be generated using the JavaScript library
78  * https://github.com/miguelmota/merkletreejs[merkletreejs].
79  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
80  *
81  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
82  *
83  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
84  * hashing, or use a hash function other than keccak256 for hashing leaves.
85  * This is because the concatenation of a sorted pair of internal nodes in
86  * the merkle tree could be reinterpreted as a leaf value.
87  */
88 library MerkleProof {
89     /**
90      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
91      * defined by `root`. For this, a `proof` must be provided, containing
92      * sibling hashes on the branch from the leaf to the root of the tree. Each
93      * pair of leaves and each pair of pre-images are assumed to be sorted.
94      */
95     function verify(
96         bytes32[] memory proof,
97         bytes32 root,
98         bytes32 leaf
99     ) internal pure returns (bool) {
100         return processProof(proof, leaf) == root;
101     }
102 
103     /**
104      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
105      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
106      * hash matches the root of the tree. When processing the proof, the pairs
107      * of leafs & pre-images are assumed to be sorted.
108      *
109      * _Available since v4.4._
110      */
111     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
112         bytes32 computedHash = leaf;
113         for (uint256 i = 0; i < proof.length; i++) {
114             bytes32 proofElement = proof[i];
115             if (computedHash <= proofElement) {
116                 // Hash(current computed hash + current element of the proof)
117                 computedHash = _efficientHash(computedHash, proofElement);
118             } else {
119                 // Hash(current element of the proof + current computed hash)
120                 computedHash = _efficientHash(proofElement, computedHash);
121             }
122         }
123         return computedHash;
124     }
125 
126     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
127         assembly {
128             mstore(0x00, a)
129             mstore(0x20, b)
130             value := keccak256(0x00, 0x40)
131         }
132     }
133 }
134 
135 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @title Counters
144  * @author Matt Condon (@shrugs)
145  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
146  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
147  *
148  * Include with `using Counters for Counters.Counter;`
149  */
150 library Counters {
151     struct Counter {
152         // This variable should never be directly accessed by users of the library: interactions must be restricted to
153         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
154         // this feature: see https://github.com/ethereum/solidity/issues/4637
155         uint256 _value; // default: 0
156     }
157 
158     function current(Counter storage counter) internal view returns (uint256) {
159         return counter._value;
160     }
161 
162     function increment(Counter storage counter) internal {
163         unchecked {
164             counter._value += 1;
165         }
166     }
167 
168     function decrement(Counter storage counter) internal {
169         uint256 value = counter._value;
170         require(value > 0, "Counter: decrement overflow");
171         unchecked {
172             counter._value = value - 1;
173         }
174     }
175 
176     function reset(Counter storage counter) internal {
177         counter._value = 0;
178     }
179 }
180 
181 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev String operations.
190  */
191 library Strings {
192     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
193 
194     /**
195      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
196      */
197     function toString(uint256 value) internal pure returns (string memory) {
198         // Inspired by OraclizeAPI's implementation - MIT licence
199         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
200 
201         if (value == 0) {
202             return "0";
203         }
204         uint256 temp = value;
205         uint256 digits;
206         while (temp != 0) {
207             digits++;
208             temp /= 10;
209         }
210         bytes memory buffer = new bytes(digits);
211         while (value != 0) {
212             digits -= 1;
213             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
214             value /= 10;
215         }
216         return string(buffer);
217     }
218 
219     /**
220      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
221      */
222     function toHexString(uint256 value) internal pure returns (string memory) {
223         if (value == 0) {
224             return "0x00";
225         }
226         uint256 temp = value;
227         uint256 length = 0;
228         while (temp != 0) {
229             length++;
230             temp >>= 8;
231         }
232         return toHexString(value, length);
233     }
234 
235     /**
236      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
237      */
238     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
239         bytes memory buffer = new bytes(2 * length + 2);
240         buffer[0] = "0";
241         buffer[1] = "x";
242         for (uint256 i = 2 * length + 1; i > 1; --i) {
243             buffer[i] = _HEX_SYMBOLS[value & 0xf];
244             value >>= 4;
245         }
246         require(value == 0, "Strings: hex length insufficient");
247         return string(buffer);
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
581 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @title ERC721 token receiver interface
590  * @dev Interface for any contract that wants to support safeTransfers
591  * from ERC721 asset contracts.
592  */
593 interface IERC721Receiver {
594     /**
595      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
596      * by `operator` from `from`, this function is called.
597      *
598      * It must return its Solidity selector to confirm the token transfer.
599      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
600      *
601      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
602      */
603     function onERC721Received(
604         address operator,
605         address from,
606         uint256 tokenId,
607         bytes calldata data
608     ) external returns (bytes4);
609 }
610 
611 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
612 
613 
614 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 /**
619  * @dev Interface of the ERC165 standard, as defined in the
620  * https://eips.ethereum.org/EIPS/eip-165[EIP].
621  *
622  * Implementers can declare support of contract interfaces, which can then be
623  * queried by others ({ERC165Checker}).
624  *
625  * For an implementation, see {ERC165}.
626  */
627 interface IERC165 {
628     /**
629      * @dev Returns true if this contract implements the interface defined by
630      * `interfaceId`. See the corresponding
631      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
632      * to learn more about how these ids are created.
633      *
634      * This function call must use less than 30 000 gas.
635      */
636     function supportsInterface(bytes4 interfaceId) external view returns (bool);
637 }
638 
639 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
640 
641 
642 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 
647 /**
648  * @dev _Available since v3.1._
649  */
650 interface IERC1155Receiver is IERC165 {
651     /**
652      * @dev Handles the receipt of a single ERC1155 token type. This function is
653      * called at the end of a `safeTransferFrom` after the balance has been updated.
654      *
655      * NOTE: To accept the transfer, this must return
656      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
657      * (i.e. 0xf23a6e61, or its own function selector).
658      *
659      * @param operator The address which initiated the transfer (i.e. msg.sender)
660      * @param from The address which previously owned the token
661      * @param id The ID of the token being transferred
662      * @param value The amount of tokens being transferred
663      * @param data Additional data with no specified format
664      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
665      */
666     function onERC1155Received(
667         address operator,
668         address from,
669         uint256 id,
670         uint256 value,
671         bytes calldata data
672     ) external returns (bytes4);
673 
674     /**
675      * @dev Handles the receipt of a multiple ERC1155 token types. This function
676      * is called at the end of a `safeBatchTransferFrom` after the balances have
677      * been updated.
678      *
679      * NOTE: To accept the transfer(s), this must return
680      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
681      * (i.e. 0xbc197c81, or its own function selector).
682      *
683      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
684      * @param from The address which previously owned the token
685      * @param ids An array containing ids of each token being transferred (order and length must match values array)
686      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
687      * @param data Additional data with no specified format
688      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
689      */
690     function onERC1155BatchReceived(
691         address operator,
692         address from,
693         uint256[] calldata ids,
694         uint256[] calldata values,
695         bytes calldata data
696     ) external returns (bytes4);
697 }
698 
699 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @dev Required interface of an ERC1155 compliant contract, as defined in the
709  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
710  *
711  * _Available since v3.1._
712  */
713 interface IERC1155 is IERC165 {
714     /**
715      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
716      */
717     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
718 
719     /**
720      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
721      * transfers.
722      */
723     event TransferBatch(
724         address indexed operator,
725         address indexed from,
726         address indexed to,
727         uint256[] ids,
728         uint256[] values
729     );
730 
731     /**
732      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
733      * `approved`.
734      */
735     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
736 
737     /**
738      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
739      *
740      * If an {URI} event was emitted for `id`, the standard
741      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
742      * returned by {IERC1155MetadataURI-uri}.
743      */
744     event URI(string value, uint256 indexed id);
745 
746     /**
747      * @dev Returns the amount of tokens of token type `id` owned by `account`.
748      *
749      * Requirements:
750      *
751      * - `account` cannot be the zero address.
752      */
753     function balanceOf(address account, uint256 id) external view returns (uint256);
754 
755     /**
756      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
757      *
758      * Requirements:
759      *
760      * - `accounts` and `ids` must have the same length.
761      */
762     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
763         external
764         view
765         returns (uint256[] memory);
766 
767     /**
768      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
769      *
770      * Emits an {ApprovalForAll} event.
771      *
772      * Requirements:
773      *
774      * - `operator` cannot be the caller.
775      */
776     function setApprovalForAll(address operator, bool approved) external;
777 
778     /**
779      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
780      *
781      * See {setApprovalForAll}.
782      */
783     function isApprovedForAll(address account, address operator) external view returns (bool);
784 
785     /**
786      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
787      *
788      * Emits a {TransferSingle} event.
789      *
790      * Requirements:
791      *
792      * - `to` cannot be the zero address.
793      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
794      * - `from` must have a balance of tokens of type `id` of at least `amount`.
795      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
796      * acceptance magic value.
797      */
798     function safeTransferFrom(
799         address from,
800         address to,
801         uint256 id,
802         uint256 amount,
803         bytes calldata data
804     ) external;
805 
806     /**
807      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
808      *
809      * Emits a {TransferBatch} event.
810      *
811      * Requirements:
812      *
813      * - `ids` and `amounts` must have the same length.
814      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
815      * acceptance magic value.
816      */
817     function safeBatchTransferFrom(
818         address from,
819         address to,
820         uint256[] calldata ids,
821         uint256[] calldata amounts,
822         bytes calldata data
823     ) external;
824 }
825 
826 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
827 
828 
829 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
830 
831 pragma solidity ^0.8.0;
832 
833 
834 /**
835  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
836  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
837  *
838  * _Available since v3.1._
839  */
840 interface IERC1155MetadataURI is IERC1155 {
841     /**
842      * @dev Returns the URI for token type `id`.
843      *
844      * If the `\{id\}` substring is present in the URI, it must be replaced by
845      * clients with the actual token type ID.
846      */
847     function uri(uint256 id) external view returns (string memory);
848 }
849 
850 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
851 
852 
853 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
854 
855 pragma solidity ^0.8.0;
856 
857 
858 /**
859  * @dev Implementation of the {IERC165} interface.
860  *
861  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
862  * for the additional interface id that will be supported. For example:
863  *
864  * ```solidity
865  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
866  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
867  * }
868  * ```
869  *
870  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
871  */
872 abstract contract ERC165 is IERC165 {
873     /**
874      * @dev See {IERC165-supportsInterface}.
875      */
876     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
877         return interfaceId == type(IERC165).interfaceId;
878     }
879 }
880 
881 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
882 
883 
884 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
885 
886 pragma solidity ^0.8.0;
887 
888 
889 
890 
891 
892 
893 
894 /**
895  * @dev Implementation of the basic standard multi-token.
896  * See https://eips.ethereum.org/EIPS/eip-1155
897  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
898  *
899  * _Available since v3.1._
900  */
901 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
902     using Address for address;
903 
904     // Mapping from token ID to account balances
905     mapping(uint256 => mapping(address => uint256)) private _balances;
906 
907     // Mapping from account to operator approvals
908     mapping(address => mapping(address => bool)) private _operatorApprovals;
909 
910     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
911     string private _uri;
912 
913     /**
914      * @dev See {_setURI}.
915      */
916     constructor(string memory uri_) {
917         _setURI(uri_);
918     }
919 
920     /**
921      * @dev See {IERC165-supportsInterface}.
922      */
923     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
924         return
925             interfaceId == type(IERC1155).interfaceId ||
926             interfaceId == type(IERC1155MetadataURI).interfaceId ||
927             super.supportsInterface(interfaceId);
928     }
929 
930     /**
931      * @dev See {IERC1155MetadataURI-uri}.
932      *
933      * This implementation returns the same URI for *all* token types. It relies
934      * on the token type ID substitution mechanism
935      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
936      *
937      * Clients calling this function must replace the `\{id\}` substring with the
938      * actual token type ID.
939      */
940     function uri(uint256) public view virtual override returns (string memory) {
941         return _uri;
942     }
943 
944     /**
945      * @dev See {IERC1155-balanceOf}.
946      *
947      * Requirements:
948      *
949      * - `account` cannot be the zero address.
950      */
951     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
952         require(account != address(0), "ERC1155: balance query for the zero address");
953         return _balances[id][account];
954     }
955 
956     /**
957      * @dev See {IERC1155-balanceOfBatch}.
958      *
959      * Requirements:
960      *
961      * - `accounts` and `ids` must have the same length.
962      */
963     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
964         public
965         view
966         virtual
967         override
968         returns (uint256[] memory)
969     {
970         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
971 
972         uint256[] memory batchBalances = new uint256[](accounts.length);
973 
974         for (uint256 i = 0; i < accounts.length; ++i) {
975             batchBalances[i] = balanceOf(accounts[i], ids[i]);
976         }
977 
978         return batchBalances;
979     }
980 
981     /**
982      * @dev See {IERC1155-setApprovalForAll}.
983      */
984     function setApprovalForAll(address operator, bool approved) public virtual override {
985         _setApprovalForAll(_msgSender(), operator, approved);
986     }
987 
988     /**
989      * @dev See {IERC1155-isApprovedForAll}.
990      */
991     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
992         return _operatorApprovals[account][operator];
993     }
994 
995     /**
996      * @dev See {IERC1155-safeTransferFrom}.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 id,
1002         uint256 amount,
1003         bytes memory data
1004     ) public virtual override {
1005         require(
1006             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1007             "ERC1155: caller is not owner nor approved"
1008         );
1009         _safeTransferFrom(from, to, id, amount, data);
1010     }
1011 
1012     /**
1013      * @dev See {IERC1155-safeBatchTransferFrom}.
1014      */
1015     function safeBatchTransferFrom(
1016         address from,
1017         address to,
1018         uint256[] memory ids,
1019         uint256[] memory amounts,
1020         bytes memory data
1021     ) public virtual override {
1022         require(
1023             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1024             "ERC1155: transfer caller is not owner nor approved"
1025         );
1026         _safeBatchTransferFrom(from, to, ids, amounts, data);
1027     }
1028 
1029     /**
1030      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1031      *
1032      * Emits a {TransferSingle} event.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1038      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1039      * acceptance magic value.
1040      */
1041     function _safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 id,
1045         uint256 amount,
1046         bytes memory data
1047     ) internal virtual {
1048         require(to != address(0), "ERC1155: transfer to the zero address");
1049 
1050         address operator = _msgSender();
1051         uint256[] memory ids = _asSingletonArray(id);
1052         uint256[] memory amounts = _asSingletonArray(amount);
1053 
1054         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1055 
1056         uint256 fromBalance = _balances[id][from];
1057         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1058         unchecked {
1059             _balances[id][from] = fromBalance - amount;
1060         }
1061         _balances[id][to] += amount;
1062 
1063         emit TransferSingle(operator, from, to, id, amount);
1064 
1065         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1066 
1067         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1068     }
1069 
1070     /**
1071      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1072      *
1073      * Emits a {TransferBatch} event.
1074      *
1075      * Requirements:
1076      *
1077      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1078      * acceptance magic value.
1079      */
1080     function _safeBatchTransferFrom(
1081         address from,
1082         address to,
1083         uint256[] memory ids,
1084         uint256[] memory amounts,
1085         bytes memory data
1086     ) internal virtual {
1087         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1088         require(to != address(0), "ERC1155: transfer to the zero address");
1089 
1090         address operator = _msgSender();
1091 
1092         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1093 
1094         for (uint256 i = 0; i < ids.length; ++i) {
1095             uint256 id = ids[i];
1096             uint256 amount = amounts[i];
1097 
1098             uint256 fromBalance = _balances[id][from];
1099             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1100             unchecked {
1101                 _balances[id][from] = fromBalance - amount;
1102             }
1103             _balances[id][to] += amount;
1104         }
1105 
1106         emit TransferBatch(operator, from, to, ids, amounts);
1107 
1108         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1109 
1110         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1111     }
1112 
1113     /**
1114      * @dev Sets a new URI for all token types, by relying on the token type ID
1115      * substitution mechanism
1116      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1117      *
1118      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1119      * URI or any of the amounts in the JSON file at said URI will be replaced by
1120      * clients with the token type ID.
1121      *
1122      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1123      * interpreted by clients as
1124      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1125      * for token type ID 0x4cce0.
1126      *
1127      * See {uri}.
1128      *
1129      * Because these URIs cannot be meaningfully represented by the {URI} event,
1130      * this function emits no events.
1131      */
1132     function _setURI(string memory newuri) internal virtual {
1133         _uri = newuri;
1134     }
1135 
1136     /**
1137      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1138      *
1139      * Emits a {TransferSingle} event.
1140      *
1141      * Requirements:
1142      *
1143      * - `to` cannot be the zero address.
1144      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1145      * acceptance magic value.
1146      */
1147     function _mint(
1148         address to,
1149         uint256 id,
1150         uint256 amount,
1151         bytes memory data
1152     ) internal virtual {
1153         require(to != address(0), "ERC1155: mint to the zero address");
1154 
1155         address operator = _msgSender();
1156         uint256[] memory ids = _asSingletonArray(id);
1157         uint256[] memory amounts = _asSingletonArray(amount);
1158 
1159         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1160 
1161         _balances[id][to] += amount;
1162         emit TransferSingle(operator, address(0), to, id, amount);
1163 
1164         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1165 
1166         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1167     }
1168 
1169     /**
1170      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1171      *
1172      * Requirements:
1173      *
1174      * - `ids` and `amounts` must have the same length.
1175      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1176      * acceptance magic value.
1177      */
1178     function _mintBatch(
1179         address to,
1180         uint256[] memory ids,
1181         uint256[] memory amounts,
1182         bytes memory data
1183     ) internal virtual {
1184         require(to != address(0), "ERC1155: mint to the zero address");
1185         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1186 
1187         address operator = _msgSender();
1188 
1189         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1190 
1191         for (uint256 i = 0; i < ids.length; i++) {
1192             _balances[ids[i]][to] += amounts[i];
1193         }
1194 
1195         emit TransferBatch(operator, address(0), to, ids, amounts);
1196 
1197         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1198 
1199         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1200     }
1201 
1202     /**
1203      * @dev Destroys `amount` tokens of token type `id` from `from`
1204      *
1205      * Requirements:
1206      *
1207      * - `from` cannot be the zero address.
1208      * - `from` must have at least `amount` tokens of token type `id`.
1209      */
1210     function _burn(
1211         address from,
1212         uint256 id,
1213         uint256 amount
1214     ) internal virtual {
1215         require(from != address(0), "ERC1155: burn from the zero address");
1216 
1217         address operator = _msgSender();
1218         uint256[] memory ids = _asSingletonArray(id);
1219         uint256[] memory amounts = _asSingletonArray(amount);
1220 
1221         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1222 
1223         uint256 fromBalance = _balances[id][from];
1224         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1225         unchecked {
1226             _balances[id][from] = fromBalance - amount;
1227         }
1228 
1229         emit TransferSingle(operator, from, address(0), id, amount);
1230 
1231         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1232     }
1233 
1234     /**
1235      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1236      *
1237      * Requirements:
1238      *
1239      * - `ids` and `amounts` must have the same length.
1240      */
1241     function _burnBatch(
1242         address from,
1243         uint256[] memory ids,
1244         uint256[] memory amounts
1245     ) internal virtual {
1246         require(from != address(0), "ERC1155: burn from the zero address");
1247         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1248 
1249         address operator = _msgSender();
1250 
1251         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1252 
1253         for (uint256 i = 0; i < ids.length; i++) {
1254             uint256 id = ids[i];
1255             uint256 amount = amounts[i];
1256 
1257             uint256 fromBalance = _balances[id][from];
1258             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1259             unchecked {
1260                 _balances[id][from] = fromBalance - amount;
1261             }
1262         }
1263 
1264         emit TransferBatch(operator, from, address(0), ids, amounts);
1265 
1266         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1267     }
1268 
1269     /**
1270      * @dev Approve `operator` to operate on all of `owner` tokens
1271      *
1272      * Emits a {ApprovalForAll} event.
1273      */
1274     function _setApprovalForAll(
1275         address owner,
1276         address operator,
1277         bool approved
1278     ) internal virtual {
1279         require(owner != operator, "ERC1155: setting approval status for self");
1280         _operatorApprovals[owner][operator] = approved;
1281         emit ApprovalForAll(owner, operator, approved);
1282     }
1283 
1284     /**
1285      * @dev Hook that is called before any token transfer. This includes minting
1286      * and burning, as well as batched variants.
1287      *
1288      * The same hook is called on both single and batched variants. For single
1289      * transfers, the length of the `id` and `amount` arrays will be 1.
1290      *
1291      * Calling conditions (for each `id` and `amount` pair):
1292      *
1293      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1294      * of token type `id` will be  transferred to `to`.
1295      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1296      * for `to`.
1297      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1298      * will be burned.
1299      * - `from` and `to` are never both zero.
1300      * - `ids` and `amounts` have the same, non-zero length.
1301      *
1302      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1303      */
1304     function _beforeTokenTransfer(
1305         address operator,
1306         address from,
1307         address to,
1308         uint256[] memory ids,
1309         uint256[] memory amounts,
1310         bytes memory data
1311     ) internal virtual {}
1312 
1313     /**
1314      * @dev Hook that is called after any token transfer. This includes minting
1315      * and burning, as well as batched variants.
1316      *
1317      * The same hook is called on both single and batched variants. For single
1318      * transfers, the length of the `id` and `amount` arrays will be 1.
1319      *
1320      * Calling conditions (for each `id` and `amount` pair):
1321      *
1322      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1323      * of token type `id` will be  transferred to `to`.
1324      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1325      * for `to`.
1326      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1327      * will be burned.
1328      * - `from` and `to` are never both zero.
1329      * - `ids` and `amounts` have the same, non-zero length.
1330      *
1331      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1332      */
1333     function _afterTokenTransfer(
1334         address operator,
1335         address from,
1336         address to,
1337         uint256[] memory ids,
1338         uint256[] memory amounts,
1339         bytes memory data
1340     ) internal virtual {}
1341 
1342     function _doSafeTransferAcceptanceCheck(
1343         address operator,
1344         address from,
1345         address to,
1346         uint256 id,
1347         uint256 amount,
1348         bytes memory data
1349     ) private {
1350         if (to.isContract()) {
1351             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1352                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1353                     revert("ERC1155: ERC1155Receiver rejected tokens");
1354                 }
1355             } catch Error(string memory reason) {
1356                 revert(reason);
1357             } catch {
1358                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1359             }
1360         }
1361     }
1362 
1363     function _doSafeBatchTransferAcceptanceCheck(
1364         address operator,
1365         address from,
1366         address to,
1367         uint256[] memory ids,
1368         uint256[] memory amounts,
1369         bytes memory data
1370     ) private {
1371         if (to.isContract()) {
1372             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1373                 bytes4 response
1374             ) {
1375                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1376                     revert("ERC1155: ERC1155Receiver rejected tokens");
1377                 }
1378             } catch Error(string memory reason) {
1379                 revert(reason);
1380             } catch {
1381                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1382             }
1383         }
1384     }
1385 
1386     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1387         uint256[] memory array = new uint256[](1);
1388         array[0] = element;
1389 
1390         return array;
1391     }
1392 }
1393 
1394 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1395 
1396 
1397 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
1398 
1399 pragma solidity ^0.8.0;
1400 
1401 
1402 /**
1403  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1404  * own tokens and those that they have been approved to use.
1405  *
1406  * _Available since v3.1._
1407  */
1408 abstract contract ERC1155Burnable is ERC1155 {
1409     function burn(
1410         address account,
1411         uint256 id,
1412         uint256 value
1413     ) public virtual {
1414         require(
1415             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1416             "ERC1155: caller is not owner nor approved"
1417         );
1418 
1419         _burn(account, id, value);
1420     }
1421 
1422     function burnBatch(
1423         address account,
1424         uint256[] memory ids,
1425         uint256[] memory values
1426     ) public virtual {
1427         require(
1428             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1429             "ERC1155: caller is not owner nor approved"
1430         );
1431 
1432         _burnBatch(account, ids, values);
1433     }
1434 }
1435 
1436 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1437 
1438 
1439 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1440 
1441 pragma solidity ^0.8.0;
1442 
1443 
1444 /**
1445  * @dev Required interface of an ERC721 compliant contract.
1446  */
1447 interface IERC721 is IERC165 {
1448     /**
1449      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1450      */
1451     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1452 
1453     /**
1454      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1455      */
1456     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1457 
1458     /**
1459      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1460      */
1461     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1462 
1463     /**
1464      * @dev Returns the number of tokens in ``owner``'s account.
1465      */
1466     function balanceOf(address owner) external view returns (uint256 balance);
1467 
1468     /**
1469      * @dev Returns the owner of the `tokenId` token.
1470      *
1471      * Requirements:
1472      *
1473      * - `tokenId` must exist.
1474      */
1475     function ownerOf(uint256 tokenId) external view returns (address owner);
1476 
1477     /**
1478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1480      *
1481      * Requirements:
1482      *
1483      * - `from` cannot be the zero address.
1484      * - `to` cannot be the zero address.
1485      * - `tokenId` token must exist and be owned by `from`.
1486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1488      *
1489      * Emits a {Transfer} event.
1490      */
1491     function safeTransferFrom(
1492         address from,
1493         address to,
1494         uint256 tokenId
1495     ) external;
1496 
1497     /**
1498      * @dev Transfers `tokenId` token from `from` to `to`.
1499      *
1500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1501      *
1502      * Requirements:
1503      *
1504      * - `from` cannot be the zero address.
1505      * - `to` cannot be the zero address.
1506      * - `tokenId` token must be owned by `from`.
1507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function transferFrom(
1512         address from,
1513         address to,
1514         uint256 tokenId
1515     ) external;
1516 
1517     /**
1518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1519      * The approval is cleared when the token is transferred.
1520      *
1521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1522      *
1523      * Requirements:
1524      *
1525      * - The caller must own the token or be an approved operator.
1526      * - `tokenId` must exist.
1527      *
1528      * Emits an {Approval} event.
1529      */
1530     function approve(address to, uint256 tokenId) external;
1531 
1532     /**
1533      * @dev Returns the account approved for `tokenId` token.
1534      *
1535      * Requirements:
1536      *
1537      * - `tokenId` must exist.
1538      */
1539     function getApproved(uint256 tokenId) external view returns (address operator);
1540 
1541     /**
1542      * @dev Approve or remove `operator` as an operator for the caller.
1543      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1544      *
1545      * Requirements:
1546      *
1547      * - The `operator` cannot be the caller.
1548      *
1549      * Emits an {ApprovalForAll} event.
1550      */
1551     function setApprovalForAll(address operator, bool _approved) external;
1552 
1553     /**
1554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1555      *
1556      * See {setApprovalForAll}
1557      */
1558     function isApprovedForAll(address owner, address operator) external view returns (bool);
1559 
1560     /**
1561      * @dev Safely transfers `tokenId` token from `from` to `to`.
1562      *
1563      * Requirements:
1564      *
1565      * - `from` cannot be the zero address.
1566      * - `to` cannot be the zero address.
1567      * - `tokenId` token must exist and be owned by `from`.
1568      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1570      *
1571      * Emits a {Transfer} event.
1572      */
1573     function safeTransferFrom(
1574         address from,
1575         address to,
1576         uint256 tokenId,
1577         bytes calldata data
1578     ) external;
1579 }
1580 
1581 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1582 
1583 
1584 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 /**
1590  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1591  * @dev See https://eips.ethereum.org/EIPS/eip-721
1592  */
1593 interface IERC721Metadata is IERC721 {
1594     /**
1595      * @dev Returns the token collection name.
1596      */
1597     function name() external view returns (string memory);
1598 
1599     /**
1600      * @dev Returns the token collection symbol.
1601      */
1602     function symbol() external view returns (string memory);
1603 
1604     /**
1605      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1606      */
1607     function tokenURI(uint256 tokenId) external view returns (string memory);
1608 }
1609 
1610 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1611 
1612 
1613 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1614 
1615 pragma solidity ^0.8.0;
1616 
1617 
1618 
1619 
1620 
1621 
1622 
1623 
1624 /**
1625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1626  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1627  * {ERC721Enumerable}.
1628  */
1629 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1630     using Address for address;
1631     using Strings for uint256;
1632 
1633     // Token name
1634     string private _name;
1635 
1636     // Token symbol
1637     string private _symbol;
1638 
1639     // Mapping from token ID to owner address
1640     mapping(uint256 => address) private _owners;
1641 
1642     // Mapping owner address to token count
1643     mapping(address => uint256) private _balances;
1644 
1645     // Mapping from token ID to approved address
1646     mapping(uint256 => address) private _tokenApprovals;
1647 
1648     // Mapping from owner to operator approvals
1649     mapping(address => mapping(address => bool)) private _operatorApprovals;
1650 
1651     /**
1652      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1653      */
1654     constructor(string memory name_, string memory symbol_) {
1655         _name = name_;
1656         _symbol = symbol_;
1657     }
1658 
1659     /**
1660      * @dev See {IERC165-supportsInterface}.
1661      */
1662     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1663         return
1664             interfaceId == type(IERC721).interfaceId ||
1665             interfaceId == type(IERC721Metadata).interfaceId ||
1666             super.supportsInterface(interfaceId);
1667     }
1668 
1669     /**
1670      * @dev See {IERC721-balanceOf}.
1671      */
1672     function balanceOf(address owner) public view virtual override returns (uint256) {
1673         require(owner != address(0), "ERC721: balance query for the zero address");
1674         return _balances[owner];
1675     }
1676 
1677     /**
1678      * @dev See {IERC721-ownerOf}.
1679      */
1680     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1681         address owner = _owners[tokenId];
1682         require(owner != address(0), "ERC721: owner query for nonexistent token");
1683         return owner;
1684     }
1685 
1686     /**
1687      * @dev See {IERC721Metadata-name}.
1688      */
1689     function name() public view virtual override returns (string memory) {
1690         return _name;
1691     }
1692 
1693     /**
1694      * @dev See {IERC721Metadata-symbol}.
1695      */
1696     function symbol() public view virtual override returns (string memory) {
1697         return _symbol;
1698     }
1699 
1700     /**
1701      * @dev See {IERC721Metadata-tokenURI}.
1702      */
1703     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1704         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1705 
1706         string memory baseURI = _baseURI();
1707         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1708     }
1709 
1710     /**
1711      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1712      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1713      * by default, can be overridden in child contracts.
1714      */
1715     function _baseURI() internal view virtual returns (string memory) {
1716         return "";
1717     }
1718 
1719     /**
1720      * @dev See {IERC721-approve}.
1721      */
1722     function approve(address to, uint256 tokenId) public virtual override {
1723         address owner = ERC721.ownerOf(tokenId);
1724         require(to != owner, "ERC721: approval to current owner");
1725 
1726         require(
1727             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1728             "ERC721: approve caller is not owner nor approved for all"
1729         );
1730 
1731         _approve(to, tokenId);
1732     }
1733 
1734     /**
1735      * @dev See {IERC721-getApproved}.
1736      */
1737     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1738         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1739 
1740         return _tokenApprovals[tokenId];
1741     }
1742 
1743     /**
1744      * @dev See {IERC721-setApprovalForAll}.
1745      */
1746     function setApprovalForAll(address operator, bool approved) public virtual override {
1747         _setApprovalForAll(_msgSender(), operator, approved);
1748     }
1749 
1750     /**
1751      * @dev See {IERC721-isApprovedForAll}.
1752      */
1753     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1754         return _operatorApprovals[owner][operator];
1755     }
1756 
1757     /**
1758      * @dev See {IERC721-transferFrom}.
1759      */
1760     function transferFrom(
1761         address from,
1762         address to,
1763         uint256 tokenId
1764     ) public virtual override {
1765         //solhint-disable-next-line max-line-length
1766         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1767 
1768         _transfer(from, to, tokenId);
1769     }
1770 
1771     /**
1772      * @dev See {IERC721-safeTransferFrom}.
1773      */
1774     function safeTransferFrom(
1775         address from,
1776         address to,
1777         uint256 tokenId
1778     ) public virtual override {
1779         safeTransferFrom(from, to, tokenId, "");
1780     }
1781 
1782     /**
1783      * @dev See {IERC721-safeTransferFrom}.
1784      */
1785     function safeTransferFrom(
1786         address from,
1787         address to,
1788         uint256 tokenId,
1789         bytes memory _data
1790     ) public virtual override {
1791         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1792         _safeTransfer(from, to, tokenId, _data);
1793     }
1794 
1795     /**
1796      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1797      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1798      *
1799      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1800      *
1801      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1802      * implement alternative mechanisms to perform token transfer, such as signature-based.
1803      *
1804      * Requirements:
1805      *
1806      * - `from` cannot be the zero address.
1807      * - `to` cannot be the zero address.
1808      * - `tokenId` token must exist and be owned by `from`.
1809      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1810      *
1811      * Emits a {Transfer} event.
1812      */
1813     function _safeTransfer(
1814         address from,
1815         address to,
1816         uint256 tokenId,
1817         bytes memory _data
1818     ) internal virtual {
1819         _transfer(from, to, tokenId);
1820         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1821     }
1822 
1823     /**
1824      * @dev Returns whether `tokenId` exists.
1825      *
1826      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1827      *
1828      * Tokens start existing when they are minted (`_mint`),
1829      * and stop existing when they are burned (`_burn`).
1830      */
1831     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1832         return _owners[tokenId] != address(0);
1833     }
1834 
1835     /**
1836      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1837      *
1838      * Requirements:
1839      *
1840      * - `tokenId` must exist.
1841      */
1842     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1843         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1844         address owner = ERC721.ownerOf(tokenId);
1845         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1846     }
1847 
1848     /**
1849      * @dev Safely mints `tokenId` and transfers it to `to`.
1850      *
1851      * Requirements:
1852      *
1853      * - `tokenId` must not exist.
1854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1855      *
1856      * Emits a {Transfer} event.
1857      */
1858     function _safeMint(address to, uint256 tokenId) internal virtual {
1859         _safeMint(to, tokenId, "");
1860     }
1861 
1862     /**
1863      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1864      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1865      */
1866     function _safeMint(
1867         address to,
1868         uint256 tokenId,
1869         bytes memory _data
1870     ) internal virtual {
1871         _mint(to, tokenId);
1872         require(
1873             _checkOnERC721Received(address(0), to, tokenId, _data),
1874             "ERC721: transfer to non ERC721Receiver implementer"
1875         );
1876     }
1877 
1878     /**
1879      * @dev Mints `tokenId` and transfers it to `to`.
1880      *
1881      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1882      *
1883      * Requirements:
1884      *
1885      * - `tokenId` must not exist.
1886      * - `to` cannot be the zero address.
1887      *
1888      * Emits a {Transfer} event.
1889      */
1890     function _mint(address to, uint256 tokenId) internal virtual {
1891         require(to != address(0), "ERC721: mint to the zero address");
1892         require(!_exists(tokenId), "ERC721: token already minted");
1893 
1894         _beforeTokenTransfer(address(0), to, tokenId);
1895 
1896         _balances[to] += 1;
1897         _owners[tokenId] = to;
1898 
1899         emit Transfer(address(0), to, tokenId);
1900 
1901         _afterTokenTransfer(address(0), to, tokenId);
1902     }
1903 
1904     /**
1905      * @dev Destroys `tokenId`.
1906      * The approval is cleared when the token is burned.
1907      *
1908      * Requirements:
1909      *
1910      * - `tokenId` must exist.
1911      *
1912      * Emits a {Transfer} event.
1913      */
1914     function _burn(uint256 tokenId) internal virtual {
1915         address owner = ERC721.ownerOf(tokenId);
1916 
1917         _beforeTokenTransfer(owner, address(0), tokenId);
1918 
1919         // Clear approvals
1920         _approve(address(0), tokenId);
1921 
1922         _balances[owner] -= 1;
1923         delete _owners[tokenId];
1924 
1925         emit Transfer(owner, address(0), tokenId);
1926 
1927         _afterTokenTransfer(owner, address(0), tokenId);
1928     }
1929 
1930     /**
1931      * @dev Transfers `tokenId` from `from` to `to`.
1932      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1933      *
1934      * Requirements:
1935      *
1936      * - `to` cannot be the zero address.
1937      * - `tokenId` token must be owned by `from`.
1938      *
1939      * Emits a {Transfer} event.
1940      */
1941     function _transfer(
1942         address from,
1943         address to,
1944         uint256 tokenId
1945     ) internal virtual {
1946         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1947         require(to != address(0), "ERC721: transfer to the zero address");
1948 
1949         _beforeTokenTransfer(from, to, tokenId);
1950 
1951         // Clear approvals from the previous owner
1952         _approve(address(0), tokenId);
1953 
1954         _balances[from] -= 1;
1955         _balances[to] += 1;
1956         _owners[tokenId] = to;
1957 
1958         emit Transfer(from, to, tokenId);
1959 
1960         _afterTokenTransfer(from, to, tokenId);
1961     }
1962 
1963     /**
1964      * @dev Approve `to` to operate on `tokenId`
1965      *
1966      * Emits a {Approval} event.
1967      */
1968     function _approve(address to, uint256 tokenId) internal virtual {
1969         _tokenApprovals[tokenId] = to;
1970         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1971     }
1972 
1973     /**
1974      * @dev Approve `operator` to operate on all of `owner` tokens
1975      *
1976      * Emits a {ApprovalForAll} event.
1977      */
1978     function _setApprovalForAll(
1979         address owner,
1980         address operator,
1981         bool approved
1982     ) internal virtual {
1983         require(owner != operator, "ERC721: approve to caller");
1984         _operatorApprovals[owner][operator] = approved;
1985         emit ApprovalForAll(owner, operator, approved);
1986     }
1987 
1988     /**
1989      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1990      * The call is not executed if the target address is not a contract.
1991      *
1992      * @param from address representing the previous owner of the given token ID
1993      * @param to target address that will receive the tokens
1994      * @param tokenId uint256 ID of the token to be transferred
1995      * @param _data bytes optional data to send along with the call
1996      * @return bool whether the call correctly returned the expected magic value
1997      */
1998     function _checkOnERC721Received(
1999         address from,
2000         address to,
2001         uint256 tokenId,
2002         bytes memory _data
2003     ) private returns (bool) {
2004         if (to.isContract()) {
2005             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2006                 return retval == IERC721Receiver.onERC721Received.selector;
2007             } catch (bytes memory reason) {
2008                 if (reason.length == 0) {
2009                     revert("ERC721: transfer to non ERC721Receiver implementer");
2010                 } else {
2011                     assembly {
2012                         revert(add(32, reason), mload(reason))
2013                     }
2014                 }
2015             }
2016         } else {
2017             return true;
2018         }
2019     }
2020 
2021     /**
2022      * @dev Hook that is called before any token transfer. This includes minting
2023      * and burning.
2024      *
2025      * Calling conditions:
2026      *
2027      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2028      * transferred to `to`.
2029      * - When `from` is zero, `tokenId` will be minted for `to`.
2030      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2031      * - `from` and `to` are never both zero.
2032      *
2033      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2034      */
2035     function _beforeTokenTransfer(
2036         address from,
2037         address to,
2038         uint256 tokenId
2039     ) internal virtual {}
2040 
2041     /**
2042      * @dev Hook that is called after any transfer of tokens. This includes
2043      * minting and burning.
2044      *
2045      * Calling conditions:
2046      *
2047      * - when `from` and `to` are both non-zero.
2048      * - `from` and `to` are never both zero.
2049      *
2050      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2051      */
2052     function _afterTokenTransfer(
2053         address from,
2054         address to,
2055         uint256 tokenId
2056     ) internal virtual {}
2057 }
2058 
2059 // File: slape.sol
2060 
2061 pragma solidity ^0.8.0;
2062 
2063 
2064 
2065 /*
2066   ______                                 __          _    _                       _                             
2067 .' ____ \                               [  |        / |_ (_)                     / \                            
2068 | (___ \_|__   _  _ .--.   .---.  _ .--. | |  ,--. `| |-'__  _   __  .---.      / _ \    _ .--.   .---.  .--.   
2069  _.____`.[  | | |[ '/'`\ \/ /__\\[ `/'`\]| | `'_\ : | | [  |[ \ [  ]/ /__\\    / ___ \  [ '/'`\ \/ /__\\( (`\]  
2070 | \____) || \_/ |,| \__/ || \__., | |    | | // | |,| |, | | \ \/ / | \__.,  _/ /   \ \_ | \__/ || \__., `'.'.  
2071  \______.''.__.'_/| ;.__/  '.__.'[___]  [___]\'-;__/\__/[___] \__/   '.__.' |____| |____|| ;.__/  '.__.'[\__) ) 
2072                  [__|                                                                   [__|                        
2073 */
2074 
2075 
2076 contract SUPERLATIVEAPES is ERC721, Ownable {
2077    
2078     using Strings for uint256;
2079     using Counters for Counters.Counter;
2080 
2081     string public baseURI;
2082     string public baseExtension = ".json";
2083 
2084 
2085     uint256 public maxTx = 5;
2086     uint256 public maxPreTx = 2;
2087     uint256 public maxSupply = 4444;
2088     uint256 public presaleSupply = 2400;
2089     uint256 public price = 0.069 ether;
2090    
2091    
2092     //December 16th 3AM GMT
2093     uint256 public presaleTime = 1639623600;
2094     //December 16th 11PM GMT 
2095     uint256 public presaleClose = 1639695600;
2096 
2097     //December 17th 3AM GMT
2098     uint256 public mainsaleTime = 1639710000;
2099    
2100     Counters.Counter private _tokenIdTracker;
2101 
2102     mapping (address => bool) public presaleWallets;
2103     mapping (address => uint256) public presaleWalletLimits;
2104     mapping (address => uint256) public mainsaleWalletLimits;
2105 
2106 
2107     modifier isMainsaleOpen
2108     {
2109          require(block.timestamp >= mainsaleTime);
2110          _;
2111     }
2112     modifier isPresaleOpen
2113     {
2114          require(block.timestamp >= presaleTime && block.timestamp <= presaleClose, "Presale closed!");
2115          _;
2116     }
2117    
2118     constructor(string memory _initBaseURI) ERC721("Superlative Apes", "SLAPE")
2119     {
2120         setBaseURI(_initBaseURI);
2121         for(uint256 i=0; i<80; i++)
2122         {
2123             _tokenIdTracker.increment();
2124             _safeMint(msg.sender, totalToken());
2125         }
2126         
2127     }
2128    
2129     function setPrice(uint256 newPrice) external onlyOwner  {
2130         price = newPrice;
2131     }
2132    
2133     function setMaxTx(uint newMax) external onlyOwner {
2134         maxTx = newMax;
2135     }
2136 
2137     function totalToken() public view returns (uint256) {
2138             return _tokenIdTracker.current();
2139     }
2140 
2141     function mainSale(uint8 mintTotal) public payable isMainsaleOpen
2142     {
2143         uint256 totalMinted = mintTotal + mainsaleWalletLimits[msg.sender];
2144         
2145         require(mintTotal >= 1 && mintTotal <= maxTx, "Mint Amount Incorrect");
2146         require(msg.value >= price * mintTotal, "Minting a SLAPE APE Costs 0.069 Ether Each!");
2147         require(totalToken() <= maxSupply, "SOLD OUT!");
2148         require(totalMinted <= maxTx, "You'll pass mint limit!");
2149        
2150         for(uint i=0;i<mintTotal;i++)
2151         {
2152             mainsaleWalletLimits[msg.sender]++;
2153             _tokenIdTracker.increment();
2154             require(totalToken() <= maxSupply, "SOLD OUT!");
2155             _safeMint(msg.sender, totalToken());
2156         }
2157     }
2158    
2159     function preSale(uint8 mintTotal) public payable isPresaleOpen
2160     {
2161         uint256 totalMinted = mintTotal + presaleWalletLimits[msg.sender];
2162 
2163         require(presaleWallets[msg.sender] == true, "You aren't whitelisted!");
2164         require(mintTotal >= 1 && mintTotal <= maxTx, "Mint Amount Incorrect");
2165         require(msg.value >= price * mintTotal, "Minting a SLAPE APE Costs 0.069 Ether Each!");
2166         require(totalToken() <= presaleSupply, "SOLD OUT!");
2167         require(totalMinted <= maxPreTx, "You'll pass mint limit!");
2168        
2169         for(uint i=0; i<mintTotal; i++)
2170         {
2171             presaleWalletLimits[msg.sender]++;
2172             _tokenIdTracker.increment();
2173             require(totalToken() <= presaleSupply, "SOLD OUT!");
2174             _safeMint(msg.sender, totalToken());
2175         }
2176        
2177     }
2178    
2179     function airdrop(address airdropPatricipent, uint8 tokenID) public payable onlyOwner
2180     {
2181         _transfer(address(this), airdropPatricipent, tokenID);
2182     }
2183    
2184     function addWhiteList(address[] memory whiteListedAddresses) public onlyOwner
2185     {
2186         for(uint256 i=0; i<whiteListedAddresses.length;i++)
2187         {
2188             presaleWallets[whiteListedAddresses[i]] = true;
2189         }
2190     }
2191     function isAddressWhitelisted(address whitelist) public view returns(bool)
2192     {
2193         return presaleWallets[whitelist];
2194     }
2195        
2196     function withdrawContractEther(address payable recipient) external onlyOwner
2197     {
2198         recipient.transfer(getBalance());
2199     }
2200    
2201     function _baseURI() internal view virtual override returns (string memory) {
2202         return baseURI;
2203     }
2204    
2205     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2206         baseURI = _newBaseURI;
2207     }
2208    
2209     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2210     {
2211         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2212 
2213         string memory currentBaseURI = _baseURI();
2214         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2215     }
2216     function getBalance() public view returns(uint)
2217     {
2218         return address(this).balance;
2219     }
2220    
2221 
2222 }
2223 // File: serum.sol
2224 
2225 pragma solidity 0.8.7;
2226 
2227 
2228 contract SuperlativeMagicLaboratory is ERC1155Burnable, Ownable, ReentrancyGuard {
2229 
2230     using Strings for uint256;
2231     SUPERLATIVEAPES public slapeContract;
2232 
2233     string public baseURI;
2234     string public baseExtension = ".json";
2235 
2236 
2237     uint256 constant public MagicVialMaxReserve = 3333;
2238     uint256 constant public MagicHerbsMaxReserve = 1106;
2239     uint256 constant public MagicPotsMaxReserve = 5;
2240 
2241     uint256 public vialMinted;
2242     uint256 public herbsMinted;
2243     uint256 public potsMinted;
2244 
2245 
2246     bool public WhitelistOpen = false;
2247 
2248     mapping (address => uint256) public totalPresaleMinted;
2249 
2250     mapping (address => bool) public whitelistClaim;
2251 
2252     constructor(string memory _initBaseURI, address slapesAddress) ERC1155(_initBaseURI)
2253     {
2254         setBaseURI(_initBaseURI);
2255         slapeContract = SUPERLATIVEAPES(slapesAddress);
2256 
2257         vialMinted++;
2258         _mint(msg.sender, 1, 1, ""); 
2259     }
2260 
2261     function randomNum(uint256 _mod, uint256 _seed, uint256 _salt) internal view returns(uint256)
2262     {
2263         return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
2264     }
2265 
2266     modifier onlySender {
2267         require(msg.sender == tx.origin);
2268         _;
2269     }
2270 
2271     modifier isClaimOpen
2272     {
2273          require(WhitelistOpen == true);
2274          _;
2275     }
2276 
2277     function setClaimOpen() public onlyOwner
2278     {
2279         WhitelistOpen = !WhitelistOpen;
2280     }
2281 
2282     function Whitelist() public nonReentrant onlySender isClaimOpen
2283     {
2284         bool skipHerbs = false;
2285         bool skipPots = false;
2286 
2287         require(whitelistClaim[msg.sender] == false, "You have claimed already!");
2288         require(slapeContract.balanceOf(msg.sender) >= 1, "You dont have anything to claim");
2289         require((vialMinted < MagicVialMaxReserve || herbsMinted < MagicHerbsMaxReserve || potsMinted < MagicPotsMaxReserve) , "No serums left!");
2290 
2291         if(potsMinted >= MagicPotsMaxReserve)
2292         {
2293             skipPots = true;
2294         }
2295         else if(herbsMinted >= MagicHerbsMaxReserve)
2296         {
2297             skipHerbs = true;
2298         }
2299 
2300         for(uint256 i=0; i<slapeContract.balanceOf(msg.sender);i++)
2301         {      
2302             bool notMintedYet = false;
2303             while(!notMintedYet)
2304             {
2305                 uint256 selectedSerum = randomNum(12, (block.timestamp * randomNum(1000, block.timestamp, block.timestamp) * i), (block.timestamp * randomNum(1000, block.timestamp, block.timestamp) * i));
2306                 
2307                 if(selectedSerum == 0 && !skipPots)
2308                 {
2309                     notMintedYet = true;
2310                     potsMinted++;
2311                     _mint(msg.sender, 3, 1, "");                   
2312                 }
2313                 else if(selectedSerum >= 1 && selectedSerum <= 3 && !skipHerbs)
2314                 {
2315                     notMintedYet = true;
2316                     herbsMinted++;
2317                     _mint(msg.sender, 2, 1, "");                   
2318                 }
2319                 else
2320                 {
2321                     notMintedYet = true;
2322                     vialMinted++;
2323                     _mint(msg.sender, 1, 1, "");                  
2324                 }
2325             }
2326         }
2327 
2328         whitelistClaim[msg.sender] = true;
2329 
2330     }
2331 
2332     function _withdraw(address payable address_, uint256 amount_) internal {
2333         (bool success, ) = payable(address_).call{value: amount_}("");
2334         require(success, "Transfer failed");
2335     }
2336 
2337     function withdrawEther() external onlyOwner {
2338         _withdraw(payable(msg.sender), address(this).balance);
2339     }
2340 
2341     function withdrawEtherTo(address payable to_) external onlyOwner {
2342         _withdraw(to_, address(this).balance);
2343     }
2344 
2345     function _baseURI() internal view virtual returns (string memory) {
2346         return baseURI;
2347     }
2348    
2349     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2350         baseURI = _newBaseURI;
2351     }
2352    
2353     function uri(uint256 tokenId) public view override virtual returns (string memory)
2354     {
2355         string memory currentBaseURI = _baseURI();
2356         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2357     }
2358 }
2359 // File: mutant.sol
2360 
2361 pragma solidity ^0.8.0;
2362 
2363 
2364 
2365 
2366 
2367 
2368 
2369 
2370 /// SPDX-License-Identifier: UNLICENSED
2371 
2372 contract SUPERLATIVEMUTANTS is ERC721, Ownable, ReentrancyGuard {
2373 
2374     using Strings for uint256;
2375     using Counters for Counters.Counter;
2376 
2377     string public baseURI;
2378     string public baseExtension = ".json";
2379 
2380     Counters.Counter private _tokenIdTracker;
2381 
2382     SuperlativeMagicLaboratory public serumContract;
2383     SUPERLATIVEAPES public slapeContract;
2384 
2385     uint256 public preMaxTx = 5;
2386     uint256 public publicMaxTx = 10;
2387     uint256 public price = 0.15 ether;
2388 
2389     uint256 public maxPresaleSupply = 3000;
2390     uint256 public maxSupply = 4444;
2391     uint256 public potsUsed = 0;
2392 
2393     bytes32 public whitelistProof = '';
2394 
2395     mapping(address => uint256) totalMintedPre;
2396     mapping(address => uint256) totalMinted;
2397     mapping(uint256 => bool) public slapeMutated;
2398 
2399 
2400     bool public presaleOpen = false;
2401     bool public mainsaleOpen = false;
2402     bool public mutateOpen = false;
2403 
2404     constructor(string memory _initBaseURI, address serumAddress, address slapeAddress) ERC721("Superlative Mutated Apes", "SMAPE")
2405     {
2406         slapeContract = SUPERLATIVEAPES(slapeAddress);
2407         serumContract = SuperlativeMagicLaboratory(serumAddress);
2408         setBaseURI(_initBaseURI);
2409 
2410         for(uint256 i=0; i<50; i++)
2411         {
2412             _tokenIdTracker.increment();
2413             _safeMint(msg.sender, totalToken());
2414         }
2415     }
2416 
2417     modifier onlySender {
2418         require(msg.sender == tx.origin);
2419         _;
2420     }
2421 
2422     modifier isPresaleOpen
2423     {
2424          require(presaleOpen == true);
2425          _;
2426     }
2427 
2428     modifier isMainsaleOpen
2429     {
2430          require(mainsaleOpen == true);
2431          _;
2432     }
2433 
2434     modifier isMutateOpen
2435     {
2436          require(mutateOpen == true);
2437          _;
2438     }
2439 
2440     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner
2441     {
2442         whitelistProof = _merkleRoot;
2443     }
2444 
2445     function setPresaleOpen() public onlyOwner
2446     {
2447         presaleOpen = !presaleOpen;
2448     }
2449 
2450     function setMainsaleOpen() public onlyOwner
2451     {
2452         mainsaleOpen = !mainsaleOpen;
2453     }
2454 
2455     function setMutateOpen() public onlyOwner
2456     {
2457         mutateOpen = !mutateOpen;
2458     }
2459 
2460     function setPreMaxTx(uint256 _max) public onlyOwner
2461     {
2462         preMaxTx = _max;
2463     }
2464 
2465     function setMainMaxTx(uint256 _max) public onlyOwner
2466     {
2467         publicMaxTx = _max;
2468     }
2469 
2470     function presaleMutant(bytes32[] calldata _merkleProof, uint256 amountToMint) public payable nonReentrant onlySender isPresaleOpen
2471     {
2472         require(msg.value >= (price * amountToMint), "Minting a Superlative Mutant 0.15 Ether Each!");
2473         require(amountToMint <= preMaxTx, "Max mint is 5");
2474         require((totalMintedPre[msg.sender] + amountToMint) <= preMaxTx, "You already minted 5");
2475         require((totalToken() + amountToMint) < maxPresaleSupply, "Surpassing presale supply!");
2476 
2477         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2478         require(MerkleProof.verify(_merkleProof, whitelistProof, leaf), "Invalid proof.");
2479 
2480         for(uint256 i=0; i<amountToMint; i++)
2481         {
2482             totalMintedPre[msg.sender] += 1;
2483             _tokenIdTracker.increment();
2484             _safeMint(msg.sender, totalToken());
2485         }
2486     }
2487 
2488     function mainsaleMutant(uint256 amountToMint) public payable nonReentrant onlySender isMainsaleOpen
2489     {
2490         require(msg.value >= (price * amountToMint), "Minting a Superlative Mutant 0.15 Ether Each!");
2491         require(amountToMint <= publicMaxTx, "Max mint is 10");
2492         require((totalMinted[msg.sender] + amountToMint) <= publicMaxTx);
2493         require((totalToken() + amountToMint) < maxSupply, "Surpassing supply!");
2494 
2495         for(uint256 i=0; i<amountToMint; i++)
2496         {
2497             totalMinted[msg.sender] += 1;
2498             _tokenIdTracker.increment();
2499             _safeMint(msg.sender, totalToken());
2500         }
2501     }
2502 
2503     function mutateSlape(uint256 slapeID , uint256 serumID) public nonReentrant onlySender isMutateOpen
2504     {
2505         require(slapeContract.ownerOf(slapeID) == msg.sender, "You don't own this slape");
2506         require(serumContract.balanceOf(msg.sender, serumID) >= 1, "You don't own this serum");
2507         require(slapeMutated[slapeID] == false, "Slape already mutated");
2508 
2509 
2510         if(serumID == 1)
2511         {
2512             slapeMutated[slapeID] = true;
2513             serumContract.burn(msg.sender, 1, 1);
2514             _tokenIdTracker.increment();
2515             _safeMint(msg.sender, (4444 + slapeID));
2516         }
2517         else if(serumID == 2)
2518         {
2519             slapeMutated[slapeID] = true;
2520             serumContract.burn(msg.sender, 2, 1);
2521             _tokenIdTracker.increment();
2522             _safeMint(msg.sender, (8888 + slapeID));
2523         }
2524         else if(serumID == 3)
2525         {
2526             slapeMutated[slapeID] = true;
2527             serumContract.burn(msg.sender, 3, 1);
2528             _tokenIdTracker.increment();
2529             potsUsed += 1;
2530             _safeMint(msg.sender, (13332 + potsUsed));
2531         }
2532     }
2533 
2534     function devMint(uint256 amountToMint) public onlyOwner
2535     {
2536         for(uint256 i=0; i<amountToMint; i++)
2537         {
2538             _tokenIdTracker.increment();
2539             _safeMint(msg.sender, totalToken());
2540         }
2541     }
2542 
2543     function setPrice(uint256 newPrice) external onlyOwner  {
2544         price = newPrice;
2545     }
2546    
2547 
2548     function totalToken() public view returns (uint256) {
2549             return _tokenIdTracker.current();
2550     }
2551 
2552     function totalSupply() public view returns (uint256) {
2553             return _tokenIdTracker.current();
2554     }
2555 
2556     function _baseURI() internal view virtual override returns (string memory) {
2557         return baseURI;
2558     }
2559    
2560     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2561         baseURI = _newBaseURI;
2562     }
2563    
2564     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2565     {
2566         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2567 
2568         string memory currentBaseURI = _baseURI();
2569         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2570     }
2571 
2572     function _withdraw(address payable address_, uint256 amount_) internal {
2573         (bool success, ) = payable(address_).call{value: amount_}("");
2574         require(success, "Transfer failed");
2575     }
2576 
2577     function withdrawEther() external onlyOwner {
2578         _withdraw(payable(msg.sender), address(this).balance);
2579     }
2580 
2581     function withdrawEtherTo(address payable to_) external onlyOwner {
2582         _withdraw(to_, address(this).balance);
2583     }
2584 
2585     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
2586         uint256 _balance = balanceOf(address_);
2587         uint256[] memory _tokens = new uint256[] (_balance);
2588         uint256 _index;
2589         uint256 _loopThrough = totalSupply();
2590         for (uint256 i = 0; i < _loopThrough; i++) {
2591             bool _exists = _exists(i);
2592             if (_exists) {
2593                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
2594             }
2595             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
2596         }
2597         return _tokens;
2598     }   
2599 }