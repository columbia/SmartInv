1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 // CAUTION
72 // This version of SafeMath should only be used with Solidity 0.8 or later,
73 // because it relies on the compiler's built in overflow checks.
74 
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations.
77  *
78  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
79  * now has built in overflow checking.
80  */
81 library SafeMath {
82     /**
83      * @dev Returns the addition of two unsigned integers, with an overflow flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             uint256 c = a + b;
90             if (c < a) return (false, 0);
91             return (true, c);
92         }
93     }
94 
95     /**
96      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
97      *
98      * _Available since v3.4._
99      */
100     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
101         unchecked {
102             if (b > a) return (false, 0);
103             return (true, a - b);
104         }
105     }
106 
107     /**
108      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
109      *
110      * _Available since v3.4._
111      */
112     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
113         unchecked {
114             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115             // benefit is lost if 'b' is also tested.
116             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117             if (a == 0) return (true, 0);
118             uint256 c = a * b;
119             if (c / a != b) return (false, 0);
120             return (true, c);
121         }
122     }
123 
124     /**
125      * @dev Returns the division of two unsigned integers, with a division by zero flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         unchecked {
131             if (b == 0) return (false, 0);
132             return (true, a / b);
133         }
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
138      *
139      * _Available since v3.4._
140      */
141     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         unchecked {
143             if (b == 0) return (false, 0);
144             return (true, a % b);
145         }
146     }
147 
148     /**
149      * @dev Returns the addition of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `+` operator.
153      *
154      * Requirements:
155      *
156      * - Addition cannot overflow.
157      */
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a + b;
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         return a - b;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         return a * b;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers, reverting on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator.
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a / b;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return a % b;
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
222      * overflow (when the result is negative).
223      *
224      * CAUTION: This function is deprecated because it requires allocating memory for the error
225      * message unnecessarily. For custom revert reasons use {trySub}.
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      *
231      * - Subtraction cannot overflow.
232      */
233     function sub(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         unchecked {
239             require(b <= a, errorMessage);
240             return a - b;
241         }
242     }
243 
244     /**
245      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
246      * division by zero. The result is rounded towards zero.
247      *
248      * Counterpart to Solidity's `/` operator. Note: this function uses a
249      * `revert` opcode (which leaves remaining gas untouched) while Solidity
250      * uses an invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function div(
257         uint256 a,
258         uint256 b,
259         string memory errorMessage
260     ) internal pure returns (uint256) {
261         unchecked {
262             require(b > 0, errorMessage);
263             return a / b;
264         }
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * reverting with custom message when dividing by zero.
270      *
271      * CAUTION: This function is deprecated because it requires allocating memory for the error
272      * message unnecessarily. For custom revert reasons use {tryMod}.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function mod(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         unchecked {
288             require(b > 0, errorMessage);
289             return a % b;
290         }
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Strings.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev String operations.
303  */
304 library Strings {
305     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
306 
307     /**
308      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
309      */
310     function toString(uint256 value) internal pure returns (string memory) {
311         // Inspired by OraclizeAPI's implementation - MIT licence
312         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
313 
314         if (value == 0) {
315             return "0";
316         }
317         uint256 temp = value;
318         uint256 digits;
319         while (temp != 0) {
320             digits++;
321             temp /= 10;
322         }
323         bytes memory buffer = new bytes(digits);
324         while (value != 0) {
325             digits -= 1;
326             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
327             value /= 10;
328         }
329         return string(buffer);
330     }
331 
332     /**
333      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
334      */
335     function toHexString(uint256 value) internal pure returns (string memory) {
336         if (value == 0) {
337             return "0x00";
338         }
339         uint256 temp = value;
340         uint256 length = 0;
341         while (temp != 0) {
342             length++;
343             temp >>= 8;
344         }
345         return toHexString(value, length);
346     }
347 
348     /**
349      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
350      */
351     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
352         bytes memory buffer = new bytes(2 * length + 2);
353         buffer[0] = "0";
354         buffer[1] = "x";
355         for (uint256 i = 2 * length + 1; i > 1; --i) {
356             buffer[i] = _HEX_SYMBOLS[value & 0xf];
357             value >>= 4;
358         }
359         require(value == 0, "Strings: hex length insufficient");
360         return string(buffer);
361     }
362 }
363 
364 // File: @openzeppelin/contracts/utils/Context.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @dev Provides information about the current execution context, including the
373  * sender of the transaction and its data. While these are generally available
374  * via msg.sender and msg.data, they should not be accessed in such a direct
375  * manner, since when dealing with meta-transactions the account sending and
376  * paying for execution may not be the actual sender (as far as an application
377  * is concerned).
378  *
379  * This contract is only required for intermediate, library-like contracts.
380  */
381 abstract contract Context {
382     function _msgSender() internal view virtual returns (address) {
383         return msg.sender;
384     }
385 
386     function _msgData() internal view virtual returns (bytes calldata) {
387         return msg.data;
388     }
389 }
390 
391 // File: @openzeppelin/contracts/access/Ownable.sol
392 
393 
394 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 
399 /**
400  * @dev Contract module which provides a basic access control mechanism, where
401  * there is an account (an owner) that can be granted exclusive access to
402  * specific functions.
403  *
404  * By default, the owner account will be the one that deploys the contract. This
405  * can later be changed with {transferOwnership}.
406  *
407  * This module is used through inheritance. It will make available the modifier
408  * `onlyOwner`, which can be applied to your functions to restrict their use to
409  * the owner.
410  */
411 abstract contract Ownable is Context {
412     address private _owner;
413 
414     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415 
416     /**
417      * @dev Initializes the contract setting the deployer as the initial owner.
418      */
419     constructor() {
420         _transferOwnership(_msgSender());
421     }
422 
423     /**
424      * @dev Returns the address of the current owner.
425      */
426     function owner() public view virtual returns (address) {
427         return _owner;
428     }
429 
430     /**
431      * @dev Throws if called by any account other than the owner.
432      */
433     modifier onlyOwner() {
434         require(owner() == _msgSender(), "Ownable: caller is not the owner");
435         _;
436     }
437 
438     /**
439      * @dev Leaves the contract without owner. It will not be possible to call
440      * `onlyOwner` functions anymore. Can only be called by the current owner.
441      *
442      * NOTE: Renouncing ownership will leave the contract without an owner,
443      * thereby removing any functionality that is only available to the owner.
444      */
445     function renounceOwnership() public virtual onlyOwner {
446         _transferOwnership(address(0));
447     }
448 
449     /**
450      * @dev Transfers ownership of the contract to a new account (`newOwner`).
451      * Can only be called by the current owner.
452      */
453     function transferOwnership(address newOwner) public virtual onlyOwner {
454         require(newOwner != address(0), "Ownable: new owner is the zero address");
455         _transferOwnership(newOwner);
456     }
457 
458     /**
459      * @dev Transfers ownership of the contract to a new account (`newOwner`).
460      * Internal function without access restriction.
461      */
462     function _transferOwnership(address newOwner) internal virtual {
463         address oldOwner = _owner;
464         _owner = newOwner;
465         emit OwnershipTransferred(oldOwner, newOwner);
466     }
467 }
468 
469 // File: @openzeppelin/contracts/utils/Address.sol
470 
471 
472 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
473 
474 pragma solidity ^0.8.1;
475 
476 /**
477  * @dev Collection of functions related to the address type
478  */
479 library Address {
480     /**
481      * @dev Returns true if `account` is a contract.
482      *
483      * [IMPORTANT]
484      * ====
485      * It is unsafe to assume that an address for which this function returns
486      * false is an externally-owned account (EOA) and not a contract.
487      *
488      * Among others, `isContract` will return false for the following
489      * types of addresses:
490      *
491      *  - an externally-owned account
492      *  - a contract in construction
493      *  - an address where a contract will be created
494      *  - an address where a contract lived, but was destroyed
495      * ====
496      *
497      * [IMPORTANT]
498      * ====
499      * You shouldn't rely on `isContract` to protect against flash loan attacks!
500      *
501      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
502      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
503      * constructor.
504      * ====
505      */
506     function isContract(address account) internal view returns (bool) {
507         // This method relies on extcodesize/address.code.length, which returns 0
508         // for contracts in construction, since the code is only stored at the end
509         // of the constructor execution.
510 
511         return account.code.length > 0;
512     }
513 
514     /**
515      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
516      * `recipient`, forwarding all available gas and reverting on errors.
517      *
518      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
519      * of certain opcodes, possibly making contracts go over the 2300 gas limit
520      * imposed by `transfer`, making them unable to receive funds via
521      * `transfer`. {sendValue} removes this limitation.
522      *
523      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
524      *
525      * IMPORTANT: because control is transferred to `recipient`, care must be
526      * taken to not create reentrancy vulnerabilities. Consider using
527      * {ReentrancyGuard} or the
528      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
529      */
530     function sendValue(address payable recipient, uint256 amount) internal {
531         require(address(this).balance >= amount, "Address: insufficient balance");
532 
533         (bool success, ) = recipient.call{value: amount}("");
534         require(success, "Address: unable to send value, recipient may have reverted");
535     }
536 
537     /**
538      * @dev Performs a Solidity function call using a low level `call`. A
539      * plain `call` is an unsafe replacement for a function call: use this
540      * function instead.
541      *
542      * If `target` reverts with a revert reason, it is bubbled up by this
543      * function (like regular Solidity function calls).
544      *
545      * Returns the raw returned data. To convert to the expected return value,
546      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
547      *
548      * Requirements:
549      *
550      * - `target` must be a contract.
551      * - calling `target` with `data` must not revert.
552      *
553      * _Available since v3.1._
554      */
555     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
556         return functionCall(target, data, "Address: low-level call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
561      * `errorMessage` as a fallback revert reason when `target` reverts.
562      *
563      * _Available since v3.1._
564      */
565     function functionCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, 0, errorMessage);
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
575      * but also transferring `value` wei to `target`.
576      *
577      * Requirements:
578      *
579      * - the calling contract must have an ETH balance of at least `value`.
580      * - the called Solidity function must be `payable`.
581      *
582      * _Available since v3.1._
583      */
584     function functionCallWithValue(
585         address target,
586         bytes memory data,
587         uint256 value
588     ) internal returns (bytes memory) {
589         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
594      * with `errorMessage` as a fallback revert reason when `target` reverts.
595      *
596      * _Available since v3.1._
597      */
598     function functionCallWithValue(
599         address target,
600         bytes memory data,
601         uint256 value,
602         string memory errorMessage
603     ) internal returns (bytes memory) {
604         require(address(this).balance >= value, "Address: insufficient balance for call");
605         require(isContract(target), "Address: call to non-contract");
606 
607         (bool success, bytes memory returndata) = target.call{value: value}(data);
608         return verifyCallResult(success, returndata, errorMessage);
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
613      * but performing a static call.
614      *
615      * _Available since v3.3._
616      */
617     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
618         return functionStaticCall(target, data, "Address: low-level static call failed");
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(
628         address target,
629         bytes memory data,
630         string memory errorMessage
631     ) internal view returns (bytes memory) {
632         require(isContract(target), "Address: static call to non-contract");
633 
634         (bool success, bytes memory returndata) = target.staticcall(data);
635         return verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but performing a delegate call.
641      *
642      * _Available since v3.4._
643      */
644     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
645         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a delegate call.
651      *
652      * _Available since v3.4._
653      */
654     function functionDelegateCall(
655         address target,
656         bytes memory data,
657         string memory errorMessage
658     ) internal returns (bytes memory) {
659         require(isContract(target), "Address: delegate call to non-contract");
660 
661         (bool success, bytes memory returndata) = target.delegatecall(data);
662         return verifyCallResult(success, returndata, errorMessage);
663     }
664 
665     /**
666      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
667      * revert reason using the provided one.
668      *
669      * _Available since v4.3._
670      */
671     function verifyCallResult(
672         bool success,
673         bytes memory returndata,
674         string memory errorMessage
675     ) internal pure returns (bytes memory) {
676         if (success) {
677             return returndata;
678         } else {
679             // Look for revert reason and bubble it up if present
680             if (returndata.length > 0) {
681                 // The easiest way to bubble the revert reason is using memory via assembly
682 
683                 assembly {
684                     let returndata_size := mload(returndata)
685                     revert(add(32, returndata), returndata_size)
686                 }
687             } else {
688                 revert(errorMessage);
689             }
690         }
691     }
692 }
693 
694 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 /**
702  * @title ERC721 token receiver interface
703  * @dev Interface for any contract that wants to support safeTransfers
704  * from ERC721 asset contracts.
705  */
706 interface IERC721Receiver {
707     /**
708      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
709      * by `operator` from `from`, this function is called.
710      *
711      * It must return its Solidity selector to confirm the token transfer.
712      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
713      *
714      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
715      */
716     function onERC721Received(
717         address operator,
718         address from,
719         uint256 tokenId,
720         bytes calldata data
721     ) external returns (bytes4);
722 }
723 
724 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 /**
732  * @dev Interface of the ERC165 standard, as defined in the
733  * https://eips.ethereum.org/EIPS/eip-165[EIP].
734  *
735  * Implementers can declare support of contract interfaces, which can then be
736  * queried by others ({ERC165Checker}).
737  *
738  * For an implementation, see {ERC165}.
739  */
740 interface IERC165 {
741     /**
742      * @dev Returns true if this contract implements the interface defined by
743      * `interfaceId`. See the corresponding
744      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
745      * to learn more about how these ids are created.
746      *
747      * This function call must use less than 30 000 gas.
748      */
749     function supportsInterface(bytes4 interfaceId) external view returns (bool);
750 }
751 
752 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 
760 /**
761  * @dev Implementation of the {IERC165} interface.
762  *
763  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
764  * for the additional interface id that will be supported. For example:
765  *
766  * ```solidity
767  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
768  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
769  * }
770  * ```
771  *
772  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
773  */
774 abstract contract ERC165 is IERC165 {
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
779         return interfaceId == type(IERC165).interfaceId;
780     }
781 }
782 
783 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
784 
785 
786 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 
791 /**
792  * @dev Required interface of an ERC721 compliant contract.
793  */
794 interface IERC721 is IERC165 {
795     /**
796      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
797      */
798     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
799 
800     /**
801      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
802      */
803     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
804 
805     /**
806      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
807      */
808     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
809 
810     /**
811      * @dev Returns the number of tokens in ``owner``'s account.
812      */
813     function balanceOf(address owner) external view returns (uint256 balance);
814 
815     /**
816      * @dev Returns the owner of the `tokenId` token.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      */
822     function ownerOf(uint256 tokenId) external view returns (address owner);
823 
824     /**
825      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
826      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
827      *
828      * Requirements:
829      *
830      * - `from` cannot be the zero address.
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must exist and be owned by `from`.
833      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
834      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
835      *
836      * Emits a {Transfer} event.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) external;
843 
844     /**
845      * @dev Transfers `tokenId` token from `from` to `to`.
846      *
847      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
848      *
849      * Requirements:
850      *
851      * - `from` cannot be the zero address.
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must be owned by `from`.
854      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
855      *
856      * Emits a {Transfer} event.
857      */
858     function transferFrom(
859         address from,
860         address to,
861         uint256 tokenId
862     ) external;
863 
864     /**
865      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
866      * The approval is cleared when the token is transferred.
867      *
868      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
869      *
870      * Requirements:
871      *
872      * - The caller must own the token or be an approved operator.
873      * - `tokenId` must exist.
874      *
875      * Emits an {Approval} event.
876      */
877     function approve(address to, uint256 tokenId) external;
878 
879     /**
880      * @dev Returns the account approved for `tokenId` token.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      */
886     function getApproved(uint256 tokenId) external view returns (address operator);
887 
888     /**
889      * @dev Approve or remove `operator` as an operator for the caller.
890      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
891      *
892      * Requirements:
893      *
894      * - The `operator` cannot be the caller.
895      *
896      * Emits an {ApprovalForAll} event.
897      */
898     function setApprovalForAll(address operator, bool _approved) external;
899 
900     /**
901      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
902      *
903      * See {setApprovalForAll}
904      */
905     function isApprovedForAll(address owner, address operator) external view returns (bool);
906 
907     /**
908      * @dev Safely transfers `tokenId` token from `from` to `to`.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes calldata data
925     ) external;
926 }
927 
928 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
929 
930 
931 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
932 
933 pragma solidity ^0.8.0;
934 
935 
936 /**
937  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
938  * @dev See https://eips.ethereum.org/EIPS/eip-721
939  */
940 interface IERC721Enumerable is IERC721 {
941     /**
942      * @dev Returns the total amount of tokens stored by the contract.
943      */
944     function totalSupply() external view returns (uint256);
945 
946     /**
947      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
948      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
949      */
950     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
951 
952     /**
953      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
954      * Use along with {totalSupply} to enumerate all tokens.
955      */
956     function tokenByIndex(uint256 index) external view returns (uint256);
957 }
958 
959 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
960 
961 
962 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
963 
964 pragma solidity ^0.8.0;
965 
966 
967 /**
968  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
969  * @dev See https://eips.ethereum.org/EIPS/eip-721
970  */
971 interface IERC721Metadata is IERC721 {
972     /**
973      * @dev Returns the token collection name.
974      */
975     function name() external view returns (string memory);
976 
977     /**
978      * @dev Returns the token collection symbol.
979      */
980     function symbol() external view returns (string memory);
981 
982     /**
983      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
984      */
985     function tokenURI(uint256 tokenId) external view returns (string memory);
986 }
987 
988 // File: contracts/artifacts/ERC721A.sol
989 
990 
991 
992 pragma solidity ^0.8.10;
993 
994 
995 
996 
997 
998 
999 
1000 
1001 
1002 /**
1003  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1004  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1005  *
1006  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1007  *
1008  * Does not support burning tokens to address(0).
1009  */
1010 contract ERC721A is
1011   Context,
1012   ERC165,
1013   IERC721,
1014   IERC721Metadata,
1015   IERC721Enumerable
1016 {
1017   using Address for address;
1018   using Strings for uint256;
1019 
1020   struct TokenOwnership {
1021     address addr;
1022     uint64 startTimestamp;
1023   }
1024 
1025   struct AddressData {
1026     uint128 balance;
1027     uint128 numberMinted;
1028   }
1029 
1030   uint256 private currentIndex = 1;
1031 
1032   uint256 public immutable maxBatchSize;
1033 
1034   // Token name
1035   string private _name;
1036 
1037   // Token symbol
1038   string private _symbol;
1039 
1040   // Mapping from token ID to ownership details
1041   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1042   mapping(uint256 => TokenOwnership) private _ownerships;
1043 
1044   // Mapping owner address to address data
1045   mapping(address => AddressData) private _addressData;
1046 
1047   // Mapping from token ID to approved address
1048   mapping(uint256 => address) private _tokenApprovals;
1049 
1050   // Mapping from owner to operator approvals
1051   mapping(address => mapping(address => bool)) private _operatorApprovals;
1052 
1053   /**
1054    * @dev
1055    * `maxBatchSize` refers to how much a minter can mint at a time.
1056    */
1057   constructor(
1058     string memory name_,
1059     string memory symbol_,
1060     uint256 maxBatchSize_
1061   ) {
1062     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1063     _name = name_;
1064     _symbol = symbol_;
1065     maxBatchSize = maxBatchSize_;
1066   }
1067 
1068   /**
1069    * @dev See {IERC721Enumerable-totalSupply}.
1070    */
1071   function totalSupply() public view override returns (uint256) {
1072     return currentIndex - 1;
1073   }
1074 
1075   /**
1076    * @dev See {IERC721Enumerable-tokenByIndex}.
1077    */
1078   function tokenByIndex(uint256 index) public view override returns (uint256) {
1079     require(index < totalSupply(), "ERC721A: global index out of bounds");
1080     return index;
1081   }
1082 
1083   /**
1084    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1085    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1086    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1087    */
1088   function tokenOfOwnerByIndex(address owner, uint256 index)
1089     public
1090     view
1091     override
1092     returns (uint256)
1093   {
1094     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1095     uint256 numMintedSoFar = totalSupply();
1096     uint256 tokenIdsIdx = 0;
1097     address currOwnershipAddr = address(0);
1098     for (uint256 i = 0; i < numMintedSoFar; i++) {
1099       TokenOwnership memory ownership = _ownerships[i];
1100       if (ownership.addr != address(0)) {
1101         currOwnershipAddr = ownership.addr;
1102       }
1103       if (currOwnershipAddr == owner) {
1104         if (tokenIdsIdx == index) {
1105           return i;
1106         }
1107         tokenIdsIdx++;
1108       }
1109     }
1110     revert("ERC721A: unable to get token of owner by index");
1111   }
1112 
1113   /**
1114    * @dev See {IERC165-supportsInterface}.
1115    */
1116   function supportsInterface(bytes4 interfaceId)
1117     public
1118     view
1119     virtual
1120     override(ERC165, IERC165)
1121     returns (bool)
1122   {
1123     return
1124       interfaceId == type(IERC721).interfaceId ||
1125       interfaceId == type(IERC721Metadata).interfaceId ||
1126       interfaceId == type(IERC721Enumerable).interfaceId ||
1127       super.supportsInterface(interfaceId);
1128   }
1129 
1130   /**
1131    * @dev See {IERC721-balanceOf}.
1132    */
1133   function balanceOf(address owner) public view override returns (uint256) {
1134     require(owner != address(0), "ERC721A: balance query for the zero address");
1135     return uint256(_addressData[owner].balance);
1136   }
1137 
1138   function _numberMinted(address owner) internal view returns (uint256) {
1139     require(
1140       owner != address(0),
1141       "ERC721A: number minted query for the zero address"
1142     );
1143     return uint256(_addressData[owner].numberMinted);
1144   }
1145 
1146   function ownershipOf(uint256 tokenId)
1147     internal
1148     view
1149     returns (TokenOwnership memory)
1150   {
1151     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1152 
1153     uint256 lowestTokenToCheck;
1154     if (tokenId >= maxBatchSize) {
1155       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1156     }
1157 
1158     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1159       TokenOwnership memory ownership = _ownerships[curr];
1160       if (ownership.addr != address(0)) {
1161         return ownership;
1162       }
1163     }
1164 
1165     revert("ERC721A: unable to determine the owner of token");
1166   }
1167 
1168   /**
1169    * @dev See {IERC721-ownerOf}.
1170    */
1171   function ownerOf(uint256 tokenId) public view override returns (address) {
1172     return ownershipOf(tokenId).addr;
1173   }
1174 
1175   /**
1176    * @dev See {IERC721Metadata-name}.
1177    */
1178   function name() public view virtual override returns (string memory) {
1179     return _name;
1180   }
1181 
1182   /**
1183    * @dev See {IERC721Metadata-symbol}.
1184    */
1185   function symbol() public view virtual override returns (string memory) {
1186     return _symbol;
1187   }
1188 
1189   /**
1190    * @dev See {IERC721Metadata-tokenURI}.
1191    */
1192   function tokenURI(uint256 tokenId)
1193     public
1194     view
1195     virtual
1196     override
1197     returns (string memory)
1198   {
1199     require(
1200       _exists(tokenId),
1201       "ERC721Metadata: URI query for nonexistent token"
1202     );
1203 
1204     string memory baseURI = _baseURI();
1205     return
1206       bytes(baseURI).length > 0
1207         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1208         : "";
1209   }
1210 
1211   /**
1212    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1213    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1214    * by default, can be overriden in child contracts.
1215    */
1216   function _baseURI() internal view virtual returns (string memory) {
1217     return "";
1218   }
1219 
1220   /**
1221    * @dev See {IERC721-approve}.
1222    */
1223   function approve(address to, uint256 tokenId) public override {
1224     address owner = ERC721A.ownerOf(tokenId);
1225     require(to != owner, "ERC721A: approval to current owner");
1226 
1227     require(
1228       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1229       "ERC721A: approve caller is not owner nor approved for all"
1230     );
1231 
1232     _approve(to, tokenId, owner);
1233   }
1234 
1235   /**
1236    * @dev See {IERC721-getApproved}.
1237    */
1238   function getApproved(uint256 tokenId) public view override returns (address) {
1239     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1240 
1241     return _tokenApprovals[tokenId];
1242   }
1243 
1244   /**
1245    * @dev See {IERC721-setApprovalForAll}.
1246    */
1247   function setApprovalForAll(address operator, bool approved) public override {
1248     require(operator != _msgSender(), "ERC721A: approve to caller");
1249 
1250     _operatorApprovals[_msgSender()][operator] = approved;
1251     emit ApprovalForAll(_msgSender(), operator, approved);
1252   }
1253 
1254   /**
1255    * @dev See {IERC721-isApprovedForAll}.
1256    */
1257   function isApprovedForAll(address owner, address operator)
1258     public
1259     view
1260     virtual
1261     override
1262     returns (bool)
1263   {
1264     return _operatorApprovals[owner][operator];
1265   }
1266 
1267   /**
1268    * @dev See {IERC721-transferFrom}.
1269    */
1270   function transferFrom(
1271     address from,
1272     address to,
1273     uint256 tokenId
1274   ) public override {
1275     _transfer(from, to, tokenId);
1276   }
1277 
1278   /**
1279    * @dev See {IERC721-safeTransferFrom}.
1280    */
1281   function safeTransferFrom(
1282     address from,
1283     address to,
1284     uint256 tokenId
1285   ) public override {
1286     safeTransferFrom(from, to, tokenId, "");
1287   }
1288 
1289   /**
1290    * @dev See {IERC721-safeTransferFrom}.
1291    */
1292   function safeTransferFrom(
1293     address from,
1294     address to,
1295     uint256 tokenId,
1296     bytes memory _data
1297   ) public override {
1298     _transfer(from, to, tokenId);
1299     require(
1300       _checkOnERC721Received(from, to, tokenId, _data),
1301       "ERC721A: transfer to non ERC721Receiver implementer"
1302     );
1303   }
1304 
1305   /**
1306    * @dev Returns whether `tokenId` exists.
1307    *
1308    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1309    *
1310    * Tokens start existing when they are minted (`_mint`),
1311    */
1312   function _exists(uint256 tokenId) internal view returns (bool) {
1313     return tokenId < currentIndex;
1314   }
1315 
1316   function _safeMint(address to, uint256 quantity) internal {
1317     _safeMint(to, quantity, "");
1318   }
1319 
1320   /**
1321    * @dev Mints `quantity` tokens and transfers them to `to`.
1322    *
1323    * Requirements:
1324    *
1325    * - `to` cannot be the zero address.
1326    * - `quantity` cannot be larger than the max batch size.
1327    *
1328    * Emits a {Transfer} event.
1329    */
1330   function _safeMint(
1331     address to,
1332     uint256 quantity,
1333     bytes memory _data
1334   ) internal {
1335     uint256 startTokenId = currentIndex;
1336     require(to != address(0), "ERC721A: mint to the zero address");
1337     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1338     require(!_exists(startTokenId), "ERC721A: token already minted");
1339     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1340 
1341     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1342 
1343     AddressData memory addressData = _addressData[to];
1344     _addressData[to] = AddressData(
1345       addressData.balance + uint128(quantity),
1346       addressData.numberMinted + uint128(quantity)
1347     );
1348     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1349 
1350     uint256 updatedIndex = startTokenId;
1351 
1352     for (uint256 i = 0; i < quantity; i++) {
1353       emit Transfer(address(0), to, updatedIndex);
1354       require(
1355         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1356         "ERC721A: transfer to non ERC721Receiver implementer"
1357       );
1358       updatedIndex++;
1359     }
1360 
1361     currentIndex = updatedIndex;
1362     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1363   }
1364 
1365   /**
1366    * @dev Transfers `tokenId` from `from` to `to`.
1367    *
1368    * Requirements:
1369    *
1370    * - `to` cannot be the zero address.
1371    * - `tokenId` token must be owned by `from`.
1372    *
1373    * Emits a {Transfer} event.
1374    */
1375   function _transfer(
1376     address from,
1377     address to,
1378     uint256 tokenId
1379   ) private {
1380     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1381 
1382     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1383       getApproved(tokenId) == _msgSender() ||
1384       isApprovedForAll(prevOwnership.addr, _msgSender()));
1385 
1386     require(
1387       isApprovedOrOwner,
1388       "ERC721A: transfer caller is not owner nor approved"
1389     );
1390 
1391     require(
1392       prevOwnership.addr == from,
1393       "ERC721A: transfer from incorrect owner"
1394     );
1395     require(to != address(0), "ERC721A: transfer to the zero address");
1396 
1397     _beforeTokenTransfers(from, to, tokenId, 1);
1398 
1399     // Clear approvals from the previous owner
1400     _approve(address(0), tokenId, prevOwnership.addr);
1401 
1402     _addressData[from].balance -= 1;
1403     _addressData[to].balance += 1;
1404     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1405 
1406     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1407     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1408     uint256 nextTokenId = tokenId + 1;
1409     if (_ownerships[nextTokenId].addr == address(0)) {
1410       if (_exists(nextTokenId)) {
1411         _ownerships[nextTokenId] = TokenOwnership(
1412           prevOwnership.addr,
1413           prevOwnership.startTimestamp
1414         );
1415       }
1416     }
1417 
1418     emit Transfer(from, to, tokenId);
1419     _afterTokenTransfers(from, to, tokenId, 1);
1420   }
1421 
1422   /**
1423    * @dev Approve `to` to operate on `tokenId`
1424    *
1425    * Emits a {Approval} event.
1426    */
1427   function _approve(
1428     address to,
1429     uint256 tokenId,
1430     address owner
1431   ) private {
1432     _tokenApprovals[tokenId] = to;
1433     emit Approval(owner, to, tokenId);
1434   }
1435 
1436   uint256 public nextOwnerToExplicitlySet = 0;
1437 
1438   /**
1439    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1440    */
1441   function _setOwnersExplicit(uint256 quantity) internal {
1442     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1443     require(quantity > 0, "quantity must be nonzero");
1444     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1445     if (endIndex > currentIndex - 1) {
1446       endIndex = currentIndex - 1;
1447     }
1448     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1449     require(_exists(endIndex), "not enough minted yet for this cleanup");
1450     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1451       if (_ownerships[i].addr == address(0)) {
1452         TokenOwnership memory ownership = ownershipOf(i);
1453         _ownerships[i] = TokenOwnership(
1454           ownership.addr,
1455           ownership.startTimestamp
1456         );
1457       }
1458     }
1459     nextOwnerToExplicitlySet = endIndex + 1;
1460   }
1461 
1462   /**
1463    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1464    * The call is not executed if the target address is not a contract.
1465    *
1466    * @param from address representing the previous owner of the given token ID
1467    * @param to target address that will receive the tokens
1468    * @param tokenId uint256 ID of the token to be transferred
1469    * @param _data bytes optional data to send along with the call
1470    * @return bool whether the call correctly returned the expected magic value
1471    */
1472   function _checkOnERC721Received(
1473     address from,
1474     address to,
1475     uint256 tokenId,
1476     bytes memory _data
1477   ) private returns (bool) {
1478     if (to.isContract()) {
1479       try
1480         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1481       returns (bytes4 retval) {
1482         return retval == IERC721Receiver(to).onERC721Received.selector;
1483       } catch (bytes memory reason) {
1484         if (reason.length == 0) {
1485           revert("ERC721A: transfer to non ERC721Receiver implementer");
1486         } else {
1487           assembly {
1488             revert(add(32, reason), mload(reason))
1489           }
1490         }
1491       }
1492     } else {
1493       return true;
1494     }
1495   }
1496 
1497   /**
1498    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1499    *
1500    * startTokenId - the first token id to be transferred
1501    * quantity - the amount to be transferred
1502    *
1503    * Calling conditions:
1504    *
1505    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1506    * transferred to `to`.
1507    * - When `from` is zero, `tokenId` will be minted for `to`.
1508    */
1509   function _beforeTokenTransfers(
1510     address from,
1511     address to,
1512     uint256 startTokenId,
1513     uint256 quantity
1514   ) internal virtual {}
1515 
1516   /**
1517    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1518    * minting.
1519    *
1520    * startTokenId - the first token id to be transferred
1521    * quantity - the amount to be transferred
1522    *
1523    * Calling conditions:
1524    *
1525    * - when `from` and `to` are both non-zero.
1526    * - `from` and `to` are never both zero.
1527    */
1528   function _afterTokenTransfers(
1529     address from,
1530     address to,
1531     uint256 startTokenId,
1532     uint256 quantity
1533   ) internal virtual {}
1534 }
1535 // File: contracts/artifacts/Ck.sol
1536 
1537 
1538 
1539 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
1540 
1541 
1542 
1543 pragma solidity >=0.7.0 <0.9.0;
1544 
1545 
1546 
1547 
1548 
1549 
1550 contract CryptoKarls is ERC721A, Ownable {
1551   using Strings for uint256;
1552 
1553   string public baseURI;
1554   string public baseExtension = ".json";
1555   string public notRevealedUri;
1556   uint256 public cost = 0.05 ether;
1557   uint256 public wlcost = 0.03 ether;
1558   uint256 public maxSupply = 2500;
1559   uint256 public WlSupply = 2500;
1560   uint256 public MaxperWallet = 5;
1561   uint256 public MaxperWalletWl = 5;
1562   uint256 public MaxperTxWl = 5;
1563   uint256 public maxsize = 5 ; // max mint per tx
1564   bool public paused = false;
1565   bool public revealed = false;
1566   bool public preSale = true;
1567   bool public publicSale = false;
1568   bytes32 public merkleRoot = 0x663d931af97f42bad5073eb8d21cc4e0de7c377b9164403e603c03c822b4dc71;
1569   mapping(address => uint256) private _presaleMints;
1570 
1571   constructor(
1572     string memory _initBaseURI,
1573     string memory _initNotRevealedUri
1574   ) ERC721A("CryptoKarls", "CK", maxsize) {
1575     setBaseURI(_initBaseURI);
1576     setNotRevealedURI(_initNotRevealedUri);
1577   }
1578 
1579   // internal
1580   function _baseURI() internal view virtual override returns (string memory) {
1581     return baseURI;
1582   }
1583 
1584   // public
1585   function mint(uint256 tokens) public payable {
1586     require(!paused, "CK: oops contract is paused");
1587     require(publicSale, "CK: Sale Hasn't started yet");
1588     uint256 supply = totalSupply();
1589     uint256 ownerTokenCount = balanceOf(_msgSender());
1590     require(tokens > 0, "CK: need to mint at least 1 NFT");
1591     require(tokens <= maxsize, "CK: max mint amount per tx exceeded");
1592     require(supply + tokens <= maxSupply, "CK: We Soldout");
1593     require(ownerTokenCount + tokens <= MaxperWallet + _presaleMints[_msgSender()], "CK: Max NFT Per Wallet exceeded");
1594     require(msg.value >= cost * tokens, "CK: insufficient funds");
1595 
1596       _safeMint(_msgSender(), tokens);
1597     
1598   }
1599 /// @dev presale mint for whitelisted
1600     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable  {
1601     require(!paused, "CK: oops contract is paused");
1602     require(preSale, "CK: Presale Hasn't started yet");
1603     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "CK: You are not Whitelisted");
1604     uint256 supply = totalSupply();
1605     require(_presaleMints[_msgSender()] + tokens <= MaxperWalletWl, "CK: Max NFT Per Wallet For Whitelist exceeded");
1606     require(tokens > 0, "CK: need to mint at least 1 NFT");
1607     require(tokens <= MaxperTxWl, "CK: max mint per Tx exceeded");
1608     require(supply + tokens <= WlSupply, "CK: Whitelist MaxSupply exceeded");
1609     require(msg.value >= wlcost * tokens, "CK: insufficient funds");
1610 
1611       _safeMint(_msgSender(), tokens);
1612       _presaleMints[_msgSender()] += tokens;
1613     
1614   }
1615 
1616 
1617 
1618 
1619   /// @dev use it for giveaway and mint for yourself
1620      function gift(uint256 _mintAmount, address destination) public onlyOwner {
1621     require(_mintAmount > 0, "need to mint at least 1 NFT");
1622     uint256 supply = totalSupply();
1623     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1624 
1625       _safeMint(destination, _mintAmount);
1626     
1627   }
1628 
1629   
1630 
1631 
1632   function walletOfOwner(address _owner)
1633     public
1634     view
1635     returns (uint256[] memory)
1636   {
1637     uint256 ownerTokenCount = balanceOf(_owner);
1638     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1639     for (uint256 i; i < ownerTokenCount; i++) {
1640       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1641     }
1642     return tokenIds;
1643   }
1644 
1645   function tokenURI(uint256 tokenId)
1646     public
1647     view
1648     virtual
1649     override
1650     returns (string memory)
1651   {
1652     require(
1653       _exists(tokenId),
1654       "ERC721AMetadata: URI query for nonexistent token"
1655     );
1656     
1657     if(revealed == false) {
1658         return notRevealedUri;
1659     }
1660 
1661     string memory currentBaseURI = _baseURI();
1662     return bytes(currentBaseURI).length > 0
1663         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1664         : "";
1665   }
1666 
1667   //only owner
1668   function reveal(bool _state) public onlyOwner {
1669       revealed = _state;
1670   }
1671 
1672   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1673         merkleRoot = _merkleRoot;
1674     }
1675   
1676   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1677     MaxperWallet = _limit;
1678   }
1679 
1680     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
1681     MaxperWalletWl = _limit;
1682   }
1683 
1684   function setmaxsize(uint256 _maxsize) public onlyOwner {
1685     maxsize = _maxsize;
1686   }
1687 
1688     function setWLMaxpertx(uint256 _maxpertx) public onlyOwner {
1689     MaxperTxWl = _maxpertx;
1690   }
1691   
1692   function setCost(uint256 _newCost) public onlyOwner {
1693     cost = _newCost;
1694   }
1695 
1696     function setWlCost(uint256 _newWlCost) public onlyOwner {
1697     wlcost = _newWlCost;
1698   }
1699 
1700     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1701     maxSupply = _newsupply;
1702   }
1703 
1704     function setwlsupply(uint256 _newsupply) public onlyOwner {
1705     WlSupply = _newsupply;
1706   }
1707 
1708   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1709     baseURI = _newBaseURI;
1710   }
1711 
1712   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1713     baseExtension = _newBaseExtension;
1714   }
1715   
1716   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1717     notRevealedUri = _notRevealedURI;
1718   }
1719 
1720   function pause(bool _state) public onlyOwner {
1721     paused = _state;
1722   }
1723 
1724     function togglepreSale(bool _state) external onlyOwner {
1725         preSale = _state;
1726     }
1727 
1728     function togglepublicSale(bool _state) external onlyOwner {
1729         publicSale = _state;
1730     }
1731   
1732  
1733   function withdraw() public payable onlyOwner {
1734     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1735     require(success);
1736   }
1737 }