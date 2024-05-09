1 // File: contracts/re.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-07-09
5 */
6 
7 // File: contracts/re.sol
8 
9 pragma solidity ^0.8.0;
10 
11 // CAUTION
12 // This version of SafeMath should only be used with Solidity 0.8 or later,
13 // because it relies on the compiler's built in overflow checks.
14 
15 /**
16  * @dev Wrappers over Solidity's arithmetic operations.
17  *
18  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
19  * now has built in overflow checking.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, with an overflow flag.
24      *
25      * _Available since v3.4._
26      */
27     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {
29             uint256 c = a + b;
30             if (c < a) return (false, 0);
31             return (true, c);
32         }
33     }
34 
35     /**
36      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
37      *
38      * _Available since v3.4._
39      */
40     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             if (b > a) return (false, 0);
43             return (true, a - b);
44         }
45     }
46 
47     /**
48      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
49      *
50      * _Available since v3.4._
51      */
52     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55             // benefit is lost if 'b' is also tested.
56             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
57             if (a == 0) return (true, 0);
58             uint256 c = a * b;
59             if (c / a != b) return (false, 0);
60             return (true, c);
61         }
62     }
63 
64     /**
65      * @dev Returns the division of two unsigned integers, with a division by zero flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         unchecked {
71             if (b == 0) return (false, 0);
72             return (true, a / b);
73         }
74     }
75 
76     /**
77      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b == 0) return (false, 0);
84             return (true, a % b);
85         }
86     }
87 
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a + b;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a - b;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      *
124      * - Multiplication cannot overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a * b;
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers, reverting on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator.
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a % b;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * CAUTION: This function is deprecated because it requires allocating memory for the error
165      * message unnecessarily. For custom revert reasons use {trySub}.
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(
174         uint256 a,
175         uint256 b,
176         string memory errorMessage
177     ) internal pure returns (uint256) {
178         unchecked {
179             require(b <= a, errorMessage);
180             return a - b;
181         }
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         unchecked {
202             require(b > 0, errorMessage);
203             return a / b;
204         }
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting with custom message when dividing by zero.
210      *
211      * CAUTION: This function is deprecated because it requires allocating memory for the error
212      * message unnecessarily. For custom revert reasons use {tryMod}.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b > 0, errorMessage);
229             return a % b;
230         }
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Counters.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @title Counters
243  * @author Matt Condon (@shrugs)
244  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
245  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
246  *
247  * Include with `using Counters for Counters.Counter;`
248  */
249 library Counters {
250     struct Counter {
251         // This variable should never be directly accessed by users of the library: interactions must be restricted to
252         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
253         // this feature: see https://github.com/ethereum/solidity/issues/4637
254         uint256 _value; // default: 0
255     }
256 
257     function current(Counter storage counter) internal view returns (uint256) {
258         return counter._value;
259     }
260 
261     function increment(Counter storage counter) internal {
262         unchecked {
263             counter._value += 1;
264         }
265     }
266 
267     function decrement(Counter storage counter) internal {
268         uint256 value = counter._value;
269         require(value > 0, "Counter: decrement overflow");
270         unchecked {
271             counter._value = value - 1;
272         }
273     }
274 
275     function reset(Counter storage counter) internal {
276         counter._value = 0;
277     }
278 }
279 
280 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
281 
282 
283 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @dev Contract module that helps prevent reentrant calls to a function.
289  *
290  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
291  * available, which can be applied to functions to make sure there are no nested
292  * (reentrant) calls to them.
293  *
294  * Note that because there is a single `nonReentrant` guard, functions marked as
295  * `nonReentrant` may not call one another. This can be worked around by making
296  * those functions `private`, and then adding `external` `nonReentrant` entry
297  * points to them.
298  *
299  * TIP: If you would like to learn more about reentrancy and alternative ways
300  * to protect against it, check out our blog post
301  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
302  */
303 abstract contract ReentrancyGuard {
304     // Booleans are more expensive than uint256 or any type that takes up a full
305     // word because each write operation emits an extra SLOAD to first read the
306     // slot's contents, replace the bits taken up by the boolean, and then write
307     // back. This is the compiler's defense against contract upgrades and
308     // pointer aliasing, and it cannot be disabled.
309 
310     // The values being non-zero value makes deployment a bit more expensive,
311     // but in exchange the refund on every call to nonReentrant will be lower in
312     // amount. Since refunds are capped to a percentage of the total
313     // transaction's gas, it is best to keep them low in cases like this one, to
314     // increase the likelihood of the full refund coming into effect.
315     uint256 private constant _NOT_ENTERED = 1;
316     uint256 private constant _ENTERED = 2;
317 
318     uint256 private _status;
319 
320     constructor() {
321         _status = _NOT_ENTERED;
322     }
323 
324     /**
325      * @dev Prevents a contract from calling itself, directly or indirectly.
326      * Calling a `nonReentrant` function from another `nonReentrant`
327      * function is not supported. It is possible to prevent this from happening
328      * by making the `nonReentrant` function external, and making it call a
329      * `private` function that does the actual work.
330      */
331     modifier nonReentrant() {
332         // On the first call to nonReentrant, _notEntered will be true
333         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
334 
335         // Any calls to nonReentrant after this point will fail
336         _status = _ENTERED;
337 
338         _;
339 
340         // By storing the original value once again, a refund is triggered (see
341         // https://eips.ethereum.org/EIPS/eip-2200)
342         _status = _NOT_ENTERED;
343     }
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Interface of the ERC20 standard as defined in the EIP.
355  */
356 interface IERC20 {
357     /**
358      * @dev Returns the amount of tokens in existence.
359      */
360     function totalSupply() external view returns (uint256);
361 
362     /**
363      * @dev Returns the amount of tokens owned by `account`.
364      */
365     function balanceOf(address account) external view returns (uint256);
366 
367     /**
368      * @dev Moves `amount` tokens from the caller's account to `recipient`.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * Emits a {Transfer} event.
373      */
374     function transfer(address recipient, uint256 amount) external returns (bool);
375 
376     /**
377      * @dev Returns the remaining number of tokens that `spender` will be
378      * allowed to spend on behalf of `owner` through {transferFrom}. This is
379      * zero by default.
380      *
381      * This value changes when {approve} or {transferFrom} are called.
382      */
383     function allowance(address owner, address spender) external view returns (uint256);
384 
385     /**
386      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * IMPORTANT: Beware that changing an allowance with this method brings the risk
391      * that someone may use both the old and the new allowance by unfortunate
392      * transaction ordering. One possible solution to mitigate this race
393      * condition is to first reduce the spender's allowance to 0 and set the
394      * desired value afterwards:
395      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
396      *
397      * Emits an {Approval} event.
398      */
399     function approve(address spender, uint256 amount) external returns (bool);
400 
401     /**
402      * @dev Moves `amount` tokens from `sender` to `recipient` using the
403      * allowance mechanism. `amount` is then deducted from the caller's
404      * allowance.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address sender,
412         address recipient,
413         uint256 amount
414     ) external returns (bool);
415 
416     /**
417      * @dev Emitted when `value` tokens are moved from one account (`from`) to
418      * another (`to`).
419      *
420      * Note that `value` may be zero.
421      */
422     event Transfer(address indexed from, address indexed to, uint256 value);
423 
424     /**
425      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
426      * a call to {approve}. `value` is the new allowance.
427      */
428     event Approval(address indexed owner, address indexed spender, uint256 value);
429 }
430 
431 // File: @openzeppelin/contracts/interfaces/IERC20.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 
439 // File: @openzeppelin/contracts/utils/Strings.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev String operations.
448  */
449 library Strings {
450     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
451 
452     /**
453      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
454      */
455     function toString(uint256 value) internal pure returns (string memory) {
456         // Inspired by OraclizeAPI's implementation - MIT licence
457         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
458 
459         if (value == 0) {
460             return "0";
461         }
462         uint256 temp = value;
463         uint256 digits;
464         while (temp != 0) {
465             digits++;
466             temp /= 10;
467         }
468         bytes memory buffer = new bytes(digits);
469         while (value != 0) {
470             digits -= 1;
471             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
472             value /= 10;
473         }
474         return string(buffer);
475     }
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
479      */
480     function toHexString(uint256 value) internal pure returns (string memory) {
481         if (value == 0) {
482             return "0x00";
483         }
484         uint256 temp = value;
485         uint256 length = 0;
486         while (temp != 0) {
487             length++;
488             temp >>= 8;
489         }
490         return toHexString(value, length);
491     }
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
495      */
496     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
497         bytes memory buffer = new bytes(2 * length + 2);
498         buffer[0] = "0";
499         buffer[1] = "x";
500         for (uint256 i = 2 * length + 1; i > 1; --i) {
501             buffer[i] = _HEX_SYMBOLS[value & 0xf];
502             value >>= 4;
503         }
504         require(value == 0, "Strings: hex length insufficient");
505         return string(buffer);
506     }
507 }
508 
509 // File: @openzeppelin/contracts/utils/Context.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Provides information about the current execution context, including the
518  * sender of the transaction and its data. While these are generally available
519  * via msg.sender and msg.data, they should not be accessed in such a direct
520  * manner, since when dealing with meta-transactions the account sending and
521  * paying for execution may not be the actual sender (as far as an application
522  * is concerned).
523  *
524  * This contract is only required for intermediate, library-like contracts.
525  */
526 abstract contract Context {
527     function _msgSender() internal view virtual returns (address) {
528         return msg.sender;
529     }
530 
531     function _msgData() internal view virtual returns (bytes calldata) {
532         return msg.data;
533     }
534 }
535 
536 // File: @openzeppelin/contracts/access/Ownable.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @dev Contract module which provides a basic access control mechanism, where
546  * there is an account (an owner) that can be granted exclusive access to
547  * specific functions.
548  *
549  * By default, the owner account will be the one that deploys the contract. This
550  * can later be changed with {transferOwnership}.
551  *
552  * This module is used through inheritance. It will make available the modifier
553  * `onlyOwner`, which can be applied to your functions to restrict their use to
554  * the owner.
555  */
556 abstract contract Ownable is Context {
557     address private _owner;
558 
559     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
560 
561     /**
562      * @dev Initializes the contract setting the deployer as the initial owner.
563      */
564     constructor() {
565         _transferOwnership(_msgSender());
566     }
567 
568     /**
569      * @dev Returns the address of the current owner.
570      */
571     function owner() public view virtual returns (address) {
572         return _owner;
573     }
574 
575     /**
576      * @dev Throws if called by any account other than the owner.
577      */
578     modifier onlyOwner() {
579         require(owner() == _msgSender(), "Ownable: caller is not the owner");
580         _;
581     }
582 
583     /**
584      * @dev Leaves the contract without owner. It will not be possible to call
585      * `onlyOwner` functions anymore. Can only be called by the current owner.
586      *
587      * NOTE: Renouncing ownership will leave the contract without an owner,
588      * thereby removing any functionality that is only available to the owner.
589      */
590     function renounceOwnership() public virtual onlyOwner {
591         _transferOwnership(address(0));
592     }
593 
594     /**
595      * @dev Transfers ownership of the contract to a new account (`newOwner`).
596      * Can only be called by the current owner.
597      */
598     function transferOwnership(address newOwner) public virtual onlyOwner {
599         require(newOwner != address(0), "Ownable: new owner is the zero address");
600         _transferOwnership(newOwner);
601     }
602 
603     /**
604      * @dev Transfers ownership of the contract to a new account (`newOwner`).
605      * Internal function without access restriction.
606      */
607     function _transferOwnership(address newOwner) internal virtual {
608         address oldOwner = _owner;
609         _owner = newOwner;
610         emit OwnershipTransferred(oldOwner, newOwner);
611     }
612 }
613 
614 // File: @openzeppelin/contracts/utils/Address.sol
615 
616 
617 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 /**
622  * @dev Collection of functions related to the address type
623  */
624 library Address {
625     /**
626      * @dev Returns true if `account` is a contract.
627      *
628      * [IMPORTANT]
629      * ====
630      * It is unsafe to assume that an address for which this function returns
631      * false is an externally-owned account (EOA) and not a contract.
632      *
633      * Among others, `isContract` will return false for the following
634      * types of addresses:
635      *
636      *  - an externally-owned account
637      *  - a contract in construction
638      *  - an address where a contract will be created
639      *  - an address where a contract lived, but was destroyed
640      * ====
641      */
642     function isContract(address account) internal view returns (bool) {
643         // This method relies on extcodesize, which returns 0 for contracts in
644         // construction, since the code is only stored at the end of the
645         // constructor execution.
646 
647         uint256 size;
648         assembly {
649             size := extcodesize(account)
650         }
651         return size > 0;
652     }
653 
654     /**
655      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
656      * `recipient`, forwarding all available gas and reverting on errors.
657      *
658      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
659      * of certain opcodes, possibly making contracts go over the 2300 gas limit
660      * imposed by `transfer`, making them unable to receive funds via
661      * `transfer`. {sendValue} removes this limitation.
662      *
663      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
664      *
665      * IMPORTANT: because control is transferred to `recipient`, care must be
666      * taken to not create reentrancy vulnerabilities. Consider using
667      * {ReentrancyGuard} or the
668      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
669      */
670     function sendValue(address payable recipient, uint256 amount) internal {
671         require(address(this).balance >= amount, "Address: insufficient balance");
672 
673         (bool success, ) = recipient.call{value: amount}("");
674         require(success, "Address: unable to send value, recipient may have reverted");
675     }
676 
677     /**
678      * @dev Performs a Solidity function call using a low level `call`. A
679      * plain `call` is an unsafe replacement for a function call: use this
680      * function instead.
681      *
682      * If `target` reverts with a revert reason, it is bubbled up by this
683      * function (like regular Solidity function calls).
684      *
685      * Returns the raw returned data. To convert to the expected return value,
686      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
687      *
688      * Requirements:
689      *
690      * - `target` must be a contract.
691      * - calling `target` with `data` must not revert.
692      *
693      * _Available since v3.1._
694      */
695     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
696         return functionCall(target, data, "Address: low-level call failed");
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
701      * `errorMessage` as a fallback revert reason when `target` reverts.
702      *
703      * _Available since v3.1._
704      */
705     function functionCall(
706         address target,
707         bytes memory data,
708         string memory errorMessage
709     ) internal returns (bytes memory) {
710         return functionCallWithValue(target, data, 0, errorMessage);
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
715      * but also transferring `value` wei to `target`.
716      *
717      * Requirements:
718      *
719      * - the calling contract must have an ETH balance of at least `value`.
720      * - the called Solidity function must be `payable`.
721      *
722      * _Available since v3.1._
723      */
724     function functionCallWithValue(
725         address target,
726         bytes memory data,
727         uint256 value
728     ) internal returns (bytes memory) {
729         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
734      * with `errorMessage` as a fallback revert reason when `target` reverts.
735      *
736      * _Available since v3.1._
737      */
738     function functionCallWithValue(
739         address target,
740         bytes memory data,
741         uint256 value,
742         string memory errorMessage
743     ) internal returns (bytes memory) {
744         require(address(this).balance >= value, "Address: insufficient balance for call");
745         require(isContract(target), "Address: call to non-contract");
746 
747         (bool success, bytes memory returndata) = target.call{value: value}(data);
748         return verifyCallResult(success, returndata, errorMessage);
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
753      * but performing a static call.
754      *
755      * _Available since v3.3._
756      */
757     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
758         return functionStaticCall(target, data, "Address: low-level static call failed");
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
763      * but performing a static call.
764      *
765      * _Available since v3.3._
766      */
767     function functionStaticCall(
768         address target,
769         bytes memory data,
770         string memory errorMessage
771     ) internal view returns (bytes memory) {
772         require(isContract(target), "Address: static call to non-contract");
773 
774         (bool success, bytes memory returndata) = target.staticcall(data);
775         return verifyCallResult(success, returndata, errorMessage);
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
780      * but performing a delegate call.
781      *
782      * _Available since v3.4._
783      */
784     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
785         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
786     }
787 
788     /**
789      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
790      * but performing a delegate call.
791      *
792      * _Available since v3.4._
793      */
794     function functionDelegateCall(
795         address target,
796         bytes memory data,
797         string memory errorMessage
798     ) internal returns (bytes memory) {
799         require(isContract(target), "Address: delegate call to non-contract");
800 
801         (bool success, bytes memory returndata) = target.delegatecall(data);
802         return verifyCallResult(success, returndata, errorMessage);
803     }
804 
805     /**
806      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
807      * revert reason using the provided one.
808      *
809      * _Available since v4.3._
810      */
811     function verifyCallResult(
812         bool success,
813         bytes memory returndata,
814         string memory errorMessage
815     ) internal pure returns (bytes memory) {
816         if (success) {
817             return returndata;
818         } else {
819             // Look for revert reason and bubble it up if present
820             if (returndata.length > 0) {
821                 // The easiest way to bubble the revert reason is using memory via assembly
822 
823                 assembly {
824                     let returndata_size := mload(returndata)
825                     revert(add(32, returndata), returndata_size)
826                 }
827             } else {
828                 revert(errorMessage);
829             }
830         }
831     }
832 }
833 
834 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
835 
836 
837 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
838 
839 pragma solidity ^0.8.0;
840 
841 /**
842  * @title ERC721 token receiver interface
843  * @dev Interface for any contract that wants to support safeTransfers
844  * from ERC721 asset contracts.
845  */
846 interface IERC721Receiver {
847     /**
848      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
849      * by `operator` from `from`, this function is called.
850      *
851      * It must return its Solidity selector to confirm the token transfer.
852      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
853      *
854      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
855      */
856     function onERC721Received(
857         address operator,
858         address from,
859         uint256 tokenId,
860         bytes calldata data
861     ) external returns (bytes4);
862 }
863 
864 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
865 
866 
867 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
868 
869 pragma solidity ^0.8.0;
870 
871 /**
872  * @dev Interface of the ERC165 standard, as defined in the
873  * https://eips.ethereum.org/EIPS/eip-165[EIP].
874  *
875  * Implementers can declare support of contract interfaces, which can then be
876  * queried by others ({ERC165Checker}).
877  *
878  * For an implementation, see {ERC165}.
879  */
880 interface IERC165 {
881     /**
882      * @dev Returns true if this contract implements the interface defined by
883      * `interfaceId`. See the corresponding
884      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
885      * to learn more about how these ids are created.
886      *
887      * This function call must use less than 30 000 gas.
888      */
889     function supportsInterface(bytes4 interfaceId) external view returns (bool);
890 }
891 
892 // File: @openzeppelin/contracts/interfaces/IERC165.sol
893 
894 
895 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 
900 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
901 
902 
903 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 
908 /**
909  * @dev Interface for the NFT Royalty Standard
910  */
911 interface IERC2981 is IERC165 {
912     /**
913      * @dev Called with the sale price to determine how much royalty is owed and to whom.
914      * @param tokenId - the NFT asset queried for royalty information
915      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
916      * @return receiver - address of who should be sent the royalty payment
917      * @return royaltyAmount - the royalty payment amount for `salePrice`
918      */
919     function royaltyInfo(uint256 tokenId, uint256 salePrice)
920         external
921         view
922         returns (address receiver, uint256 royaltyAmount);
923 }
924 
925 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
926 
927 
928 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
929 
930 pragma solidity ^0.8.0;
931 
932 
933 /**
934  * @dev Implementation of the {IERC165} interface.
935  *
936  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
937  * for the additional interface id that will be supported. For example:
938  *
939  * ```solidity
940  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
941  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
942  * }
943  * ```
944  *
945  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
946  */
947 abstract contract ERC165 is IERC165 {
948     /**
949      * @dev See {IERC165-supportsInterface}.
950      */
951     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
952         return interfaceId == type(IERC165).interfaceId;
953     }
954 }
955 
956 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
957 
958 
959 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
960 
961 pragma solidity ^0.8.0;
962 
963 
964 /**
965  * @dev Required interface of an ERC721 compliant contract.
966  */
967 interface IERC721 is IERC165 {
968     /**
969      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
970      */
971     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
972 
973     /**
974      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
975      */
976     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
977 
978     /**
979      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
980      */
981     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
982 
983     /**
984      * @dev Returns the number of tokens in ``owner``'s account.
985      */
986     function balanceOf(address owner) external view returns (uint256 balance);
987 
988     /**
989      * @dev Returns the owner of the `tokenId` token.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must exist.
994      */
995     function ownerOf(uint256 tokenId) external view returns (address owner);
996 
997     /**
998      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
999      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1000      *
1001      * Requirements:
1002      *
1003      * - `from` cannot be the zero address.
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must exist and be owned by `from`.
1006      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1007      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function safeTransferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) external;
1016 
1017     /**
1018      * @dev Transfers `tokenId` token from `from` to `to`.
1019      *
1020      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1021      *
1022      * Requirements:
1023      *
1024      * - `from` cannot be the zero address.
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function transferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) external;
1036 
1037     /**
1038      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1039      * The approval is cleared when the token is transferred.
1040      *
1041      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1042      *
1043      * Requirements:
1044      *
1045      * - The caller must own the token or be an approved operator.
1046      * - `tokenId` must exist.
1047      *
1048      * Emits an {Approval} event.
1049      */
1050     function approve(address to, uint256 tokenId) external;
1051 
1052     /**
1053      * @dev Returns the account approved for `tokenId` token.
1054      *
1055      * Requirements:
1056      *
1057      * - `tokenId` must exist.
1058      */
1059     function getApproved(uint256 tokenId) external view returns (address operator);
1060 
1061     /**
1062      * @dev Approve or remove `operator` as an operator for the caller.
1063      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1064      *
1065      * Requirements:
1066      *
1067      * - The `operator` cannot be the caller.
1068      *
1069      * Emits an {ApprovalForAll} event.
1070      */
1071     function setApprovalForAll(address operator, bool _approved) external;
1072 
1073     /**
1074      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1075      *
1076      * See {setApprovalForAll}
1077      */
1078     function isApprovedForAll(address owner, address operator) external view returns (bool);
1079 
1080     /**
1081      * @dev Safely transfers `tokenId` token from `from` to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - `from` cannot be the zero address.
1086      * - `to` cannot be the zero address.
1087      * - `tokenId` token must exist and be owned by `from`.
1088      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1089      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function safeTransferFrom(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes calldata data
1098     ) external;
1099 }
1100 
1101 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1102 
1103 
1104 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1105 
1106 pragma solidity ^0.8.0;
1107 
1108 
1109 /**
1110  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1111  * @dev See https://eips.ethereum.org/EIPS/eip-721
1112  */
1113 interface IERC721Enumerable is IERC721 {
1114     /**
1115      * @dev Returns the total amount of tokens stored by the contract.
1116      */
1117     function totalSupply() external view returns (uint256);
1118 
1119     /**
1120      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1121      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1122      */
1123     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1124 
1125     /**
1126      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1127      * Use along with {totalSupply} to enumerate all tokens.
1128      */
1129     function tokenByIndex(uint256 index) external view returns (uint256);
1130 }
1131 
1132 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1133 
1134 
1135 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 
1140 /**
1141  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1142  * @dev See https://eips.ethereum.org/EIPS/eip-721
1143  */
1144 interface IERC721Metadata is IERC721 {
1145     /**
1146      * @dev Returns the token collection name.
1147      */
1148     function name() external view returns (string memory);
1149 
1150     /**
1151      * @dev Returns the token collection symbol.
1152      */
1153     function symbol() external view returns (string memory);
1154 
1155     /**
1156      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1157      */
1158     function tokenURI(uint256 tokenId) external view returns (string memory);
1159 }
1160 
1161 // File: contracts/ERC721A.sol
1162 
1163 
1164 
1165 pragma solidity ^0.8.0;
1166 
1167 
1168 
1169 
1170 
1171 
1172 
1173 
1174 
1175 /**
1176  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1177  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1178  *
1179  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1180  *
1181  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1182  *
1183  * Does not support burning tokens to address(0).
1184  */
1185 contract ERC721A is
1186   Context,
1187   ERC165,
1188   IERC721,
1189   IERC721Metadata,
1190   IERC721Enumerable
1191 {
1192   using Address for address;
1193   using Strings for uint256;
1194 
1195   struct TokenOwnership {
1196     address addr;
1197     uint64 startTimestamp;
1198   }
1199 
1200   struct AddressData {
1201     uint128 balance;
1202     uint128 numberMinted;
1203   }
1204 
1205   uint256 private currentIndex = 0;
1206 
1207   uint256 internal immutable collectionSize;
1208   uint256 internal immutable maxBatchSize;
1209 
1210   // Token name
1211   string private _name;
1212 
1213   // Token symbol
1214   string private _symbol;
1215 
1216   // Mapping from token ID to ownership details
1217   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1218   mapping(uint256 => TokenOwnership) private _ownerships;
1219 
1220   // Mapping owner address to address data
1221   mapping(address => AddressData) private _addressData;
1222 
1223   // Mapping from token ID to approved address
1224   mapping(uint256 => address) private _tokenApprovals;
1225 
1226   // Mapping from owner to operator approvals
1227   mapping(address => mapping(address => bool)) private _operatorApprovals;
1228 
1229   /**
1230    * @dev
1231    * `maxBatchSize` refers to how much a minter can mint at a time.
1232    * `collectionSize_` refers to how many tokens are in the collection.
1233    */
1234   constructor(
1235     string memory name_,
1236     string memory symbol_,
1237     uint256 maxBatchSize_,
1238     uint256 collectionSize_
1239   ) {
1240     require(
1241       collectionSize_ > 0,
1242       "ERC721A: collection must have a nonzero supply"
1243     );
1244     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1245     _name = name_;
1246     _symbol = symbol_;
1247     maxBatchSize = maxBatchSize_;
1248     collectionSize = collectionSize_;
1249   }
1250 
1251   /**
1252    * @dev See {IERC721Enumerable-totalSupply}.
1253    */
1254   function totalSupply() public view override returns (uint256) {
1255     return currentIndex;
1256   }
1257 
1258   /**
1259    * @dev See {IERC721Enumerable-tokenByIndex}.
1260    */
1261   function tokenByIndex(uint256 index) public view override returns (uint256) {
1262     require(index < totalSupply(), "ERC721A: global index out of bounds");
1263     return index;
1264   }
1265 
1266   /**
1267    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1268    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1269    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1270    */
1271   function tokenOfOwnerByIndex(address owner, uint256 index)
1272     public
1273     view
1274     override
1275     returns (uint256)
1276   {
1277     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1278     uint256 numMintedSoFar = totalSupply();
1279     uint256 tokenIdsIdx = 0;
1280     address currOwnershipAddr = address(0);
1281     for (uint256 i = 0; i < numMintedSoFar; i++) {
1282       TokenOwnership memory ownership = _ownerships[i];
1283       if (ownership.addr != address(0)) {
1284         currOwnershipAddr = ownership.addr;
1285       }
1286       if (currOwnershipAddr == owner) {
1287         if (tokenIdsIdx == index) {
1288           return i;
1289         }
1290         tokenIdsIdx++;
1291       }
1292     }
1293     revert("ERC721A: unable to get token of owner by index");
1294   }
1295 
1296   /**
1297    * @dev See {IERC165-supportsInterface}.
1298    */
1299   function supportsInterface(bytes4 interfaceId)
1300     public
1301     view
1302     virtual
1303     override(ERC165, IERC165)
1304     returns (bool)
1305   {
1306     return
1307       interfaceId == type(IERC721).interfaceId ||
1308       interfaceId == type(IERC721Metadata).interfaceId ||
1309       interfaceId == type(IERC721Enumerable).interfaceId ||
1310       super.supportsInterface(interfaceId);
1311   }
1312 
1313   /**
1314    * @dev See {IERC721-balanceOf}.
1315    */
1316   function balanceOf(address owner) public view override returns (uint256) {
1317     require(owner != address(0), "ERC721A: balance query for the zero address");
1318     return uint256(_addressData[owner].balance);
1319   }
1320 
1321   function _numberMinted(address owner) internal view returns (uint256) {
1322     require(
1323       owner != address(0),
1324       "ERC721A: number minted query for the zero address"
1325     );
1326     return uint256(_addressData[owner].numberMinted);
1327   }
1328 
1329   function ownershipOf(uint256 tokenId)
1330     internal
1331     view
1332     returns (TokenOwnership memory)
1333   {
1334     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1335 
1336     uint256 lowestTokenToCheck;
1337     if (tokenId >= maxBatchSize) {
1338       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1339     }
1340 
1341     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1342       TokenOwnership memory ownership = _ownerships[curr];
1343       if (ownership.addr != address(0)) {
1344         return ownership;
1345       }
1346     }
1347 
1348     revert("ERC721A: unable to determine the owner of token");
1349   }
1350 
1351   /**
1352    * @dev See {IERC721-ownerOf}.
1353    */
1354   function ownerOf(uint256 tokenId) public view override returns (address) {
1355     return ownershipOf(tokenId).addr;
1356   }
1357 
1358   /**
1359    * @dev See {IERC721Metadata-name}.
1360    */
1361   function name() public view virtual override returns (string memory) {
1362     return _name;
1363   }
1364 
1365   /**
1366    * @dev See {IERC721Metadata-symbol}.
1367    */
1368   function symbol() public view virtual override returns (string memory) {
1369     return _symbol;
1370   }
1371 
1372   /**
1373    * @dev See {IERC721Metadata-tokenURI}.
1374    */
1375   function tokenURI(uint256 tokenId)
1376     public
1377     view
1378     virtual
1379     override
1380     returns (string memory)
1381   {
1382     require(
1383       _exists(tokenId),
1384       "ERC721Metadata: URI query for nonexistent token"
1385     );
1386 
1387     string memory baseURI = _baseURI();
1388     return
1389       bytes(baseURI).length > 0
1390         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1391         : "";
1392   }
1393 
1394   /**
1395    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1396    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1397    * by default, can be overriden in child contracts.
1398    */
1399   function _baseURI() internal view virtual returns (string memory) {
1400     return "";
1401   }
1402 
1403   /**
1404    * @dev See {IERC721-approve}.
1405    */
1406   function approve(address to, uint256 tokenId) public override {
1407     address owner = ERC721A.ownerOf(tokenId);
1408     require(to != owner, "ERC721A: approval to current owner");
1409 
1410     require(
1411       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1412       "ERC721A: approve caller is not owner nor approved for all"
1413     );
1414 
1415     _approve(to, tokenId, owner);
1416   }
1417 
1418   /**
1419    * @dev See {IERC721-getApproved}.
1420    */
1421   function getApproved(uint256 tokenId) public view override returns (address) {
1422     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1423 
1424     return _tokenApprovals[tokenId];
1425   }
1426 
1427   /**
1428    * @dev See {IERC721-setApprovalForAll}.
1429    */
1430   function setApprovalForAll(address operator, bool approved) public override {
1431     require(operator != _msgSender(), "ERC721A: approve to caller");
1432 
1433     _operatorApprovals[_msgSender()][operator] = approved;
1434     emit ApprovalForAll(_msgSender(), operator, approved);
1435   }
1436 
1437   /**
1438    * @dev See {IERC721-isApprovedForAll}.
1439    */
1440   function isApprovedForAll(address owner, address operator)
1441     public
1442     view
1443     virtual
1444     override
1445     returns (bool)
1446   {
1447     return _operatorApprovals[owner][operator];
1448   }
1449 
1450   /**
1451    * @dev See {IERC721-transferFrom}.
1452    */
1453   function transferFrom(
1454     address from,
1455     address to,
1456     uint256 tokenId
1457   ) public override {
1458     _transfer(from, to, tokenId);
1459   }
1460 
1461   /**
1462    * @dev See {IERC721-safeTransferFrom}.
1463    */
1464   function safeTransferFrom(
1465     address from,
1466     address to,
1467     uint256 tokenId
1468   ) public override {
1469     safeTransferFrom(from, to, tokenId, "");
1470   }
1471 
1472   /**
1473    * @dev See {IERC721-safeTransferFrom}.
1474    */
1475   function safeTransferFrom(
1476     address from,
1477     address to,
1478     uint256 tokenId,
1479     bytes memory _data
1480   ) public override {
1481     _transfer(from, to, tokenId);
1482     require(
1483       _checkOnERC721Received(from, to, tokenId, _data),
1484       "ERC721A: transfer to non ERC721Receiver implementer"
1485     );
1486   }
1487 
1488   /**
1489    * @dev Returns whether `tokenId` exists.
1490    *
1491    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1492    *
1493    * Tokens start existing when they are minted (`_mint`),
1494    */
1495   function _exists(uint256 tokenId) internal view returns (bool) {
1496     return tokenId < currentIndex;
1497   }
1498 
1499   function _safeMint(address to, uint256 quantity) internal {
1500     _safeMint(to, quantity, "");
1501   }
1502 
1503   /**
1504    * @dev Mints `quantity` tokens and transfers them to `to`.
1505    *
1506    * Requirements:
1507    *
1508    * - there must be `quantity` tokens remaining unminted in the total collection.
1509    * - `to` cannot be the zero address.
1510    * - `quantity` cannot be larger than the max batch size.
1511    *
1512    * Emits a {Transfer} event.
1513    */
1514   function _safeMint(
1515     address to,
1516     uint256 quantity,
1517     bytes memory _data
1518   ) internal {
1519     uint256 startTokenId = currentIndex;
1520     require(to != address(0), "ERC721A: mint to the zero address");
1521     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1522     require(!_exists(startTokenId), "ERC721A: token already minted");
1523     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1524 
1525     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1526 
1527     AddressData memory addressData = _addressData[to];
1528     _addressData[to] = AddressData(
1529       addressData.balance + uint128(quantity),
1530       addressData.numberMinted + uint128(quantity)
1531     );
1532     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1533 
1534     uint256 updatedIndex = startTokenId;
1535 
1536     for (uint256 i = 0; i < quantity; i++) {
1537       emit Transfer(address(0), to, updatedIndex);
1538       require(
1539         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1540         "ERC721A: transfer to non ERC721Receiver implementer"
1541       );
1542       updatedIndex++;
1543     }
1544 
1545     currentIndex = updatedIndex;
1546     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1547   }
1548 
1549   /**
1550    * @dev Transfers `tokenId` from `from` to `to`.
1551    *
1552    * Requirements:
1553    *
1554    * - `to` cannot be the zero address.
1555    * - `tokenId` token must be owned by `from`.
1556    *
1557    * Emits a {Transfer} event.
1558    */
1559   function _transfer(
1560     address from,
1561     address to,
1562     uint256 tokenId
1563   ) private {
1564     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1565 
1566     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1567       getApproved(tokenId) == _msgSender() ||
1568       isApprovedForAll(prevOwnership.addr, _msgSender()));
1569 
1570     require(
1571       isApprovedOrOwner,
1572       "ERC721A: transfer caller is not owner nor approved"
1573     );
1574 
1575     require(
1576       prevOwnership.addr == from,
1577       "ERC721A: transfer from incorrect owner"
1578     );
1579     require(to != address(0), "ERC721A: transfer to the zero address");
1580 
1581     _beforeTokenTransfers(from, to, tokenId, 1);
1582 
1583     // Clear approvals from the previous owner
1584     _approve(address(0), tokenId, prevOwnership.addr);
1585 
1586     _addressData[from].balance -= 1;
1587     _addressData[to].balance += 1;
1588     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1589 
1590     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1591     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1592     uint256 nextTokenId = tokenId + 1;
1593     if (_ownerships[nextTokenId].addr == address(0)) {
1594       if (_exists(nextTokenId)) {
1595         _ownerships[nextTokenId] = TokenOwnership(
1596           prevOwnership.addr,
1597           prevOwnership.startTimestamp
1598         );
1599       }
1600     }
1601 
1602     emit Transfer(from, to, tokenId);
1603     _afterTokenTransfers(from, to, tokenId, 1);
1604   }
1605 
1606   /**
1607    * @dev Approve `to` to operate on `tokenId`
1608    *
1609    * Emits a {Approval} event.
1610    */
1611   function _approve(
1612     address to,
1613     uint256 tokenId,
1614     address owner
1615   ) private {
1616     _tokenApprovals[tokenId] = to;
1617     emit Approval(owner, to, tokenId);
1618   }
1619 
1620   uint256 public nextOwnerToExplicitlySet = 0;
1621 
1622   /**
1623    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1624    */
1625   function _setOwnersExplicit(uint256 quantity) internal {
1626     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1627     require(quantity > 0, "quantity must be nonzero");
1628     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1629     if (endIndex > collectionSize - 1) {
1630       endIndex = collectionSize - 1;
1631     }
1632     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1633     require(_exists(endIndex), "not enough minted yet for this cleanup");
1634     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1635       if (_ownerships[i].addr == address(0)) {
1636         TokenOwnership memory ownership = ownershipOf(i);
1637         _ownerships[i] = TokenOwnership(
1638           ownership.addr,
1639           ownership.startTimestamp
1640         );
1641       }
1642     }
1643     nextOwnerToExplicitlySet = endIndex + 1;
1644   }
1645 
1646   /**
1647    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1648    * The call is not executed if the target address is not a contract.
1649    *
1650    * @param from address representing the previous owner of the given token ID
1651    * @param to target address that will receive the tokens
1652    * @param tokenId uint256 ID of the token to be transferred
1653    * @param _data bytes optional data to send along with the call
1654    * @return bool whether the call correctly returned the expected magic value
1655    */
1656   function _checkOnERC721Received(
1657     address from,
1658     address to,
1659     uint256 tokenId,
1660     bytes memory _data
1661   ) private returns (bool) {
1662     if (to.isContract()) {
1663       try
1664         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1665       returns (bytes4 retval) {
1666         return retval == IERC721Receiver(to).onERC721Received.selector;
1667       } catch (bytes memory reason) {
1668         if (reason.length == 0) {
1669           revert("ERC721A: transfer to non ERC721Receiver implementer");
1670         } else {
1671           assembly {
1672             revert(add(32, reason), mload(reason))
1673           }
1674         }
1675       }
1676     } else {
1677       return true;
1678     }
1679   }
1680 
1681   /**
1682    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1683    *
1684    * startTokenId - the first token id to be transferred
1685    * quantity - the amount to be transferred
1686    *
1687    * Calling conditions:
1688    *
1689    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1690    * transferred to `to`.
1691    * - When `from` is zero, `tokenId` will be minted for `to`.
1692    */
1693   function _beforeTokenTransfers(
1694     address from,
1695     address to,
1696     uint256 startTokenId,
1697     uint256 quantity
1698   ) internal virtual {}
1699 
1700   /**
1701    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1702    * minting.
1703    *
1704    * startTokenId - the first token id to be transferred
1705    * quantity - the amount to be transferred
1706    *
1707    * Calling conditions:
1708    *
1709    * - when `from` and `to` are both non-zero.
1710    * - `from` and `to` are never both zero.
1711    */
1712   function _afterTokenTransfers(
1713     address from,
1714     address to,
1715     uint256 startTokenId,
1716     uint256 quantity
1717   ) internal virtual {}
1718 }
1719 
1720 //SPDX-License-Identifier: MIT
1721 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1722 
1723 pragma solidity ^0.8.0;
1724 
1725 
1726 
1727 
1728 
1729 
1730 
1731 
1732 
1733 contract CyberIT is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1734     using Counters for Counters.Counter;
1735     using Strings for uint256;
1736 
1737     Counters.Counter private tokenCounter;
1738 
1739     string private baseURI = "ipfs://Qmax9UDsbAJW1QUmNUsKyP8uTBbu5aQPwgQSNSzxDBDfoY";
1740     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1741     bool private isOpenSeaProxyActive = true;
1742 
1743     uint256 public constant MAX_MINTS_PER_TX = 5;
1744     uint256 public maxSupply = 1500;
1745 
1746     uint256 public constant PUBLIC_SALE_PRICE = 0.003 ether;
1747     uint256 public NUM_FREE_MINTS = 600;
1748     bool public isPublicSaleActive = true;
1749 
1750 
1751 
1752 
1753     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1754 
1755     modifier publicSaleActive() {
1756         require(isPublicSaleActive, "Public sale is not open");
1757         _;
1758     }
1759     
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
1803     ) ERC721A("CyberIT", "CLONE", 100, maxSupply) {
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
1838     function ownermint(uint256 _NUM)
1839       external
1840       onlyOwner
1841     {
1842       maxSupply = _NUM;
1843     }
1844 
1845     // function to disable gasless listings for security in case
1846     // opensea ever shuts down or is compromised
1847     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1848         external
1849         onlyOwner
1850     {
1851         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1852     }
1853 
1854     function setIsPublicSaleActive(bool _isPublicSaleActive)
1855         external
1856         onlyOwner
1857     {
1858         isPublicSaleActive = _isPublicSaleActive;
1859     }
1860 
1861 
1862     function setnumfree(uint256 _numfreemints)
1863         external
1864         onlyOwner
1865     {
1866         NUM_FREE_MINTS = _numfreemints;
1867     }
1868 
1869 
1870     function withdraw() public onlyOwner {
1871         uint256 balance = address(this).balance;
1872         payable(msg.sender).transfer(balance);
1873     }
1874 
1875     function withdrawTokens(IERC20 token) public onlyOwner {
1876         uint256 balance = token.balanceOf(address(this));
1877         token.transfer(msg.sender, balance);
1878     }
1879 
1880 
1881 
1882     // ============ SUPPORTING FUNCTIONS ============
1883 
1884     function nextTokenId() private returns (uint256) {
1885         tokenCounter.increment();
1886         return tokenCounter.current();
1887     }
1888 
1889     // ============ FUNCTION OVERRIDES ============
1890 
1891     function supportsInterface(bytes4 interfaceId)
1892         public
1893         view
1894         virtual
1895         override(ERC721A, IERC165)
1896         returns (bool)
1897     {
1898         return
1899             interfaceId == type(IERC2981).interfaceId ||
1900             super.supportsInterface(interfaceId);
1901     }
1902 
1903     /**
1904      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1905      */
1906     function isApprovedForAll(address owner, address operator)
1907         public
1908         view
1909         override
1910         returns (bool)
1911     {
1912         // Get a reference to OpenSea's proxy registry contract by instantiating
1913         // the contract using the already existing address.
1914         ProxyRegistry proxyRegistry = ProxyRegistry(
1915             openSeaProxyRegistryAddress
1916         );
1917         if (
1918             isOpenSeaProxyActive &&
1919             address(proxyRegistry.proxies(owner)) == operator
1920         ) {
1921             return true;
1922         }
1923 
1924         return super.isApprovedForAll(owner, operator);
1925     }
1926 
1927     /**
1928      * @dev See {IERC721Metadata-tokenURI}.
1929      */
1930     function tokenURI(uint256 tokenId)
1931         public
1932         view
1933         virtual
1934         override
1935         returns (string memory)
1936     {
1937         require(_exists(tokenId), "Nonexistent token");
1938 
1939         return
1940             baseURI;
1941     }
1942 
1943     /**
1944      * @dev See {IERC165-royaltyInfo}.
1945      */
1946     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1947         external
1948         view
1949         override
1950         returns (address receiver, uint256 royaltyAmount)
1951     {
1952         require(_exists(tokenId), "Nonexistent token");
1953 
1954         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1955     }
1956 }
1957 
1958 // These contract definitions are used to create a reference to the OpenSea
1959 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1960 contract OwnableDelegateProxy {
1961 
1962 }
1963 
1964 contract ProxyRegistry {
1965     mapping(address => OwnableDelegateProxy) public proxies;
1966 }