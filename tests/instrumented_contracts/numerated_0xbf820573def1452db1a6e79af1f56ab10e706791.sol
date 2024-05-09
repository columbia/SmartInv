1 // File: contracts/robo.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-03-19
5 */
6 
7 // File: contracts/ROBO.sol
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-02-25
11 */
12 
13 // File: contracts/ROBO.sol
14 
15 /**
16  *Submitted for verification at Etherscan.io on 2022-02-23
17 */
18 
19 /**
20  *Submitted for verification at Etherscan.io on 2022-02-14
21 */
22 
23 // File: contracts/ROBO.sol
24 
25 /**
26  *Submitted for verification at Etherscan.io on 2022-01-18
27 */
28 
29 // File: contracts/ROBO.sol
30 
31 /**
32  *Submitted for verification at Etherscan.io on 2022-01-18
33 */
34 
35 /**
36  *Submitted for verification at Etherscan.io on 2022-01-18
37 */
38 
39 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
40 
41 
42 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 // CAUTION
47 // This version of SafeMath should only be used with Solidity 0.8 or later,
48 // because it relies on the compiler's built in overflow checks.
49 
50 /**
51  * @dev Wrappers over Solidity's arithmetic operations.
52  *
53  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
54  * now has built in overflow checking.
55  */
56 library SafeMath {
57     /**
58      * @dev Returns the addition of two unsigned integers, with an overflow flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             uint256 c = a + b;
65             if (c < a) return (false, 0);
66             return (true, c);
67         }
68     }
69 
70     /**
71      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
72      *
73      * _Available since v3.4._
74      */
75     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b > a) return (false, 0);
78             return (true, a - b);
79         }
80     }
81 
82     /**
83      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90             // benefit is lost if 'b' is also tested.
91             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92             if (a == 0) return (true, 0);
93             uint256 c = a * b;
94             if (c / a != b) return (false, 0);
95             return (true, c);
96         }
97     }
98 
99     /**
100      * @dev Returns the division of two unsigned integers, with a division by zero flag.
101      *
102      * _Available since v3.4._
103      */
104     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             if (b == 0) return (false, 0);
107             return (true, a / b);
108         }
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
113      *
114      * _Available since v3.4._
115      */
116     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             if (b == 0) return (false, 0);
119             return (true, a % b);
120         }
121     }
122 
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      *
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a + b;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a - b;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a * b;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers, reverting on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator.
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a / b;
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * reverting when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a % b;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
197      * overflow (when the result is negative).
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {trySub}.
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      *
206      * - Subtraction cannot overflow.
207      */
208     function sub(
209         uint256 a,
210         uint256 b,
211         string memory errorMessage
212     ) internal pure returns (uint256) {
213         unchecked {
214             require(b <= a, errorMessage);
215             return a - b;
216         }
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         unchecked {
237             require(b > 0, errorMessage);
238             return a / b;
239         }
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * reverting with custom message when dividing by zero.
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {tryMod}.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a % b;
265         }
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Counters.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @title Counters
278  * @author Matt Condon (@shrugs)
279  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
280  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
281  *
282  * Include with `using Counters for Counters.Counter;`
283  */
284 library Counters {
285     struct Counter {
286         // This variable should never be directly accessed by users of the library: interactions must be restricted to
287         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
288         // this feature: see https://github.com/ethereum/solidity/issues/4637
289         uint256 _value; // default: 0
290     }
291 
292     function current(Counter storage counter) internal view returns (uint256) {
293         return counter._value;
294     }
295 
296     function increment(Counter storage counter) internal {
297         unchecked {
298             counter._value += 1;
299         }
300     }
301 
302     function decrement(Counter storage counter) internal {
303         uint256 value = counter._value;
304         require(value > 0, "Counter: decrement overflow");
305         unchecked {
306             counter._value = value - 1;
307         }
308     }
309 
310     function reset(Counter storage counter) internal {
311         counter._value = 0;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev Contract module that helps prevent reentrant calls to a function.
324  *
325  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
326  * available, which can be applied to functions to make sure there are no nested
327  * (reentrant) calls to them.
328  *
329  * Note that because there is a single `nonReentrant` guard, functions marked as
330  * `nonReentrant` may not call one another. This can be worked around by making
331  * those functions `private`, and then adding `external` `nonReentrant` entry
332  * points to them.
333  *
334  * TIP: If you would like to learn more about reentrancy and alternative ways
335  * to protect against it, check out our blog post
336  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
337  */
338 abstract contract ReentrancyGuard {
339     // Booleans are more expensive than uint256 or any type that takes up a full
340     // word because each write operation emits an extra SLOAD to first read the
341     // slot's contents, replace the bits taken up by the boolean, and then write
342     // back. This is the compiler's defense against contract upgrades and
343     // pointer aliasing, and it cannot be disabled.
344 
345     // The values being non-zero value makes deployment a bit more expensive,
346     // but in exchange the refund on every call to nonReentrant will be lower in
347     // amount. Since refunds are capped to a percentage of the total
348     // transaction's gas, it is best to keep them low in cases like this one, to
349     // increase the likelihood of the full refund coming into effect.
350     uint256 private constant _NOT_ENTERED = 1;
351     uint256 private constant _ENTERED = 2;
352 
353     uint256 private _status;
354 
355     constructor() {
356         _status = _NOT_ENTERED;
357     }
358 
359     /**
360      * @dev Prevents a contract from calling itself, directly or indirectly.
361      * Calling a `nonReentrant` function from another `nonReentrant`
362      * function is not supported. It is possible to prevent this from happening
363      * by making the `nonReentrant` function external, and making it call a
364      * `private` function that does the actual work.
365      */
366     modifier nonReentrant() {
367         // On the first call to nonReentrant, _notEntered will be true
368         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
369 
370         // Any calls to nonReentrant after this point will fail
371         _status = _ENTERED;
372 
373         _;
374 
375         // By storing the original value once again, a refund is triggered (see
376         // https://eips.ethereum.org/EIPS/eip-2200)
377         _status = _NOT_ENTERED;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @dev Interface of the ERC20 standard as defined in the EIP.
390  */
391 interface IERC20 {
392     /**
393      * @dev Returns the amount of tokens in existence.
394      */
395     function totalSupply() external view returns (uint256);
396 
397     /**
398      * @dev Returns the amount of tokens owned by `account`.
399      */
400     function balanceOf(address account) external view returns (uint256);
401 
402     /**
403      * @dev Moves `amount` tokens from the caller's account to `recipient`.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transfer(address recipient, uint256 amount) external returns (bool);
410 
411     /**
412      * @dev Returns the remaining number of tokens that `spender` will be
413      * allowed to spend on behalf of `owner` through {transferFrom}. This is
414      * zero by default.
415      *
416      * This value changes when {approve} or {transferFrom} are called.
417      */
418     function allowance(address owner, address spender) external view returns (uint256);
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * IMPORTANT: Beware that changing an allowance with this method brings the risk
426      * that someone may use both the old and the new allowance by unfortunate
427      * transaction ordering. One possible solution to mitigate this race
428      * condition is to first reduce the spender's allowance to 0 and set the
429      * desired value afterwards:
430      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
431      *
432      * Emits an {Approval} event.
433      */
434     function approve(address spender, uint256 amount) external returns (bool);
435 
436     /**
437      * @dev Moves `amount` tokens from `sender` to `recipient` using the
438      * allowance mechanism. `amount` is then deducted from the caller's
439      * allowance.
440      *
441      * Returns a boolean value indicating whether the operation succeeded.
442      *
443      * Emits a {Transfer} event.
444      */
445     function transferFrom(
446         address sender,
447         address recipient,
448         uint256 amount
449     ) external returns (bool);
450 
451     /**
452      * @dev Emitted when `value` tokens are moved from one account (`from`) to
453      * another (`to`).
454      *
455      * Note that `value` may be zero.
456      */
457     event Transfer(address indexed from, address indexed to, uint256 value);
458 
459     /**
460      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
461      * a call to {approve}. `value` is the new allowance.
462      */
463     event Approval(address indexed owner, address indexed spender, uint256 value);
464 }
465 
466 // File: @openzeppelin/contracts/interfaces/IERC20.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 
474 // File: @openzeppelin/contracts/utils/Strings.sol
475 
476 
477 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev String operations.
483  */
484 library Strings {
485     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
489      */
490     function toString(uint256 value) internal pure returns (string memory) {
491         // Inspired by OraclizeAPI's implementation - MIT licence
492         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
493 
494         if (value == 0) {
495             return "0";
496         }
497         uint256 temp = value;
498         uint256 digits;
499         while (temp != 0) {
500             digits++;
501             temp /= 10;
502         }
503         bytes memory buffer = new bytes(digits);
504         while (value != 0) {
505             digits -= 1;
506             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
507             value /= 10;
508         }
509         return string(buffer);
510     }
511 
512     /**
513      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
514      */
515     function toHexString(uint256 value) internal pure returns (string memory) {
516         if (value == 0) {
517             return "0x00";
518         }
519         uint256 temp = value;
520         uint256 length = 0;
521         while (temp != 0) {
522             length++;
523             temp >>= 8;
524         }
525         return toHexString(value, length);
526     }
527 
528     /**
529      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
530      */
531     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
532         bytes memory buffer = new bytes(2 * length + 2);
533         buffer[0] = "0";
534         buffer[1] = "x";
535         for (uint256 i = 2 * length + 1; i > 1; --i) {
536             buffer[i] = _HEX_SYMBOLS[value & 0xf];
537             value >>= 4;
538         }
539         require(value == 0, "Strings: hex length insufficient");
540         return string(buffer);
541     }
542 }
543 
544 // File: @openzeppelin/contracts/utils/Context.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev Provides information about the current execution context, including the
553  * sender of the transaction and its data. While these are generally available
554  * via msg.sender and msg.data, they should not be accessed in such a direct
555  * manner, since when dealing with meta-transactions the account sending and
556  * paying for execution may not be the actual sender (as far as an application
557  * is concerned).
558  *
559  * This contract is only required for intermediate, library-like contracts.
560  */
561 abstract contract Context {
562     function _msgSender() internal view virtual returns (address) {
563         return msg.sender;
564     }
565 
566     function _msgData() internal view virtual returns (bytes calldata) {
567         return msg.data;
568     }
569 }
570 
571 // File: @openzeppelin/contracts/access/Ownable.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 /**
580  * @dev Contract module which provides a basic access control mechanism, where
581  * there is an account (an owner) that can be granted exclusive access to
582  * specific functions.
583  *
584  * By default, the owner account will be the one that deploys the contract. This
585  * can later be changed with {transferOwnership}.
586  *
587  * This module is used through inheritance. It will make available the modifier
588  * `onlyOwner`, which can be applied to your functions to restrict their use to
589  * the owner.
590  */
591 abstract contract Ownable is Context {
592     address private _owner;
593 
594     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
595 
596     /**
597      * @dev Initializes the contract setting the deployer as the initial owner.
598      */
599     constructor() {
600         _transferOwnership(_msgSender());
601     }
602 
603     /**
604      * @dev Returns the address of the current owner.
605      */
606     function owner() public view virtual returns (address) {
607         return _owner;
608     }
609 
610     /**
611      * @dev Throws if called by any account other than the owner.
612      */
613     modifier onlyOwner() {
614         require(owner() == _msgSender(), "Ownable: caller is not the owner");
615         _;
616     }
617 
618     /**
619      * @dev Leaves the contract without owner. It will not be possible to call
620      * `onlyOwner` functions anymore. Can only be called by the current owner.
621      *
622      * NOTE: Renouncing ownership will leave the contract without an owner,
623      * thereby removing any functionality that is only available to the owner.
624      */
625     function renounceOwnership() public virtual onlyOwner {
626         _transferOwnership(address(0));
627     }
628 
629     /**
630      * @dev Transfers ownership of the contract to a new account (`newOwner`).
631      * Can only be called by the current owner.
632      */
633     function transferOwnership(address newOwner) public virtual onlyOwner {
634         require(newOwner != address(0), "Ownable: new owner is the zero address");
635         _transferOwnership(newOwner);
636     }
637 
638     /**
639      * @dev Transfers ownership of the contract to a new account (`newOwner`).
640      * Internal function without access restriction.
641      */
642     function _transferOwnership(address newOwner) internal virtual {
643         address oldOwner = _owner;
644         _owner = newOwner;
645         emit OwnershipTransferred(oldOwner, newOwner);
646     }
647 }
648 
649 // File: @openzeppelin/contracts/utils/Address.sol
650 
651 
652 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Collection of functions related to the address type
658  */
659 library Address {
660     /**
661      * @dev Returns true if `account` is a contract.
662      *
663      * [IMPORTANT]
664      * ====
665      * It is unsafe to assume that an address for which this function returns
666      * false is an externally-owned account (EOA) and not a contract.
667      *
668      * Among others, `isContract` will return false for the following
669      * types of addresses:
670      *
671      *  - an externally-owned account
672      *  - a contract in construction
673      *  - an address where a contract will be created
674      *  - an address where a contract lived, but was destroyed
675      * ====
676      */
677     function isContract(address account) internal view returns (bool) {
678         // This method relies on extcodesize, which returns 0 for contracts in
679         // construction, since the code is only stored at the end of the
680         // constructor execution.
681 
682         uint256 size;
683         assembly {
684             size := extcodesize(account)
685         }
686         return size > 0;
687     }
688 
689     /**
690      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
691      * `recipient`, forwarding all available gas and reverting on errors.
692      *
693      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
694      * of certain opcodes, possibly making contracts go over the 2300 gas limit
695      * imposed by `transfer`, making them unable to receive funds via
696      * `transfer`. {sendValue} removes this limitation.
697      *
698      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
699      *
700      * IMPORTANT: because control is transferred to `recipient`, care must be
701      * taken to not create reentrancy vulnerabilities. Consider using
702      * {ReentrancyGuard} or the
703      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
704      */
705     function sendValue(address payable recipient, uint256 amount) internal {
706         require(address(this).balance >= amount, "Address: insufficient balance");
707 
708         (bool success, ) = recipient.call{value: amount}("");
709         require(success, "Address: unable to send value, recipient may have reverted");
710     }
711 
712     /**
713      * @dev Performs a Solidity function call using a low level `call`. A
714      * plain `call` is an unsafe replacement for a function call: use this
715      * function instead.
716      *
717      * If `target` reverts with a revert reason, it is bubbled up by this
718      * function (like regular Solidity function calls).
719      *
720      * Returns the raw returned data. To convert to the expected return value,
721      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
722      *
723      * Requirements:
724      *
725      * - `target` must be a contract.
726      * - calling `target` with `data` must not revert.
727      *
728      * _Available since v3.1._
729      */
730     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
731         return functionCall(target, data, "Address: low-level call failed");
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
736      * `errorMessage` as a fallback revert reason when `target` reverts.
737      *
738      * _Available since v3.1._
739      */
740     function functionCall(
741         address target,
742         bytes memory data,
743         string memory errorMessage
744     ) internal returns (bytes memory) {
745         return functionCallWithValue(target, data, 0, errorMessage);
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
750      * but also transferring `value` wei to `target`.
751      *
752      * Requirements:
753      *
754      * - the calling contract must have an ETH balance of at least `value`.
755      * - the called Solidity function must be `payable`.
756      *
757      * _Available since v3.1._
758      */
759     function functionCallWithValue(
760         address target,
761         bytes memory data,
762         uint256 value
763     ) internal returns (bytes memory) {
764         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
769      * with `errorMessage` as a fallback revert reason when `target` reverts.
770      *
771      * _Available since v3.1._
772      */
773     function functionCallWithValue(
774         address target,
775         bytes memory data,
776         uint256 value,
777         string memory errorMessage
778     ) internal returns (bytes memory) {
779         require(address(this).balance >= value, "Address: insufficient balance for call");
780         require(isContract(target), "Address: call to non-contract");
781 
782         (bool success, bytes memory returndata) = target.call{value: value}(data);
783         return verifyCallResult(success, returndata, errorMessage);
784     }
785 
786     /**
787      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
788      * but performing a static call.
789      *
790      * _Available since v3.3._
791      */
792     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
793         return functionStaticCall(target, data, "Address: low-level static call failed");
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
798      * but performing a static call.
799      *
800      * _Available since v3.3._
801      */
802     function functionStaticCall(
803         address target,
804         bytes memory data,
805         string memory errorMessage
806     ) internal view returns (bytes memory) {
807         require(isContract(target), "Address: static call to non-contract");
808 
809         (bool success, bytes memory returndata) = target.staticcall(data);
810         return verifyCallResult(success, returndata, errorMessage);
811     }
812 
813     /**
814      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
815      * but performing a delegate call.
816      *
817      * _Available since v3.4._
818      */
819     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
820         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
821     }
822 
823     /**
824      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
825      * but performing a delegate call.
826      *
827      * _Available since v3.4._
828      */
829     function functionDelegateCall(
830         address target,
831         bytes memory data,
832         string memory errorMessage
833     ) internal returns (bytes memory) {
834         require(isContract(target), "Address: delegate call to non-contract");
835 
836         (bool success, bytes memory returndata) = target.delegatecall(data);
837         return verifyCallResult(success, returndata, errorMessage);
838     }
839 
840     /**
841      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
842      * revert reason using the provided one.
843      *
844      * _Available since v4.3._
845      */
846     function verifyCallResult(
847         bool success,
848         bytes memory returndata,
849         string memory errorMessage
850     ) internal pure returns (bytes memory) {
851         if (success) {
852             return returndata;
853         } else {
854             // Look for revert reason and bubble it up if present
855             if (returndata.length > 0) {
856                 // The easiest way to bubble the revert reason is using memory via assembly
857 
858                 assembly {
859                     let returndata_size := mload(returndata)
860                     revert(add(32, returndata), returndata_size)
861                 }
862             } else {
863                 revert(errorMessage);
864             }
865         }
866     }
867 }
868 
869 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
870 
871 
872 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 /**
877  * @title ERC721 token receiver interface
878  * @dev Interface for any contract that wants to support safeTransfers
879  * from ERC721 asset contracts.
880  */
881 interface IERC721Receiver {
882     /**
883      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
884      * by `operator` from `from`, this function is called.
885      *
886      * It must return its Solidity selector to confirm the token transfer.
887      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
888      *
889      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
890      */
891     function onERC721Received(
892         address operator,
893         address from,
894         uint256 tokenId,
895         bytes calldata data
896     ) external returns (bytes4);
897 }
898 
899 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
900 
901 
902 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @dev Interface of the ERC165 standard, as defined in the
908  * https://eips.ethereum.org/EIPS/eip-165[EIP].
909  *
910  * Implementers can declare support of contract interfaces, which can then be
911  * queried by others ({ERC165Checker}).
912  *
913  * For an implementation, see {ERC165}.
914  */
915 interface IERC165 {
916     /**
917      * @dev Returns true if this contract implements the interface defined by
918      * `interfaceId`. See the corresponding
919      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
920      * to learn more about how these ids are created.
921      *
922      * This function call must use less than 30 000 gas.
923      */
924     function supportsInterface(bytes4 interfaceId) external view returns (bool);
925 }
926 
927 // File: @openzeppelin/contracts/interfaces/IERC165.sol
928 
929 
930 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 
935 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
936 
937 
938 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 
943 /**
944  * @dev Interface for the NFT Royalty Standard
945  */
946 interface IERC2981 is IERC165 {
947     /**
948      * @dev Called with the sale price to determine how much royalty is owed and to whom.
949      * @param tokenId - the NFT asset queried for royalty information
950      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
951      * @return receiver - address of who should be sent the royalty payment
952      * @return royaltyAmount - the royalty payment amount for `salePrice`
953      */
954     function royaltyInfo(uint256 tokenId, uint256 salePrice)
955         external
956         view
957         returns (address receiver, uint256 royaltyAmount);
958 }
959 
960 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
961 
962 
963 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
964 
965 pragma solidity ^0.8.0;
966 
967 
968 /**
969  * @dev Implementation of the {IERC165} interface.
970  *
971  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
972  * for the additional interface id that will be supported. For example:
973  *
974  * ```solidity
975  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
976  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
977  * }
978  * ```
979  *
980  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
981  */
982 abstract contract ERC165 is IERC165 {
983     /**
984      * @dev See {IERC165-supportsInterface}.
985      */
986     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
987         return interfaceId == type(IERC165).interfaceId;
988     }
989 }
990 
991 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
992 
993 
994 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
995 
996 pragma solidity ^0.8.0;
997 
998 
999 /**
1000  * @dev Required interface of an ERC721 compliant contract.
1001  */
1002 interface IERC721 is IERC165 {
1003     /**
1004      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1005      */
1006     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1007 
1008     /**
1009      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1010      */
1011     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1012 
1013     /**
1014      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1015      */
1016     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1017 
1018     /**
1019      * @dev Returns the number of tokens in ``owner``'s account.
1020      */
1021     function balanceOf(address owner) external view returns (uint256 balance);
1022 
1023     /**
1024      * @dev Returns the owner of the `tokenId` token.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must exist.
1029      */
1030     function ownerOf(uint256 tokenId) external view returns (address owner);
1031 
1032     /**
1033      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1034      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1035      *
1036      * Requirements:
1037      *
1038      * - `from` cannot be the zero address.
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must exist and be owned by `from`.
1041      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1042      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function safeTransferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) external;
1051 
1052     /**
1053      * @dev Transfers `tokenId` token from `from` to `to`.
1054      *
1055      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1056      *
1057      * Requirements:
1058      *
1059      * - `from` cannot be the zero address.
1060      * - `to` cannot be the zero address.
1061      * - `tokenId` token must be owned by `from`.
1062      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function transferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) external;
1071 
1072     /**
1073      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1074      * The approval is cleared when the token is transferred.
1075      *
1076      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1077      *
1078      * Requirements:
1079      *
1080      * - The caller must own the token or be an approved operator.
1081      * - `tokenId` must exist.
1082      *
1083      * Emits an {Approval} event.
1084      */
1085     function approve(address to, uint256 tokenId) external;
1086 
1087     /**
1088      * @dev Returns the account approved for `tokenId` token.
1089      *
1090      * Requirements:
1091      *
1092      * - `tokenId` must exist.
1093      */
1094     function getApproved(uint256 tokenId) external view returns (address operator);
1095 
1096     /**
1097      * @dev Approve or remove `operator` as an operator for the caller.
1098      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1099      *
1100      * Requirements:
1101      *
1102      * - The `operator` cannot be the caller.
1103      *
1104      * Emits an {ApprovalForAll} event.
1105      */
1106     function setApprovalForAll(address operator, bool _approved) external;
1107 
1108     /**
1109      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1110      *
1111      * See {setApprovalForAll}
1112      */
1113     function isApprovedForAll(address owner, address operator) external view returns (bool);
1114 
1115     /**
1116      * @dev Safely transfers `tokenId` token from `from` to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `from` cannot be the zero address.
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must exist and be owned by `from`.
1123      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function safeTransferFrom(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes calldata data
1133     ) external;
1134 }
1135 
1136 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1137 
1138 
1139 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1140 
1141 pragma solidity ^0.8.0;
1142 
1143 
1144 /**
1145  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1146  * @dev See https://eips.ethereum.org/EIPS/eip-721
1147  */
1148 interface IERC721Enumerable is IERC721 {
1149     /**
1150      * @dev Returns the total amount of tokens stored by the contract.
1151      */
1152     function totalSupply() external view returns (uint256);
1153 
1154     /**
1155      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1156      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1157      */
1158     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1159 
1160     /**
1161      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1162      * Use along with {totalSupply} to enumerate all tokens.
1163      */
1164     function tokenByIndex(uint256 index) external view returns (uint256);
1165 }
1166 
1167 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1168 
1169 
1170 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 
1175 /**
1176  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1177  * @dev See https://eips.ethereum.org/EIPS/eip-721
1178  */
1179 interface IERC721Metadata is IERC721 {
1180     /**
1181      * @dev Returns the token collection name.
1182      */
1183     function name() external view returns (string memory);
1184 
1185     /**
1186      * @dev Returns the token collection symbol.
1187      */
1188     function symbol() external view returns (string memory);
1189 
1190     /**
1191      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1192      */
1193     function tokenURI(uint256 tokenId) external view returns (string memory);
1194 }
1195 
1196 // File: contracts/ERC721A.sol
1197 
1198 
1199 
1200 pragma solidity ^0.8.0;
1201 
1202 
1203 
1204 
1205 
1206 
1207 
1208 
1209 
1210 /**
1211  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1212  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1213  *
1214  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1215  *
1216  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1217  *
1218  * Does not support burning tokens to address(0).
1219  */
1220 contract ERC721A is
1221   Context,
1222   ERC165,
1223   IERC721,
1224   IERC721Metadata,
1225   IERC721Enumerable
1226 {
1227   using Address for address;
1228   using Strings for uint256;
1229 
1230   struct TokenOwnership {
1231     address addr;
1232     uint64 startTimestamp;
1233   }
1234 
1235   struct AddressData {
1236     uint128 balance;
1237     uint128 numberMinted;
1238   }
1239 
1240   uint256 private currentIndex = 0;
1241 
1242   uint256 internal immutable collectionSize;
1243   uint256 internal immutable maxBatchSize;
1244 
1245   // Token name
1246   string private _name;
1247 
1248   // Token symbol
1249   string private _symbol;
1250 
1251   // Mapping from token ID to ownership details
1252   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1253   mapping(uint256 => TokenOwnership) private _ownerships;
1254 
1255   // Mapping owner address to address data
1256   mapping(address => AddressData) private _addressData;
1257 
1258   // Mapping from token ID to approved address
1259   mapping(uint256 => address) private _tokenApprovals;
1260 
1261   // Mapping from owner to operator approvals
1262   mapping(address => mapping(address => bool)) private _operatorApprovals;
1263 
1264   /**
1265    * @dev
1266    * `maxBatchSize` refers to how much a minter can mint at a time.
1267    * `collectionSize_` refers to how many tokens are in the collection.
1268    */
1269   constructor(
1270     string memory name_,
1271     string memory symbol_,
1272     uint256 maxBatchSize_,
1273     uint256 collectionSize_
1274   ) {
1275     require(
1276       collectionSize_ > 0,
1277       "ERC721A: collection must have a nonzero supply"
1278     );
1279     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1280     _name = name_;
1281     _symbol = symbol_;
1282     maxBatchSize = maxBatchSize_;
1283     collectionSize = collectionSize_;
1284   }
1285 
1286   /**
1287    * @dev See {IERC721Enumerable-totalSupply}.
1288    */
1289   function totalSupply() public view override returns (uint256) {
1290     return currentIndex;
1291   }
1292 
1293   /**
1294    * @dev See {IERC721Enumerable-tokenByIndex}.
1295    */
1296   function tokenByIndex(uint256 index) public view override returns (uint256) {
1297     require(index < totalSupply(), "ERC721A: global index out of bounds");
1298     return index;
1299   }
1300 
1301   /**
1302    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1303    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1304    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1305    */
1306   function tokenOfOwnerByIndex(address owner, uint256 index)
1307     public
1308     view
1309     override
1310     returns (uint256)
1311   {
1312     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1313     uint256 numMintedSoFar = totalSupply();
1314     uint256 tokenIdsIdx = 0;
1315     address currOwnershipAddr = address(0);
1316     for (uint256 i = 0; i < numMintedSoFar; i++) {
1317       TokenOwnership memory ownership = _ownerships[i];
1318       if (ownership.addr != address(0)) {
1319         currOwnershipAddr = ownership.addr;
1320       }
1321       if (currOwnershipAddr == owner) {
1322         if (tokenIdsIdx == index) {
1323           return i;
1324         }
1325         tokenIdsIdx++;
1326       }
1327     }
1328     revert("ERC721A: unable to get token of owner by index");
1329   }
1330 
1331   /**
1332    * @dev See {IERC165-supportsInterface}.
1333    */
1334   function supportsInterface(bytes4 interfaceId)
1335     public
1336     view
1337     virtual
1338     override(ERC165, IERC165)
1339     returns (bool)
1340   {
1341     return
1342       interfaceId == type(IERC721).interfaceId ||
1343       interfaceId == type(IERC721Metadata).interfaceId ||
1344       interfaceId == type(IERC721Enumerable).interfaceId ||
1345       super.supportsInterface(interfaceId);
1346   }
1347 
1348   /**
1349    * @dev See {IERC721-balanceOf}.
1350    */
1351   function balanceOf(address owner) public view override returns (uint256) {
1352     require(owner != address(0), "ERC721A: balance query for the zero address");
1353     return uint256(_addressData[owner].balance);
1354   }
1355 
1356   function _numberMinted(address owner) internal view returns (uint256) {
1357     require(
1358       owner != address(0),
1359       "ERC721A: number minted query for the zero address"
1360     );
1361     return uint256(_addressData[owner].numberMinted);
1362   }
1363 
1364   function ownershipOf(uint256 tokenId)
1365     internal
1366     view
1367     returns (TokenOwnership memory)
1368   {
1369     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1370 
1371     uint256 lowestTokenToCheck;
1372     if (tokenId >= maxBatchSize) {
1373       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1374     }
1375 
1376     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1377       TokenOwnership memory ownership = _ownerships[curr];
1378       if (ownership.addr != address(0)) {
1379         return ownership;
1380       }
1381     }
1382 
1383     revert("ERC721A: unable to determine the owner of token");
1384   }
1385 
1386   /**
1387    * @dev See {IERC721-ownerOf}.
1388    */
1389   function ownerOf(uint256 tokenId) public view override returns (address) {
1390     return ownershipOf(tokenId).addr;
1391   }
1392 
1393   /**
1394    * @dev See {IERC721Metadata-name}.
1395    */
1396   function name() public view virtual override returns (string memory) {
1397     return _name;
1398   }
1399 
1400   /**
1401    * @dev See {IERC721Metadata-symbol}.
1402    */
1403   function symbol() public view virtual override returns (string memory) {
1404     return _symbol;
1405   }
1406 
1407   /**
1408    * @dev See {IERC721Metadata-tokenURI}.
1409    */
1410   function tokenURI(uint256 tokenId)
1411     public
1412     view
1413     virtual
1414     override
1415     returns (string memory)
1416   {
1417     require(
1418       _exists(tokenId),
1419       "ERC721Metadata: URI query for nonexistent token"
1420     );
1421 
1422     string memory baseURI = _baseURI();
1423     return
1424       bytes(baseURI).length > 0
1425         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1426         : "";
1427   }
1428 
1429   /**
1430    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1431    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1432    * by default, can be overriden in child contracts.
1433    */
1434   function _baseURI() internal view virtual returns (string memory) {
1435     return "";
1436   }
1437 
1438   /**
1439    * @dev See {IERC721-approve}.
1440    */
1441   function approve(address to, uint256 tokenId) public override {
1442     address owner = ERC721A.ownerOf(tokenId);
1443     require(to != owner, "ERC721A: approval to current owner");
1444 
1445     require(
1446       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1447       "ERC721A: approve caller is not owner nor approved for all"
1448     );
1449 
1450     _approve(to, tokenId, owner);
1451   }
1452 
1453   /**
1454    * @dev See {IERC721-getApproved}.
1455    */
1456   function getApproved(uint256 tokenId) public view override returns (address) {
1457     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1458 
1459     return _tokenApprovals[tokenId];
1460   }
1461 
1462   /**
1463    * @dev See {IERC721-setApprovalForAll}.
1464    */
1465   function setApprovalForAll(address operator, bool approved) public override {
1466     require(operator != _msgSender(), "ERC721A: approve to caller");
1467 
1468     _operatorApprovals[_msgSender()][operator] = approved;
1469     emit ApprovalForAll(_msgSender(), operator, approved);
1470   }
1471 
1472   /**
1473    * @dev See {IERC721-isApprovedForAll}.
1474    */
1475   function isApprovedForAll(address owner, address operator)
1476     public
1477     view
1478     virtual
1479     override
1480     returns (bool)
1481   {
1482     return _operatorApprovals[owner][operator];
1483   }
1484 
1485   /**
1486    * @dev See {IERC721-transferFrom}.
1487    */
1488   function transferFrom(
1489     address from,
1490     address to,
1491     uint256 tokenId
1492   ) public override {
1493     _transfer(from, to, tokenId);
1494   }
1495 
1496   /**
1497    * @dev See {IERC721-safeTransferFrom}.
1498    */
1499   function safeTransferFrom(
1500     address from,
1501     address to,
1502     uint256 tokenId
1503   ) public override {
1504     safeTransferFrom(from, to, tokenId, "");
1505   }
1506 
1507   /**
1508    * @dev See {IERC721-safeTransferFrom}.
1509    */
1510   function safeTransferFrom(
1511     address from,
1512     address to,
1513     uint256 tokenId,
1514     bytes memory _data
1515   ) public override {
1516     _transfer(from, to, tokenId);
1517     require(
1518       _checkOnERC721Received(from, to, tokenId, _data),
1519       "ERC721A: transfer to non ERC721Receiver implementer"
1520     );
1521   }
1522 
1523   /**
1524    * @dev Returns whether `tokenId` exists.
1525    *
1526    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1527    *
1528    * Tokens start existing when they are minted (`_mint`),
1529    */
1530   function _exists(uint256 tokenId) internal view returns (bool) {
1531     return tokenId < currentIndex;
1532   }
1533 
1534   function _safeMint(address to, uint256 quantity) internal {
1535     _safeMint(to, quantity, "");
1536   }
1537 
1538   /**
1539    * @dev Mints `quantity` tokens and transfers them to `to`.
1540    *
1541    * Requirements:
1542    *
1543    * - there must be `quantity` tokens remaining unminted in the total collection.
1544    * - `to` cannot be the zero address.
1545    * - `quantity` cannot be larger than the max batch size.
1546    *
1547    * Emits a {Transfer} event.
1548    */
1549   function _safeMint(
1550     address to,
1551     uint256 quantity,
1552     bytes memory _data
1553   ) internal {
1554     uint256 startTokenId = currentIndex;
1555     require(to != address(0), "ERC721A: mint to the zero address");
1556     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1557     require(!_exists(startTokenId), "ERC721A: token already minted");
1558     // require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1559 
1560     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1561 
1562     AddressData memory addressData = _addressData[to];
1563     _addressData[to] = AddressData(
1564       addressData.balance + uint128(quantity),
1565       addressData.numberMinted + uint128(quantity)
1566     );
1567     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1568 
1569     uint256 updatedIndex = startTokenId;
1570 
1571     for (uint256 i = 0; i < quantity; i++) {
1572       emit Transfer(address(0), to, updatedIndex);
1573       require(
1574         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1575         "ERC721A: transfer to non ERC721Receiver implementer"
1576       );
1577       updatedIndex++;
1578     }
1579 
1580     currentIndex = updatedIndex;
1581     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1582   }
1583 
1584   /**
1585    * @dev Transfers `tokenId` from `from` to `to`.
1586    *
1587    * Requirements:
1588    *
1589    * - `to` cannot be the zero address.
1590    * - `tokenId` token must be owned by `from`.
1591    *
1592    * Emits a {Transfer} event.
1593    */
1594   function _transfer(
1595     address from,
1596     address to,
1597     uint256 tokenId
1598   ) private {
1599     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1600 
1601     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1602       getApproved(tokenId) == _msgSender() ||
1603       isApprovedForAll(prevOwnership.addr, _msgSender()));
1604 
1605     require(
1606       isApprovedOrOwner,
1607       "ERC721A: transfer caller is not owner nor approved"
1608     );
1609 
1610     require(
1611       prevOwnership.addr == from,
1612       "ERC721A: transfer from incorrect owner"
1613     );
1614     require(to != address(0), "ERC721A: transfer to the zero address");
1615 
1616     _beforeTokenTransfers(from, to, tokenId, 1);
1617 
1618     // Clear approvals from the previous owner
1619     _approve(address(0), tokenId, prevOwnership.addr);
1620 
1621     _addressData[from].balance -= 1;
1622     _addressData[to].balance += 1;
1623     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1624 
1625     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1626     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1627     uint256 nextTokenId = tokenId + 1;
1628     if (_ownerships[nextTokenId].addr == address(0)) {
1629       if (_exists(nextTokenId)) {
1630         _ownerships[nextTokenId] = TokenOwnership(
1631           prevOwnership.addr,
1632           prevOwnership.startTimestamp
1633         );
1634       }
1635     }
1636 
1637     emit Transfer(from, to, tokenId);
1638     _afterTokenTransfers(from, to, tokenId, 1);
1639   }
1640 
1641   /**
1642    * @dev Approve `to` to operate on `tokenId`
1643    *
1644    * Emits a {Approval} event.
1645    */
1646   function _approve(
1647     address to,
1648     uint256 tokenId,
1649     address owner
1650   ) private {
1651     _tokenApprovals[tokenId] = to;
1652     emit Approval(owner, to, tokenId);
1653   }
1654 
1655   uint256 public nextOwnerToExplicitlySet = 0;
1656 
1657   /**
1658    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1659    */
1660   function _setOwnersExplicit(uint256 quantity) internal {
1661     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1662     require(quantity > 0, "quantity must be nonzero");
1663     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1664     if (endIndex > collectionSize - 1) {
1665       endIndex = collectionSize - 1;
1666     }
1667     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1668     require(_exists(endIndex), "not enough minted yet for this cleanup");
1669     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1670       if (_ownerships[i].addr == address(0)) {
1671         TokenOwnership memory ownership = ownershipOf(i);
1672         _ownerships[i] = TokenOwnership(
1673           ownership.addr,
1674           ownership.startTimestamp
1675         );
1676       }
1677     }
1678     nextOwnerToExplicitlySet = endIndex + 1;
1679   }
1680 
1681   /**
1682    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1683    * The call is not executed if the target address is not a contract.
1684    *
1685    * @param from address representing the previous owner of the given token ID
1686    * @param to target address that will receive the tokens
1687    * @param tokenId uint256 ID of the token to be transferred
1688    * @param _data bytes optional data to send along with the call
1689    * @return bool whether the call correctly returned the expected magic value
1690    */
1691   function _checkOnERC721Received(
1692     address from,
1693     address to,
1694     uint256 tokenId,
1695     bytes memory _data
1696   ) private returns (bool) {
1697     if (to.isContract()) {
1698       try
1699         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1700       returns (bytes4 retval) {
1701         return retval == IERC721Receiver(to).onERC721Received.selector;
1702       } catch (bytes memory reason) {
1703         if (reason.length == 0) {
1704           revert("ERC721A: transfer to non ERC721Receiver implementer");
1705         } else {
1706           assembly {
1707             revert(add(32, reason), mload(reason))
1708           }
1709         }
1710       }
1711     } else {
1712       return true;
1713     }
1714   }
1715 
1716   /**
1717    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1718    *
1719    * startTokenId - the first token id to be transferred
1720    * quantity - the amount to be transferred
1721    *
1722    * Calling conditions:
1723    *
1724    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1725    * transferred to `to`.
1726    * - When `from` is zero, `tokenId` will be minted for `to`.
1727    */
1728   function _beforeTokenTransfers(
1729     address from,
1730     address to,
1731     uint256 startTokenId,
1732     uint256 quantity
1733   ) internal virtual {}
1734 
1735   /**
1736    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1737    * minting.
1738    *
1739    * startTokenId - the first token id to be transferred
1740    * quantity - the amount to be transferred
1741    *
1742    * Calling conditions:
1743    *
1744    * - when `from` and `to` are both non-zero.
1745    * - `from` and `to` are never both zero.
1746    */
1747   function _afterTokenTransfers(
1748     address from,
1749     address to,
1750     uint256 startTokenId,
1751     uint256 quantity
1752   ) internal virtual {}
1753 }
1754 // File: contracts/ROBO.sol
1755 
1756 //SPDX-License-Identifier: MIT
1757 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1758 
1759 pragma solidity ^0.8.0;
1760 
1761 
1762 
1763 
1764 
1765 
1766 
1767 
1768 
1769 contract ROBO is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1770     using Counters for Counters.Counter;
1771     using Strings for uint256;
1772 
1773     Counters.Counter private tokenCounter;
1774 
1775     string private baseURI = "ipfs://QmZbVggQFYXgptPoByLNn2ZL3qWmtiATgHmYLeQK5zNbmu";
1776 
1777     uint256 public constant MAX_MINTS_PER_TX = 10;
1778     uint256 public maxSupply = 589;
1779 
1780     uint256 public constant PUBLIC_SALE_PRICE = 0.03 ether;
1781     bool public isPublicSaleActive = false;
1782 
1783 
1784 
1785 
1786     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1787 
1788     modifier publicSaleActive() {
1789         require(isPublicSaleActive, "Public sale is not open");
1790         _;
1791     }
1792 
1793 
1794 
1795     modifier maxMintsPerTX(uint256 numberOfTokens) {
1796         require(
1797             numberOfTokens <= MAX_MINTS_PER_TX,
1798             "Max mints per transaction exceeded"
1799         );
1800         _;
1801     }
1802 
1803     modifier canMintNFTs(uint256 numberOfTokens) {
1804         require(
1805             totalSupply() + numberOfTokens <=
1806                 maxSupply,
1807             "Not enough mints remaining to mint"
1808         );
1809         _;
1810     }
1811 
1812     constructor(
1813     ) ERC721A("Ether Robots", "ROBO", 100, maxSupply) {
1814     }
1815 
1816 modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1817         require(
1818             (price * numberOfTokens) == msg.value,
1819             "Incorrect ETH value sent"
1820         );
1821         _;
1822     }
1823 
1824     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1825 
1826     function mint(uint256 numberOfTokens)
1827         external
1828         payable
1829         nonReentrant
1830         publicSaleActive
1831         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1832         canMintNFTs(numberOfTokens)
1833         maxMintsPerTX(numberOfTokens)
1834     {
1835 
1836         _safeMint(msg.sender, numberOfTokens);
1837     }
1838 
1839 
1840 
1841 
1842     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1843 
1844     function getBaseURI() external view returns (string memory) {
1845         return baseURI;
1846     }
1847 
1848     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1849 
1850     function setBaseURI(string memory _baseURI) external onlyOwner {
1851         baseURI = _baseURI;
1852     }
1853 
1854 
1855     function setIsPublicSaleActive(bool _isPublicSaleActive)
1856         external
1857         onlyOwner
1858     {
1859         isPublicSaleActive = _isPublicSaleActive;
1860     }
1861 
1862 
1863 
1864     function withdraw() public onlyOwner {
1865         uint256 balance = address(this).balance;
1866         payable(msg.sender).transfer(balance);
1867     }
1868 
1869     function withdrawTokens(IERC20 token) public onlyOwner {
1870         uint256 balance = token.balanceOf(address(this));
1871         token.transfer(msg.sender, balance);
1872     }
1873 
1874 
1875 
1876     // ============ SUPPORTING FUNCTIONS ============
1877 
1878     function nextTokenId() private returns (uint256) {
1879         tokenCounter.increment();
1880         return tokenCounter.current();
1881     }
1882 
1883     // ============ FUNCTION OVERRIDES ============
1884 
1885     function supportsInterface(bytes4 interfaceId)
1886         public
1887         view
1888         virtual
1889         override(ERC721A, IERC165)
1890         returns (bool)
1891     {
1892         return
1893             interfaceId == type(IERC2981).interfaceId ||
1894             super.supportsInterface(interfaceId);
1895     }
1896 
1897     /**
1898      * @dev See {IERC721Metadata-tokenURI}.
1899      */
1900     function tokenURI(uint256 tokenId)
1901         public
1902         view
1903         virtual
1904         override
1905         returns (string memory)
1906     {
1907         require(_exists(tokenId), "Nonexistent token");
1908 
1909         return
1910             baseURI;
1911     }
1912 
1913     /**
1914      * @dev See {IERC165-royaltyInfo}.
1915      */
1916     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1917         external
1918         view
1919         override
1920         returns (address receiver, uint256 royaltyAmount)
1921     {
1922         require(_exists(tokenId), "Nonexistent token");
1923 
1924         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1925     }
1926 }
1927 
1928 // These contract definitions are used to create a reference to the OpenSea
1929 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1930 contract OwnableDelegateProxy {
1931 
1932 }
1933 
1934 contract ProxyRegistry {
1935     mapping(address => OwnableDelegateProxy) public proxies;
1936 }