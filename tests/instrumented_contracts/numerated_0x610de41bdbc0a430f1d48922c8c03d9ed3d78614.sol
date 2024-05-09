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
332 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Contract module that helps prevent reentrant calls to a function.
341  *
342  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
343  * available, which can be applied to functions to make sure there are no nested
344  * (reentrant) calls to them.
345  *
346  * Note that because there is a single `nonReentrant` guard, functions marked as
347  * `nonReentrant` may not call one another. This can be worked around by making
348  * those functions `private`, and then adding `external` `nonReentrant` entry
349  * points to them.
350  *
351  * TIP: If you would like to learn more about reentrancy and alternative ways
352  * to protect against it, check out our blog post
353  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
354  */
355 abstract contract ReentrancyGuard {
356     // Booleans are more expensive than uint256 or any type that takes up a full
357     // word because each write operation emits an extra SLOAD to first read the
358     // slot's contents, replace the bits taken up by the boolean, and then write
359     // back. This is the compiler's defense against contract upgrades and
360     // pointer aliasing, and it cannot be disabled.
361 
362     // The values being non-zero value makes deployment a bit more expensive,
363     // but in exchange the refund on every call to nonReentrant will be lower in
364     // amount. Since refunds are capped to a percentage of the total
365     // transaction's gas, it is best to keep them low in cases like this one, to
366     // increase the likelihood of the full refund coming into effect.
367     uint256 private constant _NOT_ENTERED = 1;
368     uint256 private constant _ENTERED = 2;
369 
370     uint256 private _status;
371 
372     constructor() {
373         _status = _NOT_ENTERED;
374     }
375 
376     /**
377      * @dev Prevents a contract from calling itself, directly or indirectly.
378      * Calling a `nonReentrant` function from another `nonReentrant`
379      * function is not supported. It is possible to prevent this from happening
380      * by making the `nonReentrant` function external, and making it call a
381      * `private` function that does the actual work.
382      */
383     modifier nonReentrant() {
384         // On the first call to nonReentrant, _notEntered will be true
385         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
386 
387         // Any calls to nonReentrant after this point will fail
388         _status = _ENTERED;
389 
390         _;
391 
392         // By storing the original value once again, a refund is triggered (see
393         // https://eips.ethereum.org/EIPS/eip-2200)
394         _status = _NOT_ENTERED;
395     }
396 }
397 
398 // File: @openzeppelin/contracts/utils/Strings.sol
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @dev String operations.
407  */
408 library Strings {
409     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
410 
411     /**
412      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
413      */
414     function toString(uint256 value) internal pure returns (string memory) {
415         // Inspired by OraclizeAPI's implementation - MIT licence
416         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
417 
418         if (value == 0) {
419             return "0";
420         }
421         uint256 temp = value;
422         uint256 digits;
423         while (temp != 0) {
424             digits++;
425             temp /= 10;
426         }
427         bytes memory buffer = new bytes(digits);
428         while (value != 0) {
429             digits -= 1;
430             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
431             value /= 10;
432         }
433         return string(buffer);
434     }
435 
436     /**
437      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
438      */
439     function toHexString(uint256 value) internal pure returns (string memory) {
440         if (value == 0) {
441             return "0x00";
442         }
443         uint256 temp = value;
444         uint256 length = 0;
445         while (temp != 0) {
446             length++;
447             temp >>= 8;
448         }
449         return toHexString(value, length);
450     }
451 
452     /**
453      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
454      */
455     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
456         bytes memory buffer = new bytes(2 * length + 2);
457         buffer[0] = "0";
458         buffer[1] = "x";
459         for (uint256 i = 2 * length + 1; i > 1; --i) {
460             buffer[i] = _HEX_SYMBOLS[value & 0xf];
461             value >>= 4;
462         }
463         require(value == 0, "Strings: hex length insufficient");
464         return string(buffer);
465     }
466 }
467 
468 // File: @openzeppelin/contracts/utils/Context.sol
469 
470 
471 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @dev Provides information about the current execution context, including the
477  * sender of the transaction and its data. While these are generally available
478  * via msg.sender and msg.data, they should not be accessed in such a direct
479  * manner, since when dealing with meta-transactions the account sending and
480  * paying for execution may not be the actual sender (as far as an application
481  * is concerned).
482  *
483  * This contract is only required for intermediate, library-like contracts.
484  */
485 abstract contract Context {
486     function _msgSender() internal view virtual returns (address) {
487         return msg.sender;
488     }
489 
490     function _msgData() internal view virtual returns (bytes calldata) {
491         return msg.data;
492     }
493 }
494 
495 // File: @openzeppelin/contracts/access/Ownable.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Contract module which provides a basic access control mechanism, where
505  * there is an account (an owner) that can be granted exclusive access to
506  * specific functions.
507  *
508  * By default, the owner account will be the one that deploys the contract. This
509  * can later be changed with {transferOwnership}.
510  *
511  * This module is used through inheritance. It will make available the modifier
512  * `onlyOwner`, which can be applied to your functions to restrict their use to
513  * the owner.
514  */
515 abstract contract Ownable is Context {
516     address private _owner;
517 
518     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
519 
520     /**
521      * @dev Initializes the contract setting the deployer as the initial owner.
522      */
523     constructor() {
524         _transferOwnership(_msgSender());
525     }
526 
527     /**
528      * @dev Returns the address of the current owner.
529      */
530     function owner() public view virtual returns (address) {
531         return _owner;
532     }
533 
534     /**
535      * @dev Throws if called by any account other than the owner.
536      */
537     modifier onlyOwner() {
538         require(owner() == _msgSender(), "Ownable: caller is not the owner");
539         _;
540     }
541 
542     /**
543      * @dev Leaves the contract without owner. It will not be possible to call
544      * `onlyOwner` functions anymore. Can only be called by the current owner.
545      *
546      * NOTE: Renouncing ownership will leave the contract without an owner,
547      * thereby removing any functionality that is only available to the owner.
548      */
549     function renounceOwnership() public virtual onlyOwner {
550         _transferOwnership(address(0));
551     }
552 
553     /**
554      * @dev Transfers ownership of the contract to a new account (`newOwner`).
555      * Can only be called by the current owner.
556      */
557     function transferOwnership(address newOwner) public virtual onlyOwner {
558         require(newOwner != address(0), "Ownable: new owner is the zero address");
559         _transferOwnership(newOwner);
560     }
561 
562     /**
563      * @dev Transfers ownership of the contract to a new account (`newOwner`).
564      * Internal function without access restriction.
565      */
566     function _transferOwnership(address newOwner) internal virtual {
567         address oldOwner = _owner;
568         _owner = newOwner;
569         emit OwnershipTransferred(oldOwner, newOwner);
570     }
571 }
572 
573 // File: @openzeppelin/contracts/utils/Address.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @dev Collection of functions related to the address type
582  */
583 library Address {
584     /**
585      * @dev Returns true if `account` is a contract.
586      *
587      * [IMPORTANT]
588      * ====
589      * It is unsafe to assume that an address for which this function returns
590      * false is an externally-owned account (EOA) and not a contract.
591      *
592      * Among others, `isContract` will return false for the following
593      * types of addresses:
594      *
595      *  - an externally-owned account
596      *  - a contract in construction
597      *  - an address where a contract will be created
598      *  - an address where a contract lived, but was destroyed
599      * ====
600      */
601     function isContract(address account) internal view returns (bool) {
602         // This method relies on extcodesize, which returns 0 for contracts in
603         // construction, since the code is only stored at the end of the
604         // constructor execution.
605 
606         uint256 size;
607         assembly {
608             size := extcodesize(account)
609         }
610         return size > 0;
611     }
612 
613     /**
614      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
615      * `recipient`, forwarding all available gas and reverting on errors.
616      *
617      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
618      * of certain opcodes, possibly making contracts go over the 2300 gas limit
619      * imposed by `transfer`, making them unable to receive funds via
620      * `transfer`. {sendValue} removes this limitation.
621      *
622      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
623      *
624      * IMPORTANT: because control is transferred to `recipient`, care must be
625      * taken to not create reentrancy vulnerabilities. Consider using
626      * {ReentrancyGuard} or the
627      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
628      */
629     function sendValue(address payable recipient, uint256 amount) internal {
630         require(address(this).balance >= amount, "Address: insufficient balance");
631 
632         (bool success, ) = recipient.call{value: amount}("");
633         require(success, "Address: unable to send value, recipient may have reverted");
634     }
635 
636     /**
637      * @dev Performs a Solidity function call using a low level `call`. A
638      * plain `call` is an unsafe replacement for a function call: use this
639      * function instead.
640      *
641      * If `target` reverts with a revert reason, it is bubbled up by this
642      * function (like regular Solidity function calls).
643      *
644      * Returns the raw returned data. To convert to the expected return value,
645      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
646      *
647      * Requirements:
648      *
649      * - `target` must be a contract.
650      * - calling `target` with `data` must not revert.
651      *
652      * _Available since v3.1._
653      */
654     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
655         return functionCall(target, data, "Address: low-level call failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
660      * `errorMessage` as a fallback revert reason when `target` reverts.
661      *
662      * _Available since v3.1._
663      */
664     function functionCall(
665         address target,
666         bytes memory data,
667         string memory errorMessage
668     ) internal returns (bytes memory) {
669         return functionCallWithValue(target, data, 0, errorMessage);
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
674      * but also transferring `value` wei to `target`.
675      *
676      * Requirements:
677      *
678      * - the calling contract must have an ETH balance of at least `value`.
679      * - the called Solidity function must be `payable`.
680      *
681      * _Available since v3.1._
682      */
683     function functionCallWithValue(
684         address target,
685         bytes memory data,
686         uint256 value
687     ) internal returns (bytes memory) {
688         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
693      * with `errorMessage` as a fallback revert reason when `target` reverts.
694      *
695      * _Available since v3.1._
696      */
697     function functionCallWithValue(
698         address target,
699         bytes memory data,
700         uint256 value,
701         string memory errorMessage
702     ) internal returns (bytes memory) {
703         require(address(this).balance >= value, "Address: insufficient balance for call");
704         require(isContract(target), "Address: call to non-contract");
705 
706         (bool success, bytes memory returndata) = target.call{value: value}(data);
707         return verifyCallResult(success, returndata, errorMessage);
708     }
709 
710     /**
711      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
712      * but performing a static call.
713      *
714      * _Available since v3.3._
715      */
716     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
717         return functionStaticCall(target, data, "Address: low-level static call failed");
718     }
719 
720     /**
721      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
722      * but performing a static call.
723      *
724      * _Available since v3.3._
725      */
726     function functionStaticCall(
727         address target,
728         bytes memory data,
729         string memory errorMessage
730     ) internal view returns (bytes memory) {
731         require(isContract(target), "Address: static call to non-contract");
732 
733         (bool success, bytes memory returndata) = target.staticcall(data);
734         return verifyCallResult(success, returndata, errorMessage);
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
739      * but performing a delegate call.
740      *
741      * _Available since v3.4._
742      */
743     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
744         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
749      * but performing a delegate call.
750      *
751      * _Available since v3.4._
752      */
753     function functionDelegateCall(
754         address target,
755         bytes memory data,
756         string memory errorMessage
757     ) internal returns (bytes memory) {
758         require(isContract(target), "Address: delegate call to non-contract");
759 
760         (bool success, bytes memory returndata) = target.delegatecall(data);
761         return verifyCallResult(success, returndata, errorMessage);
762     }
763 
764     /**
765      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
766      * revert reason using the provided one.
767      *
768      * _Available since v4.3._
769      */
770     function verifyCallResult(
771         bool success,
772         bytes memory returndata,
773         string memory errorMessage
774     ) internal pure returns (bytes memory) {
775         if (success) {
776             return returndata;
777         } else {
778             // Look for revert reason and bubble it up if present
779             if (returndata.length > 0) {
780                 // The easiest way to bubble the revert reason is using memory via assembly
781 
782                 assembly {
783                     let returndata_size := mload(returndata)
784                     revert(add(32, returndata), returndata_size)
785                 }
786             } else {
787                 revert(errorMessage);
788             }
789         }
790     }
791 }
792 
793 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
794 
795 
796 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
797 
798 pragma solidity ^0.8.0;
799 
800 /**
801  * @title ERC721 token receiver interface
802  * @dev Interface for any contract that wants to support safeTransfers
803  * from ERC721 asset contracts.
804  */
805 interface IERC721Receiver {
806     /**
807      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
808      * by `operator` from `from`, this function is called.
809      *
810      * It must return its Solidity selector to confirm the token transfer.
811      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
812      *
813      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
814      */
815     function onERC721Received(
816         address operator,
817         address from,
818         uint256 tokenId,
819         bytes calldata data
820     ) external returns (bytes4);
821 }
822 
823 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
824 
825 
826 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 /**
831  * @dev Interface of the ERC165 standard, as defined in the
832  * https://eips.ethereum.org/EIPS/eip-165[EIP].
833  *
834  * Implementers can declare support of contract interfaces, which can then be
835  * queried by others ({ERC165Checker}).
836  *
837  * For an implementation, see {ERC165}.
838  */
839 interface IERC165 {
840     /**
841      * @dev Returns true if this contract implements the interface defined by
842      * `interfaceId`. See the corresponding
843      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
844      * to learn more about how these ids are created.
845      *
846      * This function call must use less than 30 000 gas.
847      */
848     function supportsInterface(bytes4 interfaceId) external view returns (bool);
849 }
850 
851 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
852 
853 
854 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
855 
856 pragma solidity ^0.8.0;
857 
858 
859 /**
860  * @dev Implementation of the {IERC165} interface.
861  *
862  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
863  * for the additional interface id that will be supported. For example:
864  *
865  * ```solidity
866  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
867  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
868  * }
869  * ```
870  *
871  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
872  */
873 abstract contract ERC165 is IERC165 {
874     /**
875      * @dev See {IERC165-supportsInterface}.
876      */
877     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
878         return interfaceId == type(IERC165).interfaceId;
879     }
880 }
881 
882 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
883 
884 
885 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
886 
887 pragma solidity ^0.8.0;
888 
889 
890 /**
891  * @dev Required interface of an ERC721 compliant contract.
892  */
893 interface IERC721 is IERC165 {
894     /**
895      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
896      */
897     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
898 
899     /**
900      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
901      */
902     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
903 
904     /**
905      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
906      */
907     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
908 
909     /**
910      * @dev Returns the number of tokens in ``owner``'s account.
911      */
912     function balanceOf(address owner) external view returns (uint256 balance);
913 
914     /**
915      * @dev Returns the owner of the `tokenId` token.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function ownerOf(uint256 tokenId) external view returns (address owner);
922 
923     /**
924      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
925      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
926      *
927      * Requirements:
928      *
929      * - `from` cannot be the zero address.
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must exist and be owned by `from`.
932      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
933      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
934      *
935      * Emits a {Transfer} event.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) external;
942 
943     /**
944      * @dev Transfers `tokenId` token from `from` to `to`.
945      *
946      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
947      *
948      * Requirements:
949      *
950      * - `from` cannot be the zero address.
951      * - `to` cannot be the zero address.
952      * - `tokenId` token must be owned by `from`.
953      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
954      *
955      * Emits a {Transfer} event.
956      */
957     function transferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) external;
962 
963     /**
964      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
965      * The approval is cleared when the token is transferred.
966      *
967      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
968      *
969      * Requirements:
970      *
971      * - The caller must own the token or be an approved operator.
972      * - `tokenId` must exist.
973      *
974      * Emits an {Approval} event.
975      */
976     function approve(address to, uint256 tokenId) external;
977 
978     /**
979      * @dev Returns the account approved for `tokenId` token.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must exist.
984      */
985     function getApproved(uint256 tokenId) external view returns (address operator);
986 
987     /**
988      * @dev Approve or remove `operator` as an operator for the caller.
989      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
990      *
991      * Requirements:
992      *
993      * - The `operator` cannot be the caller.
994      *
995      * Emits an {ApprovalForAll} event.
996      */
997     function setApprovalForAll(address operator, bool _approved) external;
998 
999     /**
1000      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1001      *
1002      * See {setApprovalForAll}
1003      */
1004     function isApprovedForAll(address owner, address operator) external view returns (bool);
1005 
1006     /**
1007      * @dev Safely transfers `tokenId` token from `from` to `to`.
1008      *
1009      * Requirements:
1010      *
1011      * - `from` cannot be the zero address.
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must exist and be owned by `from`.
1014      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1015      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes calldata data
1024     ) external;
1025 }
1026 
1027 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1028 
1029 
1030 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1031 
1032 pragma solidity ^0.8.0;
1033 
1034 
1035 /**
1036  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1037  * @dev See https://eips.ethereum.org/EIPS/eip-721
1038  */
1039 interface IERC721Enumerable is IERC721 {
1040     /**
1041      * @dev Returns the total amount of tokens stored by the contract.
1042      */
1043     function totalSupply() external view returns (uint256);
1044 
1045     /**
1046      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1047      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1048      */
1049     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1050 
1051     /**
1052      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1053      * Use along with {totalSupply} to enumerate all tokens.
1054      */
1055     function tokenByIndex(uint256 index) external view returns (uint256);
1056 }
1057 
1058 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1059 
1060 
1061 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1062 
1063 pragma solidity ^0.8.0;
1064 
1065 
1066 /**
1067  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1068  * @dev See https://eips.ethereum.org/EIPS/eip-721
1069  */
1070 interface IERC721Metadata is IERC721 {
1071     /**
1072      * @dev Returns the token collection name.
1073      */
1074     function name() external view returns (string memory);
1075 
1076     /**
1077      * @dev Returns the token collection symbol.
1078      */
1079     function symbol() external view returns (string memory);
1080 
1081     /**
1082      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1083      */
1084     function tokenURI(uint256 tokenId) external view returns (string memory);
1085 }
1086 
1087 // File: erc721a/contracts/ERC721A.sol
1088 
1089 
1090 // Creator: Chiru Labs
1091 
1092 pragma solidity ^0.8.4;
1093 
1094 
1095 
1096 
1097 
1098 
1099 
1100 
1101 
1102 error ApprovalCallerNotOwnerNorApproved();
1103 error ApprovalQueryForNonexistentToken();
1104 error ApproveToCaller();
1105 error ApprovalToCurrentOwner();
1106 error BalanceQueryForZeroAddress();
1107 error MintedQueryForZeroAddress();
1108 error BurnedQueryForZeroAddress();
1109 error MintToZeroAddress();
1110 error MintZeroQuantity();
1111 error OwnerIndexOutOfBounds();
1112 error OwnerQueryForNonexistentToken();
1113 error TokenIndexOutOfBounds();
1114 error TransferCallerNotOwnerNorApproved();
1115 error TransferFromIncorrectOwner();
1116 error TransferToNonERC721ReceiverImplementer();
1117 error TransferToZeroAddress();
1118 error URIQueryForNonexistentToken();
1119 
1120 /**
1121  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1122  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1123  *
1124  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1125  *
1126  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1127  *
1128  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
1129  */
1130 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1131     using Address for address;
1132     using Strings for uint256;
1133 
1134     // Compiler will pack this into a single 256bit word.
1135     struct TokenOwnership {
1136         // The address of the owner.
1137         address addr;
1138         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1139         uint64 startTimestamp;
1140         // Whether the token has been burned.
1141         bool burned;
1142     }
1143 
1144     // Compiler will pack this into a single 256bit word.
1145     struct AddressData {
1146         // Realistically, 2**64-1 is more than enough.
1147         uint64 balance;
1148         // Keeps track of mint count with minimal overhead for tokenomics.
1149         uint64 numberMinted;
1150         // Keeps track of burn count with minimal overhead for tokenomics.
1151         uint64 numberBurned;
1152     }
1153 
1154     // Compiler will pack the following 
1155     // _currentIndex and _burnCounter into a single 256bit word.
1156     
1157     // The tokenId of the next token to be minted.
1158     uint128 internal _currentIndex;
1159 
1160     // The number of tokens burned.
1161     uint128 internal _burnCounter;
1162 
1163     // Token name
1164     string private _name;
1165 
1166     // Token symbol
1167     string private _symbol;
1168 
1169     // Mapping from token ID to ownership details
1170     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1171     mapping(uint256 => TokenOwnership) internal _ownerships;
1172 
1173     // Mapping owner address to address data
1174     mapping(address => AddressData) private _addressData;
1175 
1176     // Mapping from token ID to approved address
1177     mapping(uint256 => address) private _tokenApprovals;
1178 
1179     // Mapping from owner to operator approvals
1180     mapping(address => mapping(address => bool)) private _operatorApprovals;
1181 
1182     constructor(string memory name_, string memory symbol_) {
1183         _name = name_;
1184         _symbol = symbol_;
1185     }
1186 
1187     /**
1188      * @dev See {IERC721Enumerable-totalSupply}.
1189      */
1190     function totalSupply() public view override returns (uint256) {
1191         // Counter underflow is impossible as _burnCounter cannot be incremented
1192         // more than _currentIndex times
1193         unchecked {
1194             return _currentIndex - _burnCounter;    
1195         }
1196     }
1197 
1198     /**
1199      * @dev See {IERC721Enumerable-tokenByIndex}.
1200      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1201      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1202      */
1203     function tokenByIndex(uint256 index) public view override returns (uint256) {
1204         uint256 numMintedSoFar = _currentIndex;
1205         uint256 tokenIdsIdx;
1206 
1207         // Counter overflow is impossible as the loop breaks when
1208         // uint256 i is equal to another uint256 numMintedSoFar.
1209         unchecked {
1210             for (uint256 i; i < numMintedSoFar; i++) {
1211                 TokenOwnership memory ownership = _ownerships[i];
1212                 if (!ownership.burned) {
1213                     if (tokenIdsIdx == index) {
1214                         return i;
1215                     }
1216                     tokenIdsIdx++;
1217                 }
1218             }
1219         }
1220         revert TokenIndexOutOfBounds();
1221     }
1222 
1223     /**
1224      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1225      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1226      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1227      */
1228     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1229         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1230         uint256 numMintedSoFar = _currentIndex;
1231         uint256 tokenIdsIdx;
1232         address currOwnershipAddr;
1233 
1234         // Counter overflow is impossible as the loop breaks when
1235         // uint256 i is equal to another uint256 numMintedSoFar.
1236         unchecked {
1237             for (uint256 i; i < numMintedSoFar; i++) {
1238                 TokenOwnership memory ownership = _ownerships[i];
1239                 if (ownership.burned) {
1240                     continue;
1241                 }
1242                 if (ownership.addr != address(0)) {
1243                     currOwnershipAddr = ownership.addr;
1244                 }
1245                 if (currOwnershipAddr == owner) {
1246                     if (tokenIdsIdx == index) {
1247                         return i;
1248                     }
1249                     tokenIdsIdx++;
1250                 }
1251             }
1252         }
1253 
1254         // Execution should never reach this point.
1255         revert();
1256     }
1257 
1258     /**
1259      * @dev See {IERC165-supportsInterface}.
1260      */
1261     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1262         return
1263             interfaceId == type(IERC721).interfaceId ||
1264             interfaceId == type(IERC721Metadata).interfaceId ||
1265             interfaceId == type(IERC721Enumerable).interfaceId ||
1266             super.supportsInterface(interfaceId);
1267     }
1268 
1269     /**
1270      * @dev See {IERC721-balanceOf}.
1271      */
1272     function balanceOf(address owner) public view override returns (uint256) {
1273         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1274         return uint256(_addressData[owner].balance);
1275     }
1276 
1277     function _numberMinted(address owner) internal view returns (uint256) {
1278         if (owner == address(0)) revert MintedQueryForZeroAddress();
1279         return uint256(_addressData[owner].numberMinted);
1280     }
1281 
1282     function _numberBurned(address owner) internal view returns (uint256) {
1283         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1284         return uint256(_addressData[owner].numberBurned);
1285     }
1286 
1287     /**
1288      * Gas spent here starts off proportional to the maximum mint batch size.
1289      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1290      */
1291     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1292         uint256 curr = tokenId;
1293 
1294         unchecked {
1295             if (curr < _currentIndex) {
1296                 TokenOwnership memory ownership = _ownerships[curr];
1297                 if (!ownership.burned) {
1298                     if (ownership.addr != address(0)) {
1299                         return ownership;
1300                     }
1301                     // Invariant: 
1302                     // There will always be an ownership that has an address and is not burned 
1303                     // before an ownership that does not have an address and is not burned.
1304                     // Hence, curr will not underflow.
1305                     while (true) {
1306                         curr--;
1307                         ownership = _ownerships[curr];
1308                         if (ownership.addr != address(0)) {
1309                             return ownership;
1310                         }
1311                     }
1312                 }
1313             }
1314         }
1315         revert OwnerQueryForNonexistentToken();
1316     }
1317 
1318     /**
1319      * @dev See {IERC721-ownerOf}.
1320      */
1321     function ownerOf(uint256 tokenId) public view override returns (address) {
1322         return ownershipOf(tokenId).addr;
1323     }
1324 
1325     /**
1326      * @dev See {IERC721Metadata-name}.
1327      */
1328     function name() public view virtual override returns (string memory) {
1329         return _name;
1330     }
1331 
1332     /**
1333      * @dev See {IERC721Metadata-symbol}.
1334      */
1335     function symbol() public view virtual override returns (string memory) {
1336         return _symbol;
1337     }
1338 
1339     /**
1340      * @dev See {IERC721Metadata-tokenURI}.
1341      */
1342     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1343         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1344 
1345         string memory baseURI = _baseURI();
1346         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1347     }
1348 
1349     /**
1350      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1351      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1352      * by default, can be overriden in child contracts.
1353      */
1354     function _baseURI() internal view virtual returns (string memory) {
1355         return '';
1356     }
1357 
1358     /**
1359      * @dev See {IERC721-approve}.
1360      */
1361     function approve(address to, uint256 tokenId) public override {
1362         address owner = ERC721A.ownerOf(tokenId);
1363         if (to == owner) revert ApprovalToCurrentOwner();
1364 
1365         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1366             revert ApprovalCallerNotOwnerNorApproved();
1367         }
1368 
1369         _approve(to, tokenId, owner);
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-getApproved}.
1374      */
1375     function getApproved(uint256 tokenId) public view override returns (address) {
1376         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1377 
1378         return _tokenApprovals[tokenId];
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-setApprovalForAll}.
1383      */
1384     function setApprovalForAll(address operator, bool approved) public override {
1385         if (operator == _msgSender()) revert ApproveToCaller();
1386 
1387         _operatorApprovals[_msgSender()][operator] = approved;
1388         emit ApprovalForAll(_msgSender(), operator, approved);
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-isApprovedForAll}.
1393      */
1394     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1395         return _operatorApprovals[owner][operator];
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-transferFrom}.
1400      */
1401     function transferFrom(
1402         address from,
1403         address to,
1404         uint256 tokenId
1405     ) public virtual override {
1406         _transfer(from, to, tokenId);
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-safeTransferFrom}.
1411      */
1412     function safeTransferFrom(
1413         address from,
1414         address to,
1415         uint256 tokenId
1416     ) public virtual override {
1417         safeTransferFrom(from, to, tokenId, '');
1418     }
1419 
1420     /**
1421      * @dev See {IERC721-safeTransferFrom}.
1422      */
1423     function safeTransferFrom(
1424         address from,
1425         address to,
1426         uint256 tokenId,
1427         bytes memory _data
1428     ) public virtual override {
1429         _transfer(from, to, tokenId);
1430         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1431             revert TransferToNonERC721ReceiverImplementer();
1432         }
1433     }
1434 
1435     /**
1436      * @dev Returns whether `tokenId` exists.
1437      *
1438      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1439      *
1440      * Tokens start existing when they are minted (`_mint`),
1441      */
1442     function _exists(uint256 tokenId) internal view returns (bool) {
1443         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1444     }
1445 
1446     function _safeMint(address to, uint256 quantity) internal {
1447         _safeMint(to, quantity, '');
1448     }
1449 
1450     /**
1451      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1452      *
1453      * Requirements:
1454      *
1455      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1456      * - `quantity` must be greater than 0.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _safeMint(
1461         address to,
1462         uint256 quantity,
1463         bytes memory _data
1464     ) internal {
1465         _mint(to, quantity, _data, true);
1466     }
1467 
1468     /**
1469      * @dev Mints `quantity` tokens and transfers them to `to`.
1470      *
1471      * Requirements:
1472      *
1473      * - `to` cannot be the zero address.
1474      * - `quantity` must be greater than 0.
1475      *
1476      * Emits a {Transfer} event.
1477      */
1478     function _mint(
1479         address to,
1480         uint256 quantity,
1481         bytes memory _data,
1482         bool safe
1483     ) internal {
1484         uint256 startTokenId = _currentIndex;
1485         if (to == address(0)) revert MintToZeroAddress();
1486         if (quantity == 0) revert MintZeroQuantity();
1487 
1488         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1489 
1490         // Overflows are incredibly unrealistic.
1491         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1492         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1493         unchecked {
1494             _addressData[to].balance += uint64(quantity);
1495             _addressData[to].numberMinted += uint64(quantity);
1496 
1497             _ownerships[startTokenId].addr = to;
1498             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1499 
1500             uint256 updatedIndex = startTokenId;
1501 
1502             for (uint256 i; i < quantity; i++) {
1503                 emit Transfer(address(0), to, updatedIndex);
1504                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1505                     revert TransferToNonERC721ReceiverImplementer();
1506                 }
1507                 updatedIndex++;
1508             }
1509 
1510             _currentIndex = uint128(updatedIndex);
1511         }
1512         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1513     }
1514 
1515     /**
1516      * @dev Transfers `tokenId` from `from` to `to`.
1517      *
1518      * Requirements:
1519      *
1520      * - `to` cannot be the zero address.
1521      * - `tokenId` token must be owned by `from`.
1522      *
1523      * Emits a {Transfer} event.
1524      */
1525     function _transfer(
1526         address from,
1527         address to,
1528         uint256 tokenId
1529     ) private {
1530         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1531 
1532         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1533             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1534             getApproved(tokenId) == _msgSender());
1535 
1536         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1537         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1538         if (to == address(0)) revert TransferToZeroAddress();
1539 
1540         _beforeTokenTransfers(from, to, tokenId, 1);
1541 
1542         // Clear approvals from the previous owner
1543         _approve(address(0), tokenId, prevOwnership.addr);
1544 
1545         // Underflow of the sender's balance is impossible because we check for
1546         // ownership above and the recipient's balance can't realistically overflow.
1547         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1548         unchecked {
1549             _addressData[from].balance -= 1;
1550             _addressData[to].balance += 1;
1551 
1552             _ownerships[tokenId].addr = to;
1553             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1554 
1555             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1556             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1557             uint256 nextTokenId = tokenId + 1;
1558             if (_ownerships[nextTokenId].addr == address(0)) {
1559                 // This will suffice for checking _exists(nextTokenId),
1560                 // as a burned slot cannot contain the zero address.
1561                 if (nextTokenId < _currentIndex) {
1562                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1563                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1564                 }
1565             }
1566         }
1567 
1568         emit Transfer(from, to, tokenId);
1569         _afterTokenTransfers(from, to, tokenId, 1);
1570     }
1571 
1572     /**
1573      * @dev Destroys `tokenId`.
1574      * The approval is cleared when the token is burned.
1575      *
1576      * Requirements:
1577      *
1578      * - `tokenId` must exist.
1579      *
1580      * Emits a {Transfer} event.
1581      */
1582     function _burn(uint256 tokenId) internal virtual {
1583         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1584 
1585         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1586 
1587         // Clear approvals from the previous owner
1588         _approve(address(0), tokenId, prevOwnership.addr);
1589 
1590         // Underflow of the sender's balance is impossible because we check for
1591         // ownership above and the recipient's balance can't realistically overflow.
1592         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1593         unchecked {
1594             _addressData[prevOwnership.addr].balance -= 1;
1595             _addressData[prevOwnership.addr].numberBurned += 1;
1596 
1597             // Keep track of who burned the token, and the timestamp of burning.
1598             _ownerships[tokenId].addr = prevOwnership.addr;
1599             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1600             _ownerships[tokenId].burned = true;
1601 
1602             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1603             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1604             uint256 nextTokenId = tokenId + 1;
1605             if (_ownerships[nextTokenId].addr == address(0)) {
1606                 // This will suffice for checking _exists(nextTokenId),
1607                 // as a burned slot cannot contain the zero address.
1608                 if (nextTokenId < _currentIndex) {
1609                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1610                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1611                 }
1612             }
1613         }
1614 
1615         emit Transfer(prevOwnership.addr, address(0), tokenId);
1616         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1617 
1618         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1619         unchecked { 
1620             _burnCounter++;
1621         }
1622     }
1623 
1624     /**
1625      * @dev Approve `to` to operate on `tokenId`
1626      *
1627      * Emits a {Approval} event.
1628      */
1629     function _approve(
1630         address to,
1631         uint256 tokenId,
1632         address owner
1633     ) private {
1634         _tokenApprovals[tokenId] = to;
1635         emit Approval(owner, to, tokenId);
1636     }
1637 
1638     /**
1639      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1640      * The call is not executed if the target address is not a contract.
1641      *
1642      * @param from address representing the previous owner of the given token ID
1643      * @param to target address that will receive the tokens
1644      * @param tokenId uint256 ID of the token to be transferred
1645      * @param _data bytes optional data to send along with the call
1646      * @return bool whether the call correctly returned the expected magic value
1647      */
1648     function _checkOnERC721Received(
1649         address from,
1650         address to,
1651         uint256 tokenId,
1652         bytes memory _data
1653     ) private returns (bool) {
1654         if (to.isContract()) {
1655             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1656                 return retval == IERC721Receiver(to).onERC721Received.selector;
1657             } catch (bytes memory reason) {
1658                 if (reason.length == 0) {
1659                     revert TransferToNonERC721ReceiverImplementer();
1660                 } else {
1661                     assembly {
1662                         revert(add(32, reason), mload(reason))
1663                     }
1664                 }
1665             }
1666         } else {
1667             return true;
1668         }
1669     }
1670 
1671     /**
1672      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1673      * And also called before burning one token.
1674      *
1675      * startTokenId - the first token id to be transferred
1676      * quantity - the amount to be transferred
1677      *
1678      * Calling conditions:
1679      *
1680      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1681      * transferred to `to`.
1682      * - When `from` is zero, `tokenId` will be minted for `to`.
1683      * - When `to` is zero, `tokenId` will be burned by `from`.
1684      * - `from` and `to` are never both zero.
1685      */
1686     function _beforeTokenTransfers(
1687         address from,
1688         address to,
1689         uint256 startTokenId,
1690         uint256 quantity
1691     ) internal virtual {}
1692 
1693     /**
1694      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1695      * minting.
1696      * And also called after one token has been burned.
1697      *
1698      * startTokenId - the first token id to be transferred
1699      * quantity - the amount to be transferred
1700      *
1701      * Calling conditions:
1702      *
1703      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1704      * transferred to `to`.
1705      * - When `from` is zero, `tokenId` has been minted for `to`.
1706      * - When `to` is zero, `tokenId` has been burned by `from`.
1707      * - `from` and `to` are never both zero.
1708      */
1709     function _afterTokenTransfers(
1710         address from,
1711         address to,
1712         uint256 startTokenId,
1713         uint256 quantity
1714     ) internal virtual {}
1715 }
1716 
1717 // File: contracts/KartalCollectible.sol
1718 
1719 
1720 pragma solidity >=0.4.22 <0.9.0;
1721 
1722 
1723 
1724 
1725 
1726 
1727 
1728 
1729 contract KartalCollectible is ERC721A, Ownable, ReentrancyGuard { 
1730     using Strings for uint256;
1731 
1732     // Maximum supply of NFT's
1733     uint256 constant public MAX_SUPPLY = 5000;
1734 
1735     // Set the current listing price to 0.2 ether.
1736     uint256 constant public LISTING_PRICE = 0.2 ether;
1737 
1738     // Merkle Proof hash
1739     bytes32 public merkleTreeRootHash = 0x7bc87f848fbb6ea0e6609dd97646643d3a04c5d957fd739efaac1f510c822f60;
1740     
1741     // Presale
1742     bool private presaleActive = true;
1743 
1744     // Open sale
1745     bool private saleOpen = false;
1746 
1747     // NFT Metadata Base URI
1748     string private baseUri = "https://cdn.kartal-nft.io/";
1749 
1750     constructor() ERC721A("KARTAL CLUB", "KRTL") ReentrancyGuard() {
1751 
1752     }
1753 
1754     function mintTokenFromWeb(uint256 tokenQuantity, bytes32[] calldata merkleProof) nonReentrant() callerIsUser external payable {
1755         // Check if sale is open
1756         require(saleOpen, "The sale is not yet open");
1757 
1758         // Check if enough ether was sent
1759         uint256 totalPrice = SafeMath.mul(tokenQuantity, LISTING_PRICE);
1760         require(msg.value >= totalPrice, "Ether value sent is not correct");
1761 
1762         // Check if the given token quantity is not null or negative
1763         require(tokenQuantity > 0, "Token quantity must be greater than 0");
1764 
1765         // Check if this purchase would exceed the max supply
1766         uint256 supplyAfterMint = SafeMath.add(totalSupply(), tokenQuantity);
1767         require(supplyAfterMint <= MAX_SUPPLY, "Purchase would exceed max supply");        
1768 
1769         // If presale is active check for whitelist proof
1770         if (presaleActive) {
1771             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1772             require(MerkleProof.verify(merkleProof, merkleTreeRootHash, leaf), "Your address is not whitelisted");
1773         }
1774 
1775         // Mint the tokens
1776         _safeMint(msg.sender, tokenQuantity);
1777     }
1778 
1779     // ==== Modifiers ====
1780 
1781     modifier callerIsUser() {
1782         require(tx.origin == msg.sender, "The caller should be an user");
1783         _;
1784     }
1785 
1786     // ==== Only owner methods ====
1787 
1788     function withdraw() external onlyOwner nonReentrant {
1789         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1790         require(success, "Transfer failed.");
1791     }
1792 
1793     function setPresale(bool _presale) external onlyOwner {
1794         presaleActive = _presale;
1795     }
1796 
1797     function setSaleOpen(bool _saleOpen) external onlyOwner {
1798         saleOpen = _saleOpen;
1799     }
1800 
1801     function setBaseURI(string calldata _uri) external onlyOwner {
1802         baseUri = _uri;
1803     }
1804 
1805     function setMerkleTreeRootHash(bytes32 _hash) external onlyOwner {
1806         merkleTreeRootHash = _hash;
1807     }
1808 
1809     // ==== Public methods =====
1810 
1811     function _baseURI() internal view override returns (string memory) {
1812         return baseUri;
1813     }
1814 
1815     function getPresaleActive() external view returns (bool) {
1816         return presaleActive;
1817     }
1818 
1819     /**
1820      * @dev See {IERC721Metadata-tokenURI}.
1821      */
1822     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1823         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1824 
1825         string memory baseURI = _baseURI();
1826         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1827     }
1828 }