1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Counters.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @title Counters
240  * @author Matt Condon (@shrugs)
241  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
242  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
243  *
244  * Include with `using Counters for Counters.Counter;`
245  */
246 library Counters {
247     struct Counter {
248         // This variable should never be directly accessed by users of the library: interactions must be restricted to
249         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
250         // this feature: see https://github.com/ethereum/solidity/issues/4637
251         uint256 _value; // default: 0
252     }
253 
254     function current(Counter storage counter) internal view returns (uint256) {
255         return counter._value;
256     }
257 
258     function increment(Counter storage counter) internal {
259         unchecked {
260             counter._value += 1;
261         }
262     }
263 
264     function decrement(Counter storage counter) internal {
265         uint256 value = counter._value;
266         require(value > 0, "Counter: decrement overflow");
267         unchecked {
268             counter._value = value - 1;
269         }
270     }
271 
272     function reset(Counter storage counter) internal {
273         counter._value = 0;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
278 
279 
280 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev These functions deal with verification of Merkle Trees proofs.
286  *
287  * The proofs can be generated using the JavaScript library
288  * https://github.com/miguelmota/merkletreejs[merkletreejs].
289  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
290  *
291  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
292  */
293 library MerkleProof {
294     /**
295      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
296      * defined by `root`. For this, a `proof` must be provided, containing
297      * sibling hashes on the branch from the leaf to the root of the tree. Each
298      * pair of leaves and each pair of pre-images are assumed to be sorted.
299      */
300     function verify(
301         bytes32[] memory proof,
302         bytes32 root,
303         bytes32 leaf
304     ) internal pure returns (bool) {
305         return processProof(proof, leaf) == root;
306     }
307 
308     /**
309      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
310      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
311      * hash matches the root of the tree. When processing the proof, the pairs
312      * of leafs & pre-images are assumed to be sorted.
313      *
314      * _Available since v4.4._
315      */
316     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
317         bytes32 computedHash = leaf;
318         for (uint256 i = 0; i < proof.length; i++) {
319             bytes32 proofElement = proof[i];
320             if (computedHash <= proofElement) {
321                 // Hash(current computed hash + current element of the proof)
322                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
323             } else {
324                 // Hash(current element of the proof + current computed hash)
325                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
326             }
327         }
328         return computedHash;
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
398 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @dev Interface of the ERC20 standard as defined in the EIP.
407  */
408 interface IERC20 {
409     /**
410      * @dev Returns the amount of tokens in existence.
411      */
412     function totalSupply() external view returns (uint256);
413 
414     /**
415      * @dev Returns the amount of tokens owned by `account`.
416      */
417     function balanceOf(address account) external view returns (uint256);
418 
419     /**
420      * @dev Moves `amount` tokens from the caller's account to `recipient`.
421      *
422      * Returns a boolean value indicating whether the operation succeeded.
423      *
424      * Emits a {Transfer} event.
425      */
426     function transfer(address recipient, uint256 amount) external returns (bool);
427 
428     /**
429      * @dev Returns the remaining number of tokens that `spender` will be
430      * allowed to spend on behalf of `owner` through {transferFrom}. This is
431      * zero by default.
432      *
433      * This value changes when {approve} or {transferFrom} are called.
434      */
435     function allowance(address owner, address spender) external view returns (uint256);
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
439      *
440      * Returns a boolean value indicating whether the operation succeeded.
441      *
442      * IMPORTANT: Beware that changing an allowance with this method brings the risk
443      * that someone may use both the old and the new allowance by unfortunate
444      * transaction ordering. One possible solution to mitigate this race
445      * condition is to first reduce the spender's allowance to 0 and set the
446      * desired value afterwards:
447      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
448      *
449      * Emits an {Approval} event.
450      */
451     function approve(address spender, uint256 amount) external returns (bool);
452 
453     /**
454      * @dev Moves `amount` tokens from `sender` to `recipient` using the
455      * allowance mechanism. `amount` is then deducted from the caller's
456      * allowance.
457      *
458      * Returns a boolean value indicating whether the operation succeeded.
459      *
460      * Emits a {Transfer} event.
461      */
462     function transferFrom(
463         address sender,
464         address recipient,
465         uint256 amount
466     ) external returns (bool);
467 
468     /**
469      * @dev Emitted when `value` tokens are moved from one account (`from`) to
470      * another (`to`).
471      *
472      * Note that `value` may be zero.
473      */
474     event Transfer(address indexed from, address indexed to, uint256 value);
475 
476     /**
477      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
478      * a call to {approve}. `value` is the new allowance.
479      */
480     event Approval(address indexed owner, address indexed spender, uint256 value);
481 }
482 
483 // File: @openzeppelin/contracts/interfaces/IERC20.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 
491 // File: @openzeppelin/contracts/utils/Strings.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev String operations.
500  */
501 library Strings {
502     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
506      */
507     function toString(uint256 value) internal pure returns (string memory) {
508         // Inspired by OraclizeAPI's implementation - MIT licence
509         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
510 
511         if (value == 0) {
512             return "0";
513         }
514         uint256 temp = value;
515         uint256 digits;
516         while (temp != 0) {
517             digits++;
518             temp /= 10;
519         }
520         bytes memory buffer = new bytes(digits);
521         while (value != 0) {
522             digits -= 1;
523             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
524             value /= 10;
525         }
526         return string(buffer);
527     }
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
531      */
532     function toHexString(uint256 value) internal pure returns (string memory) {
533         if (value == 0) {
534             return "0x00";
535         }
536         uint256 temp = value;
537         uint256 length = 0;
538         while (temp != 0) {
539             length++;
540             temp >>= 8;
541         }
542         return toHexString(value, length);
543     }
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
547      */
548     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
549         bytes memory buffer = new bytes(2 * length + 2);
550         buffer[0] = "0";
551         buffer[1] = "x";
552         for (uint256 i = 2 * length + 1; i > 1; --i) {
553             buffer[i] = _HEX_SYMBOLS[value & 0xf];
554             value >>= 4;
555         }
556         require(value == 0, "Strings: hex length insufficient");
557         return string(buffer);
558     }
559 }
560 
561 // File: @openzeppelin/contracts/utils/Context.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 /**
569  * @dev Provides information about the current execution context, including the
570  * sender of the transaction and its data. While these are generally available
571  * via msg.sender and msg.data, they should not be accessed in such a direct
572  * manner, since when dealing with meta-transactions the account sending and
573  * paying for execution may not be the actual sender (as far as an application
574  * is concerned).
575  *
576  * This contract is only required for intermediate, library-like contracts.
577  */
578 abstract contract Context {
579     function _msgSender() internal view virtual returns (address) {
580         return msg.sender;
581     }
582 
583     function _msgData() internal view virtual returns (bytes calldata) {
584         return msg.data;
585     }
586 }
587 
588 // File: @openzeppelin/contracts/access/Ownable.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @dev Contract module which provides a basic access control mechanism, where
598  * there is an account (an owner) that can be granted exclusive access to
599  * specific functions.
600  *
601  * By default, the owner account will be the one that deploys the contract. This
602  * can later be changed with {transferOwnership}.
603  *
604  * This module is used through inheritance. It will make available the modifier
605  * `onlyOwner`, which can be applied to your functions to restrict their use to
606  * the owner.
607  */
608 abstract contract Ownable is Context {
609     address private _owner;
610 
611     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
612 
613     /**
614      * @dev Initializes the contract setting the deployer as the initial owner.
615      */
616     constructor() {
617         _transferOwnership(_msgSender());
618     }
619 
620     /**
621      * @dev Returns the address of the current owner.
622      */
623     function owner() public view virtual returns (address) {
624         return _owner;
625     }
626 
627     /**
628      * @dev Throws if called by any account other than the owner.
629      */
630     modifier onlyOwner() {
631         require(owner() == _msgSender(), "Ownable: caller is not the owner");
632         _;
633     }
634 
635     /**
636      * @dev Leaves the contract without owner. It will not be possible to call
637      * `onlyOwner` functions anymore. Can only be called by the current owner.
638      *
639      * NOTE: Renouncing ownership will leave the contract without an owner,
640      * thereby removing any functionality that is only available to the owner.
641      */
642     function renounceOwnership() public virtual onlyOwner {
643         _transferOwnership(address(0));
644     }
645 
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Can only be called by the current owner.
649      */
650     function transferOwnership(address newOwner) public virtual onlyOwner {
651         require(newOwner != address(0), "Ownable: new owner is the zero address");
652         _transferOwnership(newOwner);
653     }
654 
655     /**
656      * @dev Transfers ownership of the contract to a new account (`newOwner`).
657      * Internal function without access restriction.
658      */
659     function _transferOwnership(address newOwner) internal virtual {
660         address oldOwner = _owner;
661         _owner = newOwner;
662         emit OwnershipTransferred(oldOwner, newOwner);
663     }
664 }
665 
666 // File: @openzeppelin/contracts/utils/Address.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Collection of functions related to the address type
675  */
676 library Address {
677     /**
678      * @dev Returns true if `account` is a contract.
679      *
680      * [IMPORTANT]
681      * ====
682      * It is unsafe to assume that an address for which this function returns
683      * false is an externally-owned account (EOA) and not a contract.
684      *
685      * Among others, `isContract` will return false for the following
686      * types of addresses:
687      *
688      *  - an externally-owned account
689      *  - a contract in construction
690      *  - an address where a contract will be created
691      *  - an address where a contract lived, but was destroyed
692      * ====
693      */
694     function isContract(address account) internal view returns (bool) {
695         // This method relies on extcodesize, which returns 0 for contracts in
696         // construction, since the code is only stored at the end of the
697         // constructor execution.
698 
699         uint256 size;
700         assembly {
701             size := extcodesize(account)
702         }
703         return size > 0;
704     }
705 
706     /**
707      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
708      * `recipient`, forwarding all available gas and reverting on errors.
709      *
710      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
711      * of certain opcodes, possibly making contracts go over the 2300 gas limit
712      * imposed by `transfer`, making them unable to receive funds via
713      * `transfer`. {sendValue} removes this limitation.
714      *
715      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
716      *
717      * IMPORTANT: because control is transferred to `recipient`, care must be
718      * taken to not create reentrancy vulnerabilities. Consider using
719      * {ReentrancyGuard} or the
720      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
721      */
722     function sendValue(address payable recipient, uint256 amount) internal {
723         require(address(this).balance >= amount, "Address: insufficient balance");
724 
725         (bool success, ) = recipient.call{value: amount}("");
726         require(success, "Address: unable to send value, recipient may have reverted");
727     }
728 
729     /**
730      * @dev Performs a Solidity function call using a low level `call`. A
731      * plain `call` is an unsafe replacement for a function call: use this
732      * function instead.
733      *
734      * If `target` reverts with a revert reason, it is bubbled up by this
735      * function (like regular Solidity function calls).
736      *
737      * Returns the raw returned data. To convert to the expected return value,
738      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
739      *
740      * Requirements:
741      *
742      * - `target` must be a contract.
743      * - calling `target` with `data` must not revert.
744      *
745      * _Available since v3.1._
746      */
747     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
748         return functionCall(target, data, "Address: low-level call failed");
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
753      * `errorMessage` as a fallback revert reason when `target` reverts.
754      *
755      * _Available since v3.1._
756      */
757     function functionCall(
758         address target,
759         bytes memory data,
760         string memory errorMessage
761     ) internal returns (bytes memory) {
762         return functionCallWithValue(target, data, 0, errorMessage);
763     }
764 
765     /**
766      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
767      * but also transferring `value` wei to `target`.
768      *
769      * Requirements:
770      *
771      * - the calling contract must have an ETH balance of at least `value`.
772      * - the called Solidity function must be `payable`.
773      *
774      * _Available since v3.1._
775      */
776     function functionCallWithValue(
777         address target,
778         bytes memory data,
779         uint256 value
780     ) internal returns (bytes memory) {
781         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
782     }
783 
784     /**
785      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
786      * with `errorMessage` as a fallback revert reason when `target` reverts.
787      *
788      * _Available since v3.1._
789      */
790     function functionCallWithValue(
791         address target,
792         bytes memory data,
793         uint256 value,
794         string memory errorMessage
795     ) internal returns (bytes memory) {
796         require(address(this).balance >= value, "Address: insufficient balance for call");
797         require(isContract(target), "Address: call to non-contract");
798 
799         (bool success, bytes memory returndata) = target.call{value: value}(data);
800         return verifyCallResult(success, returndata, errorMessage);
801     }
802 
803     /**
804      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
805      * but performing a static call.
806      *
807      * _Available since v3.3._
808      */
809     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
810         return functionStaticCall(target, data, "Address: low-level static call failed");
811     }
812 
813     /**
814      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
815      * but performing a static call.
816      *
817      * _Available since v3.3._
818      */
819     function functionStaticCall(
820         address target,
821         bytes memory data,
822         string memory errorMessage
823     ) internal view returns (bytes memory) {
824         require(isContract(target), "Address: static call to non-contract");
825 
826         (bool success, bytes memory returndata) = target.staticcall(data);
827         return verifyCallResult(success, returndata, errorMessage);
828     }
829 
830     /**
831      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
832      * but performing a delegate call.
833      *
834      * _Available since v3.4._
835      */
836     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
837         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
838     }
839 
840     /**
841      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
842      * but performing a delegate call.
843      *
844      * _Available since v3.4._
845      */
846     function functionDelegateCall(
847         address target,
848         bytes memory data,
849         string memory errorMessage
850     ) internal returns (bytes memory) {
851         require(isContract(target), "Address: delegate call to non-contract");
852 
853         (bool success, bytes memory returndata) = target.delegatecall(data);
854         return verifyCallResult(success, returndata, errorMessage);
855     }
856 
857     /**
858      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
859      * revert reason using the provided one.
860      *
861      * _Available since v4.3._
862      */
863     function verifyCallResult(
864         bool success,
865         bytes memory returndata,
866         string memory errorMessage
867     ) internal pure returns (bytes memory) {
868         if (success) {
869             return returndata;
870         } else {
871             // Look for revert reason and bubble it up if present
872             if (returndata.length > 0) {
873                 // The easiest way to bubble the revert reason is using memory via assembly
874 
875                 assembly {
876                     let returndata_size := mload(returndata)
877                     revert(add(32, returndata), returndata_size)
878                 }
879             } else {
880                 revert(errorMessage);
881             }
882         }
883     }
884 }
885 
886 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
887 
888 
889 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 /**
894  * @title ERC721 token receiver interface
895  * @dev Interface for any contract that wants to support safeTransfers
896  * from ERC721 asset contracts.
897  */
898 interface IERC721Receiver {
899     /**
900      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
901      * by `operator` from `from`, this function is called.
902      *
903      * It must return its Solidity selector to confirm the token transfer.
904      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
905      *
906      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
907      */
908     function onERC721Received(
909         address operator,
910         address from,
911         uint256 tokenId,
912         bytes calldata data
913     ) external returns (bytes4);
914 }
915 
916 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
917 
918 
919 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
920 
921 pragma solidity ^0.8.0;
922 
923 /**
924  * @dev Interface of the ERC165 standard, as defined in the
925  * https://eips.ethereum.org/EIPS/eip-165[EIP].
926  *
927  * Implementers can declare support of contract interfaces, which can then be
928  * queried by others ({ERC165Checker}).
929  *
930  * For an implementation, see {ERC165}.
931  */
932 interface IERC165 {
933     /**
934      * @dev Returns true if this contract implements the interface defined by
935      * `interfaceId`. See the corresponding
936      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
937      * to learn more about how these ids are created.
938      *
939      * This function call must use less than 30 000 gas.
940      */
941     function supportsInterface(bytes4 interfaceId) external view returns (bool);
942 }
943 
944 // File: @openzeppelin/contracts/interfaces/IERC165.sol
945 
946 
947 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
948 
949 pragma solidity ^0.8.0;
950 
951 
952 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
953 
954 
955 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
956 
957 pragma solidity ^0.8.0;
958 
959 
960 /**
961  * @dev Interface for the NFT Royalty Standard
962  */
963 interface IERC2981 is IERC165 {
964     /**
965      * @dev Called with the sale price to determine how much royalty is owed and to whom.
966      * @param tokenId - the NFT asset queried for royalty information
967      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
968      * @return receiver - address of who should be sent the royalty payment
969      * @return royaltyAmount - the royalty payment amount for `salePrice`
970      */
971     function royaltyInfo(uint256 tokenId, uint256 salePrice)
972         external
973         view
974         returns (address receiver, uint256 royaltyAmount);
975 }
976 
977 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
978 
979 
980 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
981 
982 pragma solidity ^0.8.0;
983 
984 
985 /**
986  * @dev Implementation of the {IERC165} interface.
987  *
988  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
989  * for the additional interface id that will be supported. For example:
990  *
991  * ```solidity
992  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
993  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
994  * }
995  * ```
996  *
997  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
998  */
999 abstract contract ERC165 is IERC165 {
1000     /**
1001      * @dev See {IERC165-supportsInterface}.
1002      */
1003     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1004         return interfaceId == type(IERC165).interfaceId;
1005     }
1006 }
1007 
1008 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1009 
1010 
1011 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1012 
1013 pragma solidity ^0.8.0;
1014 
1015 
1016 /**
1017  * @dev Required interface of an ERC721 compliant contract.
1018  */
1019 interface IERC721 is IERC165 {
1020     /**
1021      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1022      */
1023     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1024 
1025     /**
1026      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1027      */
1028     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1029 
1030     /**
1031      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1032      */
1033     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1034 
1035     /**
1036      * @dev Returns the number of tokens in ``owner``'s account.
1037      */
1038     function balanceOf(address owner) external view returns (uint256 balance);
1039 
1040     /**
1041      * @dev Returns the owner of the `tokenId` token.
1042      *
1043      * Requirements:
1044      *
1045      * - `tokenId` must exist.
1046      */
1047     function ownerOf(uint256 tokenId) external view returns (address owner);
1048 
1049     /**
1050      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1051      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1052      *
1053      * Requirements:
1054      *
1055      * - `from` cannot be the zero address.
1056      * - `to` cannot be the zero address.
1057      * - `tokenId` token must exist and be owned by `from`.
1058      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1059      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function safeTransferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) external;
1068 
1069     /**
1070      * @dev Transfers `tokenId` token from `from` to `to`.
1071      *
1072      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1073      *
1074      * Requirements:
1075      *
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must be owned by `from`.
1079      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function transferFrom(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) external;
1088 
1089     /**
1090      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1091      * The approval is cleared when the token is transferred.
1092      *
1093      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1094      *
1095      * Requirements:
1096      *
1097      * - The caller must own the token or be an approved operator.
1098      * - `tokenId` must exist.
1099      *
1100      * Emits an {Approval} event.
1101      */
1102     function approve(address to, uint256 tokenId) external;
1103 
1104     /**
1105      * @dev Returns the account approved for `tokenId` token.
1106      *
1107      * Requirements:
1108      *
1109      * - `tokenId` must exist.
1110      */
1111     function getApproved(uint256 tokenId) external view returns (address operator);
1112 
1113     /**
1114      * @dev Approve or remove `operator` as an operator for the caller.
1115      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1116      *
1117      * Requirements:
1118      *
1119      * - The `operator` cannot be the caller.
1120      *
1121      * Emits an {ApprovalForAll} event.
1122      */
1123     function setApprovalForAll(address operator, bool _approved) external;
1124 
1125     /**
1126      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1127      *
1128      * See {setApprovalForAll}
1129      */
1130     function isApprovedForAll(address owner, address operator) external view returns (bool);
1131 
1132     /**
1133      * @dev Safely transfers `tokenId` token from `from` to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `from` cannot be the zero address.
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must exist and be owned by `from`.
1140      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1141      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function safeTransferFrom(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes calldata data
1150     ) external;
1151 }
1152 
1153 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1154 
1155 
1156 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 
1161 /**
1162  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1163  * @dev See https://eips.ethereum.org/EIPS/eip-721
1164  */
1165 interface IERC721Metadata is IERC721 {
1166     /**
1167      * @dev Returns the token collection name.
1168      */
1169     function name() external view returns (string memory);
1170 
1171     /**
1172      * @dev Returns the token collection symbol.
1173      */
1174     function symbol() external view returns (string memory);
1175 
1176     /**
1177      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1178      */
1179     function tokenURI(uint256 tokenId) external view returns (string memory);
1180 }
1181 
1182 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1183 
1184 
1185 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 
1191 
1192 
1193 
1194 
1195 
1196 /**
1197  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1198  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1199  * {ERC721Enumerable}.
1200  */
1201 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1202     using Address for address;
1203     using Strings for uint256;
1204 
1205     // Token name
1206     string private _name;
1207 
1208     // Token symbol
1209     string private _symbol;
1210 
1211     // Mapping from token ID to owner address
1212     mapping(uint256 => address) private _owners;
1213 
1214     // Mapping owner address to token count
1215     mapping(address => uint256) private _balances;
1216 
1217     // Mapping from token ID to approved address
1218     mapping(uint256 => address) private _tokenApprovals;
1219 
1220     // Mapping from owner to operator approvals
1221     mapping(address => mapping(address => bool)) private _operatorApprovals;
1222 
1223     /**
1224      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1225      */
1226     constructor(string memory name_, string memory symbol_) {
1227         _name = name_;
1228         _symbol = symbol_;
1229     }
1230 
1231     /**
1232      * @dev See {IERC165-supportsInterface}.
1233      */
1234     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1235         return
1236             interfaceId == type(IERC721).interfaceId ||
1237             interfaceId == type(IERC721Metadata).interfaceId ||
1238             super.supportsInterface(interfaceId);
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-balanceOf}.
1243      */
1244     function balanceOf(address owner) public view virtual override returns (uint256) {
1245         require(owner != address(0), "ERC721: balance query for the zero address");
1246         return _balances[owner];
1247     }
1248 
1249     /**
1250      * @dev See {IERC721-ownerOf}.
1251      */
1252     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1253         address owner = _owners[tokenId];
1254         require(owner != address(0), "ERC721: owner query for nonexistent token");
1255         return owner;
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Metadata-name}.
1260      */
1261     function name() public view virtual override returns (string memory) {
1262         return _name;
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Metadata-symbol}.
1267      */
1268     function symbol() public view virtual override returns (string memory) {
1269         return _symbol;
1270     }
1271 
1272     /**
1273      * @dev See {IERC721Metadata-tokenURI}.
1274      */
1275     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1276         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1277 
1278         string memory baseURI = _baseURI();
1279         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1280     }
1281 
1282     /**
1283      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1284      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1285      * by default, can be overriden in child contracts.
1286      */
1287     function _baseURI() internal view virtual returns (string memory) {
1288         return "";
1289     }
1290 
1291     /**
1292      * @dev See {IERC721-approve}.
1293      */
1294     function approve(address to, uint256 tokenId) public virtual override {
1295         address owner = ERC721.ownerOf(tokenId);
1296         require(to != owner, "ERC721: approval to current owner");
1297 
1298         require(
1299             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1300             "ERC721: approve caller is not owner nor approved for all"
1301         );
1302 
1303         _approve(to, tokenId);
1304     }
1305 
1306     /**
1307      * @dev See {IERC721-getApproved}.
1308      */
1309     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1310         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1311 
1312         return _tokenApprovals[tokenId];
1313     }
1314 
1315     /**
1316      * @dev See {IERC721-setApprovalForAll}.
1317      */
1318     function setApprovalForAll(address operator, bool approved) public virtual override {
1319         _setApprovalForAll(_msgSender(), operator, approved);
1320     }
1321 
1322     /**
1323      * @dev See {IERC721-isApprovedForAll}.
1324      */
1325     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1326         return _operatorApprovals[owner][operator];
1327     }
1328 
1329     /**
1330      * @dev See {IERC721-transferFrom}.
1331      */
1332     function transferFrom(
1333         address from,
1334         address to,
1335         uint256 tokenId
1336     ) public virtual override {
1337         //solhint-disable-next-line max-line-length
1338         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1339 
1340         _transfer(from, to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev See {IERC721-safeTransferFrom}.
1345      */
1346     function safeTransferFrom(
1347         address from,
1348         address to,
1349         uint256 tokenId
1350     ) public virtual override {
1351         safeTransferFrom(from, to, tokenId, "");
1352     }
1353 
1354     /**
1355      * @dev See {IERC721-safeTransferFrom}.
1356      */
1357     function safeTransferFrom(
1358         address from,
1359         address to,
1360         uint256 tokenId,
1361         bytes memory _data
1362     ) public virtual override {
1363         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1364         _safeTransfer(from, to, tokenId, _data);
1365     }
1366 
1367     /**
1368      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1369      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1370      *
1371      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1372      *
1373      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1374      * implement alternative mechanisms to perform token transfer, such as signature-based.
1375      *
1376      * Requirements:
1377      *
1378      * - `from` cannot be the zero address.
1379      * - `to` cannot be the zero address.
1380      * - `tokenId` token must exist and be owned by `from`.
1381      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1382      *
1383      * Emits a {Transfer} event.
1384      */
1385     function _safeTransfer(
1386         address from,
1387         address to,
1388         uint256 tokenId,
1389         bytes memory _data
1390     ) internal virtual {
1391         _transfer(from, to, tokenId);
1392         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1393     }
1394 
1395     /**
1396      * @dev Returns whether `tokenId` exists.
1397      *
1398      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1399      *
1400      * Tokens start existing when they are minted (`_mint`),
1401      * and stop existing when they are burned (`_burn`).
1402      */
1403     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1404         return _owners[tokenId] != address(0);
1405     }
1406 
1407     /**
1408      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1409      *
1410      * Requirements:
1411      *
1412      * - `tokenId` must exist.
1413      */
1414     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1415         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1416         address owner = ERC721.ownerOf(tokenId);
1417         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1418     }
1419 
1420     /**
1421      * @dev Safely mints `tokenId` and transfers it to `to`.
1422      *
1423      * Requirements:
1424      *
1425      * - `tokenId` must not exist.
1426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1427      *
1428      * Emits a {Transfer} event.
1429      */
1430     function _safeMint(address to, uint256 tokenId) internal virtual {
1431         _safeMint(to, tokenId, "");
1432     }
1433 
1434     /**
1435      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1436      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1437      */
1438     function _safeMint(
1439         address to,
1440         uint256 tokenId,
1441         bytes memory _data
1442     ) internal virtual {
1443         _mint(to, tokenId);
1444         require(
1445             _checkOnERC721Received(address(0), to, tokenId, _data),
1446             "ERC721: transfer to non ERC721Receiver implementer"
1447         );
1448     }
1449 
1450     /**
1451      * @dev Mints `tokenId` and transfers it to `to`.
1452      *
1453      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1454      *
1455      * Requirements:
1456      *
1457      * - `tokenId` must not exist.
1458      * - `to` cannot be the zero address.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _mint(address to, uint256 tokenId) internal virtual {
1463         require(to != address(0), "ERC721: mint to the zero address");
1464         require(!_exists(tokenId), "ERC721: token already minted");
1465 
1466         _beforeTokenTransfer(address(0), to, tokenId);
1467 
1468         _balances[to] += 1;
1469         _owners[tokenId] = to;
1470 
1471         emit Transfer(address(0), to, tokenId);
1472     }
1473 
1474     /**
1475      * @dev Destroys `tokenId`.
1476      * The approval is cleared when the token is burned.
1477      *
1478      * Requirements:
1479      *
1480      * - `tokenId` must exist.
1481      *
1482      * Emits a {Transfer} event.
1483      */
1484     function _burn(uint256 tokenId) internal virtual {
1485         address owner = ERC721.ownerOf(tokenId);
1486 
1487         _beforeTokenTransfer(owner, address(0), tokenId);
1488 
1489         // Clear approvals
1490         _approve(address(0), tokenId);
1491 
1492         _balances[owner] -= 1;
1493         delete _owners[tokenId];
1494 
1495         emit Transfer(owner, address(0), tokenId);
1496     }
1497 
1498     /**
1499      * @dev Transfers `tokenId` from `from` to `to`.
1500      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1501      *
1502      * Requirements:
1503      *
1504      * - `to` cannot be the zero address.
1505      * - `tokenId` token must be owned by `from`.
1506      *
1507      * Emits a {Transfer} event.
1508      */
1509     function _transfer(
1510         address from,
1511         address to,
1512         uint256 tokenId
1513     ) internal virtual {
1514         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1515         require(to != address(0), "ERC721: transfer to the zero address");
1516 
1517         _beforeTokenTransfer(from, to, tokenId);
1518 
1519         // Clear approvals from the previous owner
1520         _approve(address(0), tokenId);
1521 
1522         _balances[from] -= 1;
1523         _balances[to] += 1;
1524         _owners[tokenId] = to;
1525 
1526         emit Transfer(from, to, tokenId);
1527     }
1528 
1529     /**
1530      * @dev Approve `to` to operate on `tokenId`
1531      *
1532      * Emits a {Approval} event.
1533      */
1534     function _approve(address to, uint256 tokenId) internal virtual {
1535         _tokenApprovals[tokenId] = to;
1536         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1537     }
1538 
1539     /**
1540      * @dev Approve `operator` to operate on all of `owner` tokens
1541      *
1542      * Emits a {ApprovalForAll} event.
1543      */
1544     function _setApprovalForAll(
1545         address owner,
1546         address operator,
1547         bool approved
1548     ) internal virtual {
1549         require(owner != operator, "ERC721: approve to caller");
1550         _operatorApprovals[owner][operator] = approved;
1551         emit ApprovalForAll(owner, operator, approved);
1552     }
1553 
1554     /**
1555      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1556      * The call is not executed if the target address is not a contract.
1557      *
1558      * @param from address representing the previous owner of the given token ID
1559      * @param to target address that will receive the tokens
1560      * @param tokenId uint256 ID of the token to be transferred
1561      * @param _data bytes optional data to send along with the call
1562      * @return bool whether the call correctly returned the expected magic value
1563      */
1564     function _checkOnERC721Received(
1565         address from,
1566         address to,
1567         uint256 tokenId,
1568         bytes memory _data
1569     ) private returns (bool) {
1570         if (to.isContract()) {
1571             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1572                 return retval == IERC721Receiver.onERC721Received.selector;
1573             } catch (bytes memory reason) {
1574                 if (reason.length == 0) {
1575                     revert("ERC721: transfer to non ERC721Receiver implementer");
1576                 } else {
1577                     assembly {
1578                         revert(add(32, reason), mload(reason))
1579                     }
1580                 }
1581             }
1582         } else {
1583             return true;
1584         }
1585     }
1586 
1587     /**
1588      * @dev Hook that is called before any token transfer. This includes minting
1589      * and burning.
1590      *
1591      * Calling conditions:
1592      *
1593      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1594      * transferred to `to`.
1595      * - When `from` is zero, `tokenId` will be minted for `to`.
1596      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1597      * - `from` and `to` are never both zero.
1598      *
1599      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1600      */
1601     function _beforeTokenTransfer(
1602         address from,
1603         address to,
1604         uint256 tokenId
1605     ) internal virtual {}
1606 }
1607 
1608 // File: hardhat/console.sol
1609 
1610 
1611 pragma solidity >= 0.4.22 <0.9.0;
1612 
1613 library console {
1614 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1615 
1616 	function _sendLogPayload(bytes memory payload) private view {
1617 		uint256 payloadLength = payload.length;
1618 		address consoleAddress = CONSOLE_ADDRESS;
1619 		assembly {
1620 			let payloadStart := add(payload, 32)
1621 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1622 		}
1623 	}
1624 
1625 	function log() internal view {
1626 		_sendLogPayload(abi.encodeWithSignature("log()"));
1627 	}
1628 
1629 	function logInt(int p0) internal view {
1630 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1631 	}
1632 
1633 	function logUint(uint p0) internal view {
1634 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1635 	}
1636 
1637 	function logString(string memory p0) internal view {
1638 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1639 	}
1640 
1641 	function logBool(bool p0) internal view {
1642 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1643 	}
1644 
1645 	function logAddress(address p0) internal view {
1646 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1647 	}
1648 
1649 	function logBytes(bytes memory p0) internal view {
1650 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1651 	}
1652 
1653 	function logBytes1(bytes1 p0) internal view {
1654 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1655 	}
1656 
1657 	function logBytes2(bytes2 p0) internal view {
1658 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1659 	}
1660 
1661 	function logBytes3(bytes3 p0) internal view {
1662 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1663 	}
1664 
1665 	function logBytes4(bytes4 p0) internal view {
1666 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1667 	}
1668 
1669 	function logBytes5(bytes5 p0) internal view {
1670 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1671 	}
1672 
1673 	function logBytes6(bytes6 p0) internal view {
1674 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1675 	}
1676 
1677 	function logBytes7(bytes7 p0) internal view {
1678 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1679 	}
1680 
1681 	function logBytes8(bytes8 p0) internal view {
1682 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1683 	}
1684 
1685 	function logBytes9(bytes9 p0) internal view {
1686 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1687 	}
1688 
1689 	function logBytes10(bytes10 p0) internal view {
1690 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1691 	}
1692 
1693 	function logBytes11(bytes11 p0) internal view {
1694 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1695 	}
1696 
1697 	function logBytes12(bytes12 p0) internal view {
1698 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1699 	}
1700 
1701 	function logBytes13(bytes13 p0) internal view {
1702 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1703 	}
1704 
1705 	function logBytes14(bytes14 p0) internal view {
1706 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1707 	}
1708 
1709 	function logBytes15(bytes15 p0) internal view {
1710 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1711 	}
1712 
1713 	function logBytes16(bytes16 p0) internal view {
1714 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1715 	}
1716 
1717 	function logBytes17(bytes17 p0) internal view {
1718 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1719 	}
1720 
1721 	function logBytes18(bytes18 p0) internal view {
1722 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1723 	}
1724 
1725 	function logBytes19(bytes19 p0) internal view {
1726 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1727 	}
1728 
1729 	function logBytes20(bytes20 p0) internal view {
1730 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1731 	}
1732 
1733 	function logBytes21(bytes21 p0) internal view {
1734 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1735 	}
1736 
1737 	function logBytes22(bytes22 p0) internal view {
1738 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1739 	}
1740 
1741 	function logBytes23(bytes23 p0) internal view {
1742 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1743 	}
1744 
1745 	function logBytes24(bytes24 p0) internal view {
1746 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1747 	}
1748 
1749 	function logBytes25(bytes25 p0) internal view {
1750 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1751 	}
1752 
1753 	function logBytes26(bytes26 p0) internal view {
1754 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1755 	}
1756 
1757 	function logBytes27(bytes27 p0) internal view {
1758 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1759 	}
1760 
1761 	function logBytes28(bytes28 p0) internal view {
1762 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1763 	}
1764 
1765 	function logBytes29(bytes29 p0) internal view {
1766 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1767 	}
1768 
1769 	function logBytes30(bytes30 p0) internal view {
1770 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1771 	}
1772 
1773 	function logBytes31(bytes31 p0) internal view {
1774 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1775 	}
1776 
1777 	function logBytes32(bytes32 p0) internal view {
1778 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1779 	}
1780 
1781 	function log(uint p0) internal view {
1782 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1783 	}
1784 
1785 	function log(string memory p0) internal view {
1786 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1787 	}
1788 
1789 	function log(bool p0) internal view {
1790 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1791 	}
1792 
1793 	function log(address p0) internal view {
1794 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1795 	}
1796 
1797 	function log(uint p0, uint p1) internal view {
1798 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1799 	}
1800 
1801 	function log(uint p0, string memory p1) internal view {
1802 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1803 	}
1804 
1805 	function log(uint p0, bool p1) internal view {
1806 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1807 	}
1808 
1809 	function log(uint p0, address p1) internal view {
1810 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1811 	}
1812 
1813 	function log(string memory p0, uint p1) internal view {
1814 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1815 	}
1816 
1817 	function log(string memory p0, string memory p1) internal view {
1818 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1819 	}
1820 
1821 	function log(string memory p0, bool p1) internal view {
1822 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1823 	}
1824 
1825 	function log(string memory p0, address p1) internal view {
1826 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1827 	}
1828 
1829 	function log(bool p0, uint p1) internal view {
1830 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1831 	}
1832 
1833 	function log(bool p0, string memory p1) internal view {
1834 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1835 	}
1836 
1837 	function log(bool p0, bool p1) internal view {
1838 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1839 	}
1840 
1841 	function log(bool p0, address p1) internal view {
1842 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1843 	}
1844 
1845 	function log(address p0, uint p1) internal view {
1846 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1847 	}
1848 
1849 	function log(address p0, string memory p1) internal view {
1850 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1851 	}
1852 
1853 	function log(address p0, bool p1) internal view {
1854 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1855 	}
1856 
1857 	function log(address p0, address p1) internal view {
1858 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1859 	}
1860 
1861 	function log(uint p0, uint p1, uint p2) internal view {
1862 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1863 	}
1864 
1865 	function log(uint p0, uint p1, string memory p2) internal view {
1866 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1867 	}
1868 
1869 	function log(uint p0, uint p1, bool p2) internal view {
1870 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1871 	}
1872 
1873 	function log(uint p0, uint p1, address p2) internal view {
1874 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1875 	}
1876 
1877 	function log(uint p0, string memory p1, uint p2) internal view {
1878 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1879 	}
1880 
1881 	function log(uint p0, string memory p1, string memory p2) internal view {
1882 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1883 	}
1884 
1885 	function log(uint p0, string memory p1, bool p2) internal view {
1886 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1887 	}
1888 
1889 	function log(uint p0, string memory p1, address p2) internal view {
1890 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1891 	}
1892 
1893 	function log(uint p0, bool p1, uint p2) internal view {
1894 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1895 	}
1896 
1897 	function log(uint p0, bool p1, string memory p2) internal view {
1898 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1899 	}
1900 
1901 	function log(uint p0, bool p1, bool p2) internal view {
1902 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1903 	}
1904 
1905 	function log(uint p0, bool p1, address p2) internal view {
1906 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1907 	}
1908 
1909 	function log(uint p0, address p1, uint p2) internal view {
1910 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1911 	}
1912 
1913 	function log(uint p0, address p1, string memory p2) internal view {
1914 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1915 	}
1916 
1917 	function log(uint p0, address p1, bool p2) internal view {
1918 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1919 	}
1920 
1921 	function log(uint p0, address p1, address p2) internal view {
1922 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1923 	}
1924 
1925 	function log(string memory p0, uint p1, uint p2) internal view {
1926 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1927 	}
1928 
1929 	function log(string memory p0, uint p1, string memory p2) internal view {
1930 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1931 	}
1932 
1933 	function log(string memory p0, uint p1, bool p2) internal view {
1934 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1935 	}
1936 
1937 	function log(string memory p0, uint p1, address p2) internal view {
1938 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1939 	}
1940 
1941 	function log(string memory p0, string memory p1, uint p2) internal view {
1942 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1943 	}
1944 
1945 	function log(string memory p0, string memory p1, string memory p2) internal view {
1946 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1947 	}
1948 
1949 	function log(string memory p0, string memory p1, bool p2) internal view {
1950 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1951 	}
1952 
1953 	function log(string memory p0, string memory p1, address p2) internal view {
1954 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1955 	}
1956 
1957 	function log(string memory p0, bool p1, uint p2) internal view {
1958 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1959 	}
1960 
1961 	function log(string memory p0, bool p1, string memory p2) internal view {
1962 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1963 	}
1964 
1965 	function log(string memory p0, bool p1, bool p2) internal view {
1966 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1967 	}
1968 
1969 	function log(string memory p0, bool p1, address p2) internal view {
1970 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1971 	}
1972 
1973 	function log(string memory p0, address p1, uint p2) internal view {
1974 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1975 	}
1976 
1977 	function log(string memory p0, address p1, string memory p2) internal view {
1978 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1979 	}
1980 
1981 	function log(string memory p0, address p1, bool p2) internal view {
1982 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1983 	}
1984 
1985 	function log(string memory p0, address p1, address p2) internal view {
1986 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1987 	}
1988 
1989 	function log(bool p0, uint p1, uint p2) internal view {
1990 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1991 	}
1992 
1993 	function log(bool p0, uint p1, string memory p2) internal view {
1994 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1995 	}
1996 
1997 	function log(bool p0, uint p1, bool p2) internal view {
1998 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1999 	}
2000 
2001 	function log(bool p0, uint p1, address p2) internal view {
2002 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
2003 	}
2004 
2005 	function log(bool p0, string memory p1, uint p2) internal view {
2006 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
2007 	}
2008 
2009 	function log(bool p0, string memory p1, string memory p2) internal view {
2010 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
2011 	}
2012 
2013 	function log(bool p0, string memory p1, bool p2) internal view {
2014 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
2015 	}
2016 
2017 	function log(bool p0, string memory p1, address p2) internal view {
2018 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
2019 	}
2020 
2021 	function log(bool p0, bool p1, uint p2) internal view {
2022 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
2023 	}
2024 
2025 	function log(bool p0, bool p1, string memory p2) internal view {
2026 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
2027 	}
2028 
2029 	function log(bool p0, bool p1, bool p2) internal view {
2030 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
2031 	}
2032 
2033 	function log(bool p0, bool p1, address p2) internal view {
2034 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
2035 	}
2036 
2037 	function log(bool p0, address p1, uint p2) internal view {
2038 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
2039 	}
2040 
2041 	function log(bool p0, address p1, string memory p2) internal view {
2042 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
2043 	}
2044 
2045 	function log(bool p0, address p1, bool p2) internal view {
2046 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
2047 	}
2048 
2049 	function log(bool p0, address p1, address p2) internal view {
2050 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
2051 	}
2052 
2053 	function log(address p0, uint p1, uint p2) internal view {
2054 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
2055 	}
2056 
2057 	function log(address p0, uint p1, string memory p2) internal view {
2058 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
2059 	}
2060 
2061 	function log(address p0, uint p1, bool p2) internal view {
2062 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
2063 	}
2064 
2065 	function log(address p0, uint p1, address p2) internal view {
2066 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
2067 	}
2068 
2069 	function log(address p0, string memory p1, uint p2) internal view {
2070 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
2071 	}
2072 
2073 	function log(address p0, string memory p1, string memory p2) internal view {
2074 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
2075 	}
2076 
2077 	function log(address p0, string memory p1, bool p2) internal view {
2078 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
2079 	}
2080 
2081 	function log(address p0, string memory p1, address p2) internal view {
2082 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
2083 	}
2084 
2085 	function log(address p0, bool p1, uint p2) internal view {
2086 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
2087 	}
2088 
2089 	function log(address p0, bool p1, string memory p2) internal view {
2090 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2091 	}
2092 
2093 	function log(address p0, bool p1, bool p2) internal view {
2094 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2095 	}
2096 
2097 	function log(address p0, bool p1, address p2) internal view {
2098 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2099 	}
2100 
2101 	function log(address p0, address p1, uint p2) internal view {
2102 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
2103 	}
2104 
2105 	function log(address p0, address p1, string memory p2) internal view {
2106 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2107 	}
2108 
2109 	function log(address p0, address p1, bool p2) internal view {
2110 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2111 	}
2112 
2113 	function log(address p0, address p1, address p2) internal view {
2114 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2115 	}
2116 
2117 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
2118 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
2119 	}
2120 
2121 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2122 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2123 	}
2124 
2125 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2126 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2127 	}
2128 
2129 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2130 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2131 	}
2132 
2133 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2134 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2135 	}
2136 
2137 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2138 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2139 	}
2140 
2141 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2142 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2143 	}
2144 
2145 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2146 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2147 	}
2148 
2149 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2150 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2151 	}
2152 
2153 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2154 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2155 	}
2156 
2157 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2158 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2159 	}
2160 
2161 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2162 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2163 	}
2164 
2165 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2166 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2167 	}
2168 
2169 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2170 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2171 	}
2172 
2173 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2174 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2175 	}
2176 
2177 	function log(uint p0, uint p1, address p2, address p3) internal view {
2178 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2179 	}
2180 
2181 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2182 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2183 	}
2184 
2185 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2186 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2187 	}
2188 
2189 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2190 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2191 	}
2192 
2193 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2194 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2195 	}
2196 
2197 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2198 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2199 	}
2200 
2201 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2202 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2203 	}
2204 
2205 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2206 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2207 	}
2208 
2209 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2210 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2211 	}
2212 
2213 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2214 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2215 	}
2216 
2217 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2218 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2219 	}
2220 
2221 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2222 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2223 	}
2224 
2225 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2226 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2227 	}
2228 
2229 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2230 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2231 	}
2232 
2233 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2234 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2235 	}
2236 
2237 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2238 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2239 	}
2240 
2241 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2242 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2243 	}
2244 
2245 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2246 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2247 	}
2248 
2249 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2250 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2251 	}
2252 
2253 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2254 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2255 	}
2256 
2257 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2258 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2259 	}
2260 
2261 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2262 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2263 	}
2264 
2265 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2266 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2267 	}
2268 
2269 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2270 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2271 	}
2272 
2273 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2274 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2275 	}
2276 
2277 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2278 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2279 	}
2280 
2281 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2282 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2283 	}
2284 
2285 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2286 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2287 	}
2288 
2289 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2290 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2291 	}
2292 
2293 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2294 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2295 	}
2296 
2297 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2298 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2299 	}
2300 
2301 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2302 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2303 	}
2304 
2305 	function log(uint p0, bool p1, address p2, address p3) internal view {
2306 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2307 	}
2308 
2309 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2310 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2311 	}
2312 
2313 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2314 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2315 	}
2316 
2317 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2318 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2319 	}
2320 
2321 	function log(uint p0, address p1, uint p2, address p3) internal view {
2322 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2323 	}
2324 
2325 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2326 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2327 	}
2328 
2329 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2330 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2331 	}
2332 
2333 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2334 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2335 	}
2336 
2337 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2338 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2339 	}
2340 
2341 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2342 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2343 	}
2344 
2345 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2346 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2347 	}
2348 
2349 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2350 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2351 	}
2352 
2353 	function log(uint p0, address p1, bool p2, address p3) internal view {
2354 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2355 	}
2356 
2357 	function log(uint p0, address p1, address p2, uint p3) internal view {
2358 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2359 	}
2360 
2361 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2362 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2363 	}
2364 
2365 	function log(uint p0, address p1, address p2, bool p3) internal view {
2366 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2367 	}
2368 
2369 	function log(uint p0, address p1, address p2, address p3) internal view {
2370 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2371 	}
2372 
2373 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2374 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2375 	}
2376 
2377 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2378 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2379 	}
2380 
2381 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2382 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2383 	}
2384 
2385 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2386 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2387 	}
2388 
2389 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2390 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2391 	}
2392 
2393 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2394 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2395 	}
2396 
2397 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2398 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2399 	}
2400 
2401 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2402 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2403 	}
2404 
2405 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2406 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2407 	}
2408 
2409 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2410 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2411 	}
2412 
2413 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2414 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2415 	}
2416 
2417 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2418 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2419 	}
2420 
2421 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2422 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2423 	}
2424 
2425 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2426 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2427 	}
2428 
2429 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2430 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2431 	}
2432 
2433 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2434 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2435 	}
2436 
2437 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2438 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2439 	}
2440 
2441 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2442 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2443 	}
2444 
2445 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2446 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2447 	}
2448 
2449 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2450 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2451 	}
2452 
2453 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2454 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2455 	}
2456 
2457 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2458 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2459 	}
2460 
2461 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2462 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2463 	}
2464 
2465 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2466 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2467 	}
2468 
2469 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2470 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2471 	}
2472 
2473 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2474 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2475 	}
2476 
2477 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2478 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2479 	}
2480 
2481 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2482 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2483 	}
2484 
2485 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2486 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2487 	}
2488 
2489 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2490 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2491 	}
2492 
2493 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2494 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2495 	}
2496 
2497 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2498 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2499 	}
2500 
2501 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2502 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2503 	}
2504 
2505 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2506 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2507 	}
2508 
2509 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2510 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2511 	}
2512 
2513 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2514 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2515 	}
2516 
2517 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2518 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2519 	}
2520 
2521 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2522 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2523 	}
2524 
2525 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2526 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2527 	}
2528 
2529 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2530 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2531 	}
2532 
2533 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2534 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2535 	}
2536 
2537 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2538 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2539 	}
2540 
2541 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2542 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2543 	}
2544 
2545 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2546 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2547 	}
2548 
2549 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2550 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2551 	}
2552 
2553 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2554 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2555 	}
2556 
2557 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2558 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2559 	}
2560 
2561 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2562 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2563 	}
2564 
2565 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2566 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2567 	}
2568 
2569 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2570 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2571 	}
2572 
2573 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2574 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2575 	}
2576 
2577 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2578 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2579 	}
2580 
2581 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2582 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2583 	}
2584 
2585 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2586 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2587 	}
2588 
2589 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2590 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2591 	}
2592 
2593 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2594 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2595 	}
2596 
2597 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2598 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2599 	}
2600 
2601 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2602 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2603 	}
2604 
2605 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2606 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2607 	}
2608 
2609 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2610 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2611 	}
2612 
2613 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2614 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2615 	}
2616 
2617 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2618 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2619 	}
2620 
2621 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2622 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2623 	}
2624 
2625 	function log(string memory p0, address p1, address p2, address p3) internal view {
2626 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2627 	}
2628 
2629 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2630 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2631 	}
2632 
2633 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2634 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2635 	}
2636 
2637 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2638 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2639 	}
2640 
2641 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2642 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2643 	}
2644 
2645 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2646 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2647 	}
2648 
2649 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2650 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2651 	}
2652 
2653 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2654 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2655 	}
2656 
2657 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2658 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2659 	}
2660 
2661 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2662 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2663 	}
2664 
2665 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2666 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2667 	}
2668 
2669 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2670 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2671 	}
2672 
2673 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2674 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2675 	}
2676 
2677 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2678 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2679 	}
2680 
2681 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2682 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2683 	}
2684 
2685 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2686 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2687 	}
2688 
2689 	function log(bool p0, uint p1, address p2, address p3) internal view {
2690 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2691 	}
2692 
2693 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2694 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2695 	}
2696 
2697 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2698 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2699 	}
2700 
2701 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2702 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2703 	}
2704 
2705 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2706 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2707 	}
2708 
2709 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2710 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2711 	}
2712 
2713 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2714 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2715 	}
2716 
2717 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2718 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2719 	}
2720 
2721 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2722 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2723 	}
2724 
2725 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2726 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2727 	}
2728 
2729 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2730 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2731 	}
2732 
2733 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2734 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2735 	}
2736 
2737 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2738 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2739 	}
2740 
2741 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2742 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2743 	}
2744 
2745 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2746 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2747 	}
2748 
2749 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2750 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2751 	}
2752 
2753 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2754 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2755 	}
2756 
2757 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2758 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2759 	}
2760 
2761 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2762 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2763 	}
2764 
2765 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2766 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2767 	}
2768 
2769 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2770 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2771 	}
2772 
2773 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2774 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2775 	}
2776 
2777 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2778 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2779 	}
2780 
2781 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2782 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2783 	}
2784 
2785 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2786 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2787 	}
2788 
2789 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2790 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2791 	}
2792 
2793 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2794 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2795 	}
2796 
2797 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2798 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2799 	}
2800 
2801 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2802 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2803 	}
2804 
2805 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2806 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2807 	}
2808 
2809 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2810 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2811 	}
2812 
2813 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2814 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2815 	}
2816 
2817 	function log(bool p0, bool p1, address p2, address p3) internal view {
2818 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2819 	}
2820 
2821 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2822 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2823 	}
2824 
2825 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2826 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2827 	}
2828 
2829 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2830 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2831 	}
2832 
2833 	function log(bool p0, address p1, uint p2, address p3) internal view {
2834 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2835 	}
2836 
2837 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2838 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2839 	}
2840 
2841 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2842 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2843 	}
2844 
2845 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2846 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2847 	}
2848 
2849 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2850 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2851 	}
2852 
2853 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2854 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2855 	}
2856 
2857 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2858 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2859 	}
2860 
2861 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2862 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2863 	}
2864 
2865 	function log(bool p0, address p1, bool p2, address p3) internal view {
2866 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2867 	}
2868 
2869 	function log(bool p0, address p1, address p2, uint p3) internal view {
2870 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2871 	}
2872 
2873 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2874 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2875 	}
2876 
2877 	function log(bool p0, address p1, address p2, bool p3) internal view {
2878 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2879 	}
2880 
2881 	function log(bool p0, address p1, address p2, address p3) internal view {
2882 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2883 	}
2884 
2885 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2886 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2887 	}
2888 
2889 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2890 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2891 	}
2892 
2893 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2894 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2895 	}
2896 
2897 	function log(address p0, uint p1, uint p2, address p3) internal view {
2898 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2899 	}
2900 
2901 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2902 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2903 	}
2904 
2905 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2906 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2907 	}
2908 
2909 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2910 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2911 	}
2912 
2913 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2914 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2915 	}
2916 
2917 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2918 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2919 	}
2920 
2921 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2922 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2923 	}
2924 
2925 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2926 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2927 	}
2928 
2929 	function log(address p0, uint p1, bool p2, address p3) internal view {
2930 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2931 	}
2932 
2933 	function log(address p0, uint p1, address p2, uint p3) internal view {
2934 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2935 	}
2936 
2937 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2938 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2939 	}
2940 
2941 	function log(address p0, uint p1, address p2, bool p3) internal view {
2942 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2943 	}
2944 
2945 	function log(address p0, uint p1, address p2, address p3) internal view {
2946 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2947 	}
2948 
2949 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2950 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2951 	}
2952 
2953 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2954 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2955 	}
2956 
2957 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2958 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2959 	}
2960 
2961 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2962 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2963 	}
2964 
2965 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2966 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2967 	}
2968 
2969 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2970 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2971 	}
2972 
2973 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2974 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2975 	}
2976 
2977 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2978 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2979 	}
2980 
2981 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2982 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2983 	}
2984 
2985 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2986 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2987 	}
2988 
2989 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2990 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2991 	}
2992 
2993 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2994 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2995 	}
2996 
2997 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2998 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2999 	}
3000 
3001 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
3002 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
3003 	}
3004 
3005 	function log(address p0, string memory p1, address p2, bool p3) internal view {
3006 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
3007 	}
3008 
3009 	function log(address p0, string memory p1, address p2, address p3) internal view {
3010 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
3011 	}
3012 
3013 	function log(address p0, bool p1, uint p2, uint p3) internal view {
3014 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
3015 	}
3016 
3017 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
3018 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
3019 	}
3020 
3021 	function log(address p0, bool p1, uint p2, bool p3) internal view {
3022 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
3023 	}
3024 
3025 	function log(address p0, bool p1, uint p2, address p3) internal view {
3026 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
3027 	}
3028 
3029 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
3030 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
3031 	}
3032 
3033 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
3034 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
3035 	}
3036 
3037 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
3038 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
3039 	}
3040 
3041 	function log(address p0, bool p1, string memory p2, address p3) internal view {
3042 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
3043 	}
3044 
3045 	function log(address p0, bool p1, bool p2, uint p3) internal view {
3046 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
3047 	}
3048 
3049 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
3050 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
3051 	}
3052 
3053 	function log(address p0, bool p1, bool p2, bool p3) internal view {
3054 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
3055 	}
3056 
3057 	function log(address p0, bool p1, bool p2, address p3) internal view {
3058 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
3059 	}
3060 
3061 	function log(address p0, bool p1, address p2, uint p3) internal view {
3062 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
3063 	}
3064 
3065 	function log(address p0, bool p1, address p2, string memory p3) internal view {
3066 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
3067 	}
3068 
3069 	function log(address p0, bool p1, address p2, bool p3) internal view {
3070 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
3071 	}
3072 
3073 	function log(address p0, bool p1, address p2, address p3) internal view {
3074 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
3075 	}
3076 
3077 	function log(address p0, address p1, uint p2, uint p3) internal view {
3078 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
3079 	}
3080 
3081 	function log(address p0, address p1, uint p2, string memory p3) internal view {
3082 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
3083 	}
3084 
3085 	function log(address p0, address p1, uint p2, bool p3) internal view {
3086 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
3087 	}
3088 
3089 	function log(address p0, address p1, uint p2, address p3) internal view {
3090 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
3091 	}
3092 
3093 	function log(address p0, address p1, string memory p2, uint p3) internal view {
3094 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
3095 	}
3096 
3097 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3098 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3099 	}
3100 
3101 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3102 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3103 	}
3104 
3105 	function log(address p0, address p1, string memory p2, address p3) internal view {
3106 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3107 	}
3108 
3109 	function log(address p0, address p1, bool p2, uint p3) internal view {
3110 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
3111 	}
3112 
3113 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3114 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3115 	}
3116 
3117 	function log(address p0, address p1, bool p2, bool p3) internal view {
3118 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3119 	}
3120 
3121 	function log(address p0, address p1, bool p2, address p3) internal view {
3122 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3123 	}
3124 
3125 	function log(address p0, address p1, address p2, uint p3) internal view {
3126 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3127 	}
3128 
3129 	function log(address p0, address p1, address p2, string memory p3) internal view {
3130 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3131 	}
3132 
3133 	function log(address p0, address p1, address p2, bool p3) internal view {
3134 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3135 	}
3136 
3137 	function log(address p0, address p1, address p2, address p3) internal view {
3138 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3139 	}
3140 
3141 }
3142 
3143 // File: metamoguls.sol
3144 
3145 //SPDX-License-Identifier: MIT
3146 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
3147 
3148 pragma solidity ^0.8.0;
3149 
3150 
3151 
3152 
3153 
3154 
3155 
3156 
3157 
3158 
3159 
3160 contract MetaMoguls is ERC721, IERC2981, Ownable, ReentrancyGuard {
3161     using Counters for Counters.Counter;
3162     using Strings for uint256;
3163 
3164     Counters.Counter private tokenCounter;
3165 
3166     string private baseURI;
3167     string public verificationHash;
3168     //address public openSeaProxyRegistryAddress;
3169     /*bool private isOpenSeaProxyActive = true;*/
3170 
3171     uint256 public MAX_NFTs_PER_WALLET = 10; //removed constant and added set function
3172     uint256 public maxNFTs;
3173 
3174     uint256 public PUBLIC_SALE_PRICE = 0.06 ether; //removed constant and added set function
3175     bool public isPublicSaleActive;
3176 
3177     uint256 public ALLOW_LIST_SALE_PRICE = 0.05 ether; //removed constant and added set function
3178     uint256 public maxAllowListSaleNFTs;
3179     bytes32 public allowListSaleMerkleRoot = 0xa7b3433ed25e71fffc4a706fd54565cc745a603b997ed359114fc405bb57a950;
3180     bool public isAllowListSaleActive;
3181     bool public REVEAL;
3182 
3183     uint256 public maxGiftedNFTs;
3184     uint256 public numGiftedNFTs;
3185     bytes32 public claimListMerkleRoot;
3186 
3187     mapping(address => uint256) public allowListMintCounts;
3188     mapping(address => bool) public claimed;
3189 
3190     // ============ ACCESS CONTROL/Function MODIFIERS ============
3191 
3192     modifier publicSaleActive() {
3193         require(isPublicSaleActive, "Public sale is not open");
3194         _;
3195     }
3196 
3197     modifier allowListSaleActive() {
3198         require(isAllowListSaleActive, "Allow list sale is not open");
3199         _;
3200     }
3201 
3202     modifier maxNFTsPerWallet(uint256 numberOfTokens) {
3203         require(
3204             balanceOf(msg.sender) + numberOfTokens <= MAX_NFTs_PER_WALLET,
3205             "Max NFTs to mint is ten"
3206         );
3207         _;
3208     }
3209 
3210     modifier canMintNFTs(uint256 numberOfTokens) {
3211         require(
3212             tokenCounter.current() + numberOfTokens <=
3213                 maxNFTs - maxGiftedNFTs,
3214             "Not enough NFTs remaining to mint"
3215         );
3216         _;
3217     }
3218 
3219     modifier canGiftNFTs(uint256 num) {
3220         require(
3221             numGiftedNFTs + num <= maxGiftedNFTs,
3222             "Not enough NFTs remaining to gift"
3223         );
3224         require(
3225             tokenCounter.current() + num <= maxNFTs,
3226             "Not enough NFTs remaining to mint"
3227         );
3228         _;
3229     }
3230 
3231     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
3232         require(
3233             price * numberOfTokens == msg.value,
3234             "Incorrect ETH value sent"
3235         );
3236         _;
3237     }
3238 
3239     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
3240         require(
3241             MerkleProof.verify(
3242                 merkleProof,
3243                 root,
3244                 keccak256(abi.encodePacked(msg.sender))
3245             ),
3246             "Address does not exist in list"
3247         );
3248         _;
3249     }
3250 
3251     constructor(
3252         /*address _openSeaProxyRegistryAddress,*/
3253         uint256 _maxNFTs1,
3254         uint256 _maxAllowListSaleNFTs,
3255         uint256 _maxGiftedNFTs,
3256 	    string memory _baseURI, 
3257 	    bool _isPublicSaleActive,
3258 	    bool _isAllowListSaleActive, 
3259         bool _REVEAL
3260     ) ERC721("Meta Moguls", "MOGUL") {
3261         /*openSeaProxyRegistryAddress = _openSeaProxyRegistryAddress;*/
3262         maxNFTs = _maxNFTs1;
3263         maxAllowListSaleNFTs = _maxAllowListSaleNFTs;
3264         maxGiftedNFTs = _maxGiftedNFTs;
3265         baseURI = _baseURI;
3266         REVEAL = _REVEAL;
3267 	isPublicSaleActive = _isPublicSaleActive;
3268 	isAllowListSaleActive = _isAllowListSaleActive;
3269     }
3270          
3271     
3272 
3273     // ============ PUBLIC FUNCTIONS FOR MINTING ============
3274 
3275     function mint(uint256 numberOfTokens)
3276         external
3277         payable
3278         nonReentrant
3279         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
3280         publicSaleActive
3281         canMintNFTs(numberOfTokens)
3282         maxNFTsPerWallet(numberOfTokens)
3283     {
3284         for (uint256 i = 0; i < numberOfTokens; i++) {
3285             _safeMint(msg.sender, nextTokenId());
3286         }
3287     }
3288 
3289     function mintAllowListSale(
3290         uint8 numberOfTokens,
3291         bytes32[] calldata merkleProof
3292     )
3293         external
3294         payable
3295         nonReentrant
3296         allowListSaleActive
3297         canMintNFTs(numberOfTokens)
3298         isCorrectPayment(ALLOW_LIST_SALE_PRICE, numberOfTokens)
3299         isValidMerkleProof(merkleProof, allowListSaleMerkleRoot)
3300     {
3301         uint256 numAlreadyMinted = allowListMintCounts[msg.sender];
3302 
3303         require(
3304             numAlreadyMinted + numberOfTokens <= MAX_NFTs_PER_WALLET,
3305             "Max NFTs to mint in allow list sale is ten"
3306         );
3307 
3308         require(
3309             tokenCounter.current() + numberOfTokens <= maxAllowListSaleNFTs,
3310             "Not enough NFTs remaining to mint"
3311         );
3312 
3313         allowListMintCounts[msg.sender] = numAlreadyMinted + numberOfTokens;
3314 
3315         for (uint256 i = 0; i < numberOfTokens; i++) {
3316             _safeMint(msg.sender, nextTokenId());
3317         }
3318     }
3319 
3320     function claim(bytes32[] calldata merkleProof)
3321         external
3322         isValidMerkleProof(merkleProof, claimListMerkleRoot)
3323         canGiftNFTs(1)
3324     {
3325         require(!claimed[msg.sender], "NFT already claimed by this wallet");
3326 
3327         claimed[msg.sender] = true;
3328         numGiftedNFTs += 1;
3329 
3330         _safeMint(msg.sender, nextTokenId());
3331     }
3332 
3333     // ============ PUBLIC READ-ONLY FUNCTIONS ============
3334 
3335     function getBaseURI() external view returns (string memory) {
3336         return baseURI;
3337     }
3338 
3339     function getLastTokenId() external view returns (uint256) {
3340         return tokenCounter.current();
3341     }
3342 
3343     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
3344 
3345     function setBaseURI(string memory _baseURI1) external onlyOwner {
3346         baseURI = _baseURI1;
3347     }
3348 
3349     
3350     
3351     function setMaxNFTsInTOTALCollection(uint256 _maxNFTs2) external onlyOwner {
3352         maxNFTs = _maxNFTs2;
3353     }
3354     
3355     function setMaxAllowListSaleNFTs(uint256 _maxAllowListSaleNFTs) external onlyOwner {
3356         maxAllowListSaleNFTs = _maxAllowListSaleNFTs;
3357     }
3358     
3359     function setMaxGiftedNFTs(uint256 _maxGiftedNFTs) external onlyOwner {
3360         maxGiftedNFTs = _maxGiftedNFTs;
3361     }
3362     
3363     function setMAX_NFTs_PER_WALLET(uint256 _MAX_NFTs_PER_WALLET) external onlyOwner {
3364         MAX_NFTs_PER_WALLET = _MAX_NFTs_PER_WALLET;
3365     }
3366 	
3367     function setPUBLIC_SALE_PRICEinEther(uint256 _PUBLIC_SALE_PRICE) external onlyOwner {
3368         PUBLIC_SALE_PRICE = _PUBLIC_SALE_PRICE;
3369     }
3370     
3371     function setALLOW_LIST_SALE_PRICEinEther(uint256 _ALLOW_LIST_SALE_PRICE) external onlyOwner {
3372         ALLOW_LIST_SALE_PRICE = _ALLOW_LIST_SALE_PRICE;
3373     }
3374 
3375 
3376     // function to disable gasless listings for security in case
3377     // opensea ever shuts down or is compromised
3378     /*function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
3379         external
3380         onlyOwner
3381     {
3382         isOpenSeaProxyActive = _isOpenSeaProxyActive;
3383     }*/
3384 
3385     function setVerificationHash(string memory _verificationHash)
3386         external
3387         onlyOwner
3388     {
3389         verificationHash = _verificationHash;
3390     }
3391 
3392     function setIsPublicSaleActive(bool _isPublicSaleActive)
3393         external
3394         onlyOwner
3395     {
3396         isPublicSaleActive = _isPublicSaleActive;
3397     }
3398 
3399     function setIsAllowListSaleActive(bool _isAllowListSaleActive)
3400         external
3401         onlyOwner
3402     {
3403         isAllowListSaleActive = _isAllowListSaleActive;
3404     }
3405 
3406     function _generateMerkleLeaf(address account) internal pure returns(bytes32) {
3407 	return keccak256(abi.encodePacked(account));
3408 	}
3409 
3410     function setAllowListListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
3411         allowListSaleMerkleRoot = merkleRoot;
3412     }
3413 
3414     function setClaimListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
3415         claimListMerkleRoot = merkleRoot;
3416     }
3417 
3418     function reserveForGifting(uint256 numToReserve)
3419         external
3420         nonReentrant
3421         onlyOwner
3422         canGiftNFTs(numToReserve)
3423     {
3424         numGiftedNFTs += numToReserve;
3425 
3426         for (uint256 i = 0; i < numToReserve; i++) {
3427             _safeMint(msg.sender, nextTokenId());
3428         }
3429     }
3430 
3431     function giftNFTs(address[] calldata addresses)
3432         external
3433         nonReentrant
3434         onlyOwner
3435         canGiftNFTs(addresses.length)
3436     {
3437         uint256 numToGift = addresses.length;
3438         numGiftedNFTs += numToGift;
3439 
3440         for (uint256 i = 0; i < numToGift; i++) {
3441             _safeMint(addresses[i], nextTokenId());
3442         }
3443     }
3444 
3445     function withdraw() public onlyOwner {
3446         uint256 balance = address(this).balance;
3447         payable(msg.sender).transfer(balance);
3448     }
3449 
3450     function withdrawTokens(IERC20 token) public onlyOwner {
3451         uint256 balance = token.balanceOf(address(this));
3452         token.transfer(msg.sender, balance);
3453     }
3454 
3455     function rollOverNFTs(address[] calldata addresses)
3456         external
3457         nonReentrant
3458         onlyOwner
3459     {
3460         require(
3461             tokenCounter.current() + addresses.length <= 128,
3462             "All NFTs are already rolled over"
3463         );
3464 
3465         for (uint256 i = 0; i < addresses.length; i++) {
3466             allowListMintCounts[addresses[i]] += 1;
3467             // use mint rather than _safeMint here to reduce gas costs
3468             
3469             _mint(addresses[i], nextTokenId());
3470         }
3471     }
3472 
3473     // ============ SUPPORTING FUNCTIONS ============
3474 
3475     function nextTokenId() private returns (uint256) {
3476         tokenCounter.increment();
3477         return tokenCounter.current();
3478     }
3479 
3480     // ============ FUNCTION OVERRIDES ============
3481 
3482     function supportsInterface(bytes4 interfaceId)
3483         public
3484         view
3485         virtual
3486         override(ERC721, IERC165)
3487         returns (bool)
3488     {
3489         return
3490             interfaceId == type(IERC2981).interfaceId ||
3491             super.supportsInterface(interfaceId);
3492     }
3493 
3494     /**
3495      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
3496      */
3497     /*function isApprovedForAll(address owner, address operator)
3498         public
3499         view
3500         override
3501         returns (bool)
3502     {
3503         // Get a reference to OpenSea's proxy registry contract by instantiating
3504         // the contract using the already existing address.
3505         ProxyRegistry proxyRegistry = ProxyRegistry(
3506             openSeaProxyRegistryAddress
3507         );
3508         if (
3509             isOpenSeaProxyActive &&
3510             address(proxyRegistry.proxies(owner)) == operator
3511         ) {
3512             return true;
3513         }
3514 
3515         return super.isApprovedForAll(owner, operator);
3516     }*/
3517 
3518     /**
3519      * @dev See {IERC721Metadata-tokenURI}.
3520      */
3521     
3522 
3523     function tokenURI(uint256 tokenId)
3524         public
3525         view
3526         virtual
3527         override
3528         returns (string memory)
3529     {
3530         require(_exists(tokenId), "Nonexistent token");
3531         if (REVEAL) {
3532             return string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
3533             }
3534         else{
3535         return
3536             baseURI;
3537         }
3538     }
3539 
3540     /**
3541      * @dev See {IERC165-royaltyInfo}.
3542      */
3543     function royaltyInfo(uint256 tokenId, uint256 salePrice)
3544         external
3545         view
3546         override
3547         returns (address receiver, uint256 royaltyAmount)
3548     {
3549         require(_exists(tokenId), "Nonexistent token");
3550 
3551         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
3552     }
3553 }
3554 
3555 // These contract definitions are used to create a reference to the OpenSea
3556 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
3557 /*contract OwnableDelegateProxy {
3558 
3559 }
3560 
3561 contract ProxyRegistry {
3562     mapping(address => OwnableDelegateProxy) public proxies;
3563 }*/