1 /*
2 ascii 
3 */
4 pragma solidity ^0.8.0;
5 
6 // CAUTION
7 // This version of SafeMath should only be used with Solidity 0.8 or later,
8 // because it relies on the compiler's built in overflow checks.
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations.
12  *
13  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
14  * now has built in overflow checking.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, with an overflow flag.
19      *
20      * _Available since v3.4._
21      */
22     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {
24             uint256 c = a + b;
25             if (c < a) return (false, 0);
26             return (true, c);
27         }
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             if (b > a) return (false, 0);
38             return (true, a - b);
39         }
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50             // benefit is lost if 'b' is also tested.
51             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             if (b == 0) return (false, 0);
67             return (true, a / b);
68         }
69     }
70 
71     /**
72      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a % b);
80         }
81     }
82 
83     /**
84      * @dev Returns the addition of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `+` operator.
88      *
89      * Requirements:
90      *
91      * - Addition cannot overflow.
92      */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a + b;
95     }
96 
97     /**
98      * @dev Returns the subtraction of two unsigned integers, reverting on
99      * overflow (when the result is negative).
100      *
101      * Counterpart to Solidity's `-` operator.
102      *
103      * Requirements:
104      *
105      * - Subtraction cannot overflow.
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a - b;
109     }
110 
111     /**
112      * @dev Returns the multiplication of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `*` operator.
116      *
117      * Requirements:
118      *
119      * - Multiplication cannot overflow.
120      */
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a * b;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator.
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a / b;
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * reverting when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a % b;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * CAUTION: This function is deprecated because it requires allocating memory for the error
160      * message unnecessarily. For custom revert reasons use {trySub}.
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         unchecked {
174             require(b <= a, errorMessage);
175             return a - b;
176         }
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         unchecked {
197             require(b > 0, errorMessage);
198             return a / b;
199         }
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * reverting with custom message when dividing by zero.
205      *
206      * CAUTION: This function is deprecated because it requires allocating memory for the error
207      * message unnecessarily. For custom revert reasons use {tryMod}.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b > 0, errorMessage);
224             return a % b;
225         }
226     }
227 }
228 
229 // File: @openzeppelin/contracts/utils/Counters.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @title Counters
238  * @author Matt Condon (@shrugs)
239  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
240  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
241  *
242  * Include with `using Counters for Counters.Counter;`
243  */
244 library Counters {
245     struct Counter {
246         // This variable should never be directly accessed by users of the library: interactions must be restricted to
247         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
248         // this feature: see https://github.com/ethereum/solidity/issues/4637
249         uint256 _value; // default: 0
250     }
251 
252     function current(Counter storage counter) internal view returns (uint256) {
253         return counter._value;
254     }
255 
256     function increment(Counter storage counter) internal {
257         unchecked {
258             counter._value += 1;
259         }
260     }
261 
262     function decrement(Counter storage counter) internal {
263         uint256 value = counter._value;
264         require(value > 0, "Counter: decrement overflow");
265         unchecked {
266             counter._value = value - 1;
267         }
268     }
269 
270     function reset(Counter storage counter) internal {
271         counter._value = 0;
272     }
273 }
274 
275 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Contract module that helps prevent reentrant calls to a function.
284  *
285  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
286  * available, which can be applied to functions to make sure there are no nested
287  * (reentrant) calls to them.
288  *
289  * Note that because there is a single `nonReentrant` guard, functions marked as
290  * `nonReentrant` may not call one another. This can be worked around by making
291  * those functions `private`, and then adding `external` `nonReentrant` entry
292  * points to them.
293  *
294  * TIP: If you would like to learn more about reentrancy and alternative ways
295  * to protect against it, check out our blog post
296  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
297  */
298 abstract contract ReentrancyGuard {
299     // Booleans are more expensive than uint256 or any type that takes up a full
300     // word because each write operation emits an extra SLOAD to first read the
301     // slot's contents, replace the bits taken up by the boolean, and then write
302     // back. This is the compiler's defense against contract upgrades and
303     // pointer aliasing, and it cannot be disabled.
304 
305     // The values being non-zero value makes deployment a bit more expensive,
306     // but in exchange the refund on every call to nonReentrant will be lower in
307     // amount. Since refunds are capped to a percentage of the total
308     // transaction's gas, it is best to keep them low in cases like this one, to
309     // increase the likelihood of the full refund coming into effect.
310     uint256 private constant _NOT_ENTERED = 1;
311     uint256 private constant _ENTERED = 2;
312 
313     uint256 private _status;
314 
315     constructor() {
316         _status = _NOT_ENTERED;
317     }
318 
319     /**
320      * @dev Prevents a contract from calling itself, directly or indirectly.
321      * Calling a `nonReentrant` function from another `nonReentrant`
322      * function is not supported. It is possible to prevent this from happening
323      * by making the `nonReentrant` function external, and making it call a
324      * `private` function that does the actual work.
325      */
326     modifier nonReentrant() {
327         // On the first call to nonReentrant, _notEntered will be true
328         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
329 
330         // Any calls to nonReentrant after this point will fail
331         _status = _ENTERED;
332 
333         _;
334 
335         // By storing the original value once again, a refund is triggered (see
336         // https://eips.ethereum.org/EIPS/eip-2200)
337         _status = _NOT_ENTERED;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
342 
343 
344 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @dev Interface of the ERC20 standard as defined in the EIP.
350  */
351 interface IERC20 {
352     /**
353      * @dev Returns the amount of tokens in existence.
354      */
355     function totalSupply() external view returns (uint256);
356 
357     /**
358      * @dev Returns the amount of tokens owned by `account`.
359      */
360     function balanceOf(address account) external view returns (uint256);
361 
362     /**
363      * @dev Moves `amount` tokens from the caller's account to `recipient`.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * Emits a {Transfer} event.
368      */
369     function transfer(address recipient, uint256 amount) external returns (bool);
370 
371     /**
372      * @dev Returns the remaining number of tokens that `spender` will be
373      * allowed to spend on behalf of `owner` through {transferFrom}. This is
374      * zero by default.
375      *
376      * This value changes when {approve} or {transferFrom} are called.
377      */
378     function allowance(address owner, address spender) external view returns (uint256);
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * IMPORTANT: Beware that changing an allowance with this method brings the risk
386      * that someone may use both the old and the new allowance by unfortunate
387      * transaction ordering. One possible solution to mitigate this race
388      * condition is to first reduce the spender's allowance to 0 and set the
389      * desired value afterwards:
390      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
391      *
392      * Emits an {Approval} event.
393      */
394     function approve(address spender, uint256 amount) external returns (bool);
395 
396     /**
397      * @dev Moves `amount` tokens from `sender` to `recipient` using the
398      * allowance mechanism. `amount` is then deducted from the caller's
399      * allowance.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transferFrom(
406         address sender,
407         address recipient,
408         uint256 amount
409     ) external returns (bool);
410 
411     /**
412      * @dev Emitted when `value` tokens are moved from one account (`from`) to
413      * another (`to`).
414      *
415      * Note that `value` may be zero.
416      */
417     event Transfer(address indexed from, address indexed to, uint256 value);
418 
419     /**
420      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
421      * a call to {approve}. `value` is the new allowance.
422      */
423     event Approval(address indexed owner, address indexed spender, uint256 value);
424 }
425 
426 // File: @openzeppelin/contracts/interfaces/IERC20.sol
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 
434 // File: @openzeppelin/contracts/utils/Strings.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev String operations.
443  */
444 library Strings {
445     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
446 
447     /**
448      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
449      */
450     function toString(uint256 value) internal pure returns (string memory) {
451         // Inspired by OraclizeAPI's implementation - MIT licence
452         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
453 
454         if (value == 0) {
455             return "0";
456         }
457         uint256 temp = value;
458         uint256 digits;
459         while (temp != 0) {
460             digits++;
461             temp /= 10;
462         }
463         bytes memory buffer = new bytes(digits);
464         while (value != 0) {
465             digits -= 1;
466             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
467             value /= 10;
468         }
469         return string(buffer);
470     }
471 
472     /**
473      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
474      */
475     function toHexString(uint256 value) internal pure returns (string memory) {
476         if (value == 0) {
477             return "0x00";
478         }
479         uint256 temp = value;
480         uint256 length = 0;
481         while (temp != 0) {
482             length++;
483             temp >>= 8;
484         }
485         return toHexString(value, length);
486     }
487 
488     /**
489      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
490      */
491     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
492         bytes memory buffer = new bytes(2 * length + 2);
493         buffer[0] = "0";
494         buffer[1] = "x";
495         for (uint256 i = 2 * length + 1; i > 1; --i) {
496             buffer[i] = _HEX_SYMBOLS[value & 0xf];
497             value >>= 4;
498         }
499         require(value == 0, "Strings: hex length insufficient");
500         return string(buffer);
501     }
502 }
503 
504 // File: @openzeppelin/contracts/utils/Context.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 /**
512  * @dev Provides information about the current execution context, including the
513  * sender of the transaction and its data. While these are generally available
514  * via msg.sender and msg.data, they should not be accessed in such a direct
515  * manner, since when dealing with meta-transactions the account sending and
516  * paying for execution may not be the actual sender (as far as an application
517  * is concerned).
518  *
519  * This contract is only required for intermediate, library-like contracts.
520  */
521 abstract contract Context {
522     function _msgSender() internal view virtual returns (address) {
523         return msg.sender;
524     }
525 
526     function _msgData() internal view virtual returns (bytes calldata) {
527         return msg.data;
528     }
529 }
530 
531 // File: @openzeppelin/contracts/access/Ownable.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Contract module which provides a basic access control mechanism, where
541  * there is an account (an owner) that can be granted exclusive access to
542  * specific functions.
543  *
544  * By default, the owner account will be the one that deploys the contract. This
545  * can later be changed with {transferOwnership}.
546  *
547  * This module is used through inheritance. It will make available the modifier
548  * `onlyOwner`, which can be applied to your functions to restrict their use to
549  * the owner.
550  */
551 abstract contract Ownable is Context {
552     address private _owner;
553 
554     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
555 
556     /**
557      * @dev Initializes the contract setting the deployer as the initial owner.
558      */
559     constructor() {
560         _transferOwnership(_msgSender());
561     }
562 
563     /**
564      * @dev Returns the address of the current owner.
565      */
566     function owner() public view virtual returns (address) {
567         return _owner;
568     }
569 
570     /**
571      * @dev Throws if called by any account other than the owner.
572      */
573     modifier onlyOwner() {
574         require(owner() == _msgSender(), "Ownable: caller is not the owner");
575         _;
576     }
577 
578     /**
579      * @dev Leaves the contract without owner. It will not be possible to call
580      * `onlyOwner` functions anymore. Can only be called by the current owner.
581      *
582      * NOTE: Renouncing ownership will leave the contract without an owner,
583      * thereby removing any functionality that is only available to the owner.
584      */
585     function renounceOwnership() public virtual onlyOwner {
586         _transferOwnership(address(0));
587     }
588 
589     /**
590      * @dev Transfers ownership of the contract to a new account (`newOwner`).
591      * Can only be called by the current owner.
592      */
593     function transferOwnership(address newOwner) public virtual onlyOwner {
594         require(newOwner != address(0), "Ownable: new owner is the zero address");
595         _transferOwnership(newOwner);
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Internal function without access restriction.
601      */
602     function _transferOwnership(address newOwner) internal virtual {
603         address oldOwner = _owner;
604         _owner = newOwner;
605         emit OwnershipTransferred(oldOwner, newOwner);
606     }
607 }
608 
609 // File: @openzeppelin/contracts/utils/Address.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev Collection of functions related to the address type
618  */
619 library Address {
620     /**
621      * @dev Returns true if `account` is a contract.
622      *
623      * [IMPORTANT]
624      * ====
625      * It is unsafe to assume that an address for which this function returns
626      * false is an externally-owned account (EOA) and not a contract.
627      *
628      * Among others, `isContract` will return false for the following
629      * types of addresses:
630      *
631      *  - an externally-owned account
632      *  - a contract in construction
633      *  - an address where a contract will be created
634      *  - an address where a contract lived, but was destroyed
635      * ====
636      */
637     function isContract(address account) internal view returns (bool) {
638         // This method relies on extcodesize, which returns 0 for contracts in
639         // construction, since the code is only stored at the end of the
640         // constructor execution.
641 
642         uint256 size;
643         assembly {
644             size := extcodesize(account)
645         }
646         return size > 0;
647     }
648 
649     /**
650      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
651      * `recipient`, forwarding all available gas and reverting on errors.
652      *
653      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
654      * of certain opcodes, possibly making contracts go over the 2300 gas limit
655      * imposed by `transfer`, making them unable to receive funds via
656      * `transfer`. {sendValue} removes this limitation.
657      *
658      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
659      *
660      * IMPORTANT: because control is transferred to `recipient`, care must be
661      * taken to not create reentrancy vulnerabilities. Consider using
662      * {ReentrancyGuard} or the
663      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
664      */
665     function sendValue(address payable recipient, uint256 amount) internal {
666         require(address(this).balance >= amount, "Address: insufficient balance");
667 
668         (bool success, ) = recipient.call{value: amount}("");
669         require(success, "Address: unable to send value, recipient may have reverted");
670     }
671 
672     /**
673      * @dev Performs a Solidity function call using a low level `call`. A
674      * plain `call` is an unsafe replacement for a function call: use this
675      * function instead.
676      *
677      * If `target` reverts with a revert reason, it is bubbled up by this
678      * function (like regular Solidity function calls).
679      *
680      * Returns the raw returned data. To convert to the expected return value,
681      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
682      *
683      * Requirements:
684      *
685      * - `target` must be a contract.
686      * - calling `target` with `data` must not revert.
687      *
688      * _Available since v3.1._
689      */
690     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
691         return functionCall(target, data, "Address: low-level call failed");
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
696      * `errorMessage` as a fallback revert reason when `target` reverts.
697      *
698      * _Available since v3.1._
699      */
700     function functionCall(
701         address target,
702         bytes memory data,
703         string memory errorMessage
704     ) internal returns (bytes memory) {
705         return functionCallWithValue(target, data, 0, errorMessage);
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
710      * but also transferring `value` wei to `target`.
711      *
712      * Requirements:
713      *
714      * - the calling contract must have an ETH balance of at least `value`.
715      * - the called Solidity function must be `payable`.
716      *
717      * _Available since v3.1._
718      */
719     function functionCallWithValue(
720         address target,
721         bytes memory data,
722         uint256 value
723     ) internal returns (bytes memory) {
724         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
729      * with `errorMessage` as a fallback revert reason when `target` reverts.
730      *
731      * _Available since v3.1._
732      */
733     function functionCallWithValue(
734         address target,
735         bytes memory data,
736         uint256 value,
737         string memory errorMessage
738     ) internal returns (bytes memory) {
739         require(address(this).balance >= value, "Address: insufficient balance for call");
740         require(isContract(target), "Address: call to non-contract");
741 
742         (bool success, bytes memory returndata) = target.call{value: value}(data);
743         return verifyCallResult(success, returndata, errorMessage);
744     }
745 
746     /**
747      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
748      * but performing a static call.
749      *
750      * _Available since v3.3._
751      */
752     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
753         return functionStaticCall(target, data, "Address: low-level static call failed");
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
758      * but performing a static call.
759      *
760      * _Available since v3.3._
761      */
762     function functionStaticCall(
763         address target,
764         bytes memory data,
765         string memory errorMessage
766     ) internal view returns (bytes memory) {
767         require(isContract(target), "Address: static call to non-contract");
768 
769         (bool success, bytes memory returndata) = target.staticcall(data);
770         return verifyCallResult(success, returndata, errorMessage);
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
775      * but performing a delegate call.
776      *
777      * _Available since v3.4._
778      */
779     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
780         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
785      * but performing a delegate call.
786      *
787      * _Available since v3.4._
788      */
789     function functionDelegateCall(
790         address target,
791         bytes memory data,
792         string memory errorMessage
793     ) internal returns (bytes memory) {
794         require(isContract(target), "Address: delegate call to non-contract");
795 
796         (bool success, bytes memory returndata) = target.delegatecall(data);
797         return verifyCallResult(success, returndata, errorMessage);
798     }
799 
800     /**
801      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
802      * revert reason using the provided one.
803      *
804      * _Available since v4.3._
805      */
806     function verifyCallResult(
807         bool success,
808         bytes memory returndata,
809         string memory errorMessage
810     ) internal pure returns (bytes memory) {
811         if (success) {
812             return returndata;
813         } else {
814             // Look for revert reason and bubble it up if present
815             if (returndata.length > 0) {
816                 // The easiest way to bubble the revert reason is using memory via assembly
817 
818                 assembly {
819                     let returndata_size := mload(returndata)
820                     revert(add(32, returndata), returndata_size)
821                 }
822             } else {
823                 revert(errorMessage);
824             }
825         }
826     }
827 }
828 
829 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
830 
831 
832 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
833 
834 pragma solidity ^0.8.0;
835 
836 /**
837  * @title ERC721 token receiver interface
838  * @dev Interface for any contract that wants to support safeTransfers
839  * from ERC721 asset contracts.
840  */
841 interface IERC721Receiver {
842     /**
843      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
844      * by `operator` from `from`, this function is called.
845      *
846      * It must return its Solidity selector to confirm the token transfer.
847      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
848      *
849      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
850      */
851     function onERC721Received(
852         address operator,
853         address from,
854         uint256 tokenId,
855         bytes calldata data
856     ) external returns (bytes4);
857 }
858 
859 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
860 
861 
862 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
863 
864 pragma solidity ^0.8.0;
865 
866 /**
867  * @dev Interface of the ERC165 standard, as defined in the
868  * https://eips.ethereum.org/EIPS/eip-165[EIP].
869  *
870  * Implementers can declare support of contract interfaces, which can then be
871  * queried by others ({ERC165Checker}).
872  *
873  * For an implementation, see {ERC165}.
874  */
875 interface IERC165 {
876     /**
877      * @dev Returns true if this contract implements the interface defined by
878      * `interfaceId`. See the corresponding
879      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
880      * to learn more about how these ids are created.
881      *
882      * This function call must use less than 30 000 gas.
883      */
884     function supportsInterface(bytes4 interfaceId) external view returns (bool);
885 }
886 
887 // File: @openzeppelin/contracts/interfaces/IERC165.sol
888 
889 
890 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
891 
892 pragma solidity ^0.8.0;
893 
894 
895 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
896 
897 
898 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 
903 /**
904  * @dev Interface for the NFT Royalty Standard
905  */
906 interface IERC2981 is IERC165 {
907     /**
908      * @dev Called with the sale price to determine how much royalty is owed and to whom.
909      * @param tokenId - the NFT asset queried for royalty information
910      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
911      * @return receiver - address of who should be sent the royalty payment
912      * @return royaltyAmount - the royalty payment amount for `salePrice`
913      */
914     function royaltyInfo(uint256 tokenId, uint256 salePrice)
915         external
916         view
917         returns (address receiver, uint256 royaltyAmount);
918 }
919 
920 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
921 
922 
923 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 
928 /**
929  * @dev Implementation of the {IERC165} interface.
930  *
931  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
932  * for the additional interface id that will be supported. For example:
933  *
934  * ```solidity
935  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
936  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
937  * }
938  * ```
939  *
940  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
941  */
942 abstract contract ERC165 is IERC165 {
943     /**
944      * @dev See {IERC165-supportsInterface}.
945      */
946     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
947         return interfaceId == type(IERC165).interfaceId;
948     }
949 }
950 
951 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
952 
953 
954 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
955 
956 pragma solidity ^0.8.0;
957 
958 
959 /**
960  * @dev Required interface of an ERC721 compliant contract.
961  */
962 interface IERC721 is IERC165 {
963     /**
964      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
965      */
966     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
967 
968     /**
969      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
970      */
971     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
972 
973     /**
974      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
975      */
976     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
977 
978     /**
979      * @dev Returns the number of tokens in ``owner``'s account.
980      */
981     function balanceOf(address owner) external view returns (uint256 balance);
982 
983     /**
984      * @dev Returns the owner of the `tokenId` token.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function ownerOf(uint256 tokenId) external view returns (address owner);
991 
992     /**
993      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
994      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
995      *
996      * Requirements:
997      *
998      * - `from` cannot be the zero address.
999      * - `to` cannot be the zero address.
1000      * - `tokenId` token must exist and be owned by `from`.
1001      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function safeTransferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) external;
1011 
1012     /**
1013      * @dev Transfers `tokenId` token from `from` to `to`.
1014      *
1015      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1016      *
1017      * Requirements:
1018      *
1019      * - `from` cannot be the zero address.
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must be owned by `from`.
1022      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function transferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) external;
1031 
1032     /**
1033      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1034      * The approval is cleared when the token is transferred.
1035      *
1036      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1037      *
1038      * Requirements:
1039      *
1040      * - The caller must own the token or be an approved operator.
1041      * - `tokenId` must exist.
1042      *
1043      * Emits an {Approval} event.
1044      */
1045     function approve(address to, uint256 tokenId) external;
1046 
1047     /**
1048      * @dev Returns the account approved for `tokenId` token.
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must exist.
1053      */
1054     function getApproved(uint256 tokenId) external view returns (address operator);
1055 
1056     /**
1057      * @dev Approve or remove `operator` as an operator for the caller.
1058      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1059      *
1060      * Requirements:
1061      *
1062      * - The `operator` cannot be the caller.
1063      *
1064      * Emits an {ApprovalForAll} event.
1065      */
1066     function setApprovalForAll(address operator, bool _approved) external;
1067 
1068     /**
1069      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1070      *
1071      * See {setApprovalForAll}
1072      */
1073     function isApprovedForAll(address owner, address operator) external view returns (bool);
1074 
1075     /**
1076      * @dev Safely transfers `tokenId` token from `from` to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `from` cannot be the zero address.
1081      * - `to` cannot be the zero address.
1082      * - `tokenId` token must exist and be owned by `from`.
1083      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1084      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function safeTransferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes calldata data
1093     ) external;
1094 }
1095 
1096 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1097 
1098 
1099 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 
1104 /**
1105  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1106  * @dev See https://eips.ethereum.org/EIPS/eip-721
1107  */
1108 interface IERC721Enumerable is IERC721 {
1109     /**
1110      * @dev Returns the total amount of tokens stored by the contract.
1111      */
1112     function totalSupply() external view returns (uint256);
1113 
1114     /**
1115      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1116      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1117      */
1118     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1119 
1120     /**
1121      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1122      * Use along with {totalSupply} to enumerate all tokens.
1123      */
1124     function tokenByIndex(uint256 index) external view returns (uint256);
1125 }
1126 
1127 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1128 
1129 
1130 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 /**
1136  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1137  * @dev See https://eips.ethereum.org/EIPS/eip-721
1138  */
1139 interface IERC721Metadata is IERC721 {
1140     /**
1141      * @dev Returns the token collection name.
1142      */
1143     function name() external view returns (string memory);
1144 
1145     /**
1146      * @dev Returns the token collection symbol.
1147      */
1148     function symbol() external view returns (string memory);
1149 
1150     /**
1151      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1152      */
1153     function tokenURI(uint256 tokenId) external view returns (string memory);
1154 }
1155 
1156 // File: contracts/ERC721A.sol
1157 
1158 
1159 
1160 pragma solidity ^0.8.0;
1161 
1162 
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 /**
1171  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1172  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1173  *
1174  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1175  *
1176  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1177  *
1178  * Does not support burning tokens to address(0).
1179  */
1180 contract ERC721A is
1181   Context,
1182   ERC165,
1183   IERC721,
1184   IERC721Metadata,
1185   IERC721Enumerable
1186 {
1187   using Address for address;
1188   using Strings for uint256;
1189 
1190   struct TokenOwnership {
1191     address addr;
1192     uint64 startTimestamp;
1193   }
1194 
1195   struct AddressData {
1196     uint128 balance;
1197     uint128 numberMinted;
1198   }
1199 
1200   uint256 private currentIndex = 0;
1201 
1202   uint256 internal immutable collectionSize;
1203   uint256 internal immutable maxBatchSize;
1204 
1205   // Token name
1206   string private _name;
1207 
1208   // Token symbol
1209   string private _symbol;
1210 
1211   // Mapping from token ID to ownership details
1212   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1213   mapping(uint256 => TokenOwnership) private _ownerships;
1214 
1215   // Mapping owner address to address data
1216   mapping(address => AddressData) private _addressData;
1217 
1218   // Mapping from token ID to approved address
1219   mapping(uint256 => address) private _tokenApprovals;
1220 
1221   // Mapping from owner to operator approvals
1222   mapping(address => mapping(address => bool)) private _operatorApprovals;
1223 
1224   /**
1225    * @dev
1226    * `maxBatchSize` refers to how much a minter can mint at a time.
1227    * `collectionSize_` refers to how many tokens are in the collection.
1228    */
1229   constructor(
1230     string memory name_,
1231     string memory symbol_,
1232     uint256 maxBatchSize_,
1233     uint256 collectionSize_
1234   ) {
1235     require(
1236       collectionSize_ > 0,
1237       "ERC721A: collection must have a nonzero supply"
1238     );
1239     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1240     _name = name_;
1241     _symbol = symbol_;
1242     maxBatchSize = maxBatchSize_;
1243     collectionSize = collectionSize_;
1244   }
1245 
1246   /**
1247    * @dev See {IERC721Enumerable-totalSupply}.
1248    */
1249   function totalSupply() public view override returns (uint256) {
1250     return currentIndex;
1251   }
1252 
1253   /**
1254    * @dev See {IERC721Enumerable-tokenByIndex}.
1255    */
1256   function tokenByIndex(uint256 index) public view override returns (uint256) {
1257     require(index < totalSupply(), "ERC721A: global index out of bounds");
1258     return index;
1259   }
1260 
1261   /**
1262    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1263    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1264    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1265    */
1266   function tokenOfOwnerByIndex(address owner, uint256 index)
1267     public
1268     view
1269     override
1270     returns (uint256)
1271   {
1272     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1273     uint256 numMintedSoFar = totalSupply();
1274     uint256 tokenIdsIdx = 0;
1275     address currOwnershipAddr = address(0);
1276     for (uint256 i = 0; i < numMintedSoFar; i++) {
1277       TokenOwnership memory ownership = _ownerships[i];
1278       if (ownership.addr != address(0)) {
1279         currOwnershipAddr = ownership.addr;
1280       }
1281       if (currOwnershipAddr == owner) {
1282         if (tokenIdsIdx == index) {
1283           return i;
1284         }
1285         tokenIdsIdx++;
1286       }
1287     }
1288     revert("ERC721A: unable to get token of owner by index");
1289   }
1290 
1291   /**
1292    * @dev See {IERC165-supportsInterface}.
1293    */
1294   function supportsInterface(bytes4 interfaceId)
1295     public
1296     view
1297     virtual
1298     override(ERC165, IERC165)
1299     returns (bool)
1300   {
1301     return
1302       interfaceId == type(IERC721).interfaceId ||
1303       interfaceId == type(IERC721Metadata).interfaceId ||
1304       interfaceId == type(IERC721Enumerable).interfaceId ||
1305       super.supportsInterface(interfaceId);
1306   }
1307 
1308   /**
1309    * @dev See {IERC721-balanceOf}.
1310    */
1311   function balanceOf(address owner) public view override returns (uint256) {
1312     require(owner != address(0), "ERC721A: balance query for the zero address");
1313     return uint256(_addressData[owner].balance);
1314   }
1315 
1316   function _numberMinted(address owner) internal view returns (uint256) {
1317     require(
1318       owner != address(0),
1319       "ERC721A: number minted query for the zero address"
1320     );
1321     return uint256(_addressData[owner].numberMinted);
1322   }
1323 
1324   function ownershipOf(uint256 tokenId)
1325     internal
1326     view
1327     returns (TokenOwnership memory)
1328   {
1329     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1330 
1331     uint256 lowestTokenToCheck;
1332     if (tokenId >= maxBatchSize) {
1333       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1334     }
1335 
1336     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1337       TokenOwnership memory ownership = _ownerships[curr];
1338       if (ownership.addr != address(0)) {
1339         return ownership;
1340       }
1341     }
1342 
1343     revert("ERC721A: unable to determine the owner of token");
1344   }
1345 
1346   /**
1347    * @dev See {IERC721-ownerOf}.
1348    */
1349   function ownerOf(uint256 tokenId) public view override returns (address) {
1350     return ownershipOf(tokenId).addr;
1351   }
1352 
1353   /**
1354    * @dev See {IERC721Metadata-name}.
1355    */
1356   function name() public view virtual override returns (string memory) {
1357     return _name;
1358   }
1359 
1360   /**
1361    * @dev See {IERC721Metadata-symbol}.
1362    */
1363   function symbol() public view virtual override returns (string memory) {
1364     return _symbol;
1365   }
1366 
1367   /**
1368    * @dev See {IERC721Metadata-tokenURI}.
1369    */
1370   function tokenURI(uint256 tokenId)
1371     public
1372     view
1373     virtual
1374     override
1375     returns (string memory)
1376   {
1377     require(
1378       _exists(tokenId),
1379       "ERC721Metadata: URI query for nonexistent token"
1380     );
1381 
1382     string memory baseURI = _baseURI();
1383     return
1384       bytes(baseURI).length > 0
1385         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1386         : "";
1387   }
1388 
1389   /**
1390    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1391    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1392    * by default, can be overriden in child contracts.
1393    */
1394   function _baseURI() internal view virtual returns (string memory) {
1395     return "";
1396   }
1397 
1398   /**
1399    * @dev See {IERC721-approve}.
1400    */
1401   function approve(address to, uint256 tokenId) public override {
1402     address owner = ERC721A.ownerOf(tokenId);
1403     require(to != owner, "ERC721A: approval to current owner");
1404 
1405     require(
1406       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1407       "ERC721A: approve caller is not owner nor approved for all"
1408     );
1409 
1410     _approve(to, tokenId, owner);
1411   }
1412 
1413   /**
1414    * @dev See {IERC721-getApproved}.
1415    */
1416   function getApproved(uint256 tokenId) public view override returns (address) {
1417     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1418 
1419     return _tokenApprovals[tokenId];
1420   }
1421 
1422   /**
1423    * @dev See {IERC721-setApprovalForAll}.
1424    */
1425   function setApprovalForAll(address operator, bool approved) public override {
1426     require(operator != _msgSender(), "ERC721A: approve to caller");
1427 
1428     _operatorApprovals[_msgSender()][operator] = approved;
1429     emit ApprovalForAll(_msgSender(), operator, approved);
1430   }
1431 
1432   /**
1433    * @dev See {IERC721-isApprovedForAll}.
1434    */
1435   function isApprovedForAll(address owner, address operator)
1436     public
1437     view
1438     virtual
1439     override
1440     returns (bool)
1441   {
1442     return _operatorApprovals[owner][operator];
1443   }
1444 
1445   /**
1446    * @dev See {IERC721-transferFrom}.
1447    */
1448   function transferFrom(
1449     address from,
1450     address to,
1451     uint256 tokenId
1452   ) public override {
1453     _transfer(from, to, tokenId);
1454   }
1455 
1456   /**
1457    * @dev See {IERC721-safeTransferFrom}.
1458    */
1459   function safeTransferFrom(
1460     address from,
1461     address to,
1462     uint256 tokenId
1463   ) public override {
1464     safeTransferFrom(from, to, tokenId, "");
1465   }
1466 
1467   /**
1468    * @dev See {IERC721-safeTransferFrom}.
1469    */
1470   function safeTransferFrom(
1471     address from,
1472     address to,
1473     uint256 tokenId,
1474     bytes memory _data
1475   ) public override {
1476     _transfer(from, to, tokenId);
1477     require(
1478       _checkOnERC721Received(from, to, tokenId, _data),
1479       "ERC721A: transfer to non ERC721Receiver implementer"
1480     );
1481   }
1482 
1483   /**
1484    * @dev Returns whether `tokenId` exists.
1485    *
1486    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1487    *
1488    * Tokens start existing when they are minted (`_mint`),
1489    */
1490   function _exists(uint256 tokenId) internal view returns (bool) {
1491     return tokenId < currentIndex;
1492   }
1493 
1494   function _safeMint(address to, uint256 quantity) internal {
1495     _safeMint(to, quantity, "");
1496   }
1497 
1498   /**
1499    * @dev Mints `quantity` tokens and transfers them to `to`.
1500    *
1501    * Requirements:
1502    *
1503    * - there must be `quantity` tokens remaining unminted in the total collection.
1504    * - `to` cannot be the zero address.
1505    * - `quantity` cannot be larger than the max batch size.
1506    *
1507    * Emits a {Transfer} event.
1508    */
1509   function _safeMint(
1510     address to,
1511     uint256 quantity,
1512     bytes memory _data
1513   ) internal {
1514     uint256 startTokenId = currentIndex;
1515     require(to != address(0), "ERC721A: mint to the zero address");
1516     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1517     require(!_exists(startTokenId), "ERC721A: token already minted");
1518     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1519 
1520     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1521 
1522     AddressData memory addressData = _addressData[to];
1523     _addressData[to] = AddressData(
1524       addressData.balance + uint128(quantity),
1525       addressData.numberMinted + uint128(quantity)
1526     );
1527     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1528 
1529     uint256 updatedIndex = startTokenId;
1530 
1531     for (uint256 i = 0; i < quantity; i++) {
1532       emit Transfer(address(0), to, updatedIndex);
1533       require(
1534         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1535         "ERC721A: transfer to non ERC721Receiver implementer"
1536       );
1537       updatedIndex++;
1538     }
1539 
1540     currentIndex = updatedIndex;
1541     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1542   }
1543 
1544   /**
1545    * @dev Transfers `tokenId` from `from` to `to`.
1546    *
1547    * Requirements:
1548    *
1549    * - `to` cannot be the zero address.
1550    * - `tokenId` token must be owned by `from`.
1551    *
1552    * Emits a {Transfer} event.
1553    */
1554   function _transfer(
1555     address from,
1556     address to,
1557     uint256 tokenId
1558   ) private {
1559     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1560 
1561     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1562       getApproved(tokenId) == _msgSender() ||
1563       isApprovedForAll(prevOwnership.addr, _msgSender()));
1564 
1565     require(
1566       isApprovedOrOwner,
1567       "ERC721A: transfer caller is not owner nor approved"
1568     );
1569 
1570     require(
1571       prevOwnership.addr == from,
1572       "ERC721A: transfer from incorrect owner"
1573     );
1574     require(to != address(0), "ERC721A: transfer to the zero address");
1575 
1576     _beforeTokenTransfers(from, to, tokenId, 1);
1577 
1578     // Clear approvals from the previous owner
1579     _approve(address(0), tokenId, prevOwnership.addr);
1580 
1581     _addressData[from].balance -= 1;
1582     _addressData[to].balance += 1;
1583     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1584 
1585     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1586     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1587     uint256 nextTokenId = tokenId + 1;
1588     if (_ownerships[nextTokenId].addr == address(0)) {
1589       if (_exists(nextTokenId)) {
1590         _ownerships[nextTokenId] = TokenOwnership(
1591           prevOwnership.addr,
1592           prevOwnership.startTimestamp
1593         );
1594       }
1595     }
1596 
1597     emit Transfer(from, to, tokenId);
1598     _afterTokenTransfers(from, to, tokenId, 1);
1599   }
1600 
1601   /**
1602    * @dev Approve `to` to operate on `tokenId`
1603    *
1604    * Emits a {Approval} event.
1605    */
1606   function _approve(
1607     address to,
1608     uint256 tokenId,
1609     address owner
1610   ) private {
1611     _tokenApprovals[tokenId] = to;
1612     emit Approval(owner, to, tokenId);
1613   }
1614 
1615   uint256 public nextOwnerToExplicitlySet = 0;
1616 
1617   /**
1618    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1619    */
1620   function _setOwnersExplicit(uint256 quantity) internal {
1621     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1622     require(quantity > 0, "quantity must be nonzero");
1623     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1624     if (endIndex > collectionSize - 1) {
1625       endIndex = collectionSize - 1;
1626     }
1627     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1628     require(_exists(endIndex), "not enough minted yet for this cleanup");
1629     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1630       if (_ownerships[i].addr == address(0)) {
1631         TokenOwnership memory ownership = ownershipOf(i);
1632         _ownerships[i] = TokenOwnership(
1633           ownership.addr,
1634           ownership.startTimestamp
1635         );
1636       }
1637     }
1638     nextOwnerToExplicitlySet = endIndex + 1;
1639   }
1640 
1641   /**
1642    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1643    * The call is not executed if the target address is not a contract.
1644    *
1645    * @param from address representing the previous owner of the given token ID
1646    * @param to target address that will receive the tokens
1647    * @param tokenId uint256 ID of the token to be transferred
1648    * @param _data bytes optional data to send along with the call
1649    * @return bool whether the call correctly returned the expected magic value
1650    */
1651   function _checkOnERC721Received(
1652     address from,
1653     address to,
1654     uint256 tokenId,
1655     bytes memory _data
1656   ) private returns (bool) {
1657     if (to.isContract()) {
1658       try
1659         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1660       returns (bytes4 retval) {
1661         return retval == IERC721Receiver(to).onERC721Received.selector;
1662       } catch (bytes memory reason) {
1663         if (reason.length == 0) {
1664           revert("ERC721A: transfer to non ERC721Receiver implementer");
1665         } else {
1666           assembly {
1667             revert(add(32, reason), mload(reason))
1668           }
1669         }
1670       }
1671     } else {
1672       return true;
1673     }
1674   }
1675 
1676   /**
1677    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1678    *
1679    * startTokenId - the first token id to be transferred
1680    * quantity - the amount to be transferred
1681    *
1682    * Calling conditions:
1683    *
1684    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1685    * transferred to `to`.
1686    * - When `from` is zero, `tokenId` will be minted for `to`.
1687    */
1688   function _beforeTokenTransfers(
1689     address from,
1690     address to,
1691     uint256 startTokenId,
1692     uint256 quantity
1693   ) internal virtual {}
1694 
1695   /**
1696    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1697    * minting.
1698    *
1699    * startTokenId - the first token id to be transferred
1700    * quantity - the amount to be transferred
1701    *
1702    * Calling conditions:
1703    *
1704    * - when `from` and `to` are both non-zero.
1705    * - `from` and `to` are never both zero.
1706    */
1707   function _afterTokenTransfers(
1708     address from,
1709     address to,
1710     uint256 startTokenId,
1711     uint256 quantity
1712   ) internal virtual {}
1713 }
1714 
1715 //SPDX-License-Identifier: MIT
1716 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1717 
1718 pragma solidity ^0.8.0;
1719 
1720 contract LANDBITS is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1721     using Counters for Counters.Counter;
1722     using Strings for uint256;
1723 
1724     Counters.Counter private tokenCounter;
1725 
1726     string private baseURI = "ipfs://QmSD9CJUWR7McrDm3CzxHzLwFi94jkZtPQHrCBuWMkJn3r";
1727     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1728     bool private isOpenSeaProxyActive = true;
1729 
1730     uint256 public constant MAX_MINTS_PER_TX = 2;
1731     uint256 public maxSupply = 999;
1732 
1733     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
1734     uint256 public NUM_FREE_MINTS = 250;
1735     bool public isPublicSaleActive = true;
1736 
1737 
1738 
1739 
1740     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1741 
1742     modifier publicSaleActive() {
1743         require(isPublicSaleActive, "Public sale is not open");
1744         _;
1745     }
1746 
1747 
1748 
1749     modifier maxMintsPerTX(uint256 numberOfTokens) {
1750         require(
1751             numberOfTokens <= MAX_MINTS_PER_TX,
1752             "Max mints per transaction exceeded"
1753         );
1754         _;
1755     }
1756 
1757     modifier canMintNFTs(uint256 numberOfTokens) {
1758         require(
1759             totalSupply() + numberOfTokens <=
1760                 maxSupply,
1761             "Not enough mints remaining to mint"
1762         );
1763         _;
1764     }
1765 
1766     modifier freeMintsAvailable() {
1767         require(
1768             totalSupply() <=
1769                 NUM_FREE_MINTS,
1770             "Not enough free mints remain"
1771         );
1772         _;
1773     }
1774 
1775 
1776 
1777     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1778         if(totalSupply()>NUM_FREE_MINTS){
1779         require(
1780             (price * numberOfTokens) == msg.value,
1781             "Incorrect ETH value sent"
1782         );
1783         }
1784         _;
1785     }
1786 
1787 
1788     constructor(
1789     ) ERC721A("LandBits", "LANDBITS", 100, maxSupply) {
1790     }
1791 
1792     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1793 
1794     function mint(uint256 numberOfTokens)
1795         external
1796         payable
1797         nonReentrant
1798         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1799         publicSaleActive
1800         canMintNFTs(numberOfTokens)
1801         maxMintsPerTX(numberOfTokens)
1802     {
1803 
1804         _safeMint(msg.sender, numberOfTokens);
1805     }
1806 
1807 
1808 
1809     //A simple free mint function to avoid confusion
1810     //The normal mint function with a cost of 0 would work too
1811 
1812     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1813 
1814     function getBaseURI() external view returns (string memory) {
1815         return baseURI;
1816     }
1817 
1818     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1819 
1820     function setBaseURI(string memory _baseURI) external onlyOwner {
1821         baseURI = _baseURI;
1822     }
1823 
1824     // function to disable gasless listings for security in case
1825     // opensea ever shuts down or is compromised
1826     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1827         external
1828         onlyOwner
1829     {
1830         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1831     }
1832 
1833     function setIsPublicSaleActive(bool _isPublicSaleActive)
1834         external
1835         onlyOwner
1836     {
1837         isPublicSaleActive = _isPublicSaleActive;
1838     }
1839 
1840 
1841     function mints(uint256 _numfreemints)
1842         external
1843         onlyOwner
1844     {
1845         NUM_FREE_MINTS = _numfreemints;
1846     }
1847 
1848 
1849     function withdraw() public onlyOwner {
1850         uint256 balance = address(this).balance;
1851         payable(msg.sender).transfer(balance);
1852     }
1853 
1854     function withdrawTokens(IERC20 token) public onlyOwner {
1855         uint256 balance = token.balanceOf(address(this));
1856         token.transfer(msg.sender, balance);
1857     }
1858 
1859 
1860 
1861     // ============ SUPPORTING FUNCTIONS ============
1862 
1863     function nextTokenId() private returns (uint256) {
1864         tokenCounter.increment();
1865         return tokenCounter.current();
1866     }
1867 
1868     // ============ FUNCTION OVERRIDES ============
1869 
1870     function supportsInterface(bytes4 interfaceId)
1871         public
1872         view
1873         virtual
1874         override(ERC721A, IERC165)
1875         returns (bool)
1876     {
1877         return
1878             interfaceId == type(IERC2981).interfaceId ||
1879             super.supportsInterface(interfaceId);
1880     }
1881 
1882     /**
1883      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1884      */
1885     function isApprovedForAll(address owner, address operator)
1886         public
1887         view
1888         override
1889         returns (bool)
1890     {
1891         // Get a reference to OpenSea's proxy registry contract by instantiating
1892         // the contract using the already existing address.
1893         ProxyRegistry proxyRegistry = ProxyRegistry(
1894             openSeaProxyRegistryAddress
1895         );
1896         if (
1897             isOpenSeaProxyActive &&
1898             address(proxyRegistry.proxies(owner)) == operator
1899         ) {
1900             return true;
1901         }
1902 
1903         return super.isApprovedForAll(owner, operator);
1904     }
1905 
1906     /**
1907      * @dev See {IERC721Metadata-tokenURI}.
1908      */
1909     function tokenURI(uint256 tokenId)
1910         public
1911         view
1912         virtual
1913         override
1914         returns (string memory)
1915     {
1916         require(_exists(tokenId), "Nonexistent token");
1917 
1918         return
1919             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1920     }
1921 
1922     /**
1923      * @dev See {IERC165-royaltyInfo}.
1924      */
1925     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1926         external
1927         view
1928         override
1929         returns (address receiver, uint256 royaltyAmount)
1930     {
1931         require(_exists(tokenId), "Nonexistent token");
1932 
1933         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1934     }
1935 }
1936 
1937 // These contract definitions are used to create a reference to the OpenSea
1938 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1939 contract OwnableDelegateProxy {
1940 
1941 }
1942 
1943 contract ProxyRegistry {
1944     mapping(address => OwnableDelegateProxy) public proxies;
1945 }