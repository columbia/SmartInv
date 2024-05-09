1 // File: contracts/azuki4people.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-04-02
5 */
6 
7 // File: contracts/Azuki4People.sol
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-02-28
11 */
12 
13 // File: contracts/Azuki4People.sol
14 
15 /**
16  *Submitted for verification at Etherscan.io on 2022-02-25
17 */
18 
19 // File: contracts/Azuki4People.sol
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2022-02-23
23 */
24 
25 /**
26  *Submitted for verification at Etherscan.io on 2022-02-14
27 */
28 
29 // File: contracts/Azuki4People.sol
30 
31 /**
32  *Submitted for verification at Etherscan.io on 2022-01-18
33 */
34 
35 // File: contracts/Azuki4People.sol
36 
37 /**
38  *Submitted for verification at Etherscan.io on 2022-01-18
39 */
40 
41 /**
42  *Submitted for verification at Etherscan.io on 2022-01-18
43 */
44 
45 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
46 
47 
48 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
49 
50 pragma solidity ^0.8.0;
51 
52 // CAUTION
53 // This version of SafeMath should only be used with Solidity 0.8 or later,
54 // because it relies on the compiler's built in overflow checks.
55 
56 /**
57  * @dev Wrappers over Solidity's arithmetic operations.
58  *
59  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
60  * now has built in overflow checking.
61  */
62 library SafeMath {
63     /**
64      * @dev Returns the addition of two unsigned integers, with an overflow flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             uint256 c = a + b;
71             if (c < a) return (false, 0);
72             return (true, c);
73         }
74     }
75 
76     /**
77      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
78      *
79      * _Available since v3.4._
80      */
81     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b > a) return (false, 0);
84             return (true, a - b);
85         }
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
90      *
91      * _Available since v3.4._
92      */
93     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
94         unchecked {
95             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
96             // benefit is lost if 'b' is also tested.
97             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
98             if (a == 0) return (true, 0);
99             uint256 c = a * b;
100             if (c / a != b) return (false, 0);
101             return (true, c);
102         }
103     }
104 
105     /**
106      * @dev Returns the division of two unsigned integers, with a division by zero flag.
107      *
108      * _Available since v3.4._
109      */
110     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         unchecked {
112             if (b == 0) return (false, 0);
113             return (true, a / b);
114         }
115     }
116 
117     /**
118      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
119      *
120      * _Available since v3.4._
121      */
122     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             if (b == 0) return (false, 0);
125             return (true, a % b);
126         }
127     }
128 
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a + b;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a - b;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a * b;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers, reverting on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator.
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a / b;
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187      * reverting when dividing by zero.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
198         return a % b;
199     }
200 
201     /**
202      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
203      * overflow (when the result is negative).
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {trySub}.
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         unchecked {
220             require(b <= a, errorMessage);
221             return a - b;
222         }
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(
238         uint256 a,
239         uint256 b,
240         string memory errorMessage
241     ) internal pure returns (uint256) {
242         unchecked {
243             require(b > 0, errorMessage);
244             return a / b;
245         }
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * reverting with custom message when dividing by zero.
251      *
252      * CAUTION: This function is deprecated because it requires allocating memory for the error
253      * message unnecessarily. For custom revert reasons use {tryMod}.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         unchecked {
269             require(b > 0, errorMessage);
270             return a % b;
271         }
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Counters.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @title Counters
284  * @author Matt Condon (@shrugs)
285  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
286  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
287  *
288  * Include with `using Counters for Counters.Counter;`
289  */
290 library Counters {
291     struct Counter {
292         // This variable should never be directly accessed by users of the library: interactions must be restricted to
293         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
294         // this feature: see https://github.com/ethereum/solidity/issues/4637
295         uint256 _value; // default: 0
296     }
297 
298     function current(Counter storage counter) internal view returns (uint256) {
299         return counter._value;
300     }
301 
302     function increment(Counter storage counter) internal {
303         unchecked {
304             counter._value += 1;
305         }
306     }
307 
308     function decrement(Counter storage counter) internal {
309         uint256 value = counter._value;
310         require(value > 0, "Counter: decrement overflow");
311         unchecked {
312             counter._value = value - 1;
313         }
314     }
315 
316     function reset(Counter storage counter) internal {
317         counter._value = 0;
318     }
319 }
320 
321 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Contract module that helps prevent reentrant calls to a function.
330  *
331  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
332  * available, which can be applied to functions to make sure there are no nested
333  * (reentrant) calls to them.
334  *
335  * Note that because there is a single `nonReentrant` guard, functions marked as
336  * `nonReentrant` may not call one another. This can be worked around by making
337  * those functions `private`, and then adding `external` `nonReentrant` entry
338  * points to them.
339  *
340  * TIP: If you would like to learn more about reentrancy and alternative ways
341  * to protect against it, check out our blog post
342  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
343  */
344 abstract contract ReentrancyGuard {
345     // Booleans are more expensive than uint256 or any type that takes up a full
346     // word because each write operation emits an extra SLOAD to first read the
347     // slot's contents, replace the bits taken up by the boolean, and then write
348     // back. This is the compiler's defense against contract upgrades and
349     // pointer aliasing, and it cannot be disabled.
350 
351     // The values being non-zero value makes deployment a bit more expensive,
352     // but in exchange the refund on every call to nonReentrant will be lower in
353     // amount. Since refunds are capped to a percentage of the total
354     // transaction's gas, it is best to keep them low in cases like this one, to
355     // increase the likelihood of the full refund coming into effect.
356     uint256 private constant _NOT_ENTERED = 1;
357     uint256 private constant _ENTERED = 2;
358 
359     uint256 private _status;
360 
361     constructor() {
362         _status = _NOT_ENTERED;
363     }
364 
365     /**
366      * @dev Prevents a contract from calling itself, directly or indirectly.
367      * Calling a `nonReentrant` function from another `nonReentrant`
368      * function is not supported. It is possible to prevent this from happening
369      * by making the `nonReentrant` function external, and making it call a
370      * `private` function that does the actual work.
371      */
372     modifier nonReentrant() {
373         // On the first call to nonReentrant, _notEntered will be true
374         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
375 
376         // Any calls to nonReentrant after this point will fail
377         _status = _ENTERED;
378 
379         _;
380 
381         // By storing the original value once again, a refund is triggered (see
382         // https://eips.ethereum.org/EIPS/eip-2200)
383         _status = _NOT_ENTERED;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Interface of the ERC20 standard as defined in the EIP.
396  */
397 interface IERC20 {
398     /**
399      * @dev Returns the amount of tokens in existence.
400      */
401     function totalSupply() external view returns (uint256);
402 
403     /**
404      * @dev Returns the amount of tokens owned by `account`.
405      */
406     function balanceOf(address account) external view returns (uint256);
407 
408     /**
409      * @dev Moves `amount` tokens from the caller's account to `recipient`.
410      *
411      * Returns a boolean value indicating whether the operation succeeded.
412      *
413      * Emits a {Transfer} event.
414      */
415     function transfer(address recipient, uint256 amount) external returns (bool);
416 
417     /**
418      * @dev Returns the remaining number of tokens that `spender` will be
419      * allowed to spend on behalf of `owner` through {transferFrom}. This is
420      * zero by default.
421      *
422      * This value changes when {approve} or {transferFrom} are called.
423      */
424     function allowance(address owner, address spender) external view returns (uint256);
425 
426     /**
427      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
428      *
429      * Returns a boolean value indicating whether the operation succeeded.
430      *
431      * IMPORTANT: Beware that changing an allowance with this method brings the risk
432      * that someone may use both the old and the new allowance by unfortunate
433      * transaction ordering. One possible solution to mitigate this race
434      * condition is to first reduce the spender's allowance to 0 and set the
435      * desired value afterwards:
436      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
437      *
438      * Emits an {Approval} event.
439      */
440     function approve(address spender, uint256 amount) external returns (bool);
441 
442     /**
443      * @dev Moves `amount` tokens from `sender` to `recipient` using the
444      * allowance mechanism. `amount` is then deducted from the caller's
445      * allowance.
446      *
447      * Returns a boolean value indicating whether the operation succeeded.
448      *
449      * Emits a {Transfer} event.
450      */
451     function transferFrom(
452         address sender,
453         address recipient,
454         uint256 amount
455     ) external returns (bool);
456 
457     /**
458      * @dev Emitted when `value` tokens are moved from one account (`from`) to
459      * another (`to`).
460      *
461      * Note that `value` may be zero.
462      */
463     event Transfer(address indexed from, address indexed to, uint256 value);
464 
465     /**
466      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
467      * a call to {approve}. `value` is the new allowance.
468      */
469     event Approval(address indexed owner, address indexed spender, uint256 value);
470 }
471 
472 // File: @openzeppelin/contracts/interfaces/IERC20.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 
480 // File: @openzeppelin/contracts/utils/Strings.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev String operations.
489  */
490 library Strings {
491     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
495      */
496     function toString(uint256 value) internal pure returns (string memory) {
497         // Inspired by OraclizeAPI's implementation - MIT licence
498         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
499 
500         if (value == 0) {
501             return "0";
502         }
503         uint256 temp = value;
504         uint256 digits;
505         while (temp != 0) {
506             digits++;
507             temp /= 10;
508         }
509         bytes memory buffer = new bytes(digits);
510         while (value != 0) {
511             digits -= 1;
512             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
513             value /= 10;
514         }
515         return string(buffer);
516     }
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
520      */
521     function toHexString(uint256 value) internal pure returns (string memory) {
522         if (value == 0) {
523             return "0x00";
524         }
525         uint256 temp = value;
526         uint256 length = 0;
527         while (temp != 0) {
528             length++;
529             temp >>= 8;
530         }
531         return toHexString(value, length);
532     }
533 
534     /**
535      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
536      */
537     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
538         bytes memory buffer = new bytes(2 * length + 2);
539         buffer[0] = "0";
540         buffer[1] = "x";
541         for (uint256 i = 2 * length + 1; i > 1; --i) {
542             buffer[i] = _HEX_SYMBOLS[value & 0xf];
543             value >>= 4;
544         }
545         require(value == 0, "Strings: hex length insufficient");
546         return string(buffer);
547     }
548 }
549 
550 // File: @openzeppelin/contracts/utils/Context.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev Provides information about the current execution context, including the
559  * sender of the transaction and its data. While these are generally available
560  * via msg.sender and msg.data, they should not be accessed in such a direct
561  * manner, since when dealing with meta-transactions the account sending and
562  * paying for execution may not be the actual sender (as far as an application
563  * is concerned).
564  *
565  * This contract is only required for intermediate, library-like contracts.
566  */
567 abstract contract Context {
568     function _msgSender() internal view virtual returns (address) {
569         return msg.sender;
570     }
571 
572     function _msgData() internal view virtual returns (bytes calldata) {
573         return msg.data;
574     }
575 }
576 
577 // File: @openzeppelin/contracts/access/Ownable.sol
578 
579 
580 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @dev Contract module which provides a basic access control mechanism, where
587  * there is an account (an owner) that can be granted exclusive access to
588  * specific functions.
589  *
590  * By default, the owner account will be the one that deploys the contract. This
591  * can later be changed with {transferOwnership}.
592  *
593  * This module is used through inheritance. It will make available the modifier
594  * `onlyOwner`, which can be applied to your functions to restrict their use to
595  * the owner.
596  */
597 abstract contract Ownable is Context {
598     address private _owner;
599 
600     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
601 
602     /**
603      * @dev Initializes the contract setting the deployer as the initial owner.
604      */
605     constructor() {
606         _transferOwnership(_msgSender());
607     }
608 
609     /**
610      * @dev Returns the address of the current owner.
611      */
612     function owner() public view virtual returns (address) {
613         return _owner;
614     }
615 
616     /**
617      * @dev Throws if called by any account other than the owner.
618      */
619     modifier onlyOwner() {
620         require(owner() == _msgSender(), "Ownable: caller is not the owner");
621         _;
622     }
623 
624     /**
625      * @dev Leaves the contract without owner. It will not be possible to call
626      * `onlyOwner` functions anymore. Can only be called by the current owner.
627      *
628      * NOTE: Renouncing ownership will leave the contract without an owner,
629      * thereby removing any functionality that is only available to the owner.
630      */
631     function renounceOwnership() public virtual onlyOwner {
632         _transferOwnership(address(0));
633     }
634 
635     /**
636      * @dev Transfers ownership of the contract to a new account (`newOwner`).
637      * Can only be called by the current owner.
638      */
639     function transferOwnership(address newOwner) public virtual onlyOwner {
640         require(newOwner != address(0), "Ownable: new owner is the zero address");
641         _transferOwnership(newOwner);
642     }
643 
644     /**
645      * @dev Transfers ownership of the contract to a new account (`newOwner`).
646      * Internal function without access restriction.
647      */
648     function _transferOwnership(address newOwner) internal virtual {
649         address oldOwner = _owner;
650         _owner = newOwner;
651         emit OwnershipTransferred(oldOwner, newOwner);
652     }
653 }
654 
655 // File: @openzeppelin/contracts/utils/Address.sol
656 
657 
658 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @dev Collection of functions related to the address type
664  */
665 library Address {
666     /**
667      * @dev Returns true if `account` is a contract.
668      *
669      * [IMPORTANT]
670      * ====
671      * It is unsafe to assume that an address for which this function returns
672      * false is an externally-owned account (EOA) and not a contract.
673      *
674      * Among others, `isContract` will return false for the following
675      * types of addresses:
676      *
677      *  - an externally-owned account
678      *  - a contract in construction
679      *  - an address where a contract will be created
680      *  - an address where a contract lived, but was destroyed
681      * ====
682      */
683     function isContract(address account) internal view returns (bool) {
684         // This method relies on extcodesize, which returns 0 for contracts in
685         // construction, since the code is only stored at the end of the
686         // constructor execution.
687 
688         uint256 size;
689         assembly {
690             size := extcodesize(account)
691         }
692         return size > 0;
693     }
694 
695     /**
696      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
697      * `recipient`, forwarding all available gas and reverting on errors.
698      *
699      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
700      * of certain opcodes, possibly making contracts go over the 2300 gas limit
701      * imposed by `transfer`, making them unable to receive funds via
702      * `transfer`. {sendValue} removes this limitation.
703      *
704      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
705      *
706      * IMPORTANT: because control is transferred to `recipient`, care must be
707      * taken to not create reentrancy vulnerabilities. Consider using
708      * {ReentrancyGuard} or the
709      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
710      */
711     function sendValue(address payable recipient, uint256 amount) internal {
712         require(address(this).balance >= amount, "Address: insufficient balance");
713 
714         (bool success, ) = recipient.call{value: amount}("");
715         require(success, "Address: unable to send value, recipient may have reverted");
716     }
717 
718     /**
719      * @dev Performs a Solidity function call using a low level `call`. A
720      * plain `call` is an unsafe replacement for a function call: use this
721      * function instead.
722      *
723      * If `target` reverts with a revert reason, it is bubbled up by this
724      * function (like regular Solidity function calls).
725      *
726      * Returns the raw returned data. To convert to the expected return value,
727      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
728      *
729      * Requirements:
730      *
731      * - `target` must be a contract.
732      * - calling `target` with `data` must not revert.
733      *
734      * _Available since v3.1._
735      */
736     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
737         return functionCall(target, data, "Address: low-level call failed");
738     }
739 
740     /**
741      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
742      * `errorMessage` as a fallback revert reason when `target` reverts.
743      *
744      * _Available since v3.1._
745      */
746     function functionCall(
747         address target,
748         bytes memory data,
749         string memory errorMessage
750     ) internal returns (bytes memory) {
751         return functionCallWithValue(target, data, 0, errorMessage);
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
756      * but also transferring `value` wei to `target`.
757      *
758      * Requirements:
759      *
760      * - the calling contract must have an ETH balance of at least `value`.
761      * - the called Solidity function must be `payable`.
762      *
763      * _Available since v3.1._
764      */
765     function functionCallWithValue(
766         address target,
767         bytes memory data,
768         uint256 value
769     ) internal returns (bytes memory) {
770         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
775      * with `errorMessage` as a fallback revert reason when `target` reverts.
776      *
777      * _Available since v3.1._
778      */
779     function functionCallWithValue(
780         address target,
781         bytes memory data,
782         uint256 value,
783         string memory errorMessage
784     ) internal returns (bytes memory) {
785         require(address(this).balance >= value, "Address: insufficient balance for call");
786         require(isContract(target), "Address: call to non-contract");
787 
788         (bool success, bytes memory returndata) = target.call{value: value}(data);
789         return verifyCallResult(success, returndata, errorMessage);
790     }
791 
792     /**
793      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
794      * but performing a static call.
795      *
796      * _Available since v3.3._
797      */
798     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
799         return functionStaticCall(target, data, "Address: low-level static call failed");
800     }
801 
802     /**
803      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
804      * but performing a static call.
805      *
806      * _Available since v3.3._
807      */
808     function functionStaticCall(
809         address target,
810         bytes memory data,
811         string memory errorMessage
812     ) internal view returns (bytes memory) {
813         require(isContract(target), "Address: static call to non-contract");
814 
815         (bool success, bytes memory returndata) = target.staticcall(data);
816         return verifyCallResult(success, returndata, errorMessage);
817     }
818 
819     /**
820      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
821      * but performing a delegate call.
822      *
823      * _Available since v3.4._
824      */
825     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
826         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
827     }
828 
829     /**
830      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
831      * but performing a delegate call.
832      *
833      * _Available since v3.4._
834      */
835     function functionDelegateCall(
836         address target,
837         bytes memory data,
838         string memory errorMessage
839     ) internal returns (bytes memory) {
840         require(isContract(target), "Address: delegate call to non-contract");
841 
842         (bool success, bytes memory returndata) = target.delegatecall(data);
843         return verifyCallResult(success, returndata, errorMessage);
844     }
845 
846     /**
847      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
848      * revert reason using the provided one.
849      *
850      * _Available since v4.3._
851      */
852     function verifyCallResult(
853         bool success,
854         bytes memory returndata,
855         string memory errorMessage
856     ) internal pure returns (bytes memory) {
857         if (success) {
858             return returndata;
859         } else {
860             // Look for revert reason and bubble it up if present
861             if (returndata.length > 0) {
862                 // The easiest way to bubble the revert reason is using memory via assembly
863 
864                 assembly {
865                     let returndata_size := mload(returndata)
866                     revert(add(32, returndata), returndata_size)
867                 }
868             } else {
869                 revert(errorMessage);
870             }
871         }
872     }
873 }
874 
875 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
876 
877 
878 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
879 
880 pragma solidity ^0.8.0;
881 
882 /**
883  * @title ERC721 token receiver interface
884  * @dev Interface for any contract that wants to support safeTransfers
885  * from ERC721 asset contracts.
886  */
887 interface IERC721Receiver {
888     /**
889      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
890      * by `operator` from `from`, this function is called.
891      *
892      * It must return its Solidity selector to confirm the token transfer.
893      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
894      *
895      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
896      */
897     function onERC721Received(
898         address operator,
899         address from,
900         uint256 tokenId,
901         bytes calldata data
902     ) external returns (bytes4);
903 }
904 
905 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
906 
907 
908 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 /**
913  * @dev Interface of the ERC165 standard, as defined in the
914  * https://eips.ethereum.org/EIPS/eip-165[EIP].
915  *
916  * Implementers can declare support of contract interfaces, which can then be
917  * queried by others ({ERC165Checker}).
918  *
919  * For an implementation, see {ERC165}.
920  */
921 interface IERC165 {
922     /**
923      * @dev Returns true if this contract implements the interface defined by
924      * `interfaceId`. See the corresponding
925      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
926      * to learn more about how these ids are created.
927      *
928      * This function call must use less than 30 000 gas.
929      */
930     function supportsInterface(bytes4 interfaceId) external view returns (bool);
931 }
932 
933 // File: @openzeppelin/contracts/interfaces/IERC165.sol
934 
935 
936 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
937 
938 pragma solidity ^0.8.0;
939 
940 
941 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
942 
943 
944 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
945 
946 pragma solidity ^0.8.0;
947 
948 
949 /**
950  * @dev Interface for the NFT Royalty Standard
951  */
952 interface IERC2981 is IERC165 {
953     /**
954      * @dev Called with the sale price to determine how much royalty is owed and to whom.
955      * @param tokenId - the NFT asset queried for royalty information
956      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
957      * @return receiver - address of who should be sent the royalty payment
958      * @return royaltyAmount - the royalty payment amount for `salePrice`
959      */
960     function royaltyInfo(uint256 tokenId, uint256 salePrice)
961         external
962         view
963         returns (address receiver, uint256 royaltyAmount);
964 }
965 
966 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
967 
968 
969 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
970 
971 pragma solidity ^0.8.0;
972 
973 
974 /**
975  * @dev Implementation of the {IERC165} interface.
976  *
977  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
978  * for the additional interface id that will be supported. For example:
979  *
980  * ```solidity
981  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
982  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
983  * }
984  * ```
985  *
986  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
987  */
988 abstract contract ERC165 is IERC165 {
989     /**
990      * @dev See {IERC165-supportsInterface}.
991      */
992     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
993         return interfaceId == type(IERC165).interfaceId;
994     }
995 }
996 
997 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
998 
999 
1000 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1001 
1002 pragma solidity ^0.8.0;
1003 
1004 
1005 /**
1006  * @dev Required interface of an ERC721 compliant contract.
1007  */
1008 interface IERC721 is IERC165 {
1009     /**
1010      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1011      */
1012     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1013 
1014     /**
1015      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1016      */
1017     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1018 
1019     /**
1020      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1021      */
1022     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1023 
1024     /**
1025      * @dev Returns the number of tokens in ``owner``'s account.
1026      */
1027     function balanceOf(address owner) external view returns (uint256 balance);
1028 
1029     /**
1030      * @dev Returns the owner of the `tokenId` token.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must exist.
1035      */
1036     function ownerOf(uint256 tokenId) external view returns (address owner);
1037 
1038     /**
1039      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1040      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1041      *
1042      * Requirements:
1043      *
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must exist and be owned by `from`.
1047      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1048      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) external;
1057 
1058     /**
1059      * @dev Transfers `tokenId` token from `from` to `to`.
1060      *
1061      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1062      *
1063      * Requirements:
1064      *
1065      * - `from` cannot be the zero address.
1066      * - `to` cannot be the zero address.
1067      * - `tokenId` token must be owned by `from`.
1068      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function transferFrom(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) external;
1077 
1078     /**
1079      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1080      * The approval is cleared when the token is transferred.
1081      *
1082      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1083      *
1084      * Requirements:
1085      *
1086      * - The caller must own the token or be an approved operator.
1087      * - `tokenId` must exist.
1088      *
1089      * Emits an {Approval} event.
1090      */
1091     function approve(address to, uint256 tokenId) external;
1092 
1093     /**
1094      * @dev Returns the account approved for `tokenId` token.
1095      *
1096      * Requirements:
1097      *
1098      * - `tokenId` must exist.
1099      */
1100     function getApproved(uint256 tokenId) external view returns (address operator);
1101 
1102     /**
1103      * @dev Approve or remove `operator` as an operator for the caller.
1104      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1105      *
1106      * Requirements:
1107      *
1108      * - The `operator` cannot be the caller.
1109      *
1110      * Emits an {ApprovalForAll} event.
1111      */
1112     function setApprovalForAll(address operator, bool _approved) external;
1113 
1114     /**
1115      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1116      *
1117      * See {setApprovalForAll}
1118      */
1119     function isApprovedForAll(address owner, address operator) external view returns (bool);
1120 
1121     /**
1122      * @dev Safely transfers `tokenId` token from `from` to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - `from` cannot be the zero address.
1127      * - `to` cannot be the zero address.
1128      * - `tokenId` token must exist and be owned by `from`.
1129      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function safeTransferFrom(
1135         address from,
1136         address to,
1137         uint256 tokenId,
1138         bytes calldata data
1139     ) external;
1140 }
1141 
1142 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1143 
1144 
1145 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 
1150 /**
1151  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1152  * @dev See https://eips.ethereum.org/EIPS/eip-721
1153  */
1154 interface IERC721Enumerable is IERC721 {
1155     /**
1156      * @dev Returns the total amount of tokens stored by the contract.
1157      */
1158     function totalSupply() external view returns (uint256);
1159 
1160     /**
1161      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1162      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1163      */
1164     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1165 
1166     /**
1167      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1168      * Use along with {totalSupply} to enumerate all tokens.
1169      */
1170     function tokenByIndex(uint256 index) external view returns (uint256);
1171 }
1172 
1173 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1174 
1175 
1176 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 /**
1182  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1183  * @dev See https://eips.ethereum.org/EIPS/eip-721
1184  */
1185 interface IERC721Metadata is IERC721 {
1186     /**
1187      * @dev Returns the token collection name.
1188      */
1189     function name() external view returns (string memory);
1190 
1191     /**
1192      * @dev Returns the token collection symbol.
1193      */
1194     function symbol() external view returns (string memory);
1195 
1196     /**
1197      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1198      */
1199     function tokenURI(uint256 tokenId) external view returns (string memory);
1200 }
1201 
1202 // File: contracts/ERC721A.sol
1203 
1204 
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 
1209 
1210 
1211 
1212 
1213 
1214 
1215 
1216 /**
1217  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1218  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1219  *
1220  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1221  *
1222  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1223  *
1224  * Does not support burning tokens to address(0).
1225  */
1226 contract ERC721A is
1227   Context,
1228   ERC165,
1229   IERC721,
1230   IERC721Metadata,
1231   IERC721Enumerable
1232 {
1233   using Address for address;
1234   using Strings for uint256;
1235 
1236   struct TokenOwnership {
1237     address addr;
1238     uint64 startTimestamp;
1239   }
1240 
1241   struct AddressData {
1242     uint128 balance;
1243     uint128 numberMinted;
1244   }
1245 
1246   uint256 private currentIndex = 0;
1247 
1248   uint256 internal immutable collectionSize;
1249   uint256 internal immutable maxBatchSize;
1250 
1251   // Token name
1252   string private _name;
1253 
1254   // Token symbol
1255   string private _symbol;
1256 
1257   // Mapping from token ID to ownership details
1258   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1259   mapping(uint256 => TokenOwnership) private _ownerships;
1260 
1261   // Mapping owner address to address data
1262   mapping(address => AddressData) private _addressData;
1263 
1264   // Mapping from token ID to approved address
1265   mapping(uint256 => address) private _tokenApprovals;
1266 
1267   // Mapping from owner to operator approvals
1268   mapping(address => mapping(address => bool)) private _operatorApprovals;
1269 
1270   /**
1271    * @dev
1272    * `maxBatchSize` refers to how much a minter can mint at a time.
1273    * `collectionSize_` refers to how many tokens are in the collection.
1274    */
1275   constructor(
1276     string memory name_,
1277     string memory symbol_,
1278     uint256 maxBatchSize_,
1279     uint256 collectionSize_
1280   ) {
1281     require(
1282       collectionSize_ > 0,
1283       "ERC721A: collection must have a nonzero supply"
1284     );
1285     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1286     _name = name_;
1287     _symbol = symbol_;
1288     maxBatchSize = maxBatchSize_;
1289     collectionSize = collectionSize_;
1290   }
1291 
1292   /**
1293    * @dev See {IERC721Enumerable-totalSupply}.
1294    */
1295   function totalSupply() public view override returns (uint256) {
1296     return currentIndex;
1297   }
1298 
1299   /**
1300    * @dev See {IERC721Enumerable-tokenByIndex}.
1301    */
1302   function tokenByIndex(uint256 index) public view override returns (uint256) {
1303     require(index < totalSupply(), "ERC721A: global index out of bounds");
1304     return index;
1305   }
1306 
1307   /**
1308    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1309    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1310    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1311    */
1312   function tokenOfOwnerByIndex(address owner, uint256 index)
1313     public
1314     view
1315     override
1316     returns (uint256)
1317   {
1318     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1319     uint256 numMintedSoFar = totalSupply();
1320     uint256 tokenIdsIdx = 0;
1321     address currOwnershipAddr = address(0);
1322     for (uint256 i = 0; i < numMintedSoFar; i++) {
1323       TokenOwnership memory ownership = _ownerships[i];
1324       if (ownership.addr != address(0)) {
1325         currOwnershipAddr = ownership.addr;
1326       }
1327       if (currOwnershipAddr == owner) {
1328         if (tokenIdsIdx == index) {
1329           return i;
1330         }
1331         tokenIdsIdx++;
1332       }
1333     }
1334     revert("ERC721A: unable to get token of owner by index");
1335   }
1336 
1337   /**
1338    * @dev See {IERC165-supportsInterface}.
1339    */
1340   function supportsInterface(bytes4 interfaceId)
1341     public
1342     view
1343     virtual
1344     override(ERC165, IERC165)
1345     returns (bool)
1346   {
1347     return
1348       interfaceId == type(IERC721).interfaceId ||
1349       interfaceId == type(IERC721Metadata).interfaceId ||
1350       interfaceId == type(IERC721Enumerable).interfaceId ||
1351       super.supportsInterface(interfaceId);
1352   }
1353 
1354   /**
1355    * @dev See {IERC721-balanceOf}.
1356    */
1357   function balanceOf(address owner) public view override returns (uint256) {
1358     require(owner != address(0), "ERC721A: balance query for the zero address");
1359     return uint256(_addressData[owner].balance);
1360   }
1361 
1362   function _numberMinted(address owner) internal view returns (uint256) {
1363     require(
1364       owner != address(0),
1365       "ERC721A: number minted query for the zero address"
1366     );
1367     return uint256(_addressData[owner].numberMinted);
1368   }
1369 
1370   function ownershipOf(uint256 tokenId)
1371     internal
1372     view
1373     returns (TokenOwnership memory)
1374   {
1375     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1376 
1377     uint256 lowestTokenToCheck;
1378     if (tokenId >= maxBatchSize) {
1379       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1380     }
1381 
1382     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1383       TokenOwnership memory ownership = _ownerships[curr];
1384       if (ownership.addr != address(0)) {
1385         return ownership;
1386       }
1387     }
1388 
1389     revert("ERC721A: unable to determine the owner of token");
1390   }
1391 
1392   /**
1393    * @dev See {IERC721-ownerOf}.
1394    */
1395   function ownerOf(uint256 tokenId) public view override returns (address) {
1396     return ownershipOf(tokenId).addr;
1397   }
1398 
1399   /**
1400    * @dev See {IERC721Metadata-name}.
1401    */
1402   function name() public view virtual override returns (string memory) {
1403     return _name;
1404   }
1405 
1406   /**
1407    * @dev See {IERC721Metadata-symbol}.
1408    */
1409   function symbol() public view virtual override returns (string memory) {
1410     return _symbol;
1411   }
1412 
1413   /**
1414    * @dev See {IERC721Metadata-tokenURI}.
1415    */
1416   function tokenURI(uint256 tokenId)
1417     public
1418     view
1419     virtual
1420     override
1421     returns (string memory)
1422   {
1423     require(
1424       _exists(tokenId),
1425       "ERC721Metadata: URI query for nonexistent token"
1426     );
1427 
1428     string memory baseURI = _baseURI();
1429     return
1430       bytes(baseURI).length > 0
1431         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1432         : "";
1433   }
1434 
1435   /**
1436    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1437    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1438    * by default, can be overriden in child contracts.
1439    */
1440   function _baseURI() internal view virtual returns (string memory) {
1441     return "";
1442   }
1443 
1444   /**
1445    * @dev See {IERC721-approve}.
1446    */
1447   function approve(address to, uint256 tokenId) public override {
1448     address owner = ERC721A.ownerOf(tokenId);
1449     require(to != owner, "ERC721A: approval to current owner");
1450 
1451     require(
1452       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1453       "ERC721A: approve caller is not owner nor approved for all"
1454     );
1455 
1456     _approve(to, tokenId, owner);
1457   }
1458 
1459   /**
1460    * @dev See {IERC721-getApproved}.
1461    */
1462   function getApproved(uint256 tokenId) public view override returns (address) {
1463     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1464 
1465     return _tokenApprovals[tokenId];
1466   }
1467 
1468   /**
1469    * @dev See {IERC721-setApprovalForAll}.
1470    */
1471   function setApprovalForAll(address operator, bool approved) public override {
1472     require(operator != _msgSender(), "ERC721A: approve to caller");
1473 
1474     _operatorApprovals[_msgSender()][operator] = approved;
1475     emit ApprovalForAll(_msgSender(), operator, approved);
1476   }
1477 
1478   /**
1479    * @dev See {IERC721-isApprovedForAll}.
1480    */
1481   function isApprovedForAll(address owner, address operator)
1482     public
1483     view
1484     virtual
1485     override
1486     returns (bool)
1487   {
1488     return _operatorApprovals[owner][operator];
1489   }
1490 
1491   /**
1492    * @dev See {IERC721-transferFrom}.
1493    */
1494   function transferFrom(
1495     address from,
1496     address to,
1497     uint256 tokenId
1498   ) public override {
1499     _transfer(from, to, tokenId);
1500   }
1501 
1502   /**
1503    * @dev See {IERC721-safeTransferFrom}.
1504    */
1505   function safeTransferFrom(
1506     address from,
1507     address to,
1508     uint256 tokenId
1509   ) public override {
1510     safeTransferFrom(from, to, tokenId, "");
1511   }
1512 
1513   /**
1514    * @dev See {IERC721-safeTransferFrom}.
1515    */
1516   function safeTransferFrom(
1517     address from,
1518     address to,
1519     uint256 tokenId,
1520     bytes memory _data
1521   ) public override {
1522     _transfer(from, to, tokenId);
1523     require(
1524       _checkOnERC721Received(from, to, tokenId, _data),
1525       "ERC721A: transfer to non ERC721Receiver implementer"
1526     );
1527   }
1528 
1529   /**
1530    * @dev Returns whether `tokenId` exists.
1531    *
1532    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1533    *
1534    * Tokens start existing when they are minted (`_mint`),
1535    */
1536   function _exists(uint256 tokenId) internal view returns (bool) {
1537     return tokenId < currentIndex;
1538   }
1539 
1540   function _safeMint(address to, uint256 quantity) internal {
1541     _safeMint(to, quantity, "");
1542   }
1543 
1544   /**
1545    * @dev Mints `quantity` tokens and transfers them to `to`.
1546    *
1547    * Requirements:
1548    *
1549    * - there must be `quantity` tokens remaining unminted in the total collection.
1550    * - `to` cannot be the zero address.
1551    * - `quantity` cannot be larger than the max batch size.
1552    *
1553    * Emits a {Transfer} event.
1554    */
1555   function _safeMint(
1556     address to,
1557     uint256 quantity,
1558     bytes memory _data
1559   ) internal {
1560     uint256 startTokenId = currentIndex;
1561     require(to != address(0), "ERC721A: mint to the zero address");
1562     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1563     require(!_exists(startTokenId), "ERC721A: token already minted");
1564     // require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1565 
1566     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1567 
1568     AddressData memory addressData = _addressData[to];
1569     _addressData[to] = AddressData(
1570       addressData.balance + uint128(quantity),
1571       addressData.numberMinted + uint128(quantity)
1572     );
1573     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1574 
1575     uint256 updatedIndex = startTokenId;
1576 
1577     for (uint256 i = 0; i < quantity; i++) {
1578       emit Transfer(address(0), to, updatedIndex);
1579       require(
1580         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1581         "ERC721A: transfer to non ERC721Receiver implementer"
1582       );
1583       updatedIndex++;
1584     }
1585 
1586     currentIndex = updatedIndex;
1587     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1588   }
1589 
1590   /**
1591    * @dev Transfers `tokenId` from `from` to `to`.
1592    *
1593    * Requirements:
1594    *
1595    * - `to` cannot be the zero address.
1596    * - `tokenId` token must be owned by `from`.
1597    *
1598    * Emits a {Transfer} event.
1599    */
1600   function _transfer(
1601     address from,
1602     address to,
1603     uint256 tokenId
1604   ) private {
1605     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1606 
1607     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1608       getApproved(tokenId) == _msgSender() ||
1609       isApprovedForAll(prevOwnership.addr, _msgSender()));
1610 
1611     require(
1612       isApprovedOrOwner,
1613       "ERC721A: transfer caller is not owner nor approved"
1614     );
1615 
1616     require(
1617       prevOwnership.addr == from,
1618       "ERC721A: transfer from incorrect owner"
1619     );
1620     require(to != address(0), "ERC721A: transfer to the zero address");
1621 
1622     _beforeTokenTransfers(from, to, tokenId, 1);
1623 
1624     // Clear approvals from the previous owner
1625     _approve(address(0), tokenId, prevOwnership.addr);
1626 
1627     _addressData[from].balance -= 1;
1628     _addressData[to].balance += 1;
1629     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1630 
1631     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1632     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1633     uint256 nextTokenId = tokenId + 1;
1634     if (_ownerships[nextTokenId].addr == address(0)) {
1635       if (_exists(nextTokenId)) {
1636         _ownerships[nextTokenId] = TokenOwnership(
1637           prevOwnership.addr,
1638           prevOwnership.startTimestamp
1639         );
1640       }
1641     }
1642 
1643     emit Transfer(from, to, tokenId);
1644     _afterTokenTransfers(from, to, tokenId, 1);
1645   }
1646 
1647   /**
1648    * @dev Approve `to` to operate on `tokenId`
1649    *
1650    * Emits a {Approval} event.
1651    */
1652   function _approve(
1653     address to,
1654     uint256 tokenId,
1655     address owner
1656   ) private {
1657     _tokenApprovals[tokenId] = to;
1658     emit Approval(owner, to, tokenId);
1659   }
1660 
1661   uint256 public nextOwnerToExplicitlySet = 0;
1662 
1663   /**
1664    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1665    */
1666   function _setOwnersExplicit(uint256 quantity) internal {
1667     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1668     require(quantity > 0, "quantity must be nonzero");
1669     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1670     if (endIndex > collectionSize - 1) {
1671       endIndex = collectionSize - 1;
1672     }
1673     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1674     require(_exists(endIndex), "not enough minted yet for this cleanup");
1675     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1676       if (_ownerships[i].addr == address(0)) {
1677         TokenOwnership memory ownership = ownershipOf(i);
1678         _ownerships[i] = TokenOwnership(
1679           ownership.addr,
1680           ownership.startTimestamp
1681         );
1682       }
1683     }
1684     nextOwnerToExplicitlySet = endIndex + 1;
1685   }
1686 
1687   /**
1688    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1689    * The call is not executed if the target address is not a contract.
1690    *
1691    * @param from address representing the previous owner of the given token ID
1692    * @param to target address that will receive the tokens
1693    * @param tokenId uint256 ID of the token to be transferred
1694    * @param _data bytes optional data to send along with the call
1695    * @return bool whether the call correctly returned the expected magic value
1696    */
1697   function _checkOnERC721Received(
1698     address from,
1699     address to,
1700     uint256 tokenId,
1701     bytes memory _data
1702   ) private returns (bool) {
1703     if (to.isContract()) {
1704       try
1705         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1706       returns (bytes4 retval) {
1707         return retval == IERC721Receiver(to).onERC721Received.selector;
1708       } catch (bytes memory reason) {
1709         if (reason.length == 0) {
1710           revert("ERC721A: transfer to non ERC721Receiver implementer");
1711         } else {
1712           assembly {
1713             revert(add(32, reason), mload(reason))
1714           }
1715         }
1716       }
1717     } else {
1718       return true;
1719     }
1720   }
1721 
1722   /**
1723    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1724    *
1725    * startTokenId - the first token id to be transferred
1726    * quantity - the amount to be transferred
1727    *
1728    * Calling conditions:
1729    *
1730    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1731    * transferred to `to`.
1732    * - When `from` is zero, `tokenId` will be minted for `to`.
1733    */
1734   function _beforeTokenTransfers(
1735     address from,
1736     address to,
1737     uint256 startTokenId,
1738     uint256 quantity
1739   ) internal virtual {}
1740 
1741   /**
1742    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1743    * minting.
1744    *
1745    * startTokenId - the first token id to be transferred
1746    * quantity - the amount to be transferred
1747    *
1748    * Calling conditions:
1749    *
1750    * - when `from` and `to` are both non-zero.
1751    * - `from` and `to` are never both zero.
1752    */
1753   function _afterTokenTransfers(
1754     address from,
1755     address to,
1756     uint256 startTokenId,
1757     uint256 quantity
1758   ) internal virtual {}
1759 }
1760 // File: contracts/Azuki4People.sol
1761 
1762 //SPDX-License-Identifier: MIT
1763 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1764 
1765 pragma solidity ^0.8.0;
1766 
1767 
1768 
1769 
1770 
1771 
1772 
1773 
1774 
1775 contract Azuki4People is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1776     using Counters for Counters.Counter;
1777     using Strings for uint256;
1778 
1779     Counters.Counter private tokenCounter;
1780 
1781     string private baseURI = "ipfs://QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW";
1782 
1783     uint256 public constant MAX_MINTS_PER_TX = 10;
1784     uint256 public maxSupply = 3333;
1785 
1786     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
1787     bool public isPublicSaleActive = false;
1788 
1789 
1790 
1791 
1792     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1793 
1794     modifier publicSaleActive() {
1795         require(isPublicSaleActive, "Public sale is not open");
1796         _;
1797     }
1798 
1799 
1800 
1801     modifier maxMintsPerTX(uint256 numberOfTokens) {
1802         require(
1803             numberOfTokens <= MAX_MINTS_PER_TX,
1804             "Max mints per transaction exceeded"
1805         );
1806         _;
1807     }
1808 
1809     modifier canMintNFTs(uint256 numberOfTokens) {
1810         require(
1811             totalSupply() + numberOfTokens <=
1812                 maxSupply,
1813             "Not enough mints remaining to mint"
1814         );
1815         _;
1816     }
1817 
1818     constructor(
1819     ) ERC721A("Azuki For People", "Azuki", 100, maxSupply) {
1820     }
1821 
1822     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1823         require(
1824             (price * numberOfTokens) == msg.value,
1825             "Incorrect ETH value sent"
1826         );
1827         _;
1828     }
1829 
1830     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1831 
1832     function mint(uint256 numberOfTokens)
1833         external
1834         payable
1835         nonReentrant
1836         publicSaleActive
1837         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1838         canMintNFTs(numberOfTokens)
1839         maxMintsPerTX(numberOfTokens)
1840     {
1841 
1842         _safeMint(msg.sender, numberOfTokens);
1843     }
1844 
1845 
1846 
1847 
1848     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1849 
1850     function getBaseURI() external view returns (string memory) {
1851         return baseURI;
1852     }
1853 
1854     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1855 
1856     function setBaseURI(string memory _baseURI) external onlyOwner {
1857         baseURI = _baseURI;
1858     }
1859 
1860 
1861     function setIsPublicSaleActive(bool _isPublicSaleActive)
1862         external
1863         onlyOwner
1864     {
1865         isPublicSaleActive = _isPublicSaleActive;
1866     }
1867 
1868 
1869 
1870     function withdraw() public onlyOwner {
1871         uint256 balance = address(this).balance;
1872         payable(msg.sender).transfer(balance);
1873     }
1874 
1875     function withdrawTokens(IERC20 token) public onlyOwner {
1876         uint256 balance = token.balanceOf(address(this));
1877         token.transfer(msg.sender, balance);
1878     }
1879 
1880 
1881 
1882     // ============ SUPPORTING FUNCTIONS ============
1883 
1884     function nextTokenId() private returns (uint256) {
1885         tokenCounter.increment();
1886         return tokenCounter.current();
1887     }
1888 
1889     // ============ FUNCTION OVERRIDES ============
1890 
1891     function supportsInterface(bytes4 interfaceId)
1892         public
1893         view
1894         virtual
1895         override(ERC721A, IERC165)
1896         returns (bool)
1897     {
1898         return
1899             interfaceId == type(IERC2981).interfaceId ||
1900             super.supportsInterface(interfaceId);
1901     }
1902 
1903     /**
1904      * @dev See {IERC721Metadata-tokenURI}.
1905      */
1906     function tokenURI(uint256 tokenId)
1907         public
1908         view
1909         virtual
1910         override
1911         returns (string memory)
1912     {
1913         require(_exists(tokenId), "Nonexistent token");
1914 
1915         return
1916             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ""));
1917     }
1918 
1919     /**
1920      * @dev See {IERC165-royaltyInfo}.
1921      */
1922     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1923         external
1924         view
1925         override
1926         returns (address receiver, uint256 royaltyAmount)
1927     {
1928         require(_exists(tokenId), "Nonexistent token");
1929 
1930         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1931     }
1932 }
1933 
1934 // These contract definitions are used to create a reference to the OpenSea
1935 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1936 contract OwnableDelegateProxy {
1937 
1938 }
1939 
1940 contract ProxyRegistry {
1941     mapping(address => OwnableDelegateProxy) public proxies;
1942 }