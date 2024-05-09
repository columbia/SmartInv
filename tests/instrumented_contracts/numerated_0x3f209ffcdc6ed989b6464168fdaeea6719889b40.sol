1 // File: contracts/banksy.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-04-09
5 */
6 
7 // File: contracts/notBanksy.sol
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-03-30
11 */
12 
13 // File: contracts/notBanksy.sol
14 
15 /**
16  *Submitted for verification at Etherscan.io on 2022-03-19
17 */
18 
19 // File: contracts/notBanksy.sol
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2022-02-25
23 */
24 
25 // File: contracts/notBanksy.sol
26 
27 /**
28  *Submitted for verification at Etherscan.io on 2022-02-23
29 */
30 
31 /**
32  *Submitted for verification at Etherscan.io on 2022-02-14
33 */
34 
35 // File: contracts/notBanksy.sol
36 
37 /**
38  *Submitted for verification at Etherscan.io on 2022-01-18
39 */
40 
41 // File: contracts/notBanksy.sol
42 
43 /**
44  *Submitted for verification at Etherscan.io on 2022-01-18
45 */
46 
47 /**
48  *Submitted for verification at Etherscan.io on 2022-01-18
49 */
50 
51 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
52 
53 
54 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
55 
56 pragma solidity ^0.8.0;
57 
58 // CAUTION
59 // This version of SafeMath should only be used with Solidity 0.8 or later,
60 // because it relies on the compiler's built in overflow checks.
61 
62 /**
63  * @dev Wrappers over Solidity's arithmetic operations.
64  *
65  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
66  * now has built in overflow checking.
67  */
68 library SafeMath {
69     /**
70      * @dev Returns the addition of two unsigned integers, with an overflow flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             uint256 c = a + b;
77             if (c < a) return (false, 0);
78             return (true, c);
79         }
80     }
81 
82     /**
83      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
84      *
85      * _Available since v3.4._
86      */
87     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b > a) return (false, 0);
90             return (true, a - b);
91         }
92     }
93 
94     /**
95      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
96      *
97      * _Available since v3.4._
98      */
99     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
100         unchecked {
101             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102             // benefit is lost if 'b' is also tested.
103             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104             if (a == 0) return (true, 0);
105             uint256 c = a * b;
106             if (c / a != b) return (false, 0);
107             return (true, c);
108         }
109     }
110 
111     /**
112      * @dev Returns the division of two unsigned integers, with a division by zero flag.
113      *
114      * _Available since v3.4._
115      */
116     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             if (b == 0) return (false, 0);
119             return (true, a / b);
120         }
121     }
122 
123     /**
124      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         unchecked {
130             if (b == 0) return (false, 0);
131             return (true, a % b);
132         }
133     }
134 
135     /**
136      * @dev Returns the addition of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `+` operator.
140      *
141      * Requirements:
142      *
143      * - Addition cannot overflow.
144      */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a + b;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a - b;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a * b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator.
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a / b;
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * reverting when dividing by zero.
194      *
195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
196      * opcode (which leaves remaining gas untouched) while Solidity uses an
197      * invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a % b;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
209      * overflow (when the result is negative).
210      *
211      * CAUTION: This function is deprecated because it requires allocating memory for the error
212      * message unnecessarily. For custom revert reasons use {trySub}.
213      *
214      * Counterpart to Solidity's `-` operator.
215      *
216      * Requirements:
217      *
218      * - Subtraction cannot overflow.
219      */
220     function sub(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b <= a, errorMessage);
227             return a - b;
228         }
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         unchecked {
249             require(b > 0, errorMessage);
250             return a / b;
251         }
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * reverting with custom message when dividing by zero.
257      *
258      * CAUTION: This function is deprecated because it requires allocating memory for the error
259      * message unnecessarily. For custom revert reasons use {tryMod}.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         unchecked {
275             require(b > 0, errorMessage);
276             return a % b;
277         }
278     }
279 }
280 
281 // File: @openzeppelin/contracts/utils/Counters.sol
282 
283 
284 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 /**
289  * @title Counters
290  * @author Matt Condon (@shrugs)
291  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
292  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
293  *
294  * Include with `using Counters for Counters.Counter;`
295  */
296 library Counters {
297     struct Counter {
298         // This variable should never be directly accessed by users of the library: interactions must be restricted to
299         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
300         // this feature: see https://github.com/ethereum/solidity/issues/4637
301         uint256 _value; // default: 0
302     }
303 
304     function current(Counter storage counter) internal view returns (uint256) {
305         return counter._value;
306     }
307 
308     function increment(Counter storage counter) internal {
309         unchecked {
310             counter._value += 1;
311         }
312     }
313 
314     function decrement(Counter storage counter) internal {
315         uint256 value = counter._value;
316         require(value > 0, "Counter: decrement overflow");
317         unchecked {
318             counter._value = value - 1;
319         }
320     }
321 
322     function reset(Counter storage counter) internal {
323         counter._value = 0;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Contract module that helps prevent reentrant calls to a function.
336  *
337  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
338  * available, which can be applied to functions to make sure there are no nested
339  * (reentrant) calls to them.
340  *
341  * Note that because there is a single `nonReentrant` guard, functions marked as
342  * `nonReentrant` may not call one another. This can be worked around by making
343  * those functions `private`, and then adding `external` `nonReentrant` entry
344  * points to them.
345  *
346  * TIP: If you would like to learn more about reentrancy and alternative ways
347  * to protect against it, check out our blog post
348  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
349  */
350 abstract contract ReentrancyGuard {
351     // Booleans are more expensive than uint256 or any type that takes up a full
352     // word because each write operation emits an extra SLOAD to first read the
353     // slot's contents, replace the bits taken up by the boolean, and then write
354     // back. This is the compiler's defense against contract upgrades and
355     // pointer aliasing, and it cannot be disabled.
356 
357     // The values being non-zero value makes deployment a bit more expensive,
358     // but in exchange the refund on every call to nonReentrant will be lower in
359     // amount. Since refunds are capped to a percentage of the total
360     // transaction's gas, it is best to keep them low in cases like this one, to
361     // increase the likelihood of the full refund coming into effect.
362     uint256 private constant _NOT_ENTERED = 1;
363     uint256 private constant _ENTERED = 2;
364 
365     uint256 private _status;
366 
367     constructor() {
368         _status = _NOT_ENTERED;
369     }
370 
371     /**
372      * @dev Prevents a contract from calling itself, directly or indirectly.
373      * Calling a `nonReentrant` function from another `nonReentrant`
374      * function is not supported. It is possible to prevent this from happening
375      * by making the `nonReentrant` function external, and making it call a
376      * `private` function that does the actual work.
377      */
378     modifier nonReentrant() {
379         // On the first call to nonReentrant, _notEntered will be true
380         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
381 
382         // Any calls to nonReentrant after this point will fail
383         _status = _ENTERED;
384 
385         _;
386 
387         // By storing the original value once again, a refund is triggered (see
388         // https://eips.ethereum.org/EIPS/eip-2200)
389         _status = _NOT_ENTERED;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev Interface of the ERC20 standard as defined in the EIP.
402  */
403 interface IERC20 {
404     /**
405      * @dev Returns the amount of tokens in existence.
406      */
407     function totalSupply() external view returns (uint256);
408 
409     /**
410      * @dev Returns the amount of tokens owned by `account`.
411      */
412     function balanceOf(address account) external view returns (uint256);
413 
414     /**
415      * @dev Moves `amount` tokens from the caller's account to `recipient`.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transfer(address recipient, uint256 amount) external returns (bool);
422 
423     /**
424      * @dev Returns the remaining number of tokens that `spender` will be
425      * allowed to spend on behalf of `owner` through {transferFrom}. This is
426      * zero by default.
427      *
428      * This value changes when {approve} or {transferFrom} are called.
429      */
430     function allowance(address owner, address spender) external view returns (uint256);
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
434      *
435      * Returns a boolean value indicating whether the operation succeeded.
436      *
437      * IMPORTANT: Beware that changing an allowance with this method brings the risk
438      * that someone may use both the old and the new allowance by unfortunate
439      * transaction ordering. One possible solution to mitigate this race
440      * condition is to first reduce the spender's allowance to 0 and set the
441      * desired value afterwards:
442      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
443      *
444      * Emits an {Approval} event.
445      */
446     function approve(address spender, uint256 amount) external returns (bool);
447 
448     /**
449      * @dev Moves `amount` tokens from `sender` to `recipient` using the
450      * allowance mechanism. `amount` is then deducted from the caller's
451      * allowance.
452      *
453      * Returns a boolean value indicating whether the operation succeeded.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transferFrom(
458         address sender,
459         address recipient,
460         uint256 amount
461     ) external returns (bool);
462 
463     /**
464      * @dev Emitted when `value` tokens are moved from one account (`from`) to
465      * another (`to`).
466      *
467      * Note that `value` may be zero.
468      */
469     event Transfer(address indexed from, address indexed to, uint256 value);
470 
471     /**
472      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
473      * a call to {approve}. `value` is the new allowance.
474      */
475     event Approval(address indexed owner, address indexed spender, uint256 value);
476 }
477 
478 // File: @openzeppelin/contracts/interfaces/IERC20.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 
486 // File: @openzeppelin/contracts/utils/Strings.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev String operations.
495  */
496 library Strings {
497     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
501      */
502     function toString(uint256 value) internal pure returns (string memory) {
503         // Inspired by OraclizeAPI's implementation - MIT licence
504         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
505 
506         if (value == 0) {
507             return "0";
508         }
509         uint256 temp = value;
510         uint256 digits;
511         while (temp != 0) {
512             digits++;
513             temp /= 10;
514         }
515         bytes memory buffer = new bytes(digits);
516         while (value != 0) {
517             digits -= 1;
518             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
519             value /= 10;
520         }
521         return string(buffer);
522     }
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
526      */
527     function toHexString(uint256 value) internal pure returns (string memory) {
528         if (value == 0) {
529             return "0x00";
530         }
531         uint256 temp = value;
532         uint256 length = 0;
533         while (temp != 0) {
534             length++;
535             temp >>= 8;
536         }
537         return toHexString(value, length);
538     }
539 
540     /**
541      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
542      */
543     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
544         bytes memory buffer = new bytes(2 * length + 2);
545         buffer[0] = "0";
546         buffer[1] = "x";
547         for (uint256 i = 2 * length + 1; i > 1; --i) {
548             buffer[i] = _HEX_SYMBOLS[value & 0xf];
549             value >>= 4;
550         }
551         require(value == 0, "Strings: hex length insufficient");
552         return string(buffer);
553     }
554 }
555 
556 // File: @openzeppelin/contracts/utils/Context.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev Provides information about the current execution context, including the
565  * sender of the transaction and its data. While these are generally available
566  * via msg.sender and msg.data, they should not be accessed in such a direct
567  * manner, since when dealing with meta-transactions the account sending and
568  * paying for execution may not be the actual sender (as far as an application
569  * is concerned).
570  *
571  * This contract is only required for intermediate, library-like contracts.
572  */
573 abstract contract Context {
574     function _msgSender() internal view virtual returns (address) {
575         return msg.sender;
576     }
577 
578     function _msgData() internal view virtual returns (bytes calldata) {
579         return msg.data;
580     }
581 }
582 
583 // File: @openzeppelin/contracts/access/Ownable.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Contract module which provides a basic access control mechanism, where
593  * there is an account (an owner) that can be granted exclusive access to
594  * specific functions.
595  *
596  * By default, the owner account will be the one that deploys the contract. This
597  * can later be changed with {transferOwnership}.
598  *
599  * This module is used through inheritance. It will make available the modifier
600  * `onlyOwner`, which can be applied to your functions to restrict their use to
601  * the owner.
602  */
603 abstract contract Ownable is Context {
604     address private _owner;
605 
606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
607 
608     /**
609      * @dev Initializes the contract setting the deployer as the initial owner.
610      */
611     constructor() {
612         _transferOwnership(_msgSender());
613     }
614 
615     /**
616      * @dev Returns the address of the current owner.
617      */
618     function owner() public view virtual returns (address) {
619         return _owner;
620     }
621 
622     /**
623      * @dev Throws if called by any account other than the owner.
624      */
625     modifier onlyOwner() {
626         require(owner() == _msgSender(), "Ownable: caller is not the owner");
627         _;
628     }
629 
630     /**
631      * @dev Leaves the contract without owner. It will not be possible to call
632      * `onlyOwner` functions anymore. Can only be called by the current owner.
633      *
634      * NOTE: Renouncing ownership will leave the contract without an owner,
635      * thereby removing any functionality that is only available to the owner.
636      */
637     function renounceOwnership() public virtual onlyOwner {
638         _transferOwnership(address(0));
639     }
640 
641     /**
642      * @dev Transfers ownership of the contract to a new account (`newOwner`).
643      * Can only be called by the current owner.
644      */
645     function transferOwnership(address newOwner) public virtual onlyOwner {
646         require(newOwner != address(0), "Ownable: new owner is the zero address");
647         _transferOwnership(newOwner);
648     }
649 
650     /**
651      * @dev Transfers ownership of the contract to a new account (`newOwner`).
652      * Internal function without access restriction.
653      */
654     function _transferOwnership(address newOwner) internal virtual {
655         address oldOwner = _owner;
656         _owner = newOwner;
657         emit OwnershipTransferred(oldOwner, newOwner);
658     }
659 }
660 
661 // File: @openzeppelin/contracts/utils/Address.sol
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @dev Collection of functions related to the address type
670  */
671 library Address {
672     /**
673      * @dev Returns true if `account` is a contract.
674      *
675      * [IMPORTANT]
676      * ====
677      * It is unsafe to assume that an address for which this function returns
678      * false is an externally-owned account (EOA) and not a contract.
679      *
680      * Among others, `isContract` will return false for the following
681      * types of addresses:
682      *
683      *  - an externally-owned account
684      *  - a contract in construction
685      *  - an address where a contract will be created
686      *  - an address where a contract lived, but was destroyed
687      * ====
688      */
689     function isContract(address account) internal view returns (bool) {
690         // This method relies on extcodesize, which returns 0 for contracts in
691         // construction, since the code is only stored at the end of the
692         // constructor execution.
693 
694         uint256 size;
695         assembly {
696             size := extcodesize(account)
697         }
698         return size > 0;
699     }
700 
701     /**
702      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
703      * `recipient`, forwarding all available gas and reverting on errors.
704      *
705      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
706      * of certain opcodes, possibly making contracts go over the 2300 gas limit
707      * imposed by `transfer`, making them unable to receive funds via
708      * `transfer`. {sendValue} removes this limitation.
709      *
710      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
711      *
712      * IMPORTANT: because control is transferred to `recipient`, care must be
713      * taken to not create reentrancy vulnerabilities. Consider using
714      * {ReentrancyGuard} or the
715      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
716      */
717     function sendValue(address payable recipient, uint256 amount) internal {
718         require(address(this).balance >= amount, "Address: insufficient balance");
719 
720         (bool success, ) = recipient.call{value: amount}("");
721         require(success, "Address: unable to send value, recipient may have reverted");
722     }
723 
724     /**
725      * @dev Performs a Solidity function call using a low level `call`. A
726      * plain `call` is an unsafe replacement for a function call: use this
727      * function instead.
728      *
729      * If `target` reverts with a revert reason, it is bubbled up by this
730      * function (like regular Solidity function calls).
731      *
732      * Returns the raw returned data. To convert to the expected return value,
733      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
734      *
735      * Requirements:
736      *
737      * - `target` must be a contract.
738      * - calling `target` with `data` must not revert.
739      *
740      * _Available since v3.1._
741      */
742     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
743         return functionCall(target, data, "Address: low-level call failed");
744     }
745 
746     /**
747      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
748      * `errorMessage` as a fallback revert reason when `target` reverts.
749      *
750      * _Available since v3.1._
751      */
752     function functionCall(
753         address target,
754         bytes memory data,
755         string memory errorMessage
756     ) internal returns (bytes memory) {
757         return functionCallWithValue(target, data, 0, errorMessage);
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
762      * but also transferring `value` wei to `target`.
763      *
764      * Requirements:
765      *
766      * - the calling contract must have an ETH balance of at least `value`.
767      * - the called Solidity function must be `payable`.
768      *
769      * _Available since v3.1._
770      */
771     function functionCallWithValue(
772         address target,
773         bytes memory data,
774         uint256 value
775     ) internal returns (bytes memory) {
776         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
781      * with `errorMessage` as a fallback revert reason when `target` reverts.
782      *
783      * _Available since v3.1._
784      */
785     function functionCallWithValue(
786         address target,
787         bytes memory data,
788         uint256 value,
789         string memory errorMessage
790     ) internal returns (bytes memory) {
791         require(address(this).balance >= value, "Address: insufficient balance for call");
792         require(isContract(target), "Address: call to non-contract");
793 
794         (bool success, bytes memory returndata) = target.call{value: value}(data);
795         return verifyCallResult(success, returndata, errorMessage);
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
800      * but performing a static call.
801      *
802      * _Available since v3.3._
803      */
804     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
805         return functionStaticCall(target, data, "Address: low-level static call failed");
806     }
807 
808     /**
809      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
810      * but performing a static call.
811      *
812      * _Available since v3.3._
813      */
814     function functionStaticCall(
815         address target,
816         bytes memory data,
817         string memory errorMessage
818     ) internal view returns (bytes memory) {
819         require(isContract(target), "Address: static call to non-contract");
820 
821         (bool success, bytes memory returndata) = target.staticcall(data);
822         return verifyCallResult(success, returndata, errorMessage);
823     }
824 
825     /**
826      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
827      * but performing a delegate call.
828      *
829      * _Available since v3.4._
830      */
831     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
832         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
833     }
834 
835     /**
836      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
837      * but performing a delegate call.
838      *
839      * _Available since v3.4._
840      */
841     function functionDelegateCall(
842         address target,
843         bytes memory data,
844         string memory errorMessage
845     ) internal returns (bytes memory) {
846         require(isContract(target), "Address: delegate call to non-contract");
847 
848         (bool success, bytes memory returndata) = target.delegatecall(data);
849         return verifyCallResult(success, returndata, errorMessage);
850     }
851 
852     /**
853      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
854      * revert reason using the provided one.
855      *
856      * _Available since v4.3._
857      */
858     function verifyCallResult(
859         bool success,
860         bytes memory returndata,
861         string memory errorMessage
862     ) internal pure returns (bytes memory) {
863         if (success) {
864             return returndata;
865         } else {
866             // Look for revert reason and bubble it up if present
867             if (returndata.length > 0) {
868                 // The easiest way to bubble the revert reason is using memory via assembly
869 
870                 assembly {
871                     let returndata_size := mload(returndata)
872                     revert(add(32, returndata), returndata_size)
873                 }
874             } else {
875                 revert(errorMessage);
876             }
877         }
878     }
879 }
880 
881 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
882 
883 
884 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
885 
886 pragma solidity ^0.8.0;
887 
888 /**
889  * @title ERC721 token receiver interface
890  * @dev Interface for any contract that wants to support safeTransfers
891  * from ERC721 asset contracts.
892  */
893 interface IERC721Receiver {
894     /**
895      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
896      * by `operator` from `from`, this function is called.
897      *
898      * It must return its Solidity selector to confirm the token transfer.
899      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
900      *
901      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
902      */
903     function onERC721Received(
904         address operator,
905         address from,
906         uint256 tokenId,
907         bytes calldata data
908     ) external returns (bytes4);
909 }
910 
911 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
912 
913 
914 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 /**
919  * @dev Interface of the ERC165 standard, as defined in the
920  * https://eips.ethereum.org/EIPS/eip-165[EIP].
921  *
922  * Implementers can declare support of contract interfaces, which can then be
923  * queried by others ({ERC165Checker}).
924  *
925  * For an implementation, see {ERC165}.
926  */
927 interface IERC165 {
928     /**
929      * @dev Returns true if this contract implements the interface defined by
930      * `interfaceId`. See the corresponding
931      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
932      * to learn more about how these ids are created.
933      *
934      * This function call must use less than 30 000 gas.
935      */
936     function supportsInterface(bytes4 interfaceId) external view returns (bool);
937 }
938 
939 // File: @openzeppelin/contracts/interfaces/IERC165.sol
940 
941 
942 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
943 
944 pragma solidity ^0.8.0;
945 
946 
947 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
948 
949 
950 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
951 
952 pragma solidity ^0.8.0;
953 
954 
955 /**
956  * @dev Interface for the NFT Royalty Standard
957  */
958 interface IERC2981 is IERC165 {
959     /**
960      * @dev Called with the sale price to determine how much royalty is owed and to whom.
961      * @param tokenId - the NFT asset queried for royalty information
962      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
963      * @return receiver - address of who should be sent the royalty payment
964      * @return royaltyAmount - the royalty payment amount for `salePrice`
965      */
966     function royaltyInfo(uint256 tokenId, uint256 salePrice)
967         external
968         view
969         returns (address receiver, uint256 royaltyAmount);
970 }
971 
972 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
973 
974 
975 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
976 
977 pragma solidity ^0.8.0;
978 
979 
980 /**
981  * @dev Implementation of the {IERC165} interface.
982  *
983  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
984  * for the additional interface id that will be supported. For example:
985  *
986  * ```solidity
987  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
988  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
989  * }
990  * ```
991  *
992  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
993  */
994 abstract contract ERC165 is IERC165 {
995     /**
996      * @dev See {IERC165-supportsInterface}.
997      */
998     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
999         return interfaceId == type(IERC165).interfaceId;
1000     }
1001 }
1002 
1003 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1004 
1005 
1006 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1007 
1008 pragma solidity ^0.8.0;
1009 
1010 
1011 /**
1012  * @dev Required interface of an ERC721 compliant contract.
1013  */
1014 interface IERC721 is IERC165 {
1015     /**
1016      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1017      */
1018     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1019 
1020     /**
1021      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1022      */
1023     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1024 
1025     /**
1026      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1027      */
1028     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1029 
1030     /**
1031      * @dev Returns the number of tokens in ``owner``'s account.
1032      */
1033     function balanceOf(address owner) external view returns (uint256 balance);
1034 
1035     /**
1036      * @dev Returns the owner of the `tokenId` token.
1037      *
1038      * Requirements:
1039      *
1040      * - `tokenId` must exist.
1041      */
1042     function ownerOf(uint256 tokenId) external view returns (address owner);
1043 
1044     /**
1045      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1046      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1047      *
1048      * Requirements:
1049      *
1050      * - `from` cannot be the zero address.
1051      * - `to` cannot be the zero address.
1052      * - `tokenId` token must exist and be owned by `from`.
1053      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1054      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) external;
1063 
1064     /**
1065      * @dev Transfers `tokenId` token from `from` to `to`.
1066      *
1067      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1068      *
1069      * Requirements:
1070      *
1071      * - `from` cannot be the zero address.
1072      * - `to` cannot be the zero address.
1073      * - `tokenId` token must be owned by `from`.
1074      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function transferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) external;
1083 
1084     /**
1085      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1086      * The approval is cleared when the token is transferred.
1087      *
1088      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1089      *
1090      * Requirements:
1091      *
1092      * - The caller must own the token or be an approved operator.
1093      * - `tokenId` must exist.
1094      *
1095      * Emits an {Approval} event.
1096      */
1097     function approve(address to, uint256 tokenId) external;
1098 
1099     /**
1100      * @dev Returns the account approved for `tokenId` token.
1101      *
1102      * Requirements:
1103      *
1104      * - `tokenId` must exist.
1105      */
1106     function getApproved(uint256 tokenId) external view returns (address operator);
1107 
1108     /**
1109      * @dev Approve or remove `operator` as an operator for the caller.
1110      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1111      *
1112      * Requirements:
1113      *
1114      * - The `operator` cannot be the caller.
1115      *
1116      * Emits an {ApprovalForAll} event.
1117      */
1118     function setApprovalForAll(address operator, bool _approved) external;
1119 
1120     /**
1121      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1122      *
1123      * See {setApprovalForAll}
1124      */
1125     function isApprovedForAll(address owner, address operator) external view returns (bool);
1126 
1127     /**
1128      * @dev Safely transfers `tokenId` token from `from` to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - `from` cannot be the zero address.
1133      * - `to` cannot be the zero address.
1134      * - `tokenId` token must exist and be owned by `from`.
1135      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1136      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function safeTransferFrom(
1141         address from,
1142         address to,
1143         uint256 tokenId,
1144         bytes calldata data
1145     ) external;
1146 }
1147 
1148 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1149 
1150 
1151 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1152 
1153 pragma solidity ^0.8.0;
1154 
1155 
1156 /**
1157  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1158  * @dev See https://eips.ethereum.org/EIPS/eip-721
1159  */
1160 interface IERC721Enumerable is IERC721 {
1161     /**
1162      * @dev Returns the total amount of tokens stored by the contract.
1163      */
1164     function totalSupply() external view returns (uint256);
1165 
1166     /**
1167      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1168      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1169      */
1170     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1171 
1172     /**
1173      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1174      * Use along with {totalSupply} to enumerate all tokens.
1175      */
1176     function tokenByIndex(uint256 index) external view returns (uint256);
1177 }
1178 
1179 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1180 
1181 
1182 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 /**
1188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1189  * @dev See https://eips.ethereum.org/EIPS/eip-721
1190  */
1191 interface IERC721Metadata is IERC721 {
1192     /**
1193      * @dev Returns the token collection name.
1194      */
1195     function name() external view returns (string memory);
1196 
1197     /**
1198      * @dev Returns the token collection symbol.
1199      */
1200     function symbol() external view returns (string memory);
1201 
1202     /**
1203      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1204      */
1205     function tokenURI(uint256 tokenId) external view returns (string memory);
1206 }
1207 
1208 // File: contracts/ERC721A.sol
1209 
1210 
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 
1216 
1217 
1218 
1219 
1220 
1221 
1222 /**
1223  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1224  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1225  *
1226  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1227  *
1228  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1229  *
1230  * Does not support burning tokens to address(0).
1231  */
1232 contract ERC721A is
1233   Context,
1234   ERC165,
1235   IERC721,
1236   IERC721Metadata,
1237   IERC721Enumerable
1238 {
1239   using Address for address;
1240   using Strings for uint256;
1241 
1242   struct TokenOwnership {
1243     address addr;
1244     uint64 startTimestamp;
1245   }
1246 
1247   struct AddressData {
1248     uint128 balance;
1249     uint128 numberMinted;
1250   }
1251 
1252   uint256 private currentIndex = 0;
1253 
1254   uint256 internal immutable collectionSize;
1255   uint256 internal immutable maxBatchSize;
1256 
1257   // Token name
1258   string private _name;
1259 
1260   // Token symbol
1261   string private _symbol;
1262 
1263   // Mapping from token ID to ownership details
1264   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1265   mapping(uint256 => TokenOwnership) private _ownerships;
1266 
1267   // Mapping owner address to address data
1268   mapping(address => AddressData) private _addressData;
1269 
1270   // Mapping from token ID to approved address
1271   mapping(uint256 => address) private _tokenApprovals;
1272 
1273   // Mapping from owner to operator approvals
1274   mapping(address => mapping(address => bool)) private _operatorApprovals;
1275 
1276   /**
1277    * @dev
1278    * `maxBatchSize` refers to how much a minter can mint at a time.
1279    * `collectionSize_` refers to how many tokens are in the collection.
1280    */
1281   constructor(
1282     string memory name_,
1283     string memory symbol_,
1284     uint256 maxBatchSize_,
1285     uint256 collectionSize_
1286   ) {
1287     require(
1288       collectionSize_ > 0,
1289       "ERC721A: collection must have a nonzero supply"
1290     );
1291     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1292     _name = name_;
1293     _symbol = symbol_;
1294     maxBatchSize = maxBatchSize_;
1295     collectionSize = collectionSize_;
1296   }
1297 
1298   /**
1299    * @dev See {IERC721Enumerable-totalSupply}.
1300    */
1301   function totalSupply() public view override returns (uint256) {
1302     return currentIndex;
1303   }
1304 
1305   /**
1306    * @dev See {IERC721Enumerable-tokenByIndex}.
1307    */
1308   function tokenByIndex(uint256 index) public view override returns (uint256) {
1309     require(index < totalSupply(), "ERC721A: global index out of bounds");
1310     return index;
1311   }
1312 
1313   /**
1314    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1315    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1316    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1317    */
1318   function tokenOfOwnerByIndex(address owner, uint256 index)
1319     public
1320     view
1321     override
1322     returns (uint256)
1323   {
1324     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1325     uint256 numMintedSoFar = totalSupply();
1326     uint256 tokenIdsIdx = 0;
1327     address currOwnershipAddr = address(0);
1328     for (uint256 i = 0; i < numMintedSoFar; i++) {
1329       TokenOwnership memory ownership = _ownerships[i];
1330       if (ownership.addr != address(0)) {
1331         currOwnershipAddr = ownership.addr;
1332       }
1333       if (currOwnershipAddr == owner) {
1334         if (tokenIdsIdx == index) {
1335           return i;
1336         }
1337         tokenIdsIdx++;
1338       }
1339     }
1340     revert("ERC721A: unable to get token of owner by index");
1341   }
1342 
1343   /**
1344    * @dev See {IERC165-supportsInterface}.
1345    */
1346   function supportsInterface(bytes4 interfaceId)
1347     public
1348     view
1349     virtual
1350     override(ERC165, IERC165)
1351     returns (bool)
1352   {
1353     return
1354       interfaceId == type(IERC721).interfaceId ||
1355       interfaceId == type(IERC721Metadata).interfaceId ||
1356       interfaceId == type(IERC721Enumerable).interfaceId ||
1357       super.supportsInterface(interfaceId);
1358   }
1359 
1360   /**
1361    * @dev See {IERC721-balanceOf}.
1362    */
1363   function balanceOf(address owner) public view override returns (uint256) {
1364     require(owner != address(0), "ERC721A: balance query for the zero address");
1365     return uint256(_addressData[owner].balance);
1366   }
1367 
1368   function _numberMinted(address owner) internal view returns (uint256) {
1369     require(
1370       owner != address(0),
1371       "ERC721A: number minted query for the zero address"
1372     );
1373     return uint256(_addressData[owner].numberMinted);
1374   }
1375 
1376   function ownershipOf(uint256 tokenId)
1377     internal
1378     view
1379     returns (TokenOwnership memory)
1380   {
1381     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1382 
1383     uint256 lowestTokenToCheck;
1384     if (tokenId >= maxBatchSize) {
1385       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1386     }
1387 
1388     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1389       TokenOwnership memory ownership = _ownerships[curr];
1390       if (ownership.addr != address(0)) {
1391         return ownership;
1392       }
1393     }
1394 
1395     revert("ERC721A: unable to determine the owner of token");
1396   }
1397 
1398   /**
1399    * @dev See {IERC721-ownerOf}.
1400    */
1401   function ownerOf(uint256 tokenId) public view override returns (address) {
1402     return ownershipOf(tokenId).addr;
1403   }
1404 
1405   /**
1406    * @dev See {IERC721Metadata-name}.
1407    */
1408   function name() public view virtual override returns (string memory) {
1409     return _name;
1410   }
1411 
1412   /**
1413    * @dev See {IERC721Metadata-symbol}.
1414    */
1415   function symbol() public view virtual override returns (string memory) {
1416     return _symbol;
1417   }
1418 
1419   /**
1420    * @dev See {IERC721Metadata-tokenURI}.
1421    */
1422   function tokenURI(uint256 tokenId)
1423     public
1424     view
1425     virtual
1426     override
1427     returns (string memory)
1428   {
1429     require(
1430       _exists(tokenId),
1431       "ERC721Metadata: URI query for nonexistent token"
1432     );
1433 
1434     string memory baseURI = _baseURI();
1435     return
1436       bytes(baseURI).length > 0
1437         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1438         : "";
1439   }
1440 
1441   /**
1442    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1443    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1444    * by default, can be overriden in child contracts.
1445    */
1446   function _baseURI() internal view virtual returns (string memory) {
1447     return "";
1448   }
1449 
1450   /**
1451    * @dev See {IERC721-approve}.
1452    */
1453   function approve(address to, uint256 tokenId) public override {
1454     address owner = ERC721A.ownerOf(tokenId);
1455     require(to != owner, "ERC721A: approval to current owner");
1456 
1457     require(
1458       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1459       "ERC721A: approve caller is not owner nor approved for all"
1460     );
1461 
1462     _approve(to, tokenId, owner);
1463   }
1464 
1465   /**
1466    * @dev See {IERC721-getApproved}.
1467    */
1468   function getApproved(uint256 tokenId) public view override returns (address) {
1469     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1470 
1471     return _tokenApprovals[tokenId];
1472   }
1473 
1474   /**
1475    * @dev See {IERC721-setApprovalForAll}.
1476    */
1477   function setApprovalForAll(address operator, bool approved) public override {
1478     require(operator != _msgSender(), "ERC721A: approve to caller");
1479 
1480     _operatorApprovals[_msgSender()][operator] = approved;
1481     emit ApprovalForAll(_msgSender(), operator, approved);
1482   }
1483 
1484   /**
1485    * @dev See {IERC721-isApprovedForAll}.
1486    */
1487   function isApprovedForAll(address owner, address operator)
1488     public
1489     view
1490     virtual
1491     override
1492     returns (bool)
1493   {
1494     return _operatorApprovals[owner][operator];
1495   }
1496 
1497   /**
1498    * @dev See {IERC721-transferFrom}.
1499    */
1500   function transferFrom(
1501     address from,
1502     address to,
1503     uint256 tokenId
1504   ) public override {
1505     _transfer(from, to, tokenId);
1506   }
1507 
1508   /**
1509    * @dev See {IERC721-safeTransferFrom}.
1510    */
1511   function safeTransferFrom(
1512     address from,
1513     address to,
1514     uint256 tokenId
1515   ) public override {
1516     safeTransferFrom(from, to, tokenId, "");
1517   }
1518 
1519   /**
1520    * @dev See {IERC721-safeTransferFrom}.
1521    */
1522   function safeTransferFrom(
1523     address from,
1524     address to,
1525     uint256 tokenId,
1526     bytes memory _data
1527   ) public override {
1528     _transfer(from, to, tokenId);
1529     require(
1530       _checkOnERC721Received(from, to, tokenId, _data),
1531       "ERC721A: transfer to non ERC721Receiver implementer"
1532     );
1533   }
1534 
1535   /**
1536    * @dev Returns whether `tokenId` exists.
1537    *
1538    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1539    *
1540    * Tokens start existing when they are minted (`_mint`),
1541    */
1542   function _exists(uint256 tokenId) internal view returns (bool) {
1543     return tokenId < currentIndex;
1544   }
1545 
1546   function _safeMint(address to, uint256 quantity) internal {
1547     _safeMint(to, quantity, "");
1548   }
1549 
1550   /**
1551    * @dev Mints `quantity` tokens and transfers them to `to`.
1552    *
1553    * Requirements:
1554    *
1555    * - there must be `quantity` tokens remaining unminted in the total collection.
1556    * - `to` cannot be the zero address.
1557    * - `quantity` cannot be larger than the max batch size.
1558    *
1559    * Emits a {Transfer} event.
1560    */
1561   function _safeMint(
1562     address to,
1563     uint256 quantity,
1564     bytes memory _data
1565   ) internal {
1566     uint256 startTokenId = currentIndex;
1567     require(to != address(0), "ERC721A: mint to the zero address");
1568     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1569     require(!_exists(startTokenId), "ERC721A: token already minted");
1570     // require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1571 
1572     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1573 
1574     AddressData memory addressData = _addressData[to];
1575     _addressData[to] = AddressData(
1576       addressData.balance + uint128(quantity),
1577       addressData.numberMinted + uint128(quantity)
1578     );
1579     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1580 
1581     uint256 updatedIndex = startTokenId;
1582 
1583     for (uint256 i = 0; i < quantity; i++) {
1584       emit Transfer(address(0), to, updatedIndex);
1585       require(
1586         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1587         "ERC721A: transfer to non ERC721Receiver implementer"
1588       );
1589       updatedIndex++;
1590     }
1591 
1592     currentIndex = updatedIndex;
1593     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1594   }
1595 
1596   /**
1597    * @dev Transfers `tokenId` from `from` to `to`.
1598    *
1599    * Requirements:
1600    *
1601    * - `to` cannot be the zero address.
1602    * - `tokenId` token must be owned by `from`.
1603    *
1604    * Emits a {Transfer} event.
1605    */
1606   function _transfer(
1607     address from,
1608     address to,
1609     uint256 tokenId
1610   ) private {
1611     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1612 
1613     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1614       getApproved(tokenId) == _msgSender() ||
1615       isApprovedForAll(prevOwnership.addr, _msgSender()));
1616 
1617     require(
1618       isApprovedOrOwner,
1619       "ERC721A: transfer caller is not owner nor approved"
1620     );
1621 
1622     require(
1623       prevOwnership.addr == from,
1624       "ERC721A: transfer from incorrect owner"
1625     );
1626     require(to != address(0), "ERC721A: transfer to the zero address");
1627 
1628     _beforeTokenTransfers(from, to, tokenId, 1);
1629 
1630     // Clear approvals from the previous owner
1631     _approve(address(0), tokenId, prevOwnership.addr);
1632 
1633     _addressData[from].balance -= 1;
1634     _addressData[to].balance += 1;
1635     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1636 
1637     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1638     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1639     uint256 nextTokenId = tokenId + 1;
1640     if (_ownerships[nextTokenId].addr == address(0)) {
1641       if (_exists(nextTokenId)) {
1642         _ownerships[nextTokenId] = TokenOwnership(
1643           prevOwnership.addr,
1644           prevOwnership.startTimestamp
1645         );
1646       }
1647     }
1648 
1649     emit Transfer(from, to, tokenId);
1650     _afterTokenTransfers(from, to, tokenId, 1);
1651   }
1652 
1653   /**
1654    * @dev Approve `to` to operate on `tokenId`
1655    *
1656    * Emits a {Approval} event.
1657    */
1658   function _approve(
1659     address to,
1660     uint256 tokenId,
1661     address owner
1662   ) private {
1663     _tokenApprovals[tokenId] = to;
1664     emit Approval(owner, to, tokenId);
1665   }
1666 
1667   uint256 public nextOwnerToExplicitlySet = 0;
1668 
1669   /**
1670    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1671    */
1672   function _setOwnersExplicit(uint256 quantity) internal {
1673     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1674     require(quantity > 0, "quantity must be nonzero");
1675     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1676     if (endIndex > collectionSize - 1) {
1677       endIndex = collectionSize - 1;
1678     }
1679     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1680     require(_exists(endIndex), "not enough minted yet for this cleanup");
1681     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1682       if (_ownerships[i].addr == address(0)) {
1683         TokenOwnership memory ownership = ownershipOf(i);
1684         _ownerships[i] = TokenOwnership(
1685           ownership.addr,
1686           ownership.startTimestamp
1687         );
1688       }
1689     }
1690     nextOwnerToExplicitlySet = endIndex + 1;
1691   }
1692 
1693   /**
1694    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1695    * The call is not executed if the target address is not a contract.
1696    *
1697    * @param from address representing the previous owner of the given token ID
1698    * @param to target address that will receive the tokens
1699    * @param tokenId uint256 ID of the token to be transferred
1700    * @param _data bytes optional data to send along with the call
1701    * @return bool whether the call correctly returned the expected magic value
1702    */
1703   function _checkOnERC721Received(
1704     address from,
1705     address to,
1706     uint256 tokenId,
1707     bytes memory _data
1708   ) private returns (bool) {
1709     if (to.isContract()) {
1710       try
1711         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1712       returns (bytes4 retval) {
1713         return retval == IERC721Receiver(to).onERC721Received.selector;
1714       } catch (bytes memory reason) {
1715         if (reason.length == 0) {
1716           revert("ERC721A: transfer to non ERC721Receiver implementer");
1717         } else {
1718           assembly {
1719             revert(add(32, reason), mload(reason))
1720           }
1721         }
1722       }
1723     } else {
1724       return true;
1725     }
1726   }
1727 
1728   /**
1729    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1730    *
1731    * startTokenId - the first token id to be transferred
1732    * quantity - the amount to be transferred
1733    *
1734    * Calling conditions:
1735    *
1736    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1737    * transferred to `to`.
1738    * - When `from` is zero, `tokenId` will be minted for `to`.
1739    */
1740   function _beforeTokenTransfers(
1741     address from,
1742     address to,
1743     uint256 startTokenId,
1744     uint256 quantity
1745   ) internal virtual {}
1746 
1747   /**
1748    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1749    * minting.
1750    *
1751    * startTokenId - the first token id to be transferred
1752    * quantity - the amount to be transferred
1753    *
1754    * Calling conditions:
1755    *
1756    * - when `from` and `to` are both non-zero.
1757    * - `from` and `to` are never both zero.
1758    */
1759   function _afterTokenTransfers(
1760     address from,
1761     address to,
1762     uint256 startTokenId,
1763     uint256 quantity
1764   ) internal virtual {}
1765 }
1766 // File: contracts/notBanksy.sol
1767 
1768 //SPDX-License-Identifier: MIT
1769 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1770 
1771 pragma solidity ^0.8.0;
1772 
1773 
1774 
1775 
1776 
1777 
1778 
1779 
1780 
1781 contract notBanksyballoon is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1782     using Counters for Counters.Counter;
1783     using Strings for uint256;
1784 
1785     Counters.Counter private tokenCounter;
1786 
1787     string private baseURI = "ipfs://QmZuZYA8AjDmkG2SzJj8czcPdZvg3eWW5PiRNAv7yzin5z";
1788 
1789     uint256 public constant MAX_MINTS_PER_TX = 20;
1790     uint256 public maxSupply = 1974;
1791 
1792     uint256 public constant PUBLIC_SALE_PRICE = 0.0069 ether;
1793     bool public isPublicSaleActive = true;
1794 
1795 
1796 
1797 
1798     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1799 
1800     modifier publicSaleActive() {
1801         require(isPublicSaleActive, "Public sale is not open");
1802         _;
1803     }
1804 
1805 
1806 
1807     modifier maxMintsPerTX(uint256 numberOfTokens) {
1808         require(
1809             numberOfTokens <= MAX_MINTS_PER_TX,
1810             "Max mints per transaction exceeded"
1811         );
1812         _;
1813     }
1814 
1815     modifier canMintNFTs(uint256 numberOfTokens) {
1816         require(
1817             totalSupply() + numberOfTokens <=
1818                 maxSupply,
1819             "Not enough mints remaining to mint"
1820         );
1821         _;
1822     }
1823 
1824     constructor(
1825     ) ERC721A("notBanksyballoon", "notBanksy", 100, maxSupply) {
1826     }
1827 
1828 modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1829         require(
1830             (price * numberOfTokens) == msg.value,
1831             "Incorrect ETH value sent"
1832         );
1833         _;
1834     }
1835 
1836     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1837 
1838     function mint(uint256 numberOfTokens)
1839         external
1840         payable
1841         nonReentrant
1842         publicSaleActive
1843         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1844         canMintNFTs(numberOfTokens)
1845         maxMintsPerTX(numberOfTokens)
1846     {
1847 
1848         _safeMint(msg.sender, numberOfTokens);
1849     }
1850 
1851 
1852 
1853 
1854     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1855 
1856     function getBaseURI() external view returns (string memory) {
1857         return baseURI;
1858     }
1859 
1860     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1861 
1862     function setBaseURI(string memory _baseURI) external onlyOwner {
1863         baseURI = _baseURI;
1864     }
1865 
1866 
1867     function setIsPublicSaleActive(bool _isPublicSaleActive)
1868         external
1869         onlyOwner
1870     {
1871         isPublicSaleActive = _isPublicSaleActive;
1872     }
1873 
1874 
1875 
1876     function withdraw() public onlyOwner {
1877         uint256 balance = address(this).balance;
1878         payable(msg.sender).transfer(balance);
1879     }
1880 
1881     function withdrawTokens(IERC20 token) public onlyOwner {
1882         uint256 balance = token.balanceOf(address(this));
1883         token.transfer(msg.sender, balance);
1884     }
1885 
1886 
1887     // ============ SUPPORTING FUNCTIONS ============
1888 
1889     function nextTokenId() private returns (uint256) {
1890         tokenCounter.increment();
1891         return tokenCounter.current();
1892     }
1893 
1894     // ============ FUNCTION OVERRIDES ============
1895 
1896     function supportsInterface(bytes4 interfaceId)
1897         public
1898         view
1899         virtual
1900         override(ERC721A, IERC165)
1901         returns (bool)
1902     {
1903         return
1904             interfaceId == type(IERC2981).interfaceId ||
1905             super.supportsInterface(interfaceId);
1906     }
1907 
1908     /**
1909      * @dev See {IERC721Metadata-tokenURI}.
1910      */
1911     function tokenURI(uint256 tokenId)
1912         public
1913         view
1914         virtual
1915         override
1916         returns (string memory)
1917     {
1918         require(_exists(tokenId), "Nonexistent token");
1919 
1920         return
1921             baseURI;
1922     }
1923 
1924     /**
1925      * @dev See {IERC165-royaltyInfo}.
1926      */
1927     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1928         external
1929         view
1930         override
1931         returns (address receiver, uint256 royaltyAmount)
1932     {
1933         require(_exists(tokenId), "Nonexistent token");
1934 
1935         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1936     }
1937 }
1938 
1939 // These contract definitions are used to create a reference to the OpenSea
1940 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1941 contract OwnableDelegateProxy {
1942 
1943 }
1944 
1945 contract ProxyRegistry {
1946     mapping(address => OwnableDelegateProxy) public proxies;
1947 }