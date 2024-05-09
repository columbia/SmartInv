1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-06
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
1102 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1103 
1104 
1105 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 
1110 /**
1111  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1112  * @dev See https://eips.ethereum.org/EIPS/eip-721
1113  */
1114 interface IERC721Metadata is IERC721 {
1115     /**
1116      * @dev Returns the token collection name.
1117      */
1118     function name() external view returns (string memory);
1119 
1120     /**
1121      * @dev Returns the token collection symbol.
1122      */
1123     function symbol() external view returns (string memory);
1124 
1125     /**
1126      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1127      */
1128     function tokenURI(uint256 tokenId) external view returns (string memory);
1129 }
1130 
1131 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1132 
1133 
1134 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1135 
1136 pragma solidity ^0.8.0;
1137 
1138 
1139 
1140 
1141 
1142 
1143 
1144 
1145 /**
1146  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1147  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1148  * {ERC721Enumerable}.
1149  */
1150 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1151     using Address for address;
1152     using Strings for uint256;
1153 
1154     // Token name
1155     string private _name;
1156 
1157     // Token symbol
1158     string private _symbol;
1159 
1160     // Mapping from token ID to owner address
1161     mapping(uint256 => address) private _owners;
1162 
1163     // Mapping owner address to token count
1164     mapping(address => uint256) private _balances;
1165 
1166     // Mapping from token ID to approved address
1167     mapping(uint256 => address) private _tokenApprovals;
1168 
1169     // Mapping from owner to operator approvals
1170     mapping(address => mapping(address => bool)) private _operatorApprovals;
1171 
1172     /**
1173      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1174      */
1175     constructor(string memory name_, string memory symbol_) {
1176         _name = name_;
1177         _symbol = symbol_;
1178     }
1179 
1180     /**
1181      * @dev See {IERC165-supportsInterface}.
1182      */
1183     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1184         return
1185             interfaceId == type(IERC721).interfaceId ||
1186             interfaceId == type(IERC721Metadata).interfaceId ||
1187             super.supportsInterface(interfaceId);
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-balanceOf}.
1192      */
1193     function balanceOf(address owner) public view virtual override returns (uint256) {
1194         require(owner != address(0), "ERC721: balance query for the zero address");
1195         return _balances[owner];
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-ownerOf}.
1200      */
1201     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1202         address owner = _owners[tokenId];
1203         require(owner != address(0), "ERC721: owner query for nonexistent token");
1204         return owner;
1205     }
1206 
1207     /**
1208      * @dev See {IERC721Metadata-name}.
1209      */
1210     function name() public view virtual override returns (string memory) {
1211         return _name;
1212     }
1213 
1214     /**
1215      * @dev See {IERC721Metadata-symbol}.
1216      */
1217     function symbol() public view virtual override returns (string memory) {
1218         return _symbol;
1219     }
1220 
1221     /**
1222      * @dev See {IERC721Metadata-tokenURI}.
1223      */
1224     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1225         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1226 
1227         string memory baseURI = _baseURI();
1228         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1229     }
1230 
1231     /**
1232      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1233      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1234      * by default, can be overriden in child contracts.
1235      */
1236     function _baseURI() internal view virtual returns (string memory) {
1237         return "";
1238     }
1239 
1240     /**
1241      * @dev See {IERC721-approve}.
1242      */
1243     function approve(address to, uint256 tokenId) public virtual override {
1244         address owner = ERC721.ownerOf(tokenId);
1245         require(to != owner, "ERC721: approval to current owner");
1246 
1247         require(
1248             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1249             "ERC721: approve caller is not owner nor approved for all"
1250         );
1251 
1252         _approve(to, tokenId);
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-getApproved}.
1257      */
1258     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1259         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1260 
1261         return _tokenApprovals[tokenId];
1262     }
1263 
1264     /**
1265      * @dev See {IERC721-setApprovalForAll}.
1266      */
1267     function setApprovalForAll(address operator, bool approved) public virtual override {
1268         _setApprovalForAll(_msgSender(), operator, approved);
1269     }
1270 
1271     /**
1272      * @dev See {IERC721-isApprovedForAll}.
1273      */
1274     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1275         return _operatorApprovals[owner][operator];
1276     }
1277 
1278     /**
1279      * @dev See {IERC721-transferFrom}.
1280      */
1281     function transferFrom(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) public virtual override {
1286         //solhint-disable-next-line max-line-length
1287         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1288 
1289         _transfer(from, to, tokenId);
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-safeTransferFrom}.
1294      */
1295     function safeTransferFrom(
1296         address from,
1297         address to,
1298         uint256 tokenId
1299     ) public virtual override {
1300         safeTransferFrom(from, to, tokenId, "");
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-safeTransferFrom}.
1305      */
1306     function safeTransferFrom(
1307         address from,
1308         address to,
1309         uint256 tokenId,
1310         bytes memory _data
1311     ) public virtual override {
1312         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1313         _safeTransfer(from, to, tokenId, _data);
1314     }
1315 
1316     /**
1317      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1318      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1319      *
1320      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1321      *
1322      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1323      * implement alternative mechanisms to perform token transfer, such as signature-based.
1324      *
1325      * Requirements:
1326      *
1327      * - `from` cannot be the zero address.
1328      * - `to` cannot be the zero address.
1329      * - `tokenId` token must exist and be owned by `from`.
1330      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function _safeTransfer(
1335         address from,
1336         address to,
1337         uint256 tokenId,
1338         bytes memory _data
1339     ) internal virtual {
1340         _transfer(from, to, tokenId);
1341         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1342     }
1343 
1344     /**
1345      * @dev Returns whether `tokenId` exists.
1346      *
1347      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1348      *
1349      * Tokens start existing when they are minted (`_mint`),
1350      * and stop existing when they are burned (`_burn`).
1351      */
1352     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1353         return _owners[tokenId] != address(0);
1354     }
1355 
1356     /**
1357      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1358      *
1359      * Requirements:
1360      *
1361      * - `tokenId` must exist.
1362      */
1363     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1364         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1365         address owner = ERC721.ownerOf(tokenId);
1366         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1367     }
1368 
1369     /**
1370      * @dev Safely mints `tokenId` and transfers it to `to`.
1371      *
1372      * Requirements:
1373      *
1374      * - `tokenId` must not exist.
1375      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1376      *
1377      * Emits a {Transfer} event.
1378      */
1379     function _safeMint(address to, uint256 tokenId) internal virtual {
1380         _safeMint(to, tokenId, "");
1381     }
1382 
1383     /**
1384      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1385      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1386      */
1387     function _safeMint(
1388         address to,
1389         uint256 tokenId,
1390         bytes memory _data
1391     ) internal virtual {
1392         _mint(to, tokenId);
1393         require(
1394             _checkOnERC721Received(address(0), to, tokenId, _data),
1395             "ERC721: transfer to non ERC721Receiver implementer"
1396         );
1397     }
1398 
1399     /**
1400      * @dev Mints `tokenId` and transfers it to `to`.
1401      *
1402      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1403      *
1404      * Requirements:
1405      *
1406      * - `tokenId` must not exist.
1407      * - `to` cannot be the zero address.
1408      *
1409      * Emits a {Transfer} event.
1410      */
1411     function _mint(address to, uint256 tokenId) internal virtual {
1412         require(to != address(0), "ERC721: mint to the zero address");
1413         require(!_exists(tokenId), "ERC721: token already minted");
1414 
1415         _beforeTokenTransfer(address(0), to, tokenId);
1416 
1417         _balances[to] += 1;
1418         _owners[tokenId] = to;
1419 
1420         emit Transfer(address(0), to, tokenId);
1421     }
1422 
1423     /**
1424      * @dev Destroys `tokenId`.
1425      * The approval is cleared when the token is burned.
1426      *
1427      * Requirements:
1428      *
1429      * - `tokenId` must exist.
1430      *
1431      * Emits a {Transfer} event.
1432      */
1433     function _burn(uint256 tokenId) internal virtual {
1434         address owner = ERC721.ownerOf(tokenId);
1435 
1436         _beforeTokenTransfer(owner, address(0), tokenId);
1437 
1438         // Clear approvals
1439         _approve(address(0), tokenId);
1440 
1441         _balances[owner] -= 1;
1442         delete _owners[tokenId];
1443 
1444         emit Transfer(owner, address(0), tokenId);
1445     }
1446 
1447     /**
1448      * @dev Transfers `tokenId` from `from` to `to`.
1449      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1450      *
1451      * Requirements:
1452      *
1453      * - `to` cannot be the zero address.
1454      * - `tokenId` token must be owned by `from`.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function _transfer(
1459         address from,
1460         address to,
1461         uint256 tokenId
1462     ) internal virtual {
1463         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1464         require(to != address(0), "ERC721: transfer to the zero address");
1465 
1466         _beforeTokenTransfer(from, to, tokenId);
1467 
1468         // Clear approvals from the previous owner
1469         _approve(address(0), tokenId);
1470 
1471         _balances[from] -= 1;
1472         _balances[to] += 1;
1473         _owners[tokenId] = to;
1474 
1475         emit Transfer(from, to, tokenId);
1476     }
1477 
1478     /**
1479      * @dev Approve `to` to operate on `tokenId`
1480      *
1481      * Emits a {Approval} event.
1482      */
1483     function _approve(address to, uint256 tokenId) internal virtual {
1484         _tokenApprovals[tokenId] = to;
1485         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1486     }
1487 
1488     /**
1489      * @dev Approve `operator` to operate on all of `owner` tokens
1490      *
1491      * Emits a {ApprovalForAll} event.
1492      */
1493     function _setApprovalForAll(
1494         address owner,
1495         address operator,
1496         bool approved
1497     ) internal virtual {
1498         require(owner != operator, "ERC721: approve to caller");
1499         _operatorApprovals[owner][operator] = approved;
1500         emit ApprovalForAll(owner, operator, approved);
1501     }
1502 
1503     /**
1504      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1505      * The call is not executed if the target address is not a contract.
1506      *
1507      * @param from address representing the previous owner of the given token ID
1508      * @param to target address that will receive the tokens
1509      * @param tokenId uint256 ID of the token to be transferred
1510      * @param _data bytes optional data to send along with the call
1511      * @return bool whether the call correctly returned the expected magic value
1512      */
1513     function _checkOnERC721Received(
1514         address from,
1515         address to,
1516         uint256 tokenId,
1517         bytes memory _data
1518     ) private returns (bool) {
1519         if (to.isContract()) {
1520             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1521                 return retval == IERC721Receiver.onERC721Received.selector;
1522             } catch (bytes memory reason) {
1523                 if (reason.length == 0) {
1524                     revert("ERC721: transfer to non ERC721Receiver implementer");
1525                 } else {
1526                     assembly {
1527                         revert(add(32, reason), mload(reason))
1528                     }
1529                 }
1530             }
1531         } else {
1532             return true;
1533         }
1534     }
1535 
1536     /**
1537      * @dev Hook that is called before any token transfer. This includes minting
1538      * and burning.
1539      *
1540      * Calling conditions:
1541      *
1542      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1543      * transferred to `to`.
1544      * - When `from` is zero, `tokenId` will be minted for `to`.
1545      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1546      * - `from` and `to` are never both zero.
1547      *
1548      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1549      */
1550     function _beforeTokenTransfer(
1551         address from,
1552         address to,
1553         uint256 tokenId
1554     ) internal virtual {}
1555 }
1556 
1557 // File: coven/Terrarians.sol
1558 
1559 //SPDX-License-Identifier: MIT
1560 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1561 
1562 pragma solidity ^0.8.0;
1563 
1564 
1565 
1566 
1567 
1568 
1569 
1570 
1571 
1572 contract TheTerrarians is ERC721, IERC2981, Ownable, ReentrancyGuard {
1573     using Counters for Counters.Counter;
1574     using Strings for uint256;
1575 
1576     Counters.Counter private tokenCounter;
1577 
1578     string private baseURI = "ipfs://QmcijA8Z19ysrSHAcuxN2JTDhfEQt4epHTRZT2QeneybNV";
1579     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1580     bool private isOpenSeaProxyActive = true;
1581 
1582     uint256 public constant MAX_MINTS_PER_TX = 15;
1583     uint256 public maxSupply = 3333;
1584 
1585     uint256 public constant PUBLIC_SALE_PRICE = 0.025 ether;
1586     uint256 public NUM_FREE_MINTS = 1000;
1587     bool public isPublicSaleActive = true;
1588 
1589 
1590 
1591 
1592     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1593 
1594     modifier publicSaleActive() {
1595         require(isPublicSaleActive, "Public sale is not open");
1596         _;
1597     }
1598 
1599 
1600 
1601     modifier maxMintsPerTX(uint256 numberOfTokens) {
1602         require(
1603             numberOfTokens <= MAX_MINTS_PER_TX,
1604             "Max mints per transaction exceeded"
1605         );
1606         _;
1607     }
1608 
1609     modifier canMintNFTs(uint256 numberOfTokens) {
1610         require(
1611             tokenCounter.current() + numberOfTokens <=
1612                 maxSupply,
1613             "Not enough mints remaining to mint"
1614         );
1615         _;
1616     }
1617 
1618 
1619 
1620     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1621         if(tokenCounter.current()>NUM_FREE_MINTS){
1622         require(
1623             (price * numberOfTokens) == msg.value,
1624             "Incorrect ETH value sent"
1625         );
1626         }
1627         _;
1628     }
1629 
1630 
1631     constructor(
1632     ) ERC721("TheTerrarians", "TERRA") {
1633     }
1634 
1635     
1636     
1637 
1638     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1639 
1640     function mint(uint256 numberOfTokens)
1641         external
1642         payable
1643         nonReentrant
1644         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1645         publicSaleActive
1646         canMintNFTs(numberOfTokens)
1647         maxMintsPerTX(numberOfTokens)
1648     {
1649         //require(numberOfTokens <= MAX_MINTS_PER_TX);
1650         //if(tokenCounter.current()>NUM_FREE_MINTS){
1651         //    require((PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value);
1652         //}
1653         for (uint256 i = 0; i < numberOfTokens; i++) {
1654             _safeMint(msg.sender, nextTokenId());
1655         }
1656     }
1657 
1658 
1659 
1660 
1661     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1662 
1663     function getBaseURI() external view returns (string memory) {
1664         return baseURI;
1665     }
1666 
1667     function getLastTokenId() external view returns (uint256) {
1668         return tokenCounter.current();
1669     }
1670 
1671     function totalSupply() external view returns (uint256) {
1672         return tokenCounter.current();
1673     }
1674 
1675     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1676 
1677     function setBaseURI(string memory _baseURI) external onlyOwner {
1678         baseURI = _baseURI;
1679     }
1680 
1681     // function to disable gasless listings for security in case
1682     // opensea ever shuts down or is compromised
1683     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1684         external
1685         onlyOwner
1686     {
1687         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1688     }
1689 
1690     function setIsPublicSaleActive(bool _isPublicSaleActive)
1691         external
1692         onlyOwner
1693     {
1694         isPublicSaleActive = _isPublicSaleActive;
1695     }
1696 
1697     function setNumFreeMints(uint256 _numfreemints)
1698         external
1699         onlyOwner
1700     {
1701         NUM_FREE_MINTS = _numfreemints;
1702     }
1703 
1704 
1705     function withdraw() public onlyOwner {
1706         uint256 balance = address(this).balance;
1707         payable(msg.sender).transfer(balance);
1708     }
1709 
1710     function withdrawTokens(IERC20 token) public onlyOwner {
1711         uint256 balance = token.balanceOf(address(this));
1712         token.transfer(msg.sender, balance);
1713     }
1714 
1715 
1716 
1717     // ============ SUPPORTING FUNCTIONS ============
1718 
1719     function nextTokenId() private returns (uint256) {
1720         tokenCounter.increment();
1721         return tokenCounter.current();
1722     }
1723 
1724     // ============ FUNCTION OVERRIDES ============
1725 
1726     function supportsInterface(bytes4 interfaceId)
1727         public
1728         view
1729         virtual
1730         override(ERC721, IERC165)
1731         returns (bool)
1732     {
1733         return
1734             interfaceId == type(IERC2981).interfaceId ||
1735             super.supportsInterface(interfaceId);
1736     }
1737 
1738     /**
1739      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1740      */
1741     function isApprovedForAll(address owner, address operator)
1742         public
1743         view
1744         override
1745         returns (bool)
1746     {
1747         // Get a reference to OpenSea's proxy registry contract by instantiating
1748         // the contract using the already existing address.
1749         ProxyRegistry proxyRegistry = ProxyRegistry(
1750             openSeaProxyRegistryAddress
1751         );
1752         if (
1753             isOpenSeaProxyActive &&
1754             address(proxyRegistry.proxies(owner)) == operator
1755         ) {
1756             return true;
1757         }
1758 
1759         return super.isApprovedForAll(owner, operator);
1760     }
1761 
1762     /**
1763      * @dev See {IERC721Metadata-tokenURI}.
1764      */
1765     function tokenURI(uint256 tokenId)
1766         public
1767         view
1768         virtual
1769         override
1770         returns (string memory)
1771     {
1772         require(_exists(tokenId), "Nonexistent token");
1773 
1774         return
1775             string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
1776     }
1777 
1778     /**
1779      * @dev See {IERC165-royaltyInfo}.
1780      */
1781     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1782         external
1783         view
1784         override
1785         returns (address receiver, uint256 royaltyAmount)
1786     {
1787         require(_exists(tokenId), "Nonexistent token");
1788 
1789         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1790     }
1791 }
1792 
1793 // These contract definitions are used to create a reference to the OpenSea
1794 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1795 contract OwnableDelegateProxy {
1796 
1797 }
1798 
1799 contract ProxyRegistry {
1800     mapping(address => OwnableDelegateProxy) public proxies;
1801 }