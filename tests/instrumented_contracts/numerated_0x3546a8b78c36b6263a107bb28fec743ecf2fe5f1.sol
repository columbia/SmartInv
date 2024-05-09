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
56 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
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
286 // File: @openzeppelin/contracts/utils/Counters.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @title Counters
295  * @author Matt Condon (@shrugs)
296  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
297  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
298  *
299  * Include with `using Counters for Counters.Counter;`
300  */
301 library Counters {
302     struct Counter {
303         // This variable should never be directly accessed by users of the library: interactions must be restricted to
304         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
305         // this feature: see https://github.com/ethereum/solidity/issues/4637
306         uint256 _value; // default: 0
307     }
308 
309     function current(Counter storage counter) internal view returns (uint256) {
310         return counter._value;
311     }
312 
313     function increment(Counter storage counter) internal {
314         unchecked {
315             counter._value += 1;
316         }
317     }
318 
319     function decrement(Counter storage counter) internal {
320         uint256 value = counter._value;
321         require(value > 0, "Counter: decrement overflow");
322         unchecked {
323             counter._value = value - 1;
324         }
325     }
326 
327     function reset(Counter storage counter) internal {
328         counter._value = 0;
329     }
330 }
331 
332 // File: @openzeppelin/contracts/utils/Strings.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev String operations.
341  */
342 library Strings {
343     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
344 
345     /**
346      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
347      */
348     function toString(uint256 value) internal pure returns (string memory) {
349         // Inspired by OraclizeAPI's implementation - MIT licence
350         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
351 
352         if (value == 0) {
353             return "0";
354         }
355         uint256 temp = value;
356         uint256 digits;
357         while (temp != 0) {
358             digits++;
359             temp /= 10;
360         }
361         bytes memory buffer = new bytes(digits);
362         while (value != 0) {
363             digits -= 1;
364             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
365             value /= 10;
366         }
367         return string(buffer);
368     }
369 
370     /**
371      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
372      */
373     function toHexString(uint256 value) internal pure returns (string memory) {
374         if (value == 0) {
375             return "0x00";
376         }
377         uint256 temp = value;
378         uint256 length = 0;
379         while (temp != 0) {
380             length++;
381             temp >>= 8;
382         }
383         return toHexString(value, length);
384     }
385 
386     /**
387      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
388      */
389     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
390         bytes memory buffer = new bytes(2 * length + 2);
391         buffer[0] = "0";
392         buffer[1] = "x";
393         for (uint256 i = 2 * length + 1; i > 1; --i) {
394             buffer[i] = _HEX_SYMBOLS[value & 0xf];
395             value >>= 4;
396         }
397         require(value == 0, "Strings: hex length insufficient");
398         return string(buffer);
399     }
400 }
401 
402 // File: @openzeppelin/contracts/utils/Context.sol
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Provides information about the current execution context, including the
411  * sender of the transaction and its data. While these are generally available
412  * via msg.sender and msg.data, they should not be accessed in such a direct
413  * manner, since when dealing with meta-transactions the account sending and
414  * paying for execution may not be the actual sender (as far as an application
415  * is concerned).
416  *
417  * This contract is only required for intermediate, library-like contracts.
418  */
419 abstract contract Context {
420     function _msgSender() internal view virtual returns (address) {
421         return msg.sender;
422     }
423 
424     function _msgData() internal view virtual returns (bytes calldata) {
425         return msg.data;
426     }
427 }
428 
429 // File: @openzeppelin/contracts/access/Ownable.sol
430 
431 
432 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 
437 /**
438  * @dev Contract module which provides a basic access control mechanism, where
439  * there is an account (an owner) that can be granted exclusive access to
440  * specific functions.
441  *
442  * By default, the owner account will be the one that deploys the contract. This
443  * can later be changed with {transferOwnership}.
444  *
445  * This module is used through inheritance. It will make available the modifier
446  * `onlyOwner`, which can be applied to your functions to restrict their use to
447  * the owner.
448  */
449 abstract contract Ownable is Context {
450     address private _owner;
451 
452     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
453 
454     /**
455      * @dev Initializes the contract setting the deployer as the initial owner.
456      */
457     constructor() {
458         _transferOwnership(_msgSender());
459     }
460 
461     /**
462      * @dev Returns the address of the current owner.
463      */
464     function owner() public view virtual returns (address) {
465         return _owner;
466     }
467 
468     /**
469      * @dev Throws if called by any account other than the owner.
470      */
471     modifier onlyOwner() {
472         require(owner() == _msgSender(), "Ownable: caller is not the owner");
473         _;
474     }
475 
476     /**
477      * @dev Leaves the contract without owner. It will not be possible to call
478      * `onlyOwner` functions anymore. Can only be called by the current owner.
479      *
480      * NOTE: Renouncing ownership will leave the contract without an owner,
481      * thereby removing any functionality that is only available to the owner.
482      */
483     function renounceOwnership() public virtual onlyOwner {
484         _transferOwnership(address(0));
485     }
486 
487     /**
488      * @dev Transfers ownership of the contract to a new account (`newOwner`).
489      * Can only be called by the current owner.
490      */
491     function transferOwnership(address newOwner) public virtual onlyOwner {
492         require(newOwner != address(0), "Ownable: new owner is the zero address");
493         _transferOwnership(newOwner);
494     }
495 
496     /**
497      * @dev Transfers ownership of the contract to a new account (`newOwner`).
498      * Internal function without access restriction.
499      */
500     function _transferOwnership(address newOwner) internal virtual {
501         address oldOwner = _owner;
502         _owner = newOwner;
503         emit OwnershipTransferred(oldOwner, newOwner);
504     }
505 }
506 
507 // File: @openzeppelin/contracts/utils/Address.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Collection of functions related to the address type
516  */
517 library Address {
518     /**
519      * @dev Returns true if `account` is a contract.
520      *
521      * [IMPORTANT]
522      * ====
523      * It is unsafe to assume that an address for which this function returns
524      * false is an externally-owned account (EOA) and not a contract.
525      *
526      * Among others, `isContract` will return false for the following
527      * types of addresses:
528      *
529      *  - an externally-owned account
530      *  - a contract in construction
531      *  - an address where a contract will be created
532      *  - an address where a contract lived, but was destroyed
533      * ====
534      */
535     function isContract(address account) internal view returns (bool) {
536         // This method relies on extcodesize, which returns 0 for contracts in
537         // construction, since the code is only stored at the end of the
538         // constructor execution.
539 
540         uint256 size;
541         assembly {
542             size := extcodesize(account)
543         }
544         return size > 0;
545     }
546 
547     /**
548      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
549      * `recipient`, forwarding all available gas and reverting on errors.
550      *
551      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
552      * of certain opcodes, possibly making contracts go over the 2300 gas limit
553      * imposed by `transfer`, making them unable to receive funds via
554      * `transfer`. {sendValue} removes this limitation.
555      *
556      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
557      *
558      * IMPORTANT: because control is transferred to `recipient`, care must be
559      * taken to not create reentrancy vulnerabilities. Consider using
560      * {ReentrancyGuard} or the
561      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
562      */
563     function sendValue(address payable recipient, uint256 amount) internal {
564         require(address(this).balance >= amount, "Address: insufficient balance");
565 
566         (bool success, ) = recipient.call{value: amount}("");
567         require(success, "Address: unable to send value, recipient may have reverted");
568     }
569 
570     /**
571      * @dev Performs a Solidity function call using a low level `call`. A
572      * plain `call` is an unsafe replacement for a function call: use this
573      * function instead.
574      *
575      * If `target` reverts with a revert reason, it is bubbled up by this
576      * function (like regular Solidity function calls).
577      *
578      * Returns the raw returned data. To convert to the expected return value,
579      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
580      *
581      * Requirements:
582      *
583      * - `target` must be a contract.
584      * - calling `target` with `data` must not revert.
585      *
586      * _Available since v3.1._
587      */
588     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
589         return functionCall(target, data, "Address: low-level call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
594      * `errorMessage` as a fallback revert reason when `target` reverts.
595      *
596      * _Available since v3.1._
597      */
598     function functionCall(
599         address target,
600         bytes memory data,
601         string memory errorMessage
602     ) internal returns (bytes memory) {
603         return functionCallWithValue(target, data, 0, errorMessage);
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
608      * but also transferring `value` wei to `target`.
609      *
610      * Requirements:
611      *
612      * - the calling contract must have an ETH balance of at least `value`.
613      * - the called Solidity function must be `payable`.
614      *
615      * _Available since v3.1._
616      */
617     function functionCallWithValue(
618         address target,
619         bytes memory data,
620         uint256 value
621     ) internal returns (bytes memory) {
622         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
627      * with `errorMessage` as a fallback revert reason when `target` reverts.
628      *
629      * _Available since v3.1._
630      */
631     function functionCallWithValue(
632         address target,
633         bytes memory data,
634         uint256 value,
635         string memory errorMessage
636     ) internal returns (bytes memory) {
637         require(address(this).balance >= value, "Address: insufficient balance for call");
638         require(isContract(target), "Address: call to non-contract");
639 
640         (bool success, bytes memory returndata) = target.call{value: value}(data);
641         return verifyCallResult(success, returndata, errorMessage);
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
646      * but performing a static call.
647      *
648      * _Available since v3.3._
649      */
650     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
651         return functionStaticCall(target, data, "Address: low-level static call failed");
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
656      * but performing a static call.
657      *
658      * _Available since v3.3._
659      */
660     function functionStaticCall(
661         address target,
662         bytes memory data,
663         string memory errorMessage
664     ) internal view returns (bytes memory) {
665         require(isContract(target), "Address: static call to non-contract");
666 
667         (bool success, bytes memory returndata) = target.staticcall(data);
668         return verifyCallResult(success, returndata, errorMessage);
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
673      * but performing a delegate call.
674      *
675      * _Available since v3.4._
676      */
677     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
678         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
683      * but performing a delegate call.
684      *
685      * _Available since v3.4._
686      */
687     function functionDelegateCall(
688         address target,
689         bytes memory data,
690         string memory errorMessage
691     ) internal returns (bytes memory) {
692         require(isContract(target), "Address: delegate call to non-contract");
693 
694         (bool success, bytes memory returndata) = target.delegatecall(data);
695         return verifyCallResult(success, returndata, errorMessage);
696     }
697 
698     /**
699      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
700      * revert reason using the provided one.
701      *
702      * _Available since v4.3._
703      */
704     function verifyCallResult(
705         bool success,
706         bytes memory returndata,
707         string memory errorMessage
708     ) internal pure returns (bytes memory) {
709         if (success) {
710             return returndata;
711         } else {
712             // Look for revert reason and bubble it up if present
713             if (returndata.length > 0) {
714                 // The easiest way to bubble the revert reason is using memory via assembly
715 
716                 assembly {
717                     let returndata_size := mload(returndata)
718                     revert(add(32, returndata), returndata_size)
719                 }
720             } else {
721                 revert(errorMessage);
722             }
723         }
724     }
725 }
726 
727 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @title ERC721 token receiver interface
736  * @dev Interface for any contract that wants to support safeTransfers
737  * from ERC721 asset contracts.
738  */
739 interface IERC721Receiver {
740     /**
741      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
742      * by `operator` from `from`, this function is called.
743      *
744      * It must return its Solidity selector to confirm the token transfer.
745      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
746      *
747      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
748      */
749     function onERC721Received(
750         address operator,
751         address from,
752         uint256 tokenId,
753         bytes calldata data
754     ) external returns (bytes4);
755 }
756 
757 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
758 
759 
760 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 /**
765  * @dev Interface of the ERC165 standard, as defined in the
766  * https://eips.ethereum.org/EIPS/eip-165[EIP].
767  *
768  * Implementers can declare support of contract interfaces, which can then be
769  * queried by others ({ERC165Checker}).
770  *
771  * For an implementation, see {ERC165}.
772  */
773 interface IERC165 {
774     /**
775      * @dev Returns true if this contract implements the interface defined by
776      * `interfaceId`. See the corresponding
777      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
778      * to learn more about how these ids are created.
779      *
780      * This function call must use less than 30 000 gas.
781      */
782     function supportsInterface(bytes4 interfaceId) external view returns (bool);
783 }
784 
785 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
786 
787 
788 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 /**
794  * @dev Implementation of the {IERC165} interface.
795  *
796  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
797  * for the additional interface id that will be supported. For example:
798  *
799  * ```solidity
800  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
801  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
802  * }
803  * ```
804  *
805  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
806  */
807 abstract contract ERC165 is IERC165 {
808     /**
809      * @dev See {IERC165-supportsInterface}.
810      */
811     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
812         return interfaceId == type(IERC165).interfaceId;
813     }
814 }
815 
816 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
817 
818 
819 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
820 
821 pragma solidity ^0.8.0;
822 
823 
824 /**
825  * @dev Required interface of an ERC721 compliant contract.
826  */
827 interface IERC721 is IERC165 {
828     /**
829      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
830      */
831     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
832 
833     /**
834      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
835      */
836     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
837 
838     /**
839      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
840      */
841     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
842 
843     /**
844      * @dev Returns the number of tokens in ``owner``'s account.
845      */
846     function balanceOf(address owner) external view returns (uint256 balance);
847 
848     /**
849      * @dev Returns the owner of the `tokenId` token.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function ownerOf(uint256 tokenId) external view returns (address owner);
856 
857     /**
858      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
859      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
860      *
861      * Requirements:
862      *
863      * - `from` cannot be the zero address.
864      * - `to` cannot be the zero address.
865      * - `tokenId` token must exist and be owned by `from`.
866      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
867      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
868      *
869      * Emits a {Transfer} event.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId
875     ) external;
876 
877     /**
878      * @dev Transfers `tokenId` token from `from` to `to`.
879      *
880      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
881      *
882      * Requirements:
883      *
884      * - `from` cannot be the zero address.
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must be owned by `from`.
887      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
888      *
889      * Emits a {Transfer} event.
890      */
891     function transferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) external;
896 
897     /**
898      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
899      * The approval is cleared when the token is transferred.
900      *
901      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
902      *
903      * Requirements:
904      *
905      * - The caller must own the token or be an approved operator.
906      * - `tokenId` must exist.
907      *
908      * Emits an {Approval} event.
909      */
910     function approve(address to, uint256 tokenId) external;
911 
912     /**
913      * @dev Returns the account approved for `tokenId` token.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must exist.
918      */
919     function getApproved(uint256 tokenId) external view returns (address operator);
920 
921     /**
922      * @dev Approve or remove `operator` as an operator for the caller.
923      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
924      *
925      * Requirements:
926      *
927      * - The `operator` cannot be the caller.
928      *
929      * Emits an {ApprovalForAll} event.
930      */
931     function setApprovalForAll(address operator, bool _approved) external;
932 
933     /**
934      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
935      *
936      * See {setApprovalForAll}
937      */
938     function isApprovedForAll(address owner, address operator) external view returns (bool);
939 
940     /**
941      * @dev Safely transfers `tokenId` token from `from` to `to`.
942      *
943      * Requirements:
944      *
945      * - `from` cannot be the zero address.
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must exist and be owned by `from`.
948      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
950      *
951      * Emits a {Transfer} event.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes calldata data
958     ) external;
959 }
960 
961 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
962 
963 
964 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
965 
966 pragma solidity ^0.8.0;
967 
968 
969 /**
970  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
971  * @dev See https://eips.ethereum.org/EIPS/eip-721
972  */
973 interface IERC721Metadata is IERC721 {
974     /**
975      * @dev Returns the token collection name.
976      */
977     function name() external view returns (string memory);
978 
979     /**
980      * @dev Returns the token collection symbol.
981      */
982     function symbol() external view returns (string memory);
983 
984     /**
985      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
986      */
987     function tokenURI(uint256 tokenId) external view returns (string memory);
988 }
989 
990 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
991 
992 
993 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
994 
995 pragma solidity ^0.8.0;
996 
997 
998 
999 
1000 
1001 
1002 
1003 
1004 /**
1005  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1006  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1007  * {ERC721Enumerable}.
1008  */
1009 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1010     using Address for address;
1011     using Strings for uint256;
1012 
1013     // Token name
1014     string private _name;
1015 
1016     // Token symbol
1017     string private _symbol;
1018 
1019     // Mapping from token ID to owner address
1020     mapping(uint256 => address) private _owners;
1021 
1022     // Mapping owner address to token count
1023     mapping(address => uint256) private _balances;
1024 
1025     // Mapping from token ID to approved address
1026     mapping(uint256 => address) private _tokenApprovals;
1027 
1028     // Mapping from owner to operator approvals
1029     mapping(address => mapping(address => bool)) private _operatorApprovals;
1030 
1031     /**
1032      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1033      */
1034     constructor(string memory name_, string memory symbol_) {
1035         _name = name_;
1036         _symbol = symbol_;
1037     }
1038 
1039     /**
1040      * @dev See {IERC165-supportsInterface}.
1041      */
1042     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1043         return
1044             interfaceId == type(IERC721).interfaceId ||
1045             interfaceId == type(IERC721Metadata).interfaceId ||
1046             super.supportsInterface(interfaceId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-balanceOf}.
1051      */
1052     function balanceOf(address owner) public view virtual override returns (uint256) {
1053         require(owner != address(0), "ERC721: balance query for the zero address");
1054         return _balances[owner];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-ownerOf}.
1059      */
1060     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1061         address owner = _owners[tokenId];
1062         require(owner != address(0), "ERC721: owner query for nonexistent token");
1063         return owner;
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Metadata-name}.
1068      */
1069     function name() public view virtual override returns (string memory) {
1070         return _name;
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Metadata-symbol}.
1075      */
1076     function symbol() public view virtual override returns (string memory) {
1077         return _symbol;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Metadata-tokenURI}.
1082      */
1083     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1084         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1085 
1086         string memory baseURI = _baseURI();
1087         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1088     }
1089 
1090     /**
1091      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1092      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1093      * by default, can be overriden in child contracts.
1094      */
1095     function _baseURI() internal view virtual returns (string memory) {
1096         return "";
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-approve}.
1101      */
1102     function approve(address to, uint256 tokenId) public virtual override {
1103         address owner = ERC721.ownerOf(tokenId);
1104         require(to != owner, "ERC721: approval to current owner");
1105 
1106         require(
1107             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1108             "ERC721: approve caller is not owner nor approved for all"
1109         );
1110 
1111         _approve(to, tokenId);
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-getApproved}.
1116      */
1117     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1118         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1119 
1120         return _tokenApprovals[tokenId];
1121     }
1122 
1123     /**
1124      * @dev See {IERC721-setApprovalForAll}.
1125      */
1126     function setApprovalForAll(address operator, bool approved) public virtual override {
1127         _setApprovalForAll(_msgSender(), operator, approved);
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-isApprovedForAll}.
1132      */
1133     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1134         return _operatorApprovals[owner][operator];
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-transferFrom}.
1139      */
1140     function transferFrom(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) public virtual override {
1145         //solhint-disable-next-line max-line-length
1146         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1147 
1148         _transfer(from, to, tokenId);
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-safeTransferFrom}.
1153      */
1154     function safeTransferFrom(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) public virtual override {
1159         safeTransferFrom(from, to, tokenId, "");
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-safeTransferFrom}.
1164      */
1165     function safeTransferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) public virtual override {
1171         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1172         _safeTransfer(from, to, tokenId, _data);
1173     }
1174 
1175     /**
1176      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1178      *
1179      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1180      *
1181      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1182      * implement alternative mechanisms to perform token transfer, such as signature-based.
1183      *
1184      * Requirements:
1185      *
1186      * - `from` cannot be the zero address.
1187      * - `to` cannot be the zero address.
1188      * - `tokenId` token must exist and be owned by `from`.
1189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function _safeTransfer(
1194         address from,
1195         address to,
1196         uint256 tokenId,
1197         bytes memory _data
1198     ) internal virtual {
1199         _transfer(from, to, tokenId);
1200         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1201     }
1202 
1203     /**
1204      * @dev Returns whether `tokenId` exists.
1205      *
1206      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1207      *
1208      * Tokens start existing when they are minted (`_mint`),
1209      * and stop existing when they are burned (`_burn`).
1210      */
1211     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1212         return _owners[tokenId] != address(0);
1213     }
1214 
1215     /**
1216      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must exist.
1221      */
1222     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1223         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1224         address owner = ERC721.ownerOf(tokenId);
1225         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1226     }
1227 
1228     /**
1229      * @dev Safely mints `tokenId` and transfers it to `to`.
1230      *
1231      * Requirements:
1232      *
1233      * - `tokenId` must not exist.
1234      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _safeMint(address to, uint256 tokenId) internal virtual {
1239         _safeMint(to, tokenId, "");
1240     }
1241 
1242     /**
1243      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1244      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1245      */
1246     function _safeMint(
1247         address to,
1248         uint256 tokenId,
1249         bytes memory _data
1250     ) internal virtual {
1251         _mint(to, tokenId);
1252         require(
1253             _checkOnERC721Received(address(0), to, tokenId, _data),
1254             "ERC721: transfer to non ERC721Receiver implementer"
1255         );
1256     }
1257 
1258     /**
1259      * @dev Mints `tokenId` and transfers it to `to`.
1260      *
1261      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1262      *
1263      * Requirements:
1264      *
1265      * - `tokenId` must not exist.
1266      * - `to` cannot be the zero address.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function _mint(address to, uint256 tokenId) internal virtual {
1271         require(to != address(0), "ERC721: mint to the zero address");
1272         require(!_exists(tokenId), "ERC721: token already minted");
1273 
1274         _beforeTokenTransfer(address(0), to, tokenId);
1275 
1276         _balances[to] += 1;
1277         _owners[tokenId] = to;
1278 
1279         emit Transfer(address(0), to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Destroys `tokenId`.
1284      * The approval is cleared when the token is burned.
1285      *
1286      * Requirements:
1287      *
1288      * - `tokenId` must exist.
1289      *
1290      * Emits a {Transfer} event.
1291      */
1292     function _burn(uint256 tokenId) internal virtual {
1293         address owner = ERC721.ownerOf(tokenId);
1294 
1295         _beforeTokenTransfer(owner, address(0), tokenId);
1296 
1297         // Clear approvals
1298         _approve(address(0), tokenId);
1299 
1300         _balances[owner] -= 1;
1301         delete _owners[tokenId];
1302 
1303         emit Transfer(owner, address(0), tokenId);
1304     }
1305 
1306     /**
1307      * @dev Transfers `tokenId` from `from` to `to`.
1308      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1309      *
1310      * Requirements:
1311      *
1312      * - `to` cannot be the zero address.
1313      * - `tokenId` token must be owned by `from`.
1314      *
1315      * Emits a {Transfer} event.
1316      */
1317     function _transfer(
1318         address from,
1319         address to,
1320         uint256 tokenId
1321     ) internal virtual {
1322         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1323         require(to != address(0), "ERC721: transfer to the zero address");
1324 
1325         _beforeTokenTransfer(from, to, tokenId);
1326 
1327         // Clear approvals from the previous owner
1328         _approve(address(0), tokenId);
1329 
1330         _balances[from] -= 1;
1331         _balances[to] += 1;
1332         _owners[tokenId] = to;
1333 
1334         emit Transfer(from, to, tokenId);
1335     }
1336 
1337     /**
1338      * @dev Approve `to` to operate on `tokenId`
1339      *
1340      * Emits a {Approval} event.
1341      */
1342     function _approve(address to, uint256 tokenId) internal virtual {
1343         _tokenApprovals[tokenId] = to;
1344         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1345     }
1346 
1347     /**
1348      * @dev Approve `operator` to operate on all of `owner` tokens
1349      *
1350      * Emits a {ApprovalForAll} event.
1351      */
1352     function _setApprovalForAll(
1353         address owner,
1354         address operator,
1355         bool approved
1356     ) internal virtual {
1357         require(owner != operator, "ERC721: approve to caller");
1358         _operatorApprovals[owner][operator] = approved;
1359         emit ApprovalForAll(owner, operator, approved);
1360     }
1361 
1362     /**
1363      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1364      * The call is not executed if the target address is not a contract.
1365      *
1366      * @param from address representing the previous owner of the given token ID
1367      * @param to target address that will receive the tokens
1368      * @param tokenId uint256 ID of the token to be transferred
1369      * @param _data bytes optional data to send along with the call
1370      * @return bool whether the call correctly returned the expected magic value
1371      */
1372     function _checkOnERC721Received(
1373         address from,
1374         address to,
1375         uint256 tokenId,
1376         bytes memory _data
1377     ) private returns (bool) {
1378         if (to.isContract()) {
1379             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1380                 return retval == IERC721Receiver.onERC721Received.selector;
1381             } catch (bytes memory reason) {
1382                 if (reason.length == 0) {
1383                     revert("ERC721: transfer to non ERC721Receiver implementer");
1384                 } else {
1385                     assembly {
1386                         revert(add(32, reason), mload(reason))
1387                     }
1388                 }
1389             }
1390         } else {
1391             return true;
1392         }
1393     }
1394 
1395     /**
1396      * @dev Hook that is called before any token transfer. This includes minting
1397      * and burning.
1398      *
1399      * Calling conditions:
1400      *
1401      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1402      * transferred to `to`.
1403      * - When `from` is zero, `tokenId` will be minted for `to`.
1404      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1405      * - `from` and `to` are never both zero.
1406      *
1407      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1408      */
1409     function _beforeTokenTransfer(
1410         address from,
1411         address to,
1412         uint256 tokenId
1413     ) internal virtual {}
1414 }
1415 
1416 // File: contracts/CC_Final_Contract.sol
1417 
1418 //SPDX-License-Identifier: UNLICENSED
1419 
1420 //====================================================================================================
1421 //============================     =====    =====      ===  =====  ====    ===========================
1422 //===========================  ===  ===  ==  ===  ====  ==   ===   ===  ==  ==========================
1423 //==========================  ========  ====  ==  ====  ==  =   =  ==  ====  =========================
1424 //==========================  ========  ====  ===  =======  == ==  ==  ====  =========================
1425 //==========================  ========  ====  =====  =====  =====  ==  ====  =========================
1426 //==========================  ========  ====  =======  ===  =====  ==  ====  =========================
1427 //==========================  ========  ====  ==  ====  ==  =====  ==  ====  =========================
1428 //===========================  ===  ===  ==  ===  ====  ==  =====  ===  ==  ==========================
1429 //============================     =====    =====      ===  =====  ====    ===========================
1430 //====================================================================================================
1431 //==================================================================================================== 
1432 //========     ===       ===        =====  =====        ==  ====  ==       ===        ===      ======= 
1433 //=======  ===  ==  ====  ==  ==========    =======  =====  ====  ==  ====  ==  ========  ====  ====== 
1434 //======  ========  ====  ==  =========  ==  ======  =====  ====  ==  ====  ==  ========  ====  ====== 
1435 //======  ========  ===   ==  ========  ====  =====  =====  ====  ==  ===   ==  =========  =========== 
1436 //======  ========      ====      ====  ====  =====  =====  ====  ==      ====      =======  ========= 
1437 //======  ========  ====  ==  ========        =====  =====  ====  ==  ====  ==  =============  ======= 
1438 //======  ========  ====  ==  ========  ====  =====  =====  ====  ==  ====  ==  ========  ====  ====== 
1439 //=======  ===  ==  ====  ==  ========  ====  =====  =====   ==   ==  ====  ==  ========  ====  ====== 
1440 //========     ===  ====  ==        ==  ====  =====  ======      ===  ====  ==        ===      ======= 
1441 //==================================================================================================== 
1442 pragma solidity >=0.7.0 <0.9.0;
1443 
1444 
1445 
1446 
1447 
1448 
1449 contract CosmoCreatures is ERC721, Ownable {
1450   using Counters for Counters.Counter;
1451   using SafeMath for uint256;
1452 
1453   Counters.Counter private supply;
1454   
1455   uint256 public cost = .1 ether;
1456   uint256 public maxSupplyPlusOne = 1000;
1457   uint256 public maxMintAmountPlusOne = 11;
1458   uint256 public presalemaxMintAmountPlusOne = 3;
1459 
1460   string public PROVENANCE;
1461   string private _baseURIextended;
1462 
1463   bool public saleIsActive;
1464   bool public presaleIsActive;
1465 
1466   // TODO: UPDATE
1467   address payable public immutable creatorAddress = payable(0xef2722dc49c30CAc62AdA0a8D7Bca1847c0DCaAC);
1468   address payable public immutable devAddress = payable(0x15C560d2D9Eb3AF98524aA73BeCBA43E9e6ceF02);
1469 
1470   mapping(address => uint256) public whitelistBalances;
1471 
1472   bytes32 public merkleRoot;
1473 
1474   constructor() ERC721("Cosmo Creatures", "CC") {
1475     _mintLoop(msg.sender, 35);
1476     saleIsActive = false;
1477     presaleIsActive = false;
1478   }
1479 
1480   modifier mintCompliance(uint256 _mintAmount) {
1481     require(_mintAmount > 0 && _mintAmount < maxMintAmountPlusOne, "Invalid mint amount!");
1482     require(supply.current() + _mintAmount < maxSupplyPlusOne, "Max supply exceeded!");
1483     require(msg.value >= cost * _mintAmount, "Not enough eth sent!");
1484     _;
1485   }
1486 
1487   function totalSupply() public view returns (uint256) {
1488     return supply.current();
1489   }
1490 
1491   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1492     // require(merkleRoot == bytes32(0), "Merkle root already set!");
1493     merkleRoot = _merkleRoot;
1494   }
1495 
1496   function whitelistMint(uint256 _mintAmount, bytes32[] calldata merkleProof) public payable mintCompliance(_mintAmount) {
1497     require (presaleIsActive, "Presale inactive");
1498     require(balanceOf(msg.sender) + _mintAmount < presalemaxMintAmountPlusOne, "Attempting to mint too many creatures for pre-sale");
1499     require(whitelistBalances[msg.sender] + _mintAmount < presalemaxMintAmountPlusOne, "Attempting to mint too many creatures for pre-sale (balance transferred out)");
1500 
1501     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1502     require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "You're not whitelisted for presale!");
1503     _mintLoop(msg.sender, _mintAmount);
1504     whitelistBalances[msg.sender] += _mintAmount;
1505   }
1506 
1507   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1508     require (saleIsActive, "Public sale inactive");
1509     _mintLoop(msg.sender, _mintAmount);
1510   }
1511 
1512   function setSale(bool newState) public onlyOwner {
1513     saleIsActive = newState;
1514   }
1515 
1516   function setPreSale(bool newState) public onlyOwner {
1517     presaleIsActive = newState;
1518   }
1519 
1520   function setProvenance(string memory provenance) public onlyOwner {
1521     PROVENANCE = provenance;
1522   }
1523 
1524   function setCost(uint256 _newCost) public onlyOwner {
1525     cost = _newCost;
1526   }
1527 
1528   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1529     for (uint256 i = 0; i < _mintAmount; i++) {
1530       supply.increment();
1531       _safeMint(_receiver, supply.current());
1532     }
1533   }
1534 
1535   function setBaseURI(string memory baseURI_) external onlyOwner() {
1536     _baseURIextended = baseURI_;
1537   }
1538 
1539   function _baseURI() internal view virtual override returns (string memory) {
1540     return _baseURIextended;
1541   }
1542 
1543   function withdraw() public onlyOwner {
1544       uint256 balance = address(this).balance;
1545       Address.sendValue(creatorAddress, balance.mul(95).div(100));
1546       Address.sendValue(devAddress, balance.mul(5).div(100));
1547   }
1548 
1549 }