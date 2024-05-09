1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-09
3 */
4 
5 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 // CAUTION
13 // This version of SafeMath should only be used with Solidity 0.8 or later,
14 // because it relies on the compiler's built in overflow checks.
15 
16 /**
17  * @dev Wrappers over Solidity's arithmetic operations.
18  *
19  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
20  * now has built in overflow checking.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {
30             uint256 c = a + b;
31             if (c < a) return (false, 0);
32             return (true, c);
33         }
34     }
35 
36     /**
37      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             if (b > a) return (false, 0);
44             return (true, a - b);
45         }
46     }
47 
48     /**
49      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
50      *
51      * _Available since v3.4._
52      */
53     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         unchecked {
55             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56             // benefit is lost if 'b' is also tested.
57             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
58             if (a == 0) return (true, 0);
59             uint256 c = a * b;
60             if (c / a != b) return (false, 0);
61             return (true, c);
62         }
63     }
64 
65     /**
66      * @dev Returns the division of two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             if (b == 0) return (false, 0);
73             return (true, a / b);
74         }
75     }
76 
77     /**
78      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
79      *
80      * _Available since v3.4._
81      */
82     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
83         unchecked {
84             if (b == 0) return (false, 0);
85             return (true, a % b);
86         }
87     }
88 
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      *
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         return a + b;
101     }
102 
103     /**
104      * @dev Returns the subtraction of two unsigned integers, reverting on
105      * overflow (when the result is negative).
106      *
107      * Counterpart to Solidity's `-` operator.
108      *
109      * Requirements:
110      *
111      * - Subtraction cannot overflow.
112      */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         return a - b;
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `*` operator.
122      *
123      * Requirements:
124      *
125      * - Multiplication cannot overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a * b;
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers, reverting on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator.
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a / b;
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * reverting when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(
175         uint256 a,
176         uint256 b,
177         string memory errorMessage
178     ) internal pure returns (uint256) {
179         unchecked {
180             require(b <= a, errorMessage);
181             return a - b;
182         }
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(
198         uint256 a,
199         uint256 b,
200         string memory errorMessage
201     ) internal pure returns (uint256) {
202         unchecked {
203             require(b > 0, errorMessage);
204             return a / b;
205         }
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * reverting with custom message when dividing by zero.
211      *
212      * CAUTION: This function is deprecated because it requires allocating memory for the error
213      * message unnecessarily. For custom revert reasons use {tryMod}.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         unchecked {
229             require(b > 0, errorMessage);
230             return a % b;
231         }
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/Counters.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @title Counters
244  * @author Matt Condon (@shrugs)
245  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
246  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
247  *
248  * Include with `using Counters for Counters.Counter;`
249  */
250 library Counters {
251     struct Counter {
252         // This variable should never be directly accessed by users of the library: interactions must be restricted to
253         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
254         // this feature: see https://github.com/ethereum/solidity/issues/4637
255         uint256 _value; // default: 0
256     }
257 
258     function current(Counter storage counter) internal view returns (uint256) {
259         return counter._value;
260     }
261 
262     function increment(Counter storage counter) internal {
263         unchecked {
264             counter._value += 1;
265         }
266     }
267 
268     function decrement(Counter storage counter) internal {
269         uint256 value = counter._value;
270         require(value > 0, "Counter: decrement overflow");
271         unchecked {
272             counter._value = value - 1;
273         }
274     }
275 
276     function reset(Counter storage counter) internal {
277         counter._value = 0;
278     }
279 }
280 
281 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
282 
283 
284 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 /**
289  * @dev Contract module that helps prevent reentrant calls to a function.
290  *
291  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
292  * available, which can be applied to functions to make sure there are no nested
293  * (reentrant) calls to them.
294  *
295  * Note that because there is a single `nonReentrant` guard, functions marked as
296  * `nonReentrant` may not call one another. This can be worked around by making
297  * those functions `private`, and then adding `external` `nonReentrant` entry
298  * points to them.
299  *
300  * TIP: If you would like to learn more about reentrancy and alternative ways
301  * to protect against it, check out our blog post
302  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
303  */
304 abstract contract ReentrancyGuard {
305     // Booleans are more expensive than uint256 or any type that takes up a full
306     // word because each write operation emits an extra SLOAD to first read the
307     // slot's contents, replace the bits taken up by the boolean, and then write
308     // back. This is the compiler's defense against contract upgrades and
309     // pointer aliasing, and it cannot be disabled.
310 
311     // The values being non-zero value makes deployment a bit more expensive,
312     // but in exchange the refund on every call to nonReentrant will be lower in
313     // amount. Since refunds are capped to a percentage of the total
314     // transaction's gas, it is best to keep them low in cases like this one, to
315     // increase the likelihood of the full refund coming into effect.
316     uint256 private constant _NOT_ENTERED = 1;
317     uint256 private constant _ENTERED = 2;
318 
319     uint256 private _status;
320 
321     constructor() {
322         _status = _NOT_ENTERED;
323     }
324 
325     /**
326      * @dev Prevents a contract from calling itself, directly or indirectly.
327      * Calling a `nonReentrant` function from another `nonReentrant`
328      * function is not supported. It is possible to prevent this from happening
329      * by making the `nonReentrant` function external, and making it call a
330      * `private` function that does the actual work.
331      */
332     modifier nonReentrant() {
333         // On the first call to nonReentrant, _notEntered will be true
334         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
335 
336         // Any calls to nonReentrant after this point will fail
337         _status = _ENTERED;
338 
339         _;
340 
341         // By storing the original value once again, a refund is triggered (see
342         // https://eips.ethereum.org/EIPS/eip-2200)
343         _status = _NOT_ENTERED;
344     }
345 }
346 
347 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Interface of the ERC20 standard as defined in the EIP.
356  */
357 interface IERC20 {
358     /**
359      * @dev Returns the amount of tokens in existence.
360      */
361     function totalSupply() external view returns (uint256);
362 
363     /**
364      * @dev Returns the amount of tokens owned by `account`.
365      */
366     function balanceOf(address account) external view returns (uint256);
367 
368     /**
369      * @dev Moves `amount` tokens from the caller's account to `recipient`.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * Emits a {Transfer} event.
374      */
375     function transfer(address recipient, uint256 amount) external returns (bool);
376 
377     /**
378      * @dev Returns the remaining number of tokens that `spender` will be
379      * allowed to spend on behalf of `owner` through {transferFrom}. This is
380      * zero by default.
381      *
382      * This value changes when {approve} or {transferFrom} are called.
383      */
384     function allowance(address owner, address spender) external view returns (uint256);
385 
386     /**
387      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * IMPORTANT: Beware that changing an allowance with this method brings the risk
392      * that someone may use both the old and the new allowance by unfortunate
393      * transaction ordering. One possible solution to mitigate this race
394      * condition is to first reduce the spender's allowance to 0 and set the
395      * desired value afterwards:
396      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397      *
398      * Emits an {Approval} event.
399      */
400     function approve(address spender, uint256 amount) external returns (bool);
401 
402     /**
403      * @dev Moves `amount` tokens from `sender` to `recipient` using the
404      * allowance mechanism. `amount` is then deducted from the caller's
405      * allowance.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transferFrom(
412         address sender,
413         address recipient,
414         uint256 amount
415     ) external returns (bool);
416 
417     /**
418      * @dev Emitted when `value` tokens are moved from one account (`from`) to
419      * another (`to`).
420      *
421      * Note that `value` may be zero.
422      */
423     event Transfer(address indexed from, address indexed to, uint256 value);
424 
425     /**
426      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
427      * a call to {approve}. `value` is the new allowance.
428      */
429     event Approval(address indexed owner, address indexed spender, uint256 value);
430 }
431 
432 // File: @openzeppelin/contracts/interfaces/IERC20.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 
440 // File: @openzeppelin/contracts/utils/Strings.sol
441 
442 
443 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @dev String operations.
449  */
450 library Strings {
451     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
452 
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
455      */
456     function toString(uint256 value) internal pure returns (string memory) {
457         // Inspired by OraclizeAPI's implementation - MIT licence
458         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
459 
460         if (value == 0) {
461             return "0";
462         }
463         uint256 temp = value;
464         uint256 digits;
465         while (temp != 0) {
466             digits++;
467             temp /= 10;
468         }
469         bytes memory buffer = new bytes(digits);
470         while (value != 0) {
471             digits -= 1;
472             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
473             value /= 10;
474         }
475         return string(buffer);
476     }
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
480      */
481     function toHexString(uint256 value) internal pure returns (string memory) {
482         if (value == 0) {
483             return "0x00";
484         }
485         uint256 temp = value;
486         uint256 length = 0;
487         while (temp != 0) {
488             length++;
489             temp >>= 8;
490         }
491         return toHexString(value, length);
492     }
493 
494     /**
495      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
496      */
497     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
498         bytes memory buffer = new bytes(2 * length + 2);
499         buffer[0] = "0";
500         buffer[1] = "x";
501         for (uint256 i = 2 * length + 1; i > 1; --i) {
502             buffer[i] = _HEX_SYMBOLS[value & 0xf];
503             value >>= 4;
504         }
505         require(value == 0, "Strings: hex length insufficient");
506         return string(buffer);
507     }
508 }
509 
510 // File: @openzeppelin/contracts/utils/Context.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev Provides information about the current execution context, including the
519  * sender of the transaction and its data. While these are generally available
520  * via msg.sender and msg.data, they should not be accessed in such a direct
521  * manner, since when dealing with meta-transactions the account sending and
522  * paying for execution may not be the actual sender (as far as an application
523  * is concerned).
524  *
525  * This contract is only required for intermediate, library-like contracts.
526  */
527 abstract contract Context {
528     function _msgSender() internal view virtual returns (address) {
529         return msg.sender;
530     }
531 
532     function _msgData() internal view virtual returns (bytes calldata) {
533         return msg.data;
534     }
535 }
536 
537 // File: @openzeppelin/contracts/access/Ownable.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Contract module which provides a basic access control mechanism, where
547  * there is an account (an owner) that can be granted exclusive access to
548  * specific functions.
549  *
550  * By default, the owner account will be the one that deploys the contract. This
551  * can later be changed with {transferOwnership}.
552  *
553  * This module is used through inheritance. It will make available the modifier
554  * `onlyOwner`, which can be applied to your functions to restrict their use to
555  * the owner.
556  */
557 abstract contract Ownable is Context {
558     address private _owner;
559 
560     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
561 
562     /**
563      * @dev Initializes the contract setting the deployer as the initial owner.
564      */
565     constructor() {
566         _transferOwnership(_msgSender());
567     }
568 
569     /**
570      * @dev Returns the address of the current owner.
571      */
572     function owner() public view virtual returns (address) {
573         return _owner;
574     }
575 
576     /**
577      * @dev Throws if called by any account other than the owner.
578      */
579     modifier onlyOwner() {
580         require(owner() == _msgSender(), "Ownable: caller is not the owner");
581         _;
582     }
583 
584     /**
585      * @dev Leaves the contract without owner. It will not be possible to call
586      * `onlyOwner` functions anymore. Can only be called by the current owner.
587      *
588      * NOTE: Renouncing ownership will leave the contract without an owner,
589      * thereby removing any functionality that is only available to the owner.
590      */
591     function renounceOwnership() public virtual onlyOwner {
592         _transferOwnership(address(0));
593     }
594 
595     /**
596      * @dev Transfers ownership of the contract to a new account (`newOwner`).
597      * Can only be called by the current owner.
598      */
599     function transferOwnership(address newOwner) public virtual onlyOwner {
600         require(newOwner != address(0), "Ownable: new owner is the zero address");
601         _transferOwnership(newOwner);
602     }
603 
604     /**
605      * @dev Transfers ownership of the contract to a new account (`newOwner`).
606      * Internal function without access restriction.
607      */
608     function _transferOwnership(address newOwner) internal virtual {
609         address oldOwner = _owner;
610         _owner = newOwner;
611         emit OwnershipTransferred(oldOwner, newOwner);
612     }
613 }
614 
615 // File: @openzeppelin/contracts/utils/Address.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Collection of functions related to the address type
624  */
625 library Address {
626     /**
627      * @dev Returns true if `account` is a contract.
628      *
629      * [IMPORTANT]
630      * ====
631      * It is unsafe to assume that an address for which this function returns
632      * false is an externally-owned account (EOA) and not a contract.
633      *
634      * Among others, `isContract` will return false for the following
635      * types of addresses:
636      *
637      *  - an externally-owned account
638      *  - a contract in construction
639      *  - an address where a contract will be created
640      *  - an address where a contract lived, but was destroyed
641      * ====
642      */
643     function isContract(address account) internal view returns (bool) {
644         // This method relies on extcodesize, which returns 0 for contracts in
645         // construction, since the code is only stored at the end of the
646         // constructor execution.
647 
648         uint256 size;
649         assembly {
650             size := extcodesize(account)
651         }
652         return size > 0;
653     }
654 
655     /**
656      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
657      * `recipient`, forwarding all available gas and reverting on errors.
658      *
659      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
660      * of certain opcodes, possibly making contracts go over the 2300 gas limit
661      * imposed by `transfer`, making them unable to receive funds via
662      * `transfer`. {sendValue} removes this limitation.
663      *
664      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
665      *
666      * IMPORTANT: because control is transferred to `recipient`, care must be
667      * taken to not create reentrancy vulnerabilities. Consider using
668      * {ReentrancyGuard} or the
669      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
670      */
671     function sendValue(address payable recipient, uint256 amount) internal {
672         require(address(this).balance >= amount, "Address: insufficient balance");
673 
674         (bool success, ) = recipient.call{value: amount}("");
675         require(success, "Address: unable to send value, recipient may have reverted");
676     }
677 
678     /**
679      * @dev Performs a Solidity function call using a low level `call`. A
680      * plain `call` is an unsafe replacement for a function call: use this
681      * function instead.
682      *
683      * If `target` reverts with a revert reason, it is bubbled up by this
684      * function (like regular Solidity function calls).
685      *
686      * Returns the raw returned data. To convert to the expected return value,
687      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
688      *
689      * Requirements:
690      *
691      * - `target` must be a contract.
692      * - calling `target` with `data` must not revert.
693      *
694      * _Available since v3.1._
695      */
696     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
697         return functionCall(target, data, "Address: low-level call failed");
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
702      * `errorMessage` as a fallback revert reason when `target` reverts.
703      *
704      * _Available since v3.1._
705      */
706     function functionCall(
707         address target,
708         bytes memory data,
709         string memory errorMessage
710     ) internal returns (bytes memory) {
711         return functionCallWithValue(target, data, 0, errorMessage);
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
716      * but also transferring `value` wei to `target`.
717      *
718      * Requirements:
719      *
720      * - the calling contract must have an ETH balance of at least `value`.
721      * - the called Solidity function must be `payable`.
722      *
723      * _Available since v3.1._
724      */
725     function functionCallWithValue(
726         address target,
727         bytes memory data,
728         uint256 value
729     ) internal returns (bytes memory) {
730         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
735      * with `errorMessage` as a fallback revert reason when `target` reverts.
736      *
737      * _Available since v3.1._
738      */
739     function functionCallWithValue(
740         address target,
741         bytes memory data,
742         uint256 value,
743         string memory errorMessage
744     ) internal returns (bytes memory) {
745         require(address(this).balance >= value, "Address: insufficient balance for call");
746         require(isContract(target), "Address: call to non-contract");
747 
748         (bool success, bytes memory returndata) = target.call{value: value}(data);
749         return verifyCallResult(success, returndata, errorMessage);
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
754      * but performing a static call.
755      *
756      * _Available since v3.3._
757      */
758     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
759         return functionStaticCall(target, data, "Address: low-level static call failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
764      * but performing a static call.
765      *
766      * _Available since v3.3._
767      */
768     function functionStaticCall(
769         address target,
770         bytes memory data,
771         string memory errorMessage
772     ) internal view returns (bytes memory) {
773         require(isContract(target), "Address: static call to non-contract");
774 
775         (bool success, bytes memory returndata) = target.staticcall(data);
776         return verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a delegate call.
782      *
783      * _Available since v3.4._
784      */
785     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
786         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
791      * but performing a delegate call.
792      *
793      * _Available since v3.4._
794      */
795     function functionDelegateCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal returns (bytes memory) {
800         require(isContract(target), "Address: delegate call to non-contract");
801 
802         (bool success, bytes memory returndata) = target.delegatecall(data);
803         return verifyCallResult(success, returndata, errorMessage);
804     }
805 
806     /**
807      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
808      * revert reason using the provided one.
809      *
810      * _Available since v4.3._
811      */
812     function verifyCallResult(
813         bool success,
814         bytes memory returndata,
815         string memory errorMessage
816     ) internal pure returns (bytes memory) {
817         if (success) {
818             return returndata;
819         } else {
820             // Look for revert reason and bubble it up if present
821             if (returndata.length > 0) {
822                 // The easiest way to bubble the revert reason is using memory via assembly
823 
824                 assembly {
825                     let returndata_size := mload(returndata)
826                     revert(add(32, returndata), returndata_size)
827                 }
828             } else {
829                 revert(errorMessage);
830             }
831         }
832     }
833 }
834 
835 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
836 
837 
838 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 /**
843  * @title ERC721 token receiver interface
844  * @dev Interface for any contract that wants to support safeTransfers
845  * from ERC721 asset contracts.
846  */
847 interface IERC721Receiver {
848     /**
849      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
850      * by `operator` from `from`, this function is called.
851      *
852      * It must return its Solidity selector to confirm the token transfer.
853      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
854      *
855      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
856      */
857     function onERC721Received(
858         address operator,
859         address from,
860         uint256 tokenId,
861         bytes calldata data
862     ) external returns (bytes4);
863 }
864 
865 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
866 
867 
868 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 /**
873  * @dev Interface of the ERC165 standard, as defined in the
874  * https://eips.ethereum.org/EIPS/eip-165[EIP].
875  *
876  * Implementers can declare support of contract interfaces, which can then be
877  * queried by others ({ERC165Checker}).
878  *
879  * For an implementation, see {ERC165}.
880  */
881 interface IERC165 {
882     /**
883      * @dev Returns true if this contract implements the interface defined by
884      * `interfaceId`. See the corresponding
885      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
886      * to learn more about how these ids are created.
887      *
888      * This function call must use less than 30 000 gas.
889      */
890     function supportsInterface(bytes4 interfaceId) external view returns (bool);
891 }
892 
893 // File: @openzeppelin/contracts/interfaces/IERC165.sol
894 
895 
896 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
897 
898 pragma solidity ^0.8.0;
899 
900 
901 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
902 
903 
904 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
905 
906 pragma solidity ^0.8.0;
907 
908 
909 /**
910  * @dev Interface for the NFT Royalty Standard
911  */
912 interface IERC2981 is IERC165 {
913     /**
914      * @dev Called with the sale price to determine how much royalty is owed and to whom.
915      * @param tokenId - the NFT asset queried for royalty information
916      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
917      * @return receiver - address of who should be sent the royalty payment
918      * @return royaltyAmount - the royalty payment amount for `salePrice`
919      */
920     function royaltyInfo(uint256 tokenId, uint256 salePrice)
921         external
922         view
923         returns (address receiver, uint256 royaltyAmount);
924 }
925 
926 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
927 
928 
929 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 
934 /**
935  * @dev Implementation of the {IERC165} interface.
936  *
937  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
938  * for the additional interface id that will be supported. For example:
939  *
940  * ```solidity
941  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
942  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
943  * }
944  * ```
945  *
946  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
947  */
948 abstract contract ERC165 is IERC165 {
949     /**
950      * @dev See {IERC165-supportsInterface}.
951      */
952     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
953         return interfaceId == type(IERC165).interfaceId;
954     }
955 }
956 
957 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 /**
966  * @dev Required interface of an ERC721 compliant contract.
967  */
968 interface IERC721 is IERC165 {
969     /**
970      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
971      */
972     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
973 
974     /**
975      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
976      */
977     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
978 
979     /**
980      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
981      */
982     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
983 
984     /**
985      * @dev Returns the number of tokens in ``owner``'s account.
986      */
987     function balanceOf(address owner) external view returns (uint256 balance);
988 
989     /**
990      * @dev Returns the owner of the `tokenId` token.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must exist.
995      */
996     function ownerOf(uint256 tokenId) external view returns (address owner);
997 
998     /**
999      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1000      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1001      *
1002      * Requirements:
1003      *
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must exist and be owned by `from`.
1007      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1008      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) external;
1017 
1018     /**
1019      * @dev Transfers `tokenId` token from `from` to `to`.
1020      *
1021      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1022      *
1023      * Requirements:
1024      *
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) external;
1037 
1038     /**
1039      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1040      * The approval is cleared when the token is transferred.
1041      *
1042      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1043      *
1044      * Requirements:
1045      *
1046      * - The caller must own the token or be an approved operator.
1047      * - `tokenId` must exist.
1048      *
1049      * Emits an {Approval} event.
1050      */
1051     function approve(address to, uint256 tokenId) external;
1052 
1053     /**
1054      * @dev Returns the account approved for `tokenId` token.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      */
1060     function getApproved(uint256 tokenId) external view returns (address operator);
1061 
1062     /**
1063      * @dev Approve or remove `operator` as an operator for the caller.
1064      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1065      *
1066      * Requirements:
1067      *
1068      * - The `operator` cannot be the caller.
1069      *
1070      * Emits an {ApprovalForAll} event.
1071      */
1072     function setApprovalForAll(address operator, bool _approved) external;
1073 
1074     /**
1075      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1076      *
1077      * See {setApprovalForAll}
1078      */
1079     function isApprovedForAll(address owner, address operator) external view returns (bool);
1080 
1081     /**
1082      * @dev Safely transfers `tokenId` token from `from` to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - `from` cannot be the zero address.
1087      * - `to` cannot be the zero address.
1088      * - `tokenId` token must exist and be owned by `from`.
1089      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1090      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function safeTransferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId,
1098         bytes calldata data
1099     ) external;
1100 }
1101 
1102 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1103 
1104 
1105 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 
1110 /**
1111  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1112  * @dev See https://eips.ethereum.org/EIPS/eip-721
1113  */
1114 interface IERC721Enumerable is IERC721 {
1115     /**
1116      * @dev Returns the total amount of tokens stored by the contract.
1117      */
1118     function totalSupply() external view returns (uint256);
1119 
1120     /**
1121      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1122      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1123      */
1124     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1125 
1126     /**
1127      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1128      * Use along with {totalSupply} to enumerate all tokens.
1129      */
1130     function tokenByIndex(uint256 index) external view returns (uint256);
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
1162 // File: contracts/ERC721A.sol
1163 
1164 
1165 
1166 pragma solidity ^0.8.0;
1167 
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
1178  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1179  *
1180  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1181  *
1182  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1183  *
1184  * Does not support burning tokens to address(0).
1185  */
1186 contract ERC721A is
1187   Context,
1188   ERC165,
1189   IERC721,
1190   IERC721Metadata,
1191   IERC721Enumerable
1192 {
1193   using Address for address;
1194   using Strings for uint256;
1195 
1196   struct TokenOwnership {
1197     address addr;
1198     uint64 startTimestamp;
1199   }
1200 
1201   struct AddressData {
1202     uint128 balance;
1203     uint128 numberMinted;
1204   }
1205 
1206   uint256 private currentIndex = 0;
1207 
1208   uint256 internal immutable collectionSize;
1209   uint256 internal immutable maxBatchSize;
1210 
1211   // Token name
1212   string private _name;
1213 
1214   // Token symbol
1215   string private _symbol;
1216 
1217   // Mapping from token ID to ownership details
1218   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1219   mapping(uint256 => TokenOwnership) private _ownerships;
1220 
1221   // Mapping owner address to address data
1222   mapping(address => AddressData) private _addressData;
1223 
1224   // Mapping from token ID to approved address
1225   mapping(uint256 => address) private _tokenApprovals;
1226 
1227   // Mapping from owner to operator approvals
1228   mapping(address => mapping(address => bool)) private _operatorApprovals;
1229 
1230   /**
1231    * @dev
1232    * `maxBatchSize` refers to how much a minter can mint at a time.
1233    * `collectionSize_` refers to how many tokens are in the collection.
1234    */
1235   constructor(
1236     string memory name_,
1237     string memory symbol_,
1238     uint256 maxBatchSize_,
1239     uint256 collectionSize_
1240   ) {
1241     require(
1242       collectionSize_ > 0,
1243       "ERC721A: collection must have a nonzero supply"
1244     );
1245     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1246     _name = name_;
1247     _symbol = symbol_;
1248     maxBatchSize = maxBatchSize_;
1249     collectionSize = collectionSize_;
1250   }
1251 
1252   /**
1253    * @dev See {IERC721Enumerable-totalSupply}.
1254    */
1255   function totalSupply() public view override returns (uint256) {
1256     return currentIndex;
1257   }
1258 
1259   /**
1260    * @dev See {IERC721Enumerable-tokenByIndex}.
1261    */
1262   function tokenByIndex(uint256 index) public view override returns (uint256) {
1263     require(index < totalSupply(), "ERC721A: global index out of bounds");
1264     return index;
1265   }
1266 
1267   /**
1268    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1269    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1270    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1271    */
1272   function tokenOfOwnerByIndex(address owner, uint256 index)
1273     public
1274     view
1275     override
1276     returns (uint256)
1277   {
1278     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1279     uint256 numMintedSoFar = totalSupply();
1280     uint256 tokenIdsIdx = 0;
1281     address currOwnershipAddr = address(0);
1282     for (uint256 i = 0; i < numMintedSoFar; i++) {
1283       TokenOwnership memory ownership = _ownerships[i];
1284       if (ownership.addr != address(0)) {
1285         currOwnershipAddr = ownership.addr;
1286       }
1287       if (currOwnershipAddr == owner) {
1288         if (tokenIdsIdx == index) {
1289           return i;
1290         }
1291         tokenIdsIdx++;
1292       }
1293     }
1294     revert("ERC721A: unable to get token of owner by index");
1295   }
1296 
1297   /**
1298    * @dev See {IERC165-supportsInterface}.
1299    */
1300   function supportsInterface(bytes4 interfaceId)
1301     public
1302     view
1303     virtual
1304     override(ERC165, IERC165)
1305     returns (bool)
1306   {
1307     return
1308       interfaceId == type(IERC721).interfaceId ||
1309       interfaceId == type(IERC721Metadata).interfaceId ||
1310       interfaceId == type(IERC721Enumerable).interfaceId ||
1311       super.supportsInterface(interfaceId);
1312   }
1313 
1314   /**
1315    * @dev See {IERC721-balanceOf}.
1316    */
1317   function balanceOf(address owner) public view override returns (uint256) {
1318     require(owner != address(0), "ERC721A: balance query for the zero address");
1319     return uint256(_addressData[owner].balance);
1320   }
1321 
1322   function _numberMinted(address owner) internal view returns (uint256) {
1323     require(
1324       owner != address(0),
1325       "ERC721A: number minted query for the zero address"
1326     );
1327     return uint256(_addressData[owner].numberMinted);
1328   }
1329 
1330   function ownershipOf(uint256 tokenId)
1331     internal
1332     view
1333     returns (TokenOwnership memory)
1334   {
1335     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1336 
1337     uint256 lowestTokenToCheck;
1338     if (tokenId >= maxBatchSize) {
1339       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1340     }
1341 
1342     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1343       TokenOwnership memory ownership = _ownerships[curr];
1344       if (ownership.addr != address(0)) {
1345         return ownership;
1346       }
1347     }
1348 
1349     revert("ERC721A: unable to determine the owner of token");
1350   }
1351 
1352   /**
1353    * @dev See {IERC721-ownerOf}.
1354    */
1355   function ownerOf(uint256 tokenId) public view override returns (address) {
1356     return ownershipOf(tokenId).addr;
1357   }
1358 
1359   /**
1360    * @dev See {IERC721Metadata-name}.
1361    */
1362   function name() public view virtual override returns (string memory) {
1363     return _name;
1364   }
1365 
1366   /**
1367    * @dev See {IERC721Metadata-symbol}.
1368    */
1369   function symbol() public view virtual override returns (string memory) {
1370     return _symbol;
1371   }
1372 
1373   /**
1374    * @dev See {IERC721Metadata-tokenURI}.
1375    */
1376   function tokenURI(uint256 tokenId)
1377     public
1378     view
1379     virtual
1380     override
1381     returns (string memory)
1382   {
1383     require(
1384       _exists(tokenId),
1385       "ERC721Metadata: URI query for nonexistent token"
1386     );
1387 
1388     string memory baseURI = _baseURI();
1389     return
1390       bytes(baseURI).length > 0
1391         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1392         : "";
1393   }
1394 
1395   /**
1396    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1397    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1398    * by default, can be overriden in child contracts.
1399    */
1400   function _baseURI() internal view virtual returns (string memory) {
1401     return "";
1402   }
1403 
1404   /**
1405    * @dev See {IERC721-approve}.
1406    */
1407   function approve(address to, uint256 tokenId) public override {
1408     address owner = ERC721A.ownerOf(tokenId);
1409     require(to != owner, "ERC721A: approval to current owner");
1410 
1411     require(
1412       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1413       "ERC721A: approve caller is not owner nor approved for all"
1414     );
1415 
1416     _approve(to, tokenId, owner);
1417   }
1418 
1419   /**
1420    * @dev See {IERC721-getApproved}.
1421    */
1422   function getApproved(uint256 tokenId) public view override returns (address) {
1423     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1424 
1425     return _tokenApprovals[tokenId];
1426   }
1427 
1428   /**
1429    * @dev See {IERC721-setApprovalForAll}.
1430    */
1431   function setApprovalForAll(address operator, bool approved) public override {
1432     require(operator != _msgSender(), "ERC721A: approve to caller");
1433 
1434     _operatorApprovals[_msgSender()][operator] = approved;
1435     emit ApprovalForAll(_msgSender(), operator, approved);
1436   }
1437 
1438   /**
1439    * @dev See {IERC721-isApprovedForAll}.
1440    */
1441   function isApprovedForAll(address owner, address operator)
1442     public
1443     view
1444     virtual
1445     override
1446     returns (bool)
1447   {
1448     return _operatorApprovals[owner][operator];
1449   }
1450 
1451   /**
1452    * @dev See {IERC721-transferFrom}.
1453    */
1454   function transferFrom(
1455     address from,
1456     address to,
1457     uint256 tokenId
1458   ) public override {
1459     _transfer(from, to, tokenId);
1460   }
1461 
1462   /**
1463    * @dev See {IERC721-safeTransferFrom}.
1464    */
1465   function safeTransferFrom(
1466     address from,
1467     address to,
1468     uint256 tokenId
1469   ) public override {
1470     safeTransferFrom(from, to, tokenId, "");
1471   }
1472 
1473   /**
1474    * @dev See {IERC721-safeTransferFrom}.
1475    */
1476   function safeTransferFrom(
1477     address from,
1478     address to,
1479     uint256 tokenId,
1480     bytes memory _data
1481   ) public override {
1482     _transfer(from, to, tokenId);
1483     require(
1484       _checkOnERC721Received(from, to, tokenId, _data),
1485       "ERC721A: transfer to non ERC721Receiver implementer"
1486     );
1487   }
1488 
1489   /**
1490    * @dev Returns whether `tokenId` exists.
1491    *
1492    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1493    *
1494    * Tokens start existing when they are minted (`_mint`),
1495    */
1496   function _exists(uint256 tokenId) internal view returns (bool) {
1497     return tokenId < currentIndex;
1498   }
1499 
1500   function _safeMint(address to, uint256 quantity) internal {
1501     _safeMint(to, quantity, "");
1502   }
1503 
1504   /**
1505    * @dev Mints `quantity` tokens and transfers them to `to`.
1506    *
1507    * Requirements:
1508    *
1509    * - there must be `quantity` tokens remaining unminted in the total collection.
1510    * - `to` cannot be the zero address.
1511    * - `quantity` cannot be larger than the max batch size.
1512    *
1513    * Emits a {Transfer} event.
1514    */
1515   function _safeMint(
1516     address to,
1517     uint256 quantity,
1518     bytes memory _data
1519   ) internal {
1520     uint256 startTokenId = currentIndex;
1521     require(to != address(0), "ERC721A: mint to the zero address");
1522     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1523     require(!_exists(startTokenId), "ERC721A: token already minted");
1524     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1525 
1526     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1527 
1528     AddressData memory addressData = _addressData[to];
1529     _addressData[to] = AddressData(
1530       addressData.balance + uint128(quantity),
1531       addressData.numberMinted + uint128(quantity)
1532     );
1533     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1534 
1535     uint256 updatedIndex = startTokenId;
1536 
1537     for (uint256 i = 0; i < quantity; i++) {
1538       emit Transfer(address(0), to, updatedIndex);
1539       require(
1540         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1541         "ERC721A: transfer to non ERC721Receiver implementer"
1542       );
1543       updatedIndex++;
1544     }
1545 
1546     currentIndex = updatedIndex;
1547     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1548   }
1549 
1550   /**
1551    * @dev Transfers `tokenId` from `from` to `to`.
1552    *
1553    * Requirements:
1554    *
1555    * - `to` cannot be the zero address.
1556    * - `tokenId` token must be owned by `from`.
1557    *
1558    * Emits a {Transfer} event.
1559    */
1560   function _transfer(
1561     address from,
1562     address to,
1563     uint256 tokenId
1564   ) private {
1565     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1566 
1567     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1568       getApproved(tokenId) == _msgSender() ||
1569       isApprovedForAll(prevOwnership.addr, _msgSender()));
1570 
1571     require(
1572       isApprovedOrOwner,
1573       "ERC721A: transfer caller is not owner nor approved"
1574     );
1575 
1576     require(
1577       prevOwnership.addr == from,
1578       "ERC721A: transfer from incorrect owner"
1579     );
1580     require(to != address(0), "ERC721A: transfer to the zero address");
1581 
1582     _beforeTokenTransfers(from, to, tokenId, 1);
1583 
1584     // Clear approvals from the previous owner
1585     _approve(address(0), tokenId, prevOwnership.addr);
1586 
1587     _addressData[from].balance -= 1;
1588     _addressData[to].balance += 1;
1589     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1590 
1591     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1592     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1593     uint256 nextTokenId = tokenId + 1;
1594     if (_ownerships[nextTokenId].addr == address(0)) {
1595       if (_exists(nextTokenId)) {
1596         _ownerships[nextTokenId] = TokenOwnership(
1597           prevOwnership.addr,
1598           prevOwnership.startTimestamp
1599         );
1600       }
1601     }
1602 
1603     emit Transfer(from, to, tokenId);
1604     _afterTokenTransfers(from, to, tokenId, 1);
1605   }
1606 
1607   /**
1608    * @dev Approve `to` to operate on `tokenId`
1609    *
1610    * Emits a {Approval} event.
1611    */
1612   function _approve(
1613     address to,
1614     uint256 tokenId,
1615     address owner
1616   ) private {
1617     _tokenApprovals[tokenId] = to;
1618     emit Approval(owner, to, tokenId);
1619   }
1620 
1621   uint256 public nextOwnerToExplicitlySet = 0;
1622 
1623   /**
1624    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1625    */
1626   function _setOwnersExplicit(uint256 quantity) internal {
1627     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1628     require(quantity > 0, "quantity must be nonzero");
1629     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1630     if (endIndex > collectionSize - 1) {
1631       endIndex = collectionSize - 1;
1632     }
1633     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1634     require(_exists(endIndex), "not enough minted yet for this cleanup");
1635     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1636       if (_ownerships[i].addr == address(0)) {
1637         TokenOwnership memory ownership = ownershipOf(i);
1638         _ownerships[i] = TokenOwnership(
1639           ownership.addr,
1640           ownership.startTimestamp
1641         );
1642       }
1643     }
1644     nextOwnerToExplicitlySet = endIndex + 1;
1645   }
1646 
1647   /**
1648    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1649    * The call is not executed if the target address is not a contract.
1650    *
1651    * @param from address representing the previous owner of the given token ID
1652    * @param to target address that will receive the tokens
1653    * @param tokenId uint256 ID of the token to be transferred
1654    * @param _data bytes optional data to send along with the call
1655    * @return bool whether the call correctly returned the expected magic value
1656    */
1657   function _checkOnERC721Received(
1658     address from,
1659     address to,
1660     uint256 tokenId,
1661     bytes memory _data
1662   ) private returns (bool) {
1663     if (to.isContract()) {
1664       try
1665         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1666       returns (bytes4 retval) {
1667         return retval == IERC721Receiver(to).onERC721Received.selector;
1668       } catch (bytes memory reason) {
1669         if (reason.length == 0) {
1670           revert("ERC721A: transfer to non ERC721Receiver implementer");
1671         } else {
1672           assembly {
1673             revert(add(32, reason), mload(reason))
1674           }
1675         }
1676       }
1677     } else {
1678       return true;
1679     }
1680   }
1681 
1682   /**
1683    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1684    *
1685    * startTokenId - the first token id to be transferred
1686    * quantity - the amount to be transferred
1687    *
1688    * Calling conditions:
1689    *
1690    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1691    * transferred to `to`.
1692    * - When `from` is zero, `tokenId` will be minted for `to`.
1693    */
1694   function _beforeTokenTransfers(
1695     address from,
1696     address to,
1697     uint256 startTokenId,
1698     uint256 quantity
1699   ) internal virtual {}
1700 
1701   /**
1702    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1703    * minting.
1704    *
1705    * startTokenId - the first token id to be transferred
1706    * quantity - the amount to be transferred
1707    *
1708    * Calling conditions:
1709    *
1710    * - when `from` and `to` are both non-zero.
1711    * - `from` and `to` are never both zero.
1712    */
1713   function _afterTokenTransfers(
1714     address from,
1715     address to,
1716     uint256 startTokenId,
1717     uint256 quantity
1718   ) internal virtual {}
1719 }
1720 
1721 //SPDX-License-Identifier: MIT
1722 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1723 
1724 pragma solidity ^0.8.0;
1725 
1726 
1727 
1728 
1729 
1730 
1731 
1732 
1733 
1734 contract BirthOfAGod is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1735     using Counters for Counters.Counter;
1736     using Strings for uint256;
1737 
1738     Counters.Counter private tokenCounter;
1739 
1740     string private baseURI = "ipfs://QmWorkcaiEVRRHu5batYKp5tU8gKTjHrGUs3b5K9wdsdqH";
1741     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1742     bool private isOpenSeaProxyActive = true;
1743 
1744     uint256 public constant MAX_MINTS_PER_TX = 1;
1745     uint256 public maxSupply = 444;
1746 
1747     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
1748     uint256 public NUM_FREE_MINTS = 111;
1749     bool public isPublicSaleActive = true;
1750 
1751 
1752 
1753 
1754     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1755 
1756     modifier publicSaleActive() {
1757         require(isPublicSaleActive, "Public sale is not open");
1758         _;
1759     }
1760 
1761 
1762 
1763     modifier maxMintsPerTX(uint256 numberOfTokens) {
1764         require(
1765             numberOfTokens <= MAX_MINTS_PER_TX,
1766             "Max mints per transaction exceeded"
1767         );
1768         _;
1769     }
1770 
1771     modifier canMintNFTs(uint256 numberOfTokens) {
1772         require(
1773             totalSupply() + numberOfTokens <=
1774                 maxSupply,
1775             "Not enough mints remaining to mint"
1776         );
1777         _;
1778     }
1779 
1780     modifier freeMintsAvailable() {
1781         require(
1782             totalSupply() <=
1783                 NUM_FREE_MINTS,
1784             "Not enough free mints remain"
1785         );
1786         _;
1787     }
1788 
1789 
1790 
1791     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1792         if(totalSupply()>NUM_FREE_MINTS){
1793         require(
1794             (price * numberOfTokens) == msg.value,
1795             "Incorrect ETH value sent"
1796         );
1797         }
1798         _;
1799     }
1800 
1801 
1802     constructor(
1803     ) ERC721A("Birth Of A God", "BOAG", 100, maxSupply) {
1804     }
1805 
1806     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1807 
1808     function mint(uint256 numberOfTokens)
1809         external
1810         payable
1811         nonReentrant
1812         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1813         publicSaleActive
1814         canMintNFTs(numberOfTokens)
1815         maxMintsPerTX(numberOfTokens)
1816     {
1817 
1818         _safeMint(msg.sender, numberOfTokens);
1819     }
1820 
1821 
1822 
1823     //A simple free mint function to avoid confusion
1824     //The normal mint function with a cost of 0 would work too
1825 
1826     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1827 
1828     function getBaseURI() external view returns (string memory) {
1829         return baseURI;
1830     }
1831 
1832     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1833 
1834     function setBaseURI(string memory _baseURI) external onlyOwner {
1835         baseURI = _baseURI;
1836     }
1837 
1838     // function to disable gasless listings for security in case
1839     // opensea ever shuts down or is compromised
1840     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1841         external
1842         onlyOwner
1843     {
1844         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1845     }
1846 
1847     function setIsPublicSaleActive(bool _isPublicSaleActive)
1848         external
1849         onlyOwner
1850     {
1851         isPublicSaleActive = _isPublicSaleActive;
1852     }
1853 
1854 
1855     function setNumFreeMints(uint256 _numfreemints)
1856         external
1857         onlyOwner
1858     {
1859         NUM_FREE_MINTS = _numfreemints;
1860     }
1861 
1862 
1863     function withdraw() public onlyOwner {
1864         uint256 balance = address(this).balance;
1865         payable(msg.sender).transfer(balance);
1866     }
1867 
1868     function withdrawTokens(IERC20 token) public onlyOwner {
1869         uint256 balance = token.balanceOf(address(this));
1870         token.transfer(msg.sender, balance);
1871     }
1872 
1873 
1874 
1875     // ============ SUPPORTING FUNCTIONS ============
1876 
1877     function nextTokenId() private returns (uint256) {
1878         tokenCounter.increment();
1879         return tokenCounter.current();
1880     }
1881 
1882     // ============ FUNCTION OVERRIDES ============
1883 
1884     function supportsInterface(bytes4 interfaceId)
1885         public
1886         view
1887         virtual
1888         override(ERC721A, IERC165)
1889         returns (bool)
1890     {
1891         return
1892             interfaceId == type(IERC2981).interfaceId ||
1893             super.supportsInterface(interfaceId);
1894     }
1895 
1896     /**
1897      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1898      */
1899     function isApprovedForAll(address owner, address operator)
1900         public
1901         view
1902         override
1903         returns (bool)
1904     {
1905         // Get a reference to OpenSea's proxy registry contract by instantiating
1906         // the contract using the already existing address.
1907         ProxyRegistry proxyRegistry = ProxyRegistry(
1908             openSeaProxyRegistryAddress
1909         );
1910         if (
1911             isOpenSeaProxyActive &&
1912             address(proxyRegistry.proxies(owner)) == operator
1913         ) {
1914             return true;
1915         }
1916 
1917         return super.isApprovedForAll(owner, operator);
1918     }
1919 
1920     /**
1921      * @dev See {IERC721Metadata-tokenURI}.
1922      */
1923     function tokenURI(uint256 tokenId)
1924         public
1925         view
1926         virtual
1927         override
1928         returns (string memory)
1929     {
1930         require(_exists(tokenId), "Nonexistent token");
1931 
1932         return
1933             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1934     }
1935 
1936     /**
1937      * @dev See {IERC165-royaltyInfo}.
1938      */
1939     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1940         external
1941         view
1942         override
1943         returns (address receiver, uint256 royaltyAmount)
1944     {
1945         require(_exists(tokenId), "Nonexistent token");
1946 
1947         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1948     }
1949 }
1950 
1951 // These contract definitions are used to create a reference to the OpenSea
1952 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1953 contract OwnableDelegateProxy {
1954 
1955 }
1956 
1957 contract ProxyRegistry {
1958     mapping(address => OwnableDelegateProxy) public proxies;
1959 }