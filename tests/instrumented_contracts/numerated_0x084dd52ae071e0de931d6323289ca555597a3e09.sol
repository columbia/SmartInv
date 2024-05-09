1 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
2 
3 pragma solidity ^0.8.0;
4 
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (b > a) return (false, 0);
37             return (true, a - b);
38         }
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49             // benefit is lost if 'b' is also tested.
50             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51             if (a == 0) return (true, 0);
52             uint256 c = a * b;
53             if (c / a != b) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a / b);
67         }
68     }
69 
70     /**
71      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a % b);
79         }
80     }
81 
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a + b;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a * b;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator.
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * reverting when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a % b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * CAUTION: This function is deprecated because it requires allocating memory for the error
159      * message unnecessarily. For custom revert reasons use {trySub}.
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172         unchecked {
173             require(b <= a, errorMessage);
174             return a - b;
175         }
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         unchecked {
196             require(b > 0, errorMessage);
197             return a / b;
198         }
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting with custom message when dividing by zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryMod}.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         unchecked {
222             require(b > 0, errorMessage);
223             return a % b;
224         }
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/Counters.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @title Counters
237  * @author Matt Condon (@shrugs)
238  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
239  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
240  *
241  * Include with `using Counters for Counters.Counter;`
242  */
243 library Counters {
244     struct Counter {
245         // This variable should never be directly accessed by users of the library: interactions must be restricted to
246         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
247         // this feature: see https://github.com/ethereum/solidity/issues/4637
248         uint256 _value; // default: 0
249     }
250 
251     function current(Counter storage counter) internal view returns (uint256) {
252         return counter._value;
253     }
254 
255     function increment(Counter storage counter) internal {
256         unchecked {
257             counter._value += 1;
258         }
259     }
260 
261     function decrement(Counter storage counter) internal {
262         uint256 value = counter._value;
263         require(value > 0, "Counter: decrement overflow");
264         unchecked {
265             counter._value = value - 1;
266         }
267     }
268 
269     function reset(Counter storage counter) internal {
270         counter._value = 0;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Contract module that helps prevent reentrant calls to a function.
283  *
284  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
285  * available, which can be applied to functions to make sure there are no nested
286  * (reentrant) calls to them.
287  *
288  * Note that because there is a single `nonReentrant` guard, functions marked as
289  * `nonReentrant` may not call one another. This can be worked around by making
290  * those functions `private`, and then adding `external` `nonReentrant` entry
291  * points to them.
292  *
293  * TIP: If you would like to learn more about reentrancy and alternative ways
294  * to protect against it, check out our blog post
295  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
296  */
297 abstract contract ReentrancyGuard {
298     // Booleans are more expensive than uint256 or any type that takes up a full
299     // word because each write operation emits an extra SLOAD to first read the
300     // slot's contents, replace the bits taken up by the boolean, and then write
301     // back. This is the compiler's defense against contract upgrades and
302     // pointer aliasing, and it cannot be disabled.
303 
304     // The values being non-zero value makes deployment a bit more expensive,
305     // but in exchange the refund on every call to nonReentrant will be lower in
306     // amount. Since refunds are capped to a percentage of the total
307     // transaction's gas, it is best to keep them low in cases like this one, to
308     // increase the likelihood of the full refund coming into effect.
309     uint256 private constant _NOT_ENTERED = 1;
310     uint256 private constant _ENTERED = 2;
311 
312     uint256 private _status;
313 
314     constructor() {
315         _status = _NOT_ENTERED;
316     }
317 
318     /**
319      * @dev Prevents a contract from calling itself, directly or indirectly.
320      * Calling a `nonReentrant` function from another `nonReentrant`
321      * function is not supported. It is possible to prevent this from happening
322      * by making the `nonReentrant` function external, and making it call a
323      * `private` function that does the actual work.
324      */
325     modifier nonReentrant() {
326         // On the first call to nonReentrant, _notEntered will be true
327         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
328 
329         // Any calls to nonReentrant after this point will fail
330         _status = _ENTERED;
331 
332         _;
333 
334         // By storing the original value once again, a refund is triggered (see
335         // https://eips.ethereum.org/EIPS/eip-2200)
336         _status = _NOT_ENTERED;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Interface of the ERC20 standard as defined in the EIP.
349  */
350 interface IERC20 {
351     /**
352      * @dev Returns the amount of tokens in existence.
353      */
354     function totalSupply() external view returns (uint256);
355 
356     /**
357      * @dev Returns the amount of tokens owned by `account`.
358      */
359     function balanceOf(address account) external view returns (uint256);
360 
361     /**
362      * @dev Moves `amount` tokens from the caller's account to `recipient`.
363      *
364      * Returns a boolean value indicating whether the operation succeeded.
365      *
366      * Emits a {Transfer} event.
367      */
368     function transfer(address recipient, uint256 amount) external returns (bool);
369 
370     /**
371      * @dev Returns the remaining number of tokens that `spender` will be
372      * allowed to spend on behalf of `owner` through {transferFrom}. This is
373      * zero by default.
374      *
375      * This value changes when {approve} or {transferFrom} are called.
376      */
377     function allowance(address owner, address spender) external view returns (uint256);
378 
379     /**
380      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
381      *
382      * Returns a boolean value indicating whether the operation succeeded.
383      *
384      * IMPORTANT: Beware that changing an allowance with this method brings the risk
385      * that someone may use both the old and the new allowance by unfortunate
386      * transaction ordering. One possible solution to mitigate this race
387      * condition is to first reduce the spender's allowance to 0 and set the
388      * desired value afterwards:
389      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
390      *
391      * Emits an {Approval} event.
392      */
393     function approve(address spender, uint256 amount) external returns (bool);
394 
395     /**
396      * @dev Moves `amount` tokens from `sender` to `recipient` using the
397      * allowance mechanism. `amount` is then deducted from the caller's
398      * allowance.
399      *
400      * Returns a boolean value indicating whether the operation succeeded.
401      *
402      * Emits a {Transfer} event.
403      */
404     function transferFrom(
405         address sender,
406         address recipient,
407         uint256 amount
408     ) external returns (bool);
409 
410     /**
411      * @dev Emitted when `value` tokens are moved from one account (`from`) to
412      * another (`to`).
413      *
414      * Note that `value` may be zero.
415      */
416     event Transfer(address indexed from, address indexed to, uint256 value);
417 
418     /**
419      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
420      * a call to {approve}. `value` is the new allowance.
421      */
422     event Approval(address indexed owner, address indexed spender, uint256 value);
423 }
424 
425 // File: @openzeppelin/contracts/interfaces/IERC20.sol
426 
427 
428 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 
433 // File: @openzeppelin/contracts/utils/Strings.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev String operations.
442  */
443 library Strings {
444     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
448      */
449     function toString(uint256 value) internal pure returns (string memory) {
450         // Inspired by OraclizeAPI's implementation - MIT licence
451         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
452 
453         if (value == 0) {
454             return "0";
455         }
456         uint256 temp = value;
457         uint256 digits;
458         while (temp != 0) {
459             digits++;
460             temp /= 10;
461         }
462         bytes memory buffer = new bytes(digits);
463         while (value != 0) {
464             digits -= 1;
465             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
466             value /= 10;
467         }
468         return string(buffer);
469     }
470 
471     /**
472      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
473      */
474     function toHexString(uint256 value) internal pure returns (string memory) {
475         if (value == 0) {
476             return "0x00";
477         }
478         uint256 temp = value;
479         uint256 length = 0;
480         while (temp != 0) {
481             length++;
482             temp >>= 8;
483         }
484         return toHexString(value, length);
485     }
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
489      */
490     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
491         bytes memory buffer = new bytes(2 * length + 2);
492         buffer[0] = "0";
493         buffer[1] = "x";
494         for (uint256 i = 2 * length + 1; i > 1; --i) {
495             buffer[i] = _HEX_SYMBOLS[value & 0xf];
496             value >>= 4;
497         }
498         require(value == 0, "Strings: hex length insufficient");
499         return string(buffer);
500     }
501 }
502 
503 // File: @openzeppelin/contracts/utils/Context.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Provides information about the current execution context, including the
512  * sender of the transaction and its data. While these are generally available
513  * via msg.sender and msg.data, they should not be accessed in such a direct
514  * manner, since when dealing with meta-transactions the account sending and
515  * paying for execution may not be the actual sender (as far as an application
516  * is concerned).
517  *
518  * This contract is only required for intermediate, library-like contracts.
519  */
520 abstract contract Context {
521     function _msgSender() internal view virtual returns (address) {
522         return msg.sender;
523     }
524 
525     function _msgData() internal view virtual returns (bytes calldata) {
526         return msg.data;
527     }
528 }
529 
530 // File: @openzeppelin/contracts/access/Ownable.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @dev Contract module which provides a basic access control mechanism, where
540  * there is an account (an owner) that can be granted exclusive access to
541  * specific functions.
542  *
543  * By default, the owner account will be the one that deploys the contract. This
544  * can later be changed with {transferOwnership}.
545  *
546  * This module is used through inheritance. It will make available the modifier
547  * `onlyOwner`, which can be applied to your functions to restrict their use to
548  * the owner.
549  */
550 abstract contract Ownable is Context {
551     address private _owner;
552 
553     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
554 
555     /**
556      * @dev Initializes the contract setting the deployer as the initial owner.
557      */
558     constructor() {
559         _transferOwnership(_msgSender());
560     }
561 
562     /**
563      * @dev Returns the address of the current owner.
564      */
565     function owner() public view virtual returns (address) {
566         return _owner;
567     }
568 
569     /**
570      * @dev Throws if called by any account other than the owner.
571      */
572     modifier onlyOwner() {
573         require(owner() == _msgSender(), "Ownable: caller is not the owner");
574         _;
575     }
576 
577     /**
578      * @dev Leaves the contract without owner. It will not be possible to call
579      * `onlyOwner` functions anymore. Can only be called by the current owner.
580      *
581      * NOTE: Renouncing ownership will leave the contract without an owner,
582      * thereby removing any functionality that is only available to the owner.
583      */
584     function renounceOwnership() public virtual onlyOwner {
585         _transferOwnership(address(0));
586     }
587 
588     /**
589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
590      * Can only be called by the current owner.
591      */
592     function transferOwnership(address newOwner) public virtual onlyOwner {
593         require(newOwner != address(0), "Ownable: new owner is the zero address");
594         _transferOwnership(newOwner);
595     }
596 
597     /**
598      * @dev Transfers ownership of the contract to a new account (`newOwner`).
599      * Internal function without access restriction.
600      */
601     function _transferOwnership(address newOwner) internal virtual {
602         address oldOwner = _owner;
603         _owner = newOwner;
604         emit OwnershipTransferred(oldOwner, newOwner);
605     }
606 }
607 
608 // File: @openzeppelin/contracts/utils/Address.sol
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @dev Collection of functions related to the address type
617  */
618 library Address {
619     /**
620      * @dev Returns true if `account` is a contract.
621      *
622      * [IMPORTANT]
623      * ====
624      * It is unsafe to assume that an address for which this function returns
625      * false is an externally-owned account (EOA) and not a contract.
626      *
627      * Among others, `isContract` will return false for the following
628      * types of addresses:
629      *
630      *  - an externally-owned account
631      *  - a contract in construction
632      *  - an address where a contract will be created
633      *  - an address where a contract lived, but was destroyed
634      * ====
635      */
636     function isContract(address account) internal view returns (bool) {
637         // This method relies on extcodesize, which returns 0 for contracts in
638         // construction, since the code is only stored at the end of the
639         // constructor execution.
640 
641         uint256 size;
642         assembly {
643             size := extcodesize(account)
644         }
645         return size > 0;
646     }
647 
648     /**
649      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
650      * `recipient`, forwarding all available gas and reverting on errors.
651      *
652      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
653      * of certain opcodes, possibly making contracts go over the 2300 gas limit
654      * imposed by `transfer`, making them unable to receive funds via
655      * `transfer`. {sendValue} removes this limitation.
656      *
657      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
658      *
659      * IMPORTANT: because control is transferred to `recipient`, care must be
660      * taken to not create reentrancy vulnerabilities. Consider using
661      * {ReentrancyGuard} or the
662      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
663      */
664     function sendValue(address payable recipient, uint256 amount) internal {
665         require(address(this).balance >= amount, "Address: insufficient balance");
666 
667         (bool success, ) = recipient.call{value: amount}("");
668         require(success, "Address: unable to send value, recipient may have reverted");
669     }
670 
671     /**
672      * @dev Performs a Solidity function call using a low level `call`. A
673      * plain `call` is an unsafe replacement for a function call: use this
674      * function instead.
675      *
676      * If `target` reverts with a revert reason, it is bubbled up by this
677      * function (like regular Solidity function calls).
678      *
679      * Returns the raw returned data. To convert to the expected return value,
680      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
681      *
682      * Requirements:
683      *
684      * - `target` must be a contract.
685      * - calling `target` with `data` must not revert.
686      *
687      * _Available since v3.1._
688      */
689     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
690         return functionCall(target, data, "Address: low-level call failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
695      * `errorMessage` as a fallback revert reason when `target` reverts.
696      *
697      * _Available since v3.1._
698      */
699     function functionCall(
700         address target,
701         bytes memory data,
702         string memory errorMessage
703     ) internal returns (bytes memory) {
704         return functionCallWithValue(target, data, 0, errorMessage);
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
709      * but also transferring `value` wei to `target`.
710      *
711      * Requirements:
712      *
713      * - the calling contract must have an ETH balance of at least `value`.
714      * - the called Solidity function must be `payable`.
715      *
716      * _Available since v3.1._
717      */
718     function functionCallWithValue(
719         address target,
720         bytes memory data,
721         uint256 value
722     ) internal returns (bytes memory) {
723         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
728      * with `errorMessage` as a fallback revert reason when `target` reverts.
729      *
730      * _Available since v3.1._
731      */
732     function functionCallWithValue(
733         address target,
734         bytes memory data,
735         uint256 value,
736         string memory errorMessage
737     ) internal returns (bytes memory) {
738         require(address(this).balance >= value, "Address: insufficient balance for call");
739         require(isContract(target), "Address: call to non-contract");
740 
741         (bool success, bytes memory returndata) = target.call{value: value}(data);
742         return verifyCallResult(success, returndata, errorMessage);
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
747      * but performing a static call.
748      *
749      * _Available since v3.3._
750      */
751     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
752         return functionStaticCall(target, data, "Address: low-level static call failed");
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
757      * but performing a static call.
758      *
759      * _Available since v3.3._
760      */
761     function functionStaticCall(
762         address target,
763         bytes memory data,
764         string memory errorMessage
765     ) internal view returns (bytes memory) {
766         require(isContract(target), "Address: static call to non-contract");
767 
768         (bool success, bytes memory returndata) = target.staticcall(data);
769         return verifyCallResult(success, returndata, errorMessage);
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
774      * but performing a delegate call.
775      *
776      * _Available since v3.4._
777      */
778     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
779         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
784      * but performing a delegate call.
785      *
786      * _Available since v3.4._
787      */
788     function functionDelegateCall(
789         address target,
790         bytes memory data,
791         string memory errorMessage
792     ) internal returns (bytes memory) {
793         require(isContract(target), "Address: delegate call to non-contract");
794 
795         (bool success, bytes memory returndata) = target.delegatecall(data);
796         return verifyCallResult(success, returndata, errorMessage);
797     }
798 
799     /**
800      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
801      * revert reason using the provided one.
802      *
803      * _Available since v4.3._
804      */
805     function verifyCallResult(
806         bool success,
807         bytes memory returndata,
808         string memory errorMessage
809     ) internal pure returns (bytes memory) {
810         if (success) {
811             return returndata;
812         } else {
813             // Look for revert reason and bubble it up if present
814             if (returndata.length > 0) {
815                 // The easiest way to bubble the revert reason is using memory via assembly
816 
817                 assembly {
818                     let returndata_size := mload(returndata)
819                     revert(add(32, returndata), returndata_size)
820                 }
821             } else {
822                 revert(errorMessage);
823             }
824         }
825     }
826 }
827 
828 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
829 
830 
831 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 /**
836  * @title ERC721 token receiver interface
837  * @dev Interface for any contract that wants to support safeTransfers
838  * from ERC721 asset contracts.
839  */
840 interface IERC721Receiver {
841     /**
842      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
843      * by `operator` from `from`, this function is called.
844      *
845      * It must return its Solidity selector to confirm the token transfer.
846      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
847      *
848      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
849      */
850     function onERC721Received(
851         address operator,
852         address from,
853         uint256 tokenId,
854         bytes calldata data
855     ) external returns (bytes4);
856 }
857 
858 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
859 
860 
861 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
862 
863 pragma solidity ^0.8.0;
864 
865 /**
866  * @dev Interface of the ERC165 standard, as defined in the
867  * https://eips.ethereum.org/EIPS/eip-165[EIP].
868  *
869  * Implementers can declare support of contract interfaces, which can then be
870  * queried by others ({ERC165Checker}).
871  *
872  * For an implementation, see {ERC165}.
873  */
874 interface IERC165 {
875     /**
876      * @dev Returns true if this contract implements the interface defined by
877      * `interfaceId`. See the corresponding
878      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
879      * to learn more about how these ids are created.
880      *
881      * This function call must use less than 30 000 gas.
882      */
883     function supportsInterface(bytes4 interfaceId) external view returns (bool);
884 }
885 
886 // File: @openzeppelin/contracts/interfaces/IERC165.sol
887 
888 
889 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 
894 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
895 
896 
897 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
898 
899 pragma solidity ^0.8.0;
900 
901 
902 /**
903  * @dev Interface for the NFT Royalty Standard
904  */
905 interface IERC2981 is IERC165 {
906     /**
907      * @dev Called with the sale price to determine how much royalty is owed and to whom.
908      * @param tokenId - the NFT asset queried for royalty information
909      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
910      * @return receiver - address of who should be sent the royalty payment
911      * @return royaltyAmount - the royalty payment amount for `salePrice`
912      */
913     function royaltyInfo(uint256 tokenId, uint256 salePrice)
914         external
915         view
916         returns (address receiver, uint256 royaltyAmount);
917 }
918 
919 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
920 
921 
922 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
923 
924 pragma solidity ^0.8.0;
925 
926 
927 /**
928  * @dev Implementation of the {IERC165} interface.
929  *
930  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
931  * for the additional interface id that will be supported. For example:
932  *
933  * ```solidity
934  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
935  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
936  * }
937  * ```
938  *
939  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
940  */
941 abstract contract ERC165 is IERC165 {
942     /**
943      * @dev See {IERC165-supportsInterface}.
944      */
945     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
946         return interfaceId == type(IERC165).interfaceId;
947     }
948 }
949 
950 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
951 
952 
953 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 
958 /**
959  * @dev Required interface of an ERC721 compliant contract.
960  */
961 interface IERC721 is IERC165 {
962     /**
963      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
964      */
965     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
966 
967     /**
968      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
969      */
970     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
971 
972     /**
973      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
974      */
975     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
976 
977     /**
978      * @dev Returns the number of tokens in ``owner``'s account.
979      */
980     function balanceOf(address owner) external view returns (uint256 balance);
981 
982     /**
983      * @dev Returns the owner of the `tokenId` token.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      */
989     function ownerOf(uint256 tokenId) external view returns (address owner);
990 
991     /**
992      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
993      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
994      *
995      * Requirements:
996      *
997      * - `from` cannot be the zero address.
998      * - `to` cannot be the zero address.
999      * - `tokenId` token must exist and be owned by `from`.
1000      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) external;
1010 
1011     /**
1012      * @dev Transfers `tokenId` token from `from` to `to`.
1013      *
1014      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1015      *
1016      * Requirements:
1017      *
1018      * - `from` cannot be the zero address.
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must be owned by `from`.
1021      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function transferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) external;
1030 
1031     /**
1032      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1033      * The approval is cleared when the token is transferred.
1034      *
1035      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1036      *
1037      * Requirements:
1038      *
1039      * - The caller must own the token or be an approved operator.
1040      * - `tokenId` must exist.
1041      *
1042      * Emits an {Approval} event.
1043      */
1044     function approve(address to, uint256 tokenId) external;
1045 
1046     /**
1047      * @dev Returns the account approved for `tokenId` token.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must exist.
1052      */
1053     function getApproved(uint256 tokenId) external view returns (address operator);
1054 
1055     /**
1056      * @dev Approve or remove `operator` as an operator for the caller.
1057      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1058      *
1059      * Requirements:
1060      *
1061      * - The `operator` cannot be the caller.
1062      *
1063      * Emits an {ApprovalForAll} event.
1064      */
1065     function setApprovalForAll(address operator, bool _approved) external;
1066 
1067     /**
1068      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1069      *
1070      * See {setApprovalForAll}
1071      */
1072     function isApprovedForAll(address owner, address operator) external view returns (bool);
1073 
1074     /**
1075      * @dev Safely transfers `tokenId` token from `from` to `to`.
1076      *
1077      * Requirements:
1078      *
1079      * - `from` cannot be the zero address.
1080      * - `to` cannot be the zero address.
1081      * - `tokenId` token must exist and be owned by `from`.
1082      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1083      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function safeTransferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes calldata data
1092     ) external;
1093 }
1094 
1095 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1096 
1097 
1098 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 
1103 /**
1104  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1105  * @dev See https://eips.ethereum.org/EIPS/eip-721
1106  */
1107 interface IERC721Enumerable is IERC721 {
1108     /**
1109      * @dev Returns the total amount of tokens stored by the contract.
1110      */
1111     function totalSupply() external view returns (uint256);
1112 
1113     /**
1114      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1115      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1116      */
1117     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1118 
1119     /**
1120      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1121      * Use along with {totalSupply} to enumerate all tokens.
1122      */
1123     function tokenByIndex(uint256 index) external view returns (uint256);
1124 }
1125 
1126 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1127 
1128 
1129 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 
1134 /**
1135  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1136  * @dev See https://eips.ethereum.org/EIPS/eip-721
1137  */
1138 interface IERC721Metadata is IERC721 {
1139     /**
1140      * @dev Returns the token collection name.
1141      */
1142     function name() external view returns (string memory);
1143 
1144     /**
1145      * @dev Returns the token collection symbol.
1146      */
1147     function symbol() external view returns (string memory);
1148 
1149     /**
1150      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1151      */
1152     function tokenURI(uint256 tokenId) external view returns (string memory);
1153 }
1154 
1155 // File: contracts/ERC721A.sol
1156 
1157 
1158 
1159 pragma solidity ^0.8.0;
1160 
1161 
1162 
1163 
1164 
1165 
1166 
1167 
1168 
1169 /**
1170  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1171  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1172  *
1173  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1174  *
1175  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1176  *
1177  * Does not support burning tokens to address(0).
1178  */
1179 contract ERC721A is
1180   Context,
1181   ERC165,
1182   IERC721,
1183   IERC721Metadata,
1184   IERC721Enumerable
1185 {
1186   using Address for address;
1187   using Strings for uint256;
1188 
1189   struct TokenOwnership {
1190     address addr;
1191     uint64 startTimestamp;
1192   }
1193 
1194   struct AddressData {
1195     uint128 balance;
1196     uint128 numberMinted;
1197   }
1198 
1199   uint256 private currentIndex = 0;
1200 
1201   uint256 internal immutable collectionSize;
1202   uint256 internal immutable maxBatchSize;
1203 
1204   // Token name
1205   string private _name;
1206 
1207   // Token symbol
1208   string private _symbol;
1209 
1210   // Mapping from token ID to ownership details
1211   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1212   mapping(uint256 => TokenOwnership) private _ownerships;
1213 
1214   // Mapping owner address to address data
1215   mapping(address => AddressData) private _addressData;
1216 
1217   // Mapping from token ID to approved address
1218   mapping(uint256 => address) private _tokenApprovals;
1219 
1220   // Mapping from owner to operator approvals
1221   mapping(address => mapping(address => bool)) private _operatorApprovals;
1222 
1223   /**
1224    * @dev
1225    * `maxBatchSize` refers to how much a minter can mint at a time.
1226    * `collectionSize_` refers to how many tokens are in the collection.
1227    */
1228   constructor(
1229     string memory name_,
1230     string memory symbol_,
1231     uint256 maxBatchSize_,
1232     uint256 collectionSize_
1233   ) {
1234     require(
1235       collectionSize_ > 0,
1236       "ERC721A: collection must have a nonzero supply"
1237     );
1238     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1239     _name = name_;
1240     _symbol = symbol_;
1241     maxBatchSize = maxBatchSize_;
1242     collectionSize = collectionSize_;
1243   }
1244 
1245   /**
1246    * @dev See {IERC721Enumerable-totalSupply}.
1247    */
1248   function totalSupply() public view override returns (uint256) {
1249     return currentIndex;
1250   }
1251 
1252   /**
1253    * @dev See {IERC721Enumerable-tokenByIndex}.
1254    */
1255   function tokenByIndex(uint256 index) public view override returns (uint256) {
1256     require(index < totalSupply(), "ERC721A: global index out of bounds");
1257     return index;
1258   }
1259 
1260   /**
1261    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1262    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1263    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1264    */
1265   function tokenOfOwnerByIndex(address owner, uint256 index)
1266     public
1267     view
1268     override
1269     returns (uint256)
1270   {
1271     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1272     uint256 numMintedSoFar = totalSupply();
1273     uint256 tokenIdsIdx = 0;
1274     address currOwnershipAddr = address(0);
1275     for (uint256 i = 0; i < numMintedSoFar; i++) {
1276       TokenOwnership memory ownership = _ownerships[i];
1277       if (ownership.addr != address(0)) {
1278         currOwnershipAddr = ownership.addr;
1279       }
1280       if (currOwnershipAddr == owner) {
1281         if (tokenIdsIdx == index) {
1282           return i;
1283         }
1284         tokenIdsIdx++;
1285       }
1286     }
1287     revert("ERC721A: unable to get token of owner by index");
1288   }
1289 
1290   /**
1291    * @dev See {IERC165-supportsInterface}.
1292    */
1293   function supportsInterface(bytes4 interfaceId)
1294     public
1295     view
1296     virtual
1297     override(ERC165, IERC165)
1298     returns (bool)
1299   {
1300     return
1301       interfaceId == type(IERC721).interfaceId ||
1302       interfaceId == type(IERC721Metadata).interfaceId ||
1303       interfaceId == type(IERC721Enumerable).interfaceId ||
1304       super.supportsInterface(interfaceId);
1305   }
1306 
1307   /**
1308    * @dev See {IERC721-balanceOf}.
1309    */
1310   function balanceOf(address owner) public view override returns (uint256) {
1311     require(owner != address(0), "ERC721A: balance query for the zero address");
1312     return uint256(_addressData[owner].balance);
1313   }
1314 
1315   function _numberMinted(address owner) internal view returns (uint256) {
1316     require(
1317       owner != address(0),
1318       "ERC721A: number minted query for the zero address"
1319     );
1320     return uint256(_addressData[owner].numberMinted);
1321   }
1322 
1323   function ownershipOf(uint256 tokenId)
1324     internal
1325     view
1326     returns (TokenOwnership memory)
1327   {
1328     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1329 
1330     uint256 lowestTokenToCheck;
1331     if (tokenId >= maxBatchSize) {
1332       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1333     }
1334 
1335     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1336       TokenOwnership memory ownership = _ownerships[curr];
1337       if (ownership.addr != address(0)) {
1338         return ownership;
1339       }
1340     }
1341 
1342     revert("ERC721A: unable to determine the owner of token");
1343   }
1344 
1345   /**
1346    * @dev See {IERC721-ownerOf}.
1347    */
1348   function ownerOf(uint256 tokenId) public view override returns (address) {
1349     return ownershipOf(tokenId).addr;
1350   }
1351 
1352   /**
1353    * @dev See {IERC721Metadata-name}.
1354    */
1355   function name() public view virtual override returns (string memory) {
1356     return _name;
1357   }
1358 
1359   /**
1360    * @dev See {IERC721Metadata-symbol}.
1361    */
1362   function symbol() public view virtual override returns (string memory) {
1363     return _symbol;
1364   }
1365 
1366   /**
1367    * @dev See {IERC721Metadata-tokenURI}.
1368    */
1369   function tokenURI(uint256 tokenId)
1370     public
1371     view
1372     virtual
1373     override
1374     returns (string memory)
1375   {
1376     require(
1377       _exists(tokenId),
1378       "ERC721Metadata: URI query for nonexistent token"
1379     );
1380 
1381     string memory baseURI = _baseURI();
1382     return
1383       bytes(baseURI).length > 0
1384         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1385         : "";
1386   }
1387 
1388   /**
1389    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1390    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1391    * by default, can be overriden in child contracts.
1392    */
1393   function _baseURI() internal view virtual returns (string memory) {
1394     return "";
1395   }
1396 
1397   /**
1398    * @dev See {IERC721-approve}.
1399    */
1400   function approve(address to, uint256 tokenId) public override {
1401     address owner = ERC721A.ownerOf(tokenId);
1402     require(to != owner, "ERC721A: approval to current owner");
1403 
1404     require(
1405       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1406       "ERC721A: approve caller is not owner nor approved for all"
1407     );
1408 
1409     _approve(to, tokenId, owner);
1410   }
1411 
1412   /**
1413    * @dev See {IERC721-getApproved}.
1414    */
1415   function getApproved(uint256 tokenId) public view override returns (address) {
1416     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1417 
1418     return _tokenApprovals[tokenId];
1419   }
1420 
1421   /**
1422    * @dev See {IERC721-setApprovalForAll}.
1423    */
1424   function setApprovalForAll(address operator, bool approved) public override {
1425     require(operator != _msgSender(), "ERC721A: approve to caller");
1426 
1427     _operatorApprovals[_msgSender()][operator] = approved;
1428     emit ApprovalForAll(_msgSender(), operator, approved);
1429   }
1430 
1431   /**
1432    * @dev See {IERC721-isApprovedForAll}.
1433    */
1434   function isApprovedForAll(address owner, address operator)
1435     public
1436     view
1437     virtual
1438     override
1439     returns (bool)
1440   {
1441     return _operatorApprovals[owner][operator];
1442   }
1443 
1444   /**
1445    * @dev See {IERC721-transferFrom}.
1446    */
1447   function transferFrom(
1448     address from,
1449     address to,
1450     uint256 tokenId
1451   ) public override {
1452     _transfer(from, to, tokenId);
1453   }
1454 
1455   /**
1456    * @dev See {IERC721-safeTransferFrom}.
1457    */
1458   function safeTransferFrom(
1459     address from,
1460     address to,
1461     uint256 tokenId
1462   ) public override {
1463     safeTransferFrom(from, to, tokenId, "");
1464   }
1465 
1466   /**
1467    * @dev See {IERC721-safeTransferFrom}.
1468    */
1469   function safeTransferFrom(
1470     address from,
1471     address to,
1472     uint256 tokenId,
1473     bytes memory _data
1474   ) public override {
1475     _transfer(from, to, tokenId);
1476     require(
1477       _checkOnERC721Received(from, to, tokenId, _data),
1478       "ERC721A: transfer to non ERC721Receiver implementer"
1479     );
1480   }
1481 
1482   /**
1483    * @dev Returns whether `tokenId` exists.
1484    *
1485    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1486    *
1487    * Tokens start existing when they are minted (`_mint`),
1488    */
1489   function _exists(uint256 tokenId) internal view returns (bool) {
1490     return tokenId < currentIndex;
1491   }
1492 
1493   function _safeMint(address to, uint256 quantity) internal {
1494     _safeMint(to, quantity, "");
1495   }
1496 
1497   /**
1498    * @dev Mints `quantity` tokens and transfers them to `to`.
1499    *
1500    * Requirements:
1501    *
1502    * - there must be `quantity` tokens remaining unminted in the total collection.
1503    * - `to` cannot be the zero address.
1504    * - `quantity` cannot be larger than the max batch size.
1505    *
1506    * Emits a {Transfer} event.
1507    */
1508   function _safeMint(
1509     address to,
1510     uint256 quantity,
1511     bytes memory _data
1512   ) internal {
1513     uint256 startTokenId = currentIndex;
1514     require(to != address(0), "ERC721A: mint to the zero address");
1515     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1516     require(!_exists(startTokenId), "ERC721A: token already minted");
1517     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1518 
1519     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1520 
1521     AddressData memory addressData = _addressData[to];
1522     _addressData[to] = AddressData(
1523       addressData.balance + uint128(quantity),
1524       addressData.numberMinted + uint128(quantity)
1525     );
1526     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1527 
1528     uint256 updatedIndex = startTokenId;
1529 
1530     for (uint256 i = 0; i < quantity; i++) {
1531       emit Transfer(address(0), to, updatedIndex);
1532       require(
1533         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1534         "ERC721A: transfer to non ERC721Receiver implementer"
1535       );
1536       updatedIndex++;
1537     }
1538 
1539     currentIndex = updatedIndex;
1540     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1541   }
1542 
1543   /**
1544    * @dev Transfers `tokenId` from `from` to `to`.
1545    *
1546    * Requirements:
1547    *
1548    * - `to` cannot be the zero address.
1549    * - `tokenId` token must be owned by `from`.
1550    *
1551    * Emits a {Transfer} event.
1552    */
1553   function _transfer(
1554     address from,
1555     address to,
1556     uint256 tokenId
1557   ) private {
1558     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1559 
1560     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1561       getApproved(tokenId) == _msgSender() ||
1562       isApprovedForAll(prevOwnership.addr, _msgSender()));
1563 
1564     require(
1565       isApprovedOrOwner,
1566       "ERC721A: transfer caller is not owner nor approved"
1567     );
1568 
1569     require(
1570       prevOwnership.addr == from,
1571       "ERC721A: transfer from incorrect owner"
1572     );
1573     require(to != address(0), "ERC721A: transfer to the zero address");
1574 
1575     _beforeTokenTransfers(from, to, tokenId, 1);
1576 
1577     // Clear approvals from the previous owner
1578     _approve(address(0), tokenId, prevOwnership.addr);
1579 
1580     _addressData[from].balance -= 1;
1581     _addressData[to].balance += 1;
1582     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1583 
1584     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1585     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1586     uint256 nextTokenId = tokenId + 1;
1587     if (_ownerships[nextTokenId].addr == address(0)) {
1588       if (_exists(nextTokenId)) {
1589         _ownerships[nextTokenId] = TokenOwnership(
1590           prevOwnership.addr,
1591           prevOwnership.startTimestamp
1592         );
1593       }
1594     }
1595 
1596     emit Transfer(from, to, tokenId);
1597     _afterTokenTransfers(from, to, tokenId, 1);
1598   }
1599 
1600   /**
1601    * @dev Approve `to` to operate on `tokenId`
1602    *
1603    * Emits a {Approval} event.
1604    */
1605   function _approve(
1606     address to,
1607     uint256 tokenId,
1608     address owner
1609   ) private {
1610     _tokenApprovals[tokenId] = to;
1611     emit Approval(owner, to, tokenId);
1612   }
1613 
1614   uint256 public nextOwnerToExplicitlySet = 0;
1615 
1616   /**
1617    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1618    */
1619   function _setOwnersExplicit(uint256 quantity) internal {
1620     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1621     require(quantity > 0, "quantity must be nonzero");
1622     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1623     if (endIndex > collectionSize - 1) {
1624       endIndex = collectionSize - 1;
1625     }
1626     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1627     require(_exists(endIndex), "not enough minted yet for this cleanup");
1628     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1629       if (_ownerships[i].addr == address(0)) {
1630         TokenOwnership memory ownership = ownershipOf(i);
1631         _ownerships[i] = TokenOwnership(
1632           ownership.addr,
1633           ownership.startTimestamp
1634         );
1635       }
1636     }
1637     nextOwnerToExplicitlySet = endIndex + 1;
1638   }
1639 
1640   /**
1641    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1642    * The call is not executed if the target address is not a contract.
1643    *
1644    * @param from address representing the previous owner of the given token ID
1645    * @param to target address that will receive the tokens
1646    * @param tokenId uint256 ID of the token to be transferred
1647    * @param _data bytes optional data to send along with the call
1648    * @return bool whether the call correctly returned the expected magic value
1649    */
1650   function _checkOnERC721Received(
1651     address from,
1652     address to,
1653     uint256 tokenId,
1654     bytes memory _data
1655   ) private returns (bool) {
1656     if (to.isContract()) {
1657       try
1658         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1659       returns (bytes4 retval) {
1660         return retval == IERC721Receiver(to).onERC721Received.selector;
1661       } catch (bytes memory reason) {
1662         if (reason.length == 0) {
1663           revert("ERC721A: transfer to non ERC721Receiver implementer");
1664         } else {
1665           assembly {
1666             revert(add(32, reason), mload(reason))
1667           }
1668         }
1669       }
1670     } else {
1671       return true;
1672     }
1673   }
1674 
1675   /**
1676    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1677    *
1678    * startTokenId - the first token id to be transferred
1679    * quantity - the amount to be transferred
1680    *
1681    * Calling conditions:
1682    *
1683    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1684    * transferred to `to`.
1685    * - When `from` is zero, `tokenId` will be minted for `to`.
1686    */
1687   function _beforeTokenTransfers(
1688     address from,
1689     address to,
1690     uint256 startTokenId,
1691     uint256 quantity
1692   ) internal virtual {}
1693 
1694   /**
1695    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1696    * minting.
1697    *
1698    * startTokenId - the first token id to be transferred
1699    * quantity - the amount to be transferred
1700    *
1701    * Calling conditions:
1702    *
1703    * - when `from` and `to` are both non-zero.
1704    * - `from` and `to` are never both zero.
1705    */
1706   function _afterTokenTransfers(
1707     address from,
1708     address to,
1709     uint256 startTokenId,
1710     uint256 quantity
1711   ) internal virtual {}
1712 }
1713 
1714 //SPDX-License-Identifier: MIT
1715 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1716 
1717 pragma solidity ^0.8.0;
1718 
1719 
1720 
1721 
1722 
1723 
1724 
1725 
1726 
1727 contract UnfoldedByBrunoCerasi is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1728     using Counters for Counters.Counter;
1729     using Strings for uint256;
1730 
1731     Counters.Counter private tokenCounter;
1732 
1733     string private baseURI = "ipfs://QmPRU1tbXjFaUdCZZgLzC3WZeVZTkwoPbLVCx2i7XDyKxg/";
1734     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1735     bool private isOpenSeaProxyActive = true;
1736 
1737     uint256 public constant MAX_MINTS_PER_TX = 1;
1738     uint256 public maxSupply = 777;
1739 
1740     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
1741     uint256 public NUM_FREE_MINTS = 333;
1742     bool public isPublicSaleActive = true;
1743 
1744 
1745 
1746 
1747     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1748 
1749     modifier publicSaleActive() {
1750         require(isPublicSaleActive, "Public sale is not open");
1751         _;
1752     }
1753 
1754 
1755 
1756     modifier maxMintsPerTX(uint256 numberOfTokens) {
1757         require(
1758             numberOfTokens <= MAX_MINTS_PER_TX,
1759             "Max mints per transaction exceeded"
1760         );
1761         _;
1762     }
1763 
1764     modifier canMintNFTs(uint256 numberOfTokens) {
1765         require(
1766             totalSupply() + numberOfTokens <=
1767                 maxSupply,
1768             "Not enough mints remaining to mint"
1769         );
1770         _;
1771     }
1772 
1773     modifier freeMintsAvailable() {
1774         require(
1775             totalSupply() <=
1776                 NUM_FREE_MINTS,
1777             "Not enough free mints remain"
1778         );
1779         _;
1780     }
1781 
1782 
1783     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1784         if(totalSupply()>NUM_FREE_MINTS){
1785         require(
1786             (price * numberOfTokens) == msg.value,
1787             "Incorrect ETH value sent"
1788         );
1789         }
1790         _;
1791     }
1792 
1793 
1794     constructor(
1795     ) ERC721A("UnfoldedByBrunoCerasi", "UNFOLDED", 100, maxSupply) {
1796     }
1797 
1798     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1799 
1800     function mint(uint256 numberOfTokens)
1801         external
1802         payable
1803         nonReentrant
1804         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1805         publicSaleActive
1806         canMintNFTs(numberOfTokens)
1807         maxMintsPerTX(numberOfTokens)
1808     {
1809         _safeMint(msg.sender, numberOfTokens);
1810     }
1811 
1812 
1813     //A simple free mint function to avoid confusion
1814     //The normal mint function with a cost of 0 would work too
1815 
1816     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1817 
1818     function getBaseURI() external view returns (string memory) {
1819         return baseURI;
1820     }
1821 
1822     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1823 
1824     function setBaseURI(string memory _baseURI) external onlyOwner {
1825         baseURI = _baseURI;
1826     }
1827 
1828     // function to disable gasless listings for security in case
1829     // opensea ever shuts down or is compromised
1830     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1831         external
1832         onlyOwner
1833     {
1834         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1835     }
1836 
1837     function setIsPublicSaleActive(bool _isPublicSaleActive)
1838         external
1839         onlyOwner
1840     {
1841         isPublicSaleActive = _isPublicSaleActive;
1842     }
1843 
1844 
1845     function setNumFreeMints(uint256 _numfreemints)
1846         external
1847         onlyOwner
1848     {
1849         NUM_FREE_MINTS = _numfreemints;
1850     }
1851 
1852     function setLowerMaxSupply(uint256 _newMax)
1853         external
1854         onlyOwner
1855     {
1856         maxSupply = _newMax;
1857     }
1858 
1859 
1860     function withdraw() public onlyOwner {
1861         uint256 balance = address(this).balance;
1862         payable(msg.sender).transfer(balance);
1863     }
1864 
1865     function withdrawTokens(IERC20 token) public onlyOwner {
1866         uint256 balance = token.balanceOf(address(this));
1867         token.transfer(msg.sender, balance);
1868     }
1869 
1870     function airdrop(address to, uint count) external onlyOwner {
1871 		require(
1872 			totalSupply() + count <= maxSupply,
1873 			'Exceeds max supply'
1874 		);
1875 		_safeMint(to, count);
1876 	}
1877 
1878 
1879 
1880     // ============ SUPPORTING FUNCTIONS ============
1881 
1882     function nextTokenId() private returns (uint256) {
1883         tokenCounter.increment();
1884         return tokenCounter.current();
1885     }
1886 
1887     // ============ FUNCTION OVERRIDES ============
1888 
1889     function supportsInterface(bytes4 interfaceId)
1890         public
1891         view
1892         virtual
1893         override(ERC721A, IERC165)
1894         returns (bool)
1895     {
1896         return
1897             interfaceId == type(IERC2981).interfaceId ||
1898             super.supportsInterface(interfaceId);
1899     }
1900 
1901     /**
1902      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1903      */
1904     function isApprovedForAll(address owner, address operator)
1905         public
1906         view
1907         override
1908         returns (bool)
1909     {
1910         // Get a reference to OpenSea's proxy registry contract by instantiating
1911         // the contract using the already existing address.
1912         ProxyRegistry proxyRegistry = ProxyRegistry(
1913             openSeaProxyRegistryAddress
1914         );
1915         if (
1916             isOpenSeaProxyActive &&
1917             address(proxyRegistry.proxies(owner)) == operator
1918         ) {
1919             return true;
1920         }
1921 
1922         return super.isApprovedForAll(owner, operator);
1923     }
1924 
1925     /**
1926      * @dev See {IERC721Metadata-tokenURI}.
1927      */
1928     function tokenURI(uint256 tokenId)
1929         public
1930         view
1931         virtual
1932         override
1933         returns (string memory)
1934     {
1935         require(_exists(tokenId), "Nonexistent token");
1936 
1937         return
1938             //string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1939             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ""));
1940     }
1941 
1942     /**
1943      * @dev See {IERC165-royaltyInfo}.
1944      */
1945     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1946         external
1947         view
1948         override
1949         returns (address receiver, uint256 royaltyAmount)
1950     {
1951         require(_exists(tokenId), "Nonexistent token");
1952 
1953         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1954     }
1955 }
1956 
1957 // These contract definitions are used to create a reference to the OpenSea
1958 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1959 contract OwnableDelegateProxy {
1960 
1961 }
1962 
1963 contract ProxyRegistry {
1964     mapping(address => OwnableDelegateProxy) public proxies;
1965 }