1 pragma solidity ^0.8.0;
2 
3 // CAUTION
4 // This version of SafeMath should only be used with Solidity 0.8 or later,
5 // because it relies on the compiler's built in overflow checks.
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations.
9  *
10  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
11  * now has built in overflow checking.
12  */
13 library SafeMath {
14     /**
15      * @dev Returns the addition of two unsigned integers, with an overflow flag.
16      *
17      * _Available since v3.4._
18      */
19     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {
21             uint256 c = a + b;
22             if (c < a) return (false, 0);
23             return (true, c);
24         }
25     }
26 
27     /**
28      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             if (b > a) return (false, 0);
35             return (true, a - b);
36         }
37     }
38 
39     /**
40      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47             // benefit is lost if 'b' is also tested.
48             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49             if (a == 0) return (true, 0);
50             uint256 c = a * b;
51             if (c / a != b) return (false, 0);
52             return (true, c);
53         }
54     }
55 
56     /**
57      * @dev Returns the division of two unsigned integers, with a division by zero flag.
58      *
59      * _Available since v3.4._
60      */
61     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             if (b == 0) return (false, 0);
64             return (true, a / b);
65         }
66     }
67 
68     /**
69      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             if (b == 0) return (false, 0);
76             return (true, a % b);
77         }
78     }
79 
80     /**
81      * @dev Returns the addition of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      *
88      * - Addition cannot overflow.
89      */
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a + b;
92     }
93 
94     /**
95      * @dev Returns the subtraction of two unsigned integers, reverting on
96      * overflow (when the result is negative).
97      *
98      * Counterpart to Solidity's `-` operator.
99      *
100      * Requirements:
101      *
102      * - Subtraction cannot overflow.
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a * b;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers, reverting on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator.
127      *
128      * Requirements:
129      *
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a / b;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * reverting when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a % b;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * CAUTION: This function is deprecated because it requires allocating memory for the error
157      * message unnecessarily. For custom revert reasons use {trySub}.
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(
166         uint256 a,
167         uint256 b,
168         string memory errorMessage
169     ) internal pure returns (uint256) {
170         unchecked {
171             require(b <= a, errorMessage);
172             return a - b;
173         }
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(
189         uint256 a,
190         uint256 b,
191         string memory errorMessage
192     ) internal pure returns (uint256) {
193         unchecked {
194             require(b > 0, errorMessage);
195             return a / b;
196         }
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         unchecked {
220             require(b > 0, errorMessage);
221             return a % b;
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/Counters.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title Counters
235  * @author Matt Condon (@shrugs)
236  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
237  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
238  *
239  * Include with `using Counters for Counters.Counter;`
240  */
241 library Counters {
242     struct Counter {
243         // This variable should never be directly accessed by users of the library: interactions must be restricted to
244         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
245         // this feature: see https://github.com/ethereum/solidity/issues/4637
246         uint256 _value; // default: 0
247     }
248 
249     function current(Counter storage counter) internal view returns (uint256) {
250         return counter._value;
251     }
252 
253     function increment(Counter storage counter) internal {
254         unchecked {
255             counter._value += 1;
256         }
257     }
258 
259     function decrement(Counter storage counter) internal {
260         uint256 value = counter._value;
261         require(value > 0, "Counter: decrement overflow");
262         unchecked {
263             counter._value = value - 1;
264         }
265     }
266 
267     function reset(Counter storage counter) internal {
268         counter._value = 0;
269     }
270 }
271 
272 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Contract module that helps prevent reentrant calls to a function.
281  *
282  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
283  * available, which can be applied to functions to make sure there are no nested
284  * (reentrant) calls to them.
285  *
286  * Note that because there is a single `nonReentrant` guard, functions marked as
287  * `nonReentrant` may not call one another. This can be worked around by making
288  * those functions `private`, and then adding `external` `nonReentrant` entry
289  * points to them.
290  *
291  * TIP: If you would like to learn more about reentrancy and alternative ways
292  * to protect against it, check out our blog post
293  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
294  */
295 abstract contract ReentrancyGuard {
296     // Booleans are more expensive than uint256 or any type that takes up a full
297     // word because each write operation emits an extra SLOAD to first read the
298     // slot's contents, replace the bits taken up by the boolean, and then write
299     // back. This is the compiler's defense against contract upgrades and
300     // pointer aliasing, and it cannot be disabled.
301 
302     // The values being non-zero value makes deployment a bit more expensive,
303     // but in exchange the refund on every call to nonReentrant will be lower in
304     // amount. Since refunds are capped to a percentage of the total
305     // transaction's gas, it is best to keep them low in cases like this one, to
306     // increase the likelihood of the full refund coming into effect.
307     uint256 private constant _NOT_ENTERED = 1;
308     uint256 private constant _ENTERED = 2;
309 
310     uint256 private _status;
311 
312     constructor() {
313         _status = _NOT_ENTERED;
314     }
315 
316     /**
317      * @dev Prevents a contract from calling itself, directly or indirectly.
318      * Calling a `nonReentrant` function from another `nonReentrant`
319      * function is not supported. It is possible to prevent this from happening
320      * by making the `nonReentrant` function external, and making it call a
321      * `private` function that does the actual work.
322      */
323     modifier nonReentrant() {
324         // On the first call to nonReentrant, _notEntered will be true
325         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
326 
327         // Any calls to nonReentrant after this point will fail
328         _status = _ENTERED;
329 
330         _;
331 
332         // By storing the original value once again, a refund is triggered (see
333         // https://eips.ethereum.org/EIPS/eip-2200)
334         _status = _NOT_ENTERED;
335     }
336 }
337 
338 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Interface of the ERC20 standard as defined in the EIP.
347  */
348 interface IERC20 {
349     /**
350      * @dev Returns the amount of tokens in existence.
351      */
352     function totalSupply() external view returns (uint256);
353 
354     /**
355      * @dev Returns the amount of tokens owned by `account`.
356      */
357     function balanceOf(address account) external view returns (uint256);
358 
359     /**
360      * @dev Moves `amount` tokens from the caller's account to `recipient`.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * Emits a {Transfer} event.
365      */
366     function transfer(address recipient, uint256 amount) external returns (bool);
367 
368     /**
369      * @dev Returns the remaining number of tokens that `spender` will be
370      * allowed to spend on behalf of `owner` through {transferFrom}. This is
371      * zero by default.
372      *
373      * This value changes when {approve} or {transferFrom} are called.
374      */
375     function allowance(address owner, address spender) external view returns (uint256);
376 
377     /**
378      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * IMPORTANT: Beware that changing an allowance with this method brings the risk
383      * that someone may use both the old and the new allowance by unfortunate
384      * transaction ordering. One possible solution to mitigate this race
385      * condition is to first reduce the spender's allowance to 0 and set the
386      * desired value afterwards:
387      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
388      *
389      * Emits an {Approval} event.
390      */
391     function approve(address spender, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Moves `amount` tokens from `sender` to `recipient` using the
395      * allowance mechanism. `amount` is then deducted from the caller's
396      * allowance.
397      *
398      * Returns a boolean value indicating whether the operation succeeded.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transferFrom(
403         address sender,
404         address recipient,
405         uint256 amount
406     ) external returns (bool);
407 
408     /**
409      * @dev Emitted when `value` tokens are moved from one account (`from`) to
410      * another (`to`).
411      *
412      * Note that `value` may be zero.
413      */
414     event Transfer(address indexed from, address indexed to, uint256 value);
415 
416     /**
417      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
418      * a call to {approve}. `value` is the new allowance.
419      */
420     event Approval(address indexed owner, address indexed spender, uint256 value);
421 }
422 
423 // File: @openzeppelin/contracts/interfaces/IERC20.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 
431 // File: @openzeppelin/contracts/utils/Strings.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev String operations.
440  */
441 library Strings {
442     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
443 
444     /**
445      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
446      */
447     function toString(uint256 value) internal pure returns (string memory) {
448         // Inspired by OraclizeAPI's implementation - MIT licence
449         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
450 
451         if (value == 0) {
452             return "0";
453         }
454         uint256 temp = value;
455         uint256 digits;
456         while (temp != 0) {
457             digits++;
458             temp /= 10;
459         }
460         bytes memory buffer = new bytes(digits);
461         while (value != 0) {
462             digits -= 1;
463             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
464             value /= 10;
465         }
466         return string(buffer);
467     }
468 
469     /**
470      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
471      */
472     function toHexString(uint256 value) internal pure returns (string memory) {
473         if (value == 0) {
474             return "0x00";
475         }
476         uint256 temp = value;
477         uint256 length = 0;
478         while (temp != 0) {
479             length++;
480             temp >>= 8;
481         }
482         return toHexString(value, length);
483     }
484 
485     /**
486      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
487      */
488     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
489         bytes memory buffer = new bytes(2 * length + 2);
490         buffer[0] = "0";
491         buffer[1] = "x";
492         for (uint256 i = 2 * length + 1; i > 1; --i) {
493             buffer[i] = _HEX_SYMBOLS[value & 0xf];
494             value >>= 4;
495         }
496         require(value == 0, "Strings: hex length insufficient");
497         return string(buffer);
498     }
499 }
500 
501 // File: @openzeppelin/contracts/utils/Context.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Provides information about the current execution context, including the
510  * sender of the transaction and its data. While these are generally available
511  * via msg.sender and msg.data, they should not be accessed in such a direct
512  * manner, since when dealing with meta-transactions the account sending and
513  * paying for execution may not be the actual sender (as far as an application
514  * is concerned).
515  *
516  * This contract is only required for intermediate, library-like contracts.
517  */
518 abstract contract Context {
519     function _msgSender() internal view virtual returns (address) {
520         return msg.sender;
521     }
522 
523     function _msgData() internal view virtual returns (bytes calldata) {
524         return msg.data;
525     }
526 }
527 
528 // File: @openzeppelin/contracts/access/Ownable.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @dev Contract module which provides a basic access control mechanism, where
538  * there is an account (an owner) that can be granted exclusive access to
539  * specific functions.
540  *
541  * By default, the owner account will be the one that deploys the contract. This
542  * can later be changed with {transferOwnership}.
543  *
544  * This module is used through inheritance. It will make available the modifier
545  * `onlyOwner`, which can be applied to your functions to restrict their use to
546  * the owner.
547  */
548 abstract contract Ownable is Context {
549     address private _owner;
550 
551     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
552 
553     /**
554      * @dev Initializes the contract setting the deployer as the initial owner.
555      */
556     constructor() {
557         _transferOwnership(_msgSender());
558     }
559 
560     /**
561      * @dev Returns the address of the current owner.
562      */
563     function owner() public view virtual returns (address) {
564         return _owner;
565     }
566 
567     /**
568      * @dev Throws if called by any account other than the owner.
569      */
570     modifier onlyOwner() {
571         require(owner() == _msgSender(), "Ownable: caller is not the owner");
572         _;
573     }
574 
575     /**
576      * @dev Leaves the contract without owner. It will not be possible to call
577      * `onlyOwner` functions anymore. Can only be called by the current owner.
578      *
579      * NOTE: Renouncing ownership will leave the contract without an owner,
580      * thereby removing any functionality that is only available to the owner.
581      */
582     function renounceOwnership() public virtual onlyOwner {
583         _transferOwnership(address(0));
584     }
585 
586     /**
587      * @dev Transfers ownership of the contract to a new account (`newOwner`).
588      * Can only be called by the current owner.
589      */
590     function transferOwnership(address newOwner) public virtual onlyOwner {
591         require(newOwner != address(0), "Ownable: new owner is the zero address");
592         _transferOwnership(newOwner);
593     }
594 
595     /**
596      * @dev Transfers ownership of the contract to a new account (`newOwner`).
597      * Internal function without access restriction.
598      */
599     function _transferOwnership(address newOwner) internal virtual {
600         address oldOwner = _owner;
601         _owner = newOwner;
602         emit OwnershipTransferred(oldOwner, newOwner);
603     }
604 }
605 
606 // File: @openzeppelin/contracts/utils/Address.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev Collection of functions related to the address type
615  */
616 library Address {
617     /**
618      * @dev Returns true if `account` is a contract.
619      *
620      * [IMPORTANT]
621      * ====
622      * It is unsafe to assume that an address for which this function returns
623      * false is an externally-owned account (EOA) and not a contract.
624      *
625      * Among others, `isContract` will return false for the following
626      * types of addresses:
627      *
628      *  - an externally-owned account
629      *  - a contract in construction
630      *  - an address where a contract will be created
631      *  - an address where a contract lived, but was destroyed
632      * ====
633      */
634     function isContract(address account) internal view returns (bool) {
635         // This method relies on extcodesize, which returns 0 for contracts in
636         // construction, since the code is only stored at the end of the
637         // constructor execution.
638 
639         uint256 size;
640         assembly {
641             size := extcodesize(account)
642         }
643         return size > 0;
644     }
645 
646     /**
647      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
648      * `recipient`, forwarding all available gas and reverting on errors.
649      *
650      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
651      * of certain opcodes, possibly making contracts go over the 2300 gas limit
652      * imposed by `transfer`, making them unable to receive funds via
653      * `transfer`. {sendValue} removes this limitation.
654      *
655      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
656      *
657      * IMPORTANT: because control is transferred to `recipient`, care must be
658      * taken to not create reentrancy vulnerabilities. Consider using
659      * {ReentrancyGuard} or the
660      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
661      */
662     function sendValue(address payable recipient, uint256 amount) internal {
663         require(address(this).balance >= amount, "Address: insufficient balance");
664 
665         (bool success, ) = recipient.call{value: amount}("");
666         require(success, "Address: unable to send value, recipient may have reverted");
667     }
668 
669     /**
670      * @dev Performs a Solidity function call using a low level `call`. A
671      * plain `call` is an unsafe replacement for a function call: use this
672      * function instead.
673      *
674      * If `target` reverts with a revert reason, it is bubbled up by this
675      * function (like regular Solidity function calls).
676      *
677      * Returns the raw returned data. To convert to the expected return value,
678      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
679      *
680      * Requirements:
681      *
682      * - `target` must be a contract.
683      * - calling `target` with `data` must not revert.
684      *
685      * _Available since v3.1._
686      */
687     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
688         return functionCall(target, data, "Address: low-level call failed");
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
693      * `errorMessage` as a fallback revert reason when `target` reverts.
694      *
695      * _Available since v3.1._
696      */
697     function functionCall(
698         address target,
699         bytes memory data,
700         string memory errorMessage
701     ) internal returns (bytes memory) {
702         return functionCallWithValue(target, data, 0, errorMessage);
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
707      * but also transferring `value` wei to `target`.
708      *
709      * Requirements:
710      *
711      * - the calling contract must have an ETH balance of at least `value`.
712      * - the called Solidity function must be `payable`.
713      *
714      * _Available since v3.1._
715      */
716     function functionCallWithValue(
717         address target,
718         bytes memory data,
719         uint256 value
720     ) internal returns (bytes memory) {
721         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
726      * with `errorMessage` as a fallback revert reason when `target` reverts.
727      *
728      * _Available since v3.1._
729      */
730     function functionCallWithValue(
731         address target,
732         bytes memory data,
733         uint256 value,
734         string memory errorMessage
735     ) internal returns (bytes memory) {
736         require(address(this).balance >= value, "Address: insufficient balance for call");
737         require(isContract(target), "Address: call to non-contract");
738 
739         (bool success, bytes memory returndata) = target.call{value: value}(data);
740         return verifyCallResult(success, returndata, errorMessage);
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
745      * but performing a static call.
746      *
747      * _Available since v3.3._
748      */
749     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
750         return functionStaticCall(target, data, "Address: low-level static call failed");
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
755      * but performing a static call.
756      *
757      * _Available since v3.3._
758      */
759     function functionStaticCall(
760         address target,
761         bytes memory data,
762         string memory errorMessage
763     ) internal view returns (bytes memory) {
764         require(isContract(target), "Address: static call to non-contract");
765 
766         (bool success, bytes memory returndata) = target.staticcall(data);
767         return verifyCallResult(success, returndata, errorMessage);
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
772      * but performing a delegate call.
773      *
774      * _Available since v3.4._
775      */
776     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
777         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
778     }
779 
780     /**
781      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
782      * but performing a delegate call.
783      *
784      * _Available since v3.4._
785      */
786     function functionDelegateCall(
787         address target,
788         bytes memory data,
789         string memory errorMessage
790     ) internal returns (bytes memory) {
791         require(isContract(target), "Address: delegate call to non-contract");
792 
793         (bool success, bytes memory returndata) = target.delegatecall(data);
794         return verifyCallResult(success, returndata, errorMessage);
795     }
796 
797     /**
798      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
799      * revert reason using the provided one.
800      *
801      * _Available since v4.3._
802      */
803     function verifyCallResult(
804         bool success,
805         bytes memory returndata,
806         string memory errorMessage
807     ) internal pure returns (bytes memory) {
808         if (success) {
809             return returndata;
810         } else {
811             // Look for revert reason and bubble it up if present
812             if (returndata.length > 0) {
813                 // The easiest way to bubble the revert reason is using memory via assembly
814 
815                 assembly {
816                     let returndata_size := mload(returndata)
817                     revert(add(32, returndata), returndata_size)
818                 }
819             } else {
820                 revert(errorMessage);
821             }
822         }
823     }
824 }
825 
826 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
827 
828 
829 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
830 
831 pragma solidity ^0.8.0;
832 
833 /**
834  * @title ERC721 token receiver interface
835  * @dev Interface for any contract that wants to support safeTransfers
836  * from ERC721 asset contracts.
837  */
838 interface IERC721Receiver {
839     /**
840      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
841      * by `operator` from `from`, this function is called.
842      *
843      * It must return its Solidity selector to confirm the token transfer.
844      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
845      *
846      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
847      */
848     function onERC721Received(
849         address operator,
850         address from,
851         uint256 tokenId,
852         bytes calldata data
853     ) external returns (bytes4);
854 }
855 
856 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
857 
858 
859 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
860 
861 pragma solidity ^0.8.0;
862 
863 /**
864  * @dev Interface of the ERC165 standard, as defined in the
865  * https://eips.ethereum.org/EIPS/eip-165[EIP].
866  *
867  * Implementers can declare support of contract interfaces, which can then be
868  * queried by others ({ERC165Checker}).
869  *
870  * For an implementation, see {ERC165}.
871  */
872 interface IERC165 {
873     /**
874      * @dev Returns true if this contract implements the interface defined by
875      * `interfaceId`. See the corresponding
876      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
877      * to learn more about how these ids are created.
878      *
879      * This function call must use less than 30 000 gas.
880      */
881     function supportsInterface(bytes4 interfaceId) external view returns (bool);
882 }
883 
884 // File: @openzeppelin/contracts/interfaces/IERC165.sol
885 
886 
887 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
888 
889 pragma solidity ^0.8.0;
890 
891 
892 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
893 
894 
895 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 
900 /**
901  * @dev Interface for the NFT Royalty Standard
902  */
903 interface IERC2981 is IERC165 {
904     /**
905      * @dev Called with the sale price to determine how much royalty is owed and to whom.
906      * @param tokenId - the NFT asset queried for royalty information
907      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
908      * @return receiver - address of who should be sent the royalty payment
909      * @return royaltyAmount - the royalty payment amount for `salePrice`
910      */
911     function royaltyInfo(uint256 tokenId, uint256 salePrice)
912         external
913         view
914         returns (address receiver, uint256 royaltyAmount);
915 }
916 
917 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
918 
919 
920 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
921 
922 pragma solidity ^0.8.0;
923 
924 
925 /**
926  * @dev Implementation of the {IERC165} interface.
927  *
928  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
929  * for the additional interface id that will be supported. For example:
930  *
931  * ```solidity
932  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
933  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
934  * }
935  * ```
936  *
937  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
938  */
939 abstract contract ERC165 is IERC165 {
940     /**
941      * @dev See {IERC165-supportsInterface}.
942      */
943     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
944         return interfaceId == type(IERC165).interfaceId;
945     }
946 }
947 
948 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
949 
950 
951 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
952 
953 pragma solidity ^0.8.0;
954 
955 
956 /**
957  * @dev Required interface of an ERC721 compliant contract.
958  */
959 interface IERC721 is IERC165 {
960     /**
961      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
962      */
963     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
964 
965     /**
966      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
967      */
968     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
969 
970     /**
971      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
972      */
973     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
974 
975     /**
976      * @dev Returns the number of tokens in ``owner``'s account.
977      */
978     function balanceOf(address owner) external view returns (uint256 balance);
979 
980     /**
981      * @dev Returns the owner of the `tokenId` token.
982      *
983      * Requirements:
984      *
985      * - `tokenId` must exist.
986      */
987     function ownerOf(uint256 tokenId) external view returns (address owner);
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
991      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
992      *
993      * Requirements:
994      *
995      * - `from` cannot be the zero address.
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must exist and be owned by `from`.
998      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
999      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function safeTransferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) external;
1008 
1009     /**
1010      * @dev Transfers `tokenId` token from `from` to `to`.
1011      *
1012      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1013      *
1014      * Requirements:
1015      *
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must be owned by `from`.
1019      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function transferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) external;
1028 
1029     /**
1030      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1031      * The approval is cleared when the token is transferred.
1032      *
1033      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1034      *
1035      * Requirements:
1036      *
1037      * - The caller must own the token or be an approved operator.
1038      * - `tokenId` must exist.
1039      *
1040      * Emits an {Approval} event.
1041      */
1042     function approve(address to, uint256 tokenId) external;
1043 
1044     /**
1045      * @dev Returns the account approved for `tokenId` token.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must exist.
1050      */
1051     function getApproved(uint256 tokenId) external view returns (address operator);
1052 
1053     /**
1054      * @dev Approve or remove `operator` as an operator for the caller.
1055      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1056      *
1057      * Requirements:
1058      *
1059      * - The `operator` cannot be the caller.
1060      *
1061      * Emits an {ApprovalForAll} event.
1062      */
1063     function setApprovalForAll(address operator, bool _approved) external;
1064 
1065     /**
1066      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1067      *
1068      * See {setApprovalForAll}
1069      */
1070     function isApprovedForAll(address owner, address operator) external view returns (bool);
1071 
1072     /**
1073      * @dev Safely transfers `tokenId` token from `from` to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `from` cannot be the zero address.
1078      * - `to` cannot be the zero address.
1079      * - `tokenId` token must exist and be owned by `from`.
1080      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1081      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function safeTransferFrom(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes calldata data
1090     ) external;
1091 }
1092 
1093 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1094 
1095 
1096 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1097 
1098 pragma solidity ^0.8.0;
1099 
1100 
1101 /**
1102  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1103  * @dev See https://eips.ethereum.org/EIPS/eip-721
1104  */
1105 interface IERC721Enumerable is IERC721 {
1106     /**
1107      * @dev Returns the total amount of tokens stored by the contract.
1108      */
1109     function totalSupply() external view returns (uint256);
1110 
1111     /**
1112      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1113      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1114      */
1115     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1116 
1117     /**
1118      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1119      * Use along with {totalSupply} to enumerate all tokens.
1120      */
1121     function tokenByIndex(uint256 index) external view returns (uint256);
1122 }
1123 
1124 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1125 
1126 
1127 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1128 
1129 pragma solidity ^0.8.0;
1130 
1131 
1132 /**
1133  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1134  * @dev See https://eips.ethereum.org/EIPS/eip-721
1135  */
1136 interface IERC721Metadata is IERC721 {
1137     /**
1138      * @dev Returns the token collection name.
1139      */
1140     function name() external view returns (string memory);
1141 
1142     /**
1143      * @dev Returns the token collection symbol.
1144      */
1145     function symbol() external view returns (string memory);
1146 
1147     /**
1148      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1149      */
1150     function tokenURI(uint256 tokenId) external view returns (string memory);
1151 }
1152 
1153 // File: contracts/ERC721A.sol
1154 
1155 
1156 
1157 pragma solidity ^0.8.0;
1158 
1159 
1160 
1161 
1162 
1163 
1164 
1165 
1166 
1167 /**
1168  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1169  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1170  *
1171  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1172  *
1173  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1174  *
1175  * Does not support burning tokens to address(0).
1176  */
1177 contract ERC721A is
1178   Context,
1179   ERC165,
1180   IERC721,
1181   IERC721Metadata,
1182   IERC721Enumerable
1183 {
1184   using Address for address;
1185   using Strings for uint256;
1186 
1187   struct TokenOwnership {
1188     address addr;
1189     uint64 startTimestamp;
1190   }
1191 
1192   struct AddressData {
1193     uint128 balance;
1194     uint128 numberMinted;
1195   }
1196 
1197   uint256 private currentIndex = 0;
1198 
1199   uint256 internal immutable collectionSize;
1200   uint256 internal immutable maxBatchSize;
1201 
1202   // Token name
1203   string private _name;
1204 
1205   // Token symbol
1206   string private _symbol;
1207 
1208   // Mapping from token ID to ownership details
1209   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1210   mapping(uint256 => TokenOwnership) private _ownerships;
1211 
1212   // Mapping owner address to address data
1213   mapping(address => AddressData) private _addressData;
1214 
1215   // Mapping from token ID to approved address
1216   mapping(uint256 => address) private _tokenApprovals;
1217 
1218   // Mapping from owner to operator approvals
1219   mapping(address => mapping(address => bool)) private _operatorApprovals;
1220 
1221   /**
1222    * @dev
1223    * `maxBatchSize` refers to how much a minter can mint at a time.
1224    * `collectionSize_` refers to how many tokens are in the collection.
1225    */
1226   constructor(
1227     string memory name_,
1228     string memory symbol_,
1229     uint256 maxBatchSize_,
1230     uint256 collectionSize_
1231   ) {
1232     require(
1233       collectionSize_ > 0,
1234       "ERC721A: collection must have a nonzero supply"
1235     );
1236     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1237     _name = name_;
1238     _symbol = symbol_;
1239     maxBatchSize = maxBatchSize_;
1240     collectionSize = collectionSize_;
1241   }
1242 
1243   /**
1244    * @dev See {IERC721Enumerable-totalSupply}.
1245    */
1246   function totalSupply() public view override returns (uint256) {
1247     return currentIndex;
1248   }
1249 
1250   /**
1251    * @dev See {IERC721Enumerable-tokenByIndex}.
1252    */
1253   function tokenByIndex(uint256 index) public view override returns (uint256) {
1254     require(index < totalSupply(), "ERC721A: global index out of bounds");
1255     return index;
1256   }
1257 
1258   /**
1259    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1260    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1261    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1262    */
1263   function tokenOfOwnerByIndex(address owner, uint256 index)
1264     public
1265     view
1266     override
1267     returns (uint256)
1268   {
1269     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1270     uint256 numMintedSoFar = totalSupply();
1271     uint256 tokenIdsIdx = 0;
1272     address currOwnershipAddr = address(0);
1273     for (uint256 i = 0; i < numMintedSoFar; i++) {
1274       TokenOwnership memory ownership = _ownerships[i];
1275       if (ownership.addr != address(0)) {
1276         currOwnershipAddr = ownership.addr;
1277       }
1278       if (currOwnershipAddr == owner) {
1279         if (tokenIdsIdx == index) {
1280           return i;
1281         }
1282         tokenIdsIdx++;
1283       }
1284     }
1285     revert("ERC721A: unable to get token of owner by index");
1286   }
1287 
1288   /**
1289    * @dev See {IERC165-supportsInterface}.
1290    */
1291   function supportsInterface(bytes4 interfaceId)
1292     public
1293     view
1294     virtual
1295     override(ERC165, IERC165)
1296     returns (bool)
1297   {
1298     return
1299       interfaceId == type(IERC721).interfaceId ||
1300       interfaceId == type(IERC721Metadata).interfaceId ||
1301       interfaceId == type(IERC721Enumerable).interfaceId ||
1302       super.supportsInterface(interfaceId);
1303   }
1304 
1305   /**
1306    * @dev See {IERC721-balanceOf}.
1307    */
1308   function balanceOf(address owner) public view override returns (uint256) {
1309     require(owner != address(0), "ERC721A: balance query for the zero address");
1310     return uint256(_addressData[owner].balance);
1311   }
1312 
1313   function _numberMinted(address owner) internal view returns (uint256) {
1314     require(
1315       owner != address(0),
1316       "ERC721A: number minted query for the zero address"
1317     );
1318     return uint256(_addressData[owner].numberMinted);
1319   }
1320 
1321   function ownershipOf(uint256 tokenId)
1322     internal
1323     view
1324     returns (TokenOwnership memory)
1325   {
1326     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1327 
1328     uint256 lowestTokenToCheck;
1329     if (tokenId >= maxBatchSize) {
1330       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1331     }
1332 
1333     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1334       TokenOwnership memory ownership = _ownerships[curr];
1335       if (ownership.addr != address(0)) {
1336         return ownership;
1337       }
1338     }
1339 
1340     revert("ERC721A: unable to determine the owner of token");
1341   }
1342 
1343   /**
1344    * @dev See {IERC721-ownerOf}.
1345    */
1346   function ownerOf(uint256 tokenId) public view override returns (address) {
1347     return ownershipOf(tokenId).addr;
1348   }
1349 
1350   /**
1351    * @dev See {IERC721Metadata-name}.
1352    */
1353   function name() public view virtual override returns (string memory) {
1354     return _name;
1355   }
1356 
1357   /**
1358    * @dev See {IERC721Metadata-symbol}.
1359    */
1360   function symbol() public view virtual override returns (string memory) {
1361     return _symbol;
1362   }
1363 
1364   /**
1365    * @dev See {IERC721Metadata-tokenURI}.
1366    */
1367   function tokenURI(uint256 tokenId)
1368     public
1369     view
1370     virtual
1371     override
1372     returns (string memory)
1373   {
1374     require(
1375       _exists(tokenId),
1376       "ERC721Metadata: URI query for nonexistent token"
1377     );
1378 
1379     string memory baseURI = _baseURI();
1380     return
1381       bytes(baseURI).length > 0
1382         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1383         : "";
1384   }
1385 
1386   /**
1387    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1388    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1389    * by default, can be overriden in child contracts.
1390    */
1391   function _baseURI() internal view virtual returns (string memory) {
1392     return "";
1393   }
1394 
1395   /**
1396    * @dev See {IERC721-approve}.
1397    */
1398   function approve(address to, uint256 tokenId) public override {
1399     address owner = ERC721A.ownerOf(tokenId);
1400     require(to != owner, "ERC721A: approval to current owner");
1401 
1402     require(
1403       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1404       "ERC721A: approve caller is not owner nor approved for all"
1405     );
1406 
1407     _approve(to, tokenId, owner);
1408   }
1409 
1410   /**
1411    * @dev See {IERC721-getApproved}.
1412    */
1413   function getApproved(uint256 tokenId) public view override returns (address) {
1414     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1415 
1416     return _tokenApprovals[tokenId];
1417   }
1418 
1419   /**
1420    * @dev See {IERC721-setApprovalForAll}.
1421    */
1422   function setApprovalForAll(address operator, bool approved) public override {
1423     require(operator != _msgSender(), "ERC721A: approve to caller");
1424 
1425     _operatorApprovals[_msgSender()][operator] = approved;
1426     emit ApprovalForAll(_msgSender(), operator, approved);
1427   }
1428 
1429   /**
1430    * @dev See {IERC721-isApprovedForAll}.
1431    */
1432   function isApprovedForAll(address owner, address operator)
1433     public
1434     view
1435     virtual
1436     override
1437     returns (bool)
1438   {
1439     return _operatorApprovals[owner][operator];
1440   }
1441 
1442   /**
1443    * @dev See {IERC721-transferFrom}.
1444    */
1445   function transferFrom(
1446     address from,
1447     address to,
1448     uint256 tokenId
1449   ) public override {
1450     _transfer(from, to, tokenId);
1451   }
1452 
1453   /**
1454    * @dev See {IERC721-safeTransferFrom}.
1455    */
1456   function safeTransferFrom(
1457     address from,
1458     address to,
1459     uint256 tokenId
1460   ) public override {
1461     safeTransferFrom(from, to, tokenId, "");
1462   }
1463 
1464   /**
1465    * @dev See {IERC721-safeTransferFrom}.
1466    */
1467   function safeTransferFrom(
1468     address from,
1469     address to,
1470     uint256 tokenId,
1471     bytes memory _data
1472   ) public override {
1473     _transfer(from, to, tokenId);
1474     require(
1475       _checkOnERC721Received(from, to, tokenId, _data),
1476       "ERC721A: transfer to non ERC721Receiver implementer"
1477     );
1478   }
1479 
1480   /**
1481    * @dev Returns whether `tokenId` exists.
1482    *
1483    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1484    *
1485    * Tokens start existing when they are minted (`_mint`),
1486    */
1487   function _exists(uint256 tokenId) internal view returns (bool) {
1488     return tokenId < currentIndex;
1489   }
1490 
1491   function _safeMint(address to, uint256 quantity) internal {
1492     _safeMint(to, quantity, "");
1493   }
1494 
1495   /**
1496    * @dev Mints `quantity` tokens and transfers them to `to`.
1497    *
1498    * Requirements:
1499    *
1500    * - there must be `quantity` tokens remaining unminted in the total collection.
1501    * - `to` cannot be the zero address.
1502    * - `quantity` cannot be larger than the max batch size.
1503    *
1504    * Emits a {Transfer} event.
1505    */
1506   function _safeMint(
1507     address to,
1508     uint256 quantity,
1509     bytes memory _data
1510   ) internal {
1511     uint256 startTokenId = currentIndex;
1512     require(to != address(0), "ERC721A: mint to the zero address");
1513     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1514     require(!_exists(startTokenId), "ERC721A: token already minted");
1515     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1516 
1517     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1518 
1519     AddressData memory addressData = _addressData[to];
1520     _addressData[to] = AddressData(
1521       addressData.balance + uint128(quantity),
1522       addressData.numberMinted + uint128(quantity)
1523     );
1524     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1525 
1526     uint256 updatedIndex = startTokenId;
1527 
1528     for (uint256 i = 0; i < quantity; i++) {
1529       emit Transfer(address(0), to, updatedIndex);
1530       require(
1531         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1532         "ERC721A: transfer to non ERC721Receiver implementer"
1533       );
1534       updatedIndex++;
1535     }
1536 
1537     currentIndex = updatedIndex;
1538     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1539   }
1540 
1541   /**
1542    * @dev Transfers `tokenId` from `from` to `to`.
1543    *
1544    * Requirements:
1545    *
1546    * - `to` cannot be the zero address.
1547    * - `tokenId` token must be owned by `from`.
1548    *
1549    * Emits a {Transfer} event.
1550    */
1551   function _transfer(
1552     address from,
1553     address to,
1554     uint256 tokenId
1555   ) private {
1556     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1557 
1558     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1559       getApproved(tokenId) == _msgSender() ||
1560       isApprovedForAll(prevOwnership.addr, _msgSender()));
1561 
1562     require(
1563       isApprovedOrOwner,
1564       "ERC721A: transfer caller is not owner nor approved"
1565     );
1566 
1567     require(
1568       prevOwnership.addr == from,
1569       "ERC721A: transfer from incorrect owner"
1570     );
1571     require(to != address(0), "ERC721A: transfer to the zero address");
1572 
1573     _beforeTokenTransfers(from, to, tokenId, 1);
1574 
1575     // Clear approvals from the previous owner
1576     _approve(address(0), tokenId, prevOwnership.addr);
1577 
1578     _addressData[from].balance -= 1;
1579     _addressData[to].balance += 1;
1580     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1581 
1582     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1583     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1584     uint256 nextTokenId = tokenId + 1;
1585     if (_ownerships[nextTokenId].addr == address(0)) {
1586       if (_exists(nextTokenId)) {
1587         _ownerships[nextTokenId] = TokenOwnership(
1588           prevOwnership.addr,
1589           prevOwnership.startTimestamp
1590         );
1591       }
1592     }
1593 
1594     emit Transfer(from, to, tokenId);
1595     _afterTokenTransfers(from, to, tokenId, 1);
1596   }
1597 
1598   /**
1599    * @dev Approve `to` to operate on `tokenId`
1600    *
1601    * Emits a {Approval} event.
1602    */
1603   function _approve(
1604     address to,
1605     uint256 tokenId,
1606     address owner
1607   ) private {
1608     _tokenApprovals[tokenId] = to;
1609     emit Approval(owner, to, tokenId);
1610   }
1611 
1612   uint256 public nextOwnerToExplicitlySet = 0;
1613 
1614   /**
1615    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1616    */
1617   function _setOwnersExplicit(uint256 quantity) internal {
1618     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1619     require(quantity > 0, "quantity must be nonzero");
1620     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1621     if (endIndex > collectionSize - 1) {
1622       endIndex = collectionSize - 1;
1623     }
1624     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1625     require(_exists(endIndex), "not enough minted yet for this cleanup");
1626     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1627       if (_ownerships[i].addr == address(0)) {
1628         TokenOwnership memory ownership = ownershipOf(i);
1629         _ownerships[i] = TokenOwnership(
1630           ownership.addr,
1631           ownership.startTimestamp
1632         );
1633       }
1634     }
1635     nextOwnerToExplicitlySet = endIndex + 1;
1636   }
1637 
1638   /**
1639    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1640    * The call is not executed if the target address is not a contract.
1641    *
1642    * @param from address representing the previous owner of the given token ID
1643    * @param to target address that will receive the tokens
1644    * @param tokenId uint256 ID of the token to be transferred
1645    * @param _data bytes optional data to send along with the call
1646    * @return bool whether the call correctly returned the expected magic value
1647    */
1648   function _checkOnERC721Received(
1649     address from,
1650     address to,
1651     uint256 tokenId,
1652     bytes memory _data
1653   ) private returns (bool) {
1654     if (to.isContract()) {
1655       try
1656         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1657       returns (bytes4 retval) {
1658         return retval == IERC721Receiver(to).onERC721Received.selector;
1659       } catch (bytes memory reason) {
1660         if (reason.length == 0) {
1661           revert("ERC721A: transfer to non ERC721Receiver implementer");
1662         } else {
1663           assembly {
1664             revert(add(32, reason), mload(reason))
1665           }
1666         }
1667       }
1668     } else {
1669       return true;
1670     }
1671   }
1672 
1673   /**
1674    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1675    *
1676    * startTokenId - the first token id to be transferred
1677    * quantity - the amount to be transferred
1678    *
1679    * Calling conditions:
1680    *
1681    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1682    * transferred to `to`.
1683    * - When `from` is zero, `tokenId` will be minted for `to`.
1684    */
1685   function _beforeTokenTransfers(
1686     address from,
1687     address to,
1688     uint256 startTokenId,
1689     uint256 quantity
1690   ) internal virtual {}
1691 
1692   /**
1693    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1694    * minting.
1695    *
1696    * startTokenId - the first token id to be transferred
1697    * quantity - the amount to be transferred
1698    *
1699    * Calling conditions:
1700    *
1701    * - when `from` and `to` are both non-zero.
1702    * - `from` and `to` are never both zero.
1703    */
1704   function _afterTokenTransfers(
1705     address from,
1706     address to,
1707     uint256 startTokenId,
1708     uint256 quantity
1709   ) internal virtual {}
1710 }
1711 
1712 //SPDX-License-Identifier: MIT
1713 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1714 
1715 pragma solidity ^0.8.0;
1716 
1717 contract DOODLES2 is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1718     using Counters for Counters.Counter;
1719     using Strings for uint256;
1720 
1721     Counters.Counter private tokenCounter;
1722 
1723     string private baseURI = "ipfs://QmaSDmzEZ3ZaRaZDKEq7998u28whUGh2tLne4o4Rvx579Q";
1724     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1725     bool private isOpenSeaProxyActive = true;
1726 
1727     uint256 public constant MAX_MINTS_PER_TX = 3;
1728     uint256 public maxSupply = 3000;
1729 
1730     uint256 public constant PUBLIC_SALE_PRICE = 0.005 ether;
1731     uint256 public NUM_FREE_MINTS = 1000;
1732     bool public isPublicSaleActive = true;
1733 
1734 
1735 
1736 
1737     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1738 
1739     modifier publicSaleActive() {
1740         require(isPublicSaleActive, "Public sale is not open");
1741         _;
1742     }
1743 
1744 
1745 
1746     modifier maxMintsPerTX(uint256 numberOfTokens) {
1747         require(
1748             numberOfTokens <= MAX_MINTS_PER_TX,
1749             "Max mints per transaction exceeded"
1750         );
1751         _;
1752     }
1753 
1754     modifier canMintNFTs(uint256 numberOfTokens) {
1755         require(
1756             totalSupply() + numberOfTokens <=
1757                 maxSupply,
1758             "Not enough mints remaining to mint"
1759         );
1760         _;
1761     }
1762 
1763     modifier freeMintsAvailable() {
1764         require(
1765             totalSupply() <=
1766                 NUM_FREE_MINTS,
1767             "Not enough free mints remain"
1768         );
1769         _;
1770     }
1771 
1772 
1773 
1774     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1775         if(totalSupply()>NUM_FREE_MINTS){
1776         require(
1777             (price * numberOfTokens) == msg.value,
1778             "Incorrect ETH value sent"
1779         );
1780         }
1781         _;
1782     }
1783 
1784 
1785     constructor(
1786     ) ERC721A("Doodles 2.0", "DOODLE2", 100, maxSupply) {
1787     }
1788 
1789     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1790 
1791     function mint(uint256 numberOfTokens)
1792         external
1793         payable
1794         nonReentrant
1795         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1796         publicSaleActive
1797         canMintNFTs(numberOfTokens)
1798         maxMintsPerTX(numberOfTokens)
1799     {
1800 
1801         _safeMint(msg.sender, numberOfTokens);
1802     }
1803 
1804 
1805 
1806     //A simple free mint function to avoid confusion
1807     //The normal mint function with a cost of 0 would work too
1808 
1809     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1810 
1811     function getBaseURI() external view returns (string memory) {
1812         return baseURI;
1813     }
1814 
1815     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1816 
1817     function setBaseURI(string memory _baseURI) external onlyOwner {
1818         baseURI = _baseURI;
1819     }
1820 
1821     // function to disable gasless listings for security in case
1822     // opensea ever shuts down or is compromised
1823     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1824         external
1825         onlyOwner
1826     {
1827         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1828     }
1829 
1830     function setIsPublicSaleActive(bool _isPublicSaleActive)
1831         external
1832         onlyOwner
1833     {
1834         isPublicSaleActive = _isPublicSaleActive;
1835     }
1836 
1837 
1838     function mints(uint256 _numfreemints)
1839         external
1840         onlyOwner
1841     {
1842         NUM_FREE_MINTS = _numfreemints;
1843     }
1844 
1845 
1846     function withdraw() public onlyOwner {
1847         uint256 balance = address(this).balance;
1848         payable(msg.sender).transfer(balance);
1849     }
1850 
1851     function withdrawTokens(IERC20 token) public onlyOwner {
1852         uint256 balance = token.balanceOf(address(this));
1853         token.transfer(msg.sender, balance);
1854     }
1855 
1856 
1857 
1858     // ============ SUPPORTING FUNCTIONS ============
1859 
1860     function nextTokenId() private returns (uint256) {
1861         tokenCounter.increment();
1862         return tokenCounter.current();
1863     }
1864 
1865     // ============ FUNCTION OVERRIDES ============
1866 
1867     function supportsInterface(bytes4 interfaceId)
1868         public
1869         view
1870         virtual
1871         override(ERC721A, IERC165)
1872         returns (bool)
1873     {
1874         return
1875             interfaceId == type(IERC2981).interfaceId ||
1876             super.supportsInterface(interfaceId);
1877     }
1878 
1879     /**
1880      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1881      */
1882     function isApprovedForAll(address owner, address operator)
1883         public
1884         view
1885         override
1886         returns (bool)
1887     {
1888         // Get a reference to OpenSea's proxy registry contract by instantiating
1889         // the contract using the already existing address.
1890         ProxyRegistry proxyRegistry = ProxyRegistry(
1891             openSeaProxyRegistryAddress
1892         );
1893         if (
1894             isOpenSeaProxyActive &&
1895             address(proxyRegistry.proxies(owner)) == operator
1896         ) {
1897             return true;
1898         }
1899 
1900         return super.isApprovedForAll(owner, operator);
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
1916             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
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