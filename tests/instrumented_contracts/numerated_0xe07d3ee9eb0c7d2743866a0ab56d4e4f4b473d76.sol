1 // File: contracts/ReeferMadness.sol
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/utils/Counters.sol
231 
232 
233 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @title Counters
239  * @author Matt Condon (@shrugs)
240  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
241  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
242  *
243  * Include with `using Counters for Counters.Counter;`
244  */
245 library Counters {
246     struct Counter {
247         // This variable should never be directly accessed by users of the library: interactions must be restricted to
248         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
249         // this feature: see https://github.com/ethereum/solidity/issues/4637
250         uint256 _value; // default: 0
251     }
252 
253     function current(Counter storage counter) internal view returns (uint256) {
254         return counter._value;
255     }
256 
257     function increment(Counter storage counter) internal {
258         unchecked {
259             counter._value += 1;
260         }
261     }
262 
263     function decrement(Counter storage counter) internal {
264         uint256 value = counter._value;
265         require(value > 0, "Counter: decrement overflow");
266         unchecked {
267             counter._value = value - 1;
268         }
269     }
270 
271     function reset(Counter storage counter) internal {
272         counter._value = 0;
273     }
274 }
275 
276 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
277 
278 
279 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev Contract module that helps prevent reentrant calls to a function.
285  *
286  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
287  * available, which can be applied to functions to make sure there are no nested
288  * (reentrant) calls to them.
289  *
290  * Note that because there is a single `nonReentrant` guard, functions marked as
291  * `nonReentrant` may not call one another. This can be worked around by making
292  * those functions `private`, and then adding `external` `nonReentrant` entry
293  * points to them.
294  *
295  * TIP: If you would like to learn more about reentrancy and alternative ways
296  * to protect against it, check out our blog post
297  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
298  */
299 abstract contract ReentrancyGuard {
300     // Booleans are more expensive than uint256 or any type that takes up a full
301     // word because each write operation emits an extra SLOAD to first read the
302     // slot's contents, replace the bits taken up by the boolean, and then write
303     // back. This is the compiler's defense against contract upgrades and
304     // pointer aliasing, and it cannot be disabled.
305 
306     // The values being non-zero value makes deployment a bit more expensive,
307     // but in exchange the refund on every call to nonReentrant will be lower in
308     // amount. Since refunds are capped to a percentage of the total
309     // transaction's gas, it is best to keep them low in cases like this one, to
310     // increase the likelihood of the full refund coming into effect.
311     uint256 private constant _NOT_ENTERED = 1;
312     uint256 private constant _ENTERED = 2;
313 
314     uint256 private _status;
315 
316     constructor() {
317         _status = _NOT_ENTERED;
318     }
319 
320     /**
321      * @dev Prevents a contract from calling itself, directly or indirectly.
322      * Calling a `nonReentrant` function from another `nonReentrant`
323      * function is not supported. It is possible to prevent this from happening
324      * by making the `nonReentrant` function external, and making it call a
325      * `private` function that does the actual work.
326      */
327     modifier nonReentrant() {
328         // On the first call to nonReentrant, _notEntered will be true
329         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
330 
331         // Any calls to nonReentrant after this point will fail
332         _status = _ENTERED;
333 
334         _;
335 
336         // By storing the original value once again, a refund is triggered (see
337         // https://eips.ethereum.org/EIPS/eip-2200)
338         _status = _NOT_ENTERED;
339     }
340 }
341 
342 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
343 
344 
345 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
346 
347 pragma solidity ^0.8.0;
348 
349 /**
350  * @dev Interface of the ERC20 standard as defined in the EIP.
351  */
352 interface IERC20 {
353     /**
354      * @dev Returns the amount of tokens in existence.
355      */
356     function totalSupply() external view returns (uint256);
357 
358     /**
359      * @dev Returns the amount of tokens owned by `account`.
360      */
361     function balanceOf(address account) external view returns (uint256);
362 
363     /**
364      * @dev Moves `amount` tokens from the caller's account to `recipient`.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * Emits a {Transfer} event.
369      */
370     function transfer(address recipient, uint256 amount) external returns (bool);
371 
372     /**
373      * @dev Returns the remaining number of tokens that `spender` will be
374      * allowed to spend on behalf of `owner` through {transferFrom}. This is
375      * zero by default.
376      *
377      * This value changes when {approve} or {transferFrom} are called.
378      */
379     function allowance(address owner, address spender) external view returns (uint256);
380 
381     /**
382      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * IMPORTANT: Beware that changing an allowance with this method brings the risk
387      * that someone may use both the old and the new allowance by unfortunate
388      * transaction ordering. One possible solution to mitigate this race
389      * condition is to first reduce the spender's allowance to 0 and set the
390      * desired value afterwards:
391      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
392      *
393      * Emits an {Approval} event.
394      */
395     function approve(address spender, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Moves `amount` tokens from `sender` to `recipient` using the
399      * allowance mechanism. `amount` is then deducted from the caller's
400      * allowance.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transferFrom(
407         address sender,
408         address recipient,
409         uint256 amount
410     ) external returns (bool);
411 
412     /**
413      * @dev Emitted when `value` tokens are moved from one account (`from`) to
414      * another (`to`).
415      *
416      * Note that `value` may be zero.
417      */
418     event Transfer(address indexed from, address indexed to, uint256 value);
419 
420     /**
421      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
422      * a call to {approve}. `value` is the new allowance.
423      */
424     event Approval(address indexed owner, address indexed spender, uint256 value);
425 }
426 
427 // File: @openzeppelin/contracts/interfaces/IERC20.sol
428 
429 
430 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
431 
432 pragma solidity ^0.8.0;
433 
434 
435 // File: @openzeppelin/contracts/utils/Strings.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev String operations.
444  */
445 library Strings {
446     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
447 
448     /**
449      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
450      */
451     function toString(uint256 value) internal pure returns (string memory) {
452         // Inspired by OraclizeAPI's implementation - MIT licence
453         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
454 
455         if (value == 0) {
456             return "0";
457         }
458         uint256 temp = value;
459         uint256 digits;
460         while (temp != 0) {
461             digits++;
462             temp /= 10;
463         }
464         bytes memory buffer = new bytes(digits);
465         while (value != 0) {
466             digits -= 1;
467             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
468             value /= 10;
469         }
470         return string(buffer);
471     }
472 
473     /**
474      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
475      */
476     function toHexString(uint256 value) internal pure returns (string memory) {
477         if (value == 0) {
478             return "0x00";
479         }
480         uint256 temp = value;
481         uint256 length = 0;
482         while (temp != 0) {
483             length++;
484             temp >>= 8;
485         }
486         return toHexString(value, length);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
491      */
492     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
493         bytes memory buffer = new bytes(2 * length + 2);
494         buffer[0] = "0";
495         buffer[1] = "x";
496         for (uint256 i = 2 * length + 1; i > 1; --i) {
497             buffer[i] = _HEX_SYMBOLS[value & 0xf];
498             value >>= 4;
499         }
500         require(value == 0, "Strings: hex length insufficient");
501         return string(buffer);
502     }
503 }
504 
505 // File: @openzeppelin/contracts/utils/Context.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev Provides information about the current execution context, including the
514  * sender of the transaction and its data. While these are generally available
515  * via msg.sender and msg.data, they should not be accessed in such a direct
516  * manner, since when dealing with meta-transactions the account sending and
517  * paying for execution may not be the actual sender (as far as an application
518  * is concerned).
519  *
520  * This contract is only required for intermediate, library-like contracts.
521  */
522 abstract contract Context {
523     function _msgSender() internal view virtual returns (address) {
524         return msg.sender;
525     }
526 
527     function _msgData() internal view virtual returns (bytes calldata) {
528         return msg.data;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/access/Ownable.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Contract module which provides a basic access control mechanism, where
542  * there is an account (an owner) that can be granted exclusive access to
543  * specific functions.
544  *
545  * By default, the owner account will be the one that deploys the contract. This
546  * can later be changed with {transferOwnership}.
547  *
548  * This module is used through inheritance. It will make available the modifier
549  * `onlyOwner`, which can be applied to your functions to restrict their use to
550  * the owner.
551  */
552 abstract contract Ownable is Context {
553     address private _owner;
554 
555     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
556 
557     /**
558      * @dev Initializes the contract setting the deployer as the initial owner.
559      */
560     constructor() {
561         _transferOwnership(_msgSender());
562     }
563 
564     /**
565      * @dev Returns the address of the current owner.
566      */
567     function owner() public view virtual returns (address) {
568         return _owner;
569     }
570 
571     /**
572      * @dev Throws if called by any account other than the owner.
573      */
574     modifier onlyOwner() {
575         require(owner() == _msgSender(), "Ownable: caller is not the owner");
576         _;
577     }
578 
579     /**
580      * @dev Leaves the contract without owner. It will not be possible to call
581      * `onlyOwner` functions anymore. Can only be called by the current owner.
582      *
583      * NOTE: Renouncing ownership will leave the contract without an owner,
584      * thereby removing any functionality that is only available to the owner.
585      */
586     function renounceOwnership() public virtual onlyOwner {
587         _transferOwnership(address(0));
588     }
589 
590     /**
591      * @dev Transfers ownership of the contract to a new account (`newOwner`).
592      * Can only be called by the current owner.
593      */
594     function transferOwnership(address newOwner) public virtual onlyOwner {
595         require(newOwner != address(0), "Ownable: new owner is the zero address");
596         _transferOwnership(newOwner);
597     }
598 
599     /**
600      * @dev Transfers ownership of the contract to a new account (`newOwner`).
601      * Internal function without access restriction.
602      */
603     function _transferOwnership(address newOwner) internal virtual {
604         address oldOwner = _owner;
605         _owner = newOwner;
606         emit OwnershipTransferred(oldOwner, newOwner);
607     }
608 }
609 
610 // File: @openzeppelin/contracts/utils/Address.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Collection of functions related to the address type
619  */
620 library Address {
621     /**
622      * @dev Returns true if `account` is a contract.
623      *
624      * [IMPORTANT]
625      * ====
626      * It is unsafe to assume that an address for which this function returns
627      * false is an externally-owned account (EOA) and not a contract.
628      *
629      * Among others, `isContract` will return false for the following
630      * types of addresses:
631      *
632      *  - an externally-owned account
633      *  - a contract in construction
634      *  - an address where a contract will be created
635      *  - an address where a contract lived, but was destroyed
636      * ====
637      */
638     function isContract(address account) internal view returns (bool) {
639         // This method relies on extcodesize, which returns 0 for contracts in
640         // construction, since the code is only stored at the end of the
641         // constructor execution.
642 
643         uint256 size;
644         assembly {
645             size := extcodesize(account)
646         }
647         return size > 0;
648     }
649 
650     /**
651      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
652      * `recipient`, forwarding all available gas and reverting on errors.
653      *
654      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
655      * of certain opcodes, possibly making contracts go over the 2300 gas limit
656      * imposed by `transfer`, making them unable to receive funds via
657      * `transfer`. {sendValue} removes this limitation.
658      *
659      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
660      *
661      * IMPORTANT: because control is transferred to `recipient`, care must be
662      * taken to not create reentrancy vulnerabilities. Consider using
663      * {ReentrancyGuard} or the
664      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
665      */
666     function sendValue(address payable recipient, uint256 amount) internal {
667         require(address(this).balance >= amount, "Address: insufficient balance");
668 
669         (bool success, ) = recipient.call{value: amount}("");
670         require(success, "Address: unable to send value, recipient may have reverted");
671     }
672 
673     /**
674      * @dev Performs a Solidity function call using a low level `call`. A
675      * plain `call` is an unsafe replacement for a function call: use this
676      * function instead.
677      *
678      * If `target` reverts with a revert reason, it is bubbled up by this
679      * function (like regular Solidity function calls).
680      *
681      * Returns the raw returned data. To convert to the expected return value,
682      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
683      *
684      * Requirements:
685      *
686      * - `target` must be a contract.
687      * - calling `target` with `data` must not revert.
688      *
689      * _Available since v3.1._
690      */
691     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
692         return functionCall(target, data, "Address: low-level call failed");
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
697      * `errorMessage` as a fallback revert reason when `target` reverts.
698      *
699      * _Available since v3.1._
700      */
701     function functionCall(
702         address target,
703         bytes memory data,
704         string memory errorMessage
705     ) internal returns (bytes memory) {
706         return functionCallWithValue(target, data, 0, errorMessage);
707     }
708 
709     /**
710      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
711      * but also transferring `value` wei to `target`.
712      *
713      * Requirements:
714      *
715      * - the calling contract must have an ETH balance of at least `value`.
716      * - the called Solidity function must be `payable`.
717      *
718      * _Available since v3.1._
719      */
720     function functionCallWithValue(
721         address target,
722         bytes memory data,
723         uint256 value
724     ) internal returns (bytes memory) {
725         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
726     }
727 
728     /**
729      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
730      * with `errorMessage` as a fallback revert reason when `target` reverts.
731      *
732      * _Available since v3.1._
733      */
734     function functionCallWithValue(
735         address target,
736         bytes memory data,
737         uint256 value,
738         string memory errorMessage
739     ) internal returns (bytes memory) {
740         require(address(this).balance >= value, "Address: insufficient balance for call");
741         require(isContract(target), "Address: call to non-contract");
742 
743         (bool success, bytes memory returndata) = target.call{value: value}(data);
744         return verifyCallResult(success, returndata, errorMessage);
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
749      * but performing a static call.
750      *
751      * _Available since v3.3._
752      */
753     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
754         return functionStaticCall(target, data, "Address: low-level static call failed");
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
759      * but performing a static call.
760      *
761      * _Available since v3.3._
762      */
763     function functionStaticCall(
764         address target,
765         bytes memory data,
766         string memory errorMessage
767     ) internal view returns (bytes memory) {
768         require(isContract(target), "Address: static call to non-contract");
769 
770         (bool success, bytes memory returndata) = target.staticcall(data);
771         return verifyCallResult(success, returndata, errorMessage);
772     }
773 
774     /**
775      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
776      * but performing a delegate call.
777      *
778      * _Available since v3.4._
779      */
780     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
781         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
782     }
783 
784     /**
785      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
786      * but performing a delegate call.
787      *
788      * _Available since v3.4._
789      */
790     function functionDelegateCall(
791         address target,
792         bytes memory data,
793         string memory errorMessage
794     ) internal returns (bytes memory) {
795         require(isContract(target), "Address: delegate call to non-contract");
796 
797         (bool success, bytes memory returndata) = target.delegatecall(data);
798         return verifyCallResult(success, returndata, errorMessage);
799     }
800 
801     /**
802      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
803      * revert reason using the provided one.
804      *
805      * _Available since v4.3._
806      */
807     function verifyCallResult(
808         bool success,
809         bytes memory returndata,
810         string memory errorMessage
811     ) internal pure returns (bytes memory) {
812         if (success) {
813             return returndata;
814         } else {
815             // Look for revert reason and bubble it up if present
816             if (returndata.length > 0) {
817                 // The easiest way to bubble the revert reason is using memory via assembly
818 
819                 assembly {
820                     let returndata_size := mload(returndata)
821                     revert(add(32, returndata), returndata_size)
822                 }
823             } else {
824                 revert(errorMessage);
825             }
826         }
827     }
828 }
829 
830 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
831 
832 
833 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
834 
835 pragma solidity ^0.8.0;
836 
837 /**
838  * @title ERC721 token receiver interface
839  * @dev Interface for any contract that wants to support safeTransfers
840  * from ERC721 asset contracts.
841  */
842 interface IERC721Receiver {
843     /**
844      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
845      * by `operator` from `from`, this function is called.
846      *
847      * It must return its Solidity selector to confirm the token transfer.
848      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
849      *
850      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
851      */
852     function onERC721Received(
853         address operator,
854         address from,
855         uint256 tokenId,
856         bytes calldata data
857     ) external returns (bytes4);
858 }
859 
860 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
861 
862 
863 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
864 
865 pragma solidity ^0.8.0;
866 
867 /**
868  * @dev Interface of the ERC165 standard, as defined in the
869  * https://eips.ethereum.org/EIPS/eip-165[EIP].
870  *
871  * Implementers can declare support of contract interfaces, which can then be
872  * queried by others ({ERC165Checker}).
873  *
874  * For an implementation, see {ERC165}.
875  */
876 interface IERC165 {
877     /**
878      * @dev Returns true if this contract implements the interface defined by
879      * `interfaceId`. See the corresponding
880      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
881      * to learn more about how these ids are created.
882      *
883      * This function call must use less than 30 000 gas.
884      */
885     function supportsInterface(bytes4 interfaceId) external view returns (bool);
886 }
887 
888 // File: @openzeppelin/contracts/interfaces/IERC165.sol
889 
890 
891 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 
896 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
897 
898 
899 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
900 
901 pragma solidity ^0.8.0;
902 
903 
904 /**
905  * @dev Interface for the NFT Royalty Standard
906  */
907 interface IERC2981 is IERC165 {
908     /**
909      * @dev Called with the sale price to determine how much royalty is owed and to whom.
910      * @param tokenId - the NFT asset queried for royalty information
911      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
912      * @return receiver - address of who should be sent the royalty payment
913      * @return royaltyAmount - the royalty payment amount for `salePrice`
914      */
915     function royaltyInfo(uint256 tokenId, uint256 salePrice)
916         external
917         view
918         returns (address receiver, uint256 royaltyAmount);
919 }
920 
921 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
922 
923 
924 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
925 
926 pragma solidity ^0.8.0;
927 
928 
929 /**
930  * @dev Implementation of the {IERC165} interface.
931  *
932  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
933  * for the additional interface id that will be supported. For example:
934  *
935  * ```solidity
936  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
937  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
938  * }
939  * ```
940  *
941  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
942  */
943 abstract contract ERC165 is IERC165 {
944     /**
945      * @dev See {IERC165-supportsInterface}.
946      */
947     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
948         return interfaceId == type(IERC165).interfaceId;
949     }
950 }
951 
952 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
953 
954 
955 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
956 
957 pragma solidity ^0.8.0;
958 
959 
960 /**
961  * @dev Required interface of an ERC721 compliant contract.
962  */
963 interface IERC721 is IERC165 {
964     /**
965      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
966      */
967     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
968 
969     /**
970      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
971      */
972     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
973 
974     /**
975      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
976      */
977     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
978 
979     /**
980      * @dev Returns the number of tokens in ``owner``'s account.
981      */
982     function balanceOf(address owner) external view returns (uint256 balance);
983 
984     /**
985      * @dev Returns the owner of the `tokenId` token.
986      *
987      * Requirements:
988      *
989      * - `tokenId` must exist.
990      */
991     function ownerOf(uint256 tokenId) external view returns (address owner);
992 
993     /**
994      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
995      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
996      *
997      * Requirements:
998      *
999      * - `from` cannot be the zero address.
1000      * - `to` cannot be the zero address.
1001      * - `tokenId` token must exist and be owned by `from`.
1002      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function safeTransferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) external;
1012 
1013     /**
1014      * @dev Transfers `tokenId` token from `from` to `to`.
1015      *
1016      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1017      *
1018      * Requirements:
1019      *
1020      * - `from` cannot be the zero address.
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must be owned by `from`.
1023      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function transferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) external;
1032 
1033     /**
1034      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1035      * The approval is cleared when the token is transferred.
1036      *
1037      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1038      *
1039      * Requirements:
1040      *
1041      * - The caller must own the token or be an approved operator.
1042      * - `tokenId` must exist.
1043      *
1044      * Emits an {Approval} event.
1045      */
1046     function approve(address to, uint256 tokenId) external;
1047 
1048     /**
1049      * @dev Returns the account approved for `tokenId` token.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      */
1055     function getApproved(uint256 tokenId) external view returns (address operator);
1056 
1057     /**
1058      * @dev Approve or remove `operator` as an operator for the caller.
1059      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1060      *
1061      * Requirements:
1062      *
1063      * - The `operator` cannot be the caller.
1064      *
1065      * Emits an {ApprovalForAll} event.
1066      */
1067     function setApprovalForAll(address operator, bool _approved) external;
1068 
1069     /**
1070      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1071      *
1072      * See {setApprovalForAll}
1073      */
1074     function isApprovedForAll(address owner, address operator) external view returns (bool);
1075 
1076     /**
1077      * @dev Safely transfers `tokenId` token from `from` to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - `from` cannot be the zero address.
1082      * - `to` cannot be the zero address.
1083      * - `tokenId` token must exist and be owned by `from`.
1084      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1085      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId,
1093         bytes calldata data
1094     ) external;
1095 }
1096 
1097 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1098 
1099 
1100 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1101 
1102 pragma solidity ^0.8.0;
1103 
1104 
1105 /**
1106  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1107  * @dev See https://eips.ethereum.org/EIPS/eip-721
1108  */
1109 interface IERC721Enumerable is IERC721 {
1110     /**
1111      * @dev Returns the total amount of tokens stored by the contract.
1112      */
1113     function totalSupply() external view returns (uint256);
1114 
1115     /**
1116      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1117      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1118      */
1119     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1120 
1121     /**
1122      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1123      * Use along with {totalSupply} to enumerate all tokens.
1124      */
1125     function tokenByIndex(uint256 index) external view returns (uint256);
1126 }
1127 
1128 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1129 
1130 
1131 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1132 
1133 pragma solidity ^0.8.0;
1134 
1135 
1136 /**
1137  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1138  * @dev See https://eips.ethereum.org/EIPS/eip-721
1139  */
1140 interface IERC721Metadata is IERC721 {
1141     /**
1142      * @dev Returns the token collection name.
1143      */
1144     function name() external view returns (string memory);
1145 
1146     /**
1147      * @dev Returns the token collection symbol.
1148      */
1149     function symbol() external view returns (string memory);
1150 
1151     /**
1152      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1153      */
1154     function tokenURI(uint256 tokenId) external view returns (string memory);
1155 }
1156 
1157 // File: contracts/ERC721A.sol
1158 
1159 
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 
1171 /**
1172  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1173  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1174  *
1175  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1176  *
1177  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1178  *
1179  * Does not support burning tokens to address(0).
1180  */
1181 contract ERC721A is
1182   Context,
1183   ERC165,
1184   IERC721,
1185   IERC721Metadata,
1186   IERC721Enumerable
1187 {
1188   using Address for address;
1189   using Strings for uint256;
1190 
1191   struct TokenOwnership {
1192     address addr;
1193     uint64 startTimestamp;
1194   }
1195 
1196   struct AddressData {
1197     uint128 balance;
1198     uint128 numberMinted;
1199   }
1200 
1201   uint256 private currentIndex = 0;
1202 
1203   uint256 internal immutable collectionSize;
1204   uint256 internal immutable maxBatchSize;
1205 
1206   // Token name
1207   string private _name;
1208 
1209   // Token symbol
1210   string private _symbol;
1211 
1212   // Mapping from token ID to ownership details
1213   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1214   mapping(uint256 => TokenOwnership) private _ownerships;
1215 
1216   // Mapping owner address to address data
1217   mapping(address => AddressData) private _addressData;
1218 
1219   // Mapping from token ID to approved address
1220   mapping(uint256 => address) private _tokenApprovals;
1221 
1222   // Mapping from owner to operator approvals
1223   mapping(address => mapping(address => bool)) private _operatorApprovals;
1224 
1225   /**
1226    * @dev
1227    * `maxBatchSize` refers to how much a minter can mint at a time.
1228    * `collectionSize_` refers to how many tokens are in the collection.
1229    */
1230   constructor(
1231     string memory name_,
1232     string memory symbol_,
1233     uint256 maxBatchSize_,
1234     uint256 collectionSize_
1235   ) {
1236     require(
1237       collectionSize_ > 0,
1238       "ERC721A: collection must have a nonzero supply"
1239     );
1240     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1241     _name = name_;
1242     _symbol = symbol_;
1243     maxBatchSize = maxBatchSize_;
1244     collectionSize = collectionSize_;
1245   }
1246 
1247   /**
1248    * @dev See {IERC721Enumerable-totalSupply}.
1249    */
1250   function totalSupply() public view override returns (uint256) {
1251     return currentIndex;
1252   }
1253 
1254   /**
1255    * @dev See {IERC721Enumerable-tokenByIndex}.
1256    */
1257   function tokenByIndex(uint256 index) public view override returns (uint256) {
1258     require(index < totalSupply(), "ERC721A: global index out of bounds");
1259     return index;
1260   }
1261 
1262   /**
1263    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1264    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1265    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1266    */
1267   function tokenOfOwnerByIndex(address owner, uint256 index)
1268     public
1269     view
1270     override
1271     returns (uint256)
1272   {
1273     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1274     uint256 numMintedSoFar = totalSupply();
1275     uint256 tokenIdsIdx = 0;
1276     address currOwnershipAddr = address(0);
1277     for (uint256 i = 0; i < numMintedSoFar; i++) {
1278       TokenOwnership memory ownership = _ownerships[i];
1279       if (ownership.addr != address(0)) {
1280         currOwnershipAddr = ownership.addr;
1281       }
1282       if (currOwnershipAddr == owner) {
1283         if (tokenIdsIdx == index) {
1284           return i;
1285         }
1286         tokenIdsIdx++;
1287       }
1288     }
1289     revert("ERC721A: unable to get token of owner by index");
1290   }
1291 
1292   /**
1293    * @dev See {IERC165-supportsInterface}.
1294    */
1295   function supportsInterface(bytes4 interfaceId)
1296     public
1297     view
1298     virtual
1299     override(ERC165, IERC165)
1300     returns (bool)
1301   {
1302     return
1303       interfaceId == type(IERC721).interfaceId ||
1304       interfaceId == type(IERC721Metadata).interfaceId ||
1305       interfaceId == type(IERC721Enumerable).interfaceId ||
1306       super.supportsInterface(interfaceId);
1307   }
1308 
1309   /**
1310    * @dev See {IERC721-balanceOf}.
1311    */
1312   function balanceOf(address owner) public view override returns (uint256) {
1313     require(owner != address(0), "ERC721A: balance query for the zero address");
1314     return uint256(_addressData[owner].balance);
1315   }
1316 
1317   function _numberMinted(address owner) internal view returns (uint256) {
1318     require(
1319       owner != address(0),
1320       "ERC721A: number minted query for the zero address"
1321     );
1322     return uint256(_addressData[owner].numberMinted);
1323   }
1324 
1325   function ownershipOf(uint256 tokenId)
1326     internal
1327     view
1328     returns (TokenOwnership memory)
1329   {
1330     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1331 
1332     uint256 lowestTokenToCheck;
1333     if (tokenId >= maxBatchSize) {
1334       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1335     }
1336 
1337     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1338       TokenOwnership memory ownership = _ownerships[curr];
1339       if (ownership.addr != address(0)) {
1340         return ownership;
1341       }
1342     }
1343 
1344     revert("ERC721A: unable to determine the owner of token");
1345   }
1346 
1347   /**
1348    * @dev See {IERC721-ownerOf}.
1349    */
1350   function ownerOf(uint256 tokenId) public view override returns (address) {
1351     return ownershipOf(tokenId).addr;
1352   }
1353 
1354   /**
1355    * @dev See {IERC721Metadata-name}.
1356    */
1357   function name() public view virtual override returns (string memory) {
1358     return _name;
1359   }
1360 
1361   /**
1362    * @dev See {IERC721Metadata-symbol}.
1363    */
1364   function symbol() public view virtual override returns (string memory) {
1365     return _symbol;
1366   }
1367 
1368   /**
1369    * @dev See {IERC721Metadata-tokenURI}.
1370    */
1371   function tokenURI(uint256 tokenId)
1372     public
1373     view
1374     virtual
1375     override
1376     returns (string memory)
1377   {
1378     require(
1379       _exists(tokenId),
1380       "ERC721Metadata: URI query for nonexistent token"
1381     );
1382 
1383     string memory baseURI = _baseURI();
1384     return
1385       bytes(baseURI).length > 0
1386         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1387         : "";
1388   }
1389 
1390   /**
1391    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1392    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1393    * by default, can be overriden in child contracts.
1394    */
1395   function _baseURI() internal view virtual returns (string memory) {
1396     return "";
1397   }
1398 
1399   /**
1400    * @dev See {IERC721-approve}.
1401    */
1402   function approve(address to, uint256 tokenId) public override {
1403     address owner = ERC721A.ownerOf(tokenId);
1404     require(to != owner, "ERC721A: approval to current owner");
1405 
1406     require(
1407       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1408       "ERC721A: approve caller is not owner nor approved for all"
1409     );
1410 
1411     _approve(to, tokenId, owner);
1412   }
1413 
1414   /**
1415    * @dev See {IERC721-getApproved}.
1416    */
1417   function getApproved(uint256 tokenId) public view override returns (address) {
1418     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1419 
1420     return _tokenApprovals[tokenId];
1421   }
1422 
1423   /**
1424    * @dev See {IERC721-setApprovalForAll}.
1425    */
1426   function setApprovalForAll(address operator, bool approved) public override {
1427     require(operator != _msgSender(), "ERC721A: approve to caller");
1428 
1429     _operatorApprovals[_msgSender()][operator] = approved;
1430     emit ApprovalForAll(_msgSender(), operator, approved);
1431   }
1432 
1433   /**
1434    * @dev See {IERC721-isApprovedForAll}.
1435    */
1436   function isApprovedForAll(address owner, address operator)
1437     public
1438     view
1439     virtual
1440     override
1441     returns (bool)
1442   {
1443     return _operatorApprovals[owner][operator];
1444   }
1445 
1446   /**
1447    * @dev See {IERC721-transferFrom}.
1448    */
1449   function transferFrom(
1450     address from,
1451     address to,
1452     uint256 tokenId
1453   ) public override {
1454     _transfer(from, to, tokenId);
1455   }
1456 
1457   /**
1458    * @dev See {IERC721-safeTransferFrom}.
1459    */
1460   function safeTransferFrom(
1461     address from,
1462     address to,
1463     uint256 tokenId
1464   ) public override {
1465     safeTransferFrom(from, to, tokenId, "");
1466   }
1467 
1468   /**
1469    * @dev See {IERC721-safeTransferFrom}.
1470    */
1471   function safeTransferFrom(
1472     address from,
1473     address to,
1474     uint256 tokenId,
1475     bytes memory _data
1476   ) public override {
1477     _transfer(from, to, tokenId);
1478     require(
1479       _checkOnERC721Received(from, to, tokenId, _data),
1480       "ERC721A: transfer to non ERC721Receiver implementer"
1481     );
1482   }
1483 
1484   /**
1485    * @dev Returns whether `tokenId` exists.
1486    *
1487    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1488    *
1489    * Tokens start existing when they are minted (`_mint`),
1490    */
1491   function _exists(uint256 tokenId) internal view returns (bool) {
1492     return tokenId < currentIndex;
1493   }
1494 
1495   function _safeMint(address to, uint256 quantity) internal {
1496     _safeMint(to, quantity, "");
1497   }
1498 
1499   /**
1500    * @dev Mints `quantity` tokens and transfers them to `to`.
1501    *
1502    * Requirements:
1503    *
1504    * - there must be `quantity` tokens remaining unminted in the total collection.
1505    * - `to` cannot be the zero address.
1506    * - `quantity` cannot be larger than the max batch size.
1507    *
1508    * Emits a {Transfer} event.
1509    */
1510   function _safeMint(
1511     address to,
1512     uint256 quantity,
1513     bytes memory _data
1514   ) internal {
1515     uint256 startTokenId = currentIndex;
1516     require(to != address(0), "ERC721A: mint to the zero address");
1517     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1518     require(!_exists(startTokenId), "ERC721A: token already minted");
1519     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1520 
1521     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1522 
1523     AddressData memory addressData = _addressData[to];
1524     _addressData[to] = AddressData(
1525       addressData.balance + uint128(quantity),
1526       addressData.numberMinted + uint128(quantity)
1527     );
1528     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1529 
1530     uint256 updatedIndex = startTokenId;
1531 
1532     for (uint256 i = 0; i < quantity; i++) {
1533       emit Transfer(address(0), to, updatedIndex);
1534       require(
1535         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1536         "ERC721A: transfer to non ERC721Receiver implementer"
1537       );
1538       updatedIndex++;
1539     }
1540 
1541     currentIndex = updatedIndex;
1542     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1543   }
1544 
1545   /**
1546    * @dev Transfers `tokenId` from `from` to `to`.
1547    *
1548    * Requirements:
1549    *
1550    * - `to` cannot be the zero address.
1551    * - `tokenId` token must be owned by `from`.
1552    *
1553    * Emits a {Transfer} event.
1554    */
1555   function _transfer(
1556     address from,
1557     address to,
1558     uint256 tokenId
1559   ) private {
1560     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1561 
1562     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1563       getApproved(tokenId) == _msgSender() ||
1564       isApprovedForAll(prevOwnership.addr, _msgSender()));
1565 
1566     require(
1567       isApprovedOrOwner,
1568       "ERC721A: transfer caller is not owner nor approved"
1569     );
1570 
1571     require(
1572       prevOwnership.addr == from,
1573       "ERC721A: transfer from incorrect owner"
1574     );
1575     require(to != address(0), "ERC721A: transfer to the zero address");
1576 
1577     _beforeTokenTransfers(from, to, tokenId, 1);
1578 
1579     // Clear approvals from the previous owner
1580     _approve(address(0), tokenId, prevOwnership.addr);
1581 
1582     _addressData[from].balance -= 1;
1583     _addressData[to].balance += 1;
1584     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1585 
1586     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1587     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1588     uint256 nextTokenId = tokenId + 1;
1589     if (_ownerships[nextTokenId].addr == address(0)) {
1590       if (_exists(nextTokenId)) {
1591         _ownerships[nextTokenId] = TokenOwnership(
1592           prevOwnership.addr,
1593           prevOwnership.startTimestamp
1594         );
1595       }
1596     }
1597 
1598     emit Transfer(from, to, tokenId);
1599     _afterTokenTransfers(from, to, tokenId, 1);
1600   }
1601 
1602   /**
1603    * @dev Approve `to` to operate on `tokenId`
1604    *
1605    * Emits a {Approval} event.
1606    */
1607   function _approve(
1608     address to,
1609     uint256 tokenId,
1610     address owner
1611   ) private {
1612     _tokenApprovals[tokenId] = to;
1613     emit Approval(owner, to, tokenId);
1614   }
1615 
1616   uint256 public nextOwnerToExplicitlySet = 0;
1617 
1618   /**
1619    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1620    */
1621   function _setOwnersExplicit(uint256 quantity) internal {
1622     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1623     require(quantity > 0, "quantity must be nonzero");
1624     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1625     if (endIndex > collectionSize - 1) {
1626       endIndex = collectionSize - 1;
1627     }
1628     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1629     require(_exists(endIndex), "not enough minted yet for this cleanup");
1630     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1631       if (_ownerships[i].addr == address(0)) {
1632         TokenOwnership memory ownership = ownershipOf(i);
1633         _ownerships[i] = TokenOwnership(
1634           ownership.addr,
1635           ownership.startTimestamp
1636         );
1637       }
1638     }
1639     nextOwnerToExplicitlySet = endIndex + 1;
1640   }
1641 
1642   /**
1643    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1644    * The call is not executed if the target address is not a contract.
1645    *
1646    * @param from address representing the previous owner of the given token ID
1647    * @param to target address that will receive the tokens
1648    * @param tokenId uint256 ID of the token to be transferred
1649    * @param _data bytes optional data to send along with the call
1650    * @return bool whether the call correctly returned the expected magic value
1651    */
1652   function _checkOnERC721Received(
1653     address from,
1654     address to,
1655     uint256 tokenId,
1656     bytes memory _data
1657   ) private returns (bool) {
1658     if (to.isContract()) {
1659       try
1660         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1661       returns (bytes4 retval) {
1662         return retval == IERC721Receiver(to).onERC721Received.selector;
1663       } catch (bytes memory reason) {
1664         if (reason.length == 0) {
1665           revert("ERC721A: transfer to non ERC721Receiver implementer");
1666         } else {
1667           assembly {
1668             revert(add(32, reason), mload(reason))
1669           }
1670         }
1671       }
1672     } else {
1673       return true;
1674     }
1675   }
1676 
1677   /**
1678    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1679    *
1680    * startTokenId - the first token id to be transferred
1681    * quantity - the amount to be transferred
1682    *
1683    * Calling conditions:
1684    *
1685    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1686    * transferred to `to`.
1687    * - When `from` is zero, `tokenId` will be minted for `to`.
1688    */
1689   function _beforeTokenTransfers(
1690     address from,
1691     address to,
1692     uint256 startTokenId,
1693     uint256 quantity
1694   ) internal virtual {}
1695 
1696   /**
1697    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1698    * minting.
1699    *
1700    * startTokenId - the first token id to be transferred
1701    * quantity - the amount to be transferred
1702    *
1703    * Calling conditions:
1704    *
1705    * - when `from` and `to` are both non-zero.
1706    * - `from` and `to` are never both zero.
1707    */
1708   function _afterTokenTransfers(
1709     address from,
1710     address to,
1711     uint256 startTokenId,
1712     uint256 quantity
1713   ) internal virtual {}
1714 }
1715 
1716 //SPDX-License-Identifier: MIT
1717 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1718 
1719 pragma solidity ^0.8.0;
1720 
1721 
1722 contract ReeferMadness is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1723     using Counters for Counters.Counter;
1724     using Strings for uint256;
1725 
1726     Counters.Counter private tokenCounter;
1727 
1728     string private baseURI = "ipfs://QmQzufoAymZFBbfgZ28CTNGYDmLafFWvocPQHb7XtVEq99";
1729     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1730     bool private isOpenSeaProxyActive = true;
1731 
1732     uint256 public constant MAX_MINTS_PER_TX = 1;
1733     uint256 public maxSupply = 315;
1734 
1735     uint256 public constant PRICE = 0.005 ether;
1736     uint256 public NUM_FREE_MINTS = 315;
1737     bool public isPublicSaleActive = false;
1738 
1739 
1740 
1741 
1742     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1743 
1744     modifier publicSaleActive() {
1745         require(isPublicSaleActive, "Public sale is not open");
1746         _;
1747     }
1748 
1749 
1750 
1751     modifier maxMintsPerTX(uint256 numberOfTokens) {
1752         require(
1753             numberOfTokens <= MAX_MINTS_PER_TX,
1754             "Max mints per transaction exceeded"
1755         );
1756         _;
1757     }
1758 
1759     modifier canMintNFTs(uint256 numberOfTokens) {
1760         require(
1761             totalSupply() + numberOfTokens <=
1762                 maxSupply,
1763             "Not enough mints remaining to mint"
1764         );
1765         _;
1766     }
1767 
1768     modifier freeMintsAvailable() {
1769         require(
1770             totalSupply() <=
1771                 NUM_FREE_MINTS,
1772             "Not enough free mints remain"
1773         );
1774         _;
1775     }
1776 
1777 
1778 
1779     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1780         if(totalSupply()>NUM_FREE_MINTS){
1781         require(
1782             (price * numberOfTokens) == msg.value,
1783             "Incorrect ETH value sent"
1784         );
1785         }
1786         _;
1787     }
1788 
1789 
1790     constructor(
1791     ) ERC721A("Reefer Madness", "Reefer", 100, maxSupply) {
1792     }
1793 
1794     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1795 
1796     function mint(uint256 numberOfTokens)
1797         external
1798         payable
1799         nonReentrant
1800         isCorrectPayment(PRICE, numberOfTokens)
1801         publicSaleActive
1802         canMintNFTs(numberOfTokens)
1803         maxMintsPerTX(numberOfTokens)
1804     {
1805 
1806         _safeMint(msg.sender, numberOfTokens);
1807     }
1808 
1809 
1810 
1811     //A simple free mint function to avoid confusion
1812     //The normal mint function with a cost of 0 would work too
1813 
1814     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1815 
1816     function getBaseURI() external view returns (string memory) {
1817         return baseURI;
1818     }
1819 
1820     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1821 
1822     function setBaseURI(string memory _baseURI) external onlyOwner {
1823         baseURI = _baseURI;
1824     }
1825 
1826     // function to disable gasless listings for security in case
1827     // opensea ever shuts down or is compromised
1828     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1829         external
1830         onlyOwner
1831     {
1832         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1833     }
1834 
1835     function setIsPublicSaleActive(bool _isPublicSaleActive)
1836         external
1837         onlyOwner
1838     {
1839         isPublicSaleActive = _isPublicSaleActive;
1840     }
1841 
1842     function setNumFreeMints(uint256 _numfreemints)
1843         external
1844         onlyOwner
1845     {
1846         NUM_FREE_MINTS = _numfreemints;
1847     }
1848 
1849 
1850     function withdraw() public onlyOwner {
1851         uint256 balance = address(this).balance;
1852         payable(msg.sender).transfer(balance);
1853     }
1854 
1855     function withdrawTokens(IERC20 token) public onlyOwner {
1856         uint256 balance = token.balanceOf(address(this));
1857         token.transfer(msg.sender, balance);
1858     }
1859 
1860 
1861 
1862     // ============ SUPPORTING FUNCTIONS ============
1863 
1864     function nextTokenId() private returns (uint256) {
1865         tokenCounter.increment();
1866         return tokenCounter.current();
1867     }
1868 
1869     // ============ FUNCTION OVERRIDES ============
1870 
1871     function supportsInterface(bytes4 interfaceId)
1872         public
1873         view
1874         virtual
1875         override(ERC721A, IERC165)
1876         returns (bool)
1877     {
1878         return
1879             interfaceId == type(IERC2981).interfaceId ||
1880             super.supportsInterface(interfaceId);
1881     }
1882 
1883     /**
1884      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1885      */
1886     function isApprovedForAll(address owner, address operator)
1887         public
1888         view
1889         override
1890         returns (bool)
1891     {
1892         // Get a reference to OpenSea's proxy registry contract by instantiating
1893         // the contract using the already existing address.
1894         ProxyRegistry proxyRegistry = ProxyRegistry(
1895             openSeaProxyRegistryAddress
1896         );
1897         if (
1898             isOpenSeaProxyActive &&
1899             address(proxyRegistry.proxies(owner)) == operator
1900         ) {
1901             return true;
1902         }
1903 
1904         return super.isApprovedForAll(owner, operator);
1905     }
1906 
1907     /**
1908      * @dev See {IERC721Metadata-tokenURI}.
1909      */
1910     function tokenURI(uint256 tokenId)
1911         public
1912         view
1913         virtual
1914         override
1915         returns (string memory)
1916     {
1917         require(_exists(tokenId), "Nonexistent token");
1918 
1919         return
1920             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1921     }
1922 
1923     /**
1924      * @dev See {IERC165-royaltyInfo}.
1925      */
1926     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1927         external
1928         view
1929         override
1930         returns (address receiver, uint256 royaltyAmount)
1931     {
1932         require(_exists(tokenId), "Nonexistent token");
1933 
1934         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1935     }
1936 }
1937 
1938 // These contract definitions are used to create a reference to the OpenSea
1939 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1940 contract OwnableDelegateProxy {
1941 
1942 }
1943 
1944 contract ProxyRegistry {
1945     mapping(address => OwnableDelegateProxy) public proxies;
1946 }