1 // File: contracts/Abstract.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-02-23
5 */
6 
7 /**
8  *Submitted for verification at Etherscan.io on 2022-02-14
9 */
10 
11 // File: contracts/Abstract.sol
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-01-18
15 */
16 
17 // File: contracts/Abstract.sol
18 
19 /**
20  *Submitted for verification at Etherscan.io on 2022-01-18
21 */
22 
23 /**
24  *Submitted for verification at Etherscan.io on 2022-01-18
25 */
26 
27 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
28 
29 
30 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 // CAUTION
35 // This version of SafeMath should only be used with Solidity 0.8 or later,
36 // because it relies on the compiler's built in overflow checks.
37 
38 /**
39  * @dev Wrappers over Solidity's arithmetic operations.
40  *
41  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
42  * now has built in overflow checking.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             uint256 c = a + b;
53             if (c < a) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
60      *
61      * _Available since v3.4._
62      */
63     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b > a) return (false, 0);
66             return (true, a - b);
67         }
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78             // benefit is lost if 'b' is also tested.
79             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80             if (a == 0) return (true, 0);
81             uint256 c = a * b;
82             if (c / a != b) return (false, 0);
83             return (true, c);
84         }
85     }
86 
87     /**
88      * @dev Returns the division of two unsigned integers, with a division by zero flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             if (b == 0) return (false, 0);
95             return (true, a / b);
96         }
97     }
98 
99     /**
100      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
101      *
102      * _Available since v3.4._
103      */
104     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             if (b == 0) return (false, 0);
107             return (true, a % b);
108         }
109     }
110 
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      *
119      * - Addition cannot overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a + b;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a - b;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      *
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a * b;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers, reverting on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator.
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function div(uint256 a, uint256 b) internal pure returns (uint256) {
164         return a / b;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * reverting when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a % b;
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
185      * overflow (when the result is negative).
186      *
187      * CAUTION: This function is deprecated because it requires allocating memory for the error
188      * message unnecessarily. For custom revert reasons use {trySub}.
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         unchecked {
202             require(b <= a, errorMessage);
203             return a - b;
204         }
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a / b;
227         }
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * reverting with custom message when dividing by zero.
233      *
234      * CAUTION: This function is deprecated because it requires allocating memory for the error
235      * message unnecessarily. For custom revert reasons use {tryMod}.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(
246         uint256 a,
247         uint256 b,
248         string memory errorMessage
249     ) internal pure returns (uint256) {
250         unchecked {
251             require(b > 0, errorMessage);
252             return a % b;
253         }
254     }
255 }
256 
257 // File: @openzeppelin/contracts/utils/Counters.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @title Counters
266  * @author Matt Condon (@shrugs)
267  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
268  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
269  *
270  * Include with `using Counters for Counters.Counter;`
271  */
272 library Counters {
273     struct Counter {
274         // This variable should never be directly accessed by users of the library: interactions must be restricted to
275         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
276         // this feature: see https://github.com/ethereum/solidity/issues/4637
277         uint256 _value; // default: 0
278     }
279 
280     function current(Counter storage counter) internal view returns (uint256) {
281         return counter._value;
282     }
283 
284     function increment(Counter storage counter) internal {
285         unchecked {
286             counter._value += 1;
287         }
288     }
289 
290     function decrement(Counter storage counter) internal {
291         uint256 value = counter._value;
292         require(value > 0, "Counter: decrement overflow");
293         unchecked {
294             counter._value = value - 1;
295         }
296     }
297 
298     function reset(Counter storage counter) internal {
299         counter._value = 0;
300     }
301 }
302 
303 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Contract module that helps prevent reentrant calls to a function.
312  *
313  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
314  * available, which can be applied to functions to make sure there are no nested
315  * (reentrant) calls to them.
316  *
317  * Note that because there is a single `nonReentrant` guard, functions marked as
318  * `nonReentrant` may not call one another. This can be worked around by making
319  * those functions `private`, and then adding `external` `nonReentrant` entry
320  * points to them.
321  *
322  * TIP: If you would like to learn more about reentrancy and alternative ways
323  * to protect against it, check out our blog post
324  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
325  */
326 abstract contract ReentrancyGuard {
327     // Booleans are more expensive than uint256 or any type that takes up a full
328     // word because each write operation emits an extra SLOAD to first read the
329     // slot's contents, replace the bits taken up by the boolean, and then write
330     // back. This is the compiler's defense against contract upgrades and
331     // pointer aliasing, and it cannot be disabled.
332 
333     // The values being non-zero value makes deployment a bit more expensive,
334     // but in exchange the refund on every call to nonReentrant will be lower in
335     // amount. Since refunds are capped to a percentage of the total
336     // transaction's gas, it is best to keep them low in cases like this one, to
337     // increase the likelihood of the full refund coming into effect.
338     uint256 private constant _NOT_ENTERED = 1;
339     uint256 private constant _ENTERED = 2;
340 
341     uint256 private _status;
342 
343     constructor() {
344         _status = _NOT_ENTERED;
345     }
346 
347     /**
348      * @dev Prevents a contract from calling itself, directly or indirectly.
349      * Calling a `nonReentrant` function from another `nonReentrant`
350      * function is not supported. It is possible to prevent this from happening
351      * by making the `nonReentrant` function external, and making it call a
352      * `private` function that does the actual work.
353      */
354     modifier nonReentrant() {
355         // On the first call to nonReentrant, _notEntered will be true
356         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
357 
358         // Any calls to nonReentrant after this point will fail
359         _status = _ENTERED;
360 
361         _;
362 
363         // By storing the original value once again, a refund is triggered (see
364         // https://eips.ethereum.org/EIPS/eip-2200)
365         _status = _NOT_ENTERED;
366     }
367 }
368 
369 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
370 
371 
372 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Interface of the ERC20 standard as defined in the EIP.
378  */
379 interface IERC20 {
380     /**
381      * @dev Returns the amount of tokens in existence.
382      */
383     function totalSupply() external view returns (uint256);
384 
385     /**
386      * @dev Returns the amount of tokens owned by `account`.
387      */
388     function balanceOf(address account) external view returns (uint256);
389 
390     /**
391      * @dev Moves `amount` tokens from the caller's account to `recipient`.
392      *
393      * Returns a boolean value indicating whether the operation succeeded.
394      *
395      * Emits a {Transfer} event.
396      */
397     function transfer(address recipient, uint256 amount) external returns (bool);
398 
399     /**
400      * @dev Returns the remaining number of tokens that `spender` will be
401      * allowed to spend on behalf of `owner` through {transferFrom}. This is
402      * zero by default.
403      *
404      * This value changes when {approve} or {transferFrom} are called.
405      */
406     function allowance(address owner, address spender) external view returns (uint256);
407 
408     /**
409      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
410      *
411      * Returns a boolean value indicating whether the operation succeeded.
412      *
413      * IMPORTANT: Beware that changing an allowance with this method brings the risk
414      * that someone may use both the old and the new allowance by unfortunate
415      * transaction ordering. One possible solution to mitigate this race
416      * condition is to first reduce the spender's allowance to 0 and set the
417      * desired value afterwards:
418      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
419      *
420      * Emits an {Approval} event.
421      */
422     function approve(address spender, uint256 amount) external returns (bool);
423 
424     /**
425      * @dev Moves `amount` tokens from `sender` to `recipient` using the
426      * allowance mechanism. `amount` is then deducted from the caller's
427      * allowance.
428      *
429      * Returns a boolean value indicating whether the operation succeeded.
430      *
431      * Emits a {Transfer} event.
432      */
433     function transferFrom(
434         address sender,
435         address recipient,
436         uint256 amount
437     ) external returns (bool);
438 
439     /**
440      * @dev Emitted when `value` tokens are moved from one account (`from`) to
441      * another (`to`).
442      *
443      * Note that `value` may be zero.
444      */
445     event Transfer(address indexed from, address indexed to, uint256 value);
446 
447     /**
448      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
449      * a call to {approve}. `value` is the new allowance.
450      */
451     event Approval(address indexed owner, address indexed spender, uint256 value);
452 }
453 
454 // File: @openzeppelin/contracts/interfaces/IERC20.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 // File: @openzeppelin/contracts/utils/Strings.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev String operations.
471  */
472 library Strings {
473     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
474 
475     /**
476      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
477      */
478     function toString(uint256 value) internal pure returns (string memory) {
479         // Inspired by OraclizeAPI's implementation - MIT licence
480         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
481 
482         if (value == 0) {
483             return "0";
484         }
485         uint256 temp = value;
486         uint256 digits;
487         while (temp != 0) {
488             digits++;
489             temp /= 10;
490         }
491         bytes memory buffer = new bytes(digits);
492         while (value != 0) {
493             digits -= 1;
494             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
495             value /= 10;
496         }
497         return string(buffer);
498     }
499 
500     /**
501      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
502      */
503     function toHexString(uint256 value) internal pure returns (string memory) {
504         if (value == 0) {
505             return "0x00";
506         }
507         uint256 temp = value;
508         uint256 length = 0;
509         while (temp != 0) {
510             length++;
511             temp >>= 8;
512         }
513         return toHexString(value, length);
514     }
515 
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
518      */
519     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
520         bytes memory buffer = new bytes(2 * length + 2);
521         buffer[0] = "0";
522         buffer[1] = "x";
523         for (uint256 i = 2 * length + 1; i > 1; --i) {
524             buffer[i] = _HEX_SYMBOLS[value & 0xf];
525             value >>= 4;
526         }
527         require(value == 0, "Strings: hex length insufficient");
528         return string(buffer);
529     }
530 }
531 
532 // File: @openzeppelin/contracts/utils/Context.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev Provides information about the current execution context, including the
541  * sender of the transaction and its data. While these are generally available
542  * via msg.sender and msg.data, they should not be accessed in such a direct
543  * manner, since when dealing with meta-transactions the account sending and
544  * paying for execution may not be the actual sender (as far as an application
545  * is concerned).
546  *
547  * This contract is only required for intermediate, library-like contracts.
548  */
549 abstract contract Context {
550     function _msgSender() internal view virtual returns (address) {
551         return msg.sender;
552     }
553 
554     function _msgData() internal view virtual returns (bytes calldata) {
555         return msg.data;
556     }
557 }
558 
559 // File: @openzeppelin/contracts/access/Ownable.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @dev Contract module which provides a basic access control mechanism, where
569  * there is an account (an owner) that can be granted exclusive access to
570  * specific functions.
571  *
572  * By default, the owner account will be the one that deploys the contract. This
573  * can later be changed with {transferOwnership}.
574  *
575  * This module is used through inheritance. It will make available the modifier
576  * `onlyOwner`, which can be applied to your functions to restrict their use to
577  * the owner.
578  */
579 abstract contract Ownable is Context {
580     address private _owner;
581 
582     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
583 
584     /**
585      * @dev Initializes the contract setting the deployer as the initial owner.
586      */
587     constructor() {
588         _transferOwnership(_msgSender());
589     }
590 
591     /**
592      * @dev Returns the address of the current owner.
593      */
594     function owner() public view virtual returns (address) {
595         return _owner;
596     }
597 
598     /**
599      * @dev Throws if called by any account other than the owner.
600      */
601     modifier onlyOwner() {
602         require(owner() == _msgSender(), "Ownable: caller is not the owner");
603         _;
604     }
605 
606     /**
607      * @dev Leaves the contract without owner. It will not be possible to call
608      * `onlyOwner` functions anymore. Can only be called by the current owner.
609      *
610      * NOTE: Renouncing ownership will leave the contract without an owner,
611      * thereby removing any functionality that is only available to the owner.
612      */
613     function renounceOwnership() public virtual onlyOwner {
614         _transferOwnership(address(0));
615     }
616 
617     /**
618      * @dev Transfers ownership of the contract to a new account (`newOwner`).
619      * Can only be called by the current owner.
620      */
621     function transferOwnership(address newOwner) public virtual onlyOwner {
622         require(newOwner != address(0), "Ownable: new owner is the zero address");
623         _transferOwnership(newOwner);
624     }
625 
626     /**
627      * @dev Transfers ownership of the contract to a new account (`newOwner`).
628      * Internal function without access restriction.
629      */
630     function _transferOwnership(address newOwner) internal virtual {
631         address oldOwner = _owner;
632         _owner = newOwner;
633         emit OwnershipTransferred(oldOwner, newOwner);
634     }
635 }
636 
637 // File: @openzeppelin/contracts/utils/Address.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev Collection of functions related to the address type
646  */
647 library Address {
648     /**
649      * @dev Returns true if `account` is a contract.
650      *
651      * [IMPORTANT]
652      * ====
653      * It is unsafe to assume that an address for which this function returns
654      * false is an externally-owned account (EOA) and not a contract.
655      *
656      * Among others, `isContract` will return false for the following
657      * types of addresses:
658      *
659      *  - an externally-owned account
660      *  - a contract in construction
661      *  - an address where a contract will be created
662      *  - an address where a contract lived, but was destroyed
663      * ====
664      */
665     function isContract(address account) internal view returns (bool) {
666         // This method relies on extcodesize, which returns 0 for contracts in
667         // construction, since the code is only stored at the end of the
668         // constructor execution.
669 
670         uint256 size;
671         assembly {
672             size := extcodesize(account)
673         }
674         return size > 0;
675     }
676 
677     /**
678      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
679      * `recipient`, forwarding all available gas and reverting on errors.
680      *
681      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
682      * of certain opcodes, possibly making contracts go over the 2300 gas limit
683      * imposed by `transfer`, making them unable to receive funds via
684      * `transfer`. {sendValue} removes this limitation.
685      *
686      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
687      *
688      * IMPORTANT: because control is transferred to `recipient`, care must be
689      * taken to not create reentrancy vulnerabilities. Consider using
690      * {ReentrancyGuard} or the
691      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
692      */
693     function sendValue(address payable recipient, uint256 amount) internal {
694         require(address(this).balance >= amount, "Address: insufficient balance");
695 
696         (bool success, ) = recipient.call{value: amount}("");
697         require(success, "Address: unable to send value, recipient may have reverted");
698     }
699 
700     /**
701      * @dev Performs a Solidity function call using a low level `call`. A
702      * plain `call` is an unsafe replacement for a function call: use this
703      * function instead.
704      *
705      * If `target` reverts with a revert reason, it is bubbled up by this
706      * function (like regular Solidity function calls).
707      *
708      * Returns the raw returned data. To convert to the expected return value,
709      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
710      *
711      * Requirements:
712      *
713      * - `target` must be a contract.
714      * - calling `target` with `data` must not revert.
715      *
716      * _Available since v3.1._
717      */
718     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
719         return functionCall(target, data, "Address: low-level call failed");
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
724      * `errorMessage` as a fallback revert reason when `target` reverts.
725      *
726      * _Available since v3.1._
727      */
728     function functionCall(
729         address target,
730         bytes memory data,
731         string memory errorMessage
732     ) internal returns (bytes memory) {
733         return functionCallWithValue(target, data, 0, errorMessage);
734     }
735 
736     /**
737      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
738      * but also transferring `value` wei to `target`.
739      *
740      * Requirements:
741      *
742      * - the calling contract must have an ETH balance of at least `value`.
743      * - the called Solidity function must be `payable`.
744      *
745      * _Available since v3.1._
746      */
747     function functionCallWithValue(
748         address target,
749         bytes memory data,
750         uint256 value
751     ) internal returns (bytes memory) {
752         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
757      * with `errorMessage` as a fallback revert reason when `target` reverts.
758      *
759      * _Available since v3.1._
760      */
761     function functionCallWithValue(
762         address target,
763         bytes memory data,
764         uint256 value,
765         string memory errorMessage
766     ) internal returns (bytes memory) {
767         require(address(this).balance >= value, "Address: insufficient balance for call");
768         require(isContract(target), "Address: call to non-contract");
769 
770         (bool success, bytes memory returndata) = target.call{value: value}(data);
771         return verifyCallResult(success, returndata, errorMessage);
772     }
773 
774     /**
775      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
776      * but performing a static call.
777      *
778      * _Available since v3.3._
779      */
780     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
781         return functionStaticCall(target, data, "Address: low-level static call failed");
782     }
783 
784     /**
785      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
786      * but performing a static call.
787      *
788      * _Available since v3.3._
789      */
790     function functionStaticCall(
791         address target,
792         bytes memory data,
793         string memory errorMessage
794     ) internal view returns (bytes memory) {
795         require(isContract(target), "Address: static call to non-contract");
796 
797         (bool success, bytes memory returndata) = target.staticcall(data);
798         return verifyCallResult(success, returndata, errorMessage);
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
803      * but performing a delegate call.
804      *
805      * _Available since v3.4._
806      */
807     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
808         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
813      * but performing a delegate call.
814      *
815      * _Available since v3.4._
816      */
817     function functionDelegateCall(
818         address target,
819         bytes memory data,
820         string memory errorMessage
821     ) internal returns (bytes memory) {
822         require(isContract(target), "Address: delegate call to non-contract");
823 
824         (bool success, bytes memory returndata) = target.delegatecall(data);
825         return verifyCallResult(success, returndata, errorMessage);
826     }
827 
828     /**
829      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
830      * revert reason using the provided one.
831      *
832      * _Available since v4.3._
833      */
834     function verifyCallResult(
835         bool success,
836         bytes memory returndata,
837         string memory errorMessage
838     ) internal pure returns (bytes memory) {
839         if (success) {
840             return returndata;
841         } else {
842             // Look for revert reason and bubble it up if present
843             if (returndata.length > 0) {
844                 // The easiest way to bubble the revert reason is using memory via assembly
845 
846                 assembly {
847                     let returndata_size := mload(returndata)
848                     revert(add(32, returndata), returndata_size)
849                 }
850             } else {
851                 revert(errorMessage);
852             }
853         }
854     }
855 }
856 
857 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
858 
859 
860 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
861 
862 pragma solidity ^0.8.0;
863 
864 /**
865  * @title ERC721 token receiver interface
866  * @dev Interface for any contract that wants to support safeTransfers
867  * from ERC721 asset contracts.
868  */
869 interface IERC721Receiver {
870     /**
871      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
872      * by `operator` from `from`, this function is called.
873      *
874      * It must return its Solidity selector to confirm the token transfer.
875      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
876      *
877      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
878      */
879     function onERC721Received(
880         address operator,
881         address from,
882         uint256 tokenId,
883         bytes calldata data
884     ) external returns (bytes4);
885 }
886 
887 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
888 
889 
890 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
891 
892 pragma solidity ^0.8.0;
893 
894 /**
895  * @dev Interface of the ERC165 standard, as defined in the
896  * https://eips.ethereum.org/EIPS/eip-165[EIP].
897  *
898  * Implementers can declare support of contract interfaces, which can then be
899  * queried by others ({ERC165Checker}).
900  *
901  * For an implementation, see {ERC165}.
902  */
903 interface IERC165 {
904     /**
905      * @dev Returns true if this contract implements the interface defined by
906      * `interfaceId`. See the corresponding
907      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
908      * to learn more about how these ids are created.
909      *
910      * This function call must use less than 30 000 gas.
911      */
912     function supportsInterface(bytes4 interfaceId) external view returns (bool);
913 }
914 
915 // File: @openzeppelin/contracts/interfaces/IERC165.sol
916 
917 
918 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 
923 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
924 
925 
926 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
927 
928 pragma solidity ^0.8.0;
929 
930 
931 /**
932  * @dev Interface for the NFT Royalty Standard
933  */
934 interface IERC2981 is IERC165 {
935     /**
936      * @dev Called with the sale price to determine how much royalty is owed and to whom.
937      * @param tokenId - the NFT asset queried for royalty information
938      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
939      * @return receiver - address of who should be sent the royalty payment
940      * @return royaltyAmount - the royalty payment amount for `salePrice`
941      */
942     function royaltyInfo(uint256 tokenId, uint256 salePrice)
943         external
944         view
945         returns (address receiver, uint256 royaltyAmount);
946 }
947 
948 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
949 
950 
951 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
952 
953 pragma solidity ^0.8.0;
954 
955 
956 /**
957  * @dev Implementation of the {IERC165} interface.
958  *
959  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
960  * for the additional interface id that will be supported. For example:
961  *
962  * ```solidity
963  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
964  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
965  * }
966  * ```
967  *
968  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
969  */
970 abstract contract ERC165 is IERC165 {
971     /**
972      * @dev See {IERC165-supportsInterface}.
973      */
974     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
975         return interfaceId == type(IERC165).interfaceId;
976     }
977 }
978 
979 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
980 
981 
982 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
983 
984 pragma solidity ^0.8.0;
985 
986 
987 /**
988  * @dev Required interface of an ERC721 compliant contract.
989  */
990 interface IERC721 is IERC165 {
991     /**
992      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
993      */
994     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
995 
996     /**
997      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
998      */
999     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1000 
1001     /**
1002      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1003      */
1004     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1005 
1006     /**
1007      * @dev Returns the number of tokens in ``owner``'s account.
1008      */
1009     function balanceOf(address owner) external view returns (uint256 balance);
1010 
1011     /**
1012      * @dev Returns the owner of the `tokenId` token.
1013      *
1014      * Requirements:
1015      *
1016      * - `tokenId` must exist.
1017      */
1018     function ownerOf(uint256 tokenId) external view returns (address owner);
1019 
1020     /**
1021      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1022      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1023      *
1024      * Requirements:
1025      *
1026      * - `from` cannot be the zero address.
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must exist and be owned by `from`.
1029      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1030      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) external;
1039 
1040     /**
1041      * @dev Transfers `tokenId` token from `from` to `to`.
1042      *
1043      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1044      *
1045      * Requirements:
1046      *
1047      * - `from` cannot be the zero address.
1048      * - `to` cannot be the zero address.
1049      * - `tokenId` token must be owned by `from`.
1050      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function transferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) external;
1059 
1060     /**
1061      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1062      * The approval is cleared when the token is transferred.
1063      *
1064      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1065      *
1066      * Requirements:
1067      *
1068      * - The caller must own the token or be an approved operator.
1069      * - `tokenId` must exist.
1070      *
1071      * Emits an {Approval} event.
1072      */
1073     function approve(address to, uint256 tokenId) external;
1074 
1075     /**
1076      * @dev Returns the account approved for `tokenId` token.
1077      *
1078      * Requirements:
1079      *
1080      * - `tokenId` must exist.
1081      */
1082     function getApproved(uint256 tokenId) external view returns (address operator);
1083 
1084     /**
1085      * @dev Approve or remove `operator` as an operator for the caller.
1086      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1087      *
1088      * Requirements:
1089      *
1090      * - The `operator` cannot be the caller.
1091      *
1092      * Emits an {ApprovalForAll} event.
1093      */
1094     function setApprovalForAll(address operator, bool _approved) external;
1095 
1096     /**
1097      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1098      *
1099      * See {setApprovalForAll}
1100      */
1101     function isApprovedForAll(address owner, address operator) external view returns (bool);
1102 
1103     /**
1104      * @dev Safely transfers `tokenId` token from `from` to `to`.
1105      *
1106      * Requirements:
1107      *
1108      * - `from` cannot be the zero address.
1109      * - `to` cannot be the zero address.
1110      * - `tokenId` token must exist and be owned by `from`.
1111      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1112      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function safeTransferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId,
1120         bytes calldata data
1121     ) external;
1122 }
1123 
1124 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1125 
1126 
1127 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1128 
1129 pragma solidity ^0.8.0;
1130 
1131 
1132 /**
1133  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1134  * @dev See https://eips.ethereum.org/EIPS/eip-721
1135  */
1136 interface IERC721Enumerable is IERC721 {
1137     /**
1138      * @dev Returns the total amount of tokens stored by the contract.
1139      */
1140     function totalSupply() external view returns (uint256);
1141 
1142     /**
1143      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1144      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1145      */
1146     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1147 
1148     /**
1149      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1150      * Use along with {totalSupply} to enumerate all tokens.
1151      */
1152     function tokenByIndex(uint256 index) external view returns (uint256);
1153 }
1154 
1155 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1156 
1157 
1158 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1159 
1160 pragma solidity ^0.8.0;
1161 
1162 
1163 /**
1164  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1165  * @dev See https://eips.ethereum.org/EIPS/eip-721
1166  */
1167 interface IERC721Metadata is IERC721 {
1168     /**
1169      * @dev Returns the token collection name.
1170      */
1171     function name() external view returns (string memory);
1172 
1173     /**
1174      * @dev Returns the token collection symbol.
1175      */
1176     function symbol() external view returns (string memory);
1177 
1178     /**
1179      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1180      */
1181     function tokenURI(uint256 tokenId) external view returns (string memory);
1182 }
1183 
1184 // File: contracts/ERC721A.sol
1185 
1186 
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 
1191 
1192 
1193 
1194 
1195 
1196 
1197 
1198 /**
1199  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1200  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1201  *
1202  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1203  *
1204  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1205  *
1206  * Does not support burning tokens to address(0).
1207  */
1208 contract ERC721A is
1209   Context,
1210   ERC165,
1211   IERC721,
1212   IERC721Metadata,
1213   IERC721Enumerable
1214 {
1215   using Address for address;
1216   using Strings for uint256;
1217 
1218   struct TokenOwnership {
1219     address addr;
1220     uint64 startTimestamp;
1221   }
1222 
1223   struct AddressData {
1224     uint128 balance;
1225     uint128 numberMinted;
1226   }
1227 
1228   uint256 private currentIndex = 0;
1229 
1230   uint256 internal immutable collectionSize;
1231   uint256 internal immutable maxBatchSize;
1232 
1233   // Token name
1234   string private _name;
1235 
1236   // Token symbol
1237   string private _symbol;
1238 
1239   // Mapping from token ID to ownership details
1240   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1241   mapping(uint256 => TokenOwnership) private _ownerships;
1242 
1243   // Mapping owner address to address data
1244   mapping(address => AddressData) private _addressData;
1245 
1246   // Mapping from token ID to approved address
1247   mapping(uint256 => address) private _tokenApprovals;
1248 
1249   // Mapping from owner to operator approvals
1250   mapping(address => mapping(address => bool)) private _operatorApprovals;
1251 
1252   /**
1253    * @dev
1254    * `maxBatchSize` refers to how much a minter can mint at a time.
1255    * `collectionSize_` refers to how many tokens are in the collection.
1256    */
1257   constructor(
1258     string memory name_,
1259     string memory symbol_,
1260     uint256 maxBatchSize_,
1261     uint256 collectionSize_
1262   ) {
1263     require(
1264       collectionSize_ > 0,
1265       "ERC721A: collection must have a nonzero supply"
1266     );
1267     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1268     _name = name_;
1269     _symbol = symbol_;
1270     maxBatchSize = maxBatchSize_;
1271     collectionSize = collectionSize_;
1272   }
1273 
1274   /**
1275    * @dev See {IERC721Enumerable-totalSupply}.
1276    */
1277   function totalSupply() public view override returns (uint256) {
1278     return currentIndex;
1279   }
1280 
1281   /**
1282    * @dev See {IERC721Enumerable-tokenByIndex}.
1283    */
1284   function tokenByIndex(uint256 index) public view override returns (uint256) {
1285     require(index < totalSupply(), "ERC721A: global index out of bounds");
1286     return index;
1287   }
1288 
1289   /**
1290    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1291    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1292    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1293    */
1294   function tokenOfOwnerByIndex(address owner, uint256 index)
1295     public
1296     view
1297     override
1298     returns (uint256)
1299   {
1300     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1301     uint256 numMintedSoFar = totalSupply();
1302     uint256 tokenIdsIdx = 0;
1303     address currOwnershipAddr = address(0);
1304     for (uint256 i = 0; i < numMintedSoFar; i++) {
1305       TokenOwnership memory ownership = _ownerships[i];
1306       if (ownership.addr != address(0)) {
1307         currOwnershipAddr = ownership.addr;
1308       }
1309       if (currOwnershipAddr == owner) {
1310         if (tokenIdsIdx == index) {
1311           return i;
1312         }
1313         tokenIdsIdx++;
1314       }
1315     }
1316     revert("ERC721A: unable to get token of owner by index");
1317   }
1318 
1319   /**
1320    * @dev See {IERC165-supportsInterface}.
1321    */
1322   function supportsInterface(bytes4 interfaceId)
1323     public
1324     view
1325     virtual
1326     override(ERC165, IERC165)
1327     returns (bool)
1328   {
1329     return
1330       interfaceId == type(IERC721).interfaceId ||
1331       interfaceId == type(IERC721Metadata).interfaceId ||
1332       interfaceId == type(IERC721Enumerable).interfaceId ||
1333       super.supportsInterface(interfaceId);
1334   }
1335 
1336   /**
1337    * @dev See {IERC721-balanceOf}.
1338    */
1339   function balanceOf(address owner) public view override returns (uint256) {
1340     require(owner != address(0), "ERC721A: balance query for the zero address");
1341     return uint256(_addressData[owner].balance);
1342   }
1343 
1344   function _numberMinted(address owner) internal view returns (uint256) {
1345     require(
1346       owner != address(0),
1347       "ERC721A: number minted query for the zero address"
1348     );
1349     return uint256(_addressData[owner].numberMinted);
1350   }
1351 
1352   function ownershipOf(uint256 tokenId)
1353     internal
1354     view
1355     returns (TokenOwnership memory)
1356   {
1357     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1358 
1359     uint256 lowestTokenToCheck;
1360     if (tokenId >= maxBatchSize) {
1361       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1362     }
1363 
1364     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1365       TokenOwnership memory ownership = _ownerships[curr];
1366       if (ownership.addr != address(0)) {
1367         return ownership;
1368       }
1369     }
1370 
1371     revert("ERC721A: unable to determine the owner of token");
1372   }
1373 
1374   /**
1375    * @dev See {IERC721-ownerOf}.
1376    */
1377   function ownerOf(uint256 tokenId) public view override returns (address) {
1378     return ownershipOf(tokenId).addr;
1379   }
1380 
1381   /**
1382    * @dev See {IERC721Metadata-name}.
1383    */
1384   function name() public view virtual override returns (string memory) {
1385     return _name;
1386   }
1387 
1388   /**
1389    * @dev See {IERC721Metadata-symbol}.
1390    */
1391   function symbol() public view virtual override returns (string memory) {
1392     return _symbol;
1393   }
1394 
1395   /**
1396    * @dev See {IERC721Metadata-tokenURI}.
1397    */
1398   function tokenURI(uint256 tokenId)
1399     public
1400     view
1401     virtual
1402     override
1403     returns (string memory)
1404   {
1405     require(
1406       _exists(tokenId),
1407       "ERC721Metadata: URI query for nonexistent token"
1408     );
1409 
1410     string memory baseURI = _baseURI();
1411     return
1412       bytes(baseURI).length > 0
1413         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1414         : "";
1415   }
1416 
1417   /**
1418    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1419    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1420    * by default, can be overriden in child contracts.
1421    */
1422   function _baseURI() internal view virtual returns (string memory) {
1423     return "";
1424   }
1425 
1426   /**
1427    * @dev See {IERC721-approve}.
1428    */
1429   function approve(address to, uint256 tokenId) public override {
1430     address owner = ERC721A.ownerOf(tokenId);
1431     require(to != owner, "ERC721A: approval to current owner");
1432 
1433     require(
1434       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1435       "ERC721A: approve caller is not owner nor approved for all"
1436     );
1437 
1438     _approve(to, tokenId, owner);
1439   }
1440 
1441   /**
1442    * @dev See {IERC721-getApproved}.
1443    */
1444   function getApproved(uint256 tokenId) public view override returns (address) {
1445     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1446 
1447     return _tokenApprovals[tokenId];
1448   }
1449 
1450   /**
1451    * @dev See {IERC721-setApprovalForAll}.
1452    */
1453   function setApprovalForAll(address operator, bool approved) public override {
1454     require(operator != _msgSender(), "ERC721A: approve to caller");
1455 
1456     _operatorApprovals[_msgSender()][operator] = approved;
1457     emit ApprovalForAll(_msgSender(), operator, approved);
1458   }
1459 
1460   /**
1461    * @dev See {IERC721-isApprovedForAll}.
1462    */
1463   function isApprovedForAll(address owner, address operator)
1464     public
1465     view
1466     virtual
1467     override
1468     returns (bool)
1469   {
1470     return _operatorApprovals[owner][operator];
1471   }
1472 
1473   /**
1474    * @dev See {IERC721-transferFrom}.
1475    */
1476   function transferFrom(
1477     address from,
1478     address to,
1479     uint256 tokenId
1480   ) public override {
1481     _transfer(from, to, tokenId);
1482   }
1483 
1484   /**
1485    * @dev See {IERC721-safeTransferFrom}.
1486    */
1487   function safeTransferFrom(
1488     address from,
1489     address to,
1490     uint256 tokenId
1491   ) public override {
1492     safeTransferFrom(from, to, tokenId, "");
1493   }
1494 
1495   /**
1496    * @dev See {IERC721-safeTransferFrom}.
1497    */
1498   function safeTransferFrom(
1499     address from,
1500     address to,
1501     uint256 tokenId,
1502     bytes memory _data
1503   ) public override {
1504     _transfer(from, to, tokenId);
1505     require(
1506       _checkOnERC721Received(from, to, tokenId, _data),
1507       "ERC721A: transfer to non ERC721Receiver implementer"
1508     );
1509   }
1510 
1511   /**
1512    * @dev Returns whether `tokenId` exists.
1513    *
1514    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1515    *
1516    * Tokens start existing when they are minted (`_mint`),
1517    */
1518   function _exists(uint256 tokenId) internal view returns (bool) {
1519     return tokenId < currentIndex;
1520   }
1521 
1522   function _safeMint(address to, uint256 quantity) internal {
1523     _safeMint(to, quantity, "");
1524   }
1525 
1526   /**
1527    * @dev Mints `quantity` tokens and transfers them to `to`.
1528    *
1529    * Requirements:
1530    *
1531    * - there must be `quantity` tokens remaining unminted in the total collection.
1532    * - `to` cannot be the zero address.
1533    * - `quantity` cannot be larger than the max batch size.
1534    *
1535    * Emits a {Transfer} event.
1536    */
1537   function _safeMint(
1538     address to,
1539     uint256 quantity,
1540     bytes memory _data
1541   ) internal {
1542     uint256 startTokenId = currentIndex;
1543     require(to != address(0), "ERC721A: mint to the zero address");
1544     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1545     require(!_exists(startTokenId), "ERC721A: token already minted");
1546     // require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1547 
1548     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1549 
1550     AddressData memory addressData = _addressData[to];
1551     _addressData[to] = AddressData(
1552       addressData.balance + uint128(quantity),
1553       addressData.numberMinted + uint128(quantity)
1554     );
1555     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1556 
1557     uint256 updatedIndex = startTokenId;
1558 
1559     for (uint256 i = 0; i < quantity; i++) {
1560       emit Transfer(address(0), to, updatedIndex);
1561       require(
1562         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1563         "ERC721A: transfer to non ERC721Receiver implementer"
1564       );
1565       updatedIndex++;
1566     }
1567 
1568     currentIndex = updatedIndex;
1569     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1570   }
1571 
1572   /**
1573    * @dev Transfers `tokenId` from `from` to `to`.
1574    *
1575    * Requirements:
1576    *
1577    * - `to` cannot be the zero address.
1578    * - `tokenId` token must be owned by `from`.
1579    *
1580    * Emits a {Transfer} event.
1581    */
1582   function _transfer(
1583     address from,
1584     address to,
1585     uint256 tokenId
1586   ) private {
1587     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1588 
1589     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1590       getApproved(tokenId) == _msgSender() ||
1591       isApprovedForAll(prevOwnership.addr, _msgSender()));
1592 
1593     require(
1594       isApprovedOrOwner,
1595       "ERC721A: transfer caller is not owner nor approved"
1596     );
1597 
1598     require(
1599       prevOwnership.addr == from,
1600       "ERC721A: transfer from incorrect owner"
1601     );
1602     require(to != address(0), "ERC721A: transfer to the zero address");
1603 
1604     _beforeTokenTransfers(from, to, tokenId, 1);
1605 
1606     // Clear approvals from the previous owner
1607     _approve(address(0), tokenId, prevOwnership.addr);
1608 
1609     _addressData[from].balance -= 1;
1610     _addressData[to].balance += 1;
1611     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1612 
1613     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1614     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1615     uint256 nextTokenId = tokenId + 1;
1616     if (_ownerships[nextTokenId].addr == address(0)) {
1617       if (_exists(nextTokenId)) {
1618         _ownerships[nextTokenId] = TokenOwnership(
1619           prevOwnership.addr,
1620           prevOwnership.startTimestamp
1621         );
1622       }
1623     }
1624 
1625     emit Transfer(from, to, tokenId);
1626     _afterTokenTransfers(from, to, tokenId, 1);
1627   }
1628 
1629   /**
1630    * @dev Approve `to` to operate on `tokenId`
1631    *
1632    * Emits a {Approval} event.
1633    */
1634   function _approve(
1635     address to,
1636     uint256 tokenId,
1637     address owner
1638   ) private {
1639     _tokenApprovals[tokenId] = to;
1640     emit Approval(owner, to, tokenId);
1641   }
1642 
1643   uint256 public nextOwnerToExplicitlySet = 0;
1644 
1645   /**
1646    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1647    */
1648   function _setOwnersExplicit(uint256 quantity) internal {
1649     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1650     require(quantity > 0, "quantity must be nonzero");
1651     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1652     if (endIndex > collectionSize - 1) {
1653       endIndex = collectionSize - 1;
1654     }
1655     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1656     require(_exists(endIndex), "not enough minted yet for this cleanup");
1657     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1658       if (_ownerships[i].addr == address(0)) {
1659         TokenOwnership memory ownership = ownershipOf(i);
1660         _ownerships[i] = TokenOwnership(
1661           ownership.addr,
1662           ownership.startTimestamp
1663         );
1664       }
1665     }
1666     nextOwnerToExplicitlySet = endIndex + 1;
1667   }
1668 
1669   /**
1670    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1671    * The call is not executed if the target address is not a contract.
1672    *
1673    * @param from address representing the previous owner of the given token ID
1674    * @param to target address that will receive the tokens
1675    * @param tokenId uint256 ID of the token to be transferred
1676    * @param _data bytes optional data to send along with the call
1677    * @return bool whether the call correctly returned the expected magic value
1678    */
1679   function _checkOnERC721Received(
1680     address from,
1681     address to,
1682     uint256 tokenId,
1683     bytes memory _data
1684   ) private returns (bool) {
1685     if (to.isContract()) {
1686       try
1687         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1688       returns (bytes4 retval) {
1689         return retval == IERC721Receiver(to).onERC721Received.selector;
1690       } catch (bytes memory reason) {
1691         if (reason.length == 0) {
1692           revert("ERC721A: transfer to non ERC721Receiver implementer");
1693         } else {
1694           assembly {
1695             revert(add(32, reason), mload(reason))
1696           }
1697         }
1698       }
1699     } else {
1700       return true;
1701     }
1702   }
1703 
1704   /**
1705    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1706    *
1707    * startTokenId - the first token id to be transferred
1708    * quantity - the amount to be transferred
1709    *
1710    * Calling conditions:
1711    *
1712    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1713    * transferred to `to`.
1714    * - When `from` is zero, `tokenId` will be minted for `to`.
1715    */
1716   function _beforeTokenTransfers(
1717     address from,
1718     address to,
1719     uint256 startTokenId,
1720     uint256 quantity
1721   ) internal virtual {}
1722 
1723   /**
1724    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1725    * minting.
1726    *
1727    * startTokenId - the first token id to be transferred
1728    * quantity - the amount to be transferred
1729    *
1730    * Calling conditions:
1731    *
1732    * - when `from` and `to` are both non-zero.
1733    * - `from` and `to` are never both zero.
1734    */
1735   function _afterTokenTransfers(
1736     address from,
1737     address to,
1738     uint256 startTokenId,
1739     uint256 quantity
1740   ) internal virtual {}
1741 }
1742 // File: contracts/Abstract.sol
1743 
1744 //SPDX-License-Identifier: MIT
1745 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1746 
1747 pragma solidity ^0.8.0;
1748 
1749 
1750 
1751 
1752 
1753 
1754 
1755 
1756 
1757 contract Abstract is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1758     using Counters for Counters.Counter;
1759     using Strings for uint256;
1760 
1761     Counters.Counter private tokenCounter;
1762 
1763     string private baseURI = "ipfs://Qmdu2kci7dFtwQwpw7To7HnL8ze1dfvUqbUcPCwLaNcWR2";
1764 
1765     uint256 public constant MAX_MINTS_PER_TX = 5;
1766     uint256 public maxSupply = 1111;
1767 
1768     uint256 public constant PUBLIC_SALE_PRICE = 0.05 ether;
1769     bool public isPublicSaleActive = false;
1770 
1771 
1772 
1773 
1774     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1775 
1776     modifier publicSaleActive() {
1777         require(isPublicSaleActive, "Public sale is not open");
1778         _;
1779     }
1780 
1781 
1782 
1783     modifier maxMintsPerTX(uint256 numberOfTokens) {
1784         require(
1785             numberOfTokens <= MAX_MINTS_PER_TX,
1786             "Max mints per transaction exceeded"
1787         );
1788         _;
1789     }
1790 
1791     modifier canMintNFTs(uint256 numberOfTokens) {
1792         require(
1793             totalSupply() + numberOfTokens <=
1794                 maxSupply,
1795             "Not enough mints remaining to mint"
1796         );
1797         _;
1798     }
1799 
1800     constructor(
1801     ) ERC721A("Abstract by Hinote", "Abstract", 100, maxSupply) {
1802     }
1803 
1804 modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1805         require(
1806             (price * numberOfTokens) == msg.value,
1807             "Incorrect ETH value sent"
1808         );
1809         _;
1810     }
1811 
1812     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1813 
1814     function mint(uint256 numberOfTokens)
1815         external
1816         payable
1817         nonReentrant
1818         publicSaleActive
1819         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1820         canMintNFTs(numberOfTokens)
1821         maxMintsPerTX(numberOfTokens)
1822     {
1823 
1824         _safeMint(msg.sender, numberOfTokens);
1825     }
1826 
1827 
1828 
1829 
1830     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1831 
1832     function getBaseURI() external view returns (string memory) {
1833         return baseURI;
1834     }
1835 
1836     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1837 
1838     function setBaseURI(string memory _baseURI) external onlyOwner {
1839         baseURI = _baseURI;
1840     }
1841 
1842 
1843     function setIsPublicSaleActive(bool _isPublicSaleActive)
1844         external
1845         onlyOwner
1846     {
1847         isPublicSaleActive = _isPublicSaleActive;
1848     }
1849 
1850 
1851 
1852     function withdraw() public onlyOwner {
1853         uint256 balance = address(this).balance;
1854         payable(msg.sender).transfer(balance);
1855     }
1856 
1857     function withdrawTokens(IERC20 token) public onlyOwner {
1858         uint256 balance = token.balanceOf(address(this));
1859         token.transfer(msg.sender, balance);
1860     }
1861 
1862 
1863 
1864     // ============ SUPPORTING FUNCTIONS ============
1865 
1866     function nextTokenId() private returns (uint256) {
1867         tokenCounter.increment();
1868         return tokenCounter.current();
1869     }
1870 
1871     // ============ FUNCTION OVERRIDES ============
1872 
1873     function supportsInterface(bytes4 interfaceId)
1874         public
1875         view
1876         virtual
1877         override(ERC721A, IERC165)
1878         returns (bool)
1879     {
1880         return
1881             interfaceId == type(IERC2981).interfaceId ||
1882             super.supportsInterface(interfaceId);
1883     }
1884 
1885     /**
1886      * @dev See {IERC721Metadata-tokenURI}.
1887      */
1888     function tokenURI(uint256 tokenId)
1889         public
1890         view
1891         virtual
1892         override
1893         returns (string memory)
1894     {
1895         require(_exists(tokenId), "Nonexistent token");
1896 
1897         return
1898             baseURI;
1899     }
1900 
1901     /**
1902      * @dev See {IERC165-royaltyInfo}.
1903      */
1904     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1905         external
1906         view
1907         override
1908         returns (address receiver, uint256 royaltyAmount)
1909     {
1910         require(_exists(tokenId), "Nonexistent token");
1911 
1912         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1913     }
1914 }
1915 
1916 // These contract definitions are used to create a reference to the OpenSea
1917 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1918 contract OwnableDelegateProxy {
1919 
1920 }
1921 
1922 contract ProxyRegistry {
1923     mapping(address => OwnableDelegateProxy) public proxies;
1924 }