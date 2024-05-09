1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-02
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-03-19
7 */
8 
9 // File: contracts/KOFI.sol
10 
11 /**
12  *Submitted for verification at Etherscan.io on 2022-02-25
13 */
14 
15 // File: contracts/kofi.sol
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-02-23
19 */
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2022-02-14
23 */
24 
25 // File: contracts/kofi.sol
26 
27 /**
28  *Submitted for verification at Etherscan.io on 2022-01-18
29 */
30 
31 // File: contracts/kofi.sol
32 
33 /**
34  *Submitted for verification at Etherscan.io on 2022-01-18
35 */
36 
37 /**
38  *Submitted for verification at Etherscan.io on 2022-01-18
39 */
40 
41 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
42 
43 
44 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
45 
46 pragma solidity ^0.8.0;
47 
48 // CAUTION
49 // This version of SafeMath should only be used with Solidity 0.8 or later,
50 // because it relies on the compiler's built in overflow checks.
51 
52 /**
53  * @dev Wrappers over Solidity's arithmetic operations.
54  *
55  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
56  * now has built in overflow checking.
57  */
58 library SafeMath {
59     /**
60      * @dev Returns the addition of two unsigned integers, with an overflow flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             uint256 c = a + b;
67             if (c < a) return (false, 0);
68             return (true, c);
69         }
70     }
71 
72     /**
73      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
74      *
75      * _Available since v3.4._
76      */
77     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b > a) return (false, 0);
80             return (true, a - b);
81         }
82     }
83 
84     /**
85      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
86      *
87      * _Available since v3.4._
88      */
89     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
90         unchecked {
91             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92             // benefit is lost if 'b' is also tested.
93             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
94             if (a == 0) return (true, 0);
95             uint256 c = a * b;
96             if (c / a != b) return (false, 0);
97             return (true, c);
98         }
99     }
100 
101     /**
102      * @dev Returns the division of two unsigned integers, with a division by zero flag.
103      *
104      * _Available since v3.4._
105      */
106     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         unchecked {
108             if (b == 0) return (false, 0);
109             return (true, a / b);
110         }
111     }
112 
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
115      *
116      * _Available since v3.4._
117      */
118     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         unchecked {
120             if (b == 0) return (false, 0);
121             return (true, a % b);
122         }
123     }
124 
125     /**
126      * @dev Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      *
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a + b;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a - b;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      *
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         return a * b;
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers, reverting on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator.
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a / b;
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * reverting when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194         return a % b;
195     }
196 
197     /**
198      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
199      * overflow (when the result is negative).
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {trySub}.
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(
211         uint256 a,
212         uint256 b,
213         string memory errorMessage
214     ) internal pure returns (uint256) {
215         unchecked {
216             require(b <= a, errorMessage);
217             return a - b;
218         }
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         unchecked {
239             require(b > 0, errorMessage);
240             return a / b;
241         }
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * reverting with custom message when dividing by zero.
247      *
248      * CAUTION: This function is deprecated because it requires allocating memory for the error
249      * message unnecessarily. For custom revert reasons use {tryMod}.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         unchecked {
265             require(b > 0, errorMessage);
266             return a % b;
267         }
268     }
269 }
270 
271 // File: @openzeppelin/contracts/utils/Counters.sol
272 
273 
274 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @title Counters
280  * @author Matt Condon (@shrugs)
281  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
282  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
283  *
284  * Include with `using Counters for Counters.Counter;`
285  */
286 library Counters {
287     struct Counter {
288         // This variable should never be directly accessed by users of the library: interactions must be restricted to
289         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
290         // this feature: see https://github.com/ethereum/solidity/issues/4637
291         uint256 _value; // default: 0
292     }
293 
294     function current(Counter storage counter) internal view returns (uint256) {
295         return counter._value;
296     }
297 
298     function increment(Counter storage counter) internal {
299         unchecked {
300             counter._value += 1;
301         }
302     }
303 
304     function decrement(Counter storage counter) internal {
305         uint256 value = counter._value;
306         require(value > 0, "Counter: decrement overflow");
307         unchecked {
308             counter._value = value - 1;
309         }
310     }
311 
312     function reset(Counter storage counter) internal {
313         counter._value = 0;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev Contract module that helps prevent reentrant calls to a function.
326  *
327  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
328  * available, which can be applied to functions to make sure there are no nested
329  * (reentrant) calls to them.
330  *
331  * Note that because there is a single `nonReentrant` guard, functions marked as
332  * `nonReentrant` may not call one another. This can be worked around by making
333  * those functions `private`, and then adding `external` `nonReentrant` entry
334  * points to them.
335  *
336  * TIP: If you would like to learn more about reentrancy and alternative ways
337  * to protect against it, check out our blog post
338  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
339  */
340 abstract contract ReentrancyGuard {
341     // Booleans are more expensive than uint256 or any type that takes up a full
342     // word because each write operation emits an extra SLOAD to first read the
343     // slot's contents, replace the bits taken up by the boolean, and then write
344     // back. This is the compiler's defense against contract upgrades and
345     // pointer aliasing, and it cannot be disabled.
346 
347     // The values being non-zero value makes deployment a bit more expensive,
348     // but in exchange the refund on every call to nonReentrant will be lower in
349     // amount. Since refunds are capped to a percentage of the total
350     // transaction's gas, it is best to keep them low in cases like this one, to
351     // increase the likelihood of the full refund coming into effect.
352     uint256 private constant _NOT_ENTERED = 1;
353     uint256 private constant _ENTERED = 2;
354 
355     uint256 private _status;
356 
357     constructor() {
358         _status = _NOT_ENTERED;
359     }
360 
361     /**
362      * @dev Prevents a contract from calling itself, directly or indirectly.
363      * Calling a `nonReentrant` function from another `nonReentrant`
364      * function is not supported. It is possible to prevent this from happening
365      * by making the `nonReentrant` function external, and making it call a
366      * `private` function that does the actual work.
367      */
368     modifier nonReentrant() {
369         // On the first call to nonReentrant, _notEntered will be true
370         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
371 
372         // Any calls to nonReentrant after this point will fail
373         _status = _ENTERED;
374 
375         _;
376 
377         // By storing the original value once again, a refund is triggered (see
378         // https://eips.ethereum.org/EIPS/eip-2200)
379         _status = _NOT_ENTERED;
380     }
381 }
382 
383 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
384 
385 
386 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
387 
388 pragma solidity ^0.8.0;
389 
390 /**
391  * @dev Interface of the ERC20 standard as defined in the EIP.
392  */
393 interface IERC20 {
394     /**
395      * @dev Returns the amount of tokens in existence.
396      */
397     function totalSupply() external view returns (uint256);
398 
399     /**
400      * @dev Returns the amount of tokens owned by `account`.
401      */
402     function balanceOf(address account) external view returns (uint256);
403 
404     /**
405      * @dev Moves `amount` tokens from the caller's account to `recipient`.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transfer(address recipient, uint256 amount) external returns (bool);
412 
413     /**
414      * @dev Returns the remaining number of tokens that `spender` will be
415      * allowed to spend on behalf of `owner` through {transferFrom}. This is
416      * zero by default.
417      *
418      * This value changes when {approve} or {transferFrom} are called.
419      */
420     function allowance(address owner, address spender) external view returns (uint256);
421 
422     /**
423      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
424      *
425      * Returns a boolean value indicating whether the operation succeeded.
426      *
427      * IMPORTANT: Beware that changing an allowance with this method brings the risk
428      * that someone may use both the old and the new allowance by unfortunate
429      * transaction ordering. One possible solution to mitigate this race
430      * condition is to first reduce the spender's allowance to 0 and set the
431      * desired value afterwards:
432      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
433      *
434      * Emits an {Approval} event.
435      */
436     function approve(address spender, uint256 amount) external returns (bool);
437 
438     /**
439      * @dev Moves `amount` tokens from `sender` to `recipient` using the
440      * allowance mechanism. `amount` is then deducted from the caller's
441      * allowance.
442      *
443      * Returns a boolean value indicating whether the operation succeeded.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transferFrom(
448         address sender,
449         address recipient,
450         uint256 amount
451     ) external returns (bool);
452 
453     /**
454      * @dev Emitted when `value` tokens are moved from one account (`from`) to
455      * another (`to`).
456      *
457      * Note that `value` may be zero.
458      */
459     event Transfer(address indexed from, address indexed to, uint256 value);
460 
461     /**
462      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
463      * a call to {approve}. `value` is the new allowance.
464      */
465     event Approval(address indexed owner, address indexed spender, uint256 value);
466 }
467 
468 // File: @openzeppelin/contracts/interfaces/IERC20.sol
469 
470 
471 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 
476 // File: @openzeppelin/contracts/utils/Strings.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev String operations.
485  */
486 library Strings {
487     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
491      */
492     function toString(uint256 value) internal pure returns (string memory) {
493         // Inspired by OraclizeAPI's implementation - MIT licence
494         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
495 
496         if (value == 0) {
497             return "0";
498         }
499         uint256 temp = value;
500         uint256 digits;
501         while (temp != 0) {
502             digits++;
503             temp /= 10;
504         }
505         bytes memory buffer = new bytes(digits);
506         while (value != 0) {
507             digits -= 1;
508             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
509             value /= 10;
510         }
511         return string(buffer);
512     }
513 
514     /**
515      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
516      */
517     function toHexString(uint256 value) internal pure returns (string memory) {
518         if (value == 0) {
519             return "0x00";
520         }
521         uint256 temp = value;
522         uint256 length = 0;
523         while (temp != 0) {
524             length++;
525             temp >>= 8;
526         }
527         return toHexString(value, length);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
532      */
533     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
534         bytes memory buffer = new bytes(2 * length + 2);
535         buffer[0] = "0";
536         buffer[1] = "x";
537         for (uint256 i = 2 * length + 1; i > 1; --i) {
538             buffer[i] = _HEX_SYMBOLS[value & 0xf];
539             value >>= 4;
540         }
541         require(value == 0, "Strings: hex length insufficient");
542         return string(buffer);
543     }
544 }
545 
546 // File: @openzeppelin/contracts/utils/Context.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev Provides information about the current execution context, including the
555  * sender of the transaction and its data. While these are generally available
556  * via msg.sender and msg.data, they should not be accessed in such a direct
557  * manner, since when dealing with meta-transactions the account sending and
558  * paying for execution may not be the actual sender (as far as an application
559  * is concerned).
560  *
561  * This contract is only required for intermediate, library-like contracts.
562  */
563 abstract contract Context {
564     function _msgSender() internal view virtual returns (address) {
565         return msg.sender;
566     }
567 
568     function _msgData() internal view virtual returns (bytes calldata) {
569         return msg.data;
570     }
571 }
572 
573 // File: @openzeppelin/contracts/access/Ownable.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @dev Contract module which provides a basic access control mechanism, where
583  * there is an account (an owner) that can be granted exclusive access to
584  * specific functions.
585  *
586  * By default, the owner account will be the one that deploys the contract. This
587  * can later be changed with {transferOwnership}.
588  *
589  * This module is used through inheritance. It will make available the modifier
590  * `onlyOwner`, which can be applied to your functions to restrict their use to
591  * the owner.
592  */
593 abstract contract Ownable is Context {
594     address private _owner;
595 
596     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
597 
598     /**
599      * @dev Initializes the contract setting the deployer as the initial owner.
600      */
601     constructor() {
602         _transferOwnership(_msgSender());
603     }
604 
605     /**
606      * @dev Returns the address of the current owner.
607      */
608     function owner() public view virtual returns (address) {
609         return _owner;
610     }
611 
612     /**
613      * @dev Throws if called by any account other than the owner.
614      */
615     modifier onlyOwner() {
616         require(owner() == _msgSender(), "Ownable: caller is not the owner");
617         _;
618     }
619 
620     /**
621      * @dev Leaves the contract without owner. It will not be possible to call
622      * `onlyOwner` functions anymore. Can only be called by the current owner.
623      *
624      * NOTE: Renouncing ownership will leave the contract without an owner,
625      * thereby removing any functionality that is only available to the owner.
626      */
627     function renounceOwnership() public virtual onlyOwner {
628         _transferOwnership(address(0));
629     }
630 
631     /**
632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
633      * Can only be called by the current owner.
634      */
635     function transferOwnership(address newOwner) public virtual onlyOwner {
636         require(newOwner != address(0), "Ownable: new owner is the zero address");
637         _transferOwnership(newOwner);
638     }
639 
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      * Internal function without access restriction.
643      */
644     function _transferOwnership(address newOwner) internal virtual {
645         address oldOwner = _owner;
646         _owner = newOwner;
647         emit OwnershipTransferred(oldOwner, newOwner);
648     }
649 }
650 
651 // File: @openzeppelin/contracts/utils/Address.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Collection of functions related to the address type
660  */
661 library Address {
662     /**
663      * @dev Returns true if `account` is a contract.
664      *
665      * [IMPORTANT]
666      * ====
667      * It is unsafe to assume that an address for which this function returns
668      * false is an externally-owned account (EOA) and not a contract.
669      *
670      * Among others, `isContract` will return false for the following
671      * types of addresses:
672      *
673      *  - an externally-owned account
674      *  - a contract in construction
675      *  - an address where a contract will be created
676      *  - an address where a contract lived, but was destroyed
677      * ====
678      */
679     function isContract(address account) internal view returns (bool) {
680         // This method relies on extcodesize, which returns 0 for contracts in
681         // construction, since the code is only stored at the end of the
682         // constructor execution.
683 
684         uint256 size;
685         assembly {
686             size := extcodesize(account)
687         }
688         return size > 0;
689     }
690 
691     /**
692      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
693      * `recipient`, forwarding all available gas and reverting on errors.
694      *
695      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
696      * of certain opcodes, possibly making contracts go over the 2300 gas limit
697      * imposed by `transfer`, making them unable to receive funds via
698      * `transfer`. {sendValue} removes this limitation.
699      *
700      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
701      *
702      * IMPORTANT: because control is transferred to `recipient`, care must be
703      * taken to not create reentrancy vulnerabilities. Consider using
704      * {ReentrancyGuard} or the
705      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
706      */
707     function sendValue(address payable recipient, uint256 amount) internal {
708         require(address(this).balance >= amount, "Address: insufficient balance");
709 
710         (bool success, ) = recipient.call{value: amount}("");
711         require(success, "Address: unable to send value, recipient may have reverted");
712     }
713 
714     /**
715      * @dev Performs a Solidity function call using a low level `call`. A
716      * plain `call` is an unsafe replacement for a function call: use this
717      * function instead.
718      *
719      * If `target` reverts with a revert reason, it is bubbled up by this
720      * function (like regular Solidity function calls).
721      *
722      * Returns the raw returned data. To convert to the expected return value,
723      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
724      *
725      * Requirements:
726      *
727      * - `target` must be a contract.
728      * - calling `target` with `data` must not revert.
729      *
730      * _Available since v3.1._
731      */
732     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
733         return functionCall(target, data, "Address: low-level call failed");
734     }
735 
736     /**
737      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
738      * `errorMessage` as a fallback revert reason when `target` reverts.
739      *
740      * _Available since v3.1._
741      */
742     function functionCall(
743         address target,
744         bytes memory data,
745         string memory errorMessage
746     ) internal returns (bytes memory) {
747         return functionCallWithValue(target, data, 0, errorMessage);
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
752      * but also transferring `value` wei to `target`.
753      *
754      * Requirements:
755      *
756      * - the calling contract must have an ETH balance of at least `value`.
757      * - the called Solidity function must be `payable`.
758      *
759      * _Available since v3.1._
760      */
761     function functionCallWithValue(
762         address target,
763         bytes memory data,
764         uint256 value
765     ) internal returns (bytes memory) {
766         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
767     }
768 
769     /**
770      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
771      * with `errorMessage` as a fallback revert reason when `target` reverts.
772      *
773      * _Available since v3.1._
774      */
775     function functionCallWithValue(
776         address target,
777         bytes memory data,
778         uint256 value,
779         string memory errorMessage
780     ) internal returns (bytes memory) {
781         require(address(this).balance >= value, "Address: insufficient balance for call");
782         require(isContract(target), "Address: call to non-contract");
783 
784         (bool success, bytes memory returndata) = target.call{value: value}(data);
785         return verifyCallResult(success, returndata, errorMessage);
786     }
787 
788     /**
789      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
790      * but performing a static call.
791      *
792      * _Available since v3.3._
793      */
794     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
795         return functionStaticCall(target, data, "Address: low-level static call failed");
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
800      * but performing a static call.
801      *
802      * _Available since v3.3._
803      */
804     function functionStaticCall(
805         address target,
806         bytes memory data,
807         string memory errorMessage
808     ) internal view returns (bytes memory) {
809         require(isContract(target), "Address: static call to non-contract");
810 
811         (bool success, bytes memory returndata) = target.staticcall(data);
812         return verifyCallResult(success, returndata, errorMessage);
813     }
814 
815     /**
816      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
817      * but performing a delegate call.
818      *
819      * _Available since v3.4._
820      */
821     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
822         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
823     }
824 
825     /**
826      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
827      * but performing a delegate call.
828      *
829      * _Available since v3.4._
830      */
831     function functionDelegateCall(
832         address target,
833         bytes memory data,
834         string memory errorMessage
835     ) internal returns (bytes memory) {
836         require(isContract(target), "Address: delegate call to non-contract");
837 
838         (bool success, bytes memory returndata) = target.delegatecall(data);
839         return verifyCallResult(success, returndata, errorMessage);
840     }
841 
842     /**
843      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
844      * revert reason using the provided one.
845      *
846      * _Available since v4.3._
847      */
848     function verifyCallResult(
849         bool success,
850         bytes memory returndata,
851         string memory errorMessage
852     ) internal pure returns (bytes memory) {
853         if (success) {
854             return returndata;
855         } else {
856             // Look for revert reason and bubble it up if present
857             if (returndata.length > 0) {
858                 // The easiest way to bubble the revert reason is using memory via assembly
859 
860                 assembly {
861                     let returndata_size := mload(returndata)
862                     revert(add(32, returndata), returndata_size)
863                 }
864             } else {
865                 revert(errorMessage);
866             }
867         }
868     }
869 }
870 
871 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
872 
873 
874 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
875 
876 pragma solidity ^0.8.0;
877 
878 /**
879  * @title ERC721 token receiver interface
880  * @dev Interface for any contract that wants to support safeTransfers
881  * from ERC721 asset contracts.
882  */
883 interface IERC721Receiver {
884     /**
885      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
886      * by `operator` from `from`, this function is called.
887      *
888      * It must return its Solidity selector to confirm the token transfer.
889      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
890      *
891      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
892      */
893     function onERC721Received(
894         address operator,
895         address from,
896         uint256 tokenId,
897         bytes calldata data
898     ) external returns (bytes4);
899 }
900 
901 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
902 
903 
904 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
905 
906 pragma solidity ^0.8.0;
907 
908 /**
909  * @dev Interface of the ERC165 standard, as defined in the
910  * https://eips.ethereum.org/EIPS/eip-165[EIP].
911  *
912  * Implementers can declare support of contract interfaces, which can then be
913  * queried by others ({ERC165Checker}).
914  *
915  * For an implementation, see {ERC165}.
916  */
917 interface IERC165 {
918     /**
919      * @dev Returns true if this contract implements the interface defined by
920      * `interfaceId`. See the corresponding
921      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
922      * to learn more about how these ids are created.
923      *
924      * This function call must use less than 30 000 gas.
925      */
926     function supportsInterface(bytes4 interfaceId) external view returns (bool);
927 }
928 
929 // File: @openzeppelin/contracts/interfaces/IERC165.sol
930 
931 
932 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 
937 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
938 
939 
940 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
941 
942 pragma solidity ^0.8.0;
943 
944 
945 /**
946  * @dev Interface for the NFT Royalty Standard
947  */
948 interface IERC2981 is IERC165 {
949     /**
950      * @dev Called with the sale price to determine how much royalty is owed and to whom.
951      * @param tokenId - the NFT asset queried for royalty information
952      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
953      * @return receiver - address of who should be sent the royalty payment
954      * @return royaltyAmount - the royalty payment amount for `salePrice`
955      */
956     function royaltyInfo(uint256 tokenId, uint256 salePrice)
957         external
958         view
959         returns (address receiver, uint256 royaltyAmount);
960 }
961 
962 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
963 
964 
965 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 
970 /**
971  * @dev Implementation of the {IERC165} interface.
972  *
973  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
974  * for the additional interface id that will be supported. For example:
975  *
976  * ```solidity
977  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
978  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
979  * }
980  * ```
981  *
982  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
983  */
984 abstract contract ERC165 is IERC165 {
985     /**
986      * @dev See {IERC165-supportsInterface}.
987      */
988     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
989         return interfaceId == type(IERC165).interfaceId;
990     }
991 }
992 
993 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
994 
995 
996 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
997 
998 pragma solidity ^0.8.0;
999 
1000 
1001 /**
1002  * @dev Required interface of an ERC721 compliant contract.
1003  */
1004 interface IERC721 is IERC165 {
1005     /**
1006      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1007      */
1008     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1009 
1010     /**
1011      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1012      */
1013     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1014 
1015     /**
1016      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1017      */
1018     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1019 
1020     /**
1021      * @dev Returns the number of tokens in ``owner``'s account.
1022      */
1023     function balanceOf(address owner) external view returns (uint256 balance);
1024 
1025     /**
1026      * @dev Returns the owner of the `tokenId` token.
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must exist.
1031      */
1032     function ownerOf(uint256 tokenId) external view returns (address owner);
1033 
1034     /**
1035      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1036      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1037      *
1038      * Requirements:
1039      *
1040      * - `from` cannot be the zero address.
1041      * - `to` cannot be the zero address.
1042      * - `tokenId` token must exist and be owned by `from`.
1043      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1044      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) external;
1053 
1054     /**
1055      * @dev Transfers `tokenId` token from `from` to `to`.
1056      *
1057      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1058      *
1059      * Requirements:
1060      *
1061      * - `from` cannot be the zero address.
1062      * - `to` cannot be the zero address.
1063      * - `tokenId` token must be owned by `from`.
1064      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function transferFrom(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) external;
1073 
1074     /**
1075      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1076      * The approval is cleared when the token is transferred.
1077      *
1078      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1079      *
1080      * Requirements:
1081      *
1082      * - The caller must own the token or be an approved operator.
1083      * - `tokenId` must exist.
1084      *
1085      * Emits an {Approval} event.
1086      */
1087     function approve(address to, uint256 tokenId) external;
1088 
1089     /**
1090      * @dev Returns the account approved for `tokenId` token.
1091      *
1092      * Requirements:
1093      *
1094      * - `tokenId` must exist.
1095      */
1096     function getApproved(uint256 tokenId) external view returns (address operator);
1097 
1098     /**
1099      * @dev Approve or remove `operator` as an operator for the caller.
1100      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1101      *
1102      * Requirements:
1103      *
1104      * - The `operator` cannot be the caller.
1105      *
1106      * Emits an {ApprovalForAll} event.
1107      */
1108     function setApprovalForAll(address operator, bool _approved) external;
1109 
1110     /**
1111      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1112      *
1113      * See {setApprovalForAll}
1114      */
1115     function isApprovedForAll(address owner, address operator) external view returns (bool);
1116 
1117     /**
1118      * @dev Safely transfers `tokenId` token from `from` to `to`.
1119      *
1120      * Requirements:
1121      *
1122      * - `from` cannot be the zero address.
1123      * - `to` cannot be the zero address.
1124      * - `tokenId` token must exist and be owned by `from`.
1125      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1126      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function safeTransferFrom(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes calldata data
1135     ) external;
1136 }
1137 
1138 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1139 
1140 
1141 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 
1146 /**
1147  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1148  * @dev See https://eips.ethereum.org/EIPS/eip-721
1149  */
1150 interface IERC721Enumerable is IERC721 {
1151     /**
1152      * @dev Returns the total amount of tokens stored by the contract.
1153      */
1154     function totalSupply() external view returns (uint256);
1155 
1156     /**
1157      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1158      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1159      */
1160     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1161 
1162     /**
1163      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1164      * Use along with {totalSupply} to enumerate all tokens.
1165      */
1166     function tokenByIndex(uint256 index) external view returns (uint256);
1167 }
1168 
1169 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1170 
1171 
1172 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 
1177 /**
1178  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1179  * @dev See https://eips.ethereum.org/EIPS/eip-721
1180  */
1181 interface IERC721Metadata is IERC721 {
1182     /**
1183      * @dev Returns the token collection name.
1184      */
1185     function name() external view returns (string memory);
1186 
1187     /**
1188      * @dev Returns the token collection symbol.
1189      */
1190     function symbol() external view returns (string memory);
1191 
1192     /**
1193      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1194      */
1195     function tokenURI(uint256 tokenId) external view returns (string memory);
1196 }
1197 
1198 // File: contracts/ERC721A.sol
1199 
1200 
1201 
1202 pragma solidity ^0.8.0;
1203 
1204 
1205 
1206 
1207 
1208 
1209 
1210 
1211 
1212 /**
1213  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1214  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1215  *
1216  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1217  *
1218  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1219  *
1220  * Does not support burning tokens to address(0).
1221  */
1222 contract ERC721A is
1223   Context,
1224   ERC165,
1225   IERC721,
1226   IERC721Metadata,
1227   IERC721Enumerable
1228 {
1229   using Address for address;
1230   using Strings for uint256;
1231 
1232   struct TokenOwnership {
1233     address addr;
1234     uint64 startTimestamp;
1235   }
1236 
1237   struct AddressData {
1238     uint128 balance;
1239     uint128 numberMinted;
1240   }
1241 
1242   uint256 private currentIndex = 0;
1243 
1244   uint256 internal immutable collectionSize;
1245   uint256 internal immutable maxBatchSize;
1246 
1247   // Token name
1248   string private _name;
1249 
1250   // Token symbol
1251   string private _symbol;
1252 
1253   // Mapping from token ID to ownership details
1254   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1255   mapping(uint256 => TokenOwnership) private _ownerships;
1256 
1257   // Mapping owner address to address data
1258   mapping(address => AddressData) private _addressData;
1259 
1260   // Mapping from token ID to approved address
1261   mapping(uint256 => address) private _tokenApprovals;
1262 
1263   // Mapping from owner to operator approvals
1264   mapping(address => mapping(address => bool)) private _operatorApprovals;
1265 
1266   /**
1267    * @dev
1268    * `maxBatchSize` refers to how much a minter can mint at a time.
1269    * `collectionSize_` refers to how many tokens are in the collection.
1270    */
1271   constructor(
1272     string memory name_,
1273     string memory symbol_,
1274     uint256 maxBatchSize_,
1275     uint256 collectionSize_
1276   ) {
1277     require(
1278       collectionSize_ > 0,
1279       "ERC721A: collection must have a nonzero supply"
1280     );
1281     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1282     _name = name_;
1283     _symbol = symbol_;
1284     maxBatchSize = maxBatchSize_;
1285     collectionSize = collectionSize_;
1286   }
1287 
1288   /**
1289    * @dev See {IERC721Enumerable-totalSupply}.
1290    */
1291   function totalSupply() public view override returns (uint256) {
1292     return currentIndex;
1293   }
1294 
1295   /**
1296    * @dev See {IERC721Enumerable-tokenByIndex}.
1297    */
1298   function tokenByIndex(uint256 index) public view override returns (uint256) {
1299     require(index < totalSupply(), "ERC721A: global index out of bounds");
1300     return index;
1301   }
1302 
1303   /**
1304    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1305    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1306    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1307    */
1308   function tokenOfOwnerByIndex(address owner, uint256 index)
1309     public
1310     view
1311     override
1312     returns (uint256)
1313   {
1314     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1315     uint256 numMintedSoFar = totalSupply();
1316     uint256 tokenIdsIdx = 0;
1317     address currOwnershipAddr = address(0);
1318     for (uint256 i = 0; i < numMintedSoFar; i++) {
1319       TokenOwnership memory ownership = _ownerships[i];
1320       if (ownership.addr != address(0)) {
1321         currOwnershipAddr = ownership.addr;
1322       }
1323       if (currOwnershipAddr == owner) {
1324         if (tokenIdsIdx == index) {
1325           return i;
1326         }
1327         tokenIdsIdx++;
1328       }
1329     }
1330     revert("ERC721A: unable to get token of owner by index");
1331   }
1332 
1333   /**
1334    * @dev See {IERC165-supportsInterface}.
1335    */
1336   function supportsInterface(bytes4 interfaceId)
1337     public
1338     view
1339     virtual
1340     override(ERC165, IERC165)
1341     returns (bool)
1342   {
1343     return
1344       interfaceId == type(IERC721).interfaceId ||
1345       interfaceId == type(IERC721Metadata).interfaceId ||
1346       interfaceId == type(IERC721Enumerable).interfaceId ||
1347       super.supportsInterface(interfaceId);
1348   }
1349 
1350   /**
1351    * @dev See {IERC721-balanceOf}.
1352    */
1353   function balanceOf(address owner) public view override returns (uint256) {
1354     require(owner != address(0), "ERC721A: balance query for the zero address");
1355     return uint256(_addressData[owner].balance);
1356   }
1357 
1358   function _numberMinted(address owner) internal view returns (uint256) {
1359     require(
1360       owner != address(0),
1361       "ERC721A: number minted query for the zero address"
1362     );
1363     return uint256(_addressData[owner].numberMinted);
1364   }
1365 
1366   function ownershipOf(uint256 tokenId)
1367     internal
1368     view
1369     returns (TokenOwnership memory)
1370   {
1371     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1372 
1373     uint256 lowestTokenToCheck;
1374     if (tokenId >= maxBatchSize) {
1375       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1376     }
1377 
1378     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1379       TokenOwnership memory ownership = _ownerships[curr];
1380       if (ownership.addr != address(0)) {
1381         return ownership;
1382       }
1383     }
1384 
1385     revert("ERC721A: unable to determine the owner of token");
1386   }
1387 
1388   /**
1389    * @dev See {IERC721-ownerOf}.
1390    */
1391   function ownerOf(uint256 tokenId) public view override returns (address) {
1392     return ownershipOf(tokenId).addr;
1393   }
1394 
1395   /**
1396    * @dev See {IERC721Metadata-name}.
1397    */
1398   function name() public view virtual override returns (string memory) {
1399     return _name;
1400   }
1401 
1402   /**
1403    * @dev See {IERC721Metadata-symbol}.
1404    */
1405   function symbol() public view virtual override returns (string memory) {
1406     return _symbol;
1407   }
1408 
1409   /**
1410    * @dev See {IERC721Metadata-tokenURI}.
1411    */
1412   function tokenURI(uint256 tokenId)
1413     public
1414     view
1415     virtual
1416     override
1417     returns (string memory)
1418   {
1419     require(
1420       _exists(tokenId),
1421       "ERC721Metadata: URI query for nonexistent token"
1422     );
1423 
1424     string memory baseURI = _baseURI();
1425     return
1426       bytes(baseURI).length > 0
1427         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1428         : "";
1429   }
1430 
1431   /**
1432    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1433    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1434    * by default, can be overriden in child contracts.
1435    */
1436   function _baseURI() internal view virtual returns (string memory) {
1437     return "";
1438   }
1439 
1440   /**
1441    * @dev See {IERC721-approve}.
1442    */
1443   function approve(address to, uint256 tokenId) public override {
1444     address owner = ERC721A.ownerOf(tokenId);
1445     require(to != owner, "ERC721A: approval to current owner");
1446 
1447     require(
1448       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1449       "ERC721A: approve caller is not owner nor approved for all"
1450     );
1451 
1452     _approve(to, tokenId, owner);
1453   }
1454 
1455   /**
1456    * @dev See {IERC721-getApproved}.
1457    */
1458   function getApproved(uint256 tokenId) public view override returns (address) {
1459     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1460 
1461     return _tokenApprovals[tokenId];
1462   }
1463 
1464   /**
1465    * @dev See {IERC721-setApprovalForAll}.
1466    */
1467   function setApprovalForAll(address operator, bool approved) public override {
1468     require(operator != _msgSender(), "ERC721A: approve to caller");
1469 
1470     _operatorApprovals[_msgSender()][operator] = approved;
1471     emit ApprovalForAll(_msgSender(), operator, approved);
1472   }
1473 
1474   /**
1475    * @dev See {IERC721-isApprovedForAll}.
1476    */
1477   function isApprovedForAll(address owner, address operator)
1478     public
1479     view
1480     virtual
1481     override
1482     returns (bool)
1483   {
1484     return _operatorApprovals[owner][operator];
1485   }
1486 
1487   /**
1488    * @dev See {IERC721-transferFrom}.
1489    */
1490   function transferFrom(
1491     address from,
1492     address to,
1493     uint256 tokenId
1494   ) public override {
1495     _transfer(from, to, tokenId);
1496   }
1497 
1498   /**
1499    * @dev See {IERC721-safeTransferFrom}.
1500    */
1501   function safeTransferFrom(
1502     address from,
1503     address to,
1504     uint256 tokenId
1505   ) public override {
1506     safeTransferFrom(from, to, tokenId, "");
1507   }
1508 
1509   /**
1510    * @dev See {IERC721-safeTransferFrom}.
1511    */
1512   function safeTransferFrom(
1513     address from,
1514     address to,
1515     uint256 tokenId,
1516     bytes memory _data
1517   ) public override {
1518     _transfer(from, to, tokenId);
1519     require(
1520       _checkOnERC721Received(from, to, tokenId, _data),
1521       "ERC721A: transfer to non ERC721Receiver implementer"
1522     );
1523   }
1524 
1525   /**
1526    * @dev Returns whether `tokenId` exists.
1527    *
1528    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1529    *
1530    * Tokens start existing when they are minted (`_mint`),
1531    */
1532   function _exists(uint256 tokenId) internal view returns (bool) {
1533     return tokenId < currentIndex;
1534   }
1535 
1536   function _safeMint(address to, uint256 quantity) internal {
1537     _safeMint(to, quantity, "");
1538   }
1539 
1540   /**
1541    * @dev Mints `quantity` tokens and transfers them to `to`.
1542    *
1543    * Requirements:
1544    *
1545    * - there must be `quantity` tokens remaining unminted in the total collection.
1546    * - `to` cannot be the zero address.
1547    * - `quantity` cannot be larger than the max batch size.
1548    *
1549    * Emits a {Transfer} event.
1550    */
1551   function _safeMint(
1552     address to,
1553     uint256 quantity,
1554     bytes memory _data
1555   ) internal {
1556     uint256 startTokenId = currentIndex;
1557     require(to != address(0), "ERC721A: mint to the zero address");
1558     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1559     require(!_exists(startTokenId), "ERC721A: token already minted");
1560     // require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1561 
1562     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1563 
1564     AddressData memory addressData = _addressData[to];
1565     _addressData[to] = AddressData(
1566       addressData.balance + uint128(quantity),
1567       addressData.numberMinted + uint128(quantity)
1568     );
1569     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1570 
1571     uint256 updatedIndex = startTokenId;
1572 
1573     for (uint256 i = 0; i < quantity; i++) {
1574       emit Transfer(address(0), to, updatedIndex);
1575       require(
1576         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1577         "ERC721A: transfer to non ERC721Receiver implementer"
1578       );
1579       updatedIndex++;
1580     }
1581 
1582     currentIndex = updatedIndex;
1583     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1584   }
1585 
1586   /**
1587    * @dev Transfers `tokenId` from `from` to `to`.
1588    *
1589    * Requirements:
1590    *
1591    * - `to` cannot be the zero address.
1592    * - `tokenId` token must be owned by `from`.
1593    *
1594    * Emits a {Transfer} event.
1595    */
1596   function _transfer(
1597     address from,
1598     address to,
1599     uint256 tokenId
1600   ) private {
1601     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1602 
1603     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1604       getApproved(tokenId) == _msgSender() ||
1605       isApprovedForAll(prevOwnership.addr, _msgSender()));
1606 
1607     require(
1608       isApprovedOrOwner,
1609       "ERC721A: transfer caller is not owner nor approved"
1610     );
1611 
1612     require(
1613       prevOwnership.addr == from,
1614       "ERC721A: transfer from incorrect owner"
1615     );
1616     require(to != address(0), "ERC721A: transfer to the zero address");
1617 
1618     _beforeTokenTransfers(from, to, tokenId, 1);
1619 
1620     // Clear approvals from the previous owner
1621     _approve(address(0), tokenId, prevOwnership.addr);
1622 
1623     _addressData[from].balance -= 1;
1624     _addressData[to].balance += 1;
1625     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1626 
1627     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1628     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1629     uint256 nextTokenId = tokenId + 1;
1630     if (_ownerships[nextTokenId].addr == address(0)) {
1631       if (_exists(nextTokenId)) {
1632         _ownerships[nextTokenId] = TokenOwnership(
1633           prevOwnership.addr,
1634           prevOwnership.startTimestamp
1635         );
1636       }
1637     }
1638 
1639     emit Transfer(from, to, tokenId);
1640     _afterTokenTransfers(from, to, tokenId, 1);
1641   }
1642 
1643   /**
1644    * @dev Approve `to` to operate on `tokenId`
1645    *
1646    * Emits a {Approval} event.
1647    */
1648   function _approve(
1649     address to,
1650     uint256 tokenId,
1651     address owner
1652   ) private {
1653     _tokenApprovals[tokenId] = to;
1654     emit Approval(owner, to, tokenId);
1655   }
1656 
1657   uint256 public nextOwnerToExplicitlySet = 0;
1658 
1659   /**
1660    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1661    */
1662   function _setOwnersExplicit(uint256 quantity) internal {
1663     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1664     require(quantity > 0, "quantity must be nonzero");
1665     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1666     if (endIndex > collectionSize - 1) {
1667       endIndex = collectionSize - 1;
1668     }
1669     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1670     require(_exists(endIndex), "not enough minted yet for this cleanup");
1671     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1672       if (_ownerships[i].addr == address(0)) {
1673         TokenOwnership memory ownership = ownershipOf(i);
1674         _ownerships[i] = TokenOwnership(
1675           ownership.addr,
1676           ownership.startTimestamp
1677         );
1678       }
1679     }
1680     nextOwnerToExplicitlySet = endIndex + 1;
1681   }
1682 
1683   /**
1684    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1685    * The call is not executed if the target address is not a contract.
1686    *
1687    * @param from address representing the previous owner of the given token ID
1688    * @param to target address that will receive the tokens
1689    * @param tokenId uint256 ID of the token to be transferred
1690    * @param _data bytes optional data to send along with the call
1691    * @return bool whether the call correctly returned the expected magic value
1692    */
1693   function _checkOnERC721Received(
1694     address from,
1695     address to,
1696     uint256 tokenId,
1697     bytes memory _data
1698   ) private returns (bool) {
1699     if (to.isContract()) {
1700       try
1701         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1702       returns (bytes4 retval) {
1703         return retval == IERC721Receiver(to).onERC721Received.selector;
1704       } catch (bytes memory reason) {
1705         if (reason.length == 0) {
1706           revert("ERC721A: transfer to non ERC721Receiver implementer");
1707         } else {
1708           assembly {
1709             revert(add(32, reason), mload(reason))
1710           }
1711         }
1712       }
1713     } else {
1714       return true;
1715     }
1716   }
1717 
1718   /**
1719    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1720    *
1721    * startTokenId - the first token id to be transferred
1722    * quantity - the amount to be transferred
1723    *
1724    * Calling conditions:
1725    *
1726    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1727    * transferred to `to`.
1728    * - When `from` is zero, `tokenId` will be minted for `to`.
1729    */
1730   function _beforeTokenTransfers(
1731     address from,
1732     address to,
1733     uint256 startTokenId,
1734     uint256 quantity
1735   ) internal virtual {}
1736 
1737   /**
1738    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1739    * minting.
1740    *
1741    * startTokenId - the first token id to be transferred
1742    * quantity - the amount to be transferred
1743    *
1744    * Calling conditions:
1745    *
1746    * - when `from` and `to` are both non-zero.
1747    * - `from` and `to` are never both zero.
1748    */
1749   function _afterTokenTransfers(
1750     address from,
1751     address to,
1752     uint256 startTokenId,
1753     uint256 quantity
1754   ) internal virtual {}
1755 }
1756 // File: contracts/kofi.sol
1757 
1758 //SPDX-License-Identifier: MIT
1759 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1760 
1761 pragma solidity ^0.8.0;
1762 
1763 
1764 
1765 
1766 
1767 
1768 
1769 
1770 
1771 contract InterFaceDao is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1772     using Counters for Counters.Counter;
1773     using Strings for uint256;
1774 
1775     Counters.Counter private tokenCounter;
1776 
1777     string private baseURI = "ipfs://QmUnt8mBufRHDtn4QXE6AMHom29NfTUV3wyb2zWoPJ3PyT";
1778 
1779     uint256 public constant MAX_MINTS_PER_TX = 3;
1780     uint256 public maxSupply = 2022;
1781 
1782     uint256 public constant PUBLIC_SALE_PRICE = 0.00001 ether;
1783     bool public isPublicSaleActive = false;
1784 
1785 
1786 
1787 
1788     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1789 
1790     modifier publicSaleActive() {
1791         require(isPublicSaleActive, "Public sale is not open");
1792         _;
1793     }
1794 
1795 
1796 
1797     modifier maxMintsPerTX(uint256 numberOfTokens) {
1798         require(
1799             numberOfTokens <= MAX_MINTS_PER_TX,
1800             "Max mints per transaction exceeded"
1801         );
1802         _;
1803     }
1804 
1805     modifier canMintNFTs(uint256 numberOfTokens) {
1806         require(
1807             totalSupply() + numberOfTokens <=
1808                 maxSupply,
1809             "Not enough mints remaining to mint"
1810         );
1811         _;
1812     }
1813 
1814 
1815     constructor(
1816     ) ERC721A("InterFaceDao", "Int", 100, maxSupply) {
1817     }
1818 
1819 modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1820         require(
1821             (price * numberOfTokens) == msg.value,
1822             "Incorrect ETH value sent"
1823         );
1824         _;
1825     }
1826 
1827     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1828 
1829     function mint(uint256 numberOfTokens)
1830         external
1831         payable
1832         nonReentrant
1833         publicSaleActive
1834         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1835         canMintNFTs(numberOfTokens)
1836         maxMintsPerTX(numberOfTokens)
1837     {
1838 
1839         _safeMint(msg.sender, numberOfTokens);
1840     }
1841 
1842 
1843 
1844 
1845     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1846 
1847     function getBaseURI() external view returns (string memory) {
1848         return baseURI;
1849     }
1850 
1851     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1852 
1853     function setBaseURI(string memory _baseURI) external onlyOwner {
1854         baseURI = _baseURI;
1855     }
1856 
1857 
1858     function setIsPublicSaleActive(bool _isPublicSaleActive)
1859         external
1860         onlyOwner
1861     {
1862         isPublicSaleActive = _isPublicSaleActive;
1863     }
1864 
1865 
1866 
1867     function withdraw() public onlyOwner {
1868         uint256 balance = address(this).balance;
1869         payable(msg.sender).transfer(balance);
1870     }
1871 
1872     function withdrawTokens(IERC20 token) public onlyOwner {
1873         uint256 balance = token.balanceOf(address(this));
1874         token.transfer(msg.sender, balance);
1875     }
1876 
1877 
1878 
1879     // ============ SUPPORTING FUNCTIONS ============
1880 
1881     function nextTokenId() private returns (uint256) {
1882         tokenCounter.increment();
1883         return tokenCounter.current();
1884     }
1885 
1886     // ============ FUNCTION OVERRIDES ============
1887 
1888     function supportsInterface(bytes4 interfaceId)
1889         public
1890         view
1891         virtual
1892         override(ERC721A, IERC165)
1893         returns (bool)
1894     {
1895         return
1896             interfaceId == type(IERC2981).interfaceId ||
1897             super.supportsInterface(interfaceId);
1898     }
1899 
1900     /**
1901      * @dev See {IERC721Metadata-tokenURI}.
1902      */
1903     function tokenURI(uint256 tokenId)
1904         public
1905         view
1906         virtual
1907         override
1908         returns (string memory)
1909     {
1910         require(_exists(tokenId), "Nonexistent token");
1911 
1912         return
1913             baseURI;
1914     }
1915 
1916     /**
1917      * @dev See {IERC165-royaltyInfo}.
1918      */
1919     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1920         external
1921         view
1922         override
1923         returns (address receiver, uint256 royaltyAmount)
1924     {
1925         require(_exists(tokenId), "Nonexistent token");
1926 
1927         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1928     }
1929 }
1930 
1931 // These contract definitions are used to create a reference to the OpenSea
1932 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1933 contract OwnableDelegateProxy {
1934 
1935 }
1936 
1937 contract ProxyRegistry {
1938     mapping(address => OwnableDelegateProxy) public proxies;
1939 }