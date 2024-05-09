1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev These functions deal with verification of Merkle Trees proofs.
9  *
10  * The proofs can be generated using the JavaScript library
11  * https://github.com/miguelmota/merkletreejs[merkletreejs].
12  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
13  *
14  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
15  */
16 library MerkleProof {
17     /**
18      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
19      * defined by `root`. For this, a `proof` must be provided, containing
20      * sibling hashes on the branch from the leaf to the root of the tree. Each
21      * pair of leaves and each pair of pre-images are assumed to be sorted.
22      */
23     function verify(
24         bytes32[] memory proof,
25         bytes32 root,
26         bytes32 leaf
27     ) internal pure returns (bool) {
28         bytes32 computedHash = leaf;
29 
30         for (uint256 i = 0; i < proof.length; i++) {
31             bytes32 proofElement = proof[i];
32 
33             if (computedHash <= proofElement) {
34                 // Hash(current computed hash + current element of the proof)
35                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
36             } else {
37                 // Hash(current element of the proof + current computed hash)
38                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
39             }
40         }
41 
42         // Check if the computed hash (root) is equal to the provided root
43         return computedHash == root;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Counters.sol
48 
49 
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @title Counters
55  * @author Matt Condon (@shrugs)
56  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
57  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
58  *
59  * Include with `using Counters for Counters.Counter;`
60  */
61 library Counters {
62     struct Counter {
63         // This variable should never be directly accessed by users of the library: interactions must be restricted to
64         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
65         // this feature: see https://github.com/ethereum/solidity/issues/4637
66         uint256 _value; // default: 0
67     }
68 
69     function current(Counter storage counter) internal view returns (uint256) {
70         return counter._value;
71     }
72 
73     function increment(Counter storage counter) internal {
74         unchecked {
75             counter._value += 1;
76         }
77     }
78 
79     function decrement(Counter storage counter) internal {
80         uint256 value = counter._value;
81         require(value > 0, "Counter: decrement overflow");
82         unchecked {
83             counter._value = value - 1;
84         }
85     }
86 
87     function reset(Counter storage counter) internal {
88         counter._value = 0;
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
93 
94 
95 
96 pragma solidity ^0.8.0;
97 
98 // CAUTION
99 // This version of SafeMath should only be used with Solidity 0.8 or later,
100 // because it relies on the compiler's built in overflow checks.
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations.
104  *
105  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
106  * now has built in overflow checking.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, with an overflow flag.
111      *
112      * _Available since v3.4._
113      */
114     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
115         unchecked {
116             uint256 c = a + b;
117             if (c < a) return (false, 0);
118             return (true, c);
119         }
120     }
121 
122     /**
123      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
124      *
125      * _Available since v3.4._
126      */
127     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
128         unchecked {
129             if (b > a) return (false, 0);
130             return (true, a - b);
131         }
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         unchecked {
141             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142             // benefit is lost if 'b' is also tested.
143             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
144             if (a == 0) return (true, 0);
145             uint256 c = a * b;
146             if (c / a != b) return (false, 0);
147             return (true, c);
148         }
149     }
150 
151     /**
152      * @dev Returns the division of two unsigned integers, with a division by zero flag.
153      *
154      * _Available since v3.4._
155      */
156     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157         unchecked {
158             if (b == 0) return (false, 0);
159             return (true, a / b);
160         }
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
165      *
166      * _Available since v3.4._
167      */
168     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         unchecked {
170             if (b == 0) return (false, 0);
171             return (true, a % b);
172         }
173     }
174 
175     /**
176      * @dev Returns the addition of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `+` operator.
180      *
181      * Requirements:
182      *
183      * - Addition cannot overflow.
184      */
185     function add(uint256 a, uint256 b) internal pure returns (uint256) {
186         return a + b;
187     }
188 
189     /**
190      * @dev Returns the subtraction of two unsigned integers, reverting on
191      * overflow (when the result is negative).
192      *
193      * Counterpart to Solidity's `-` operator.
194      *
195      * Requirements:
196      *
197      * - Subtraction cannot overflow.
198      */
199     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a - b;
201     }
202 
203     /**
204      * @dev Returns the multiplication of two unsigned integers, reverting on
205      * overflow.
206      *
207      * Counterpart to Solidity's `*` operator.
208      *
209      * Requirements:
210      *
211      * - Multiplication cannot overflow.
212      */
213     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a * b;
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers, reverting on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator.
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b) internal pure returns (uint256) {
228         return a / b;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * reverting when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a % b;
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
249      * overflow (when the result is negative).
250      *
251      * CAUTION: This function is deprecated because it requires allocating memory for the error
252      * message unnecessarily. For custom revert reasons use {trySub}.
253      *
254      * Counterpart to Solidity's `-` operator.
255      *
256      * Requirements:
257      *
258      * - Subtraction cannot overflow.
259      */
260     function sub(
261         uint256 a,
262         uint256 b,
263         string memory errorMessage
264     ) internal pure returns (uint256) {
265         unchecked {
266             require(b <= a, errorMessage);
267             return a - b;
268         }
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function div(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         unchecked {
289             require(b > 0, errorMessage);
290             return a / b;
291         }
292     }
293 
294     /**
295      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
296      * reverting with custom message when dividing by zero.
297      *
298      * CAUTION: This function is deprecated because it requires allocating memory for the error
299      * message unnecessarily. For custom revert reasons use {tryMod}.
300      *
301      * Counterpart to Solidity's `%` operator. This function uses a `revert`
302      * opcode (which leaves remaining gas untouched) while Solidity uses an
303      * invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function mod(
310         uint256 a,
311         uint256 b,
312         string memory errorMessage
313     ) internal pure returns (uint256) {
314         unchecked {
315             require(b > 0, errorMessage);
316             return a % b;
317         }
318     }
319 }
320 
321 // File: @openzeppelin/contracts/utils/Strings.sol
322 
323 
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @dev String operations.
329  */
330 library Strings {
331     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
332 
333     /**
334      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
335      */
336     function toString(uint256 value) internal pure returns (string memory) {
337         // Inspired by OraclizeAPI's implementation - MIT licence
338         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
339 
340         if (value == 0) {
341             return "0";
342         }
343         uint256 temp = value;
344         uint256 digits;
345         while (temp != 0) {
346             digits++;
347             temp /= 10;
348         }
349         bytes memory buffer = new bytes(digits);
350         while (value != 0) {
351             digits -= 1;
352             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
353             value /= 10;
354         }
355         return string(buffer);
356     }
357 
358     /**
359      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
360      */
361     function toHexString(uint256 value) internal pure returns (string memory) {
362         if (value == 0) {
363             return "0x00";
364         }
365         uint256 temp = value;
366         uint256 length = 0;
367         while (temp != 0) {
368             length++;
369             temp >>= 8;
370         }
371         return toHexString(value, length);
372     }
373 
374     /**
375      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
376      */
377     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
378         bytes memory buffer = new bytes(2 * length + 2);
379         buffer[0] = "0";
380         buffer[1] = "x";
381         for (uint256 i = 2 * length + 1; i > 1; --i) {
382             buffer[i] = _HEX_SYMBOLS[value & 0xf];
383             value >>= 4;
384         }
385         require(value == 0, "Strings: hex length insufficient");
386         return string(buffer);
387     }
388 }
389 
390 // File: @openzeppelin/contracts/utils/Context.sol
391 
392 
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Provides information about the current execution context, including the
398  * sender of the transaction and its data. While these are generally available
399  * via msg.sender and msg.data, they should not be accessed in such a direct
400  * manner, since when dealing with meta-transactions the account sending and
401  * paying for execution may not be the actual sender (as far as an application
402  * is concerned).
403  *
404  * This contract is only required for intermediate, library-like contracts.
405  */
406 abstract contract Context {
407     function _msgSender() internal view virtual returns (address) {
408         return msg.sender;
409     }
410 
411     function _msgData() internal view virtual returns (bytes calldata) {
412         return msg.data;
413     }
414 }
415 
416 // File: @openzeppelin/contracts/access/Ownable.sol
417 
418 
419 
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @dev Contract module which provides a basic access control mechanism, where
425  * there is an account (an owner) that can be granted exclusive access to
426  * specific functions.
427  *
428  * By default, the owner account will be the one that deploys the contract. This
429  * can later be changed with {transferOwnership}.
430  *
431  * This module is used through inheritance. It will make available the modifier
432  * `onlyOwner`, which can be applied to your functions to restrict their use to
433  * the owner.
434  */
435 abstract contract Ownable is Context {
436     address private _owner;
437 
438     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439 
440     /**
441      * @dev Initializes the contract setting the deployer as the initial owner.
442      */
443     constructor() {
444         _setOwner(_msgSender());
445     }
446 
447     /**
448      * @dev Returns the address of the current owner.
449      */
450     function owner() public view virtual returns (address) {
451         return _owner;
452     }
453 
454     /**
455      * @dev Throws if called by any account other than the owner.
456      */
457     modifier onlyOwner() {
458         require(owner() == _msgSender(), "Ownable: caller is not the owner");
459         _;
460     }
461 
462     /**
463      * @dev Leaves the contract without owner. It will not be possible to call
464      * `onlyOwner` functions anymore. Can only be called by the current owner.
465      *
466      * NOTE: Renouncing ownership will leave the contract without an owner,
467      * thereby removing any functionality that is only available to the owner.
468      */
469     //function renounceOwnership() public virtual onlyOwner {
470     //    _setOwner(address(0));
471     //}
472 
473     /**
474      * @dev Transfers ownership of the contract to a new account (`newOwner`).
475      * Can only be called by the current owner.
476      */
477     function transferOwnership(address newOwner) public virtual onlyOwner {
478         require(newOwner != address(0), "Ownable: new owner is the zero address");
479         _setOwner(newOwner);
480     }
481 
482     function _setOwner(address newOwner) private {
483         address oldOwner = _owner;
484         _owner = newOwner;
485         emit OwnershipTransferred(oldOwner, newOwner);
486     }
487 }
488 
489 // File: @openzeppelin/contracts/utils/Address.sol
490 
491 
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Collection of functions related to the address type
497  */
498 library Address {
499     /**
500      * @dev Returns true if `account` is a contract.
501      *
502      * [IMPORTANT]
503      * ====
504      * It is unsafe to assume that an address for which this function returns
505      * false is an externally-owned account (EOA) and not a contract.
506      *
507      * Among others, `isContract` will return false for the following
508      * types of addresses:
509      *
510      *  - an externally-owned account
511      *  - a contract in construction
512      *  - an address where a contract will be created
513      *  - an address where a contract lived, but was destroyed
514      * ====
515      */
516     function isContract(address account) internal view returns (bool) {
517         // This method relies on extcodesize, which returns 0 for contracts in
518         // construction, since the code is only stored at the end of the
519         // constructor execution.
520 
521         uint256 size;
522         assembly {
523             size := extcodesize(account)
524         }
525         return size > 0;
526     }
527 
528     /**
529      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
530      * `recipient`, forwarding all available gas and reverting on errors.
531      *
532      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
533      * of certain opcodes, possibly making contracts go over the 2300 gas limit
534      * imposed by `transfer`, making them unable to receive funds via
535      * `transfer`. {sendValue} removes this limitation.
536      *
537      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
538      *
539      * IMPORTANT: because control is transferred to `recipient`, care must be
540      * taken to not create reentrancy vulnerabilities. Consider using
541      * {ReentrancyGuard} or the
542      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
543      */
544     function sendValue(address payable recipient, uint256 amount) internal {
545         require(address(this).balance >= amount, "Address: insufficient balance");
546 
547         (bool success, ) = recipient.call{value: amount}("");
548         require(success, "Address: unable to send value, recipient may have reverted");
549     }
550 
551     /**
552      * @dev Performs a Solidity function call using a low level `call`. A
553      * plain `call` is an unsafe replacement for a function call: use this
554      * function instead.
555      *
556      * If `target` reverts with a revert reason, it is bubbled up by this
557      * function (like regular Solidity function calls).
558      *
559      * Returns the raw returned data. To convert to the expected return value,
560      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
561      *
562      * Requirements:
563      *
564      * - `target` must be a contract.
565      * - calling `target` with `data` must not revert.
566      *
567      * _Available since v3.1._
568      */
569     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
570         return functionCall(target, data, "Address: low-level call failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
575      * `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCall(
580         address target,
581         bytes memory data,
582         string memory errorMessage
583     ) internal returns (bytes memory) {
584         return functionCallWithValue(target, data, 0, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but also transferring `value` wei to `target`.
590      *
591      * Requirements:
592      *
593      * - the calling contract must have an ETH balance of at least `value`.
594      * - the called Solidity function must be `payable`.
595      *
596      * _Available since v3.1._
597      */
598     function functionCallWithValue(
599         address target,
600         bytes memory data,
601         uint256 value
602     ) internal returns (bytes memory) {
603         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
608      * with `errorMessage` as a fallback revert reason when `target` reverts.
609      *
610      * _Available since v3.1._
611      */
612     function functionCallWithValue(
613         address target,
614         bytes memory data,
615         uint256 value,
616         string memory errorMessage
617     ) internal returns (bytes memory) {
618         require(address(this).balance >= value, "Address: insufficient balance for call");
619         require(isContract(target), "Address: call to non-contract");
620 
621         (bool success, bytes memory returndata) = target.call{value: value}(data);
622         return verifyCallResult(success, returndata, errorMessage);
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
627      * but performing a static call.
628      *
629      * _Available since v3.3._
630      */
631     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
632         return functionStaticCall(target, data, "Address: low-level static call failed");
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
637      * but performing a static call.
638      *
639      * _Available since v3.3._
640      */
641     function functionStaticCall(
642         address target,
643         bytes memory data,
644         string memory errorMessage
645     ) internal view returns (bytes memory) {
646         require(isContract(target), "Address: static call to non-contract");
647 
648         (bool success, bytes memory returndata) = target.staticcall(data);
649         return verifyCallResult(success, returndata, errorMessage);
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
654      * but performing a delegate call.
655      *
656      * _Available since v3.4._
657      */
658     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
659         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
664      * but performing a delegate call.
665      *
666      * _Available since v3.4._
667      */
668     function functionDelegateCall(
669         address target,
670         bytes memory data,
671         string memory errorMessage
672     ) internal returns (bytes memory) {
673         require(isContract(target), "Address: delegate call to non-contract");
674 
675         (bool success, bytes memory returndata) = target.delegatecall(data);
676         return verifyCallResult(success, returndata, errorMessage);
677     }
678 
679     /**
680      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
681      * revert reason using the provided one.
682      *
683      * _Available since v4.3._
684      */
685     function verifyCallResult(
686         bool success,
687         bytes memory returndata,
688         string memory errorMessage
689     ) internal pure returns (bytes memory) {
690         if (success) {
691             return returndata;
692         } else {
693             // Look for revert reason and bubble it up if present
694             if (returndata.length > 0) {
695                 // The easiest way to bubble the revert reason is using memory via assembly
696 
697                 assembly {
698                     let returndata_size := mload(returndata)
699                     revert(add(32, returndata), returndata_size)
700                 }
701             } else {
702                 revert(errorMessage);
703             }
704         }
705     }
706 }
707 
708 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
709 
710 
711 
712 pragma solidity ^0.8.0;
713 
714 /**
715  * @title ERC721 token receiver interface
716  * @dev Interface for any contract that wants to support safeTransfers
717  * from ERC721 asset contracts.
718  */
719 interface IERC721Receiver {
720     /**
721      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
722      * by `operator` from `from`, this function is called.
723      *
724      * It must return its Solidity selector to confirm the token transfer.
725      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
726      *
727      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
728      */
729     function onERC721Received(
730         address operator,
731         address from,
732         uint256 tokenId,
733         bytes calldata data
734     ) external returns (bytes4);
735 }
736 
737 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
738 
739 
740 
741 pragma solidity ^0.8.0;
742 
743 /**
744  * @dev Interface of the ERC165 standard, as defined in the
745  * https://eips.ethereum.org/EIPS/eip-165[EIP].
746  *
747  * Implementers can declare support of contract interfaces, which can then be
748  * queried by others ({ERC165Checker}).
749  *
750  * For an implementation, see {ERC165}.
751  */
752 interface IERC165 {
753     /**
754      * @dev Returns true if this contract implements the interface defined by
755      * `interfaceId`. See the corresponding
756      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
757      * to learn more about how these ids are created.
758      *
759      * This function call must use less than 30 000 gas.
760      */
761     function supportsInterface(bytes4 interfaceId) external view returns (bool);
762 }
763 
764 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
765 
766 
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @dev Implementation of the {IERC165} interface.
773  *
774  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
775  * for the additional interface id that will be supported. For example:
776  *
777  * ```solidity
778  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
779  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
780  * }
781  * ```
782  *
783  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
784  */
785 abstract contract ERC165 is IERC165 {
786     /**
787      * @dev See {IERC165-supportsInterface}.
788      */
789     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
790         return interfaceId == type(IERC165).interfaceId;
791     }
792 }
793 
794 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
795 
796 
797 
798 pragma solidity ^0.8.0;
799 
800 
801 /**
802  * @dev Required interface of an ERC721 compliant contract.
803  */
804 interface IERC721 is IERC165 {
805     /**
806      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
807      */
808     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
809 
810     /**
811      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
812      */
813     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
814 
815     /**
816      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
817      */
818     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
819 
820     /**
821      * @dev Returns the number of tokens in ``owner``'s account.
822      */
823     function balanceOf(address owner) external view returns (uint256 balance);
824 
825     /**
826      * @dev Returns the owner of the `tokenId` token.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      */
832     function ownerOf(uint256 tokenId) external view returns (address owner);
833 
834     /**
835      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
836      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
837      *
838      * Requirements:
839      *
840      * - `from` cannot be the zero address.
841      * - `to` cannot be the zero address.
842      * - `tokenId` token must exist and be owned by `from`.
843      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
844      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
845      *
846      * Emits a {Transfer} event.
847      */
848     function safeTransferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) external;
853 
854     /**
855      * @dev Transfers `tokenId` token from `from` to `to`.
856      *
857      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
858      *
859      * Requirements:
860      *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must be owned by `from`.
864      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
865      *
866      * Emits a {Transfer} event.
867      */
868     function transferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) external;
873 
874     /**
875      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
876      * The approval is cleared when the token is transferred.
877      *
878      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
879      *
880      * Requirements:
881      *
882      * - The caller must own the token or be an approved operator.
883      * - `tokenId` must exist.
884      *
885      * Emits an {Approval} event.
886      */
887     function approve(address to, uint256 tokenId) external;
888 
889     /**
890      * @dev Returns the account approved for `tokenId` token.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must exist.
895      */
896     function getApproved(uint256 tokenId) external view returns (address operator);
897 
898     /**
899      * @dev Approve or remove `operator` as an operator for the caller.
900      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
901      *
902      * Requirements:
903      *
904      * - The `operator` cannot be the caller.
905      *
906      * Emits an {ApprovalForAll} event.
907      */
908     function setApprovalForAll(address operator, bool _approved) external;
909 
910     /**
911      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
912      *
913      * See {setApprovalForAll}
914      */
915     function isApprovedForAll(address owner, address operator) external view returns (bool);
916 
917     /**
918      * @dev Safely transfers `tokenId` token from `from` to `to`.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must exist and be owned by `from`.
925      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
926      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
927      *
928      * Emits a {Transfer} event.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId,
934         bytes calldata data
935     ) external;
936 }
937 
938 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
939 
940 
941 
942 pragma solidity ^0.8.0;
943 
944 
945 /**
946  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
947  * @dev See https://eips.ethereum.org/EIPS/eip-721
948  */
949 interface IERC721Enumerable is IERC721 {
950     /**
951      * @dev Returns the total amount of tokens stored by the contract.
952      */
953     function totalSupply() external view returns (uint256);
954 
955     /**
956      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
957      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
958      */
959     //function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
960 
961     /**
962      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
963      * Use along with {totalSupply} to enumerate all tokens.
964      */
965     function tokenByIndex(uint256 index) external view returns (uint256);
966 }
967 
968 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
969 
970 
971 
972 pragma solidity ^0.8.0;
973 
974 
975 /**
976  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
977  * @dev See https://eips.ethereum.org/EIPS/eip-721
978  */
979 interface IERC721Metadata is IERC721 {
980     /**
981      * @dev Returns the token collection name.
982      */
983     function name() external view returns (string memory);
984 
985     /**
986      * @dev Returns the token collection symbol.
987      */
988     function symbol() external view returns (string memory);
989 
990     /**
991      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
992      */
993     function tokenURI(uint256 tokenId) external view returns (string memory);
994 }
995 
996 // File: ERC721.sol
997 
998 
999 
1000 pragma solidity ^0.8.0;
1001 
1002 
1003 
1004 
1005 
1006 
1007 
1008 
1009 /**
1010  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1011  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1012  * {ERC721Enumerable}.
1013  */
1014 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1015     using Address for address;
1016     using Strings for uint256;
1017 
1018     // Token name
1019     string private _name;
1020 
1021     // Token symbol
1022     string private _symbol;
1023 
1024     // Mapping from token ID to owner address
1025     mapping(uint256 => address) private _owners;
1026 
1027     // Mapping owner address to token count
1028     mapping(address => uint256) private _balances;
1029 
1030     // Mapping from token ID to approved address
1031     mapping(uint256 => address) private _tokenApprovals;
1032 
1033     // Mapping from owner to operator approvals
1034     mapping(address => mapping(address => bool)) private _operatorApprovals;
1035 
1036     /**
1037      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1038      */
1039     constructor(string memory name_, string memory symbol_) {
1040         _name = name_;
1041         _symbol = symbol_;
1042     }
1043 
1044     /**
1045      * @dev See {IERC165-supportsInterface}.
1046      */
1047     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1048         return
1049         interfaceId == type(IERC721).interfaceId ||
1050         interfaceId == type(IERC721Metadata).interfaceId ||
1051         super.supportsInterface(interfaceId);
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-balanceOf}.
1056      */
1057     function balanceOf(address owner) public view virtual override returns (uint256) {
1058         require(owner != address(0), "ERC721: balance query for the zero address");
1059         return _balances[owner];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-ownerOf}.
1064      */
1065     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1066         address owner = _owners[tokenId];
1067         require(owner != address(0), "ERC721: owner query for nonexistent token");
1068         return owner;
1069     }
1070 
1071     /**
1072      * @dev Edit for rawOwnerOf token
1073      */
1074     function rawOwnerOf(uint256 tokenId) public view returns (address) {
1075         return _owners[tokenId];
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-name}.
1080      */
1081     function name() public view virtual override returns (string memory) {
1082         return _name;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-symbol}.
1087      */
1088     function symbol() public view virtual override returns (string memory) {
1089         return _symbol;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Metadata-tokenURI}.
1094      */
1095     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1096         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1097 
1098         string memory baseURI = _baseURI();
1099         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : "";
1100     }
1101 
1102     /**
1103      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1104      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1105      * by default, can be overriden in child contracts.
1106      */
1107     function _baseURI() internal view virtual returns (string memory) {
1108         return "";
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-approve}.
1113      */
1114     function approve(address to, uint256 tokenId) public virtual override {
1115         address owner = ERC721.ownerOf(tokenId);
1116         require(to != owner, "ERC721: approval to current owner");
1117 
1118         require(
1119             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1120             "ERC721: approve caller is not owner nor approved for all"
1121         );
1122 
1123         _approve(to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-getApproved}.
1128      */
1129     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1130         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1131 
1132         return _tokenApprovals[tokenId];
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-setApprovalForAll}.
1137      */
1138     function setApprovalForAll(address operator, bool approved) public virtual override {
1139         require(operator != _msgSender(), "ERC721: approve to caller");
1140 
1141         _operatorApprovals[_msgSender()][operator] = approved;
1142         emit ApprovalForAll(_msgSender(), operator, approved);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-isApprovedForAll}.
1147      */
1148     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1149         return _operatorApprovals[owner][operator];
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-transferFrom}.
1154      */
1155     function transferFrom(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) public virtual override {
1160         //solhint-disable-next-line max-line-length
1161         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1162 
1163         _transfer(from, to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-safeTransferFrom}.
1168      */
1169     function safeTransferFrom(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) public virtual override {
1174         safeTransferFrom(from, to, tokenId, "");
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-safeTransferFrom}.
1179      */
1180     function safeTransferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) public virtual override {
1186         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1187         _safeTransfer(from, to, tokenId, _data);
1188     }
1189 
1190     /**
1191      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1192      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1193      *
1194      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1195      *
1196      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1197      * implement alternative mechanisms to perform token transfer, such as signature-based.
1198      *
1199      * Requirements:
1200      *
1201      * - `from` cannot be the zero address.
1202      * - `to` cannot be the zero address.
1203      * - `tokenId` token must exist and be owned by `from`.
1204      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _safeTransfer(
1209         address from,
1210         address to,
1211         uint256 tokenId,
1212         bytes memory _data
1213     ) internal virtual {
1214         _transfer(from, to, tokenId);
1215         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1216     }
1217 
1218     /**
1219      * @dev Returns whether `tokenId` exists.
1220      *
1221      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1222      *
1223      * Tokens start existing when they are minted (`_mint`),
1224      * and stop existing when they are burned (`_burn`).
1225      */
1226     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1227         return _owners[tokenId] != address(0);
1228     }
1229 
1230     /**
1231      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1232      *
1233      * Requirements:
1234      *
1235      * - `tokenId` must exist.
1236      */
1237     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1238         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1239         address owner = ERC721.ownerOf(tokenId);
1240         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1241     }
1242 
1243     /**
1244      * Team QaziPolo
1245      * @dev Safely mints `tokenId` and transfers it to `to`.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must not exist.
1250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _safeMint(address to, uint256 tokenId) internal virtual {
1255         _safeMint(to, tokenId, "");
1256     }
1257 
1258     /**
1259      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1260      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1261      */
1262     function _safeMint(
1263         address to,
1264         uint256 tokenId,
1265         bytes memory _data
1266     ) internal virtual {
1267         _mint(to, tokenId);
1268         require(
1269             _checkOnERC721Received(address(0), to, tokenId, _data),
1270             "ERC721: transfer to non ERC721Receiver implementer"
1271         );
1272     }
1273 
1274     /**
1275      * @dev Mints `tokenId` and transfers it to `to`.
1276      *
1277      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1278      *
1279      * Requirements:
1280      *
1281      * - `tokenId` must not exist.
1282      * - `to` cannot be the zero address.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function _mint(address to, uint256 tokenId) internal virtual {
1287         require(to != address(0), "ERC721: mint to the zero address");
1288         require(!_exists(tokenId), "ERC721: token already minted");
1289 
1290         _beforeTokenTransfer(address(0), to, tokenId);
1291 
1292         _balances[to] += 1;
1293         _owners[tokenId] = to;
1294 
1295         emit Transfer(address(0), to, tokenId);
1296     }
1297 
1298     /**
1299      * @dev Destroys `tokenId`.
1300      * The approval is cleared when the token is burned.
1301      *
1302      * Requirements:
1303      *
1304      * - `tokenId` must exist.
1305      *
1306      * Emits a {Transfer} event.
1307      */
1308     function _burn(uint256 tokenId) internal virtual {
1309         address owner = ERC721.ownerOf(tokenId);
1310         address to = address(0);
1311 
1312         _beforeTokenTransfer(owner, to, tokenId);
1313 
1314         // Clear approvals
1315         _approve(address(0), tokenId);
1316 
1317         _balances[owner] -= 1;
1318         delete _owners[tokenId];
1319 
1320         emit Transfer(owner, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev Transfers `tokenId` from `from` to `to`.
1325      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1326      *
1327      * Requirements:
1328      *
1329      * - `to` cannot be the zero address.
1330      * - `tokenId` token must be owned by `from`.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function _transfer(
1335         address from,
1336         address to,
1337         uint256 tokenId
1338     ) internal virtual {
1339         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1340         require(to != address(0), "ERC721: transfer to the zero address");
1341 
1342         _beforeTokenTransfer(from, to, tokenId);
1343 
1344         // Clear approvals from the previous owner
1345         _approve(address(0), tokenId);
1346 
1347         _balances[from] -= 1;
1348         _balances[to] += 1;
1349         _owners[tokenId] = to;
1350 
1351         emit Transfer(from, to, tokenId);
1352     }
1353 
1354     /**
1355      * @dev Approve `to` to operate on `tokenId`
1356      *
1357      * Emits a {Approval} event.
1358      */
1359     function _approve(address to, uint256 tokenId) internal virtual {
1360         _tokenApprovals[tokenId] = to;
1361         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1362     }
1363 
1364     /**
1365      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1366      * The call is not executed if the target address is not a contract.
1367      *
1368      * @param from address representing the previous owner of the given token ID
1369      * @param to target address that will receive the tokens
1370      * @param tokenId uint256 ID of the token to be transferred
1371      * @param _data bytes optional data to send along with the call
1372      * @return bool whether the call correctly returned the expected magic value
1373      */
1374     function _checkOnERC721Received(
1375         address from,
1376         address to,
1377         uint256 tokenId,
1378         bytes memory _data
1379     ) private returns (bool) {
1380         if (to.isContract()) {
1381             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1382                 return retval == IERC721Receiver(to).onERC721Received.selector;
1383             } catch (bytes memory reason) {
1384                 if (reason.length == 0) {
1385                     revert("ERC721: transfer to non ERC721Receiver implementer");
1386                 } else {
1387                     assembly {
1388                         revert(add(32, reason), mload(reason))
1389                     }
1390                 }
1391             }
1392         } else {
1393             return true;
1394         }
1395     }
1396 
1397     /**
1398      * @dev Hook that is called before any token transfer. This includes minting
1399      * and burning.
1400      *
1401      * Calling conditions:
1402      *
1403      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1404      * transferred to `to`.
1405      * - When `from` is zero, `tokenId` will be minted for `to`.
1406      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1407      * - `from` and `to` are never both zero.
1408      *
1409      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1410      */
1411     function _beforeTokenTransfer(
1412         address from,
1413         address to,
1414         uint256 tokenId
1415     ) internal virtual {}
1416 }
1417 // File: ERC721Enumerable.sol
1418 
1419 
1420 
1421 pragma solidity ^0.8.0;
1422 
1423 
1424 /**
1425  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1426  * enumerability of all the token ids in the contract as well as all token ids owned by each
1427  * account.
1428  */
1429 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1430     // Mapping from owner to list of owned token IDs
1431     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1432 
1433     // Mapping from token ID to index of the owner tokens list
1434     mapping(uint256 => uint256) private _ownedTokensIndex;
1435 
1436     // Array with all token ids, used for enumeration
1437     uint256[] private _allTokens;
1438 
1439     // Mapping from token id to position in the allTokens array
1440     mapping(uint256 => uint256) private _allTokensIndex;
1441 
1442     /**
1443      * @dev See {IERC165-supportsInterface}.
1444      */
1445     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1446         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1451      */
1452     //function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1453     //    require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1454     //    return _ownedTokens[owner][index];
1455     //}
1456 
1457     /**
1458      * @dev See {IERC721Enumerable-totalSupply}.
1459      */
1460     function totalSupply() public view virtual override returns (uint256) {
1461         return _allTokens.length;
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Enumerable-tokenByIndex}.
1466      */
1467     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1468         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1469         return _allTokens[index];
1470     }
1471 
1472     /**
1473      * @dev Hook that is called before any token transfer. This includes minting
1474      * and burning.
1475      *
1476      * Calling conditions:
1477      *
1478      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1479      * transferred to `to`.
1480      * - When `from` is zero, `tokenId` will be minted for `to`.
1481      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1482      * - `from` cannot be the zero address.
1483      * - `to` cannot be the zero address.
1484      *
1485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1486      */
1487     function _beforeTokenTransfer(
1488         address from,
1489         address to,
1490         uint256 tokenId
1491     ) internal virtual override {
1492         super._beforeTokenTransfer(from, to, tokenId);
1493 
1494         if (from == address(0)) {
1495             _addTokenToAllTokensEnumeration(tokenId);
1496         } else if (from != to) {
1497             _removeTokenFromOwnerEnumeration(from, tokenId);
1498         }
1499         if (to == address(0)) {
1500             _removeTokenFromAllTokensEnumeration(tokenId);
1501         } else if (to != from) {
1502             _addTokenToOwnerEnumeration(to, tokenId);
1503         }
1504     }
1505 
1506     /**
1507      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1508      * @param to address representing the new owner of the given token ID
1509      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1510      */
1511     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1512         uint256 length = ERC721.balanceOf(to);
1513         _ownedTokens[to][length] = tokenId;
1514         _ownedTokensIndex[tokenId] = length;
1515     }
1516 
1517     /**
1518      * @dev Private function to add a token to this extension's token tracking data structures.
1519      * @param tokenId uint256 ID of the token to be added to the tokens list
1520      */
1521     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1522         _allTokensIndex[tokenId] = _allTokens.length;
1523         _allTokens.push(tokenId);
1524     }
1525 
1526     /**
1527      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1528      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1529      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1530      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1531      * @param from address representing the previous owner of the given token ID
1532      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1533      */
1534     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1535         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1536         // then delete the last slot (swap and pop).
1537 
1538         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1539         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1540 
1541         // When the token to delete is the last token, the swap operation is unnecessary
1542         if (tokenIndex != lastTokenIndex) {
1543             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1544 
1545             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1546             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1547         }
1548 
1549         // This also deletes the contents at the last position of the array
1550         delete _ownedTokensIndex[tokenId];
1551         delete _ownedTokens[from][lastTokenIndex];
1552     }
1553 
1554     /**
1555      * @dev Private function to remove a token from this extension's token tracking data structures.
1556      * This has O(1) time complexity, but alters the order of the _allTokens array.
1557      * @param tokenId uint256 ID of the token to be removed from the tokens list
1558      */
1559     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1560         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1561         // then delete the last slot (swap and pop).
1562 
1563         uint256 lastTokenIndex = _allTokens.length - 1;
1564         uint256 tokenIndex = _allTokensIndex[tokenId];
1565 
1566         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1567         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1568         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1569         uint256 lastTokenId = _allTokens[lastTokenIndex];
1570 
1571         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1572         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1573 
1574         // This also deletes the contents at the last position of the array
1575         delete _allTokensIndex[tokenId];
1576         _allTokens.pop();
1577     }
1578 }
1579 
1580 pragma solidity ^0.8.0;
1581 pragma abicoder v2;
1582 
1583 contract LLH is ERC721Enumerable, Ownable {
1584 
1585     using SafeMath for uint256;
1586 
1587     address private owner_;
1588     uint256 private tokenId;
1589     bytes32 public merkleRoot;
1590 	  bytes32 public merkleRootVIP;
1591 	  address private wallet1 = 0x2E06835f0EF53dc8F854B16a353B2718E571DC06;
1592     address private Authorized = 0x7a29d9a21A45E269F1bFFFa15a84c16BA0050E27;
1593 
1594 
1595     uint256 public LLHPrice_whitelist = 55500000000000000;
1596 	  uint256 public LLHPrice_public = 55500000000000000;
1597     uint public maxLLHTx = 20;
1598 	  uint public maxLLHPurchase = 20;
1599     uint public maxLLHPurchaseWl = 20;
1600     uint public maxLLHPurchaseVip = 20;
1601 
1602     uint256 public constant MAX_LLH = 10000;
1603     uint public LLHReserve = 200;
1604 	  uint public LLHWhitelistReserve = 50;
1605 
1606 
1607     bool public whitelistSaleIsActive = false;
1608 	  bool public publicSaleIsActive = false;
1609     mapping(address => uint) private max_mints_per_address;
1610 
1611 
1612 
1613 
1614 
1615     string public baseTokenURI;
1616 
1617     constructor() ERC721("Lazy Longhorns", "LLH") { }
1618 
1619     modifier onlyAuthorized {
1620         require(_msgSender() == owner() || _msgSender() == Authorized , "Not authorized");
1621         _;
1622     }
1623 
1624     function withdraw() public onlyOwner {
1625         uint balance = address(this).balance;
1626         payable(msg.sender).transfer(balance);
1627     }
1628 
1629     function reserveLLH(address _to, uint256 _reserveAmount) public onlyAuthorized {
1630         uint supply = totalSupply();
1631         require(_reserveAmount > 0 && _reserveAmount <= LLHReserve, "Not enough reserve");
1632         for (uint i = 0; i < _reserveAmount; i++) {
1633             _safeMint(_to, supply + i + 1);
1634         }
1635         LLHReserve = LLHReserve.sub(_reserveAmount);
1636     }
1637 
1638 
1639     function _baseURI() internal view virtual override returns (string memory) {
1640         return baseTokenURI;
1641     }
1642 
1643     function setBaseURI(string memory baseURI) public onlyAuthorized {
1644         baseTokenURI = baseURI;
1645     }
1646 
1647 
1648     function flipPublicSaleState() public onlyAuthorized {
1649         publicSaleIsActive = !publicSaleIsActive;
1650     }
1651 
1652 	 function flipWPSaleState() public onlyAuthorized {
1653         whitelistSaleIsActive = !whitelistSaleIsActive;
1654     }
1655 
1656 
1657      function mintLLH(uint numberOfTokens) public payable {
1658         require(publicSaleIsActive, "Sale not active");
1659         require(numberOfTokens > 0 && numberOfTokens <= maxLLHTx, "1 pTX allowed");
1660         require(msg.value == LLHPrice_public.mul(numberOfTokens), "Check ETH");
1661         require(max_mints_per_address[msg.sender].add(numberOfTokens) <= maxLLHPurchase,"Max pW reached");
1662 
1663         for(uint i = 0; i < numberOfTokens; i++) {
1664             if (totalSupply() < MAX_LLH) {
1665                 _safeMint(msg.sender, totalSupply()+1);
1666                 max_mints_per_address[msg.sender] = max_mints_per_address[msg.sender].add(1);
1667             } else {
1668                publicSaleIsActive = !publicSaleIsActive;
1669                 payable(msg.sender).transfer(numberOfTokens.sub(i).mul(LLHPrice_public));
1670                 break;
1671             }
1672         }
1673     }
1674 
1675 
1676    // to set the merkle root
1677     function updateMerkleRoot(bytes32 newmerkleRoot) external onlyAuthorized {
1678         merkleRoot = newmerkleRoot;
1679 
1680     }
1681 
1682 	// to set the merkle root for VIP
1683     function updateMerkleRootVIP(bytes32 newmerkleRoot) external onlyAuthorized {
1684         merkleRootVIP = newmerkleRoot;
1685 
1686     }
1687 
1688 
1689     function whitelistedMints(uint numberOfTokens, bytes32[] calldata merkleProof ) payable external  {
1690         address user_ = msg.sender;
1691 		require(whitelistSaleIsActive, "WL sale not active");
1692         require(numberOfTokens > 0 && numberOfTokens <= 1, "1 pTX allowed");
1693         require(msg.value == LLHPrice_whitelist.mul(numberOfTokens), "Check ETH");
1694         require(max_mints_per_address[msg.sender].add(numberOfTokens) <= maxLLHPurchaseWl,"Max pW reached");
1695 
1696         // Verify the merkle proof
1697         require(MerkleProof.verify(merkleProof, merkleRoot,  keccak256(abi.encodePacked(user_))  ), "Check proof");
1698 
1699 
1700              if (totalSupply() <= LLHWhitelistReserve) {
1701                 _safeMint(msg.sender, totalSupply()+1);
1702                 max_mints_per_address[msg.sender] = max_mints_per_address[msg.sender].add(1);
1703             }
1704 		     else {
1705                 whitelistSaleIsActive = !whitelistSaleIsActive;
1706             }
1707 
1708 
1709 
1710     }
1711 
1712 	function whitelistedVIPMints(uint numberOfTokens, bytes32[] calldata merkleProof ) payable external  {
1713         address user_ = msg.sender;
1714 		require(whitelistSaleIsActive, "WL sale not active");
1715         require(numberOfTokens > 0 && numberOfTokens <= 2, "2 pTX allowed");
1716         require(msg.value == LLHPrice_whitelist.mul(numberOfTokens), "Check ETH");
1717         require(max_mints_per_address[msg.sender].add(numberOfTokens) <= maxLLHPurchaseVip,"Max pW reached");
1718 
1719         // Verify the merkle proof
1720         require(MerkleProof.verify(merkleProof, merkleRootVIP,  keccak256(abi.encodePacked(user_))  ), "Check proof");
1721 
1722 		for(uint i = 0; i < numberOfTokens; i++) {
1723             if (totalSupply() <= LLHWhitelistReserve) {
1724                 _safeMint(msg.sender, totalSupply()+1);
1725                 max_mints_per_address[msg.sender] = max_mints_per_address[msg.sender].add(1);
1726             }
1727 			else {
1728                whitelistSaleIsActive = !whitelistSaleIsActive;
1729                 payable(msg.sender).transfer(numberOfTokens.sub(i).mul(LLHPrice_whitelist));
1730                 break;
1731             }
1732 		}
1733 
1734 
1735 
1736     }
1737 
1738     function withdrawAll() external onlyOwner {
1739         require(address(this).balance > 0, "No balance");
1740         uint256 _amount = address(this).balance;
1741         (bool wallet1Success, ) = wallet1.call{value: _amount.mul(100).div(100)}("");
1742 
1743         require(wallet1Success, "Withdrawal failed.");
1744     }
1745 
1746     function setPriceWL(uint256 newPriceWL) public onlyAuthorized {
1747         LLHPrice_whitelist = newPriceWL;
1748     }
1749 
1750     function setPrice(uint256 newPrice) public onlyAuthorized {
1751         LLHPrice_public = newPrice;
1752     }
1753 
1754    function setMaxLLHTx(uint256 newMaxLLHTx) public onlyAuthorized {
1755         maxLLHTx = newMaxLLHTx;
1756     }
1757 
1758    function setMaxLLHPurchase(uint256 newMaxLLHPurchase) public onlyAuthorized {
1759         maxLLHPurchase = newMaxLLHPurchase;
1760     }
1761 
1762   function setMaxLLHPurchaseWl(uint256 newMaxLLHPurchaseWl) public onlyAuthorized {
1763             maxLLHPurchaseWl = newMaxLLHPurchaseWl;
1764         }
1765 
1766   function setMaxLLHPurchaseVip(uint256 newMaxLLHPurchaseVip) public onlyAuthorized {
1767                     maxLLHPurchaseVip = newMaxLLHPurchaseVip;
1768                 }
1769 
1770 }