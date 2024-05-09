1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Counters.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @title Counters
240  * @author Matt Condon (@shrugs)
241  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
242  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
243  *
244  * Include with `using Counters for Counters.Counter;`
245  */
246 library Counters {
247     struct Counter {
248         // This variable should never be directly accessed by users of the library: interactions must be restricted to
249         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
250         // this feature: see https://github.com/ethereum/solidity/issues/4637
251         uint256 _value; // default: 0
252     }
253 
254     function current(Counter storage counter) internal view returns (uint256) {
255         return counter._value;
256     }
257 
258     function increment(Counter storage counter) internal {
259         unchecked {
260             counter._value += 1;
261         }
262     }
263 
264     function decrement(Counter storage counter) internal {
265         uint256 value = counter._value;
266         require(value > 0, "Counter: decrement overflow");
267         unchecked {
268             counter._value = value - 1;
269         }
270     }
271 
272     function reset(Counter storage counter) internal {
273         counter._value = 0;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
278 
279 
280 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Contract module that helps prevent reentrant calls to a function.
286  *
287  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
288  * available, which can be applied to functions to make sure there are no nested
289  * (reentrant) calls to them.
290  *
291  * Note that because there is a single `nonReentrant` guard, functions marked as
292  * `nonReentrant` may not call one another. This can be worked around by making
293  * those functions `private`, and then adding `external` `nonReentrant` entry
294  * points to them.
295  *
296  * TIP: If you would like to learn more about reentrancy and alternative ways
297  * to protect against it, check out our blog post
298  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
299  */
300 abstract contract ReentrancyGuard {
301     // Booleans are more expensive than uint256 or any type that takes up a full
302     // word because each write operation emits an extra SLOAD to first read the
303     // slot's contents, replace the bits taken up by the boolean, and then write
304     // back. This is the compiler's defense against contract upgrades and
305     // pointer aliasing, and it cannot be disabled.
306 
307     // The values being non-zero value makes deployment a bit more expensive,
308     // but in exchange the refund on every call to nonReentrant will be lower in
309     // amount. Since refunds are capped to a percentage of the total
310     // transaction's gas, it is best to keep them low in cases like this one, to
311     // increase the likelihood of the full refund coming into effect.
312     uint256 private constant _NOT_ENTERED = 1;
313     uint256 private constant _ENTERED = 2;
314 
315     uint256 private _status;
316 
317     constructor() {
318         _status = _NOT_ENTERED;
319     }
320 
321     /**
322      * @dev Prevents a contract from calling itself, directly or indirectly.
323      * Calling a `nonReentrant` function from another `nonReentrant`
324      * function is not supported. It is possible to prevent this from happening
325      * by making the `nonReentrant` function external, and making it call a
326      * `private` function that does the actual work.
327      */
328     modifier nonReentrant() {
329         // On the first call to nonReentrant, _notEntered will be true
330         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
331 
332         // Any calls to nonReentrant after this point will fail
333         _status = _ENTERED;
334 
335         _;
336 
337         // By storing the original value once again, a refund is triggered (see
338         // https://eips.ethereum.org/EIPS/eip-2200)
339         _status = _NOT_ENTERED;
340     }
341 }
342 
343 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
344 
345 
346 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Interface of the ERC20 standard as defined in the EIP.
352  */
353 interface IERC20 {
354     /**
355      * @dev Returns the amount of tokens in existence.
356      */
357     function totalSupply() external view returns (uint256);
358 
359     /**
360      * @dev Returns the amount of tokens owned by `account`.
361      */
362     function balanceOf(address account) external view returns (uint256);
363 
364     /**
365      * @dev Moves `amount` tokens from the caller's account to `recipient`.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transfer(address recipient, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Returns the remaining number of tokens that `spender` will be
375      * allowed to spend on behalf of `owner` through {transferFrom}. This is
376      * zero by default.
377      *
378      * This value changes when {approve} or {transferFrom} are called.
379      */
380     function allowance(address owner, address spender) external view returns (uint256);
381 
382     /**
383      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * IMPORTANT: Beware that changing an allowance with this method brings the risk
388      * that someone may use both the old and the new allowance by unfortunate
389      * transaction ordering. One possible solution to mitigate this race
390      * condition is to first reduce the spender's allowance to 0 and set the
391      * desired value afterwards:
392      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
393      *
394      * Emits an {Approval} event.
395      */
396     function approve(address spender, uint256 amount) external returns (bool);
397 
398     /**
399      * @dev Moves `amount` tokens from `sender` to `recipient` using the
400      * allowance mechanism. `amount` is then deducted from the caller's
401      * allowance.
402      *
403      * Returns a boolean value indicating whether the operation succeeded.
404      *
405      * Emits a {Transfer} event.
406      */
407     function transferFrom(
408         address sender,
409         address recipient,
410         uint256 amount
411     ) external returns (bool);
412 
413     /**
414      * @dev Emitted when `value` tokens are moved from one account (`from`) to
415      * another (`to`).
416      *
417      * Note that `value` may be zero.
418      */
419     event Transfer(address indexed from, address indexed to, uint256 value);
420 
421     /**
422      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
423      * a call to {approve}. `value` is the new allowance.
424      */
425     event Approval(address indexed owner, address indexed spender, uint256 value);
426 }
427 
428 // File: @openzeppelin/contracts/interfaces/IERC20.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 
436 // File: @openzeppelin/contracts/utils/Strings.sol
437 
438 
439 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 /**
444  * @dev String operations.
445  */
446 library Strings {
447     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
448 
449     /**
450      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
451      */
452     function toString(uint256 value) internal pure returns (string memory) {
453         // Inspired by OraclizeAPI's implementation - MIT licence
454         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
455 
456         if (value == 0) {
457             return "0";
458         }
459         uint256 temp = value;
460         uint256 digits;
461         while (temp != 0) {
462             digits++;
463             temp /= 10;
464         }
465         bytes memory buffer = new bytes(digits);
466         while (value != 0) {
467             digits -= 1;
468             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
469             value /= 10;
470         }
471         return string(buffer);
472     }
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
476      */
477     function toHexString(uint256 value) internal pure returns (string memory) {
478         if (value == 0) {
479             return "0x00";
480         }
481         uint256 temp = value;
482         uint256 length = 0;
483         while (temp != 0) {
484             length++;
485             temp >>= 8;
486         }
487         return toHexString(value, length);
488     }
489 
490     /**
491      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
492      */
493     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
494         bytes memory buffer = new bytes(2 * length + 2);
495         buffer[0] = "0";
496         buffer[1] = "x";
497         for (uint256 i = 2 * length + 1; i > 1; --i) {
498             buffer[i] = _HEX_SYMBOLS[value & 0xf];
499             value >>= 4;
500         }
501         require(value == 0, "Strings: hex length insufficient");
502         return string(buffer);
503     }
504 }
505 
506 // File: @openzeppelin/contracts/utils/Context.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev Provides information about the current execution context, including the
515  * sender of the transaction and its data. While these are generally available
516  * via msg.sender and msg.data, they should not be accessed in such a direct
517  * manner, since when dealing with meta-transactions the account sending and
518  * paying for execution may not be the actual sender (as far as an application
519  * is concerned).
520  *
521  * This contract is only required for intermediate, library-like contracts.
522  */
523 abstract contract Context {
524     function _msgSender() internal view virtual returns (address) {
525         return msg.sender;
526     }
527 
528     function _msgData() internal view virtual returns (bytes calldata) {
529         return msg.data;
530     }
531 }
532 
533 // File: @openzeppelin/contracts/access/Ownable.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Contract module which provides a basic access control mechanism, where
543  * there is an account (an owner) that can be granted exclusive access to
544  * specific functions.
545  *
546  * By default, the owner account will be the one that deploys the contract. This
547  * can later be changed with {transferOwnership}.
548  *
549  * This module is used through inheritance. It will make available the modifier
550  * `onlyOwner`, which can be applied to your functions to restrict their use to
551  * the owner.
552  */
553 abstract contract Ownable is Context {
554     address private _owner;
555 
556     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
557 
558     /**
559      * @dev Initializes the contract setting the deployer as the initial owner.
560      */
561     constructor() {
562         _transferOwnership(_msgSender());
563     }
564 
565     /**
566      * @dev Returns the address of the current owner.
567      */
568     function owner() public view virtual returns (address) {
569         return _owner;
570     }
571 
572     /**
573      * @dev Throws if called by any account other than the owner.
574      */
575     modifier onlyOwner() {
576         require(owner() == _msgSender(), "Ownable: caller is not the owner");
577         _;
578     }
579 
580     /**
581      * @dev Leaves the contract without owner. It will not be possible to call
582      * `onlyOwner` functions anymore. Can only be called by the current owner.
583      *
584      * NOTE: Renouncing ownership will leave the contract without an owner,
585      * thereby removing any functionality that is only available to the owner.
586      */
587     function renounceOwnership() public virtual onlyOwner {
588         _transferOwnership(address(0));
589     }
590 
591     /**
592      * @dev Transfers ownership of the contract to a new account (`newOwner`).
593      * Can only be called by the current owner.
594      */
595     function transferOwnership(address newOwner) public virtual onlyOwner {
596         require(newOwner != address(0), "Ownable: new owner is the zero address");
597         _transferOwnership(newOwner);
598     }
599 
600     /**
601      * @dev Transfers ownership of the contract to a new account (`newOwner`).
602      * Internal function without access restriction.
603      */
604     function _transferOwnership(address newOwner) internal virtual {
605         address oldOwner = _owner;
606         _owner = newOwner;
607         emit OwnershipTransferred(oldOwner, newOwner);
608     }
609 }
610 
611 // File: @openzeppelin/contracts/utils/Address.sol
612 
613 
614 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 /**
619  * @dev Collection of functions related to the address type
620  */
621 library Address {
622     /**
623      * @dev Returns true if `account` is a contract.
624      *
625      * [IMPORTANT]
626      * ====
627      * It is unsafe to assume that an address for which this function returns
628      * false is an externally-owned account (EOA) and not a contract.
629      *
630      * Among others, `isContract` will return false for the following
631      * types of addresses:
632      *
633      *  - an externally-owned account
634      *  - a contract in construction
635      *  - an address where a contract will be created
636      *  - an address where a contract lived, but was destroyed
637      * ====
638      */
639     function isContract(address account) internal view returns (bool) {
640         // This method relies on extcodesize, which returns 0 for contracts in
641         // construction, since the code is only stored at the end of the
642         // constructor execution.
643 
644         uint256 size;
645         assembly {
646             size := extcodesize(account)
647         }
648         return size > 0;
649     }
650 
651     /**
652      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
653      * `recipient`, forwarding all available gas and reverting on errors.
654      *
655      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
656      * of certain opcodes, possibly making contracts go over the 2300 gas limit
657      * imposed by `transfer`, making them unable to receive funds via
658      * `transfer`. {sendValue} removes this limitation.
659      *
660      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
661      *
662      * IMPORTANT: because control is transferred to `recipient`, care must be
663      * taken to not create reentrancy vulnerabilities. Consider using
664      * {ReentrancyGuard} or the
665      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
666      */
667     function sendValue(address payable recipient, uint256 amount) internal {
668         require(address(this).balance >= amount, "Address: insufficient balance");
669 
670         (bool success, ) = recipient.call{value: amount}("");
671         require(success, "Address: unable to send value, recipient may have reverted");
672     }
673 
674     /**
675      * @dev Performs a Solidity function call using a low level `call`. A
676      * plain `call` is an unsafe replacement for a function call: use this
677      * function instead.
678      *
679      * If `target` reverts with a revert reason, it is bubbled up by this
680      * function (like regular Solidity function calls).
681      *
682      * Returns the raw returned data. To convert to the expected return value,
683      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
684      *
685      * Requirements:
686      *
687      * - `target` must be a contract.
688      * - calling `target` with `data` must not revert.
689      *
690      * _Available since v3.1._
691      */
692     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
693         return functionCall(target, data, "Address: low-level call failed");
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
698      * `errorMessage` as a fallback revert reason when `target` reverts.
699      *
700      * _Available since v3.1._
701      */
702     function functionCall(
703         address target,
704         bytes memory data,
705         string memory errorMessage
706     ) internal returns (bytes memory) {
707         return functionCallWithValue(target, data, 0, errorMessage);
708     }
709 
710     /**
711      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
712      * but also transferring `value` wei to `target`.
713      *
714      * Requirements:
715      *
716      * - the calling contract must have an ETH balance of at least `value`.
717      * - the called Solidity function must be `payable`.
718      *
719      * _Available since v3.1._
720      */
721     function functionCallWithValue(
722         address target,
723         bytes memory data,
724         uint256 value
725     ) internal returns (bytes memory) {
726         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
731      * with `errorMessage` as a fallback revert reason when `target` reverts.
732      *
733      * _Available since v3.1._
734      */
735     function functionCallWithValue(
736         address target,
737         bytes memory data,
738         uint256 value,
739         string memory errorMessage
740     ) internal returns (bytes memory) {
741         require(address(this).balance >= value, "Address: insufficient balance for call");
742         require(isContract(target), "Address: call to non-contract");
743 
744         (bool success, bytes memory returndata) = target.call{value: value}(data);
745         return verifyCallResult(success, returndata, errorMessage);
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
750      * but performing a static call.
751      *
752      * _Available since v3.3._
753      */
754     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
755         return functionStaticCall(target, data, "Address: low-level static call failed");
756     }
757 
758     /**
759      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
760      * but performing a static call.
761      *
762      * _Available since v3.3._
763      */
764     function functionStaticCall(
765         address target,
766         bytes memory data,
767         string memory errorMessage
768     ) internal view returns (bytes memory) {
769         require(isContract(target), "Address: static call to non-contract");
770 
771         (bool success, bytes memory returndata) = target.staticcall(data);
772         return verifyCallResult(success, returndata, errorMessage);
773     }
774 
775     /**
776      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
777      * but performing a delegate call.
778      *
779      * _Available since v3.4._
780      */
781     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
782         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
787      * but performing a delegate call.
788      *
789      * _Available since v3.4._
790      */
791     function functionDelegateCall(
792         address target,
793         bytes memory data,
794         string memory errorMessage
795     ) internal returns (bytes memory) {
796         require(isContract(target), "Address: delegate call to non-contract");
797 
798         (bool success, bytes memory returndata) = target.delegatecall(data);
799         return verifyCallResult(success, returndata, errorMessage);
800     }
801 
802     /**
803      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
804      * revert reason using the provided one.
805      *
806      * _Available since v4.3._
807      */
808     function verifyCallResult(
809         bool success,
810         bytes memory returndata,
811         string memory errorMessage
812     ) internal pure returns (bytes memory) {
813         if (success) {
814             return returndata;
815         } else {
816             // Look for revert reason and bubble it up if present
817             if (returndata.length > 0) {
818                 // The easiest way to bubble the revert reason is using memory via assembly
819 
820                 assembly {
821                     let returndata_size := mload(returndata)
822                     revert(add(32, returndata), returndata_size)
823                 }
824             } else {
825                 revert(errorMessage);
826             }
827         }
828     }
829 }
830 
831 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
832 
833 
834 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
835 
836 pragma solidity ^0.8.0;
837 
838 /**
839  * @title ERC721 token receiver interface
840  * @dev Interface for any contract that wants to support safeTransfers
841  * from ERC721 asset contracts.
842  */
843 interface IERC721Receiver {
844     /**
845      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
846      * by `operator` from `from`, this function is called.
847      *
848      * It must return its Solidity selector to confirm the token transfer.
849      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
850      *
851      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
852      */
853     function onERC721Received(
854         address operator,
855         address from,
856         uint256 tokenId,
857         bytes calldata data
858     ) external returns (bytes4);
859 }
860 
861 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
862 
863 
864 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
865 
866 pragma solidity ^0.8.0;
867 
868 /**
869  * @dev Interface of the ERC165 standard, as defined in the
870  * https://eips.ethereum.org/EIPS/eip-165[EIP].
871  *
872  * Implementers can declare support of contract interfaces, which can then be
873  * queried by others ({ERC165Checker}).
874  *
875  * For an implementation, see {ERC165}.
876  */
877 interface IERC165 {
878     /**
879      * @dev Returns true if this contract implements the interface defined by
880      * `interfaceId`. See the corresponding
881      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
882      * to learn more about how these ids are created.
883      *
884      * This function call must use less than 30 000 gas.
885      */
886     function supportsInterface(bytes4 interfaceId) external view returns (bool);
887 }
888 
889 // File: @openzeppelin/contracts/interfaces/IERC165.sol
890 
891 
892 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 
897 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
898 
899 
900 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
901 
902 pragma solidity ^0.8.0;
903 
904 
905 /**
906  * @dev Interface for the NFT Royalty Standard
907  */
908 interface IERC2981 is IERC165 {
909     /**
910      * @dev Called with the sale price to determine how much royalty is owed and to whom.
911      * @param tokenId - the NFT asset queried for royalty information
912      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
913      * @return receiver - address of who should be sent the royalty payment
914      * @return royaltyAmount - the royalty payment amount for `salePrice`
915      */
916     function royaltyInfo(uint256 tokenId, uint256 salePrice)
917         external
918         view
919         returns (address receiver, uint256 royaltyAmount);
920 }
921 
922 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
923 
924 
925 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 /**
931  * @dev Implementation of the {IERC165} interface.
932  *
933  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
934  * for the additional interface id that will be supported. For example:
935  *
936  * ```solidity
937  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
938  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
939  * }
940  * ```
941  *
942  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
943  */
944 abstract contract ERC165 is IERC165 {
945     /**
946      * @dev See {IERC165-supportsInterface}.
947      */
948     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
949         return interfaceId == type(IERC165).interfaceId;
950     }
951 }
952 
953 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
954 
955 
956 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
957 
958 pragma solidity ^0.8.0;
959 
960 
961 /**
962  * @dev Required interface of an ERC721 compliant contract.
963  */
964 interface IERC721 is IERC165 {
965     /**
966      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
967      */
968     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
969 
970     /**
971      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
972      */
973     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
974 
975     /**
976      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
977      */
978     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
979 
980     /**
981      * @dev Returns the number of tokens in ``owner``'s account.
982      */
983     function balanceOf(address owner) external view returns (uint256 balance);
984 
985     /**
986      * @dev Returns the owner of the `tokenId` token.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      */
992     function ownerOf(uint256 tokenId) external view returns (address owner);
993 
994     /**
995      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
996      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
997      *
998      * Requirements:
999      *
1000      * - `from` cannot be the zero address.
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must exist and be owned by `from`.
1003      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) external;
1013 
1014     /**
1015      * @dev Transfers `tokenId` token from `from` to `to`.
1016      *
1017      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1018      *
1019      * Requirements:
1020      *
1021      * - `from` cannot be the zero address.
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must be owned by `from`.
1024      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function transferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) external;
1033 
1034     /**
1035      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1036      * The approval is cleared when the token is transferred.
1037      *
1038      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1039      *
1040      * Requirements:
1041      *
1042      * - The caller must own the token or be an approved operator.
1043      * - `tokenId` must exist.
1044      *
1045      * Emits an {Approval} event.
1046      */
1047     function approve(address to, uint256 tokenId) external;
1048 
1049     /**
1050      * @dev Returns the account approved for `tokenId` token.
1051      *
1052      * Requirements:
1053      *
1054      * - `tokenId` must exist.
1055      */
1056     function getApproved(uint256 tokenId) external view returns (address operator);
1057 
1058     /**
1059      * @dev Approve or remove `operator` as an operator for the caller.
1060      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1061      *
1062      * Requirements:
1063      *
1064      * - The `operator` cannot be the caller.
1065      *
1066      * Emits an {ApprovalForAll} event.
1067      */
1068     function setApprovalForAll(address operator, bool _approved) external;
1069 
1070     /**
1071      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1072      *
1073      * See {setApprovalForAll}
1074      */
1075     function isApprovedForAll(address owner, address operator) external view returns (bool);
1076 
1077     /**
1078      * @dev Safely transfers `tokenId` token from `from` to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `from` cannot be the zero address.
1083      * - `to` cannot be the zero address.
1084      * - `tokenId` token must exist and be owned by `from`.
1085      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1086      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function safeTransferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId,
1094         bytes calldata data
1095     ) external;
1096 }
1097 
1098 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1099 
1100 
1101 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 
1106 /**
1107  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1108  * @dev See https://eips.ethereum.org/EIPS/eip-721
1109  */
1110 interface IERC721Metadata is IERC721 {
1111     /**
1112      * @dev Returns the token collection name.
1113      */
1114     function name() external view returns (string memory);
1115 
1116     /**
1117      * @dev Returns the token collection symbol.
1118      */
1119     function symbol() external view returns (string memory);
1120 
1121     /**
1122      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1123      */
1124     function tokenURI(uint256 tokenId) external view returns (string memory);
1125 }
1126 
1127 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1128 
1129 
1130 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 
1136 
1137 
1138 
1139 
1140 
1141 /**
1142  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1143  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1144  * {ERC721Enumerable}.
1145  */
1146 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1147     using Address for address;
1148     using Strings for uint256;
1149 
1150     // Token name
1151     string private _name;
1152 
1153     // Token symbol
1154     string private _symbol;
1155 
1156     // Mapping from token ID to owner address
1157     mapping(uint256 => address) private _owners;
1158 
1159     // Mapping owner address to token count
1160     mapping(address => uint256) private _balances;
1161 
1162     // Mapping from token ID to approved address
1163     mapping(uint256 => address) private _tokenApprovals;
1164 
1165     // Mapping from owner to operator approvals
1166     mapping(address => mapping(address => bool)) private _operatorApprovals;
1167 
1168     /**
1169      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1170      */
1171     constructor(string memory name_, string memory symbol_) {
1172         _name = name_;
1173         _symbol = symbol_;
1174     }
1175 
1176     /**
1177      * @dev See {IERC165-supportsInterface}.
1178      */
1179     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1180         return
1181             interfaceId == type(IERC721).interfaceId ||
1182             interfaceId == type(IERC721Metadata).interfaceId ||
1183             super.supportsInterface(interfaceId);
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-balanceOf}.
1188      */
1189     function balanceOf(address owner) public view virtual override returns (uint256) {
1190         require(owner != address(0), "ERC721: balance query for the zero address");
1191         return _balances[owner];
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-ownerOf}.
1196      */
1197     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1198         address owner = _owners[tokenId];
1199         require(owner != address(0), "ERC721: owner query for nonexistent token");
1200         return owner;
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Metadata-name}.
1205      */
1206     function name() public view virtual override returns (string memory) {
1207         return _name;
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Metadata-symbol}.
1212      */
1213     function symbol() public view virtual override returns (string memory) {
1214         return _symbol;
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Metadata-tokenURI}.
1219      */
1220     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1221         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1222 
1223         string memory baseURI = _baseURI();
1224         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1225     }
1226 
1227     /**
1228      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1229      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1230      * by default, can be overriden in child contracts.
1231      */
1232     function _baseURI() internal view virtual returns (string memory) {
1233         return "";
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-approve}.
1238      */
1239     function approve(address to, uint256 tokenId) public virtual override {
1240         address owner = ERC721.ownerOf(tokenId);
1241         require(to != owner, "ERC721: approval to current owner");
1242 
1243         require(
1244             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1245             "ERC721: approve caller is not owner nor approved for all"
1246         );
1247 
1248         _approve(to, tokenId);
1249     }
1250 
1251     /**
1252      * @dev See {IERC721-getApproved}.
1253      */
1254     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1255         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1256 
1257         return _tokenApprovals[tokenId];
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-setApprovalForAll}.
1262      */
1263     function setApprovalForAll(address operator, bool approved) public virtual override {
1264         _setApprovalForAll(_msgSender(), operator, approved);
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-isApprovedForAll}.
1269      */
1270     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1271         return _operatorApprovals[owner][operator];
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-transferFrom}.
1276      */
1277     function transferFrom(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) public virtual override {
1282         //solhint-disable-next-line max-line-length
1283         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1284 
1285         _transfer(from, to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-safeTransferFrom}.
1290      */
1291     function safeTransferFrom(
1292         address from,
1293         address to,
1294         uint256 tokenId
1295     ) public virtual override {
1296         safeTransferFrom(from, to, tokenId, "");
1297     }
1298 
1299     /**
1300      * @dev See {IERC721-safeTransferFrom}.
1301      */
1302     function safeTransferFrom(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) public virtual override {
1308         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1309         _safeTransfer(from, to, tokenId, _data);
1310     }
1311 
1312     /**
1313      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1314      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1315      *
1316      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1317      *
1318      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1319      * implement alternative mechanisms to perform token transfer, such as signature-based.
1320      *
1321      * Requirements:
1322      *
1323      * - `from` cannot be the zero address.
1324      * - `to` cannot be the zero address.
1325      * - `tokenId` token must exist and be owned by `from`.
1326      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _safeTransfer(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) internal virtual {
1336         _transfer(from, to, tokenId);
1337         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1338     }
1339 
1340     /**
1341      * @dev Returns whether `tokenId` exists.
1342      *
1343      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1344      *
1345      * Tokens start existing when they are minted (`_mint`),
1346      * and stop existing when they are burned (`_burn`).
1347      */
1348     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1349         return _owners[tokenId] != address(0);
1350     }
1351 
1352     /**
1353      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1354      *
1355      * Requirements:
1356      *
1357      * - `tokenId` must exist.
1358      */
1359     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1360         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1361         address owner = ERC721.ownerOf(tokenId);
1362         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1363     }
1364 
1365     /**
1366      * @dev Safely mints `tokenId` and transfers it to `to`.
1367      *
1368      * Requirements:
1369      *
1370      * - `tokenId` must not exist.
1371      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1372      *
1373      * Emits a {Transfer} event.
1374      */
1375     function _safeMint(address to, uint256 tokenId) internal virtual {
1376         _safeMint(to, tokenId, "");
1377     }
1378 
1379     /**
1380      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1381      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1382      */
1383     function _safeMint(
1384         address to,
1385         uint256 tokenId,
1386         bytes memory _data
1387     ) internal virtual {
1388         _mint(to, tokenId);
1389         require(
1390             _checkOnERC721Received(address(0), to, tokenId, _data),
1391             "ERC721: transfer to non ERC721Receiver implementer"
1392         );
1393     }
1394 
1395     /**
1396      * @dev Mints `tokenId` and transfers it to `to`.
1397      *
1398      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1399      *
1400      * Requirements:
1401      *
1402      * - `tokenId` must not exist.
1403      * - `to` cannot be the zero address.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function _mint(address to, uint256 tokenId) internal virtual {
1408         require(to != address(0), "ERC721: mint to the zero address");
1409         require(!_exists(tokenId), "ERC721: token already minted");
1410 
1411         _beforeTokenTransfer(address(0), to, tokenId);
1412 
1413         _balances[to] += 1;
1414         _owners[tokenId] = to;
1415 
1416         emit Transfer(address(0), to, tokenId);
1417     }
1418 
1419     /**
1420      * @dev Destroys `tokenId`.
1421      * The approval is cleared when the token is burned.
1422      *
1423      * Requirements:
1424      *
1425      * - `tokenId` must exist.
1426      *
1427      * Emits a {Transfer} event.
1428      */
1429     function _burn(uint256 tokenId) internal virtual {
1430         address owner = ERC721.ownerOf(tokenId);
1431 
1432         _beforeTokenTransfer(owner, address(0), tokenId);
1433 
1434         // Clear approvals
1435         _approve(address(0), tokenId);
1436 
1437         _balances[owner] -= 1;
1438         delete _owners[tokenId];
1439 
1440         emit Transfer(owner, address(0), tokenId);
1441     }
1442 
1443     /**
1444      * @dev Transfers `tokenId` from `from` to `to`.
1445      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1446      *
1447      * Requirements:
1448      *
1449      * - `to` cannot be the zero address.
1450      * - `tokenId` token must be owned by `from`.
1451      *
1452      * Emits a {Transfer} event.
1453      */
1454     function _transfer(
1455         address from,
1456         address to,
1457         uint256 tokenId
1458     ) internal virtual {
1459         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1460         require(to != address(0), "ERC721: transfer to the zero address");
1461 
1462         _beforeTokenTransfer(from, to, tokenId);
1463 
1464         // Clear approvals from the previous owner
1465         _approve(address(0), tokenId);
1466 
1467         _balances[from] -= 1;
1468         _balances[to] += 1;
1469         _owners[tokenId] = to;
1470 
1471         emit Transfer(from, to, tokenId);
1472     }
1473 
1474     /**
1475      * @dev Approve `to` to operate on `tokenId`
1476      *
1477      * Emits a {Approval} event.
1478      */
1479     function _approve(address to, uint256 tokenId) internal virtual {
1480         _tokenApprovals[tokenId] = to;
1481         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1482     }
1483 
1484     /**
1485      * @dev Approve `operator` to operate on all of `owner` tokens
1486      *
1487      * Emits a {ApprovalForAll} event.
1488      */
1489     function _setApprovalForAll(
1490         address owner,
1491         address operator,
1492         bool approved
1493     ) internal virtual {
1494         require(owner != operator, "ERC721: approve to caller");
1495         _operatorApprovals[owner][operator] = approved;
1496         emit ApprovalForAll(owner, operator, approved);
1497     }
1498 
1499     /**
1500      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1501      * The call is not executed if the target address is not a contract.
1502      *
1503      * @param from address representing the previous owner of the given token ID
1504      * @param to target address that will receive the tokens
1505      * @param tokenId uint256 ID of the token to be transferred
1506      * @param _data bytes optional data to send along with the call
1507      * @return bool whether the call correctly returned the expected magic value
1508      */
1509     function _checkOnERC721Received(
1510         address from,
1511         address to,
1512         uint256 tokenId,
1513         bytes memory _data
1514     ) private returns (bool) {
1515         if (to.isContract()) {
1516             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1517                 return retval == IERC721Receiver.onERC721Received.selector;
1518             } catch (bytes memory reason) {
1519                 if (reason.length == 0) {
1520                     revert("ERC721: transfer to non ERC721Receiver implementer");
1521                 } else {
1522                     assembly {
1523                         revert(add(32, reason), mload(reason))
1524                     }
1525                 }
1526             }
1527         } else {
1528             return true;
1529         }
1530     }
1531 
1532     /**
1533      * @dev Hook that is called before any token transfer. This includes minting
1534      * and burning.
1535      *
1536      * Calling conditions:
1537      *
1538      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1539      * transferred to `to`.
1540      * - When `from` is zero, `tokenId` will be minted for `to`.
1541      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1542      * - `from` and `to` are never both zero.
1543      *
1544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1545      */
1546     function _beforeTokenTransfer(
1547         address from,
1548         address to,
1549         uint256 tokenId
1550     ) internal virtual {}
1551 }
1552 
1553 
1554 //SPDX-License-Identifier: MIT
1555 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1556 
1557 pragma solidity ^0.8.0;
1558 
1559 
1560 
1561 
1562 
1563 
1564 
1565 
1566 
1567 contract AlienPunks is ERC721, IERC2981, Ownable, ReentrancyGuard {
1568     using Counters for Counters.Counter;
1569     using Strings for uint256;
1570 
1571     Counters.Counter private tokenCounter;
1572 
1573     string private baseURI = "ipfs://QmcAaqMRZ8dSxt6WkQMxeoEZKJ8HqEfphdFgeCAafhgpdh";
1574     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1575     bool private isOpenSeaProxyActive = true;
1576 
1577     uint256 public constant MAX_MINTS_PER_TX = 20;
1578     uint256 public maxSupply = 5000;
1579 
1580     uint256 public constant PUBLIC_SALE_PRICE = 0.02 ether;
1581     uint256 public NUM_FREE_MINTS = 1000;
1582     bool public isPublicSaleActive = true;
1583 
1584 
1585 
1586 
1587     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1588 
1589     modifier publicSaleActive() {
1590         require(isPublicSaleActive, "Public sale is not open");
1591         _;
1592     }
1593 
1594 
1595 
1596     modifier maxMintsPerTX(uint256 numberOfTokens) {
1597         require(
1598             numberOfTokens <= MAX_MINTS_PER_TX,
1599             "Max mints per transaction exceeded"
1600         );
1601         _;
1602     }
1603 
1604     modifier canMintNFTs(uint256 numberOfTokens) {
1605         require(
1606             tokenCounter.current() + numberOfTokens <=
1607                 maxSupply,
1608             "Not enough mints remaining to mint"
1609         );
1610         _;
1611     }
1612 
1613 
1614 
1615     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1616         if(tokenCounter.current()>NUM_FREE_MINTS){
1617         require(
1618             (price * numberOfTokens) == msg.value,
1619             "Incorrect ETH value sent"
1620         );
1621         }
1622         _;
1623     }
1624 
1625 
1626     constructor(
1627     ) ERC721("Alien Punks", "ALIENPUNK") {
1628     }
1629 
1630     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1631 
1632     function mint(uint256 numberOfTokens)
1633         external
1634         payable
1635         nonReentrant
1636         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1637         publicSaleActive
1638         canMintNFTs(numberOfTokens)
1639         maxMintsPerTX(numberOfTokens)
1640     {
1641         //require(numberOfTokens <= MAX_MINTS_PER_TX);
1642         //if(tokenCounter.current()>NUM_FREE_MINTS){
1643         //    require((PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value);
1644         //}
1645         for (uint256 i = 0; i < numberOfTokens; i++) {
1646             _safeMint(msg.sender, nextTokenId());
1647         }
1648     }
1649 
1650 
1651 
1652 
1653     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1654 
1655     function getBaseURI() external view returns (string memory) {
1656         return baseURI;
1657     }
1658 
1659     function getLastTokenId() external view returns (uint256) {
1660         return tokenCounter.current();
1661     }
1662 
1663     function totalSupply() external view returns (uint256) {
1664         return tokenCounter.current();
1665     }
1666 
1667     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1668 
1669     function setBaseURI(string memory _baseURI) external onlyOwner {
1670         baseURI = _baseURI;
1671     }
1672 
1673     // function to disable gasless listings for security in case
1674     // opensea ever shuts down or is compromised
1675     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1676         external
1677         onlyOwner
1678     {
1679         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1680     }
1681 
1682     function setIsPublicSaleActive(bool _isPublicSaleActive)
1683         external
1684         onlyOwner
1685     {
1686         isPublicSaleActive = _isPublicSaleActive;
1687     }
1688 
1689     function setNumFreeMints(uint256 _numfreemints)
1690         external
1691         onlyOwner
1692     {
1693         NUM_FREE_MINTS = _numfreemints;
1694     }
1695 
1696 
1697     function withdraw() public onlyOwner {
1698         uint256 balance = address(this).balance;
1699         payable(msg.sender).transfer(balance);
1700     }
1701 
1702     function withdrawTokens(IERC20 token) public onlyOwner {
1703         uint256 balance = token.balanceOf(address(this));
1704         token.transfer(msg.sender, balance);
1705     }
1706 
1707 
1708 
1709     // ============ SUPPORTING FUNCTIONS ============
1710 
1711     function nextTokenId() private returns (uint256) {
1712         tokenCounter.increment();
1713         return tokenCounter.current();
1714     }
1715 
1716     // ============ FUNCTION OVERRIDES ============
1717 
1718     function supportsInterface(bytes4 interfaceId)
1719         public
1720         view
1721         virtual
1722         override(ERC721, IERC165)
1723         returns (bool)
1724     {
1725         return
1726             interfaceId == type(IERC2981).interfaceId ||
1727             super.supportsInterface(interfaceId);
1728     }
1729 
1730     /**
1731      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1732      */
1733     function isApprovedForAll(address owner, address operator)
1734         public
1735         view
1736         override
1737         returns (bool)
1738     {
1739         // Get a reference to OpenSea's proxy registry contract by instantiating
1740         // the contract using the already existing address.
1741         ProxyRegistry proxyRegistry = ProxyRegistry(
1742             openSeaProxyRegistryAddress
1743         );
1744         if (
1745             isOpenSeaProxyActive &&
1746             address(proxyRegistry.proxies(owner)) == operator
1747         ) {
1748             return true;
1749         }
1750 
1751         return super.isApprovedForAll(owner, operator);
1752     }
1753 
1754     /**
1755      * @dev See {IERC721Metadata-tokenURI}.
1756      */
1757     function tokenURI(uint256 tokenId)
1758         public
1759         view
1760         virtual
1761         override
1762         returns (string memory)
1763     {
1764         require(_exists(tokenId), "Nonexistent token");
1765 
1766         return
1767             string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
1768     }
1769 
1770     /**
1771      * @dev See {IERC165-royaltyInfo}.
1772      */
1773     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1774         external
1775         view
1776         override
1777         returns (address receiver, uint256 royaltyAmount)
1778     {
1779         require(_exists(tokenId), "Nonexistent token");
1780 
1781         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1782     }
1783 }
1784 
1785 // These contract definitions are used to create a reference to the OpenSea
1786 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1787 contract OwnableDelegateProxy {
1788 
1789 }
1790 
1791 contract ProxyRegistry {
1792     mapping(address => OwnableDelegateProxy) public proxies;
1793 }