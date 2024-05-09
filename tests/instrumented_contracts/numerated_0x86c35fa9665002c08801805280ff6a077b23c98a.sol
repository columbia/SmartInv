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
280 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
322                 computedHash = _efficientHash(computedHash, proofElement);
323             } else {
324                 // Hash(current element of the proof + current computed hash)
325                 computedHash = _efficientHash(proofElement, computedHash);
326             }
327         }
328         return computedHash;
329     }
330 
331     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
332         assembly {
333             mstore(0x00, a)
334             mstore(0x20, b)
335             value := keccak256(0x00, 0x40)
336         }
337     }
338 }
339 
340 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Contract module that helps prevent reentrant calls to a function.
349  *
350  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
351  * available, which can be applied to functions to make sure there are no nested
352  * (reentrant) calls to them.
353  *
354  * Note that because there is a single `nonReentrant` guard, functions marked as
355  * `nonReentrant` may not call one another. This can be worked around by making
356  * those functions `private`, and then adding `external` `nonReentrant` entry
357  * points to them.
358  *
359  * TIP: If you would like to learn more about reentrancy and alternative ways
360  * to protect against it, check out our blog post
361  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
362  */
363 abstract contract ReentrancyGuard {
364     // Booleans are more expensive than uint256 or any type that takes up a full
365     // word because each write operation emits an extra SLOAD to first read the
366     // slot's contents, replace the bits taken up by the boolean, and then write
367     // back. This is the compiler's defense against contract upgrades and
368     // pointer aliasing, and it cannot be disabled.
369 
370     // The values being non-zero value makes deployment a bit more expensive,
371     // but in exchange the refund on every call to nonReentrant will be lower in
372     // amount. Since refunds are capped to a percentage of the total
373     // transaction's gas, it is best to keep them low in cases like this one, to
374     // increase the likelihood of the full refund coming into effect.
375     uint256 private constant _NOT_ENTERED = 1;
376     uint256 private constant _ENTERED = 2;
377 
378     uint256 private _status;
379 
380     constructor() {
381         _status = _NOT_ENTERED;
382     }
383 
384     /**
385      * @dev Prevents a contract from calling itself, directly or indirectly.
386      * Calling a `nonReentrant` function from another `nonReentrant`
387      * function is not supported. It is possible to prevent this from happening
388      * by making the `nonReentrant` function external, and making it call a
389      * `private` function that does the actual work.
390      */
391     modifier nonReentrant() {
392         // On the first call to nonReentrant, _notEntered will be true
393         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
394 
395         // Any calls to nonReentrant after this point will fail
396         _status = _ENTERED;
397 
398         _;
399 
400         // By storing the original value once again, a refund is triggered (see
401         // https://eips.ethereum.org/EIPS/eip-2200)
402         _status = _NOT_ENTERED;
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
407 
408 
409 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @dev Interface of the ERC20 standard as defined in the EIP.
415  */
416 interface IERC20 {
417     /**
418      * @dev Returns the amount of tokens in existence.
419      */
420     function totalSupply() external view returns (uint256);
421 
422     /**
423      * @dev Returns the amount of tokens owned by `account`.
424      */
425     function balanceOf(address account) external view returns (uint256);
426 
427     /**
428      * @dev Moves `amount` tokens from the caller's account to `to`.
429      *
430      * Returns a boolean value indicating whether the operation succeeded.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transfer(address to, uint256 amount) external returns (bool);
435 
436     /**
437      * @dev Returns the remaining number of tokens that `spender` will be
438      * allowed to spend on behalf of `owner` through {transferFrom}. This is
439      * zero by default.
440      *
441      * This value changes when {approve} or {transferFrom} are called.
442      */
443     function allowance(address owner, address spender) external view returns (uint256);
444 
445     /**
446      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
447      *
448      * Returns a boolean value indicating whether the operation succeeded.
449      *
450      * IMPORTANT: Beware that changing an allowance with this method brings the risk
451      * that someone may use both the old and the new allowance by unfortunate
452      * transaction ordering. One possible solution to mitigate this race
453      * condition is to first reduce the spender's allowance to 0 and set the
454      * desired value afterwards:
455      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
456      *
457      * Emits an {Approval} event.
458      */
459     function approve(address spender, uint256 amount) external returns (bool);
460 
461     /**
462      * @dev Moves `amount` tokens from `from` to `to` using the
463      * allowance mechanism. `amount` is then deducted from the caller's
464      * allowance.
465      *
466      * Returns a boolean value indicating whether the operation succeeded.
467      *
468      * Emits a {Transfer} event.
469      */
470     function transferFrom(
471         address from,
472         address to,
473         uint256 amount
474     ) external returns (bool);
475 
476     /**
477      * @dev Emitted when `value` tokens are moved from one account (`from`) to
478      * another (`to`).
479      *
480      * Note that `value` may be zero.
481      */
482     event Transfer(address indexed from, address indexed to, uint256 value);
483 
484     /**
485      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
486      * a call to {approve}. `value` is the new allowance.
487      */
488     event Approval(address indexed owner, address indexed spender, uint256 value);
489 }
490 
491 // File: @openzeppelin/contracts/interfaces/IERC20.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 // File: @openzeppelin/contracts/utils/Strings.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 /**
507  * @dev String operations.
508  */
509 library Strings {
510     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
511 
512     /**
513      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
514      */
515     function toString(uint256 value) internal pure returns (string memory) {
516         // Inspired by OraclizeAPI's implementation - MIT licence
517         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
518 
519         if (value == 0) {
520             return "0";
521         }
522         uint256 temp = value;
523         uint256 digits;
524         while (temp != 0) {
525             digits++;
526             temp /= 10;
527         }
528         bytes memory buffer = new bytes(digits);
529         while (value != 0) {
530             digits -= 1;
531             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
532             value /= 10;
533         }
534         return string(buffer);
535     }
536 
537     /**
538      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
539      */
540     function toHexString(uint256 value) internal pure returns (string memory) {
541         if (value == 0) {
542             return "0x00";
543         }
544         uint256 temp = value;
545         uint256 length = 0;
546         while (temp != 0) {
547             length++;
548             temp >>= 8;
549         }
550         return toHexString(value, length);
551     }
552 
553     /**
554      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
555      */
556     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
557         bytes memory buffer = new bytes(2 * length + 2);
558         buffer[0] = "0";
559         buffer[1] = "x";
560         for (uint256 i = 2 * length + 1; i > 1; --i) {
561             buffer[i] = _HEX_SYMBOLS[value & 0xf];
562             value >>= 4;
563         }
564         require(value == 0, "Strings: hex length insufficient");
565         return string(buffer);
566     }
567 }
568 
569 // File: @openzeppelin/contracts/utils/Context.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 /**
577  * @dev Provides information about the current execution context, including the
578  * sender of the transaction and its data. While these are generally available
579  * via msg.sender and msg.data, they should not be accessed in such a direct
580  * manner, since when dealing with meta-transactions the account sending and
581  * paying for execution may not be the actual sender (as far as an application
582  * is concerned).
583  *
584  * This contract is only required for intermediate, library-like contracts.
585  */
586 abstract contract Context {
587     function _msgSender() internal view virtual returns (address) {
588         return msg.sender;
589     }
590 
591     function _msgData() internal view virtual returns (bytes calldata) {
592         return msg.data;
593     }
594 }
595 
596 // File: @openzeppelin/contracts/access/Ownable.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 
604 /**
605  * @dev Contract module which provides a basic access control mechanism, where
606  * there is an account (an owner) that can be granted exclusive access to
607  * specific functions.
608  *
609  * By default, the owner account will be the one that deploys the contract. This
610  * can later be changed with {transferOwnership}.
611  *
612  * This module is used through inheritance. It will make available the modifier
613  * `onlyOwner`, which can be applied to your functions to restrict their use to
614  * the owner.
615  */
616 abstract contract Ownable is Context {
617     address private _owner;
618 
619     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
620 
621     /**
622      * @dev Initializes the contract setting the deployer as the initial owner.
623      */
624     constructor() {
625         _transferOwnership(_msgSender());
626     }
627 
628     /**
629      * @dev Returns the address of the current owner.
630      */
631     function owner() public view virtual returns (address) {
632         return _owner;
633     }
634 
635     /**
636      * @dev Throws if called by any account other than the owner.
637      */
638     modifier onlyOwner() {
639         require(owner() == _msgSender(), "Ownable: caller is not the owner");
640         _;
641     }
642 
643     /**
644      * @dev Leaves the contract without owner. It will not be possible to call
645      * `onlyOwner` functions anymore. Can only be called by the current owner.
646      *
647      * NOTE: Renouncing ownership will leave the contract without an owner,
648      * thereby removing any functionality that is only available to the owner.
649      */
650     function renounceOwnership() public virtual onlyOwner {
651         _transferOwnership(address(0));
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      * Can only be called by the current owner.
657      */
658     function transferOwnership(address newOwner) public virtual onlyOwner {
659         require(newOwner != address(0), "Ownable: new owner is the zero address");
660         _transferOwnership(newOwner);
661     }
662 
663     /**
664      * @dev Transfers ownership of the contract to a new account (`newOwner`).
665      * Internal function without access restriction.
666      */
667     function _transferOwnership(address newOwner) internal virtual {
668         address oldOwner = _owner;
669         _owner = newOwner;
670         emit OwnershipTransferred(oldOwner, newOwner);
671     }
672 }
673 
674 // File: @openzeppelin/contracts/utils/Address.sol
675 
676 
677 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
678 
679 pragma solidity ^0.8.1;
680 
681 /**
682  * @dev Collection of functions related to the address type
683  */
684 library Address {
685     /**
686      * @dev Returns true if `account` is a contract.
687      *
688      * [IMPORTANT]
689      * ====
690      * It is unsafe to assume that an address for which this function returns
691      * false is an externally-owned account (EOA) and not a contract.
692      *
693      * Among others, `isContract` will return false for the following
694      * types of addresses:
695      *
696      *  - an externally-owned account
697      *  - a contract in construction
698      *  - an address where a contract will be created
699      *  - an address where a contract lived, but was destroyed
700      * ====
701      *
702      * [IMPORTANT]
703      * ====
704      * You shouldn't rely on `isContract` to protect against flash loan attacks!
705      *
706      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
707      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
708      * constructor.
709      * ====
710      */
711     function isContract(address account) internal view returns (bool) {
712         // This method relies on extcodesize/address.code.length, which returns 0
713         // for contracts in construction, since the code is only stored at the end
714         // of the constructor execution.
715 
716         return account.code.length > 0;
717     }
718 
719     /**
720      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
721      * `recipient`, forwarding all available gas and reverting on errors.
722      *
723      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
724      * of certain opcodes, possibly making contracts go over the 2300 gas limit
725      * imposed by `transfer`, making them unable to receive funds via
726      * `transfer`. {sendValue} removes this limitation.
727      *
728      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
729      *
730      * IMPORTANT: because control is transferred to `recipient`, care must be
731      * taken to not create reentrancy vulnerabilities. Consider using
732      * {ReentrancyGuard} or the
733      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
734      */
735     function sendValue(address payable recipient, uint256 amount) internal {
736         require(address(this).balance >= amount, "Address: insufficient balance");
737 
738         (bool success, ) = recipient.call{value: amount}("");
739         require(success, "Address: unable to send value, recipient may have reverted");
740     }
741 
742     /**
743      * @dev Performs a Solidity function call using a low level `call`. A
744      * plain `call` is an unsafe replacement for a function call: use this
745      * function instead.
746      *
747      * If `target` reverts with a revert reason, it is bubbled up by this
748      * function (like regular Solidity function calls).
749      *
750      * Returns the raw returned data. To convert to the expected return value,
751      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
752      *
753      * Requirements:
754      *
755      * - `target` must be a contract.
756      * - calling `target` with `data` must not revert.
757      *
758      * _Available since v3.1._
759      */
760     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
761         return functionCall(target, data, "Address: low-level call failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
766      * `errorMessage` as a fallback revert reason when `target` reverts.
767      *
768      * _Available since v3.1._
769      */
770     function functionCall(
771         address target,
772         bytes memory data,
773         string memory errorMessage
774     ) internal returns (bytes memory) {
775         return functionCallWithValue(target, data, 0, errorMessage);
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
780      * but also transferring `value` wei to `target`.
781      *
782      * Requirements:
783      *
784      * - the calling contract must have an ETH balance of at least `value`.
785      * - the called Solidity function must be `payable`.
786      *
787      * _Available since v3.1._
788      */
789     function functionCallWithValue(
790         address target,
791         bytes memory data,
792         uint256 value
793     ) internal returns (bytes memory) {
794         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
799      * with `errorMessage` as a fallback revert reason when `target` reverts.
800      *
801      * _Available since v3.1._
802      */
803     function functionCallWithValue(
804         address target,
805         bytes memory data,
806         uint256 value,
807         string memory errorMessage
808     ) internal returns (bytes memory) {
809         require(address(this).balance >= value, "Address: insufficient balance for call");
810         require(isContract(target), "Address: call to non-contract");
811 
812         (bool success, bytes memory returndata) = target.call{value: value}(data);
813         return verifyCallResult(success, returndata, errorMessage);
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
818      * but performing a static call.
819      *
820      * _Available since v3.3._
821      */
822     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
823         return functionStaticCall(target, data, "Address: low-level static call failed");
824     }
825 
826     /**
827      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
828      * but performing a static call.
829      *
830      * _Available since v3.3._
831      */
832     function functionStaticCall(
833         address target,
834         bytes memory data,
835         string memory errorMessage
836     ) internal view returns (bytes memory) {
837         require(isContract(target), "Address: static call to non-contract");
838 
839         (bool success, bytes memory returndata) = target.staticcall(data);
840         return verifyCallResult(success, returndata, errorMessage);
841     }
842 
843     /**
844      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
845      * but performing a delegate call.
846      *
847      * _Available since v3.4._
848      */
849     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
850         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
855      * but performing a delegate call.
856      *
857      * _Available since v3.4._
858      */
859     function functionDelegateCall(
860         address target,
861         bytes memory data,
862         string memory errorMessage
863     ) internal returns (bytes memory) {
864         require(isContract(target), "Address: delegate call to non-contract");
865 
866         (bool success, bytes memory returndata) = target.delegatecall(data);
867         return verifyCallResult(success, returndata, errorMessage);
868     }
869 
870     /**
871      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
872      * revert reason using the provided one.
873      *
874      * _Available since v4.3._
875      */
876     function verifyCallResult(
877         bool success,
878         bytes memory returndata,
879         string memory errorMessage
880     ) internal pure returns (bytes memory) {
881         if (success) {
882             return returndata;
883         } else {
884             // Look for revert reason and bubble it up if present
885             if (returndata.length > 0) {
886                 // The easiest way to bubble the revert reason is using memory via assembly
887 
888                 assembly {
889                     let returndata_size := mload(returndata)
890                     revert(add(32, returndata), returndata_size)
891                 }
892             } else {
893                 revert(errorMessage);
894             }
895         }
896     }
897 }
898 
899 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
900 
901 
902 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @title ERC721 token receiver interface
908  * @dev Interface for any contract that wants to support safeTransfers
909  * from ERC721 asset contracts.
910  */
911 interface IERC721Receiver {
912     /**
913      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
914      * by `operator` from `from`, this function is called.
915      *
916      * It must return its Solidity selector to confirm the token transfer.
917      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
918      *
919      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
920      */
921     function onERC721Received(
922         address operator,
923         address from,
924         uint256 tokenId,
925         bytes calldata data
926     ) external returns (bytes4);
927 }
928 
929 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
930 
931 
932 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 /**
937  * @dev Interface of the ERC165 standard, as defined in the
938  * https://eips.ethereum.org/EIPS/eip-165[EIP].
939  *
940  * Implementers can declare support of contract interfaces, which can then be
941  * queried by others ({ERC165Checker}).
942  *
943  * For an implementation, see {ERC165}.
944  */
945 interface IERC165 {
946     /**
947      * @dev Returns true if this contract implements the interface defined by
948      * `interfaceId`. See the corresponding
949      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
950      * to learn more about how these ids are created.
951      *
952      * This function call must use less than 30 000 gas.
953      */
954     function supportsInterface(bytes4 interfaceId) external view returns (bool);
955 }
956 
957 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 /**
966  * @dev Implementation of the {IERC165} interface.
967  *
968  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
969  * for the additional interface id that will be supported. For example:
970  *
971  * ```solidity
972  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
973  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
974  * }
975  * ```
976  *
977  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
978  */
979 abstract contract ERC165 is IERC165 {
980     /**
981      * @dev See {IERC165-supportsInterface}.
982      */
983     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
984         return interfaceId == type(IERC165).interfaceId;
985     }
986 }
987 
988 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
989 
990 
991 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
992 
993 pragma solidity ^0.8.0;
994 
995 
996 /**
997  * @dev Required interface of an ERC721 compliant contract.
998  */
999 interface IERC721 is IERC165 {
1000     /**
1001      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1002      */
1003     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1004 
1005     /**
1006      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1007      */
1008     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1009 
1010     /**
1011      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1012      */
1013     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1014 
1015     /**
1016      * @dev Returns the number of tokens in ``owner``'s account.
1017      */
1018     function balanceOf(address owner) external view returns (uint256 balance);
1019 
1020     /**
1021      * @dev Returns the owner of the `tokenId` token.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      */
1027     function ownerOf(uint256 tokenId) external view returns (address owner);
1028 
1029     /**
1030      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1031      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1032      *
1033      * Requirements:
1034      *
1035      * - `from` cannot be the zero address.
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must exist and be owned by `from`.
1038      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1039      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) external;
1048 
1049     /**
1050      * @dev Transfers `tokenId` token from `from` to `to`.
1051      *
1052      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1053      *
1054      * Requirements:
1055      *
1056      * - `from` cannot be the zero address.
1057      * - `to` cannot be the zero address.
1058      * - `tokenId` token must be owned by `from`.
1059      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function transferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) external;
1068 
1069     /**
1070      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1071      * The approval is cleared when the token is transferred.
1072      *
1073      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1074      *
1075      * Requirements:
1076      *
1077      * - The caller must own the token or be an approved operator.
1078      * - `tokenId` must exist.
1079      *
1080      * Emits an {Approval} event.
1081      */
1082     function approve(address to, uint256 tokenId) external;
1083 
1084     /**
1085      * @dev Returns the account approved for `tokenId` token.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must exist.
1090      */
1091     function getApproved(uint256 tokenId) external view returns (address operator);
1092 
1093     /**
1094      * @dev Approve or remove `operator` as an operator for the caller.
1095      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1096      *
1097      * Requirements:
1098      *
1099      * - The `operator` cannot be the caller.
1100      *
1101      * Emits an {ApprovalForAll} event.
1102      */
1103     function setApprovalForAll(address operator, bool _approved) external;
1104 
1105     /**
1106      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1107      *
1108      * See {setApprovalForAll}
1109      */
1110     function isApprovedForAll(address owner, address operator) external view returns (bool);
1111 
1112     /**
1113      * @dev Safely transfers `tokenId` token from `from` to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `from` cannot be the zero address.
1118      * - `to` cannot be the zero address.
1119      * - `tokenId` token must exist and be owned by `from`.
1120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes calldata data
1130     ) external;
1131 }
1132 
1133 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1134 
1135 
1136 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 
1141 /**
1142  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1143  * @dev See https://eips.ethereum.org/EIPS/eip-721
1144  */
1145 interface IERC721Metadata is IERC721 {
1146     /**
1147      * @dev Returns the token collection name.
1148      */
1149     function name() external view returns (string memory);
1150 
1151     /**
1152      * @dev Returns the token collection symbol.
1153      */
1154     function symbol() external view returns (string memory);
1155 
1156     /**
1157      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1158      */
1159     function tokenURI(uint256 tokenId) external view returns (string memory);
1160 }
1161 
1162 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1163 
1164 
1165 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 
1170 
1171 
1172 
1173 
1174 
1175 
1176 /**
1177  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1178  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1179  * {ERC721Enumerable}.
1180  */
1181 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1182     using Address for address;
1183     using Strings for uint256;
1184 
1185     // Token name
1186     string private _name;
1187 
1188     // Token symbol
1189     string private _symbol;
1190 
1191     // Mapping from token ID to owner address
1192     mapping(uint256 => address) private _owners;
1193 
1194     // Mapping owner address to token count
1195     mapping(address => uint256) private _balances;
1196 
1197     // Mapping from token ID to approved address
1198     mapping(uint256 => address) private _tokenApprovals;
1199 
1200     // Mapping from owner to operator approvals
1201     mapping(address => mapping(address => bool)) private _operatorApprovals;
1202 
1203     /**
1204      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1205      */
1206     constructor(string memory name_, string memory symbol_) {
1207         _name = name_;
1208         _symbol = symbol_;
1209     }
1210 
1211     /**
1212      * @dev See {IERC165-supportsInterface}.
1213      */
1214     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1215         return
1216             interfaceId == type(IERC721).interfaceId ||
1217             interfaceId == type(IERC721Metadata).interfaceId ||
1218             super.supportsInterface(interfaceId);
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-balanceOf}.
1223      */
1224     function balanceOf(address owner) public view virtual override returns (uint256) {
1225         require(owner != address(0), "ERC721: balance query for the zero address");
1226         return _balances[owner];
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-ownerOf}.
1231      */
1232     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1233         address owner = _owners[tokenId];
1234         require(owner != address(0), "ERC721: owner query for nonexistent token");
1235         return owner;
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Metadata-name}.
1240      */
1241     function name() public view virtual override returns (string memory) {
1242         return _name;
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Metadata-symbol}.
1247      */
1248     function symbol() public view virtual override returns (string memory) {
1249         return _symbol;
1250     }
1251 
1252     /**
1253      * @dev See {IERC721Metadata-tokenURI}.
1254      */
1255     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1256         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1257 
1258         string memory baseURI = _baseURI();
1259         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1260     }
1261 
1262     /**
1263      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1264      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1265      * by default, can be overriden in child contracts.
1266      */
1267     function _baseURI() internal view virtual returns (string memory) {
1268         return "";
1269     }
1270 
1271     /**
1272      * @dev See {IERC721-approve}.
1273      */
1274     function approve(address to, uint256 tokenId) public virtual override {
1275         address owner = ERC721.ownerOf(tokenId);
1276         require(to != owner, "ERC721: approval to current owner");
1277 
1278         require(
1279             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1280             "ERC721: approve caller is not owner nor approved for all"
1281         );
1282 
1283         _approve(to, tokenId);
1284     }
1285 
1286     /**
1287      * @dev See {IERC721-getApproved}.
1288      */
1289     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1290         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1291 
1292         return _tokenApprovals[tokenId];
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-setApprovalForAll}.
1297      */
1298     function setApprovalForAll(address operator, bool approved) public virtual override {
1299         _setApprovalForAll(_msgSender(), operator, approved);
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-isApprovedForAll}.
1304      */
1305     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1306         return _operatorApprovals[owner][operator];
1307     }
1308 
1309     /**
1310      * @dev See {IERC721-transferFrom}.
1311      */
1312     function transferFrom(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) public virtual override {
1317         //solhint-disable-next-line max-line-length
1318         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1319 
1320         _transfer(from, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-safeTransferFrom}.
1325      */
1326     function safeTransferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) public virtual override {
1331         safeTransferFrom(from, to, tokenId, "");
1332     }
1333 
1334     /**
1335      * @dev See {IERC721-safeTransferFrom}.
1336      */
1337     function safeTransferFrom(
1338         address from,
1339         address to,
1340         uint256 tokenId,
1341         bytes memory _data
1342     ) public virtual override {
1343         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1344         _safeTransfer(from, to, tokenId, _data);
1345     }
1346 
1347     /**
1348      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1349      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1350      *
1351      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1352      *
1353      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1354      * implement alternative mechanisms to perform token transfer, such as signature-based.
1355      *
1356      * Requirements:
1357      *
1358      * - `from` cannot be the zero address.
1359      * - `to` cannot be the zero address.
1360      * - `tokenId` token must exist and be owned by `from`.
1361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1362      *
1363      * Emits a {Transfer} event.
1364      */
1365     function _safeTransfer(
1366         address from,
1367         address to,
1368         uint256 tokenId,
1369         bytes memory _data
1370     ) internal virtual {
1371         _transfer(from, to, tokenId);
1372         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1373     }
1374 
1375     /**
1376      * @dev Returns whether `tokenId` exists.
1377      *
1378      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1379      *
1380      * Tokens start existing when they are minted (`_mint`),
1381      * and stop existing when they are burned (`_burn`).
1382      */
1383     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1384         return _owners[tokenId] != address(0);
1385     }
1386 
1387     /**
1388      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1389      *
1390      * Requirements:
1391      *
1392      * - `tokenId` must exist.
1393      */
1394     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1395         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1396         address owner = ERC721.ownerOf(tokenId);
1397         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1398     }
1399 
1400     /**
1401      * @dev Safely mints `tokenId` and transfers it to `to`.
1402      *
1403      * Requirements:
1404      *
1405      * - `tokenId` must not exist.
1406      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1407      *
1408      * Emits a {Transfer} event.
1409      */
1410     function _safeMint(address to, uint256 tokenId) internal virtual {
1411         _safeMint(to, tokenId, "");
1412     }
1413 
1414     /**
1415      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1416      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1417      */
1418     function _safeMint(
1419         address to,
1420         uint256 tokenId,
1421         bytes memory _data
1422     ) internal virtual {
1423         _mint(to, tokenId);
1424         require(
1425             _checkOnERC721Received(address(0), to, tokenId, _data),
1426             "ERC721: transfer to non ERC721Receiver implementer"
1427         );
1428     }
1429 
1430     /**
1431      * @dev Mints `tokenId` and transfers it to `to`.
1432      *
1433      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1434      *
1435      * Requirements:
1436      *
1437      * - `tokenId` must not exist.
1438      * - `to` cannot be the zero address.
1439      *
1440      * Emits a {Transfer} event.
1441      */
1442     function _mint(address to, uint256 tokenId) internal virtual {
1443         require(to != address(0), "ERC721: mint to the zero address");
1444         require(!_exists(tokenId), "ERC721: token already minted");
1445 
1446         _beforeTokenTransfer(address(0), to, tokenId);
1447 
1448         _balances[to] += 1;
1449         _owners[tokenId] = to;
1450 
1451         emit Transfer(address(0), to, tokenId);
1452 
1453         _afterTokenTransfer(address(0), to, tokenId);
1454     }
1455 
1456     /**
1457      * @dev Destroys `tokenId`.
1458      * The approval is cleared when the token is burned.
1459      *
1460      * Requirements:
1461      *
1462      * - `tokenId` must exist.
1463      *
1464      * Emits a {Transfer} event.
1465      */
1466     function _burn(uint256 tokenId) internal virtual {
1467         address owner = ERC721.ownerOf(tokenId);
1468 
1469         _beforeTokenTransfer(owner, address(0), tokenId);
1470 
1471         // Clear approvals
1472         _approve(address(0), tokenId);
1473 
1474         _balances[owner] -= 1;
1475         delete _owners[tokenId];
1476 
1477         emit Transfer(owner, address(0), tokenId);
1478 
1479         _afterTokenTransfer(owner, address(0), tokenId);
1480     }
1481 
1482     /**
1483      * @dev Transfers `tokenId` from `from` to `to`.
1484      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1485      *
1486      * Requirements:
1487      *
1488      * - `to` cannot be the zero address.
1489      * - `tokenId` token must be owned by `from`.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function _transfer(
1494         address from,
1495         address to,
1496         uint256 tokenId
1497     ) internal virtual {
1498         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1499         require(to != address(0), "ERC721: transfer to the zero address");
1500 
1501         _beforeTokenTransfer(from, to, tokenId);
1502 
1503         // Clear approvals from the previous owner
1504         _approve(address(0), tokenId);
1505 
1506         _balances[from] -= 1;
1507         _balances[to] += 1;
1508         _owners[tokenId] = to;
1509 
1510         emit Transfer(from, to, tokenId);
1511 
1512         _afterTokenTransfer(from, to, tokenId);
1513     }
1514 
1515     /**
1516      * @dev Approve `to` to operate on `tokenId`
1517      *
1518      * Emits a {Approval} event.
1519      */
1520     function _approve(address to, uint256 tokenId) internal virtual {
1521         _tokenApprovals[tokenId] = to;
1522         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1523     }
1524 
1525     /**
1526      * @dev Approve `operator` to operate on all of `owner` tokens
1527      *
1528      * Emits a {ApprovalForAll} event.
1529      */
1530     function _setApprovalForAll(
1531         address owner,
1532         address operator,
1533         bool approved
1534     ) internal virtual {
1535         require(owner != operator, "ERC721: approve to caller");
1536         _operatorApprovals[owner][operator] = approved;
1537         emit ApprovalForAll(owner, operator, approved);
1538     }
1539 
1540     /**
1541      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1542      * The call is not executed if the target address is not a contract.
1543      *
1544      * @param from address representing the previous owner of the given token ID
1545      * @param to target address that will receive the tokens
1546      * @param tokenId uint256 ID of the token to be transferred
1547      * @param _data bytes optional data to send along with the call
1548      * @return bool whether the call correctly returned the expected magic value
1549      */
1550     function _checkOnERC721Received(
1551         address from,
1552         address to,
1553         uint256 tokenId,
1554         bytes memory _data
1555     ) private returns (bool) {
1556         if (to.isContract()) {
1557             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1558                 return retval == IERC721Receiver.onERC721Received.selector;
1559             } catch (bytes memory reason) {
1560                 if (reason.length == 0) {
1561                     revert("ERC721: transfer to non ERC721Receiver implementer");
1562                 } else {
1563                     assembly {
1564                         revert(add(32, reason), mload(reason))
1565                     }
1566                 }
1567             }
1568         } else {
1569             return true;
1570         }
1571     }
1572 
1573     /**
1574      * @dev Hook that is called before any token transfer. This includes minting
1575      * and burning.
1576      *
1577      * Calling conditions:
1578      *
1579      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1580      * transferred to `to`.
1581      * - When `from` is zero, `tokenId` will be minted for `to`.
1582      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1583      * - `from` and `to` are never both zero.
1584      *
1585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1586      */
1587     function _beforeTokenTransfer(
1588         address from,
1589         address to,
1590         uint256 tokenId
1591     ) internal virtual {}
1592 
1593     /**
1594      * @dev Hook that is called after any transfer of tokens. This includes
1595      * minting and burning.
1596      *
1597      * Calling conditions:
1598      *
1599      * - when `from` and `to` are both non-zero.
1600      * - `from` and `to` are never both zero.
1601      *
1602      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1603      */
1604     function _afterTokenTransfer(
1605         address from,
1606         address to,
1607         uint256 tokenId
1608     ) internal virtual {}
1609 }
1610 
1611 // File: contracts/CatBloxGenesis.sol
1612 
1613 //SPDX-License-Identifier: MIT
1614 
1615 pragma solidity ^0.8.0;
1616 
1617 contract CatBloxGenesis is ERC721, Ownable, ReentrancyGuard {
1618     using Counters for Counters.Counter;
1619     using Strings for uint256;
1620 
1621     Counters.Counter private tokenCounter;
1622 
1623     string public baseURI;
1624     string public provenanceHash;
1625 
1626     uint256 public constant MAX_CATS_PER_WALLET = 2;
1627     uint256 public immutable maxCats;
1628 
1629     bool public isMilkListActive;
1630     bool public isReserveListActive;
1631     bool public isPublicSaleActive;
1632 
1633     uint256 public milkListSalePrice = 0.18 ether;
1634     uint256 public reserveListSalePrice = 0.22 ether;
1635     uint256 public publicSalePrice = 0.22 ether;
1636 
1637     bytes32 public milkListMerkleRoot;
1638     bytes32 public reserveListMerkleRoot;
1639 
1640     mapping(address => uint256) public milkListMintCounts;
1641     mapping(address => uint256) public reserveListMintCounts;
1642     mapping(address => uint256) public publicListMintCounts;
1643 
1644     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1645 
1646     modifier milkListActive() {
1647         require(isMilkListActive, "Milk list not active");
1648         _;
1649     }
1650     
1651     modifier reserveListActive() {
1652         require(isReserveListActive, "Reserve list not active");
1653         _;
1654     }
1655 
1656     modifier publicSaleActive() {
1657         require(isPublicSaleActive, "Public sale not active");
1658         _;
1659     }
1660 
1661     modifier totalNotExceeded(uint256 numberOfTokens) {
1662         require(
1663             tokenCounter.current() + numberOfTokens <= maxCats,
1664             "Not enough cats remaining to mint"
1665         );
1666         _;
1667     }
1668 
1669     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1670         require(
1671             price * numberOfTokens == msg.value,
1672             "Incorrect ETH value sent"
1673         );
1674         _;
1675     }
1676 
1677     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1678         require(
1679             MerkleProof.verify(
1680                 merkleProof,
1681                 root,
1682                 keccak256(abi.encodePacked(msg.sender))
1683             ),
1684             "Address does not exist in list"
1685         );
1686         _;
1687     }
1688 
1689     constructor(string memory _baseURI, uint256 _maxCats) ERC721("CatBloxGenesis", "CATBLOXGEN") {
1690         baseURI = _baseURI;
1691         maxCats = _maxCats;
1692     }
1693 
1694     // ============ OWNER ONLY FUNCTION FOR MINTING ============
1695 
1696     function mintToTeam(uint256 numberOfTokens, address recipient)
1697         external
1698         onlyOwner
1699         totalNotExceeded(numberOfTokens)
1700     {
1701         for (uint256 i = 0; i < numberOfTokens; i++) {
1702             _safeMint(recipient, nextTokenId());
1703         }
1704     }
1705 
1706     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1707 
1708     function mintMilkListSale(
1709         uint8 numberOfTokens,
1710         bytes32[] calldata merkleProof
1711     )
1712         external
1713         payable
1714         nonReentrant
1715         milkListActive
1716         isCorrectPayment(milkListSalePrice, numberOfTokens)
1717         totalNotExceeded(numberOfTokens)
1718         isValidMerkleProof(merkleProof, milkListMerkleRoot)
1719     {
1720         uint256 numAlreadyMinted = milkListMintCounts[msg.sender];
1721         require(numAlreadyMinted + numberOfTokens <= MAX_CATS_PER_WALLET, "ML: Two cats max per wallet");
1722         milkListMintCounts[msg.sender] = numAlreadyMinted + numberOfTokens;
1723 
1724         for (uint256 i = 0; i < numberOfTokens; i++) {
1725             _safeMint(msg.sender, nextTokenId());
1726         }
1727     }
1728 
1729     function mintReserveListSale(
1730         uint8 numberOfTokens,
1731         bytes32[] calldata merkleProof
1732     )
1733         external
1734         payable
1735         nonReentrant
1736         reserveListActive
1737         isCorrectPayment(reserveListSalePrice, numberOfTokens)
1738         totalNotExceeded(numberOfTokens)
1739         isValidMerkleProof(merkleProof, reserveListMerkleRoot)
1740     {
1741         uint256 numAlreadyMinted = reserveListMintCounts[msg.sender];
1742         require(numAlreadyMinted + numberOfTokens <= MAX_CATS_PER_WALLET, "RL: Two cats max per wallet");
1743         reserveListMintCounts[msg.sender] = numAlreadyMinted + numberOfTokens;
1744 
1745         for (uint256 i = 0; i < numberOfTokens; i++) {
1746             _safeMint(msg.sender, nextTokenId());
1747         }
1748     }
1749 
1750     function publicMint(uint256 numberOfTokens)
1751         external
1752         payable
1753         nonReentrant
1754         publicSaleActive
1755         isCorrectPayment(publicSalePrice, numberOfTokens)
1756         totalNotExceeded(numberOfTokens)
1757     {
1758         uint256 numAlreadyMinted = publicListMintCounts[msg.sender];
1759         require(numAlreadyMinted + numberOfTokens <= MAX_CATS_PER_WALLET, "PM: Two cats max per wallet");
1760         publicListMintCounts[msg.sender] = numAlreadyMinted + numberOfTokens;
1761 
1762         for (uint256 i = 0; i < numberOfTokens; i++) {
1763             _safeMint(msg.sender, nextTokenId());
1764         }
1765     }
1766 
1767     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1768 
1769     function totalSupply() external view returns (uint256) {
1770         return tokenCounter.current();
1771     }
1772 
1773     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1774 
1775     function setBaseURI(string memory _baseURI) external onlyOwner {
1776         baseURI = _baseURI;
1777     }
1778 
1779     function setProvenanceHash(string memory _hash) external onlyOwner {
1780         provenanceHash = _hash;
1781     }
1782 
1783     // Set prices 
1784 
1785     function setPublicSalePrice(uint256 _price) external onlyOwner {
1786         publicSalePrice = _price;
1787     }
1788 
1789     function setMilkListPrice(uint256 _price) external onlyOwner {
1790         milkListSalePrice = _price;
1791     }
1792 
1793     function setReserveListPrice(uint256 _price) external onlyOwner {
1794         reserveListSalePrice = _price;
1795     }
1796 
1797     // Toggle Sales Active / Inactive 
1798 
1799     function setPublicSaleActive(bool _isPublicSaleActive) external onlyOwner {
1800         isPublicSaleActive = _isPublicSaleActive;
1801     }
1802 
1803     function setMilkListActive(bool _isMilkListActive) external onlyOwner {
1804         isMilkListActive = _isMilkListActive;
1805     }
1806 
1807     function setReserveListActive(bool _isReserveListActive) external onlyOwner {
1808         isReserveListActive = _isReserveListActive;
1809     }
1810 
1811     // Set Merkle Roots 
1812 
1813     function setMilkListMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1814         milkListMerkleRoot = _merkleRoot;
1815     }
1816 
1817     function setReserveListMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1818         reserveListMerkleRoot = _merkleRoot;
1819     }
1820 
1821     // Withdrawal 
1822 
1823     function withdraw() public onlyOwner {
1824         uint256 balance = address(this).balance;
1825         payable(msg.sender).transfer(balance);
1826     }
1827 
1828     function withdrawTokens(IERC20 token) public onlyOwner {
1829         uint256 balance = token.balanceOf(address(this));
1830         token.transfer(msg.sender, balance);
1831     }
1832 
1833     // ============ SUPPORTING FUNCTIONS ============
1834 
1835     function nextTokenId() private returns (uint256) {
1836         tokenCounter.increment();
1837         return tokenCounter.current();
1838     }
1839 
1840     /**
1841      * @dev See {IERC721Metadata-tokenURI}.
1842      */
1843     function tokenURI(uint256 tokenId)
1844         public
1845         view
1846         virtual
1847         override
1848         returns (string memory)
1849     {
1850         require(_exists(tokenId), "Nonexistent token");
1851 
1852         return string(abi.encodePacked(baseURI, tokenId.toString()));
1853     }
1854 }