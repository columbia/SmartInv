1 // File: PPTC_flat.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev These functions deal with verification of Merkle Trees proofs.
13  *
14  * The proofs can be generated using the JavaScript library
15  * https://github.com/miguelmota/merkletreejs[merkletreejs].
16  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
17  *
18  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
19  */
20 library MerkleProof {
21     /**
22      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
23      * defined by `root`. For this, a `proof` must be provided, containing
24      * sibling hashes on the branch from the leaf to the root of the tree. Each
25      * pair of leaves and each pair of pre-images are assumed to be sorted.
26      */
27     function verify(
28         bytes32[] memory proof,
29         bytes32 root,
30         bytes32 leaf
31     ) internal pure returns (bool) {
32         return processProof(proof, leaf) == root;
33     }
34 
35     /**
36      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
37      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
38      * hash matches the root of the tree. When processing the proof, the pairs
39      * of leafs & pre-images are assumed to be sorted.
40      *
41      * _Available since v4.4._
42      */
43     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
44         bytes32 computedHash = leaf;
45         for (uint256 i = 0; i < proof.length; i++) {
46             bytes32 proofElement = proof[i];
47             if (computedHash <= proofElement) {
48                 // Hash(current computed hash + current element of the proof)
49                 computedHash = _efficientHash(computedHash, proofElement);
50             } else {
51                 // Hash(current element of the proof + current computed hash)
52                 computedHash = _efficientHash(proofElement, computedHash);
53             }
54         }
55         return computedHash;
56     }
57 
58     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
59         assembly {
60             mstore(0x00, a)
61             mstore(0x20, b)
62             value := keccak256(0x00, 0x40)
63         }
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 // CAUTION
75 // This version of SafeMath should only be used with Solidity 0.8 or later,
76 // because it relies on the compiler's built in overflow checks.
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations.
80  *
81  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
82  * now has built in overflow checking.
83  */
84 library SafeMath {
85     /**
86      * @dev Returns the addition of two unsigned integers, with an overflow flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             uint256 c = a + b;
93             if (c < a) return (false, 0);
94             return (true, c);
95         }
96     }
97 
98     /**
99      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
100      *
101      * _Available since v3.4._
102      */
103     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         unchecked {
105             if (b > a) return (false, 0);
106             return (true, a - b);
107         }
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
112      *
113      * _Available since v3.4._
114      */
115     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         unchecked {
117             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118             // benefit is lost if 'b' is also tested.
119             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
120             if (a == 0) return (true, 0);
121             uint256 c = a * b;
122             if (c / a != b) return (false, 0);
123             return (true, c);
124         }
125     }
126 
127     /**
128      * @dev Returns the division of two unsigned integers, with a division by zero flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         unchecked {
134             if (b == 0) return (false, 0);
135             return (true, a / b);
136         }
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         unchecked {
146             if (b == 0) return (false, 0);
147             return (true, a % b);
148         }
149     }
150 
151     /**
152      * @dev Returns the addition of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `+` operator.
156      *
157      * Requirements:
158      *
159      * - Addition cannot overflow.
160      */
161     function add(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a + b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      *
173      * - Subtraction cannot overflow.
174      */
175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a * b;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers, reverting on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator.
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a / b;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a % b;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
225      * overflow (when the result is negative).
226      *
227      * CAUTION: This function is deprecated because it requires allocating memory for the error
228      * message unnecessarily. For custom revert reasons use {trySub}.
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      *
234      * - Subtraction cannot overflow.
235      */
236     function sub(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         unchecked {
242             require(b <= a, errorMessage);
243             return a - b;
244         }
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function div(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         unchecked {
265             require(b > 0, errorMessage);
266             return a / b;
267         }
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * reverting with custom message when dividing by zero.
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {tryMod}.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(
286         uint256 a,
287         uint256 b,
288         string memory errorMessage
289     ) internal pure returns (uint256) {
290         unchecked {
291             require(b > 0, errorMessage);
292             return a % b;
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Strings.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev String operations.
306  */
307 library Strings {
308     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
309 
310     /**
311      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
312      */
313     function toString(uint256 value) internal pure returns (string memory) {
314         // Inspired by OraclizeAPI's implementation - MIT licence
315         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
316 
317         if (value == 0) {
318             return "0";
319         }
320         uint256 temp = value;
321         uint256 digits;
322         while (temp != 0) {
323             digits++;
324             temp /= 10;
325         }
326         bytes memory buffer = new bytes(digits);
327         while (value != 0) {
328             digits -= 1;
329             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
330             value /= 10;
331         }
332         return string(buffer);
333     }
334 
335     /**
336      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
337      */
338     function toHexString(uint256 value) internal pure returns (string memory) {
339         if (value == 0) {
340             return "0x00";
341         }
342         uint256 temp = value;
343         uint256 length = 0;
344         while (temp != 0) {
345             length++;
346             temp >>= 8;
347         }
348         return toHexString(value, length);
349     }
350 
351     /**
352      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
353      */
354     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
355         bytes memory buffer = new bytes(2 * length + 2);
356         buffer[0] = "0";
357         buffer[1] = "x";
358         for (uint256 i = 2 * length + 1; i > 1; --i) {
359             buffer[i] = _HEX_SYMBOLS[value & 0xf];
360             value >>= 4;
361         }
362         require(value == 0, "Strings: hex length insufficient");
363         return string(buffer);
364     }
365 }
366 
367 // File: @openzeppelin/contracts/utils/Context.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Provides information about the current execution context, including the
376  * sender of the transaction and its data. While these are generally available
377  * via msg.sender and msg.data, they should not be accessed in such a direct
378  * manner, since when dealing with meta-transactions the account sending and
379  * paying for execution may not be the actual sender (as far as an application
380  * is concerned).
381  *
382  * This contract is only required for intermediate, library-like contracts.
383  */
384 abstract contract Context {
385     function _msgSender() internal view virtual returns (address) {
386         return msg.sender;
387     }
388 
389     function _msgData() internal view virtual returns (bytes calldata) {
390         return msg.data;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/access/Ownable.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Contract module which provides a basic access control mechanism, where
404  * there is an account (an owner) that can be granted exclusive access to
405  * specific functions.
406  *
407  * By default, the owner account will be the one that deploys the contract. This
408  * can later be changed with {transferOwnership}.
409  *
410  * This module is used through inheritance. It will make available the modifier
411  * `onlyOwner`, which can be applied to your functions to restrict their use to
412  * the owner.
413  */
414 abstract contract Ownable is Context {
415     address private _owner;
416 
417     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
418 
419     /**
420      * @dev Initializes the contract setting the deployer as the initial owner.
421      */
422     constructor() {
423         _transferOwnership(_msgSender());
424     }
425 
426     /**
427      * @dev Returns the address of the current owner.
428      */
429     function owner() public view virtual returns (address) {
430         return _owner;
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         require(owner() == _msgSender(), "Ownable: caller is not the owner");
438         _;
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         _transferOwnership(address(0));
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         _transferOwnership(newOwner);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Internal function without access restriction.
464      */
465     function _transferOwnership(address newOwner) internal virtual {
466         address oldOwner = _owner;
467         _owner = newOwner;
468         emit OwnershipTransferred(oldOwner, newOwner);
469     }
470 }
471 
472 // File: @openzeppelin/contracts/utils/Address.sol
473 
474 
475 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
476 
477 pragma solidity ^0.8.1;
478 
479 /**
480  * @dev Collection of functions related to the address type
481  */
482 library Address {
483     /**
484      * @dev Returns true if `account` is a contract.
485      *
486      * [IMPORTANT]
487      * ====
488      * It is unsafe to assume that an address for which this function returns
489      * false is an externally-owned account (EOA) and not a contract.
490      *
491      * Among others, `isContract` will return false for the following
492      * types of addresses:
493      *
494      *  - an externally-owned account
495      *  - a contract in construction
496      *  - an address where a contract will be created
497      *  - an address where a contract lived, but was destroyed
498      * ====
499      *
500      * [IMPORTANT]
501      * ====
502      * You shouldn't rely on `isContract` to protect against flash loan attacks!
503      *
504      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
505      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
506      * constructor.
507      * ====
508      */
509     function isContract(address account) internal view returns (bool) {
510         // This method relies on extcodesize/address.code.length, which returns 0
511         // for contracts in construction, since the code is only stored at the end
512         // of the constructor execution.
513 
514         return account.code.length > 0;
515     }
516 
517     /**
518      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
519      * `recipient`, forwarding all available gas and reverting on errors.
520      *
521      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
522      * of certain opcodes, possibly making contracts go over the 2300 gas limit
523      * imposed by `transfer`, making them unable to receive funds via
524      * `transfer`. {sendValue} removes this limitation.
525      *
526      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
527      *
528      * IMPORTANT: because control is transferred to `recipient`, care must be
529      * taken to not create reentrancy vulnerabilities. Consider using
530      * {ReentrancyGuard} or the
531      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
532      */
533     function sendValue(address payable recipient, uint256 amount) internal {
534         require(address(this).balance >= amount, "Address: insufficient balance");
535 
536         (bool success, ) = recipient.call{value: amount}("");
537         require(success, "Address: unable to send value, recipient may have reverted");
538     }
539 
540     /**
541      * @dev Performs a Solidity function call using a low level `call`. A
542      * plain `call` is an unsafe replacement for a function call: use this
543      * function instead.
544      *
545      * If `target` reverts with a revert reason, it is bubbled up by this
546      * function (like regular Solidity function calls).
547      *
548      * Returns the raw returned data. To convert to the expected return value,
549      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
550      *
551      * Requirements:
552      *
553      * - `target` must be a contract.
554      * - calling `target` with `data` must not revert.
555      *
556      * _Available since v3.1._
557      */
558     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionCall(target, data, "Address: low-level call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
564      * `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, 0, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but also transferring `value` wei to `target`.
579      *
580      * Requirements:
581      *
582      * - the calling contract must have an ETH balance of at least `value`.
583      * - the called Solidity function must be `payable`.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(
588         address target,
589         bytes memory data,
590         uint256 value
591     ) internal returns (bytes memory) {
592         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
597      * with `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(
602         address target,
603         bytes memory data,
604         uint256 value,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         require(address(this).balance >= value, "Address: insufficient balance for call");
608         require(isContract(target), "Address: call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.call{value: value}(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a static call.
617      *
618      * _Available since v3.3._
619      */
620     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
621         return functionStaticCall(target, data, "Address: low-level static call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a static call.
627      *
628      * _Available since v3.3._
629      */
630     function functionStaticCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal view returns (bytes memory) {
635         require(isContract(target), "Address: static call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.staticcall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
643      * but performing a delegate call.
644      *
645      * _Available since v3.4._
646      */
647     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
648         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
653      * but performing a delegate call.
654      *
655      * _Available since v3.4._
656      */
657     function functionDelegateCall(
658         address target,
659         bytes memory data,
660         string memory errorMessage
661     ) internal returns (bytes memory) {
662         require(isContract(target), "Address: delegate call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.delegatecall(data);
665         return verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
670      * revert reason using the provided one.
671      *
672      * _Available since v4.3._
673      */
674     function verifyCallResult(
675         bool success,
676         bytes memory returndata,
677         string memory errorMessage
678     ) internal pure returns (bytes memory) {
679         if (success) {
680             return returndata;
681         } else {
682             // Look for revert reason and bubble it up if present
683             if (returndata.length > 0) {
684                 // The easiest way to bubble the revert reason is using memory via assembly
685 
686                 assembly {
687                     let returndata_size := mload(returndata)
688                     revert(add(32, returndata), returndata_size)
689                 }
690             } else {
691                 revert(errorMessage);
692             }
693         }
694     }
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 /**
705  * @title ERC721 token receiver interface
706  * @dev Interface for any contract that wants to support safeTransfers
707  * from ERC721 asset contracts.
708  */
709 interface IERC721Receiver {
710     /**
711      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
712      * by `operator` from `from`, this function is called.
713      *
714      * It must return its Solidity selector to confirm the token transfer.
715      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
716      *
717      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
718      */
719     function onERC721Received(
720         address operator,
721         address from,
722         uint256 tokenId,
723         bytes calldata data
724     ) external returns (bytes4);
725 }
726 
727 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Interface of the ERC165 standard, as defined in the
736  * https://eips.ethereum.org/EIPS/eip-165[EIP].
737  *
738  * Implementers can declare support of contract interfaces, which can then be
739  * queried by others ({ERC165Checker}).
740  *
741  * For an implementation, see {ERC165}.
742  */
743 interface IERC165 {
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30 000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) external view returns (bool);
753 }
754 
755 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
756 
757 
758 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 
763 /**
764  * @dev Implementation of the {IERC165} interface.
765  *
766  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
767  * for the additional interface id that will be supported. For example:
768  *
769  * ```solidity
770  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
772  * }
773  * ```
774  *
775  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
776  */
777 abstract contract ERC165 is IERC165 {
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
782         return interfaceId == type(IERC165).interfaceId;
783     }
784 }
785 
786 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
787 
788 
789 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @dev Required interface of an ERC721 compliant contract.
796  */
797 interface IERC721 is IERC165 {
798     /**
799      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
800      */
801     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
802 
803     /**
804      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
805      */
806     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
807 
808     /**
809      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
810      */
811     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
812 
813     /**
814      * @dev Returns the number of tokens in ``owner``'s account.
815      */
816     function balanceOf(address owner) external view returns (uint256 balance);
817 
818     /**
819      * @dev Returns the owner of the `tokenId` token.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function ownerOf(uint256 tokenId) external view returns (address owner);
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
829      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must exist and be owned by `from`.
836      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function safeTransferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) external;
846 
847     /**
848      * @dev Transfers `tokenId` token from `from` to `to`.
849      *
850      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must be owned by `from`.
857      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
858      *
859      * Emits a {Transfer} event.
860      */
861     function transferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) external;
866 
867     /**
868      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
869      * The approval is cleared when the token is transferred.
870      *
871      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
872      *
873      * Requirements:
874      *
875      * - The caller must own the token or be an approved operator.
876      * - `tokenId` must exist.
877      *
878      * Emits an {Approval} event.
879      */
880     function approve(address to, uint256 tokenId) external;
881 
882     /**
883      * @dev Returns the account approved for `tokenId` token.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must exist.
888      */
889     function getApproved(uint256 tokenId) external view returns (address operator);
890 
891     /**
892      * @dev Approve or remove `operator` as an operator for the caller.
893      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
894      *
895      * Requirements:
896      *
897      * - The `operator` cannot be the caller.
898      *
899      * Emits an {ApprovalForAll} event.
900      */
901     function setApprovalForAll(address operator, bool _approved) external;
902 
903     /**
904      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
905      *
906      * See {setApprovalForAll}
907      */
908     function isApprovedForAll(address owner, address operator) external view returns (bool);
909 
910     /**
911      * @dev Safely transfers `tokenId` token from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must exist and be owned by `from`.
918      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes calldata data
928     ) external;
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
932 
933 
934 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 /**
940  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
941  * @dev See https://eips.ethereum.org/EIPS/eip-721
942  */
943 interface IERC721Enumerable is IERC721 {
944     /**
945      * @dev Returns the total amount of tokens stored by the contract.
946      */
947     function totalSupply() external view returns (uint256);
948 
949     /**
950      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
951      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
952      */
953     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
954 
955     /**
956      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
957      * Use along with {totalSupply} to enumerate all tokens.
958      */
959     function tokenByIndex(uint256 index) external view returns (uint256);
960 }
961 
962 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
963 
964 
965 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 
970 /**
971  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
972  * @dev See https://eips.ethereum.org/EIPS/eip-721
973  */
974 interface IERC721Metadata is IERC721 {
975     /**
976      * @dev Returns the token collection name.
977      */
978     function name() external view returns (string memory);
979 
980     /**
981      * @dev Returns the token collection symbol.
982      */
983     function symbol() external view returns (string memory);
984 
985     /**
986      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
987      */
988     function tokenURI(uint256 tokenId) external view returns (string memory);
989 }
990 
991 // File: contracts/ERC721A.sol
992 
993 
994 
995 pragma solidity ^0.8.10;
996 
997 
998 
999 
1000 
1001 
1002 
1003 
1004 
1005 /**
1006  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1007  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1008  *
1009  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1010  *
1011  * Does not support burning tokens to address(0).
1012  */
1013 contract ERC721A is
1014   Context,
1015   ERC165,
1016   IERC721,
1017   IERC721Metadata,
1018   IERC721Enumerable
1019 {
1020   using Address for address;
1021   using Strings for uint256;
1022 
1023   struct TokenOwnership {
1024     address addr;
1025     uint64 startTimestamp;
1026   }
1027 
1028   struct AddressData {
1029     uint128 balance;
1030     uint128 numberMinted;
1031   }
1032 
1033   uint256 private currentIndex = 1;
1034 
1035   uint256 public immutable maxBatchSize;
1036 
1037   // Token name
1038   string private _name;
1039 
1040   // Token symbol
1041   string private _symbol;
1042 
1043   // Mapping from token ID to ownership details
1044   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1045   mapping(uint256 => TokenOwnership) private _ownerships;
1046 
1047   // Mapping owner address to address data
1048   mapping(address => AddressData) private _addressData;
1049 
1050   // Mapping from token ID to approved address
1051   mapping(uint256 => address) private _tokenApprovals;
1052 
1053   // Mapping from owner to operator approvals
1054   mapping(address => mapping(address => bool)) private _operatorApprovals;
1055 
1056   /**
1057    * @dev
1058    * `maxBatchSize` refers to how much a minter can mint at a time.
1059    */
1060   constructor(
1061     string memory name_,
1062     string memory symbol_,
1063     uint256 maxBatchSize_
1064   ) {
1065     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1066     _name = name_;
1067     _symbol = symbol_;
1068     maxBatchSize = maxBatchSize_;
1069   }
1070 
1071   /**
1072    * @dev See {IERC721Enumerable-totalSupply}.
1073    */
1074   function totalSupply() public view override returns (uint256) {
1075     return currentIndex - 1;
1076   }
1077 
1078   /**
1079    * @dev See {IERC721Enumerable-tokenByIndex}.
1080    */
1081   function tokenByIndex(uint256 index) public view override returns (uint256) {
1082     require(index < totalSupply(), "ERC721A: global index out of bounds");
1083     return index;
1084   }
1085 
1086   /**
1087    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1088    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1089    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1090    */
1091   function tokenOfOwnerByIndex(address owner, uint256 index)
1092     public
1093     view
1094     override
1095     returns (uint256)
1096   {
1097     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1098     uint256 numMintedSoFar = totalSupply();
1099     uint256 tokenIdsIdx = 0;
1100     address currOwnershipAddr = address(0);
1101     for (uint256 i = 0; i < numMintedSoFar; i++) {
1102       TokenOwnership memory ownership = _ownerships[i];
1103       if (ownership.addr != address(0)) {
1104         currOwnershipAddr = ownership.addr;
1105       }
1106       if (currOwnershipAddr == owner) {
1107         if (tokenIdsIdx == index) {
1108           return i;
1109         }
1110         tokenIdsIdx++;
1111       }
1112     }
1113     revert("ERC721A: unable to get token of owner by index");
1114   }
1115 
1116   /**
1117    * @dev See {IERC165-supportsInterface}.
1118    */
1119   function supportsInterface(bytes4 interfaceId)
1120     public
1121     view
1122     virtual
1123     override(ERC165, IERC165)
1124     returns (bool)
1125   {
1126     return
1127       interfaceId == type(IERC721).interfaceId ||
1128       interfaceId == type(IERC721Metadata).interfaceId ||
1129       interfaceId == type(IERC721Enumerable).interfaceId ||
1130       super.supportsInterface(interfaceId);
1131   }
1132 
1133   /**
1134    * @dev See {IERC721-balanceOf}.
1135    */
1136   function balanceOf(address owner) public view override returns (uint256) {
1137     require(owner != address(0), "ERC721A: balance query for the zero address");
1138     return uint256(_addressData[owner].balance);
1139   }
1140 
1141   function _numberMinted(address owner) internal view returns (uint256) {
1142     require(
1143       owner != address(0),
1144       "ERC721A: number minted query for the zero address"
1145     );
1146     return uint256(_addressData[owner].numberMinted);
1147   }
1148 
1149   function ownershipOf(uint256 tokenId)
1150     internal
1151     view
1152     returns (TokenOwnership memory)
1153   {
1154     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1155 
1156     uint256 lowestTokenToCheck;
1157     if (tokenId >= maxBatchSize) {
1158       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1159     }
1160 
1161     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1162       TokenOwnership memory ownership = _ownerships[curr];
1163       if (ownership.addr != address(0)) {
1164         return ownership;
1165       }
1166     }
1167 
1168     revert("ERC721A: unable to determine the owner of token");
1169   }
1170 
1171   /**
1172    * @dev See {IERC721-ownerOf}.
1173    */
1174   function ownerOf(uint256 tokenId) public view override returns (address) {
1175     return ownershipOf(tokenId).addr;
1176   }
1177 
1178   /**
1179    * @dev See {IERC721Metadata-name}.
1180    */
1181   function name() public view virtual override returns (string memory) {
1182     return _name;
1183   }
1184 
1185   /**
1186    * @dev See {IERC721Metadata-symbol}.
1187    */
1188   function symbol() public view virtual override returns (string memory) {
1189     return _symbol;
1190   }
1191 
1192   /**
1193    * @dev See {IERC721Metadata-tokenURI}.
1194    */
1195   function tokenURI(uint256 tokenId)
1196     public
1197     view
1198     virtual
1199     override
1200     returns (string memory)
1201   {
1202     require(
1203       _exists(tokenId),
1204       "ERC721Metadata: URI query for nonexistent token"
1205     );
1206 
1207     string memory baseURI = _baseURI();
1208     return
1209       bytes(baseURI).length > 0
1210         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1211         : "";
1212   }
1213 
1214   /**
1215    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1216    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1217    * by default, can be overriden in child contracts.
1218    */
1219   function _baseURI() internal view virtual returns (string memory) {
1220     return "";
1221   }
1222 
1223   /**
1224    * @dev See {IERC721-approve}.
1225    */
1226   function approve(address to, uint256 tokenId) public override {
1227     address owner = ERC721A.ownerOf(tokenId);
1228     require(to != owner, "ERC721A: approval to current owner");
1229 
1230     require(
1231       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1232       "ERC721A: approve caller is not owner nor approved for all"
1233     );
1234 
1235     _approve(to, tokenId, owner);
1236   }
1237 
1238   /**
1239    * @dev See {IERC721-getApproved}.
1240    */
1241   function getApproved(uint256 tokenId) public view override returns (address) {
1242     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1243 
1244     return _tokenApprovals[tokenId];
1245   }
1246 
1247   /**
1248    * @dev See {IERC721-setApprovalForAll}.
1249    */
1250   function setApprovalForAll(address operator, bool approved) public override {
1251     require(operator != _msgSender(), "ERC721A: approve to caller");
1252 
1253     _operatorApprovals[_msgSender()][operator] = approved;
1254     emit ApprovalForAll(_msgSender(), operator, approved);
1255   }
1256 
1257   /**
1258    * @dev See {IERC721-isApprovedForAll}.
1259    */
1260   function isApprovedForAll(address owner, address operator)
1261     public
1262     view
1263     virtual
1264     override
1265     returns (bool)
1266   {
1267     return _operatorApprovals[owner][operator];
1268   }
1269 
1270   /**
1271    * @dev See {IERC721-transferFrom}.
1272    */
1273   function transferFrom(
1274     address from,
1275     address to,
1276     uint256 tokenId
1277   ) public override {
1278     _transfer(from, to, tokenId);
1279   }
1280 
1281   /**
1282    * @dev See {IERC721-safeTransferFrom}.
1283    */
1284   function safeTransferFrom(
1285     address from,
1286     address to,
1287     uint256 tokenId
1288   ) public override {
1289     safeTransferFrom(from, to, tokenId, "");
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-safeTransferFrom}.
1294    */
1295   function safeTransferFrom(
1296     address from,
1297     address to,
1298     uint256 tokenId,
1299     bytes memory _data
1300   ) public override {
1301     _transfer(from, to, tokenId);
1302     require(
1303       _checkOnERC721Received(from, to, tokenId, _data),
1304       "ERC721A: transfer to non ERC721Receiver implementer"
1305     );
1306   }
1307 
1308   /**
1309    * @dev Returns whether `tokenId` exists.
1310    *
1311    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1312    *
1313    * Tokens start existing when they are minted (`_mint`),
1314    */
1315   function _exists(uint256 tokenId) internal view returns (bool) {
1316     return tokenId < currentIndex;
1317   }
1318 
1319   function _safeMint(address to, uint256 quantity) internal {
1320     _safeMint(to, quantity, "");
1321   }
1322 
1323   /**
1324    * @dev Mints `quantity` tokens and transfers them to `to`.
1325    *
1326    * Requirements:
1327    *
1328    * - `to` cannot be the zero address.
1329    * - `quantity` cannot be larger than the max batch size.
1330    *
1331    * Emits a {Transfer} event.
1332    */
1333   function _safeMint(
1334     address to,
1335     uint256 quantity,
1336     bytes memory _data
1337   ) internal {
1338     uint256 startTokenId = currentIndex;
1339     require(to != address(0), "ERC721A: mint to the zero address");
1340     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1341     require(!_exists(startTokenId), "ERC721A: token already minted");
1342     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1343 
1344     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1345 
1346     AddressData memory addressData = _addressData[to];
1347     _addressData[to] = AddressData(
1348       addressData.balance + uint128(quantity),
1349       addressData.numberMinted + uint128(quantity)
1350     );
1351     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1352 
1353     uint256 updatedIndex = startTokenId;
1354 
1355     for (uint256 i = 0; i < quantity; i++) {
1356       emit Transfer(address(0), to, updatedIndex);
1357       require(
1358         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1359         "ERC721A: transfer to non ERC721Receiver implementer"
1360       );
1361       updatedIndex++;
1362     }
1363 
1364     currentIndex = updatedIndex;
1365     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1366   }
1367 
1368   /**
1369    * @dev Transfers `tokenId` from `from` to `to`.
1370    *
1371    * Requirements:
1372    *
1373    * - `to` cannot be the zero address.
1374    * - `tokenId` token must be owned by `from`.
1375    *
1376    * Emits a {Transfer} event.
1377    */
1378   function _transfer(
1379     address from,
1380     address to,
1381     uint256 tokenId
1382   ) private {
1383     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1384 
1385     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1386       getApproved(tokenId) == _msgSender() ||
1387       isApprovedForAll(prevOwnership.addr, _msgSender()));
1388 
1389     require(
1390       isApprovedOrOwner,
1391       "ERC721A: transfer caller is not owner nor approved"
1392     );
1393 
1394     require(
1395       prevOwnership.addr == from,
1396       "ERC721A: transfer from incorrect owner"
1397     );
1398     require(to != address(0), "ERC721A: transfer to the zero address");
1399 
1400     _beforeTokenTransfers(from, to, tokenId, 1);
1401 
1402     // Clear approvals from the previous owner
1403     _approve(address(0), tokenId, prevOwnership.addr);
1404 
1405     _addressData[from].balance -= 1;
1406     _addressData[to].balance += 1;
1407     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1408 
1409     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1410     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1411     uint256 nextTokenId = tokenId + 1;
1412     if (_ownerships[nextTokenId].addr == address(0)) {
1413       if (_exists(nextTokenId)) {
1414         _ownerships[nextTokenId] = TokenOwnership(
1415           prevOwnership.addr,
1416           prevOwnership.startTimestamp
1417         );
1418       }
1419     }
1420 
1421     emit Transfer(from, to, tokenId);
1422     _afterTokenTransfers(from, to, tokenId, 1);
1423   }
1424 
1425   /**
1426    * @dev Approve `to` to operate on `tokenId`
1427    *
1428    * Emits a {Approval} event.
1429    */
1430   function _approve(
1431     address to,
1432     uint256 tokenId,
1433     address owner
1434   ) private {
1435     _tokenApprovals[tokenId] = to;
1436     emit Approval(owner, to, tokenId);
1437   }
1438 
1439   uint256 public nextOwnerToExplicitlySet = 0;
1440 
1441   /**
1442    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1443    */
1444   function _setOwnersExplicit(uint256 quantity) internal {
1445     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1446     require(quantity > 0, "quantity must be nonzero");
1447     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1448     if (endIndex > currentIndex - 1) {
1449       endIndex = currentIndex - 1;
1450     }
1451     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1452     require(_exists(endIndex), "not enough minted yet for this cleanup");
1453     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1454       if (_ownerships[i].addr == address(0)) {
1455         TokenOwnership memory ownership = ownershipOf(i);
1456         _ownerships[i] = TokenOwnership(
1457           ownership.addr,
1458           ownership.startTimestamp
1459         );
1460       }
1461     }
1462     nextOwnerToExplicitlySet = endIndex + 1;
1463   }
1464 
1465   /**
1466    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1467    * The call is not executed if the target address is not a contract.
1468    *
1469    * @param from address representing the previous owner of the given token ID
1470    * @param to target address that will receive the tokens
1471    * @param tokenId uint256 ID of the token to be transferred
1472    * @param _data bytes optional data to send along with the call
1473    * @return bool whether the call correctly returned the expected magic value
1474    */
1475   function _checkOnERC721Received(
1476     address from,
1477     address to,
1478     uint256 tokenId,
1479     bytes memory _data
1480   ) private returns (bool) {
1481     if (to.isContract()) {
1482       try
1483         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1484       returns (bytes4 retval) {
1485         return retval == IERC721Receiver(to).onERC721Received.selector;
1486       } catch (bytes memory reason) {
1487         if (reason.length == 0) {
1488           revert("ERC721A: transfer to non ERC721Receiver implementer");
1489         } else {
1490           assembly {
1491             revert(add(32, reason), mload(reason))
1492           }
1493         }
1494       }
1495     } else {
1496       return true;
1497     }
1498   }
1499 
1500   /**
1501    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1502    *
1503    * startTokenId - the first token id to be transferred
1504    * quantity - the amount to be transferred
1505    *
1506    * Calling conditions:
1507    *
1508    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1509    * transferred to `to`.
1510    * - When `from` is zero, `tokenId` will be minted for `to`.
1511    */
1512   function _beforeTokenTransfers(
1513     address from,
1514     address to,
1515     uint256 startTokenId,
1516     uint256 quantity
1517   ) internal virtual {}
1518 
1519   /**
1520    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1521    * minting.
1522    *
1523    * startTokenId - the first token id to be transferred
1524    * quantity - the amount to be transferred
1525    *
1526    * Calling conditions:
1527    *
1528    * - when `from` and `to` are both non-zero.
1529    * - `from` and `to` are never both zero.
1530    */
1531   function _afterTokenTransfers(
1532     address from,
1533     address to,
1534     uint256 startTokenId,
1535     uint256 quantity
1536   ) internal virtual {}
1537 }
1538 // File: contracts/PPTC.sol
1539 
1540 
1541 
1542 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
1543 
1544 
1545 
1546 pragma solidity >=0.7.0 <0.9.0;
1547 
1548 
1549 
1550 
1551 
1552 
1553 contract ProperParrotTreeClub is ERC721A, Ownable {
1554   using Strings for uint256;
1555 
1556   string public baseURI;
1557   string public baseExtension = ".json";
1558   string public notRevealedUri;
1559   uint256 public cost = 0.05 ether;
1560   uint256 public wlcost = 0.04 ether;
1561   uint256 public maxSupply = 10000;
1562   uint256 public WlSupply = 5000;
1563   uint256 public MaxperWallet = 20;
1564   uint256 public MaxperWalletWl = 20;
1565   uint256 public MaxperTxWl = 20;
1566   uint256 public maxsize = 20 ; // max mint per tx
1567   bool public paused = true;
1568   bool public revealed = false;
1569   bool public preSale = true;
1570   bool public publicSale = false;
1571   bytes32 public merkleRoot = 0x7d47dd9d8fd212164c3a9e8d23f89077455d468a3e287590d7f66b9c5ed8dcfd;
1572 
1573   constructor(
1574     string memory _initBaseURI,
1575     string memory _initNotRevealedUri
1576   ) ERC721A("Proper Parrot Tree Club", "PPTC", maxsize) {
1577     setBaseURI(_initBaseURI);
1578     setNotRevealedURI(_initNotRevealedUri);
1579   }
1580 
1581   // internal
1582   function _baseURI() internal view virtual override returns (string memory) {
1583     return baseURI;
1584   }
1585 
1586   // public
1587   function mint(uint256 tokens) public payable {
1588     require(!paused, "PPTC: Oops contract is paused");
1589     require(publicSale, "PPTC: Sale Hasn't started yet");
1590     uint256 supply = totalSupply();
1591     uint256 ownerTokenCount = balanceOf(_msgSender());
1592     require(tokens > 0, "PPTC: need to mint at least 1 NFT");
1593     require(tokens <= maxsize, "PPTC: max mint amount per tx exceeded");
1594     require(supply + tokens <= maxSupply, "PPTC: We Soldout");
1595     require(ownerTokenCount + tokens <= MaxperWallet, "PPTC: Max NFT Per Wallet exceeded");
1596     require(msg.value >= cost * tokens, "PPTC: insufficient funds");
1597 
1598       _safeMint(_msgSender(), tokens);
1599     
1600   }
1601 
1602     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable  {
1603     require(!paused, "PPTC: Oops contract is paused");
1604     require(preSale, "PPTC: Presale Hasn't started yet");
1605     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "PPTC: You are not eligible for the presale");
1606     uint256 supply = totalSupply();
1607     uint256 ownerTokenCount = balanceOf(_msgSender());
1608     require(ownerTokenCount + tokens <= MaxperWalletWl, "PPTC: Max NFT Per Wallet exceeded");
1609     require(tokens > 0, "PPTC: need to mint at least 1 NFT");
1610     require(tokens <= maxsize, "PPTC: max mint per Tx exceeded");
1611     require(supply + tokens <= WlSupply, "PPTC: WL Supply exceeded");
1612     require(msg.value >= wlcost * tokens, "insufficient funds");
1613 
1614       _safeMint(_msgSender(), tokens);
1615     
1616   }
1617 
1618 
1619 
1620 
1621   /// @dev use it for giveaway and mint for yourself
1622      function gift(uint256 _mintAmount, address destination) public onlyOwner {
1623     require(_mintAmount > 0, "need to mint at least 1 NFT");
1624     uint256 supply = totalSupply();
1625     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1626 
1627       _safeMint(destination, _mintAmount);
1628     
1629   }
1630 
1631   
1632 
1633 
1634   function walletOfOwner(address _owner)
1635     public
1636     view
1637     returns (uint256[] memory)
1638   {
1639     uint256 ownerTokenCount = balanceOf(_owner);
1640     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1641     for (uint256 i; i < ownerTokenCount; i++) {
1642       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1643     }
1644     return tokenIds;
1645   }
1646 
1647   function tokenURI(uint256 tokenId)
1648     public
1649     view
1650     virtual
1651     override
1652     returns (string memory)
1653   {
1654     require(
1655       _exists(tokenId),
1656       "ERC721AMetadata: URI query for nonexistent token"
1657     );
1658     
1659     if(revealed == false) {
1660         return notRevealedUri;
1661     }
1662 
1663     string memory currentBaseURI = _baseURI();
1664     return bytes(currentBaseURI).length > 0
1665         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1666         : "";
1667   }
1668 
1669   //only owner
1670   function reveal() public onlyOwner {
1671       revealed = true;
1672   }
1673 
1674       function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1675         merkleRoot = _merkleRoot;
1676     }
1677   
1678   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1679     MaxperWallet = _limit;
1680   }
1681 
1682     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
1683     MaxperWalletWl = _limit;
1684   }
1685 
1686   function setmaxsize(uint256 _maxsize) public onlyOwner {
1687     maxsize = _maxsize;
1688   }
1689 
1690     function setWLMaxpertx(uint256 _maxpertx) public onlyOwner {
1691     MaxperTxWl = _maxpertx;
1692   }
1693   
1694   function setCost(uint256 _newCost) public onlyOwner {
1695     cost = _newCost;
1696   }
1697 
1698     function setWlCost(uint256 _newWlCost) public onlyOwner {
1699     wlcost = _newWlCost;
1700   }
1701 
1702     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1703     maxSupply = _newsupply;
1704   }
1705 
1706     function setwlsupply(uint256 _newsupply) public onlyOwner {
1707     WlSupply = _newsupply;
1708   }
1709 
1710   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1711     baseURI = _newBaseURI;
1712   }
1713 
1714   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1715     baseExtension = _newBaseExtension;
1716   }
1717   
1718   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1719     notRevealedUri = _notRevealedURI;
1720   }
1721 
1722   function pause(bool _state) public onlyOwner {
1723     paused = _state;
1724   }
1725 
1726       function togglepreSale(bool _state) external onlyOwner {
1727         preSale = _state;
1728     }
1729 
1730     function togglepublicSale(bool _state) external onlyOwner {
1731         publicSale = _state;
1732     }
1733   
1734  
1735   function withdraw() public payable onlyOwner {
1736     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1737     require(success);
1738   }
1739 }