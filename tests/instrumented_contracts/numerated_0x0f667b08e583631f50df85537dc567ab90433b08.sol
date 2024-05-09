1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/utils/cryptography/MerkleProof.sol
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
56 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/utils/math/SafeMath.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 // CAUTION
64 // This version of SafeMath should only be used with Solidity 0.8 or later,
65 // because it relies on the compiler's built in overflow checks.
66 
67 /**
68  * @dev Wrappers over Solidity's arithmetic operations.
69  *
70  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
71  * now has built in overflow checking.
72  */
73 library SafeMath {
74     /**
75      * @dev Returns the addition of two unsigned integers, with an overflow flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             uint256 c = a + b;
82             if (c < a) return (false, 0);
83             return (true, c);
84         }
85     }
86 
87     /**
88      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
89      *
90      * _Available since v3.4._
91      */
92     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             if (b > a) return (false, 0);
95             return (true, a - b);
96         }
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
101      *
102      * _Available since v3.4._
103      */
104     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
107             // benefit is lost if 'b' is also tested.
108             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
109             if (a == 0) return (true, 0);
110             uint256 c = a * b;
111             if (c / a != b) return (false, 0);
112             return (true, c);
113         }
114     }
115 
116     /**
117      * @dev Returns the division of two unsigned integers, with a division by zero flag.
118      *
119      * _Available since v3.4._
120      */
121     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         unchecked {
123             if (b == 0) return (false, 0);
124             return (true, a / b);
125         }
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             if (b == 0) return (false, 0);
136             return (true, a % b);
137         }
138     }
139 
140     /**
141      * @dev Returns the addition of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `+` operator.
145      *
146      * Requirements:
147      *
148      * - Addition cannot overflow.
149      */
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a + b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return a - b;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a * b;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator.
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return a / b;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a % b;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
214      * overflow (when the result is negative).
215      *
216      * CAUTION: This function is deprecated because it requires allocating memory for the error
217      * message unnecessarily. For custom revert reasons use {trySub}.
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      *
223      * - Subtraction cannot overflow.
224      */
225     function sub(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b <= a, errorMessage);
232             return a - b;
233         }
234     }
235 
236     /**
237      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
238      * division by zero. The result is rounded towards zero.
239      *
240      * Counterpart to Solidity's `/` operator. Note: this function uses a
241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
242      * uses an invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function div(
249         uint256 a,
250         uint256 b,
251         string memory errorMessage
252     ) internal pure returns (uint256) {
253         unchecked {
254             require(b > 0, errorMessage);
255             return a / b;
256         }
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * reverting with custom message when dividing by zero.
262      *
263      * CAUTION: This function is deprecated because it requires allocating memory for the error
264      * message unnecessarily. For custom revert reasons use {tryMod}.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(
275         uint256 a,
276         uint256 b,
277         string memory errorMessage
278     ) internal pure returns (uint256) {
279         unchecked {
280             require(b > 0, errorMessage);
281             return a % b;
282         }
283     }
284 }
285 
286 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/utils/Context.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Provides information about the current execution context, including the
295  * sender of the transaction and its data. While these are generally available
296  * via msg.sender and msg.data, they should not be accessed in such a direct
297  * manner, since when dealing with meta-transactions the account sending and
298  * paying for execution may not be the actual sender (as far as an application
299  * is concerned).
300  *
301  * This contract is only required for intermediate, library-like contracts.
302  */
303 abstract contract Context {
304     function _msgSender() internal view virtual returns (address) {
305         return msg.sender;
306     }
307 
308     function _msgData() internal view virtual returns (bytes calldata) {
309         return msg.data;
310     }
311 }
312 
313 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/access/Ownable.sol
314 
315 
316 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 
321 /**
322  * @dev Contract module which provides a basic access control mechanism, where
323  * there is an account (an owner) that can be granted exclusive access to
324  * specific functions.
325  *
326  * By default, the owner account will be the one that deploys the contract. This
327  * can later be changed with {transferOwnership}.
328  *
329  * This module is used through inheritance. It will make available the modifier
330  * `onlyOwner`, which can be applied to your functions to restrict their use to
331  * the owner.
332  */
333 abstract contract Ownable is Context {
334     address private _owner;
335 
336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
337 
338     /**
339      * @dev Initializes the contract setting the deployer as the initial owner.
340      */
341     constructor() {
342         _transferOwnership(_msgSender());
343     }
344 
345     /**
346      * @dev Returns the address of the current owner.
347      */
348     function owner() public view virtual returns (address) {
349         return _owner;
350     }
351 
352     /**
353      * @dev Throws if called by any account other than the owner.
354      */
355     modifier onlyOwner() {
356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
357         _;
358     }
359 
360     /**
361      * @dev Leaves the contract without owner. It will not be possible to call
362      * `onlyOwner` functions anymore. Can only be called by the current owner.
363      *
364      * NOTE: Renouncing ownership will leave the contract without an owner,
365      * thereby removing any functionality that is only available to the owner.
366      */
367     function renounceOwnership() public virtual onlyOwner {
368         _transferOwnership(address(0));
369     }
370 
371     /**
372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
373      * Can only be called by the current owner.
374      */
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         _transferOwnership(newOwner);
378     }
379 
380     /**
381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
382      * Internal function without access restriction.
383      */
384     function _transferOwnership(address newOwner) internal virtual {
385         address oldOwner = _owner;
386         _owner = newOwner;
387         emit OwnershipTransferred(oldOwner, newOwner);
388     }
389 }
390 
391 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/utils/Address.sol
392 
393 
394 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 /**
399  * @dev Collection of functions related to the address type
400  */
401 library Address {
402     /**
403      * @dev Returns true if `account` is a contract.
404      *
405      * [IMPORTANT]
406      * ====
407      * It is unsafe to assume that an address for which this function returns
408      * false is an externally-owned account (EOA) and not a contract.
409      *
410      * Among others, `isContract` will return false for the following
411      * types of addresses:
412      *
413      *  - an externally-owned account
414      *  - a contract in construction
415      *  - an address where a contract will be created
416      *  - an address where a contract lived, but was destroyed
417      * ====
418      */
419     function isContract(address account) internal view returns (bool) {
420         // This method relies on extcodesize, which returns 0 for contracts in
421         // construction, since the code is only stored at the end of the
422         // constructor execution.
423 
424         uint256 size;
425         assembly {
426             size := extcodesize(account)
427         }
428         return size > 0;
429     }
430 
431     /**
432      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
433      * `recipient`, forwarding all available gas and reverting on errors.
434      *
435      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
436      * of certain opcodes, possibly making contracts go over the 2300 gas limit
437      * imposed by `transfer`, making them unable to receive funds via
438      * `transfer`. {sendValue} removes this limitation.
439      *
440      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
441      *
442      * IMPORTANT: because control is transferred to `recipient`, care must be
443      * taken to not create reentrancy vulnerabilities. Consider using
444      * {ReentrancyGuard} or the
445      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
446      */
447     function sendValue(address payable recipient, uint256 amount) internal {
448         require(address(this).balance >= amount, "Address: insufficient balance");
449 
450         (bool success, ) = recipient.call{value: amount}("");
451         require(success, "Address: unable to send value, recipient may have reverted");
452     }
453 
454     /**
455      * @dev Performs a Solidity function call using a low level `call`. A
456      * plain `call` is an unsafe replacement for a function call: use this
457      * function instead.
458      *
459      * If `target` reverts with a revert reason, it is bubbled up by this
460      * function (like regular Solidity function calls).
461      *
462      * Returns the raw returned data. To convert to the expected return value,
463      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
464      *
465      * Requirements:
466      *
467      * - `target` must be a contract.
468      * - calling `target` with `data` must not revert.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionCall(target, data, "Address: low-level call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
478      * `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, 0, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but also transferring `value` wei to `target`.
493      *
494      * Requirements:
495      *
496      * - the calling contract must have an ETH balance of at least `value`.
497      * - the called Solidity function must be `payable`.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value
505     ) internal returns (bytes memory) {
506         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
511      * with `errorMessage` as a fallback revert reason when `target` reverts.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(
516         address target,
517         bytes memory data,
518         uint256 value,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         require(address(this).balance >= value, "Address: insufficient balance for call");
522         require(isContract(target), "Address: call to non-contract");
523 
524         (bool success, bytes memory returndata) = target.call{value: value}(data);
525         return verifyCallResult(success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
535         return functionStaticCall(target, data, "Address: low-level static call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal view returns (bytes memory) {
549         require(isContract(target), "Address: static call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.staticcall(data);
552         return verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
562         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(isContract(target), "Address: delegate call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.delegatecall(data);
579         return verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
584      * revert reason using the provided one.
585      *
586      * _Available since v4.3._
587      */
588     function verifyCallResult(
589         bool success,
590         bytes memory returndata,
591         string memory errorMessage
592     ) internal pure returns (bytes memory) {
593         if (success) {
594             return returndata;
595         } else {
596             // Look for revert reason and bubble it up if present
597             if (returndata.length > 0) {
598                 // The easiest way to bubble the revert reason is using memory via assembly
599 
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 
611 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/utils/introspection/IERC165.sol
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
639 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/utils/introspection/ERC165.sol
640 
641 
642 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 
647 /**
648  * @dev Implementation of the {IERC165} interface.
649  *
650  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
651  * for the additional interface id that will be supported. For example:
652  *
653  * ```solidity
654  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
655  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
656  * }
657  * ```
658  *
659  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
660  */
661 abstract contract ERC165 is IERC165 {
662     /**
663      * @dev See {IERC165-supportsInterface}.
664      */
665     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
666         return interfaceId == type(IERC165).interfaceId;
667     }
668 }
669 
670 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/token/ERC1155/IERC1155Receiver.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 
678 /**
679  * @dev _Available since v3.1._
680  */
681 interface IERC1155Receiver is IERC165 {
682     /**
683         @dev Handles the receipt of a single ERC1155 token type. This function is
684         called at the end of a `safeTransferFrom` after the balance has been updated.
685         To accept the transfer, this must return
686         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
687         (i.e. 0xf23a6e61, or its own function selector).
688         @param operator The address which initiated the transfer (i.e. msg.sender)
689         @param from The address which previously owned the token
690         @param id The ID of the token being transferred
691         @param value The amount of tokens being transferred
692         @param data Additional data with no specified format
693         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
694     */
695     function onERC1155Received(
696         address operator,
697         address from,
698         uint256 id,
699         uint256 value,
700         bytes calldata data
701     ) external returns (bytes4);
702 
703     /**
704         @dev Handles the receipt of a multiple ERC1155 token types. This function
705         is called at the end of a `safeBatchTransferFrom` after the balances have
706         been updated. To accept the transfer(s), this must return
707         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
708         (i.e. 0xbc197c81, or its own function selector).
709         @param operator The address which initiated the batch transfer (i.e. msg.sender)
710         @param from The address which previously owned the token
711         @param ids An array containing ids of each token being transferred (order and length must match values array)
712         @param values An array containing amounts of each token being transferred (order and length must match ids array)
713         @param data Additional data with no specified format
714         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
715     */
716     function onERC1155BatchReceived(
717         address operator,
718         address from,
719         uint256[] calldata ids,
720         uint256[] calldata values,
721         bytes calldata data
722     ) external returns (bytes4);
723 }
724 
725 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/token/ERC1155/IERC1155.sol
726 
727 
728 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 
733 /**
734  * @dev Required interface of an ERC1155 compliant contract, as defined in the
735  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
736  *
737  * _Available since v3.1._
738  */
739 interface IERC1155 is IERC165 {
740     /**
741      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
742      */
743     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
744 
745     /**
746      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
747      * transfers.
748      */
749     event TransferBatch(
750         address indexed operator,
751         address indexed from,
752         address indexed to,
753         uint256[] ids,
754         uint256[] values
755     );
756 
757     /**
758      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
759      * `approved`.
760      */
761     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
762 
763     /**
764      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
765      *
766      * If an {URI} event was emitted for `id`, the standard
767      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
768      * returned by {IERC1155MetadataURI-uri}.
769      */
770     event URI(string value, uint256 indexed id);
771 
772     /**
773      * @dev Returns the amount of tokens of token type `id` owned by `account`.
774      *
775      * Requirements:
776      *
777      * - `account` cannot be the zero address.
778      */
779     function balanceOf(address account, uint256 id) external view returns (uint256);
780 
781     /**
782      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
783      *
784      * Requirements:
785      *
786      * - `accounts` and `ids` must have the same length.
787      */
788     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
789         external
790         view
791         returns (uint256[] memory);
792 
793     /**
794      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
795      *
796      * Emits an {ApprovalForAll} event.
797      *
798      * Requirements:
799      *
800      * - `operator` cannot be the caller.
801      */
802     function setApprovalForAll(address operator, bool approved) external;
803 
804     /**
805      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
806      *
807      * See {setApprovalForAll}.
808      */
809     function isApprovedForAll(address account, address operator) external view returns (bool);
810 
811     /**
812      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
813      *
814      * Emits a {TransferSingle} event.
815      *
816      * Requirements:
817      *
818      * - `to` cannot be the zero address.
819      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
820      * - `from` must have a balance of tokens of type `id` of at least `amount`.
821      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
822      * acceptance magic value.
823      */
824     function safeTransferFrom(
825         address from,
826         address to,
827         uint256 id,
828         uint256 amount,
829         bytes calldata data
830     ) external;
831 
832     /**
833      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
834      *
835      * Emits a {TransferBatch} event.
836      *
837      * Requirements:
838      *
839      * - `ids` and `amounts` must have the same length.
840      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
841      * acceptance magic value.
842      */
843     function safeBatchTransferFrom(
844         address from,
845         address to,
846         uint256[] calldata ids,
847         uint256[] calldata amounts,
848         bytes calldata data
849     ) external;
850 }
851 
852 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
853 
854 
855 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
856 
857 pragma solidity ^0.8.0;
858 
859 
860 /**
861  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
862  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
863  *
864  * _Available since v3.1._
865  */
866 interface IERC1155MetadataURI is IERC1155 {
867     /**
868      * @dev Returns the URI for token type `id`.
869      *
870      * If the `\{id\}` substring is present in the URI, it must be replaced by
871      * clients with the actual token type ID.
872      */
873     function uri(uint256 id) external view returns (string memory);
874 }
875 
876 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/token/ERC1155/ERC1155.sol
877 
878 
879 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 
884 
885 
886 
887 
888 
889 /**
890  * @dev Implementation of the basic standard multi-token.
891  * See https://eips.ethereum.org/EIPS/eip-1155
892  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
893  *
894  * _Available since v3.1._
895  */
896 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
897     using Address for address;
898 
899     // Mapping from token ID to account balances
900     mapping(uint256 => mapping(address => uint256)) private _balances;
901 
902     // Mapping from account to operator approvals
903     mapping(address => mapping(address => bool)) private _operatorApprovals;
904 
905     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
906     string private _uri;
907 
908     /**
909      * @dev See {_setURI}.
910      */
911     constructor(string memory uri_) {
912         _setURI(uri_);
913     }
914 
915     /**
916      * @dev See {IERC165-supportsInterface}.
917      */
918     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
919         return
920             interfaceId == type(IERC1155).interfaceId ||
921             interfaceId == type(IERC1155MetadataURI).interfaceId ||
922             super.supportsInterface(interfaceId);
923     }
924 
925     /**
926      * @dev See {IERC1155MetadataURI-uri}.
927      *
928      * This implementation returns the same URI for *all* token types. It relies
929      * on the token type ID substitution mechanism
930      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
931      *
932      * Clients calling this function must replace the `\{id\}` substring with the
933      * actual token type ID.
934      */
935     function uri(uint256) public view virtual override returns (string memory) {
936         return _uri;
937     }
938 
939     /**
940      * @dev See {IERC1155-balanceOf}.
941      *
942      * Requirements:
943      *
944      * - `account` cannot be the zero address.
945      */
946     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
947         require(account != address(0), "ERC1155: balance query for the zero address");
948         return _balances[id][account];
949     }
950 
951     /**
952      * @dev See {IERC1155-balanceOfBatch}.
953      *
954      * Requirements:
955      *
956      * - `accounts` and `ids` must have the same length.
957      */
958     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
959         public
960         view
961         virtual
962         override
963         returns (uint256[] memory)
964     {
965         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
966 
967         uint256[] memory batchBalances = new uint256[](accounts.length);
968 
969         for (uint256 i = 0; i < accounts.length; ++i) {
970             batchBalances[i] = balanceOf(accounts[i], ids[i]);
971         }
972 
973         return batchBalances;
974     }
975 
976     /**
977      * @dev See {IERC1155-setApprovalForAll}.
978      */
979     function setApprovalForAll(address operator, bool approved) public virtual override {
980         _setApprovalForAll(_msgSender(), operator, approved);
981     }
982 
983     /**
984      * @dev See {IERC1155-isApprovedForAll}.
985      */
986     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
987         return _operatorApprovals[account][operator];
988     }
989 
990     /**
991      * @dev See {IERC1155-safeTransferFrom}.
992      */
993     function safeTransferFrom(
994         address from,
995         address to,
996         uint256 id,
997         uint256 amount,
998         bytes memory data
999     ) public virtual override {
1000         require(
1001             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1002             "ERC1155: caller is not owner nor approved"
1003         );
1004         _safeTransferFrom(from, to, id, amount, data);
1005     }
1006 
1007     /**
1008      * @dev See {IERC1155-safeBatchTransferFrom}.
1009      */
1010     function safeBatchTransferFrom(
1011         address from,
1012         address to,
1013         uint256[] memory ids,
1014         uint256[] memory amounts,
1015         bytes memory data
1016     ) public virtual override {
1017         require(
1018             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1019             "ERC1155: transfer caller is not owner nor approved"
1020         );
1021         _safeBatchTransferFrom(from, to, ids, amounts, data);
1022     }
1023 
1024     /**
1025      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1026      *
1027      * Emits a {TransferSingle} event.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1033      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1034      * acceptance magic value.
1035      */
1036     function _safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 id,
1040         uint256 amount,
1041         bytes memory data
1042     ) internal virtual {
1043         require(to != address(0), "ERC1155: transfer to the zero address");
1044 
1045         address operator = _msgSender();
1046 
1047         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1048 
1049         uint256 fromBalance = _balances[id][from];
1050         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1051         unchecked {
1052             _balances[id][from] = fromBalance - amount;
1053         }
1054         _balances[id][to] += amount;
1055 
1056         emit TransferSingle(operator, from, to, id, amount);
1057 
1058         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1059     }
1060 
1061     /**
1062      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1063      *
1064      * Emits a {TransferBatch} event.
1065      *
1066      * Requirements:
1067      *
1068      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1069      * acceptance magic value.
1070      */
1071     function _safeBatchTransferFrom(
1072         address from,
1073         address to,
1074         uint256[] memory ids,
1075         uint256[] memory amounts,
1076         bytes memory data
1077     ) internal virtual {
1078         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1079         require(to != address(0), "ERC1155: transfer to the zero address");
1080 
1081         address operator = _msgSender();
1082 
1083         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1084 
1085         for (uint256 i = 0; i < ids.length; ++i) {
1086             uint256 id = ids[i];
1087             uint256 amount = amounts[i];
1088 
1089             uint256 fromBalance = _balances[id][from];
1090             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1091             unchecked {
1092                 _balances[id][from] = fromBalance - amount;
1093             }
1094             _balances[id][to] += amount;
1095         }
1096 
1097         emit TransferBatch(operator, from, to, ids, amounts);
1098 
1099         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1100     }
1101 
1102     /**
1103      * @dev Sets a new URI for all token types, by relying on the token type ID
1104      * substitution mechanism
1105      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1106      *
1107      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1108      * URI or any of the amounts in the JSON file at said URI will be replaced by
1109      * clients with the token type ID.
1110      *
1111      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1112      * interpreted by clients as
1113      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1114      * for token type ID 0x4cce0.
1115      *
1116      * See {uri}.
1117      *
1118      * Because these URIs cannot be meaningfully represented by the {URI} event,
1119      * this function emits no events.
1120      */
1121     function _setURI(string memory newuri) internal virtual {
1122         _uri = newuri;
1123     }
1124 
1125     /**
1126      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1127      *
1128      * Emits a {TransferSingle} event.
1129      *
1130      * Requirements:
1131      *
1132      * - `to` cannot be the zero address.
1133      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1134      * acceptance magic value.
1135      */
1136     function _mint(
1137         address to,
1138         uint256 id,
1139         uint256 amount,
1140         bytes memory data
1141     ) internal virtual {
1142         require(to != address(0), "ERC1155: mint to the zero address");
1143 
1144         address operator = _msgSender();
1145 
1146         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1147 
1148         _balances[id][to] += amount;
1149         emit TransferSingle(operator, address(0), to, id, amount);
1150 
1151         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1152     }
1153 
1154     /**
1155      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1156      *
1157      * Requirements:
1158      *
1159      * - `ids` and `amounts` must have the same length.
1160      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1161      * acceptance magic value.
1162      */
1163     function _mintBatch(
1164         address to,
1165         uint256[] memory ids,
1166         uint256[] memory amounts,
1167         bytes memory data
1168     ) internal virtual {
1169         require(to != address(0), "ERC1155: mint to the zero address");
1170         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1171 
1172         address operator = _msgSender();
1173 
1174         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1175 
1176         for (uint256 i = 0; i < ids.length; i++) {
1177             _balances[ids[i]][to] += amounts[i];
1178         }
1179 
1180         emit TransferBatch(operator, address(0), to, ids, amounts);
1181 
1182         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1183     }
1184 
1185     /**
1186      * @dev Destroys `amount` tokens of token type `id` from `from`
1187      *
1188      * Requirements:
1189      *
1190      * - `from` cannot be the zero address.
1191      * - `from` must have at least `amount` tokens of token type `id`.
1192      */
1193     function _burn(
1194         address from,
1195         uint256 id,
1196         uint256 amount
1197     ) internal virtual {
1198         require(from != address(0), "ERC1155: burn from the zero address");
1199 
1200         address operator = _msgSender();
1201 
1202         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1203 
1204         uint256 fromBalance = _balances[id][from];
1205         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1206         unchecked {
1207             _balances[id][from] = fromBalance - amount;
1208         }
1209 
1210         emit TransferSingle(operator, from, address(0), id, amount);
1211     }
1212 
1213     /**
1214      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1215      *
1216      * Requirements:
1217      *
1218      * - `ids` and `amounts` must have the same length.
1219      */
1220     function _burnBatch(
1221         address from,
1222         uint256[] memory ids,
1223         uint256[] memory amounts
1224     ) internal virtual {
1225         require(from != address(0), "ERC1155: burn from the zero address");
1226         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1227 
1228         address operator = _msgSender();
1229 
1230         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1231 
1232         for (uint256 i = 0; i < ids.length; i++) {
1233             uint256 id = ids[i];
1234             uint256 amount = amounts[i];
1235 
1236             uint256 fromBalance = _balances[id][from];
1237             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1238             unchecked {
1239                 _balances[id][from] = fromBalance - amount;
1240             }
1241         }
1242 
1243         emit TransferBatch(operator, from, address(0), ids, amounts);
1244     }
1245 
1246     /**
1247      * @dev Approve `operator` to operate on all of `owner` tokens
1248      *
1249      * Emits a {ApprovalForAll} event.
1250      */
1251     function _setApprovalForAll(
1252         address owner,
1253         address operator,
1254         bool approved
1255     ) internal virtual {
1256         require(owner != operator, "ERC1155: setting approval status for self");
1257         _operatorApprovals[owner][operator] = approved;
1258         emit ApprovalForAll(owner, operator, approved);
1259     }
1260 
1261     /**
1262      * @dev Hook that is called before any token transfer. This includes minting
1263      * and burning, as well as batched variants.
1264      *
1265      * The same hook is called on both single and batched variants. For single
1266      * transfers, the length of the `id` and `amount` arrays will be 1.
1267      *
1268      * Calling conditions (for each `id` and `amount` pair):
1269      *
1270      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1271      * of token type `id` will be  transferred to `to`.
1272      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1273      * for `to`.
1274      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1275      * will be burned.
1276      * - `from` and `to` are never both zero.
1277      * - `ids` and `amounts` have the same, non-zero length.
1278      *
1279      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1280      */
1281     function _beforeTokenTransfer(
1282         address operator,
1283         address from,
1284         address to,
1285         uint256[] memory ids,
1286         uint256[] memory amounts,
1287         bytes memory data
1288     ) internal virtual {}
1289 
1290     function _doSafeTransferAcceptanceCheck(
1291         address operator,
1292         address from,
1293         address to,
1294         uint256 id,
1295         uint256 amount,
1296         bytes memory data
1297     ) private {
1298         if (to.isContract()) {
1299             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1300                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1301                     revert("ERC1155: ERC1155Receiver rejected tokens");
1302                 }
1303             } catch Error(string memory reason) {
1304                 revert(reason);
1305             } catch {
1306                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1307             }
1308         }
1309     }
1310 
1311     function _doSafeBatchTransferAcceptanceCheck(
1312         address operator,
1313         address from,
1314         address to,
1315         uint256[] memory ids,
1316         uint256[] memory amounts,
1317         bytes memory data
1318     ) private {
1319         if (to.isContract()) {
1320             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1321                 bytes4 response
1322             ) {
1323                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1324                     revert("ERC1155: ERC1155Receiver rejected tokens");
1325                 }
1326             } catch Error(string memory reason) {
1327                 revert(reason);
1328             } catch {
1329                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1330             }
1331         }
1332     }
1333 
1334     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1335         uint256[] memory array = new uint256[](1);
1336         array[0] = element;
1337 
1338         return array;
1339     }
1340 }
1341 
1342 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.2/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1343 
1344 
1345 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
1346 
1347 pragma solidity ^0.8.0;
1348 
1349 
1350 /**
1351  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1352  * own tokens and those that they have been approved to use.
1353  *
1354  * _Available since v3.1._
1355  */
1356 abstract contract ERC1155Burnable is ERC1155 {
1357     function burn(
1358         address account,
1359         uint256 id,
1360         uint256 value
1361     ) public virtual {
1362         require(
1363             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1364             "ERC1155: caller is not owner nor approved"
1365         );
1366 
1367         _burn(account, id, value);
1368     }
1369 
1370     function burnBatch(
1371         address account,
1372         uint256[] memory ids,
1373         uint256[] memory values
1374     ) public virtual {
1375         require(
1376             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1377             "ERC1155: caller is not owner nor approved"
1378         );
1379 
1380         _burnBatch(account, ids, values);
1381     }
1382 }
1383 
1384 // File: contracts/erc1155.sol
1385 
1386 
1387 /* 
1388 8888888b.          888               888               d8b               8888888b.  d8b                            d8b                   
1389 888   Y88b         888               888               Y8P               888  "Y88b Y8P                            Y8P                   
1390 888    888         888               888                                 888    888                                                      
1391 888   d88P .d88b.  88888b.   .d88b.  888 .d8888b       888 88888b.       888    888 888 .d8888b   .d88b.  888  888 888 .d8888b   .d88b.  
1392 8888888P" d8P  Y8b 888 "88b d8P  Y8b 888 88K           888 888 "88b      888    888 888 88K      d88P"88b 888  888 888 88K      d8P  Y8b 
1393 888 T88b  88888888 888  888 88888888 888 "Y8888b.      888 888  888      888    888 888 "Y8888b. 888  888 888  888 888 "Y8888b. 88888888 
1394 888  T88b Y8b.     888 d88P Y8b.     888      X88      888 888  888      888  .d88P 888      X88 Y88b 888 Y88b 888 888      X88 Y8b.     
1395 888   T88b "Y8888  88888P"   "Y8888  888  88888P'      888 888  888      8888888P"  888  88888P'  "Y88888  "Y88888 888  88888P'  "Y8888  
1396                                                                                                       888                                
1397                                                                                                  Y8b d88P                                
1398                                                                                                   "Y88P"                                 
1399 */
1400 pragma solidity ^0.8.2;
1401 
1402 
1403 
1404 
1405 
1406 
1407 contract RebelsCoin is ERC1155, Ownable, ERC1155Burnable {
1408     using SafeMath for uint256;
1409     using MerkleProof for bytes32[];
1410 
1411     uint256 amountMinted = 0;
1412     uint256 perTransaction = 5;
1413     uint256 perTransactionForWhitelist = 2;
1414     uint256 maxrebels = 5555;
1415 
1416     uint256 private tokenPrice = 55000000000000000;
1417     bytes32 public merkleRoot;
1418     string name_;
1419     string symbol_;
1420 
1421     mapping(address => bool) public whitelistClaimed;
1422 
1423     bool whitelistSale = true;
1424     bool publicSale = false;
1425     bool salesStarted = false;
1426     bool migrationStarted = false;
1427 
1428     Rebels721Contract public rebels721Contract;
1429 
1430     // Payout addresses
1431     address team1 = 0xd228c59148a3428B845b572d88E7ec77839cf474;
1432     address team2 = 0xdBdFdB5a3c50BE2481cC021828b6815B46d2f2f8;
1433     address team3 = 0x13205830f2bf6f1197D057f145454CE99A955A6d;
1434     address team4 = 0xE2BFf72848B50e2385E63c23681695e990eC42cb;
1435     address team5 = 0x3F838Fb407b750655632088bDf1D0430F53AC8F3;
1436     address team6 = 0xCdC82eE2cbC9168e7DA4CD3EeF49705C5610839b;
1437     address team7 = 0x35364A2B2c2DC73bEdF16e7fBCd29D2dA27E04D4;
1438     address team8 = 0xDf82600D2fA71B2Cb9406EEF582114b395729d23;
1439     address team9 = 0x9D35BaDbC2300003B5CF077262e7Ef389a89e981;
1440 
1441     constructor(address _rebels721Contract, string memory _name, string memory _symbol)
1442         ERC1155("https://gateway.pinata.cloud/ipfs/QmRKarHppL2BCj6Vvm6HKaaR5vHF63mvn9aRHj8fKGgocb/0")
1443     {
1444         name_ = _name;
1445         symbol_ = _symbol;
1446         rebels721Contract = Rebels721Contract(_rebels721Contract);
1447     }
1448 
1449     modifier callerIsUser() {
1450         require(tx.origin == msg.sender, "The caller is another contract");
1451         _;
1452     }
1453 
1454     // set Rebels ERC721 contract
1455     function setRebelsERC721Contract(address _contract) public onlyOwner {
1456         rebels721Contract = Rebels721Contract(_contract);
1457     }
1458 
1459     // Toggle all sales
1460     function toggleSales() public onlyOwner {
1461         salesStarted = !salesStarted;
1462     }
1463 
1464     // Toggle the private sales system
1465     function toggleWhitelistSales() public onlyOwner {
1466         whitelistSale = !whitelistSale;
1467     }
1468 
1469     // Toggle public sale
1470     function togglePublicSales() public onlyOwner {
1471         publicSale = !publicSale;
1472     }
1473 
1474     // Toggle migrations
1475     function toggleMigration() public onlyOwner {
1476         migrationStarted = !migrationStarted;
1477     }
1478 
1479     //Set merkle root hash
1480     function setMerkleRoot(bytes32 root) public onlyOwner {
1481         merkleRoot = root;
1482     }
1483 
1484     // Mint function
1485     function mint(uint256 _count) public payable callerIsUser {
1486         require(salesStarted == true, "Sales have not started");
1487         require(publicSale == true, "Public sale have not yet started");
1488         require(msg.value >= tokenPrice.mul(_count), "Not enough money");
1489         require(_count <= perTransaction, "Only 5 for public per transaction");
1490         require(_count + amountMinted <= maxrebels, "Limit reached");
1491 
1492         _mint(msg.sender, 0, _count, "");
1493         amountMinted += _count;
1494     }
1495 
1496     // Mint function for whitelist
1497     function whitelistMint(uint256 _count, bytes32[] calldata merkleProof) public payable {
1498         require(salesStarted == true, "Sales have not started");
1499         require(whitelistSale == true, "Whitelist sale have not yet started");
1500         require(msg.value >= tokenPrice.mul(_count), "Not enough money");
1501         require(_count + amountMinted <= maxrebels, "Limit reached");
1502         require(_count <= perTransactionForWhitelist, "Only 2 for whitelisted users");
1503         require(!whitelistClaimed[msg.sender], "Whitelist already claimed");
1504         require(merkleProof.verify(merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not whitelisted");
1505 
1506         _mint(msg.sender, 0, _count, "");
1507         whitelistClaimed[msg.sender] = true;
1508         amountMinted += _count;
1509     }
1510 
1511     // Mint function for only owner
1512     function mintForOwner(uint256 _count) public onlyOwner {
1513         require(_count + amountMinted <= maxrebels, "Limit reached");
1514 
1515         _mint(msg.sender, 0, _count, "");
1516         amountMinted += _count;
1517     }
1518 
1519     // Migrate ERC1155 to ERC721
1520     function migrateBatch(uint256 _count) public {
1521         require(migrationStarted == true, "Migration has not started");
1522         require(balanceOf(msg.sender, 0) >= _count, "Doesn't own the token");
1523 
1524         rebels721Contract.mintTransfer(msg.sender, _count);
1525         burn(msg.sender, 0, _count);
1526     }
1527 
1528     // Get amount of 1155 minted
1529     function totalSupply() public view returns (uint256) {
1530         return amountMinted;
1531     }
1532 
1533     // Change price
1534     function setPrice(uint256 _newPrice) public onlyOwner {
1535         tokenPrice = _newPrice;
1536     }
1537 
1538     // Change supply
1539     function setSupply(uint256 _newSupply) public onlyOwner {
1540         maxrebels = _newSupply;
1541     }
1542 
1543     // Basic withdrawal of funds function in order to transfert ETH out of the smart contract
1544     function withdraw() public onlyOwner {
1545         uint256 amountToTeam1 = (address(this).balance * 150) / 1000; // 15%
1546         uint256 amountToTeam2 = (address(this).balance * 125) / 1000; // 12.5%
1547         uint256 amountToTeam4 = (address(this).balance * 50) / 1000; // 5%
1548         uint256 amountToTeam5 = (address(this).balance * 125) / 1000; // 12.5%
1549         uint256 amountToTeam6 = (address(this).balance * 125) / 1000; // 12.5%
1550         uint256 amountToTeam7 = (address(this).balance * 125) / 1000; // 12.5%
1551         uint256 amountToTeam8 = (address(this).balance * 125) / 1000; // 12.5%
1552         uint256 amountToTeam9 = (address(this).balance * 125) / 1000; // 12.5%
1553 
1554         sendEth(team1, amountToTeam1);
1555         sendEth(team2, amountToTeam2);
1556         sendEth(team4, amountToTeam4);
1557         sendEth(team5, amountToTeam5);
1558         sendEth(team6, amountToTeam6);
1559         sendEth(team7, amountToTeam7);
1560         sendEth(team8, amountToTeam8);
1561         sendEth(team9, amountToTeam9);
1562 
1563         // send the rest to team 3
1564         uint256 amountToTeam3 = address(this).balance; // ~10%
1565         sendEth(team3, amountToTeam3);
1566     }
1567 
1568     function sendEth(address to, uint256 amount) internal {
1569         (bool success, ) = to.call{value: amount}("");
1570         require(success, "Failed to send ether");
1571     }
1572 
1573     function name() public view returns (string memory) {
1574         return name_;
1575     }
1576 
1577     function symbol() public view returns (string memory) {
1578         return symbol_;
1579     }   
1580 }
1581 
1582 interface Rebels721Contract {
1583     function mintTransfer(address to, uint256 _count) external;
1584  }